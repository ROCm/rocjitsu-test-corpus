from __future__ import annotations

import hashlib
import json
import struct
import subprocess
import sys
import time
from pathlib import Path

import msgpack
import pytest

from support.define_contracts import RunContext, TargetSpec
from test_suites import dbt


@pytest.fixture(autouse=True)
def isolate_llvm_objdump_environment(monkeypatch):
    monkeypatch.delenv("ROCJITSU_DBT_LLVM_OBJDUMP", raising=False)


def test_shipped_profile_loads():
    configs = dbt.load_target_configs([str(dbt.CONFIGS_ROOT / "gfx1250_b0_a0.json")])

    assert len(configs) == 1
    assert configs[0]["timeout_seconds"] == 30
    assert "baseline_manifest_sha256" not in configs[0]
    assert "expected_unique_code_objects" not in configs[0]
    assert "package_lock" not in configs[0]
    assert "expected_failures" not in configs[0]
    assert "expected_rewrites" not in configs[0]


def test_discover_accepts_external_translator_expectations(tmp_path: Path):
    corpus, config, translator, _digest = _make_inputs(tmp_path)
    expected_failures = config.pop("expected_failures")
    expected_rewrites = config.pop("expected_rewrites")
    package_lock = config.pop("package_lock")

    cases = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        expected_failures_path=expected_failures,
        expected_rewrites_path=expected_rewrites,
        package_lock_path=package_lock,
        timeout_seconds=1,
        allow_incomplete=False,
    )

    assert len(cases) == 1


def test_discover_rejects_empty_rewrite_expectations(tmp_path: Path):
    corpus, config, translator, _digest = _make_inputs(tmp_path)
    expected_rewrites_path = Path(config["expected_rewrites"])
    expected_rewrites = json.loads(
        expected_rewrites_path.read_text(encoding="utf-8")
    )
    expected_rewrites["expected_rewrites"] = {}
    _write_json(expected_rewrites_path, expected_rewrites)

    with pytest.raises(ValueError, match="contains no rewrite expectations"):
        dbt.discover(
            TargetSpec("gfx1250"),
            [config],
            corpus_directory=corpus,
            translator=translator,
            timeout_seconds=1,
            allow_incomplete=False,
        )


def test_profile_rejects_identity_revision(tmp_path: Path):
    _corpus, config, _translator, _digest = _make_inputs(tmp_path)
    config["output_revision"] = config["input_revision"]
    config_path = Path(config.pop("_path"))
    _write_json(config_path, config)

    with pytest.raises(ValueError, match="different input_revision"):
        dbt.load_target_configs([str(config_path)])


def test_discover_rejects_incomplete_extraction_without_opt_in(tmp_path: Path):
    corpus, config, translator, _digest = _make_inputs(tmp_path, complete=False)

    with pytest.raises(ValueError, match="complete=false"):
        dbt.discover(
            TargetSpec("gfx1250"),
            [config],
            corpus_directory=corpus,
            translator=translator,
            timeout_seconds=1,
            allow_incomplete=False,
        )

    cases = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        timeout_seconds=1,
        allow_incomplete=True,
    )
    assert len(cases) == 1


def test_discover_rejects_failed_extraction_with_incomplete_opt_in(tmp_path: Path):
    corpus, config, translator, _digest = _make_inputs(tmp_path, complete=False)
    summary_path = corpus / "summary.json"
    summary = json.loads(summary_path.read_text(encoding="utf-8"))
    summary["ccob_status"] = "failed"
    summary["failures"] = [{"category": "hip-bundle", "operation": "list"}]
    _write_json(summary_path, summary)

    with pytest.raises(ValueError, match="records extraction failures"):
        dbt.discover(
            TargetSpec("gfx1250"),
            [config],
            corpus_directory=corpus,
            translator=translator,
            timeout_seconds=1,
            allow_incomplete=True,
        )


