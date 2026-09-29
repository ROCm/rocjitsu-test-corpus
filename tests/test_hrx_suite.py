"""GPU-free regression checks for the HRX CTS adapter."""

import multiprocessing
import sys
from pathlib import Path

import pytest

from support.define_contracts import BuildResult, RunContext, TargetSpec
from test_suites import hrx


def _run_after_barrier(case, result, context, barrier):
    barrier.wait()
    hrx.run(case, result, context)


def test_all_skipped_binary_fails_even_when_ctest_succeeds(tmp_path):
    xml = (
        '<testsuites><testsuite><testcase name="only_case" result="skipped">'
        '<skipped message="intentional capability skip"/>'
        "</testcase></testsuite></testsuites>"
    )
    fake_ctest = tmp_path / "fake-ctest"
    fake_ctest.write_text(
        f"#!{sys.executable}\n"
        "import os\nfrom pathlib import Path\n"
        f"Path(os.environ['GTEST_OUTPUT'][4:]).write_text({xml!r})\n"
    )
    fake_ctest.chmod(0o755)
    case = hrx.discover(TargetSpec("gfx1201"), ["core_tests"])[0]
    context = RunContext(tmp_path, tmp_path / "artifacts", False, str(fake_ctest))
    with pytest.raises(RuntimeError, match="no Google Test cases executed"):
        hrx.run(case, BuildResult(tmp_path, fake_ctest), context)
    log_dir = context.artifact_directory / "hrx/gfx1201"
    assert (log_dir / "core_tests.gtest.xml").is_file()
    assert (log_dir / "core_tests.ctest.log").is_file()


def test_backend_unavailable_skip_fails_even_with_other_executed_cases(tmp_path):
    xml_path = tmp_path / "results.xml"
    xml_path.write_text(
        '<testsuites><testsuite><testcase name="passed" result="completed"/>'
        '<testcase name="skipped" result="skipped">'
        '<skipped message="Backend &apos;amdgpu&apos; unavailable: HSA missing"/>'
        "</testcase></testsuite></testsuites>"
    )
    with pytest.raises(RuntimeError, match="backend unavailable"):
        hrx._check_gtest_results(xml_path)


def test_ctest_failure_shows_diagnostic_in_pytest_output(tmp_path):
    fake_ctest = tmp_path / "fake-ctest"
    fake_ctest.write_text(f"#!{sys.executable}\nprint('driver allocation failed')\nraise SystemExit(7)\n")
    fake_ctest.chmod(0o755)
    case = hrx.discover(TargetSpec("gfx1201"), ["core_tests"])[0]
    context = RunContext(tmp_path, tmp_path / "artifacts", False, str(fake_ctest))
    with pytest.raises(RuntimeError, match="driver allocation failed"):
        hrx.run(case, BuildResult(tmp_path, fake_ctest), context)


def test_gpu_lock_serializes_separate_adapter_processes(tmp_path):
    marker = tmp_path / "gpu-in-use"
    xml = '<testsuites><testsuite><testcase name="ran" result="completed"/></testsuite></testsuites>'
    fake_ctest = tmp_path / "fake-ctest"
    fake_ctest.write_text(
        f"#!{sys.executable}\n"
        "import os\nimport time\nfrom pathlib import Path\n"
        f"marker = Path({str(marker)!r})\n"
        "try:\n"
        "    fd = os.open(marker, os.O_CREAT | os.O_EXCL | os.O_WRONLY)\n"
        "except FileExistsError:\n"
        "    raise SystemExit(7)\n"
        "try:\n"
        "    time.sleep(0.6)\n"
        f"    Path(os.environ['GTEST_OUTPUT'][4:]).write_text({xml!r})\n"
        "finally:\n"
        "    os.close(fd)\n"
        "    marker.unlink()\n"
    )
    fake_ctest.chmod(0o755)
    cases = hrx.discover(TargetSpec("gfx1201"), ["core_tests", "buffer_tests"])
    context = RunContext(tmp_path, tmp_path / "artifacts", False, str(fake_ctest))
    result = BuildResult(tmp_path, fake_ctest)
    process_context = multiprocessing.get_context("fork")
    barrier = process_context.Barrier(2)
    processes = [
        process_context.Process(
            target=_run_after_barrier, args=(case, result, context, barrier)
        )
        for case in cases
    ]
    for process in processes:
        process.start()
    for process in processes:
        process.join(timeout=10)
    assert [process.exitcode for process in processes] == [0, 0]
    assert not marker.exists()
    assert len(list((context.artifact_directory / "hrx/gfx1201").glob("*.gtest.xml"))) == 2
