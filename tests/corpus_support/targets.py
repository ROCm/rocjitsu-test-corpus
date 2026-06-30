"""Target helpers for the unified corpus pytest flow."""

from __future__ import annotations

import re

from .model import TargetSpec


def make_target_spec(target_name: str) -> TargetSpec:
    if not re.fullmatch(r"gfx[0-9A-Za-z]+", target_name):
        raise ValueError(f"Target '{target_name}' must be a concrete gfx target")
    return TargetSpec(target=target_name)


def supports_target(target: TargetSpec, target_config: dict) -> bool:
    return target_config.get("target") == target.target
