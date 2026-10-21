from __future__ import annotations

import json
import re
import os
import shlex
import signal
import subprocess
import sys
import time
import xml.etree.ElementTree as ET
from pathlib import Path

import pytest

from support.prepare_inputs import make_target_spec
from support.define_contracts import BuildResult, BuildState, RunContext
from test_suites import race


@pytest.fixture(autouse=True)
def _isolate_case_timeout(monkeypatch) -> None:
    monkeypatch.delenv(race.CASE_TIMEOUT_ENV, raising=False)


def test_configs_preserve_every_moved_gtest() -> None:
    configs = race.load_target_configs(race.default_config_files())
    expected_counts = {"gfx942": 8, "gfx950": 79, "gfx1151": 29}

    for target, expected_count in expected_counts.items():
        cases = race.discover(make_target_spec(target), configs)
        assert len(cases) == expected_count
        assert {case.metadata["test_filter"] for case in cases} == _source_gtests(
            target
        )
        assert all(
            (
                f"RaceTest.vmem_{target}_{case.metadata['name'].removeprefix('vmem_')}"
                if case.metadata["name"].startswith("vmem_")
                else f"RaceTest.{target}_{case.metadata['name']}"
            )
            in case.selector_names
            for case in cases
        )


@pytest.mark.parametrize("target", ["gfx950", "gfx1151"])
def test_discover_honors_compile_exclusions(tmp_path: Path, target: str) -> None:
    configs = _configs_with_exclusions(
        tmp_path,
        target,
        skip_compile_tests=["vgpr_waitcnt"],
        skip_run_tests=["vgpr_waitcnt_race"],
    )

    cases = race.discover(make_target_spec(target), configs)

    # Run exclusions still need a build, so they remain in discovery.
    assert [case.metadata["name"] for case in cases] == ["vgpr_waitcnt_race"]


@pytest.mark.parametrize("target", ["gfx950", "gfx1151"])
def test_run_honors_run_exclusions(tmp_path: Path, monkeypatch, target: str) -> None:
    configs = _configs_with_exclusions(
        tmp_path, target, skip_run_tests=["vgpr_waitcnt"]
    )
    excluded, control = race.discover(make_target_spec(target), configs)
    base = tmp_path / "base.json"
    _write_base_config(base, target)
    monkeypatch.setenv("ROCJITSU_RACE_CONFIG", str(base))
    context = RunContext(
        repo_root=race.REPO_ROOT,
        artifact_directory=tmp_path / "artifacts",
        skip_all_runs=False,
        run_wrapper="rocjitsu --config {config} --",
    )
    build_result = BuildResult(build_dir=None, executable_path=tmp_path / "race-test")

    def process_launch(*args, **kwargs):
        raise RuntimeError("case reached process launch")

    monkeypatch.setattr(race, "_run_command", process_launch)
    race.run(excluded, build_result, context)
    assert not context.artifact_directory.exists()

    # An exclusion for one case must not suppress an unlisted case.
    with pytest.raises(RuntimeError, match="case reached process launch"):
        race.run(control, build_result, context)


def test_materialize_config_adds_required_race_plugin(tmp_path: Path) -> None:
    base = tmp_path / "base.json"
    output = tmp_path / "case" / "config.json"
    sink = tmp_path / "case" / "plugins"
    output.parent.mkdir()
    sink.mkdir()
    _write_base_config(base, "gfx950", max_ticks=123)

    race._materialize_config(base, output, sink, target="gfx950")

    value = json.loads(output.read_text(encoding="utf-8"))
    assert value["max_ticks"] == 123
    assert value["require_all_plugins"] is True
    assert value["plugins"] == {"race": {}}
    assert value["sinks"] == {"types": ["file"], "dir": str(sink)}


def test_materialize_config_rejects_preconfigured_plugins(tmp_path: Path) -> None:
    base = tmp_path / "base.json"
    output = tmp_path / "config.json"
    sink = tmp_path / "plugins"
    base.write_text('{"plugins": {"logging": {}}}\n', encoding="utf-8")

    with pytest.raises(RuntimeError, match="must not enable plugins or sinks"):
        race._materialize_config(base, output, sink, target="gfx950")


