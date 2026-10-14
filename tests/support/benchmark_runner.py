# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Fictional, CPU-only benchmark harness fixtures and shared helpers."""

from __future__ import annotations

import contextlib
import json
import subprocess
from collections.abc import Callable, Mapping, Sequence
from dataclasses import replace
from functools import partial
from pathlib import Path
from types import SimpleNamespace
from typing import Any, TextIO
from unittest import mock

import pytest

from benchmarks import runner


# Keep harness behavior tests independent of the scheduled workload selection.
def harness_suite() -> runner.Suite:
    return runner.Suite(
        name="nightly",
        targets=("gfx950", "gfx1250"),
        timeout_seconds=300,
        cases=(
            runner.Case(
                id="triton.rmsnorm_bf16.threads8",
                workload="rmsnorm",
                suite="Triton",
                name="BF16 RMSNorm",
                operation="RMSNorm",
                targets=("gfx950", "gfx1250"),
                thread_policies=("default", "single"),
                params={
                    "rows": 128,
                    "columns": 4096,
                    "dtype": "bf16",
                    "epsilon": 1e-05,
                },
            ),
            runner.Case(
                id="triton.gemm_bf16_aligned.threads8",
                workload="gemm",
                suite="Triton",
                name="Aligned BF16 GEMM",
                operation="GEMM",
                targets=("gfx950", "gfx1250"),
                thread_policies=("default", "single"),
                params={"m": 256, "n": 256, "k": 512, "dtype": "bf16"},
            ),
            runner.Case(
                id="triton.gpt_oss_attention_bf16.threads8",
                workload="gpt_oss_attention",
                suite="GPT-OSS",
                name="GPT-OSS BF16 attention",
                operation="Attention",
                targets=("gfx950", "gfx1250"),
                thread_policies=("default", "single"),
                params={
                    "dtype": "bf16",
                    "batch": 1,
                    "query_heads": 64,
                    "key_value_heads": 8,
                    "sequence": 128,
                    "window": 128,
                    "head_dimension": 64,
                },
            ),
        ),
    )


