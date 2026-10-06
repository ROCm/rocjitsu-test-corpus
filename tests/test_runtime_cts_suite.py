"""Manifest and process-boundary regressions; fake executables require no GPU."""

from pathlib import Path
import json
import time

import pytest

from support.define_contracts import BuildResult, CorpusCase, RunContext, TargetSpec
from test_suites import runtime_cts as suite


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
        'slow="yes"',
        "slow=1",
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
    root = tmp_path / "corpus" / "pm4"
    root.mkdir(parents=True)
    source = manifest(tmp_path)
    (root / "cases_gfx1250.toml").write_text(source.read_text())
    monkeypatch.setattr(suite, "ROOT", root.parent)
    binary = tmp_path / "sample_gfx1250"
    binary.write_text("#!/bin/sh\nexit 0\n")
    binary.chmod(0o755)
    (tmp_path / "runtime-gfx1250-features.txt").write_text("pm4\n")
    inv = tmp_path / "pm4-gfx1250-targets.txt"
    inv.write_text("sample_gfx1250\n")
    cases = suite.discover(
        TargetSpec("gfx1250"), suite_name="pm4", binary_dir=str(tmp_path), cases_config=str(source)
    )
    assert len(cases) == 1
    inv.write_text("sample_gfx1250\nforgotten_gfx1250\n")
    with pytest.raises(ValueError, match="forgotten_gfx1250"):
        suite.discover(
            TargetSpec("gfx1250"), suite_name="pm4", binary_dir=str(tmp_path), cases_config=str(source)
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
        "pm4.gfx1250.fake",
        "pm4",
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
        (context.artifact_directory / "pm4/gfx1250/fake.json").read_text()
    )
    assert record["status"] == "PASS"
    assert record["command"][-1] == case.run["args"][0]


def test_skip_never_launches(tmp_path):
    case, build, context = fake_case(tmp_path, "exit 99\n")
    case.run.update(status="SKIP", reason="investigate")
    with pytest.raises(pytest.skip.Exception, match="investigate"):
        suite.run(case, build, context)
    assert not context.artifact_directory.exists()


@pytest.mark.parametrize(
    "argument", ["signature", "\nsignature", "μ\nsignature", "first\nsignature\nlast"]
)
def test_xfail_matches_output_not_command(tmp_path, argument):
    case, build, context = fake_case(tmp_path, "echo other; exit 1\n")
    case.run.update(
        status="XFAIL",
        reason="bug",
        expected_exit_code=1,
        expected_output="signature",
        args=suite.load_manifest(manifest(tmp_path, args=json.dumps([argument])))[0]["args"],
    )
    with pytest.raises(pytest.fail.Exception):
        suite.run(case, build, context)
    result_path = context.artifact_directory / "pm4/gfx1250/fake.json"
    assert json.loads(result_path.read_text())["status"] == "FAIL"
    build.executable_path.write_text("#!/bin/sh\necho signature; exit 1\n")
    with pytest.raises(suite.ExpectedFailure):
        suite.run(case, build, context)
    assert json.loads(result_path.read_text())["status"] == "XFAIL"


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
    binary = tmp_path / "pm4_packet_flood_gfx1250"
    binary.write_text(
        '#!/bin/sh\ncase "$1" in fail) echo "known defect"; exit 1;; wrong) echo other; exit 1;; esac\nexit 0\n'
    )
    binary.chmod(0o755)
    (tmp_path / "runtime-gfx1250-features.txt").write_text("pm4\n")
    (tmp_path / "pm4-gfx1250-targets.txt").write_text(binary.name + "\n")
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
                "pm4",
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
        assert (artifacts / "pm4/gfx1250/second.json").exists() == (
            returncode == 0
        )
    finally:
        shutil.rmtree(artifacts, ignore_errors=True)


