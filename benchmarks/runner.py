# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""Run parameterized Rocjitsu performance benchmarks from a suite TOML."""

from __future__ import annotations

import argparse
import dataclasses
import datetime
import hashlib
import importlib.metadata
import importlib.util
import json
import math
import os
import platform
import re
import shlex
import shutil
import signal
import socket
import statistics
import subprocess
import sys
import time
import tomllib
from collections.abc import Mapping, Sequence
from pathlib import Path
from typing import Any, Literal, TextIO

BENCHMARK_ROOT = Path(__file__).resolve().parent
CORPUS_ROOT = BENCHMARK_ROOT.parent
WORKLOAD_ROOT = CORPUS_ROOT / "corpus" / "benchmarks"
DEFAULT_MANIFEST = BENCHMARK_ROOT / "suites" / "nightly.toml"
TARGET_NAME = re.compile(r"gfx[0-9A-Za-z]+")
MANIFEST_FIELDS = {
    "name",
    "targets",
    "cases",
    "warmups",
    "samples",
    "timeout_seconds",
}
PACKAGE_NAMES = (
    "rocm-sdk-devel",
    "rocm-sdk-libraries",
    "rocm-sdk-device-gfx950",
    "rocm-sdk-device-gfx1250",
    "torch",
    "triton",
    "amd-torch-device-gfx950",
    "amd-torch-device-gfx1250",
)
CASE_ID = re.compile(r"^[a-z0-9_]+(?:\.[a-z0-9_]+)*$")
WORKLOADS = {
    "copy",
    "vector_add",
    "transpose",
    "gather",
    "atomic_add",
    "softmax",
    "rmsnorm",
    "gemm",
    "gpt_oss_attention",
    "triton_persistent",
    "triton_grouped",
    "deepseek_fp8",
    "triton_softmax",
    "triton_layernorm",
    "deepseek_act_quant",
    "deepseek_weight_dequant",
    "tensile_candidate",
}
WORKLOAD_FIELDS = {"schema", "case", "target", "provider", "parameters", "timings_ns"}
PLUGIN_PROFILES: dict[str, tuple[str, ...]] = {
    "none": (),
    "logging": ("logging",),
    "race": ("race",),
    "throughput": ("throughput",),
}


class RunnerError(ValueError):
    """A user-facing configuration or execution error."""


class _CommandInterrupted(KeyboardInterrupt):
    """An interruption with output drained from the terminated workload."""

    def __init__(self, message: str, stdout: str, stderr: str) -> None:
        super().__init__(message)
        self.stdout = stdout
        self.stderr = stderr


@dataclasses.dataclass(frozen=True)
class Case:
    id: str
    workload: str
    suite: str
    name: str
    operation: str
    params: dict[str, Any]
    targets: tuple[str, ...] = ()


@dataclasses.dataclass(frozen=True)
class Suite:
    name: str
    targets: tuple[str, ...]
    cases: tuple[Case, ...]
    warmups: int
    samples: int
    num_threads: int | None
    timeout_seconds: float
    thread_policy: Literal["default", "single"] | None = None


@dataclasses.dataclass(frozen=True)
class Cell:
    definition: Case
    target: str

    @property
    def case(self) -> str:
        return self.definition.id


@dataclasses.dataclass(frozen=True)
class PreparedCommand:
    argv: tuple[str, ...]
    cwd: Path
    environment: dict[str, str]
    workload_path: Path
    config_path: Path
    plugin_reports: dict[str, Path]


@dataclasses.dataclass(frozen=True)
class TargetMetadata:
    configuration: dict[str, Any]
    config_sha256: str


def _string_list(value: Any, field: str) -> tuple[str, ...]:
    if not isinstance(value, list) or not value:
        raise RunnerError(f"{field} must be a non-empty array of strings")
    if any(not isinstance(item, str) or not item for item in value):
        raise RunnerError(f"{field} must be a non-empty array of strings")
    result = tuple(value)
    if len(set(result)) != len(result):
        raise RunnerError(f"{field} must not contain duplicates")
    return result


def _integer(value: Any, field: str, *, allow_zero: bool) -> int:
    minimum = 0 if allow_zero else 1
    if isinstance(value, bool) or not isinstance(value, int) or value < minimum:
        qualifier = "non-negative" if allow_zero else "positive"
        raise RunnerError(f"{field} must be a {qualifier} integer")
    return value


def _sample_count(value: Any, field: str = "samples") -> int:
    count = _integer(value, field, allow_zero=False)
    if count % 2 == 0:
        raise RunnerError(f"{field} must be odd so its median is an observed sample")
    return count


