# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Run a prepared TensileLite candidate through the native single-launch adapter."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

from prepare import CANDIDATES, REVISION


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workload", choices=["tensile_candidate"], required=True)
    parser.add_argument("--params", type=json.loads, required=True)
    parser.add_argument("--case", required=True)
    parser.add_argument("--target", required=True)
    parser.add_argument("--warmups", type=int, required=True)
    parser.add_argument("--samples", type=int, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    params = args.params
    variant = params["variant"]
    if variant not in CANDIDATES or args.target != CANDIDATES[variant][0]:
        raise ValueError("unsupported TensileLite variant/target")
    if args.warmups < 0 or args.samples <= 0:
        raise ValueError("invalid sampling counts")
    expected_dtype = "mxfp8" if variant == "mxfp8_subtile" else "mxfp4" if variant == "mxfp4_streamk" else "bf16"
    if params.get("dtype") != expected_dtype:
        raise ValueError("dtype does not match TensileLite variant")
    shape = [params[key] for key in ("m", "n", "k")]
    if any(type(size) is not int or size <= 0 for size in shape):
        raise ValueError("dimensions must be positive integers")
    root = Path(os.environ["TENSILE_CANDIDATE_ARTIFACTS"]) / variant
    provenance = json.loads((root / "artifacts.json").read_text())
    if (provenance["source_revision"] != REVISION or provenance["target"] != args.target
            or provenance["shape"] != shape or provenance["variant"] != variant):
        raise ValueError("TensileLite artifact provenance mismatch")
    actual_files = {p.name for p in root.iterdir() if p.suffix in (".co", ".hsaco")} | {"TensileLibrary.yaml"}
    if actual_files != set(provenance["files"]):
        raise ValueError("TensileLite artifact inventory mismatch")
    for filename, expected in provenance["files"].items():
        path = root / filename
        if not path.resolve().is_relative_to(root.resolve()):
            raise ValueError("artifact path escapes candidate directory")
        if hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            raise ValueError(f"TensileLite artifact hash mismatch: {filename}")
    with tempfile.TemporaryDirectory(prefix="tensile-samples-") as tmp:
        samples_path = Path(tmp) / "samples.json"
        command = [os.environ["TENSILE_CANDIDATE_RUNNER"], str(root), variant,
                   args.target, *map(str, shape), str(args.warmups), str(args.samples),
                   str(samples_path)]
        subprocess.run(command, check=True)
        result = json.loads(samples_path.read_text())
        timings = result["timings_ns"]
        if len(timings) != args.samples or any(type(t) is not int or t <= 0 for t in timings):
            raise ValueError("invalid native timing samples")
        if result["invocations"] != 1 or result["correctness"] != "passed":
            raise ValueError("candidate is not a validated single kernel launch")
    parameters = dict(params, source_revision=REVISION, kernel_name=result["kernel_name"],
                      solution_index=result["solution_index"], invocation_count=1,
                      input_pattern=result["input_pattern"], correctness="full_output_reference",
                      artifact_sha256=provenance["files"],
                      upstream_config=provenance["upstream_file"],
                      upstream_config_sha256=provenance["upstream_sha256"],
                      configuration_sha256=provenance["config_sha256"],
                      warmups=args.warmups,
                      timing="one_launch_and_device_synchronize; resets_and_validation_excluded")
    payload = {"schema": "rocjitsu.benchmark.workload.v1", "case": args.case,
               "target": args.target, "provider": "tensile", "parameters": parameters,
               "timings_ns": timings}
    args.output.write_text(json.dumps(payload) + "\n")


if __name__ == "__main__":
    main()
