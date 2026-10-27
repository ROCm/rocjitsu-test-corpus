# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
import dataclasses
import errno
import json
import os
import re
import subprocess
import sys
import tomllib
import typing
from collections.abc import Callable
from pathlib import Path

import pytest

from support.race_corpus import corpus_table, load_script
from test_recipe import BAD_RECIPES, GOOD, GOOD_TEXT

regen = load_script("regenerate_asm")
SELECT_TOOLCHAIN = regen.select_toolchain

# A case that needs the rocWMMA headers, as inventory.load returns it.
ROCWMMA_RECORD = regen.inventory.Case(
    id="k", kernel="kernel", targets=(), headers=("rocwmma/rocwmma.hpp",)
)
ROCWMMA_INVENTORY = regen.inventory.Inventory(
    targets=("gfx950",), cases=(ROCWMMA_RECORD,)
)

# The fixtures that build and run a scratch corpus: see manifest and corpus_main.
Manifest = Callable[[list[str] | None, str], None]
CorpusMain = tuple[Callable[..., regen.ExitCode], Path]

PINNED = "; pinned assembly that must survive a failed regeneration\n"


# The variables that must not reach the compile: none of them is recorded in
# recipe.toml, and each changes what is built.
UNRECORDED_VARIABLES = (
    "HIPCC_COMPILE_FLAGS_APPEND",
    "HIPCC_LINK_FLAGS_APPEND",
    "CCC_OVERRIDE_OPTIONS",
    "CPATH",
    "CPLUS_INCLUDE_PATH",
    "C_INCLUDE_PATH",
    "HIP_PATH",
    "HIP_CLANG_PATH",
    "DEVICE_LIB_PATH",
)

# The variables the fake compiler records from its environment.
WATCHED_ENVIRONMENT = (*UNRECORDED_VARIABLES, "ROCM_PATH", "RACE_UNRELATED")


# The fake compiler's code, after the lines write_fake_compiler puts in front of
# it: its interpreter, BEHAVIOUR, and WATCHED (the variables it records).
FAKE_COMPILER_BODY = r"""
import json
import os
import sys
from pathlib import Path

args = sys.argv[1:]
if args == ["--version"]:
    print(os.environ.get("FAKE_COMPILER_VERSION", "fake clang version 1.0"))
    sys.exit(0)
script = Path(__file__).absolute()
with script.with_name(script.name + ".argv").open("a") as log:
    log.write(json.dumps(args) + "\n")
with script.with_name(script.name + ".env").open("a") as log:
    log.write(json.dumps({name: os.environ.get(name) for name in WATCHED}) + "\n")
source = Path(next((arg for arg in args if arg.endswith(".hip")), ""))
failing = os.environ.get("FAKE_COMPILER_FAIL")
if BEHAVIOUR == "fail" or (failing and source.name == failing + ".hip"):
    sys.stderr.write("error: unknown argument\n")
    sys.exit(1)
text = "kernel:\n\ts_endpgm\n.globl __hip_cuid_0123abcd\n"
if BEHAVIOUR == "silent":
    sys.exit(0)
Path(args[args.index("-o") + 1]).write_text(text)
if BEHAVIOUR == "save-temps":
    arch = next(arg for arg in args if arg.startswith("--offload-arch=")).split("=", 1)[1]
    for suffix in (".hipi", ".tmp.bc"):
        Path(f"{source.stem}-hip-amdgcn-amd-amdhsa-{arch}{suffix}").write_text("")
"""


def write_script(path: Path, body: str) -> Path:
    """An executable Python script at *path* that runs *body*: a fake tool."""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(f"#!{sys.executable}\n{body}")
    path.chmod(0o755)
    return path


def write_header(path: Path) -> Path:
    """A header at *path* that defines VALUE, for the include-path tests."""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("#define VALUE 1\n")
    return path


def prepend_to_path(
    monkeypatch: pytest.MonkeyPatch, directory: Path, only: bool = False
) -> None:
    """Search *directory* for tools first, or, when *only*, nowhere else."""
    rest = "" if only else f"{os.pathsep}{os.environ['PATH']}"
    monkeypatch.setenv("PATH", f"{directory}{rest}")


def write_fake_compiler(compiler: Path, behaviour: str) -> Path:
    """
    Stand in for hipcc with a script, so these tests need no ROCm install.

    Each compile appends the arguments it received, as a JSON list, to
    ``<name>.argv`` beside it, and the variables in WATCHED_ENVIRONMENT it saw
    to ``<name>.env``; see compiler_invocations and compiler_environments.
    ``--version`` prints ``FAKE_COMPILER_VERSION`` and is not logged. A kernel
    named in ``FAKE_COMPILER_FAIL`` fails whatever *behaviour* says.

    *behaviour* is one of:
      fail        exit 1 without writing anything
      output      write to the -o path
      save-temps  write to the -o path, and write intermediates into the
                  working directory, as -save-temps does
      silent      exit 0 without writing anything
    """
    return write_script(
        compiler,
        f"BEHAVIOUR = {behaviour!r}\n"
        f"WATCHED = {WATCHED_ENVIRONMENT!r}\n" + FAKE_COMPILER_BODY,
    )


def install_fake_compiler(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, behaviour: str
) -> regen.Toolchain:
    """
    Make the selected toolchain a fake compiler with a scratch SDK root; see
    write_fake_compiler. Returns that toolchain.
    """
    toolchain = regen.Toolchain(
        root=tmp_path / "rocm",
        compiler=write_fake_compiler(tmp_path / "fake-hipcc", behaviour),
    )
    monkeypatch.setattr(regen, "select_toolchain", lambda: toolchain)
    return toolchain


@pytest.fixture
def pinned(tmp_path: Path) -> Path:
    out = tmp_path / "asm" / "gfx950" / "kernel.s"
    out.parent.mkdir(parents=True)
    out.write_text(PINNED)
    return out


@pytest.fixture
def kernel(tmp_path: Path) -> Path:
    source = tmp_path / "kernels" / "kernel.hip"
    source.parent.mkdir()
    source.write_text("__global__ void kernel() {}\n")
    return source


