"""IREE suite adapter for the unified corpus entrypoint.

This adapter translates legacy IREE corpus discovery/build/run logic into the
common `CorpusCase`/`BuildResult` interface used by `tests/test_corpus.py`.
"""

from __future__ import annotations

from pathlib import Path

from ..model import BuildResult, CorpusCase, RunContext, TargetSpec

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
                    tags=tuple(["iree"] + list(case.get("tags", []))),
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
    return BuildResult(
        cache_key="",
        build_dir=None,
        executable_path=None,
        metadata={},
    )


def run(case: CorpusCase, build_result: BuildResult, context: RunContext) -> None:
    target_config = dict(case.metadata["target_config"])
    compile_only = context.skip_all_runs or (
        case.metadata["name"] in target_config.get("skip_run_tests", [])
    )
    legacy_iree.run_case(
        case.metadata["case_path"],
        target_config,
        str(context.artifact_directory),
        compile_only=compile_only,
        run_wrapper=None,
    )


def _supports_target(target: TargetSpec, target_config: dict) -> bool:
    compile_flags = " ".join(target_config.get("iree_compile_flags", []))
    if any(hip_arch in compile_flags for hip_arch in target.hip_architectures):
        return True
    return target.target in target_config.get("config_name", "")
