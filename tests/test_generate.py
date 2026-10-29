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
GFX1250_ONLY = PORTABLE.replace('hazard = "RAW"', 'targets = ["gfx1250"]')


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


def test_tag_override_replaces_the_derived_tag(scratch: Path) -> None:
    override = pin(
        "tag", "s_wait_loadcnt 0x0", "gfx1250", 'resource = "lds"\nhazard = "WAR"\n'
    )
    write_corpus(scratch, PORTABLE + override, LISTINGS)
    rows = rows_of(scratch, ["gfx950", "gfx1250"])
    assert {row.target: (row.resource, row.hazard) for row in rows} == {
        "gfx950": ("vgpr", "RAW"),
        "gfx1250": ("lds", "WAR"),
    }


def test_wait_that_exposes_nothing_must_be_settled(scratch: Path) -> None:
    # The second wait retires nothing: the first one already did.
    listing = (
        "\ts_load_b32 s2, s[0:1], 0x24\n\ts_wait_kmcnt 0x0\n"
        "\ts_and_b32 s3, s2, 0xffff\n\ts_wait_kmcnt 0x0\n"
    )
    write_corpus(scratch, GFX1250_ONLY, {"gfx1250": listing})
    with pytest.raises(
        generate.GenerationError,
        match=r"only \(gfx1250\): wait ordinal 1 \(s_wait_kmcnt 0x0\): removing the "
        r"wait exposes nothing",
    ):
        rows_of(scratch, ["gfx1250"])


def test_settled_wait_takes_its_override(scratch: Path) -> None:
    listing = (
        "\ts_load_b32 s2, s[0:1], 0x24\n\ts_wait_kmcnt 0x0\n"
        "\ts_and_b32 s3, s2, 0xffff\n\ts_wait_kmcnt 0x0\n"
    )
    exempt = pin("exempt", "s_wait_kmcnt 0x0").replace("ordinal = 0", "ordinal = 1")
    tag = pin(
        "tag", "s_wait_kmcnt 0x0", extra='resource = "sgpr"\nhazard = "RAW"\n'
    ).replace("ordinal = 0", "ordinal = 1")
    write_corpus(scratch, GFX1250_ONLY + exempt + tag, {"gfx1250": listing})
    second = rows_of(scratch, ["gfx1250"])[1]
    assert (second.resource, second.hazard, second.exempt_reason) == (
        "sgpr",
        "RAW",
        "r",
    )


# --- Memory sites ----------------------------------------------------------------

MEMORY_CASE = GFX1250_ONLY.replace('mutate = ["wait"]', 'mutate = ["memory"]')


