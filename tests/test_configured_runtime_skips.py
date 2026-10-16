"""A successful build must not turn a disabled runtime check into a pass."""

import pytest

from support.define_contracts import BuildResult, RunContext, TargetSpec
from test_suites import cts, iree, kernels, semantics


@pytest.mark.parametrize("suite", [cts, iree, kernels, semantics])
def test_configured_runtime_skip_is_reported_without_launching(suite, tmp_path, monkeypatch):
    configs = suite.load_target_configs(suite.default_config_files())
    case = suite.discover(TargetSpec("gfx1250"), configs)[0]
    config = case.metadata["target_config"]
    selector = case.metadata.get("name", case.selector_names[0])
    if suite is kernels:
        selector = case.selector_names[0]
    config["skip_run_tests"] = [selector]
    result = BuildResult(
        build_dir=tmp_path,
        executable_path=tmp_path / "unused",
        metadata={
            "logs_dir": str(tmp_path),
            "target_config": config,
            "effective_case": case.metadata.get("effective_case"),
            "run_dir": tmp_path,
        },
    )
    context = RunContext(tmp_path, tmp_path, skip_all_runs=False)

    def unexpected_launch(*args, **kwargs):
        pytest.fail("A disabled runtime check must not launch a subprocess")

    if suite is cts:
        monkeypatch.setattr(cts, "_run_command", unexpected_launch)
    elif suite is kernels:
        monkeypatch.setattr(kernels.legacy_kernels, "materialize_inputs", unexpected_launch)
    elif suite is iree:
        monkeypatch.setattr(iree.legacy_iree, "run_case", unexpected_launch)
    else:
        monkeypatch.setattr(semantics, "_run_semantic_binary", unexpected_launch)

    with pytest.raises(pytest.skip.Exception, match="Runtime disabled by target configuration"):
        suite.run(case, result, context)


def test_iree_case_compile_only_reports_its_reason(tmp_path, monkeypatch):
    configs = iree.load_target_configs(iree.default_config_files())
    case = iree.discover(TargetSpec("gfx1250"), configs)[0]
    case.metadata["target_config"]["skip_run_tests"] = []
    monkeypatch.setattr(iree.legacy_iree, "load_case", lambda _: {
        "compile_only": True, "skip_reason": "Native matmul test support is required."
    })
    monkeypatch.setattr(iree.legacy_iree, "run_case", lambda *args, **kwargs: pytest.fail("Unexpected run"))
    with pytest.raises(pytest.skip.Exception, match="Native matmul test support is required"):
        iree.run(case, BuildResult(None, None, {}), RunContext(tmp_path, tmp_path, skip_all_runs=False))
