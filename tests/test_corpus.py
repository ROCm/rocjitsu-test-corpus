from __future__ import annotations

from pathlib import Path

import pytest

from corpus_support.build import BuildManager, resolve_artifact_directory
from corpus_support.model import RunContext, SelectionOptions
from corpus_support.selection import (
    filter_cases,
    merge_selection,
    parse_csv_values,
)
from corpus_support.suites import cts, iree, kernels
from corpus_support.targets import load_target_spec, require_target


REPO_ROOT = Path(__file__).resolve().parents[1]
SUITE_MODULES = {
    "iree": iree,
    "kernels": kernels,
    "cts": cts,
}
DEFAULT_TARGET = "gfx1201"
DEFAULT_SUITES = ("iree", "kernels", "cts")


def pytest_generate_tests(metafunc):
    if "corpus_case" not in metafunc.fixturenames:
        return

    config = metafunc.config
    target = _resolve_target(
        target_name=config.getoption("target"),
        target_config_file=config.getoption("target_config_file"),
    )
    requested_suites = parse_csv_values(config.getoption("suite"))

    discovered = []
    suite_config_cache = {}
    selected_suites = requested_suites or target.supported_suites or DEFAULT_SUITES
    _validate_selected_suites(selected_suites)
    _validate_target_suites(target, selected_suites)

    requested_backends = parse_csv_values(config.getoption("backend"))
    include_backends = requested_backends
    if not include_backends and "kernels" in selected_suites:
        include_backends = tuple(
            target.suite_defaults.get("kernels", {}).get("backends", [])
        )
    cli_selection = SelectionOptions(
        include_suites=requested_suites,
        exclude_suites=parse_csv_values(config.getoption("exclude_suite")),
        include_backends=include_backends,
        exclude_backends=parse_csv_values(config.getoption("exclude_backend")),
        include_cases=parse_csv_values(config.getoption("case")),
        exclude_cases=parse_csv_values(config.getoption("exclude_case")),
        include_tags=parse_csv_values(config.getoption("tag")),
        exclude_tags=parse_csv_values(config.getoption("exclude_tag")),
    )
    selection = merge_selection(cli_selection)

    target_cases = []
    for suite in selected_suites:
        suite_module = SUITE_MODULES[suite]
        if suite not in suite_config_cache:
            suite_config_cache[suite] = suite_module.load_target_configs(
                tuple(str(path) for path in suite_module.default_config_files())
            )
        target_cases.extend(suite_module.discover(target, suite_config_cache[suite]))
    discovered.extend(filter_cases(target_cases, selection))

    cases = discovered
    config._corpus_target = target.target
    config._corpus_case_count = len(cases)

    params = []
    for case in cases:
        marks = []
        if case.expected_compile_failure or case.expected_run_failure:
            marks.append(
                pytest.mark.xfail(
                    strict=True,
                    reason="Expected failure for this target configuration.",
                )
            )
        params.append(pytest.param(case, id=case.id, marks=marks))

    metafunc.parametrize("corpus_case", params)


@pytest.fixture(scope="session")
def run_context(pytestconfig) -> RunContext:
    artifact_directory = resolve_artifact_directory(
        REPO_ROOT, pytestconfig.getoption("artifact_directory")
    )
    return RunContext(
        repo_root=REPO_ROOT,
        artifact_directory=artifact_directory,
        skip_all_runs=pytestconfig.getoption("skip_all_runs"),
    )


@pytest.fixture(scope="session")
def build_manager(run_context) -> BuildManager:
    return BuildManager(run_context)


def test_corpus_case(corpus_case, run_context, build_manager):
    suite_module = SUITE_MODULES[corpus_case.suite]
    build_result = build_manager.ensure_built(corpus_case, suite_module)
    suite_module.run(corpus_case, build_result, run_context)


def _resolve_target(
    *,
    target_name: str | None,
    target_config_file: str | None,
):
    if target_config_file:
        config_path = Path(target_config_file)
        if not config_path.is_absolute():
            config_path = REPO_ROOT / config_path
        try:
            return load_target_spec(config_path, target_name=target_name)
        except ValueError as exc:
            raise pytest.UsageError(str(exc)) from exc

    try:
        return require_target(target_name or DEFAULT_TARGET)
    except ValueError as exc:
        raise pytest.UsageError(str(exc)) from exc


def _validate_selected_suites(selected_suites) -> None:
    for suite in selected_suites:
        if suite not in SUITE_MODULES:
            allowed = ", ".join(sorted(SUITE_MODULES))
            raise pytest.UsageError(
                f"Unknown suite '{suite}'. Allowed suites: {allowed}"
            )


def _validate_target_suites(target, selected_suites) -> None:
    if not target.supported_suites:
        return
    unsupported = sorted(set(selected_suites) - set(target.supported_suites))
    if unsupported:
        raise pytest.UsageError(
            "Requested suites are not supported by target "
            f"'{target.target}': {', '.join(unsupported)}"
        )


