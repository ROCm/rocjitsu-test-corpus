"""RocJITsu race-detector HIP integration suite.

The integration programs preserve the original functional and race assertions,
check HIP operations, and run through a caller-supplied RocJITsu wrapper. Each
filtered test gets a private plugin config and sink directory. The race plugin
reports LDS races; register hazards come from the simulator core's memory-wait
diagnostics, which each case's config entry predicts. The standalone mutation
kernels in corpus/race/kernels are outside this suite.
"""

from __future__ import annotations

import json
import math
import os
import re
import shlex
import shutil
import signal
import subprocess
import tempfile
import xml.etree.ElementTree as ET
from pathlib import Path

from filelock import FileLock

from support.define_contracts import (
    BuildResult,
    BuildState,
    CorpusCase,
    RunContext,
    TargetSpec,
)
from support.prepare_inputs import load_suite_target_configs, supports_target

REPO_ROOT = Path(__file__).resolve().parents[2]
RACE_SOURCE_DIR = REPO_ROOT / "corpus" / "race" / "integration"
CONFIGS_ROOT = RACE_SOURCE_DIR / "configs"
CASE_TIMEOUT_SECONDS = 30
CASE_TIMEOUT_ENV = "ROCJITSU_RACE_CASE_TIMEOUT"
MEMORY_WAIT_ACCESSES = ("read", "overwrite")
MEMORY_WAIT_REGISTERS = ("VGPR", "SGPR", "TTMP")
MEMORY_WAIT_COUNTERS = ("vmcnt", "vscnt", "lgkmcnt", "expcnt")
# For example: "[rj warn] memory-wait: soc.xcd0.se0.cu0 wg=0 wave=0 pc=0x...:
# read of v8 before memory result from pc=0x... is known ready (vmcnt). ..."
_MEMORY_WAIT_DIAGNOSTIC = re.compile(r"\bmemory-wait: (.*)")
_MEMORY_WAIT_HAZARD = re.compile(
    r"\S+ wg=\S+ wave=\S+ pc=0x[0-9a-fA-F]+: (read|overwrite) of ([a-z_]+)\d* "
    r"before memory result from pc=0x[0-9a-fA-F]+ is known ready \((\w+)\)"
)
_MEMORY_WAIT_SUPPRESSED = "further diagnostics on this CU are suppressed"
_REGISTER_CLASSES = {"v": "VGPR", "s": "SGPR", "ttmp": "TTMP"}
TARGET_LAYOUT = {
    "gfx942": {
        "binary": "hip_race_tests_gfx942",
        "fixture": "VmemRaceTest",
    },
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
    configs = load_suite_target_configs(
        config_files,
        repo_root=REPO_ROOT,
        required_fields=("cases",),
        allowed_fields=("cases", "memory_wait"),
    )
    for config in configs:
        cases = config["cases"]
        if (
            not isinstance(cases, list)
            or not cases
            or any(not isinstance(case, str) or not case for case in cases)
        ):
            raise ValueError(
                f"{config['_path']} field 'cases' must contain non-empty strings"
            )
        if len(cases) != len(set(cases)):
            raise ValueError(f"{config['_path']} field 'cases' contains duplicates")
        _validate_memory_wait_expectations(config)
    return configs


def _validate_memory_wait_expectations(config: dict) -> None:
    expectations = config.get("memory_wait", {})
    if not isinstance(expectations, dict):
        raise ValueError(
            f"{config['_path']} field 'memory_wait' must map case names to expectations"
        )
    for name, expected in expectations.items():
        if name not in config["cases"]:
            raise ValueError(
                f"{config['_path']} field 'memory_wait' names unknown case {name!r}"
            )
        if (
            not isinstance(expected, dict)
            or set(expected) != {"access", "register", "counter", "count"}
            or expected["access"] not in MEMORY_WAIT_ACCESSES
            or expected["register"] not in MEMORY_WAIT_REGISTERS
            or expected["counter"] not in MEMORY_WAIT_COUNTERS
            or not (
                expected["count"] == "capped"
                or (type(expected["count"]) is int and expected["count"] > 0)
            )
        ):
            raise ValueError(
                f"{config['_path']} field 'memory_wait' entry {name!r} must have an "
                f"'access' in {MEMORY_WAIT_ACCESSES}, a 'register' in "
                f"{MEMORY_WAIT_REGISTERS}, a 'counter' in {MEMORY_WAIT_COUNTERS}, "
                "and a 'count' that is a positive integer or 'capped'"
            )


def discover(target: TargetSpec, target_configs: list[dict]) -> list[CorpusCase]:
    discovered: list[CorpusCase] = []
    for target_config in target_configs:
        if not supports_target(target, target_config):
            continue
        layout = TARGET_LAYOUT.get(target.target)
        if layout is None:
            continue
        for name in target_config["cases"]:
            if name in target_config.get("skip_compile_tests", []):
                continue
            test_filter = (
                f"VmemRaceTest.{name.removeprefix('vmem_')}"
                if name.startswith("vmem_")
                else f"{layout['fixture']}.{name}"
            )
            legacy_name = (
                f"RaceTest.vmem_{target.target}_{name.removeprefix('vmem_')}"
                if name.startswith("vmem_")
                else f"RaceTest.{target.target}_{name}"
            )
            discovered.append(
                CorpusCase(
                    id=f"race.{target.target}.{name}",
                    suite="race",
                    target=target.target,
                    collection="rocjitsu",
                    backend=None,
                    path=Path(target_config["_path"]),
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
                        "memory_wait": target_config.get("memory_wait", {}).get(name),
                    },
                    selector_names=(test_filter, legacy_name),
                )
            )
    return discovered


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
    executable = build_dir / layout["binary"]
    run_uid = os.getenv("PYTEST_XDIST_TESTRUNUID", f"pid-{os.getpid()}")
    completion_stamp = build_root / f"{run_uid}.complete"

    with FileLock(build_root / ".build.lock"):
        if not completion_stamp.exists():
            _build_programs(case, context, build_dir, logs_dir)
            if not executable.is_file():
                raise RuntimeError(f"Race test build did not produce {executable}")
            completion_stamp.touch()

    if not executable.is_file():
        raise RuntimeError(f"Race test build did not produce {executable}")
    return BuildResult(
        build_dir=build_dir,
        executable_path=executable,
        metadata={"logs_dir": str(logs_dir), "completion_stamp": str(completion_stamp)},
    )


