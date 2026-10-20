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
``tests/test_check_cases.py`` runs it under pytest. It covers the inventory
only, not whether the assembly is up to date with its source, which only this
script's ``--check`` can tell. The workflow is described
in ``corpus/race/README.md``.

Why the assembly is committed rather than compiled per run: the compiler decides
how many ``s_wait_*`` instructions a kernel contains, and the corpus derives one
mutant per wait. Compiling at test time therefore lets a toolchain bump silently
reshape the corpus -- a different mutant count, different case IDs, different
results -- so two runs months apart are not comparing the same thing. Freezing
the assembly makes the set of injected defects fixed, and makes regenerating it
a deliberate, reviewable commit.

Pinning fixes the text, not which assembler can read it: a listing carries the
SDK's directives too, which a newer assembler can reject. The listings and their
mutants are meant to be assembled with the SDK recorded in ``recipe.toml``.

The cost is that the corpus stops tracking current codegen. A compiler that
starts emitting a new wait pattern will not be exercised until someone runs this
script. That is the intended trade: for scoring detectors, a stable set of known
defects beats following the compiler.

Each ``.s`` carries an ``.ident`` line naming the compiler that produced it, so
the provenance of a committed artifact is visible in the artifact itself. It is
kept, but ``--check`` compares it apart from the rest of the file: a compiler
revision changes every ``.ident`` line even when it emits identical code, and
that is reported as a provenance change, not as drift.

``.ident`` names clang, but not the SDK or the flags, so regenerating also
writes ``asm/<target>/recipe.toml``: the compiler, its version, the SDK release
and build, and the explicit flags. ``--check`` compares it with the recipe it
would use, and reports a changed recipe apart from a toolchain update. Variables
that change the compile from the environment, such as
``HIPCC_COMPILE_FLAGS_APPEND`` or ``CPATH``, would leave no record, so they are
removed from the compile's environment; see ``_UNRECORDED_VARIABLES``.

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

import argparse
import dataclasses
import difflib
import importlib.metadata
import os
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
from collections.abc import Sequence
from pathlib import Path

import inventory
import recipe

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

# Flags that add a directory to the header search path. Each takes its value as
# a separate token or glued to the flag.
_INCLUDE_DIR_FLAGS = ("-isystem", "-iquote", "-I")
# Flags whose value is a path: the search directories, and -include, whose value
# is a file to include rather than a directory to search.
_PATH_FLAGS = (*_INCLUDE_DIR_FLAGS, "-include")

# The recipe the pinned assembly is built with. hipcc adds these on its own, but
# the clang++ fallback does not: without them it compiles at -O0, and the
# instructions and wait sites the mutants are derived from change. They come
# before --cxxflags, so a flag there still overrides them.
_BASELINE_COMPILER_FLAGS = ("-O3", "-x", "hip")

# Variables that change what the compiler builds without appearing in its
# command line, and so in the recipe: hipcc appends HIPCC_*_FLAGS_APPEND to every
# invocation, clang rewrites its arguments from CCC_OVERRIDE_OPTIONS, the
# *_INCLUDE_PATH variables add header directories, and hipcc's HIP_* variables
# and DEVICE_LIB_PATH point it at another SDK's parts. They are removed from the
# compile's environment, which names only the selected SDK; flags and include
# directories go through --cxxflags, which the recipe records.
_UNRECORDED_VARIABLES = (
    "CCC_OVERRIDE_OPTIONS",
    "CPATH",
    "CPLUS_INCLUDE_PATH",
    "C_INCLUDE_PATH",
    "DEVICE_LIB_PATH",
)
_UNRECORDED_PREFIXES = ("HIP_", "HIPCC_")


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


def include_dirs(flags: Sequence[str]) -> list[Path]:
    """
    Where the compiler will look for headers.

    ROCm's include, then -I/-isystem/-iquote. The include-path environment
    variables are not searched, because the compile does not inherit them; see
    _UNRECORDED_VARIABLES.
    """
    dirs = [rocm_path() / "include"]
    tokens = iter(flags)
    for flag in tokens:
        for prefix in _INCLUDE_DIR_FLAGS:
            if flag == prefix:
                dirs.append(Path(next(tokens, "")))
            elif flag.startswith(prefix) and len(flag) > len(prefix):
                dirs.append(Path(flag[len(prefix):]))
            else:
                continue
            break
    return dirs


