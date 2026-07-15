"""IREE suite adapter for the unified corpus entrypoint.

This adapter translates legacy IREE corpus discovery/build/run logic into the
common `CorpusCase`/`BuildResult` interface used by `tests/test_corpus.py`.
"""

from __future__ import annotations

from pathlib import Path

from support.define_contracts import BuildResult, CorpusCase, RunContext, TargetSpec
from support.prepare_inputs import supports_target

from . import iree_impl as legacy_iree


def default_config_files() -> tuple[Path, ...]:
    return tuple(legacy_iree.default_config_files())


def load_target_configs(config_files: tuple[str, ...] | list[str]) -> list[dict]:
    return legacy_iree.load_target_configs(config_files)


def discover(target: TargetSpec, target_configs: list[dict]) -> list[CorpusCase]:
    discovered: list[CorpusCase] = []
    for case_path in legacy_iree.discover_case_files():
        case = legacy_iree.load_case(case_path)
        relative = Path(case_path).resolve().relative_to(legacy_iree.CORPUS_ROOT).with_suffix("")
        case_token = relative.as_posix().replace("/", ".")
        for target_config in target_configs:
            if not _supports_target(target, target_config):
                continue
            if case["name"] in target_config.get("skip_compile_tests", []):
                continue
            discovered.append(
                CorpusCase(
                    id=f"iree.{target.target}.{case_token}",
                    suite="iree",
                    target=target.target,
                    collection=None,
                    backend=None,
                    path=Path(case_path),
                    build={
                        "system": "iree_compile",
                        "config_name": target_config["config_name"],
                    },
                    run={"kind": "run_module"},
                    metadata={
                        "name": case["name"],
                        "case_path": str(case_path),
                        "target_config": target_config,
                    },
                    selector_names=(case["name"],),
                    expected_compile_failure=case["name"]
                    in target_config.get("expected_compile_failures", []),
                    expected_run_failure=case["name"]
                    in target_config.get("expected_run_failures", []),
                )
            )
    return discovered


def build(case: CorpusCase, context: RunContext) -> BuildResult | None:
    target_config = dict(case.metadata["target_config"])
    artifact_directory = _artifact_directory_for_case(case, context)
    metadata = legacy_iree.build_case(
        case.metadata["case_path"],
        target_config,
        artifact_directory,
    )
    return BuildResult(
        build_dir=None,
        executable_path=None,
        metadata=metadata,
    )


def run(case: CorpusCase, build_result: BuildResult, context: RunContext) -> None:
    target_config = dict(case.metadata["target_config"])
    compile_only = context.skip_all_runs or (
        case.metadata["name"] in target_config.get("skip_run_tests", [])
    )
    artifact_directory = _artifact_directory_for_case(case, context)
    legacy_iree.run_case(
        case.metadata["case_path"],
        target_config,
        artifact_directory,
        compile_only=compile_only,
        run_wrapper=context.run_wrapper,
        modules=build_result.metadata["modules"],
    )


def _supports_target(target: TargetSpec, target_config: dict) -> bool:
    return supports_target(target, target_config)


def _artifact_directory_for_case(case: CorpusCase, context: RunContext) -> Path:
    artifact_directory = context.artifact_directory
    suite_shard = case.build.get("suite_shard")
    if suite_shard:
        artifact_directory = artifact_directory / "_suite_shards" / str(suite_shard)
    return artifact_directory
