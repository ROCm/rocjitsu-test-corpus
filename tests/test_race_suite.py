from __future__ import annotations

import json
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

import pytest

from support.prepare_inputs import make_target_spec
from support.define_contracts import BuildResult, RunContext
from test_suites import race


def test_configs_preserve_every_moved_gtest() -> None:
    configs = race.load_target_configs(race.default_config_files())
    expected_counts = {"gfx950": 45, "gfx1151": 8}

    for target, expected_count in expected_counts.items():
        cases = race.discover(make_target_spec(target), configs)
        assert len(cases) == expected_count
        assert {case.metadata["test_filter"] for case in cases} == _source_gtests(
            target
        )
        assert all(
            f"RaceTest.{target}_{case.metadata['name']}" in case.selector_names
            for case in cases
        )


def test_materialize_config_adds_required_race_plugin(tmp_path: Path) -> None:
    base = tmp_path / "base.json"
    output = tmp_path / "case" / "config.json"
    sink = tmp_path / "case" / "plugins"
    output.parent.mkdir()
    sink.mkdir()
    base.write_text('{"max_ticks": 123, "vm": {}}\n', encoding="utf-8")

    race._materialize_config(base, output, sink)

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
        race._materialize_config(base, output, sink)


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
    base.write_text('{"vm": {}}', encoding="utf-8")
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
        (Path(kwargs["env"]["RJ_SINK_DIR"]) / "race.log").touch()

    monkeypatch.setattr(race, "_run_command", bind_daemon_socket)
    monkeypatch.setattr(race, "_validate_gtest_report", lambda *args: None)
    build_result = BuildResult(build_dir=None, executable_path=tmp_path / "race-test")
    for case in cases:
        race.run(case, build_result, context)


@pytest.mark.parametrize(
    "outcome, error",
    [
        ("passed", None),
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
    base.write_text('{"vm": {}}', encoding="utf-8")
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

    def successful_process(command, *, cwd, log_path, phase, env):
        assert not (case_dir / "gtest.xml").exists()
        assert cwd == case_dir
        assert command[2] == str(case_dir / "config.json")
        assert f"--gtest_filter={case.metadata['test_filter']}" in command
        assert cwd / env["ROCJITSU_RUNTIME_DIR"] == case_dir / "runtime"
        # An empty race log is valid for clean kernels, so it cannot prove
        # that GoogleTest executed the requested test.
        (Path(env["RJ_SINK_DIR"]) / "race.log").touch()
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


def _source_gtests(target: str) -> set[str]:
    layout = race.TARGET_LAYOUT[target]
    source = race.RACE_SOURCE_DIR / f"hip_race_{target}_test.hip"
    pattern = re.compile(r"^TEST_F\(([^,]+),\s*([^)]+)\)", re.MULTILINE)
    return {
        f"{fixture.strip()}.{name.strip()}"
        for fixture, name in pattern.findall(source.read_text(encoding="utf-8"))
        if fixture.strip() == layout["fixture"]
    }
