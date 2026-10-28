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

Why the assembly is committed rather than compiled per run: the compiler places
most of a kernel's wait instructions (``s_waitcnt`` on gfx950, the per-counter
``s_wait_*`` instructions on gfx1250; a few are inline assembly in the kernel
source, between ``;;#ASMSTART`` and ``;;#ASMEND``), and the corpus derives its
mutants from them, and from marked loads: in global_byte_eviction, a byte load
the mutation harness rewrites as a store is followed by a ``; probe`` marker
block with no instruction in it. Which waits and loads become mutants is the
mutant generator's decision. Compiling at test time therefore lets a toolchain
bump silently reshape the corpus -- different mutants, different case IDs,
different results -- so two runs months apart are not comparing the same thing.
Freezing the assembly makes the set of injected defects fixed, and makes
regenerating it a deliberate, reviewable commit.

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
removed from the compile's environment; see ``_UNRECORDED_VARIABLES``. The
recipe does not capture the whole host: the compiler's own header search still
includes host directories, such as the host C++ standard library and
``/usr/include``, which are not recorded.

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
import enum
import importlib.metadata
import os
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
from collections.abc import Callable, Sequence, Set
from pathlib import Path

import inventory
import recipe

# The corpus layout, from inventory. Bound here so that a test can point a run
# at a scratch corpus.
CORPUS_ROOT = inventory.CORPUS_ROOT
CASES_PATH = inventory.CASES_PATH
KERNELS_DIR = inventory.KERNELS_DIR
ASM_DIR = inventory.ASM_DIR

# hipcc's per-translation-unit id, which is regenerated on every invocation.
# See the module docstring for why replacing it is safe. The word boundary keeps
# the placeholder, whose "c" is a hex digit, from matching, so normalizing twice
# changes nothing.
_CUID_RE = re.compile(r"__hip_cuid_[0-9a-f]+\b")
_CUID_PLACEHOLDER = "__hip_cuid_corpus"

# The line naming the compiler that produced a file. See the module docstring.
_IDENT_RE = re.compile(r"^\s*\.ident\s")

# The --cxxflags path contract. The compile runs in a scratch directory, so a
# relative path must be resolved against the caller's directory first. That is
# supported only for the include-directory options, which are made absolute,
# and -include, which must name a file in the caller's directory; see
# _forced_include. Each takes its value as a separate token or glued to it.
_INCLUDE_DIR_FLAGS = ("-I", "-iquote", "-isystem")
_FORCED_INCLUDE_FLAG = "-include"
# Those options, as the diagnostics and --help name them.
_RELATIVE_PATH_FLAGS_TEXT = (
    f"{', '.join(_INCLUDE_DIR_FLAGS)} and {_FORCED_INCLUDE_FLAG}"
)
# The other path-taking options the script recognizes. Each must be given an
# absolute path: resolved in the scratch directory, a relative one would name
# something else. A --option also takes its value after "=".
_ABSOLUTE_PATH_FLAGS = (
    "--include-directory",
    "--sysroot",
    "-idirafter",
    "-iframework",
    "-imacros",
    "-include-pch",
    "-iprefix",
    "-isysroot",
    "-isystem-after",
    "-ivfsoverlay",
    "-iwithprefix",
    "-iwithprefixbefore",
    "-iwithsysroot",
    "-resource-dir",
)
# The path-taking options clang spells with "=" as well as with a separate value:
# every --option, and -resource-dir.
_EQUALS_FLAGS = (
    *(flag for flag in _ABSOLUTE_PATH_FLAGS if flag.startswith("--")),
    "-resource-dir",
)
# Options that pass the next argument to a later stage unchanged. A path option
# forwarded this way is passed through as written, so its path must be
# absolute; see _forwarded_length.
_FORWARDING_FLAGS = ("-Xarch_device", "-Xarch_host", "-Xclang", "-Xpreprocessor")
# The other arguments --cxxflags accepts: options that cannot carry a path.
# Macros, optimization levels, warnings, the language standard, -save-temps,
# and the -f and -m switches in _REPRODUCIBLE_SWITCHES. Anything else, such as
# an alias of a path option, a response file (@file) or an input file, could
# name a path the script cannot see, and is rejected. So is -g: debug info
# embeds the scratch compile directory, so the listing would differ on every
# regeneration.
_PLAIN_OPTION = re.compile(
    r"-(?:[DU]\S+|O(?:[0-3sgz]|fast)?|W[\w-]+(?:=[\w-]+)?|std=[\w+]+|save-temps)"
)
# The -f and -m switches --cxxflags accepts: those that compile to the same
# listing in every scratch directory, so an immediate --check after an update
# matches. Other switches can embed per-invocation data, such as the scratch
# compile directory (-frecord-command-line, -fsave-optimization-record) or
# encoded metadata (-fprofile-generate, -fcoverage-mapping, -fgpu-rdc), and
# would be reported as drift, so they are rejected. A switch is added here
# only with a real-compiler regenerate-then-check test.
_REPRODUCIBLE_SWITCHES = frozenset(
    {
        "-ffast-math",
        "-fno-fast-math",
        "-finline",
        "-fno-inline",
        "-funroll-loops",
        "-fno-unroll-loops",
        "-fstrict-aliasing",
        "-fno-strict-aliasing",
        "-fgpu-approx-transcendentals",
        "-fno-gpu-approx-transcendentals",
        "-fgpu-flush-denormals-to-zero",
        "-fno-gpu-flush-denormals-to-zero",
        "-fhip-fp32-correctly-rounded-divide-sqrt",
        "-fno-hip-fp32-correctly-rounded-divide-sqrt",
        "-fno-gpu-rdc",
        "-mcumode",
        "-mno-cumode",
        "-mwavefrontsize64",
        "-mno-wavefrontsize64",
    }
)
# Prefixes of the other forwarding options, which the script does not follow,
# and -mllvm, whose backend options it does not interpret. They could carry a
# path it cannot see, so they are rejected.
_UNFOLLOWED_FORWARDING = ("-X", "-Wp,", "-Wa,", "-Wl,", "-mllvm")
# Every path-taking option the script recognizes, longest first, so that one is
# never read as a shorter one with a glued value: -include-pch is not -include.
_PATH_FLAGS = sorted(
    (*_INCLUDE_DIR_FLAGS, _FORCED_INCLUDE_FLAG, *_ABSOLUTE_PATH_FLAGS),
    key=len,
    reverse=True,
)

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