def test_discover_rejects_package_drift(tmp_path: Path):
    corpus, config, translator, _digest = _make_inputs(tmp_path)
    _write_json(
        corpus / "manifests" / "packages.json",
        [{"name": "producer-package", "version": "2"}],
    )

    with pytest.raises(ValueError, match="requires '1'"):
        dbt.discover(
            TargetSpec("gfx1250"),
            [config],
            corpus_directory=corpus,
            translator=translator,
            timeout_seconds=1,
            allow_incomplete=False,
        )


def test_discover_rejects_unexpected_corpus_size(tmp_path: Path):
    corpus, config, translator, _digest = _make_inputs(tmp_path)
    lock_path = Path(config["package_lock"])
    lock = json.loads(lock_path.read_text(encoding="utf-8"))
    lock["expected_unique_code_objects"]["materialized"]["minimum"] = 2
    _write_json(lock_path, lock)

    with pytest.raises(ValueError, match="requires at least 2"):
        dbt.discover(
            TargetSpec("gfx1250"),
            [config],
            corpus_directory=corpus,
            translator=translator,
            timeout_seconds=1,
            allow_incomplete=False,
        )


def test_discover_rejects_unexpected_incomplete_corpus_size(tmp_path: Path):
    corpus, config, translator, _digest = _make_inputs(tmp_path, complete=False)
    lock_path = Path(config["package_lock"])
    lock = json.loads(lock_path.read_text(encoding="utf-8"))
    lock["expected_unique_code_objects"]["skipped"]["exact"] = 2
    _write_json(lock_path, lock)

    with pytest.raises(ValueError, match="requires exactly 2"):
        dbt.discover(
            TargetSpec("gfx1250"),
            [config],
            corpus_directory=corpus,
            translator=translator,
            timeout_seconds=1,
            allow_incomplete=True,
        )


def test_discover_rejects_materialized_baseline_swap(tmp_path: Path):
    corpus, config, translator, _digest = _make_inputs(tmp_path)
    replacement = b"different packaged gfx1250 code object"
    replacement_digest = hashlib.sha256(replacement).hexdigest()
    (corpus / "objects" / f"{replacement_digest}.hsaco").write_bytes(replacement)
    (corpus / "manifests" / "SHA256SUMS").write_text(
        f"{replacement_digest}  objects/{replacement_digest}.hsaco\n",
        encoding="ascii",
    )

    with pytest.raises(ValueError, match="baseline is missing"):
        dbt.discover(
            TargetSpec("gfx1250"),
            [config],
            corpus_directory=corpus,
            translator=translator,
            timeout_seconds=1,
            allow_incomplete=False,
        )


def test_successful_translation_emits_valid_code_object(tmp_path: Path):
    corpus, config, translator, digest = _make_inputs(tmp_path)
    cases = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        timeout_seconds=1,
        allow_incomplete=False,
    )
    context = _run_context(tmp_path)
    result = dbt.build(cases[0], context, None)

    dbt.run(cases[0], result, context)

    assert cases[0].metadata["sha256"] == digest
    assert not context.artifact_directory.exists()


def test_data_only_noop_accepts_unchanged_non_executable_code_object(
    tmp_path: Path,
):
    source = minimal_data_only_code_object()
    corpus, config, translator, digest = _make_inputs(
        tmp_path,
        source=source,
        translator_body=(
            "import pathlib\n"
            "import sys\n"
            "sys.stdout.buffer.write(pathlib.Path(sys.argv[1]).read_bytes())\n"
            f"print({dbt.DATA_ONLY_NOOP_WARNING!r}, file=sys.stderr)\n"
        ),
    )
    case = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        timeout_seconds=1,
        allow_incomplete=False,
    )[0]
    case.metadata["expected_rewrite"] = None
    context = _run_context(tmp_path)
    result = dbt.build(case, context, None)

    dbt.run(case, result, context)

    assert case.metadata["sha256"] == digest
    assert not context.artifact_directory.exists()


