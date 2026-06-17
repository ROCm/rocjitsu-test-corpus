import pytest

from fuzz_targets import (
    FuzzTargetError,
    case_config_names,
    case_id,
    discover_cases,
    matches_case_selector,
    run_case,
    supports_target_config,
)


def pytest_generate_tests(metafunc):
    if {"fuzz_case", "target_config"} - set(metafunc.fixturenames):
        return

    params = []
    ignore_xfails = metafunc.config.getoption("ignore_xfails")
    for fuzz_case in discover_cases():
        case = fuzz_case.case
        config_names = case_config_names(fuzz_case)
        for target_config in metafunc.config.fuzz_target_configs:
            if not supports_target_config(fuzz_case, target_config):
                continue
            if matches_case_selector(
                fuzz_case,
                target_config.get("skip_tests", []),
            ):
                continue

            marks = []
            if not ignore_xfails:
                if any(
                    name in target_config.get("expected_compile_failures", [])
                    for name in config_names
                ):
                    marks.append(
                        pytest.mark.xfail(
                            raises=FuzzTargetError,
                            strict=True,
                            reason="Expected CMake build to fail for this target config.",
                        )
                    )
                if any(
                    name in target_config.get("expected_run_failures", [])
                    for name in config_names
                ):
                    marks.append(
                        pytest.mark.xfail(
                            raises=FuzzTargetError,
                            strict=True,
                            reason="Expected executable run to fail for this target config.",
                        )
                    )

            params.append(
                pytest.param(
                    fuzz_case,
                    target_config,
                    id=case_id(fuzz_case, target_config),
                    marks=marks,
                )
            )

    metafunc.parametrize("fuzz_case,target_config", params)


def test_fuzz_target_case(fuzz_case, target_config, pytestconfig):
    run_case(
        fuzz_case,
        target_config,
        pytestconfig.getoption("artifact_directory"),
        build_only=pytestconfig.getoption("skip_all_runs"),
        run_wrapper=pytestconfig.getoption("run_wrapper"),
        case_timeout_seconds=pytestconfig.getoption("case_timeout"),
    )