def test_unavailable_wrapper_rejected_before_discovery(tmp_path):
    with pytest.raises(ValueError, match="wrapper executable is unavailable"):
        suite.discover(
            TargetSpec("gfx1250"), suite_name="pm4",
            binary_dir=str(tmp_path),
            cases_config=None,
            run_wrapper="/nonexistent/runtime-cts-wrapper",
        )


@pytest.mark.parametrize(
    "options, summary, fast_runs, slow_runs",
    [
        ([], "1 passed, 2 skipped", True, False),
        (["--run-slow"], "2 passed, 1 skipped", True, True),
        (["--run-slow", "-m", "slow"], "1 passed, 1 skipped, 1 deselected", False, True),
    ],
)
def test_slow_cases_require_opt_in(tmp_path, options, summary, fast_runs, slow_runs):
    import shutil
    import subprocess
    import sys

    repo = Path(__file__).resolve().parents[1]
    binary = tmp_path / "pm4_packet_flood_gfx1250"
    binary.write_text("#!/bin/sh\necho PASS\n")
    binary.chmod(0o755)
    (tmp_path / "pm4-gfx1250-targets.txt").write_text(binary.name + "\n")
    (tmp_path / "runtime-gfx1250-features.txt").write_text("pm4\n")
    config = tmp_path / "custom.toml"
    config.write_text(
        f'[[case]]\nid="fast"\nbinary="{binary.name}"\n'
        f'[[case]]\nid="extended"\nbinary="{binary.name}"\nslow=true\n'
        f'[[case]]\nid="unqualified"\nbinary="{binary.name}"\nslow=true\n'
        'status="SKIP"\nreason="unresolved reproducer"\n'
    )
    artifacts = repo / ".pytest-artifacts" / ("slow-unit-" + tmp_path.name)
    try:
        result = subprocess.run(
            [sys.executable, "-m", "pytest", "tests/test_corpus.py",
             "--suite", "pm4", "--target", "gfx1250",
             "--binary-dir", str(tmp_path), "--cases-config", str(config),
             "--artifact-directory", str(artifacts), "-q", "-rs", *options],
            cwd=repo, capture_output=True, text=True, timeout=20,
        )
        output = result.stdout + result.stderr
        assert result.returncode == 0, output
        assert summary in output
        assert (artifacts / "pm4/gfx1250/fast.json").exists() == fast_runs
        assert (artifacts / "pm4/gfx1250/extended.json").exists() == slow_runs
        assert not (artifacts / "pm4/gfx1250/unqualified.json").exists()
        assert "unresolved reproducer" in output
    finally:
        shutil.rmtree(artifacts, ignore_errors=True)


def test_custom_subset_requires_helper_binaries(tmp_path, monkeypatch):
    root = tmp_path / "corpus" / "pm4"
    root.mkdir(parents=True)
    source = manifest(tmp_path)
    defaults = source.read_text() + '\n[[case]]\nid="helper"\nbinary="helper_gfx1250"\n'
    (root / "cases_gfx1250.toml").write_text(defaults)
    monkeypatch.setattr(suite, "ROOT", root.parent)
    binary = tmp_path / "sample_gfx1250"
    binary.write_text("#!/bin/sh\nexit 0\n")
    binary.chmod(0o755)
    (tmp_path / "runtime-gfx1250-features.txt").write_text("pm4\n")
    (tmp_path / "pm4-gfx1250-targets.txt").write_text(
        "sample_gfx1250\nhelper_gfx1250\n"
    )
    with pytest.raises(ValueError, match="Missing executable: .*helper_gfx1250"):
        suite.discover(
            TargetSpec("gfx1250"), suite_name="pm4", binary_dir=str(tmp_path), cases_config=str(source)
        )


