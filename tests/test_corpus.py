from __future__ import annotations

import json
from pathlib import Path

import pytest

from corpus_support.build import BuildManager, resolve_artifact_directory
from corpus_support.model import RunContext, SelectionOptions
from corpus_support.selection import (
    filter_cases,
    merge_selection,
    parse_csv_values,
    selection_from_profile,
)
from corpus_support.suites import DEFAULT_SUITES, SUITE_MODULES
from corpus_support.targets import require_target


REPO_ROOT = Path(__file__).resolve().parents[1]


def pytest_generate_tests(metafunc):
    if "corpus_case" not in metafunc.fixturenames:
        return

    config = metafunc.config
    target_name = config.getoption("target")
    if not target_name:
        raise pytest.UsageError("--target is required")

    target = require_target(target_name)
    profile_path = config.getoption("corpus_config_file", default=None)
    if profile_path is None:
        profile_path = config.getoption("config_file", default=None)
    profile = _load_profile(profile_path)

    selected_suites = parse_csv_values(config.getoption("suite"))
    if not selected_suites:
        selected_suites = DEFAULT_SUITES
    for suite in selected_suites:
        if suite not in SUITE_MODULES:
            allowed = ", ".join(sorted(SUITE_MODULES))
            raise pytest.UsageError(
                f"Unknown suite '{suite}'. Allowed suites: {allowed}"
            )

    profile_selection = selection_from_profile(profile)
    cli_selection = SelectionOptions(
        include_suites=selected_suites,
        exclude_suites=parse_csv_values(config.getoption("exclude_suite")),
        include_backends=parse_csv_values(config.getoption("backend")),
        exclude_backends=parse_csv_values(config.getoption("exclude_backend")),
        include_cases=parse_csv_values(config.getoption("case")),
        exclude_cases=parse_csv_values(config.getoption("exclude_case")),
        include_tags=parse_csv_values(config.getoption("tag")),
        exclude_tags=parse_csv_values(config.getoption("exclude_tag")),
    )
    selection = merge_selection(profile_selection, cli_selection)

    discovered = []
    for suite in selected_suites:
        suite_module = SUITE_MODULES[suite]
        target_configs = suite_module.load_target_configs(
            tuple(str(path) for path in suite_module.default_config_files())
        )
        discovered.extend(suite_module.discover(target, target_configs))

    cases = filter_cases(discovered, selection)
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


def _load_profile(path: str | None) -> dict:
    if path is None:
        return {}
    profile_path = Path(path)
    with profile_path.open("r", encoding="utf-8") as f:
        return json.load(f)
