"""Run manifest-selected, prebuilt direct-KFD binaries, without CTest.

Case intent and programming references are in corpus/runtime-torture source headers.
Subprocess isolation follows this repository's Vulkan adapter; process-group API:
https://docs.python.org/3/library/subprocess.html#subprocess.Popen
"""

from __future__ import annotations

import json
import math
import os
from pathlib import Path
import re
import shlex
import shutil
import signal
import subprocess
import time
import tomllib

import pytest

from support.define_contracts import BuildResult, CorpusCase

ROOT = Path(__file__).resolve().parents[2] / "corpus" / "runtime-torture"
NAME = re.compile(r"[A-Za-z0-9][A-Za-z0-9_.-]*\Z")


class ExpectedFailure(RuntimeError):
    """Only a manifest-matching failure may satisfy a strict pytest xfail."""


def load_manifest(path: Path, target: str | None = None) -> list[dict]:
    with path.open("rb") as stream:
        data = tomllib.load(stream)
    if set(data) - {"defaults", "case"}:
        raise ValueError(f"Unknown manifest fields in {path}")
    defaults = data.get("defaults", {})
    if not isinstance(defaults, dict) or set(defaults) - {"timeout_seconds"}:
        raise ValueError("defaults only supports timeout_seconds")
    rows = data.get("case")
    if not isinstance(rows, list) or not rows:
        raise ValueError("Manifest must contain at least one [[case]]")
    result, ids = [], set()
    for row in rows:
        allowed = {
            "id",
            "binary",
            "args",
            "timeout_seconds",
            "status",
            "reason",
            "expected_exit_code",
            "expected_output",
            "requires",
        }
        if not isinstance(row, dict) or set(row) - allowed:
            raise ValueError(f"Unknown case fields: {row}")
        case = {"args": [], "status": "", **defaults, **row}
        if target is not None and isinstance(case.get("binary"), str):
            case["binary"] = case["binary"].replace("{target}", target)
        required = case.get("requires", [])
        if not isinstance(required, list) or any(not isinstance(v, str) for v in required):
            raise ValueError("requires must be an array of feature names")
        if set(required) - {"aql_metadata", "sdma_signal64", "wave32_scratch", "wgp_placement",
                            "pm4", "pm4_wait64", "pm4_release_mem", "aql_pm4_ib", "pm4_wait_offload"}:
            raise ValueError("Unknown required feature")
        for key in ("id", "binary"):
            if not isinstance(case.get(key), str) or not NAME.fullmatch(case[key]):
                raise ValueError(f"Case {key} must be a simple nonempty name: {row}")
        if case["id"] in ids:
            raise ValueError(f"Duplicate case id: {case['id']}")
        ids.add(case["id"])
        if not isinstance(case["args"], list) or any(
            not isinstance(arg, str) or "\0" in arg for arg in case["args"]
        ):
            raise ValueError(f"{case['id']}: args must be a string array without NULs")
        timeout = case.setdefault("timeout_seconds", 60)
        if (
            type(timeout) not in (int, float)
            or not math.isfinite(timeout)
            or timeout <= 0
        ):
            raise ValueError(
                f"{case['id']}: timeout_seconds must be finite and positive"
            )
        if case["status"] not in ("", "SKIP", "XFAIL"):
            raise ValueError(f"{case['id']}: status must be SKIP or XFAIL, or omitted")
        if case["status"] and (
            not isinstance(case.get("reason"), str) or not case["reason"].strip()
        ):
            raise ValueError(f"{case['id']}: status requires a reason")
        if case["status"] == "XFAIL":
            code = case.get("expected_exit_code")
            if type(code) is not int or code in (0, 77, 124) or not -64 <= code <= 255:
                raise ValueError(
                    f"{case['id']}: XFAIL needs a nonzero, non-skip, non-watchdog exit code"
                )
            if (
                not isinstance(case.get("expected_output"), str)
                or not case["expected_output"].strip()
            ):
                raise ValueError(f"{case['id']}: XFAIL needs expected_output substring")
        elif "expected_exit_code" in case or "expected_output" in case:
            raise ValueError(f"{case['id']}: expected failure fields require XFAIL")
        result.append(case)
    return result


def validate_inventory(
    defaults: list[dict], selected: list[dict], binaries: set[str]
) -> None:
    missing = binaries - {case["binary"] for case in defaults}
    unknown = {case["binary"] for case in selected} - binaries
    if missing or unknown:
        raise ValueError(
            f"Manifest coverage error: missing default entries={sorted(missing)}; "
            f"unknown selected binaries={sorted(unknown)}. "
            "Reconfigure and rebuild the complete suite after adding tests."
        )


