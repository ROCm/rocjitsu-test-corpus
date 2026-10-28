# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
import tomllib
from pathlib import Path

import pytest

from support.race_corpus import corpus_table, load_script

generate = load_script("generate")

# A case that builds only for gfx1250, with its resource pinned so that tagging
# needs no memory operation before the wait.
GFX1250_ONLY = (
    '[[case]]\nid = "only"\nkernel = "only"\ntargets = ["gfx1250"]\n'
    'mutate = ["wait"]\nhazard = "RAW"\nresource = "vgpr"\n'
)


@pytest.fixture
def scratch(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Path:
    """A scratch corpus root with generate pointed at it; returns the root."""
    monkeypatch.setattr(generate, "CORPUS_ROOT", tmp_path)
    monkeypatch.setattr(generate, "ASM_DIR", tmp_path / "asm")
    return tmp_path


def write_corpus(root: Path, cases: str, listings: dict[str, str]) -> None:
    """cases.toml with *cases*, and asm/<target>/only.s for each listing body."""
    (root / "cases.toml").write_text(
        corpus_table(["gfx950", "gfx1250"]) + cases, encoding="utf-8"
    )
    for target, body in listings.items():
        (root / "asm" / target).mkdir(parents=True)
        (root / "asm" / target / "only.s").write_text(body)


def test_cases_are_read_with_their_targets(scratch: Path) -> None:
    portable = '[[case]]\nid = "p"\nkernel = "p"\nhazard = "RAW"\n'
    write_corpus(scratch, GFX1250_ONLY + portable, listings={})
    only, any_target = generate.load_cases()
    assert only.targets == ["gfx1250"]
    assert any_target.targets == []


def test_case_is_skipped_for_a_target_it_does_not_build_for(
    scratch: Path, capsys: pytest.CaptureFixture[str]
) -> None:
    write_corpus(scratch, GFX1250_ONLY, listings={"gfx1250": "\ts_wait_loadcnt 0x0\n"})
    rows = generate.generate(["gfx950", "gfx1250"])
    assert [row["target"] for row in rows] == ["gfx1250"]
    captured = capsys.readouterr()
    # Skipped, not reported as a missing gfx950 listing.
    assert "skip: only (gfx950): builds only for gfx1250" in captured.out
    assert "FAIL" not in captured.err


def test_committed_mutants_match_the_committed_corpus(
    capsys: pytest.CaptureFixture[str],
) -> None:
    targets = sorted(path.name for path in generate.ASM_DIR.iterdir() if path.is_dir())
    rendered = generate.render_manifest(generate.generate(targets), targets)
    assert rendered == generate.MANIFEST_PATH.read_text()
    # Every case is generated for, or skipped on, each target: none is missing
    # a listing because its targets were not read.
    assert "FAIL" not in capsys.readouterr().err


# --- A mutant is identified by (target, id) ------------------------------------

# A case on every target, with one wait in each target's listing.
PORTABLE = (
    '[[case]]\nid = "only"\nkernel = "only"\nmutate = ["wait"]\nhazard = "RAW"\n'
    'resource = "vgpr"\n'
)
LISTINGS = {"gfx950": "\ts_waitcnt vmcnt(0)\n", "gfx1250": "\ts_wait_loadcnt 0x0\n"}


def test_ids_are_target_local_and_the_pair_is_unique(scratch: Path) -> None:
    write_corpus(scratch, PORTABLE, listings=LISTINGS)
    rows = generate.generate(["gfx950", "gfx1250"])
    # One id, naming a different instruction on each target.
    assert {(row["target"], row["id"], row["site"]) for row in rows} == {
        ("gfx950", "only.wait000", "s_waitcnt"),
        ("gfx1250", "only.wait000", "s_wait_loadcnt"),
    }


def test_repeated_target_and_id_is_rejected(scratch: Path) -> None:
    # Two cases sharing a kernel give every mutant of it the same (target, id).
    second = PORTABLE.replace('id = "only"', 'id = "again"')
    write_corpus(scratch, PORTABLE + second, listings=LISTINGS)
    with pytest.raises(
        SystemExit,
        match=r"\(target, id\) must be unique, but these repeat: "
        r"gfx1250/only\.wait000, gfx950/only\.wait000",
    ):
        generate.generate(["gfx950", "gfx1250"])


def test_manifest_header_defines_the_key() -> None:
    header = generate.render_manifest([], ["gfx950"])
    assert "A mutant is identified by (target, id), which is unique" in header
    assert "never by id alone" in header


def test_committed_manifest_has_unique_keys() -> None:
    mutants = tomllib.loads(generate.MANIFEST_PATH.read_text())["mutant"]
    keys = [(mutant["target"], mutant["id"]) for mutant in mutants]
    assert len(keys) == len(set(keys))
    # The ids alone repeat across targets, which is why the pair is the key.
    assert len({mutant["id"] for mutant in mutants}) < len(keys)


# --- Exemptions can be scoped to the target they were checked against ----------


def exemption(site: str, target: str | None = None) -> str:
    """A [[case.exempt]] table for wait ordinal 0 at *site*, on *target* if given."""
    scope = f'target = "{target}"\n' if target else ""
    return (
        f'[[case.exempt]]\n{scope}kind = "wait"\nordinal = 0\nsite = "{site}"\n'
        'reason = "harmless"\n'
    )


def exempt_targets(rows: list[dict]) -> set[str]:
    return {row["target"] for row in rows if row.get("exempt")}


def test_targeted_exemption_applies_only_to_its_target(scratch: Path) -> None:
    write_corpus(
        scratch, PORTABLE + exemption("s_wait_loadcnt", "gfx1250"), listings=LISTINGS
    )
    rows = generate.generate(["gfx950", "gfx1250"])
    assert exempt_targets(rows) == {"gfx1250"}


def test_one_exemption_per_target_with_its_own_site(scratch: Path) -> None:
    exemptions = exemption("s_waitcnt", "gfx950") + exemption(
        "s_wait_loadcnt", "gfx1250"
    )
    write_corpus(scratch, PORTABLE + exemptions, listings=LISTINGS)
    rows = generate.generate(["gfx950", "gfx1250"])
    assert exempt_targets(rows) == {"gfx950", "gfx1250"}


def test_untargeted_exemption_must_match_the_site_on_every_target(
    scratch: Path,
) -> None:
    # Without a target the exemption applies to gfx950 too, where ordinal 0 is
    # s_waitcnt, so it is stale there.
    write_corpus(scratch, PORTABLE + exemption("s_wait_loadcnt"), listings=LISTINGS)
    with pytest.raises(
        SystemExit,
        match="expects 's_wait_loadcnt', but gfx950 codegen puts 's_waitcnt'",
    ):
        generate.generate(["gfx950", "gfx1250"])


def test_committed_lds_war_pattern_exempts_its_unprotected_waits() -> None:
    mutants = tomllib.loads(generate.MANIFEST_PATH.read_text())["mutant"]
    exempt = {
        (mutant["target"], mutant["id"])
        for mutant in mutants
        if mutant["case"] == "lds-war-pattern" and mutant.get("exempt")
    }
    assert exempt == {
        (target, f"lds_war_pattern.wait00{ordinal}")
        for target in ("gfx950", "gfx1250")
        for ordinal in (2, 4)
    }
