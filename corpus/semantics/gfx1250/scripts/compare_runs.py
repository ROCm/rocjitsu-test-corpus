#!/usr/bin/env python3
"""Compare two semantic run reports byte-for-byte, independent of their launchers."""

from __future__ import annotations

import argparse
from pathlib import Path
import sys
from typing import Any

from result_protocol import ResultError, compare_records, load_report


def indexed_tests(report: dict[str, Any], path: Path) -> dict[str, dict[str, Any]]:
    indexed: dict[str, dict[str, Any]] = {}
    for row in report["tests"]:
        if not isinstance(row, dict) or not isinstance(row.get("test"), str):
            raise ResultError(f"{path}: invalid test entry")
        test = row["test"]
        if test in indexed:
            raise ResultError(f"{path}: duplicate test entry {test}")
        if not isinstance(row.get("records"), list):
            raise ResultError(f"{path}: {test} contains no result records")
        indexed[test] = row
    return indexed


def compare_reports(
    reference_path: Path,
    candidate_path: Path,
) -> None:
    reference = load_report(reference_path)
    candidate = load_report(candidate_path)
    if reference.get("corpus") != candidate.get("corpus"):
        raise ResultError(
            "run reports use different corpus targets or manifest revisions"
        )

    reference_tests = indexed_tests(reference, reference_path)
    candidate_tests = indexed_tests(candidate, candidate_path)
    if reference_tests.keys() != candidate_tests.keys():
        missing = sorted(reference_tests.keys() - candidate_tests.keys())
        extra = sorted(candidate_tests.keys() - reference_tests.keys())
        raise ResultError(
            f"run reports select different tests: missing={missing!r}, extra={extra!r}"
        )

    for test in reference_tests:
        reference_records = reference_tests[test]["records"]
        candidate_records = candidate_tests[test]["records"]
        compare_records(
            test=test,
            reference_records=reference_records,
            candidate_records=candidate_records,
        )
        print(f"PASS: {test}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("reference", type=Path, help="reference run report")
    parser.add_argument("candidate", type=Path, help="candidate run report")
    args = parser.parse_args()
    try:
        compare_reports(args.reference, args.candidate)
    except ResultError as error:
        print(f"FAIL: {error}", file=sys.stderr)
        return 1
    print("\nPASS: semantic runs match")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
