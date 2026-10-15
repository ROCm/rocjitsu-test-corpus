# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
from __future__ import annotations

import importlib.util
import pytest
import sys
import tomllib

from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
SCRIPT = REPO_ROOT / "corpus" / "race" / "scripts" / "check_cases.py"


# The scripts import their shared inventory module as a sibling, as they do when
# run directly from scripts/.
sys.path.insert(0, str(SCRIPT.parent))


def load_script():
    spec = importlib.util.spec_from_file_location("check_cases", SCRIPT)
    assert spec is not None
    assert spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules["check_cases"] = module
    spec.loader.exec_module(module)
    return module


check_cases = load_script()

PORTABLE = '[[case]]\nid = "portable"\nkernel = "portable"\ntargets = []\n'
GFX1250_ONLY = '[[case]]\nid = "only"\nkernel = "only"\ntargets = ["gfx1250"]\n'


def listing(target: str) -> str:
    """The start of a device assembly listing for *target*, as hipcc writes it."""
    return f'\t.amdgcn_target "amdgcn-amd-amdhsa-unknown-{target}"\n\ts_endpgm\n'


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
            (tmp_path / "asm" / target / f"{kernel}.s").write_text(listing(target))

    return build


def run(capsys) -> tuple[int, str]:
    code = check_cases.main([])
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


def test_case_target_outside_the_corpus_targets_is_reported(corpus, capsys):
    corpus(
        ["gfx950", "gfx1250"],
        PORTABLE + '[[case]]\nid = "only"\nkernel = "only"\ntargets = ["gfx1201"]\n',
        ["gfx950/portable", "gfx1250/portable"],
    )
    code, out = run(capsys)
    assert code == 1
    assert "lists target gfx1201, which is not in [corpus] targets" in out


def test_case_target_does_not_widen_portable_cases(corpus, capsys):
    # A case naming a new target, even with its assembly committed, does not make
    # every portable case build for that target: the manifest is rejected for
    # the case's target, and the portable case is not expected under
    # asm/gfx1201/. The stray directory is reported once the manifest is valid;
    # see test_assembly_directory_for_an_undeclared_target_is_reported.
    corpus(
        ["gfx950", "gfx1250"],
        PORTABLE + '[[case]]\nid = "only"\nkernel = "only"\ntargets = ["gfx1201"]\n',
        ["gfx950/portable", "gfx1250/portable", "gfx1201/only"],
    )
    code, out = run(capsys)
    assert code == 1
    assert "cases.toml [only]: lists target gfx1201, which is not in [corpus] targets" in out
    assert "asm/gfx1201/portable.s is missing" not in out


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
    manifest = tomllib.loads((SCRIPT.parent.parent / "cases.toml").read_text())
    assert manifest["corpus"]["targets"] == ["gfx950", "gfx1250"]


# --- The inventory contract --------------------------------------------------
#
# No compiler is needed: the checker compares cases.toml with kernels/ and asm/
# on disk, so pytest keeps the manifest and the set of pinned files in step. It
# does not show that the assembly matches its source; that is the manual
# regenerate_asm.py --check.


def test_committed_inventory_passes(capsys):
    # The real corpus, as committed, with no paths redirected.
    module = load_script()
    code = module.main([])
    out = capsys.readouterr()
    assert code == 0, out.err


def test_unknown_field_is_reported(corpus, capsys):
    corpus(["gfx950"], PORTABLE.replace("targets = []", 'targets = []\nordinal = 3'), ["gfx950/portable"])
    code, out = run(capsys)
    assert code == 1
    assert "cases.toml [portable]: unknown field 'ordinal'" in out


def test_missing_assembly_is_reported(corpus, capsys):
    corpus(["gfx950", "gfx1250"], PORTABLE, ["gfx950/portable", "gfx1250/unrelated"])
    code, out = run(capsys)
    assert code == 1
    assert "cases.toml [portable]: asm/gfx1250/portable.s is missing" in out


def test_orphan_assembly_is_reported(corpus, capsys):
    corpus(["gfx950"], PORTABLE, ["gfx950/portable", "gfx950/leftover"])
    code, out = run(capsys)
    assert code == 1
    assert "asm/gfx950/leftover.s: no case builds leftover for gfx950" in out