def test_data_only_noop_rejects_changed_code_object(tmp_path: Path):
    source = minimal_data_only_code_object()
    corpus, config, translator, _digest = _make_inputs(
        tmp_path,
        source=source,
        translator_body=(
            "import pathlib\n"
            "import sys\n"
            "sys.stdout.buffer.write(pathlib.Path(sys.argv[1]).read_bytes() + b'X')\n"
            f"print({dbt.DATA_ONLY_NOOP_WARNING!r}, file=sys.stderr)\n"
        ),
    )
    case = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        timeout_seconds=1,
        allow_incomplete=False,
    )[0]
    case.metadata["expected_rewrite"] = None
    context = _run_context(tmp_path)
    result = dbt.build(case, context, None)

    with pytest.raises(RuntimeError, match="reported a data-only no-op but changed"):
        dbt.run(case, result, context)


def test_data_only_noop_rejects_executable_code_object(tmp_path: Path):
    source = minimal_code_object()
    corpus, config, translator, _digest = _make_inputs(
        tmp_path,
        source=source,
        translator_body=(
            "import pathlib\n"
            "import sys\n"
            "sys.stdout.buffer.write(pathlib.Path(sys.argv[1]).read_bytes())\n"
            f"print({dbt.DATA_ONLY_NOOP_WARNING!r}, file=sys.stderr)\n"
        ),
    )
    case = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        timeout_seconds=1,
        allow_incomplete=False,
    )[0]
    case.metadata["expected_rewrite"] = None
    context = _run_context(tmp_path)
    result = dbt.build(case, context, None)

    with pytest.raises(
        RuntimeError,
        match="reported a data-only no-op for an object with executable",
    ):
        dbt.run(case, result, context)


def test_translation_rejects_identity_rewrite_evidence(tmp_path: Path):
    code_object = minimal_code_object()
    corpus, config, translator, _digest = _make_inputs(
        tmp_path,
        translator_body=(
            "import sys\n"
            "mode = sys.argv[sys.argv.index('--output-mode') + 1]\n"
            "if mode == 'diff':\n"
            "    print('instruction_translations:')\n"
            "    print('  total=1 changed=0 shown=0')\n"
            "else:\n"
            f"    sys.stdout.buffer.write({code_object!r})\n"
        ),
    )
    case = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        timeout_seconds=1,
        allow_incomplete=False,
    )[0]
    context = _run_context(tmp_path)
    result = dbt.build(case, context, None)

    with pytest.raises(RuntimeError, match="no B0-to-A0 instruction rewrites"):
        dbt.run(case, result, context)

    log_path = (
        context.artifact_directory
        / "dbt"
        / "gfx1250.b0-to-a0"
        / f"{case.metadata['sha256']}.log"
    )
    assert "total=1 changed=0 shown=0" in log_path.read_text(encoding="utf-8")


def test_translation_rejects_rewrite_count_drift(tmp_path: Path):
    code_object = minimal_code_object()
    corpus, config, translator, _digest = _make_inputs(
        tmp_path,
        translator_body=(
            "import sys\n"
            "mode = sys.argv[sys.argv.index('--output-mode') + 1]\n"
            "if mode == 'diff':\n"
            "    print('instruction_translations:')\n"
            "    print('  total=2 changed=2 shown=2')\n"
            "else:\n"
            f"    sys.stdout.buffer.write({code_object!r})\n"
        ),
    )
    case = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        timeout_seconds=1,
        allow_incomplete=False,
    )[0]
    context = _run_context(tmp_path)
    result = dbt.build(case, context, None)

    with pytest.raises(
        RuntimeError,
        match="expected 1 source instructions requiring rewrite",
    ):
        dbt.run(case, result, context)


def test_translation_rejects_header_only_code_object(tmp_path: Path):
    header_only = bytearray(64)
    header_only[:7] = b"\x7fELF\x02\x01\x01"
    struct.pack_into("<HHI", header_only, 16, 3, 224, 1)
    struct.pack_into("<H", header_only, 52, 64)

    with pytest.raises(RuntimeError, match="program-header table"):
        dbt._validate_code_object(bytes(header_only), "0" * 64)


def test_translation_rejects_invalid_elf_header_version():
    malformed = bytearray(minimal_code_object())
    struct.pack_into("<I", malformed, 20, 0)

    with pytest.raises(RuntimeError, match="invalid ELF version"):
        dbt._validate_code_object(bytes(malformed), "0" * 64)