def _thread_policy(value: Any) -> Literal["default", "single"]:
    if value not in ("default", "single"):
        raise RunnerError('thread_policy must be "default" or "single"')
    return value


def load_manifest(path: str | Path = DEFAULT_MANIFEST) -> Suite:
    """Read and validate the intentionally small suite manifest."""

    manifest = Path(path).expanduser().resolve()
    try:
        value = tomllib.loads(manifest.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, tomllib.TOMLDecodeError) as error:
        raise RunnerError(f"cannot read manifest {manifest}: {error}") from error
    fields = set(value)
    threading_fields = fields & {"num_threads", "thread_policy"}
    if len(threading_fields) != 1:
        raise RunnerError("manifest requires exactly one of thread_policy or num_threads")
    fields -= threading_fields
    if fields != MANIFEST_FIELDS:
        missing = sorted(MANIFEST_FIELDS - fields)
        extra = sorted(fields - MANIFEST_FIELDS)
        raise RunnerError(f"manifest fields differ: missing={missing}, extra={extra}")
    name = value["name"]
    if not isinstance(name, str) or not name:
        raise RunnerError("name must be a non-empty string")
    targets = _string_list(value["targets"], "targets")
    if any(not TARGET_NAME.fullmatch(target) for target in targets):
        raise RunnerError("targets must be concrete gfx target names")
    raw_cases = value["cases"]
    if not isinstance(raw_cases, list) or not raw_cases:
        raise RunnerError("cases must be a non-empty array of tables")
    cases = []
    ids = set()
    case_fields = {"id", "workload", "suite", "name", "operation", "params"}
    for entry in raw_cases:
        if not isinstance(entry, dict) or set(entry) - {"targets"} != case_fields:
            raise RunnerError(
                "each case must contain id, workload, suite, name, operation, params"
            )
        for field in case_fields - {"params"}:
            if not isinstance(entry[field], str) or not entry[field].strip():
                raise RunnerError(f"case {field} must be a non-empty string")
        if not CASE_ID.fullmatch(entry["id"]):
            raise RunnerError(f"invalid benchmark case ID {entry['id']!r}")
        if entry["id"] in ids:
            raise RunnerError(f"duplicate case ID {entry['id']!r}")
        ids.add(entry["id"])
        if entry["workload"] not in WORKLOADS:
            raise RunnerError(f"unknown workload {entry['workload']!r}")
        params = entry["params"]
        if not isinstance(params, dict) or not isinstance(params.get("dtype"), str):
            raise RunnerError("case params must be a table containing dtype")
        try:
            json.dumps(params, allow_nan=False)
        except (TypeError, ValueError) as error:
            raise RunnerError(
                f"case parameters must be finite JSON values: {error}"
            ) from error
        entry = dict(entry)
        if "targets" in entry:
            entry["targets"] = _string_list(entry["targets"], "case targets")
            if set(entry["targets"]) - set(targets):
                raise RunnerError("case targets must be selected from suite targets")
        cases.append(Case(**entry))
    timeout = value["timeout_seconds"]
    if (
        isinstance(timeout, bool)
        or not isinstance(timeout, (int, float))
        or not math.isfinite(timeout)
        or timeout <= 0
    ):
        raise RunnerError("timeout_seconds must be a positive number")
    return Suite(
        name=name,
        targets=targets,
        cases=tuple(cases),
        warmups=_integer(value["warmups"], "warmups", allow_zero=True),
        samples=_sample_count(value["samples"]),
        num_threads=(
            _integer(value["num_threads"], "num_threads", allow_zero=False)
            if "num_threads" in value else None
        ),
        thread_policy=_thread_policy(value["thread_policy"]) if "thread_policy" in value else None,
        timeout_seconds=float(timeout),
    )


def select_matrix(
    suite: Suite,
    *,
    targets: Sequence[str] = (),
    cases: Sequence[str] = (),
) -> tuple[Cell, ...]:
    """Select cells while retaining manifest case-major ordering."""

    requested_targets = set(targets)
    requested_cases = set(cases)
    unknown_targets = sorted(requested_targets - set(suite.targets))
    unknown_cases = sorted(requested_cases - {case.id for case in suite.cases})
    if unknown_targets:
        raise RunnerError(f"selected targets are not in the suite: {unknown_targets}")
    if unknown_cases:
        raise RunnerError(f"selected cases are not in the suite: {unknown_cases}")
    chosen_targets = tuple(
        target
        for target in suite.targets
        if not requested_targets or target in requested_targets
    )
    chosen_cases = tuple(
        case
        for case in suite.cases
        if not requested_cases or case.id in requested_cases
    )
    matrix = tuple(
        Cell(case, target)
        for case in chosen_cases
        for target in chosen_targets
        if not case.targets or target in case.targets
    )
    if not matrix:
        raise RunnerError("selected cases have no supported targets in the selection")
    return matrix


