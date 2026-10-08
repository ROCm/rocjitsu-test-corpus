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

``--check`` compares assembly text only. ``scripts/check_cases.py`` checks the
metadata in ``cases.toml`` against the committed assembly -- the per-target
``waits`` and every exemption's ordinal -- and needs no compiler; run it after
regenerating.

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
the provenance of a committed artifact is visible in the artifact itself. It is
kept, but ``--check`` compares it apart from the rest of the file: a compiler
revision changes every ``.ident`` line even when it emits identical code, and
that is reported as a provenance change, not as drift.

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


# The line naming the compiler that produced a file. See the module docstring.
_IDENT_RE = re.compile(r"^\s*\.ident\s")


def split_provenance(assembly: str) -> tuple[list[str], list[str]]:
    """*assembly*'s lines, split into everything else and its ``.ident`` values."""
    lines = assembly.splitlines()
    return (
        [line for line in lines if not _IDENT_RE.match(line)],
        [line.strip().removeprefix(".ident").strip() for line in lines if _IDENT_RE.match(line)],
    )


def normalize(assembly: str) -> str:
    """Strip the one part of hipcc's output that is not reproducible."""
    return _CUID_RE.sub(_CUID_PLACEHOLDER, assembly)


class CompileError(RuntimeError):
    """A kernel could not be compiled for the requested target."""


# Flags whose value is a path, as a separate token or glued to the flag.
_PATH_FLAGS = ("-isystem", "-iquote", "-include", "-I")


def absolute_flags(flags: list[str], base: Path) -> list[str]:
    """
    *flags* with relative include paths made absolute against *base*.

    The compiler runs in a scratch directory, so a relative ``-I`` written
    against the caller's working directory has to be resolved first.
    """
    out: list[str] = []
    expect_path = False
    for flag in flags:
        if expect_path:
            out.append(str(base / flag) if not Path(flag).is_absolute() else flag)
            expect_path = False
            continue
        if flag in _PATH_FLAGS:
            out.append(flag)
            expect_path = True
            continue
        prefix = next((p for p in _PATH_FLAGS if flag.startswith(p) and len(flag) > len(p)), None)
        if prefix is not None and not Path(flag[len(prefix):]).is_absolute():
            out.append(prefix + str(base / flag[len(prefix):]))
        else:
            out.append(flag)
    return out


def include_dirs(flags: list[str]) -> list[Path]:
    """Where the compiler will look for headers: ROCm's include, then -I/-isystem/-iquote."""
    dirs = [rocm_path() / "include"]
    tokens = iter(flags)
    for flag in tokens:
        for prefix in ("-isystem", "-iquote", "-I"):
            if flag == prefix:
                dirs.append(Path(next(tokens, "")))
            elif flag.startswith(prefix) and len(flag) > len(prefix):
                dirs.append(Path(flag[len(prefix):]))
            else:
                continue
            break
    return dirs


