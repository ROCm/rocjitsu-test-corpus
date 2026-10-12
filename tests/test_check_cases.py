from __future__ import annotations

import importlib.util
import sys
import textwrap
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[1]
SCRIPT = REPO_ROOT / "corpus" / "race" / "scripts" / "check_cases.py"


def load_script():
    spec = importlib.util.spec_from_file_location("check_cases", SCRIPT)
    assert spec is not None
    assert spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules["check_cases"] = module
    spec.loader.exec_module(module)
    return module


check_cases = load_script()

PORTABLE = '[[case]]\nid = "portable"\nkernel = "portable"\nrequires = []\n'
GFX1250_ONLY = '[[case]]\nid = "only"\nkernel = "only"\nrequires = ["gfx1250"]\n'


@pytest.fixture
def corpus(tmp_path: Path, monkeypatch):
    """
    A scratch corpus with check_cases pointed at it.

    Returns a function that writes cases.toml with the given ``[corpus]``
    targets and cases, and creates the kernels and the assembly files given as
    ``target/kernel`` paths.
    """
    monkeypatch.setattr(check_cases, "ASM_DIR", tmp_path / "asm")
    monkeypatch.setattr(check_cases, "KERNELS_DIR", tmp_path / "kernels")
    monkeypatch.setattr(check_cases, "CASES_PATH", tmp_path / "cases.toml")

    def build(targets: list[str] | None, cases: str, asm: list[str]) -> None:
        corpus_table = 'schema = 1\nname = "race"\n'
        if targets is not None:
            corpus_table += f"targets = {targets!r}\n".replace("'", '"')
        (tmp_path / "cases.toml").write_text(f"[corpus]\n{corpus_table}\n{cases}")
        (tmp_path / "kernels").mkdir(exist_ok=True)
        for kernel in ("portable", "only"):
            (tmp_path / "kernels" / f"{kernel}.hip").write_text("")
        (tmp_path / "asm").mkdir(exist_ok=True)
        for path in asm:
            target, kernel = path.split("/")
            (tmp_path / "asm" / target).mkdir(exist_ok=True)
            (tmp_path / "asm" / target / f"{kernel}.s").write_text("")

    return build


def run(capsys) -> tuple[int, str]:
    code = check_cases.main()
    captured = capsys.readouterr()
    return code, captured.out + captured.err


def test_consistent_corpus_passes(corpus, capsys):
    corpus(
        ["gfx950", "gfx1250"],
        PORTABLE + GFX1250_ONLY,
        ["gfx950/portable", "gfx1250/portable", "gfx1250/only"],
    )
    code, out = run(capsys)
    assert code == 0, out


def test_missing_target_directory_is_reported(corpus, capsys):
    # The corpus is built for gfx950 and gfx1250, but only gfx1250's assembly is
    # present. The target set comes from cases.toml, not from asm/, so the
    # missing directory and every gfx950 file in it are reported.
    corpus(["gfx950", "gfx1250"], PORTABLE + GFX1250_ONLY, ["gfx1250/portable", "gfx1250/only"])
    code, out = run(capsys)
    assert code == 1
    assert "asm/gfx950/ is missing" in out
    assert "asm/gfx950/portable.s is missing" in out


def test_requires_outside_the_corpus_targets_is_reported(corpus, capsys):
    corpus(
        ["gfx950", "gfx1250"],
        PORTABLE + '[[case]]\nid = "only"\nkernel = "only"\nrequires = ["gfx1201"]\n',
        ["gfx950/portable", "gfx1250/portable"],
    )
    code, out = run(capsys)
    assert code == 1
    assert "requires gfx1201, which is not in [corpus] targets" in out


def test_requires_does_not_widen_portable_cases(corpus, capsys):
    # A case requiring a new target, even with its assembly committed, does not
    # make every portable case build for that target: the portable case is not
    # expected under asm/gfx1201/, and the undeclared directory is reported.
    corpus(
        ["gfx950", "gfx1250"],
        PORTABLE + '[[case]]\nid = "only"\nkernel = "only"\nrequires = ["gfx1201"]\n',
        ["gfx950/portable", "gfx1250/portable", "gfx1201/only"],
    )
    code, out = run(capsys)
    assert code == 1
    assert "asm/gfx1201/portable.s is missing" not in out
    assert "asm/gfx1201/ is not a corpus target" in out


def test_assembly_directory_for_an_undeclared_target_is_reported(corpus, capsys):
    corpus(["gfx950"], PORTABLE, ["gfx950/portable", "gfx1250/portable"])
    code, out = run(capsys)
    assert code == 1
    assert "asm/gfx1250/ is not a corpus target" in out


@pytest.mark.parametrize("targets", [None, []])
def test_manifest_without_targets_is_rejected(corpus, capsys, targets):
    corpus(targets, PORTABLE, ["gfx950/portable"])
    code, out = run(capsys)
    assert code != 0
    assert "[corpus] targets" in out


def test_committed_manifest_declares_its_targets():
    import tomllib

    manifest = tomllib.loads((SCRIPT.parent.parent / "cases.toml").read_text())
    assert manifest["corpus"]["targets"] == ["gfx950", "gfx1250"]
