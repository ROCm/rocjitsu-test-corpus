from __future__ import annotations

import json
import subprocess
from pathlib import Path

from ..model import BuildResult, CorpusCase, RunContext, TargetSpec


REPO_ROOT = Path(__file__).resolve().parents[3]
DEFAULT_CONFIG = REPO_ROOT / "corpus" / "cts" / "configs" / "general.json"
RUNNER = REPO_ROOT / "tests" / "run_fpsan_ctest.sh"


def default_config_files() -> tuple[Path, ...]:
    configs_root = DEFAULT_CONFIG.parent
    return tuple(sorted(configs_root.glob("*.json")))


def load_target_configs(config_files: tuple[str, ...] | list[str]) -> list[dict]:
    configs: list[dict] = []
    for config_file in config_files:
        config_path = _resolve_repo_path(config_file)
        with config_path.open("r", encoding="utf-8") as f:
            config = json.load(f)
        for field in ("config_name", "hip_architectures", "tests"):
            if field not in config:
                raise ValueError(f"{config_path} is missing required field '{field}'")
        config["_path"] = str(config_path)
        configs.append(config)
    return configs


def discover(target: TargetSpec, target_configs: list[dict]) -> list[CorpusCase]:
    discovered: list[CorpusCase] = []
    for target_config in target_configs:
        if not _supports_target(target, target_config):
            continue
        for test_name in target_config["tests"]:
            discovered.append(
                CorpusCase(
                    id=f"cts.{target.target}.fpsan.{_sanitize_id_component(test_name)}",
                    suite="cts",
                    target=target.target,
                    collection="fpsan",
                    backend=None,
                    path=Path(target_config["_path"]),
                    tags=("cts", "fpsan"),
                    build={
                        "system": "cmake_ctest",
                        "config_name": target_config["config_name"],
                    },
                    run={"kind": "ctest_case"},
                    metadata={
                        "name": test_name,
                        "config_path": target_config["_path"],
                    },
                    selector_names=(test_name,),
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
    if context.skip_all_runs:
        return
    command = [
        str(RUNNER),
        "--config",
        str(case.metadata["config_path"]),
        "--case",
        str(case.metadata["name"]),
        "--limit",
        "1",
    ]
    process = subprocess.run(
        command,
        cwd=str(REPO_ROOT),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        check=False,
    )
    if process.returncode != 0:
        raise RuntimeError(
            "\n".join(
                [
                    "CTS case execution failed.",
                    "command: " + " ".join(command),
                    f"returncode: {process.returncode}",
                    "stdout:",
                    process.stdout or "<empty>",
                    "stderr:",
                    process.stderr or "<empty>",
                ]
            )
        )


def _resolve_repo_path(path: str | Path) -> Path:
    path = Path(path)
    if path.is_absolute():
        return path
    return REPO_ROOT / path


def _supports_target(target: TargetSpec, target_config: dict) -> bool:
    return bool(set(target.hip_architectures).intersection(target_config["hip_architectures"]))


def _sanitize_id_component(value: str) -> str:
    return value.replace("/", "_").replace(":", "_")
