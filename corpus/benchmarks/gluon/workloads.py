#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Bounded Gluon copies; imports device dependencies only for actual execution."""

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
SCHEMA = "rocjitsu.benchmark.workload.v1"
WORKLOADS = ("gluon_copy", "gluon_copy_2d")


def validate_parameters(workload, parameters):
    keys = {"elements"} if workload == "gluon_copy" else {"rows", "columns"}
    if (
        workload not in WORKLOADS
        or not isinstance(parameters, dict)
        or set(parameters) - {"dtype"} != keys
    ):
        raise ValueError("unknown workload or unexpected parameters")
    if parameters.get("dtype", "fp32") != "fp32":
        raise ValueError("dtype must be fp32")
    product = 1
    for key in keys:
        value = parameters[key]
        if type(value) is not int or not 1 <= value <= 134217728:
            raise ValueError("dimensions must be positive bounded integers")
        product *= value
    if product > 134217728:
        raise ValueError("copy footprint exceeds 134217728 elements")
    return {**parameters, "dtype": "fp32"}


def result(case, target, parameters, timings):
    if target not in ("gfx1100", "gfx1201"):
        raise ValueError("unsupported target")
    if not timings or any(type(x) is not int or x <= 0 for x in timings):
        raise ValueError("timings must be positive integer nanoseconds")
    return dict(
        schema=SCHEMA,
        case=case,
        target=target,
        provider="gluon",
        parameters=parameters,
        timings_ns=timings,
    )


def host_input(rows, columns, *, pinned=True):
    import torch

    # CPU generation only; dyadic, nonuniform and exactly representable.
    host = torch.empty((rows, columns), dtype=torch.float32, pin_memory=pinned)
    flat = host.view(-1)
    for start in range(0, rows * columns, 1048576):
        end = min(rows * columns, start + 1048576)
        values = torch.arange(start, end, dtype=torch.int64) % 8191 - 4095
        flat[start:end].copy_(values.to(torch.float32).div_(16))
    return host


def poison_output(output):
    # fill_ honors arbitrary strides; view(uint8) fails for the transposed view.
    output.fill_(float("nan"))


def check_output(actual, expected):
    import torch

    if (
        actual.device.type != "cpu"
        or expected.device.type != "cpu"
        or actual.shape != expected.shape
    ):
        raise RuntimeError("copy validation requires equal-shaped CPU tensors")
    chunk_rows = max(1, 1048576 // expected.shape[1])
    for start in range(0, expected.shape[0], chunk_rows):
        if not torch.equal(
            actual[start : start + chunk_rows], expected[start : start + chunk_rows]
        ):
            raise RuntimeError("full exact CPU copy validation failed")


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workload", choices=WORKLOADS, required=True)
    parser.add_argument("--params", required=True)
    parser.add_argument("--case", required=True)
    parser.add_argument("--target", choices=("gfx1100", "gfx1201"), required=True)
    parser.add_argument("--warmups", type=int, default=0)
    parser.add_argument("--samples", type=int, default=1)
    parser.add_argument("--output", default="-")
    args = parser.parse_args(argv)
    try:
        params = validate_parameters(args.workload, json.loads(args.params))
        if not 0 <= args.warmups <= 100 or not 1 <= args.samples <= 100:
            raise ValueError("warmups must be 0..100 and samples 1..100")
    except (ValueError, TypeError) as exc:
        parser.error(str(exc))
    from corpus.benchmarks.gluon.prepare import verify_local

    verify_local()
    import torch
    import triton
    from triton.experimental.gluon import language as gl
    from corpus.benchmarks.gluon.kernels import memcpy_1d_kernel, memcpy_2d_inout_kernel
    from benchmarks.measurement import (
        TritonLaunch,
        measure,
        to_cpu,
        reported_target,
        target_matches,
        progress_writer,
        write_result,
    )

    if not target_matches(reported_target(), args.target):
        raise RuntimeError("reported target does not match requested target")
    rows = params.get("rows", params.get("elements"))
    columns = params.get("columns", 1)
    host = host_input(rows, columns)
    x = host.to(device="cuda")
    if args.workload == "gluon_copy":
        y = torch.empty_like(x)
        launch = TritonLaunch(
            memcpy_1d_kernel,
            (triton.cdiv(rows, 1024),),
            x,
            y,
            rows,
            XBLOCK=1024,
            layout=gl.BlockedLayout([1], [32], [4], [0]),
            num_warps=4,
            before_launch=lambda: poison_output(y),
        )
    else:
        y = torch.empty((columns, rows), device="cuda", dtype=torch.float32).T
        launch = TritonLaunch(
            memcpy_2d_inout_kernel,
            (triton.cdiv(rows, 128), triton.cdiv(columns, 128)),
            x,
            y,
            rows,
            columns,
            *x.stride(),
            *y.stride(),
            gl.BlockedLayout([1, 4], [4, 8], [4, 1], [1, 0]),
            gl.BlockedLayout([4, 1], [8, 4], [1, 4], [0, 1]),
            128,
            128,
            num_warps=4,
            before_launch=lambda: poison_output(y)
        )
    launch.compile()
    torch.cuda.synchronize()
    timings = measure(
        launch, args.warmups, args.samples, progress_writer(args.output, args.case)
    )
    check_output(to_cpu(y), host)
    write_result(args.output, result(args.case, args.target, params, timings))


if __name__ == "__main__":
    main()
