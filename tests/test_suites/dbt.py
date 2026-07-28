"""Offline code-object rewrite coverage for RocJITsu DBT profiles."""

from __future__ import annotations

import hashlib
import json
import mmap
import os
import re
import shlex
import shutil
import signal
import struct
import subprocess
import tempfile
import time
from pathlib import Path

import pytest

from support.define_contracts import (
    BuildResult,
    BuildState,
    CorpusCase,
    RunContext,
    TargetSpec,
)
from support.prepare_inputs import load_suite_target_configs, supports_target


REPO_ROOT = Path(__file__).resolve().parents[2]
CONFIGS_ROOT = REPO_ROOT / "corpus" / "dbt" / "configs"
DATA_ONLY_NOOP_WARNING = (
    "warning: data-only: code object has no executable sections, segments, "
    "or callable symbols; leaving unchanged"
)
SHA256_RE = re.compile(r"[0-9a-f]{64}")
SHA256SUM_RE = re.compile(
    r"(?P<digest>[0-9a-f]{64})  "
    r"(?P<path>objects/(?P=digest)\.hsaco)"
)
TRANSLATION_COUNTS_RE = re.compile(
    r"(?m)^  total=(?P<total>[0-9]+) "
    r"changed=(?P<changed>[0-9]+) shown=(?P<shown>[0-9]+)$"
)
SUPPORTED_REVISIONS = {"a0", "b0"}
CLEAN_ENVIRONMENT_KEYS = (
    "GPU_DUMP_CODE_OBJECT",
    "HSA_OVERRIDE_GFX_VERSION",
    "HSA_OVERRIDE_GFX_REVISION",
    "LD_PRELOAD",
    "RJ_CONFIG",
)


def add_pytest_options(parser) -> None:
    parser.addoption(
        "--dbt-corpus",
        action="store",
        default=None,
        help=(
            "Root of a packaged-HSACO extraction to consume with the dbt suite. "
            "Defaults to ROCJITSU_HSACO_CORPUS."
        ),
    )
    parser.addoption(
        "--dbt-translator",
        action="store",
        default=None,
        help=(
            "Path to rj_dbt_translate for the dbt suite. Defaults to "
            "RJ_DBT_TRANSLATE, ROCJITSU_BUILD_DIR/tools/rj_dbt_translate, or PATH."
        ),
    )
    parser.addoption(
        "--dbt-llvm-objdump",
        action="store",
        default=None,
        help=(
            "Path to the TheRock llvm-objdump used to validate translated "
            "code objects. Defaults to ROCJITSU_DBT_LLVM_OBJDUMP, a sibling "
            "of rj_dbt_translate, or PATH."
        ),
    )
    parser.addoption(
        "--dbt-package-lock",
        action="store",
        default=None,
        help=(
            "Consumer-owned package and extraction-input lock for the dbt "
            "suite. Required unless the selected profile embeds one."
        ),
    )
    parser.addoption(
        "--dbt-expected-failures",
        action="store",
        default=None,
        help=(
            "Consumer-owned expected-failure manifest for the dbt suite. "
            "Required unless the selected profile embeds one."
        ),
    )
    parser.addoption(
        "--dbt-expected-rewrites",
        action="store",
        default=None,
        help=(
            "Consumer-owned source-rewrite manifest for the dbt suite. "
            "Required unless the selected profile embeds one."
        ),
    )
    parser.addoption(
        "--dbt-timeout",
        action="store",
        type=float,
        default=None,
        help="Override the DBT profile per-object translator timeout.",
    )
    parser.addoption(
        "--dbt-memory-limit-mib",
        action="store",
        type=int,
        default=None,
        help="Override the DBT profile per-object resident-memory limit.",
    )
    parser.addoption(
        "--dbt-allow-incomplete-corpus",
        action="store_true",
        default=False,
        help=(
            "Allow an extraction whose summary records complete=false, for "
            "example an offline run that deliberately skipped CCOB materialization."
        ),
    )


def default_config_files() -> tuple[Path, ...]:
    return tuple(sorted(CONFIGS_ROOT.glob("*.json")))


def load_target_configs(config_files: tuple[str, ...] | list[str]) -> list[dict]:
    configs = load_suite_target_configs(
        config_files,
        repo_root=REPO_ROOT,
        required_fields=(
            "input_revision",
            "output_revision",
            "memory_limit_mib",
            "timeout_seconds",
        ),
        allowed_fields=(
            "input_revision",
            "output_revision",
            "expected_failures",
            "expected_rewrites",
            "memory_limit_mib",
            "package_lock",
            "timeout_seconds",
        ),
    )
    for config in configs:
        config_path = Path(config["_path"])
        for field in ("input_revision", "output_revision"):
            revision = config[field]
            if revision not in SUPPORTED_REVISIONS:
                allowed = ", ".join(sorted(SUPPORTED_REVISIONS))
                raise ValueError(
                    f"{config_path} field '{field}' must be one of: {allowed}"
                )
        if config["input_revision"] == config["output_revision"]:
            raise ValueError(
                f"{config_path} must use different input_revision and "
                "output_revision values"
            )
        for field in ("expected_failures", "expected_rewrites", "package_lock"):
            if field not in config:
                continue
            value = config[field]
            if not isinstance(value, str) or not value:
                raise ValueError(
                    f"{config_path} field '{field}' must be a non-empty string"
                )
        for field in ("memory_limit_mib", "timeout_seconds"):
            value = config[field]
            if (
                isinstance(value, bool)
                or not isinstance(value, (int, float))
                or value <= 0
            ):
                raise ValueError(
                    f"{config_path} field '{field}' must be a positive number"
                )
    return configs


