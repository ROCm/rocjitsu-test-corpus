#!/usr/bin/env python3
"""Check bug-report.md against the recorded triage evidence.

Verifies that every cited test ID and case string is real, that the
per-issue counts sum to the persistent failure total, that every source
path referenced exists in the pinned worktree, and that each issue
carries a recognised confidence level.

Usage: ./validate_bug_report.py
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

RESULTS = Path(__file__).resolve().parent
WORKTREE = Path.home() / "rocjitsu_dev/wt/rocm-systems/llama-root-cause-trace"
CONFIDENCES = {
    "Confirmed by experiment",
    "Confirmed at source",
    "Inferred from runtime evidence",
    "Speculative",
}
TEST_ID = re.compile(
    r"`(llama\.gfx[0-9a-z]+\.backend_ops\.[A-Z0-9_]+\.[0-9a-f]{12})`"
)
SOURCE_PATH = re.compile(
    r"`(emulation/rocjitsu/[^`]+?)`(?: lines (\d+)-(\d+))?"
)
COUNT_ROW = re.compile(r"^\| \d+ \| .+? \| (\d+) \|", re.MULTILINE)


def main() -> int:
    report = (RESULTS / "bug-report.md").read_text(encoding="utf-8")
    merged = json.loads(
        (RESULTS / "merged-bugs.json").read_text(encoding="utf-8")
    )
    known = {c["id"]: c for b in merged["bugs"] for c in b["owned"]}
    failures: list[str] = []

    cited = set(TEST_ID.findall(report))
    for test_id in sorted(cited):
        if test_id not in known:
            failures.append(f"unknown test id cited: {test_id}")
    if not cited:
        failures.append("report cites no test ids")

    for case in re.findall(r"^  - `(.+)`$", report, re.MULTILINE):
        if case not in {c["case"] for c in known.values()}:
            failures.append(f"unknown case string cited: {case}")

    counts = [int(m) for m in COUNT_ROW.findall(report)]
    if sum(counts) != merged["persistent_failures"]:
        failures.append(
            f"summary counts sum to {sum(counts)}, expected "
            f"{merged['persistent_failures']}"
        )
    if len(counts) != merged["bug_count"]:
        failures.append(
            f"summary lists {len(counts)} issues, expected "
            f"{merged['bug_count']}"
        )

    for path, start, end in SOURCE_PATH.findall(report):
        target = WORKTREE / path
        if not target.exists():
            failures.append(f"source path does not exist: {path}")
            continue
        if start and target.is_file():
            line_count = len(target.read_text(errors="replace").splitlines())
            if int(end) > line_count:
                failures.append(
                    f"{path} cites line {end} but has {line_count} lines"
                )

    stated = re.findall(r"^\*\*Confidence\*\*: (.+)$", report, re.MULTILINE)
    for value in stated:
        if value.strip() not in CONFIDENCES:
            failures.append(f"unrecognised confidence: {value!r}")
    if len(stated) != merged["bug_count"]:
        failures.append(
            f"{len(stated)} confidence lines, expected {merged['bug_count']}"
        )

    if failures:
        for failure in failures:
            print(f"FAIL {failure}")
        return 1

    print(
        f"ok: {len(cited)} test ids, {len(counts)} issues summing to "
        f"{sum(counts)}, {len(set(p for p, _, _ in SOURCE_PATH.findall(report)))}"
        " source paths verified"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
