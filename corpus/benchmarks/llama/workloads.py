#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Fixed-count GGML graph adapter; no models, adaptive loops or CPU fallback."""

import argparse
import json
import os
from pathlib import Path
import subprocess

PIN = "26d52b0f9543f441fc2bfa383557c992a4fbf4b9"
WORKLOADS = {
    "llama_rope": "rope",
    "llama_matvec": "matvec-q4",
    "llama_gather": "gather-q8",
}
SCHEMA = "rocjitsu.benchmark.workload.v1"


def validate_parameters(workload, params):
    keys = (
        {"k", "heads", "tokens"}
        if workload == "llama_rope"
        else {"k", "rows", "tokens"}
    )
    if (
        workload not in WORKLOADS
        or not isinstance(params, dict)
        or set(params) - {"dtype"} != keys
    ):
        raise ValueError("unknown workload or unexpected parameters")
    if params.get("dtype", "fp32") != "fp32":
        raise ValueError("dtype must be fp32")
    if any(
        type(params[key]) is not int or not 1 <= params[key] <= 32768 for key in keys
    ):
        raise ValueError("dimensions must be integers in 1..32768")
    k, tokens = params["k"], params["tokens"]
    if k % (2 if workload == "llama_rope" else 32):
        raise ValueError("K must be even for RoPE or divisible by 32 for quantization")
    if workload == "llama_matvec" and tokens != 1:
        raise ValueError("matvec requires exactly one RHS")
    footprint = k * params.get("rows", params.get("heads", 1))
    if workload == "llama_rope":
        footprint *= tokens
    if footprint > 134217728 or k * tokens > 134217728:
        raise ValueError("footprint exceeds 134217728 elements")
    return {**params, "dtype": "fp32"}


def checked_result(
    data, case, target, params, samples, *, warmups=0, cpu=False, op=None
):
    timings = data.get("timings_ns")
    expected = (
        params["k"] * params["heads"] * params["tokens"]
        if "heads" in params
        else (
            params["rows"]
            if params["tokens"] == 1 and op == "matvec-q4"
            else params["k"] * params["tokens"]
        )
    )
    if (
        data.get("source_pin") != PIN
        or data.get("pass") is not True
        or data.get("bad") != 0
        or type(data.get("checked")) is not int
        or data["checked"] != expected
        or data.get("warmups") != warmups
        or data.get("graph_invocations") != warmups + samples
        or (cpu and data.get("backend") != "CPU")
        or (
            not cpu
            and not str(data.get("backend", "")).startswith(("ROCm", "CUDA", "HIP"))
        )
        or (op is not None and data.get("op") != op)
        or not isinstance(timings, list)
        or len(timings) != samples
        or any(type(t) is not int or t <= 0 for t in timings)
    ):
        raise ValueError(
            "native result failed correctness, provenance or sampling contract"
        )
    # dtype is wrapper metadata: the fixed-FP32 native protocol reports dimensions only.
    if any(data.get(key) != value for key, value in params.items() if key != "dtype"):
        raise ValueError("native parameters do not match requested parameters")
    return dict(
        schema=SCHEMA,
        case=case,
        target=target,
        provider="llama",
        parameters={**params, "dtype": "fp32"},
        timings_ns=timings,
    )


def verify_binary(binary, *, cpu, target):
    import hashlib

    binary = Path(binary).resolve()
    data = json.loads(binary.with_name("benchmark-build.json").read_text())
    if (
        data.get("source_pin") != PIN
        or data.get("backend") != ("cpu" if cpu else "hip")
        or (not cpu and target not in data.get("targets", []))
        or data.get("binary_sha256") != hashlib.sha256(binary.read_bytes()).hexdigest()
    ):
        raise ValueError("prepared binary provenance, backend, target or hash mismatch")
    return binary


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workload", choices=WORKLOADS, required=True)
    parser.add_argument("--params", required=True)
    parser.add_argument("--case", required=True)
    parser.add_argument("--target", choices=("gfx1100", "gfx1201"), required=True)
    parser.add_argument("--warmups", type=int, default=0)
    parser.add_argument("--samples", type=int, default=1)
    parser.add_argument("--output", default="-")
    parser.add_argument("--binary", default=os.environ.get("ROCJITSU_LLAMA_BINARY"))
    parser.add_argument(
        "--cpu", action="store_true", help="host-only test; never a GPU result"
    )
    args = parser.parse_args(argv)
    try:
        params = validate_parameters(args.workload, json.loads(args.params))
        if not 0 <= args.warmups <= 100 or not 1 <= args.samples <= 100:
            raise ValueError("warmups must be 0..100 and samples 1..100")
        if not args.binary:
            raise ValueError(
                "set ROCJITSU_LLAMA_BINARY or --binary to the prepared executable"
            )
        binary = verify_binary(args.binary, cpu=args.cpu, target=args.target)
        command = [
            str(binary),
            WORKLOADS[args.workload],
            "--warmups",
            str(args.warmups),
            "--samples",
            str(args.samples),
            "--target",
            args.target,
        ]
        if args.cpu:
            command.append("--cpu")
        for key, value in params.items():
            if key != "dtype":
                command += ["--" + key, str(value)]
        process = subprocess.run(command, stdout=subprocess.PIPE, text=True, check=True)
        data = json.loads(process.stdout)
        output = checked_result(
            data,
            args.case,
            args.target,
            params,
            args.samples,
            warmups=args.warmups,
            cpu=args.cpu,
            op=WORKLOADS[args.workload],
        )
        text = json.dumps(output, sort_keys=True, allow_nan=False) + "\n"
        if args.output == "-":
            print(text, end="")
        else:
            path = Path(args.output)
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text)
    except (ValueError, OSError, subprocess.CalledProcessError) as exc:
        parser.exit(1, str(exc) + "\n")


if __name__ == "__main__":
    main()