def test_translation_rejects_invalid_section_table():
    malformed = bytearray(minimal_code_object())
    struct.pack_into("<H", malformed, 60, 0)

    with pytest.raises(RuntimeError, match="section-header table"):
        dbt._validate_code_object(bytes(malformed), "0" * 64)


def test_translation_rejects_out_of_bounds_segment():
    malformed = bytearray(minimal_code_object())
    program_offset = struct.unpack_from("<Q", malformed, 32)[0]
    struct.pack_into("<Q", malformed, program_offset + 8, len(malformed))

    with pytest.raises(RuntimeError, match="out-of-bounds segment"):
        dbt._validate_code_object(bytes(malformed), "0" * 64)


def test_translation_rejects_out_of_bounds_section():
    malformed = bytearray(minimal_code_object())
    section_offset = struct.unpack_from("<Q", malformed, 40)[0]
    struct.pack_into("<Q", malformed, section_offset + 2 * 64 + 24, len(malformed))

    with pytest.raises(RuntimeError, match="out-of-bounds section"):
        dbt._validate_code_object(bytes(malformed), "0" * 64)


def test_translation_rejects_non_executable_load():
    malformed = bytearray(minimal_code_object())
    program_offset = struct.unpack_from("<Q", malformed, 32)[0]
    struct.pack_into("<I", malformed, program_offset + 4, 4)

    with pytest.raises(RuntimeError, match="no executable loadable content"):
        dbt._validate_code_object(bytes(malformed), "0" * 64)


def test_translation_fails_when_llvm_objdump_rejects_output(tmp_path: Path):
    corpus, config, translator, _digest = _make_inputs(tmp_path)
    llvm_objdump = translator.parent / "llvm-objdump"
    llvm_objdump.write_text(
        "#!/usr/bin/env python3\n"
        "import sys\n"
        "print('invalid object', file=sys.stderr)\n"
        "raise SystemExit(1)\n",
        encoding="utf-8",
    )
    llvm_objdump.chmod(0o755)
    cases = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        timeout_seconds=1,
        allow_incomplete=False,
    )
    context = _run_context(tmp_path)
    result = dbt.build(cases[0], context, None)

    with pytest.raises(RuntimeError, match="llvm-objdump rejected"):
        dbt.run(cases[0], result, context)


def test_expected_translation_error_is_xfailed_after_diagnostic_match(
    tmp_path: Path,
):
    corpus, config, translator, digest = _make_inputs(
        tmp_path,
        expected_failure={
            "kind": "translation-error",
            "reason": "known failure",
            "returncode": 3,
            "stderr_regex": "known diagnostic",
        },
        translator_body=(
            "import sys\n"
            "print('error: known diagnostic', file=sys.stderr)\n"
            "raise SystemExit(3)\n"
        ),
    )
    case = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        timeout_seconds=1,
        allow_incomplete=False,
    )[0]
    context = _run_context(tmp_path)
    result = dbt.build(case, context, None)

    with pytest.raises(pytest.xfail.Exception, match="known failure"):
        dbt.run(case, result, context)

    log_path = context.artifact_directory / "dbt" / "gfx1250.b0-to-a0" / f"{digest}.log"
    assert "known diagnostic" in log_path.read_text(encoding="utf-8")


def test_unexpected_translation_error_is_an_error(tmp_path: Path):
    corpus, config, translator, _digest = _make_inputs(
        tmp_path,
        translator_body="raise SystemExit(7)\n",
    )
    case = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        timeout_seconds=1,
        allow_incomplete=False,
    )[0]
    context = _run_context(tmp_path)
    result = dbt.build(case, context, None)

    with pytest.raises(
        RuntimeError,
        match="failure is not listed in the expected-failure manifest",
    ):
        dbt.run(case, result, context)


