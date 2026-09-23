"""RocJITsu race-detector HIP integration suite.

The HIP programs and their GoogleTest assertions are intentionally kept
unchanged from their original in-tree form. This adapter only builds the
selected architecture, gives every filtered test a private plugin config and
sink directory, and runs it through the caller-supplied RocJITsu wrapper.
"""

from __future__ import annotations

import contextlib
import fcntl
import json
import os
import shlex
import shutil
import subprocess
from pathlib import Path

from support.define_contracts import (
    BuildResult,
    BuildState,
    CorpusCase,
    RunContext,
    TargetSpec,
)
from support.prepare_inputs import load_json, load_suite_target_configs, supports_target


REPO_ROOT = Path(__file__).resolve().parents[2]
RACE_SOURCE_DIR = REPO_ROOT / "corpus" / "race"
CONFIGS_ROOT = RACE_SOURCE_DIR / "configs"
CASES_PATH = RACE_SOURCE_DIR / "test_cases.json"
TARGET_LAYOUT = {
    "gfx950": {
        "binary": "hip_race_tests_gfx950",
        "fixture": "Gfx950RaceTest",
    },
    "gfx1151": {
        "binary": "hip_race_tests_gfx1151",
        "fixture": "Gfx1151RaceTest",
    },
}


def default_config_files() -> tuple[Path, ...]:
    return tuple(sorted(CONFIGS_ROOT.glob("*.json")))


def load_target_configs(config_files: tuple[str, ...] | list[str]) -> list[dict]:
    return load_suite_target_configs(config_files, repo_root=REPO_ROOT)


def discover(target: TargetSpec, target_configs: list[dict]) -> list[CorpusCase]:
    discovered: list[CorpusCase] = []
    cases = discover_cases()
    for target_config in target_configs:
        if not supports_target(target, target_config):
            continue
        layout = TARGET_LAYOUT.get(target.target)
        if layout is None:
            continue
        for entry in cases:
            if target.target not in entry["supported_targets"]:
                continue
            name = entry["name"]
            test_filter = f"{layout['fixture']}.{name}"
            legacy_name = f"RaceTest.{target.target}_{name}"
            discovered.append(
                CorpusCase(
                    id=f"race.{target.target}.{name}",
                    suite="race",
                    target=target.target,
                    collection="rocjitsu",
                    backend=None,
                    path=CASES_PATH,
                    build={
                        "system": "cmake_hip",
                        "config_name": target_config["config_name"],
                        "target": layout["binary"],
                    },
                    run={"kind": "filtered_gtest", "filter": test_filter},
                    metadata={
                        "name": name,
                        "test_filter": test_filter,
                        "target_config": target_config,
                    },
                    selector_names=(test_filter, legacy_name),
                )
            )
    return discovered


def discover_cases() -> list[dict]:
    payload = load_json(CASES_PATH)
    if payload.get("collection") != "rocjitsu-race":
        raise ValueError(f"{CASES_PATH} has an invalid collection")
    entries = payload.get("cases")
    if not isinstance(entries, list) or not entries:
        raise ValueError(f"{CASES_PATH} field 'cases' must be a non-empty list")

    cases: list[dict] = []
    names_by_target: set[tuple[str, str]] = set()
    for entry in entries:
        if not isinstance(entry, dict) or set(entry) != {"name", "supported_targets"}:
            raise ValueError(
                f"{CASES_PATH} case entries require name and supported_targets"
            )
        name = entry["name"]
        targets = entry["supported_targets"]
        if not isinstance(name, str) or not name:
            raise ValueError(f"{CASES_PATH} case name must be a non-empty string")
        if not isinstance(targets, list) or not targets:
            raise ValueError(
                f"{CASES_PATH} case {name!r} requires supported_targets"
            )
        for supported_target in targets:
            if supported_target not in TARGET_LAYOUT:
                raise ValueError(
                    f"{CASES_PATH} case {name!r} has unsupported target "
                    f"{supported_target!r}"
                )
            key = (supported_target, name)
            if key in names_by_target:
                raise ValueError(
                    f"{CASES_PATH} repeats case {name!r} for {supported_target}"
                )
            names_by_target.add(key)
        cases.append(entry)
    return cases


def build(
    case: CorpusCase,
    context: RunContext,
    _build_state: BuildState,
) -> BuildResult:
    layout = TARGET_LAYOUT[case.target]
    build_root = _build_root(context) / case.target
    build_dir = build_root / "build"
    logs_dir = build_root / "logs"
    logs_dir.mkdir(parents=True, exist_ok=True)

    with _build_lock(build_root / ".build.lock"):
        configure = [
            "cmake",
            "-S",
            str(RACE_SOURCE_DIR),
            "-B",
            str(build_dir),
            "-G",
            "Ninja",
            f"-DCMAKE_HIP_ARCHITECTURES={case.target}",
        ]
        if rocm_path := os.getenv("ROCM_PATH"):
            configure.append(f"-DROCM_PATH={rocm_path}")
        _run_command(
            configure,
            cwd=REPO_ROOT,
            log_path=logs_dir / "configure.log",
            phase="configure",
        )
        _run_command(
            [
                "cmake",
                "--build",
                str(build_dir),
                "--target",
                layout["binary"],
            ],
            cwd=REPO_ROOT,
            log_path=logs_dir / "build.log",
            phase="build",
        )

    executable = build_dir / layout["binary"]
    if not executable.is_file():
        raise RuntimeError(f"Race test build did not produce {executable}")
    return BuildResult(
        build_dir=build_dir,
        executable_path=executable,
        metadata={"logs_dir": str(logs_dir)},
    )


