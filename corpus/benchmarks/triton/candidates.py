# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Fixed-launch adapters for pinned upstream candidate kernels."""

import torch
import triton

from benchmarks.measurement import deterministic_tensor

TRITON_COMMIT = "ced7e4b42f992f0b125208767cafc371d079ffd9"
DEEPSEEK_COMMIT = "9b4e9788e4a3a731f7567338ed15d3ec549ce03b"


def _copy_to_cpu(tensor):
    host = torch.empty(tensor.shape, dtype=tensor.dtype, device="cpu", pin_memory=True)
    host.copy_(tensor)
    return host


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
                _copy_to_cpu(output), expected, rtol=0.01, atol=0.01
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
    grid = (min(sms, triton.cdiv(m, 64) * triton.cdiv(n, 64)),)
    knobs = {
        "BLOCK_SIZE_M": 64,
        "BLOCK_SIZE_N": 64,
        "BLOCK_SIZE_K": 64,
        "GROUP_SIZE_M": 8,
        "NUM_SMS": sms,
        "num_warps": 4,
        "num_stages": 1,
    }

    def launch():
        matmul_kernel_persistent[grid](
            a, b, c, m, n, k, *a.stride(), *b.stride(), *c.stride(), **knobs
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
    groups = parameters.get("groups", 4)
    if m % 64 or n % 64 or k % 64:
        raise ValueError("upstream grouped GEMM requires full 64-element tiles")
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
    knobs = {
        "BLOCK_SIZE_M": 64,
        "BLOCK_SIZE_N": 64,
        "BLOCK_SIZE_K": 64,
        "NUM_SM": sms,
        "num_warps": 4,
        "num_stages": 1,
    }

    def launch():
        # Keep allocations addressed by the device pointer tables alive.
        _ = aa, bb, cc
        grouped_matmul_kernel[(sms,)](*pointers, sizes, strides, groups, **knobs)

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
    a_scale = torch.full(
        (m, triton.cdiv(k, 128)), 0.5, device="cuda", dtype=torch.float32
    )
    b_scale = torch.full(
        (triton.cdiv(n, 128), triton.cdiv(k, 128)),
        0.25,
        device="cuda",
        dtype=torch.float32,
    )
    c = torch.empty((m, n), device="cuda", dtype=torch.bfloat16)
    grid = (triton.cdiv(m, 32), triton.cdiv(n, 64))
    knobs = {
        "BLOCK_SIZE_M": 32,
        "BLOCK_SIZE_N": 64,
        "BLOCK_SIZE_K": 128,
        "num_warps": 8,
        "num_stages": 3,
    }

    def launch():
        fp8_gemm_kernel.fn[grid](a, b, c, a_scale, b_scale, m, n, k, **knobs)

    _metadata(
        parameters,
        ("https://github.com/deepseek-ai/DeepSeek-V3", DEEPSEEK_COMMIT),
        "inference/kernel.py:fp8_gemm_kernel",
        {"grid": list(grid), **knobs},
    )
    parameters["output_dtype"] = "bf16"
    parameters["scale_values"] = [0.5, 0.25]
    return parameters, launch, _constant_check([c], k, input_dtype=dtype, scales=0.125)


def prepare_triton_library(parameters):
    """Prepare upstream wrapper once, then replay its single fixed kernel launch."""
    import importlib
    import os
    from pathlib import Path
    import sys

    root = os.environ.get("ROCJITSU_TRITON_KERNELS_ROOT")
    if not root:
        raise ValueError(
            "ROCJITSU_TRITON_KERNELS_ROOT must point to the pinned python/triton_kernels directory"
        )
    package_root = Path(root).resolve()
    if not (package_root / "triton_kernels/matmul.py").is_file():
        raise ValueError(
            "ROCJITSU_TRITON_KERNELS_ROOT does not contain triton_kernels/matmul.py"
        )
    sys.path.insert(0, str(package_root))
    upstream = importlib.import_module("triton_kernels.matmul")
    if not Path(upstream.__file__).resolve().is_relative_to(package_root):
        raise RuntimeError(
            "another triton_kernels package was imported before the pinned dependency"
        )
    m, n, k = (parameters[name] for name in ("rows", "columns", "reduction"))
    a = deterministic_tensor((m, k), torch.float16)
    b = deterministic_tensor((k, n), torch.float16, phase=83)
    c = torch.empty((m, n), device="cuda", dtype=torch.float16)
    flags = upstream.OptFlags(
        block_m=64,
        block_n=64,
        block_k=64,
        num_warps=4,
        num_stages=1,
        group_m=8,
        xcd_swizzle=0,
        w_cache_modifier="",
        split_k=1,
        is_persistent=False,
        idle_sms=0,
        epilogue_subtile=1,
        arch=None,
        occupancy_target=1,
        target_kernel_kwargs={},
    )
    kernels = upstream.specializations.get()
    kernel = kernels._matmul
    captured = []

    class Capture:
        def __getitem__(self, grid):
            def capture(*args, **kwargs):
                captured.append((grid, args, kwargs))

            return capture

    # This adapter runs in a single-threaded workload process. Restore upstream
    # state even if allocation or argument preparation fails.
    kernels._matmul = Capture()
    try:
        with upstream.scoped_opt_flags(flags):
            upstream.matmul(a, b, None, c=c)
    finally:
        kernels._matmul = kernel
    if len(captured) != 1:
        raise RuntimeError(
            f"expected one upstream _matmul launch, captured {len(captured)}"
        )
    grid, args, kwargs = captured[0]

    def launch():
        kernel[grid](*args, **kwargs)

    _metadata(
        parameters,
        ("https://github.com/triton-lang/triton", TRITON_COMMIT),
        "python/triton_kernels/triton_kernels/matmul_details/_matmul.py:_matmul",
        {"grid": list(grid), **vars(flags)},
    )
    parameters["dependency_root"] = str(package_root)
    return parameters, launch, _constant_check([c], k)


PREPARE_CANDIDATES = {
    "triton_matmul": prepare_triton_library,
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
    if set(parameters) != dimensions | {"dtype"}:
        raise ValueError(
            f"{workload} requires exactly these params: {', '.join(sorted(dimensions | {'dtype'}))}"
        )
    for key in dimensions:
        if type(parameters[key]) is not int or parameters[key] <= 0:
            raise ValueError(f"{key} must be a positive integer")
    dtype = "fp8" if workload == "deepseek_fp8" else "fp16"
    if parameters["dtype"] != dtype:
        raise ValueError(f"{workload} requires dtype={dtype}")
    if workload == "triton_grouped" and any(
        parameters[key] % 64 for key in ("rows", "columns", "reduction")
    ):
        raise ValueError("upstream grouped GEMM requires full 64-element tiles")
    return dict(parameters)
