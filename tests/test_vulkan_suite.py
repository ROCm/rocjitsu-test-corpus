from __future__ import annotations

import hashlib
import json

import pytest

from support.define_contracts import BuildResult, RunContext, TargetSpec
from test_suites import vulkan

NAME = "dEQP-VK.compute.pipeline.basic.copy_ssbo_bounds"


def qpa(status="Pass", name=NAME, device_id="0x7448"):
    return f"""#sessionInfo releaseName {vulkan.CTS_REVISION}
#sessionInfo vendorID 0x1002
#sessionInfo deviceID {device_id}
#sessionInfo deviceName Test device (RADV)
#beginSession
#beginTestCaseResult {name}
<?xml version="1.0" encoding="UTF-8"?>
<TestCaseResult CasePath="{name}"><Result StatusCode="{status}">detail</Result></TestCaseResult>
#endTestCaseResult
#endSession
"""


@pytest.mark.parametrize(
    "target,unsupported_count,unsupported_digest",
    [
        (
            "gfx1100",
            589,
            "6630ad4abf9a2e737651fb509c327515f7f1e61a961b0c47a8f98f08263ac34b",
        ),
        (
            "gfx1201",
            565,
            "0e3b94b715130f9ccde66b9fce11632fcf4ee8b78bd6b8c7781f111731c84e17",
        ),
    ],
)
def test_inventory(target, unsupported_count, unsupported_digest):
    cases = vulkan.discover(TargetSpec(target), list(vulkan.default_config_files()))
    assert len(cases) == 3290
    assert len({case.id for case in cases}) == len(cases)
    assert (
        sum(case.metadata["allow_not_supported"] for case in cases) == unsupported_count
    )
    assert sum("smoke" in case.selector_names for case in cases) == 10
    assert sum("stress" in case.selector_names for case in cases) == 12
    assert sum("ci" in case.selector_names for case in cases) == 3278
    assert sum(case.collection == "compute" for case in cases) == 747
    for case in cases:
        if "stress" in case.selector_names:
            assert case.collection == "compute"
        if case.collection == "texel-buffer":
            assert case.metadata["name"].startswith("dEQP-VK.image.")
            assert ".buffer." in case.metadata["name"]
    names = {case.metadata["name"] for case in cases}
    unsupported = vulkan.read_unsupported(
        vulkan.CORPUS_ROOT / f"unsupported-{target}.txt", names
    )
    # Freeze the original hardware baseline, including membership: equal counts
    # alone would miss patterns that accidentally swap supported/unsupported cases.
    expanded = "\n".join(sorted(unsupported)) + "\n"
    assert hashlib.sha256(expanded.encode()).hexdigest() == unsupported_digest
    assert set(vulkan.read_cases(vulkan.CORPUS_ROOT / "smoke.txt")) <= names
    excluded = set(vulkan.read_cases(vulkan.CORPUS_ROOT / "excluded-graphics.txt"))
    assert len(excluded) == 4
    assert excluded.isdisjoint(names)


def test_unsupported_patterns_are_scoped_to_inventory(tmp_path):
    path = tmp_path / "unsupported.txt"
    path.write_text("dEQP-VK.image.*.buffer.r32_*\n")
    names = {
        "dEQP-VK.image.store.buffer.r32_sfloat",
        "dEQP-VK.image.store.buffer.r16_sfloat",
    }
    assert vulkan.read_unsupported(path, names) == {
        "dEQP-VK.image.store.buffer.r32_sfloat"
    }
    with pytest.raises(ValueError, match="exact CTS case names"):
        vulkan.read_cases(path)
    with pytest.raises(ValueError, match="matches no selected cases"):
        vulkan.read_unsupported(path, {NAME})
    path.write_text("dEQP-VK.image.[ab]\n")
    with pytest.raises(ValueError, match="Invalid CTS unsupported pattern"):
        vulkan.read_unsupported(path, names)


def test_compute_only_collection_keeps_full_unsupported_inventory():
    cases = vulkan.discover(TargetSpec("gfx1100"), [vulkan.CORPUS_ROOT / "compute.txt"])
    assert len(cases) == 747
    assert not any(case.metadata["allow_not_supported"] for case in cases)


def test_unsupported_target_fails_collection():
    with pytest.raises(ValueError, match="gfx1100 and gfx1201"):
        vulkan.discover(TargetSpec("gfx1250"), [])


@pytest.mark.parametrize(
    "target,device_id", [("gfx1100", "0x7448"), ("gfx1201", "0x7551")]
)
def test_expected_results(target, device_id):
    assert vulkan.check_result(qpa(device_id=device_id), NAME, target, False) == "Pass"
    assert (
        vulkan.check_result(
            qpa("NotSupported", device_id=device_id), NAME, target, True
        )
        == "NotSupported"
    )
    # A driver gaining support is allowed; capability loss is not.
    assert vulkan.check_result(qpa(device_id=device_id), NAME, target, True) == "Pass"


@pytest.mark.parametrize(
    "status", ["Fail", "InternalError", "Crash", "QualityWarning", "NotSupported"]
)
def test_nonpassing_result_fails(status):
    with pytest.raises(RuntimeError, match="CTS"):
        vulkan.check_result(qpa(status), NAME, "gfx1100", False)


@pytest.mark.parametrize(
    "log",
    [
        "",
        qpa().replace("#endSession", ""),
        qpa().replace("#endTestCaseResult", ""),
        qpa() + qpa(),
        qpa(name="dEQP-VK.other"),
        qpa().replace("0x7448", "0x7551"),
        qpa().replace("0x1002", "0x1234"),
        qpa().replace("RADV", "llvmpipe"),
        qpa().replace(vulkan.CTS_REVISION, "wrong-revision"),
        qpa().replace('CasePath="' + NAME, 'CasePath="wrong'),
    ],
)
def test_incomplete_or_wrong_run_fails(log):
    with pytest.raises(RuntimeError):
        vulkan.check_result(log, NAME, "gfx1100", False)


def test_runtime_rejects_stale_log_and_times_out(tmp_path, monkeypatch):
    case = next(
        case
        for case in vulkan.discover(
            TargetSpec("gfx1100"), list(vulkan.default_config_files())
        )
        if case.metadata["name"] == NAME
    )
    context = RunContext(tmp_path, tmp_path / "artifacts", False)
    binary = tmp_path / "deqp-vk"
    binary.write_text("#!/bin/sh\nexit 0\n")
    binary.chmod(0o755)
    result = BuildResult(tmp_path, binary)
    with pytest.raises(RuntimeError, match="diagnostics"):
        vulkan.run(case, result, context)
    run_dir = next((context.artifact_directory / "vulkan/gfx1100").iterdir())
    (run_dir / "results.qpa").write_text(qpa())
    with pytest.raises(RuntimeError, match="diagnostics"):
        vulkan.run(case, result, context)
    assert not (run_dir / "results.qpa").exists()
    binary.write_text("#!/bin/sh\nsleep 30 &\nwait\n")
    monkeypatch.setenv("VULKAN_CTS_TIMEOUT", "0.05")
    with pytest.raises(RuntimeError, match="timed out"):
        vulkan.run(case, result, context)
    assert json.loads((run_dir / "run.json").read_text())["timed_out"]
