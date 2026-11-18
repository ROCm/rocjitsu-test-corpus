# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Runner-protocol entry point for separately pinned full Tensile artifacts."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

from prepare import REVISION, validate_parameters, validate_artifacts


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workload", choices=["full_tensile"], required=True)
    parser.add_argument("--params", type=json.loads, required=True)
    parser.add_argument("--case", required=True)
    parser.add_argument("--target", required=True)
    parser.add_argument("--warmups", type=int, required=True)
    parser.add_argument("--samples", type=int, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    params = args.params
    variant = validate_parameters(params, args.target)
    if args.warmups < 0 or args.samples <= 0:
        raise ValueError("invalid sampling counts")
    root = Path(os.environ["FULL_TENSILE_ARTIFACTS"]).resolve() / args.target / variant
    provenance = validate_artifacts(root, params, args.target)
    runner = Path(os.environ["FULL_TENSILE_RUNNER"]).resolve(strict=True)
    m = params["i"] if variant == "tensor" else params["m"]
    n = params["j"] if variant == "tensor" else params["n"]
    dimensions = [
        m,
        n,
        params["k"],
        params.get("l", 1),
        params.get("batch", 1),
        params["beta"],
    ]
    with tempfile.TemporaryDirectory(prefix="full-tensile-samples-") as temp:
        native_output = Path(temp) / "samples.json"
        command = [
            str(runner),
            str(root),
            variant,
            args.target,
            *map(str, dimensions),
            str(args.warmups),
            str(args.samples),
            str(native_output),
        ]
        subprocess.run(command, check=True)
        result = json.loads(native_output.read_text())
    timings = result.get("timings_ns")
    invocations = 2 if variant == "splitk" else 1
    if (
        not isinstance(timings, list)
        or len(timings) != args.samples
        or any(type(value) is not int or value <= 0 for value in timings)
    ):
        raise ValueError("invalid native timing samples")
    if (
        result.get("correctness") != "passed"
        or type(result.get("invocations")) is not int
        or result["invocations"] != invocations
        or result.get("input_pattern") != "signed_integer_periodic_v1"
        or not isinstance(result.get("kernel_name"), str)
        or not result["kernel_name"]
        or type(result.get("solution_index")) is not int
    ):
        raise ValueError(
            "native result is not an independently validated whole solution"
        )
    parameters = dict(
        params,
        source_revision=REVISION,
        kernel_name=result["kernel_name"],
        solution_index=result["solution_index"],
        invocation_count=invocations,
        input_pattern=result["input_pattern"],
        correctness="full_output_exact_integer_reference",
        artifact_sha256=provenance["files"],
        upstream_config=provenance["upstream_file"],
        upstream_config_sha256=provenance["upstream_sha256"],
        native_runner_sha256=hashlib.sha256(runner.read_bytes()).hexdigest(),
        warmups=args.warmups,
        timing="whole_solution_enqueue_and_device_synchronize; reset_load_validation_excluded",
    )
    payload = dict(
        schema="rocjitsu.benchmark.workload.v1",
        case=args.case,
        target=args.target,
        provider="full_tensile",
        parameters=parameters,
        timings_ns=timings,
    )
    args.output.write_text(json.dumps(payload) + "\n")


if __name__ == "__main__":
    main()
