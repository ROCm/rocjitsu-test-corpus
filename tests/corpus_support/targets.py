"""Target capability loading and target resolution helpers.

Targets are concrete gfx names. HIP architectures are derived from the target
name, so target capability entries only describe suite support/defaults.
"""

from __future__ import annotations

import json
from pathlib import Path

from .model import TargetSpec


TARGET_CAPABILITIES_FILE = Path(__file__).resolve().parent / "target_capabilities.json"


def load_targets() -> dict[str, TargetSpec]:
    entries = _load_targets_entries(TARGET_CAPABILITIES_FILE)
    return {
        target: _target_spec_from_entry(target, entry)
        for target, entry in entries.items()
    }


def require_target(target_name: str) -> TargetSpec:
    targets = load_targets()
    if target_name not in targets:
        available = ", ".join(sorted(targets))
        raise ValueError(
            f"Unknown target '{target_name}'. Available targets: {available}"
        )
    return targets[target_name]


def normalize_target_config(path: str | Path, config: dict) -> dict:
    if "target" not in config:
        raise ValueError(f"{path} is missing required field 'target'")
    target = config["target"]
    expected_hip_architectures = [target]
    hip_architectures = config.get("hip_architectures", expected_hip_architectures)
    if hip_architectures != expected_hip_architectures:
        raise ValueError(
            f"{path} field 'hip_architectures' must be {expected_hip_architectures!r}"
        )
    config["hip_architectures"] = expected_hip_architectures
    return config


def supports_target(target: TargetSpec, target_config: dict) -> bool:
    return target_config.get("target") == target.target


def load_target_spec(
    config_path: str | Path,
    *,
    target_name: str | None = None,
) -> TargetSpec:
    path = Path(config_path)
    with path.open("r", encoding="utf-8") as f:
        data = json.load(f)

    if "target" in data:
        return _target_spec_from_entry(data["target"], data)

    entries = _load_targets_entries(path, data=data)
    if target_name is None:
        if len(entries) != 1:
            raise ValueError(
                f"{path} contains multiple targets; provide --target to choose one."
            )
        target_name = next(iter(entries))
    if target_name not in entries:
        available = ", ".join(sorted(entries))
        raise ValueError(
            f"{path} does not define target '{target_name}'. Available targets: {available}"
        )
    return _target_spec_from_entry(target_name, entries[target_name])


def _load_targets_entries(path: Path, *, data: dict | None = None) -> dict[str, dict]:
    if data is None:
        with path.open("r", encoding="utf-8") as f:
            data = json.load(f)
    entries: dict[str, dict] = {}
    for target_name, entry in data.items():
        if str(target_name).startswith("_"):
            continue
        if not isinstance(entry, dict):
            raise ValueError(f"{path} entry '{target_name}' must be an object")
        entries[str(target_name)] = entry
    return entries


def _target_spec_from_entry(target_name: str, entry: dict) -> TargetSpec:
    return TargetSpec(
        target=target_name,
        supported_suites=tuple(entry.get("supported_suites", [])),
        suite_defaults=entry.get("suite_defaults", {}),
    )