def discover(
    target: TargetSpec,
    target_configs: list[dict],
    *,
    corpus_directory: str | Path | None,
    translator: str | Path | None,
    timeout_seconds: float | None,
    allow_incomplete: bool,
    memory_limit_mib: int | None = None,
    llvm_objdump: str | Path | None = None,
    expected_failures_path: str | Path | None = None,
    expected_rewrites_path: str | Path | None = None,
    package_lock_path: str | Path | None = None,
) -> list[CorpusCase]:
    matching_configs = [
        config for config in target_configs if supports_target(target, config)
    ]
    if not matching_configs:
        return []
    if timeout_seconds is not None and timeout_seconds <= 0:
        raise ValueError("--dbt-timeout must be greater than zero")
    if memory_limit_mib is not None and memory_limit_mib <= 0:
        raise ValueError("--dbt-memory-limit-mib must be greater than zero")
    matching_configs = [
        _with_consumer_paths(
            config,
            expected_failures_path=expected_failures_path,
            expected_rewrites_path=expected_rewrites_path,
            package_lock_path=package_lock_path,
        )
        for config in matching_configs
    ]

    corpus_root = _resolve_corpus_root(corpus_directory)
    translator_path = _resolve_translator(translator)
    llvm_objdump_path = _resolve_llvm_objdump(llvm_objdump, translator_path)
    summary = _load_json_object(corpus_root / "summary.json")
    _validate_summary(
        corpus_root,
        summary,
        target=target.target,
        allow_incomplete=allow_incomplete,
    )
    input_policy = _validate_package_lock(corpus_root, matching_configs)
    objects = _load_object_manifest(corpus_root)
    if summary["unique_code_objects"] != len(objects):
        raise ValueError(
            f"{corpus_root}/summary.json records "
            f"{summary['unique_code_objects']} unique objects, but "
            f"manifests/SHA256SUMS contains {len(objects)}"
        )
    expected_counts = input_policy["expected_unique_code_objects"]
    baseline_manifest_sha256 = input_policy["baseline_manifest_sha256"]
    extraction_mode = summary.get("ccob_status")
    _validate_baseline_manifest(
        corpus_root,
        set(objects),
        baseline_manifest_sha256,
        extraction_mode,
    )
    count_rule = expected_counts.get(extraction_mode)
    if count_rule is None:
        raise ValueError(
            f"{corpus_root}/summary.json field 'ccob_status' is "
            f"{extraction_mode!r}; the pinned DBT profile has no object-count "
            "rule for that extraction mode"
        )
    _validate_object_count(corpus_root, len(objects), extraction_mode, count_rule)

    discovered: list[CorpusCase] = []
    for target_config in matching_configs:
        expected_failures = _load_expected_failures(target_config)
        expected_rewrites = _load_expected_rewrites(target_config)
        missing_xfails = sorted(set(expected_failures) - set(objects))
        if missing_xfails:
            shown = ", ".join(missing_xfails[:3])
            suffix = "" if len(missing_xfails) <= 3 else ", ..."
            raise ValueError(
                f"{target_config['expected_failures']} contains "
                f"{len(missing_xfails)} digest(s) absent from the extraction: "
                f"{shown}{suffix}"
            )
        missing_rewrites = sorted(set(expected_rewrites) - set(objects))
        if missing_rewrites:
            shown = ", ".join(missing_rewrites[:3])
            suffix = "" if len(missing_rewrites) <= 3 else ", ..."
            raise ValueError(
                f"{target_config['expected_rewrites']} contains "
                f"{len(missing_rewrites)} digest(s) absent from the extraction: "
                f"{shown}{suffix}"
            )
        conflicting_expectations = sorted(
            set(expected_failures) & set(expected_rewrites)
        )
        if conflicting_expectations:
            raise ValueError(
                "DBT digests cannot be both expected failures and expected "
                f"rewrites: {', '.join(conflicting_expectations[:3])}"
            )
        if not expected_rewrites and set(objects) - set(expected_failures):
            raise ValueError(
                f"{target_config['expected_rewrites']} contains no rewrite "
                "expectations for a corpus with non-xfailed objects"
            )

        input_revision = target_config["input_revision"]
        output_revision = target_config["output_revision"]
        selected_timeout = (
            timeout_seconds
            if timeout_seconds is not None
            else target_config["timeout_seconds"]
        )
        selected_memory_limit = (
            memory_limit_mib
            if memory_limit_mib is not None
            else target_config["memory_limit_mib"]
        )
        profile = f"{target.target}.{input_revision}-to-{output_revision}"
        for digest, object_path in objects.items():
            expected_failure = expected_failures.get(digest)
            discovered.append(
                CorpusCase(
                    id=f"dbt.{profile}.{digest}",
                    suite="dbt",
                    target=target.target,
                    collection=f"{input_revision}-to-{output_revision}",
                    backend=None,
                    path=object_path,
                    build={
                        "system": "rj_dbt_translate",
                        "llvm_objdump": str(llvm_objdump_path),
                        "translator": str(translator_path),
                        "input_revision": input_revision,
                        "output_revision": output_revision,
                    },
                    run={"kind": "offline_code_object_rewrite"},
                    metadata={
                        "name": digest,
                        "sha256": digest,
                        "target_config": target_config,
                        "expected_failure": expected_failure,
                        "expected_rewrite": expected_rewrites.get(digest),
                        "memory_limit_bytes": int(selected_memory_limit * 1024 * 1024),
                        "timeout_seconds": selected_timeout,
                    },
                    selector_names=(digest, digest[:16], profile),
                )
            )
    return discovered


def build(
    case: CorpusCase,
    _context: RunContext,
    _build_state: BuildState,
) -> BuildResult:
    translator = Path(case.build["translator"])
    if not translator.is_file() or not os.access(translator, os.X_OK):
        raise RuntimeError(f"DBT translator is not executable: {translator}")
    llvm_objdump = Path(case.build["llvm_objdump"])
    if not llvm_objdump.is_file() or not os.access(llvm_objdump, os.X_OK):
        raise RuntimeError(f"llvm-objdump is not executable: {llvm_objdump}")
    return BuildResult(
        build_dir=translator.parent.parent,
        executable_path=translator,
        metadata={},
    )