def test_expected_failure_that_passes_is_an_error(tmp_path: Path):
    corpus, config, translator, _digest = _make_inputs(
        tmp_path,
        expected_failure={
            "kind": "translation-error",
            "reason": "known failure",
            "returncode": 3,
            "stderr_regex": "known diagnostic",
        },
    )
    case = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        timeout_seconds=1,
        allow_incomplete=False,
    )[0]
    context = _run_context(tmp_path)
    result = dbt.build(case, context, None)

    with pytest.raises(RuntimeError, match="unexpectedly passed"):
        dbt.run(case, result, context)


def test_expected_failure_diagnostic_drift_is_an_error(tmp_path: Path):
    corpus, config, translator, _digest = _make_inputs(
        tmp_path,
        expected_failure={
            "kind": "translation-error",
            "reason": "known failure",
            "returncode": 3,
            "stderr_regex": "old diagnostic",
        },
        translator_body=(
            "import sys\n"
            "print('error: new diagnostic', file=sys.stderr)\n"
            "raise SystemExit(3)\n"
        ),
    )
    case = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        timeout_seconds=1,
        allow_incomplete=False,
    )[0]
    context = _run_context(tmp_path)
    result = dbt.build(case, context, None)

    with pytest.raises(RuntimeError, match="did not match expected regex"):
        dbt.run(case, result, context)


def test_expected_timeout_is_xfailed(tmp_path: Path, monkeypatch):
    corpus, config, translator, _digest = _make_inputs(
        tmp_path,
        expected_failure={
            "kind": "timeout",
            "reason": "known hang",
        },
    )
    case = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        timeout_seconds=1,
        allow_incomplete=False,
    )[0]
    context = _run_context(tmp_path)
    result = dbt.build(case, context, None)

    def raise_timeout(*_args, **_kwargs):
        raise subprocess.TimeoutExpired(["rj_dbt_translate"], 1)

    monkeypatch.setattr(dbt, "_run_translator", raise_timeout)
    with pytest.raises(pytest.xfail.Exception, match="known hang"):
        dbt.run(case, result, context)


def test_expected_memory_limit_is_xfailed(tmp_path: Path, monkeypatch):
    corpus, config, translator, _digest = _make_inputs(
        tmp_path,
        expected_failure={
            "kind": "memory-limit",
            "reason": "known memory growth",
        },
    )
    case = dbt.discover(
        TargetSpec("gfx1250"),
        [config],
        corpus_directory=corpus,
        translator=translator,
        timeout_seconds=1,
        allow_incomplete=False,
    )[0]
    context = _run_context(tmp_path)
    result = dbt.build(case, context, None)

    monkeypatch.setattr(dbt, "_run_translator", lambda *_args, **_kwargs: (-9, True))
    with pytest.raises(pytest.xfail.Exception, match="known memory growth"):
        dbt.run(case, result, context)


def test_translator_timeout_kills_process_group(tmp_path: Path):
    child_pid_path = tmp_path / "child.pid"
    script = tmp_path / "forking_translator.py"
    script.write_text(
        "import subprocess, sys, time\n"
        "child = subprocess.Popen([sys.executable, '-c', "
        "'import time; time.sleep(30)'])\n"
        f"open({str(child_pid_path)!r}, 'w').write(str(child.pid))\n"
        "time.sleep(30)\n",
        encoding="utf-8",
    )
    with (
        (tmp_path / "stdout").open("w+b") as stdout,
        (tmp_path / "stderr").open("w+b") as stderr,
        pytest.raises(subprocess.TimeoutExpired),
    ):
        dbt._run_translator(
            [sys.executable, str(script)],
            cwd=tmp_path,
            env={},
            stdout=stdout,
            stderr=stderr,
            timeout_seconds=0.5,
            memory_limit_bytes=1024 * 1024 * 1024,
        )

    child_pid = int(child_pid_path.read_text(encoding="ascii"))
    for _attempt in range(50):
        try:
            state = Path(f"/proc/{child_pid}/stat").read_text().split()[2]
        except (FileNotFoundError, IndexError, OSError):
            state = None
        if state in (None, "Z"):
            break
        time.sleep(0.01)
    assert state in (None, "Z"), "translator child outlived the process-group kill"


