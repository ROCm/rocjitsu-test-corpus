"""Standalone semantic programs with launcher-neutral result validation."""

from __future__ import annotations

import os
from pathlib import Path
import shlex
import shutil
import subprocess
import sys

from support.define_contracts import (
    BuildResult,
    BuildState,
    CorpusCase,
    RunContext,
    TargetSpec,
)
from support.prepare_inputs import load_suite_target_configs, supports_target

REPO_ROOT = Path(__file__).resolve().parents[2]
CORPUS_ROOT = REPO_ROOT / "corpus" / "semantics" / "gfx1250"
CONFIGS_ROOT = CORPUS_ROOT.parent / "configs"
SCRIPTS_ROOT = CORPUS_ROOT / "scripts"
if str(SCRIPTS_ROOT) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_ROOT))

from result_protocol import (  # noqa: E402
    ResultError,
    case_tests,
    compare_records,
    expected_records,
    load_manifest,
    parse_records,
)


def default_config_files() -> tuple[Path, ...]:
    return tuple(sorted(CONFIGS_ROOT.glob("*.json")))


def load_target_configs(config_files: tuple[str, ...] | list[str]) -> list[dict]:
    return load_suite_target_configs(config_files, repo_root=REPO_ROOT)


def discover(
    target: TargetSpec,
    target_configs: list[dict],
) -> list[CorpusCase]:
    manifest_path = CORPUS_ROOT / "cases.toml"
    manifest = load_manifest(manifest_path)
    contracts = expected_records(manifest)
    selectors_by_test: dict[str, list[str]] = {test: [] for test in contracts}
    for case_id, test in case_tests(manifest).items():
        selectors_by_test[test].append(case_id)

    discovered = []
    for target_config in target_configs:
        if not supports_target(target, target_config):
            continue
        for test in sorted(contracts):
            discovered.append(
                CorpusCase(
                    id=f"semantics.{target.target}.{test}",
                    suite="semantics",
                    target=target.target,
                    collection="gfx1250",
                    backend=None,
                    path=CORPUS_ROOT / "test_cases" / f"{test}.hip",
                    build={
                        "system": "cmake",
                        "config_name": target_config["config_name"],
                    },
                    run={"kind": "semantic-binary"},
                    metadata={
                        "name": test,
                        "test": test,
                        "expected_records": contracts[test],
                        "target_config": target_config,
                    },
                    selector_names=tuple(selectors_by_test[test]),
                )
            )
    return discovered


def build(
    case: CorpusCase,
    context: RunContext,
    build_state: BuildState,
) -> BuildResult:
    shard = str(case.metadata["suite_shard"])
    config_name = case.metadata["target_config"]["config_name"]
    build_root = context.artifact_directory / "semantics" / shard / config_name
    build_dir = build_root / "build"
    logs_dir = build_root / "logs"
    logs_dir.mkdir(parents=True, exist_ok=True)
    test = case.metadata["test"]

    if build_dir not in build_state.configured_build_dirs:
        _run_command(
            [
                "cmake",
                "-S",
                str(CORPUS_ROOT),
                "-B",
                str(build_dir),
                "-G",
                "Ninja",
                f"-DHIPCC={_resolve_hipcc()}",
            ],
            cwd=REPO_ROOT,
            log_path=logs_dir / "configure.log",
            phase="configure",
        )
        build_state.configured_build_dirs = build_state.configured_build_dirs | {
            build_dir
        }

    _run_command(
        [
            "cmake",
            "--build",
            str(build_dir),
            "--target",
            f"check-semantic-{test}",
        ],
        cwd=REPO_ROOT,
        log_path=logs_dir / f"{test}.build.log",
        phase="build",
    )
    return BuildResult(
        build_dir=build_dir,
        executable_path=None,
        metadata={"logs_dir": str(logs_dir)},
    )