@pytest.mark.parametrize("suite_name, feature", [("aql", "sdma_signal64"), ("pm4", "pm4_wait_offload")])
@pytest.mark.parametrize("target", ["gfx900", "gfx942", "gfx1100", "gfx1201", "gfx1250"])
def test_target_manifest_and_feature_gates(tmp_path, monkeypatch, target, suite_name, feature):
    root = tmp_path / "corpus"
    (root / suite_name).mkdir(parents=True)
    (root / suite_name / f"cases_{target}.toml").write_text('''[[case]]
id="copy"
binary="aql_copy_{target}"

[[case]]
id="signal64"
binary="aql_signal64_{target}"
requires=["FEATURE"]
'''.replace("aql_", f"{suite_name}_").replace("FEATURE", feature))
    monkeypatch.setattr(suite, "ROOT", root)
    names = [f"{suite_name}_copy_{target}"]
    features = ""
    if target == "gfx1250":
        features = feature + "\n"
        names.append(f"{suite_name}_signal64_{target}")
    (tmp_path / f"runtime-{target}-features.txt").write_text(features)
    (tmp_path / f"{suite_name}-{target}-targets.txt").write_text("\n".join(names) + "\n")
    for name in names:
        binary = tmp_path / name
        binary.write_text("#!/bin/sh\nexit 0\n")
        binary.chmod(0o755)
    cases = suite.discover(
        TargetSpec(target), suite_name=suite_name, binary_dir=str(tmp_path), cases_config=None
    )
    assert [case.suite for case in cases] == [suite_name, suite_name]
    assert cases[0].run["status"] == ""
    assert cases[1].run["status"] == ("" if features else "SKIP")
    # A custom manifest cannot disguise an unknown binary as a gated feature.
    custom = tmp_path / "custom.toml"
    custom.write_text('''[[case]]
id="unknown"
binary="unknown"
requires=["FEATURE"]
'''.replace("aql_", f"{suite_name}_").replace("FEATURE", feature))
    with pytest.raises(ValueError, match="unknown selected binaries"):
        suite.discover(
            TargetSpec(target), suite_name=suite_name, binary_dir=str(tmp_path),
            cases_config=str(custom),
        )


@pytest.mark.parametrize("requirement", ['"sdma_signal64"', '["typo"]', '[1]'])
def test_reject_invalid_feature_gates(tmp_path, requirement):
    with pytest.raises(ValueError, match="feature|requires"):
        suite.load_manifest(manifest(tmp_path, f"requires={requirement}"))


@pytest.mark.parametrize("suite_name", ["aql", "pm4"])
@pytest.mark.parametrize("target", ["gfx1201", "gfx1250"])
def test_target_manifest_selection(tmp_path, monkeypatch, suite_name, target):
    root = tmp_path / "corpus" / suite_name
    root.mkdir(parents=True)
    common = '[[case]]\nid="plain"\nbinary="sample_{target}"\n'
    specific = common.replace('id="plain"', 'id="metadata"') + 'args=["--aql-metadata","on"]\n'
    (root / "cases_gfx1201.toml").write_text(common)
    (root / "cases_gfx1250.toml").write_text(specific)
    monkeypatch.setattr(suite, "ROOT", root.parent)
    binary = tmp_path / f"sample_{target}"
    binary.write_text("#!/bin/sh\nexit 0\n")
    binary.chmod(0o755)
    inventory = tmp_path / f"{suite_name}-{target}-targets.txt"
    inventory.write_text(binary.name + "\n")
    (tmp_path / f"runtime-{target}-features.txt").write_text("aql_metadata\n")
    options = dict(suite_name=suite_name, binary_dir=str(tmp_path), cases_config=None)
    case, = suite.discover(TargetSpec(target), **options)
    filename = f"cases_{target}.toml"
    assert case.path == root / filename
    assert case.run["args"] == (["--aql-metadata", "on"] if target == "gfx1250" else [])
    # Explicit custom selection wins, but selected default coverage is still checked.
    custom = tmp_path / "custom.toml"
    custom.write_text(common)
    options["cases_config"] = str(custom)
    case, = suite.discover(TargetSpec(target), **options)
    assert case.path == custom
    assert case.run["args"] == []
    (root / filename).write_text(common.replace("sample_{target}", "wrong_{target}"))
    with pytest.raises(ValueError, match="missing default entries"):
        suite.discover(TargetSpec(target), **options)


