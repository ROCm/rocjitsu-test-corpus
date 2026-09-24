#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""
Regenerate the committed device assembly under ``asm/``.

This is the **only** part of the corpus that needs a HIP compiler, and it is
meant to be run by a person, not by CI::

    python corpus/race/scripts/regenerate_asm.py                 # every target
    python corpus/race/scripts/regenerate_asm.py --target gfx950
    python corpus/race/scripts/regenerate_asm.py --check         # CI drift gate

Why the assembly is committed rather than compiled per run: the compiler decides
how many ``s_wait_*`` instructions a kernel contains, and the corpus derives one
mutant per wait. Compiling at test time therefore lets a toolchain bump silently
reshape the corpus -- a different mutant count, different case IDs, different
results -- so two runs months apart are not comparing the same thing. Freezing
the assembly makes the set of injected defects fixed, and makes regenerating it
a deliberate, reviewable commit.

The cost is that the corpus stops tracking current codegen. A compiler that
starts emitting a new wait pattern will not be exercised until someone runs this
script. That is the intended trade: for scoring detectors, a stable set of known
defects beats following the compiler.

Each ``.s`` carries an ``.ident`` line naming the compiler that produced it, so
the provenance of a committed artifact is visible in the artifact itself.

One normalization is applied on the way out. hipcc stamps each translation unit
with a ``__hip_cuid_<hash>`` symbol that changes on every invocation, even for
identical input on an identical toolchain, which would make every regeneration
a 37-file diff of pure noise and make drift detection impossible. The hash is
rewritten to a fixed placeholder. Nothing cross-checks it: the device code is
located through the ``__hip_fatbin_<hash>`` symbol read out of the *host*
object at link time, so the cuid in the device assembly is unused -- verified by
linking committed assembly against a freshly compiled host object with a
deliberately mismatched cuid and running it successfully.
"""

from __future__ import annotations

import argparse
import difflib
import os
import re
import shutil
import subprocess
import sys
import tempfile
import tomllib
from pathlib import Path

CORPUS_ROOT = Path(__file__).resolve().parent.parent
KERNELS_DIR = CORPUS_ROOT / "kernels"
ASM_DIR = CORPUS_ROOT / "asm"

# hipcc's per-translation-unit id, which is regenerated on every invocation.
# See the module docstring for why replacing it is safe.
_CUID_RE = re.compile(r"__hip_cuid_[0-9a-f]+")
_CUID_PLACEHOLDER = "__hip_cuid_corpus"


def normalize(assembly: str) -> str:
    """Strip the one part of hipcc's output that is not reproducible."""
    return _CUID_RE.sub(_CUID_PLACEHOLDER, assembly)


class CompileError(RuntimeError):
    """A kernel could not be compiled for the requested target."""


# --- Toolchain ---------------------------------------------------------------
# Discovered, never pinned. Which toolchain produced a given .s is recorded in
# that file's .ident line rather than being constrained here.


def rocm_path() -> Path:
    if (explicit := os.environ.get("ROCM_PATH")):
        return Path(explicit)
    if shutil.which("rocm-sdk"):
        proc = subprocess.run(
            ["rocm-sdk", "path", "--root"], capture_output=True, text=True, check=False
        )
        if proc.returncode == 0 and proc.stdout.strip():
            return Path(proc.stdout.strip())
    if Path("/opt/rocm").is_dir():
        return Path("/opt/rocm")
    raise SystemExit("set ROCM_PATH, or make rocm-sdk available on PATH")


def hipcc() -> Path:
    root = rocm_path()
    for candidate in (root / "bin" / "hipcc", root / "llvm" / "bin" / "clang++"):
        if candidate.is_file():
            return candidate
    if (found := shutil.which("hipcc")):
        return Path(found)
    raise SystemExit(f"no hipcc under {root}; set ROCM_PATH to a ROCm install")


def compile_device_asm(kernel: Path, target: str, out: Path, extra_flags: list[str]) -> None:
    """
    ``hipcc -S --cuda-device-only`` for one kernel.

    hipcc sometimes ignores ``-o`` under ``--cuda-device-only`` and writes an
    auto-named file into the working directory instead, so both are checked.
    """
    tool = hipcc()
    root = rocm_path()
    out.parent.mkdir(parents=True, exist_ok=True)
    argv = [
        str(tool),
        f"--rocm-path={root}",
        "-S",
        "--cuda-device-only",
        f"--offload-arch={target}",
        str(kernel),
        "-o",
        str(out),
    ]
    if (root / "include").is_dir():
        argv += ["-I", str(root / "include")]
    argv += extra_flags

    auto_named = Path.cwd() / f"{kernel.stem}-hip-amdgcn-amd-amdhsa-{target}.s"
    for stale in (out, auto_named):
        stale.unlink(missing_ok=True)

    proc = subprocess.run(argv, capture_output=True, text=True, check=False)
    if proc.returncode != 0:
        raise CompileError(f"{kernel.name} ({target}):\n{proc.stderr.strip()}")
    if not out.is_file():
        if not auto_named.is_file():
            raise CompileError(f"{kernel.name} ({target}): hipcc produced no output file")
        shutil.move(str(auto_named), str(out))
    out.write_text(normalize(out.read_text()))


