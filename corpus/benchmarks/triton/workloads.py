#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Parameterized, deterministic Triton workloads for end-to-end rocjitsu runs."""

from __future__ import annotations

import argparse
import json
import math
import sys
from typing import Any

import torch
import triton
import triton.language as tl

from benchmarks.measurement import (
    deterministic_tensor as _deterministic_tensor,
    measure as _measure,
    reported_target as _reported_target,
    target_matches as _target_matches,
    write_result as _write_result,
)

SCHEMA = "rocjitsu.benchmark.workload.v1"


@triton.jit
def _copy_kernel(
    input_pointer, output_pointer, elements: tl.constexpr, BLOCK_SIZE: tl.constexpr
):
    offsets = tl.program_id(0) * BLOCK_SIZE + tl.arange(0, BLOCK_SIZE)
    mask = offsets < elements
    values = tl.load(input_pointer + offsets, mask=mask)
    tl.store(output_pointer + offsets, values, mask=mask)


@triton.jit
def _vector_add_kernel(
    left_pointer,
    right_pointer,
    output_pointer,
    elements: tl.constexpr,
    BLOCK_SIZE: tl.constexpr,
):
    offsets = tl.program_id(0) * BLOCK_SIZE + tl.arange(0, BLOCK_SIZE)
    mask = offsets < elements
    left = tl.load(left_pointer + offsets, mask=mask)
    right = tl.load(right_pointer + offsets, mask=mask)
    tl.store(output_pointer + offsets, left + right, mask=mask)


@triton.jit
def _transpose_kernel(
    input_pointer,
    output_pointer,
    rows: tl.constexpr,
    columns: tl.constexpr,
    TILE: tl.constexpr,
):
    tile_row = tl.program_id(0)
    tile_column = tl.program_id(1)
    row_offsets = tile_row * TILE + tl.arange(0, TILE)
    column_offsets = tile_column * TILE + tl.arange(0, TILE)
    mask = (row_offsets[:, None] < rows) & (column_offsets[None, :] < columns)
    values = tl.load(
        input_pointer + row_offsets[:, None] * columns + column_offsets[None, :],
        mask=mask,
    )
    tl.store(
        output_pointer + column_offsets[None, :] * rows + row_offsets[:, None],
        values,
        mask=mask,
    )


@triton.jit
def _gather_kernel(
    input_pointer,
    index_pointer,
    output_pointer,
    elements: tl.constexpr,
    BLOCK_SIZE: tl.constexpr,
):
    offsets = tl.program_id(0) * BLOCK_SIZE + tl.arange(0, BLOCK_SIZE)
    mask = offsets < elements
    indices = tl.load(index_pointer + offsets, mask=mask, other=0)
    values = tl.load(input_pointer + indices, mask=mask)
    tl.store(output_pointer + offsets, values, mask=mask)


@triton.jit
def _atomic_add_kernel(
    input_pointer,
    output_pointer,
    elements: tl.constexpr,
    buckets: tl.constexpr,
    BLOCK_SIZE: tl.constexpr,
):
    offsets = tl.program_id(0) * BLOCK_SIZE + tl.arange(0, BLOCK_SIZE)
    mask = offsets < elements
    values = tl.load(input_pointer + offsets, mask=mask, other=0.0)
    tl.atomic_add(output_pointer + offsets % buckets, values, mask=mask)


@triton.jit
def _softmax_kernel(
    input_pointer, output_pointer, row_width: tl.constexpr, BLOCK_SIZE: tl.constexpr
):
    row = tl.program_id(0)
    columns = tl.arange(0, BLOCK_SIZE)
    mask = columns < row_width
    values = tl.load(
        input_pointer + row * row_width + columns, mask=mask, other=-float("inf")
    ).to(tl.float32)
    values -= tl.max(values, axis=0)
    numerator = tl.exp(values)
    result = numerator / tl.sum(numerator, axis=0)
    tl.store(output_pointer + row * row_width + columns, result, mask=mask)


@triton.jit
def _rmsnorm_kernel(
    input_pointer,
    output_pointer,
    row_width: tl.constexpr,
    epsilon: tl.constexpr,
    BLOCK_SIZE: tl.constexpr,
):
    row = tl.program_id(0)
    columns = tl.arange(0, BLOCK_SIZE)
    mask = columns < row_width
    values = tl.load(
        input_pointer + row * row_width + columns, mask=mask, other=0.0
    ).to(tl.float32)
    mean_square = tl.sum(values * values, axis=0) / row_width
    normalized = values * tl.rsqrt(mean_square + epsilon)
    tl.store(output_pointer + row * row_width + columns, normalized, mask=mask)


