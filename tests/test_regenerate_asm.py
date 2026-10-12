# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
from __future__ import annotations

import importlib.util
import os
import sys
import textwrap
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[1]
SCRIPT = REPO_ROOT / "corpus" / "race" / "scripts" / "regenerate_asm.py"


def load_script():
    spec = importlib.util.spec_from_file_location("regenerate_asm", SCRIPT)
    assert spec is not None
    assert spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules["regenerate_asm"] = module
    spec.loader.exec_module(module)
    return module


regen = load_script()

PINNED = "; pinned assembly that must survive a failed regeneration\n"


def write_fake_compiler(compiler: Path, behaviour: str) -> Path:
    """
    Stand in for hipcc with a script, so these tests need no ROCm install.

    Each invocation appends the arguments it received, as a JSON list, to
    ``fake-hipcc.argv`` beside it; see compiler_invocations.

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
            with open(os.path.abspath(__file__) + ".argv", "a") as log:
                log.write(json.dumps(args) + "\\n")
            if {behaviour!r} == "fail":
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
    monkeypatch.setattr(
        regen,
        "load_cases",
        lambda: [{"id": "k", "kernel": "kernel", "headers": ["rocwmma/rocwmma.hpp"]}],
    )
    written, failures, skipped = regen.regenerate(["gfx950"], [], pinned.parent.parent)
    assert (written, failures) == (0, [])
    assert len(skipped) == 1 and "rocwmma/rocwmma.hpp" in skipped[0]
    assert pinned.read_text() == PINNED


def test_declared_header_found_through_include_flag(monkeypatch, tmp_path, pinned, kernel):
    install_fake_compiler(monkeypatch, tmp_path, "output")
    include = tmp_path / "rocwmma-install" / "include"
    (include / "rocwmma").mkdir(parents=True)
    (include / "rocwmma" / "rocwmma.hpp").write_text("")
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    monkeypatch.setattr(
        regen,
        "load_cases",
        lambda: [{"id": "k", "kernel": "kernel", "headers": ["rocwmma/rocwmma.hpp"]}],
    )
    written, failures, skipped = regen.regenerate(["gfx950"], [f"-I{include}"], pinned.parent.parent)
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
# for exactly those, and a case's requires must name only those, so adding a
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


PORTABLE_CASE = '[[case]]\nid = "portable"\nkernel = "kernel"\nrequires = []\n'


def test_default_targets_come_from_the_manifest_not_asm(manifest, monkeypatch, tmp_path):
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    # An assembly directory for another target does not add it.
    asm = tmp_path / "asm"
    for target in ("gfx950", "gfx1250", "gfx1201"):
        (asm / target).mkdir(parents=True)
    monkeypatch.setattr(regen, "ASM_DIR", asm)
    assert regen.targets_for([]) == ["gfx950", "gfx1250"]


def test_requested_target_must_be_a_corpus_target(manifest):
    manifest(["gfx950", "gfx1250"], PORTABLE_CASE)
    assert regen.targets_for(["gfx1250"]) == ["gfx1250"]
    with pytest.raises(SystemExit, match="gfx1201.*not in \\[corpus\\] targets"):
        regen.targets_for(["gfx1201"])


def test_requires_outside_the_corpus_targets_is_rejected(manifest):
    manifest(
        ["gfx950", "gfx1250"],
        PORTABLE_CASE + '[[case]]\nid = "new"\nkernel = "new"\nrequires = ["gfx1201"]\n',
    )
    with pytest.raises(SystemExit, match="gfx1201.*not in \\[corpus\\] targets"):
        regen.load_cases()


@pytest.mark.parametrize("targets", [None, []])
def test_manifest_without_targets_is_rejected(manifest, targets):
    manifest(targets, PORTABLE_CASE)
    with pytest.raises(SystemExit, match="\\[corpus\\] targets"):
        regen.load_cases()


def test_portable_case_builds_for_every_corpus_target(manifest, monkeypatch, tmp_path, kernel):
    install_fake_compiler(monkeypatch, tmp_path, "output")
    manifest(
        ["gfx950", "gfx1250"],
        PORTABLE_CASE + '[[case]]\nid = "only"\nkernel = "only"\nrequires = ["gfx1250"]\n',
    )
    (kernel.parent / "only.hip").write_text("__global__ void only() {}\n")
    monkeypatch.setattr(regen, "KERNELS_DIR", kernel.parent)
    out_root = tmp_path / "out"
    written, failures, skipped = regen.regenerate(regen.targets_for([]), [], out_root)
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
    monkeypatch.setattr(
        regen,
        "load_cases",
        lambda: [{"id": "k", "kernel": "kernel", "headers": ["rocwmma/rocwmma.hpp"]}],
    )
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
    written, failures, skipped = regen.regenerate(["gfx950"], [], pinned.parent.parent)
    assert (written, failures, skipped) == (1, [], [])
    assert "s_endpgm" in pinned.read_text()


def test_c_include_path_is_not_searched_for_hip(monkeypatch, tmp_path, pinned, rocwmma_case):
    install_fake_compiler(monkeypatch, tmp_path, "fail")  # must not be invoked
    monkeypatch.setenv("C_INCLUDE_PATH", str(header_dir(tmp_path)))
    written, failures, skipped = regen.regenerate(["gfx950"], [], pinned.parent.parent)
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
    written, failures, skipped = regen.regenerate(["gfx950"], [], pinned.parent.parent)
    assert (written, failures) == (0, [])
    assert len(skipped) == 1
    assert pinned.read_text() == PINNED


# --- What the script says about regeneration and --check ----------------------
#
# cases.toml is an inventory: id, kernel, requires and headers. The messages
# describe regenerating as a change to the pinned assembly, and --check as the
# textual comparison it performs, without mutation-site fields cases.toml does
# not have.


def test_check_help_describes_the_textual_comparison(monkeypatch, capsys):
    monkeypatch.setattr(sys, "argv", ["regenerate_asm.py", "--help"])
    with pytest.raises(SystemExit):
        regen.main()
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
    monkeypatch.setattr(sys, "argv", ["regenerate_asm.py"])
    assert regen.main() == 0
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
    '[[case]]\nid = "wmma"\nkernel = "wmma"\nrequires = []\n'
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
        monkeypatch.setattr(sys, "argv", ["regenerate_asm.py", *argv])
        return regen.main()

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
        '[[case]]\nid = "only"\nkernel = "only"\nrequires = ["gfx1250"]\n',
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


def test_update_mode_still_skips_a_case_missing_its_optional_header(
    manifest, corpus_main, capsys
):
    run, committed = corpus_main
    manifest(["gfx950"], PORTABLE_CASE + ROCWMMA_CASE)
    assert run() == 0
    out = capsys.readouterr().out
    assert "skip: wmma" in out
    assert (committed / "gfx950" / "kernel.s").is_file()
    assert not (committed / "gfx950" / "wmma.s").exists()


def test_check_help_documents_the_exit_codes(monkeypatch, capsys):
    monkeypatch.setattr(sys, "argv", ["regenerate_asm.py", "--help"])
    with pytest.raises(SystemExit):
        regen.main()
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


def compiler_invocations(tmp_path: Path) -> list[list[str]]:
    """The argument lists the fake compiler has been run with, in order."""
    import json

    log = tmp_path / "fake-hipcc.argv"
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