def run(case: CorpusCase, build_result: BuildResult, context: RunContext) -> None:
    if context.skip_all_runs:
        return

    digest = case.metadata["sha256"]
    source = case.path.read_bytes()
    actual_digest = hashlib.sha256(source).hexdigest()
    if actual_digest != digest:
        raise RuntimeError(
            f"DBT input integrity check failed for {case.path}: "
            f"expected {digest}, got {actual_digest}"
        )

    target_config = case.metadata["target_config"]
    command = [
        str(build_result.executable_path),
        str(case.path),
        "--input-target",
        case.target,
        "--output-target",
        case.target,
        "--input-revision",
        target_config["input_revision"],
        "--output-revision",
        target_config["output_revision"],
        "--output-mode",
        "code-object",
    ]
    timeout_seconds = case.metadata["timeout_seconds"]
    memory_limit_bytes = case.metadata["memory_limit_bytes"]
    expected_failure = case.metadata["expected_failure"]
    with (
        tempfile.NamedTemporaryFile(suffix=".hsaco") as stdout_file,
        tempfile.TemporaryFile() as stderr_file,
    ):
        try:
            returncode, memory_exceeded = _run_translator(
                command,
                cwd=REPO_ROOT,
                env=_clean_runtime_environment(),
                stdout=stdout_file,
                stderr=stderr_file,
                timeout_seconds=timeout_seconds,
                memory_limit_bytes=memory_limit_bytes,
            )
        except subprocess.TimeoutExpired as exc:
            stdout_size = _stream_size(stdout_file)
            stderr = _read_bounded_stream(stderr_file)
            log_path = _write_diagnostic_log(
                case,
                context,
                command=command,
                returncode=None,
                stdout_size=stdout_size,
                stderr=stderr,
                outcome=f"timeout after {timeout_seconds:g} seconds",
            )
            if expected_failure is not None and expected_failure["kind"] == "timeout":
                pytest.xfail(f"{expected_failure['reason']} (log: {log_path})")
            expected = _expected_description(expected_failure)
            raise RuntimeError(
                f"DBT translation timed out after {timeout_seconds:g} seconds for "
                f"{digest}; expected {expected}; log: {log_path}"
            ) from exc

        stdout_size = _stream_size(stdout_file)
        stderr = _read_bounded_stream(stderr_file)
        if memory_exceeded:
            log_path = _write_diagnostic_log(
                case,
                context,
                command=command,
                returncode=returncode,
                stdout_size=stdout_size,
                stderr=stderr,
                outcome=f"resident memory exceeded {memory_limit_bytes} bytes",
            )
            if (
                expected_failure is not None
                and expected_failure["kind"] == "memory-limit"
            ):
                pytest.xfail(f"{expected_failure['reason']} (log: {log_path})")
            expected = _expected_description(expected_failure)
            raise RuntimeError(
                f"DBT translation exceeded the "
                f"{memory_limit_bytes // (1024 * 1024)} MiB resident-memory "
                f"limit for {digest}; expected {expected}; log: {log_path}"
            )

        if returncode != 0:
            log_path = _write_diagnostic_log(
                case,
                context,
                command=command,
                returncode=returncode,
                stdout_size=stdout_size,
                stderr=stderr,
                outcome="translation error",
            )
            mismatch = _expected_translation_mismatch(
                expected_failure,
                returncode=returncode,
                stderr=stderr,
            )
            if mismatch is None:
                pytest.xfail(f"{expected_failure['reason']} (log: {log_path})")
            raise RuntimeError(
                f"DBT translation failed for {digest}: {mismatch}; log: {log_path}\n"
                f"stderr:\n{stderr or '<empty>'}"
            )

        if expected_failure is not None:
            log_path = _write_diagnostic_log(
                case,
                context,
                command=command,
                returncode=returncode,
                stdout_size=stdout_size,
                stderr=stderr,
                outcome="unexpected pass",
            )
            raise RuntimeError(
                f"DBT translation unexpectedly passed for xfailed object {digest}; "
                f"remove or update the expected-failure entry; log: {log_path}"
            )

        if not stdout_size:
            _validate_code_object(b"", digest)
        stdout_file.seek(0)
        with mmap.mmap(stdout_file.fileno(), 0, access=mmap.ACCESS_READ) as output:
            data_only_noop = DATA_ONLY_NOOP_WARNING in stderr.splitlines()
            if data_only_noop and output[:] != source:
                raise RuntimeError(
                    f"DBT translation for {digest} reported a data-only no-op "
                    "but changed the code object"
                )
            _validate_code_object(
                output,
                digest,
                allow_data_only=data_only_noop,
            )
        _validate_with_llvm_objdump(
            Path(stdout_file.name),
            Path(case.build["llvm_objdump"]),
            case,
            context,
            stdout_size=stdout_size,
        )
    expected_rewrite = case.metadata["expected_rewrite"]
    if expected_rewrite is not None:
        _validate_rewrite_applied(
            case,
            context,
            command=command,
            timeout_seconds=timeout_seconds,
            memory_limit_bytes=memory_limit_bytes,
            expected_rewrite=expected_rewrite,
        )


def _validate_rewrite_applied(
    case: CorpusCase,
    context: RunContext,
    *,
    command: list[str],
    timeout_seconds: float,
    memory_limit_bytes: int,
    expected_rewrite: dict,
) -> None:
    digest = case.metadata["sha256"]
    diff_command = [*command[:-1], "diff"]
    with (
        tempfile.TemporaryFile() as stdout_file,
        tempfile.TemporaryFile() as stderr_file,
    ):
        try:
            returncode, memory_exceeded = _run_translator(
                diff_command,
                cwd=REPO_ROOT,
                env=_clean_runtime_environment(),
                stdout=stdout_file,
                stderr=stderr_file,
                timeout_seconds=timeout_seconds,
                memory_limit_bytes=memory_limit_bytes,
            )
        except subprocess.TimeoutExpired as exc:
            stdout = _read_bounded_stream(stdout_file)
            stderr = _read_bounded_stream(stderr_file)
            log_path = _write_diagnostic_log(
                case,
                context,
                command=diff_command,
                returncode=None,
                stdout_size=_stream_size(stdout_file),
                stdout=stdout,
                stderr=stderr,
                outcome=f"rewrite evidence timed out after {timeout_seconds:g} seconds",
            )
            raise RuntimeError(
                f"DBT rewrite evidence timed out after {timeout_seconds:g} "
                f"seconds for {digest}; log: {log_path}"
            ) from exc

        stdout_size = _stream_size(stdout_file)
        stdout = _read_bounded_stream(stdout_file)
        stderr = _read_bounded_stream(stderr_file)
        if memory_exceeded:
            log_path = _write_diagnostic_log(
                case,
                context,
                command=diff_command,
                returncode=returncode,
                stdout_size=stdout_size,
                stdout=stdout,
                stderr=stderr,
                outcome=f"rewrite evidence exceeded {memory_limit_bytes} bytes",
            )
            raise RuntimeError(
                f"DBT rewrite evidence exceeded the "
                f"{memory_limit_bytes // (1024 * 1024)} MiB resident-memory "
                f"limit for {digest}; log: {log_path}"
            )
        if returncode != 0:
            log_path = _write_diagnostic_log(
                case,
                context,
                command=diff_command,
                returncode=returncode,
                stdout_size=stdout_size,
                stdout=stdout,
                stderr=stderr,
                outcome="rewrite evidence error",
            )
            raise RuntimeError(
                f"DBT rewrite evidence failed for {digest} with return code "
                f"{returncode}; log: {log_path}\n"
                f"stderr:\n{stderr or '<empty>'}"
            )
        try:
            _validate_translation_counts(stdout, digest, expected_rewrite)
        except RuntimeError as exc:
            log_path = _write_diagnostic_log(
                case,
                context,
                command=diff_command,
                returncode=returncode,
                stdout_size=stdout_size,
                stdout=stdout,
                stderr=stderr,
                outcome="invalid rewrite evidence",
            )
            raise RuntimeError(f"{exc}; log: {log_path}") from exc


