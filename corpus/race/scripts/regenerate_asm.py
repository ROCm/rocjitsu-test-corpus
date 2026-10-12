#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""
Regenerate the committed device assembly under ``asm/``.

This is the **only** part of the corpus that needs a HIP compiler. It is a
manual tool, run by a person, not by CI::

    python corpus/race/scripts/regenerate_asm.py                 # every target
    python corpus/race/scripts/regenerate_asm.py --target gfx950
    python corpus/race/scripts/regenerate_asm.py --check         # report drift

``--check`` is manual too: it compiles with whatever toolchain is installed, so
its result changes when the toolchain does, which is not something a CI gate
should depend on. It compares assembly text only. ``scripts/check_cases.py``
checks the case inventory in ``cases.toml`` against ``kernels/`` and the
committed assembly with no compiler; that is the check suited to CI, and
``tests/test_check_cases.py`` runs it under pytest. The workflow is described
in ``corpus/race/README.md``.

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
import shlex
import shutil
import subprocess
import sys
import tempfile
import tomllib
from pathlib import Path

CORPUS_ROOT = Path(__file__).resolve().parent.parent
KERNELS_DIR = CORPUS_ROOT / "kernels"
ASM_DIR = CORPUS_ROOT / "asm"
CASES_PATH = CORPUS_ROOT / "cases.toml"

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


def parse_cxxflags(text: str) -> list[str]:
    """
    Split ``--cxxflags`` into arguments the way a shell would, without running one.

    A quoted path with spaces, such as ``-I"my headers"``, stays one argument.
    Malformed quoting is refused here, before any kernel is compiled.
    """
    try:
        return shlex.split(text)
    except ValueError as error:
        raise SystemExit(f"--cxxflags: cannot parse {text!r}: {error} (check the quoting)") from None


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


# Environment variables the compiler adds include directories from. HIP
# compiles as C++, so CPLUS_INCLUDE_PATH applies and C_INCLUDE_PATH does not.
_INCLUDE_PATH_VARIABLES = ("CPATH", "CPLUS_INCLUDE_PATH")


def include_dirs(flags: list[str]) -> list[Path]:
    """
    Where the compiler will look for headers.

    ROCm's include, then -I/-isystem/-iquote, then the absolute entries of the
    include-path environment variables, which the compile inherits. A relative
    entry is not counted: the compiler runs in a private scratch directory,
    where it would name nothing.
    """
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
    for variable in _INCLUDE_PATH_VARIABLES:
        for entry in os.environ.get(variable, "").split(os.pathsep):
            if entry and Path(entry).is_absolute():
                dirs.append(Path(entry))
    return dirs


def missing_headers(case: dict, flags: list[str]) -> list[str]:
    """The case's declared ``headers`` that no include directory provides."""
    dirs = include_dirs(flags)
    return [h for h in case.get("headers", []) if not any((d / h).is_file() for d in dirs)]


# --- Toolchain ---------------------------------------------------------------
# Discovered, never pinned. Which toolchain produced a given .s is recorded in
# that file's .ident line rather than being constrained here.


def rocm_path() -> Path:
    """
    The ROCm SDK root, as an absolute path.

    Absolute because the compiler runs from a private scratch directory: a
    relative ROCM_PATH names the caller's directory, and would name nothing
    there.
    """
    if (explicit := os.environ.get("ROCM_PATH")):
        return Path(explicit).expanduser().absolute()
    if shutil.which("rocm-sdk"):
        proc = subprocess.run(
            ["rocm-sdk", "path", "--root"], capture_output=True, text=True, check=False
        )
        if proc.returncode == 0 and proc.stdout.strip():
            return Path(proc.stdout.strip()).absolute()
    if Path("/opt/rocm").is_dir():
        return Path("/opt/rocm")
    raise SystemExit("set ROCM_PATH, or make rocm-sdk available on PATH")


def find_hip_compiler() -> Path:
    """
    The HIP compiler, as an absolute path: the SDK's ``bin/hipcc``, else its
    ``llvm/bin/clang++``, else ``hipcc`` on PATH. Absolute for the same reason
    as rocm_path: it is run from the scratch directory.
    """
    root = rocm_path()
    for candidate in (root / "bin" / "hipcc", root / "llvm" / "bin" / "clang++"):
        if candidate.is_file():
            return candidate
    if (found := shutil.which("hipcc")):
        return Path(found).absolute()
    raise SystemExit(
        f"no HIP compiler: neither {root}/bin/hipcc nor {root}/llvm/bin/clang++ exists, "
        f"and hipcc is not on PATH; set ROCM_PATH to a ROCm install"
    )


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
    tool = find_hip_compiler()
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


