"""llama.cpp `test-backend-ops` coverage for RocJITsu backend regressions.

The suite builds the vendored `test-backend-ops` harness once per target and
then runs one subprocess per selected `OP(params)` case so that a crash or hang
in one operator cannot hide the results of the others.
"""

from __future__ import annotations

import csv
import hashlib
import json
import os
import re
import shlex
import shutil
import signal
import subprocess
import time
from pathlib import Path

from support.define_contracts import (
    BuildResult,
    BuildState,
    CorpusCase,
    RunContext,
    TargetSpec,
)
from support.prepare_inputs import load_json


REPO_ROOT = Path(__file__).resolve().parents[2]
CORPUS_ROOT = REPO_ROOT / "corpus" / "llama"
INVENTORY_PATH = CORPUS_ROOT / "selected_llama_backend_ops_tests.json"
BUILD_SCRIPT = CORPUS_ROOT / "build.sh"
EXECUTABLE_NAME = "test-backend-ops"
BACKEND = "ROCm0"
CASE_PATTERN = re.compile(r"[A-Z][A-Z0-9_]*\(.*\)")
CSV_HEADER_PREFIX = '"backend_name"'


def default_config_files() -> tuple[Path, ...]:
    return (INVENTORY_PATH,)


def load_target_configs(
    config_files: tuple[str, ...] | list[str],
) -> list[tuple[Path, str, tuple[str, ...], tuple[str, ...]]]:
    return _load_inventories(config_files)


def discover(
    target: TargetSpec,
    inventories: list[tuple[Path, str, tuple[str, ...], tuple[str, ...]]],
) -> list[CorpusCase]:
    discovered: list[CorpusCase] = []
    for inventory_path, collection, supported_targets, cases in inventories:
        if target.target not in supported_targets:
            continue
        for case_name in cases:
            operator = case_name.split("(", 1)[0]
            digest = hashlib.sha256(case_name.encode("utf-8")).hexdigest()
            short_digest = digest[:12]
            discovered.append(
                CorpusCase(
                    id=(
                        f"llama.{target.target}.{collection}.{operator}."
                        f"{short_digest}"
                    ),
                    suite="llama",
                    target=target.target,
                    collection=collection,
                    backend=BACKEND,
                    path=inventory_path,
                    build={
                        "system": "cmake",
                        "config_name": target.target,
                        "target": EXECUTABLE_NAME,
                    },
                    run={"kind": "backend_ops_case"},
                    metadata={
                        "name": case_name,
                        "operator": operator,
                        "sha256": digest,
                        "artifact_name": f"{operator}.{short_digest}",
                    },
                    selector_names=(
                        case_name,
                        operator,
                        digest,
                        short_digest,
                        collection,
                    ),
                )
            )
    return discovered


def build(
    case: CorpusCase,
    context: RunContext,
    _build_state: BuildState,
) -> BuildResult:
    build_root = context.artifact_directory / "llama" / _suite_shard(case) / case.target
    build_dir = build_root / "build"
    logs_dir = build_root / "logs"
    _run_command(
        [
            "bash",
            str(BUILD_SCRIPT),
            case.target,
            str(build_dir),
        ],
        log_path=logs_dir / "build.log",
        phase="build",
    )

    executable_path = build_dir / EXECUTABLE_NAME
    if not executable_path.is_file() or not os.access(executable_path, os.X_OK):
        raise RuntimeError(
            f"llama build did not produce an executable {executable_path}"
        )
    return BuildResult(
        build_dir=build_dir,
        executable_path=executable_path,
        metadata={},
    )


def run(case: CorpusCase, build_result: BuildResult, context: RunContext) -> None:
    if context.skip_all_runs:
        return

    case_name = case.metadata["name"]
    command = _run_wrapper_command(context.run_wrapper) + [
        str(build_result.executable_path),
        "test",
        "-o",
        case_name,
        "-b",
        case.backend,
        "-j",
        "1",
        "--output",
        "csv",
    ]
    completed = _run_case(command)
    outcome = _classify(completed)
    log_path = _write_case_artifacts(case, context, command, completed, outcome)

    if outcome == "pass":
        return

    raise RuntimeError(
        f"llama case {case_name} reported '{outcome}'; log: {log_path}\n"
        f"stderr:\n{completed['stderr'] or '<empty>'}"
    )


