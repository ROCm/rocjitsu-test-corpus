"""Kernels suite adapter for the unified corpus entrypoint.

This adapter wraps legacy kernel case discovery/build/run behavior and exposes
it through normalized `CorpusCase` rows and the shared build/run interface.
"""

from __future__ import annotations

from pathlib import Path

from ..model import BuildResult, CorpusCase, RunContext, TargetSpec
from ..targets import supports_target

from . import kernels_impl as legacy_kernels


def default_config_files() -> tuple[Path, ...]:
    return tuple(legacy_kernels.default_config_files())


def load_target_configs(config_files: tuple[str, ...] | list[str]) -> list[dict]:
    return legacy_kernels.load_target_configs(config_files)


def discover(target: TargetSpec, target_configs: list[dict]) -> list[CorpusCase]:
    discovered: list[CorpusCase] = []
    for kernel_case in legacy_kernels.discover_cases():
        case = kernel_case.case
        backend = case["project"]
        selectors = tuple(legacy_kernels.case_config_names(kernel_case))
        for target_config in target_configs:
            if not _supports_target(target, target_config):
                continue
            if not legacy_kernels.supports_target_config(kernel_case, target_config):
                continue
            if legacy_kernels.matches_case_selector(
                kernel_case, target_config.get("skip_compile_tests", [])
            ):
                continue

            variant = _variant_name(kernel_case)
            discovered.append(
                CorpusCase(
                    id=(
                        f"kernels.{target.target}.{backend}.{case['name']}."
                        f"{_sanitize_id_component(variant)}"
                    ),
                    suite="kernels",
                    target=target.target,
                    collection=None,
                    backend=backend,
                    path=Path(kernel_case.path),
                    tags=tuple(["kernels", backend] + list(case.get("tags", []))),
                    build={
                        "system": "cmake",
                        "config_name": target_config["config_name"],
                        "target": case["build"]["target"],
                    },
                    run={"kind": "kernel_case", "variant": variant},
                    metadata={
                        "name": case["name"],
                        "kernel_case": kernel_case,
                        "target_config": target_config,
                        "effective_case": legacy_kernels.effective_case(kernel_case),
                    },
                    selector_names=selectors,
                    expected_compile_failure=any(
                        selector in target_config.get("expected_compile_failures", [])
                        for selector in selectors
                    ),
                    expected_run_failure=any(
                        selector in target_config.get("expected_run_failures", [])
                        for selector in selectors
                    ),
                )
            )
    return discovered


def build(case: CorpusCase, context: RunContext) -> BuildResult | None:
    effective_case = case.metadata["effective_case"]
    target_config = case.metadata["target_config"]
    kernel_case = case.metadata["kernel_case"]
    artifact_root = legacy_kernels.resolve_repo_path(str(context.artifact_directory))
    run_dir = legacy_kernels._run_dir(artifact_root, target_config, kernel_case)
    run_dir.mkdir(parents=True, exist_ok=True)
    result = legacy_kernels.build_runner(
        effective_case,
        target_config,
        artifact_root,
        run_dir,
    )
    return BuildResult(
        cache_key="",
        build_dir=result.build_dir,
        executable_path=result.executable_path,
        metadata={
            "effective_case": effective_case,
            "target_config": target_config,
            "run_dir": run_dir,
        },
    )


def run(case: CorpusCase, build_result: BuildResult, context: RunContext) -> None:
    if context.skip_all_runs:
        return

    effective_case = build_result.metadata["effective_case"]
    target_config = build_result.metadata["target_config"]
    run_dir = build_result.metadata["run_dir"]
    if legacy_kernels.matches_case_selector(
        case.metadata["kernel_case"], target_config.get("skip_run_tests", [])
    ):
        return
    materialized_inputs = legacy_kernels.materialize_inputs(effective_case, run_dir)
    legacy_kernels.run_executable(
        effective_case,
        target_config,
        build_result.build_dir,
        build_result.executable_path,
        run_dir,
        materialized_inputs,
        run_wrapper=None,
        case_timeout_seconds=None,
    )


def _supports_target(target: TargetSpec, target_config: dict) -> bool:
    return supports_target(target, target_config)


def _variant_name(kernel_case) -> str:
    if kernel_case.test_name is not None:
        return kernel_case.test_name
    if kernel_case.input_set is not None:
        return kernel_case.input_set["name"]
    return "default"


def _sanitize_id_component(value: str) -> str:
    return value.replace("/", "_").replace(":", "_")
