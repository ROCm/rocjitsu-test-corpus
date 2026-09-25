"""Pinned Vulkan CTS compute/buffer cases; one isolated process per case."""

from __future__ import annotations

import hashlib
import json
import os
import re
import shlex
import signal
import subprocess
import time
import xml.etree.ElementTree as ET
from fnmatch import fnmatchcase
from functools import lru_cache
from pathlib import Path

import pytest

from support.define_contracts import (
    BuildResult,
    BuildState,
    CorpusCase,
    RunContext,
    TargetSpec,
)

REPO_ROOT = Path(__file__).resolve().parents[2]
CORPUS_ROOT = REPO_ROOT / "corpus" / "vulkan"
CTS_REVISION = (CORPUS_ROOT / "revision.txt").read_text(encoding="utf-8").strip()
TARGET_DEVICES = {"gfx1100": 0x7448, "gfx1201": 0x7551}


def default_config_files() -> tuple[Path, ...]:
    return (CORPUS_ROOT / "compute.txt", CORPUS_ROOT / "texel-buffer.txt")


def read_cases(path: Path) -> list[str]:
    names = path.read_text(encoding="utf-8").splitlines()
    if not names or len(set(names)) != len(names):
        raise ValueError(f"Empty or duplicate CTS case list: {path}")
    if any(not re.fullmatch(r"dEQP-VK\.[A-Za-z0-9_.-]+", name) for name in names):
        raise ValueError(f"Expected exact CTS case names in {path}")
    return names


def load_target_configs(config_files: tuple[str, ...] | list[str]) -> list[Path]:
    return [Path(path) for path in config_files]


def read_unsupported(path: Path, inventory: set[str]) -> set[str]:
    """Expand '*' patterns only against the pinned, explicit case inventory."""
    patterns = path.read_text(encoding="utf-8").splitlines()
    if not patterns or len(set(patterns)) != len(patterns):
        raise ValueError(f"Empty or duplicate CTS unsupported patterns: {path}")
    unsupported = set()
    for pattern in patterns:
        if not re.fullmatch(r"dEQP-VK\.[A-Za-z0-9_.*-]+", pattern):
            raise ValueError(f"Invalid CTS unsupported pattern: {pattern}")
        matches = {name for name in inventory if fnmatchcase(name, pattern)}
        if not matches:
            raise ValueError(
                f"CTS unsupported pattern matches no selected cases: {pattern}"
            )
        unsupported.update(matches)
    return unsupported


def discover(target: TargetSpec, target_configs: list[Path]) -> list[CorpusCase]:
    if target.target not in TARGET_DEVICES:
        raise ValueError("Vulkan CTS supports gfx1100 and gfx1201 only")
    inventory = {name for path in default_config_files() for name in read_cases(path)}
    unsupported = read_unsupported(
        CORPUS_ROOT / f"unsupported-{target.target}.txt", inventory
    )
    smoke = set(read_cases(CORPUS_ROOT / "smoke.txt"))
    stress = set(read_cases(CORPUS_ROOT / "stress.txt"))
    cases = []
    for path in target_configs:
        for name in read_cases(path):
            cases.append(
                CorpusCase(
                    id=f"vulkan.{target.target}.{name}",
                    suite="vulkan",
                    target=target.target,
                    collection=path.stem,
                    backend="radv",
                    path=path,
                    build={"system": "prebuilt", "revision": CTS_REVISION},
                    run={"kind": "deqp"},
                    metadata={"name": name, "allow_not_supported": name in unsupported},
                    selector_names=(
                        name,
                        path.stem,
                        "stress" if name in stress else "ci",
                        *(("smoke",) if name in smoke else ()),
                    ),
                )
            )
    return cases


def build(
    case: CorpusCase, _context: RunContext, _build_state: BuildState
) -> BuildResult:
    binary = Path(
        os.environ.get(
            "VULKAN_CTS_BINARY",
            str(
                REPO_ROOT
                / ".build/vulkan-cts/build/external/vulkancts/modules/vulkan/deqp-vk"
            ),
        )
    ).resolve()
    if not binary.is_file() or not os.access(binary, os.X_OK):
        raise RuntimeError(
            f"Missing Vulkan CTS binary: {binary}. Run bash scripts/build_vulkan_cts.sh "
            "or set VULKAN_CTS_BINARY to a build of the pinned revision."
        )
    return BuildResult(
        build_dir=binary.parent,
        executable_path=binary,
        metadata={"binary_sha256": binary_sha256(binary)},
    )


