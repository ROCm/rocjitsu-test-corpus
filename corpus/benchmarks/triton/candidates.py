# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Fixed-launch adapters for pinned upstream candidate kernels."""

from typing import Any

import torch
import triton

from benchmarks.measurement import TritonLaunch, poison_outputs, to_cpu
from corpus.benchmarks.triton.candidate_reference import (
    assert_candidate_output, candidate_expected, candidate_inputs,
)

TRITON_COMMIT = "ced7e4b42f992f0b125208767cafc371d079ffd9"
DEEPSEEK_COMMIT = "9b4e9788e4a3a731f7567338ed15d3ec549ce03b"


def _candidate_check(outputs, reduction, scale_bases=None):
    # Each sampled output was poisoned before its launch. Validate the final
    # sample without executing the benchmark kernel again.
    def check():
        for group, output in enumerate(outputs):
            expected = candidate_expected(
                *output.shape, reduction, output.dtype,
                group=group, scale_bases=scale_bases,
            )
            assert_candidate_output(to_cpu(output), expected)

    return check


def _device_inputs(*args, **kwargs):
    return tuple(value.pin_memory().to("cuda") for value in candidate_inputs(*args, **kwargs))


def _metadata(parameters, source, entrypoint, launch):
    repository, commit = source
    parameters.update(
        {
            "input_pattern": "positive_dyadic_row_column_group_k_and_block",
            "correctness": "exact_output_dtype_reference_final_sample_prelaunch_poison",
            "measurement_scope": "kernel_launch_and_synchronize",
            "source": {
                "repository": repository,
                "commit": commit,
                "entrypoint": entrypoint,
            },
            "launch": launch,
        }
    )


def prepare_triton_persistent(parameters):
    from corpus.benchmarks.third_party.triton_candidates.persistent import (
        matmul_kernel_persistent,
    )

    m, n, k = (parameters[name] for name in ("rows", "columns", "reduction"))
    a, b = _device_inputs(m, n, k, torch.float16)
    c = torch.empty((m, n), device="cuda", dtype=torch.float16)
    sms = torch.cuda.get_device_properties("cuda").multi_processor_count
    large_tile_configuration = parameters.get("configuration") == "large_tile"
    tile = 128 if large_tile_configuration else 64
    grid = (min(sms, triton.cdiv(m, tile) * triton.cdiv(n, tile)),)
    knobs = {
        "BLOCK_SIZE_M": tile,
        "BLOCK_SIZE_N": tile,
        "BLOCK_SIZE_K": 64,
        "GROUP_SIZE_M": 8,
        "NUM_SMS": sms,
        "num_warps": 4,
        "num_stages": 2 if large_tile_configuration else 1,
    }

    launch = TritonLaunch(
        matmul_kernel_persistent, grid,
        a,
        b,
        c,
        m,
        n,
        k,
        *a.stride(),
        *b.stride(),
        *c.stride(),
        before_launch=lambda: poison_outputs([c]),
        **knobs,
    )

    _metadata(
        parameters,
        ("https://github.com/triton-lang/triton", TRITON_COMMIT),
        "09-persistent-matmul.py:matmul_kernel_persistent",
        {"grid": list(grid), **knobs},
    )
    return parameters, launch, _candidate_check([c], k)


def prepare_triton_grouped(parameters):
    from corpus.benchmarks.third_party.triton_candidates.grouped import (
        grouped_matmul_kernel,
    )

    m, n, k = (parameters[name] for name in ("rows", "columns", "reduction"))
    groups = parameters["groups"]
    inputs = [_device_inputs(m, n, k, torch.float16, group=i) for i in range(groups)]
    aa, bb = [pair[0] for pair in inputs], [pair[1] for pair in inputs]
    cc = [
        torch.empty((m, n), device="cuda", dtype=torch.float16) for _ in range(groups)
    ]
    # Pointer/shape tables are allocated once and retained by the launch closure.
    pointers = [
        torch.tensor([x.data_ptr() for x in xs], device="cuda", dtype=torch.int64)
        for xs in (aa, bb, cc)
    ]
    sizes = torch.tensor([m, n, k] * groups, device="cuda", dtype=torch.int32)
    strides = torch.tensor([k, n, n] * groups, device="cuda", dtype=torch.int32)
    sms = torch.cuda.get_device_properties("cuda").multi_processor_count
    large_tile_configuration = parameters.get("configuration") == "large_tile"
    tile = 128 if large_tile_configuration else 64
    knobs = {
        "BLOCK_SIZE_M": tile,
        "BLOCK_SIZE_N": tile,
        "BLOCK_SIZE_K": 64,
        "NUM_SM": sms,
        "num_warps": 4,
        "num_stages": 2 if large_tile_configuration else 1,
    }

    launch = TritonLaunch(
        grouped_matmul_kernel, (sms,),
        *pointers,
        sizes,
        strides,
        groups,
        **knobs,
        keepalive=(aa, bb, cc),
        before_launch=lambda: poison_outputs(cc),
    )

    _metadata(
        parameters,
        ("https://github.com/triton-lang/triton", TRITON_COMMIT),
        "08-grouped-gemm.py:grouped_matmul_kernel",
        {"grid": [sms], **knobs},
    )
    return parameters, launch, _candidate_check(cc, k)