def _build_programs(
    case: CorpusCase, context: RunContext, build_dir: Path, logs_dir: Path
) -> None:
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
            TARGET_LAYOUT[case.target]["binary"],
            "race_log_expectation_test",
            "race_test_support_test",
            "--parallel",
            os.getenv("CMAKE_BUILD_PARALLEL_LEVEL", str(context.worker_count)),
        ],
        cwd=REPO_ROOT,
        log_path=logs_dir / "build.log",
        phase="build",
    )
    _run_command(
        [str(build_dir / "race_log_expectation_test"), "--gtest_brief=1"],
        cwd=REPO_ROOT,
        log_path=logs_dir / "race_log_expectation_test.log",
        phase="race-log expectation test",
    )
    _run_command(
        [str(build_dir / "race_test_support_test"), "--gtest_brief=1"],
        cwd=REPO_ROOT,
        log_path=logs_dir / "race_test_support_test.log",
        phase="HIP fixture error test",
    )


def run(case: CorpusCase, build_result: BuildResult, context: RunContext) -> None:
    target_config = case.metadata["target_config"]
    if context.skip_all_runs or (
        case.metadata["name"] in target_config.get("skip_run_tests", [])
    ):
        return
    if build_result.executable_path is None:
        raise RuntimeError("Race test executable is unavailable")

    timeout = _case_timeout()
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
    _materialize_config(base_config, config_path, sink_dir, target=case.target)
    gtest_report = case_dir / "gtest.xml"
    command = [
        *_run_wrapper_command(context.run_wrapper, config_path),
        str(build_result.executable_path),
        f"--gtest_filter={case.metadata['test_filter']}",
        f"--gtest_output=xml:{gtest_report}",
    ]
    environment = dict(os.environ)
    environment["RJ_SINK_DIR"] = str(sink_dir)
    # Each case runs from its own directory. Keep the socket path relative so
    # runtime/<pid>/daemon.sock fits even under a long artifact directory.
    environment["ROCJITSU_RUNTIME_DIR"] = "runtime"
    log_path = case_dir / "run.log"
    stderr = _run_command(
        command,
        cwd=case_dir,
        log_path=log_path,
        phase="run",
        env=environment,
        timeout=timeout,
    )
    _validate_gtest_report(gtest_report, case.metadata["test_filter"])
    report = sink_dir / "race.log"
    if not report.is_file():
        raise RuntimeError(f"Race test did not produce {report}")
    _validate_kernel_dispatch(report)
    _validate_memory_wait(
        stderr, case.metadata["memory_wait"], case.metadata["test_filter"], log_path
    )


