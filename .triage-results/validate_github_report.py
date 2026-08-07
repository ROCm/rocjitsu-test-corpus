#!/usr/bin/env python3
"""Check the generated GitHub report for coverage, structure, and links."""

from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path

import render_github_report as renderer

SECTION_PATTERN = re.compile(r"^### \d+\. (.+)$", re.MULTILINE)
LINK_PATTERN = re.compile(r"\]\((https://github\.com/[^)]+)\)")
BLOB_PATTERN = re.compile(
    r"https://github\.com/ROCm/(?P<repo>[^/]+)/blob/(?P<commit>[0-9a-f]{40})/"
    r"(?P<path>[^#)]+)(?:#L(?P<start>\d+)-L(?P<end>\d+)|#L(?P<line>\d+))?"
)
REQUIRED_PARTS = (
    "**Affected tests**",
    "**Likely root cause**",
    "*Confidence:",
    "**Evidence**",
    "**Reproducer**",
)
REPO_CHECKOUTS = {
    "rocm-systems": Path.home() / "rocjitsu_dev" / "rocm-systems",
    "rocjitsu-test-corpus": Path.home()
    / "rocjitsu_dev"
    / "rocjitsu-test-corpus",
}


def fail(failures: list[str], message: str) -> None:
    failures.append(message)


def check_case_coverage(
    report: str, payload: dict, failures: list[str]
) -> None:
    expected = {
        case["id"] for cases in payload["groups"].values() for case in cases
    }
    for case_id in sorted(expected):
        if report.count(f"`{case_id}`") < 1:
            fail(failures, f"case {case_id} is missing from the report")
    print(f"checked {len(expected)} persistent case IDs")

    listed = set(re.findall(r"`(llama\.gfx[0-9a-z]+\.[^`]+)`", report))
    extra = sorted(listed - expected)
    if extra:
        fail(failures, f"report lists unknown case IDs: {extra}")


def check_sections(report: str, failures: list[str]) -> None:
    blocks = report.split("### ")[1:]
    if len(blocks) != len(renderer.GROUPS):
        fail(
            failures,
            f"expected {len(renderer.GROUPS)} sections, found {len(blocks)}",
        )
    for block in blocks:
        title = block.splitlines()[0]
        for part in REQUIRED_PARTS:
            if part not in block:
                fail(failures, f"section '{title}' is missing {part}")
        if "$ROCJITSU" not in block:
            fail(failures, f"section '{title}' has no reproducer command")
    print(f"checked {len(blocks)} bug sections")


def check_commands(report: str, payload: dict, failures: list[str]) -> None:
    known_cases = {
        case["case"] for cases in payload["groups"].values() for case in cases
    }
    commands = re.findall(
        r'"\$ROCJITSU" --config "\$ROCJITSU_CONFIGS/([^"]+)" -- \\\n'
        r'  "\$CORPUS/corpus/llama/build/test-backend-ops" test \\\n'
        r"  -o '([^']+)' \\\n"
        r"  -b ROCm0 -j 1 --output csv",
        report,
    )
    if len(commands) != len(renderer.GROUPS):
        fail(
            failures,
            f"expected {len(renderer.GROUPS)} reproducers, "
            f"found {len(commands)}",
        )
    config_root = (
        Path.home()
        / "rocjitsu_dev"
        / "rocm-systems"
        / "emulation"
        / "rocjitsu"
        / "configs"
    )
    for config, case in commands:
        if not (config_root / config).is_file():
            fail(failures, f"config {config} does not exist")
        if case not in known_cases:
            fail(failures, f"reproducer case is not a corpus case: {case}")
    print(f"checked {len(commands)} reproducer commands")


def check_links(report: str, failures: list[str]) -> None:
    links = sorted(set(LINK_PATTERN.findall(report)))
    for link in links:
        match = BLOB_PATTERN.fullmatch(link)
        if not match:
            continue
        checkout = REPO_CHECKOUTS[match.group("repo")]
        blob = f"{match.group('commit')}:{match.group('path')}"
        result = subprocess.run(
            ["git", "-C", str(checkout), "show", blob],
            capture_output=True,
            text=True,
            check=False,
        )
        if result.returncode != 0:
            fail(failures, f"link target missing in checkout: {link}")
            continue
        line_count = len(result.stdout.splitlines())
        last = match.group("end") or match.group("line")
        if last and int(last) > line_count:
            fail(
                failures,
                f"link {link} points past end of file ({line_count} lines)",
            )
    print(f"checked {len(links)} GitHub links")


def check_issue_size(report: str, failures: list[str]) -> None:
    """GitHub rejects issue and comment bodies over 65,536 characters."""
    limit = 65536
    size = len(report)
    if size > limit:
        fail(failures, f"report is {size} characters, over the {limit} limit")
    print(f"checked issue size: {size} of {limit} characters")


def check_determinism(report_path: Path, failures: list[str]) -> None:
    first = report_path.read_bytes()
    subprocess.run(
        [sys.executable, str(report_path.parent / "render_github_report.py")],
        capture_output=True,
        check=True,
    )
    if report_path.read_bytes() != first:
        fail(failures, "regeneration produced different output")
    print("checked determinism across two runs")


def main() -> None:
    result_root = Path(__file__).resolve().parent
    payload = renderer.load_payload(result_root)
    report_path = result_root / "github-report.md"
    report = report_path.read_text(encoding="utf-8")

    failures: list[str] = []
    check_case_coverage(report, payload, failures)
    check_sections(report, failures)
    check_commands(report, payload, failures)
    check_links(report, failures)
    check_issue_size(report, failures)
    check_determinism(report_path, failures)

    if failures:
        for failure in failures:
            print(f"FAIL: {failure}")
        raise SystemExit(1)
    print("report validation passed")


if __name__ == "__main__":
    main()