def _load_inventories(
    inventory_files: tuple[str, ...] | list[str],
) -> list[tuple[Path, str, tuple[str, ...], tuple[str, ...]]]:
    if not inventory_files:
        raise ValueError("the llama suite requires a case inventory")

    inventories: list[tuple[Path, str, tuple[str, ...], tuple[str, ...]]] = []
    for inventory_file in inventory_files:
        inventory_path = Path(inventory_file)
        payload = load_json(inventory_path)
        if not isinstance(payload, dict):
            raise TypeError(f"{inventory_path} must contain a JSON object")
        unknown = sorted(
            set(payload)
            - {"schema_version", "collection", "supported_targets", "cases"}
        )
        if unknown:
            raise ValueError(
                f"{inventory_path} has unknown field(s): {', '.join(unknown)}"
            )
        if payload.get("schema_version") != 1:
            raise ValueError(f"{inventory_path} field 'schema_version' must be 1")
        collection = payload.get("collection")
        if not isinstance(collection, str) or not collection:
            raise ValueError(
                f"{inventory_path} field 'collection' must be a non-empty string"
            )
        supported_targets = payload.get("supported_targets")
        if not isinstance(supported_targets, list) or not supported_targets:
            raise ValueError(
                f"{inventory_path} field 'supported_targets' must be a "
                "non-empty list"
            )
        for supported_target in supported_targets:
            if not isinstance(supported_target, str) or not re.fullmatch(
                r"gfx[0-9A-Za-z]+", supported_target
            ):
                raise ValueError(
                    f"{inventory_path} field 'supported_targets' must contain "
                    "concrete gfx targets"
                )
        if len(set(supported_targets)) != len(supported_targets):
            raise ValueError(
                f"{inventory_path} field 'supported_targets' must not repeat entries"
            )
        cases = payload.get("cases")
        if not isinstance(cases, list) or not cases:
            raise ValueError(f"{inventory_path} field 'cases' must be a non-empty list")
        seen: set[str] = set()
        for case_name in cases:
            if not isinstance(case_name, str) or not CASE_PATTERN.fullmatch(case_name):
                raise ValueError(
                    f"{inventory_path} case {case_name!r} must be an exact "
                    "test-backend-ops 'OP(params)' string"
                )
            if case_name in seen:
                raise ValueError(f"{inventory_path} repeats case {case_name}")
            seen.add(case_name)
        if cases != sorted(cases):
            raise ValueError(
                f"{inventory_path} field 'cases' must be sorted for "
                "deterministic discovery"
            )
        inventories.append(
            (
                inventory_path,
                collection,
                tuple(supported_targets),
                tuple(cases),
            )
        )
    return inventories


def _run_command(command: list[str], *, log_path: Path, phase: str) -> None:
    tool = shutil.which(command[0])
    if tool is None:
        raise RuntimeError(f"Missing required tool '{command[0]}' in PATH")
    resolved = [tool, *command[1:]]
    log_path.parent.mkdir(parents=True, exist_ok=True)
    with log_path.open("w", encoding="utf-8") as log:
        log.write("$ " + " ".join(shlex.quote(part) for part in resolved) + "\n")
        log.flush()
        process = subprocess.run(
            resolved,
            cwd=str(REPO_ROOT),
            stdout=log,
            stderr=subprocess.STDOUT,
            check=False,
        )
        log.write(f"\nreturncode: {process.returncode}\n")
    if process.returncode != 0:
        raise RuntimeError(
            f"llama {phase} failed with return code {process.returncode}; "
            f"log: {log_path}"
        )


def _run_case(command: list[str]) -> dict:
    started = time.monotonic()
    process = subprocess.run(
        command,
        cwd=str(REPO_ROOT),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        errors="replace",
        check=False,
    )
    return {
        "returncode": process.returncode,
        "duration_seconds": time.monotonic() - started,
        "stdout": process.stdout,
        "stderr": process.stderr,
    }


def _classify(completed: dict) -> str:
    returncode = completed["returncode"]
    terminating_signal = _terminating_signal(returncode)
    if terminating_signal == signal.SIGSEGV:
        return "segfault"
    if terminating_signal is not None:
        return "crash"

    result = _parse_csv_result(completed["stdout"])
    if not result:
        return "no-result" if returncode == 0 else "error"
    if result["error_message"] == "test failed":
        return "test-failure"
    if result["error_message"] == "not supported" or result["supported"] == "0":
        return "not-supported"
    if returncode == 0 and result["supported"] == "1" and not result["error_message"]:
        return "pass"
    return "error"


def _terminating_signal(returncode: int) -> int | None:
    if returncode < 0:
        return -returncode
    # Shell-style wrappers report a killed child as 128 + signal number.
    if returncode > 128:
        return returncode - 128
    return None


def _parse_csv_result(stdout: str) -> dict[str, str]:
    header: list[str] | None = None
    rows: list[dict[str, str]] = []
    for line in stdout.splitlines():
        # A run wrapper may prefix its own text before the harness output.
        quote_index = line.find('"')
        if quote_index < 0:
            continue
        record = line[quote_index:]
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


def _write_case_artifacts(
    case: CorpusCase,
    context: RunContext,
    command: list[str],
    completed: dict,
    outcome: str,
) -> Path:
    case_directory = (
        context.artifact_directory
        / "llama"
        / case.target
        / "cases"
    )
    case_directory.mkdir(parents=True, exist_ok=True)
    artifact_name = case.metadata["artifact_name"]

    log_path = case_directory / f"{artifact_name}.log"
    log_path.write_text(
        "\n".join(
            [
                "$ " + " ".join(shlex.quote(part) for part in command),
                f"case: {case.metadata['name']}",
                f"outcome: {outcome}",
                f"returncode: {completed['returncode']}",
                f"duration_seconds: {completed['duration_seconds']:.3f}",
                "",
                "stdout:",
                completed["stdout"] or "<empty>",
                "",
                "stderr:",
                completed["stderr"] or "<empty>",
                "",
            ]
        ),
        encoding="utf-8",
    )
    outcome_path = case_directory / f"{artifact_name}.outcome.json"
    outcome_path.write_text(
        json.dumps(
            {
                "case": case.metadata["name"],
                "outcome": outcome,
                "returncode": completed["returncode"],
                "duration_seconds": round(completed["duration_seconds"], 3),
            },
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    return log_path


def _run_wrapper_command(run_wrapper: str | list[str] | None) -> list[str]:
    if run_wrapper is None:
        return []
    if isinstance(run_wrapper, str):
        return shlex.split(run_wrapper)
    return [str(part) for part in run_wrapper]


def _suite_shard(case: CorpusCase) -> str:
    return str(case.build.get("suite_shard", "llama_shard_0"))
