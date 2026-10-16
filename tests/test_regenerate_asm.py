# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
from __future__ import annotations

import dataclasses
import importlib.util
import json
import os
import sys
import textwrap
import tomllib
from pathlib import Path

import pytest

from test_recipe import BAD_RECIPES

REPO_ROOT = Path(__file__).resolve().parents[1]
SCRIPT = REPO_ROOT / "corpus" / "race" / "scripts" / "regenerate_asm.py"


# The scripts import their shared inventory module as a sibling, as they do when
# run directly from scripts/.
sys.path.insert(0, str(SCRIPT.parent))


def load_script():
    spec = importlib.util.spec_from_file_location("regenerate_asm", SCRIPT)
    assert spec is not None
    assert spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules["regenerate_asm"] = module
    spec.loader.exec_module(module)
    return module


regen = load_script()
FIND_HIP_COMPILER = regen.find_hip_compiler

# A case that needs the rocWMMA headers, as inventory.load returns it.
ROCWMMA_RECORD = regen.inventory.Case(
    id="k", kernel="kernel", targets=(), headers=("rocwmma/rocwmma.hpp",)
)
ROCWMMA_INVENTORY = regen.inventory.Inventory(targets=("gfx950",), cases=(ROCWMMA_RECORD,))

PINNED = "; pinned assembly that must survive a failed regeneration\n"