# Where ROCm installs by default: the SDK used when neither ROCM_PATH nor
# rocm-sdk selects one. See rocm_path.
_DEFAULT_ROCM_PATH = Path("/opt/rocm")


def split_provenance(assembly: str) -> tuple[list[str], list[str]]:
    """*assembly*'s lines, split into everything else and its ``.ident`` values."""
    lines = assembly.splitlines()
    return (
        [line for line in lines if not _IDENT_RE.match(line)],
        [
            line.strip().removeprefix(".ident").strip()
            for line in lines
            if _IDENT_RE.match(line)
        ],
    )


def normalize(assembly: str) -> str:
    """Strip the one part of hipcc's output that is not reproducible."""
    return _CUID_RE.sub(_CUID_PLACEHOLDER, assembly)


class CompileError(RuntimeError):
    """A kernel could not be compiled for the requested target."""


class SetupError(RuntimeError):
    """The inventory or the toolchain cannot be used, so nothing was compiled."""


class UsageError(ValueError):
    """A command-line argument is invalid; reported through ``parser.error``."""


class ExitCode(enum.IntEnum):
    """How a run ended; see ``--help`` and corpus/race/README.md."""

    SUCCESS = 0
    DRIFT = 1
    COMPILE_FAILED = 2
    INCOMPLETE = 3
    SETUP_FAILED = 4


def parse_cxxflags(text: str) -> list[str]:
    """
    Split ``--cxxflags`` into arguments the way a shell would, without running one.

    A quoted path with spaces, such as ``-I"my headers"``, stays one argument.
    Raises UsageError on malformed quoting, before any kernel is compiled.
    """
    try:
        return shlex.split(text)
    except ValueError as error:
        raise UsageError(
            f"--cxxflags: cannot parse {text!r}: {error} (check the quoting)"
        ) from error


def absolute_flags(flags: list[str], base: Path) -> list[str]:
    """
    *flags* with relative paths resolved against *base*, the caller's directory.

    This is the --cxxflags path contract. A relative ``-I``, ``-iquote`` or
    ``-isystem`` directory is made absolute. A relative ``-include`` must name a
    file in *base*, and becomes that absolute path; see _forced_include. Every
    other path-taking option in _ABSOLUTE_PATH_FLAGS must be given an absolute
    path. Two kinds of argument are kept as written: a value starting with "=",
    which clang reads as relative to the sysroot (``-I=/usr/include``), and an
    argument forwarded with an option in _FORWARDING_FLAGS, which is checked
    like a top-level argument and whose path must be absolute; see
    _forwarded_length. Path options are recognized only by their
    complete spelling; see _split_joined. Any other argument must be a plain
    option that cannot carry a path; see _check_plain_option. Raises UsageError for
    anything the contract does not support, such as an alias of a path option, a
    response file or an input file.
    """
    return _rewrite_path_values(
        flags, rewrite=lambda name, value: _resolved_path(name, value, base=base)
    )


def _resolved_path(name: str, value: str, base: Path) -> str:
    """
    The path option *name* gets for *value*, given relative to *base*. An
    absolute path is kept, and so is one clang reads as relative to the sysroot,
    which starts with "=".
    """
    if Path(value).is_absolute() or (
        value.startswith("=") and name != _FORCED_INCLUDE_FLAG
    ):
        return value
    if name in _INCLUDE_DIR_FLAGS:
        return str(base / value)
    if name == _FORCED_INCLUDE_FLAG:
        return _forced_include(value, base)
    raise UsageError(
        f"{name} {value}: relative paths are supported only for "
        f"{_RELATIVE_PATH_FLAGS_TEXT}; give an absolute path"
    )


