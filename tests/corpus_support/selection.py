"""Selection parsing and deterministic include/exclude filtering.

This module converts CLI/profile selector inputs into `SelectionOptions` and
applies suite/backend/case/tag filters to discovered `CorpusCase` rows before
pytest parametrization.
"""

from __future__ import annotations

from dataclasses import asdict

from .model import CorpusCase, SelectionOptions


def parse_csv_values(values: list[str] | tuple[str, ...] | None) -> tuple[str, ...]:
    if not values:
        return ()
    parsed: list[str] = []
    for value in values:
        for piece in str(value).split(","):
            stripped = piece.strip()
            if stripped:
                parsed.append(stripped)
    return tuple(parsed)


def selection_from_profile(profile: dict | None) -> SelectionOptions:
    if not profile:
        return SelectionOptions()
    include = profile.get("include", {})
    exclude = profile.get("exclude", {})
    return SelectionOptions(
        include_suites=tuple(include.get("suites", [])),
        exclude_suites=tuple(exclude.get("suites", [])),
        include_backends=tuple(
            include.get("backends", include.get("kernel_backends", []))
        ),
        exclude_backends=tuple(
            exclude.get("backends", exclude.get("kernel_backends", []))
        ),
        include_cases=tuple(include.get("cases", [])),
        exclude_cases=tuple(exclude.get("cases", [])),
        include_tags=tuple(include.get("tags", [])),
        exclude_tags=tuple(exclude.get("tags", [])),
    )


def merge_selection(*selections: SelectionOptions) -> SelectionOptions:
    merged: dict[str, list[str]] = {
        "include_suites": [],
        "exclude_suites": [],
        "include_backends": [],
        "exclude_backends": [],
        "include_cases": [],
        "exclude_cases": [],
        "include_tags": [],
        "exclude_tags": [],
    }
    for selection in selections:
        for key, values in asdict(selection).items():
            merged[key].extend(values)
    return SelectionOptions(**{key: tuple(values) for key, values in merged.items()})


def filter_cases(cases: list[CorpusCase], selection: SelectionOptions) -> list[CorpusCase]:
    filtered: list[CorpusCase] = []
    for case in cases:
        if not _include_match(case, selection):
            continue
        if _exclude_match(case, selection):
            continue
        filtered.append(case)
    return filtered


def _include_match(case: CorpusCase, selection: SelectionOptions) -> bool:
    if selection.include_suites and case.suite not in selection.include_suites:
        return False
    if case.suite == "kernels" and selection.include_backends:
        if case.backend is None or case.backend not in selection.include_backends:
            return False
    if selection.include_cases and not _matches_case_selector(case, selection.include_cases):
        return False
    if selection.include_tags and not set(case.tags).intersection(selection.include_tags):
        return False
    return True


def _exclude_match(case: CorpusCase, selection: SelectionOptions) -> bool:
    if case.suite in selection.exclude_suites:
        return True
    if case.suite == "kernels" and case.backend is not None and case.backend in selection.exclude_backends:
        return True
    if _matches_case_selector(case, selection.exclude_cases):
        return True
    if set(case.tags).intersection(selection.exclude_tags):
        return True
    return False


def _matches_case_selector(case: CorpusCase, selectors: tuple[str, ...]) -> bool:
    if case.id in selectors:
        return True
    if case.metadata.get("name") in selectors:
        return True
    return any(selector in selectors for selector in case.selector_names)
