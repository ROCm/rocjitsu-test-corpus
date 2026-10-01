"""Manifest and process-boundary regressions; fake executables require no GPU."""

from pathlib import Path
import json
import time

import pytest

from support.define_contracts import BuildResult, CorpusCase, RunContext, TargetSpec
from test_suites import runtime_torture as suite


def manifest(tmp_path, extra="", args='["--mode", "pm4"]'):
    path = tmp_path / "cases.toml"
    path.write_text(
        f'[[case]]\nid="sample"\nbinary="sample_gfx1250"\nargs={args}\n{extra}'
    )
    return path


def test_multiple_invocations_and_defaults(tmp_path):
    path = manifest(tmp_path)
    path.write_text(
        "[defaults]\ntimeout_seconds=12\n"
        + path.read_text()
        + '\n[[case]]\nid="other"\nbinary="sample_gfx1250"\nargs=["--mode","aql"]\ntimeout_seconds=4\n'
    )
    rows = suite.load_manifest(path)
    assert [r["timeout_seconds"] for r in rows] == [12, 4]
    assert rows[0]["binary"] == rows[1]["binary"]
    suite.validate_inventory(rows, rows[:1], {"sample_gfx1250"})


@pytest.mark.parametrize(
    "extra",
    [
        'status="INVESTIGATE"',
        'status="SKIP"',
        "timeout_seconds=0",
        "timeout_seconds=nan",
        "timeout_seconds=true",
        "typo=1",
        'status="XFAIL"\nreason="bug"',
        'status="XFAIL"\nreason="bug"\nexpected_exit_code=124\nexpected_output="watchdog"',
        "expected_exit_code=1",
    ],
)
def test_reject_bad_policy(tmp_path, extra):
    with pytest.raises(ValueError):
        suite.load_manifest(manifest(tmp_path, extra))


@pytest.mark.parametrize("args", ['"--mode pm4"', "[1]", '["\\u0000"]'])
def test_reject_bad_args(tmp_path, args):
    with pytest.raises(ValueError):
        suite.load_manifest(manifest(tmp_path, args=args))


def test_duplicate_and_path_names(tmp_path):
    path = manifest(tmp_path)
    text = path.read_text()
    path.write_text(text + text)
    with pytest.raises(ValueError, match="Duplicate"):
        suite.load_manifest(path)
    path.write_text(text.replace("sample_gfx1250", "../sample"))
    with pytest.raises(ValueError, match="simple"):
        suite.load_manifest(path)


def test_missing_default_and_unknown_custom():
    rows = [{"binary": "a"}]
    with pytest.raises(ValueError, match="missing default entries=\\['b'\\]"):
        suite.validate_inventory(rows, rows, {"a", "b"})
    with pytest.raises(ValueError, match="unknown selected binaries=\\['typo'\\]"):
        suite.validate_inventory(rows, [{"binary": "typo"}], {"a"})


def test_custom_subset_still_checks_default_coverage(tmp_path, monkeypatch):
    root = tmp_path / "corpus" / "gfx1250"
    root.mkdir(parents=True)
    source = manifest(tmp_path)
    (root / "cases.toml").write_text(source.read_text())
    monkeypatch.setattr(suite, "ROOT", root.parent)
    binary = tmp_path / "sample_gfx1250"
    binary.write_text("#!/bin/sh\nexit 0\n")
    binary.chmod(0o755)
    inv = tmp_path / "runtime-torture-gfx1250-targets.txt"
    inv.write_text("sample_gfx1250\n")
    cases = suite.discover(
        TargetSpec("gfx1250"), binary_dir=str(tmp_path), cases_config=str(source)
    )
    assert len(cases) == 1
    inv.write_text("sample_gfx1250\nforgotten_gfx1250\n")
    with pytest.raises(ValueError, match="forgotten_gfx1250"):
        suite.discover(
            TargetSpec("gfx1250"), binary_dir=str(tmp_path), cases_config=str(source)
        )


def test_xfail_signature():
    row = dict(status="XFAIL", expected_exit_code=1, expected_output="specific defect")
    assert suite.classify(row, 1, False, "specific defect") == "XFAIL"
    assert suite.classify(row, -11, False, "specific defect") == "FAIL"
    assert suite.classify(row, 1, False, "unrelated defect") == "FAIL"
    assert suite.classify(row, 0, False, "specific defect") == "XPASS"
    assert suite.classify(row, 124, False, "specific defect") == "TIMEOUT"
    assert suite.classify(row, -9, True, "specific defect") == "TIMEOUT"


def fake_case(tmp_path, script, **overrides):
    binary = tmp_path / "fake"
    binary.write_text("#!/bin/sh\n" + script)
    binary.chmod(0o755)
    row = dict(
        id="fake", binary="fake", args=[], status="", timeout_seconds=2, **overrides
    )
    case = CorpusCase(
        "runtime-torture.gfx1250.fake",
        "runtime-torture",
        "gfx1250",
        None,
        None,
        tmp_path,
        {},
        row,
        {},
    )
    context = RunContext(tmp_path, tmp_path / "artifacts", False)
    build = BuildResult(tmp_path, binary, {})
    return case, build, context


def test_run_literal_args_and_result(tmp_path):
    case, build, context = fake_case(tmp_path, 'printf "%s\\n" "$1"\n')
    case.run["args"] = ["$(touch SHOULD_NOT_EXIST)"]
    suite.run(case, build, context)
    assert not (Path.cwd() / "SHOULD_NOT_EXIST").exists()
    record = json.loads(
        (context.artifact_directory / "runtime-torture/gfx1250/fake.json").read_text()
    )
    assert record["status"] == "PASS"
    assert record["command"][-1] == case.run["args"][0]