def _forced_include(value: str, base: Path) -> str:
    """
    The file a relative ``-include`` names, for a compile run from a scratch
    directory.

    The compiler looks for it in its working directory first, and then applies
    header-search rules this script does not reproduce. So it must name a file
    in *base*, the caller's directory, where the compiler would look first, and
    becomes that absolute path. Raises UsageError otherwise, since the compiler
    might select a different file.
    """
    if (base / value).is_file():
        return str(base / value)
    raise UsageError(
        f"-include {value}: not found in {base}; give its path from this directory, "
        f"such as -include include/{Path(value).name}, or an absolute path"
    )


def _rewrite_path_values(
    flags: Sequence[str], rewrite: Callable[[str, str], str]
) -> list[str]:
    """
    *flags* with the value of each path-taking option, separate, glued or after
    "=", replaced by ``rewrite(option, value)``. Arguments forwarded to a later
    stage are kept as written; see _forwarded_length.
    """
    out: list[str] = []
    i = 0
    while i < len(flags):
        flag = flags[i]
        name = _path_flag_name(flag)
        if flag not in _FORWARDING_FLAGS and flag.startswith(_UNFOLLOWED_FORWARDING):
            raise _unsupported(flag)
        if flag in _FORWARDING_FLAGS and i + 1 < len(flags):
            length = _forwarded_length(flags, start=i, rewrite=rewrite)
            out += flags[i : i + length]
            i += length
        elif name is None:
            _check_plain_option(flag)
            out.append(flag)
            i += 1
        elif flag == name and i + 1 == len(flags):
            out.append(flag)
            i += 1
        elif flag == name:
            out += [flag, rewrite(name, flags[i + 1])]
            i += 2
        else:
            separator, value = _split_joined(flag, name)
            out.append(name + separator + rewrite(name, value))
            i += 1
    return out


def _forwarded_length(
    flags: Sequence[str], start: int, rewrite: Callable[[str, str], str]
) -> int:
    """
    How many arguments the forwarding option at *start* covers: it and the
    argument it forwards, or, for a forwarded path option with a separate value
    (``-Xclang -iquote -Xclang /path``), both pairs. A forwarded argument is
    passed through unchanged and checked as a top-level one is: a path must be
    absolute, or relative to the sysroot, and anything else must be a plain
    option (see _check_plain_option), not an alias, a response file, an input file or
    another forwarding option. Raises UsageError otherwise. *rewrite* still sees
    a forwarded path, unchanged.
    """
    forwarding, argument = flags[start], flags[start + 1]
    name = _path_flag_name(argument)
    if name is None:
        if argument.startswith(_UNFOLLOWED_FORWARDING):
            raise _unsupported(argument)
        _check_plain_option(argument)
        return 2
    length, value = 2, None
    if argument != name:
        value = _split_joined(argument, name)[1]
    elif start + 3 < len(flags) and flags[start + 2] == forwarding:
        length, value = 4, flags[start + 3]
    if value is not None:
        if not (Path(value).is_absolute() or value.startswith("=")):
            raise UsageError(
                f"{forwarding} {name} {value}: a path forwarded with {forwarding} "
                f"is passed through unchanged, so give an absolute path"
            )
        rewrite(name, value)
    return length


def _path_flag_name(flag: str) -> str | None:
    """The path-taking option *flag* starts with, or None."""
    return next((name for name in _PATH_FLAGS if flag.startswith(name)), None)


def _split_joined(flag: str, name: str) -> tuple[str, str]:
    """
    The separator and value of *flag*, which starts with option *name* and joins
    its value to it. Only complete spellings are accepted: "=" for an option in
    _EQUALS_FLAGS, a glued value for the options that support relative paths,
    and a glued absolute path for the others. Anything else may be a different
    option that only starts the same way, so it raises UsageError rather than
    being read as a path.
    """
    rest = flag[len(name) :]
    if name in _EQUALS_FLAGS:
        if rest.startswith("="):
            return "=", rest[1:]
    elif name in (*_INCLUDE_DIR_FLAGS, _FORCED_INCLUDE_FLAG) or (
        Path(rest).is_absolute() or rest.startswith("=")
    ):
        return "", rest
    raise _unsupported(flag)


def _check_plain_option(argument: str) -> None:
    """
    Raise UsageError unless *argument* is an option that cannot carry a path:
    one _PLAIN_OPTION matches, or a switch in _REPRODUCIBLE_SWITCHES. Any other
    -f or -m switch is named as one that may not compile reproducibly.
    """
    if argument in _REPRODUCIBLE_SWITCHES or _PLAIN_OPTION.fullmatch(argument):
        return
    if argument.startswith(("-f", "-m")):
        raise UsageError(
            f"{argument}: not one of the -f and -m switches known to compile "
            f"reproducibly in --cxxflags; see --cxxflags in --help"
        )
    raise _unsupported(argument)


