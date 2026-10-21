# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Check the assembly/host checkpoint layout agreement without requiring a GPU."""

import json
import re
from pathlib import Path

import pytest


CASES = Path(__file__).resolve().parents[1] / "corpus/kernels/cases/guitar-hero"
MANIFESTS = sorted(CASES.rglob("case.json"))


@pytest.mark.parametrize("manifest", MANIFESTS, ids=lambda path: path.parent.name)
def test_checkpoint_layout(manifest):
    case = manifest.parent
    metadata = json.loads(manifest.read_text())
    name = metadata["name"]
    source = (
        case.parent / "guitar_hero_rdna4.s"
        if metadata["supported_targets"] == ["gfx1201"]
        else case / f"{name}.s"
    )
    assembly = source.read_text()
    checkpoints = re.findall(r'"([^"]+)"', (case / "checkpoints.inc").read_text())
    ids = [int(n) for n in re.findall(r"^checkpoint (\d+)$", assembly, re.MULTILINE)]
    assert ids == list(range(len(checkpoints)))
    assert len(set(checkpoints)) == len(checkpoints)

    # Group zero cannot expose a wrong stride; check it even on hosts without HIP.
    strides = re.findall(
        r"^s_mul_i32 s12, (?:ttmp9|s48|s68), (\d+)$", assembly, re.MULTILINE
    )
    assert len(strides) == 1
    assert int(strides[0]) == len(checkpoints) * 64 * 2 * 4

    if name == "guitar_hero_cdna4":
        assert ".wavefront_size: 64" in assembly
        assert ".private_segment_fixed_size: 0" in assembly
    elif name == "guitar_hero_rdna2":
        assert ".wavefront_size: 32" in assembly
        assert ".private_segment_fixed_size: 64" in assembly
        assert ".amdhsa_user_sgpr_count 4" in assembly
        assert ".amdhsa_user_sgpr_flat_scratch_init 1" in assembly
        assert ".amdhsa_system_sgpr_private_segment_wavefront_offset 1" in assembly
        assert ".amdhsa_reserve_flat_scratch 1" in assembly
        assert """guitar_hero_rdna2:
s_add_u32 s2, s2, s5
s_addc_u32 s3, s3, 0
s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s2
s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s3
s_mov_b32 s48, s4
""" in assembly
    elif name == "guitar_hero_cdna5":
        assert ".wavefront_size: 32" in assembly
        assert ".private_segment_fixed_size: 64" in assembly


def test_rdna2_ds_cmpst_compare_and_replacement_operands():
    assembly = (CASES / "guitar_hero_rdna2/guitar_hero_rdna2.s").read_text()
    instructions = re.findall(r"^ds_cmpst.*$", assembly, re.MULTILINE)
    assert instructions == [
        "ds_cmpst_b32 v52, v41, v40",
        "ds_cmpst_b64 v52, v[34:35], v[32:33]",
        "ds_cmpst_rtn_b32 v16, v52, v41, v40",
        "ds_cmpst_rtn_b64 v[24:25], v52, v[34:35], v[32:33]",
        "ds_cmpst_f32 v52, v42, v40",
        "ds_cmpst_rtn_f32 v16, v52, v42, v40",
        "ds_cmpst_f64 v52, v[42:43], v[40:41]",
        "ds_cmpst_rtn_f64 v[16:17], v52, v[42:43], v[40:41]",
    ]

    # Comparison values equal initialized LDS on even lanes and differ on odd
    # lanes; replacement values differ from initialized LDS on every lane.
    for checkpoint in (178, 179):
        body = assembly.split(f"; Checkpoint {checkpoint}:", 1)[1]
        body = body.split(f"checkpoint {checkpoint}", 1)[0]
        assert "v_xor_b32 v40, 0x00400000, v8" in body
        assert "v_and_b32 v41, 1, v0\nv_xor_b32 v41, v41, v8" in body
        assert "v_and_b32 v36, 1, v0\nv_xor_b32 v34, v36, v8" in body
    for checkpoint in (473, 474, 475, 476):
        body = assembly.split(f"; Checkpoint {checkpoint}:", 1)[1]
        body = body.split(f"checkpoint {checkpoint}", 1)[0]
        assert "v_and_b32 v44, 1, v0\nv_xor_b32 v42, v44, v8" in body


def test_rdna2_low_half_dpp8_coverage():
    assembly = (CASES / "guitar_hero_rdna2/guitar_hero_rdna2.s").read_text()
    start = assembly.index("; Checkpoint 91: vop1_dpp8_00")
    end = assembly.index("; Checkpoint 115: vop3_plain_00")
    dpp8 = assembly[start:end]
    expected = {
        "v_ceil_f16",
        "v_cos_f16",
        "v_cvt_f16_f32",
        "v_cvt_f16_i16",
        "v_cvt_f16_u16",
        "v_cvt_f32_f16",
        "v_cvt_i16_f16",
        "v_cvt_norm_i16_f16",
        "v_cvt_norm_u16_f16",
        "v_cvt_u16_f16",
        "v_exp_f16",
        "v_floor_f16",
        "v_fract_f16",
        "v_frexp_exp_i16_f16",
        "v_frexp_mant_f16",
        "v_log_f16",
        "v_rcp_f16",
        "v_rndne_f16",
        "v_rsq_f16",
        "v_sat_pk_u8_i16",
        "v_sin_f16",
        "v_sqrt_f16",
        "v_trunc_f16",
        "v_add_f16",
        "v_fmac_f16",
        "v_ldexp_f16",
        "v_max_f16",
        "v_min_f16",
        "v_mul_f16",
        "v_sub_f16",
        "v_subrev_f16",
    }
    observed = [
        line.split()[0]
        for line in dpp8.splitlines()
        if " dpp8:" in line and line.split()[0] in expected
    ]
    assert len(observed) == len(expected) == 31
    assert set(observed) == expected

    conversion = dpp8.split("; Checkpoint 92: vop1_dpp8_01", 1)[1]
    conversion = conversion.split("checkpoint 92", 1)[0]
    assert "s_mov_b32 exec_lo, 0xa5a55a5a\ns_mov_b32 exec_lo, -1" not in conversion