def parse_run_wrapper(value: str) -> tuple[str, ...]:
    """Parse a command prefix, with one literal per-cell config placeholder."""
    try:
        argv = tuple(shlex.split(value))
    except ValueError as error:
        raise RunnerError(f"invalid --run-wrapper: {error}") from error
    if not argv or argv[0] == "{config}" or argv.count("{config}") != 1:
        raise RunnerError(
            "--run-wrapper requires a command and exactly one standalone {config} token"
        )
    if any("{config}" in arg and arg != "{config}" for arg in argv):
        raise RunnerError("{config} must be a standalone --run-wrapper token")
    return argv


def parse_target_configs(values: Sequence[str]) -> dict[str, Path]:
    configs = {}
    for value in values:
        target, separator, path = value.partition("=")
        if not separator or not TARGET_NAME.fullmatch(target) or not path.strip():
            raise RunnerError(
                "--target-config must be TARGET=PATH with a concrete gfx target"
            )
        if target in configs:
            raise RunnerError(f"duplicate --target-config for {target}")
        configs[target] = Path(path).expanduser().resolve()
    return configs


def prepare_command(
    output: str | Path,
    cell: Cell,
    *,
    run_wrapper: Sequence[str],
    target: TargetMetadata,
    warmups: int,
    samples: int,
    plugin_profile: str = "none",
) -> PreparedCommand:
    """Construct one shell-free Rocjitsu workload command."""

    output_root = Path(output).expanduser().resolve()
    workload_path = output_root / "cases" / cell.case / cell.target / "workload.json"
    config_path, plugin_reports = _materialize_config(
        output_root,
        cell,
        plugin_profile,
        configuration=target.configuration,
    )
    payload = (
        sys.executable,
        str(
            WORKLOAD_ROOT / "tensile_candidates" / "workload.py"
            if cell.definition.workload == "tensile_candidate"
            else WORKLOAD_ROOT / "triton" / "workloads.py"
        ),
        "--workload",
        cell.definition.workload,
        "--params",
        json.dumps(cell.definition.params, allow_nan=False),
        "--case",
        cell.case,
        "--target",
        cell.target,
        "--warmups",
        str(warmups),
        "--samples",
        str(samples),
        "--output",
        str(workload_path),
    )
    environment = dict(os.environ)
    # Official runs always use the device libraries installed with the selected
    # SDK, never a caller-provided source-build or development override.
    environment.pop("HIPBLASLT_TENSILE_LIBPATH", None)
    environment["PYTHONPATH"] = (
        str(CORPUS_ROOT) + os.pathsep + environment.get("PYTHONPATH", "")
    )
    environment["PYTHONHASHSEED"] = "0"
    environment["TRITON_CACHE_DIR"] = str(
        output_root / "cache" / "triton" / cell.target
    )
    return PreparedCommand(
        argv=(
            *(str(config_path) if arg == "{config}" else arg for arg in run_wrapper),
            *payload,
        ),
        cwd=CORPUS_ROOT,
        environment=environment,
        workload_path=workload_path,
        config_path=config_path,
        plugin_reports=plugin_reports,
    )


def _require_file(path: Path, description: str) -> None:
    if not path.is_file():
        raise RunnerError(f"missing {description}: {path}")


def _installed_rocm_path() -> Path:
    spec = importlib.util.find_spec("_rocm_sdk_devel")
    if spec is None or spec.origin is None:
        raise RunnerError("the rocm-sdk-devel package is not installed")
    return Path(spec.origin).resolve().parent


