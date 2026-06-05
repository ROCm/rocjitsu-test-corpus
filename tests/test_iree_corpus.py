import pytest

from iree_corpus import CorpusError, discover_case_files, load_case, run_case


def pytest_generate_tests(metafunc):
    if {"case_path", "target_config"} - set(metafunc.fixturenames):
        return

    params = []
    ignore_xfails = metafunc.config.getoption("ignore_xfails")
    for case_path in discover_case_files():
        case = load_case(case_path)
        for target_config in metafunc.config.iree_target_configs:
            if case["name"] in target_config.get("skip_compile_tests", []):
                continue

            marks = []
            if not ignore_xfails:
                if case["name"] in target_config.get("expected_compile_failures", []):
                    marks.append(
                        pytest.mark.xfail(
                            raises=CorpusError,
                            strict=True,
                            reason="Expected compilation to fail for this target config.",
                        )
                    )
                if case["name"] in target_config.get("expected_run_failures", []):
                    marks.append(
                        pytest.mark.xfail(
                            raises=CorpusError,
                            strict=True,
                            reason="Expected execution to fail for this target config.",
                        )
                    )

            params.append(
                pytest.param(
                    case_path,
                    target_config,
                    id=f"{target_config['config_name']}::{case['name']}",
                    marks=marks,
                )
            )

    metafunc.parametrize("case_path,target_config", params)


def test_iree_corpus_case(case_path, target_config, pytestconfig):
    case = load_case(case_path)
    compile_only = pytestconfig.getoption("skip_all_runs") or (
        case["name"] in target_config.get("skip_run_tests", [])
    )
    run_case(
        case_path,
        target_config,
        pytestconfig.getoption("artifact_directory"),
        compile_only=compile_only,
        run_wrapper=pytestconfig.getoption("run_wrapper"),
    )