def test_run_wrapper_substitutes_private_config(tmp_path: Path) -> None:
    config = tmp_path / "config.json"
    assert race._run_wrapper_command("rocjitsu --config {config} --", config) == [
        "rocjitsu",
        "--config",
        str(config),
        "--",
    ]


@pytest.mark.parametrize(
    "wrapper",
    ["rocjitsu --config fixed.json --", "rocjitsu {config} {config} --"],
)
def test_run_wrapper_requires_one_config_token(wrapper: str, tmp_path: Path) -> None:
    with pytest.raises(RuntimeError, match="exactly one"):
        race._run_wrapper_command(wrapper, tmp_path / "config.json")


def test_run_can_bind_private_daemon_socket_under_long_artifact_directory(
    tmp_path: Path, monkeypatch
) -> None:
    cases = race.discover(
        make_target_spec("gfx950"),
        race.load_target_configs(race.default_config_files()),
    )[:2]
    base = tmp_path / "base.json"
    _write_base_config(base, "gfx950")
    monkeypatch.setenv("ROCJITSU_RACE_CONFIG", str(base))
    context = RunContext(
        repo_root=race.REPO_ROOT,
        artifact_directory=tmp_path / ("long-artifact-directory-" * 8),
        skip_all_runs=False,
        run_wrapper="rocjitsu --daemon --config {config} --",
    )
    run_command = race._run_command

    def bind_daemon_socket(command, **kwargs):
        # Exercise the OS socket limit in a child with the launcher's cwd and
        # environment. Reusing the socket name also checks case isolation.
        run_command(
            [
                sys.executable,
                "-c",
                "import os, socket; from pathlib import Path; "
                "runtime = Path(os.environ['ROCJITSU_RUNTIME_DIR']) / '1234567'; "
                "runtime.mkdir(); "
                "sock = socket.socket(socket.AF_UNIX); "
                "sock.bind(str(runtime / 'daemon.sock')); sock.close()",
            ],
            **kwargs,
        )
        (Path(kwargs["env"]["RJ_SINK_DIR"]) / "race.log").write_text(
            '[rocjitsu] Kernel dispatch: "test_kernel" symbol="test_kernel"\n'
        )

    monkeypatch.setattr(race, "_run_command", bind_daemon_socket)
    monkeypatch.setattr(race, "_validate_gtest_report", lambda *args: None)
    build_result = BuildResult(build_dir=None, executable_path=tmp_path / "race-test")
    for case in cases:
        race.run(case, build_result, context)