def validate_build(
    build_dir: str | Path,
    *,
    rocjitsu_source_dir: str | Path,
    plugin_profile: str = "none",
) -> None:
    """Require a Release build and every file needed by the selected matrix."""

    build = Path(build_dir).expanduser().resolve()
    cache = build / "CMakeCache.txt"
    _require_file(cache, "CMake cache")
    values: dict[str, str] = {}
    for line in cache.read_text(encoding="utf-8", errors="replace").splitlines():
        key_and_type, separator, value = line.partition("=")
        if separator and ":" in key_and_type:
            key = key_and_type.partition(":")[0]
            values[key] = value
    build_type = values.get("CMAKE_BUILD_TYPE")
    source_dir = values.get("CMAKE_HOME_DIRECTORY")
    if build_type != "Release":
        raise RunnerError(f"benchmark build must be Release, got {build_type!r}")
    expected_source = Path(rocjitsu_source_dir).expanduser().resolve()
    if source_dir is None or Path(source_dir).resolve() != expected_source:
        raise RunnerError(
            f"benchmark build belongs to {source_dir!r}, expected {str(rocjitsu_source_dir)!r}"
        )
    if values.get("LTO") != "OFF":
        raise RunnerError("benchmark build must set LTO=OFF")
    enabled_sanitizers = [
        name
        for name in (
            "RJ_ENABLE_ASAN",
            "RJ_ENABLE_MSAN",
            "RJ_ENABLE_TSAN",
            "RJ_ENABLE_UBSAN",
        )
        if values.get(name) != "OFF"
    ]
    if enabled_sanitizers:
        raise RunnerError(
            "benchmark build must disable sanitizers: " + ", ".join(enabled_sanitizers)
        )
    configured_rocm = values.get("ROCM_PATH")
    if not configured_rocm:
        raise RunnerError("benchmark build has no ROCM_PATH")
    rocm_path = Path(configured_rocm).resolve()
    installed_rocm = _installed_rocm_path()
    if rocm_path != installed_rocm:
        raise RunnerError(
            f"benchmark build uses ROCM_PATH {str(rocm_path)!r}, "
            f"but this Python environment provides {str(installed_rocm)!r}"
        )
    _require_file(WORKLOAD_ROOT / "triton" / "workloads.py", "Triton workload")
    try:
        plugins = PLUGIN_PROFILES[plugin_profile]
    except KeyError as error:
        raise RunnerError(f"unknown plugin profile {plugin_profile!r}") from error
    for plugin in plugins:
        _require_file(
            build / f"librocjitsu_plugin_{plugin}.so",
            f"{plugin} plugin",
        )


def _load_target_configuration(
    path: Path,
    *,
    thread_policy: Literal["default", "single"] | None = None,
) -> tuple[dict[str, Any], str]:
    try:
        encoded = path.read_bytes()
        value = json.loads(encoded)
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise RunnerError(
            f"cannot read target configuration {path}: {error}"
        ) from error
    if not isinstance(value, Mapping):
        raise RunnerError(f"target configuration must be a JSON object: {path}")
    if value.get("plugins") or value.get("sinks"):
        raise RunnerError(
            f"benchmark base configuration must not enable plugins or sinks: {path}"
        )
    exec_mode = value.get("exec_mode")
    if not isinstance(exec_mode, str) or not exec_mode:
        raise RunnerError(f"target configuration has invalid exec_mode: {path}")
    result = dict(value)
    # Benchmarks must finish the workload without a simulation tick limit.
    result["max_ticks"] = 0
    if thread_policy == "single":
        # A single engine alone still permits parallel dispatch and helpers.
        result.update(
            cpu_thread_budget=1,
            num_threads=1,
            cpu_dispatch_threads=1,
            async_helper_threads=0,
        )
    encoded = (
        json.dumps(result, indent=2, sort_keys=True, allow_nan=False) + "\n"
    ).encode()
    return result, hashlib.sha256(encoded).hexdigest()


def _native_target_metadata(
    configuration: tuple[dict[str, Any], str],
    target: str,
    output: Path,
    wrapper: Sequence[str],
    thread_policy: str,
) -> TargetMetadata:
    """Resolve workers using the same native CLI and CPU affinity as the run."""
    value, digest = configuration
    directory = output / "thread-policy" / target
    directory.mkdir(parents=True)
    snapshot = directory / "config.json"
    snapshot.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    argv = [str(snapshot) if arg == "{config}" else arg for arg in wrapper]
    if argv[-1] == "--":
        argv.pop()
    argv.append("--thread-budget-table")
    try:
        completed = _run_command(
            argv, cwd=CORPUS_ROOT, env=dict(os.environ), timeout=30
        )
    except (OSError, subprocess.TimeoutExpired) as error:
        raise RunnerError(
            f"cannot resolve {thread_policy} worker policy for {target}; "
            f"native --thread-budget-table failed: {error}; "
            f"stdout={_captured_text(getattr(error, 'stdout', None))!r}; "
            f"stderr={_captured_text(getattr(error, 'stderr', None))!r}"
        ) from error
    raw = _captured_text(completed.stdout)
    (directory / "policy.txt").write_text(raw)
    (directory / "stderr.txt").write_text(_captured_text(completed.stderr))
    rows = re.findall(
        r"^\s*Configured\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*$",
        raw,
        re.MULTILINE,
    )
    if completed.returncode or len(rows) != 1:
        raise RunnerError(
            f"cannot resolve {thread_policy} worker policy for {target}; "
            f"native --thread-budget-table must return one Configured row "
            f"with exit status 0 (got {completed.returncode}); "
            f"stdout={raw!r}; stderr={_captured_text(completed.stderr)!r}"
        )
    engine, dispatch, helpers, total = map(int, rows[0])
    if engine < 1 or dispatch < 1 or total != engine + dispatch - 1 + helpers:
        raise RunnerError(f"invalid native worker allocation for {target}: {rows[0]}")
    if thread_policy == "single" and (engine, dispatch, helpers, total) != (1, 1, 0, 1):
        raise RunnerError(
            f"single-thread policy requires allocation 1/1/0, total 1 "
            f"for {target}; got {engine}/{dispatch}/{helpers}, total {total}"
        )
    allocation = {
        "engine": engine,
        "dispatch": dispatch,
        "helpers": helpers,
        "total": total,
    }
    (directory / "allocation.json").write_text(
        json.dumps(
            {
                **allocation,
                "command": argv,
            },
            indent=2,
        )
        + "\n"
    )
    return TargetMetadata(value, digest)