def validate_execution(run_wrapper: str | None, target: str) -> None:
    """Check launcher/config requirements before building execution cases."""
    _run_wrapper_command(run_wrapper, Path("/private/config.json"))
    _load_base_config(_base_config_path(), target=target)
    _case_timeout()


def _validate_kernel_dispatch(path: Path) -> None:
    # HIP copies can dispatch successfully even when no test code object
    # matches the simulator. They do not establish integration coverage.
    dispatch = re.compile(r'^\[rocjitsu\] Kernel dispatch: "([^"]+)" symbol="([^"]+)"$')
    with path.open(encoding="utf-8") as log:
        for line in log:
            match = dispatch.fullmatch(line.rstrip("\n"))
            if match and all(
                name not in ("?", "unknown", "<unknown>")
                and not name.startswith("__amd_rocclr_")
                for name in match.groups()
            ):
                return
    raise RuntimeError(f"Race test did not dispatch a test kernel: {path}")


def _memory_wait_findings(stderr: str) -> list[tuple[str, tuple | str | None]]:
    """Return each memory-wait line with its (access, register class, counter).

    A per-CU suppression notice keeps its text as the kind, so only capped
    expectations accept it. The kind is None for a line this parser does not
    recognize, so a changed diagnostic format fails every case instead of
    passing the no-finding cases.
    """
    findings = []
    for line in stderr.splitlines():
        diagnostic = _MEMORY_WAIT_DIAGNOSTIC.search(line)
        if diagnostic is None:
            continue
        hazard = _MEMORY_WAIT_HAZARD.match(diagnostic.group(1))
        kind = None
        if diagnostic.group(1) == _MEMORY_WAIT_SUPPRESSED:
            kind = _MEMORY_WAIT_SUPPRESSED
        elif hazard:
            access, register, counter = hazard.groups()
            kind = (access, _REGISTER_CLASSES.get(register), counter)
        findings.append((line, kind))
    return findings


def _validate_memory_wait(
    stderr: str, expected: dict | None, test_filter: str, log_path: Path
) -> None:
    # Every finding must be the expected hazard, and the case must print the
    # expected number of them. Capped cases instead reach the core's per-CU limit
    # by design, so their totals and suppression notices are not checked. Cases
    # without an expectation must have none, which also guards against core
    # false positives.
    findings = _memory_wait_findings(stderr)
    if expected is None:
        if not findings:
            return
        problem = "expected no memory-wait diagnostics"
    else:
        kind = (expected["access"], expected["register"], expected["counter"])
        capped = expected["count"] == "capped"
        kinds = [
            found
            for _, found in findings
            if not (capped and found == _MEMORY_WAIT_SUPPRESSED)
        ]
        if (
            kinds
            and all(found == kind for found in kinds)
            and (capped or len(kinds) == expected["count"])
        ):
            return
        problem = (
            f"expected memory-wait diagnostics only for {kind[0]} of {kind[1]} "
            f"({kind[2]})"
        )
        if not capped:
            problem += f", {expected['count']} in total"
    raise RuntimeError(
        "\n".join(
            [
                f"Race test {test_filter} {problem}.",
                f"log: {log_path}",
                "memory-wait diagnostics:",
                *([line for line, _ in findings] or ["<none>"]),
            ]
        )
    )