def load_manifest() -> dict:
    manifest = tomllib.loads(CASES_PATH.read_text())
    corpus = manifest.get("corpus", {})
    if corpus.get("schema") != 1:
        raise SystemExit("cases.toml: unsupported corpus schema")
    targets = corpus.get("targets")
    if not targets or not all(isinstance(target, str) for target in targets):
        raise SystemExit("cases.toml: [corpus] targets must list the gfx targets the corpus is built for")
    for case in manifest["case"]:
        for target in case.get("requires", []):
            if target not in targets:
                raise SystemExit(
                    f"cases.toml [{case['id']}]: requires {target}, which is not in "
                    f"[corpus] targets; add it there first"
                )
    return manifest


def load_cases() -> list[dict]:
    return load_manifest()["case"]


def targets_for(requested: list[str]) -> list[str]:
    """The targets to regenerate: the ones requested, or every corpus target."""
    targets = load_manifest()["corpus"]["targets"]
    for target in requested:
        if target not in targets:
            raise SystemExit(
                f"--target {target}: {target} is not in [corpus] targets in cases.toml; "
                f"add it there first"
            )
    return list(requested) or list(targets)


def expected_outputs(cases: list[dict], targets: list[str]) -> set[tuple[str, str]]:
    """The (target, file) each selected case should produce: ``asm/<target>/<kernel>.s``."""
    return {
        (target, f"{case['kernel']}.s")
        for target in targets
        for case in cases
        if not case.get("requires") or target in case["requires"]
    }


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
                    f"pass its include directory with --cxxflags, or add it to CPATH"
                )
                continue
            kernel = KERNELS_DIR / f"{case['kernel']}.hip"
            out = out_root / target / f"{case['kernel']}.s"
            try:
                compile_device_asm(kernel, target, out, extra_flags)
                written += 1
            except CompileError as error:
                # The whole message: the kernel and target, then the
                # compiler's own diagnostic, which says what to fix.
                failures.append(str(error))
    return written, failures, skipped


def main() -> int:
    parser = argparse.ArgumentParser(
        description=(
            "Regenerate the committed device assembly under corpus/race/asm/ from "
            "the kernels in cases.toml, or check it for drift with --check."
        ),
        epilog="The workflow, layout and checks are described in corpus/race/README.md.",
    )
    parser.add_argument(
        "--target",
        action="append",
        default=[],
        help=(
            "gfx target to regenerate; repeat for several. Default: every target in "
            "[corpus] targets in cases.toml."
        ),
    )
    parser.add_argument(
        "--cxxflags",
        default="",
        help=(
            "Extra compiler flags, split like shell words, so a path with spaces "
            "can be quoted, e.g. --cxxflags='-I\"/path/to/my headers\"'"
        ),
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help=(
            "Do not write. Regenerate into a temporary directory and compare it "
            "with the committed assembly as text, after replacing hipcc's "
            "per-invocation __hip_cuid hash. A file that differs only in its "
            ".ident line came from another compiler that emitted the same text, "
            "and is reported without failing. Any other difference, in an "
            "instruction, a directive or metadata, is drift and fails the check, "
            "as does an expected file that is missing or a committed file no "
            "selected case builds. Exits 0 on a match, 1 on drift, 2 when a case "
            "fails to compile, and 3 when the check is incomplete because a case "
            "was skipped (see --allow-skipped) or nothing was compared."
        ),
    )
    parser.add_argument(
        "--allow-skipped",
        action="store_true",
        help=(
            "With --check, pass when every case that could be compared matches, "
            "even if some were skipped because an optional header is unavailable. "
            "The skipped cases are still listed as not compared. Without this, a "
            "skipped case makes the check incomplete (exit 3)."
        ),
    )
    args = parser.parse_args()
    if args.allow_skipped and not args.check:
        parser.error("--allow-skipped only applies with --check")

    targets = targets_for(args.target)
    extra_flags = absolute_flags(parse_cxxflags(args.cxxflags), Path.cwd())

    if not args.check:
        return _regenerate_and_report(args, targets, extra_flags, ASM_DIR)
    # The comparison has to finish while the regenerated files still exist, and
    # the directory is removed however the check ends.
    with tempfile.TemporaryDirectory(prefix="race-asm-") as scratch:
        return _regenerate_and_report(args, targets, extra_flags, Path(scratch))