@pytest.mark.parametrize(
    "outcome, error",
    [
        ("passed", None),
        ("copy_only", "did not dispatch a test kernel"),
        ("empty", "exactly one"),
        ("multiple", "exactly one"),
        ("wrong_case", "did not pass the requested case"),
        ("skipped", "did not pass the requested case"),
        ("failed", "did not pass the requested case"),
        ("missing", "Could not read race GoogleTest report"),
        ("malformed", "Could not read race GoogleTest report"),
    ],
)
def test_run_requires_the_requested_gtest_to_pass(
    tmp_path: Path, monkeypatch, outcome: str, error: str | None
) -> None:
    case = race.discover(
        make_target_spec("gfx950"),
        race.load_target_configs(race.default_config_files()),
    )[0]
    base = tmp_path / "base.json"
    _write_base_config(base, "gfx950")
    monkeypatch.setenv("ROCJITSU_RACE_CONFIG", str(base))
    context = RunContext(
        repo_root=race.REPO_ROOT,
        artifact_directory=tmp_path / "artifacts",
        skip_all_runs=False,
        run_wrapper="rocjitsu --config {config} --",
    )
    case_dir = (
        context.artifact_directory
        / "race"
        / case.target
        / "cases"
        / case.metadata["name"]
    )
    case_dir.mkdir(parents=True)
    # A report from an earlier successful run must not hide a missing result.
    (case_dir / "gtest.xml").write_text("stale report", encoding="utf-8")

    def successful_process(command, *, cwd, log_path, phase, env, timeout):
        assert timeout == 30
        assert not (case_dir / "gtest.xml").exists()
        assert cwd == case_dir
        assert command[2] == str(case_dir / "config.json")
        assert f"--gtest_filter={case.metadata['test_filter']}" in command
        assert cwd / env["ROCJITSU_RUNTIME_DIR"] == case_dir / "runtime"
        # A clean runtime copy and passing GoogleTest XML must not substitute
        # for the selected no-race kernel actually being dispatched.
        (Path(env["RJ_SINK_DIR"]) / "race.log").write_text(
            '[rocjitsu] Kernel dispatch: "__amd_rocclr_copyBuffer" symbol="__amd_rocclr_copyBuffer"\n'
            + (
                ""
                if outcome == "copy_only"
                else '[rocjitsu] Kernel dispatch: "test_kernel" symbol="test_kernel"\n'
            )
        )
        if outcome == "missing":
            return
        report_arg = next(arg for arg in command if arg.startswith("--gtest_output="))
        report = Path(report_arg.removeprefix("--gtest_output=xml:"))
        if outcome == "malformed":
            report.write_text("broken XML", encoding="utf-8")
            return
        count = {"empty": 0, "multiple": 2}.get(outcome, 1)
        root = ET.Element(
            "testsuites", tests=str(count), failures="0", errors="0", disabled="0"
        )
        suite = ET.SubElement(root, "testsuite")
        fixture, name = case.metadata["test_filter"].split(".")
        for _ in range(count):
            result = ET.SubElement(
                suite,
                "testcase",
                classname=fixture,
                name="other" if outcome == "wrong_case" else name,
                status="run",
                result="skipped" if outcome == "skipped" else "completed",
            )
            if outcome == "failed":
                ET.SubElement(result, "failure")
        ET.ElementTree(root).write(report)

    monkeypatch.setattr(race, "_run_command", successful_process)
    build_result = BuildResult(build_dir=None, executable_path=tmp_path / "race-test")
    if error:
        with pytest.raises(RuntimeError, match=error):
            race.run(case, build_result, context)
    else:
        race.run(case, build_result, context)


def _configs_with_exclusions(tmp_path: Path, target: str, **exclusions) -> list[dict]:
    path = tmp_path / "target.json"
    path.write_text(
        json.dumps(
            {
                "config_name": target,
                "target": target,
                "cases": ["vgpr_waitcnt", "vgpr_waitcnt_race"],
                **exclusions,
            }
        ),
        encoding="utf-8",
    )
    return race.load_target_configs([str(path)])


def _source_gtests(target: str) -> set[str]:
    layout = race.TARGET_LAYOUT[target]
    sources = [
        race.RACE_SOURCE_DIR / f"hip_race_{target}_test.hip",
        race.RACE_SOURCE_DIR / "hip_race_vmem_test.hip",
    ]
    pattern = re.compile(r"^TEST_F\(([^,]+),\s*([^)]+)\)", re.MULTILINE)
    return {
        f"{fixture.strip()}.{name.strip()}"
        for fixture, name in pattern.findall(
            "\n".join(source.read_text(encoding="utf-8") for source in sources)
        )
        if fixture.strip() in (layout["fixture"], "VmemRaceTest")
    }


@pytest.mark.parametrize(
    "target,base_target",
    [
        ("gfx942", "gfx950"),
        ("gfx942", "gfx1151"),
        ("gfx950", "gfx942"),
        ("gfx950", "gfx1151"),
        ("gfx1151", "gfx942"),
        ("gfx1151", "gfx950"),
    ],
)
def test_mismatched_simulator_target_fails_before_launch(
    tmp_path: Path, monkeypatch, target: str, base_target: str
) -> None:
    case = race.discover(
        make_target_spec(target), race.load_target_configs(race.default_config_files())
    )[0]
    base = tmp_path / "base.json"
    _write_base_config(base, base_target)
    monkeypatch.setenv("ROCJITSU_RACE_CONFIG", str(base))
    context = RunContext(
        repo_root=race.REPO_ROOT,
        artifact_directory=tmp_path / "artifacts",
        skip_all_runs=False,
        run_wrapper="rocjitsu --config {config} --",
    )
    monkeypatch.setattr(
        race,
        "_run_command",
        lambda *args, **kwargs: pytest.fail("launched mismatched target"),
    )
    with pytest.raises(RuntimeError, match=f"does not match {target}"):
        race.run(case, BuildResult(None, tmp_path / "test"), context)


