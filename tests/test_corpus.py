from __future__ import annotations

import json
from pathlib import Path

import pytest

from support.define_contracts import RunContext, SelectionOptions
from support.manage_builds import BuildManager, resolve_artifact_directory
from support.prepare_inputs import (
    filter_cases,
    make_target_spec,
    matches_case_selector,
    parse_csv_values,
    resolve_repo_path,
)
from test_suites import cts, iree, kernels


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
    target = _resolve_target(target_name=config.getoption("target"))
    requested_suites = parse_csv_values(config.getoption("suite"))
    run_tests_config = _load_run_tests_config(config.getoption("run_tests_config"))

    discovered = []
    suite_config_cache = {}
    selected_suites = requested_suites or DEFAULT_SUITES
    _validate_selected_suites(selected_suites)

    skip_tests_config = _load_skip_tests_config(config.getoption("skip_tests_config"))

    selection = SelectionOptions(
        include_suites=requested_suites,
        exclude_suites=parse_csv_values(config.getoption("exclude_suite")),
        include_backends=parse_csv_values(config.getoption("backend")),
        exclude_backends=parse_csv_values(config.getoption("exclude_backend")),
        include_cases=_resolve_include_cases(
            parse_csv_values(config.getoption("case")),
            run_tests_config,
            selected_suites,
        ),
        exclude_cases=parse_csv_values(config.getoption("exclude_case")),
    )

    if run_tests_config is None or selection.include_cases:
        target_cases = []
        for suite in selected_suites:
            suite_module = SUITE_MODULES[suite]
            if suite not in suite_config_cache:
                suite_config_cache[suite] = suite_module.load_target_configs(
                    tuple(str(path) for path in suite_module.default_config_files())
                )
            discovered_suite_cases = suite_module.discover(
                target, suite_config_cache[suite]
            )
            coalesce_cases = getattr(suite_module, "coalesce_cases", None)
            if coalesce_cases is None:
                target_cases.extend(filter_cases(discovered_suite_cases, selection))
                continue

            skip_selectors = skip_tests_config.get(suite, ())
            target_cases.extend(
                _filter_coalesced_suite_cases(
                    discovered_suite_cases,
                    selection,
                    skip_selectors,
                    coalesce_cases,
                )
            )
        discovered.extend(target_cases)

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
        if matches_case_selector(case, skip_tests_config.get(case.suite, ())):
            marks.append(
                pytest.mark.skip(
                    reason="Skipped by --skip-tests-config configuration.",
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
        ctest_jobs=_positive_int_option(pytestconfig, "ctest_jobs", "--ctest-jobs"),
        ctest_timeout=_positive_int_option(
            pytestconfig, "ctest_timeout", "--ctest-timeout"
        ),
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
):
    try:
        return make_target_spec(target_name or DEFAULT_TARGET)
    except ValueError as exc:
        raise pytest.UsageError(str(exc)) from exc


def _validate_selected_suites(selected_suites) -> None:
    for suite in selected_suites:
        if suite not in SUITE_MODULES:
            allowed = ", ".join(sorted(SUITE_MODULES))
            raise pytest.UsageError(
                f"Unknown suite '{suite}'. Allowed suites: {allowed}"
            )


def _positive_int_option(config, option_name: str, display_name: str) -> int:
    value = config.getoption(option_name)
    if value <= 0:
        raise pytest.UsageError(f"{display_name} must be a positive integer")
    return value


def _filter_coalesced_suite_cases(
    cases,
    selection: SelectionOptions,
    skip_selectors: tuple[str, ...],
    coalesce_cases,
):
    suite_cases = filter_cases(cases, _selection_without_case_filters(selection))
    standalone_cases = [
        case for case in suite_cases if _must_stay_standalone(case, skip_selectors)
    ]
    coalescible_cases = [
        case for case in suite_cases if case not in standalone_cases
    ]

    selected_cases = []
    selected_cases.extend(
        _select_coalesced_cases(coalescible_cases, selection, coalesce_cases)
    )
    selected_cases.extend(_select_standalone_cases(standalone_cases, selection))
    return selected_cases


def _selection_without_case_filters(selection: SelectionOptions) -> SelectionOptions:
    return SelectionOptions(
        include_suites=selection.include_suites,
        exclude_suites=selection.exclude_suites,
        include_backends=selection.include_backends,
        exclude_backends=selection.exclude_backends,
    )


def _select_coalesced_cases(cases, selection: SelectionOptions, coalesce_cases):
    selected_cases = []
    for aggregate_case in coalesce_cases(cases):
        group_cases = tuple(aggregate_case.metadata["selected_cases"])
        group_selected_cases = _select_coalesced_group(
            aggregate_case, group_cases, selection
        )
        if group_selected_cases:
            selected_cases.extend(coalesce_cases(list(group_selected_cases)))
    return selected_cases


def _select_coalesced_group(
    aggregate_case,
    group_cases: tuple,
    selection: SelectionOptions,
) -> tuple:
    if _aggregate_case_id_matches(aggregate_case, selection.exclude_cases):
        return ()

    if not selection.include_cases or _aggregate_case_id_matches(
        aggregate_case, selection.include_cases
    ):
        included_cases = group_cases
    else:
        included_cases = tuple(
            case
            for case in group_cases
            if matches_case_selector(case, selection.include_cases)
        )

    return tuple(
        case
        for case in included_cases
        if not matches_case_selector(case, selection.exclude_cases)
    )


def _select_standalone_cases(cases, selection: SelectionOptions):
    selected_cases = []
    for case in cases:
        if selection.include_cases and not matches_case_selector(
            case, selection.include_cases
        ):
            continue
        if matches_case_selector(case, selection.exclude_cases):
            continue
        selected_cases.append(case)
    return selected_cases


def _aggregate_case_id_matches(case, selectors: tuple[str, ...]) -> bool:
    return case.id in selectors


def _must_stay_standalone(case, skip_selectors: tuple[str, ...]) -> bool:
    return (
        matches_case_selector(case, skip_selectors)
        or case.expected_compile_failure
        or case.expected_run_failure
        or str(case.metadata.get("name", "")).startswith("fpsan_neg_")
    )


def _load_skip_tests_config(path_value: str | None) -> dict[str, tuple[str, ...]]:
    if path_value is None:
        return {}

    return _load_suite_selector_config(path_value, "--skip-tests-config")


def _load_run_tests_config(path_value: str | None) -> dict[str, tuple[str, ...]] | None:
    if path_value is None:
        return None

    return _load_suite_selector_config(path_value, "--run-tests-config")


def _load_suite_selector_config(
    path_value: str,
    option_name: str,
) -> dict[str, tuple[str, ...]]:
    path = resolve_repo_path(REPO_ROOT, path_value)
    try:
        with path.open("r", encoding="utf-8") as f:
            payload = json.load(f)
    except OSError as exc:
        raise pytest.UsageError(
            f"Could not read {option_name} config {path}: {exc}"
        ) from exc
    except json.JSONDecodeError as exc:
        raise pytest.UsageError(f"Invalid {option_name} config {path}: {exc}") from exc

    if not isinstance(payload, dict):
        raise pytest.UsageError(f"{path} must contain an object keyed by suite name")

    selector_config: dict[str, tuple[str, ...]] = {}
    for suite, selectors in payload.items():
        if suite not in SUITE_MODULES:
            allowed = ", ".join(sorted(SUITE_MODULES))
            raise pytest.UsageError(
                f"{path} has unknown suite '{suite}'. Allowed suites: {allowed}"
            )
        selector_config[suite] = tuple(
            _validate_suite_selectors(path, suite, selectors)
        )
    return selector_config


def _validate_suite_selectors(path: Path, suite: str, selectors) -> list[str]:
    if not isinstance(selectors, list):
        raise pytest.UsageError(f"{path} field '{suite}' must be a list")
    for selector in selectors:
        if not isinstance(selector, str) or not selector:
            raise pytest.UsageError(
                f"{path} field '{suite}' must contain non-empty strings"
            )
    return selectors


def _resolve_include_cases(
    requested_cases: tuple[str, ...],
    run_tests_config: dict[str, tuple[str, ...]] | None,
    selected_suites: tuple[str, ...],
) -> tuple[str, ...]:
    if run_tests_config is None:
        return requested_cases

    configured_cases = []
    for suite in selected_suites:
        configured_cases.extend(run_tests_config.get(suite, ()))
    return (*requested_cases, *configured_cases)