@triton.jit
def _gemm_kernel(
    left_pointer,
    right_pointer,
    output_pointer,
    rows: tl.constexpr,
    columns: tl.constexpr,
    reduction: tl.constexpr,
    BLOCK_M: tl.constexpr,
    BLOCK_N: tl.constexpr,
    BLOCK_K: tl.constexpr,
):
    program = tl.program_id(0)
    programs_n = tl.cdiv(columns, BLOCK_N)
    program_m = program // programs_n
    program_n = program % programs_n

    offsets_m = program_m * BLOCK_M + tl.arange(0, BLOCK_M)
    offsets_n = program_n * BLOCK_N + tl.arange(0, BLOCK_N)
    offsets_k = tl.arange(0, BLOCK_K)
    accumulator = tl.zeros((BLOCK_M, BLOCK_N), dtype=tl.float32)

    for reduction_start in range(0, reduction, BLOCK_K):
        reduction_offsets = reduction_start + offsets_k
        left = tl.load(
            left_pointer + offsets_m[:, None] * reduction + reduction_offsets[None, :],
            mask=(offsets_m[:, None] < rows) & (reduction_offsets[None, :] < reduction),
            other=0.0,
        )
        right = tl.load(
            right_pointer + reduction_offsets[:, None] * columns + offsets_n[None, :],
            mask=(reduction_offsets[:, None] < reduction)
            & (offsets_n[None, :] < columns),
            other=0.0,
        )
        accumulator += tl.dot(left, right)

    tl.store(
        output_pointer + offsets_m[:, None] * columns + offsets_n[None, :],
        accumulator,
        mask=(offsets_m[:, None] < rows) & (offsets_n[None, :] < columns),
    )


def prepare_copy(parameters):
    elements = parameters["elements"]
    input_gpu = _deterministic_tensor((elements,), DTYPES[parameters["dtype"]])
    output_gpu = torch.empty_like(input_gpu)
    block_size, num_warps, num_stages = 1024, 4, 1
    grid = (triton.cdiv(elements, block_size),)
    parameters["launch"] = {
        "grid": list(grid),
        "block_size": block_size,
        "num_warps": num_warps,
        "num_stages": num_stages,
    }

    def launch() -> None:
        _copy_kernel[grid](
            input_gpu,
            output_gpu,
            elements=elements,
            BLOCK_SIZE=block_size,
            num_warps=num_warps,
            num_stages=num_stages,
        )

    return parameters, launch, None


def prepare_vector_add(parameters):
    elements = parameters["elements"]
    left_gpu = _deterministic_tensor((elements,), DTYPES[parameters["dtype"]])
    right_gpu = _deterministic_tensor(
        (elements,), DTYPES[parameters["dtype"]], phase=83
    )
    output_gpu = torch.empty_like(left_gpu)
    block_size, num_warps, num_stages = 1024, 4, 1
    grid = (triton.cdiv(elements, block_size),)
    parameters["launch"] = {
        "grid": list(grid),
        "block_size": block_size,
        "num_warps": num_warps,
        "num_stages": num_stages,
    }

    def launch() -> None:
        _vector_add_kernel[grid](
            left_gpu,
            right_gpu,
            output_gpu,
            elements=elements,
            BLOCK_SIZE=block_size,
            num_warps=num_warps,
            num_stages=num_stages,
        )

    return parameters, launch, None


def prepare_transpose(parameters):
    rows, columns = parameters["rows"], parameters["columns"]
    input_gpu = _deterministic_tensor((rows, columns), DTYPES[parameters["dtype"]])
    output_gpu = torch.empty(
        (columns, rows), device="cuda", dtype=DTYPES[parameters["dtype"]]
    )
    tile, num_warps, num_stages = 32, 8, 1
    grid = (triton.cdiv(rows, tile), triton.cdiv(columns, tile))
    parameters["launch"] = {
        "grid": list(grid),
        "tile": [tile, tile],
        "num_warps": num_warps,
        "num_stages": num_stages,
    }

    def launch() -> None:
        _transpose_kernel[grid](
            input_gpu,
            output_gpu,
            rows=rows,
            columns=columns,
            TILE=tile,
            num_warps=num_warps,
            num_stages=num_stages,
        )

    return parameters, launch, None