@pytest.mark.parametrize(
    "output,passes",
    [
        ("", False),
        (
            '[rocjitsu] Kernel dispatch: "__amd_rocclr_copyBuffer" symbol="__amd_rocclr_copyBuffer"\n',
            False,
        ),
        ('[rocjitsu] Kernel dispatch: "<unknown>" symbol="<unknown>"\n', False),
        ('[rocjitsu] Kernel dispatch: "?" symbol="?"\n', False),
        (
            '[rocjitsu] Kernel dispatch: "vgpr_no_race_kernel" symbol="_Z19vgpr_no_race_kernelPKfPf"\n',
            True,
        ),
    ],
)
def test_copy_dispatch_alone_cannot_pass(
    tmp_path: Path, output: str, passes: bool
) -> None:
    report = tmp_path / "race.log"
    report.write_text(output)
    if passes:
        race._validate_kernel_dispatch(report)
    else:
        with pytest.raises(RuntimeError, match="did not dispatch a test kernel"):
            race._validate_kernel_dispatch(report)


@pytest.mark.parametrize("prefix", ["", "env "])
def test_relative_launcher_runs_from_private_directory(
    tmp_path: Path, monkeypatch, prefix: str
) -> None:
    repo = tmp_path / "repo"
    repo.mkdir()
    launcher = tmp_path / "launcher"
    launcher.write_text("#!/bin/sh\nprintf '%s\\n' \"$PWD\"\n")
    launcher.chmod(0o755)
    case_dir = tmp_path / "case"
    case_dir.mkdir()
    monkeypatch.setattr(race, "REPO_ROOT", repo)
    command = race._run_wrapper_command(
        prefix + "../launcher {config}", case_dir / "config.json"
    )
    race._run_command(command, cwd=case_dir, log_path=case_dir / "run.log", phase="run")
    assert f"stdout:\n{case_dir}\n" in (case_dir / "run.log").read_text()


@pytest.mark.parametrize("mode", [0o644, 0o755])
@pytest.mark.parametrize("script_path", ["wrapper.py", "./wrapper.py", "../wrapper.py"])
def test_relative_interpreter_script_runs_from_private_directory(
    tmp_path: Path, monkeypatch, mode: int, script_path: str
) -> None:
    repo = tmp_path / "repo"
    repo.mkdir()
    script = repo / script_path
    script.write_text("import os; print(os.getcwd())\n")
    script.chmod(mode)
    case_dir = tmp_path / "case"
    case_dir.mkdir()
    monkeypatch.setattr(race, "REPO_ROOT", repo)
    command = race._run_wrapper_command(
        f"{shlex.quote(sys.executable)} {script_path} {{config}}",
        case_dir / "config.json",
    )
    race._run_command(command, cwd=case_dir, log_path=case_dir / "run.log", phase="run")
    assert f"stdout:\n{case_dir}\n" in (case_dir / "run.log").read_text()


def test_wrapper_only_resolves_existing_file_operands(
    tmp_path: Path, monkeypatch
) -> None:
    monkeypatch.setattr(race, "REPO_ROOT", tmp_path)
    (tmp_path / "input.json").touch()
    (tmp_path / "directory").mkdir()
    command = race._run_wrapper_command(
        "env INPUT=./input.json launcher --input ./input.json "
        "--output=./result.json ./result.json ./directory {config}",
        tmp_path / "private-config.json",
    )
    assert command == [
        "env",
        "INPUT=./input.json",
        "launcher",
        "--input",
        str(tmp_path / "input.json"),
        "--output=./result.json",
        "./result.json",
        "./directory",
        str(tmp_path / "private-config.json"),
    ]