def _materialize_config(
    output_root: Path,
    cell: Cell,
    plugin_profile: str,
    *,
    configuration: Mapping[str, Any],
) -> tuple[Path, dict[str, Path]]:
    try:
        plugins = PLUGIN_PROFILES[plugin_profile]
    except KeyError as error:
        raise RunnerError(f"unknown plugin profile {plugin_profile!r}") from error
    value = dict(configuration)

    cell_dir = output_root / "cases" / cell.case / cell.target
    cell_dir.mkdir(parents=True, exist_ok=True)
    reports: dict[str, Path] = {}
    if plugins:
        sink_dir = cell_dir / "plugins"
        sink_dir.mkdir()
        value["plugins"] = {plugin: {} for plugin in plugins}
        value["sinks"] = {"types": ["file"], "dir": str(sink_dir)}
        reports = {plugin: sink_dir / f"{plugin}.log" for plugin in plugins}

    config_path = cell_dir / "config.json"
    config_path.write_text(
        json.dumps(value, indent=2, sort_keys=True, allow_nan=False) + "\n",
        encoding="utf-8",
    )
    return config_path, reports


def validate_workload(path: Path, cell: Cell, samples: int) -> list[float]:
    """Validate a workload result and return its timing samples in seconds."""

    def reject_constant(value: str) -> None:
        raise ValueError(f"non-finite JSON value {value}")

    def finite_float(value: str) -> float:
        parsed = float(value)
        if not math.isfinite(parsed):
            reject_constant(value)
        return parsed

    try:
        value = json.loads(
            path.read_text(encoding="utf-8"),
            parse_constant=reject_constant,
            parse_float=finite_float,
        )
    except (OSError, UnicodeDecodeError, ValueError) as error:
        raise RunnerError(f"cannot read workload result: {error}") from error
    if not isinstance(value, Mapping):
        raise RunnerError("workload result must be a JSON object")
    if set(value) != WORKLOAD_FIELDS:
        raise RunnerError("workload result must contain exactly the schema fields")
    expected = {
        "schema": "rocjitsu.benchmark.workload.v1",
        "case": cell.case,
        "target": cell.target,
        "provider": (
            "tensile" if cell.definition.workload == "tensile_candidate" else "triton"
        ),
    }
    for field, expected_value in expected.items():
        if value.get(field) != expected_value:
            raise RunnerError(
                f"workload {field} is {value.get(field)!r}, expected {expected_value!r}"
            )
    parameters = value.get("parameters")
    if not isinstance(parameters, dict):
        raise RunnerError("workload parameters must be an object")
    timings = value.get("timings_ns")
    if not isinstance(timings, list) or len(timings) != samples:
        actual = len(timings) if isinstance(timings, list) else "not a list"
        raise RunnerError(f"workload has {actual} timings, expected {samples}")
    if any(
        isinstance(item, bool) or not isinstance(item, int) or item <= 0
        for item in timings
    ):
        raise RunnerError("workload timings must be positive integers")
    return [sample / 1_000_000_000 for sample in timings]


def _utc_now() -> str:
    return (
        datetime.datetime.now(datetime.timezone.utc).isoformat().replace("+00:00", "Z")
    )


def _normalize_timestamp(value: str) -> str | None:
    try:
        parsed = datetime.datetime.fromisoformat(value)
    except ValueError:
        return None
    if parsed.tzinfo is None:
        return None
    return parsed.astimezone(datetime.timezone.utc).isoformat().replace("+00:00", "Z")


