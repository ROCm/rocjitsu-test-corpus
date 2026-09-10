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
from pathlib import Path
import platform
import re
import signal
import socket
import statistics
import subprocess
import sys
import time
import tomllib
from collections.abc import Mapping, Sequence
from typing import Any, TextIO

BENCHMARK_ROOT = Path(__file__).resolve().parent
CORPUS_ROOT = BENCHMARK_ROOT.parent
WORKLOAD_ROOT = CORPUS_ROOT / "corpus" / "benchmarks"
DEFAULT_MANIFEST = BENCHMARK_ROOT / "suites" / "nightly.toml"
TARGET_CONFIGS = {
    "gfx950": Path("configs") / "gfx950_mi355x_kmd.json",
    "gfx1250": Path("configs") / "gfx1250_mi455x.json",
}
MANIFEST_FIELDS = {
    "name",
    "targets",
    "cases",
    "warmups",
    "samples",
    "num_threads",
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


@dataclasses.dataclass(frozen=True)
class Case:
    id: str
    workload: str
    suite: str
    name: str
    operation: str
    params: dict[str, Any]


@dataclasses.dataclass(frozen=True)
class Suite:
    name: str
    targets: tuple[str, ...]
    cases: tuple[Case, ...]
    warmups: int
    samples: int
    num_threads: int
    timeout_seconds: float


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
    exec_mode: str
    num_threads: int
    config_sha256: str


@dataclasses.dataclass(frozen=True)
class BuildMetadata:
    build_type: str
    rocm_path: Path


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


def load_manifest(path: str | Path = DEFAULT_MANIFEST) -> Suite:
    """Read and validate the intentionally small suite manifest."""

    manifest = Path(path).expanduser().resolve()
    try:
        value = tomllib.loads(manifest.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, tomllib.TOMLDecodeError) as error:
        raise RunnerError(f"cannot read manifest {manifest}: {error}") from error
    fields = set(value)
    if fields != MANIFEST_FIELDS:
        missing = sorted(MANIFEST_FIELDS - fields)
        extra = sorted(fields - MANIFEST_FIELDS)
        raise RunnerError(f"manifest fields differ: missing={missing}, extra={extra}")
    name = value["name"]
    if not isinstance(name, str) or not name:
        raise RunnerError("name must be a non-empty string")
    targets = _string_list(value["targets"], "targets")
    unknown_targets = sorted(set(targets) - set(TARGET_CONFIGS))
    if unknown_targets:
        raise RunnerError(f"unknown targets: {unknown_targets}")
    raw_cases = value["cases"]
    if not isinstance(raw_cases, list) or not raw_cases:
        raise RunnerError("cases must be a non-empty array of tables")
    cases = []
    ids = set()
    case_fields = {"id", "workload", "suite", "name", "operation", "params"}
    for entry in raw_cases:
        if not isinstance(entry, dict) or set(entry) != case_fields:
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
        num_threads=_integer(value["num_threads"], "num_threads", allow_zero=False),
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
    return tuple(
        Cell(case, target) for case in chosen_cases for target in chosen_targets
    )


def prepare_command(
    build_dir: str | Path,
    output: str | Path,
    cell: Cell,
    *,
    rocjitsu_source_dir: str | Path,
    warmups: int,
    samples: int,
    num_threads: int | None = None,
    plugin_profile: str = "none",
) -> PreparedCommand:
    """Construct one shell-free Rocjitsu workload command."""

    build = Path(build_dir).expanduser().resolve()
    output_root = Path(output).expanduser().resolve()
    workload_path = output_root / "cases" / cell.case / cell.target / "workload.json"
    config_path, plugin_reports = _materialize_config(
        output_root,
        cell,
        plugin_profile,
        num_threads=num_threads,
        rocjitsu_source_dir=Path(rocjitsu_source_dir),
    )
    payload = (
        sys.executable,
        str(WORKLOAD_ROOT / "triton" / "workloads.py"),
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
            str(build / "tools" / "rocjitsu" / "rocjitsu"),
            "--config",
            str(config_path),
            "--",
            *payload,
        ),
        cwd=CORPUS_ROOT,
        environment=environment,
        workload_path=workload_path,
        config_path=config_path,
        plugin_reports=plugin_reports,
    )


def _require_file(path: Path, description: str, *, executable: bool = False) -> None:
    if not path.is_file():
        raise RunnerError(f"missing {description}: {path}")
    if executable and not os.access(path, os.X_OK):
        raise RunnerError(f"{description} is not executable: {path}")


def _installed_rocm_path() -> Path:
    spec = importlib.util.find_spec("_rocm_sdk_devel")
    if spec is None or spec.origin is None:
        raise RunnerError("the rocm-sdk-devel package is not installed")
    return Path(spec.origin).resolve().parent