def _validate_translation_counts(
    output: str,
    digest: str,
    expected_rewrite: dict,
) -> None:
    matches = list(TRANSLATION_COUNTS_RE.finditer(output))
    if len(matches) != 1:
        raise RuntimeError(
            f"DBT diff for {digest} did not emit exactly one instruction "
            "translation summary"
        )
    total = int(matches[0].group("total"))
    changed = int(matches[0].group("changed"))
    shown = int(matches[0].group("shown"))
    if total <= 0:
        raise RuntimeError(
            f"DBT diff for {digest} reported no decoded instructions"
        )
    expected_changed = expected_rewrite["instructions_requiring_rewrite"]
    if changed <= 0:
        raise RuntimeError(
            f"DBT diff for {digest} reported no B0-to-A0 instruction rewrites; "
            f"expected {expected_changed}"
        )
    if changed != expected_changed:
        raise RuntimeError(
            f"DBT diff for {digest} reported changed={changed}; expected "
            f"{expected_changed} source instructions requiring rewrite"
        )
    if changed > total or shown > changed:
        raise RuntimeError(
            f"DBT diff for {digest} reported inconsistent instruction counts: "
            f"total={total}, changed={changed}, shown={shown}"
        )


def _resolve_corpus_root(value: str | Path | None) -> Path:
    selected = value or os.getenv("ROCJITSU_HSACO_CORPUS")
    if not selected:
        raise ValueError(
            "--dbt-corpus or ROCJITSU_HSACO_CORPUS is required for the dbt suite"
        )
    path = Path(selected)
    if not path.is_absolute():
        path = REPO_ROOT / path
    path = path.resolve()
    if not path.is_dir():
        raise ValueError(f"DBT extraction directory does not exist: {path}")
    return path


def _resolve_translator(value: str | Path | None) -> Path:
    selected = value or os.getenv("RJ_DBT_TRANSLATE")
    candidates: list[Path] = []
    if selected:
        selected_path = Path(selected)
        if selected_path.parent == Path("."):
            resolved_on_path = shutil.which(str(selected))
            if resolved_on_path:
                candidates.append(Path(resolved_on_path))
        if not selected_path.is_absolute():
            selected_path = REPO_ROOT / selected_path
        candidates.append(selected_path)

    build_directory = os.getenv("ROCJITSU_BUILD_DIR") or os.getenv("ROCJITSU_BUILD")
    if build_directory:
        candidates.append(Path(build_directory) / "tools" / "rj_dbt_translate")
    resolved_on_path = shutil.which("rj_dbt_translate")
    if resolved_on_path:
        candidates.append(Path(resolved_on_path))

    for candidate in candidates:
        resolved = candidate.resolve()
        if resolved.is_file() and os.access(resolved, os.X_OK):
            return resolved
    shown = ", ".join(str(candidate) for candidate in candidates) or "<none>"
    raise ValueError(
        "could not find an executable rj_dbt_translate; pass --dbt-translator "
        f"or set RJ_DBT_TRANSLATE/ROCJITSU_BUILD_DIR (checked: {shown})"
    )


def _resolve_llvm_objdump(
    value: str | Path | None,
    translator: Path,
) -> Path:
    selected = value or os.getenv("ROCJITSU_DBT_LLVM_OBJDUMP")
    candidates: list[Path] = []
    if selected:
        selected_path = Path(selected)
        if selected_path.parent == Path("."):
            resolved_on_path = shutil.which(str(selected))
            if resolved_on_path:
                candidates.append(Path(resolved_on_path))
        if not selected_path.is_absolute():
            selected_path = REPO_ROOT / selected_path
        candidates.append(selected_path)
    candidates.append(translator.parent / "llvm-objdump")
    resolved_on_path = shutil.which("llvm-objdump")
    if resolved_on_path:
        candidates.append(Path(resolved_on_path))

    for candidate in candidates:
        resolved = candidate.resolve()
        if resolved.is_file() and os.access(resolved, os.X_OK):
            return resolved
    shown = ", ".join(str(candidate) for candidate in candidates) or "<none>"
    raise ValueError(
        "could not find an executable TheRock llvm-objdump; pass "
        f"--dbt-llvm-objdump or set ROCJITSU_DBT_LLVM_OBJDUMP (checked: {shown})"
    )


def _validate_summary(
    corpus_root: Path,
    summary: dict,
    *,
    target: str,
    allow_incomplete: bool,
) -> None:
    if summary.get("target") != target:
        raise ValueError(
            f"{corpus_root}/summary.json target is {summary.get('target')!r}, "
            f"expected {target!r}"
        )
    unique_count = summary.get("unique_code_objects")
    if not isinstance(unique_count, int) or unique_count < 0:
        raise ValueError(
            f"{corpus_root}/summary.json field 'unique_code_objects' "
            "must be a non-negative integer"
        )
    complete = summary.get("complete")
    if not isinstance(complete, bool):
        raise TypeError(
            f"{corpus_root}/summary.json field 'complete' must be a boolean"
        )
    if not complete and not allow_incomplete:
        raise ValueError(
            f"{corpus_root}/summary.json records complete=false; pass "
            "--dbt-allow-incomplete-corpus only when the omitted extraction "
            "category is intentional"
        )
    if not complete:
        failures = summary.get("failures")
        if not isinstance(failures, list):
            raise TypeError(
                f"{corpus_root}/summary.json field 'failures' must be a list"
            )
        if failures:
            raise ValueError(
                f"{corpus_root}/summary.json records extraction failures; "
                "--dbt-allow-incomplete-corpus permits only intentionally "
                "skipped CCOB materialization"
            )
        if summary.get("ccob_status") != "skipped":
            raise ValueError(
                f"{corpus_root}/summary.json field 'ccob_status' must be "
                "'skipped' when --dbt-allow-incomplete-corpus is used"
            )