def _source_info(source_dir: Path) -> dict[str, Any]:
    revision = None
    commit_timestamp = None
    try:
        revision = subprocess.check_output(
            ["git", "rev-parse", "HEAD"],
            cwd=source_dir,
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()
    except (OSError, subprocess.CalledProcessError):
        pass
    if revision is not None:
        try:
            value = subprocess.check_output(
                ["git", "show", "-s", "--format=%cI", revision],
                cwd=source_dir,
                stderr=subprocess.DEVNULL,
                text=True,
            ).strip()
            commit_timestamp = _normalize_timestamp(value)
        except (OSError, subprocess.CalledProcessError):
            pass
    return {
        "commit_sha": revision,
        "commit_timestamp": commit_timestamp,
    }


def _environment_info() -> dict[str, Any]:
    packages: dict[str, str | None] = {}
    for package in PACKAGE_NAMES:
        try:
            packages[package] = importlib.metadata.version(package)
        except importlib.metadata.PackageNotFoundError:
            packages[package] = None
    return {
        "hostname": socket.gethostname(),
        "platform": platform.platform(),
        "kernel": platform.release(),
        "cpu": platform.processor() or platform.machine(),
        "python": platform.python_version(),
        "packages": packages,
    }


def _write_run(output: Path, run: dict[str, Any]) -> None:
    temporary = output / ".run.json.tmp"
    temporary.write_text(
        json.dumps(run, indent=2, sort_keys=True, allow_nan=False) + "\n",
        encoding="utf-8",
    )
    temporary.replace(output / "run.json")


def _captured_text(value: str | bytes | None) -> str:
    if value is None:
        return ""
    if isinstance(value, bytes):
        return value.decode("utf-8", errors="replace")
    return value


def _progress(stream: TextIO | None, message: str) -> None:
    if stream is not None:
        print(f"[rocjitsu-benchmark] {message}", file=stream, flush=True)


def _run_command(
    argv: Sequence[str],
    *,
    cwd: Path,
    env: Mapping[str, str],
    timeout: float,
) -> subprocess.CompletedProcess[str]:
    """Run one cell and leave no descendant processes behind."""

    def terminate_group() -> None:
        if os.name == "posix":
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
        else:
            process.kill()

    def terminate() -> tuple[str, str]:
        terminate_group()
        return process.communicate()

    process = subprocess.Popen(
        argv,
        cwd=cwd,
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        encoding="utf-8",
        errors="replace",
        start_new_session=os.name == "posix",
    )
    try:
        stdout, stderr = process.communicate(timeout=timeout)
    except subprocess.TimeoutExpired:
        stdout, stderr = terminate()
        raise subprocess.TimeoutExpired(
            argv, timeout, output=stdout, stderr=stderr
        ) from None
    except BaseException as error:
        try:
            stdout, stderr = terminate()
        except BaseException:
            pass
        else:
            if isinstance(error, KeyboardInterrupt):
                raise _CommandInterrupted(str(error), stdout, stderr) from error
        raise
    return subprocess.CompletedProcess(argv, process.returncode, stdout, stderr)


def _failed_test(cell: Cell, error: str) -> dict[str, Any]:
    metadata = cell.definition
    return {
        "id": cell.case,
        "suite": metadata.suite,
        "name": metadata.name,
        "target": cell.target,
        "problem": dict(metadata.params),
        "timing_results_s": [],
        "status": "failed",
        "exit_code": None,
        "error": error,
    }


def run_suite(
    suite: Suite,
    matrix: Sequence[Cell],
    *,
    build_dir: str | Path,
    rocjitsu_source_dir: str | Path,
    output: str | Path,
    run_wrapper: str,
    target_configs: Mapping[str, Path],
    warmups: int | None = None,
    samples: int | None = None,
    plugin_profile: str = "none",
    progress: TextIO | None = None,
) -> dict[str, Any]:
    """Run all selected cells, preserving partial results after failures."""

    if suite.thread_policy not in {"default", "single"}:
        raise RunnerError(
            "raw benchmark runs require thread_policy = default or single; "
            "numeric num_threads is unsupported"
        )
    output_path = Path(output).expanduser().resolve()
    if output_path.exists():
        raise RunnerError(f"output already exists: {output_path}")
    selected_warmups = (
        suite.warmups
        if warmups is None
        else _integer(warmups, "warmups", allow_zero=True)
    )
    selected_samples = suite.samples if samples is None else _sample_count(samples)
    build = Path(build_dir).expanduser().resolve()
    source_dir = Path(rocjitsu_source_dir).expanduser().resolve()
    wrapper = parse_run_wrapper(run_wrapper)
    validate_build(
        build, rocjitsu_source_dir=source_dir, plugin_profile=plugin_profile
    )
    targets = tuple(dict.fromkeys(cell.target for cell in matrix))
    missing = sorted(set(targets) - set(target_configs))
    if missing:
        raise RunnerError(f"missing --target-config for selected targets: {missing}")
    configurations = {
        target: _load_target_configuration(
            target_configs[target], thread_policy=suite.thread_policy
        )
        for target in targets
    }
    started = time.monotonic()
    timestamp = _utc_now()
    source = _source_info(source_dir)
    corpus = _source_info(CORPUS_ROOT)
    environment = _environment_info()
    output_path.mkdir(parents=True)
    try:
        target_metadata = {
            target: _native_target_metadata(
                configurations[target], target, output_path, wrapper, suite.thread_policy
            )
            for target in targets
        }
        total_cells = len(matrix)
        _progress(
            progress,
            f"START suite={suite.name} cells={total_cells} "
            f"warmups={selected_warmups} samples={selected_samples} "
            f"threads={suite.thread_policy} plugin={plugin_profile}",
        )
        summary = {
            "warmups": selected_warmups,
            "samples": selected_samples,
            "timeout_seconds": suite.timeout_seconds,
            "benchmark_suite": suite.name,
            "threading_mode": suite.thread_policy,
            "timestamp": timestamp,
            "finished_at": None,
            "wall_time_s": 0.0,
        }
        run: dict[str, Any] = {
            "execution_summary": summary,
            "provenance": {
                "machine": {
                    key: environment[key]
                    for key in ("hostname", "platform", "kernel", "cpu")
                },
                "rocjitsu": {
                    "rocjitsu_commit_sha": source["commit_sha"],
                    "rocjitsu_commit_timestamp": source["commit_timestamp"],
                    "target_config_sha256": {
                        target: target_metadata[target].config_sha256 for target in targets
                    },
                    "rocm_sdk_version": environment["packages"]["rocm-sdk-devel"],
                },
                "corpus": {
                    "corpus_commit_sha": corpus["commit_sha"],
                    "corpus_commit_timestamp": corpus["commit_timestamp"],
                },
                "auxiliary": {**environment["packages"], "python": environment["python"]},
            },
            "benchmark_results": [
                _failed_test(cell, "run interrupted before completion") for cell in matrix
            ],
        }
        _write_run(output_path, run)
    except BaseException:
        # Until the first checkpoint, setup has no partial results to preserve.
        # mkdir above must succeed before taking ownership of this directory.
        shutil.rmtree(output_path)
        raise

    try:
        for position, cell in enumerate(matrix, start=1):
            cell_started = time.monotonic()
            _progress(
                progress,
                f"START [{position}/{total_cells}] case={cell.case} "
                f"target={cell.target} provider={'tensile' if cell.definition.workload == 'tensile_candidate' else 'triton'} "
                f"timeout_seconds={suite.timeout_seconds:g}",
            )
            command = prepare_command(
                output_path,
                cell,
                run_wrapper=wrapper,
                target=target_metadata[cell.target],
                warmups=selected_warmups,
                samples=selected_samples,
                plugin_profile=plugin_profile,
            )
            cell_dir = command.workload_path.parent
            (output_path / "cache" / "triton" / cell.target).mkdir(
                parents=True, exist_ok=True
            )
            stdout = ""
            stderr = ""
            result = _failed_test(cell, "workload did not run")
            try:
                completed = _run_command(
                    command.argv,
                    cwd=command.cwd,
                    env=command.environment,
                    timeout=suite.timeout_seconds,
                )
                stdout = _captured_text(completed.stdout)
                stderr = _captured_text(completed.stderr)
                result["exit_code"] = completed.returncode
                if completed.returncode != 0:
                    raise RunnerError(
                        f"command exited with status {completed.returncode}"
                    )
                timings = validate_workload(
                    command.workload_path, cell, selected_samples
                )
                missing_reports = [
                    plugin
                    for plugin, path in command.plugin_reports.items()
                    if not path.is_file()
                ]
                if missing_reports:
                    raise RunnerError(
                        "workload did not produce plugin reports: "
                        + ", ".join(missing_reports)
                    )
                result["timing_results_s"] = timings
                result["status"] = "completed"
                result["error"] = None
            except subprocess.TimeoutExpired as error:
                stdout = _captured_text(error.stdout)
                stderr = _captured_text(error.stderr)
                result["status"] = "timeout"
                result["error"] = (
                    f"command timed out after {suite.timeout_seconds:g} seconds"
                )
            except (OSError, RunnerError) as error:
                result["error"] = str(error)
            except KeyboardInterrupt as error:
                if isinstance(error, _CommandInterrupted):
                    stdout = _captured_text(error.stdout)
                    stderr = _captured_text(error.stderr)
                result = _failed_test(
                    cell, "workload interrupted" + (f": {error}" if str(error) else "")
                )
                raise
            finally:
                (cell_dir / "stdout.txt").write_text(stdout, encoding="utf-8")
                (cell_dir / "stderr.txt").write_text(stderr, encoding="utf-8")
                run["benchmark_results"][position - 1] = result
                summary["wall_time_s"] = time.monotonic() - started
                _write_run(output_path, run)
            detail = ""
            if result["status"] == "completed":
                detail = f" median_s={statistics.median(result['timing_results_s']):g}"
            _progress(
                progress,
                f"DONE  [{position}/{total_cells}] case={cell.case} "
                f"target={cell.target} status={result['status']} "
                f"elapsed_seconds={time.monotonic() - cell_started:.1f}{detail}",
            )
    except BaseException:
        summary["finished_at"] = _utc_now()
        summary["wall_time_s"] = time.monotonic() - started
        _write_run(output_path, run)
        _progress(
            progress,
            f"ABORT suite={suite.name} "
            f"completed={sum(test['status'] == 'completed' for test in run['benchmark_results'])}/{total_cells} "
            f"elapsed_seconds={summary['wall_time_s']:.1f}",
        )
        raise

    summary["finished_at"] = _utc_now()
    summary["wall_time_s"] = time.monotonic() - started
    _write_run(output_path, run)
    status_counts = {
        status: sum(test["status"] == status for test in run["benchmark_results"])
        for status in ("completed", "failed", "timeout")
    }
    status = "completed" if status_counts["completed"] == total_cells else "failed"
    _progress(
        progress,
        f"DONE suite={suite.name} status={status} "
        f"completed={status_counts['completed']} failed={status_counts['failed']} "
        f"timeout={status_counts['timeout']} "
        f"elapsed_seconds={summary['wall_time_s']:.1f}",
    )
    return run


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    parser.add_argument("--target", action="append", default=[])
    parser.add_argument("--case", action="append", default=[])
    parser.add_argument("--warmups", type=int)
    parser.add_argument("--samples", type=int)
    parser.add_argument(
        "--plugin-profile", choices=tuple(PLUGIN_PROFILES), default="none"
    )
    parser.add_argument("--rocjitsu-source-dir", type=Path)
    parser.add_argument("--build-dir", type=Path)
    parser.add_argument(
        "--run-wrapper", help="Command prefix with one standalone {config} token"
    )
    parser.add_argument(
        "--target-config", action="append", default=[], metavar="TARGET=PATH"
    )
    parser.add_argument("--output", type=Path)
    parser.add_argument("--list", action="store_true")
    return parser


def _raise_interruption(signum: int, _frame: Any) -> None:
    raise KeyboardInterrupt(signal.Signals(signum).name)


def main(argv: Sequence[str] | None = None) -> int:
    parser = build_parser()
    arguments = parser.parse_args(argv)
    previous_handlers = {
        signum: signal.signal(signum, _raise_interruption)
        for signum in (signal.SIGHUP, signal.SIGTERM)
    }
    try:
        suite = load_manifest(arguments.manifest)
        matrix = select_matrix(suite, targets=arguments.target, cases=arguments.case)
        if arguments.list:
            for cell in matrix:
                print(f"{cell.case}\t{cell.target}")
            return 0
        if (
            arguments.build_dir is None
            or arguments.output is None
            or arguments.rocjitsu_source_dir is None
            or arguments.run_wrapper is None
        ):
            raise RunnerError(
                "--rocjitsu-source-dir, --build-dir, --run-wrapper and --output are required unless --list is used"
            )
        run = run_suite(
            suite,
            matrix,
            build_dir=arguments.build_dir,
            rocjitsu_source_dir=arguments.rocjitsu_source_dir,
            output=arguments.output,
            run_wrapper=arguments.run_wrapper,
            target_configs=parse_target_configs(arguments.target_config),
            warmups=arguments.warmups,
            samples=arguments.samples,
            plugin_profile=arguments.plugin_profile,
            progress=sys.stdout,
        )
        artifact = arguments.output.expanduser().resolve() / "run.json"
        status = (
            "completed"
            if all(result["status"] == "completed" for result in run["benchmark_results"])
            else "failed"
        )
        print(f"run {status}: {artifact}")
        return 0 if status == "completed" else 1
    except RunnerError as error:
        print(f"error: {error}", file=sys.stderr)
        return 2
    except KeyboardInterrupt:
        print("error: benchmark run interrupted", file=sys.stderr)
        return 130
    finally:
        for signum, handler in previous_handlers.items():
            signal.signal(signum, handler)


if __name__ == "__main__":
    raise SystemExit(main())