def validate_build(
    build_dir: str | Path,
    matrix: Sequence[Cell],
    *,
    rocjitsu_source_dir: str | Path,
    plugin_profile: str = "none",
) -> BuildMetadata:
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
    _require_file(
        build / "tools" / "rocjitsu" / "rocjitsu", "rocjitsu", executable=True
    )
    for target in {cell.target for cell in matrix}:
        _require_file(
            expected_source / TARGET_CONFIGS[target], f"{target} configuration"
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
    return BuildMetadata(build_type=build_type, rocm_path=rocm_path)


def _load_target_configuration(
    target: str,
    num_threads: int | None = None,
    rocjitsu_source_dir: Path = CORPUS_ROOT,
) -> tuple[dict[str, Any], str]:
    path = rocjitsu_source_dir / TARGET_CONFIGS[target]
    try:
        encoded = path.read_bytes()
        value = json.loads(encoded)
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise RunnerError(
            f"cannot read target configuration {path}: {error}"
        ) from error
    if not isinstance(value, Mapping):
        raise RunnerError(f"target configuration must be a JSON object: {path}")
    result = dict(value)
    # Benchmarks must finish the workload without a simulation tick limit.
    result["max_ticks"] = 0
    if num_threads is not None:
        result["num_threads"] = num_threads
    encoded = (
        json.dumps(result, indent=2, sort_keys=True, allow_nan=False) + "\n"
    ).encode()
    return result, hashlib.sha256(encoded).hexdigest()


def _target_metadata(
    target: str,
    num_threads: int | None = None,
    rocjitsu_source_dir: Path = CORPUS_ROOT,
) -> TargetMetadata:
    path = rocjitsu_source_dir / TARGET_CONFIGS[target]
    value, config_sha256 = _load_target_configuration(
        target, num_threads, rocjitsu_source_dir
    )
    exec_mode = value.get("exec_mode")
    num_threads = value.get("num_threads")
    if not isinstance(exec_mode, str) or not exec_mode:
        raise RunnerError(f"target configuration has invalid exec_mode: {path}")
    if (
        isinstance(num_threads, bool)
        or not isinstance(num_threads, int)
        or num_threads <= 0
    ):
        raise RunnerError(f"target configuration has invalid num_threads: {path}")
    return TargetMetadata(
        exec_mode=exec_mode,
        num_threads=num_threads,
        config_sha256=config_sha256,
    )


def _materialize_config(
    output_root: Path,
    cell: Cell,
    plugin_profile: str,
    *,
    num_threads: int | None = None,
    rocjitsu_source_dir: Path = CORPUS_ROOT,
) -> tuple[Path, dict[str, Path]]:
    try:
        plugins = PLUGIN_PROFILES[plugin_profile]
    except KeyError as error:
        raise RunnerError(f"unknown plugin profile {plugin_profile!r}") from error
    value, _ = _load_target_configuration(cell.target, num_threads, rocjitsu_source_dir)
    if value.get("plugins") or value.get("sinks"):
        raise RunnerError(
            f"benchmark base configuration must not enable plugins or sinks: "
            f"{TARGET_CONFIGS[cell.target]}"
        )

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


def _camel_case(key: str) -> str:
    head, *tail = key.split("_")
    return head + "".join(part[:1].upper() + part[1:] for part in tail)


def _dashboard_value(value: Any) -> Any:
    if isinstance(value, Mapping):
        normalized: dict[str, Any] = {}
        for key, item in value.items():
            if not isinstance(key, str):
                raise RunnerError("workload parameter keys must be strings")
            dashboard_key = _camel_case(key)
            if dashboard_key in normalized:
                raise RunnerError(
                    f"workload parameter keys collide as {dashboard_key!r}"
                )
            normalized[dashboard_key] = _dashboard_value(item)
        return normalized
    if isinstance(value, list):
        return [_dashboard_value(item) for item in value]
    return value


def validate_workload(path: Path, cell: Cell, samples: int) -> dict[str, Any]:
    """Validate and aggregate one workload's small JSON contract."""

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
        "provider": "triton",
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
    median = statistics.median(timings)
    return {
        "durationSeconds": median / 1_000_000_000,
        "timing": {
            "unit": "ns",
            "samples": timings,
            "minimum": min(timings),
            "median": median,
            "maximum": max(timings),
        },
    }


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
    dirty = None
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
    try:
        dirty = bool(
            subprocess.check_output(
                ["git", "status", "--porcelain", "--", "."],
                cwd=source_dir,
                stderr=subprocess.DEVNULL,
                text=True,
            ).strip()
        )
    except (OSError, subprocess.CalledProcessError):
        pass
    return {
        "commit_sha": revision,
        "commit_timestamp": commit_timestamp,
        "dirty": dirty,
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


def _provenance(
    source: Mapping[str, Any], environment: Mapping[str, Any], build: BuildMetadata
) -> dict[str, Any]:
    packages = environment["packages"]
    return {
        "rocjitsuCommitSha": source["commit_sha"],
        "rocjitsuCommitTimestamp": source["commit_timestamp"],
        "dirty": source["dirty"],
        "buildType": build.build_type,
        "rocmSdkPath": str(build.rocm_path),
        "rocmSdkVersion": packages["rocm-sdk-devel"],
        "pythonVersion": environment["python"],
        "torchVersion": packages["torch"],
        "tritonVersion": packages["triton"],
        "tritonCommitSha": None,
        "tensileLiteCommitSha": None,
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
    except BaseException:
        try:
            terminate()
        except BaseException:
            pass
        raise
    return subprocess.CompletedProcess(argv, process.returncode, stdout, stderr)


def _failed_test(
    cell: Cell,
    target: TargetMetadata,
    error: str,
    *,
    config_path: str | None,
    plugin_reports: Mapping[str, str],
) -> dict[str, Any]:
    metadata = cell.definition
    base = f"cases/{cell.case}/{cell.target}"
    return {
        "testId": f"{cell.target}:{cell.case}",
        "logicalTestId": cell.case,
        "suite": metadata.suite,
        "name": metadata.name,
        "target": cell.target,
        "operation": metadata.operation,
        "dataType": metadata.params["dtype"],
        "problem": _dashboard_value(metadata.params),
        "execMode": target.exec_mode,
        "numThreads": target.num_threads,
        "durationSeconds": None,
        "timing": {
            "unit": "ns",
            "samples": [],
            "minimum": None,
            "median": None,
            "maximum": None,
        },
        "status": "failed",
        "exitCode": None,
        "timedOut": False,
        "error": error,
        "artifacts": {
            "workload": f"{base}/workload.json" if config_path else None,
            "stdout": f"{base}/stdout.txt" if config_path else None,
            "stderr": f"{base}/stderr.txt" if config_path else None,
            "config": config_path,
            "pluginReports": dict(plugin_reports),
        },
    }


def run_suite(
    suite: Suite,
    matrix: Sequence[Cell],
    *,
    build_dir: str | Path,
    rocjitsu_source_dir: str | Path,
    output: str | Path,
    warmups: int | None = None,
    samples: int | None = None,
    plugin_profile: str = "none",
    progress: TextIO | None = None,
) -> dict[str, Any]:
    """Run all selected cells, preserving partial results after failures."""

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
    build_metadata = validate_build(
        build, matrix, rocjitsu_source_dir=source_dir, plugin_profile=plugin_profile
    )
    targets = tuple(dict.fromkeys(cell.target for cell in matrix))
    target_metadata = {
        target: _target_metadata(target, suite.num_threads, source_dir)
        for target in targets
    }
    started = time.monotonic()
    timestamp = _utc_now()
    source = _source_info(source_dir)
    corpus = _source_info(CORPUS_ROOT)
    environment = _environment_info()
    output_path.mkdir(parents=True)
    total_cells = len(matrix)
    _progress(
        progress,
        f"START suite={suite.name} cells={total_cells} "
        f"warmups={selected_warmups} samples={selected_samples} "
        f"threads={suite.num_threads} plugin={plugin_profile}",
    )
    run: dict[str, Any] = {
        "schemaVersion": 1,
        "timestamp": timestamp,
        "finishedAt": None,
        "status": "running",
        "wallTimeSeconds": 0.0,
        "benchmarkSuite": suite.name,
        "targets": list(targets),
        "measurement": {
            "warmups": selected_warmups,
            "samples": selected_samples,
            "timeoutSeconds": suite.timeout_seconds,
        },
        "configuration": {
            "id": f"plugins-{plugin_profile}-v1",
            "pluginProfile": plugin_profile,
            "plugins": list(PLUGIN_PROFILES[plugin_profile]),
            "targetConfigSha256": {
                target: target_metadata[target].config_sha256 for target in targets
            },
        },
        "provenance": {
            **_provenance(source, environment, build_metadata),
            "corpusCommitSha": corpus["commit_sha"],
            "corpusCommitTimestamp": corpus["commit_timestamp"],
            "corpusDirty": corpus["dirty"],
        },
        "environment": {
            key: environment[key] for key in ("hostname", "platform", "kernel", "cpu")
        },
        "tests": [
            _failed_test(
                cell,
                target_metadata[cell.target],
                "run interrupted before completion",
                config_path=None,
                plugin_reports={},
            )
            for cell in matrix
        ],
    }
    _write_run(output_path, run)

    try:
        for position, cell in enumerate(matrix, start=1):
            cell_started = time.monotonic()
            _progress(
                progress,
                f"START [{position}/{total_cells}] case={cell.case} "
                f"target={cell.target} provider=triton "
                f"timeout_seconds={suite.timeout_seconds:g}",
            )
            command = prepare_command(
                build,
                output_path,
                cell,
                rocjitsu_source_dir=source_dir,
                warmups=selected_warmups,
                samples=selected_samples,
                num_threads=suite.num_threads,
                plugin_profile=plugin_profile,
            )
            cell_dir = command.workload_path.parent
            (output_path / "cache" / "triton" / cell.target).mkdir(
                parents=True, exist_ok=True
            )
            config_artifact = str(command.config_path.relative_to(output_path))
            plugin_artifacts = {
                plugin: str(path.relative_to(output_path))
                for plugin, path in command.plugin_reports.items()
            }
            stdout = ""
            stderr = ""
            result = _failed_test(
                cell,
                target_metadata[cell.target],
                "workload did not run",
                config_path=config_artifact,
                plugin_reports=plugin_artifacts,
            )
            try:
                completed = _run_command(
                    command.argv,
                    cwd=command.cwd,
                    env=command.environment,
                    timeout=suite.timeout_seconds,
                )
                stdout = _captured_text(completed.stdout)
                stderr = _captured_text(completed.stderr)
                result["exitCode"] = completed.returncode
                if completed.returncode != 0:
                    raise RunnerError(
                        f"command exited with status {completed.returncode}"
                    )
                aggregate = validate_workload(
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
                result.update(aggregate)
                result["status"] = "completed"
                result["error"] = None
            except subprocess.TimeoutExpired as error:
                stdout = _captured_text(error.stdout)
                stderr = _captured_text(error.stderr)
                result["status"] = "timeout"
                result["timedOut"] = True
                result["error"] = (
                    f"command timed out after {suite.timeout_seconds:g} seconds"
                )
            except (OSError, RunnerError) as error:
                result["error"] = str(error)
            if not command.workload_path.is_file():
                result["artifacts"]["workload"] = None
            (cell_dir / "stdout.txt").write_text(stdout, encoding="utf-8")
            (cell_dir / "stderr.txt").write_text(stderr, encoding="utf-8")
            run["tests"][position - 1] = result
            run["wallTimeSeconds"] = time.monotonic() - started
            _write_run(output_path, run)
            detail = ""
            if result["status"] == "completed":
                detail = f" median_ns={result['timing']['median']}"
            _progress(
                progress,
                f"DONE  [{position}/{total_cells}] case={cell.case} "
                f"target={cell.target} status={result['status']} "
                f"elapsed_seconds={time.monotonic() - cell_started:.1f}{detail}",
            )
    except BaseException:
        run["status"] = "failed"
        run["finishedAt"] = _utc_now()
        run["wallTimeSeconds"] = time.monotonic() - started
        _write_run(output_path, run)
        _progress(
            progress,
            f"ABORT suite={suite.name} "
            f"completed={sum(test['status'] == 'completed' for test in run['tests'])}/{total_cells} "
            f"elapsed_seconds={run['wallTimeSeconds']:.1f}",
        )
        raise

    run["status"] = (
        "completed"
        if all(item["status"] == "completed" for item in run["tests"])
        else "failed"
    )
    run["finishedAt"] = _utc_now()
    run["wallTimeSeconds"] = time.monotonic() - started
    _write_run(output_path, run)
    status_counts = {
        status: sum(test["status"] == status for test in run["tests"])
        for status in ("completed", "failed", "timeout")
    }
    _progress(
        progress,
        f"DONE suite={suite.name} status={run['status']} "
        f"completed={status_counts['completed']} failed={status_counts['failed']} "
        f"timeout={status_counts['timeout']} "
        f"elapsed_seconds={run['wallTimeSeconds']:.1f}",
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
        ):
            raise RunnerError(
                "--rocjitsu-source-dir, --build-dir and --output are required unless --list is used"
            )
        run = run_suite(
            suite,
            matrix,
            build_dir=arguments.build_dir,
            rocjitsu_source_dir=arguments.rocjitsu_source_dir,
            output=arguments.output,
            warmups=arguments.warmups,
            samples=arguments.samples,
            plugin_profile=arguments.plugin_profile,
            progress=sys.stdout,
        )
        artifact = arguments.output.expanduser().resolve() / "run.json"
        print(f"run {run['status']}: {artifact}")
        return 0 if run["status"] == "completed" else 1
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
