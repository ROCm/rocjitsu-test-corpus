# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Reuse native corpus discovery, parameters, and builds for benchmarks."""

from __future__ import annotations

import dataclasses
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tests"))
from test_suites import kernels, kernels_impl  # noqa: E402
from support.define_contracts import RunContext, TargetSpec  # noqa: E402
from support.manage_builds import BuildManager  # noqa: E402


def resolve(entry, targets):
    configs = kernels.load_target_configs(kernels.default_config_files())
    matches = tuple(
        case
        for target in targets
        for case in kernels.discover(TargetSpec(target), configs)
        if case.metadata["name"] == entry["case"]
        and case.run["variant"] == entry["variant"]
    )
    if not matches:
        raise ValueError(f"unknown or unsupported corpus case/variant: {entry}")
    if len({case.target for case in matches}) != len(matches):
        raise ValueError(f"ambiguous corpus case: {entry}")
    for case in matches:
        config = case.metadata["target_config"]
        if (
            case.expected_compile_failure
            or case.expected_run_failure
            or kernels_impl.matches_case_selector(
                case.metadata["kernel_case"], config.get("skip_run_tests", [])
            )
        ):
            raise ValueError(f"case is not runnable for benchmarking: {case.id}")
        variant = case.metadata["kernel_case"].test
        if (
            not case.metadata["effective_case"].get("benchmark")
            or not variant
            or "parameters" not in variant
        ):
            raise ValueError(f"case has no structured benchmark capability: {entry}")
    return matches


def build_manager(repo_root, artifact_root):
    return BuildManager(RunContext(repo_root, artifact_root, False))


def build(case, manager, rocm_path):
    """Use the correctness build adapter with an isolated Release profile."""
    config = dict(case.metadata["target_config"])
    cache = {key: "OFF" for key in kernels_impl.KERNEL_CORPUS_ENABLE_CACHE_VARIABLES}
    cache.update(
        KERNEL_CORPUS_ENABLE_HIPKITTENS="ON",
        CMAKE_BUILD_TYPE="Release",
        ROCM_PATH=str(rocm_path),
    )
    config["cmake"] = {"cache_variables": cache}
    config["run_environment"] = {
        **config.get("run_environment", {}),
        "ROCM_PATH": str(rocm_path),
    }
    case = dataclasses.replace(
        case,
        metadata={**case.metadata, "target_config": config},
        build={**case.build, "profile": "benchmark", "rocm_path": str(rocm_path)},
    )
    return manager.ensure_built(case, kernels)


def command(case, built, *, case_id, target, warmups, samples, output):
    payload = (
        str(built.executable_path),
        *map(str, case.metadata["effective_case"]["run"]["args"]),
        "--benchmark",
        "--case",
        case_id,
        "--target",
        target,
        "--warmups",
        str(warmups),
        "--samples",
        str(samples),
        "--output",
        str(output),
    )
    environment = kernels_impl.command_environment(
        built.metadata["target_config"],
        case.metadata["effective_case"]["run"].get("env", {}),
    )
    environment.pop("HIPBLASLT_TENSILE_LIBPATH", None)
    return payload, environment
