"""HRX AMDGPU driver CTS from a pinned, separately built HRX checkout."""

from __future__ import annotations

import fcntl
import json
import os
import re
import shlex
import subprocess
from pathlib import Path
from xml.etree import ElementTree

from support.define_contracts import BuildResult, BuildState, CorpusCase, RunContext, TargetSpec


REPO_ROOT = Path(__file__).resolve().parents[2]
CORPUS_ROOT = REPO_ROOT / "corpus" / "hrx-system"
CTS_PREFIX = "iree/hal/drivers/amdgpu/cts/"
BINARY_DIR = "runtime/src/iree/hal/drivers/amdgpu/cts"
TARGETS = {"gfx1201", "gfx1250"}


def default_config_files() -> tuple[Path, ...]:
    return (CORPUS_ROOT / "cases.txt",)


def load_target_configs(config_files: tuple[str, ...] | list[str]) -> list[str]:
    names = Path(config_files[0]).read_text(encoding="utf-8").splitlines()
    if not names or len(names) != len(set(names)):
        raise ValueError("HRX CTS case list is empty or contains duplicates")
    if any(not re.fullmatch(r"[a-z][a-z0-9_]*_tests", name) for name in names):
        raise ValueError("HRX CTS case list contains an invalid CTest name")
    return names


def discover(target: TargetSpec, names: list[str]) -> list[CorpusCase]:
    if target.target not in TARGETS:
        raise ValueError("HRX AMDGPU CTS supports gfx1201 and gfx1250 only")
    return [
        CorpusCase(
            id=f"hrx.{target.target}.{name}",
            suite="hrx",
            target=target.target,
            collection="amdgpu-driver-cts",
            backend="amdgpu",
            path=CORPUS_ROOT / "cases.txt",
            build={"system": "prebuilt", "revision": _revision(), "ctest": name},
            run={"kind": "ctest_case"},
            metadata={"name": name},
            selector_names=(name,),
        )
        for name in names
    ]


def _revision() -> str:
    return (CORPUS_ROOT / "revision.txt").read_text(encoding="utf-8").strip()


def build(case: CorpusCase, _context: RunContext, _state: BuildState) -> BuildResult:
    build_dir_value = os.environ.get("HRX_SYSTEM_BUILD_DIR")
    if not build_dir_value:
        raise RuntimeError("Set HRX_SYSTEM_BUILD_DIR to a build of the pinned HRX revision")
    build_dir = Path(build_dir_value).resolve()
    cache = _cmake_cache(build_dir / "CMakeCache.txt")
    source_dir = Path(cache["CMAKE_HOME_DIRECTORY"]).resolve()
    revision = subprocess.run(
        ["git", "-C", str(source_dir), "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    if revision != _revision():
        raise RuntimeError(f"HRX build uses revision {revision}; expected {_revision()}")
    if subprocess.run(["git", "-C", str(source_dir), "diff", "--quiet", "HEAD"]).returncode:
        raise RuntimeError(f"HRX source has tracked changes: {source_dir}")
    if cache.get("IREE_HAL_AMDGPU_TARGETS") != case.target:
        raise RuntimeError(f"HRX build must target {case.target}")
    if cache.get("IREE_HAL_DRIVER_AMDGPU") != "ON" or cache.get("IREE_BUILD_TESTS") != "ON":
        raise RuntimeError("HRX build must enable AMDGPU and tests")

    name = case.metadata["name"]
    binary = build_dir / BINARY_DIR / name
    if not binary.is_file():
        raise RuntimeError(f"Missing HRX CTS binary: {binary}")
    ctest_name = CTS_PREFIX + name
    selection = subprocess.run(
        ["ctest", "--test-dir", str(build_dir), "--show-only=json-v1", "-R", f"^{ctest_name}$"],
        check=True,
        capture_output=True,
        text=True,
    )
    if [test["name"] for test in json.loads(selection.stdout)["tests"]] != [ctest_name]:
        raise RuntimeError(f"HRX build does not register {ctest_name}")
    return BuildResult(build_dir=build_dir, executable_path=binary)


def _cmake_cache(path: Path) -> dict[str, str]:
    if not path.is_file():
        raise RuntimeError(f"Missing HRX CMake cache: {path}")
    cache = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.startswith(("#", "//")) or "=" not in line:
            continue
        key, value = line.split("=", 1)
        cache[key.split(":", 1)[0]] = value
    return cache


def run(case: CorpusCase, result: BuildResult, context: RunContext) -> None:
    if context.skip_all_runs:
        return
    ctest_name = CTS_PREFIX + case.metadata["name"]
    command = [
        *shlex.split(context.run_wrapper or ""),
        "ctest",
        "--test-dir",
        str(result.build_dir),
        "-R",
        f"^{ctest_name}$",
        "--output-on-failure",
    ]
    log_dir = context.artifact_directory / "hrx" / case.target
    log_dir.mkdir(parents=True, exist_ok=True)
    log_path = log_dir / f"{case.metadata['name']}.ctest.log"
    xml_path = log_dir / f"{case.metadata['name']}.gtest.xml"
    xml_path.unlink(missing_ok=True)
    lock_path = context.repo_root / ".build/hrx-gpu-device.lock"
    lock_path.parent.mkdir(parents=True, exist_ok=True)
    with lock_path.open("a+") as lock_file:
        fcntl.flock(lock_file, fcntl.LOCK_EX)
        completed = subprocess.run(
            command,
            cwd=REPO_ROOT,
            env={**os.environ, "GTEST_OUTPUT": f"xml:{xml_path}"},
            capture_output=True,
            text=True,
        )
    log_path.write_text(
        f"$ {shlex.join(command)}\n{completed.stdout}{completed.stderr}", encoding="utf-8"
    )
    if completed.returncode:
        output = "\n".join((completed.stdout + completed.stderr).splitlines()[-30:])
        raise RuntimeError(
            f"{ctest_name} failed ({completed.returncode}); logs: {log_path}, {xml_path}\n{output}"
        )
    try:
        executed, skipped = _check_gtest_results(xml_path)
    except RuntimeError as exc:
        raise RuntimeError(f"{ctest_name}: {exc}; logs: {log_path}, {xml_path}") from exc
    with log_path.open("a", encoding="utf-8") as log:
        log.write(f"\nGoogle Test: {executed} executed, {skipped} skipped\n")


def _check_gtest_results(xml_path: Path) -> tuple[int, int]:
    try:
        cases = ElementTree.parse(xml_path).getroot().findall(".//testcase")
    except (OSError, ElementTree.ParseError) as exc:
        raise RuntimeError("missing or invalid Google Test XML") from exc
    skipped = [case.find("skipped") for case in cases]
    reasons = []
    for skip in skipped:
        if skip is None:
            continue
        reason = skip.get("message", "") + (skip.text or "")
        lines = reason.strip().splitlines()
        reasons.append(lines[-1] if lines else "skip reason unavailable")
        if "Backend '" in reason and " unavailable" in reason:
            raise RuntimeError(f"HRX backend unavailable: {reasons[-1]}")
    executed = sum(
        case.get("result") == "completed" and skip is None
        for case, skip in zip(cases, skipped)
    )
    if not executed:
        detail = f": {reasons[0]}" if reasons else ""
        raise RuntimeError(f"no Google Test cases executed{detail}")
    return executed, sum(skip is not None for skip in skipped)
