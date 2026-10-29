# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
import subprocess
import sys
import tomllib
from pathlib import Path

import pytest

from support.race_corpus import CORPUS_DIR, SCRIPTS_DIR, corpus_table, load_script

generate = load_script("generate")
protocol = sys.modules["detector_protocol"]

REPO_ROOT = CORPUS_DIR.parents[1]

# A case on every target. Each listing loads a register and reads it after its
# one wait, so removing the wait is a vgpr RAW.
PORTABLE = '[[case]]\nid = "only"\nkernel = "only"\nmutate = ["wait"]\nhazard = "RAW"\n'
LISTINGS = {
    "gfx950": "\tglobal_load_dword v1, v0, s[0:1]\n\ts_waitcnt vmcnt(0)\n"
    "\tv_add_u32_e32 v2, v1, v1\n",
    "gfx1250": "\tglobal_load_b32 v1, v0, s[0:1]\n\ts_wait_loadcnt 0x0\n"
    "\tv_add_nc_u32_e32 v2, v1, v1\n",
}
GFX1250_ONLY = PORTABLE.replace(
    'mutate = ["wait"]', 'targets = ["gfx1250"]\nmutate = ["wait"]'
)


@pytest.fixture
def scratch(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Path:
    """A scratch corpus root with generate pointed at it; returns the root."""
    monkeypatch.setattr(generate, "CASES_PATH", tmp_path / "cases.toml")
    monkeypatch.setattr(generate, "ASM_DIR", tmp_path / "asm")
    monkeypatch.setattr(generate, "MANIFEST_PATH", tmp_path / "mutants.toml")
    return tmp_path


def write_corpus(root: Path, cases: str, listings: dict[str, str]) -> None:
    """cases.toml with *cases*, and asm/<target>/only.s for each listing body."""
    (root / "cases.toml").write_text(
        corpus_table(["gfx950", "gfx1250"]) + cases, encoding="utf-8"
    )
    for target, body in listings.items():
        (root / "asm" / target).mkdir(parents=True, exist_ok=True)
        (root / "asm" / target / "only.s").write_text(body)


def rows_of(root: Path, targets: list[str]) -> list["generate.MutantRow"]:
    return generate.generate(generate.load_corpus(), targets)


def pin(table: str, site: str, target: str | None = None, extra: str = "") -> str:
    """A [[case.<table>]] for wait ordinal 0 at *site*, on *target* if given."""
    scope = f'target = "{target}"\n' if target else ""
    return (
        f'[[case.{table}]]\n{scope}kind = "wait"\nordinal = 0\nsite = "{site}"\n'
        f'reason = "r"\n{extra}'
    )


# --- Rows ------------------------------------------------------------------------


def test_case_is_generated_only_for_its_targets(
    scratch: Path, capsys: pytest.CaptureFixture[str]
) -> None:
    write_corpus(scratch, GFX1250_ONLY, listings={"gfx1250": LISTINGS["gfx1250"]})
    rows = rows_of(scratch, ["gfx950", "gfx1250"])
    assert [(row.target, row.id) for row in rows] == [("gfx1250", "only.wait000")]


def test_ids_are_target_local_and_sites_are_signatures(scratch: Path) -> None:
    write_corpus(scratch, PORTABLE, listings=LISTINGS)
    rows = rows_of(scratch, ["gfx950", "gfx1250"])
    assert [(row.target, row.id, row.site) for row in rows] == [
        ("gfx950", "only.wait000", "s_waitcnt vmcnt(0)"),
        ("gfx1250", "only.wait000", "s_wait_loadcnt 0x0"),
    ]
    assert {(row.resource, row.hazard) for row in rows} == {("vgpr", "RAW")}


def test_repeated_target_and_id_is_rejected() -> None:
    row = generate.MutantRow(
        id="k.wait000",
        case="k",
        kernel="k",
        target="gfx950",
        kind="wait",
        ordinal=0,
        resource="vgpr",
        hazard="RAW",
        site="s_waitcnt vmcnt(0)",
    )
    with pytest.raises(
        generate.GenerationError,
        match=r"\(target, id\) must be unique, but these repeat: gfx950/k\.wait000",
    ):
        generate.check_unique_keys([row, row])


def test_invalid_inventory_is_reported(scratch: Path) -> None:
    # Two cases sharing a kernel would give their mutants the same keys.
    write_corpus(
        scratch, PORTABLE + PORTABLE.replace('"only"\nkernel', '"b"\nkernel'), {}
    )
    with pytest.raises(
        generate.GenerationError, match="kernel only is already used by another case"
    ):
        generate.load_corpus()


# --- Pins: exemptions and tag overrides -----------------------------------------


def test_targeted_exemption_applies_only_to_its_target(scratch: Path) -> None:
    write_corpus(
        scratch, PORTABLE + pin("exempt", "s_wait_loadcnt 0x0", "gfx1250"), LISTINGS
    )
    rows = rows_of(scratch, ["gfx950", "gfx1250"])
    assert {row.target for row in rows if row.exempt_reason} == {"gfx1250"}


def test_untargeted_pin_must_match_on_every_target(scratch: Path) -> None:
    # Without a target it applies to gfx950 too, where ordinal 0 is s_waitcnt.
    write_corpus(scratch, PORTABLE + pin("exempt", "s_wait_loadcnt 0x0"), LISTINGS)
    with pytest.raises(
        generate.GenerationError,
        match=r"a pinned wait ordinal 0 is 's_waitcnt vmcnt\(0\)' at "
        r"asm/gfx950/only.s:2, not 's_wait_loadcnt 0x0'",
    ):
        rows_of(scratch, ["gfx950", "gfx1250"])


# --- Memory sites ----------------------------------------------------------------

MEMORY_CASE = GFX1250_ONLY.replace('mutate = ["wait"]', 'mutate = ["memory"]')


@pytest.mark.parametrize(
    "load, tag",
    [
        ("global_load_u8 v1, v0, s[0:1]", ("global", "RAW")),
        ("ds_load_u8 v1, v0", None),
    ],
)
def test_memory_site_takes_its_address_space(
    scratch: Path, load: str, tag: tuple[str, str] | None
) -> None:
    write_corpus(scratch, MEMORY_CASE, {"gfx1250": f"\t{load}\n"})
    rows = rows_of(scratch, ["gfx1250"])
    # ds_load_u8 is not a sub-dword load the memory mutation rewrites.
    assert [(row.resource, row.hazard) for row in rows] == ([tag] if tag else [])


def test_flat_memory_site_needs_a_tag(scratch: Path) -> None:
    write_corpus(scratch, MEMORY_CASE, {"gfx1250": "\tflat_load_u8 v1, v[0:1]\n"})
    with pytest.raises(
        generate.GenerationError, match=r"\(flat_load_u8\) does not say which memory"
    ):
        rows_of(scratch, ["gfx1250"])


# --- The committed manifest ------------------------------------------------------


def committed_mutants() -> dict[tuple[str, str], dict[str, object]]:
    mutants = tomllib.loads(generate.MANIFEST_PATH.read_text())["mutant"]
    return {(mutant["target"], mutant["id"]): mutant for mutant in mutants}


def test_committed_memory_sites_race_between_workgroups() -> None:
    memory = [m for m in committed_mutants().values() if m["kind"] == "memory"]
    assert memory and all(
        (m["resource"], m["hazard"]) == ("global", "GlobalMemoryRace") for m in memory
    )


def test_committed_exemptions() -> None:
    exempt = {
        key for key, mutant in committed_mutants().items() if mutant.get("exempt")
    }
    assert exempt == {
        ("gfx950", "lds_war_pattern.wait002"),
        ("gfx950", "lds_war_pattern.wait004"),
        ("gfx1250", "lds_war_pattern.wait002"),
        ("gfx1250", "lds_war_pattern.wait004"),
        ("gfx1250", "wmma_rocwmma.wait003"),
    }


def test_committed_manifest_has_unique_keys() -> None:
    mutants = tomllib.loads(generate.MANIFEST_PATH.read_text())["mutant"]
    keys = [(mutant["target"], mutant["id"]) for mutant in mutants]
    assert len(keys) == len(set(keys))
    # The ids alone repeat across targets, which is why the pair is the key.
    assert len({mutant["id"] for mutant in mutants}) < len(keys)


def test_manifest_header_defines_the_key() -> None:
    header = generate.render_manifest([], ["gfx950"])
    assert "A mutant is identified by (target, id), which is unique" in header
    assert "never by id alone" in header


@pytest.mark.parametrize(
    "command",
    [
        [SCRIPTS_DIR / "generate.py", "--check"],
        [SCRIPTS_DIR / "check_cases.py"],
    ],
    ids=["generate.py --check", "check_cases.py"],
)
def test_committed_corpus_passes_its_command_line_checks(command: list[Path]) -> None:
    # Run as a user runs them, from the repository root, so a stale manifest
    # or inventory fails the suite.
    result = subprocess.run(
        [sys.executable, *map(str, command)],
        cwd=REPO_ROOT,
        capture_output=True,
        text=True,
        check=False,
    )
    assert result.returncode == 0, result.stdout + result.stderr