@pytest.fixture
def caller_dir(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Path:
    """
    The directory the script is run from, holding an unrelated file named like
    an intermediate the compiler writes under -save-temps.
    """
    directory = tmp_path / "caller"
    directory.mkdir()
    (directory / "kernel-hip-amdgcn-amd-amdhsa-gfx950.hipi").write_text("not ours\n")
    monkeypatch.chdir(directory)
    return directory


def test_failed_compile_keeps_pinned_file(
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    pinned: Path,
    kernel: Path,
    caller_dir: Path,
) -> None:
    toolchain = install_fake_compiler(monkeypatch, tmp_path, "fail")
    with pytest.raises(regen.CompileError):
        regen.compile_device_asm(
            kernel=kernel,
            target="gfx950",
            out=pinned,
            extra_flags=[],
            toolchain=toolchain,
        )
    assert pinned.read_text() == PINNED
    assert [p.name for p in pinned.parent.iterdir()] == [
        "kernel.s"
    ]  # no staged leftovers
    assert (
        caller_dir / "kernel-hip-amdgcn-amd-amdhsa-gfx950.hipi"
    ).read_text() == "not ours\n"


# hipcc's cuid, as it appears in a listing: alone on a line, before a comma,
# and as a label.
CUID_FORMS = "\t.globl __hip_cuid_0123abcd\n\t.long __hip_cuid_0123abcd, 0\n__hip_cuid_0123abcd:\n"


def test_normalize_replaces_every_form_of_the_cuid() -> None:
    assert regen.normalize(CUID_FORMS) == (
        "\t.globl __hip_cuid_corpus\n\t.long __hip_cuid_corpus, 0\n__hip_cuid_corpus:\n"
    )


def test_normalize_is_idempotent() -> None:
    # The placeholder starts with a hex digit, c, so it must not be read as a
    # hash and rewritten again.
    once = regen.normalize(CUID_FORMS)
    assert regen.normalize(once) == once


def test_successful_compile_replaces_and_normalizes(
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    pinned: Path,
    kernel: Path,
    caller_dir: Path,
) -> None:
    toolchain = install_fake_compiler(monkeypatch, tmp_path, "output")
    regen.compile_device_asm(
        kernel=kernel, target="gfx950", out=pinned, extra_flags=[], toolchain=toolchain
    )
    text = pinned.read_text()
    assert "s_endpgm" in text
    assert "__hip_cuid_corpus" in text and "__hip_cuid_0123abcd" not in text
    assert [p.name for p in pinned.parent.iterdir()] == ["kernel.s"]


def test_intermediates_stay_in_the_scratch_directory(
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    pinned: Path,
    kernel: Path,
    caller_dir: Path,
) -> None:
    # -save-temps writes .hipi and .bc intermediates into the compiler's
    # working directory: the scratch directory, never the caller's.
    toolchain = install_fake_compiler(monkeypatch, tmp_path, "save-temps")
    regen.compile_device_asm(
        kernel=kernel,
        target="gfx950",
        out=pinned,
        extra_flags=["-save-temps"],
        toolchain=toolchain,
    )
    assert "s_endpgm" in pinned.read_text()
    # The caller's same-named file is neither replaced nor deleted, and no
    # intermediate is added beside it.
    assert sorted(p.name for p in caller_dir.iterdir()) == [
        "kernel-hip-amdgcn-amd-amdhsa-gfx950.hipi"
    ]
    assert (
        caller_dir / "kernel-hip-amdgcn-amd-amdhsa-gfx950.hipi"
    ).read_text() == "not ours\n"


def test_compile_that_writes_no_listing_is_a_failure(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, pinned: Path, kernel: Path
) -> None:
    toolchain = install_fake_compiler(monkeypatch, tmp_path, "silent")
    with pytest.raises(
        regen.CompileError, match="kernel.hip .gfx950.: the compiler wrote no listing"
    ):
        regen.compile_device_asm(
            kernel=kernel,
            target="gfx950",
            out=pinned,
            extra_flags=[],
            toolchain=toolchain,
        )
    assert pinned.read_text() == PINNED


def test_missing_header_skips_case_and_keeps_pinned_file(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, pinned: Path, kernel: Path
) -> None:
    toolchain = install_fake_compiler(
        monkeypatch, tmp_path, "fail"
    )  # must not even be invoked
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    result = regen.regenerate(
        corpus=ROCWMMA_INVENTORY,
        targets=["gfx950"],
        extra_flags=[],
        out_root=pinned.parent.parent,
        toolchain=toolchain,
    )
    assert result.failures == ()
    assert len(result.skipped) == 1 and "rocwmma/rocwmma.hpp" in result.skipped[0]
    assert pinned.read_text() == PINNED


def test_declared_header_found_through_include_flag(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, pinned: Path, kernel: Path
) -> None:
    toolchain = install_fake_compiler(monkeypatch, tmp_path, "output")
    include = tmp_path / "rocwmma-install" / "include"
    (include / "rocwmma").mkdir(parents=True)
    (include / "rocwmma" / "rocwmma.hpp").write_text("")
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    result = regen.regenerate(
        corpus=ROCWMMA_INVENTORY,
        targets=["gfx950"],
        extra_flags=[f"-I{include}"],
        out_root=pinned.parent.parent,
        toolchain=toolchain,
    )
    assert result == regen.RegenerateResult(failures=(), skipped=())
    assert "s_endpgm" in pinned.read_text()


def test_relative_include_flags_are_made_absolute(tmp_path: Path) -> None:
    base = tmp_path / "caller"
    write_header(base / "pre.h")
    flags = ["-I../inc", "-isystem", "sys", "-I/abs", "-O2", "-include", "pre.h"]
    assert regen.absolute_flags(flags, base) == [
        f"-I{base / '../inc'}",
        "-isystem",
        str(base / "sys"),
        "-I/abs",
        "-O2",
        "-include",
        str(base / "pre.h"),
    ]


# --- --check: code drift versus compiler provenance ---------------------------


def assembly(
    ident: str = "AMD clang version 23 (abc)", wait: str = "s_waitcnt vmcnt(0)"
) -> str:
    return f'\t.text\nkernel:\n\t{wait}\n\ts_endpgm\n\t.ident\t"{ident}"\n'


@pytest.fixture
def drift_dirs(monkeypatch: pytest.MonkeyPatch, tmp_path: Path) -> tuple[Path, Path]:
    """(committed, fresh) target directories, with ASM_DIR pointed at committed."""
    committed_root, fresh_root = tmp_path / "committed", tmp_path / "fresh"
    (committed_root / "gfx950").mkdir(parents=True)
    (fresh_root / "gfx950").mkdir(parents=True)
    monkeypatch.setattr(regen, "ASM_DIR", committed_root)
    return committed_root / "gfx950", fresh_root


def check(
    fresh_root: Path, expected: set[tuple[str, str]] | None = None
) -> regen.ExitCode:
    """_report_drift for gfx950, expecting by default exactly the generated files."""
    if expected is None:
        expected = {
            ("gfx950", path.name) for path in (fresh_root / "gfx950").glob("*.s")
        }
    return regen._report_drift(
        targets=["gfx950"], out_root=fresh_root, expected=expected
    )


def test_check_passes_identical_assembly(drift_dirs: tuple[Path, Path]) -> None:
    committed, fresh_root = drift_dirs
    (committed / "k.s").write_text(assembly())
    (fresh_root / "gfx950" / "k.s").write_text(assembly())
    assert check(fresh_root) == regen.ExitCode.SUCCESS


def test_check_reports_ident_only_change_as_provenance_not_drift(
    drift_dirs: tuple[Path, Path], capsys: pytest.CaptureFixture[str]
) -> None:
    committed, fresh_root = drift_dirs
    (committed / "k.s").write_text(assembly(ident="AMD clang version 23 (abc)"))
    (fresh_root / "gfx950" / "k.s").write_text(
        assembly(ident="AMD clang version 24 (def)")
    )
    assert check(fresh_root) == regen.ExitCode.SUCCESS
    out = capsys.readouterr()
    assert "gfx950/k.s" in out.out
    assert (
        "AMD clang version 23 (abc)" in out.out
        and "AMD clang version 24 (def)" in out.out
    )
    assert "drift" not in out.err


def test_check_fails_on_instruction_change(
    drift_dirs: tuple[Path, Path], capsys: pytest.CaptureFixture[str]
) -> None:
    committed, fresh_root = drift_dirs
    (committed / "k.s").write_text(assembly(wait="s_waitcnt vmcnt(0)"))
    (fresh_root / "gfx950" / "k.s").write_text(assembly(wait="s_waitcnt vmcnt(1)"))
    assert check(fresh_root) == regen.ExitCode.DRIFT
    assert "gfx950/k.s" in capsys.readouterr().err


def test_check_counts_instruction_change_as_drift_even_with_new_ident(
    drift_dirs: tuple[Path, Path], capsys: pytest.CaptureFixture[str]
) -> None:
    committed, fresh_root = drift_dirs
    (committed / "k.s").write_text(assembly(ident="A", wait="s_waitcnt vmcnt(0)"))
    (fresh_root / "gfx950" / "k.s").write_text(
        assembly(ident="B", wait="s_waitcnt vmcnt(1)")
    )
    assert check(fresh_root) == regen.ExitCode.DRIFT
    out = capsys.readouterr()
    assert "gfx950/k.s" in out.err
    assert "gfx950/k.s" not in out.out  # not also listed as provenance-only


def test_check_fails_on_uncommitted_file(
    drift_dirs: tuple[Path, Path], capsys: pytest.CaptureFixture[str]
) -> None:
    _, fresh_root = drift_dirs
    (fresh_root / "gfx950" / "new.s").write_text(assembly())
    assert check(fresh_root) == regen.ExitCode.DRIFT
    assert "gfx950/new.s: not committed" in capsys.readouterr().err


# --- The corpus target set ---------------------------------------------------
#
# cases.toml declares the targets the corpus is built for. A portable case builds
# for exactly those, and a case's targets must name only those, so adding a
# target is a deliberate edit to the manifest.


@pytest.fixture
def manifest(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Manifest:
    """Point the script at a scratch cases.toml written from (targets, cases)."""
    path = tmp_path / "cases.toml"
    monkeypatch.setattr(regen, "CASES_PATH", path)

    def write(targets: list[str] | None, cases: str) -> None:
        path.write_text(corpus_table(targets) + cases)

    return write


PORTABLE_CASE = '[[case]]\nid = "portable"\nkernel = "kernel"\ntargets = []\n'


def test_default_targets_come_from_the_manifest_not_asm(
    manifest: Manifest, monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    # An assembly directory for another target does not add it.
    asm = tmp_path / "asm"
    for target in ("gfx950", "gfx1250", "gfx1201"):
        (asm / target).mkdir(parents=True)
    monkeypatch.setattr(regen, "ASM_DIR", asm)
    assert regen.targets_for(regen.load_inventory(), []) == ["gfx950", "gfx1250"]


def test_requested_target_must_be_a_corpus_target(manifest: Manifest) -> None:
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    corpus = regen.load_inventory()
    assert regen.targets_for(corpus, ["gfx1250"]) == ["gfx1250"]
    with pytest.raises(regen.UsageError, match="gfx1201.*not in \\[corpus\\] targets"):
        regen.targets_for(corpus, ["gfx1201"])


def test_case_target_outside_the_corpus_targets_is_rejected(manifest: Manifest) -> None:
    manifest(
        ["gfx950", "gfx1250"],
        PORTABLE_CASE + '[[case]]\nid = "new"\nkernel = "new"\ntargets = ["gfx1201"]\n',
    )
    with pytest.raises(regen.SetupError, match="gfx1201.*not in \\[corpus\\] targets"):
        regen.load_inventory()


@pytest.mark.parametrize("targets", [None, []])
def test_manifest_without_targets_is_rejected(
    manifest: Manifest, targets: list[str] | None
) -> None:
    manifest(targets, PORTABLE_CASE)
    with pytest.raises(regen.SetupError, match="\\[corpus\\] targets"):
        regen.load_inventory()


def test_portable_case_builds_for_every_corpus_target(
    manifest: Manifest, monkeypatch: pytest.MonkeyPatch, tmp_path: Path, kernel: Path
) -> None:
    toolchain = install_fake_compiler(monkeypatch, tmp_path, "output")
    manifest(
        ["gfx950", "gfx1250"],
        PORTABLE_CASE
        + '[[case]]\nid = "only"\nkernel = "only"\ntargets = ["gfx1250"]\n',
    )
    (kernel.parent / "only.hip").write_text("__global__ void only() {}\n")
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    out_root = tmp_path / "out"
    corpus = regen.load_inventory()
    result = regen.regenerate(
        corpus=corpus,
        targets=regen.targets_for(corpus, []),
        extra_flags=[],
        out_root=out_root,
        toolchain=toolchain,
    )
    assert result == regen.RegenerateResult(failures=(), skipped=())
    assert sorted(str(p.relative_to(out_root)) for p in out_root.rglob("*.s")) == [
        "gfx1250/kernel.s",
        "gfx1250/only.s",
        "gfx950/kernel.s",
    ]


# --- Header preflight ignores the environment's include paths ------------------
#
# The compile does not inherit CPATH, CPLUS_INCLUDE_PATH or C_INCLUDE_PATH (see
# "Only recorded inputs reach the compiler"), so the preflight does not search
# them either: a header available only through one of them is missing, and its
# case is skipped. Headers outside the SDK come through --cxxflags -I.


def header_dir(tmp_path: Path) -> Path:
    include = tmp_path / "env-include"
    (include / "rocwmma").mkdir(parents=True)
    (include / "rocwmma" / "rocwmma.hpp").write_text("")
    return include


@pytest.mark.parametrize("variable", ["CPATH", "CPLUS_INCLUDE_PATH", "C_INCLUDE_PATH"])
def test_environment_include_path_is_not_searched(
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    pinned: Path,
    kernel: Path,
    variable: str,
) -> None:
    # The compiler must not be invoked: the case is skipped first.
    toolchain = install_fake_compiler(monkeypatch, tmp_path, "fail")
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    monkeypatch.setenv(variable, str(header_dir(tmp_path)))
    result = regen.regenerate(
        corpus=ROCWMMA_INVENTORY,
        targets=["gfx950"],
        extra_flags=[],
        out_root=pinned.parent.parent,
        toolchain=toolchain,
    )
    assert result.failures == ()
    assert len(result.skipped) == 1 and "--cxxflags" in result.skipped[0]
    assert pinned.read_text() == PINNED


# --- Header preflight resolves sysroot-relative include directories --------------
#
# A directory starting with "=", such as -I=/custom, is relative to the sysroot:
# the last -isysroot, else the last --sysroot. The preflight looks for declared
# headers where the compiler would, so a header reachable only that way does not
# make regenerate() skip its case. With no sysroot, the compiler keeps the "="
# path as written, and so does the preflight.

SYSROOT_HEADER_CASE = regen.inventory.Case(
    id="sysroot", kernel="kernel", targets=(), headers=("required.h",)
)
SYSROOT_HEADER_INVENTORY = regen.inventory.Inventory(
    targets=("gfx950",), cases=(SYSROOT_HEADER_CASE,)
)


def sysroot_with_header(path: Path) -> Path:
    """A sysroot at *path* whose custom/ holds required.h. Returns *path*."""
    write_header(path / "custom" / "required.h")
    return path


def sysroot_flags(form: str, sysroot: Path, other: Path) -> list[str]:
    """The flags of each sysroot form; *other* is a sysroot without the header."""
    return {
        "-I=": [f"--sysroot={sysroot}", "-I=/custom"],
        "-isystem =": ["--sysroot", str(sysroot), "-isystem", "=/custom"],
        "-iquote =": [f"--sysroot={sysroot}", "-iquote", "=/custom"],
        "-isysroot over --sysroot": [
            "-isysroot",
            str(sysroot),
            f"--sysroot={other}",
            "-I=/custom",
        ],
    }[form]


@pytest.mark.parametrize(
    "form", ["-I=", "-isystem =", "-iquote =", "-isysroot over --sysroot"]
)
def test_header_under_the_sysroot_is_found(
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    pinned: Path,
    kernel: Path,
    form: str,
) -> None:
    toolchain = install_fake_compiler(monkeypatch, tmp_path, "output")
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    sysroot = sysroot_with_header(tmp_path / "sysroot")
    flags = sysroot_flags(form, sysroot=sysroot, other=tmp_path / "other")
    assert regen.absolute_flags(flags, tmp_path) == flags
    result = regen.regenerate(
        corpus=SYSROOT_HEADER_INVENTORY,
        targets=["gfx950"],
        extra_flags=flags,
        out_root=pinned.parent.parent,
        toolchain=toolchain,
    )
    assert result == regen.RegenerateResult(failures=(), skipped=())
    assert "s_endpgm" in pinned.read_text()


def test_overridden_sysroot_is_not_searched(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, pinned: Path, kernel: Path
) -> None:
    # Only --sysroot has the header, but -isysroot overrides it for headers.
    toolchain = install_fake_compiler(monkeypatch, tmp_path, "fail")  # not invoked
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    with_header = sysroot_with_header(tmp_path / "with-header")
    flags = ["-isysroot", str(tmp_path / "without"), f"--sysroot={with_header}"]
    result = regen.regenerate(
        corpus=SYSROOT_HEADER_INVENTORY,
        targets=["gfx950"],
        extra_flags=[*flags, "-I=/custom"],
        out_root=pinned.parent.parent,
        toolchain=toolchain,
    )
    assert len(result.skipped) == 1 and "required.h" in result.skipped[0]
    assert pinned.read_text() == PINNED


def test_real_compiler_header_under_the_sysroot_is_regenerated(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    # The kernel needs required.h, reachable only as -I=/custom under the
    # sysroot: VALUE is undefined without it, so the compile succeeds only if the
    # header is found. The sysroot links the host's /usr, for the C++ headers HIP
    # needs.
    toolchain = real_toolchain()
    sysroot = sysroot_with_header(tmp_path / "sysroot")
    (sysroot / "usr").symlink_to("/usr")
    kernels = tmp_path / "kernels"
    kernels.mkdir()
    (kernels / "kernel.hip").write_text(
        "#include <required.h>\\n__attribute__((used)) __device__ int value = VALUE;\\n"
    )
    monkeypatch.setattr(regen, "KERNELS_DIR", kernels)
    out_root = tmp_path / "out"
    result = regen.regenerate(
        corpus=SYSROOT_HEADER_INVENTORY,
        targets=["gfx950"],
        extra_flags=[f"--sysroot={sysroot}", "-I=/custom"],
        out_root=out_root,
        toolchain=toolchain,
    )
    assert result == regen.RegenerateResult(failures=(), skipped=())
    listing = (out_root / "gfx950" / "kernel.s").read_text()
    assert '.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx950' in listing


# --- What the script says about regeneration and --check ----------------------
#
# cases.toml is an inventory: id, kernel, targets and headers. The messages
# describe regenerating as a change to the pinned assembly, and --check as the
# textual comparison it performs, without mutation-site fields cases.toml does
# not have.


def test_check_help_describes_the_textual_comparison(
    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
) -> None:
    with pytest.raises(SystemExit):
        regen.main(["--help"])
    help_text = " ".join(capsys.readouterr().out.split())
    assert ".ident" in help_text
    assert "directive" in help_text and "metadata" in help_text
    assert "means this toolchain generates different code" not in help_text


def test_drift_report_does_not_mention_ordinals(
    drift_dirs: tuple[Path, Path], capsys: pytest.CaptureFixture[str]
) -> None:
    committed, fresh_root = drift_dirs
    (committed / "k.s").write_text("s_waitcnt 0\n")
    (fresh_root / "gfx950" / "k.s").write_text("s_nop 0\n")
    assert check(fresh_root) == regen.ExitCode.DRIFT
    err = " ".join(capsys.readouterr().err.split())
    assert "ordinal" not in err
    assert "pinned assembly" in err


def test_write_summary_does_not_mention_ordinals(
    manifest: Manifest,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    kernel: Path,
    capsys: pytest.CaptureFixture[str],
) -> None:
    install_fake_compiler(monkeypatch, tmp_path, "output")
    manifest(["gfx950"], PORTABLE_CASE)
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    monkeypatch.setattr(regen, "CORPUS_ROOT", tmp_path / "corpus" / "race")
    monkeypatch.setattr(regen, "ASM_DIR", tmp_path / "corpus" / "race" / "asm")
    assert regen.main([]) == regen.ExitCode.SUCCESS
    out = " ".join(capsys.readouterr().out.split())
    assert "ordinal" not in out
    assert "pinned assembly" in out


# --- A --check verdict covers the whole selected inventory ---------------------
#
# --check succeeds only when every output the selected cases should produce was
# generated and compared, and nothing else is committed for the selected
# targets. A case skipped for a missing header, an obsolete committed file, or a
# missing target directory must not leave "matches" as the verdict. Update mode
# keeps skipping cases whose optional headers are unavailable.

ROCWMMA_CASE = (
    '[[case]]\nid = "wmma"\nkernel = "wmma"\ntargets = []\n'
    'headers = ["rocwmma/rocwmma.hpp"]\n'
)


@pytest.fixture
def corpus_main(
    manifest: Manifest, monkeypatch: pytest.MonkeyPatch, tmp_path: Path, kernel: Path
) -> CorpusMain:
    """
    Run main() against a scratch corpus whose committed assembly is under
    ``corpus/race/asm``, with the fake compiler writing ``assembly()``-free
    output. Returns (run, committed_root).
    """
    install_fake_compiler(monkeypatch, tmp_path, "output")
    (kernel.parent / "wmma.hip").write_text("__global__ void wmma() {}\n")
    (kernel.parent / "only.hip").write_text("__global__ void only() {}\n")
    for name in ("CPATH", "CPLUS_INCLUDE_PATH"):
        monkeypatch.delenv(name, raising=False)
    root = tmp_path / "corpus" / "race"
    committed = root / "asm"
    monkeypatch.setattr(regen, "CORPUS_ROOT", root)
    monkeypatch.setattr(regen, "ASM_DIR", committed)
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)

    def run(*argv: str) -> regen.ExitCode:
        return regen.main([*argv])

    return run, committed


def commit_fresh_output(run: Callable[..., regen.ExitCode], committed: Path) -> None:
    """Populate the committed tree by running update mode, as a person would."""
    assert run() == regen.ExitCode.SUCCESS
    assert any(committed.rglob("*.s"))


def test_check_with_only_a_skipped_case_is_incomplete(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, _ = corpus_main
    manifest(["gfx950"], ROCWMMA_CASE)
    code = run("--check")
    out = capsys.readouterr()
    assert code == regen.ExitCode.INCOMPLETE
    assert "matches" not in out.out
    assert "incomplete" in out.err and "wmma" in out.err


def test_check_with_some_cases_skipped_is_incomplete(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    manifest(["gfx950"], PORTABLE_CASE + ROCWMMA_CASE)
    capsys.readouterr()
    assert run("--check") == regen.ExitCode.INCOMPLETE
    assert "matches" not in capsys.readouterr().out


def test_check_with_nothing_selected_is_incomplete(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, _ = corpus_main
    manifest(
        ["gfx950", "gfx1250"],
        '[[case]]\nid = "only"\nkernel = "only"\ntargets = ["gfx1250"]\n',
    )
    assert run("--check", "--target", "gfx950") == regen.ExitCode.INCOMPLETE
    out = capsys.readouterr()
    assert "matches" not in out.out
    assert "incomplete" in out.err


def test_check_passes_a_complete_matching_inventory(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, committed = corpus_main
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    capsys.readouterr()
    assert run("--check") == regen.ExitCode.SUCCESS
    assert "matches" in capsys.readouterr().out


def test_check_reports_an_obsolete_committed_file(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    (committed / "gfx950" / "obsolete.s").write_text("; no case builds this\n")
    capsys.readouterr()
    assert run("--check") == regen.ExitCode.DRIFT
    err = capsys.readouterr().err
    assert "gfx950/obsolete.s" in err and "no selected case" in err


def test_check_reports_a_missing_committed_target_directory(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, committed = corpus_main
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    for path in (committed / "gfx1250").iterdir():
        path.unlink()
    (committed / "gfx1250").rmdir()
    capsys.readouterr()
    assert run("--check") == regen.ExitCode.DRIFT
    assert "gfx1250/kernel.s: not committed" in capsys.readouterr().err


def test_check_reports_an_expected_output_absent_from_both_trees(
    drift_dirs: tuple[Path, Path], capsys: pytest.CaptureFixture[str]
) -> None:
    # A selected case whose output was neither generated nor committed.
    _, fresh_root = drift_dirs
    assert check(fresh_root, expected={("gfx950", "k.s")}) == regen.ExitCode.DRIFT
    assert "gfx950/k.s: not generated and not committed" in capsys.readouterr().err


def test_update_mode_reports_a_skipped_case_and_leaves_its_target(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    # The skip is still reported, but the target's other listing is not written
    # either: its recipe could not describe both.
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE + ROCWMMA_CASE)
    assert run() == regen.ExitCode.INCOMPLETE
    out = capsys.readouterr().out
    assert "skip: wmma" in out
    assert not (committed / "gfx950" / "kernel.s").exists()
    assert not (committed / "gfx950" / "recipe.toml").exists()


def test_check_help_documents_the_exit_codes(
    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
) -> None:
    with pytest.raises(SystemExit):
        regen.main(["--help"])
    help_text = " ".join(capsys.readouterr().out.split())
    assert (
        "Exits 0 on success, 1 when --check finds drift, 2 when a case fails to compile "
        "or an argument is invalid, 3 when a case was skipped"
    ) in help_text
    assert "4 when the inventory or the toolchain cannot be used" in help_text


def test_exit_codes_keep_their_public_numbers() -> None:
    # The numbers are part of the script's interface: --help and the README
    # document them, and callers may test them. Everything else names them.
    assert {code.name: int(code) for code in regen.ExitCode} == {
        "SUCCESS": 0,
        "DRIFT": 1,
        "COMPILE_FAILED": 2,
        "INCOMPLETE": 3,
        "SETUP_FAILED": 4,
    }


# --- A compile failure keeps the compiler's diagnostic -----------------------


def test_main_preserves_the_compiler_diagnostic(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    capsys: pytest.CaptureFixture[str],
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    pinned_file = committed / "gfx950" / "kernel.s"
    pinned_file.parent.mkdir(parents=True)
    pinned_file.write_text(PINNED)
    # Replace the fixture's compiler with one that fails the way hipcc does on
    # a bad flag: exit 1, with the cause on stderr.
    install_fake_compiler(monkeypatch, tmp_path, "fail")
    assert run() == regen.ExitCode.COMPILE_FAILED
    err = capsys.readouterr().err
    assert "FAIL: kernel.hip (gfx950):" in err
    assert "error: unknown argument" in err
    assert pinned_file.read_text() == PINNED


# --- --cxxflags is parsed as shell words -------------------------------------


def compiler_environments(
    tmp_path: Path, name: str = "fake-hipcc"
) -> list[dict[str, str | None]]:
    """The watched environment of each compile by the fake compiler *name*, in order."""
    log = tmp_path / f"{name}.env"
    if not log.is_file():
        return []
    return [json.loads(line) for line in log.read_text().splitlines()]


def compiler_invocations(tmp_path: Path, name: str = "fake-hipcc") -> list[list[str]]:
    """The argument lists the fake compiler *name* has been run with, in order."""
    log = tmp_path / f"{name}.argv"
    if not log.is_file():
        return []
    return [json.loads(line) for line in log.read_text().splitlines()]


def test_quoted_include_path_with_spaces_reaches_the_compiler_whole(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
) -> None:
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    caller = tmp_path / "caller"
    caller.mkdir()
    monkeypatch.chdir(caller)
    assert (
        run("--cxxflags", '-I"headers with spaces" -isystem "/abs dir/inc" -DX=1')
        == regen.ExitCode.SUCCESS
    )
    (argv,) = compiler_invocations(tmp_path)
    assert f"-I{caller / 'headers with spaces'}" in argv
    assert argv[argv.index("-isystem") + 1] == "/abs dir/inc"
    assert "-DX=1" in argv
    assert not any(arg in ("with", 'spaces"', 'dir/inc"') for arg in argv)


def test_malformed_quoting_is_rejected_before_compiling(
    manifest: Manifest,
    corpus_main: CorpusMain,
    tmp_path: Path,
    capsys: pytest.CaptureFixture[str],
) -> None:
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    # The --flag=value form, as typed on a command line: argparse would read a
    # separate "-I..." word as an option of its own.
    with pytest.raises(SystemExit) as exit_info:
        run('--cxxflags=-I"unterminated')
    message = str(exit_info.value.code) + capsys.readouterr().err
    assert exit_info.value.code not in (0, None)
    assert "--cxxflags" in message and "quot" in message
    assert compiler_invocations(tmp_path) == []


# --- SDK and compiler paths survive the compiler's scratch directory --------
#
# The compiler runs from a private scratch directory, so every path handed to it,
# the executable included, must already be absolute. A relative ROCM_PATH means
# something only from the caller's directory.


@pytest.fixture
def no_sdk_discovery(monkeypatch: pytest.MonkeyPatch) -> None:
    """Leave ROCM_PATH as the only way to find an SDK."""
    monkeypatch.delenv("ROCM_PATH", raising=False)
    monkeypatch.setattr(regen.shutil, "which", lambda name: None)


def fake_sdk(root: Path, layout: str = "bin/hipcc", behaviour: str = "output") -> Path:
    """An SDK directory holding a fake compiler at *layout* under *root*."""
    compiler = root / layout
    compiler.parent.mkdir(parents=True)
    (root / "include").mkdir()
    return write_fake_compiler(compiler, behaviour)


def test_relative_rocm_path_compiles_from_the_scratch_directory(
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    pinned: Path,
    kernel: Path,
    no_sdk_discovery: None,
) -> None:
    caller = tmp_path / "caller"
    fake_sdk(caller / "rocm")
    monkeypatch.chdir(caller)
    monkeypatch.setenv("ROCM_PATH", "rocm")
    regen.compile_device_asm(
        kernel=kernel,
        target="gfx950",
        out=pinned,
        extra_flags=[],
        toolchain=regen.select_toolchain(),
    )
    assert "s_endpgm" in pinned.read_text()
    (argv,) = [
        line
        for line in (caller / "rocm" / "bin" / "hipcc.argv").read_text().splitlines()
    ]
    assert f"--rocm-path={caller / 'rocm'}" in argv
    assert str(caller / "rocm" / "include") in argv


def test_rocm_path_is_absolute(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, no_sdk_discovery: None
) -> None:
    (tmp_path / "rocm").mkdir()
    monkeypatch.chdir(tmp_path)
    monkeypatch.setenv("ROCM_PATH", "rocm")
    assert regen.rocm_path() == tmp_path / "rocm"


def test_clang_is_used_when_the_sdk_has_no_hipcc(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, no_sdk_discovery: None
) -> None:
    compiler = fake_sdk(tmp_path / "rocm", layout="llvm/bin/clang++")
    assert regen.find_hip_compiler(tmp_path / "rocm") == compiler


def test_missing_compiler_error_names_both_candidates(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, no_sdk_discovery: None
) -> None:
    (tmp_path / "rocm").mkdir()
    with pytest.raises(regen.SetupError) as error:
        regen.find_hip_compiler(tmp_path / "rocm")
    assert "bin/hipcc" in str(error.value) and "llvm/bin/clang++" in str(error.value)


# --- Skipping explicitly allowed ----------------------------------------------
#
# --allow-skipped lets a --check pass on the cases it could compare, for a
# machine without an optional dependency, but the verdict still names every
# case it did not compare. It cannot turn "nothing was compared" into a match.


def test_check_allowing_skips_names_the_cases_not_compared(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    manifest(["gfx950"], PORTABLE_CASE + ROCWMMA_CASE)
    capsys.readouterr()
    assert run("--check", "--allow-skipped") == regen.ExitCode.SUCCESS
    out = capsys.readouterr()
    verdict = " ".join((out.out + out.err).split())
    assert "not compared: wmma (gfx950)" in verdict
    assert "1 case(s) skipped and not compared" in verdict
    assert "committed assembly matches this toolchain for the compared cases" in verdict


def test_check_allowing_skips_still_fails_on_drift(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    (committed / "gfx950" / "kernel.s").write_text("; changed by hand\n")
    manifest(["gfx950"], PORTABLE_CASE + ROCWMMA_CASE)
    assert run("--check", "--allow-skipped") == regen.ExitCode.DRIFT


def test_check_allowing_skips_with_nothing_compared_is_still_incomplete(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, _ = corpus_main
    manifest(["gfx950"], ROCWMMA_CASE)
    assert run("--check", "--allow-skipped") == regen.ExitCode.INCOMPLETE
    out = capsys.readouterr()
    assert "matches" not in out.out
    assert "incomplete" in out.err


def test_allow_skipped_only_applies_with_check(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    with pytest.raises(SystemExit) as exit_info:
        run("--allow-skipped")
    # argparse's own status for a usage error, not an ExitCode.
    assert exit_info.value.code == 2
    assert "--allow-skipped only applies with --check" in capsys.readouterr().err


# --- --check cleans up its generated assembly ---------------------------------


@pytest.fixture
def temp_root(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Path:
    """Where tempfile creates directories during the test, to see what is left."""
    root = tmp_path / "system-tmp"
    root.mkdir()
    monkeypatch.setattr(regen.tempfile, "tempdir", str(root))
    return root


@pytest.mark.parametrize("outcome", ["match", "drift", "compile-failure", "incomplete"])
def test_check_leaves_no_temporary_directory(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    temp_root: Path,
    outcome: str,
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    expected_code = regen.ExitCode.SUCCESS
    if outcome == "drift":
        (committed / "gfx950" / "kernel.s").write_text("; changed by hand\n")
        expected_code = regen.ExitCode.DRIFT
    elif outcome == "compile-failure":
        install_fake_compiler(monkeypatch, tmp_path, "fail")
        expected_code = regen.ExitCode.COMPILE_FAILED
    elif outcome == "incomplete":
        manifest(["gfx950"], PORTABLE_CASE + ROCWMMA_CASE)
        expected_code = regen.ExitCode.INCOMPLETE
    assert run("--check") == expected_code
    assert list(temp_root.iterdir()) == []


# --- --help is a short description, with the workflow in the README -----------


def test_help_is_short_and_points_to_the_readme(
    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
) -> None:
    with pytest.raises(SystemExit):
        regen.main(["--help"])
    help_text = capsys.readouterr().out
    assert "corpus/race/README.md" in help_text
    # The rationale and usage examples live in the module docstring and the
    # README, not in --help.
    assert "Why the assembly is committed" not in help_text
    assert "CI drift gate" not in help_text


def test_help_states_the_path_flag_contract(capsys: pytest.CaptureFixture[str]) -> None:
    with pytest.raises(SystemExit):
        regen.main(["--help"])
    help_text = " ".join(capsys.readouterr().out.split())
    assert (
        "Relative paths are supported only for -I, -iquote, -isystem and -include"
        in (help_text)
    )
    assert "a relative -include must name a file in this directory" in help_text
    assert "relative to the sysroot" in help_text
    assert "a path forwarded that way must be absolute" in help_text
    assert "a response file (@file)" in help_text
    assert "-g, whose debug info would embed the scratch directory" in help_text


# --- The per-case field is targets ---------------------------------------------


def test_case_without_targets_regenerates_for_every_corpus_target(
    manifest: Manifest, monkeypatch: pytest.MonkeyPatch, tmp_path: Path, kernel: Path
) -> None:
    toolchain = install_fake_compiler(monkeypatch, tmp_path, "output")
    manifest(["gfx950", "gfx1250"], '[[case]]\nid = "portable"\nkernel = "kernel"\n')
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    out_root = tmp_path / "out"
    corpus = regen.load_inventory()
    result = regen.regenerate(
        corpus=corpus,
        targets=regen.targets_for(corpus, []),
        extra_flags=[],
        out_root=out_root,
        toolchain=toolchain,
    )
    assert result == regen.RegenerateResult(failures=(), skipped=())
    assert sorted(str(p.relative_to(out_root)) for p in out_root.rglob("*.s")) == [
        "gfx1250/kernel.s",
        "gfx950/kernel.s",
    ]


def test_requires_is_rejected_rather_than_ignored(manifest: Manifest) -> None:
    # Ignoring it would turn a target-specific case into a portable one.
    manifest(
        ["gfx950", "gfx1250"],
        '[[case]]\nid = "only"\nkernel = "only"\nrequires = ["gfx1250"]\n',
    )
    with pytest.raises(regen.SetupError, match="'requires' is now 'targets'"):
        regen.load_inventory()


# --- One validated inventory ---------------------------------------------------


def test_misspelled_case_field_is_rejected(manifest: Manifest) -> None:
    # Regeneration used to accept a field the checker rejects.
    manifest(
        ["gfx950"],
        '[[case]]\nid = "wmma"\nkernel = "wmma"\nheader = ["rocwmma/rocwmma.hpp"]\n',
    )
    with pytest.raises(regen.SetupError, match="unknown field 'header'"):
        regen.load_inventory()


def test_main_reads_the_manifest_once(
    manifest: Manifest, corpus_main: CorpusMain, monkeypatch: pytest.MonkeyPatch
) -> None:
    # Regenerating and the --check verdict must judge the same inventory, so
    # cases.toml is read once and passed down rather than re-read per step.
    run, committed = corpus_main
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    reads = []
    real_load = regen.inventory.load
    monkeypatch.setattr(
        regen.inventory, "load", lambda path: reads.append(path) or real_load(path)
    )
    assert run("--check") == regen.ExitCode.SUCCESS
    assert len(reads) == 1


def test_misspelled_case_table_leaves_every_pinned_file(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    # [[cases]] for [[case]] would leave no cases, and so publish every target
    # with no listings. The manifest is rejected instead, before anything is
    # compiled or published.
    run, committed = corpus_main
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    pinned = {path: path.read_text() for path in committed.rglob("*") if path.is_file()}
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE.replace("[[case]]", "[[cases]]"))
    capsys.readouterr()
    assert run() == regen.ExitCode.SETUP_FAILED
    assert "unknown top-level key 'cases'" in capsys.readouterr().err
    assert {
        path: path.read_text() for path in committed.rglob("*") if path.is_file()
    } == pinned


# --- One list of include-directory flags --------------------------------------
#
# The header preflight and the relative-path rewrite read include directories
# from the same flags, so a flag added to one is understood by both.


@pytest.mark.parametrize("flag", regen._INCLUDE_DIR_FLAGS)
def test_every_include_directory_flag_is_searched_and_made_absolute(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, flag: str
) -> None:
    base = tmp_path / "caller"
    for flags in ([flag, "inc"], [f"{flag}inc"]):
        assert regen.include_dirs(flags, root=tmp_path / "rocm")[1:] == [Path("inc")]
        assert str(base / "inc") in "".join(regen.absolute_flags(flags, base))


def test_forced_include_file_is_not_an_include_directory(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    # A forced include names a file, not a directory to search for headers.
    base = tmp_path / "caller"
    write_header(base / "pre.h")
    flags = ["-include", "pre.h"]
    assert regen.include_dirs(flags, root=tmp_path / "rocm") == [
        tmp_path / "rocm" / "include"
    ]
    assert regen.absolute_flags(flags, base) == ["-include", str(base / "pre.h")]


# --- A forced include names a file from the caller's directory ------------------
#
# The compiler looks for `-include file` in its working directory first, and
# then applies its own header-search rules, which the script does not copy. The
# compile runs in a scratch directory, so a relative -include must name a file
# from the caller's directory, where the compiler would look first: it is passed,
# and recorded, as that absolute path. Anything else is rejected, since the
# compiler might select a different file.


def test_forced_include_in_the_working_directory_is_made_absolute(
    tmp_path: Path,
) -> None:
    caller = tmp_path / "caller"
    in_caller = write_header(caller / "options.h")
    write_header(caller / "include" / "options.h")
    flags = ["-Iinclude", "-include", "options.h"]
    assert regen.absolute_flags(flags, caller)[-1] == str(in_caller)


def test_forced_include_with_a_path_from_the_working_directory_is_made_absolute(
    tmp_path: Path,
) -> None:
    caller = tmp_path / "caller"
    header = write_header(caller / "include" / "options.h")
    resolved = regen.absolute_flags(["-includeinclude/options.h"], caller)
    assert resolved == [f"-include{header}"]


def test_absolute_forced_include_is_passed_unchanged(tmp_path: Path) -> None:
    flags = ["-include", str(tmp_path / "anywhere" / "options.h")]
    assert regen.absolute_flags(flags, tmp_path / "caller") == flags


def test_forced_include_not_in_the_working_directory_is_rejected(
    tmp_path: Path,
) -> None:
    # Only include/options.h exists: the compiler would search for options.h
    # with its own rules, which the script cannot reproduce from elsewhere.
    caller = tmp_path / "caller"
    write_header(caller / "include" / "options.h")
    with pytest.raises(regen.UsageError, match="-include options.h: not found in"):
        regen.absolute_flags(["-Iinclude", "-include", "options.h"], caller)


def test_rejected_forced_include_is_a_usage_error(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    capsys: pytest.CaptureFixture[str],
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    caller = tmp_path / "caller"
    write_header(caller / "include" / "options.h")
    monkeypatch.chdir(caller)
    with pytest.raises(SystemExit) as exit_info:
        run("--cxxflags=-Iinclude -include options.h")
    # argparse's own status for a usage error, not an ExitCode.
    assert exit_info.value.code == 2
    assert "give its path from this directory" in capsys.readouterr().err
    assert compiler_invocations(tmp_path) == []
    assert not (committed / "gfx950").exists()


# The flags of the overlapping-directory case: first is both an -I and an
# -isystem directory, so the compiler searches it as a system directory, after
# second. Each directory's options.h defines a different value.
OVERLAPPING_FLAGS = [
    "-Ifirst",
    "-Isecond",
    "-isystem",
    "first",
    "-include",
    "options.h",
]


def write_overlapping_headers(caller: Path) -> None:
    for directory, value in (("first", 11), ("second", 22)):
        (caller / directory).mkdir(parents=True)
        (caller / directory / "options.h").write_text(f"#define RACE_VALUE {value}\n")


def real_toolchain() -> regen.Toolchain:
    """The selected SDK's toolchain, or skip the test when there is none."""
    try:
        return regen.select_toolchain()
    except regen.SetupError as error:
        pytest.skip(f"no ROCm SDK with a HIP compiler: {error}")


def compiled_value(listing: str) -> str:
    """The value of the kernel's `value` variable in a listing."""
    lines = listing.splitlines()
    return lines[lines.index("value:") + 1].split()[1]


def compile_directly(toolchain: regen.Toolchain, kernel: Path, out: Path) -> None:
    """Compile *kernel* with OVERLAPPING_FLAGS from its own directory, as a user would."""
    subprocess.run(
        [str(toolchain.compiler), f"--rocm-path={toolchain.root}", "-O3", "-x", "hip"]
        + ["-S", "--cuda-device-only", "--offload-arch=gfx950", *OVERLAPPING_FLAGS]
        + [str(kernel), "-o", str(out)],
        cwd=kernel.parent,
        check=True,
        capture_output=True,
        env=regen.compiler_environment(toolchain.root),
    )


def test_real_compiler_rejects_an_overlapping_directory_forced_include(
    tmp_path: Path,
) -> None:
    # The compiler selects second/options.h here, where a copy of its search
    # rules would select first/options.h, so the flag is rejected instead.
    toolchain = real_toolchain()
    caller = tmp_path / "caller"
    write_overlapping_headers(caller)
    kernel = caller / "forced.hip"
    kernel.write_text("__attribute__((used)) __device__ int value = RACE_VALUE;\n")
    direct = caller / "direct.s"
    compile_directly(toolchain, kernel=kernel, out=direct)
    assert compiled_value(direct.read_text()) == "22"
    with pytest.raises(regen.UsageError, match="-include options.h: not found in"):
        regen.absolute_flags(OVERLAPPING_FLAGS, caller)


def test_real_compiler_selects_the_forced_include_the_script_records(
    tmp_path: Path,
) -> None:
    # With options.h in the caller's directory, the compiler run from there
    # selects it ahead of first/ and second/, and so does the scratch compile
    # given the absolute path the script records.
    toolchain = real_toolchain()
    caller = tmp_path / "caller"
    write_overlapping_headers(caller)
    (caller / "options.h").write_text("#define RACE_VALUE 33\n")
    kernel = caller / "forced.hip"
    kernel.write_text("__attribute__((used)) __device__ int value = RACE_VALUE;\n")
    direct = caller / "direct.s"
    compile_directly(toolchain, kernel=kernel, out=direct)
    flags = regen.absolute_flags(OVERLAPPING_FLAGS, caller)
    assert flags[-1] == str(caller / "options.h")
    regenerated = tmp_path / "regenerated.s"
    regen.compile_device_asm(
        kernel=kernel,
        target="gfx950",
        out=regenerated,
        extra_flags=flags,
        toolchain=toolchain,
    )
    assert compiled_value(direct.read_text()) == "33"
    assert compiled_value(regenerated.read_text()) == "33"


# --- The path-flag contract -----------------------------------------------------
#
# The compile runs in a scratch directory. Relative paths are supported for -I,
# -iquote, -isystem and -include, which the script resolves against the caller's
# directory. Every other path-taking option the script knows must be given an
# absolute path; a relative one is rejected rather than resolved in the wrong
# directory. Two kinds of argument are kept as written: a value clang reads as
# relative to the sysroot (-I=/usr/include), and an argument forwarded with
# -Xclang, -Xpreprocessor, -Xarch_* or -mllvm, whose path must be absolute.
# Anything that only starts like a path option is rejected by name. Every other
# argument must be a plain option that cannot carry a path; aliases, response
# files and input files are rejected.

UNSUPPORTED_RELATIVE = {
    "-idirafter": (["-idirafter", "include"], "-idirafter include"),
    "--include-directory": (
        ["--include-directory=include"],
        "--include-directory include",
    ),
    "-include-pch": (["-include-pch", "x.pch"], "-include-pch x.pch"),
    "-imacros": (["-imacros", "macros.h"], "-imacros macros.h"),
}


@pytest.mark.parametrize(
    "flags, named", UNSUPPORTED_RELATIVE.values(), ids=UNSUPPORTED_RELATIVE.keys()
)
def test_relative_path_for_an_unsupported_option_is_rejected(
    tmp_path: Path, flags: list[str], named: str
) -> None:
    with pytest.raises(
        regen.UsageError,
        match=f"{re.escape(named)}: relative paths are supported only for -I, "
        f"-iquote, -isystem and -include",
    ):
        regen.absolute_flags(flags, tmp_path)


def test_absolute_path_for_an_unsupported_option_is_kept(tmp_path: Path) -> None:
    # -include-pch is its own option, not -include with a value of "-pch".
    for flags in (
        ["-idirafter", "/abs/include"],
        ["--include-directory=/abs/include"],
        ["-include-pch", "/abs/x.pch"],
    ):
        assert regen.absolute_flags(flags, tmp_path) == flags


def test_unsupported_relative_option_is_a_usage_error(
    manifest: Manifest,
    corpus_main: CorpusMain,
    tmp_path: Path,
    capsys: pytest.CaptureFixture[str],
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    with pytest.raises(SystemExit) as exit_info:
        run("--cxxflags=-idirafter include")
    # argparse's own status for a usage error, not an ExitCode.
    assert exit_info.value.code == 2
    assert "give an absolute path" in capsys.readouterr().err
    assert compiler_invocations(tmp_path) == []
    assert not (committed / "gfx950").exists()


# Valid absolute inputs the parser must keep exactly as written: the "="
# spelling of options defined with it, values clang reads as relative to the
# sysroot, and arguments forwarded to the compiler front end, whose boundaries
# must not shift.
KEPT_AS_WRITTEN = {
    "-resource-dir=": ["-resource-dir=/abs/resource"],
    "--sysroot=": ["--sysroot=/abs/sysroot"],
    "--include-directory=": ["--include-directory=/abs/include"],
    "-I= sysroot-relative": ["-I=/usr/include"],
    "-isystem = sysroot-relative": ["-isystem", "=/usr/include"],
    "-Xclang -iquote, separate": ["-Xclang", "-iquote", "-Xclang", "/abs/include"],
    "-Xclang -iquote, glued": ["-Xclang", "-iquote/abs/include"],
    "-Xclang, not a path": ["-Xclang", "-fno-pch-timestamp"],
    "-mllvm, not a path": ["-mllvm", "-amdgpu-early-inline-all"],
    "-Xpreprocessor -iquote, separate": [
        "-Xpreprocessor",
        "-iquote",
        "-Xpreprocessor",
        "/abs/include",
    ],
    "-iframework, glued absolute": ["-iframework/abs/include"],
    "not a path option": ["-O1", "-DX=1", "-Wall", "-ffast-math"],
    "every accepted plain form": [
        "-O0",
        "-O3",
        "-Ofast",
        "-DNAME",
        '-DPATH="a/b"',
        "-UNAME",
        "-Wno-unused-variable",
        "-Werror=unused-variable",
        "-fno-inline",
        "-mcumode",
        "-mno-wavefrontsize64",
        "-std=c++20",
        "-save-temps",
    ],
}


# Arguments the parser cannot classify safely: an option that only starts like a
# path option, a path option spelled in a way the script does not accept, or a
# forwarding option it does not follow. Each is rejected by name, not read as a
# path option with a glued value.
UNSUPPORTED_ARGUMENTS = {
    # Aliases of the path options, which the script does not interpret.
    "--include=": (["--include=opt.h"], "--include=opt.h"),
    "--imacros=": (["--imacros=opt.h"], "--imacros=opt.h"),
    "-cxx-isystem": (["-cxx-isystem", "include"], "-cxx-isystem"),
    # A response file, whose arguments the script cannot see.
    "@ relative": (["@flags.rsp"], "@flags.rsp"),
    "@ absolute": (["@/abs/flags.rsp"], "@/abs/flags.rsp"),
    # Debug info, which embeds the scratch compile directory.
    "-g": (["-g"], "-g"),
    "-gdwarf-5": (["-gdwarf-5"], "-gdwarf-5"),
    # An input file, and plain options whose value can be a path.
    "input file": (["extra.hip"], "extra.hip"),
    "-f with a value": (
        ["-fprofile-instr-use=prof.profdata"],
        "-fprofile-instr-use=prof.profdata",
    ),
    "--include-directory-after=": (
        ["--include-directory-after=/abs/include"],
        "--include-directory-after=/abs/include",
    ),
    "-iframeworkwithsysroot": (
        ["-iframeworkwithsysroot", "/abs/include"],
        "-iframeworkwithsysroot",
    ),
    "-idirafter glued relative": (["-idirafterinclude"], "-idirafterinclude"),
    "-Xassembler": (["-Xassembler", "-mcpu=gfx950"], "-Xassembler"),
    "-Wp,": (["-Wp,-I,include"], "-Wp,-I,include"),
}


@pytest.mark.parametrize(
    "flags, argument", UNSUPPORTED_ARGUMENTS.values(), ids=UNSUPPORTED_ARGUMENTS.keys()
)
def test_unsupported_argument_is_rejected_by_name(
    tmp_path: Path, flags: list[str], argument: str
) -> None:
    with pytest.raises(
        regen.UsageError,
        match=f"{re.escape(argument)}: not an option or spelling this script supports",
    ):
        regen.absolute_flags(flags, tmp_path)


# --include=opt.h and a response file selecting it, with a second header that
# a scratch compile would select instead. Each is rejected before compiling.
def write_selectable_headers(caller: Path) -> Path:
    """opt.h (11) in *caller*, and second/opt.h (22). Returns second/."""
    (caller / "opt.h").write_text("#define RACE_VALUE 11\n")
    (caller / "second").mkdir()
    (caller / "second" / "opt.h").write_text("#define RACE_VALUE 22\n")
    return caller / "second"


def compile_from(toolchain: regen.Toolchain, caller: Path, flags: list[str]) -> str:
    """The value a kernel compiled directly from *caller* with *flags* selects."""
    kernel = caller / "selected.hip"
    kernel.write_text("__attribute__((used)) __device__ int value = RACE_VALUE;\n")
    out = caller / "selected.s"
    subprocess.run(
        [str(toolchain.compiler), f"--rocm-path={toolchain.root}", "-O3", "-x", "hip"]
        + ["-S", "--cuda-device-only", "--offload-arch=gfx950", *flags]
        + [str(kernel), "-o", str(out)],
        cwd=caller,
        check=True,
        capture_output=True,
        env=regen.compiler_environment(toolchain.root),
    )
    return compiled_value(out.read_text())


@pytest.mark.parametrize("form", ["alias", "response file"])
def test_real_compiler_form_the_script_cannot_interpret_is_rejected(
    tmp_path: Path, form: str
) -> None:
    toolchain = real_toolchain()
    caller = tmp_path / "caller"
    caller.mkdir()
    second = write_selectable_headers(caller)
    if form == "alias":
        flags = ["--include=opt.h", f"-I{second}"]
    else:
        response = caller / "flags.rsp"
        response.write_text(f"-include opt.h -I{second}\n")
        flags = [f"@{response}"]
    # Directly, from the caller's directory, the caller's opt.h is selected.
    assert compile_from(toolchain, caller=caller, flags=flags) == "11"
    # A scratch compile would select second/opt.h, so the form is rejected.
    with pytest.raises(regen.UsageError, match="not an option or spelling"):
        regen.absolute_flags(flags, caller)


def test_response_file_is_rejected_before_compiling(
    manifest: Manifest,
    corpus_main: CorpusMain,
    tmp_path: Path,
    capsys: pytest.CaptureFixture[str],
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    (tmp_path / "flags.rsp").write_text("-Iinclude\n")
    with pytest.raises(SystemExit) as exit_info:
        run(f"--cxxflags=@{tmp_path / 'flags.rsp'}")
    # argparse's own status for a usage error, not an ExitCode.
    assert exit_info.value.code == 2
    assert "not an option or spelling" in capsys.readouterr().err
    assert compiler_invocations(tmp_path) == []
    assert not (committed / "gfx950").exists()


@pytest.mark.parametrize("flags", KEPT_AS_WRITTEN.values(), ids=KEPT_AS_WRITTEN.keys())
def test_valid_flags_are_kept_as_written(tmp_path: Path, flags: list[str]) -> None:
    assert regen.absolute_flags(flags, tmp_path) == flags


REJECTED_RELATIVE = {
    "-resource-dir=": (["-resource-dir=resource"], "-resource-dir resource"),
    "-Xclang -iquote, separate": (
        ["-Xclang", "-iquote", "-Xclang", "include"],
        "-Xclang -iquote include",
    ),
    "-Xclang -iquote, glued": (
        ["-Xclang", "-iquoteinclude"],
        "-Xclang -iquote include",
    ),
}


@pytest.mark.parametrize(
    "flags, named", REJECTED_RELATIVE.values(), ids=REJECTED_RELATIVE.keys()
)
def test_relative_path_in_an_unsupported_spelling_is_rejected(
    tmp_path: Path, flags: list[str], named: str
) -> None:
    with pytest.raises(regen.UsageError, match=f"{re.escape(named)}: "):
        regen.absolute_flags(flags, tmp_path)


def resource_dir(toolchain: regen.Toolchain) -> str:
    """The resource directory of the SDK's clang."""
    clang = toolchain.root / "llvm" / "bin" / "clang"
    return subprocess.check_output(
        [str(clang), "-print-resource-dir"], text=True
    ).strip()


@pytest.mark.parametrize("spelling", ["equals", "separate"])
def test_real_compiler_accepts_an_absolute_resource_dir(
    tmp_path: Path, spelling: str
) -> None:
    toolchain = real_toolchain()
    directory = resource_dir(toolchain)
    flags = (
        [f"-resource-dir={directory}"]
        if spelling == "equals"
        else ["-resource-dir", directory]
    )
    assert regen.absolute_flags(flags, tmp_path) == flags
    kernel = tmp_path / "kernel.hip"
    kernel.write_text("__attribute__((used)) __device__ int value = 5;\n")
    out = tmp_path / "kernel.s"
    regen.compile_device_asm(
        kernel=kernel, target="gfx950", out=out, extra_flags=flags, toolchain=toolchain
    )
    assert compiled_value(out.read_text()) == "5"


@pytest.mark.parametrize("forwarding", ["-Xclang", "-Xpreprocessor"])
def test_real_compiler_selects_a_header_through_a_forwarded_iquote(
    tmp_path: Path, forwarding: str
) -> None:
    # The forwarding boundaries are kept, and the kernel's quoted include is
    # found only through the forwarded -iquote.
    toolchain = real_toolchain()
    include = tmp_path / "forwarded"
    include.mkdir()
    (include / "forwarded.h").write_text("#define RACE_VALUE 44\n")
    kernel = tmp_path / "kernel" / "forwarded.hip"
    kernel.parent.mkdir()
    kernel.write_text(
        '#include "forwarded.h"\n'
        "__attribute__((used)) __device__ int value = RACE_VALUE;\n"
    )
    flags = [forwarding, "-iquote", forwarding, str(include)]
    assert regen.absolute_flags(flags, tmp_path) == flags
    out = tmp_path / "forwarded.s"
    regen.compile_device_asm(
        kernel=kernel, target="gfx950", out=out, extra_flags=flags, toolchain=toolchain
    )
    assert compiled_value(out.read_text()) == "44"


def test_every_long_path_option_takes_an_equals_value(tmp_path: Path) -> None:
    # The "=" spelling is derived from the option table, so a --option added
    # there accepts it without a second list to update.
    long_options = [f for f in regen._ABSOLUTE_PATH_FLAGS if f.startswith("--")]
    assert long_options
    for option in [*long_options, "-resource-dir"]:
        flags = [f"{option}=/abs/path"]
        assert regen.absolute_flags(flags, tmp_path) == flags


# --- The baseline recipe is explicit -------------------------------------------
#
# hipcc adds -O3 and -x hip itself; the documented clang++ fallback does not. So
# the compile passes them explicitly, before --cxxflags, and both compilers build
# the pinned assembly the same way.


@pytest.mark.parametrize("sdk_compiler", ["bin/hipcc", "llvm/bin/clang++"])
def test_baseline_recipe_is_passed_to_either_compiler(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    sdk_compiler: str,
) -> None:
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    # An SDK with only this compiler, found by the script's own discovery.
    sdk = tmp_path / "sdk"
    (sdk / sdk_compiler).parent.mkdir(parents=True)
    compiler = write_fake_compiler(sdk / sdk_compiler, "output")
    monkeypatch.setenv("ROCM_PATH", str(sdk))
    monkeypatch.setattr(regen, "select_toolchain", SELECT_TOOLCHAIN)
    assert run() == regen.ExitCode.SUCCESS
    (argv,) = compiler_invocations(compiler.parent, compiler.name)
    assert "-O3" in argv
    assert argv[argv.index("-x") + 1] == "hip"
    # -x applies to the files after it, so it has to precede the kernel.
    assert argv.index("-x") < next(
        i for i, arg in enumerate(argv) if arg.endswith(".hip")
    )


def test_cxxflags_come_after_the_baseline_recipe(
    manifest: Manifest, corpus_main: CorpusMain, tmp_path: Path
) -> None:
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    assert run("--cxxflags=-O1") == regen.ExitCode.SUCCESS
    (argv,) = compiler_invocations(tmp_path)
    # The last -O wins, so --cxxflags can still override the baseline.
    assert argv.index("-O3") < argv.index("-O1")


# --- Only recorded inputs reach the compiler -----------------------------------
#
# hipcc appends HIPCC_COMPILE_FLAGS_APPEND to every compile, clang edits its own
# command line from CCC_OVERRIDE_OPTIONS, CPATH and its relatives add header
# directories, and hipcc's HIP_* variables point it at another SDK's parts. None
# of them is recorded in recipe.toml, so they are removed from the compile's
# environment, with a note, and ROCM_PATH names the selected SDK. Flags and
# include directories go through --cxxflags, which is recorded.


@pytest.mark.parametrize("variable", UNRECORDED_VARIABLES)
def test_unrecorded_variable_does_not_reach_the_compiler(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    capsys: pytest.CaptureFixture[str],
    variable: str,
) -> None:
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    monkeypatch.setenv(variable, "/elsewhere")
    monkeypatch.setenv("RACE_UNRELATED", "kept")
    assert run() == regen.ExitCode.SUCCESS
    (environment,) = compiler_environments(tmp_path)
    assert environment[variable] is None
    # Only the unrecorded variables are removed.
    assert environment["RACE_UNRELATED"] == "kept"
    err = capsys.readouterr().err
    assert variable in err and "--cxxflags" in err


def test_compile_sees_the_selected_sdk_as_rocm_path(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
) -> None:
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    monkeypatch.setenv("ROCM_PATH", str(tmp_path / "another-sdk"))
    assert run() == regen.ExitCode.SUCCESS
    (environment,) = compiler_environments(tmp_path)
    assert environment["ROCM_PATH"] == str(tmp_path / "rocm")


def test_clean_environment_prints_no_note(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    for variable in list(os.environ):
        if variable in UNRECORDED_VARIABLES or variable.startswith(("HIP_", "HIPCC_")):
            monkeypatch.delenv(variable)
    assert run() == regen.ExitCode.SUCCESS
    assert "ignoring" not in capsys.readouterr().err


def test_header_selection_cannot_change_under_the_same_recipe(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
) -> None:
    # A CPATH header that would shadow the SDK's, and switch optimization off,
    # must not change what is built while the recipe stays the same: the compile
    # runs with the same arguments and environment with or without it.
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    assert run() == regen.ExitCode.SUCCESS
    recipe_without = read_recipe(committed, "gfx950")
    shadow = tmp_path / "shadow"
    shadow.mkdir()
    (shadow / "hip_runtime.h").write_text("#pragma clang optimize off\n")
    monkeypatch.setenv("CPATH", str(shadow))
    assert run() == regen.ExitCode.SUCCESS
    assert read_recipe(committed, "gfx950") == recipe_without
    # Each compile writes to its own scratch file; everything else is the same.
    without, with_shadow = (
        [arg for arg in argv if "race-asm-compile-" not in arg]
        for argv in compiler_invocations(tmp_path)
    )
    assert without == with_shadow
    environment_without, environment_with_shadow = compiler_environments(tmp_path)
    assert environment_without == environment_with_shadow


# --- The recipe is recorded beside the pinned assembly ----------------------------
#
# .ident names the compiler, but not the SDK or the flags. Regeneration writes
# asm/<target>/recipe.toml, and --check compares it, so a changed recipe can be
# told apart from a toolchain update.


def read_recipe(committed: Path, target: str) -> dict[str, object]:
    return tomllib.loads((committed / target / "recipe.toml").read_text())


def set_rocm_release(tmp_path: Path, release: str) -> None:
    info = tmp_path / "rocm" / ".info"
    info.mkdir(parents=True, exist_ok=True)
    (info / "version").write_text(f"{release}\n")


def test_regeneration_records_the_recipe(
    manifest: Manifest, corpus_main: CorpusMain, tmp_path: Path
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    set_rocm_release(tmp_path, "7.3.0")
    assert run("--cxxflags=-DX=1") == regen.ExitCode.SUCCESS
    assert read_recipe(committed, "gfx950") == {
        "compiler": "fake-hipcc",
        "compiler_version": "fake clang version 1.0",
        "rocm_release": "7.3.0",
        # The fake SDK was not installed as a Python distribution.
        "rocm_build": "unknown",
        "flags": ["-O3", "-x", "hip", "-DX=1"],
    }


def test_regenerating_one_target_records_only_its_recipe(
    manifest: Manifest, corpus_main: CorpusMain
) -> None:
    run, committed = corpus_main
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    assert run("--target", "gfx1250") == regen.ExitCode.SUCCESS
    assert (committed / "gfx1250" / "recipe.toml").is_file()
    assert not (committed / "gfx950" / "recipe.toml").exists()


def test_check_does_not_rewrite_the_committed_recipe(
    manifest: Manifest, corpus_main: CorpusMain
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    before = (committed / "gfx950" / "recipe.toml").read_text()
    run("--check", "--cxxflags=-DX=1")
    assert (committed / "gfx950" / "recipe.toml").read_text() == before


def test_check_reports_an_unchanged_recipe(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    capsys.readouterr()
    assert run("--check") == regen.ExitCode.SUCCESS
    assert "gfx950: recipe unchanged" in capsys.readouterr().out


def test_check_reports_changed_flags_as_a_recipe_change(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    capsys.readouterr()
    run("--check", "--cxxflags=-DX=1")
    out = capsys.readouterr().out
    assert "gfx950: recipe changed: flags" in out and "-DX=1" in out
    assert "toolchain changed" not in out


def test_check_reports_a_new_compiler_as_a_toolchain_change(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    capsys: pytest.CaptureFixture[str],
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    set_rocm_release(tmp_path, "7.3.0")
    commit_fresh_output(run, committed)
    monkeypatch.setenv("FAKE_COMPILER_VERSION", "fake clang version 2.0")
    set_rocm_release(tmp_path, "7.4.0")
    capsys.readouterr()
    run("--check")
    out = capsys.readouterr().out
    assert "gfx950: toolchain changed" in out
    assert "fake clang version 2.0" in out and "7.4.0" in out
    assert "recipe changed" not in out


def test_check_without_a_committed_recipe_says_so(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    (committed / "gfx950" / "recipe.toml").unlink()
    capsys.readouterr()
    assert run("--check") == regen.ExitCode.SUCCESS
    assert "gfx950: no recipe.toml committed" in capsys.readouterr().out


# --- An invalid committed recipe is reported, not raised -----------------------------


@pytest.mark.parametrize("text, problem", BAD_RECIPES.values(), ids=BAD_RECIPES.keys())
def test_check_reports_an_invalid_committed_recipe(
    manifest: Manifest,
    corpus_main: CorpusMain,
    capsys: pytest.CaptureFixture[str],
    text: str,
    problem: str,
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    (committed / "gfx950" / "recipe.toml").write_text(text)
    capsys.readouterr()
    # The recipe comparison is informational: the assembly still matches.
    assert run("--check") == regen.ExitCode.SUCCESS
    out = capsys.readouterr().out
    assert "gfx950: recipe.toml cannot be compared" in out
    assert problem in out


# --- A target's listings and recipe are replaced together, or not at all --------
#
# The recipe describes every listing beside it. So a run replaces a target's
# assembly only when every case for that target compiled, and writes the recipe
# with it; a failed or skipped case leaves the whole target as it was.


def seed_target(committed: Path, target: str, kernels: list[str]) -> None:
    """
    A committed target directory: an old listing per kernel, and GOOD's recipe,
    which the fake compiler never reproduces.
    """
    (committed / target).mkdir(parents=True, exist_ok=True)
    for kernel in kernels:
        (committed / target / f"{kernel}.s").write_text(f"old {kernel}\n")
    (committed / target / "recipe.toml").write_text(GOOD_TEXT)


def assert_untouched(committed: Path, target: str, kernels: list[str]) -> None:
    for kernel in kernels:
        assert (committed / target / f"{kernel}.s").read_text() == f"old {kernel}\n"
    assert regen.recipe.load(committed / target / "recipe.toml") == GOOD


def test_partial_skip_leaves_the_target_as_it_was(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE + ROCWMMA_CASE)
    seed_target(committed, "gfx950", ["kernel", "wmma"])
    assert run("--cxxflags=-O1") == regen.ExitCode.INCOMPLETE
    assert_untouched(committed, "gfx950", ["kernel", "wmma"])
    assert "gfx950: not updated" in capsys.readouterr().err


def test_partial_failure_leaves_the_target_as_it_was(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE + '[[case]]\nid = "only"\nkernel = "only"\n')
    seed_target(committed, "gfx950", ["kernel", "only"])
    monkeypatch.setenv("FAKE_COMPILER_FAIL", "only")
    assert run("--cxxflags=-O1") == regen.ExitCode.COMPILE_FAILED
    assert_untouched(committed, "gfx950", ["kernel", "only"])
    assert "gfx950: not updated" in capsys.readouterr().err


def test_all_skipped_run_leaves_the_recipe_as_it_was(
    manifest: Manifest, corpus_main: CorpusMain
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], ROCWMMA_CASE)
    seed_target(committed, "gfx950", ["wmma"])
    assert run("--cxxflags=-O1") == regen.ExitCode.INCOMPLETE
    assert_untouched(committed, "gfx950", ["wmma"])


def test_complete_target_is_written_while_a_blocked_one_is_kept(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, committed = corpus_main
    manifest(
        ["gfx950", "gfx1250"],
        PORTABLE_CASE + ROCWMMA_CASE.replace("targets = []", 'targets = ["gfx1250"]'),
    )
    seed_target(committed, "gfx950", ["kernel"])
    seed_target(committed, "gfx1250", ["kernel", "wmma"])
    assert run("--cxxflags=-O1") == regen.ExitCode.INCOMPLETE
    # gfx950 compiled completely: its listing and its recipe are both new.
    assert "s_endpgm" in (committed / "gfx950" / "kernel.s").read_text()
    assert regen.recipe.load(committed / "gfx950" / "recipe.toml").flags[-1] == "-O1"
    # gfx1250 skipped a case, so nothing in it changed.
    assert_untouched(committed, "gfx1250", ["kernel", "wmma"])
    err = capsys.readouterr().err
    assert "gfx1250: not updated" in err and "gfx950: not updated" not in err


def test_removed_case_is_removed_from_its_target(
    manifest: Manifest, corpus_main: CorpusMain
) -> None:
    # A target is published with exactly the listings its cases produce, so a
    # removed case's listing cannot stay behind under the new recipe.
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    seed_target(committed, "gfx950", ["kernel", "removed"])
    assert run("--cxxflags=-O1") == regen.ExitCode.SUCCESS
    assert sorted(p.name for p in (committed / "gfx950").iterdir()) == [
        "kernel.s",
        "recipe.toml",
    ]


def test_narrowed_case_is_removed_from_targets_it_no_longer_builds_for(
    manifest: Manifest, corpus_main: CorpusMain
) -> None:
    run, committed = corpus_main
    manifest(
        ["gfx950", "gfx1250"],
        PORTABLE_CASE
        + '[[case]]\nid = "only"\nkernel = "only"\ntargets = ["gfx1250"]\n',
    )
    seed_target(committed, "gfx950", ["kernel", "only"])
    assert run() == regen.ExitCode.SUCCESS
    assert sorted(p.name for p in (committed / "gfx950").iterdir()) == [
        "kernel.s",
        "recipe.toml",
    ]
    assert (committed / "gfx1250" / "only.s").is_file()


def test_narrowing_the_last_case_empties_its_old_target(
    manifest: Manifest, corpus_main: CorpusMain
) -> None:
    # The only case builds for both targets, then is narrowed to gfx1250. No
    # case builds for gfx950 any more, so gfx950 is published with no listings:
    # its old listing goes, and its recipe is the new one.
    run, committed = corpus_main
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    assert run() == regen.ExitCode.SUCCESS
    assert (committed / "gfx950" / "kernel.s").is_file()
    manifest(
        ["gfx950", "gfx1250"],
        PORTABLE_CASE.replace("targets = []", 'targets = ["gfx1250"]'),
    )
    assert run("--cxxflags=-DNARROWED") == regen.ExitCode.SUCCESS
    assert sorted(p.name for p in (committed / "gfx950").iterdir()) == ["recipe.toml"]
    assert (
        regen.recipe.load(committed / "gfx950" / "recipe.toml").flags[-1]
        == "-DNARROWED"
    )
    assert (committed / "gfx1250" / "kernel.s").is_file()


def test_failed_publication_keeps_the_old_target(
    manifest: Manifest, corpus_main: CorpusMain, monkeypatch: pytest.MonkeyPatch
) -> None:
    # The disk fills while the second listing is staged: the target keeps its
    # old listings and recipe, and no staging directory is left behind.
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE + '[[case]]\nid = "only"\nkernel = "only"\n')
    seed_target(committed, "gfx950", ["kernel", "only"])
    copies: list[Path] = []
    real_copyfile = regen.shutil.copyfile

    def copy_until_the_disk_is_full(source: Path, destination: Path) -> Path:
        copies.append(source)
        if len(copies) == 2:
            raise OSError(errno.ENOSPC, "No space left on device")
        return real_copyfile(source, destination)

    monkeypatch.setattr(regen.shutil, "copyfile", copy_until_the_disk_is_full)
    with pytest.raises(OSError, match="No space left on device"):
        run("--cxxflags=-O1")
    assert_untouched(committed, "gfx950", ["kernel", "only"])
    assert [p.name for p in committed.iterdir()] == ["gfx950"]


def test_failed_swap_restores_the_old_target(
    manifest: Manifest, corpus_main: CorpusMain, monkeypatch: pytest.MonkeyPatch
) -> None:
    # The old target is moved aside, and then moving the staged one into place
    # fails: the old target is moved back.
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    seed_target(committed, "gfx950", ["kernel"])
    renames: list[Path] = []
    real_rename = regen.os.rename

    def fail_the_second_rename(source: Path, destination: Path) -> None:
        renames.append(Path(source))
        if len(renames) == 2:
            raise OSError(errno.EIO, "Input/output error")
        real_rename(source, destination)

    monkeypatch.setattr(regen.os, "rename", fail_the_second_rename)
    with pytest.raises(OSError, match="Input/output error"):
        run("--cxxflags=-O1")
    monkeypatch.setattr(regen.os, "rename", real_rename)
    assert_untouched(committed, "gfx950", ["kernel"])
    assert [p.name for p in committed.iterdir()] == ["gfx950"]


# --- The recipe names the SDK build ----------------------------------------------
#
# .info/version has only the release, such as 10.1.0, which two builds can share
# along with their clang revision. A pip-installed SDK's build, such as
# 10.1.0a20260822, is the version of the distributions that installed it, read
# from the selected installation itself, so it does not depend on PATH or on how
# the root was named.

REAL_ROCM_PATH = regen.rocm_path


def pip_sdk(tmp_path: Path, versions: dict[str, str]) -> Path:
    """
    A pip-installed SDK under a scratch site-packages: its root, with release
    10.1.0, and one distribution per entry of *versions* installing files in it.
    """
    site = tmp_path / "site-packages"
    root = site / "_rocm_sdk_devel"
    (root / ".info").mkdir(parents=True)
    (root / ".info" / "version").write_text("10.1.0\n")
    (root / "bin").mkdir()
    for name, version in versions.items():
        # importlib.metadata lists only the recorded files that exist.
        (root / "bin" / name).write_text("")
        dist = site / f"{name.replace('-', '_')}-{version}.dist-info"
        dist.mkdir()
        (dist / "METADATA").write_text(
            f"Metadata-Version: 2.1\nName: {name}\nVersion: {version}\n"
        )
        (dist / "RECORD").write_text(
            f"_rocm_sdk_devel/bin/{name},,\n{dist.name}/RECORD,,\n"
        )
    return root


def install_fake_rocm_sdk(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, root: Path
) -> None:
    """Put only a rocm-sdk that reports *root* as its path on PATH."""
    tool = write_script(
        tmp_path / "rocm-sdk-bin" / "rocm-sdk", f"print({str(root)!r})\n"
    )
    prepend_to_path(monkeypatch, tool.parent, only=True)


def test_build_comes_from_the_distributions_that_installed_the_sdk(
    tmp_path: Path,
) -> None:
    root = pip_sdk(
        tmp_path, {"rocm-sdk-devel": "10.1.0a1", "rocm-sdk-device-gfx950": "10.1.0a1"}
    )
    assert regen.sdk_build(root) == "10.1.0a1"
    assert regen.sdk_release(root) == "10.1.0"


def test_mixed_builds_are_each_recorded(tmp_path: Path) -> None:
    root = pip_sdk(
        tmp_path, {"rocm-sdk-devel": "10.1.0a1", "rocm-sdk-device-gfx950": "10.1.0a2"}
    )
    assert (
        regen.sdk_build(root)
        == "rocm-sdk-devel==10.1.0a1, rocm-sdk-device-gfx950==10.1.0a2"
    )


def test_sdk_outside_a_distribution_has_an_unknown_build(tmp_path: Path) -> None:
    root = tmp_path / "opt-rocm"
    root.mkdir()
    assert regen.sdk_build(root) == regen.recipe.UNKNOWN
    assert regen.sdk_release(root) == regen.recipe.UNKNOWN


def test_build_is_found_through_a_symlinked_rocm_path_without_rocm_sdk(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    root = pip_sdk(tmp_path, {"rocm-sdk-devel": "10.1.0a1"})
    link = tmp_path / "rocm-link"
    link.symlink_to(root)
    monkeypatch.setenv("ROCM_PATH", str(link))
    prepend_to_path(monkeypatch, tmp_path / "empty-bin", only=True)
    selected = REAL_ROCM_PATH()
    assert selected == root
    assert regen.sdk_build(selected) == "10.1.0a1"


def test_build_is_found_through_rocm_sdk_discovery(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    root = pip_sdk(tmp_path, {"rocm-sdk-devel": "10.1.0a1"})
    link = tmp_path / "rocm-link"
    link.symlink_to(root)
    monkeypatch.delenv("ROCM_PATH", raising=False)
    install_fake_rocm_sdk(monkeypatch, tmp_path, link)
    selected = REAL_ROCM_PATH()
    assert selected == root
    assert regen.sdk_build(selected) == "10.1.0a1"


# --- Comparing builds -------------------------------------------------------------
#
# A build is compared only when both recipes know it. An unknown build is not a
# toolchain change: it says the builds cannot be told apart.


def test_unknown_build_is_incomparable_not_changed() -> None:
    notes = regen.describe_change(
        target="gfx950",
        committed=GOOD,
        current=dataclasses.replace(GOOD, rocm_build="unknown"),
    )
    assert notes == [
        "gfx950: SDK build cannot be compared: '10.1.0a20260822' -> 'unknown'"
    ]


def test_changed_build_is_a_toolchain_change() -> None:
    notes = regen.describe_change(
        target="gfx950",
        committed=GOOD,
        current=dataclasses.replace(GOOD, rocm_build="10.1.0a2"),
    )
    assert notes == [
        "gfx950: toolchain changed: rocm_build '10.1.0a20260822' -> '10.1.0a2'"
    ]


def test_changed_release_is_a_toolchain_change_even_without_builds() -> None:
    current = dataclasses.replace(GOOD, rocm_release="10.2.0", rocm_build="unknown")
    notes = regen.describe_change(target="gfx950", committed=GOOD, current=current)
    assert "gfx950: toolchain changed: rocm_release '10.1.0' -> '10.2.0'" in notes
    assert (
        "gfx950: SDK build cannot be compared: '10.1.0a20260822' -> 'unknown'" in notes
    )


@pytest.mark.parametrize("record", ["Build", "RegenerateResult"])
def test_records_are_frozen_dataclasses_of_immutable_fields(record: str) -> None:
    # Like the inventory and recipe records: frozen, and with tuples rather
    # than lists, so no field can be changed in place either.
    record_type = getattr(regen, record)
    assert dataclasses.is_dataclass(record_type)
    assert record_type.__dataclass_params__.frozen
    hints = typing.get_type_hints(record_type)
    assert not any(typing.get_origin(hint) is list for hint in hints.values())


# --- Errors are raised by helpers, and turned into exit codes by main -------------
#
# Helpers raise: SetupError when the inventory or the toolchain cannot be used,
# UsageError for an invalid argument. main reports the first as exit 4 and the
# second through argparse. A failing rocm-sdk or compiler is reported, not
# replaced by a fallback.


def test_invalid_inventory_exits_with_setup_failed(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE + "ordinal = 3\n")
    assert run() == regen.ExitCode.SETUP_FAILED
    assert (
        "error: cases.toml [portable]: unknown field 'ordinal'"
        in capsys.readouterr().err
    )


def test_target_outside_the_corpus_is_a_usage_error(
    manifest: Manifest, corpus_main: CorpusMain, capsys: pytest.CaptureFixture[str]
) -> None:
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    with pytest.raises(SystemExit) as exit_info:
        run("--target", "gfx1201")
    # argparse's own status for a usage error, not an ExitCode.
    assert exit_info.value.code == 2
    assert "gfx1201 is not in [corpus] targets" in capsys.readouterr().err


def test_check_can_be_switched_off_explicitly(
    manifest: Manifest, corpus_main: CorpusMain
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    assert run("--no-check") == regen.ExitCode.SUCCESS
    assert (committed / "gfx950" / "kernel.s").is_file()


def test_failing_rocm_sdk_is_reported_rather_than_skipped(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    tool = write_script(
        tmp_path / "rocm-sdk-bin" / "rocm-sdk",
        "import sys\nprint('no SDK installed')\nsys.exit(1)\n",
    )
    monkeypatch.delenv("ROCM_PATH", raising=False)
    prepend_to_path(monkeypatch, tool.parent, only=True)
    with pytest.raises(
        regen.SetupError, match="rocm-sdk path --root failed .*no SDK installed"
    ):
        REAL_ROCM_PATH()


def test_failing_compiler_version_is_reported_rather_than_unknown(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    tool = write_script(
        tmp_path / "broken-hipcc", "import sys\nprint('cannot start')\nsys.exit(1)\n"
    )
    with pytest.raises(regen.SetupError, match="--version failed .*cannot start"):
        regen.compiler_version(regen.Toolchain(root=tmp_path / "rocm", compiler=tool))


def test_rocm_path_that_is_not_a_directory_is_reported(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    # Falling back to another compiler would only fail every compile against an
    # SDK that is not there.
    monkeypatch.setenv("ROCM_PATH", str(tmp_path / "missing"))
    with pytest.raises(
        regen.SetupError, match="ROCM_PATH .*missing.* is not a directory"
    ):
        REAL_ROCM_PATH()


# --- The compiler always comes from the selected SDK ------------------------------
#
# The recipe records what the compiler reports for --version, and the compile
# runs against the selected SDK. Both must be the SDK's own compiler: a hipcc
# found on PATH can report one clang and build with another. So an SDK without
# bin/hipcc or llvm/bin/clang++ is rejected, whatever is on PATH.


def install_hipcc_on_path(monkeypatch: pytest.MonkeyPatch, tmp_path: Path) -> Path:
    """
    Put a hipcc on PATH that records being run at all, in front of the rest of
    PATH. Returns the file it writes when run.
    """
    ran = tmp_path / "path-hipcc-ran"
    hipcc = write_script(
        tmp_path / "path-bin" / "hipcc",
        "from pathlib import Path\n"
        f"Path({str(ran)!r}).write_text('ran')\n"
        "print('clang version from PATH')\n",
    )
    prepend_to_path(monkeypatch, hipcc.parent)
    return ran


@pytest.fixture
def sdk_without_a_compiler(monkeypatch: pytest.MonkeyPatch, tmp_path: Path) -> Path:
    """Select an SDK with neither bin/hipcc nor llvm/bin/clang++. Returns its root."""
    root = tmp_path / "rocm"
    (root / "include").mkdir(parents=True)
    monkeypatch.setenv("ROCM_PATH", str(root))
    return root


def test_hipcc_on_path_is_not_used_for_an_sdk_without_a_compiler(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, sdk_without_a_compiler: Path
) -> None:
    install_hipcc_on_path(monkeypatch, tmp_path)
    with pytest.raises(regen.SetupError, match="no HIP compiler in the selected SDK"):
        regen.find_hip_compiler(sdk_without_a_compiler)


def test_recipe_is_not_created_from_a_compiler_on_path(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, sdk_without_a_compiler: Path
) -> None:
    ran = install_hipcc_on_path(monkeypatch, tmp_path)
    with pytest.raises(regen.SetupError, match="no HIP compiler in the selected SDK"):
        regen.current_recipe(toolchain=regen.select_toolchain(), extra_flags=[])
    assert not ran.exists()


def test_compile_does_not_use_a_compiler_on_path(
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    sdk_without_a_compiler: Path,
    kernel: Path,
    pinned: Path,
) -> None:
    ran = install_hipcc_on_path(monkeypatch, tmp_path)
    with pytest.raises(regen.SetupError, match="no HIP compiler in the selected SDK"):
        regen.compile_device_asm(
            kernel=kernel,
            target="gfx950",
            out=pinned,
            extra_flags=[],
            toolchain=regen.select_toolchain(),
        )
    assert not ran.exists()
    assert pinned.read_text() == PINNED


def test_run_with_a_compiler_only_on_path_compiles_nothing(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    sdk_without_a_compiler: Path,
    capsys: pytest.CaptureFixture[str],
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    monkeypatch.setattr(regen, "select_toolchain", SELECT_TOOLCHAIN)
    ran = install_hipcc_on_path(monkeypatch, tmp_path)
    assert run() == regen.ExitCode.SETUP_FAILED
    assert "no HIP compiler in the selected SDK" in capsys.readouterr().err
    assert not ran.exists()
    assert not (committed / "gfx950").exists()


def test_recipe_names_the_sdk_compiler_that_compiles(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
) -> None:
    # With a hipcc on PATH as well, the SDK's own clang++ reports the version
    # and compiles every listing.
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    sdk_clang = fake_sdk(tmp_path / "sdk", layout="llvm/bin/clang++")
    monkeypatch.setenv("ROCM_PATH", str(tmp_path / "sdk"))
    monkeypatch.setattr(regen, "select_toolchain", SELECT_TOOLCHAIN)
    ran = install_hipcc_on_path(monkeypatch, tmp_path)
    assert run() == regen.ExitCode.SUCCESS
    assert not ran.exists()
    assert read_recipe(committed, "gfx950")["compiler"] == "clang++"
    (argv,) = compiler_invocations(sdk_clang.parent, sdk_clang.name)
    assert any(arg.endswith("kernel.hip") for arg in argv)


# --- The recipe records the flags the compiler receives ---------------------------
#
# A relative path in --cxxflags is resolved against the directory the script
# runs from, so one spelling can select different files. The recipe records each
# flag as the compiler receives it, with the path made absolute, so changing
# which file a flag selects changes the recipe.


def caller_with_options(tmp_path: Path, name: str, value: int) -> Path:
    """A caller directory holding an options.h that defines VALUE as *value*."""
    caller = tmp_path / name
    (caller / "include").mkdir(parents=True)
    (caller / "options.h").write_text(f"#define VALUE {value}\n")
    return caller


def test_recipe_records_path_flags_as_the_compiler_receives_them(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
) -> None:
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    caller = caller_with_options(tmp_path, name="caller", value=2)
    monkeypatch.chdir(caller)
    assert (
        run("--cxxflags=-include options.h -Iinclude -DX=1") == regen.ExitCode.SUCCESS
    )
    extra = ["-include", str(caller / "options.h"), f"-I{caller / 'include'}", "-DX=1"]
    assert read_recipe(committed, "gfx950")["flags"] == ["-O3", "-x", "hip", *extra]
    (argv,) = compiler_invocations(tmp_path)
    assert argv[-len(extra) :] == extra


def test_header_selected_from_another_directory_changes_the_recipe(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
    capsys: pytest.CaptureFixture[str],
) -> None:
    # The same --cxxflags, run from two directories whose options.h differ,
    # selects different headers, so the recipes differ too.
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    first = caller_with_options(tmp_path, name="first", value=2)
    second = caller_with_options(tmp_path, name="second", value=7)
    monkeypatch.chdir(first)
    assert run("--cxxflags=-include options.h") == regen.ExitCode.SUCCESS
    capsys.readouterr()
    monkeypatch.chdir(second)
    run("--check", "--cxxflags=-include options.h")
    out = capsys.readouterr().out
    assert "gfx950: recipe changed: flags" in out
    assert str(first / "options.h") in out and str(second / "options.h") in out
    assert "recipe unchanged" not in out


# --- The SDK and its compiler are resolved once per run ----------------------------
#
# The recipe and every compile use the same SDK and compiler, resolved once when
# the run starts, rather than each looking them up again.


def test_sdk_is_resolved_once_per_run(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
) -> None:
    run, _ = corpus_main
    manifest(
        ["gfx950", "gfx1250"],
        PORTABLE_CASE + '[[case]]\nid = "only"\nkernel = "only"\n',
    )
    sdk = tmp_path / "sdk"
    fake_sdk(sdk)
    calls = tmp_path / "rocm-sdk-calls"
    tool = write_script(
        tmp_path / "counting-bin" / "rocm-sdk",
        "from pathlib import Path\n"
        f"with Path({str(calls)!r}).open('a') as log:\n"
        "    log.write('call\\n')\n"
        f"print({str(sdk)!r})\n",
    )
    monkeypatch.delenv("ROCM_PATH", raising=False)
    prepend_to_path(monkeypatch, tool.parent)
    monkeypatch.setattr(regen, "select_toolchain", SELECT_TOOLCHAIN)
    assert run() == regen.ExitCode.SUCCESS
    # Four compiles, two cases on two targets, and one lookup.
    assert len(compiler_invocations(sdk / "bin", "hipcc")) == 4
    assert calls.read_text().splitlines() == ["call"]


# --- The default SDK location -----------------------------------------------------


def test_default_sdk_is_used_when_nothing_else_selects_one(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, no_sdk_discovery: None
) -> None:
    default = tmp_path / "opt-rocm"
    default.mkdir()
    monkeypatch.setattr(regen, "_DEFAULT_ROCM_PATH", default)
    assert regen.rocm_path() == default


def test_missing_default_sdk_is_reported(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, no_sdk_discovery: None
) -> None:
    monkeypatch.setattr(regen, "_DEFAULT_ROCM_PATH", tmp_path / "missing")
    with pytest.raises(regen.SetupError, match="no ROCm SDK"):
        regen.rocm_path()


# --- A regeneration reproduces itself --------------------------------------------
#
# Each compile runs in its own scratch directory, so nothing the compiler embeds
# may depend on it. Debug info would (-g is rejected); the accepted forms that
# change codegen must not, so an immediate --check after an update matches.


@pytest.mark.parametrize(
    "cxxflags", [[], ["--cxxflags=-O1"], ["--cxxflags=-save-temps"]]
)
def test_real_compiler_regeneration_then_check_matches(
    manifest: Manifest,
    corpus_main: CorpusMain,
    monkeypatch: pytest.MonkeyPatch,
    cxxflags: list[str],
) -> None:
    real_toolchain()
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    monkeypatch.setattr(regen, "select_toolchain", SELECT_TOOLCHAIN)
    assert run(*cxxflags) == regen.ExitCode.SUCCESS
    assert (committed / "gfx950" / "kernel.s").is_file()
    assert run("--check", *cxxflags) == regen.ExitCode.SUCCESS