def missing_headers(case: inventory.Case, flags: Sequence[str]) -> list[str]:
    """The case's declared ``headers`` that no include directory provides."""
    dirs = include_dirs(flags)
    return [h for h in case.headers if not any((d / h).is_file() for d in dirs)]


# --- Toolchain ---------------------------------------------------------------
# Discovered, never pinned. Which toolchain produced a given .s is recorded in
# that file's .ident line rather than being constrained here.


def rocm_path() -> Path:
    """
    The ROCm SDK root, as an absolute path with symlinks resolved.

    Absolute because the compiler runs from a private scratch directory: a
    relative ROCM_PATH names the caller's directory, and would name nothing
    there. Resolved so that every name for one installation, such as a
    symlinked ROCM_PATH, selects the same root and reports the same build.
    """
    if (explicit := os.environ.get("ROCM_PATH")):
        return Path(explicit).expanduser().resolve()
    if shutil.which("rocm-sdk"):
        proc = subprocess.run(
            ["rocm-sdk", "path", "--root"], capture_output=True, text=True, check=False
        )
        if proc.returncode == 0 and proc.stdout.strip():
            return Path(proc.stdout.strip()).resolve()
    if Path("/opt/rocm").is_dir():
        return Path("/opt/rocm").resolve()
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


def _is_unrecorded(name: str) -> bool:
    return name in _UNRECORDED_VARIABLES or name.startswith(_UNRECORDED_PREFIXES)


def compiler_environment(root: Path) -> dict[str, str]:
    """
    This process's environment for a compile with the SDK at *root*: without the
    unrecorded variables, and with ROCM_PATH naming *root*.
    """
    environment = {k: v for k, v in os.environ.items() if not _is_unrecorded(k)}
    environment["ROCM_PATH"] = str(root)
    return environment


def ignored_environment() -> list[str]:
    """The unrecorded variables that are set, and that the compile will not see."""
    return sorted(name for name in os.environ if _is_unrecorded(name))


# --- Recipe ------------------------------------------------------------------


def compiler_version(tool: Path) -> str:
    """The ``clang version`` line *tool* reports, or its first line."""
    proc = subprocess.run(
        [str(tool), "--version"],
        capture_output=True,
        text=True,
        check=False,
        env=compiler_environment(rocm_path()),
    )
    lines = [line.strip() for line in proc.stdout.splitlines() if line.strip()]
    return next((line for line in lines if "clang version" in line), lines[0] if lines else "unknown")


def sdk_release(root: Path) -> str:
    """The release of the SDK at *root*, such as ``10.1.0``, from ``.info/version``."""
    version_file = root / ".info" / "version"
    if version_file.is_file() and (release := version_file.read_text().strip()):
        return release
    return recipe.UNKNOWN


def sdk_build(root: Path) -> str:
    """
    The build of the SDK at *root*, such as ``10.1.0a20260822``.

    A pip-installed SDK is the package directory *root* inside site-packages,
    and its build is the version of the distributions that installed files
    there. It is read from that installation itself, so it does not depend on
    PATH or on how *root* was named. When those distributions disagree, each is
    named, so a mixed installation is not recorded as one build. An SDK that was
    not installed this way, such as /opt/rocm, has an unknown build.
    """
    versions = {
        dist.metadata["Name"]: dist.version
        for dist in importlib.metadata.distributions(path=[str(root.parent)])
        if any(Path(file).parts[:1] == (root.name,) for file in dist.files or ())
    }
    if not versions:
        return recipe.UNKNOWN
    if len(set(versions.values())) == 1:
        return next(iter(versions.values()))
    return ", ".join(f"{name}=={version}" for name, version in sorted(versions.items()))


def current_recipe(cxxflags: Sequence[str]) -> recipe.Recipe:
    """The recipe a regeneration with *cxxflags*, as given, uses on this machine."""
    tool = find_hip_compiler()
    root = rocm_path()
    return recipe.Recipe(
        compiler=tool.name,
        compiler_version=compiler_version(tool),
        rocm_release=sdk_release(root),
        rocm_build=sdk_build(root),
        flags=(*_BASELINE_COMPILER_FLAGS, *cxxflags),
    )