@pytest.mark.parametrize(
    "load, tag",
    [
        ("global_load_u8 v1, v0, s[0:1]", ("global", "GlobalMemoryRace")),
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
        generate.GenerationError, match=r"flat_load_u8 does not say which memory"
    ):
        rows_of(scratch, ["gfx1250"])


# --- The manifest is never written incomplete ------------------------------------


def generate_main(*argv: str) -> "generate.ExitCode":
    return generate.main(list(argv))


def test_missing_assembly_aborts_and_keeps_the_manifest(
    scratch: Path, capsys: pytest.CaptureFixture[str]
) -> None:
    write_corpus(scratch, PORTABLE, LISTINGS)
    assert generate_main() == generate.ExitCode.SUCCESS
    committed = (scratch / "mutants.toml").read_text()
    (scratch / "asm" / "gfx950" / "only.s").unlink()
    capsys.readouterr()
    assert generate_main() == generate.ExitCode.FAILED
    assert "missing assembly" in capsys.readouterr().err
    assert (scratch / "mutants.toml").read_text() == committed
    # --check does not pass on what it cannot generate either.
    assert generate_main("--check") == generate.ExitCode.FAILED


def test_target_subset_keeps_the_other_targets(scratch: Path) -> None:
    write_corpus(scratch, PORTABLE, LISTINGS)
    assert generate_main() == generate.ExitCode.SUCCESS
    committed = (scratch / "mutants.toml").read_text()
    assert generate_main("--target", "gfx950") == generate.ExitCode.SUCCESS
    assert (scratch / "mutants.toml").read_text() == committed
    assert generate_main("--check", "--target", "gfx950") == generate.ExitCode.SUCCESS


def test_target_subset_regenerates_only_its_target(scratch: Path) -> None:
    write_corpus(scratch, PORTABLE, LISTINGS)
    assert generate_main() == generate.ExitCode.SUCCESS
    # gfx1250 gains a second wait site, and so a second mutant.
    (scratch / "asm" / "gfx1250" / "only.s").write_text(
        LISTINGS["gfx1250"] + "\tglobal_load_b32 v3, v0, s[0:1]\n\ts_wait_loadcnt 0x0\n"
        "\tv_add_nc_u32_e32 v4, v3, v3\n"
    )
    assert generate_main("--check", "--target", "gfx950") == generate.ExitCode.SUCCESS
    assert (
        generate_main("--check", "--target", "gfx1250") == generate.ExitCode.OUT_OF_DATE
    )
    assert generate_main("--target", "gfx950") == generate.ExitCode.SUCCESS
    manifest = tomllib.loads((scratch / "mutants.toml").read_text())
    assert manifest["manifest"]["targets"] == ["gfx1250", "gfx950"]
    # gfx1250's committed row is kept, not regenerated.
    assert [(m["target"], m["id"]) for m in manifest["mutant"]] == [
        ("gfx1250", "only.wait000"),
        ("gfx950", "only.wait000"),
    ]
    assert generate_main("--target", "gfx1250") == generate.ExitCode.SUCCESS
    manifest = tomllib.loads((scratch / "mutants.toml").read_text())
    assert len(manifest["mutant"]) == 3


def test_target_subset_without_committed_rows_is_rejected(
    scratch: Path, capsys: pytest.CaptureFixture[str]
) -> None:
    write_corpus(scratch, PORTABLE, LISTINGS)
    assert generate_main("--target", "gfx950") == generate.ExitCode.FAILED
    assert "mutants.toml has no rows for gfx1250 to keep" in capsys.readouterr().err
    assert not (scratch / "mutants.toml").exists()


def test_unknown_target_is_a_usage_error(scratch: Path) -> None:
    write_corpus(scratch, PORTABLE, LISTINGS)
    with pytest.raises(SystemExit) as exit_info:
        generate_main("--target", "gfx1201")
    assert exit_info.value.code == 2


# --- The committed manifest ------------------------------------------------------


def committed_mutants() -> dict[tuple[str, str], dict[str, object]]:
    mutants = tomllib.loads(generate.MANIFEST_PATH.read_text())["mutant"]
    return {(mutant["target"], mutant["id"]): mutant for mutant in mutants}


# Pinned sites whose tags follow from their own dependency, not their case's
# declared hazard: (target, id) -> (resource, hazard, site).
PINNED_TAGS = {
    # The prologue's kernarg load, read by SALU: SGPR RAW, though the case
    # is a WAW (or WAR) kernel.
    ("gfx1250", "waw_pattern.wait000"): ("sgpr", "RAW", "s_wait_kmcnt 0x0"),
    ("gfx1250", "war_pattern.wait000"): ("sgpr", "RAW", "s_wait_kmcnt 0x0"),
    # The waw_pattern load's result is stored: VGPR RAW.
    ("gfx1250", "waw_pattern.wait002"): ("vgpr", "RAW", "s_wait_loadcnt 0x0"),
    # A DS read consumed by a VALU op: the register, not LDS.
    ("gfx1250", "lds_reduce.wait003"): ("vgpr", "RAW", "s_wait_dscnt 0x0"),
    # A combined counter, attributed to the flat load it retires.
    ("gfx1250", "pointer_chase.wait003"): ("vgpr", "RAW", "s_wait_loadcnt_dscnt 0x0"),
    # A DS store in flight at a barrier: another wave's read races it.
    ("gfx1250", "fa_barrier_epoch.wait002"): (
        "lds",
        "LocalMemoryRace",
        "s_wait_dscnt 0",
    ),
    ("gfx950", "lds_reduce.wait002"): (
        "lds",
        "LocalMemoryRace",
        "s_waitcnt lgkmcnt(0)",
    ),
    # The tensor load into LDS, read by a DS load.
    ("gfx1250", "tensor_lds.wait003"): ("lds", "RAW", "s_wait_tensorcnt 0"),
    # s_mov writes s11 while the dwordx8 load into s[4:11] is in flight.
    ("gfx950", "add_buffer.wait000"): ("sgpr", "WAW", "s_waitcnt lgkmcnt(0)"),
    # Retires nothing, so its tag is given by a [[case.tag]].
    ("gfx1250", "wmma_rocwmma.wait003"): ("sgpr", "RAW", "s_wait_kmcnt 0x0"),
}


@pytest.mark.parametrize("key, tag", PINNED_TAGS.items(), ids=lambda k: str(k))
def test_committed_site_tag(key: tuple[str, str], tag: tuple[str, str, str]) -> None:
    mutant = committed_mutants()[key]
    assert (mutant["resource"], mutant["hazard"], mutant["site"]) == tag


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


class RegisterOnlyDetector:
    """A detector of register hazards inside a wave, and nothing on LDS."""

    name = "registers"
    supports = protocol.capability({"sgpr", "vgpr", "agpr"}, {"RAW", "WAR", "WAW"})
    needs_execution = False


@pytest.mark.parametrize(
    "key, in_scope",
    [
        (("gfx1250", "lds_reduce.wait003"), True),
        (("gfx1250", "lds_reduce.wait002"), False),
        (("gfx1250", "waw_pattern.wait000"), True),
        (("gfx1250", "tensor_lds.wait003"), False),
        (("gfx950", "add_buffer.wait000"), True),
    ],
)
def test_committed_tags_decide_scope(key: tuple[str, str], in_scope: bool) -> None:
    mutant = committed_mutants()[key]
    reason = protocol.out_of_scope_reason(
        RegisterOnlyDetector(), mutant["resource"], mutant["hazard"]
    )
    assert (reason is None) == in_scope


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