def _regenerate_and_report(
    args: argparse.Namespace, targets: list[str], extra_flags: list[str], out_root: Path
) -> int:
    """Regenerate into *out_root* and report: a write summary, or the --check verdict."""
    print(f"regenerating {', '.join(targets)} -> {out_root}")

    written, failures, skipped = regenerate(targets, extra_flags, out_root)
    for skip in skipped:
        print(f"  skip: {skip}")
    for failure in failures:
        header, _, diagnostic = failure.partition("\n")
        print(f"  FAIL: {header}", file=sys.stderr)
        for line in diagnostic.splitlines():
            print(f"    {line}", file=sys.stderr)
    if failures:
        print("\nfailed kernels' committed assembly is untouched", file=sys.stderr)
        return 2

    if not args.check:
        print(f"\nwrote {written} file(s) under {ASM_DIR.relative_to(CORPUS_ROOT.parent.parent)}")
        print("Review the diff before committing: regenerating is a deliberate change to")
        print("the pinned assembly. Mutants are derived from it, so where waits or loads")
        print("moved, the mutants of those kernels change with them.")
        return 0

    # A verdict covers only what was compared. A check that skipped a case is
    # incomplete unless skipping was allowed, and one that compared nothing
    # cannot report a match either way.
    expected = expected_outputs(load_cases(), targets)
    not_generated = {(t, f) for t, f in expected if not (out_root / t / f).is_file()}
    compared_nothing = not expected or not_generated == expected
    if compared_nothing or (skipped and not args.allow_skipped):
        reason = (
            f"{len(skipped)} case(s) were skipped, so their committed assembly was not compared"
            if skipped
            else f"no case builds for {', '.join(targets)}, so nothing was compared"
        )
        print(f"\ncheck incomplete: {reason}.", file=sys.stderr)
        if skipped:
            for skip in skipped:
                print(f"  not compared: {skip.split(':', 1)[0]}", file=sys.stderr)
            print("Make the skipped cases' headers available and check again,", file=sys.stderr)
            print("or pass --allow-skipped to check only the rest.", file=sys.stderr)
        return 3
    return _report_drift(
        targets, out_root, expected, not_compared=not_generated if skipped else set()
    )


def _report_drift(
    targets: list[str],
    out_root: Path,
    expected: set[tuple[str, str]],
    not_compared: set[tuple[str, str]] = frozenset(),
) -> int:
    """
    Compare freshly generated assembly against what is committed.

    Every output the selected cases should produce (*expected*) must have been
    generated and committed, and nothing else may be committed for the selected
    targets: a missing or obsolete file is drift, not something to pass over.
    The exception is *not_compared*: expected outputs of cases skipped with
    --allow-skipped, which are named in the verdict rather than compared.

    The ``.ident`` line is compared apart from everything else. A file whose
    only difference is its ``.ident`` came from a different compiler that
    emitted the same text; that is reported, but is not drift. Any other
    difference -- an instruction, a directive, metadata -- is drift.
    """
    drifted: list[str] = []
    provenance: dict[tuple[str, str], list[str]] = {}
    for target in targets:
        fresh_dir, committed_dir = out_root / target, ASM_DIR / target
        fresh_names = {path.name for path in fresh_dir.glob("*.s")} if fresh_dir.is_dir() else set()
        committed_names = (
            {path.name for path in committed_dir.glob("*.s")} if committed_dir.is_dir() else set()
        )
        expected_names = {file for expected_target, file in expected if expected_target == target}
        for file in sorted(expected_names | fresh_names | committed_names):
            name = f"{target}/{file}"
            fresh, committed = fresh_dir / file, committed_dir / file
            if file not in expected_names:
                if file in committed_names:
                    drifted.append(f"{name}: committed, but no selected case builds it")
                else:
                    drifted.append(f"{name}: generated, but no selected case builds it")
                continue
            if (target, file) in not_compared:
                continue
            if file not in fresh_names:
                state = "not committed" if file not in committed_names else "committed"
                drifted.append(f"{name}: not generated and {state}")
                continue
            if file not in committed_names:
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

    if not_compared:
        print(f"\n{len(not_compared)} case(s) skipped and not compared (--allow-skipped):")
        for target, file in sorted(not_compared):
            print(f"  not compared: {Path(file).stem} ({target})")

    if not drifted:
        suffix = ", apart from .ident" if provenance else ""
        scope = " for the compared cases" if not_compared else ""
        print(f"\ncommitted assembly matches this toolchain{scope}{suffix}")
        return 0
    print(f"\n{len(drifted)} file(s) differ from what is committed:", file=sys.stderr)
    for entry in drifted:
        print(f"  {entry}", file=sys.stderr)
    print(
        "\nThis toolchain's output differs from the committed assembly outside the\n"
        ".ident line: in instructions, directives or metadata. It is not build\n"
        "noise -- the one irreproducible part of hipcc's output is normalized away\n"
        "before comparing. Regenerate only when you intend to move the pinned\n"
        "assembly onto current codegen. Mutants are derived from it, so where waits\n"
        "or sub-dword loads were added, removed or reordered, the mutants of those\n"
        "kernels change too.",
        file=sys.stderr,
    )
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