def compare_recipes(target: str, current: recipe.Recipe) -> list[str]:
    """What changed between *target*'s committed recipe and *current*."""
    try:
        committed = recipe.load(ASM_DIR / target / recipe.FILE_NAME)
    except recipe.RecipeError as error:
        return [
            f"{target}: {recipe.FILE_NAME} cannot be compared: {problem}"
            for problem in error.problems
        ]
    if committed is None:
        return [f"{target}: no {recipe.FILE_NAME} committed, so the recipe cannot be compared"]
    return describe_change(target, committed, current)


def describe_change(target: str, committed: recipe.Recipe, current: recipe.Recipe) -> list[str]:
    """
    How *current* differs from *committed*: in the flags, which is a changed
    recipe, or in the toolchain. A build is compared only when both are known;
    an unknown one says the builds cannot be told apart, not that they differ.
    """
    if committed == current:
        return [f"{target}: recipe unchanged"]
    notes = []
    if committed.flags != current.flags:
        notes.append(
            f"{target}: recipe changed: flags {list(committed.flags)} -> {list(current.flags)}"
        )
    builds_known = recipe.UNKNOWN not in (committed.rocm_build, current.rocm_build)
    toolchain = [
        f"{field} {getattr(committed, field)!r} -> {getattr(current, field)!r}"
        for field in recipe.TOOLCHAIN_FIELDS
        if getattr(committed, field) != getattr(current, field)
        and (field != "rocm_build" or builds_known)
    ]
    if toolchain:
        notes.append(f"{target}: toolchain changed: {'; '.join(toolchain)}")
    if not builds_known and committed.rocm_build != current.rocm_build:
        notes.append(
            f"{target}: SDK build cannot be compared: "
            f"{committed.rocm_build!r} -> {current.rocm_build!r}"
        )
    return notes


# --- Compiling ---------------------------------------------------------------


def compile_device_asm(
    kernel: Path, target: str, out: Path, extra_flags: Sequence[str]
) -> None:
    """
    ``hipcc -S --cuda-device-only`` for one kernel, writing *out* on success.

    *out* is written only once the compile has succeeded, and then replaced
    atomically, so a failed or interrupted compile leaves any existing *out* as
    it was. The compiler runs in a private scratch directory, which is also its
    working directory: hipcc sometimes ignores ``-o`` under
    ``--cuda-device-only`` and writes an auto-named file into the working
    directory instead, and that file must neither land in nor be deleted from
    the caller's directory. *extra_flags* must not hold relative paths; see
    absolute_flags.
    """
    root = rocm_path()
    with tempfile.TemporaryDirectory(prefix="race-asm-compile-") as scratch_dir:
        scratch = Path(scratch_dir)
        compiled = scratch / f"{kernel.stem}.s"
        proc = subprocess.run(
            _compile_command(kernel=kernel, target=target, out=compiled, extra_flags=extra_flags),
            cwd=scratch,
            capture_output=True,
            text=True,
            check=False,
            env=compiler_environment(root),
        )
        if proc.returncode != 0:
            raise CompileError(f"{kernel.name} ({target}):\n{proc.stderr.strip()}")
        if not compiled.is_file():
            compiled = scratch / f"{kernel.stem}-hip-amdgcn-amd-amdhsa-{target}.s"
            if not compiled.is_file():
                raise CompileError(f"{kernel.name} ({target}): hipcc produced no output file")
        assembly = normalize(compiled.read_text())

    _replace(out, assembly)


def _compile_command(
    kernel: Path, target: str, out: Path, extra_flags: Sequence[str]
) -> list[str]:
    """The compiler's arguments: the baseline recipe, the target, then *extra_flags*."""
    root = rocm_path()
    argv = [
        str(find_hip_compiler()),
        f"--rocm-path={root}",
        *_BASELINE_COMPILER_FLAGS,
        "-S",
        "--cuda-device-only",
        f"--offload-arch={target}",
        str(kernel.resolve()),
        "-o",
        str(out),
    ]
    if (root / "include").is_dir():
        argv += ["-I", str(root / "include")]
    return argv + list(extra_flags)


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


def load_inventory() -> inventory.Inventory:
    """cases.toml, validated by the inventory module that check_cases.py also uses."""
    try:
        return inventory.load(CASES_PATH)
    except inventory.InventoryError as error:
        raise SystemExit("\n".join(error.problems)) from None