def _validate_gtest_report(path: Path, expected_filter: str) -> None:
    # GoogleTest exits successfully when a filter matches no tests, or when a
    # test skips. Neither result exercises the assertion this corpus case owns.
    try:
        root = ET.parse(path).getroot()
    except (OSError, ET.ParseError) as error:
        raise RuntimeError(
            f"Could not read race GoogleTest report {path}: {error}"
        ) from error
    cases = root.findall("./testsuite/testcase")
    if root.get("tests") != "1" or len(cases) != 1:
        raise RuntimeError(
            f"Expected exactly one GoogleTest case for {expected_filter}: {path}"
        )
    case = cases[0]
    actual_filter = f"{case.get('classname')}.{case.get('name')}"
    if (
        actual_filter != expected_filter
        or case.get("status") != "run"
        or case.get("result") != "completed"
        or case.find("failure") is not None
        or case.find("error") is not None
        or case.find("skipped") is not None
        or any(root.get(field) != "0" for field in ("failures", "errors", "disabled"))
    ):
        raise RuntimeError(
            f"GoogleTest did not pass the requested case {expected_filter}: {path}"
        )


def _build_root(context: RunContext) -> Path:
    if configured := os.getenv("ROCJITSU_RACE_BUILD_ROOT"):
        return Path(configured).expanduser().resolve()
    return context.artifact_directory / "race-build"


def _case_timeout() -> float:
    """Return the per-case run deadline, allowing ``CASE_TIMEOUT_ENV`` to override it."""
    configured = os.getenv(CASE_TIMEOUT_ENV)
    if not configured:
        return CASE_TIMEOUT_SECONDS
    try:
        timeout = float(configured)
    except ValueError:
        timeout = 0.0
    if not math.isfinite(timeout) or timeout <= 0:
        raise RuntimeError(f"{CASE_TIMEOUT_ENV} must be a positive number of seconds")
    return timeout


def _base_config_path() -> Path:
    configured = os.getenv("ROCJITSU_RACE_CONFIG")
    if not configured:
        raise RuntimeError("ROCJITSU_RACE_CONFIG must name the base simulator config")
    path = Path(configured).expanduser().resolve()
    if not path.is_file():
        raise RuntimeError(f"Race simulator config does not exist: {path}")
    return path


def _load_base_config(base_path: Path, *, target: str) -> dict:
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
    if value.get("wait_checking") == "off":
        raise RuntimeError(
            "Race simulator base config must not disable wait checking, which "
            f"reports the register hazards: {base_path}"
        )
    try:
        version = value["vm"]["gpu"]["device"]["gfx_target_version"]
    except (KeyError, TypeError) as error:
        raise RuntimeError(
            f"Race simulator config must specify vm.gpu.device.gfx_target_version: {base_path}"
        ) from error
    # KFD encodes gfx950 as 9.5.0 -> 90500, gfx1151 as 11.5.1 -> 110501.
    digits = target.removeprefix("gfx")
    expected = int(digits[:-2]) * 10000 + int(digits[-2]) * 100 + int(digits[-1])
    if type(version) is not int or version != expected:
        raise RuntimeError(
            f"Race simulator target {version!r} does not match {target} "
            f"(gfx_target_version={expected}): {base_path}"
        )
    return value