@pytest.mark.timeout(10)
@pytest.mark.parametrize(
    "wrapper_exits,new_session", [(False, False), (True, False), (False, True)]
)
def test_run_cleans_up_sleeping_process_tree(
    tmp_path: Path, monkeypatch, wrapper_exits: bool, new_session: bool
) -> None:
    case = race.discover(
        make_target_spec("gfx950"),
        race.load_target_configs(race.default_config_files()),
    )[0]
    base = tmp_path / "base.json"
    _write_base_config(base, "gfx950")
    monkeypatch.setenv("ROCJITSU_RACE_CONFIG", str(base))
    monkeypatch.setenv(race.CASE_TIMEOUT_ENV, "1")
    wrapper = tmp_path / "sleep.py"
    wrapper.write_text(
        "import os, signal, sys, time\n"
        "from pathlib import Path\n"
        "signal.signal(signal.SIGTERM, signal.SIG_IGN)\n"
        "Path('wrapper.pid').write_text(str(os.getpid()))\n"
        "if os.fork() == 0:\n"
        f"    if {new_session!r}: os.setsid()\n"
        "    Path('child.pid').write_text(str(os.getpid()))\n"
        "    if os.fork() == 0:\n"
        "        Path('grandchild.pid').write_text(str(os.getpid()))\n"
        "    time.sleep(60)\n"
        "    os._exit(0)\n"
        "while not Path('grandchild.pid').exists():\n"
        "    time.sleep(0.01)\n"
        "print('wrapper ready', flush=True)\n"
        "print('partial diagnostic', file=sys.stderr, flush=True)\n"
        + ("sys.exit(0)\n" if wrapper_exits else "time.sleep(60)\n")
    )
    context = RunContext(
        repo_root=race.REPO_ROOT,
        artifact_directory=tmp_path / "artifacts",
        skip_all_runs=False,
        run_wrapper=(
            f"{shlex.quote(sys.executable)} {shlex.quote(str(wrapper))} {{config}}"
        ),
    )
    case_dir = context.artifact_directory / "race/gfx950/cases/vgpr_waitcnt"
    expected = (
        "Could not read race GoogleTest report"
        if wrapper_exits
        else "run timed out after 1s"
    )
    started = time.monotonic()
    try:
        with pytest.raises(RuntimeError, match=expected) as error:
            race.run(case, BuildResult(None, tmp_path / "unused-test"), context)
        assert time.monotonic() - started < 6
        log_path = case_dir / "run.log"
        output = log_path.read_text()
        assert "wrapper ready" in output
        assert "partial diagnostic" in output
        if not wrapper_exits:
            assert str(log_path) in str(error.value)
            assert "partial diagnostic" in str(error.value)
            assert "timed out after 1s" in output
        for name in ("wrapper", "child", "grandchild"):
            pid = int((case_dir / f"{name}.pid").read_text())
            # Orphaned children may remain zombies until init reaps them.
            for _ in range(100):
                if not _process_is_running(pid):
                    break
                time.sleep(0.01)
            assert not _process_is_running(pid), f"{name} survived: {pid}"
    finally:
        # A regression in cleanup must not leave the test's sleepers behind.
        for pid_file in case_dir.glob("*.pid"):
            pid = int(pid_file.read_text())
            if _process_is_running(pid):
                os.kill(pid, signal.SIGKILL)


def _process_is_running(pid: int) -> bool:
    try:
        stat = Path(f"/proc/{pid}/stat").read_text()
    except FileNotFoundError:
        return False
    return stat.rsplit(")", 1)[1].split()[0] != "Z"


