# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
import pytest

from support.race_corpus import import_module

exposure = import_module("exposure")

# The line the mutated wait is on, in each listing below.
WAIT = "MUTATED"


def expose(listing: str, target: str) -> "exposure.Tag | None":
    """What removing the wait marked ``; MUTATED`` in *listing* exposes."""
    lines = listing.splitlines()
    wait_line = next(i for i, line in enumerate(lines) if WAIT in line)
    return exposure.expose(lines, wait_line, target)


def tag(listing: str, target: str) -> tuple[str, str, str]:
    """The resource, hazard and witness instruction that *listing* exposes."""
    found = expose(listing, target)
    assert found is not None
    return found.resource, found.hazard, found.witness.text


# --- Reading instructions --------------------------------------------------------


@pytest.mark.parametrize(
    "token, register",
    [
        ("s5", exposure.Register(kind="s", low=5, high=5)),
        ("s[4:7]", exposure.Register(kind="s", low=4, high=7)),
        ("v[2:3]", exposure.Register(kind="v", low=2, high=3)),
        ("a0", exposure.Register(kind="a", low=0, high=0)),
        ("vcc", None),
        ("vcc_lo", None),
        ("0x24", None),
        ("null", None),
    ],
)
def test_parse_register(token: str, register: "exposure.Register | None") -> None:
    assert exposure.parse_register(token) == register


def regs(*tokens: str) -> tuple["exposure.Register", ...]:
    return tuple(exposure.parse_register(token) for token in tokens)


@pytest.mark.parametrize(
    "text, writes, reads",
    [
        ("v_add_nc_u32_e32 v2, v7, v6", ("v2",), ("v7", "v6")),
        ("global_store_b32 v0, v1, s[2:3]", (), ("v0", "v1", "s[2:3]")),
        ("ds_write_b32 v1, v3", (), ("v1", "v3")),
        ("ds_add_u32 v1, v3", (), ("v1", "v3")),
        ("ds_add_rtn_u32 v2, v1, v3", ("v2",), ("v1", "v3")),
        ("global_atomic_add_u32 v0, v1, s[0:1]", (), ("v0", "v1", "s[0:1]")),
        (
            "global_atomic_add_u32 v2, v0, v1, s[0:1] th:TH_ATOMIC_RETURN",
            ("v2",),
            ("v0", "v1", "s[0:1]"),
        ),
        ("v_add_co_u32_e64 v2, s[0:1], v3, v4", ("v2", "s[0:1]"), ("v3", "v4")),
        ("v_cmpx_ne_u32_e32 1, v2", (), ("v2",)),
        (
            "v_dual_mov_b32 v1, v2 :: v_dual_add_f32 v3, v4, v5",
            ("v1", "v3"),
            ("v2", "v4", "v5"),
        ),
        ("tensor_load_to_lds s[16:19], s[4:11]", (), ("s[16:19]", "s[4:11]")),
    ],
)
def test_instruction_reads_and_writes(
    text: str, writes: tuple[str, ...], reads: tuple[str, ...]
) -> None:
    instruction = exposure.parse_instruction(0, f"\t{text} ; comment")
    assert instruction.writes == regs(*writes)
    assert instruction.reads == regs(*reads)


@pytest.mark.parametrize("line", ["", "; comment", ".LBB0_2:", "\t.p2align 8"])
def test_non_instructions_are_skipped(line: str) -> None:
    assert exposure.parse_instruction(0, line) is None


# --- Dependencies inside a wave --------------------------------------------------


def test_scalar_load_read_after_the_wait_is_sgpr_raw() -> None:
    listing = """
\ts_load_b32 s2, s[0:1], 0x24
\ts_wait_kmcnt 0x0 ; MUTATED
\ts_and_b32 s3, s2, 0xffff
"""
    assert tag(listing, "gfx1250") == ("sgpr", "RAW", "s_and_b32 s3, s2, 0xffff")


def test_overwriting_a_scalar_load_destination_is_sgpr_waw() -> None:
    # gfx950's add_buffer: the late load could overwrite s11 after the s_mov.
    listing = """
\ts_load_dwordx8 s[4:11], s[0:1], 0x0
\ts_waitcnt lgkmcnt(0) ; MUTATED
\ts_mov_b32 s11, s15
\ts_and_b32 s0, s11, 0xffff
"""
    assert tag(listing, "gfx950") == ("sgpr", "WAW", "s_mov_b32 s11, s15")


def test_ds_read_exposes_its_destination_register_not_lds() -> None:
    # lds_reduce.wait003: the DS read's result is consumed by a VALU op.
    listing = """
\tds_load_b32 v3, v2
\ts_wait_dscnt 0x0 ; MUTATED
\tv_add_nc_u32_e32 v2, v3, v2
"""
    assert tag(listing, "gfx1250") == ("vgpr", "RAW", "v_add_nc_u32_e32 v2, v3, v2")