@lru_cache
def binary_sha256(binary: Path) -> str:
    digest = hashlib.sha256()
    with binary.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def check_result(qpa: str, name: str, target: str, allow_not_supported: bool) -> str:
    """Reject empty/truncated/wrong-case logs and unexpected capability loss."""
    info = dict(re.findall(r"^#sessionInfo (\w+) (.*)$", qpa, re.MULTILINE))
    if info.get("releaseName") != CTS_REVISION:
        raise RuntimeError(
            f"Expected CTS revision {CTS_REVISION}, got {info.get('releaseName')}"
        )
    if (
        info.get("vendorID") != "0x1002"
        or int(info.get("deviceID", "0"), 16) != TARGET_DEVICES[target]
        or "RADV" not in info.get("deviceName", "")
    ):
        raise RuntimeError(f"Expected RADV {target}, got {info}")
    if re.findall(r"^#beginTestCaseResult (.*)$", qpa, re.MULTILINE) != [name]:
        raise RuntimeError("CTS did not execute exactly the requested case")
    if qpa.count("#endTestCaseResult") != 1 or "#endSession" not in qpa:
        raise RuntimeError("Incomplete CTS result log")
    records = re.findall(r"<TestCaseResult\b.*?</TestCaseResult>", qpa, re.DOTALL)
    if len(records) != 1:
        raise RuntimeError("Expected exactly one CTS result")
    record = ET.fromstring(records[0])
    results = record.findall("Result")
    if record.get("CasePath") != name or len(results) != 1:
        raise RuntimeError("Missing or mismatched CTS case result")
    status = results[0].get("StatusCode")
    if status == "Pass" or (status == "NotSupported" and allow_not_supported):
        return status
    raise RuntimeError(f"CTS {status}: {results[0].text}")


def run(case: CorpusCase, build_result: BuildResult, context: RunContext) -> None:
    if context.skip_all_runs:
        return
    name = case.metadata["name"]
    # CTS names can exceed the filesystem's per-component length limit.
    case_id = hashlib.sha256(name.encode()).hexdigest()[:16]
    run_dir = context.artifact_directory / "vulkan" / case.target / case_id
    run_dir.mkdir(parents=True, exist_ok=True)
    qpa_path = run_dir / "results.qpa"
    qpa_path.unlink(missing_ok=True)
    binary = build_result.executable_path
    command = [
        *shlex.split(context.run_wrapper or ""),
        str(binary),
        f"--deqp-case={name}",
        f"--deqp-log-filename={qpa_path}",
        f"--deqp-archive-dir={os.environ.get('VULKAN_CTS_DATA_DIR', str(binary.parent))}",
        "--deqp-log-images=disable",
        "--deqp-log-shader-sources=disable",
        "--deqp-shadercache=disable",
    ]
    timeout = float(os.environ.get("VULKAN_CTS_TIMEOUT", "600"))
    if not 0 < timeout < float("inf"):
        raise ValueError("VULKAN_CTS_TIMEOUT must be a finite positive number")
    started = time.monotonic()
    timed_out = False
    with (run_dir / "run.log").open("w", encoding="utf-8") as log:
        log.write(shlex.join(command) + "\n")
        log.flush()
        process = subprocess.Popen(
            command,
            cwd=run_dir,
            stdout=log,
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )
        try:
            returncode = process.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            timed_out = True
        finally:
            # Reap any descendants left by an exited launcher.
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            returncode = process.wait()
    (run_dir / "run.json").write_text(
        json.dumps(
            {
                "case": name,
                "target": case.target,
                "command": command,
                "binary_sha256": build_result.metadata.get("binary_sha256"),
                "returncode": returncode,
                "timed_out": timed_out,
                "seconds": time.monotonic() - started,
            },
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    if timed_out:
        raise RuntimeError(f"CTS timed out after {timeout}s; diagnostics: {run_dir}")
    if returncode:
        raise RuntimeError(f"CTS exited {returncode}; diagnostics: {run_dir}")
    try:
        status = check_result(
            qpa_path.read_text(encoding="utf-8"),
            name,
            case.target,
            case.metadata["allow_not_supported"],
        )
    except (OSError, ValueError, ET.ParseError, RuntimeError) as exc:
        raise RuntimeError(f"{exc}; diagnostics: {run_dir}") from exc
    if status == "NotSupported":
        pytest.skip("NotSupported on the recorded hardware baseline")
