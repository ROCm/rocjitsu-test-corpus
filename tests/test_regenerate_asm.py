from __future__ import annotations

import importlib.util
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


def install_fake_compiler(monkeypatch, tmp_path: Path, behaviour: str) -> None:
    """
    Stand in for hipcc with a script, so these tests need no ROCm install.

    *behaviour* is one of:
      fail        exit 1 without writing anything
      output      write to the -o path
      auto-named  ignore -o and write the auto-named file into the working
                  directory, as hipcc sometimes does under --cuda-device-only
    """
    compiler = tmp_path / "fake-hipcc"
    compiler.write_text(
        textwrap.dedent(
            f"""\
            #!{sys.executable}
            import os, sys
            args = sys.argv[1:]
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
    monkeypatch.setattr(regen, "hipcc", lambda: compiler)
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


def check(fresh_root: Path) -> int:
    return regen._report_drift(["gfx950"], fresh_root)


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
