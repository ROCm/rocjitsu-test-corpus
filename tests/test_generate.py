# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
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