def test_skip_never_launches(tmp_path):
    case, build, context = fake_case(tmp_path, "exit 99\n")
    case.run.update(status="SKIP", reason="investigate")
    with pytest.raises(pytest.skip.Exception, match="investigate"):
        suite.run(case, build, context)
    assert not context.artifact_directory.exists()


def test_xfail_matches_output_not_command(tmp_path):
    case, build, context = fake_case(tmp_path, "echo other; exit 1\n")
    case.run.update(
        status="XFAIL",
        reason="bug",
        expected_exit_code=1,
        expected_output="signature",
        args=["signature"],
    )
    with pytest.raises(pytest.fail.Exception):
        suite.run(case, build, context)
    build.executable_path.write_text("#!/bin/sh\necho signature; exit 1\n")
    with pytest.raises(suite.ExpectedFailure):
        suite.run(case, build, context)


def test_timeout_kills_descendants(tmp_path):
    child = tmp_path / "child.pid"
    case, build, context = fake_case(
        tmp_path, f'sleep 30 &\necho $! > "{child}"\nwait\n'
    )
    case.run["timeout_seconds"] = 0.2
    started = time.monotonic()
    with pytest.raises(pytest.fail.Exception, match="TIMEOUT"):
        suite.run(case, build, context)
    assert time.monotonic() - started < 7
    pid = int(child.read_text())
    stat = Path(f"/proc/{pid}/stat")
    if stat.exists():
        assert stat.read_text().split()[2] == "Z"  # Killed, awaiting init's reap.


@pytest.mark.parametrize(
    "first_args,status,expectations,summary,returncode",
    [
        (
            '["fail"]',
            "XFAIL",
            'expected_exit_code=1\nexpected_output="known defect"',
            "1 passed, 1 xfailed",
            0,
        ),
        (
            "[]",
            "XFAIL",
            'expected_exit_code=1\nexpected_output="known defect"',
            "XPASS(strict)",
            1,
        ),
        (
            '["wrong"]',
            "XFAIL",
            'expected_exit_code=1\nexpected_output="known defect"',
            "1 failed",
            1,
        ),
        ('["fail"]', "SKIP", "", "1 passed, 1 skipped", 0),
    ],
)
def test_pytest_adapter_status_and_failfast(
    tmp_path, first_args, status, expectations, summary, returncode
):
    import shutil
    import subprocess
    import sys

    repo = Path(__file__).resolve().parents[1]
    binary = tmp_path / "packet_flood_gfx1250"
    binary.write_text(
        '#!/bin/sh\ncase "$1" in fail) echo "known defect"; exit 1;; wrong) echo other; exit 1;; esac\nexit 0\n'
    )
    binary.chmod(0o755)
    (tmp_path / "runtime-torture-gfx1250-targets.txt").write_text(binary.name + "\n")
    config = tmp_path / "custom.toml"
    config.write_text(f'''[[case]]
id="first"
binary="{binary.name}"
args={first_args}
status="{status}"
reason="test failure policy"
{expectations}

[[case]]
id="second"
binary="{binary.name}"
''')
    artifacts = repo / ".pytest-artifacts" / ("runner-unit-" + tmp_path.name)
    try:
        result = subprocess.run(
            [
                sys.executable,
                "-m",
                "pytest",
                "tests/test_corpus.py",
                "--suite",
                "runtime-torture",
                "--target",
                "gfx1250",
                "--binary-dir",
                str(tmp_path),
                "--cases-config",
                str(config),
                "--artifact-directory",
                str(artifacts),
                "-q",
                "-ra",
            ],
            cwd=repo,
            capture_output=True,
            text=True,
            timeout=20,
        )
        output = result.stdout + result.stderr
        assert result.returncode == returncode, output
        assert summary in output
        assert (artifacts / "runtime-torture/gfx1250/second.json").exists() == (
            returncode == 0
        )
    finally:
        shutil.rmtree(artifacts, ignore_errors=True)


def test_unavailable_wrapper_rejected_before_discovery(tmp_path):
    with pytest.raises(ValueError, match="wrapper executable is unavailable"):
        suite.discover(
            TargetSpec("gfx1250"),
            binary_dir=str(tmp_path),
            cases_config=None,
            run_wrapper="/nonexistent/runtime-torture-wrapper",
        )


def test_custom_subset_requires_helper_binaries(tmp_path, monkeypatch):
    root = tmp_path / "corpus" / "gfx1250"
    root.mkdir(parents=True)
    source = manifest(tmp_path)
    defaults = source.read_text() + '\n[[case]]\nid="helper"\nbinary="helper_gfx1250"\n'
    (root / "cases.toml").write_text(defaults)
    monkeypatch.setattr(suite, "ROOT", root.parent)
    binary = tmp_path / "sample_gfx1250"
    binary.write_text("#!/bin/sh\nexit 0\n")
    binary.chmod(0o755)
    (tmp_path / "runtime-torture-gfx1250-targets.txt").write_text(
        "sample_gfx1250\nhelper_gfx1250\n"
    )
    with pytest.raises(ValueError, match="Missing executable: .*helper_gfx1250"):
        suite.discover(
            TargetSpec("gfx1250"), binary_dir=str(tmp_path), cases_config=str(source)
        )