def _unsupported(argument: str) -> UsageError:
    return UsageError(
        f"{argument}: not an option or spelling this script supports in --cxxflags; "
        f"see --cxxflags in --help"
    )


def _path_values(flags: Sequence[str]) -> list[tuple[str, str]]:
    """Each path option in *flags* and its value, in order."""
    values: list[tuple[str, str]] = []

    def record(name: str, value: str) -> str:
        values.append((name, value))
        return value

    _rewrite_path_values(flags, rewrite=record)
    return values


def _header_sysroot(values: Sequence[tuple[str, str]]) -> str | None:
    """
    The sysroot an include directory starting with "=" is relative to: the last
    -isysroot, else the last --sysroot, as the compiler resolves it. None when
    neither is given, and the compiler keeps the "=" path as written.
    """
    for name in ("-isysroot", "--sysroot"):
        given = [value for option, value in values if option == name]
        if given:
            return given[-1]
    return None


def _search_dirs(flags: Sequence[str]) -> list[Path]:
    """
    The include directories in *flags*, for checking that a declared header
    exists, with a sysroot-relative one (``-I=/dir``) resolved under the
    sysroot. Which copy the compiler selects is left to the compiler.
    """
    values = _path_values(flags)
    sysroot = _header_sysroot(values)
    dirs: list[Path] = []
    for name, value in values:
        if name not in _INCLUDE_DIR_FLAGS:
            continue
        if value.startswith("=") and sysroot is not None:
            dirs.append(Path(sysroot) / value[1:].lstrip("/"))
        else:
            dirs.append(Path(value))
    return dirs


def include_dirs(flags: Sequence[str], root: Path) -> list[Path]:
    """
    The directories checked for a declared header's existence, with the SDK at
    *root*: the SDK's include directory, and the directory of each option in
    _INCLUDE_DIR_FLAGS, with sysroot-relative ones resolved; see _search_dirs.

    This is an existence check only. It implies no search order: which copy of
    a header the compiler selects is left to the compiler. The include-path
    environment variables are not checked, because the compile does not inherit
    them; see _UNRECORDED_VARIABLES.
    """
    return [root / "include", *_search_dirs(flags)]


def missing_headers(
    case: inventory.Case, flags: Sequence[str], root: Path
) -> list[str]:
    """The case's declared ``headers`` that no include directory provides."""
    dirs = include_dirs(flags, root)
    return [h for h in case.headers if not any((d / h).is_file() for d in dirs)]


# --- Toolchain ---------------------------------------------------------------
# The SDK is selected from ROCM_PATH, rocm-sdk or _DEFAULT_ROCM_PATH, and its own
# compiler is found within it; see select_toolchain. The compiler, its version,
# the SDK's release and build, and the explicit flags are recorded in each
# target's recipe.toml, and the compiler's .ident line names it in each listing.


def rocm_path() -> Path:
    """
    The ROCm SDK root, as an absolute path with symlinks resolved.

    Absolute because the compiler runs from a private scratch directory: a
    relative ROCM_PATH names the caller's directory, and would name nothing
    there. Resolved so that every name for one installation, such as a
    symlinked ROCM_PATH, selects the same root and reports the same build.
    """
    if explicit := os.environ.get("ROCM_PATH"):
        root = Path(explicit).expanduser().resolve()
        if not root.is_dir():
            raise SetupError(f"ROCM_PATH {explicit} is not a directory")
        return root
    if shutil.which("rocm-sdk"):
        return _rocm_sdk_root()
    if _DEFAULT_ROCM_PATH.is_dir():
        return _DEFAULT_ROCM_PATH.resolve()
    raise SetupError("no ROCm SDK: set ROCM_PATH, or make rocm-sdk available on PATH")


def _rocm_sdk_root() -> Path:
    """The SDK root ``rocm-sdk path --root`` reports. Raises SetupError if it fails."""
    try:
        output = subprocess.check_output(
            ["rocm-sdk", "path", "--root"], stderr=subprocess.STDOUT, text=True
        )
    except subprocess.CalledProcessError as error:
        raise SetupError(
            f"rocm-sdk path --root failed ({error.returncode}): {error.output.strip()}; "
            f"set ROCM_PATH to choose an SDK"
        ) from error
    if not output.strip():
        raise SetupError(
            "rocm-sdk path --root printed no path; set ROCM_PATH to choose an SDK"
        )
    return Path(output.strip()).resolve()


