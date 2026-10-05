# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Fixed-launch adapters for pinned upstream candidate kernels."""

import torch
import triton

from benchmarks.measurement import TritonLaunch, deterministic_tensor, to_cpu

TRITON_COMMIT = "ced7e4b42f992f0b125208767cafc371d079ffd9"
DEEPSEEK_COMMIT = "9b4e9788e4a3a731f7567338ed15d3ec549ce03b"


def _constant_check(outputs, reduction, input_dtype=torch.float16, scales=1.0):
    # The same explicitly rounded constants initialize every element on device.
    # Validate every output element without a second large GEMM in the guest.
    def check():
        for index, output in enumerate(outputs):
            a = (
                torch.tensor(((index * 17) % 251 + 1) / 251.0, dtype=input_dtype)
                .float()
                .item()
            )
            b = (
                torch.tensor(((83 + index * 17) % 251 + 1) / 251.0, dtype=input_dtype)
                .float()
                .item()
            )
            expected = torch.full(
                output.shape, reduction * a * b * scales, dtype=output.dtype
            )
            torch.testing.assert_close(
                to_cpu(output), expected, rtol=0.01, atol=0.01
            )

    return check


def _metadata(parameters, source, entrypoint, launch):
    repository, commit = source
    parameters.update(
        {
            "input_pattern": "deterministic_nonzero_constant_by_phase",
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
    a = deterministic_tensor((m, k), torch.float16)
    b = deterministic_tensor((k, n), torch.float16, phase=83)
    c = torch.empty((m, n), device="cuda", dtype=torch.float16)
    sms = torch.cuda.get_device_properties("cuda").multi_processor_count
    issue_configuration = parameters.get("configuration") == "issue12611"
    tile = 128 if issue_configuration else 64
    grid = (min(sms, triton.cdiv(m, tile) * triton.cdiv(n, tile)),)
    knobs = {
        "BLOCK_SIZE_M": tile,
        "BLOCK_SIZE_N": tile,
        "BLOCK_SIZE_K": 64,
        "GROUP_SIZE_M": 8,
        "NUM_SMS": sms,
        "num_warps": 4,
        "num_stages": 2 if issue_configuration else 1,
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
        **knobs,
    )

    _metadata(
        parameters,
        ("https://github.com/triton-lang/triton", TRITON_COMMIT),
        "09-persistent-matmul.py:matmul_kernel_persistent",
        {"grid": list(grid), **knobs},
    )
    return parameters, launch, _constant_check([c], k)


def prepare_triton_grouped(parameters):
    from corpus.benchmarks.third_party.triton_candidates.grouped import (
        grouped_matmul_kernel,
    )

    m, n, k = (parameters[name] for name in ("rows", "columns", "reduction"))
    groups = parameters["groups"]
    aa = [
        deterministic_tensor((m, k), torch.float16, phase=i * 17) for i in range(groups)
    ]
    bb = [
        deterministic_tensor((k, n), torch.float16, phase=83 + i * 17)
        for i in range(groups)
    ]
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
    issue_configuration = parameters.get("configuration") == "issue12611"
    tile = 128 if issue_configuration else 64
    knobs = {
        "BLOCK_SIZE_M": tile,
        "BLOCK_SIZE_N": tile,
        "BLOCK_SIZE_K": 64,
        "NUM_SM": sms,
        "num_warps": 4,
        "num_stages": 2 if issue_configuration else 1,
    }

    launch = TritonLaunch(
        grouped_matmul_kernel, (sms,),
        *pointers,
        sizes,
        strides,
        groups,
        **knobs,
        keepalive=(aa, bb, cc),
    )

    _metadata(
        parameters,
        ("https://github.com/triton-lang/triton", TRITON_COMMIT),
        "08-grouped-gemm.py:grouped_matmul_kernel",
        {"grid": [sms], **knobs},
    )
    return parameters, launch, _constant_check(cc, k)


def prepare_deepseek_fp8(parameters):
    from corpus.benchmarks.third_party.deepseek.kernel import fp8_gemm_kernel

    m, n, k = (parameters[name] for name in ("rows", "columns", "reduction"))
    dtype = torch.float8_e4m3fn
    a = deterministic_tensor((m, k), dtype)
    b = deterministic_tensor((n, k), dtype, phase=83)
    issue_configuration = parameters.get("configuration") == "issue12611"
    scale_a, scale_b = (1.0, 1.0) if issue_configuration else (0.5, 0.25)
    tile_m = 64 if issue_configuration else 32
    a_scale = torch.full(
        (m, triton.cdiv(k, 128)), scale_a, device="cuda", dtype=torch.float32
    )
    b_scale = torch.full(
        (triton.cdiv(n, 128), triton.cdiv(k, 128)),
        scale_b,
        device="cuda",
        dtype=torch.float32,
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
        **knobs,
    )

    _metadata(
        parameters,
        ("https://github.com/deepseek-ai/DeepSeek-V3", DEEPSEEK_COMMIT),
        "inference/kernel.py:fp8_gemm_kernel",
        {"grid": list(grid), **knobs},
    )
    parameters["output_dtype"] = "bf16"
    parameters["scale_values"] = [scale_a, scale_b]
    return parameters, launch, _constant_check(
        [c], k, input_dtype=dtype, scales=scale_a * scale_b
    )


PREPARE_CANDIDATES = {
    "triton_persistent": prepare_triton_persistent,
    "triton_grouped": prepare_triton_grouped,
    "deepseek_fp8": prepare_deepseek_fp8,
}


def validate_candidate_parameters(workload, parameters):
    if workload not in PREPARE_CANDIDATES:
        raise ValueError(f"unknown candidate workload: {workload}")
    if not isinstance(parameters, dict):
        raise ValueError("params must be an object")
    dimensions = {"rows", "columns", "reduction"}
    if workload == "triton_grouped":
        dimensions.add("groups")
    if "configuration" in parameters and parameters["configuration"] != "issue12611":
        raise ValueError("configuration must be issue12611 when specified")
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
        tile = 128 if parameters.get("configuration") == "issue12611" else 64
        if parameters["rows"] % tile or parameters["columns"] % tile or parameters["reduction"] % 64:
            raise ValueError(
                f"upstream grouped GEMM requires full {tile}-element tiles in rows/columns and 64-element reduction tiles"
            )
    return dict(parameters)
