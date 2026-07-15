from __future__ import annotations

import hashlib
import json
import os
from dataclasses import replace
from pathlib import Path

import pytest

from support.define_contracts import CorpusCase, RunContext, SelectionOptions
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
            target_cases.extend(suite_module.discover(target, suite_config_cache[suite]))
        discovered.extend(filter_cases(target_cases, selection))

    worker_groups = _requested_worker_groups(config)
    cases = _annotate_suite_shards(discovered, worker_groups)
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
        marks.append(pytest.mark.xdist_group(case.metadata["suite_shard"]))
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
        run_wrapper=pytestconfig.getoption("run_wrapper"),
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


def _annotate_suite_shards(
    cases: list[CorpusCase],
    worker_groups: int,
) -> list[CorpusCase]:
    annotated: list[CorpusCase] = []
    for case in cases:
        shard_index = _suite_shard_index(case, worker_groups)
        shard_name = f"{case.suite}_shard_{shard_index}"
        build = dict(case.build)
        build["suite_shard"] = shard_name
        metadata = dict(case.metadata)
        metadata["suite_shard"] = shard_name
        metadata["suite_shard_index"] = shard_index
        annotated.append(replace(case, build=build, metadata=metadata))
    return annotated


def _suite_shard_index(case: CorpusCase, worker_groups: int) -> int:
    if worker_groups <= 1:
        return 0
    digest = hashlib.sha256(f"{case.suite}:{case.id}".encode("utf-8")).digest()
    return int.from_bytes(digest[:8], byteorder="big", signed=False) % worker_groups


def _requested_worker_groups(config) -> int:
    worker_count = os.getenv("PYTEST_XDIST_WORKER_COUNT")
    if worker_count:
        try:
            return max(1, int(worker_count))
        except ValueError:
            pass
    numprocesses = getattr(config.option, "numprocesses", None)
    if numprocesses in (None, 0, "0"):
        return 1
    if isinstance(numprocesses, int):
        return max(1, numprocesses)
    text = str(numprocesses).strip().lower()
    if text in {"", "no"}:
        return 1
    if text in {"auto", "logical"}:
        return max(1, os.cpu_count() or 1)
    try:
        return max(1, int(text))
    except ValueError:
        return 1


