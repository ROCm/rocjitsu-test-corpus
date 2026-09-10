# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Shared kernel-only sampling and workload result helpers."""

from __future__ import annotations
import json
from pathlib import Path
import sys
import time
from typing import Any, Callable
import torch


def target_matches(reported: str, expected: str) -> bool:
    return reported == expected or reported.startswith(expected + ":")


def reported_target() -> str:
    properties = torch.cuda.get_device_properties(0)
    for attribute in ("gcnArchName", "gcn_arch_name"):
        value = getattr(properties, attribute, None)
        if value:
            return str(value)
    raise RuntimeError(
        "ROCm PyTorch did not expose gcnArchName in device properties; "
        "target provenance cannot be validated"
    )


def measure(launch: Callable[[], None], warmups: int, samples: int) -> list[int]:
    # Compile and initialize Triton's launch path before the requested warmups.
    launch()
    torch.cuda.synchronize()

    for _ in range(warmups):
        launch()
        torch.cuda.synchronize()

    durations: list[int] = []
    for _ in range(samples):
        start = time.perf_counter_ns()
        launch()
        torch.cuda.synchronize()
        duration = time.perf_counter_ns() - start
        if duration <= 0:
            raise RuntimeError("measured a non-positive dispatch duration")
        durations.append(duration)
    return durations


def deterministic_tensor(
    shape: tuple[int, ...], dtype: torch.dtype, phase: int = 0
) -> torch.Tensor:
    """Create repeatable, nonzero input data with one guest dispatch."""
    value = ((phase % 251) + 1) / 251.0
    return torch.full(shape, value, device="cuda", dtype=dtype)


def write_result(path: str, result: dict[str, Any]) -> None:
    encoded = json.dumps(result, indent=2, sort_keys=True, allow_nan=False) + "\n"
    if path == "-":
        sys.stdout.write(encoded)
        return
    output = Path(path)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(encoded, encoding="utf-8")