def run(case: CorpusCase, build_result: BuildResult, context: RunContext) -> None:
    if context.skip_all_runs:
        return
    if build_result.executable_path is None:
        raise RuntimeError("Race test executable is unavailable")

    case_dir = (
        context.artifact_directory
        / "race"
        / case.target
        / "cases"
        / case.metadata["name"]
    )
    if case_dir.exists():
        shutil.rmtree(case_dir)
    sink_dir = case_dir / "plugins"
    runtime_dir = case_dir / "runtime"
    sink_dir.mkdir(parents=True)
    runtime_dir.mkdir()

    base_config = _base_config_path()
    config_path = case_dir / "config.json"
    _materialize_config(base_config, config_path, sink_dir)
    command = [
        *_run_wrapper_command(context.run_wrapper, config_path),
        str(build_result.executable_path),
        f"--gtest_filter={case.metadata['test_filter']}",
    ]
    environment = dict(os.environ)
    environment["RJ_SINK_DIR"] = str(sink_dir)
    environment["ROCJITSU_RUNTIME_DIR"] = str(runtime_dir)
    _run_command(
        command,
        cwd=case_dir,
        log_path=case_dir / "run.log",
        phase="run",
        env=environment,
    )
    report = sink_dir / "race.log"
    if not report.is_file():
        raise RuntimeError(f"Race test did not produce {report}")


def _build_root(context: RunContext) -> Path:
    if configured := os.getenv("ROCJITSU_RACE_BUILD_ROOT"):
        return Path(configured).expanduser().resolve()
    return context.artifact_directory / "race-build"


def _base_config_path() -> Path:
    configured = os.getenv("ROCJITSU_RACE_CONFIG")
    if not configured:
        raise RuntimeError("ROCJITSU_RACE_CONFIG must name the base simulator config")
    path = Path(configured).expanduser().resolve()
    if not path.is_file():
        raise RuntimeError(f"Race simulator config does not exist: {path}")
    return path


def _materialize_config(base_path: Path, output_path: Path, sink_dir: Path) -> None:
    try:
        value = json.loads(base_path.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise RuntimeError(
            f"Could not read race simulator config {base_path}: {error}"
        ) from error
    if not isinstance(value, dict):
        raise RuntimeError(f"Race simulator config must contain an object: {base_path}")
    if value.get("plugins") or value.get("sinks"):
        raise RuntimeError(
            "Race simulator base config must not enable plugins or sinks: "
            f"{base_path}"
        )
    value["require_all_plugins"] = True
    value["plugins"] = {"race": {}}
    value["sinks"] = {"types": ["file"], "dir": str(sink_dir)}
    output_path.write_text(
        json.dumps(value, indent=2, sort_keys=True, allow_nan=False) + "\n",
        encoding="utf-8",
    )


def _run_wrapper_command(run_wrapper: str | None, config_path: Path) -> list[str]:
    if not run_wrapper:
        raise RuntimeError(
            "The race suite requires --run-wrapper with a {config} token"
        )
    try:
        wrapper = shlex.split(run_wrapper)
    except ValueError as error:
        raise RuntimeError(f"Invalid race --run-wrapper: {error}") from error
    if wrapper.count("{config}") != 1:
        raise RuntimeError(
            "The race suite --run-wrapper requires exactly one standalone {config} token"
        )
    if any("{config}" in argument and argument != "{config}" for argument in wrapper):
        raise RuntimeError("{config} must be a standalone --run-wrapper token")
    return [
        str(config_path) if argument == "{config}" else argument
        for argument in wrapper
    ]


@contextlib.contextmanager
def _build_lock(path: Path):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as lock:
        fcntl.flock(lock.fileno(), fcntl.LOCK_EX)
        try:
            yield
        finally:
            fcntl.flock(lock.fileno(), fcntl.LOCK_UN)


def _run_command(
    command: list[str],
    *,
    cwd: Path,
    log_path: Path,
    phase: str,
    env: dict[str, str] | None = None,
) -> None:
    executable = command[0]
    if os.sep not in executable:
        resolved = shutil.which(executable)
        if resolved is None:
            raise RuntimeError(f"Missing required tool {executable!r}")
        command = [resolved, *command[1:]]
    process = subprocess.run(
        command,
        cwd=str(cwd),
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        errors="replace",
        check=False,
    )
    log_path.parent.mkdir(parents=True, exist_ok=True)
    log_path.write_text(
        "\n".join(
            [
                "$ " + " ".join(shlex.quote(part) for part in command),
                f"cwd: {cwd}",
                f"returncode: {process.returncode}",
                "",
                "stdout:",
                process.stdout,
                "",
                "stderr:",
                process.stderr,
            ]
        ),
        encoding="utf-8",
    )
    if process.returncode != 0:
        raise RuntimeError(
            "\n".join(
                [
                    f"Race test {phase} failed.",
                    f"log: {log_path}",
                    "command: " + " ".join(shlex.quote(part) for part in command),
                    f"returncode: {process.returncode}",
                    "stdout:",
                    process.stdout or "<empty>",
                    "stderr:",
                    process.stderr or "<empty>",
                ]
            )
        )