@pytest.fixture
def runner_context(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> SimpleNamespace:
    ctx = SimpleNamespace(
        root=tmp_path,
        build=tmp_path / "build",
        rocm=tmp_path / "rocm",
        source=tmp_path / "rocjitsu",
    )
    ctx.rocm.mkdir()
    (ctx.source / "configs").mkdir(parents=True)
    ctx.configs = {}
    for target in ("gfx950", "gfx1250"):
        path = ctx.source / "configs" / f"{target}.json"
        path.write_text(json.dumps({"exec_mode": "functional"}))
        ctx.configs[target] = path
    ctx.build.mkdir()
    _write_cache(ctx)
    executable = ctx.build / "custom launcher"
    executable.write_text("#!/bin/sh\n", encoding="utf-8")
    executable.chmod(0o755)
    ctx.wrapper = f'"{executable}" --config {{config}} --'
    for plugin in ("logging", "race", "throughput"):
        (ctx.build / f"librocjitsu_plugin_{plugin}.so").touch()
    monkeypatch.setattr(runner, "_installed_rocm_path", lambda: ctx.rocm)
    ctx.suite = harness_suite()
    return ctx


def _write_cache(runner_context: SimpleNamespace, **overrides: str) -> None:
    values = {
        "CMAKE_BUILD_TYPE": "Release",
        "CMAKE_HOME_DIRECTORY": str(runner_context.source),
        "LTO": "OFF",
        "RJ_ENABLE_ASAN": "OFF",
        "RJ_ENABLE_MSAN": "OFF",
        "RJ_ENABLE_TSAN": "OFF",
        "RJ_ENABLE_UBSAN": "OFF",
    }
    values.update(overrides)
    (runner_context.build / "CMakeCache.txt").write_text(
        "".join((f"{key}:STRING={value}\n" for key, value in values.items())),
        encoding="utf-8",
    )


def _matrix(
    runner_context: SimpleNamespace,
    *cases: str,
    targets: tuple[str, ...] = ("gfx950",),
) -> tuple[runner.Cell, ...]:
    return runner.select_matrix(
        runner_context.suite,
        cases=cases,
        targets=targets,
        thread_policies=(runner_context.suite.cases[0].thread_policies[0],),
    )


def _with_policy(suite: runner.Suite, policy: str) -> runner.Suite:
    return replace(
        suite,
        cases=tuple(replace(case, thread_policies=(policy,)) for case in suite.cases),
    )


def _cell(runner_context: SimpleNamespace, case_id: str, target: str) -> runner.Cell:
    definition = next(case for case in runner_context.suite.cases if case.id == case_id)
    return runner.Cell(definition, target, "default")


def _artifact(output: Path, test: Mapping[str, Any], name: str) -> Path:
    return output / test["target"] / test["thread_policy"] / "cases" / test["id"] / name


def _payload(cell: runner.Cell, timings: list[int]) -> dict[str, object]:
    return {
        "schema": "rocjitsu.benchmark.workload.v1",
        "case": cell.case,
        "target": cell.target,
        "provider": "triton",
        "parameters": {"fixture": True},
        "timings_ns": timings,
    }


def _successful_process(
    runner_context: SimpleNamespace, argv: Sequence[str], **_kwargs: Any
) -> subprocess.CompletedProcess[str]:
    case = argv[argv.index("--case") + 1]
    target = argv[argv.index("--target") + 1]
    samples = int(argv[argv.index("--samples") + 1])
    output = Path(argv[argv.index("--output") + 1])
    output.write_text(
        json.dumps(
            _payload(_cell(runner_context, case, target), list(range(1, samples + 1)))
        ),
        encoding="utf-8",
    )
    config = json.loads(
        Path(argv[argv.index("--config") + 1]).read_text(encoding="utf-8")
    )
    for plugin in config.get("plugins", {}):
        report = Path(config["sinks"]["dir"]) / f"{plugin}.log"
        report.write_text(f"{plugin} report\n", encoding="utf-8")
    return subprocess.CompletedProcess(argv, 0, "out", "")


def _run(
    runner_context: SimpleNamespace,
    matrix: Sequence[runner.Cell],
    name: str,
    process: Callable[..., subprocess.CompletedProcess[str]] | None = None,
    samples: int | None = None,
    plugin_profile: str = "none",
    progress: TextIO | None = None,
    warmups: int | None = None,
) -> tuple[Path, dict[str, Any]]:
    output = runner_context.root / name

    def fake_native(config: dict[str, Any], *_args: Any) -> runner.TargetMetadata:
        return runner.TargetMetadata(config)

    native_context = (
        contextlib.nullcontext()
        if getattr(runner_context, "native_probe", False)
        else mock.patch.object(
            runner, "_native_target_metadata", side_effect=fake_native
        )
    )
    packages = {"rocm-sdk-devel": "7.2.0", "torch": "2.10.0", "triton": "3.6.0"}
    with native_context, mock.patch.object(
        runner,
        "_source_info",
        return_value={
            "commit_sha": "a" * 40,
            "commit_timestamp": "2026-09-01T21:42:10Z",
        },
    ), mock.patch.object(
        runner,
        "_environment_info",
        return_value={
            "hostname": "benchmark-host",
            "platform": "Linux-test",
            "kernel": "6.14.0",
            "cpu": "test-cpu",
            "python": "3.12.0",
            "packages": packages,
        },
    ), mock.patch.object(
        runner,
        "_run_command",
        side_effect=process or partial(_successful_process, runner_context),
    ):
        result = runner.run_suite(
            runner_context.suite,
            matrix,
            build_dir=runner_context.build,
            output=output,
            samples=1 if samples is None else samples,
            warmups=0 if warmups is None else warmups,
            plugin_profile=plugin_profile,
            progress=progress,
            rocjitsu_source_dir=runner_context.source,
            run_wrapper=runner_context.wrapper,
            target_configs=runner_context.configs,
        )
    return (output, result)
