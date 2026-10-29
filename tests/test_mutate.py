# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
from pathlib import Path

import pytest

from support.race_corpus import import_module

mutate = import_module("mutate")

# A gfx1250 listing: three wait sites (ordinals 0-2), and what is not one.
GFX1250 = """\
\t.amdgcn_target "amdgcn-amd-amdhsa--gfx1250"
kernel:
\ts_load_b32 s2, s[0:1], 0x24
\ts_wait_kmcnt 0x0
\tglobal_load_b32 v1, v0, s[0:1]
\ts_wait_xcnt 0x0
; s_wait_storecnt 0x0 in a comment
\ts_wait_loadcnt_dscnt 0x0  ; combined
\tglobal_load_u8 v2, v0, s[0:1] offset:1
\ts_wait_loadcnt 0x1
\ts_endpgm
"""

# A gfx950 listing: two waits whose counters are in the operand.
GFX950 = """\
kernel:
\ts_waitcnt vmcnt(0) lgkmcnt(0)
\tflat_load_ubyte v0, v[0:1] offset:1 sc0 sc1
\ts_waitcnt lgkmcnt(1)
\ts_endpgm
"""


@pytest.fixture
def gfx1250(tmp_path: Path) -> Path:
    path = tmp_path / "gfx1250.s"
    path.write_text(GFX1250)
    return path


@pytest.fixture
def gfx950(tmp_path: Path) -> Path:
    path = tmp_path / "gfx950.s"
    path.write_text(GFX950)
    return path


# --- Wait sites ------------------------------------------------------------------


def test_wait_sites_are_enumerated_in_order(gfx1250: Path) -> None:
    sites = mutate.find_wait_sites(gfx1250)
    # s_wait_xcnt is out of scope, and a wait in a comment is not code.
    assert [(s.ordinal, s.line_number, s.mnemonic, s.operand) for s in sites] == [
        (0, 3, "s_wait_kmcnt", "0x0"),
        (1, 7, "s_wait_loadcnt_dscnt", "0x0"),
        (2, 9, "s_wait_loadcnt", "0x1"),
    ]


def test_excluded_waits_can_be_included(gfx1250: Path) -> None:
    sites = mutate.find_wait_sites(gfx1250, excluded_waits=frozenset())
    assert [s.mnemonic for s in sites] == [
        "s_wait_kmcnt",
        "s_wait_xcnt",
        "s_wait_loadcnt_dscnt",
        "s_wait_loadcnt",
    ]


# --- Memory sites ----------------------------------------------------------------


def test_memory_sites_rewrite_the_load_as_a_store(gfx1250: Path, gfx950: Path) -> None:
    (site,) = mutate.find_memory_sites(gfx1250)
    assert site.ordinal == 0 and site.line_number == 8
    assert site.load_mnemonic == "global_load_u8"
    # Address and data swap places; the scalar base and offset stay.
    assert site.rewritten_line == "global_store_b8 v0, v2, s[0:1] offset:1"
    (flat,) = mutate.find_memory_sites(gfx950)
    # A flat store's address comes first; cache flags follow the last operand.
    assert flat.rewritten_line == "flat_store_byte v[0:1], v0 offset:1 sc0 sc1"


def test_full_dword_loads_are_not_memory_sites(gfx1250: Path) -> None:
    sites = mutate.find_memory_sites(gfx1250)
    assert [s.load_mnemonic for s in sites] == ["global_load_u8"]


# --- Applying a mutation ---------------------------------------------------------


def test_wait_mutation_replaces_one_wait_with_a_nop(
    gfx1250: Path, tmp_path: Path
) -> None:
    out = tmp_path / "mutant.s"
    site = mutate.apply_mutation(gfx1250, "wait", 1, out)
    assert site.mnemonic == "s_wait_loadcnt_dscnt"
    original, mutant = GFX1250.splitlines(), out.read_text().splitlines()
    assert [i for i, (a, b) in enumerate(zip(original, mutant)) if a != b] == [7]
    assert mutant[7] == (
        "\ts_nop 0  ; MUTANT: removed s_wait_loadcnt_dscnt 0x0  ; combined"
    )


def test_memory_mutation_rewrites_one_load(gfx1250: Path, tmp_path: Path) -> None:
    out = tmp_path / "mutant.s"
    mutate.apply_mutation(gfx1250, "memory", 0, out)
    original, mutant = GFX1250.splitlines(), out.read_text().splitlines()
    assert [i for i, (a, b) in enumerate(zip(original, mutant)) if a != b] == [8]
    assert mutant[8] == (
        "\tglobal_store_b8 v0, v2, s[0:1] offset:1  ; MUTANT: load->store "
        "global_load_u8 v2, v0, s[0:1] offset:1"
    )


def test_ordinal_past_the_sites_is_stale(gfx1250: Path, tmp_path: Path) -> None:
    with pytest.raises(
        mutate.StaleOrdinalError, match="wait ordinal 3 is out of range"
    ):
        mutate.apply_mutation(gfx1250, "wait", 3, tmp_path / "mutant.s")
    assert not (tmp_path / "mutant.s").exists()


def test_unknown_kind_is_rejected(gfx1250: Path, tmp_path: Path) -> None:
    with pytest.raises(ValueError, match="unknown mutation kind 'swap'"):
        mutate.find_sites(gfx1250, "swap")
    with pytest.raises(ValueError, match="unknown mutation kind 'swap'"):
        mutate.apply_mutation(gfx1250, "swap", 0, tmp_path / "mutant.s")