def missing_headers(case: dict, flags: list[str]) -> list[str]:
    """The case's declared ``headers`` that no include directory provides."""
    dirs = include_dirs(flags)
    return [h for h in case.get("headers", []) if not any((d / h).is_file() for d in dirs)]


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
    ``hipcc -S --cuda-device-only`` for one kernel, replacing *out* on success.

    The compiler runs in a private scratch directory, which is also its working
    directory: hipcc sometimes ignores ``-o`` under ``--cuda-device-only`` and
    writes an auto-named file into the working directory instead, and that file
    must neither land in nor be deleted from the caller's directory. *out* is
    only touched once the compile has succeeded, and then replaced atomically,
    so a failed or interrupted run leaves the pinned file exactly as it was.
    *extra_flags* must not hold relative paths; see absolute_flags.
    """
    tool = hipcc()
    root = rocm_path()
    with tempfile.TemporaryDirectory(prefix="race-asm-compile-") as scratch_dir:
        scratch = Path(scratch_dir)
        compiled = scratch / f"{kernel.stem}.s"
        argv = [
            str(tool),
            f"--rocm-path={root}",
            "-S",
            "--cuda-device-only",
            f"--offload-arch={target}",
            str(kernel.resolve()),
            "-o",
            str(compiled),
        ]
        if (root / "include").is_dir():
            argv += ["-I", str(root / "include")]
        argv += extra_flags

        proc = subprocess.run(argv, cwd=scratch, capture_output=True, text=True, check=False)
        if proc.returncode != 0:
            raise CompileError(f"{kernel.name} ({target}):\n{proc.stderr.strip()}")
        if not compiled.is_file():
            compiled = scratch / f"{kernel.stem}-hip-amdgcn-amd-amdhsa-{target}.s"
            if not compiled.is_file():
                raise CompileError(f"{kernel.name} ({target}): hipcc produced no output file")
        assembly = normalize(compiled.read_text())

    _replace(out, assembly)


def _replace(out: Path, text: str) -> None:
    """Write *text* to *out* via a sibling temporary file and an atomic rename."""
    out.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(
        "w", dir=out.parent, prefix=f".{out.name}.", suffix=".tmp", delete=False
    ) as staged:
        staged.write(text)
    try:
        os.replace(staged.name, out)
    except BaseException:
        Path(staged.name).unlink(missing_ok=True)
        raise


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


def regenerate(
    targets: list[str], extra_flags: list[str], out_root: Path
) -> tuple[int, list[str], list[str]]:
    """
    Compile every case for every target into *out_root*.

    Returns the number written, the failures, and the skips: cases whose
    declared ``headers`` are not on the include path. A skipped or failed
    case's existing file under *out_root* is left untouched.
    """
    cases = load_cases()
    written = 0
    failures: list[str] = []
    skipped: list[str] = []
    for target in targets:
        for case in cases:
            requires = case.get("requires", [])
            if requires and target not in requires:
                continue
            if (missing := missing_headers(case, extra_flags)):
                skipped.append(
                    f"{case['kernel']} ({target}): {', '.join(missing)} not found; "
                    f"pass its include directory with --cxxflags"
                )
                continue
            kernel = KERNELS_DIR / f"{case['kernel']}.hip"
            out = out_root / target / f"{case['kernel']}.s"
            try:
                compile_device_asm(kernel, target, out, extra_flags)
                written += 1
            except CompileError as error:
                failures.append(str(error).splitlines()[0])
    return written, failures, skipped


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
    extra_flags = absolute_flags(args.cxxflags.split() if args.cxxflags else [], Path.cwd())

    out_root = Path(tempfile.mkdtemp(prefix="race-asm-")) if args.check else ASM_DIR
    print(f"regenerating {', '.join(targets)} -> {out_root}")

    written, failures, skipped = regenerate(targets, extra_flags, out_root)
    for skip in skipped:
        print(f"  skip: {skip}")
    for failure in failures:
        print(f"  FAIL: {failure}", file=sys.stderr)
    if failures:
        print("\nfailed kernels' committed assembly is untouched", file=sys.stderr)
        return 2

    if not args.check:
        print(f"\nwrote {written} file(s) under {ASM_DIR.relative_to(CORPUS_ROOT.parent.parent)}")
        print("Review the diff before committing: regenerating is a deliberate change")
        print("to the corpus, and where waits or loads moved, the mutation sites the")
        print("manifest records by ordinal move with them.")
        return 0

    return _report_drift(targets, out_root)


def _report_drift(targets: list[str], out_root: Path) -> int:
    """
    Compare freshly generated assembly against what is committed.

    The ``.ident`` line is compared apart from everything else. A file whose
    only difference is its ``.ident`` came from a different compiler that
    emitted the same text; that is reported, but is not drift. Any other
    difference -- an instruction, a directive, metadata -- is drift.
    """
    drifted: list[str] = []
    provenance: dict[tuple[str, str], list[str]] = {}
    for target in targets:
        fresh_dir, committed_dir = out_root / target, ASM_DIR / target
        if not fresh_dir.is_dir():
            continue
        for fresh in sorted(fresh_dir.glob("*.s")):
            name = f"{target}/{fresh.name}"
            committed = committed_dir / fresh.name
            if not committed.is_file():
                drifted.append(f"{name}: not committed")
                continue
            fresh_body, fresh_ident = split_provenance(fresh.read_text())
            committed_body, committed_ident = split_provenance(committed.read_text())
            if fresh_body != committed_body:
                changed = sum(
                    1
                    for line in difflib.unified_diff(committed_body, fresh_body, lineterm="", n=0)
                    if line[:1] in "+-" and not line.startswith(("+++", "---"))
                )
                drifted.append(f"{name}: {changed} line(s) added or removed")
            elif fresh_ident != committed_ident:
                key = (" ".join(committed_ident) or "(none)", " ".join(fresh_ident) or "(none)")
                provenance.setdefault(key, []).append(name)

    for (was, now), names in provenance.items():
        print(f"\n{len(names)} file(s) differ only in the compiler that produced them:")
        print(f"  committed:      {was}")
        print(f"  this toolchain: {now}")
        for name in names:
            print(f"    {name}")
        print("Every other line is identical, so this is not drift; regenerating would")
        print("only update their .ident lines.")

    if not drifted:
        suffix = ", apart from .ident" if provenance else ""
        print(f"\ncommitted assembly matches this toolchain{suffix}")
        return 0
    print(f"\n{len(drifted)} file(s) differ from what is committed:", file=sys.stderr)
    for entry in drifted:
        print(f"  {entry}", file=sys.stderr)
    print(
        "\nThis toolchain's output differs from the committed assembly outside the\n"
        ".ident line: in instructions, directives or metadata. It is not build\n"
        "noise -- the one irreproducible part of hipcc's output is normalized away\n"
        "before comparing. Regenerate only when you intend to move the corpus onto\n"
        "current codegen. Where waits or sub-dword loads were added, removed or\n"
        "reordered, the mutation sites the manifest records by ordinal move too.",
        file=sys.stderr,
    )
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