def test_translator_memory_limit_reacts_to_accounted_rss(
    tmp_path: Path, monkeypatch
):
    monkeypatch.setattr(dbt, "_resident_memory_bytes", lambda _pid: 2)
    with (
        (tmp_path / "stdout").open("w+b") as stdout,
        (tmp_path / "stderr").open("w+b") as stderr,
    ):
        returncode, memory_exceeded = dbt._run_translator(
            [sys.executable, "-c", "import time; time.sleep(10)"],
            cwd=tmp_path,
            env={},
            stdout=stdout,
            stderr=stderr,
            timeout_seconds=1,
            memory_limit_bytes=1,
        )

    assert returncode < 0
    assert memory_exceeded


def test_translator_real_resident_memory_limit(tmp_path: Path):
    program = (
        "import time\n"
        "chunks = []\n"
        "for _ in range(64):\n"
        "    chunks.append(bytearray(4 * 1024 * 1024))\n"
        "    time.sleep(0.005)\n"
        "time.sleep(10)\n"
    )
    with (
        (tmp_path / "stdout").open("w+b") as stdout,
        (tmp_path / "stderr").open("w+b") as stderr,
    ):
        returncode, memory_exceeded = dbt._run_translator(
            [sys.executable, "-c", program],
            cwd=tmp_path,
            env={},
            stdout=stdout,
            stderr=stderr,
            timeout_seconds=2,
            memory_limit_bytes=64 * 1024 * 1024,
        )

    assert returncode < 0
    assert memory_exceeded


def _make_inputs(
    tmp_path: Path,
    *,
    complete: bool = True,
    expected_failure: dict | None = None,
    source: bytes | None = None,
    translator_body: str | None = None,
) -> tuple[Path, dict, Path, str]:
    corpus = tmp_path / "extraction"
    objects = corpus / "objects"
    manifests = corpus / "manifests"
    objects.mkdir(parents=True)
    manifests.mkdir()

    if source is None:
        source = b"packaged gfx1250 code object"
    digest = hashlib.sha256(source).hexdigest()
    (objects / f"{digest}.hsaco").write_bytes(source)
    (manifests / "SHA256SUMS").write_text(
        f"{digest}  objects/{digest}.hsaco\n",
        encoding="ascii",
    )
    baseline_content = f"{digest}  objects/{digest}.hsaco\n"
    (manifests / "NON_CCOB_SHA256SUMS").write_text(
        baseline_content,
        encoding="ascii",
    )
    _write_json(
        corpus / "summary.json",
        {
            "ccob_status": "materialized" if complete else "skipped",
            "complete": complete,
            "failures": [],
            "target": "gfx1250",
            "unique_code_objects": 1,
        },
    )
    _write_json(
        manifests / "packages.json",
        [{"name": "producer-package", "version": "1"}],
    )

    lock_path = tmp_path / "packages.lock.json"
    _write_json(
        lock_path,
        {
            "baseline_manifest_sha256": hashlib.sha256(
                baseline_content.encode("ascii")
            ).hexdigest(),
            "expected_unique_code_objects": {
                "materialized": {"minimum": 1},
                "skipped": {"exact": 1},
            },
            "packages": {"producer-package": "1"},
            "schema_version": 1,
        },
    )
    expected_failures_path = tmp_path / "expected_failures.json"
    _write_json(
        expected_failures_path,
        {
            "expected_failures": (
                {digest: expected_failure} if expected_failure is not None else {}
            ),
            "input_revision": "b0",
            "output_revision": "a0",
            "schema_version": 1,
            "target": "gfx1250",
        },
    )
    expected_rewrites_path = tmp_path / "expected_rewrites.json"
    _write_json(
        expected_rewrites_path,
        {
            "expected_rewrites": (
                {}
                if expected_failure is not None
                else {digest: {"instructions_requiring_rewrite": 1}}
            ),
            "input_revision": "b0",
            "output_revision": "a0",
            "schema_version": 1,
            "target": "gfx1250",
        },
    )
    config_path = tmp_path / "config.json"
    config = {
        "_path": str(config_path),
        "config_name": "test",
        "expected_failures": str(expected_failures_path),
        "expected_rewrites": str(expected_rewrites_path),
        "input_revision": "b0",
        "memory_limit_mib": 4096,
        "output_revision": "a0",
        "package_lock": str(lock_path),
        "target": "gfx1250",
        "timeout_seconds": 10,
    }

    translator = tmp_path / "rj_dbt_translate"
    body = translator_body
    if body is None:
        body = (
            "import sys\n"
            "mode = sys.argv[sys.argv.index('--output-mode') + 1]\n"
            "if mode == 'diff':\n"
            "    print('instruction_translations:')\n"
            "    print('  total=1 changed=1 shown=1')\n"
            "else:\n"
            f"    sys.stdout.buffer.write({minimal_code_object()!r})\n"
        )
    translator.write_text(f"#!/usr/bin/env python3\n{body}", encoding="utf-8")
    translator.chmod(0o755)
    llvm_objdump = tmp_path / "llvm-objdump"
    llvm_objdump.write_text("#!/bin/sh\nexit 0\n", encoding="utf-8")
    llvm_objdump.chmod(0o755)
    return corpus, config, translator, digest