@pytest.mark.parametrize("target", ["gfx942", "gfx950", "gfx1100", "gfx1201", "gfx1250"])
@pytest.mark.parametrize("suite_name", ["aql", "pm4"])
def test_every_slow_case_has_quick_counterpart(target, suite_name):
    rows = suite.load_manifest(suite.ROOT / suite_name / f"cases_{target}.toml", target)
    by_id = {row["id"]: row for row in rows}
    for row in rows:
        if not row.get("slow", False):
            continue
        quick = by_id[row["id"].replace("-slow", "")]
        assert not quick.get("slow", False)
        assert quick["status"] == row["status"] == ""
        assert quick["binary"] == row["binary"]
        assert quick.get("requires", []) == row.get("requires", [])
        args = dict(zip(row["args"][::2], row["args"][1::2]))
        quick_args = dict(zip(quick["args"][::2], quick["args"][1::2]))
        assert int(quick_args.pop("--iterations")) < int(args.pop("--iterations"))
        args.pop("--timeout", None)
        quick_args.pop("--timeout", None)
        assert args == quick_args


def test_missing_target_manifest_has_no_fallback(tmp_path, monkeypatch):
    root = tmp_path / "corpus" / "pm4"
    root.mkdir(parents=True)
    (root / "cases.toml").write_text('[[case]]\nid="sample"\nbinary="sample_gfx1100"\n')
    monkeypatch.setattr(suite, "ROOT", root.parent)
    (tmp_path / "pm4-gfx1100-targets.txt").write_text("sample_gfx1100\n")
    with pytest.raises(ValueError, match="No verified runtime CTS manifest for gfx1100"):
        suite.discover(TargetSpec("gfx1100"), suite_name="pm4", binary_dir=str(tmp_path), cases_config=None)


@pytest.mark.parametrize("target", ["gfx942", "gfx950", "gfx1100", "gfx1201", "gfx1250"])
def test_target_manifests_match_cmake_build_inventory(tmp_path, target):
    import re
    import shutil
    import subprocess

    cmake = shutil.which("cmake")
    if cmake is None:
        pytest.skip("CMake required to evaluate the actual target build inventory")
    script = tmp_path / "inventory.cmake"
    script.write_text('''
cmake_minimum_required(VERSION 3.20)
include("${CTS_ROOT}/cmake/RuntimeCTS.cmake")
function(add_executable)
endfunction()
function(set_target_properties target properties output_name binary)
  file(APPEND "${OUTPUT}/${suite}-targets.txt" "${binary}\\n")
endfunction()
function(target_include_directories)
endfunction()
function(target_link_libraries)
endfunction()
function(target_compile_definitions)
endfunction()
function(add_dependencies)
endfunction()
function(cts_inventory)
endfunction()
include("${CTS_ROOT}/cmake/Platforms.cmake")
cts_platform(${arch})
file(WRITE "${OUTPUT}/features.txt" "${platform_features}")
include("${CTS_ROOT}/aql/CMakeLists.txt")
include("${CTS_ROOT}/pm4/CMakeLists.txt")
''')
    subprocess.run([cmake, f"-DCTS_ROOT={suite.ROOT}", f"-DOUTPUT={tmp_path}",
                    f"-Darch={target}", "-P", str(script)], check=True, capture_output=True, text=True)
    features = set((tmp_path / "features.txt").read_text().split(";"))
    for suite_name in ("aql", "pm4"):
        rows = suite.load_manifest(suite.ROOT / suite_name / f"cases_{target}.toml", target)
        binaries = set((tmp_path / f"{suite_name}-targets.txt").read_text().splitlines())
        assert {row["binary"] for row in rows} == binaries
        for row in rows:
            assert set(row.get("requires", [])) <= features
            if row["status"] == "SKIP":
                assert set(re.findall(r"gfx[0-9a-f]+", row["reason"])) == {target}
