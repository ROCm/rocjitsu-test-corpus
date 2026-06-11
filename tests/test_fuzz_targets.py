import pytest

from fuzz_targets import FuzzTargetError, case_id, discover_cases, run_case, supports_target_config


def pytest_generate_tests(metafunc):
    if {"fuzz_case", "target_config"} - set(metafunc.fixturenames):
        return

    params = []
    ignore_xfails = metafunc.config.getoption("ignore_xfails")
    for fuzz_case in discover_cases():
        case = fuzz_case.case
        for target_config in metafunc.config.fuzz_target_configs:
            if not supports_target_config(fuzz_case, target_config):
                continue
            if case["name"] in target_config.get("skip_compile_tests", []):
                continue

            marks = []
            if not ignore_xfails:
                if case["name"] in target_config.get("expected_compile_failures", []):
                    marks.append(
                        pytest.mark.xfail(
                            raises=FuzzTargetError,
                            strict=True,
                            reason="Expected CMake build to fail for this target config.",
                        )
                    )
                if (
                    case["name"] in target_config.get("expected_run_failures", [])
                    or fuzz_case.variant["expect"] == "fail"
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
    build_only = pytestconfig.getoption("skip_all_runs") or (
        fuzz_case.case["name"] in target_config.get("skip_run_tests", [])
    )
    run_case(
        fuzz_case,
        target_config,
        pytestconfig.getoption("artifact_directory"),
        build_only=build_only,
    )