def _load_object_manifest(corpus_root: Path) -> dict[str, Path]:
    manifest = corpus_root / "manifests" / "SHA256SUMS"
    try:
        lines = manifest.read_text(encoding="utf-8").splitlines()
    except OSError as exc:
        raise ValueError(f"could not read {manifest}: {exc}") from exc
    if not lines:
        raise ValueError(f"{manifest} must contain at least one object")
    if lines != sorted(lines):
        raise ValueError(f"{manifest} must be sorted for deterministic discovery")

    objects: dict[str, Path] = {}
    for line_number, line in enumerate(lines, 1):
        match = SHA256SUM_RE.fullmatch(line)
        if match is None:
            raise ValueError(
                f"{manifest}:{line_number} is not a canonical SHA256SUMS entry"
            )
        digest = match.group("digest")
        if digest in objects:
            raise ValueError(f"{manifest}:{line_number} repeats digest {digest}")
        object_path = corpus_root / match.group("path")
        if not object_path.is_file():
            raise ValueError(f"{manifest}:{line_number} is missing {object_path}")
        objects[digest] = object_path
    return objects


def _validate_baseline_manifest(
    corpus_root: Path,
    objects: set[str],
    expected_sha256: str,
    extraction_mode: str,
) -> None:
    manifest = corpus_root / "manifests" / "NON_CCOB_SHA256SUMS"
    try:
        content = manifest.read_bytes()
        lines = content.decode("ascii").splitlines()
    except OSError as exc:
        raise ValueError(f"could not read {manifest}: {exc}") from exc
    except UnicodeDecodeError as exc:
        raise ValueError(f"{manifest} must be ASCII: {exc}") from exc
    actual_sha256 = hashlib.sha256(content).hexdigest()
    if actual_sha256 != expected_sha256:
        raise ValueError(
            f"{manifest} has SHA-256 {actual_sha256}, but the pinned DBT "
            f"profile requires {expected_sha256}"
        )
    if not lines or lines != sorted(lines):
        raise ValueError(f"{manifest} must be a non-empty sorted manifest")

    baseline: set[str] = set()
    for line_number, line in enumerate(lines, 1):
        match = SHA256SUM_RE.fullmatch(line)
        if match is None:
            raise ValueError(
                f"{manifest}:{line_number} is not a canonical SHA256SUMS entry"
            )
        digest = match.group("digest")
        if digest in baseline:
            raise ValueError(f"{manifest}:{line_number} repeats digest {digest}")
        baseline.add(digest)
    missing = sorted(baseline - objects)
    if missing:
        shown = ", ".join(missing[:3])
        suffix = "" if len(missing) <= 3 else ", ..."
        raise ValueError(
            f"{manifest} baseline is missing {len(missing)} object(s) from the "
            f"extraction: {shown}{suffix}"
        )
    if extraction_mode == "skipped" and baseline != objects:
        raise ValueError(
            f"{manifest} must equal the complete object manifest when CCOB "
            "materialization is skipped"
        )


def _load_expected_failures(target_config: dict) -> dict[str, dict]:
    manifest_path = Path(target_config["expected_failures"])
    if not manifest_path.is_absolute():
        manifest_path = REPO_ROOT / manifest_path
    payload = _load_json_object(manifest_path)
    allowed_top_level = {
        "schema_version",
        "target",
        "input_revision",
        "output_revision",
        "expected_failures",
    }
    unknown = sorted(set(payload) - allowed_top_level)
    if unknown:
        raise ValueError(f"{manifest_path} has unknown field(s): {', '.join(unknown)}")
    if payload.get("schema_version") != 1:
        raise ValueError(f"{manifest_path} field 'schema_version' must be 1")
    for field in ("target", "input_revision", "output_revision"):
        if payload.get(field) != target_config[field]:
            raise ValueError(
                f"{manifest_path} field '{field}' must match {target_config['_path']}"
            )
    entries = payload.get("expected_failures")
    if not isinstance(entries, dict):
        raise TypeError(f"{manifest_path} field 'expected_failures' must be an object")

    validated: dict[str, dict] = {}
    for digest, entry in entries.items():
        if not isinstance(digest, str) or SHA256_RE.fullmatch(digest) is None:
            raise ValueError(
                f"{manifest_path} expected-failure keys must be lowercase SHA-256"
            )
        if not isinstance(entry, dict):
            raise TypeError(f"{manifest_path} entry {digest} must be an object")
        allowed_entry_fields = {"kind", "reason", "returncode", "stderr_regex"}
        unknown_entry_fields = sorted(set(entry) - allowed_entry_fields)
        if unknown_entry_fields:
            raise ValueError(
                f"{manifest_path} entry {digest} has unknown field(s): "
                f"{', '.join(unknown_entry_fields)}"
            )
        kind = entry.get("kind")
        reason = entry.get("reason")
        if kind not in {"memory-limit", "timeout", "translation-error"}:
            raise ValueError(
                f"{manifest_path} entry {digest} field 'kind' must be "
                "'memory-limit', 'timeout', or 'translation-error'"
            )
        if not isinstance(reason, str) or not reason:
            raise ValueError(
                f"{manifest_path} entry {digest} field 'reason' "
                "must be a non-empty string"
            )
        if kind in {"memory-limit", "timeout"}:
            if set(entry) != {"kind", "reason"}:
                raise ValueError(
                    f"{manifest_path} {kind} entry {digest} may contain only "
                    "'kind' and 'reason'"
                )
        else:
            returncode = entry.get("returncode")
            stderr_regex = entry.get("stderr_regex")
            if not isinstance(returncode, int) or returncode == 0:
                raise ValueError(
                    f"{manifest_path} entry {digest} field 'returncode' "
                    "must be a non-zero integer"
                )
            if not isinstance(stderr_regex, str) or not stderr_regex:
                raise ValueError(
                    f"{manifest_path} entry {digest} field 'stderr_regex' "
                    "must be a non-empty string"
                )
            try:
                re.compile(stderr_regex)
            except re.error as exc:
                raise ValueError(
                    f"{manifest_path} entry {digest} has invalid stderr_regex: {exc}"
                ) from exc
        validated[digest] = dict(entry)
    return validated