def test_cdna5_scheduling_contract():
    assembly = (CASES / "guitar_hero_cdna5/guitar_hero_cdna5.s").read_text()
    lines = [line.split(";", 1)[0].strip() for line in assembly.splitlines()]
    lines = [line for line in lines if line]
    entry = lines.index("guitar_hero_cdna5:")
    assert lines[entry + 1:entry + 5] == [
        "s_mov_b64 s[64:65], 0",
        "v_nop",
        "global_prefetch_b8 v0, s[64:65] scope:SCOPE_SE",
        "s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1",
    ]
    # ISA 5.7.2 requires a VALU gap before TRANS source reuse/result use.
    # Explicit nops also protect macro-expanded source reloads and branch paths.
    trans = re.compile(
        r"v_(?:s_)?(?:rcp(?:_iflag)?|rsq|sqrt|exp|log|sin|cos|tanh)_"
        r"(?:f16|bf16|f32|f64)(?:_e32|_e64|_dpp)*\b"
    )
    matrices = 0
    for index, line in enumerate(lines):
        if trans.match(line) or line.startswith("v_perm_pk16_"):
            assert lines[index + 1] == "v_nop", line
        if line.startswith(("v_wmma_", "v_swmmac_")):
            matrices += 1
            assert lines[index + 1:index + 4] == [".rept 8", "v_nop", ".endr"], line
    assert matrices == 124
    assert ".p2alignl 7, 0xbf9f0000\n.rept 96\ns_code_end\n.endr" in assembly


def test_cdna5_scalar_vector_memory_coherence():
    assembly = (CASES / "guitar_hero_cdna5/guitar_hero_cdna5.s").read_text()
    setup = assembly.split("; VMEM producers and dependent SMEM loads", 1)[1]
    setup = setup.split("; Checkpoint 570:", 1)[0]
    stores = re.findall(r"^global_store_b128.*$", setup, re.MULTILINE)
    loads = re.findall(r"^s_(?:buffer_)?load_.*$", setup, re.MULTILINE)
    assert len(stores) == 4 and len(loads) == 20
    assert all(line.endswith("scope:SCOPE_SE") for line in stores + loads)
    assert "s_wait_storecnt 0\ns_dcache_inv" in setup
    assert setup.index("s_wait_kmcnt 0") < setup.index("; Checkpoint 550:")


def test_cdna5_direct_vgpr_operands_are_allocated():
    assembly = (CASES / "guitar_hero_cdna5/guitar_hero_cdna5.s").read_text()
    allocated = int(re.search(r"\.amdhsa_next_free_vgpr (\d+)", assembly)[1])
    for line in assembly.splitlines():
        instruction = line.split(";", 1)[0].strip()
        if not instruction.startswith(("v_", "s_", "ds_", "global_", "buffer_", "flat_", "scratch_")):
            continue
        for operand in re.finditer(r"\bv(?:(\d+)(?:\.[lh])?|\[(\d+):(\d+)\])", instruction):
            end = int(operand[1] if operand[1] is not None else operand[3])
            assert end < allocated, instruction


def test_cdna5_persistent_exec_regions():
    assembly = (CASES / "guitar_hero_cdna5/guitar_hero_cdna5.s").read_text()
    regions = re.findall(
        r"^masked_region_begin (\d+)\n(.*?)^masked_region_end \1$",
        assembly,
        re.MULTILINE | re.DOTALL,
    )
    assert len(regions) >= 100
    assert ".amdhsa_next_free_sgpr 80" in assembly
    for checkpoint, body in regions:
        assert not re.search(r"\bexec(?:_lo|_hi)?\b|^set_exec ", body, re.MULTILINE), checkpoint
        assert not re.search(r"\b(?:v_wmma\w*|v_swmmac\w*|ds_\w*|dpp8|quad_perm|row_sh[lr])\b", body), checkpoint
    loop_end = assembly.split(".macro masked_region_end id\n", 1)[1].split(".endm", 1)[0]
    assert loop_end.startswith("fold_results\n")
    assert loop_end.index("s_cbranch_scc1") < loop_end.index("set_exec -1")


def test_registered_cases():
    from test_suites import kernels_impl

    discovered = [
        case
        for case in kernels_impl.discover_cases()
        if case.case["project"] == "guitar-hero"
    ]
    assert {case.path for case in discovered} == set(MANIFESTS)
    for manifest in MANIFESTS:
        variants = [case for case in discovered if case.path == manifest]
        assert {case.test_name for case in variants} == {"one_group", "independent_groups"}
        assert len(variants) == 2


def test_rdna4_vopd_condition_waits_for_scalar_vcc():
    assembly = (CASES / "guitar_hero_rdna4/guitar_hero_rdna4.s").read_text()
    start = assembly.index("; Checkpoint 631:")
    end = assembly.index("v_dual_cndmask_b32", start)
    instructions = assembly[start:end]
    write = instructions.index("s_mov_b32 vcc_lo,")
    waits = re.findall(r"^s_wait_alu (0x[0-9a-f]+)$", instructions[write:], re.MULTILINE)
    # SaSdst=0 commits the scalar condition mask before VOPD reads implicit VCC.
    assert any(int(mask, 16) & 1 == 0 for mask in waits)
