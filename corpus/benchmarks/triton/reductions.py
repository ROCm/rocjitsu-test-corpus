# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Fixed launches and bounded CPU checks for upstream row reductions."""

import math

import torch
import triton

from benchmarks.measurement import TritonLaunch, to_cpu

TRITON_COMMIT = "ced7e4b42f992f0b125208767cafc371d079ffd9"
REFERENCE_ROWS = 256


def reduction_input(start, stop, columns):
    """Dyadic values whose distribution changes with both row and column."""
    row = torch.arange(start, stop, dtype=torch.int64)[:, None]
    col = torch.arange(columns, dtype=torch.int64)[None, :]
    return (((row * 17 + col * 13 + (row * col) % 127) % 257 - 128).float() / 32)


def reduction_affine(columns):
    col = torch.arange(columns, dtype=torch.int64)
    return 0.5 + (col % 13).float() / 16, ((col % 17) - 8).float() / 32


def reduction_reference(workload, start, stop, columns, epsilon=1e-5):
    x = reduction_input(start, stop, columns).double()
    if workload == "triton_softmax":
        return (torch.softmax(x, dim=1).float(),)
    mean = x.mean(dim=1)
    rstd = torch.rsqrt(((x - mean[:, None]) ** 2).mean(dim=1) + epsilon)
    weight, bias = reduction_affine(columns)
    output = (x - mean[:, None]) * rstd[:, None] * weight.double() + bias.double()
    return output.float(), mean.float(), rstd.float()


def check_reduction_output(workload, outputs, epsilon=1e-5, copy_to_cpu=lambda x: x):
    """Check every output, including LayerNorm statistics, in bounded chunks."""
    rows, columns = outputs[0].shape
    for start in range(0, rows, REFERENCE_ROWS):
        stop = min(start + REFERENCE_ROWS, rows)
        expected = reduction_reference(workload, start, stop, columns, epsilon)
        for actual, reference in zip(outputs, expected, strict=True):
            actual = copy_to_cpu(actual[start:stop])
            if not torch.isfinite(actual).all():
                raise AssertionError("reduction output contains nonfinite or unwritten values")
            # Exp/rsqrt and reduction order differ between CPU and Triton. These
            # FP32 bounds are tight enough to reject a dropped element or row.
            torch.testing.assert_close(
                actual, reference, rtol=2e-5,
                atol=1e-8 if workload == "triton_softmax" else 2e-6,
            )


def _prepare(workload, parameters):
    rows, columns = parameters["rows"], parameters["columns"]
    x = torch.empty((rows, columns), dtype=torch.float32, device="cuda")
    for start in range(0, rows, REFERENCE_ROWS):
        stop = min(start + REFERENCE_ROWS, rows)
        x[start:stop].copy_(reduction_input(start, stop, columns).pin_memory())
    # Initialize before timing: the very first measured launch must write all
    # outputs. Checks never dispatch the benchmark kernel a second time.
    y = torch.full_like(x, float("nan"))
    block = triton.next_power_of_2(columns)
    if workload == "triton_softmax":
        from corpus.benchmarks.third_party.triton_candidates.softmax import softmax_kernel

        # Match issue12611: one program per row, with no occupancy heuristic.
        grid = (rows,)
        knobs = {"BLOCK_SIZE": block, "num_warps": 8, "num_stages": 2}
        launch = TritonLaunch(softmax_kernel, grid, y, x, columns, columns, rows, columns, **knobs)
        outputs = (y,)
        entrypoint = "02-fused-softmax.py:softmax_kernel"
    else:
        from corpus.benchmarks.third_party.triton_candidates.layernorm import _layer_norm_fwd_fused

        weight, bias = [v.pin_memory().to("cuda") for v in reduction_affine(columns)]
        mean = torch.full((rows,), float("nan"), dtype=torch.float32, device="cuda")
        rstd = torch.full_like(mean, float("nan"))
        grid = (rows,)
        knobs = {"BLOCK_SIZE": block, "num_warps": 8, "num_stages": 1}
        launch = TritonLaunch(
            _layer_norm_fwd_fused, grid, x, y, weight, bias, mean, rstd,
            columns, columns, parameters["epsilon"], **knobs,
        )
        outputs = (y, mean, rstd)
        entrypoint = "05-layer-norm.py:_layer_norm_fwd_fused"
    parameters.update({
        "input_pattern": "dyadic_row_column_modular",
        "correctness": "chunked_fp64_reference_all_outputs_initial_nan_poison",
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


def validate_reduction_parameters(workload, parameters):
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