def prepare_gather(parameters):
    source_elements = parameters["source_elements"]
    output_elements = parameters["output_elements"]
    input_gpu = _deterministic_tensor((source_elements,), DTYPES[parameters["dtype"]])
    last_index = (
        parameters["index_offset"] + output_elements * parameters["index_stride"]
    )
    indices_gpu = torch.arange(
        parameters["index_offset"],
        last_index,
        parameters["index_stride"],
        device="cuda",
        dtype=torch.int64,
    )
    indices_gpu.remainder_(source_elements)
    output_gpu = torch.empty(
        output_elements, device="cuda", dtype=DTYPES[parameters["dtype"]]
    )
    block_size, num_warps, num_stages = 512, 4, 1
    grid = (triton.cdiv(output_elements, block_size),)
    parameters["launch"] = {
        "grid": list(grid),
        "block_size": block_size,
        "num_warps": num_warps,
        "num_stages": num_stages,
    }

    def launch() -> None:
        _gather_kernel[grid](
            input_gpu,
            indices_gpu,
            output_gpu,
            elements=output_elements,
            BLOCK_SIZE=block_size,
            num_warps=num_warps,
            num_stages=num_stages,
        )

    return parameters, launch, None


def prepare_atomic_add(parameters):
    elements, buckets = parameters["elements"], parameters["buckets"]
    input_gpu = _deterministic_tensor((elements,), DTYPES[parameters["dtype"]])
    output_gpu = torch.zeros(buckets, device="cuda", dtype=DTYPES[parameters["dtype"]])
    block_size, num_warps, num_stages = 256, 8, 1
    grid = (triton.cdiv(elements, block_size),)
    parameters["launch"] = {
        "grid": list(grid),
        "block_size": block_size,
        "num_warps": num_warps,
        "num_stages": num_stages,
    }

    def launch() -> None:
        _atomic_add_kernel[grid](
            input_gpu,
            output_gpu,
            elements=elements,
            buckets=buckets,
            BLOCK_SIZE=block_size,
            num_warps=num_warps,
            num_stages=num_stages,
        )

    return parameters, launch, None


def prepare_softmax(parameters):
    rows = parameters["rows"]
    columns = parameters["columns"]
    input_gpu = _deterministic_tensor((rows, columns), DTYPES[parameters["dtype"]])
    output_gpu = torch.empty_like(input_gpu)
    block_size = triton.next_power_of_2(columns)
    num_warps, num_stages = 8, 1
    grid = (rows,)
    parameters["launch"] = {
        "grid": list(grid),
        "block_size": block_size,
        "num_warps": num_warps,
        "num_stages": num_stages,
    }

    def launch() -> None:
        _softmax_kernel[grid](
            input_gpu,
            output_gpu,
            row_width=columns,
            BLOCK_SIZE=block_size,
            num_warps=num_warps,
            num_stages=num_stages,
        )

    return parameters, launch, None


def prepare_rmsnorm(parameters):
    rows = parameters["rows"]
    columns = parameters["columns"]
    epsilon = parameters["epsilon"]
    input_gpu = _deterministic_tensor((rows, columns), DTYPES[parameters["dtype"]])
    output_gpu = torch.empty_like(input_gpu)
    block_size = triton.next_power_of_2(columns)
    num_warps, num_stages = 8, 1
    grid = (rows,)
    parameters["launch"] = {
        "grid": list(grid),
        "block_size": block_size,
        "num_warps": num_warps,
        "num_stages": num_stages,
    }

    def launch() -> None:
        _rmsnorm_kernel[grid](
            input_gpu,
            output_gpu,
            row_width=columns,
            epsilon=epsilon,
            BLOCK_SIZE=block_size,
            num_warps=num_warps,
            num_stages=num_stages,
        )

    return parameters, launch, None


def prepare_gemm(parameters):
    rows, columns, reduction = parameters["m"], parameters["n"], parameters["k"]
    left_gpu = _deterministic_tensor((rows, reduction), DTYPES[parameters["dtype"]])
    right_gpu = _deterministic_tensor(
        (reduction, columns), DTYPES[parameters["dtype"]], phase=83
    )
    output_gpu = torch.empty(
        (rows, columns), device="cuda", dtype=DTYPES[parameters["dtype"]]
    )
    block_m, block_n, block_k = 64, 64, 32
    num_warps, num_stages = 4, 2
    grid = (triton.cdiv(rows, block_m) * triton.cdiv(columns, block_n),)
    parameters["launch"] = {
        "grid": list(grid),
        "block": [block_m, block_n, block_k],
        "num_warps": num_warps,
        "num_stages": num_stages,
    }

    def launch() -> None:
        _gemm_kernel[grid](
            left_gpu,
            right_gpu,
            output_gpu,
            rows=rows,
            columns=columns,
            reduction=reduction,
            BLOCK_M=block_m,
            BLOCK_N=block_n,
            BLOCK_K=block_k,
            num_warps=num_warps,
            num_stages=num_stages,
        )

    return parameters, launch, None


