# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Fixed-launch adapters for pinned DeepSeek activation and weight conversion."""

import torch
import triton

from benchmarks.measurement import TritonLaunch, poison_outputs, to_cpu
from corpus.benchmarks.triton.quantization_reference import (
    BLOCK, CHUNK_ROWS, activation_input, assert_activation_output,
    assert_weight_output, weight_input, weight_scales,
)

DEEPSEEK_COMMIT = "9b4e9788e4a3a731f7567338ed15d3ec549ce03b"


def _device_input(rows, columns, dtype, make_input):
    # Fill on the CPU in bounded chunks, then use a registered host transfer.
    host = torch.empty((rows, columns), dtype=dtype, pin_memory=True)
    for start in range(0, rows, CHUNK_ROWS):
        stop = min(start + CHUNK_ROWS, rows)
        host[start:stop].copy_(make_input(start, stop, columns))
    return host.to("cuda")


def _metadata(parameters, kernel, grid, knobs, output_dtype):
    parameters.update({
        "source": {
            "repository": "https://github.com/deepseek-ai/DeepSeek-V3",
            "commit": DEEPSEEK_COMMIT,
            "entrypoint": f"inference/kernel.py:{kernel}",
        },
        "launch": {"grid": list(grid), **knobs},
        "output_dtype": output_dtype,
        "input_pattern": "signed_row_column_block_dyadic",
        "correctness": "full_output_chunked_cpu_exact_reference_final_sample_prelaunch_poison",
        "reference_chunk_rows": CHUNK_ROWS,
        "measurement_scope": "kernel_launch_and_synchronize",
    })


def prepare_deepseek_act_quant(parameters):
    from corpus.benchmarks.third_party.deepseek.kernel import act_quant_kernel

    rows, columns = parameters["rows"], parameters["columns"]
    x = _device_input(rows, columns, torch.bfloat16, activation_input)
    y = torch.empty((rows, columns), dtype=torch.float8_e4m3fn, device="cuda")
    scales = torch.empty((rows, columns // BLOCK), dtype=torch.float32, device="cuda")
    grid = (rows * columns // BLOCK,)
    knobs = {"BLOCK_SIZE": BLOCK, "scale_fmt": None, "num_warps": 4}
    launch = TritonLaunch(
        act_quant_kernel, grid, x, y, scales,
        before_launch=lambda: poison_outputs([y, scales]), **knobs,
    )
    _metadata(parameters, "act_quant_kernel", grid, knobs, "fp8e4m3fn")
    parameters["scale_dtype"] = "fp32"
    parameters["scale_validation_rtol"] = 2e-7

    def check():
        for start in range(0, rows, CHUNK_ROWS):
            stop = min(start + CHUNK_ROWS, rows)
            assert_activation_output(
                to_cpu(y[start:stop]), to_cpu(scales[start:stop]),
                activation_input(start, stop, columns),
            )

    return parameters, launch, check


def prepare_deepseek_weight_dequant(parameters):
    from corpus.benchmarks.third_party.deepseek.kernel import weight_dequant_kernel

    rows, columns = parameters["rows"], parameters["columns"]
    x = _device_input(rows, columns, torch.float8_e4m3fn, weight_input)
    host_scales = weight_scales(rows, columns)
    scales = host_scales.pin_memory().to("cuda")
    y = torch.empty((rows, columns), dtype=torch.float32, device="cuda")
    grid = (triton.cdiv(rows, BLOCK), triton.cdiv(columns, BLOCK))
    knobs = {"BLOCK_SIZE": BLOCK, "num_warps": 4}
    launch = TritonLaunch(
        weight_dequant_kernel, grid, x, scales, y, rows, columns,
        before_launch=lambda: poison_outputs([y]), **knobs,
    )
    _metadata(parameters, "weight_dequant_kernel", grid, knobs, "fp32")
    parameters["scale_pattern"] = "power_of_two_row_column_tiles"

    def check():
        for start in range(0, rows, CHUNK_ROWS):
            stop = min(start + CHUNK_ROWS, rows)
            assert_weight_output(
                to_cpu(y[start:stop]), weight_input(start, stop, columns),
                host_scales, start,
            )

    return parameters, launch, check


PREPARE_QUANTIZATION = {
    "deepseek_act_quant": prepare_deepseek_act_quant,
    "deepseek_weight_dequant": prepare_deepseek_weight_dequant,
}


def validate_quantization_parameters(workload, parameters):
    if workload not in PREPARE_QUANTIZATION:
        raise ValueError(f"unknown quantization workload: {workload}")
    if not isinstance(parameters, dict) or set(parameters) != {"rows", "columns", "dtype"}:
        raise ValueError(f"{workload} requires exactly rows, columns, dtype")
    for key in ("rows", "columns"):
        if type(parameters[key]) is not int or parameters[key] <= 0:
            raise ValueError(f"{key} must be a positive integer")
    dtype = "bf16" if workload == "deepseek_act_quant" else "fp8"
    if parameters["dtype"] != dtype:
        raise ValueError(f"{workload} requires dtype={dtype}")
    if workload == "deepseek_act_quant" and parameters["columns"] % BLOCK:
        raise ValueError("activation quantization requires columns divisible by 128")
    return dict(parameters)