def _load_expected_rewrites(target_config: dict) -> dict[str, dict[str, int]]:
    manifest_path = Path(target_config["expected_rewrites"])
    if not manifest_path.is_absolute():
        manifest_path = REPO_ROOT / manifest_path
    payload = _load_json_object(manifest_path)
    allowed_top_level = {
        "schema_version",
        "target",
        "input_revision",
        "output_revision",
        "expected_rewrites",
    }
    unknown = sorted(set(payload) - allowed_top_level)
    if unknown:
        raise ValueError(f"{manifest_path} has unknown field(s): {', '.join(unknown)}")
    if payload.get("schema_version") != 1:
        raise ValueError(f"{manifest_path} field 'schema_version' must be 1")
    for field in ("target", "input_revision", "output_revision"):
        if payload.get(field) != target_config[field]:
            raise ValueError(
                f"{manifest_path} field '{field}' must match {target_config['_path']}"
            )
    entries = payload.get("expected_rewrites")
    if not isinstance(entries, dict):
        raise TypeError(f"{manifest_path} field 'expected_rewrites' must be an object")

    validated: dict[str, dict[str, int]] = {}
    for digest, entry in entries.items():
        if not isinstance(digest, str) or SHA256_RE.fullmatch(digest) is None:
            raise ValueError(
                f"{manifest_path} expected-rewrite keys must be lowercase SHA-256"
            )
        if (
            not isinstance(entry, dict)
            or set(entry) != {"instructions_requiring_rewrite"}
        ):
            raise ValueError(
                f"{manifest_path} entry {digest} must contain exactly "
                "'instructions_requiring_rewrite'"
            )
        rewrite_count = entry["instructions_requiring_rewrite"]
        if (
            isinstance(rewrite_count, bool)
            or not isinstance(rewrite_count, int)
            or rewrite_count <= 0
        ):
            raise ValueError(
                f"{manifest_path} entry {digest} must satisfy "
                "instructions_requiring_rewrite > 0"
            )
        validated[digest] = {"instructions_requiring_rewrite": rewrite_count}
    return validated


def _with_consumer_paths(
    target_config: dict,
    *,
    expected_failures_path: str | Path | None,
    expected_rewrites_path: str | Path | None,
    package_lock_path: str | Path | None,
) -> dict:
    configured = dict(target_config)
    if expected_failures_path is not None:
        configured["expected_failures"] = str(expected_failures_path)
    if expected_rewrites_path is not None:
        configured["expected_rewrites"] = str(expected_rewrites_path)
    if package_lock_path is not None:
        configured["package_lock"] = str(package_lock_path)
    missing = [
        option
        for option, field in (
            ("--dbt-expected-failures", "expected_failures"),
            ("--dbt-expected-rewrites", "expected_rewrites"),
            ("--dbt-package-lock", "package_lock"),
        )
        if not configured.get(field)
    ]
    if missing:
        raise ValueError(
            f"{target_config['_path']} does not embed DBT consumer inputs; "
            f"pass {' and '.join(missing)}"
        )
    return configured


def _validate_expected_object_counts(config_path: Path, rules) -> None:
    if not isinstance(rules, dict) or set(rules) != {"materialized", "skipped"}:
        raise ValueError(
            f"{config_path} field 'expected_unique_code_objects' must contain "
            "exactly 'materialized' and 'skipped' rules"
        )
    for mode, rule in rules.items():
        if not isinstance(rule, dict) or len(rule) != 1:
            raise ValueError(
                f"{config_path} object-count rule for {mode!r} must contain "
                "exactly one bound"
            )
        bound, count = next(iter(rule.items()))
        if bound not in {"exact", "minimum"}:
            raise ValueError(
                f"{config_path} object-count rule for {mode!r} must use "
                "'exact' or 'minimum'"
            )
        if not isinstance(count, int) or count <= 0:
            raise ValueError(
                f"{config_path} object-count rule for {mode!r} must be a "
                "positive integer"
            )


def _validate_object_count(
    corpus_root: Path,
    actual: int,
    extraction_mode: str,
    rule: dict,
) -> None:
    bound, expected = next(iter(rule.items()))
    valid = actual == expected if bound == "exact" else actual >= expected
    if valid:
        return
    requirement = f"exactly {expected}" if bound == "exact" else f"at least {expected}"
    raise ValueError(
        f"{corpus_root} contains {actual} unique objects in {extraction_mode!r} "
        f"CCOB mode, but the pinned DBT profile requires {requirement}"
    )