def targets_for(corpus: inventory.Inventory, requested: list[str]) -> list[str]:
    """The targets to regenerate: the ones requested, or every corpus target."""
    targets = corpus.targets
    for target in requested:
        if target not in targets:
            raise SystemExit(
                f"--target {target}: {target} is not in [corpus] targets in cases.toml; "
                f"add it there first"
            )
    return list(requested) or list(targets)


@dataclasses.dataclass(frozen=True)
class RegenerateResult:
    """
    What regenerate() did.

    Attributes:
        written: How many listings were written.
        failures: One message per case that failed to compile: the kernel and
            target, then the compiler's diagnostic.
        skipped: One message per case skipped because a declared header is not
            on the include path.
    """

    written: int
    failures: tuple[str, ...]
    skipped: tuple[str, ...]


def regenerate(
    corpus: inventory.Inventory,
    targets: Sequence[str],
    extra_flags: Sequence[str],
    out_root: Path,
) -> RegenerateResult:
    """
    Compile every case in *corpus* for every target into ``out_root/<target>``.

    A skipped or failed case writes nothing, so any existing listing of it
    under *out_root* is left as it was.
    """
    written = 0
    failures: list[str] = []
    skipped: list[str] = []
    for target in targets:
        for case in corpus.cases:
            if not case.builds_for(target):
                continue
            if (missing := missing_headers(case, extra_flags)):
                skipped.append(
                    f"{case.kernel} ({target}): {', '.join(missing)} not found; "
                    f"pass its include directory with --cxxflags"
                )
                continue
            try:
                compile_device_asm(
                    kernel=KERNELS_DIR / f"{case.kernel}.hip",
                    target=target,
                    out=out_root / target / f"{case.kernel}.s",
                    extra_flags=extra_flags,
                )
                written += 1
            except CompileError as error:
                failures.append(str(error))
    return RegenerateResult(written=written, failures=tuple(failures), skipped=tuple(skipped))


def main(argv: list[str]) -> int:
    args = _parse_args(argv)
    # Read once: regenerating and the --check verdict see the same inventory.
    corpus = load_inventory()
    cxxflags = parse_cxxflags(args.cxxflags)
    if (ignored := ignored_environment()):
        print(
            f"note: ignoring {', '.join(ignored)} for the compile; pass flags and "
            f"include directories with --cxxflags, so they are recorded in {recipe.FILE_NAME}",
            file=sys.stderr,
        )
    build = Build(
        corpus=corpus,
        targets=tuple(targets_for(corpus, args.target)),
        extra_flags=tuple(absolute_flags(cxxflags, Path.cwd())),
        recipe=current_recipe(cxxflags),
    )
    # Both modes compile into a scratch directory, removed however the run ends:
    # --check compares it with the committed assembly, and an update publishes a
    # target from it only once all of that target's cases have compiled.
    with tempfile.TemporaryDirectory(prefix="race-asm-") as scratch:
        return _regenerate_and_report(args, build, Path(scratch))


def _parse_args(argv: list[str]) -> argparse.Namespace:
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
    args = parser.parse_args(argv)
    if args.allow_skipped and not args.check:
        parser.error("--allow-skipped only applies with --check")
    return args


@dataclasses.dataclass(frozen=True)
class Build:
    """What one run regenerates, and how."""

    corpus: inventory.Inventory
    targets: tuple[str, ...]
    extra_flags: tuple[str, ...]
    recipe: recipe.Recipe


def _regenerate_and_report(args: argparse.Namespace, build: Build, out_root: Path) -> int:
    """Regenerate into *out_root* and report: a write summary, or the --check verdict."""
    print(f"regenerating {', '.join(build.targets)} -> {out_root}")
    # One target at a time, so an update can tell which targets are complete.
    results = {
        target: regenerate(
            corpus=build.corpus, targets=[target], extra_flags=build.extra_flags, out_root=out_root
        )
        for target in build.targets
    }
    failures = [failure for result in results.values() for failure in result.failures]
    skipped = [skip for result in results.values() for skip in result.skipped]
    _print_problems(failures=failures, skipped=skipped)
    if not args.check:
        return _install(build, scratch=out_root, results=results)
    if failures:
        print("\nfailed kernels' committed assembly is untouched", file=sys.stderr)
        return 2
    return _check_verdict(args, build, out_root=out_root, skipped=skipped)


