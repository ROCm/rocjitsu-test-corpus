#!/usr/bin/env python3
"""Validate the semantic case inventory and its emitted source instructions."""

from __future__ import annotations

import argparse
from collections import Counter
from pathlib import Path
import re
import sys
from typing import Any

try:
    import tomllib
except ModuleNotFoundError:
    import tomli as tomllib


def validate_manifest(
    manifest: dict[str, Any],
    manifest_path: Path,
) -> tuple[list[dict[str, Any]], bool]:
    failed = False
    corpus = manifest.get("corpus")
    if not isinstance(corpus, dict) or corpus.get("schema") != 1:
        print("MISS corpus: expected schema 1")
        failed = True
    if not isinstance(corpus, dict) or corpus.get("target") != "gfx1250":
        print("MISS corpus: expected target gfx1250")
        failed = True

    cases = manifest.get("case")
    if not isinstance(cases, list) or not cases:
        print("MISS cases: expected a non-empty [[case]] inventory")
        return [], True

    case_ids = [case.get("id") for case in cases if isinstance(case, dict)]
    duplicate_ids = sorted(
        case_id
        for case_id, count in Counter(case_ids).items()
        if case_id is not None and count != 1
    )
    if duplicate_ids:
        print(f"MISS cases: duplicate IDs: {', '.join(duplicate_ids)}")
        failed = True

    valid_cases = []
    for case in cases:
        valid = True
        if not isinstance(case, dict):
            print("MISS cases: every entry must be a table")
            failed = True
            continue
        case_id = case.get("id")
        test = case.get("test")
        patterns = case.get("source_patterns")
        if not isinstance(case_id, str) or not case_id:
            print("MISS cases: invalid case ID")
            failed = True
            valid = False
        if not isinstance(test, str) or not test:
            print(f"MISS {case_id}: invalid test name")
            failed = True
            valid = False
        else:
            source = manifest_path.parent / "test_cases" / f"{test}.hip"
            if not source.is_file():
                print(f"MISS {case_id}: source does not exist: {source}")
                failed = True
                valid = False
        if not isinstance(patterns, list) or not patterns:
            print(f"MISS {case_id}: source_patterns must be a non-empty list")
            failed = True
            valid = False
        else:
            for pattern in patterns:
                if not isinstance(pattern, str) or not pattern:
                    print(f"MISS {case_id}: source patterns must be non-empty strings")
                    failed = True
                    valid = False
                    continue
                try:
                    re.compile(pattern)
                except re.error as error:
                    print(
                        f"MISS {case_id}: invalid source pattern {pattern!r}: {error}"
                    )
                    failed = True
                    valid = False
        if valid:
            valid_cases.append(case)

    failed |= validate_result_contracts(manifest, manifest_path, valid_cases)
    return valid_cases, failed


def validate_result_contracts(
    manifest: dict[str, Any],
    manifest_path: Path,
    cases: list[dict[str, Any]],
) -> bool:
    failed = False
    results = manifest.get("results")
    if not isinstance(results, dict):
        print("MISS results: expected result contracts")
        return True

    case_tests = {case.get("test") for case in cases if isinstance(case, dict)}
    source_tests = {
        path.stem for path in (manifest_path.parent / "test_cases").glob("*.hip")
    }
    result_tests = set(results)
    for test in sorted(source_tests - case_tests):
        print(f"MISS cases: test_cases/{test}.hip has no semantic case")
        failed = True
    for test in sorted(case_tests - source_tests):
        print(f"MISS cases: missing test_cases/{test}.hip")
        failed = True
    for test in sorted(case_tests - result_tests):
        print(f"MISS results: no record contract for {test}")
        failed = True
    for test in sorted(result_tests - case_tests):
        print(f"MISS results: unknown test {test}")
        failed = True

    for test, contract in results.items():
        records = contract.get("records") if isinstance(contract, dict) else None
        if not isinstance(records, list) or not records:
            print(f"MISS results.{test}: records must be a non-empty list")
            failed = True
            continue
        names = []
        for record in records:
            name = record.get("case") if isinstance(record, dict) else None
            variants = record.get("variants") if isinstance(record, dict) else None
            if not isinstance(name, str) or not name:
                print(f"MISS results.{test}: invalid case name")
                failed = True
            if not isinstance(variants, int) or variants < 1:
                print(f"MISS results.{test}: {name!r} variants must be positive")
                failed = True
            names.append(name)
        duplicates = sorted(
            name for name, count in Counter(names).items() if count != 1
        )
        if duplicates:
            print(
                f"MISS results.{test}: duplicate case names: "
                f"{', '.join(duplicates)}"
            )
            failed = True
    return failed


def check_source_assembly(
    cases: list[dict[str, Any]],
    assembly_dir: Path,
) -> bool:
    failed = False
    assembly_cache: dict[str, str] = {}
    for case in cases:
        case_id = case["id"]
        test = case["test"]
        assembly_file = assembly_dir / f"{test}.s"
        if not assembly_file.is_file():
            print(f"MISS {case_id}: {assembly_file} does not exist")
            failed = True
            continue
        if test not in assembly_cache:
            assembly_cache[test] = assembly_file.read_text(errors="replace")
        assembly = assembly_cache[test]
        missing = [
            pattern
            for pattern in case["source_patterns"]
            if re.search(pattern, assembly, flags=re.MULTILINE) is None
        ]
        if missing:
            print(f"MISS {case_id} ({assembly_file.name})")
            for pattern in missing:
                print(f"  /{pattern}/")
            failed = True
        else:
            print(
                f"PASS {case_id}: " f"{len(case['source_patterns'])} source pattern(s)"
            )
    return failed


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--assembly-dir", type=Path, required=True)
    args = parser.parse_args()

    with args.manifest.open("rb") as stream:
        manifest = tomllib.load(stream)
    cases, failed = validate_manifest(manifest, args.manifest.resolve())
    failed |= check_source_assembly(cases, args.assembly_dir)
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
