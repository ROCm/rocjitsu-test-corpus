# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Fixed launches and bounded CPU checks for upstream row reductions."""

import math
from typing import Any

import torch
import triton

from benchmarks.measurement import TritonLaunch, poison_outputs, to_cpu
from corpus.benchmarks.triton.reduction_reference import (
    REFERENCE_ROWS, reduction_input, reduction_affine, check_reduction_output,
)

TRITON_COMMIT = "ced7e4b42f992f0b125208767cafc371d079ffd9"


def _prepare(workload, parameters):
    rows, columns = parameters["rows"], parameters["columns"]
    x = torch.empty((rows, columns), dtype=torch.float32, device="cuda")
    for start in range(0, rows, REFERENCE_ROWS):
        stop = min(start + REFERENCE_ROWS, rows)
        x[start:stop].copy_(reduction_input(start, stop, columns).pin_memory())
    y = torch.empty_like(x)
    block = triton.next_power_of_2(columns)
    if workload == "triton_softmax":
        from corpus.benchmarks.third_party.triton_candidates.softmax import softmax_kernel

        # Match issue12611: one program per row, with no occupancy heuristic.
        grid = (rows,)
        knobs = {"BLOCK_SIZE": block, "num_warps": 8, "num_stages": 2}
        outputs = (y,)
        launch = TritonLaunch(
            softmax_kernel, grid, y, x, columns, columns, rows, columns,
            before_launch=lambda: poison_outputs(outputs), **knobs,
        )
        entrypoint = "02-fused-softmax.py:softmax_kernel"
    else:
        from corpus.benchmarks.third_party.triton_candidates.layernorm import _layer_norm_fwd_fused

        weight, bias = [v.pin_memory().to("cuda") for v in reduction_affine(columns)]
        mean = torch.empty((rows,), dtype=torch.float32, device="cuda")
        rstd = torch.empty_like(mean)
        grid = (rows,)
        knobs = {"BLOCK_SIZE": block, "num_warps": 8, "num_stages": 1}
        outputs = (y, mean, rstd)
        launch = TritonLaunch(
            _layer_norm_fwd_fused, grid, x, y, weight, bias, mean, rstd,
            columns, columns, parameters["epsilon"],
            before_launch=lambda: poison_outputs(outputs), **knobs,
        )
        entrypoint = "05-layer-norm.py:_layer_norm_fwd_fused"
    parameters.update({
        "input_pattern": "dyadic_row_column_modular",
        "correctness": "chunked_fp64_reference_all_outputs_final_sample_prelaunch_poison",
        "measurement_scope": "kernel_launch_and_synchronize",
        "source": {"repository": "https://github.com/triton-lang/triton",
                   "commit": TRITON_COMMIT, "entrypoint": entrypoint},
        "launch": {"grid": list(grid), **knobs},
    })
    return parameters, launch, lambda: check_reduction_output(
        workload, outputs, parameters.get("epsilon", 1e-5), copy_to_cpu=to_cpu,
    )


def prepare_triton_softmax(parameters):
    return _prepare("triton_softmax", parameters)


def prepare_triton_layernorm(parameters):
    return _prepare("triton_layernorm", parameters)


PREPARE_REDUCTIONS = {
    "triton_softmax": prepare_triton_softmax,
    "triton_layernorm": prepare_triton_layernorm,
}


def validate_reduction_parameters(workload: str, parameters: dict[str, Any]) -> dict[str, Any]:
    if workload not in PREPARE_REDUCTIONS:
        raise ValueError(f"unknown reduction workload: {workload}")
    required = {"dtype", "rows", "columns"}
    if workload == "triton_layernorm":
        required.add("epsilon")
    if not isinstance(parameters, dict) or set(parameters) != required:
        raise ValueError(f"{workload} requires exactly these params: {', '.join(sorted(required))}")
    if parameters["dtype"] != "fp32":
        raise ValueError(f"{workload} requires dtype=fp32")
    for key in ("rows", "columns"):
        if type(parameters[key]) is not int or parameters[key] <= 0:
            raise ValueError(f"{key} must be a positive integer")
    if parameters["columns"] > 16384:
        raise ValueError("row reductions support at most 16384 columns")
    if workload == "triton_layernorm":
        epsilon = parameters["epsilon"]
        if type(epsilon) not in (float, int) or not math.isfinite(epsilon) or epsilon <= 0:
            raise ValueError("epsilon must be finite and positive")
    return dict(parameters)
