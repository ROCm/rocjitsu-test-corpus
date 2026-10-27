# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
import re
import tomllib
from collections.abc import Callable
from pathlib import Path

import pytest

from support.race_corpus import CORPUS_DIR, corpus_table, load_script
from test_recipe import BAD_RECIPES, GOOD_TEXT

check_cases = load_script("check_cases")

# The corpus fixture: writes cases.toml with the given [corpus] targets and
# cases, and the assembly files given as "target/kernel" paths.
BuildCorpus = Callable[[list[str] | None, str, list[str]], None]

PORTABLE = '[[case]]\nid = "portable"\nkernel = "portable"\ntargets = []\n'
GFX1250_ONLY = '[[case]]\nid = "only"\nkernel = "only"\ntargets = ["gfx1250"]\n'


def listing(target: str) -> str:
    """The start of a device assembly listing for *target*, as hipcc writes it."""
    return f'\t.amdgcn_target "amdgcn-amd-amdhsa-unknown-{target}"\n\ts_endpgm\n'


@pytest.fixture
def corpus(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> BuildCorpus:
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
        (tmp_path / "cases.toml").write_text(corpus_table(targets) + cases)
        (tmp_path / "kernels").mkdir(exist_ok=True)
        # The sources of the kernels the cases name, and no others.
        for kernel in re.findall(r'^kernel = "(\w+)"$', cases, flags=re.MULTILINE):
            (tmp_path / "kernels" / f"{kernel}.hip").write_text("")
        (tmp_path / "asm").mkdir(exist_ok=True)
        for path in asm:
            target, kernel = path.split("/")
            (tmp_path / "asm" / target).mkdir(exist_ok=True)
            (tmp_path / "asm" / target / "recipe.toml").write_text(GOOD_TEXT)
            (tmp_path / "asm" / target / f"{kernel}.s").write_text(listing(target))

    return build


def run(
    capsys: pytest.CaptureFixture[str],
) -> tuple[check_cases.ExitCode, str]:
    code = check_cases.main([])
    captured = capsys.readouterr()
    return code, captured.out + captured.err


def test_consistent_corpus_passes(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    corpus(
        targets=["gfx950", "gfx1250"],
        cases=PORTABLE + GFX1250_ONLY,
        asm=["gfx950/portable", "gfx1250/portable", "gfx1250/only"],
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.SUCCESS, out


def test_target_with_no_listings_passes(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str], tmp_path: Path
) -> None:
    # What regenerate_asm.py publishes when no case builds for a target any
    # more: the target's directory with only its recipe.
    corpus(targets=["gfx950", "gfx1250"], cases=GFX1250_ONLY, asm=["gfx1250/only"])
    (tmp_path / "asm" / "gfx950").mkdir()
    (tmp_path / "asm" / "gfx950" / "recipe.toml").write_text(GOOD_TEXT)
    code, out = run(capsys)
    assert code == check_cases.ExitCode.SUCCESS, out


def test_missing_target_directory_is_reported(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    # The corpus is built for gfx950 and gfx1250, but only gfx1250's assembly is
    # present. The target set comes from cases.toml, not from asm/, so the
    # missing directory and every gfx950 file in it are reported.
    corpus(
        targets=["gfx950", "gfx1250"],
        cases=PORTABLE + GFX1250_ONLY,
        asm=["gfx1250/portable", "gfx1250/only"],
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "asm/gfx950/ is missing" in out
    assert "asm/gfx950/portable.s is missing" in out


def test_case_target_outside_the_corpus_targets_is_reported(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    corpus(
        targets=["gfx950", "gfx1250"],
        cases=PORTABLE
        + '[[case]]\nid = "only"\nkernel = "only"\ntargets = ["gfx1201"]\n',
        asm=["gfx950/portable", "gfx1250/portable"],
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "lists target gfx1201, which is not in [corpus] targets" in out


def test_case_target_does_not_widen_portable_cases(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    # A case naming a new target, even with its assembly committed, does not make
    # every portable case build for that target: the manifest is rejected for
    # the case's target, and the portable case is not expected under
    # asm/gfx1201/. The stray directory is reported once the manifest is valid;
    # see test_assembly_directory_for_an_undeclared_target_is_reported.
    corpus(
        targets=["gfx950", "gfx1250"],
        cases=PORTABLE
        + '[[case]]\nid = "only"\nkernel = "only"\ntargets = ["gfx1201"]\n',
        asm=["gfx950/portable", "gfx1250/portable", "gfx1201/only"],
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert (
        "cases.toml [only]: lists target gfx1201, which is not in [corpus] targets"
        in out
    )
    assert "asm/gfx1201/portable.s is missing" not in out


def test_interrupted_publication_is_reported(
    corpus: BuildCorpus,
    capsys: pytest.CaptureFixture[str],
    tmp_path: Path,
) -> None:
    # regenerate_asm.py stages a target beside the committed ones and moves it
    # into place. A run killed in between leaves the staging directory, which
    # is not a corpus target, so the half-published state cannot pass.
    corpus(targets=["gfx950"], cases=PORTABLE, asm=["gfx950/portable"])
    (tmp_path / "asm" / ".gfx950.staging-1234").mkdir()
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "asm/.gfx950.staging-1234/ is not a corpus target" in out


def test_assembly_directory_for_an_undeclared_target_is_reported(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    corpus(
        targets=["gfx950"], cases=PORTABLE, asm=["gfx950/portable", "gfx1250/portable"]
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "asm/gfx1250/ is not a corpus target" in out


@pytest.mark.parametrize("targets", [None, []])
def test_manifest_without_targets_is_rejected(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str], targets: list[str] | None
) -> None:
    corpus(targets=targets, cases=PORTABLE, asm=["gfx950/portable"])
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "[corpus] targets" in out


def test_committed_manifest_declares_its_targets() -> None:
    manifest = tomllib.loads((CORPUS_DIR / "cases.toml").read_text())
    assert manifest["corpus"]["targets"] == ["gfx950", "gfx1250"]


# --- The inventory contract --------------------------------------------------
#
# No compiler is needed: the checker compares cases.toml with kernels/ and asm/
# on disk, so pytest keeps the manifest and the set of pinned files in step. It
# does not show that the assembly matches its source; that is the manual
# regenerate_asm.py --check.


def test_committed_inventory_passes(capsys: pytest.CaptureFixture[str]) -> None:
    # The real corpus, as committed, with no paths redirected.
    module = load_script("check_cases")
    code = module.main([])
    out = capsys.readouterr()
    assert code == check_cases.ExitCode.SUCCESS, out.err


def test_unknown_field_is_reported(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    corpus(
        targets=["gfx950"],
        cases=PORTABLE.replace("targets = []", "targets = []\nordinal = 3"),
        asm=["gfx950/portable"],
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "cases.toml [portable]: unknown field 'ordinal'" in out


def test_misspelled_case_table_is_rejected(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    corpus(
        targets=["gfx950"],
        cases=PORTABLE.replace("[[case]]", "[[cases]]"),
        asm=["gfx950/portable"],
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "cases.toml: unknown top-level key 'cases'" in out


def test_missing_assembly_is_reported(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    corpus(
        targets=["gfx950", "gfx1250"],
        cases=PORTABLE,
        asm=["gfx950/portable", "gfx1250/unrelated"],
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "cases.toml [portable]: asm/gfx1250/portable.s is missing" in out


def test_orphan_assembly_is_reported(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    corpus(
        targets=["gfx950"], cases=PORTABLE, asm=["gfx950/portable", "gfx950/leftover"]
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "asm/gfx950/leftover.s: no case builds leftover for gfx950" in out


def test_assembly_for_a_target_the_case_does_not_build_for_is_an_orphan(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    corpus(
        targets=["gfx950", "gfx1250"],
        cases=GFX1250_ONLY,
        asm=["gfx950/only", "gfx1250/only"],
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "asm/gfx950/only.s: no case builds only for gfx950" in out


def test_missing_kernel_source_is_reported(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str], tmp_path: Path
) -> None:
    corpus(targets=["gfx950"], cases=PORTABLE, asm=["gfx950/portable"])
    (tmp_path / "kernels" / "portable.hip").unlink()
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "cases.toml [portable]: kernels/portable.hip is missing" in out


def test_duplicate_id_and_kernel_are_reported(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    corpus(targets=["gfx950"], cases=PORTABLE + PORTABLE, asm=["gfx950/portable"])
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "cases.toml [portable]: duplicate id" in out
    assert (
        "cases.toml [portable]: kernel portable is already used by another case" in out
    )


# --- The per-case field is targets ---------------------------------------------
#
# A case's target allowlist is ``targets``, matching ``[corpus] targets``.
# ``requires`` means capabilities elsewhere in the repository, so it is not
# accepted here, and a case without ``targets`` builds for every corpus target.


def test_case_without_targets_builds_for_every_corpus_target(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    corpus(
        targets=["gfx950", "gfx1250"],
        cases='[[case]]\nid = "portable"\nkernel = "portable"\n',
        asm=["gfx950/portable", "gfx1250/portable"],
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.SUCCESS, out


def test_requires_is_rejected_with_its_new_name(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    corpus(
        targets=["gfx950", "gfx1250"],
        cases='[[case]]\nid = "only"\nkernel = "only"\nrequires = ["gfx1250"]\n',
        asm=["gfx1250/only"],
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "cases.toml [only]: 'requires' is now 'targets'" in out


# --- Each listing is for the target its directory names -------------------------
#
# A basic sanity check on the artifacts, not proof that they match their source:
# an empty file, or a listing for another target copied into the wrong directory,
# is caught without a compiler.


def write_asm(tmp_path: Path, target: str, kernel: str, text: str) -> None:
    (tmp_path / "asm" / target / f"{kernel}.s").write_text(text)


def test_empty_listing_is_reported(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str], tmp_path: Path
) -> None:
    corpus(targets=["gfx950"], cases=PORTABLE, asm=["gfx950/portable"])
    write_asm(tmp_path=tmp_path, target="gfx950", kernel="portable", text="")
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "asm/gfx950/portable.s: no .amdgcn_target directive" in out


def test_listing_for_another_target_is_reported(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str], tmp_path: Path
) -> None:
    corpus(
        targets=["gfx950", "gfx1250"],
        cases=PORTABLE,
        asm=["gfx950/portable", "gfx1250/portable"],
    )
    write_asm(
        tmp_path=tmp_path, target="gfx1250", kernel="portable", text=listing("gfx950")
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "asm/gfx1250/portable.s: .amdgcn_target is gfx950, not gfx1250" in out


def test_target_features_do_not_change_the_processor(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str], tmp_path: Path
) -> None:
    corpus(targets=["gfx950"], cases=PORTABLE, asm=["gfx950/portable"])
    write_asm(
        tmp_path=tmp_path,
        target="gfx950",
        kernel="portable",
        text='\t.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx950:sramecc+:xnack-"\n',
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.SUCCESS, out


def test_target_name_that_only_starts_with_the_directory_is_reported(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str], tmp_path: Path
) -> None:
    # gfx9500 is not gfx950: the processor is compared whole.
    corpus(targets=["gfx950"], cases=PORTABLE, asm=["gfx950/portable"])
    write_asm(
        tmp_path=tmp_path, target="gfx950", kernel="portable", text=listing("gfx9500")
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert ".amdgcn_target is gfx9500, not gfx950" in out


# --- Each target records its recipe ----------------------------------------------
#
# regenerate_asm.py writes asm/<target>/recipe.toml beside the assembly, and
# --check compares it to tell a changed recipe from a toolchain update. A
# regeneration commit that leaves it out is caught here, without a compiler.


def test_missing_recipe_is_reported(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str], tmp_path: Path
) -> None:
    corpus(targets=["gfx950"], cases=PORTABLE, asm=["gfx950/portable"])
    (tmp_path / "asm" / "gfx950" / "recipe.toml").unlink()
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "asm/gfx950/recipe.toml is missing" in out


# --- The recipe is read by the shared loader ----------------------------------------


@pytest.mark.parametrize("text, problem", BAD_RECIPES.values(), ids=BAD_RECIPES.keys())
def test_invalid_recipe_is_reported_as_the_shared_loader_reports_it(
    corpus: BuildCorpus,
    capsys: pytest.CaptureFixture[str],
    tmp_path: Path,
    text: str,
    problem: str,
) -> None:
    corpus(targets=["gfx950"], cases=PORTABLE, asm=["gfx950/portable"])
    (tmp_path / "asm" / "gfx950" / "recipe.toml").write_text(text)
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert f"asm/gfx950/recipe.toml: {problem}" in out


# --- Exit codes and the summary line ----------------------------------------------


def test_exit_codes_keep_their_public_numbers() -> None:
    # The numbers are part of the checker's interface: CI reads them.
    # Everything else names them.
    assert {code.name: int(code) for code in check_cases.ExitCode} == {
        "SUCCESS": 0,
        "PROBLEMS_FOUND": 1,
    }


def test_invalid_manifest_is_not_summarized_as_a_mismatch(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    corpus(targets=None, cases=PORTABLE, asm=[])
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "cases.toml is invalid: 1 problem(s)" in out
    assert "mismatch" not in out


def test_mismatch_is_summarized_as_one(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str]
) -> None:
    corpus(
        targets=["gfx950"], cases=PORTABLE, asm=["gfx950/portable", "gfx950/leftover"]
    )
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "1 mismatch(es) between cases.toml and the corpus" in out


# --- Every kernel source belongs to a case ------------------------------------------


def test_kernel_source_without_a_case_is_reported(
    corpus: BuildCorpus, capsys: pytest.CaptureFixture[str], tmp_path: Path
) -> None:
    corpus(targets=["gfx950"], cases=PORTABLE, asm=["gfx950/portable"])
    (tmp_path / "kernels" / "stray.hip").write_text("")
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert "kernels/stray.hip: no case uses it" in out


# --- A target directory holds only its listings and recipe -------------------------
#
# Regeneration replaces a target directory with its listings and recipe.toml,
# so anything else in it would be lost. The checker reports it first.


@pytest.mark.parametrize(
    "entry",
    ["NOTES.md", "add_checked.S", ".hidden", "subdirectory/"],
)
def test_stray_entry_in_a_target_directory_is_reported(
    corpus: BuildCorpus,
    capsys: pytest.CaptureFixture[str],
    tmp_path: Path,
    entry: str,
) -> None:
    corpus(targets=["gfx950"], cases=PORTABLE, asm=["gfx950/portable"])
    stray = tmp_path / "asm" / "gfx950" / entry.rstrip("/")
    if entry.endswith("/"):
        stray.mkdir()
    else:
        stray.write_text("")
    code, out = run(capsys)
    assert code == check_cases.ExitCode.PROBLEMS_FOUND
    assert (
        f"asm/gfx950/{entry}: not a listing or recipe.toml; regenerating gfx950 "
        f"would remove it"
    ) in out