def test_build_completion_is_shared_only_within_invocation(
    tmp_path: Path, monkeypatch
) -> None:
    case = race.discover(
        make_target_spec("gfx950"),
        race.load_target_configs(race.default_config_files()),
    )[0]
    context = RunContext(
        repo_root=race.REPO_ROOT, artifact_directory=tmp_path, skip_all_runs=True
    )
    calls = []

    def command(argv, **kwargs):
        calls.append(kwargs["phase"])
        if kwargs["phase"] == "build":
            build_dir = tmp_path / "race-build" / "gfx950" / "build"
            build_dir.mkdir()
            (build_dir / "hip_race_tests_gfx950").touch()

    monkeypatch.delenv("ROCJITSU_RACE_BUILD_ROOT", raising=False)
    monkeypatch.setenv("PYTEST_XDIST_TESTRUNUID", "first")
    monkeypatch.setattr(race, "_run_command", command)
    race.build(case, context, BuildState())
    race.build(case, context, BuildState())
    assert calls == [
        "configure",
        "build",
        "race-log expectation test",
        "HIP fixture error test",
    ]
    monkeypatch.setenv("PYTEST_XDIST_TESTRUNUID", "second")
    # Simulate the existing build directory on the next invocation.
    original = command

    def rebuild(argv, **kwargs):
        if kwargs["phase"] == "build":
            calls.append("build")
        else:
            original(argv, **kwargs)

    monkeypatch.setattr(race, "_run_command", rebuild)
    race.build(case, context, BuildState())
    assert len(calls) == 8


def test_failed_matcher_does_not_stamp_build(tmp_path: Path, monkeypatch) -> None:
    case = race.discover(
        make_target_spec("gfx950"),
        race.load_target_configs(race.default_config_files()),
    )[0]
    monkeypatch.delenv("ROCJITSU_RACE_BUILD_ROOT", raising=False)
    monkeypatch.setenv("PYTEST_XDIST_TESTRUNUID", "failed")

    def fail_matcher(argv, **kwargs):
        if kwargs["phase"] == "race-log expectation test":
            raise RuntimeError("matcher failed")

    monkeypatch.setattr(race, "_run_command", fail_matcher)
    with pytest.raises(RuntimeError, match="matcher failed"):
        race.build(
            case,
            RunContext(
                repo_root=race.REPO_ROOT,
                artifact_directory=tmp_path,
                skip_all_runs=True,
            ),
            BuildState(),
        )
    assert not list(tmp_path.rglob("*.complete"))


@pytest.mark.parametrize(
    "suites,wrapper,extra,error",
    [
        (
            "race,cts",
            "rocjitsu --config {config} --",
            [],
            "Run the race suite separately",
        ),
        ("race", "rocjitsu --config fixed.json --", [], "exactly one standalone"),
        ("race", None, [], "requires --run-wrapper"),
        ("race,cts", None, ["--skip-all-runs"], None),
        ("race,cts", None, ["--collect-only"], None),
    ],
)
def test_entrypoint_validates_execution_before_build(
    tmp_path: Path,
    suites: str,
    wrapper: str | None,
    extra: list[str],
    error: str | None,
) -> None:
    # For build-only runs select an unsupported target: collection is empty,
    # so this exercises option validation without invoking a toolchain.
    target = "gfx950" if error or "--collect-only" in extra else "gfx9999"
    _run_entrypoint(
        tmp_path,
        suites=suites,
        target=target,
        wrapper=wrapper,
        extra=extra,
        error=error,
    )


def _run_entrypoint(
    tmp_path: Path,
    *,
    suites: str,
    target: str,
    wrapper: str | None,
    extra: list[str],
    error: str | None,
) -> None:
    command = [
        sys.executable,
        "-B",
        "-m",
        "pytest",
        "tests/test_corpus.py",
        "-q",
        "-p",
        "no:cacheprovider",
        "--suite",
        suites,
        "--target",
        target,
        "--basetemp",
        str(tmp_path / "temp"),
        *extra,
    ]
    if wrapper is not None:
        command.extend(["--run-wrapper", wrapper])
    result = subprocess.run(
        command,
        cwd=race.REPO_ROOT,
        env=dict(os.environ, PYTHONDONTWRITEBYTECODE="1"),
        capture_output=True,
        text=True,
    )
    if error:
        assert result.returncode == 2
        assert error in result.stdout + result.stderr
        assert "Race test configure failed" not in result.stdout + result.stderr
    else:
        assert result.returncode == 0, result.stdout + result.stderr