def minimal_code_object() -> bytes:
    program_offset = 64
    program_entry_size = 56
    program_count = 2
    note_offset = program_offset + program_entry_size * program_count
    metadata = msgpack.packb(
        {
            "amdhsa.kernels": [
                {".name": "test_kernel", ".symbol": "test_kernel.kd"}
            ],
            "amdhsa.version": [1, 2],
        },
        use_bin_type=True,
    )
    note = (
        struct.pack("<III", 7, len(metadata), 32)
        + b"AMDGPU\0\0"
        + metadata
        + bytes((-len(metadata)) % 4)
    )
    text_offset = note_offset + len(note)
    text = b"\x00\x00\x00\x00"
    section_offset = text_offset + len(text)
    section_entry_size = 64
    section_count = 3
    result = bytearray(section_offset + section_entry_size * section_count)
    result[:7] = b"\x7fELF\x02\x01\x01"
    struct.pack_into("<HHI", result, 16, 3, 224, 1)
    struct.pack_into("<QQ", result, 32, program_offset, section_offset)
    struct.pack_into(
        "<HHHHHH",
        result,
        52,
        64,
        program_entry_size,
        program_count,
        section_entry_size,
        section_count,
        0,
    )
    struct.pack_into(
        "<IIQQQQQQ",
        result,
        program_offset,
        1,
        5,
        text_offset,
        0,
        0,
        len(text),
        len(text),
        4,
    )
    struct.pack_into(
        "<IIQQQQQQ",
        result,
        program_offset + program_entry_size,
        4,
        4,
        note_offset,
        0,
        0,
        len(note),
        len(note),
        4,
    )
    result[note_offset : note_offset + len(note)] = note
    result[text_offset : text_offset + len(text)] = text
    struct.pack_into(
        "<IIQQQQIIQQ",
        result,
        section_offset + section_entry_size,
        0,
        7,
        2,
        0,
        note_offset,
        len(note),
        0,
        0,
        4,
        0,
    )
    struct.pack_into(
        "<IIQQQQIIQQ",
        result,
        section_offset + 2 * section_entry_size,
        0,
        1,
        6,
        0,
        text_offset,
        len(text),
        0,
        0,
        4,
        0,
    )
    return bytes(result)


def minimal_data_only_code_object() -> bytes:
    result = bytearray(minimal_code_object())
    program_offset = struct.unpack_from("<Q", result, 32)[0]
    struct.pack_into("<I", result, program_offset + 4, 4)
    section_offset = struct.unpack_from("<Q", result, 40)[0]
    struct.pack_into("<Q", result, section_offset + 2 * 64 + 8, 2)
    return bytes(result)


def _run_context(tmp_path: Path) -> RunContext:
    return RunContext(
        repo_root=tmp_path,
        artifact_directory=tmp_path / "artifacts",
        skip_all_runs=False,
    )


def _write_json(path: Path, payload) -> None:
    path.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
