from __future__ import annotations

import json
from pathlib import Path

from .model import TargetSpec


REPO_ROOT = Path(__file__).resolve().parents[2]
TARGETS_ROOT = REPO_ROOT / "targets"


def load_targets() -> dict[str, TargetSpec]:
    targets: dict[str, TargetSpec] = {}
    for config_path in sorted(TARGETS_ROOT.glob("*.json")):
        with config_path.open("r", encoding="utf-8") as f:
            data = json.load(f)
        target = TargetSpec(
            target=data["target"],
            architecture_family=data["architecture_family"],
            hip_architectures=tuple(data["hip_architectures"]),
            tags=tuple(data.get("tags", [])),
        )
        targets[target.target] = target
    return targets


def require_target(target_name: str) -> TargetSpec:
    targets = load_targets()
    if target_name not in targets:
        available = ", ".join(sorted(targets))
        raise ValueError(f"Unknown target '{target_name}'. Available targets: {available}")
    return targets[target_name]