def test_combined_counter_wait_is_attributed() -> None:
    # pointer_chase.wait003: a flat load counts on both loadcnt and dscnt.
    listing = """
\tflat_load_b32 v1, v[2:3]
\ts_wait_loadcnt_dscnt 0x0 ; MUTATED
\tglobal_store_b32 v0, v1, s[2:3]
"""
    assert tag(listing, "gfx1250") == ("vgpr", "RAW", "global_store_b32 v0, v1, s[2:3]")


def test_partial_wait_exposes_only_the_operations_it_retires() -> None:
    # lgkmcnt(1) retires the first of two DS reads; the second stays in flight
    # whether or not the wait is there, so reading it is not this mutant's hazard.
    listing = """
\tds_read_b32 v4, v1
\tds_read_b32 v5, v3
\ts_waitcnt lgkmcnt(1) ; MUTATED
\tv_add_f32_e32 v6, 1.0, v5
\tv_mul_f32_e32 v2, 0x3fb8aa3b, v4
"""
    assert tag(listing, "gfx950") == ("vgpr", "RAW", "v_mul_f32_e32 v2, 0x3fb8aa3b, v4")


def test_tensor_load_into_lds_then_ds_read_is_lds_raw() -> None:
    listing = """
\ttensor_load_to_lds s[16:19], s[4:11]
\ts_wait_tensorcnt 0 ; MUTATED
\tds_load_b32 v1, v1
"""
    assert tag(listing, "gfx1250") == ("lds", "RAW", "ds_load_b32 v1, v1")


def test_tensor_load_into_lds_then_ds_write_is_lds_waw() -> None:
    listing = """
\ttensor_load_to_lds s[16:19], s[4:11]
\ts_wait_tensorcnt 0 ; MUTATED
\tds_store_b32 v1, v2
"""
    assert tag(listing, "gfx1250") == ("lds", "WAW", "ds_store_b32 v1, v2")


def test_tensor_store_from_lds_then_ds_write_is_lds_war() -> None:
    listing = """
\ttensor_store_from_lds s[16:19], s[4:11]
\ts_wait_tensorcnt 0 ; MUTATED
\tds_store_b32 v1, v2
"""
    assert tag(listing, "gfx1250") == ("lds", "WAR", "ds_store_b32 v1, v2")


# --- Dependencies between waves --------------------------------------------------


@pytest.mark.parametrize(
    "target, store, wait, barrier",
    [
        ("gfx950", "ds_write_b32 v1, v3", "s_waitcnt lgkmcnt(0)", "s_barrier"),
        ("gfx1250", "ds_store_b16 v5, v3", "s_wait_dscnt 0", "s_barrier_signal -1"),
    ],
)
def test_lds_write_in_flight_at_a_barrier_is_a_local_memory_race(
    target: str, store: str, wait: str, barrier: str
) -> None:
    # fa_barrier_epoch.wait002 and lds_reduce.wait002: another wave reads the
    # slot after the barrier.
    listing = f"""
\t{store}
\t{wait} ; MUTATED
\t{barrier}
\ts_barrier_wait -1
\tds_load_b32 v1, v2
"""
    assert tag(listing, target) == ("lds", "LocalMemoryRace", barrier)


def test_global_store_in_flight_at_a_barrier_has_no_tag() -> None:
    listing = """
\tglobal_store_b32 v0, v1, s[2:3]
\ts_wait_storecnt 0x0 ; MUTATED
\ts_barrier_signal -1
"""
    with pytest.raises(exposure.AttributionError, match=r"\[\[case.tag\]\]"):
        expose(listing, "gfx1250")


# --- Nothing exposed -------------------------------------------------------------


def test_wait_that_retires_nothing_exposes_nothing() -> None:
    # wmma_rocwmma.wait003: an earlier wait already retired the load.
    listing = """
\ts_load_b32 s2, s[0:1], 0x24
\ts_wait_kmcnt 0x0
\ts_wait_kmcnt 0x0 ; MUTATED
\ts_and_b32 s3, s2, 0xffff
"""
    assert expose(listing, "gfx1250") is None


def test_later_wait_ends_the_exposure() -> None:
    listing = """
\ts_load_b32 s2, s[0:1], 0x24
\ts_wait_kmcnt 0x0 ; MUTATED
\ts_wait_kmcnt 0x0
\ts_and_b32 s3, s2, 0xffff
"""
    assert expose(listing, "gfx1250") is None


def test_store_data_register_reuse_is_not_a_hazard() -> None:
    # A store reads its data register when it issues.
    listing = """
\tglobal_store_b32 v0, v1, s[2:3]
\ts_wait_storecnt 0x0 ; MUTATED
\tv_mov_b32_e32 v1, 0
\ts_endpgm
"""
    assert expose(listing, "gfx1250") is None


def test_exposure_ends_at_the_end_of_the_program() -> None:
    listing = """
\ts_load_b32 s2, s[0:1], 0x24
\ts_wait_kmcnt 0x0 ; MUTATED
\ts_endpgm
\ts_and_b32 s3, s2, 0xffff
"""
    assert expose(listing, "gfx1250") is None