def _write_base_config(path: Path, target: str, **fields) -> None:
    version = {"gfx942": 90402, "gfx950": 90500, "gfx1151": 110501}[target]
    path.write_text(
        json.dumps(
            {"vm": {"gpu": {"device": {"gfx_target_version": version}}}, **fields}
        ),
        encoding="utf-8",
    )


@pytest.mark.timeout(15)
@pytest.mark.parametrize(
    "default_timeout,override,expected",
    [
        (5, "1", "run timed out after 1s"),
        (1, "5", None),
    ],
)
def test_run_honors_case_timeout_override(
    tmp_path: Path,
    monkeypatch,
    default_timeout: int,
    override: str,
    expected: str | None,
) -> None:
    case = race.discover(
        make_target_spec("gfx950"),
        race.load_target_configs(race.default_config_files()),
    )[0]
    base = tmp_path / "base.json"
    _write_base_config(base, "gfx950")
    monkeypatch.setenv("ROCJITSU_RACE_CONFIG", str(base))
    # A three-second wrapper must pass when the override extends a shorter
    # default, and time out when the override reduces a longer default.
    monkeypatch.setattr(race, "CASE_TIMEOUT_SECONDS", default_timeout)
    monkeypatch.setenv(race.CASE_TIMEOUT_ENV, override)
    wrapper = tmp_path / "slow.py"
    report_xml = (
        '<testsuites tests="1" failures="0" errors="0" disabled="0">'
        '<testsuite><testcase classname="Gfx950RaceTest" name="vgpr_waitcnt" '
        'status="run" result="completed"/></testsuite></testsuites>'
    )
    race_log = '[rocjitsu] Kernel dispatch: "test_kernel" symbol="test_kernel"\n'
    wrapper.write_text(
        "import sys, time\n"
        "from pathlib import Path\n"
        "time.sleep(3)\n"
        "report = next(arg for arg in sys.argv if arg.startswith('--gtest_output=xml:'))\n"
        f"Path(report.removeprefix('--gtest_output=xml:')).write_text({report_xml!r})\n"
        f"Path('plugins/race.log').write_text({race_log!r})\n"
    )
    context = RunContext(
        repo_root=race.REPO_ROOT,
        artifact_directory=tmp_path / "artifacts",
        skip_all_runs=False,
        run_wrapper=(
            f"{shlex.quote(sys.executable)} {shlex.quote(str(wrapper))} {{config}}"
        ),
    )
    build_result = BuildResult(None, tmp_path / "unused-test")
    if expected:
        with pytest.raises(RuntimeError, match=expected):
            race.run(case, build_result, context)
    else:
        race.run(case, build_result, context)


def test_entrypoint_rejects_invalid_timeout_before_build(
    tmp_path: Path, monkeypatch
) -> None:
    base = tmp_path / "base.json"
    _write_base_config(base, "gfx950")
    monkeypatch.setenv("ROCJITSU_RACE_CONFIG", str(base))
    monkeypatch.setenv(race.CASE_TIMEOUT_ENV, "0")
    _run_entrypoint(
        tmp_path,
        suites="race",
        target="gfx950",
        wrapper="rocjitsu --config {config} --",
        extra=[],
        error=race.CASE_TIMEOUT_ENV,
    )


@pytest.mark.parametrize("value", ["0", "-1", "abc", "nan", "inf"])
def test_case_timeout_override_rejects_invalid_values(monkeypatch, value: str) -> None:
    monkeypatch.setenv(race.CASE_TIMEOUT_ENV, value)
    with pytest.raises(RuntimeError, match=race.CASE_TIMEOUT_ENV):
        race._case_timeout()


def test_case_timeout_defaults_to_thirty_seconds(monkeypatch) -> None:
    monkeypatch.delenv(race.CASE_TIMEOUT_ENV, raising=False)
    assert race._case_timeout() == 30
