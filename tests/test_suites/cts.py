"""CTS/FPSAN suite adapter with native Python configure/build/ctest execution.

This module discovers CTS rows (including FPSAN collections), configures/builds
the CTS project once per target config, and runs selected tests via CTest.
"""

from __future__ import annotations

import os
import re
import shlex
import shutil
import subprocess
from pathlib import Path

from support.define_contracts import BuildResult, CorpusCase, RunContext, TargetSpec
from support.prepare_inputs import load_json, load_suite_target_configs, supports_target


REPO_ROOT = Path(__file__).resolve().parents[2]
CONFIGS_ROOT = REPO_ROOT / "corpus" / "cts" / "configs"
CTS_SOURCE_DIR = REPO_ROOT / "corpus" / "cts"
TEST_CASES_ROOT = CTS_SOURCE_DIR / "test_cases"


def default_config_files() -> tuple[Path, ...]:
    return tuple(sorted(CONFIGS_ROOT.glob("*.json")))


def load_target_configs(config_files: tuple[str, ...] | list[str]) -> list[dict]:
    return load_suite_target_configs(
        config_files,
        repo_root=REPO_ROOT,
    )


def discover(target: TargetSpec, target_configs: list[dict]) -> list[CorpusCase]:
    discovered: list[CorpusCase] = []
    cts_cases = discover_cases()
    for target_config in target_configs:
        if not _supports_target(target, target_config):
            continue
        for cts_case in cts_cases:
            test_name = cts_case["name"]
            collection = cts_case["collection"]
            if target_config["target"] not in cts_case["supported_targets"]:
                continue
            if test_name in target_config.get("skip_compile_tests", []):
                continue
            discovered.append(
                CorpusCase(
                    id=(
                        f"cts.{target.target}.{collection}."
                        f"{_sanitize_id_component(test_name)}"
                    ),
                    suite="cts",
                    target=target.target,
                    collection=collection,
                    backend=None,
                    path=Path(cts_case["_path"]),
                    build={
                        "system": "cmake_ctest",
                        "config_name": target_config["config_name"],
                    },
                    run={"kind": "ctest_case"},
                    metadata={
                        "name": test_name,
                        "cts_case": cts_case,
                        "config_path": target_config["_path"],
                        "target_config": target_config,
                    },
                    selector_names=(test_name,),
                )
            )
    return discovered


def coalesce_cases(cases: list[CorpusCase]) -> list[CorpusCase]:
    grouped_cases: dict[tuple[str, str], list[CorpusCase]] = {}
    for case in cases:
        key = (case.target, case.metadata["config_path"])
        grouped_cases.setdefault(key, []).append(case)

    coalesced: list[CorpusCase] = []
    for group in grouped_cases.values():
        first = group[0]
        target_config = first.metadata["target_config"]
        config_name = target_config["config_name"]
        selected_names = tuple(case.metadata["name"] for case in group)
        coalesced.append(
            CorpusCase(
                id=f"cts.{first.target}.{config_name}.ctest",
                suite="cts",
                target=first.target,
                collection="cts",
                backend=None,
                path=CTS_SOURCE_DIR,
                build=first.build,
                run={"kind": "ctest_selection"},
                metadata={
                    "name": f"{config_name}_ctest_selection",
                    "config_path": first.metadata["config_path"],
                    "target_config": target_config,
                    "selected_cases": tuple(group),
                    "selected_names": selected_names,
                },
                selector_names=selected_names,
            )
        )
    return coalesced


def discover_cases() -> list[dict]:
    cases: list[dict] = []
    for case_file in sorted(TEST_CASES_ROOT.glob("*.json")):
        case_inventory = load_json(case_file)
        collection = case_inventory.get("collection")
        if not isinstance(collection, str) or not collection:
            raise ValueError(f"{case_file} is missing required field 'collection'")
        entries = case_inventory.get("cases")
        if not isinstance(entries, list):
            raise ValueError(f"{case_file} field 'cases' must be a list")
        for entry in entries:
            _validate_case_entry(case_file, entry)
            case = dict(entry)
            case["collection"] = collection
            case["_path"] = str(case_file)
            cases.append(case)
    return cases