def _validate_package_lock(
    corpus_root: Path,
    target_configs: list[dict],
) -> dict:
    package_snapshot_path = corpus_root / "manifests" / "packages.json"
    try:
        with package_snapshot_path.open("r", encoding="utf-8") as stream:
            package_snapshot = json.load(stream)
    except OSError as exc:
        raise ValueError(f"could not read {package_snapshot_path}: {exc}") from exc
    except json.JSONDecodeError as exc:
        raise ValueError(f"invalid JSON in {package_snapshot_path}: {exc}") from exc
    if not isinstance(package_snapshot, list):
        raise TypeError(f"{package_snapshot_path} must contain a JSON list")

    installed: dict[str, str] = {}
    for index, package in enumerate(package_snapshot):
        if not isinstance(package, dict) or set(package) != {"name", "version"}:
            raise ValueError(
                f"{package_snapshot_path} entry {index} must contain only "
                "'name' and 'version'"
            )
        name = package["name"]
        version = package["version"]
        if not isinstance(name, str) or not name:
            raise ValueError(
                f"{package_snapshot_path} entry {index} has an invalid name"
            )
        if not isinstance(version, str) or not version:
            raise ValueError(
                f"{package_snapshot_path} entry {index} has an invalid version"
            )
        normalized_name = name.lower()
        if normalized_name in installed:
            raise ValueError(
                f"{package_snapshot_path} repeats package {normalized_name}"
            )
        installed[normalized_name] = version

    input_policy = None
    for target_config in target_configs:
        lock_path = Path(target_config["package_lock"])
        if not lock_path.is_absolute():
            lock_path = REPO_ROOT / lock_path
        lock = _load_json_object(lock_path)
        if set(lock) != {
            "baseline_manifest_sha256",
            "expected_unique_code_objects",
            "packages",
            "schema_version",
        }:
            raise ValueError(
                f"{lock_path} must contain exactly 'baseline_manifest_sha256', "
                "'expected_unique_code_objects', 'packages', and 'schema_version'"
            )
        if lock["schema_version"] != 1:
            raise ValueError(f"{lock_path} field 'schema_version' must be 1")
        baseline_manifest_sha256 = lock["baseline_manifest_sha256"]
        if (
            not isinstance(baseline_manifest_sha256, str)
            or SHA256_RE.fullmatch(baseline_manifest_sha256) is None
        ):
            raise ValueError(
                f"{lock_path} field 'baseline_manifest_sha256' must be "
                "a lowercase SHA-256"
            )
        _validate_expected_object_counts(
            lock_path, lock["expected_unique_code_objects"]
        )
        packages = lock["packages"]
        if not isinstance(packages, dict) or not packages:
            raise ValueError(f"{lock_path} field 'packages' must be a non-empty object")
        for package_name, expected_version in packages.items():
            if (
                not isinstance(package_name, str)
                or not package_name
                or package_name != package_name.lower()
            ):
                raise ValueError(
                    f"{lock_path} package keys must be lowercase non-empty strings"
                )
            if not isinstance(expected_version, str) or not expected_version:
                raise ValueError(
                    f"{lock_path} package {package_name} must have a version string"
                )
            actual_version = installed.get(package_name)
            if actual_version != expected_version:
                raise ValueError(
                    f"{package_snapshot_path} package {package_name!r} is "
                    f"{actual_version!r}, but {lock_path} requires "
                    f"{expected_version!r}"
                )
        current_policy = {
            "baseline_manifest_sha256": baseline_manifest_sha256,
            "expected_unique_code_objects": lock["expected_unique_code_objects"],
        }
        if input_policy is None:
            input_policy = current_policy
        elif current_policy != input_policy:
            raise ValueError("matching DBT package locks disagree on input policy")

    assert input_policy is not None
    return input_policy


def _load_json_object(path: Path) -> dict:
    try:
        with path.open("r", encoding="utf-8") as stream:
            payload = json.load(stream)
    except OSError as exc:
        raise ValueError(f"could not read {path}: {exc}") from exc
    except json.JSONDecodeError as exc:
        raise ValueError(f"invalid JSON in {path}: {exc}") from exc
    if not isinstance(payload, dict):
        raise TypeError(f"{path} must contain a JSON object")
    return payload


def _clean_runtime_environment() -> dict[str, str]:
    environment = os.environ.copy()
    for name in CLEAN_ENVIRONMENT_KEYS:
        environment.pop(name, None)
    return environment


def _run_translator(
    command: list[str],
    *,
    cwd: Path,
    env: dict[str, str],
    stdout,
    stderr,
    timeout_seconds: float,
    memory_limit_bytes: int,
) -> tuple[int, bool]:
    process = subprocess.Popen(
        command,
        cwd=cwd,
        env=env,
        stdout=stdout,
        stderr=stderr,
        start_new_session=True,
    )
    deadline = time.monotonic() + timeout_seconds
    while True:
        remaining = deadline - time.monotonic()
        if remaining <= 0:
            _kill_process_group(process)
            raise subprocess.TimeoutExpired(command, timeout_seconds)
        try:
            return process.wait(timeout=min(0.05, remaining)), False
        except subprocess.TimeoutExpired:
            if _resident_memory_bytes(process.pid) > memory_limit_bytes:
                _kill_process_group(process)
                return process.returncode, True


def _resident_memory_bytes(pid: int) -> int:
    try:
        fields = Path(f"/proc/{pid}/statm").read_text(encoding="ascii").split()
        return int(fields[1]) * os.sysconf("SC_PAGE_SIZE")
    except (FileNotFoundError, IndexError, OSError, ValueError):
        return 0


def _kill_process_group(process: subprocess.Popen) -> None:
    try:
        os.killpg(process.pid, signal.SIGKILL)
    except ProcessLookupError:
        pass
    process.wait()


def _stream_size(stream) -> int:
    stream.flush()
    return os.fstat(stream.fileno()).st_size


def _read_bounded_stream(stream, limit: int = 1024 * 1024) -> str:
    size = _stream_size(stream)
    stream.seek(0)
    if size <= limit:
        content = stream.read()
    else:
        half = limit // 2
        first = stream.read(half)
        stream.seek(size - half)
        last = stream.read(half)
        content = (
            first + f"\n... {size - limit} stderr bytes omitted ...\n".encode() + last
        )
    return content.decode("utf-8", errors="replace")


def _expected_translation_mismatch(
    expected_failure: dict | None,
    *,
    returncode: int,
    stderr: str,
) -> str | None:
    if expected_failure is None:
        return "failure is not listed in the expected-failure manifest"
    if expected_failure["kind"] != "translation-error":
        return (
            f"expected {_expected_description(expected_failure)}, "
            f"got translation error with return code {returncode}"
        )
    if returncode != expected_failure["returncode"]:
        return (
            f"expected return code {expected_failure['returncode']}, got {returncode}"
        )
    if re.search(expected_failure["stderr_regex"], stderr) is None:
        return (
            f"stderr did not match expected regex {expected_failure['stderr_regex']!r}"
        )
    return None


def _expected_description(expected_failure: dict | None) -> str:
    if expected_failure is None:
        return "success"
    return expected_failure["kind"]