def discover(
    target,
    *,
    suite_name: str,
    binary_dir: str | None,
    cases_config: str | None,
    run_wrapper: str | None = None,
) -> list[CorpusCase]:
    if suite_name not in ("aql", "pm4"):
        raise ValueError("Expected aql or pm4 suite")
    if not binary_dir:
        raise ValueError(
            "runtime-torture requires --binary-dir pointing to a configured build"
        )
    if run_wrapper is not None:
        wrapper = shlex.split(run_wrapper)
        if not wrapper or shutil.which(wrapper[0]) is None:
            raise ValueError(f"Run wrapper executable is unavailable: {run_wrapper!r}")
    directory = Path(binary_dir).expanduser().resolve()
    inventory = directory / f"{suite_name}-{target.target}-targets.txt"
    names = inventory.read_text().splitlines()
    if (
        not names
        or len(names) != len(set(names))
        or any(not NAME.fullmatch(n) for n in names)
    ):
        raise ValueError(f"Invalid CMake executable inventory: {inventory}")
    defaults_path = ROOT / suite_name / "cases.toml"
    feature_file = directory / f"runtime-{target.target}-features.txt"
    features = set(feature_file.read_text().splitlines())
    defaults = load_manifest(defaults_path, target.target)
    path = Path(cases_config).expanduser().resolve() if cases_config else defaults_path
    rows = load_manifest(path, target.target) if cases_config else defaults
    known = set(names) | {row["binary"] for row in defaults if row.get("requires")}
    validate_inventory(defaults, rows, known)
    runnable = []
    for row in rows:
        missing = set(row.get("requires", [])) - features
        if missing:
            row.update(
                status="SKIP",
                reason=f"Platform lacks required features: {', '.join(sorted(missing))}",
            )
        else:
            runnable.append(row)
    validate_inventory(defaults, runnable, set(names))
    # Check the complete build, including helper binaries used by selected cases.
    for name in names:
        binary = directory / name
        if not binary.is_file() or not os.access(binary, os.X_OK):
            raise ValueError(f"Missing executable: {binary}; build the suite first")
    return [
        CorpusCase(
            id=f"{suite_name}.{target.target}.{row['id']}",
            suite=suite_name,
            target=target.target,
            collection=None,
            backend=None,
            path=path,
            build={"system": "prebuilt", "binary": str(directory / row["binary"])},
            run=row,
            metadata={},
            selector_names=(row["id"], row["binary"]),
        )
        for row in rows
    ]


def build(case, _context, _state) -> BuildResult:
    binary = Path(case.build["binary"])
    return BuildResult(binary.parent, binary, {})


def classify(row: dict, returncode: int, timed_out: bool, output: str) -> str:
    if timed_out or returncode == 124:
        return "TIMEOUT"
    if returncode == 77:
        return "SKIP"
    if returncode == 0:
        return "XPASS" if row["status"] == "XFAIL" else "PASS"
    if (
        row["status"] == "XFAIL"
        and returncode == row["expected_exit_code"]
        and row["expected_output"] in output
    ):
        return "XFAIL"
    return "FAIL"


def run(case, build_result, context) -> None:
    row = case.run
    if row["status"] == "SKIP":
        pytest.skip(row["reason"])
    if context.skip_all_runs:
        pytest.skip("--skip-all-runs: prebuilt binary validated; not executed")
    directory = context.artifact_directory / case.suite / case.target
    directory.mkdir(parents=True, exist_ok=True)
    log_path = directory / f"{row['id']}.log"
    command = [
        *shlex.split(context.run_wrapper or ""),
        str(build_result.executable_path),
        *row["args"],
    ]
    started = time.monotonic()
    timed_out = False
    with log_path.open("w", encoding="utf-8") as log:
        log.write(shlex.join(command) + "\n")
        log.flush()
        process = subprocess.Popen(
            command, stdout=log, stderr=subprocess.STDOUT, start_new_session=True
        )
        try:
            process.wait(timeout=row["timeout_seconds"])
        except subprocess.TimeoutExpired:
            timed_out = True
        finally:
            # Also remove children surviving their parent (multiprocess scenarios).
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            try:
                process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                # A kernel-blocked task may not be reapable until host recovery.
                timed_out = True
    output = log_path.read_text(encoding="utf-8", errors="replace")
    status = classify(row, process.returncode, timed_out, output.partition("\n")[2])
    record = {
        "case": case.id,
        "command": command,
        "status": status,
        "returncode": process.returncode,
        "timeout_seconds": row["timeout_seconds"],
        "seconds": time.monotonic() - started,
    }
    log_path.with_suffix(".json").write_text(json.dumps(record, indent=2) + "\n")
    detail = (
        f"{status}: {shlex.join(command)}\nexit={process.returncode} "
        f"timeout={row['timeout_seconds']}s\nlog={log_path}\n{output}"
    )
    if status == "SKIP":
        pytest.skip(f"Target unavailable (exit 77); log={log_path}")
    if status == "XFAIL":
        raise ExpectedFailure(f"{row['reason']}\n{detail}")
    if status in ("FAIL", "TIMEOUT"):
        pytest.fail(detail, pytrace=False)
    # Returning on XPASS lets pytest's strict xfail mark report it as a failure.
