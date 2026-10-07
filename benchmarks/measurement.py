# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Shared kernel-only sampling and workload result helpers."""

from __future__ import annotations
import json
from pathlib import Path
import sys
import time
from collections.abc import Callable, Sequence
from typing import Any
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


class TritonLaunch:
    """Keep identical arguments for compile-only preparation and execution."""

    def __init__(
        self, kernel, grid, *args, keepalive=(),
        before_launch: Callable[[], None] | None = None, **kwargs,
    ):
        self.kernel, self.grid = kernel, grid
        self.args, self.kwargs = args, kwargs
        # Grouped GEMM passes pointer tables; retain the tensors they address.
        self.keepalive = keepalive
        self.before_launch = before_launch

    def compile(self) -> None:
        compiled = self.kernel.warmup(*self.args, grid=self.grid, **self.kwargs)
        # Accessing run initializes the launcher and loads the binary, without
        # executing it. Do this here rather than on the first timed call.
        _ = compiled.run

    def __call__(self) -> None:
        self.kernel[self.grid](*self.args, **self.kwargs)


def measure(
    launch: Callable[[], None],
    warmups: int,
    samples: int,
    progress: Callable[[dict[str, Any]], None] | None = None,
    *,
    before_launch: Callable[[], None] | None = None,
) -> list[int]:
    """Sample launches with progress callbacks outside timed intervals."""
    durations: list[int] = []

    def run(stage: str, index: int) -> int:
        stage_start = time.monotonic_ns()
        if progress is not None:
            progress(
                {
                    "stage": stage,
                    "index": index,
                    "monotonic_start_ns": stage_start,
                    "monotonic_end_ns": None,
                    "timings_ns": list(durations),
                }
            )
        if before_launch is not None:
            before_launch()
            torch.cuda.synchronize()
        start = time.perf_counter_ns()
        launch()
        torch.cuda.synchronize()
        duration = time.perf_counter_ns() - start
        stage_end = time.monotonic_ns()
        if duration <= 0:
            raise RuntimeError("measured a non-positive dispatch duration")
        if stage == "sample":
            durations.append(duration)
        if progress is not None:
            progress(
                {
                    "stage": stage,
                    "index": index,
                    "monotonic_start_ns": stage_start,
                    "monotonic_end_ns": stage_end,
                    "duration_ns": duration,
                    "timings_ns": list(durations),
                }
            )
        return duration

    for index in range(warmups):
        print(f"benchmark: warmup {index + 1}/{warmups}", file=sys.stderr, flush=True)
        run("warmup", index + 1)
    for index in range(samples):
        duration = run("sample", index + 1)
        print(
            f"benchmark: sample {index + 1}/{samples} {duration} ns",
            file=sys.stderr,
            flush=True,
        )
    return durations


def progress_writer(
    output_path: str, case: str,
) -> Callable[[dict[str, Any]], None] | None:
    """Return an atomic sidecar writer, or None for stdout-only results."""
    if output_path == "-":
        return None
    path = Path(output_path).with_suffix(".progress.json")
    path.parent.mkdir(parents=True, exist_ok=True)

    def write(event: dict[str, Any]) -> None:
        temporary = path.with_suffix(path.suffix + ".tmp")
        temporary.write_text(json.dumps({"case": case, **event}, sort_keys=True) + "\n")
        temporary.replace(path)

    return write


def to_cpu(tensor: torch.Tensor) -> torch.Tensor:
    # The simulated KMD needs host pages registered for device-to-host copies.
    # Pinned memory uses that public HIP path; pageable tensor.cpu() does not.
    host = torch.empty(tensor.shape, dtype=tensor.dtype, device="cpu", pin_memory=True)
    host.copy_(tensor)
    return host


def poison_outputs(outputs: Sequence[torch.Tensor]) -> None:
    """Invalidate every output before a launch, outside its timed interval."""
    for output in outputs:
        # Byte fill supports FP8 as well as FP16/BF16/FP32. All-ones encodes
        # NaN for these output formats and needs no host-sized poison buffer.
        output.view(torch.uint8).fill_(255)


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