def to_cpu(tensor):
    # The simulated KMD needs host pages registered for device-to-host copies.
    # Pinned memory uses that public HIP path; pageable tensor.cpu() does not.
    host = torch.empty(tensor.shape, dtype=tensor.dtype, device="cpu", pin_memory=True)
    host.copy_(tensor)
    return host


def prepare_gpt_oss_attention(parameters):
    from triton.tools.tensor_descriptor import TensorDescriptor

    from corpus.benchmarks.triton.gpt_oss_attention import _attn_fwd, attention_ref

    batch, sequence = parameters["batch"], parameters["sequence"]
    heads, kv_heads = parameters["query_heads"], parameters["key_value_heads"]
    dimension, window = parameters["head_dimension"], parameters["window"]
    groups = heads // kv_heads
    q = _deterministic_tensor(
        (batch, sequence, kv_heads, groups, dimension), torch.bfloat16
    )
    k = _deterministic_tensor(
        (batch, sequence, kv_heads, dimension), torch.bfloat16, phase=83
    )
    v = _deterministic_tensor(
        (batch, sequence, kv_heads, dimension), torch.bfloat16, phase=167
    )
    sinks = _deterministic_tensor((heads,), torch.bfloat16, phase=41)
    start = torch.zeros((batch,), device="cuda", dtype=torch.int32)
    grid = (sequence // 64, batch * heads, 1)

    # Match upstream attention.forward's layout preparation, once, before timing.
    q_kernel = q.reshape(batch, sequence, heads, dimension).transpose(1, 2).contiguous()
    k_kernel = k.repeat_interleave(groups, dim=2).transpose(1, 2).contiguous()
    v_kernel = v.repeat_interleave(groups, dim=2).transpose(1, 2).contiguous()
    output = torch.empty_like(q_kernel)
    logsumexp = torch.empty(
        (batch, heads, sequence), device="cuda", dtype=torch.float32
    )
    descriptors = tuple(
        TensorDescriptor.from_tensor(tensor, [1, 1, 64, 64])
        for tensor in (q_kernel, k_kernel, v_kernel, output)
    )

    def launch():
        _attn_fwd[grid](
            descriptors[0],
            descriptors[1],
            descriptors[2],
            sinks,
            0.125,
            logsumexp,
            descriptors[3],
            start,
            batch,
            heads,
            sequence,
            sequence,
            HEAD_DIM=64,
            BLOCK_M=64,
            BLOCK_N=64,
            BANDWIDTH=window,
            num_warps=4,
            num_stages=1,
        )

    def check():
        # CPU reference and output copies are outside the sampling loop.
        expected = attention_ref(
            to_cpu(q),
            to_cpu(k),
            to_cpu(v),
            to_cpu(sinks),
            sm_scale=0.125,
            sliding_window=window,
            start_q=0,
        )
        actual = (
            to_cpu(output).transpose(1, 2).reshape(batch, sequence, heads * dimension)
        )
        torch.testing.assert_close(actual, expected)

    parameters.update(
        {
            "causal": True,
            "learned_sinks": True,
            "input_pattern": "deterministic_nonzero_constant_by_phase",
            "measurement_scope": "kernel_launch_and_synchronize",
            "source": {
                "repository": "https://github.com/openai/gpt-oss",
                "commit": "7b583341fe16729127f6d5b94a7b09ccae97e1a1",
                "entrypoint": "gpt_oss.triton.attention._attn_fwd",
            },
            "launch": {
                "grid": list(grid),
                "block": [64, 64],
                "num_warps": 4,
                "num_stages": 1,
            },
        }
    )
    return parameters, launch, check


DTYPES = {"fp16": torch.float16, "bf16": torch.bfloat16, "fp32": torch.float32}
PREPARE = {
    "copy": prepare_copy,
    "vector_add": prepare_vector_add,
    "transpose": prepare_transpose,
    "gather": prepare_gather,
    "atomic_add": prepare_atomic_add,
    "softmax": prepare_softmax,
    "rmsnorm": prepare_rmsnorm,
    "gemm": prepare_gemm,
    "gpt_oss_attention": prepare_gpt_oss_attention,
}


def validate_parameters(workload: str, parameters: dict[str, Any]) -> dict[str, Any]:
    """Reject unsupported inputs before allocating any GPU buffers."""
    dimensions = {
        "copy": ("elements",),
        "vector_add": ("elements",),
        "transpose": ("rows", "columns"),
        "gather": ("source_elements", "output_elements", "index_stride"),
        "atomic_add": ("elements", "buckets"),
        "softmax": ("rows", "columns"),
        "rmsnorm": ("rows", "columns"),
        "gemm": ("m", "n", "k"),
        "gpt_oss_attention": (
            "batch",
            "query_heads",
            "key_value_heads",
            "sequence",
            "head_dimension",
        ),
    }
    if workload not in PREPARE:
        raise ValueError(f"unknown workload: {workload}")
    if not isinstance(parameters, dict):
        raise ValueError("params must be an object")
    p = dict(parameters)
    extra = {
        "gather": {"index_offset"},
        "rmsnorm": {"epsilon"},
        "gpt_oss_attention": {"window"},
    }.get(workload, set())
    expected = {"dtype", *dimensions[workload]} | extra
    if set(p) != expected:
        raise ValueError(
            f"{workload} requires exactly these params: {', '.join(sorted(expected))}"
        )
    allowed = {
        "gemm": ("fp16", "bf16"),
        "atomic_add": ("fp32",),
        "gpt_oss_attention": ("bf16",),
    }.get(workload, tuple(DTYPES))
    if p["dtype"] not in allowed:
        raise ValueError(f"{workload} dtype must be one of {allowed}")
    for key in dimensions[workload]:
        if type(p[key]) is not int or p[key] <= 0:
            raise ValueError(f"{key} must be a positive integer")
    if workload == "gather" and (
        type(p["index_offset"]) is not int or p["index_offset"] < 0
    ):
        raise ValueError("index_offset must be a nonnegative integer")
    if workload == "rmsnorm" and (
        type(p["epsilon"]) not in (int, float)
        or not math.isfinite(p["epsilon"])
        or p["epsilon"] <= 0
    ):
        raise ValueError("epsilon must be finite and positive")
    if workload == "gpt_oss_attention":
        if p["head_dimension"] != 64 or p["sequence"] % 64:
            raise ValueError(
                "GPT-OSS requires head_dimension=64 and sequence divisible by 64"
            )
        if p["query_heads"] % p["key_value_heads"]:
            raise ValueError("query_heads must be divisible by key_value_heads")
        if type(p["window"]) is not int or p["window"] < 0 or p["window"] % 64:
            raise ValueError("window must be zero or a positive multiple of 64")
    return p


def prepare(workload, parameters):
    p = validate_parameters(workload, parameters)
    p["input_pattern"] = "deterministic_nonzero_constant_by_phase"
    if workload == "copy":
        p["bytes"] = p["elements"] * (4 if p["dtype"] == "fp32" else 2)
    elif workload == "gather":
        p["index_dtype"] = "int64"
    elif workload == "gemm":
        p.update(
            trans_a="N", trans_b="N", input_dtype=p["dtype"], accumulator_dtype="fp32"
        )
        p["output_dtype"] = p["input_dtype"]
    resolved, launch, check = PREPARE[workload](p)
    if workload == "gemm":
        resolved.pop("dtype")
    if workload == "gpt_oss_attention":
        resolved.pop("dtype")
        if (p["query_heads"], p["key_value_heads"]) == (64, 8):
            resolved["model"] = "gpt-oss-20b"
    return resolved, launch, check


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--case", required=True)
    parser.add_argument("--workload", choices=PREPARE, required=True)
    parser.add_argument("--params", type=json.loads, required=True)
    parser.add_argument("--target", required=True)
    parser.add_argument("--warmups", type=int, default=3)
    parser.add_argument("--samples", type=int, default=21)
    parser.add_argument("--output", default="-")
    arguments = parser.parse_args()
    if arguments.warmups < 0:
        parser.error("--warmups must be nonnegative")
    if arguments.samples <= 0:
        parser.error("--samples must be positive")
    validate_parameters(arguments.workload, arguments.params)
    if not torch.version.hip or not torch.cuda.is_available():
        raise RuntimeError(
            "a ROCm PyTorch build and visible rocjitsu HIP device are required"
        )

    torch.cuda.set_device(0)
    reported_target = _reported_target()
    if not _target_matches(reported_target, arguments.target):
        raise RuntimeError(
            f"runtime reported target {reported_target!r}, expected {arguments.target!r}"
        )

    with torch.inference_mode():
        parameters, launch, check = prepare(arguments.workload, arguments.params)
        durations = _measure(launch, arguments.warmups, arguments.samples)
        if check is not None:
            check()

    result = {
        "schema": SCHEMA,
        "case": arguments.case,
        "target": arguments.target,
        "provider": "triton",
        "parameters": parameters,
        "timings_ns": durations,
    }
    _write_result(arguments.output, result)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as error:  # Keep the runner's stderr artifact actionable.
        print(f"rocjitsu Triton benchmark: {error}", file=sys.stderr)
        raise SystemExit(2) from error