def _materialize_config(
    base_path: Path, output_path: Path, sink_dir: Path, *, target: str
) -> None:
    value = _load_base_config(base_path, target=target)
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
    wrapper = [
        str(config_path) if argument == "{config}" else argument for argument in wrapper
    ]
    # The private cwd keeps daemon sockets short. Resolve launcher paths and
    # existing file operands (including interpreter scripts) against the repo.
    # Options and environment assignments are not parsed as paths.
    for index, argument in enumerate(wrapper):
        if Path(argument).is_absolute() or argument.startswith("-") or "=" in argument:
            continue
        path = REPO_ROOT / argument
        if (index == 0 and os.sep in argument) or (index > 0 and path.is_file()):
            wrapper[index] = str(path.resolve())
    return wrapper


def _run_command(
    command: list[str],
    *,
    cwd: Path,
    log_path: Path,
    phase: str,
    env: dict[str, str] | None = None,
    timeout: float | None = None,
) -> str:
    """Run a phase, record its output in log_path, and return its stderr."""
    executable = command[0]
    if os.sep not in executable:
        resolved = shutil.which(executable)
        if resolved is None:
            raise RuntimeError(f"Missing required tool {executable!r}")
        command = [resolved, *command[1:]]
    timed_out = False
    # File-backed output avoids waiting on pipes inherited by grandchildren.
    # The run phase owns a process tree so expiry also stops the simulator
    # and HIP children, including ones that ignore SIGTERM.
    with (
        tempfile.TemporaryFile(mode="w+", encoding="utf-8", errors="replace") as stdout,
        tempfile.TemporaryFile(mode="w+", encoding="utf-8", errors="replace") as stderr,
    ):
        process = subprocess.Popen(
            command,
            cwd=str(cwd),
            env=env,
            stdout=stdout,
            stderr=stderr,
            start_new_session=timeout is not None,
        )
        try:
            process.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            timed_out = True
        finally:
            if timeout is not None:
                # Clean up surviving children even if the wrapper has exited.
                _kill_process_tree(process.pid)
                try:
                    process.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    timed_out = True
        stdout.seek(0)
        stderr.seek(0)
        output = stdout.read()
        errors = stderr.read()
    status = f"timed out after {timeout:g}s" if timed_out else "failed"
    log_path.parent.mkdir(parents=True, exist_ok=True)
    log_path.write_text(
        "\n".join(
            [
                "$ " + " ".join(shlex.quote(part) for part in command),
                f"cwd: {cwd}",
                f"returncode: {process.returncode}",
                *([status] if timed_out else []),
                "",
                "stdout:",
                output,
                "",
                "stderr:",
                errors,
            ]
        ),
        encoding="utf-8",
    )
    if timed_out or process.returncode != 0:
        raise RuntimeError(
            "\n".join(
                [
                    f"Race test {phase} {status}.",
                    f"log: {log_path}",
                    "command: " + " ".join(shlex.quote(part) for part in command),
                    f"returncode: {process.returncode}",
                    "stdout:",
                    output or "<empty>",
                    "stderr:",
                    errors or "<empty>",
                ]
            )
        )
    return errors


def _kill_process_tree(pid: int) -> None:
    # Some CI wrappers create a nested session. Capture its process group
    # before killing the launcher, which would reparent those descendants.
    # Inspect every thread: a simulator worker can also have child processes.
    groups = {pid: None}
    pending = [pid]
    seen = set()
    while pending:
        child = pending.pop()
        if child in seen:
            continue
        seen.add(child)
        try:
            group = os.getpgid(child)
        except ProcessLookupError:
            continue
        groups[group] = None
        for children in Path(f"/proc/{child}/task").glob("*/children"):
            try:
                pending.extend(int(value) for value in children.read_text().split())
            except FileNotFoundError:
                continue
    # Kill descendant groups first, while their supervising parents still
    # exist. The original group also covers children whose wrapper exited.
    for group in reversed(groups):
        try:
            os.killpg(group, signal.SIGKILL)
        except ProcessLookupError:
            pass
