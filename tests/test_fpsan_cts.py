import pytest

from fpsan_cts import FpsanError, case_id, run_case


def pytest_generate_tests(metafunc):
    if {"fpsan_test_name", "target_config"} - set(metafunc.fixturenames):
        return

    params = []
    ignore_xfails = metafunc.config.getoption("ignore_xfails")
    for target_config in metafunc.config.fpsan_target_configs:
        for test_name in target_config["tests"]:
            if test_name in target_config.get("skip_tests", []):
                continue

            marks = []
            if not ignore_xfails and _is_expected_failure(test_name, target_config):
                marks.append(
                    pytest.mark.xfail(
                        raises=FpsanError,
                        strict=True,
                        reason="Expected FPSAN CTS case to fail for this target config.",
                    )
                )
            params.append(
                pytest.param(
                    test_name,
                    target_config,
                    id=case_id(test_name, target_config),
                    marks=marks,
                )
            )

    metafunc.parametrize("fpsan_test_name,target_config", params)


def test_fpsan_cts_case(fpsan_test_name, target_config, pytestconfig):
    run_case(
        fpsan_test_name,
        target_config,
        pytestconfig.getoption("artifact_directory"),
        build_only=pytestconfig.getoption("skip_all_runs"),
    )


def _is_expected_failure(test_name, target_config):
    return any(
        test_name in target_config.get(field, [])
        for field in (
            "expected_failures",
            "expected_compile_failures",
            "expected_run_failures",
        )
    )
