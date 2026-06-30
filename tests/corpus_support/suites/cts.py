"""CTS/FPSAN suite adapter with native Python configure/build/ctest execution.

This module discovers CTS rows (including FPSAN collections), configures/builds
the CTS project once per target config, and runs selected tests via CTest.
"""

from __future__ import annotations

import json
import os
import re
import shlex
import shutil
import subprocess
from pathlib import Path

from ..model import BuildResult, CorpusCase, RunContext, TargetSpec
from ..targets import normalize_target_config, supports_target


REPO_ROOT = Path(__file__).resolve().parents[3]
CONFIGS_ROOT = REPO_ROOT / "corpus" / "cts" / "configs"
CTS_SOURCE_DIR = REPO_ROOT / "corpus" / "cts"


def default_config_files() -> tuple[Path, ...]:
    return tuple(sorted(CONFIGS_ROOT.glob("*.json")))


def load_target_configs(config_files: tuple[str, ...] | list[str]) -> list[dict]:
    configs: list[dict] = []
    for config_file in config_files:
        config_path = _resolve_repo_path(config_file)
        with config_path.open("r", encoding="utf-8") as f:
            config = json.load(f)
        normalize_target_config(config_path, config)
        for field in ("config_name", "tests"):
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
                        "target_config": target_config,
                    },
                    selector_names=(test_name,),
                )
            )
    return discovered


def build(case: CorpusCase, context: RunContext) -> BuildResult | None:
    target_config = case.metadata["target_config"]
    config_name = target_config["config_name"]
    build_root = context.artifact_directory / "cts" / config_name
    build_dir = build_root / "build"
    logs_dir = build_root / "logs"
    logs_dir.mkdir(parents=True, exist_ok=True)

    configure_cmd = [
        "cmake",
        "-S",
        str(CTS_SOURCE_DIR),
        "-B",
        str(build_dir),
    ]
    hip_architectures = target_config.get("hip_architectures", [])
    if hip_architectures:
        configure_cmd.append(
            "-DCMAKE_HIP_ARCHITECTURES=" + ";".join(hip_architectures)
        )
    rocm_path = _detect_rocm_path()
    if rocm_path:
        configure_cmd.append(f"-DROCM_PATH={rocm_path}")

    _run_command(
        configure_cmd,
        cwd=REPO_ROOT,
        log_path=logs_dir / "configure.log",
        phase="configure",
    )

    return BuildResult(
        cache_key="",
        build_dir=build_dir,
        executable_path=None,
        metadata={"logs_dir": str(logs_dir)},
    )


def run(case: CorpusCase, build_result: BuildResult, context: RunContext) -> None:
    if context.skip_all_runs:
        return
    test_name = case.metadata["name"]
    build_dir = build_result.build_dir
    logs_dir = Path(build_result.metadata["logs_dir"])
    safe_name = _sanitize_log_component(test_name)

    if not test_name.startswith("fpsan_neg_"):
        _run_command(
            ["cmake", "--build", str(build_dir), "--target", test_name],
            cwd=REPO_ROOT,
            log_path=logs_dir / f"{safe_name}.build.log",
            phase="build",
        )

    _run_command(
        [
            "ctest",
            "--test-dir",
            str(build_dir),
            "-R",
            f"^{re.escape(test_name)}$",
            "--output-on-failure",
        ],
        cwd=REPO_ROOT,
        log_path=logs_dir / f"{safe_name}.ctest.log",
        phase="ctest",
    )


def _resolve_repo_path(path: str | Path) -> Path:
    path = Path(path)
    if path.is_absolute():
        return path
    return REPO_ROOT / path


def _supports_target(target: TargetSpec, target_config: dict) -> bool:
    return supports_target(target, target_config)


def _sanitize_id_component(value: str) -> str:
    return value.replace("/", "_").replace(":", "_")


def _sanitize_log_component(value: str) -> str:
    return re.sub(r"[^A-Za-z0-9_.-]", "_", value)


def _run_command(
    command: list[str],
    *,
    cwd: Path,
    log_path: Path,
    phase: str,
) -> None:
    resolved = _resolve_command(command)
    process = subprocess.run(
        resolved,
        cwd=str(cwd),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        errors="replace",
        check=False,
    )
    log_path.parent.mkdir(parents=True, exist_ok=True)
    log_path.write_text(
        "\n".join(
            [
                "$ " + " ".join(shlex.quote(part) for part in resolved),
                f"cwd: {cwd}",
                f"returncode: {process.returncode}",
                "",
                "stdout:",
                process.stdout,
                "",
                "stderr:",
                process.stderr,
            ]
        ),
        encoding="utf-8",
    )
    if process.returncode != 0:
        raise RuntimeError(
            "\n".join(
                [
                    f"CTS {phase} failed.",
                    f"log: {log_path}",
                    "command: " + " ".join(resolved),
                    f"returncode: {process.returncode}",
                    "stdout:",
                    process.stdout or "<empty>",
                    "stderr:",
                    process.stderr or "<empty>",
                ]
            )
        )


def _resolve_command(command: list[str]) -> list[str]:
    first = command[0]
    if os.sep in first:
        path = Path(first)
        if not path.exists():
            raise FileNotFoundError(first)
        return command
    tool = shutil.which(first)
    if tool is None:
        raise RuntimeError(f"Missing required tool '{first}' in PATH")
    return [tool] + command[1:]


def _detect_rocm_path() -> str | None:
    env_value = os.getenv("ROCM_PATH")
    if env_value and _has_hip_config(Path(env_value)):
        return env_value

    for candidate in (Path("/opt/rocm"), Path("/opt/rocm-7.2.4")):
        if _has_hip_config(candidate):
            return str(candidate)
    return None


def _has_hip_config(root: Path) -> bool:
    return (root / "lib" / "cmake" / "hip" / "hip-config.cmake").exists()
