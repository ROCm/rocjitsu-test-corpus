#!/usr/bin/env python3
"""Run llama corpus cases under a ROCjitsu build and classify outcomes.

Classification matches tests/test_suites/llama.py so results are
comparable with the recorded triage runs.

Usage: ./run_cases.py --variant plain --ids llama.gfx1201.backend_ops.MUL_MAT.67a24d655c21
       ./run_cases.py --variant plain --bug unresolved-gpu-address --out probe.json
"""

from __future__ import annotations

import argparse
import csv
import json
import signal
import subprocess
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

RESULTS = Path(__file__).resolve().parent
CORPUS = RESULTS.parent
WORKTREE = Path.home() / "rocjitsu_dev/wt/rocm-systems/llama-root-cause-trace"
ROCJITSU_SRC = WORKTREE / "emulation/rocjitsu"
BUILDS = {
    "plain": ROCJITSU_SRC / "build",
    "trace": ROCJITSU_SRC / "build-trace",
    "asan": ROCJITSU_SRC / "build-asan",
    "probe-cdna3": ROCJITSU_SRC / "build-probe-cdna3",
}
CSV_HEADER_PREFIX = '"backend_name"'


def load_failures() -> dict[str, dict]:
    groups = json.loads(
        (RESULTS / "root-cause-groups.json").read_text(encoding="utf-8")
    )["groups"]
    return {c["id"]: c for cases in groups.values() for c in cases}


def select(args, failures: dict[str, dict]) -> list[dict]:
    if args.ids:
        return [failures[i] for i in args.ids]
    merged = json.loads(
        (RESULTS / "merged-bugs.json").read_text(encoding="utf-8")
    )
    chosen = []
    for bug in merged["bugs"]:
        if args.bug and bug["id"] != args.bug:
            continue
        chosen.extend(bug["owned"])
    if args.target:
        chosen = [c for c in chosen if c["target"] == args.target]
    return chosen


def parse_csv_result(stdout: str) -> dict[str, str]:
    header = None
    rows = []
    for line in stdout.splitlines():
        quote = line.find('"')
        if quote < 0:
            continue
        record = line[quote:]
        if record.startswith(CSV_HEADER_PREFIX):
            header = next(csv.reader([record]))
            continue
        if header is None:
            continue
        try:
            values = next(csv.reader([record]))
        except csv.Error:
            continue
        if len(values) >= len(header):
            rows.append(dict(zip(header, values)))
    if not rows:
        return {}
    result = rows[-1]
    if "error_message" not in result or "supported" not in result:
        return {}
    return result


def classify(returncode: int, stdout: str, timed_out: bool) -> str:
    if timed_out:
        return "timeout"
    sig = None
    if returncode < 0:
        sig = -returncode
    elif returncode > 128:
        sig = returncode - 128
    if sig == signal.SIGSEGV:
        return "segfault"
    if sig is not None:
        return "crash"
    result = parse_csv_result(stdout)
    if not result:
        return "no-result" if returncode == 0 else "error"
    if result["error_message"] == "test failed":
        return "test-failure"
    if (
        result["error_message"] == "not supported"
        or result["supported"] == "0"
    ):
        return "not-supported"
    if returncode == 0 and result["supported"] == "1":
        if not result["error_message"]:
            return "pass"
    return "error"


def run_one(case: dict, variant: str, timeout: int) -> dict:
    config = RESULTS / "trace-configs" / f"{case['target']}.json"
    command = [
        str(BUILDS[variant] / "tools/rocjitsu/rocjitsu"),
        "--config",
        str(config),
        "--",
        "corpus/llama/build/test-backend-ops",
        "test",
        "-o",
        case["case"],
        "-b",
        "ROCm0",
        "-j",
        "1",
        "--output",
        "csv",
    ]
    timed_out = False
    try:
        done = subprocess.run(
            command,
            cwd=str(CORPUS),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            errors="replace",
            timeout=timeout,
            check=False,
        )
        returncode, stdout = done.returncode, done.stdout
    except subprocess.TimeoutExpired as exc:
        timed_out = True
        returncode, stdout = -9, exc.stdout or ""
        if isinstance(stdout, bytes):
            stdout = stdout.decode("utf-8", "replace")

    return {
        "id": case["id"],
        "target": case["target"],
        "operator": case["operator"],
        "baseline": case["outcome"],
        "outcome": classify(returncode, stdout, timed_out),
        "returncode": returncode,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--variant", default="plain", choices=sorted(BUILDS))
    parser.add_argument("--bug")
    parser.add_argument("--target")
    parser.add_argument("--ids", nargs="*")
    parser.add_argument("--jobs", type=int, default=8)
    parser.add_argument("--timeout", type=int, default=90)
    parser.add_argument("--out")
    args = parser.parse_args()

    failures = load_failures()
    cases = select(args, failures)
    if not cases:
        raise SystemExit("no cases selected")

    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        results = list(
            pool.map(lambda c: run_one(c, args.variant, args.timeout), cases)
        )

    results.sort(key=lambda r: r["id"])
    changed = [r for r in results if r["outcome"] != r["baseline"]]
    now_pass = [r for r in results if r["outcome"] == "pass"]

    summary = {
        "variant": args.variant,
        "total": len(results),
        "now_pass": len(now_pass),
        "changed": len(changed),
        "by_outcome": {},
        "results": results,
    }
    for r in results:
        summary["by_outcome"][r["outcome"]] = (
            summary["by_outcome"].get(r["outcome"], 0) + 1
        )

    if args.out:
        Path(args.out).write_text(
            json.dumps(summary, indent=2) + "\n", encoding="utf-8"
        )

    print(f"variant={args.variant} cases={len(results)}")
    print(f"  now pass : {len(now_pass)}")
    print(f"  changed  : {len(changed)}")
    for outcome, count in sorted(summary["by_outcome"].items()):
        print(f"  {outcome:14s} {count}")


if __name__ == "__main__":
    main()
