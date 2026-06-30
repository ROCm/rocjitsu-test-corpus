"""Shared target config loading for vendored corpus suites.

Corpus config files use a common base contract:
- ``config_name`` is a stable artifact/id component.
- ``target`` is the concrete gfx target selected by pytest.

Runtime/build helpers may need HIP architecture lists, so this module derives
``hip_architectures`` from ``target`` in memory. Config files should not store
that duplicate value.
"""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Iterable


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