# --- Corpus ------------------------------------------------------------------


def load_cases() -> list[dict]:
    manifest = tomllib.loads((CORPUS_ROOT / "cases.toml").read_text())
    if manifest.get("corpus", {}).get("schema") != 1:
        raise SystemExit("cases.toml: unsupported corpus schema")
    return manifest["case"]


def targets_for(cases: list[dict], requested: list[str]) -> list[str]:
    """
    Every target the corpus mentions, unless the caller named some.

    Derived from the cases themselves so that adding a kernel for a new target
    does not also require editing this script.
    """
    if requested:
        return requested
    declared = {target for case in cases for target in case.get("requires", [])}
    # Portable kernels name no target, so the default set has to come from
    # somewhere; asm/ is the record of which targets the corpus is built for.
    existing = {path.name for path in ASM_DIR.iterdir() if path.is_dir()} if ASM_DIR.is_dir() else set()
    return sorted(declared | existing) or ["gfx950"]


def regenerate(targets: list[str], extra_flags: list[str], out_root: Path) -> tuple[int, list[str]]:
    cases = load_cases()
    written = 0
    failures: list[str] = []
    for target in targets:
        for case in cases:
            requires = case.get("requires", [])
            if requires and target not in requires:
                continue
            kernel = KERNELS_DIR / f"{case['kernel']}.hip"
            out = out_root / target / f"{case['kernel']}.s"
            try:
                compile_device_asm(kernel, target, out, extra_flags)
                written += 1
            except CompileError as error:
                failures.append(str(error).splitlines()[0])
    return written, failures


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--target",
        action="append",
        default=[],
        help="gfx target to regenerate; repeat for several. Default: every target in asm/.",
    )
    parser.add_argument(
        "--cxxflags",
        default="",
        help="Extra compiler flags, e.g. -I/path/to/rocwmma/include",
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help=(
            "Do not write. Regenerate into a temporary directory and report any "
            "difference from what is committed. A difference means this "
            "toolchain generates different code, not merely a different build."
        ),
    )
    args = parser.parse_args()

    cases = load_cases()
    targets = targets_for(cases, args.target)
    extra_flags = args.cxxflags.split() if args.cxxflags else []

    out_root = Path(tempfile.mkdtemp(prefix="race-asm-")) if args.check else ASM_DIR
    print(f"regenerating {', '.join(targets)} -> {out_root}")

    written, failures = regenerate(targets, extra_flags, out_root)
    for failure in failures:
        print(f"  FAIL: {failure}", file=sys.stderr)
    if failures:
        return 2

    if not args.check:
        print(f"\nwrote {written} file(s) under {ASM_DIR.relative_to(CORPUS_ROOT.parent.parent)}")
        print("Review the diff before committing: regenerating is a deliberate change")
        print("to the corpus, and shifts every mutant ordinal the manifest records.")
        return 0

    return _report_drift(targets, out_root)


def _report_drift(targets: list[str], out_root: Path) -> int:
    """Compare freshly generated assembly against what is committed."""
    drifted: list[str] = []
    for target in targets:
        fresh_dir, committed_dir = out_root / target, ASM_DIR / target
        if not fresh_dir.is_dir():
            continue
        for fresh in sorted(fresh_dir.glob("*.s")):
            committed = committed_dir / fresh.name
            if not committed.is_file():
                drifted.append(f"{target}/{fresh.name}: not committed")
                continue
            if fresh.read_text() != committed.read_text():
                diff = list(
                    difflib.unified_diff(
                        committed.read_text().splitlines(),
                        fresh.read_text().splitlines(),
                        fromfile=f"committed/{target}/{fresh.name}",
                        tofile=f"fresh/{target}/{fresh.name}",
                        lineterm="",
                        n=1,
                    )
                )
                drifted.append(f"{target}/{fresh.name}: {len(diff)} differing line(s)")

    if not drifted:
        print("\ncommitted assembly matches this toolchain")
        return 0
    print(f"\n{len(drifted)} file(s) differ from what is committed:", file=sys.stderr)
    for entry in drifted:
        print(f"  {entry}", file=sys.stderr)
    print(
        "\nThis toolchain generates different code than the one that produced the\n"
        "committed assembly. That is real drift, not build noise -- the one\n"
        "irreproducible part of hipcc's output is normalized away before\n"
        "comparing. Regenerate only when you intend to move the corpus onto\n"
        "current codegen, and expect every mutant ordinal to shift when you do.",
        file=sys.stderr,
    )
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