def run(case: CorpusCase, build_result: BuildResult, context: RunContext) -> None:
    if context.skip_all_runs:
        return
    assert build_result.build_dir is not None
    test = case.metadata["test"]
    if test in case.metadata["target_config"].get("skip_run_tests", []):
        return

    logs_dir = Path(build_result.metadata["logs_dir"])
    binary = build_result.build_dir / "bin" / test
    if context.comparison_run_wrapper is None:
        _run_semantic_binary(
            case=case,
            binary=binary,
            wrapper=context.run_wrapper,
            log_path=logs_dir / f"{test}.run.log",
            label=f"semantics suite: {test}",
            record_only=False,
        )
        return

    reference_log = logs_dir / f"{test}.reference.run.log"
    comparison_log = logs_dir / f"{test}.comparison.run.log"
    reference_records = _run_semantic_binary(
        case=case,
        binary=binary,
        wrapper=context.run_wrapper,
        log_path=reference_log,
        label=f"semantics reference: {test}",
        record_only=False,
    )
    candidate_records = _run_semantic_binary(
        case=case,
        binary=binary,
        wrapper=context.comparison_run_wrapper,
        log_path=comparison_log,
        label=f"semantics comparison: {test}",
        record_only=True,
        required_stderr=context.comparison_required_stderr,
    )
    try:
        compare_records(
            test=test,
            reference_records=reference_records,
            candidate_records=candidate_records,
        )
    except ResultError as error:
        raise RuntimeError(
            f"{error}; logs: {reference_log}, {comparison_log}"
        ) from error


def _run_semantic_binary(
    *,
    case: CorpusCase,
    binary: Path,
    wrapper: str | None,
    log_path: Path,
    label: str,
    record_only: bool,
    required_stderr: tuple[str, ...] = (),
) -> list[dict]:
    test = case.metadata["test"]
    command = [*_run_wrapper(wrapper), str(binary.resolve())]
    resolved = _resolve_command(command)
    environment = os.environ.copy()
    if record_only:
        environment["CORPUS_RECORD_ONLY"] = "1"
    process = subprocess.run(
        resolved,
        cwd=str(REPO_ROOT),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        errors="replace",
        check=False,
        env=environment,
    )
    log_path.write_text(
        "\n".join(
            [
                "$ " + shlex.join(resolved),
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
    if process.returncode:
        raise RuntimeError(f"{label} failed; log: {log_path}")
    missing_stderr = [
        fragment for fragment in required_stderr if fragment not in process.stderr
    ]
    if missing_stderr:
        raise RuntimeError(
            f"{label} stderr is missing {missing_stderr!r}; log: {log_path}"
        )
    try:
        return parse_records(
            label=label,
            stdout=process.stdout,
            test=test,
            expected_keys=case.metadata["expected_records"],
        )
    except ResultError as error:
        raise RuntimeError(f"{error}; log: {log_path}") from error


def _resolve_hipcc() -> Path:
    if rocm_path := os.getenv("ROCM_PATH"):
        for candidate in (
            Path(rocm_path) / "bin" / "hipcc",
            Path(rocm_path) / "bin" / "amdclang++",
            Path(rocm_path) / "lib" / "llvm" / "bin" / "amdclang++",
        ):
            if candidate.is_file():
                return candidate.resolve()
    if hipcc := shutil.which("hipcc"):
        return Path(hipcc).resolve()
    raise ValueError("HIP compiler is unavailable; set ROCM_PATH or add hipcc to PATH")


def _run_wrapper(value: str | None) -> list[str]:
    return shlex.split(value) if value else []


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
    log_path.write_text(
        "\n".join(
            [
                "$ " + shlex.join(resolved),
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
    if process.returncode:
        raise RuntimeError(f"semantics suite {phase} failed; log: {log_path}")


def _resolve_command(command: list[str]) -> list[str]:
    executable = shutil.which(command[0])
    if executable is None:
        raise RuntimeError(f"missing required tool '{command[0]}'")
    return [executable, *command[1:]]