def test_assembly_for_a_target_the_case_does_not_require_is_an_orphan(corpus, capsys):
    corpus(["gfx950", "gfx1250"], GFX1250_ONLY, ["gfx950/only", "gfx1250/only"])
    code, out = run(capsys)
    assert code == 1
    assert "asm/gfx950/only.s: no case builds only for gfx950" in out


def test_missing_kernel_source_is_reported(corpus, capsys, tmp_path):
    corpus(["gfx950"], PORTABLE, ["gfx950/portable"])
    (tmp_path / "kernels" / "portable.hip").unlink()
    code, out = run(capsys)
    assert code == 1
    assert "cases.toml [portable]: kernels/portable.hip is missing" in out


def test_duplicate_id_and_kernel_are_reported(corpus, capsys):
    corpus(["gfx950"], PORTABLE + PORTABLE, ["gfx950/portable"])
    code, out = run(capsys)
    assert code == 1
    assert "cases.toml [portable]: duplicate id" in out
    assert "cases.toml [portable]: kernel portable is already used by another case" in out



# --- The per-case field is targets ---------------------------------------------
#
# A case's target allowlist is ``targets``, matching ``[corpus] targets``.
# ``requires`` means capabilities elsewhere in the repository, so it is not
# accepted here, and a case without ``targets`` builds for every corpus target.


def test_case_without_targets_builds_for_every_corpus_target(corpus, capsys):
    corpus(
        ["gfx950", "gfx1250"],
        '[[case]]\nid = "portable"\nkernel = "portable"\n',
        ["gfx950/portable", "gfx1250/portable"],
    )
    code, out = run(capsys)
    assert code == 0, out


def test_requires_is_rejected_with_its_new_name(corpus, capsys):
    corpus(
        ["gfx950", "gfx1250"],
        '[[case]]\nid = "only"\nkernel = "only"\nrequires = ["gfx1250"]\n',
        ["gfx1250/only"],
    )
    code, out = run(capsys)
    assert code == 1
    assert "cases.toml [only]: 'requires' is now 'targets'" in out


# --- Each listing is for the target its directory names -------------------------
#
# A basic sanity check on the artifacts, not proof that they match their source:
# an empty file, or a listing for another target copied into the wrong directory,
# is caught without a compiler.


def write_asm(tmp_path: Path, target: str, kernel: str, text: str) -> None:
    (tmp_path / "asm" / target / f"{kernel}.s").write_text(text)


def test_empty_listing_is_reported(corpus, capsys, tmp_path):
    corpus(["gfx950"], PORTABLE, ["gfx950/portable"])
    write_asm(tmp_path, "gfx950", "portable", "")
    code, out = run(capsys)
    assert code == 1
    assert "asm/gfx950/portable.s: no .amdgcn_target directive" in out


def test_listing_for_another_target_is_reported(corpus, capsys, tmp_path):
    corpus(["gfx950", "gfx1250"], PORTABLE, ["gfx950/portable", "gfx1250/portable"])
    write_asm(tmp_path, "gfx1250", "portable", listing("gfx950"))
    code, out = run(capsys)
    assert code == 1
    assert "asm/gfx1250/portable.s: .amdgcn_target is gfx950, not gfx1250" in out


def test_target_features_do_not_change_the_processor(corpus, capsys, tmp_path):
    corpus(["gfx950"], PORTABLE, ["gfx950/portable"])
    write_asm(
        tmp_path,
        "gfx950",
        "portable",
        '\t.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx950:sramecc+:xnack-"\n',
    )
    code, out = run(capsys)
    assert code == 0, out


def test_target_name_that_only_starts_with_the_directory_is_reported(corpus, capsys, tmp_path):
    # gfx9500 is not gfx950: the processor is compared whole.
    corpus(["gfx950"], PORTABLE, ["gfx950/portable"])
    write_asm(tmp_path, "gfx950", "portable", listing("gfx9500"))
    code, out = run(capsys)
    assert code == 1
    assert ".amdgcn_target is gfx9500, not gfx950" in out
