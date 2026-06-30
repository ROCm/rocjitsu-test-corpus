"""Prepare target configs, target selection, and discovered case filters."""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Iterable

from .define_contracts import CorpusCase, SelectionOptions, TargetSpec


BASE_CONFIG_FIELDS = {"config_name", "target"}
SHARED_CONFIG_FIELDS = {"skip_compile_tests", "skip_run_tests"}
DERIVED_CONFIG_FIELDS = {"hip_architectures", "_path"}


def load_suite_target_configs(
    config_files: Iterable[str | Path],
    *,
    repo_root: Path,
    required_fields: Iterable[str] = (),
    allowed_fields: Iterable[str] = (),
) -> list[dict]:
    configs = []
    for config_file in config_files:
        path = resolve_repo_path(repo_root, config_file)
        config = load_json(path)
        normalize_target_config(path, config)
        validate_shared_fields(path, config)
        require_fields(path, config, tuple(required_fields))
        reject_unknown_fields(path, config, set(allowed_fields))
        config["_path"] = str(path)
        configs.append(config)
    return configs


def resolve_repo_path(repo_root: Path, path: str | Path) -> Path:
    path = Path(path)
    if path.is_absolute():
        return path
    return repo_root / path


def load_json(path: str | Path) -> dict:
    with Path(path).open("r", encoding="utf-8") as f:
        return json.load(f)


def normalize_target_config(path: Path, config: dict) -> None:
    require_fields(path, config, ("config_name", "target"))
    for field in ("config_name", "target"):
        if not isinstance(config[field], str) or not config[field]:
            raise ValueError(f"{path} field '{field}' must be a non-empty string")
    if not re.fullmatch(r"gfx[0-9A-Za-z]+", config["target"]):
        raise ValueError(f"{path} field 'target' must be a concrete gfx target")
    if "hip_architectures" in config:
        raise ValueError(
            f"{path} field 'hip_architectures' is derived from 'target'; "
            "do not store it in config files"
        )
    config["hip_architectures"] = [config["target"]]


def require_fields(path: Path, config: dict, fields: tuple[str, ...]) -> None:
    for field in fields:
        if field not in config:
            raise ValueError(f"{path} is missing required field '{field}'")


def validate_shared_fields(path: Path, config: dict) -> None:
    for field in SHARED_CONFIG_FIELDS:
        if field in config:
            validate_string_list(path, config[field], field)


def validate_string_list(path: Path, value, field: str) -> None:
    if not isinstance(value, list):
        raise ValueError(f"{path} field '{field}' must be a list")
    for item in value:
        if not isinstance(item, str) or not item:
            raise ValueError(f"{path} field '{field}' must contain non-empty strings")


def reject_unknown_fields(path: Path, config: dict, allowed_fields: set[str]) -> None:
    allowed = BASE_CONFIG_FIELDS | SHARED_CONFIG_FIELDS | DERIVED_CONFIG_FIELDS | allowed_fields
    unknown = sorted(set(config) - allowed)
    if unknown:
        joined = ", ".join(unknown)
        raise ValueError(f"{path} has unknown field(s): {joined}")


def make_target_spec(target_name: str) -> TargetSpec:
    if not re.fullmatch(r"gfx[0-9A-Za-z]+", target_name):
        raise ValueError(f"Target '{target_name}' must be a concrete gfx target")
    return TargetSpec(target=target_name)


def supports_target(target: TargetSpec, target_config: dict) -> bool:
    return target_config.get("target") == target.target


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
    return True


def _exclude_match(case: CorpusCase, selection: SelectionOptions) -> bool:
    if case.suite in selection.exclude_suites:
        return True
    if case.suite == "kernels" and case.backend is not None and case.backend in selection.exclude_backends:
        return True
    if _matches_case_selector(case, selection.exclude_cases):
        return True
    return False


def _matches_case_selector(case: CorpusCase, selectors: tuple[str, ...]) -> bool:
    if case.id in selectors:
        return True
    if case.metadata.get("name") in selectors:
        return True
    return any(selector in selectors for selector in case.selector_names)