def find_hip_compiler(root: Path) -> Path:
    """
    The HIP compiler of the SDK at *root*, as an absolute path: its
    ``bin/hipcc``, else its ``llvm/bin/clang++``. Raises SetupError if it has
    neither.

    Only the selected SDK is searched, never PATH: the recipe records what this
    compiler reports for ``--version``, and the compile runs against the
    selected SDK, so both must be the SDK's own compiler. Absolute for the same
    reason as rocm_path: it is run from the scratch directory.
    """
    for candidate in (root / "bin" / "hipcc", root / "llvm" / "bin" / "clang++"):
        if candidate.is_file():
            return candidate
    raise SetupError(
        f"no HIP compiler in the selected SDK {root}: neither bin/hipcc nor "
        f"llvm/bin/clang++ exists; set ROCM_PATH to a ROCm install that has one"
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


@dataclasses.dataclass(frozen=True)
class Toolchain:
    """
    The SDK a run uses, and its compiler, resolved once so that the recipe and
    every compile use the same ones.

    Attributes:
        root: The SDK root; see rocm_path.
        compiler: The SDK's HIP compiler; see find_hip_compiler.
    """

    root: Path
    compiler: Path


def select_toolchain() -> Toolchain:
    """The selected SDK and its compiler. Raises SetupError if either is missing."""
    root = rocm_path()
    return Toolchain(root=root, compiler=find_hip_compiler(root))


# --- Recipe ------------------------------------------------------------------


def compiler_version(toolchain: Toolchain) -> str:
    """
    The ``clang version`` line the toolchain's compiler reports, or its first
    line. Raises SetupError if it cannot report a version.
    """
    tool = toolchain.compiler
    try:
        output = subprocess.check_output(
            [str(tool), "--version"],
            stderr=subprocess.STDOUT,
            text=True,
            env=compiler_environment(toolchain.root),
        )
    except subprocess.CalledProcessError as error:
        raise SetupError(
            f"{tool} --version failed ({error.returncode}): {error.output.strip()}"
        ) from error
    lines = [line.strip() for line in output.splitlines() if line.strip()]
    if not lines:
        raise SetupError(f"{tool} --version printed nothing")
    return next((line for line in lines if "clang version" in line), lines[0])


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


def current_recipe(toolchain: Toolchain, extra_flags: Sequence[str]) -> recipe.Recipe:
    """
    The recipe a regeneration with *toolchain* and *extra_flags* uses.
    *extra_flags* are the flags as the compiler receives them; see absolute_flags.
    """
    return recipe.Recipe(
        compiler=toolchain.compiler.name,
        compiler_version=compiler_version(toolchain),
        rocm_release=sdk_release(toolchain.root),
        rocm_build=sdk_build(toolchain.root),
        flags=(*_BASELINE_COMPILER_FLAGS, *extra_flags),
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
        return [
            f"{target}: no {recipe.FILE_NAME} committed, so the recipe cannot be compared"
        ]
    return describe_change(target=target, committed=committed, current=current)


def describe_change(
    target: str, committed: recipe.Recipe, current: recipe.Recipe
) -> list[str]:
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
    kernel: Path,
    target: str,
    out: Path,
    extra_flags: Sequence[str],
    toolchain: Toolchain,
) -> None:
    """
    ``hipcc -S --cuda-device-only`` for one kernel, writing *out* on success.

    *out* is written only once the compile has succeeded, and then replaced
    atomically, so a failed or interrupted compile leaves any existing *out* as
    it was. The compiler writes its listing to ``-o`` in a private scratch
    directory, which is also its working directory: anything else it writes
    there, such as the ``.hipi`` and ``.bc`` intermediates of
    ``--cxxflags=-save-temps``, is discarded with it and never reaches the
    caller's directory. *extra_flags* must not hold relative paths; see
    absolute_flags.
    """
    with tempfile.TemporaryDirectory(prefix="race-asm-compile-") as scratch_dir:
        scratch = Path(scratch_dir)
        compiled = scratch / f"{kernel.stem}.s"
        try:
            subprocess.run(
                _compile_command(
                    kernel=kernel,
                    target=target,
                    out=compiled,
                    extra_flags=extra_flags,
                    toolchain=toolchain,
                ),
                cwd=scratch,
                capture_output=True,
                text=True,
                check=True,
                env=compiler_environment(toolchain.root),
            )
        except subprocess.CalledProcessError as error:
            raise CompileError(
                f"{kernel.name} ({target}):\n{error.stderr.strip()}"
            ) from error
        if not compiled.is_file():
            raise CompileError(
                f"{kernel.name} ({target}): the compiler wrote no listing"
            )
        assembly = normalize(compiled.read_text())

    _replace(out, assembly)


def _compile_command(
    kernel: Path,
    target: str,
    out: Path,
    extra_flags: Sequence[str],
    toolchain: Toolchain,
) -> list[str]:
    """The compiler's arguments: the baseline recipe, the target, then *extra_flags*."""
    root = toolchain.root
    argv = [
        str(toolchain.compiler),
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
    """
    cases.toml, validated by the inventory module that check_cases.py also uses.
    Raises SetupError naming every problem.
    """
    try:
        return inventory.load(CASES_PATH)
    except inventory.InventoryError as error:
        raise SetupError("\n".join(error.problems)) from error


def targets_for(corpus: inventory.Inventory, requested: list[str]) -> list[str]:
    """
    The targets to regenerate: the ones requested, or every corpus target.
    Raises UsageError for a requested target that is not a corpus target.
    """
    targets = corpus.targets
    for target in requested:
        if target not in targets:
            raise UsageError(
                f"--target {target}: {target} is not in [corpus] targets in cases.toml; "
                f"add it there first"
            )
    return list(requested) or list(targets)


@dataclasses.dataclass(frozen=True)
class RegenerateResult:
    """
    What regenerate() could not do. Every other case's listing was written.

    Attributes:
        failures: One message per case that failed to compile: the kernel and
            target, then the compiler's diagnostic.
        skipped: One message per case skipped because a declared header is not
            on the include path.
    """

    failures: tuple[str, ...]
    skipped: tuple[str, ...]


def regenerate(
    corpus: inventory.Inventory,
    targets: Sequence[str],
    extra_flags: Sequence[str],
    out_root: Path,
    toolchain: Toolchain,
) -> RegenerateResult:
    """
    Compile every case in *corpus* for every target into ``out_root/<target>``.

    A skipped or failed case writes nothing, so any existing listing of it
    under *out_root* is left as it was.
    """
    failures: list[str] = []
    skipped: list[str] = []
    for target in targets:
        for case in corpus.cases:
            if not case.builds_for(target):
                continue
            if missing := missing_headers(case, extra_flags, toolchain.root):
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
                    toolchain=toolchain,
                )
            except CompileError as error:
                failures.append(str(error))
    return RegenerateResult(failures=tuple(failures), skipped=tuple(skipped))


@dataclasses.dataclass(frozen=True)
class Build:
    """What one run regenerates, and how."""

    corpus: inventory.Inventory
    targets: tuple[str, ...]
    extra_flags: tuple[str, ...]
    toolchain: Toolchain
    recipe: recipe.Recipe


def main(argv: list[str]) -> ExitCode:
    parser = _build_parser()
    args = parser.parse_args(argv)
    if args.allow_skipped and not args.check:
        parser.error("--allow-skipped only applies with --check")
    try:
        build = _plan_build(args)
        # Both modes compile into a scratch directory, removed however the run
        # ends: --check compares it with the committed assembly, and an update
        # publishes a target from it only once all of its cases have compiled.
        with tempfile.TemporaryDirectory(prefix="race-asm-") as scratch:
            return _regenerate_and_report(args, build, Path(scratch))
    except UsageError as error:
        parser.error(str(error))
    except SetupError as error:
        print(f"error: {error}", file=sys.stderr)
        return ExitCode.SETUP_FAILED


def _plan_build(args: argparse.Namespace) -> Build:
    """
    What this run builds, and how. Reads the inventory once, so regenerating and
    the --check verdict see the same one. Raises UsageError or SetupError.
    """
    corpus = load_inventory()
    cxxflags = parse_cxxflags(args.cxxflags)
    targets = targets_for(corpus, args.target)
    if ignored := ignored_environment():
        print(
            f"note: ignoring {', '.join(ignored)} for the compile; pass flags and "
            f"include directories with --cxxflags, so they are recorded in {recipe.FILE_NAME}",
            file=sys.stderr,
        )
    # The recipe records the flags as the compiler receives them, so a relative
    # path that selects a different file from another directory changes it.
    extra_flags = tuple(absolute_flags(cxxflags, Path.cwd()))
    toolchain = select_toolchain()
    build_recipe = current_recipe(toolchain=toolchain, extra_flags=extra_flags)
    try:
        # Checked before anything is compiled: the recipe is written at publish.
        recipe.dumps(build_recipe)
    except ValueError as error:
        raise UsageError(
            f"--cxxflags cannot be recorded in recipe.toml: {error}"
        ) from error
    return Build(
        corpus=corpus,
        targets=tuple(targets),
        extra_flags=extra_flags,
        toolchain=toolchain,
        recipe=build_recipe,
    )


_DESCRIPTION = (
    "Regenerate the committed device assembly under corpus/race/asm/ from the kernels "
    "in cases.toml, or check it for drift with --check."
)
_TARGET_HELP = (
    "gfx target to regenerate; repeat for several. Default: every target in "
    "[corpus] targets in cases.toml."
)
# The exceptions to the --cxxflags path contract, for --help.
_PATH_EXCEPTIONS_HELP = (
    'A value starting with "=", which clang reads as relative to the sysroot, '
    "such as -I=/usr/include, is kept as written. Arguments are forwarded only "
    f"with {', '.join(_FORWARDING_FLAGS)}; they are kept as written and checked "
    "like top-level arguments, and a path forwarded that way must be absolute."
)
_CXXFLAGS_HELP = (
    "Extra compiler flags, split like shell words, so a path with spaces can be "
    "quoted, e.g. --cxxflags='-I\"/path/to/my headers\"'. Relative paths are "
    f"supported only for {_RELATIVE_PATH_FLAGS_TEXT}, taken from the directory "
    f"the script runs in, and a relative {_FORCED_INCLUDE_FLAG} must name a file "
    "in this directory, such as -include include/options.h. Other path-taking "
    f"options need absolute paths. {_PATH_EXCEPTIONS_HELP} Other options are "
    "accepted only if they cannot carry a path: -D and -U macros, -O levels, "
    "-W warnings, -std=, -save-temps, and these -f and -m switches, which "
    f"compile reproducibly: {', '.join(sorted(_REPRODUCIBLE_SWITCHES))}. "
    "Anything else, such as an alias of a path option, a response file (@file), "
    "an input file, -g or another -f or -m switch, which could embed the scratch "
    "directory or other per-invocation data, is rejected (exit 2). Default: none."
)
_CHECK_HELP = (
    "Do not write. Regenerate into a temporary directory and compare it with the "
    "committed assembly as text, after replacing hipcc's per-invocation __hip_cuid "
    "hash. A file that differs only in its .ident line came from another compiler "
    "that emitted the same text, and is reported without failing. Any other "
    "difference, in an instruction, a directive or metadata, is drift and fails the "
    "check, as does an expected file that is missing or a committed file no selected "
    "case builds."
)
_ALLOW_SKIPPED_HELP = (
    "With --check, pass when every case that could be compared matches, even if some "
    "were skipped because an optional header is unavailable. The skipped cases are "
    "still listed as not compared. Without this, a skipped case makes the check "
    "incomplete (exit 3)."
)
_EXIT_CODES_EPILOG = (
    "Exits 0 on success, 1 when --check finds drift, 2 when a case fails to compile "
    "or an argument is invalid, 3 when a case was skipped (with --check, see "
    "--allow-skipped) or nothing was compared, and 4 when the inventory or the "
    "toolchain cannot be used. The workflow, layout and checks are described in "
    "corpus/race/README.md."
)


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=_DESCRIPTION, epilog=_EXIT_CODES_EPILOG
    )
    parser.add_argument("--target", action="append", default=[], help=_TARGET_HELP)
    parser.add_argument("--cxxflags", default="", help=_CXXFLAGS_HELP)
    parser.add_argument(
        "--check",
        action=argparse.BooleanOptionalAction,
        default=False,
        help=_CHECK_HELP,
    )
    parser.add_argument(
        "--allow-skipped",
        action=argparse.BooleanOptionalAction,
        default=False,
        help=_ALLOW_SKIPPED_HELP,
    )
    return parser


