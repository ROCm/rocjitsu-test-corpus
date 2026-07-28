#!/usr/bin/env python3
"""Run semantic fixtures through an arbitrary wrapper and capture their results."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import shlex
import subprocess
import sys
from typing import Any

from result_protocol import (
    REPORT_SCHEMA,
    RESULT_PREFIX,
    ResultError,
    expected_records,
    load_manifest,
    parse_records,
    select_tests,
    sha256_file,
)


def load_metadata(path: Path | None) -> dict[str, Any]:
    if path is None:
        return {}
    try:
        metadata = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as error:
        raise ResultError(f"cannot read metadata {path}: {error}") from error
    if not isinstance(metadata, dict):
        raise ResultError(f"{path}: metadata must be a JSON object")
    return metadata


def run_test(
    *,
    test: str,
    binary: Path,
    wrapper: list[str],
    timeout: int,
    expected_keys: set[tuple[str, int]],
) -> dict[str, Any]:
    if not binary.is_file():
        raise ResultError(f"missing semantic test binary: {binary}")
    command = [*wrapper, str(binary.resolve())]
    label = f"semantic run: {test}"
    print(f"\n== {label} ==", flush=True)
    print("+ " + shlex.join(command), flush=True)
    try:
        process = subprocess.run(
            command,
            check=False,
            timeout=timeout,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            env={**os.environ, "CORPUS_RECORD_ONLY": "1"},
        )
    except subprocess.TimeoutExpired as error:
        if error.stdout:
            sys.stdout.write(
                error.stdout.decode(errors="replace")
                if isinstance(error.stdout, bytes)
                else error.stdout
            )
        if error.stderr:
            sys.stderr.write(
                error.stderr.decode(errors="replace")
                if isinstance(error.stderr, bytes)
                else error.stderr
            )
        raise ResultError(f"{label} exceeded {timeout}s") from error

    for line in process.stdout.splitlines():
        if not line.startswith(RESULT_PREFIX):
            print(line)
    sys.stderr.write(process.stderr)
    if process.returncode:
        raise ResultError(f"{label} exited with {process.returncode}")
    records = parse_records(
        label=label,
        stdout=process.stdout,
        test=test,
        expected_keys=expected_keys,
    )
    print(f"PASS: {label} emitted {len(records)} result record(s)")
    return {
        "test": test,
        "artifact": {
            "bytes": binary.stat().st_size,
            "sha256": sha256_file(binary),
        },
        "records": records,
    }


def capture(
    *,
    manifest_path: Path,
    binary_dir: Path,
    output: Path,
    label: str,
    metadata_path: Path | None,
    selectors: list[str],
    run_wrapper: str,
    timeout: int,
) -> dict[str, Any]:
    manifest_path = manifest_path.resolve()
    manifest = load_manifest(manifest_path)
    contracts = expected_records(manifest)
    tests = select_tests(manifest, selectors)
    wrapper = shlex.split(run_wrapper)
    rows = [
        run_test(
            test=test,
            binary=(binary_dir / test).resolve(),
            wrapper=wrapper,
            timeout=timeout,
            expected_keys=contracts[test],
        )
        for test in tests
    ]
    report = {
        "schema": REPORT_SCHEMA,
        "corpus": {
            "target": manifest["corpus"]["target"],
            "manifest_sha256": sha256_file(manifest_path),
        },
        "label": label,
        "metadata": load_metadata(metadata_path),
        "tests": rows,
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print(f"\nPASS: wrote semantic run to {output}")
    return report


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--binary-dir", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--label", default="")
    parser.add_argument(
        "--metadata",
        type=Path,
        help="optional JSON object describing the external run configuration",
    )
    parser.add_argument(
        "--test",
        action="append",
        default=[],
        help="test name or semantic case ID to run; repeatable",
    )
    parser.add_argument(
        "--run-wrapper",
        default="",
        help="shell-style command prefix appended before each test binary",
    )
    parser.add_argument("--timeout", type=int, default=120)
    args = parser.parse_args()

    try:
        capture(
            manifest_path=args.manifest,
            binary_dir=args.binary_dir,
            output=args.output,
            label=args.label,
            metadata_path=args.metadata,
            selectors=args.test,
            run_wrapper=args.run_wrapper,
            timeout=args.timeout,
        )
    except ResultError as error:
        print(f"FAIL: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