def _validate_case_entry(case_file: Path, entry: dict) -> None:
    if not isinstance(entry, dict):
        raise ValueError(f"{case_file} case entries must be objects")
    allowed_fields = {"name", "supported_targets"}
    unknown = sorted(set(entry) - allowed_fields)
    if unknown:
        joined = ", ".join(unknown)
        raise ValueError(f"{case_file} case has unknown field(s): {joined}")
    name = entry.get("name")
    if not isinstance(name, str) or not name:
        raise ValueError(f"{case_file} case field 'name' must be a non-empty string")
    supported_targets = entry.get("supported_targets")
    if not isinstance(supported_targets, list) or not supported_targets:
        raise ValueError(
            f"{case_file} case field 'supported_targets' must be a non-empty list"
        )
    for supported_target in supported_targets:
        if not isinstance(supported_target, str) or not re.fullmatch(
            r"gfx[0-9A-Za-z]+", supported_target
        ):
            raise ValueError(
                f"{case_file} has unsupported target '{supported_target}'"
            )


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
    rocm_path = os.getenv("ROCM_PATH")
    if rocm_path and (Path(rocm_path) / "lib" / "cmake" / "hip" / "hip-config.cmake").exists():
        configure_cmd.append(f"-DROCM_PATH={rocm_path}")

    _run_command(
        configure_cmd,
        cwd=REPO_ROOT,
        log_path=logs_dir / "configure.log",
        phase="configure",
    )

    return BuildResult(
        build_dir=build_dir,
        executable_path=None,
        metadata={"logs_dir": str(logs_dir)},
    )


def run(case: CorpusCase, build_result: BuildResult, context: RunContext) -> None:
    if context.skip_all_runs:
        return
    if case.run.get("kind") == "ctest_selection":
        _run_selected_cases(case, build_result, context)
        return
    _run_single_case(case, build_result, context)


def _run_selected_cases(
    case: CorpusCase, build_result: BuildResult, context: RunContext
) -> None:
    build_dir = build_result.build_dir
    logs_dir = Path(build_result.metadata["logs_dir"])
    selected_names = tuple(case.metadata["selected_names"])
    skipped_run_names = set(case.metadata["target_config"].get("skip_run_tests", []))

    build_names = tuple(
        name for name in selected_names if not name.startswith("fpsan_neg_")
    )
    if build_names:
        _run_command(
            [
                "cmake",
                "--build",
                str(build_dir),
                "--target",
                *build_names,
                "--parallel",
            ],
            cwd=REPO_ROOT,
            log_path=logs_dir / "ctest_selection.build.log",
            phase="build",
        )

    run_names = tuple(name for name in selected_names if name not in skipped_run_names)
    if not run_names:
        return

    _run_command(
        [
            "ctest",
            "--test-dir",
            str(build_dir),
            "-R",
            _ctest_selection_regex(run_names),
            "-j",
            str(context.ctest_jobs),
            "--timeout",
            str(context.ctest_timeout),
            "--output-on-failure",
        ],
        cwd=REPO_ROOT,
        log_path=logs_dir / "ctest_selection.ctest.log",
        phase="ctest",
    )


def _run_single_case(
    case: CorpusCase, build_result: BuildResult, context: RunContext
) -> None:
    test_name = case.metadata["name"]
    build_dir = build_result.build_dir
    logs_dir = Path(build_result.metadata["logs_dir"])
    safe_name = _sanitize_log_component(test_name)

    if not test_name.startswith("fpsan_neg_"):
        _run_command(
            [
                "cmake",
                "--build",
                str(build_dir),
                "--target",
                test_name,
                "--parallel",
            ],
            cwd=REPO_ROOT,
            log_path=logs_dir / f"{safe_name}.build.log",
            phase="build",
        )

    if test_name in case.metadata["target_config"].get("skip_run_tests", []):
        return

    _run_command(
        [
            "ctest",
            "--test-dir",
            str(build_dir),
            "-R",
            f"^({re.escape(test_name)}$|{re.escape(test_name)}\\.)",
            "-j",
            str(context.ctest_jobs),
            "--timeout",
            str(context.ctest_timeout),
            "--output-on-failure",
        ],
        cwd=REPO_ROOT,
        log_path=logs_dir / f"{safe_name}.ctest.log",
        phase="ctest",
    )


def _ctest_selection_regex(test_names: tuple[str, ...]) -> str:
    alternatives = []
    for test_name in sorted(test_names):
        escaped_name = re.escape(test_name)
        alternatives.append(f"{escaped_name}$")
        alternatives.append(f"{escaped_name}\\.")
    return "^(" + "|".join(alternatives) + ")"


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