def _print_problems(failures: Sequence[str], skipped: Sequence[str]) -> None:
    for skip in skipped:
        print(f"  skip: {skip}")
    for failure in failures:
        header, _, diagnostic = failure.partition("\n")
        print(f"  FAIL: {header}", file=sys.stderr)
        for line in diagnostic.splitlines():
            print(f"    {line}", file=sys.stderr)


def _check_verdict(
    args: argparse.Namespace, build: Build, out_root: Path, skipped: Sequence[str]
) -> int:
    """
    The --check verdict. It covers only what was compared: a check that skipped
    a case is incomplete unless skipping was allowed, and one that compared
    nothing cannot report a match either way.
    """
    print()
    for target in build.targets:
        for note in compare_recipes(target, build.recipe):
            print(note)
    expected = build.corpus.outputs(build.targets)
    not_generated = {(t, f) for t, f in expected if not (out_root / t / f).is_file()}
    if not expected or not_generated == expected or (skipped and not args.allow_skipped):
        _print_incomplete(targets=build.targets, skipped=skipped)
        return 3
    return _report_drift(
        targets=build.targets,
        out_root=out_root,
        expected=expected,
        not_compared=not_generated if skipped else set(),
    )


def _print_incomplete(targets: Sequence[str], skipped: Sequence[str]) -> None:
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


# --- Publishing ----------------------------------------------------------------


def _install(build: Build, scratch: Path, results: dict[str, RegenerateResult]) -> int:
    """
    Publish each complete target from *scratch* into ASM_DIR; see _publish_target.

    A target with a failed or skipped case is not published, so its committed
    listings and recipe stay exactly as they were, rather than mixing new
    listings with old ones under one recipe.
    """
    published = 0
    blocked = []
    for target, result in results.items():
        if result.failures or result.skipped:
            blocked.append(
                f"{target}: not updated: {len(result.failures)} case(s) failed and "
                f"{len(result.skipped)} skipped, and its recipe covers every listing"
            )
        elif result.written:
            published += _publish_target(target, built=scratch / target, build_recipe=build.recipe)
    _print_install_summary(published=published, blocked=blocked)
    if any(result.failures for result in results.values()):
        return 2
    return 3 if blocked else 0


def _publish_target(target: str, built: Path, build_recipe: recipe.Recipe) -> int:
    """
    Replace ``ASM_DIR/<target>`` with the listings in *built* and their recipe.

    The new target is staged beside the committed one, holding exactly the
    listings this run built and the recipe that built them, so a removed case
    leaves no listing behind. It then replaces the committed target by renames.
    A failure while staging leaves the committed target as it was. A failed
    swap moves the committed target back. A run killed between the two renames
    leaves a hidden staging or retired directory under ASM_DIR, which
    check_cases.py rejects as not a corpus target. Returns the listings published.
    """
    staging = ASM_DIR / f".{target}.staging-{os.getpid()}"
    staging.mkdir(parents=True)
    try:
        listings = sorted(built.glob("*.s"))
        for listing in listings:
            shutil.copyfile(listing, staging / listing.name)
        (staging / recipe.FILE_NAME).write_text(recipe.dumps(build_recipe))
        _swap_in(staging, ASM_DIR / target)
    finally:
        shutil.rmtree(staging, ignore_errors=True)
    return len(listings)


def _swap_in(staging: Path, live: Path) -> None:
    """Move *staging* to *live*, moving any existing *live* back if that fails."""
    retired = live.with_name(f".{live.name}.retired-{os.getpid()}")
    if live.exists():
        os.rename(live, retired)
    try:
        os.rename(staging, live)
    except BaseException:
        if retired.exists():
            os.rename(retired, live)
        raise
    shutil.rmtree(retired, ignore_errors=True)


def _print_install_summary(published: int, blocked: Sequence[str]) -> None:
    print(f"\nwrote {published} file(s) under {ASM_DIR.relative_to(CORPUS_ROOT.parent.parent)}")
    for note in blocked:
        print(note, file=sys.stderr)
    if published:
        print("Review the diff before committing: regenerating is a deliberate change to")
        print("the pinned assembly. Mutants are derived from it, so where waits or loads")
        print("moved, the mutants of those kernels change with them.")
    if blocked:
        print(
            "Make the skipped cases' headers available and regenerate those targets again.",
            file=sys.stderr,
        )


def _report_drift(
    targets: Sequence[str],
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
    sys.exit(main(sys.argv[1:]))