def _regenerate_and_report(
    args: argparse.Namespace, build: Build, out_root: Path
) -> ExitCode:
    """Regenerate into *out_root* and report: a write summary, or the --check verdict."""
    print(f"regenerating {', '.join(build.targets)} -> {out_root}")
    # One target at a time, so an update can tell which targets are complete.
    results = {
        target: regenerate(
            corpus=build.corpus,
            targets=[target],
            extra_flags=build.extra_flags,
            out_root=out_root,
            toolchain=build.toolchain,
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
        return ExitCode.COMPILE_FAILED
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
) -> ExitCode:
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
    if (
        not expected
        or not_generated == expected
        or (skipped and not args.allow_skipped)
    ):
        _print_incomplete(targets=build.targets, skipped=skipped)
        return ExitCode.INCOMPLETE
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
        print(
            "Make the skipped cases' headers available and check again,",
            file=sys.stderr,
        )
        print("or pass --allow-skipped to check only the rest.", file=sys.stderr)


# --- Publishing ----------------------------------------------------------------


def _install(
    build: Build, scratch: Path, results: dict[str, RegenerateResult]
) -> ExitCode:
    """
    Publish each complete target from *scratch* into ASM_DIR; see _publish_target.

    Every target whose cases all compiled is published, including one that no
    case builds for any more, which is published with no listings so that its
    old ones go. A target with a failed or skipped case is not published, so its
    committed listings and recipe stay exactly as they were, rather than mixing
    new listings with old ones under one recipe.
    """
    published = 0
    blocked = []
    for target, result in results.items():
        if result.failures or result.skipped:
            blocked.append(
                f"{target}: not updated: {len(result.failures)} case(s) failed and "
                f"{len(result.skipped)} skipped, and its recipe covers every listing"
            )
        else:
            published += _publish_target(
                target, built=scratch / target, build_recipe=build.recipe
            )
    _print_install_summary(
        published=published, targets=len(results) - len(blocked), blocked=blocked
    )
    if any(result.failures for result in results.values()):
        return ExitCode.COMPILE_FAILED
    return ExitCode.INCOMPLETE if blocked else ExitCode.SUCCESS


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
        (staging / recipe.FILE_NAME).write_text(
            recipe.dumps(build_recipe), encoding="utf-8"
        )
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


def _print_install_summary(
    published: int, targets: int, blocked: Sequence[str]
) -> None:
    where = ASM_DIR.relative_to(CORPUS_ROOT.parent.parent)
    print(f"\nwrote {published} file(s) for {targets} target(s) under {where}")
    for note in blocked:
        print(note, file=sys.stderr)
    if targets:
        print(
            "Review the diff before committing: regenerating is a deliberate change to"
        )
        print(
            "the pinned assembly. Mutants are derived from it, so where waits or loads"
        )
        print("moved, the mutants of those kernels change with them.")
    if blocked:
        print(
            "Make the skipped cases' headers available and regenerate those targets again.",
            file=sys.stderr,
        )


# --- Comparing (--check) ----------------------------------------------------


@dataclasses.dataclass(frozen=True)
class FileComparison:
    """
    How one fresh listing compares with the committed one.

    Attributes:
        drift: Why the file is drift, or None.
        ident_change: The committed and the fresh ``.ident``, when they are the
            only difference, or None.
    """

    drift: str | None = None
    ident_change: tuple[str, str] | None = None


def _report_drift(
    targets: Sequence[str],
    out_root: Path,
    expected: Set[tuple[str, str]],
    not_compared: Set[tuple[str, str]] = frozenset(),
) -> ExitCode:
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
        for file in _files_to_compare(target, out_root=out_root, expected=expected):
            comparison = _compare_file(
                target=target,
                file=file,
                out_root=out_root,
                expected=expected,
                not_compared=not_compared,
            )
            if comparison.drift is not None:
                drifted.append(comparison.drift)
            elif comparison.ident_change is not None:
                provenance.setdefault(comparison.ident_change, []).append(
                    f"{target}/{file}"
                )
    _print_provenance(provenance)
    _print_not_compared(not_compared)
    if not drifted:
        suffix = ", apart from .ident" if provenance else ""
        scope = " for the compared cases" if not_compared else ""
        print(f"\ncommitted assembly matches this toolchain{scope}{suffix}")
        return ExitCode.SUCCESS
    _print_drift(drifted)
    return ExitCode.DRIFT


def _files_to_compare(
    target: str, out_root: Path, expected: Set[tuple[str, str]]
) -> list[str]:
    """Every listing *target* should have, was generated with, or has committed."""
    names = {file for expected_target, file in expected if expected_target == target}
    for directory in (out_root / target, ASM_DIR / target):
        if directory.is_dir():
            names |= {path.name for path in directory.glob("*.s")}
    return sorted(names)


def _compare_file(
    target: str,
    file: str,
    out_root: Path,
    expected: Set[tuple[str, str]],
    not_compared: Set[tuple[str, str]],
) -> FileComparison:
    name = f"{target}/{file}"
    fresh, committed = out_root / target / file, ASM_DIR / target / file
    if (target, file) not in expected:
        where = "committed" if committed.is_file() else "generated"
        return FileComparison(drift=f"{name}: {where}, but no selected case builds it")
    if (target, file) in not_compared:
        return FileComparison()
    if not fresh.is_file():
        state = "committed" if committed.is_file() else "not committed"
        return FileComparison(drift=f"{name}: not generated and {state}")
    if not committed.is_file():
        return FileComparison(drift=f"{name}: not committed")
    return _compare_listings(name, fresh=fresh, committed=committed)


def _compare_listings(name: str, fresh: Path, committed: Path) -> FileComparison:
    """Compare two listings of one case, with their ``.ident`` lines apart."""
    fresh_body, fresh_ident = split_provenance(fresh.read_text())
    committed_body, committed_ident = split_provenance(committed.read_text())
    if fresh_body != committed_body:
        changed = sum(
            1
            for line in difflib.unified_diff(
                committed_body, fresh_body, lineterm="", n=0
            )
            if line[:1] in "+-" and not line.startswith(("+++", "---"))
        )
        return FileComparison(drift=f"{name}: {changed} line(s) added or removed")
    if fresh_ident != committed_ident:
        was = " ".join(committed_ident) or "(none)"
        now = " ".join(fresh_ident) or "(none)"
        return FileComparison(ident_change=(was, now))
    return FileComparison()


def _print_provenance(provenance: dict[tuple[str, str], list[str]]) -> None:
    for (was, now), names in provenance.items():
        print(f"\n{len(names)} file(s) differ only in the compiler that produced them:")
        print(f"  committed:      {was}")
        print(f"  this toolchain: {now}")
        for name in names:
            print(f"    {name}")
        print("Every other line is identical, so this is not drift; regenerating would")
        print("only update their .ident lines.")


def _print_not_compared(not_compared: Set[tuple[str, str]]) -> None:
    if not not_compared:
        return
    print(f"\n{len(not_compared)} case(s) skipped and not compared (--allow-skipped):")
    for target, file in sorted(not_compared):
        print(f"  not compared: {Path(file).stem} ({target})")


def _print_drift(drifted: Sequence[str]) -> None:
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


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