def _validate_code_object(
    output: bytes,
    digest: str,
    *,
    allow_data_only: bool = False,
) -> None:
    if len(output) < 64 or output[:4] != b"\x7fELF":
        raise RuntimeError(
            f"DBT translation for {digest} did not emit a complete ELF code object"
        )
    if output[4] != 2 or output[5] != 1:
        raise RuntimeError(
            f"DBT translation for {digest} did not emit little-endian ELF64"
        )
    if output[6] != 1:
        raise RuntimeError(
            f"DBT translation for {digest} emitted an invalid ELF version"
        )
    elf_type, machine = struct.unpack_from("<HH", output, 16)
    if elf_type != 3 or machine != 224:
        raise RuntimeError(
            f"DBT translation for {digest} emitted ELF type={elf_type}, "
            f"machine={machine}; expected ET_DYN/EM_AMDGPU"
        )
    if struct.unpack_from("<I", output, 20)[0] != 1:
        raise RuntimeError(
            f"DBT translation for {digest} emitted an invalid ELF version"
        )

    program_offset, section_offset = struct.unpack_from("<QQ", output, 32)
    (
        header_size,
        program_entry_size,
        program_count,
        section_entry_size,
        section_count,
        section_name_index,
    ) = struct.unpack_from("<HHHHHH", output, 52)
    if header_size != 64:
        raise RuntimeError(
            f"DBT translation for {digest} emitted ELF header size {header_size}"
        )
    if (
        not program_count
        or program_entry_size != 56
        or program_offset < header_size
        or program_offset + program_entry_size * program_count > len(output)
    ):
        raise RuntimeError(
            f"DBT translation for {digest} emitted an invalid program-header table"
        )
    if (
        not section_count
        or section_entry_size != 64
        or section_offset < header_size
        or section_offset + section_entry_size * section_count > len(output)
        or (section_name_index >= section_count and section_name_index != 0xFFFF)
    ):
        raise RuntimeError(
            f"DBT translation for {digest} emitted an invalid section-header table"
        )

    has_executable_load = False
    has_metadata_note = False
    for index in range(program_count):
        position = program_offset + index * program_entry_size
        segment_type, segment_flags = struct.unpack_from("<II", output, position)
        file_offset = struct.unpack_from("<Q", output, position + 8)[0]
        file_size, memory_size = struct.unpack_from("<QQ", output, position + 32)
        if file_offset + file_size > len(output) or memory_size < file_size:
            raise RuntimeError(
                f"DBT translation for {digest} emitted an out-of-bounds segment"
            )
        if segment_type == 1 and segment_flags & 1 and file_size:
            has_executable_load = True
        if segment_type == 4:
            has_metadata_note |= _contains_amdgpu_metadata_note(
                output, file_offset, file_size
            )

    has_executable_section = False
    for index in range(section_count):
        position = section_offset + index * section_entry_size
        section_type = struct.unpack_from("<I", output, position + 4)[0]
        section_flags = struct.unpack_from("<Q", output, position + 8)[0]
        file_offset, file_size = struct.unpack_from("<QQ", output, position + 24)
        if section_type != 8 and file_offset + file_size > len(output):
            raise RuntimeError(
                f"DBT translation for {digest} emitted an out-of-bounds section"
            )
        if section_type == 1 and section_flags & 0x6 == 0x6 and file_size:
            has_executable_section = True

    if allow_data_only and (has_executable_load or has_executable_section):
        raise RuntimeError(
            f"DBT translation for {digest} reported a data-only no-op for an "
            "object with executable loadable content"
        )
    if not allow_data_only and (
        not has_executable_load or not has_executable_section
    ):
        raise RuntimeError(
            f"DBT translation for {digest} emitted no executable loadable content"
        )
    if not has_metadata_note:
        raise RuntimeError(
            f"DBT translation for {digest} emitted no AMDHSA metadata note"
        )


def _contains_amdgpu_metadata_note(
    output: bytes,
    offset: int,
    size: int,
) -> bool:
    cursor = offset
    end = offset + size
    while cursor + 12 <= end:
        name_size, description_size, note_type = struct.unpack_from(
            "<III", output, cursor
        )
        cursor += 12
        name_end = cursor + name_size
        description_offset = (name_end + 3) & ~3
        description_end = description_offset + description_size
        next_note = (description_end + 3) & ~3
        if name_end > end or description_end > end or next_note > end:
            return False
        owner = output[cursor:name_end].rstrip(b"\0")
        if owner == b"AMDGPU" and note_type == 32 and description_size:
            return True
        cursor = next_note
    return False


def _validate_with_llvm_objdump(
    output_path: Path,
    llvm_objdump: Path,
    case: CorpusCase,
    context: RunContext,
    *,
    stdout_size: int,
) -> None:
    command = [str(llvm_objdump), "--disassemble", str(output_path)]
    with tempfile.TemporaryFile() as stderr_file:
        try:
            process = subprocess.run(
                command,
                cwd=REPO_ROOT,
                env=_clean_runtime_environment(),
                stdout=subprocess.DEVNULL,
                stderr=stderr_file,
                check=False,
                timeout=30,
            )
        except subprocess.TimeoutExpired as exc:
            stderr = _read_bounded_stream(stderr_file)
            log_path = _write_diagnostic_log(
                case,
                context,
                command=command,
                returncode=None,
                stdout_size=stdout_size,
                stderr=stderr,
                outcome="llvm-objdump timed out after 30 seconds",
            )
            raise RuntimeError(
                f"llvm-objdump timed out for translated object "
                f"{case.metadata['sha256']}; log: {log_path}"
            ) from exc
        if process.returncode == 0:
            return
        stderr = _read_bounded_stream(stderr_file)
        log_path = _write_diagnostic_log(
            case,
            context,
            command=command,
            returncode=process.returncode,
            stdout_size=stdout_size,
            stderr=stderr,
            outcome="llvm-objdump rejected translated code object",
        )
        raise RuntimeError(
            f"llvm-objdump rejected translated object "
            f"{case.metadata['sha256']}; log: {log_path}\n"
            f"stderr:\n{stderr or '<empty>'}"
        )


def _write_diagnostic_log(
    case: CorpusCase,
    context: RunContext,
    *,
    command: list[str],
    returncode: int | None,
    stdout_size: int,
    stdout: str | None = None,
    stderr: str,
    outcome: str,
) -> Path:
    target_config = case.metadata["target_config"]
    profile = (
        f"{case.target}.{target_config['input_revision']}-to-"
        f"{target_config['output_revision']}"
    )
    log_path = (
        context.artifact_directory / "dbt" / profile / f"{case.metadata['sha256']}.log"
    )
    log_path.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "$ " + " ".join(shlex.quote(part) for part in command),
        f"outcome: {outcome}",
        f"returncode: {returncode}",
        f"stdout_bytes: {stdout_size}",
    ]
    if stdout is not None:
        lines.extend(("", "stdout:", stdout or "<empty>"))
    lines.extend(("", "stderr:", stderr or "<empty>", ""))
    log_path.write_text("\n".join(lines), encoding="utf-8")
    return log_path