def prepare_deepseek_fp8(parameters):
    from corpus.benchmarks.third_party.deepseek.kernel import fp8_gemm_kernel

    m, n, k = (parameters[name] for name in ("rows", "columns", "reduction"))
    dtype = torch.float8_e4m3fn
    large_tile_configuration = parameters.get("configuration") == "large_tile"
    scale_a, scale_b = (1.0, 1.0) if large_tile_configuration else (0.5, 0.25)
    tile_m = 64 if large_tile_configuration else 32
    a, b, a_scale, b_scale = _device_inputs(
        m, n, k, dtype, scale_bases=(scale_a, scale_b)
    )
    c = torch.empty((m, n), device="cuda", dtype=torch.bfloat16)
    grid = (triton.cdiv(m, tile_m), triton.cdiv(n, 64))
    knobs = {
        "BLOCK_SIZE_M": tile_m,
        "BLOCK_SIZE_N": 64,
        "BLOCK_SIZE_K": 128,
        "num_warps": 8,
        "num_stages": 3,
    }

    launch = TritonLaunch(
        fp8_gemm_kernel.fn, grid,
        a,
        b,
        c,
        a_scale,
        b_scale,
        m,
        n,
        k,
        before_launch=lambda: poison_outputs([c]),
        **knobs,
    )

    _metadata(
        parameters,
        ("https://github.com/deepseek-ai/DeepSeek-V3", DEEPSEEK_COMMIT),
        "inference/kernel.py:fp8_gemm_kernel",
        {"grid": list(grid), **knobs},
    )
    parameters["output_dtype"] = "bf16"
    parameters["scale_bases"] = [scale_a, scale_b]
    parameters["scale_pattern"] = "power_of_two_row_column_block_and_kblock"
    return parameters, launch, _candidate_check(
        [c], k, scale_bases=(scale_a, scale_b)
    )


PREPARE_CANDIDATES = {
    "triton_persistent": prepare_triton_persistent,
    "triton_grouped": prepare_triton_grouped,
    "deepseek_fp8": prepare_deepseek_fp8,
}


def validate_candidate_parameters(workload: str, parameters: dict[str, Any]) -> dict[str, Any]:
    if workload not in PREPARE_CANDIDATES:
        raise ValueError(f"unknown candidate workload: {workload}")
    if not isinstance(parameters, dict):
        raise ValueError("params must be an object")
    dimensions = {"rows", "columns", "reduction"}
    if workload == "triton_grouped":
        dimensions.add("groups")
    if "configuration" in parameters and parameters["configuration"] != "large_tile":
        raise ValueError("configuration must be large_tile when specified")
    if set(parameters) - {"configuration"} != dimensions | {"dtype"}:
        raise ValueError(
            f"{workload} requires exactly these params: {', '.join(sorted(dimensions | {'dtype'}))}"
        )
    for key in dimensions:
        if type(parameters[key]) is not int or parameters[key] <= 0:
            raise ValueError(f"{key} must be a positive integer")
    dtype = "fp8" if workload == "deepseek_fp8" else "fp16"
    if parameters["dtype"] != dtype:
        raise ValueError(f"{workload} requires dtype={dtype}")
    if workload == "triton_grouped":
        tile = 128 if parameters.get("configuration") == "large_tile" else 64
        if parameters["rows"] % tile or parameters["columns"] % tile or parameters["reduction"] % 64:
            raise ValueError(
                f"upstream grouped GEMM requires full {tile}-element tiles in rows/columns and 64-element reduction tiles"
            )
    return dict(parameters)