# The variables the fake compiler records from its environment.
WATCHED_ENVIRONMENT = (
    "HIPCC_COMPILE_FLAGS_APPEND",
    "HIPCC_LINK_FLAGS_APPEND",
    "CCC_OVERRIDE_OPTIONS",
    "CPATH",
)


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
      auto-named  ignore -o and write the auto-named file into the working
                  directory, as hipcc sometimes does under --cuda-device-only
    """
    compiler.write_text(
        textwrap.dedent(
            f"""\
            #!{sys.executable}
            import json, os, sys
            args = sys.argv[1:]
            if args == ["--version"]:
                print(os.environ.get("FAKE_COMPILER_VERSION", "fake clang version 1.0"))
                sys.exit(0)
            with open(os.path.abspath(__file__) + ".argv", "a") as log:
                log.write(json.dumps(args) + "\\n")
            with open(os.path.abspath(__file__) + ".env", "a") as log:
                seen = {{name: os.environ.get(name) for name in {WATCHED_ENVIRONMENT!r}}}
                log.write(json.dumps(seen) + "\\n")
            source = next((a for a in args if a.endswith(".hip")), "")
            failing = os.environ.get("FAKE_COMPILER_FAIL")
            if {behaviour!r} == "fail" or (failing and os.path.basename(source) == failing + ".hip"):
                sys.stderr.write("error: unknown argument\\n")
                sys.exit(1)
            text = "kernel:\\n\\ts_endpgm\\n.globl __hip_cuid_0123abcd\\n"
            if {behaviour!r} == "output":
                open(args[args.index("-o") + 1], "w").write(text)
            else:
                source = next(a for a in args if a.endswith(".hip"))
                target = next(a for a in args if a.startswith("--offload-arch="))
                stem = os.path.splitext(os.path.basename(source))[0]
                arch = target.split("=", 1)[1]
                open(f"{{stem}}-hip-amdgcn-amd-amdhsa-{{arch}}.s", "w").write(text)
            """
        )
    )
    compiler.chmod(0o755)
    return compiler


def install_fake_compiler(monkeypatch, tmp_path: Path, behaviour: str) -> None:
    """Make compiler discovery return a fake compiler; see write_fake_compiler."""
    compiler = write_fake_compiler(tmp_path / "fake-hipcc", behaviour)
    monkeypatch.setattr(regen, "find_hip_compiler", lambda: compiler)
    monkeypatch.setattr(regen, "rocm_path", lambda: tmp_path / "rocm")



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
def caller_dir(tmp_path: Path, monkeypatch) -> Path:
    """The directory the script is run from, holding an unrelated stale file."""
    directory = tmp_path / "caller"
    directory.mkdir()
    (directory / "kernel-hip-amdgcn-amd-amdhsa-gfx950.s").write_text("not ours\n")
    monkeypatch.chdir(directory)
    return directory


def test_failed_compile_keeps_pinned_file(monkeypatch, tmp_path, pinned, kernel, caller_dir):
    install_fake_compiler(monkeypatch, tmp_path, "fail")
    with pytest.raises(regen.CompileError):
        regen.compile_device_asm(kernel, "gfx950", pinned, [])
    assert pinned.read_text() == PINNED
    assert [p.name for p in pinned.parent.iterdir()] == ["kernel.s"]  # no staged leftovers
    assert (caller_dir / "kernel-hip-amdgcn-amd-amdhsa-gfx950.s").read_text() == "not ours\n"


def test_successful_compile_replaces_and_normalizes(monkeypatch, tmp_path, pinned, kernel, caller_dir):
    install_fake_compiler(monkeypatch, tmp_path, "output")
    regen.compile_device_asm(kernel, "gfx950", pinned, [])
    text = pinned.read_text()
    assert "s_endpgm" in text
    assert "__hip_cuid_corpus" in text and "__hip_cuid_0123abcd" not in text
    assert [p.name for p in pinned.parent.iterdir()] == ["kernel.s"]


def test_auto_named_output_stays_in_scratch(monkeypatch, tmp_path, pinned, kernel, caller_dir):
    install_fake_compiler(monkeypatch, tmp_path, "auto-named")
    regen.compile_device_asm(kernel, "gfx950", pinned, [])
    assert "s_endpgm" in pinned.read_text()
    # The caller's same-named file is neither consumed nor deleted.
    assert sorted(p.name for p in caller_dir.iterdir()) == ["kernel-hip-amdgcn-amd-amdhsa-gfx950.s"]
    assert (caller_dir / "kernel-hip-amdgcn-amd-amdhsa-gfx950.s").read_text() == "not ours\n"


def test_missing_header_skips_case_and_keeps_pinned_file(monkeypatch, tmp_path, pinned, kernel):
    install_fake_compiler(monkeypatch, tmp_path, "fail")  # must not even be invoked
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    written, failures, skipped = regen.regenerate(
        ROCWMMA_INVENTORY, ["gfx950"], [], pinned.parent.parent
    )
    assert (written, failures) == (0, [])
    assert len(skipped) == 1 and "rocwmma/rocwmma.hpp" in skipped[0]
    assert pinned.read_text() == PINNED


def test_declared_header_found_through_include_flag(monkeypatch, tmp_path, pinned, kernel):
    install_fake_compiler(monkeypatch, tmp_path, "output")
    include = tmp_path / "rocwmma-install" / "include"
    (include / "rocwmma").mkdir(parents=True)
    (include / "rocwmma" / "rocwmma.hpp").write_text("")
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    written, failures, skipped = regen.regenerate(
        ROCWMMA_INVENTORY, ["gfx950"], [f"-I{include}"], pinned.parent.parent
    )
    assert (written, failures, skipped) == (1, [], [])
    assert "s_endpgm" in pinned.read_text()


def test_relative_include_flags_are_made_absolute(tmp_path):
    base = tmp_path / "caller"
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


def assembly(ident: str = "AMD clang version 23 (abc)", wait: str = "s_waitcnt vmcnt(0)") -> str:
    return f'\t.text\nkernel:\n\t{wait}\n\ts_endpgm\n\t.ident\t"{ident}"\n'


@pytest.fixture
def drift_dirs(monkeypatch, tmp_path: Path):
    """(committed, fresh) target directories, with ASM_DIR pointed at committed."""
    committed_root, fresh_root = tmp_path / "committed", tmp_path / "fresh"
    (committed_root / "gfx950").mkdir(parents=True)
    (fresh_root / "gfx950").mkdir(parents=True)
    monkeypatch.setattr(regen, "ASM_DIR", committed_root)
    return committed_root / "gfx950", fresh_root


def check(fresh_root: Path, expected: set[tuple[str, str]] | None = None) -> int:
    """_report_drift for gfx950, expecting by default exactly the generated files."""
    if expected is None:
        expected = {("gfx950", path.name) for path in (fresh_root / "gfx950").glob("*.s")}
    return regen._report_drift(["gfx950"], fresh_root, expected)


def test_check_passes_identical_assembly(drift_dirs):
    committed, fresh_root = drift_dirs
    (committed / "k.s").write_text(assembly())
    (fresh_root / "gfx950" / "k.s").write_text(assembly())
    assert check(fresh_root) == 0


def test_check_reports_ident_only_change_as_provenance_not_drift(drift_dirs, capsys):
    committed, fresh_root = drift_dirs
    (committed / "k.s").write_text(assembly(ident="AMD clang version 23 (abc)"))
    (fresh_root / "gfx950" / "k.s").write_text(assembly(ident="AMD clang version 24 (def)"))
    assert check(fresh_root) == 0
    out = capsys.readouterr()
    assert "gfx950/k.s" in out.out
    assert "AMD clang version 23 (abc)" in out.out and "AMD clang version 24 (def)" in out.out
    assert "drift" not in out.err


def test_check_fails_on_instruction_change(drift_dirs, capsys):
    committed, fresh_root = drift_dirs
    (committed / "k.s").write_text(assembly(wait="s_waitcnt vmcnt(0)"))
    (fresh_root / "gfx950" / "k.s").write_text(assembly(wait="s_waitcnt vmcnt(1)"))
    assert check(fresh_root) == 1
    assert "gfx950/k.s" in capsys.readouterr().err


def test_check_counts_instruction_change_as_drift_even_with_new_ident(drift_dirs, capsys):
    committed, fresh_root = drift_dirs
    (committed / "k.s").write_text(assembly(ident="A", wait="s_waitcnt vmcnt(0)"))
    (fresh_root / "gfx950" / "k.s").write_text(assembly(ident="B", wait="s_waitcnt vmcnt(1)"))
    assert check(fresh_root) == 1
    out = capsys.readouterr()
    assert "gfx950/k.s" in out.err
    assert "gfx950/k.s" not in out.out  # not also listed as provenance-only


def test_check_fails_on_uncommitted_file(drift_dirs, capsys):
    _, fresh_root = drift_dirs
    (fresh_root / "gfx950" / "new.s").write_text(assembly())
    assert check(fresh_root) == 1
    assert "gfx950/new.s: not committed" in capsys.readouterr().err


# --- The corpus target set ---------------------------------------------------
#
# cases.toml declares the targets the corpus is built for. A portable case builds
# for exactly those, and a case's targets must name only those, so adding a
# target is a deliberate edit to the manifest.


@pytest.fixture
def manifest(tmp_path: Path, monkeypatch):
    """Point the script at a scratch cases.toml written from (targets, cases)."""
    path = tmp_path / "cases.toml"
    monkeypatch.setattr(regen, "CASES_PATH", path)

    def write(targets: list[str] | None, cases: str) -> None:
        corpus_table = 'schema = 1\nname = "race"\n'
        if targets is not None:
            corpus_table += f"targets = {targets!r}\n".replace("'", '"')
        path.write_text(f"[corpus]\n{corpus_table}\n{cases}")

    return write


PORTABLE_CASE = '[[case]]\nid = "portable"\nkernel = "kernel"\ntargets = []\n'


def test_default_targets_come_from_the_manifest_not_asm(manifest, monkeypatch, tmp_path):
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    # An assembly directory for another target does not add it.
    asm = tmp_path / "asm"
    for target in ("gfx950", "gfx1250", "gfx1201"):
        (asm / target).mkdir(parents=True)
    monkeypatch.setattr(regen, "ASM_DIR", asm)
    assert regen.targets_for(regen.load_inventory(), []) == ["gfx950", "gfx1250"]


def test_requested_target_must_be_a_corpus_target(manifest):
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    corpus = regen.load_inventory()
    assert regen.targets_for(corpus, ["gfx1250"]) == ["gfx1250"]
    with pytest.raises(SystemExit, match="gfx1201.*not in \\[corpus\\] targets"):
        regen.targets_for(corpus, ["gfx1201"])


def test_case_target_outside_the_corpus_targets_is_rejected(manifest):
    manifest(
        ["gfx950", "gfx1250"],
        PORTABLE_CASE + '[[case]]\nid = "new"\nkernel = "new"\ntargets = ["gfx1201"]\n',
    )
    with pytest.raises(SystemExit, match="gfx1201.*not in \\[corpus\\] targets"):
        regen.load_inventory()


@pytest.mark.parametrize("targets", [None, []])
def test_manifest_without_targets_is_rejected(manifest, targets):
    manifest(targets, PORTABLE_CASE)
    with pytest.raises(SystemExit, match="\\[corpus\\] targets"):
        regen.load_inventory()


def test_portable_case_builds_for_every_corpus_target(manifest, monkeypatch, tmp_path, kernel):
    install_fake_compiler(monkeypatch, tmp_path, "output")
    manifest(
        ["gfx950", "gfx1250"],
        PORTABLE_CASE + '[[case]]\nid = "only"\nkernel = "only"\ntargets = ["gfx1250"]\n',
    )
    (kernel.parent / "only.hip").write_text("__global__ void only() {}\n")
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    out_root = tmp_path / "out"
    corpus = regen.load_inventory()
    written, failures, skipped = regen.regenerate(
        corpus, regen.targets_for(corpus, []), [], out_root
    )
    assert (written, failures, skipped) == (3, [], [])
    assert sorted(str(p.relative_to(out_root)) for p in out_root.rglob("*.s")) == [
        "gfx1250/kernel.s",
        "gfx1250/only.s",
        "gfx950/kernel.s",
    ]


# --- Header preflight and the compiler's environment include paths -----------
#
# hipcc also searches CPATH and, for HIP, which compiles as C++,
# CPLUS_INCLUDE_PATH. A declared header available only through one of those must
# not be skipped as missing when the compile would find it. The compiler runs in
# a private scratch directory, so only absolute entries are usable.


@pytest.fixture
def rocwmma_case(monkeypatch, kernel):
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    for name in ("CPATH", "CPLUS_INCLUDE_PATH", "C_INCLUDE_PATH"):
        monkeypatch.delenv(name, raising=False)


def header_dir(tmp_path: Path) -> Path:
    include = tmp_path / "env-include"
    (include / "rocwmma").mkdir(parents=True)
    (include / "rocwmma" / "rocwmma.hpp").write_text("")
    return include


@pytest.mark.parametrize("variable", ["CPATH", "CPLUS_INCLUDE_PATH"])
def test_declared_header_found_through_environment_include_path(
    monkeypatch, tmp_path, pinned, rocwmma_case, variable
):
    install_fake_compiler(monkeypatch, tmp_path, "output")
    monkeypatch.setenv(variable, f"/nonexistent{os.pathsep}{header_dir(tmp_path)}")
    written, failures, skipped = regen.regenerate(ROCWMMA_INVENTORY, ["gfx950"], [], pinned.parent.parent)
    assert (written, failures, skipped) == (1, [], [])
    assert "s_endpgm" in pinned.read_text()


def test_c_include_path_is_not_searched_for_hip(monkeypatch, tmp_path, pinned, rocwmma_case):
    install_fake_compiler(monkeypatch, tmp_path, "fail")  # must not be invoked
    monkeypatch.setenv("C_INCLUDE_PATH", str(header_dir(tmp_path)))
    written, failures, skipped = regen.regenerate(ROCWMMA_INVENTORY, ["gfx950"], [], pinned.parent.parent)
    assert (written, failures) == (0, [])
    assert len(skipped) == 1
    assert pinned.read_text() == PINNED


def test_relative_environment_include_path_is_not_searched(
    monkeypatch, tmp_path, pinned, rocwmma_case
):
    # The compiler runs in a scratch directory, where a relative entry names
    # nothing, so the preflight must not count it even when it resolves from
    # the caller's directory.
    install_fake_compiler(monkeypatch, tmp_path, "fail")  # must not be invoked
    header_dir(tmp_path)
    monkeypatch.chdir(tmp_path)
    monkeypatch.setenv("CPATH", "env-include")
    written, failures, skipped = regen.regenerate(ROCWMMA_INVENTORY, ["gfx950"], [], pinned.parent.parent)
    assert (written, failures) == (0, [])
    assert len(skipped) == 1
    assert pinned.read_text() == PINNED


# --- What the script says about regeneration and --check ----------------------
#
# cases.toml is an inventory: id, kernel, targets and headers. The messages
# describe regenerating as a change to the pinned assembly, and --check as the
# textual comparison it performs, without mutation-site fields cases.toml does
# not have.


def test_check_help_describes_the_textual_comparison(monkeypatch, capsys):
    with pytest.raises(SystemExit):
        regen.main(["--help"])
    help_text = " ".join(capsys.readouterr().out.split())
    assert ".ident" in help_text
    assert "directive" in help_text and "metadata" in help_text
    assert "means this toolchain generates different code" not in help_text


def test_drift_report_does_not_mention_ordinals(drift_dirs, capsys):
    committed, fresh_root = drift_dirs
    (committed / "k.s").write_text("s_waitcnt 0\n")
    (fresh_root / "gfx950" / "k.s").write_text("s_nop 0\n")
    assert check(fresh_root) == 1
    err = " ".join(capsys.readouterr().err.split())
    assert "ordinal" not in err
    assert "pinned assembly" in err


def test_write_summary_does_not_mention_ordinals(manifest, monkeypatch, tmp_path, kernel, capsys):
    install_fake_compiler(monkeypatch, tmp_path, "output")
    manifest(["gfx950"], PORTABLE_CASE)
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    monkeypatch.setattr(regen, "CORPUS_ROOT", tmp_path / "corpus" / "race")
    monkeypatch.setattr(regen, "ASM_DIR", tmp_path / "corpus" / "race" / "asm")
    assert regen.main([]) == 0
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
def corpus_main(manifest, monkeypatch, tmp_path, kernel):
    """
    Run main() against a scratch corpus whose committed assembly is under
    ``corpus/race/asm``, with the fake compiler writing ``assembly()``-free
    output. Returns (run, committed_root).
    """
    install_fake_compiler(monkeypatch, tmp_path, "output")
    # A rocm-sdk that describes no SDK these tests select, so the recipe falls
    # back to .info/version, without starting the real, slower, rocm-sdk.
    install_fake_rocm_sdk(monkeypatch, tmp_path, tmp_path / "no-sdk", "0.0.0")
    (kernel.parent / "wmma.hip").write_text("__global__ void wmma() {}\n")
    (kernel.parent / "only.hip").write_text("__global__ void only() {}\n")
    for name in ("CPATH", "CPLUS_INCLUDE_PATH"):
        monkeypatch.delenv(name, raising=False)
    root = tmp_path / "corpus" / "race"
    committed = root / "asm"
    monkeypatch.setattr(regen, "CORPUS_ROOT", root)
    monkeypatch.setattr(regen, "ASM_DIR", committed)
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)

    def run(*argv: str) -> int:
        return regen.main([*argv])

    return run, committed


def commit_fresh_output(run, committed: Path) -> None:
    """Populate the committed tree by running update mode, as a person would."""
    assert run() == 0
    assert any(committed.rglob("*.s"))


def test_check_with_only_a_skipped_case_is_incomplete(manifest, corpus_main, capsys):
    run, _ = corpus_main
    manifest(["gfx950"], ROCWMMA_CASE)
    code = run("--check")
    out = capsys.readouterr()
    assert code == 3
    assert "matches" not in out.out
    assert "incomplete" in out.err and "wmma" in out.err


def test_check_with_some_cases_skipped_is_incomplete(manifest, corpus_main, capsys):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    manifest(["gfx950"], PORTABLE_CASE + ROCWMMA_CASE)
    capsys.readouterr()
    assert run("--check") == 3
    assert "matches" not in capsys.readouterr().out


def test_check_with_nothing_selected_is_incomplete(manifest, corpus_main, capsys):
    run, _ = corpus_main
    manifest(
        ["gfx950", "gfx1250"],
        '[[case]]\nid = "only"\nkernel = "only"\ntargets = ["gfx1250"]\n',
    )
    assert run("--check", "--target", "gfx950") == 3
    out = capsys.readouterr()
    assert "matches" not in out.out
    assert "incomplete" in out.err


def test_check_passes_a_complete_matching_inventory(manifest, corpus_main, capsys):
    run, committed = corpus_main
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    capsys.readouterr()
    assert run("--check") == 0
    assert "matches" in capsys.readouterr().out


def test_check_reports_an_obsolete_committed_file(manifest, corpus_main, capsys):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    (committed / "gfx950" / "obsolete.s").write_text("; no case builds this\n")
    capsys.readouterr()
    assert run("--check") == 1
    err = capsys.readouterr().err
    assert "gfx950/obsolete.s" in err and "no selected case" in err


def test_check_reports_a_missing_committed_target_directory(manifest, corpus_main, capsys):
    run, committed = corpus_main
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    for path in (committed / "gfx1250").iterdir():
        path.unlink()
    (committed / "gfx1250").rmdir()
    capsys.readouterr()
    assert run("--check") == 1
    assert "gfx1250/kernel.s: not committed" in capsys.readouterr().err


def test_check_reports_an_expected_output_absent_from_both_trees(drift_dirs, capsys):
    # A selected case whose output was neither generated nor committed.
    _, fresh_root = drift_dirs
    assert check(fresh_root, expected={("gfx950", "k.s")}) == 1
    assert "gfx950/k.s: not generated and not committed" in capsys.readouterr().err


def test_update_mode_reports_a_skipped_case_and_leaves_its_target(
    manifest, corpus_main, capsys
):
    # The skip is still reported, but the target's other listing is not written
    # either: its recipe could not describe both.
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE + ROCWMMA_CASE)
    assert run() == 3
    out = capsys.readouterr().out
    assert "skip: wmma" in out
    assert not (committed / "gfx950" / "kernel.s").exists()
    assert not (committed / "gfx950" / "recipe.toml").exists()


def test_check_help_documents_the_exit_codes(monkeypatch, capsys):
    with pytest.raises(SystemExit):
        regen.main(["--help"])
    help_text = " ".join(capsys.readouterr().out.split())
    assert "Exits 0 on a match, 1 on drift, 2 when a case fails to compile, and 3" in help_text


# --- A compile failure keeps the compiler's diagnostic -----------------------


def test_main_preserves_the_compiler_diagnostic(
    manifest, corpus_main, monkeypatch, tmp_path, capsys
):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    pinned_file = committed / "gfx950" / "kernel.s"
    pinned_file.parent.mkdir(parents=True)
    pinned_file.write_text(PINNED)
    # Replace the fixture's compiler with one that fails the way hipcc does on
    # a bad flag: exit 1, with the cause on stderr.
    install_fake_compiler(monkeypatch, tmp_path, "fail")
    assert run() == 2
    err = capsys.readouterr().err
    assert "FAIL: kernel.hip (gfx950):" in err
    assert "error: unknown argument" in err
    assert pinned_file.read_text() == PINNED



# --- --cxxflags is parsed as shell words -------------------------------------


def compiler_environments(tmp_path: Path, name: str = "fake-hipcc") -> list[dict[str, str | None]]:
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
    manifest, corpus_main, monkeypatch, tmp_path
):
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    caller = tmp_path / "caller"
    caller.mkdir()
    monkeypatch.chdir(caller)
    assert run("--cxxflags", '-I"headers with spaces" -isystem "/abs dir/inc" -DX=1') == 0
    (argv,) = compiler_invocations(tmp_path)
    assert f"-I{caller / 'headers with spaces'}" in argv
    assert argv[argv.index("-isystem") + 1] == "/abs dir/inc"
    assert "-DX=1" in argv
    assert not any(arg in ("with", 'spaces"', "dir/inc\"") for arg in argv)


def test_malformed_quoting_is_rejected_before_compiling(manifest, corpus_main, tmp_path, capsys):
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
# the executable included, must already be absolute. A relative ROCM_PATH, or a
# compiler found through a relative PATH entry, means something only from the
# caller's directory.


@pytest.fixture
def no_sdk_discovery(monkeypatch):
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
    monkeypatch, tmp_path, pinned, kernel, no_sdk_discovery
):
    caller = tmp_path / "caller"
    fake_sdk(caller / "rocm")
    monkeypatch.chdir(caller)
    monkeypatch.setenv("ROCM_PATH", "rocm")
    regen.compile_device_asm(kernel, "gfx950", pinned, [])
    assert "s_endpgm" in pinned.read_text()
    (argv,) = [line for line in (caller / "rocm" / "bin" / "hipcc.argv").read_text().splitlines()]
    assert f"--rocm-path={caller / 'rocm'}" in argv
    assert str(caller / "rocm" / "include") in argv


def test_rocm_path_is_absolute(monkeypatch, tmp_path, no_sdk_discovery):
    monkeypatch.chdir(tmp_path)
    monkeypatch.setenv("ROCM_PATH", "rocm")
    assert regen.rocm_path() == tmp_path / "rocm"


def test_compiler_found_through_a_relative_path_entry_is_absolute(
    monkeypatch, tmp_path, no_sdk_discovery
):
    (tmp_path / "rocm").mkdir()  # an SDK root with neither candidate in it
    compiler = fake_sdk(tmp_path / "tools", layout="bin/hipcc")
    monkeypatch.chdir(tmp_path)
    monkeypatch.setenv("ROCM_PATH", str(tmp_path / "rocm"))
    monkeypatch.setattr(
        regen.shutil, "which", lambda name: "tools/bin/hipcc" if name == "hipcc" else None
    )
    assert regen.find_hip_compiler() == compiler


def test_clang_is_used_when_the_sdk_has_no_hipcc(monkeypatch, tmp_path, no_sdk_discovery):
    compiler = fake_sdk(tmp_path / "rocm", layout="llvm/bin/clang++")
    monkeypatch.setenv("ROCM_PATH", str(tmp_path / "rocm"))
    assert regen.find_hip_compiler() == compiler


def test_missing_compiler_error_names_both_candidates(monkeypatch, tmp_path, no_sdk_discovery):
    (tmp_path / "rocm").mkdir()
    monkeypatch.setenv("ROCM_PATH", str(tmp_path / "rocm"))
    with pytest.raises(SystemExit) as exit_info:
        regen.find_hip_compiler()
    message = str(exit_info.value.code)
    assert "bin/hipcc" in message and "llvm/bin/clang++" in message


# --- Skipping explicitly allowed ----------------------------------------------
#
# --allow-skipped lets a --check pass on the cases it could compare, for a
# machine without an optional dependency, but the verdict still names every
# case it did not compare. It cannot turn "nothing was compared" into a match.


def test_check_allowing_skips_names_the_cases_not_compared(manifest, corpus_main, capsys):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    manifest(["gfx950"], PORTABLE_CASE + ROCWMMA_CASE)
    capsys.readouterr()
    assert run("--check", "--allow-skipped") == 0
    out = capsys.readouterr()
    verdict = " ".join((out.out + out.err).split())
    assert "not compared: wmma (gfx950)" in verdict
    assert "1 case(s) skipped and not compared" in verdict
    assert "committed assembly matches this toolchain for the compared cases" in verdict


def test_check_allowing_skips_still_fails_on_drift(manifest, corpus_main, capsys):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    (committed / "gfx950" / "kernel.s").write_text("; changed by hand\n")
    manifest(["gfx950"], PORTABLE_CASE + ROCWMMA_CASE)
    assert run("--check", "--allow-skipped") == 1


def test_check_allowing_skips_with_nothing_compared_is_still_incomplete(
    manifest, corpus_main, capsys
):
    run, _ = corpus_main
    manifest(["gfx950"], ROCWMMA_CASE)
    assert run("--check", "--allow-skipped") == 3
    out = capsys.readouterr()
    assert "matches" not in out.out
    assert "incomplete" in out.err


def test_allow_skipped_only_applies_with_check(manifest, corpus_main, capsys):
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    with pytest.raises(SystemExit) as exit_info:
        run("--allow-skipped")
    assert exit_info.value.code == 2
    assert "--allow-skipped only applies with --check" in capsys.readouterr().err



# --- --check cleans up its generated assembly ---------------------------------


@pytest.fixture
def temp_root(tmp_path, monkeypatch) -> Path:
    """Where tempfile creates directories during the test, to see what is left."""
    root = tmp_path / "system-tmp"
    root.mkdir()
    monkeypatch.setattr(regen.tempfile, "tempdir", str(root))
    return root


@pytest.mark.parametrize("outcome", ["match", "drift", "compile-failure", "incomplete"])
def test_check_leaves_no_temporary_directory(
    manifest, corpus_main, monkeypatch, tmp_path, temp_root, outcome
):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    expected_code = 0
    if outcome == "drift":
        (committed / "gfx950" / "kernel.s").write_text("; changed by hand\n")
        expected_code = 1
    elif outcome == "compile-failure":
        install_fake_compiler(monkeypatch, tmp_path, "fail")
        expected_code = 2
    elif outcome == "incomplete":
        manifest(["gfx950"], PORTABLE_CASE + ROCWMMA_CASE)
        expected_code = 3
    assert run("--check") == expected_code
    assert list(temp_root.iterdir()) == []


# --- --help is a short description, with the workflow in the README -----------


def test_help_is_short_and_points_to_the_readme(monkeypatch, capsys):
    with pytest.raises(SystemExit):
        regen.main(["--help"])
    help_text = capsys.readouterr().out
    assert "corpus/race/README.md" in help_text
    # The rationale and usage examples live in the module docstring and the
    # README, not in --help.
    assert "Why the assembly is committed" not in help_text
    assert "CI drift gate" not in help_text



# --- The per-case field is targets ---------------------------------------------


def test_case_without_targets_regenerates_for_every_corpus_target(
    manifest, monkeypatch, tmp_path, kernel
):
    install_fake_compiler(monkeypatch, tmp_path, "output")
    manifest(["gfx950", "gfx1250"], '[[case]]\nid = "portable"\nkernel = "kernel"\n')
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    out_root = tmp_path / "out"
    corpus = regen.load_inventory()
    assert regen.regenerate(corpus, regen.targets_for(corpus, []), [], out_root) == (2, [], [])
    assert sorted(str(p.relative_to(out_root)) for p in out_root.rglob("*.s")) == [
        "gfx1250/kernel.s",
        "gfx950/kernel.s",
    ]


def test_requires_is_rejected_rather_than_ignored(manifest):
    # Ignoring it would turn a target-specific case into a portable one.
    manifest(
        ["gfx950", "gfx1250"],
        '[[case]]\nid = "only"\nkernel = "only"\nrequires = ["gfx1250"]\n',
    )
    with pytest.raises(SystemExit, match="'requires' is now 'targets'"):
        regen.load_inventory()


# --- One validated inventory ---------------------------------------------------


def test_misspelled_case_field_is_rejected(manifest):
    # Regeneration used to accept a field the checker rejects.
    manifest(
        ["gfx950"],
        '[[case]]\nid = "wmma"\nkernel = "wmma"\nheader = ["rocwmma/rocwmma.hpp"]\n',
    )
    with pytest.raises(SystemExit, match="unknown field 'header'"):
        regen.load_inventory()


def test_main_reads_the_manifest_once(manifest, corpus_main, monkeypatch):
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
    assert run("--check") == 0
    assert len(reads) == 1


# --- One list of include-directory flags --------------------------------------
#
# The header preflight and the relative-path rewrite read include directories
# from the same flags, so a flag added to one is understood by both.


@pytest.mark.parametrize("flag", regen._INCLUDE_DIR_FLAGS)
def test_every_include_directory_flag_is_searched_and_made_absolute(
    monkeypatch, tmp_path, flag
):
    monkeypatch.setenv("ROCM_PATH", str(tmp_path / "rocm"))
    for name in ("CPATH", "CPLUS_INCLUDE_PATH"):
        monkeypatch.delenv(name, raising=False)
    base = tmp_path / "caller"
    for flags in ([flag, "inc"], [f"{flag}inc"]):
        assert regen.include_dirs(flags)[1:] == [Path("inc")]
        assert str(base / "inc") in "".join(regen.absolute_flags(flags, base))


def test_forced_include_file_is_made_absolute_but_not_searched(monkeypatch, tmp_path):
    monkeypatch.setenv("ROCM_PATH", str(tmp_path / "rocm"))
    for name in ("CPATH", "CPLUS_INCLUDE_PATH"):
        monkeypatch.delenv(name, raising=False)
    base = tmp_path / "caller"
    flags = ["-include", "pre.h"]
    assert regen.include_dirs(flags) == [tmp_path / "rocm" / "include"]
    assert regen.absolute_flags(flags, base) == ["-include", str(base / "pre.h")]


# --- The baseline recipe is explicit -------------------------------------------
#
# hipcc adds -O3 and -x hip itself; the documented clang++ fallback does not. So
# the compile passes them explicitly, before --cxxflags, and both compilers build
# the pinned assembly the same way.


@pytest.mark.parametrize("sdk_compiler", ["bin/hipcc", "llvm/bin/clang++"])
def test_baseline_recipe_is_passed_to_either_compiler(
    manifest, corpus_main, monkeypatch, tmp_path, sdk_compiler
):
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    # An SDK with only this compiler, found by the script's own discovery.
    sdk = tmp_path / "sdk"
    (sdk / sdk_compiler).parent.mkdir(parents=True)
    compiler = write_fake_compiler(sdk / sdk_compiler, "output")
    monkeypatch.setattr(regen, "rocm_path", lambda: sdk)
    monkeypatch.setattr(regen, "find_hip_compiler", FIND_HIP_COMPILER)
    assert run() == 0
    (argv,) = compiler_invocations(compiler.parent, compiler.name)
    assert "-O3" in argv
    assert argv[argv.index("-x") + 1] == "hip"
    # -x applies to the files after it, so it has to precede the kernel.
    assert argv.index("-x") < next(i for i, arg in enumerate(argv) if arg.endswith(".hip"))


def test_cxxflags_come_after_the_baseline_recipe(manifest, corpus_main, tmp_path):
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    assert run("--cxxflags=-O1") == 0
    (argv,) = compiler_invocations(tmp_path)
    # The last -O wins, so --cxxflags can still override the baseline.
    assert argv.index("-O3") < argv.index("-O1")


# --- hipcc's flag-injecting environment is not inherited -------------------------
#
# hipcc appends HIPCC_COMPILE_FLAGS_APPEND to every compile, and clang edits its
# own command line from CCC_OVERRIDE_OPTIONS. Either would change the pinned
# assembly without leaving a trace in it, so they are removed from the compile's
# environment, with a note, and flags go through --cxxflags, which is recorded.


@pytest.mark.parametrize("variable", regen._FLAG_INJECTION_VARIABLES)
def test_flag_injecting_variable_does_not_reach_the_compiler(
    manifest, corpus_main, monkeypatch, tmp_path, capsys, variable
):
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    monkeypatch.setenv(variable, "-O1")
    monkeypatch.setenv("CPATH", "/kept")
    assert run() == 0
    (environment,) = compiler_environments(tmp_path)
    assert environment[variable] is None
    # Only the flag-injecting variables are removed.
    assert environment["CPATH"] == "/kept"
    err = capsys.readouterr().err
    assert variable in err and "--cxxflags" in err


def test_clean_environment_prints_no_note(manifest, corpus_main, monkeypatch, capsys):
    run, _ = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    for variable in regen._FLAG_INJECTION_VARIABLES:
        monkeypatch.delenv(variable, raising=False)
    assert run() == 0
    assert "ignoring" not in capsys.readouterr().err


# --- The recipe is recorded beside the pinned assembly ----------------------------
#
# .ident names the compiler, but not the SDK or the flags. Regeneration writes
# asm/<target>/recipe.toml, and --check compares it, so a changed recipe can be
# told apart from a toolchain update.


def read_recipe(committed: Path, target: str) -> dict:
    return tomllib.loads((committed / target / "recipe.toml").read_text())


def set_rocm_version(tmp_path: Path, version: str) -> None:
    info = tmp_path / "rocm" / ".info"
    info.mkdir(parents=True, exist_ok=True)
    (info / "version").write_text(f"{version}\n")


def test_regeneration_records_the_recipe(manifest, corpus_main, tmp_path):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    set_rocm_version(tmp_path, "7.3.0")
    assert run("--cxxflags=-DX=1") == 0
    assert read_recipe(committed, "gfx950") == {
        "compiler": "fake-hipcc",
        "compiler_version": "fake clang version 1.0",
        "rocm_version": "7.3.0",
        "flags": ["-O3", "-x", "hip", "-DX=1"],
    }


def test_regenerating_one_target_records_only_its_recipe(manifest, corpus_main):
    run, committed = corpus_main
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    assert run("--target", "gfx1250") == 0
    assert (committed / "gfx1250" / "recipe.toml").is_file()
    assert not (committed / "gfx950" / "recipe.toml").exists()


def test_check_does_not_rewrite_the_committed_recipe(manifest, corpus_main):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    before = (committed / "gfx950" / "recipe.toml").read_text()
    run("--check", "--cxxflags=-DX=1")
    assert (committed / "gfx950" / "recipe.toml").read_text() == before


def test_check_reports_an_unchanged_recipe(manifest, corpus_main, capsys):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    capsys.readouterr()
    assert run("--check") == 0
    assert "gfx950: recipe unchanged" in capsys.readouterr().out


def test_check_reports_changed_flags_as_a_recipe_change(manifest, corpus_main, capsys):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    capsys.readouterr()
    run("--check", "--cxxflags=-DX=1")
    out = capsys.readouterr().out
    assert "gfx950: recipe changed: flags" in out and "-DX=1" in out
    assert "toolchain changed" not in out


def test_check_reports_a_new_compiler_as_a_toolchain_change(
    manifest, corpus_main, monkeypatch, tmp_path, capsys
):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    set_rocm_version(tmp_path, "7.3.0")
    commit_fresh_output(run, committed)
    monkeypatch.setenv("FAKE_COMPILER_VERSION", "fake clang version 2.0")
    set_rocm_version(tmp_path, "7.4.0")
    capsys.readouterr()
    run("--check")
    out = capsys.readouterr().out
    assert "gfx950: toolchain changed" in out
    assert "fake clang version 2.0" in out and "7.4.0" in out
    assert "recipe changed" not in out


def test_check_without_a_committed_recipe_says_so(manifest, corpus_main, capsys):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    (committed / "gfx950" / "recipe.toml").unlink()
    capsys.readouterr()
    assert run("--check") == 0
    assert "gfx950: no recipe.toml committed" in capsys.readouterr().out


# --- An invalid committed recipe is reported, not raised -----------------------------


@pytest.mark.parametrize("text, problem", BAD_RECIPES.values(), ids=BAD_RECIPES.keys())
def test_check_reports_an_invalid_committed_recipe(
    manifest, corpus_main, capsys, text, problem
):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    commit_fresh_output(run, committed)
    (committed / "gfx950" / "recipe.toml").write_text(text)
    capsys.readouterr()
    # The recipe comparison is informational: the assembly still matches.
    assert run("--check") == 0
    out = capsys.readouterr().out
    assert "gfx950: recipe.toml cannot be compared" in out
    assert problem in out


# --- A target's listings and recipe are replaced together, or not at all --------
#
# The recipe describes every listing beside it. So a run replaces a target's
# assembly only when every case for that target compiled, and writes the recipe
# with it; a failed or skipped case leaves the whole target as it was.

OLD_RECIPE = regen.recipe.Recipe(
    compiler="old-hipcc", compiler_version="old clang", rocm_version="1.0", flags=("-O3", "-x", "hip")
)


def seed_target(committed: Path, target: str, kernels: list[str]) -> None:
    """A committed target directory: an old listing per kernel, and the old recipe."""
    (committed / target).mkdir(parents=True, exist_ok=True)
    for kernel in kernels:
        (committed / target / f"{kernel}.s").write_text(f"old {kernel}\n")
    (committed / target / "recipe.toml").write_text(regen.recipe.dumps(OLD_RECIPE))


def assert_untouched(committed: Path, target: str, kernels: list[str]) -> None:
    for kernel in kernels:
        assert (committed / target / f"{kernel}.s").read_text() == f"old {kernel}\n"
    assert regen.recipe.load(committed / target / "recipe.toml") == OLD_RECIPE


def test_partial_skip_leaves_the_target_as_it_was(manifest, corpus_main, capsys):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE + ROCWMMA_CASE)
    seed_target(committed, "gfx950", ["kernel", "wmma"])
    assert run("--cxxflags=-O1") == 3
    assert_untouched(committed, "gfx950", ["kernel", "wmma"])
    assert "gfx950: not updated" in capsys.readouterr().err


def test_partial_failure_leaves_the_target_as_it_was(
    manifest, corpus_main, monkeypatch, capsys
):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE + '[[case]]\nid = "only"\nkernel = "only"\n')
    seed_target(committed, "gfx950", ["kernel", "only"])
    monkeypatch.setenv("FAKE_COMPILER_FAIL", "only")
    assert run("--cxxflags=-O1") == 2
    assert_untouched(committed, "gfx950", ["kernel", "only"])
    assert "gfx950: not updated" in capsys.readouterr().err


def test_all_skipped_run_leaves_the_recipe_as_it_was(manifest, corpus_main):
    run, committed = corpus_main
    manifest(["gfx950"], ROCWMMA_CASE)
    seed_target(committed, "gfx950", ["wmma"])
    assert run("--cxxflags=-O1") == 3
    assert_untouched(committed, "gfx950", ["wmma"])


def test_complete_target_is_written_while_a_blocked_one_is_kept(manifest, corpus_main, capsys):
    run, committed = corpus_main
    manifest(
        ["gfx950", "gfx1250"],
        PORTABLE_CASE + ROCWMMA_CASE.replace("targets = []", 'targets = ["gfx1250"]'),
    )
    seed_target(committed, "gfx950", ["kernel"])
    seed_target(committed, "gfx1250", ["kernel", "wmma"])
    assert run("--cxxflags=-O1") == 3
    # gfx950 compiled completely: its listing and its recipe are both new.
    assert "s_endpgm" in (committed / "gfx950" / "kernel.s").read_text()
    assert regen.recipe.load(committed / "gfx950" / "recipe.toml").flags[-1] == "-O1"
    # gfx1250 skipped a case, so nothing in it changed.
    assert_untouched(committed, "gfx1250", ["kernel", "wmma"])
    err = capsys.readouterr().err
    assert "gfx1250: not updated" in err and "gfx950: not updated" not in err


# --- The recipe names the SDK build ----------------------------------------------
#
# rocm-sdk reports the installed build, such as 10.1.0a20260822, where
# .info/version has only the release, 10.1.0. The build is recorded when rocm-sdk
# describes the SDK that was selected; otherwise .info/version is the fallback.


def install_fake_rocm_sdk(monkeypatch, tmp_path: Path, root: Path, version: str) -> None:
    """Put a rocm-sdk on PATH that reports *root* and *version*."""
    bin_dir = tmp_path / "rocm-sdk-bin"
    bin_dir.mkdir(exist_ok=True)
    tool = bin_dir / "rocm-sdk"
    tool.write_text(
        f"#!{sys.executable}\n"
        "import sys\n"
        f"print({str(root)!r} if sys.argv[1:] == ['path', '--root'] else {version!r})\n"
    )
    tool.chmod(0o755)
    monkeypatch.setenv("PATH", f"{bin_dir}{os.pathsep}{os.environ['PATH']}")


def test_recipe_records_the_build_of_the_selected_sdk(manifest, corpus_main, monkeypatch, tmp_path):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    set_rocm_version(tmp_path, "10.1.0")
    install_fake_rocm_sdk(monkeypatch, tmp_path, tmp_path / "rocm", "10.1.0a20260822")
    assert run() == 0
    assert read_recipe(committed, "gfx950")["rocm_version"] == "10.1.0a20260822"


def test_recipe_falls_back_to_info_version_for_another_sdk(
    manifest, corpus_main, monkeypatch, tmp_path
):
    # rocm-sdk describes a different install than the one selected, so its
    # version says nothing about the compiler used.
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE)
    set_rocm_version(tmp_path, "10.1.0")
    install_fake_rocm_sdk(monkeypatch, tmp_path, tmp_path / "elsewhere", "9.9.9a1")
    assert run() == 0
    assert read_recipe(committed, "gfx950")["rocm_version"] == "10.1.0"


def test_build_is_a_frozen_dataclass():
    # Like the inventory and recipe records: a plain record with immutable fields.
    assert dataclasses.is_dataclass(regen.Build)
    assert regen.Build.__dataclass_params__.frozen
    assert not issubclass(regen.Build, tuple)
