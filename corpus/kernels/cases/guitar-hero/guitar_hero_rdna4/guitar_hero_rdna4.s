; gfx1201 wave32/wave64, exactly 64 work-items per independent workgroup.
; This one source is assembled once for each strict wave mode, then both
; entries are linked into guitar_hero_rdna4.hsaco. The SDK's mixed-wave
; parser rejects some sparse-WMMA index_key operands, so both modes retain
; their normal operand validation rather than using a permissive assembler.
.ifndef GUITAR_HERO_WAVE_SIZE
.error "Define GUITAR_HERO_WAVE_SIZE as 32 or 64"
.endif
.amdgcn_target "amdgcn-amd-amdhsa--gfx1201"
.amdhsa_code_object_version 6

; Boundary-probe helpers for the existing checkpoints.

; Dependent source-format probes for gfx1201. Each macro folds incoming
; results before replacing them; callers feed the following existing checkpoint.
; These operand helpers use s16:s23 and v16:v31 as scratch. fold_results retains
; its existing hash-register and target scratch contract. EXEC is restored.
;
; LLVM cannot spell every integer16 floating selector accepted by the ISA.
; The named encoding helpers retain the plain integer/B16 selector forms
; measured in isolated instruction chains on gfx1100/gfx1201, including
; inverse-two-pi selector 248. Full-smoke hashes can differ at other instructions.
; Modifier payloads follow the target ISA field tables; their corpus launches
; still require separate runtime validation. No reserved form is enabled.

.set GH_SRC_VGPR, 256
.set GH_SRC_DPP16, 250
.set GH_SRC_SDWA, 249
.set GH_OP_ADD_NC_U16, 771
.set GH_OP_ADD_U16_CDNA4, 294
.set GH_OP_ADD_U16_VOP2_CDNA4, 38
.set GH_OP_CVT_F16_U16, 464
.set GH_OP_CVT_F16_U16_CDNA4, 377
.set GH_OP_MOV_B16, 28
.set GH_OP_CNDMASK_B16, 605
.set GH_OP_MAD_LEGACY_U16_CDNA4, 491
.set GH_OP_DOT2_BF16_BF16, 615
.set GH_OP_CVT_F32_BF16_CDNA4, 91
.set GH_OP_CVT_F32_BF16_CDNA5, 498

.macro gh_operand_validate arch
.if \arch != 4
.error "unsupported operand corner architecture"
.endif
.endm

.macro gh_operand_wait arch
gh_operand_validate \arch
.if (\arch == 4) || (\arch == 95)
s_wait_alu 0xfffe
.else
s_nop 1
.endif
.endm

; VOP3 source field composition is shared by these four targets. CDNA4
; uses its GFX9 encoding prefix; RDNA3/4 and CDNA5 use the newer prefix.
.macro gh_operand_vop3 arch, opcode, dst, src0, src1=128, src2=128, opsel=0
gh_operand_validate \arch
.if \arch == 94
.long 0xd0000000 | ((\opcode) << 16) | (\dst) | ((\opsel) << 11)
.else
.long 0xd4000000 | ((\opcode) << 16) | (\dst) | ((\opsel) << 11)
.endif
.long (\src0) | ((\src1) << 9) | ((\src2) << 18)
.endm

; DPP16 row_mirror with all rows/banks enabled and bound_ctrl=1. SRC0 is
; v24; only SRC1 is an inline constant, so the alternate encoding is legal.
.macro gh_operand_vop3_dpp arch, opcode, dst, src1, src2=128
gh_operand_validate \arch
gh_operand_vop3 \arch, \opcode, \dst, GH_SRC_DPP16, \src1, \src2
.long (24) | (0x140 << 8) | (1 << 19) | (0xf << 24) | (0xf << 28)
.endm

; CDNA4 SDWA source0 is a scalar inline selector (S0=1), both inputs select
; WORD_0, and the destination is DWORD/UNUSED_PAD. LLVM cannot spell selector 248
; in this integer source position, but it occupies the same scalar namespace.
.macro gh_operand_sdwa_u16 selector
.long (GH_OP_ADD_U16_VOP2_CDNA4 << 25) | (16 << 17) | (24 << 9) | GH_SRC_SDWA
.long (\selector) | (6 << 8) | (4 << 16) | (1 << 23) | (4 << 24)
.endm

.macro gh_operand_s_mov dst, value, arch
s_mov_b32 \dst, \value
gh_operand_wait \arch
.endm

; Numeric half sources must decode independently of raw scalar SEXT/PACK.
; ADD -> MUL -> low conversion is a dependent chain, while direct low/HI
; conversions and their XOR retain each constant's two source interpretations.
.macro gh_operand_scalar_one value, arch, empty=0
.if \empty
s_mov_b64 exec, 0
gh_operand_wait \arch
.endif
gh_operand_s_mov s17, 0xdead4000, \arch
gh_operand_s_mov s16, 0xdeadbeef, \arch
s_add_f16 s16, \value, s17
gh_operand_wait \arch
s_mul_f16 s18, s16, 1.0
gh_operand_wait \arch
s_cvt_f32_f16 s19, s18
gh_operand_wait \arch
s_cvt_f32_f16 s20, \value
gh_operand_wait \arch
s_cvt_hi_f32_f16 s21, \value
gh_operand_wait \arch
s_xor_b32 s18, s20, s21
gh_operand_wait \arch
.if \empty
s_mov_b64 exec, s[22:23]
gh_operand_wait \arch
.endif
v_mov_b32 v16, s16
v_mov_b32 v17, s19
v_mov_b32 v18, s20
v_mov_b32 v19, s21
v_mov_b32 v20, s18
v_xor_b32 v21, v16, v17
fold_results
.endm

; Consume each scalar result before reusing its register. Empty-EXEC cases
; restore the caller's lanes only for publication, then resume scalar work.
.macro gh_operand_scalar_publish arch, empty, raw_dst, converted_dst
gh_operand_validate \arch
s_add_f16 s18, s16, 1.0
gh_operand_wait \arch
s_cvt_f32_f16 s19, s18
gh_operand_wait \arch
.if \empty
s_mov_b64 exec, s[22:23]
gh_operand_wait \arch
.endif
v_mov_b32 \raw_dst, s16
v_mov_b32 \converted_dst, s19
.if \empty
s_mov_b64 exec, 0
gh_operand_wait \arch
.endif
.endm

.macro gh_operand_scalar_binary operation, value, arch, empty, raw_dst, converted_dst
; FMAC reads its low-half accumulator; retain a nonzero upper canary too.
gh_operand_s_mov s16, 0xdead3c00, \arch
\operation s16, \value, s17
gh_operand_wait \arch
gh_operand_scalar_publish \arch, \empty, \raw_dst, \converted_dst
.endm

.macro gh_operand_scalar_unary operation, value, arch, empty, raw_dst, converted_dst
gh_operand_s_mov s16, 0xdeadbeef, \arch
\operation s16, \value
gh_operand_wait \arch
gh_operand_scalar_publish \arch, \empty, \raw_dst, \converted_dst
.endm

.macro gh_operand_scalar_compare operation, value, arch, empty, dst
\operation \value, s17
gh_operand_wait \arch
s_cselect_b32 s18, 1, 0
gh_operand_wait \arch
s_add_u32 s19, s18, 0x13579bdf
gh_operand_wait \arch
.if \empty
s_mov_b64 exec, s[22:23]
gh_operand_wait \arch
.endif
v_mov_b32 \dst, s19
v_xor_b32 \dst, 0x2468ace0, \dst
.if \empty
s_mov_b64 exec, 0
gh_operand_wait \arch
.endif
.endm

.macro gh_operand_scalar_fold arch, empty
gh_operand_validate \arch
.if \empty
s_mov_b64 exec, s[22:23]
gh_operand_wait \arch
.endif
fold_results
.if \empty
s_mov_b64 exec, 0
gh_operand_wait \arch
.endif
.endm

; Every numeric F16 source call site receives an inline value as well as the
; raw SGPR controls below. Batch distinct result registers into three folds.
.macro gh_operand_scalar_family value, arch, empty=0
.if \empty
s_mov_b64 exec, 0
gh_operand_wait \arch
.endif
gh_operand_s_mov s17, 0xdead4000, \arch
gh_operand_scalar_binary s_sub_f16, \value, \arch, \empty, v16, v17
gh_operand_scalar_binary s_fmac_f16, \value, \arch, \empty, v18, v19
gh_operand_scalar_binary s_min_num_f16, \value, \arch, \empty, v20, v21
gh_operand_scalar_binary s_max_num_f16, \value, \arch, \empty, v22, v23
gh_operand_scalar_binary s_minimum_f16, \value, \arch, \empty, v24, v25
gh_operand_scalar_binary s_maximum_f16, \value, \arch, \empty, v26, v27
gh_operand_scalar_unary s_ceil_f16, \value, \arch, \empty, v28, v29
gh_operand_scalar_unary s_floor_f16, \value, \arch, \empty, v30, v31
gh_operand_scalar_fold \arch, \empty
gh_operand_scalar_unary s_trunc_f16, \value, \arch, \empty, v16, v17
gh_operand_scalar_unary s_rndne_f16, \value, \arch, \empty, v18, v19
gh_operand_scalar_fold \arch, \empty
gh_operand_scalar_compare s_cmp_eq_f16, \value, \arch, \empty, v16
gh_operand_scalar_compare s_cmp_ge_f16, \value, \arch, \empty, v17
gh_operand_scalar_compare s_cmp_gt_f16, \value, \arch, \empty, v18
gh_operand_scalar_compare s_cmp_le_f16, \value, \arch, \empty, v19
gh_operand_scalar_compare s_cmp_lg_f16, \value, \arch, \empty, v20
gh_operand_scalar_compare s_cmp_lt_f16, \value, \arch, \empty, v21
gh_operand_scalar_compare s_cmp_neq_f16, \value, \arch, \empty, v22
gh_operand_scalar_compare s_cmp_nge_f16, \value, \arch, \empty, v23
gh_operand_scalar_compare s_cmp_ngt_f16, \value, \arch, \empty, v24
gh_operand_scalar_compare s_cmp_nle_f16, \value, \arch, \empty, v25
gh_operand_scalar_compare s_cmp_nlg_f16, \value, \arch, \empty, v26
gh_operand_scalar_compare s_cmp_nlt_f16, \value, \arch, \empty, v27
gh_operand_scalar_compare s_cmp_o_f16, \value, \arch, \empty, v28
gh_operand_scalar_compare s_cmp_u_f16, \value, \arch, \empty, v29
gh_operand_scalar_fold \arch, \empty
.if \empty
s_mov_b64 exec, s[22:23]
gh_operand_wait \arch
.endif
.endm

.macro gh_corner_scalar_f16 arch
gh_operand_validate \arch
.if (\arch == 4) || (\arch == 95)
fold_results
clear_results
s_mov_b64 s[22:23], exec
gh_operand_wait \arch
.irp value,0.5,-0.5,1.0,-1.0,2.0,-2.0,4.0,-4.0,0.15915494
gh_operand_scalar_one \value, \arch
gh_operand_scalar_one \value, \arch, 1
gh_operand_scalar_family \value, \arch
gh_operand_scalar_family \value, \arch, 1
.endr
; Raw register carriers retain both halves; literal payload 0xf2 is not a
; selector. In particular HI literal 0x40003c00 must survive the full 32-bit read.
gh_operand_s_mov s17, 0x3c004000, \arch
s_cvt_f32_f16 s16, s17
gh_operand_wait \arch
v_mov_b32 v16, s16
s_cvt_hi_f32_f16 s16, s17
gh_operand_wait \arch
v_mov_b32 v17, s16
s_cvt_hi_f32_f16 s16, 0x40003c00
gh_operand_wait \arch
v_mov_b32 v18, s16
s_cvt_hi_f32_f16 s16, 0xf2
gh_operand_wait \arch
v_mov_b32 v19, s16
s_cvt_hi_f32_f16 s16, 1
gh_operand_wait \arch
v_mov_b32 v20, s16
gh_operand_s_mov s17, 0x3c00, \arch
s_add_f16 s16, 1, s17
gh_operand_wait \arch
v_mov_b32 v21, s16
s_add_f16 s16, 0x4000, 1.0
gh_operand_wait \arch
v_mov_b32 v22, s16
v_xor_b32 v23, v18, v19
fold_results
.endif
.endm

; RDNA4's SREG_LITERAL source namespace excludes floating selectors. Some
; gfx1201 hardware accepts those words, but they are outside this qualified
; probe. Feed its SGPR source from numeric scalar arithmetic instead. CDNA5
; explicitly supports floating selectors and retains direct inline coverage.
.macro gh_operand_pseudo_f16 arch, operation, destination
gh_operand_validate \arch
.if \arch == 4
\operation \destination, s21
.else
\operation \destination, 1.0
.endif
v_nop
s_wait_alu 0xf1ff
.endm

; Pseudo-scalar VALU must consume numeric halves even with empty EXEC.
.macro gh_corner_pseudo_f16 arch
gh_operand_validate \arch
.if (\arch == 4) || (\arch == 95)
fold_results
clear_results
s_mov_b64 s[22:23], exec
gh_operand_wait \arch
.irp empty,0,1
.if \empty
s_mov_b64 exec, 0
gh_operand_wait \arch
.endif
.if \arch == 4
s_add_f16 s21, 1.0, 0
gh_operand_wait \arch
.endif
gh_operand_pseudo_f16 \arch, v_s_rcp_f16, s16
gh_operand_pseudo_f16 \arch, v_s_sqrt_f16, s17
gh_operand_pseudo_f16 \arch, v_s_rsq_f16, s18
gh_operand_pseudo_f16 \arch, v_s_exp_f16, s19
gh_operand_pseudo_f16 \arch, v_s_log_f16, s20
s_add_f16 s21, s16, s17
gh_operand_wait \arch
.if \empty
s_mov_b64 exec, s[22:23]
gh_operand_wait \arch
.endif
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s18
v_mov_b32 v19, s19
v_mov_b32 v20, s20
v_mov_b32 v21, s21
fold_results
.endr
.endif
.endm

.macro gh_corner_raw_scalar arch
gh_operand_validate \arch
fold_results
clear_results
.irp value,0.5,-0.5,1.0,-1.0,2.0,-2.0,4.0,-4.0,0.15915494
s_sext_i32_i16 s16, \value
gh_operand_wait \arch
s_pack_ll_b32_b16 s17, \value, \value
gh_operand_wait \arch
s_pack_lh_b32_b16 s18, \value, \value
gh_operand_wait \arch
s_pack_hh_b32_b16 s19, \value, \value
gh_operand_wait \arch
.if \arch != 94
s_pack_hl_b32_b16 s20, \value, \value
gh_operand_wait \arch
.else
; CDNA4 has LL/LH/HH, but no HL instruction.
s_xor_b32 s20, s18, s19
gh_operand_wait \arch
.endif
s_xor_b32 s21, s17, s19
gh_operand_wait \arch
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s18
v_mov_b32 v19, s19
v_mov_b32 v20, s20
v_mov_b32 v21, s21
fold_results
.endr
.endm

; F16 and integer16 see different values for the same nine floating selectors.
; Each result is consumed by a conversion/ALU before the next batch overwrites it.
.macro gh_corner_vector16 arch
gh_operand_validate \arch
fold_results
clear_results
.irp value,0.5,-0.5,1.0,-1.0,2.0,-2.0,4.0,-4.0,0.15915494
v_mov_b32 v24, 0
v_mov_b32 v16, 0xdeadbeef
.if \arch == 94
v_add_f16_e64 v16, \value, v24
v_nop
v_cvt_f32_f16_e64 v17, v16
.else
v_add_f16_e64 v16.l, \value, v24.l
v_nop
v_cvt_f32_f16_e64 v17, v16.l
.endif
v_nop
v_add_f32 v18, 1.0, v17
fold_results
.endr
; Numeric half constants also reach modifier delegates. DPP takes its inline
; input from SRC1; CDNA4 SDWA permits a scalar-inline SRC0.
.irp value,0.5,-0.5,1.0,-1.0,2.0,-2.0,4.0,-4.0,0.15915494
v_mov_b32 v24, 0
v_mov_b32 v16, 0xdeadbeef
.if \arch == 94
v_add_f16_sdwa v16, \value, v24 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:WORD_0
v_nop
v_cvt_f32_f16_e64 v17, v16
.elseif \arch == 3
; GFX11 DPP16 requires VGPR arithmetic sources. The typed inline producer
; feeds the legal DPP form instead of encoding a forbidden scalar SRC1.
v_mov_b32 v25, 0
v_add_f16_e64 v24.l, \value, v24.l
v_nop
v_add_f16_e64_dpp v16.l, v24.l, v25.l row_mirror row_mask:0xf bank_mask:0xf bound_ctrl:1 fi:0
v_nop
v_cvt_f32_f16_e64 v17, v16.l
.else
v_add_f16_e64_dpp v16.l, v24.l, \value row_mirror row_mask:0xf bank_mask:0xf bound_ctrl:1 fi:0
v_nop
v_cvt_f32_f16_e64 v17, v16.l
.endif
v_nop
v_add_f32 v18, 1.0, v17
fold_results
.endr
.irp selector,240,241,242,243,244,245,246,247,248
v_mov_b32 v24, 0
v_mov_b32 v16, 0xdeadbeef
.if \arch == 94
gh_operand_vop3 \arch, GH_OP_ADD_U16_CDNA4, 16, \selector, GH_SRC_VGPR+24
.else
gh_operand_vop3 \arch, GH_OP_ADD_NC_U16, 16, \selector, GH_SRC_VGPR+24
.endif
v_nop
v_and_b32 v17, 0xffff, v16
v_cvt_f32_u32 v18, v17
v_add_f32 v19, 1.0, v18
; A half destination does not make an integer source use half inlines.
.if \arch == 94
gh_operand_vop3 \arch, GH_OP_CVT_F16_U16_CDNA4, 20, \selector
v_nop
v_cvt_f32_f16_e64 v21, v20
.else
gh_operand_vop3 \arch, GH_OP_CVT_F16_U16, 20, \selector
v_nop
v_cvt_f32_f16_e64 v21, v20.l
.endif
v_nop
v_add_f32 v22, 1.0, v21
fold_results
.endr
; Legal high VGPR source/destination selection on modern true16 targets.
.if \arch != 94
v_mov_b32 v24, 0x40003c00
v_mov_b32 v25, 0x3c004000
v_mov_b32 v16, 0xdeadbeef
v_add_nc_u16_e64 v16.h, v24.h, v25.l
v_nop
v_lshrrev_b32 v17, 16, v16
v_xor_b32 v18, v17, v16
fold_results
; DPP delegates retain the integer source format for SRC1's floating selector.
.irp selector,240,241,242,243,244,245,246,247,248
v_mov_b32 v24, 0
v_mov_b32 v16, 0xdeadbeef
.if \arch == 3
gh_operand_vop3 \arch, GH_OP_ADD_NC_U16, 24, \selector, GH_SRC_VGPR+24
v_nop
gh_operand_vop3_dpp \arch, GH_OP_ADD_NC_U16, 16, GH_SRC_VGPR+24
.else
gh_operand_vop3_dpp \arch, GH_OP_ADD_NC_U16, 16, \selector
.endif
v_nop
v_and_b32 v17, 0xffff, v16
v_add_nc_u32 v18, 1, v17
fold_results
.endr
.else
; CDNA4 SDWA can select an inline scalar source. Its staging must retain the
; integer FP32 carrier, including inverse-two-pi's nonzero low half.
.irp selector,240,241,242,243,244,245,246,247,248
v_mov_b32 v24, 0
v_mov_b32 v16, 0xdeadbeef
gh_operand_sdwa_u16 \selector
v_nop
v_and_b32 v17, 0xffff, v16
v_add_u32 v18, 1, v17
fold_results
.endr
.endif
.endm

.macro gh_corner_b16 arch
gh_operand_validate \arch
fold_results
clear_results
.irp selector,240,241,242,243,244,245,246,247,248
v_mov_b32 v24, 1
v_mov_b32 v25, 0
v_mov_b32 v16, 0xdeadbeef
.if \arch == 94
; Legacy U16 MAD's bit-format operands retain the same FP32 inline carrier.
gh_operand_vop3 \arch, GH_OP_MAD_LEGACY_U16_CDNA4, 16, \selector, GH_SRC_VGPR+24, GH_SRC_VGPR+25
.else
; MOV_B16 e32, then low-half consumption; CNDMASK independently exercises
; the second B16 consumer with a zero condition selecting SRC0.
.long 0x7e000000 | (16 << 17) | (GH_OP_MOV_B16 << 9) | (\selector)
.endif
v_nop
v_and_b32 v17, 0xffff, v16
.if \arch == 94
v_add_u32 v18, 1, v17
.else
v_add_nc_u32 v18, 1, v17
gh_operand_s_mov s22, 0, \arch
gh_operand_s_mov s23, 0, \arch
gh_operand_vop3 \arch, GH_OP_CNDMASK_B16, 19, \selector, GH_SRC_VGPR+25, 22
v_nop
v_and_b32 v20, 0xffff, v19
v_add_nc_u32 v21, 1, v20
.endif
fold_results
.endr
.if \arch != 94
gh_operand_s_mov s22, -1, \arch
gh_operand_s_mov s23, -1, \arch
.irp selector,240,241,242,243,244,245,246,247,248
v_mov_b32 v24, 0
v_mov_b32 v16, 0xdeadbeef
.if \arch == 3
.long 0x7e000000 | (25 << 17) | (GH_OP_MOV_B16 << 9) | (\selector)
v_nop
gh_operand_vop3_dpp \arch, GH_OP_CNDMASK_B16, 16, GH_SRC_VGPR+25, 22
.else
gh_operand_vop3_dpp \arch, GH_OP_CNDMASK_B16, 16, \selector, 22
.endif
v_nop
v_and_b32 v17, 0xffff, v16
v_add_nc_u32 v18, 1, v17
fold_results
.endr
.endif
.endm

.macro gh_corner_bf16 arch
gh_operand_validate \arch
fold_results
clear_results
.irp selector,240,241,242,243,244,245,246,247,248
v_mov_b32 v16, 0xdeadbeef
.if \arch == 94
; CDNA4's numeric BF16 source is the low half, not a raw FP32 carrier.
.long 0x7e000000 | (16 << 17) | (GH_OP_CVT_F32_BF16_CDNA4 << 9) | (\selector)
.elseif \arch == 95
; CDNA5 permits floating inlines through e64 with FP32 carrier/high OPSEL.
; Its VOP1 floating-inline form is not a legal replacement.
gh_operand_vop3 \arch, GH_OP_CVT_F32_BF16_CDNA5, 16, \selector, 128, 128, 1
.else
; Zero packed multiplicands make the numeric BF16 accumulator independently
; observable. Selector 248 must retain BF16 0x3e22 rather than rounded 0x3e23.
v_mov_b32 v24, 0
v_mov_b32 v25, 0
gh_operand_vop3 \arch, GH_OP_DOT2_BF16_BF16, 16, GH_SRC_VGPR+24, GH_SRC_VGPR+25, \selector
.endif
v_nop
.if (\arch == 94) || (\arch == 95)
v_add_f32 v17, 1.0, v16
v_xor_b32 v18, v16, v17
.else
v_and_b32 v17, 0xffff, v16
v_lshlrev_b32 v18, 16, v17
v_add_f32 v19, 1.0, v18
.endif
fold_results
.endr
.if (\arch == 3) || (\arch == 4)
.irp selector,240,241,242,243,244,245,246,247,248
v_mov_b32 v24, 0
v_mov_b32 v25, 0
.if \arch == 3
gh_operand_vop3 \arch, GH_OP_DOT2_BF16_BF16, 26, GH_SRC_VGPR+24, GH_SRC_VGPR+25, \selector
v_nop
gh_operand_vop3_dpp \arch, GH_OP_DOT2_BF16_BF16, 16, GH_SRC_VGPR+25, GH_SRC_VGPR+26
.else
gh_operand_vop3_dpp \arch, GH_OP_DOT2_BF16_BF16, 16, GH_SRC_VGPR+25, \selector
.endif
v_nop
v_and_b32 v17, 0xffff, v16
v_lshlrev_b32 v18, 16, v17
v_add_f32 v19, 1.0, v18
fold_results
.endr
.endif
; Register carriers are selected as raw bits, independently of inline format.
.if (\arch == 94) || (\arch == 95)
gh_operand_s_mov s16, 0x3f804000, \arch
v_mov_b32 v24, 0x40003f80
.if \arch == 94
v_cvt_f32_bf16 v16, s16
v_cvt_f32_bf16 v17, v24
.else
v_cvt_f32_bf16_e64 v16, s16 op_sel:[1]
v_cvt_f32_bf16_e64 v17, v24.h
.endif
v_nop
v_add_f32 v18, v16, v17
fold_results
.endif
.endm

; PC import and return-address dependency chains for scalar_local_calls.
; Inputs: full EXEC, existing clear_results/fold_results macros.
; Clobbers: s16:s23, v16:v31, SCC and VCC; restores full EXEC and MODE.CSP.
; No raw addresses enter the hash: only address differences and fixed markers.
; Isolated instruction chains measured high-bit masking on gfx1100/gfx1201.
; Full-smoke hashes can differ at other instructions. The gfx950 and
; gfx1250 cases follow simulator masks, pending matching hardware;
; their manuals do not establish the masking of noncanonical input PCs.
; High-PC export/fetch boundaries require separately mapped code.

.macro gh_pc_wait gfx12
.if \gfx12
s_wait_alu 0xf1fc
.else
s_nop 1
.endif
.endm

.macro gh_pc_full_exec wave_size
.if \wave_size == 64
s_mov_b64 exec, -1
.else
s_mov_b32 exec_lo, -1
.endif
.endm

.macro gh_pc_poison_high high, pc_bits
.if \pc_bits == 57
s_and_b32 \high, \high, 0x01ffffff
s_or_b32 \high, \high, 0xa4000000
.else
s_and_b32 \high, \high, 0x0000ffff
s_or_b32 \high, \high, 0xa5a50000
.endif
.endm

.macro gh_pc_corners pc_bits, wave_size, gfx12, cdna_fork=0
.if ((\pc_bits != 48) && (\pc_bits != 57)) || ((\wave_size != 32) && (\wave_size != 64))
.error "unsupported PC corner width"
.endif
.if ((\gfx12 != 0) && (\gfx12 != 1)) || ((\cdna_fork != 0) && (\cdna_fork != 1))
.error "unsupported PC corner capability"
.endif
gh_pc_full_exec \wave_size
fold_results
clear_results

; GETPC -> address arithmetic -> ignored-high-bit SETPC -> dependent marker.
; A missing branch takes the guarded fallback instead of accidentally reaching
; the intended target by ordinary fallthrough.
s_getpc_b64 s[16:17]
.Lgh_pc_set_anchor\@:
gh_pc_wait \gfx12
s_add_u32 s16, s16, .Lgh_pc_set_body\@-.Lgh_pc_set_anchor\@
s_addc_u32 s17, s17, 0
gh_pc_poison_high s17, \pc_bits
gh_pc_wait \gfx12
s_setpc_b64 s[16:17]
v_mov_b32 v16, 0xbad00001
s_branch .Lgh_pc_set_done\@
.Lgh_pc_set_body\@:
v_mov_b32 v16, 0x13579bdf
.Lgh_pc_set_done\@:
fold_results
clear_results

; Nonaliasing SWAPPC must export precisely its following instruction's PC.
; Its return value is consumed by SETPC and by independent label differences.
s_getpc_b64 s[16:17]
.Lgh_pc_swap_anchor\@:
gh_pc_wait \gfx12
s_add_u32 s22, s16, .Lgh_pc_swap_return\@-.Lgh_pc_swap_anchor\@
s_addc_u32 s23, s17, 0
s_add_u32 s16, s16, .Lgh_pc_swap_body\@-.Lgh_pc_swap_anchor\@
s_addc_u32 s17, s17, 0
gh_pc_poison_high s17, \pc_bits
s_mov_b32 s20, 0
gh_pc_wait \gfx12
s_swappc_b64 s[18:19], s[16:17]
.Lgh_pc_swap_return\@:
gh_pc_wait \gfx12
s_add_u32 s20, s20, 17
s_branch .Lgh_pc_swap_done\@
.Lgh_pc_swap_body\@:
gh_pc_wait \gfx12
s_add_u32 s20, s20, 3
gh_pc_wait \gfx12
s_setpc_b64 s[18:19]
.Lgh_pc_swap_done\@:
s_xor_b32 s21, s18, s22
s_xor_b32 s22, s19, s23
gh_pc_wait \gfx12
v_mov_b32 v16, s20
v_mov_b32 v17, s21
v_mov_b32 v18, s22
fold_results
clear_results

; Aliased SWAPPC must read its target before overwriting the same pair with
; the return PC. SETPC then consumes that overwritten pair.
s_getpc_b64 s[16:17]
.Lgh_pc_alias_anchor\@:
gh_pc_wait \gfx12
s_add_u32 s18, s16, .Lgh_pc_alias_return\@-.Lgh_pc_alias_anchor\@
s_addc_u32 s19, s17, 0
s_add_u32 s16, s16, .Lgh_pc_alias_body\@-.Lgh_pc_alias_anchor\@
s_addc_u32 s17, s17, 0
gh_pc_poison_high s17, \pc_bits
s_mov_b32 s20, 0
gh_pc_wait \gfx12
s_swappc_b64 s[16:17], s[16:17]
.Lgh_pc_alias_return\@:
gh_pc_wait \gfx12
s_add_u32 s20, s20, 29
s_branch .Lgh_pc_alias_done\@
.Lgh_pc_alias_body\@:
gh_pc_wait \gfx12
s_add_u32 s20, s20, 7
gh_pc_wait \gfx12
s_setpc_b64 s[16:17]
.Lgh_pc_alias_done\@:
s_xor_b32 s21, s16, s18
s_xor_b32 s22, s17, s19
gh_pc_wait \gfx12
v_mov_b32 v16, s20
v_mov_b32 v17, s21
v_mov_b32 v18, s22
fold_results
clear_results

; CALL's exported pair controls the return. A comparison against a separately
; constructed label address supplies an observable fallback for a bad export.
s_getpc_b64 s[16:17]
.Lgh_pc_call_anchor\@:
gh_pc_wait \gfx12
s_add_u32 s16, s16, .Lgh_pc_call_return\@-.Lgh_pc_call_anchor\@
s_addc_u32 s17, s17, 0
s_mov_b32 s20, 0
gh_pc_wait \gfx12
s_call_b64 s[18:19], .Lgh_pc_call_body\@
.Lgh_pc_call_return\@:
gh_pc_wait \gfx12
s_add_u32 s20, s20, 43
s_branch .Lgh_pc_call_done\@
.Lgh_pc_call_body\@:
gh_pc_wait \gfx12
s_cmp_eq_u64 s[16:17], s[18:19]
s_cbranch_scc0 .Lgh_pc_call_bad\@
s_add_u32 s20, s20, 11
gh_pc_wait \gfx12
s_setpc_b64 s[18:19]
.Lgh_pc_call_bad\@:
s_mov_b32 s20, 0xbad00002
gh_pc_wait \gfx12
s_setpc_b64 s[16:17]
.Lgh_pc_call_done\@:
s_xor_b32 s21, s16, s18
s_xor_b32 s22, s17, s19
gh_pc_wait \gfx12
v_mov_b32 v16, s20
v_mov_b32 v17, s21
v_mov_b32 v18, s22

.if \cdna_fork
fold_results
clear_results
; CSP4 uses scratch s16:s19 for the saved EXEC/PC, preserving kernel SGPRs.
; Comparisons exercise both uniform outcomes, both smaller-side orders and an
; empty EXEC. The indirect target carries ignored upper bits; a divergent JOIN
; must consume the saved alternative PC.
s_getreg_b32 s22, hwreg(HW_REG_MODE, 29, 3)
s_nop 1
.irp compare,0x00000000,0x00000005,0xfffffffa,0xffffffff,0xeeeeeeee
s_mov_b32 s23, 4
s_setreg_b32 hwreg(HW_REG_MODE, 29, 3), s23
s_nop 1
s_getpc_b64 s[20:21]
.Lgh_pc_fork_anchor\@\compare:
s_add_u32 s20, s20, .Lgh_pc_fork_then\@\compare-.Lgh_pc_fork_anchor\@\compare
s_addc_u32 s21, s21, 0
gh_pc_poison_high s21, 48
s_mov_b32 vcc_lo, \compare
.if (\compare == 0x00000000) || (\compare == 0x00000005)
s_mov_b32 vcc_hi, 0
.else
s_mov_b32 vcc_hi, -1
.endif
s_nop 1
.if \compare == 0xeeeeeeee
s_mov_b64 exec, 0
.endif
s_cbranch_g_fork vcc, s[20:21]
v_mov_b32 v16, 2
s_branch .Lgh_pc_fork_join\@\compare
.Lgh_pc_fork_then\@\compare:
v_mov_b32 v16, 1
.Lgh_pc_fork_join\@\compare:
s_cbranch_join s23
s_mov_b64 exec, -1
v_xor_b32 v17, 0x55aa55aa, v16
fold_results
clear_results
.endr
s_setreg_b32 hwreg(HW_REG_MODE, 29, 3), s22
s_nop 1
v_mov_b32 v16, 0x50434353
.endif
gh_pc_full_exec \wave_size
.endm

; Memory corner probes for the existing Guitar Hero checkpoints.
; Inputs: s14:s15 = this workgroup's 4096-byte workspace, v0 = local id.
; Clobbers: s16:s23, v16:v31, v54:v57, SCC and VCC. EXEC exits full.
; Every intermediate result is folded before its registers are reused.
; A wave owns 64 workspace bytes at readfirstlane(v0)*64, so the two wave32s
; never share a location. Each memory probe selects just lane zero of its wave.

; Reject mixed operand/memory target tokens before emitting raw encodings.
.macro gh_corner_validate arch
.ifnc \arch,rdna4
.error "unsupported memory corner architecture"
.endif
.endm

.macro gh_corner_exec arch, wave_size, mask
gh_corner_validate \arch
.if \wave_size == 64
s_mov_b64 exec, \mask
.else
s_mov_b32 exec_lo, \mask
.endif
.endm

.macro gh_corner_salu_wait arch
gh_corner_validate \arch
.ifc \arch,rdna4
s_wait_alu 0xfffe
.else
.ifc \arch,cdna5
s_wait_alu 0xfffe
.endif
.endif
.endm

.macro gh_corner_memory_wait arch
gh_corner_validate \arch
.ifc \arch,cdna4
s_waitcnt 0
.else
.ifc \arch,rdna3
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
.else
s_wait_loadcnt 0
s_wait_storecnt 0
.endif
.endif
.endm

.macro gh_corner_memory_base arch, wave_size
gh_corner_validate \arch
gh_corner_exec \arch, \wave_size, -1
v_readfirstlane_b32 s21, v0
.ifc \arch,cdna4
s_nop 7
.else
.ifc \arch,rdna3
s_waitcnt_depctr 0
.else
s_wait_alu 0xf1ff
.endif
.endif
s_lshl_b32 s21, s21, 6
gh_corner_salu_wait \arch
s_add_u32 s22, s14, s21
s_addc_u32 s23, s15, 0
gh_corner_salu_wait \arch
.endm

.macro gh_corner_global_load arch, destination, address, offset=0
gh_corner_validate \arch
.ifc \arch,cdna4
global_load_dword \destination, \address, s[22:23] offset:\offset
.else
global_load_b32 \destination, \address, s[22:23] offset:\offset
.endif
.endm

.macro gh_corner_global_load128 arch, destination, address, offset=0
gh_corner_validate \arch
.ifc \arch,cdna4
global_load_dwordx4 \destination, \address, s[22:23] offset:\offset
.else
global_load_b128 \destination, \address, s[22:23] offset:\offset
.endif
.endm

.macro gh_corner_global_store128 arch, source, address, offset=0
gh_corner_validate \arch
.ifc \arch,cdna4
global_store_dwordx4 \address, \source, s[22:23] offset:\offset
.else
global_store_b128 \address, \source, s[22:23] offset:\offset
.endif
.endm

.macro gh_corner_memory_initialize arch, wave_size
gh_corner_validate \arch
gh_corner_exec \arch, \wave_size, -1
clear_results
v_mov_b32 v24, 0x10203004
v_mov_b32 v25, 0x21314108
v_mov_b32 v26, 0x3242520c
v_mov_b32 v27, 0x43536300
v_mov_b32 v54, 0
gh_corner_exec \arch, \wave_size, 1
gh_corner_global_store128 \arch, v[24:27], v54, 0
gh_corner_global_store128 \arch, v[24:27], v54, 16
gh_corner_global_store128 \arch, v[24:27], v54, 32
gh_corner_global_store128 \arch, v[24:27], v54, 48
gh_corner_memory_wait \arch
.endm

.macro gh_corner_buffer_descriptor arch, bound, stride=0
gh_corner_validate \arch
s_mov_b32 s16, s22
.ifc \arch,cdna5
; CDNA5: 57-bit base, 45-bit byte count, stride in DWORD 3.
s_and_b32 s17, s23, 0x01ffffff
gh_corner_salu_wait \arch
s_or_b32 s17, s17, ((\bound & 127) << 25)
s_mov_b32 s18, (\bound >> 7)
s_mov_b32 s19, (\stride << 12)
.else
; The older descriptors retain a 48-bit base and a separate count DWORD.
s_and_b32 s17, s23, 0xffff
gh_corner_salu_wait \arch
s_or_b32 s17, s17, (\stride << 16)
s_mov_b32 s18, \bound
.ifc \arch,cdna4
s_mov_b32 s19, 0x00027fac
.else
s_mov_b32 s19, 0x30020fac
.endif
.endif
gh_corner_salu_wait \arch
.endm

.macro gh_corner_buffer_issue opcode, data, kind
.if \kind == 1
\opcode \data, v54, s[16:19], s20 offen offset:12
.elseif \kind == 3
\opcode \data, v[54:55], s[16:19], s20 idxen offen
.else
\opcode \data, v54, s[16:19], s20 offen
.endif
.endm

.macro gh_corner_buffer_load arch, width, kind
gh_corner_validate \arch
.ifc \arch,cdna4
.if \width == 64
gh_corner_buffer_issue buffer_load_dwordx2, v[16:17], \kind
.elseif \width == 96
gh_corner_buffer_issue buffer_load_dwordx3, v[16:18], \kind
.else
gh_corner_buffer_issue buffer_load_dwordx4, v[16:19], \kind
.endif
.else
.if \width == 64
gh_corner_buffer_issue buffer_load_b64, v[16:17], \kind
.elseif \width == 96
gh_corner_buffer_issue buffer_load_b96, v[16:18], \kind
.else
gh_corner_buffer_issue buffer_load_b128, v[16:19], \kind
.endif
.endif
.endm

.macro gh_corner_buffer_store arch, width, kind
gh_corner_validate \arch
.ifc \arch,cdna4
.if \width == 64
gh_corner_buffer_issue buffer_store_dwordx2, v[24:25], \kind
.elseif \width == 96
gh_corner_buffer_issue buffer_store_dwordx3, v[24:26], \kind
.else
gh_corner_buffer_issue buffer_store_dwordx4, v[24:27], \kind
.endif
.else
.if \width == 64
gh_corner_buffer_issue buffer_store_b64, v[24:25], \kind
.elseif \width == 96
gh_corner_buffer_issue buffer_store_b96, v[24:26], \kind
.else
gh_corner_buffer_issue buffer_store_b128, v[24:27], \kind
.endif
.endif
.endm

.macro gh_corner_buffer_case arch, wave_size, width, remaining, kind
gh_corner_validate \arch
gh_corner_memory_initialize \arch, \wave_size
.if \kind == 1
; Exercise nonzero SOFFSET, VOFFSET and immediate together. On gfx950 the
; simulator includes SOFFSET/end-of-DWORD bounds, while the CDNA3/4 manuals
; describe a start-offset check excluding SOFFSET. No gfx950 capture here.
gh_corner_buffer_descriptor \arch, (24 + \remaining)
s_mov_b32 s20, 4
v_mov_b32 v54, 8
.elseif \kind == 3
; IDXEN retains ordinary per-DWORD bounds on CDNA5: index 1, stride 16,
; SOFFSET 4 and VOFFSET 0 address byte 20 of the backing allocation.
gh_corner_buffer_descriptor \arch, (20 + \remaining), 16
s_mov_b32 s20, 4
v_mov_b32 v54, 1
v_mov_b32 v55, 0
.else
.if \kind == 2
; A nonzero descriptor stride alone does not make a raw access structured.
gh_corner_buffer_descriptor \arch, \remaining, 16
.else
gh_corner_buffer_descriptor \arch, \remaining
.endif
s_mov_b32 s20, 0
v_mov_b32 v54, 0
.endif
gh_corner_salu_wait \arch
gh_corner_buffer_load \arch, \width, \kind
gh_corner_memory_wait \arch
; Consume the loaded bits in a second, always-backed memory dependency.
; Every possible address is an aligned DWORD in bytes 48..60.
v_xor_b32 v56, 0x10203004, v16
v_and_b32 v56, 12, v56
v_add_u32 v56, 48, v56
gh_corner_global_load \arch, v20, v56
gh_corner_memory_wait \arch
gh_corner_exec \arch, \wave_size, -1
fold_results
gh_corner_exec \arch, \wave_size, 1
; A load -> arithmetic -> bounded store -> unbounded read chain exposes both
; zero filling and suppressed stores without letting one hide the other.
v_xor_b32 v24, 0x01010101, v16
v_xor_b32 v25, 0x02020202, v17
v_xor_b32 v26, 0x03030303, v18
v_xor_b32 v27, 0x04040404, v19
gh_corner_buffer_store \arch, \width, \kind
gh_corner_memory_wait \arch
.if \kind == 1
v_mov_b32 v56, 24
.elseif \kind == 3
v_mov_b32 v56, 20
.else
v_mov_b32 v56, 0
.endif
gh_corner_global_load128 \arch, v[28:31], v56
gh_corner_memory_wait \arch
gh_corner_exec \arch, \wave_size, -1
fold_results
.endm

.macro gh_corner_buffer_bounds arch, wave_size
gh_corner_validate \arch
gh_corner_memory_base \arch, \wave_size
; Raw B64/B96/B128 cover every residual byte through 20, including exact
; fits and the byte immediately before/after each DWORD and payload boundary.
; CDNA5's raw extra-DWORD crossing rule was exposed by Triton PR 12512 for
; aligned B128 with 4/8 bytes left and whole fits. Other widths and byte
; boundaries remain model qualifications, rather than physical measurements.
; gfx950's SOFFSET participation/end-of-DWORD behavior also follows the
; simulator's hardware claim, not the CDNA3/4 manual rule; it is unmeasured here.
.irp width,64,96,128
.irp remaining,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
gh_corner_buffer_case \arch, \wave_size, \width, \remaining, 0
gh_corner_buffer_case \arch, \wave_size, \width, \remaining, 1
gh_corner_buffer_case \arch, \wave_size, \width, \remaining, 2
.ifc \arch,cdna5
gh_corner_buffer_case \arch, \wave_size, \width, \remaining, 3
.endif
.endr
.endr
.endm

.macro gh_corner_gfx12_atomic_case arch, wave_size, form, width, th, scope=2
gh_corner_validate \arch
gh_corner_memory_initialize \arch, \wave_size
v_mov_b32 v24, 7
v_mov_b32 v25, 0x12345678
v_mov_b32 v54, 0
global_store_b64 v54, v[24:25], s[22:23] scope:SCOPE_DEV
gh_corner_memory_wait \arch
gh_corner_buffer_descriptor \arch, 64
s_mov_b32 s20, 0
gh_corner_salu_wait \arch
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0x5a5a5a5a
v_mov_b32 v24, 5
v_mov_b32 v25, 0
.ifc \form,buffer
v_mov_b32 v16, v24
v_mov_b32 v17, v25
; LLVM-qualified buffer_atomic_add_u32/u64 v16, v54, s[16:19], s20 offen.
; TH is an independent three-bit field at word 1 bits 20:22. Compose the
; legal cascade+return combinations that have no symbolic assembly alias.
.if \width == 32
.long 0xc40d4014, (0x40882010 | (\th << 20) | ((\scope - 2) << 18)), 0x00000036
.else
.long 0xc410c014, (0x40882010 | (\th << 20) | ((\scope - 2) << 18)), 0x00000036
.endif
.else
.ifc \form,global
.if \width == 32
.long 0xee0d4016, (0x0c080000 | ((\th & 1) * 16) | (\th << 20) | ((\scope - 2) << 18)), 0x00000036
.else
.long 0xee10c016, (0x0c080000 | ((\th & 1) * 16) | (\th << 20) | ((\scope - 2) << 18)), 0x00000036
.endif
.else
v_mov_b32 v54, s22
v_mov_b32 v55, s23
.if \width == 32
.long 0xec0d407c, (0x0c080000 | ((\th & 1) * 16) | (\th << 20) | ((\scope - 2) << 18)), 0x00000036
.else
.long 0xec10c07c, (0x0c080000 | ((\th & 1) * 16) | (\th << 20) | ((\scope - 2) << 18)), 0x00000036
.endif
.endif
.endif
; Returning atomics use LOADCNT, nonreturning atomics use STORECNT.
gh_corner_memory_wait \arch
v_mov_b32 v54, 0
global_load_b64 v[20:21], v54, s[22:23] scope:SCOPE_DEV
gh_corner_memory_wait \arch
; The returned/retained value drives a distinct, in-allocation dependent load.
v_and_b32 v56, 3, v16
v_lshlrev_b32 v56, 2, v56
v_add_u32 v56, 32, v56
gh_corner_global_load \arch, v28, v56
gh_corner_memory_wait \arch
gh_corner_exec \arch, \wave_size, -1
fold_results
.endm

.macro gh_corner_gfx12_atomic_hints arch, wave_size
gh_corner_validate \arch
gh_corner_memory_base \arch, \wave_size
; The memory transition is 7 -> 12 in every case. TH bit 0 alone controls
; returns: BUFFER retains the addend 5 without RETURN, GLOBAL/FLAT retain
; their destination canaries; returning forms yield old 7 (and its high word).
.irp form,buffer,global,flat
.irp width,32,64
.irp th,0,1,2,3,4,5,6,7
gh_corner_gfx12_atomic_case \arch, \wave_size, \form, \width, \th
.endr
; SYS controls are restricted to the returning RT/cascade RT combinations
; physically qualified on gfx1201. NT is deliberately not combined with SYS.
gh_corner_gfx12_atomic_case \arch, \wave_size, \form, \width, 1, 3
gh_corner_gfx12_atomic_case \arch, \wave_size, \form, \width, 5, 3
.endr
.endr
.endm

.macro gh_corner_scratch_case arch, wave_size, vector, scalar, immediate=0, scaled=0, width=32
gh_corner_validate \arch
gh_corner_exec \arch, \wave_size, -1
clear_results
v_mov_b32 v24, 0x5a5a0020
v_mov_b32 v25, 0x6b6b0024
v_mov_b32 v26, 0x7c7c0028
v_mov_b32 v27, 0x8d8d002c
; All dependent addresses are backed by the existing 64-byte private segment.
scratch_store_b128 off, v[24:27], off offset:0
scratch_store_b128 off, v[24:27], off offset:16
scratch_store_b128 off, v[24:27], off offset:32
scratch_store_b128 off, v[24:27], off offset:48
gh_corner_memory_wait \arch
v_mov_b32 v54, \vector
s_mov_b32 s20, \scalar
gh_corner_salu_wait \arch
.if \scaled
.if \width == 128
scratch_load_b128 v[16:19], v54, s20 offset:\immediate scale_offset
.else
scratch_load_b32 v16, v54, s20 offset:\immediate scale_offset
.endif
.else
scratch_load_b32 v16, v54, s20 offset:\immediate
.endif
gh_corner_memory_wait \arch
; Correct signed operands select private byte 32. The load feeds a second
; private address, then a store and reread, before any observed value is reused.
v_xor_b32 v55, 0x5a5a0020, v16
v_and_b32 v55, 28, v55
v_add_u32 v55, 32, v55
scratch_load_b32 v20, v55, off
gh_corner_memory_wait \arch
v_xor_b32 v24, 0x01010101, v20
scratch_store_b32 v55, v24, off
gh_corner_memory_wait \arch
scratch_load_b32 v28, v55, off
gh_corner_memory_wait \arch
fold_results
.endm

.macro gh_corner_signed_scratch arch, wave_size
gh_corner_validate \arch
gh_corner_scratch_case \arch, \wave_size, 32, 0
.ifc \arch,rdna3
; GFX11 scalar/vector scratch inputs retain their legacy unsigned contract.
; These allocated positive controls do not import the GFX12 signed policy.
gh_corner_scratch_case \arch, \wave_size, 16, 16
.else
gh_corner_scratch_case \arch, \wave_size, 64, -32
gh_corner_scratch_case \arch, \wave_size, -32, 64
gh_corner_scratch_case \arch, \wave_size, 64, 0, -32
gh_corner_scratch_case \arch, \wave_size, -32, -32, 96
.endif
.ifc \arch,cdna5
; Widen the signed vector operand before payload scaling: -1*4+36 = 32,
; and -1*16+48 = 32. A DWORD overflow before widening cannot cancel here.
gh_corner_scratch_case \arch, \wave_size, -1, 36, 0, 1, 32
gh_corner_scratch_case \arch, \wave_size, -1, 48, 0, 1, 128
.endif
.endm

; RDNA4 FLAT LDS normalization, allocation-bound and complete-element chains.
; These address-space probes are qualified for RDNA4; other targets need
; separate qualification before adapting the instruction sequences.
; The Guitar Hero descriptor allocates exactly 4096 LDS bytes per workgroup.
; Inputs: full EXEC, v0=work-item id, v50:v51=lane-owned global address,
; v53=lane-owned global offset, s14:s15=group-owned global workspace.
; Clobbers: s16:s17, v16:v31, v54:v57, VCC and SCC; restores full EXEC.
; Existing fold_results and set_exec macros are required. No checkpoints added.

.macro gh_rdna4_lds_seed
; A single work-item owns the boundary probes. Initialize every byte that an
; in-range unaligned load can consume, using ordinary DS stores as producers.
v_mov_b32 v16, 0xffffffff
v_mov_b32 v17, 0x12345678
v_mov_b32 v18, 0x90abcdef
v_mov_b32 v19, 0x31415926
v_mov_b32 v56, 0
ds_store_b128 v56, v[16:19]
v_mov_b32 v56, 4064
ds_store_b128 v56, v[16:19]
ds_store_b128 v56, v[16:19] offset:16
s_wait_dscnt 0
.endm

.macro gh_rdna4_lds_chain bits, offset, immediate=0
gh_rdna4_lds_seed
v_mov_b32 v54, \offset
.if \bits == 8
flat_load_u8 v16, v[54:55] offset:\immediate
.elseif \bits == 16
flat_load_u16 v16, v[54:55] offset:\immediate
.elseif \bits == 32
flat_load_b32 v16, v[54:55] offset:\immediate
.elseif \bits == 64
flat_load_b64 v[16:17], v[54:55] offset:\immediate
.else
flat_load_b128 v[16:19], v[54:55] offset:\immediate
.endif
s_wait_loadcnt 0
s_wait_dscnt 0
; Consume the returned bits in a store and a subsequent load. This does not
; let a matching load/store routing mistake hide behind an unchanged canary.
v_xor_b32 v16, 0x10203040, v16
.if \bits >= 64
v_xor_b32 v17, 0x50607080, v17
.endif
.if \bits == 128
v_xor_b32 v18, 0x90a0b0c0, v18
v_xor_b32 v19, 0xd0e0f000, v19
.endif
.if \bits == 8
flat_store_b8 v[54:55], v16 offset:\immediate
.elseif \bits == 16
flat_store_b16 v[54:55], v16 offset:\immediate
.elseif \bits == 32
flat_store_b32 v[54:55], v16 offset:\immediate
.elseif \bits == 64
flat_store_b64 v[54:55], v[16:17] offset:\immediate
.else
flat_store_b128 v[54:55], v[16:19] offset:\immediate
.endif
s_wait_storecnt 0
s_wait_dscnt 0
; Reload the attempted destination before changing the address. In particular,
; an incorrectly accepted OOB store becomes nonzero even when its initial
; backing happened to be zero, so no neighboring allocation is needed as proof.
.if \bits == 8
flat_load_u8 v20, v[54:55] offset:\immediate
.elseif \bits == 16
flat_load_u16 v20, v[54:55] offset:\immediate
.elseif \bits == 32
flat_load_b32 v20, v[54:55] offset:\immediate
.elseif \bits == 64
flat_load_b64 v[20:21], v[54:55] offset:\immediate
.else
flat_load_b128 v[20:23], v[54:55] offset:\immediate
.endif
s_wait_loadcnt 0
s_wait_dscnt 0
; A safe, separately addressed consumer also depends on that reread.
v_xor_b32 v20, 0x89abcdef, v20
v_mov_b32 v54, 64
.if \bits < 64
flat_store_b32 v[54:55], v20
.elseif \bits == 64
flat_store_b64 v[54:55], v[20:21]
.else
flat_store_b128 v[54:55], v[20:23]
.endif
s_wait_storecnt 0
s_wait_dscnt 0
.if \bits < 64
flat_load_b32 v24, v[54:55]
.elseif \bits == 64
flat_load_b64 v[24:25], v[54:55]
.else
flat_load_b128 v[24:27], v[54:55]
.endif
s_wait_loadcnt 0
s_wait_dscnt 0
fold_results
; Observe stores through DS, independently of FLAT address normalization.
v_mov_b32 v56, 0
ds_load_b128 v[24:27], v56
v_mov_b32 v56, 4080
ds_load_b128 v[28:31], v56
s_wait_dscnt 0
fold_results
.endm

.macro gh_rdna4_lds_atomic offset
gh_rdna4_lds_seed
v_mov_b32 v54, \offset
v_mov_b32 v20, 1
v_mov_b32 v21, 0
flat_atomic_add_u64 v[16:17], v[54:55], v[20:21] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
flat_load_b64 v[18:19], v[54:55]
s_wait_loadcnt 0
s_wait_dscnt 0
; Returned old data also feeds an ordinary memory producer/consumer pair.
v_xor_b32 v16, 0x10203040, v16
v_xor_b32 v17, 0x50607080, v17
v_xor_b32 v16, v18, v16
v_xor_b32 v17, v19, v17
v_mov_b32 v54, 64
flat_store_b64 v[54:55], v[16:17]
s_wait_storecnt 0
s_wait_dscnt 0
flat_load_b64 v[20:21], v[54:55]
s_wait_loadcnt 0
s_wait_dscnt 0
v_mov_b32 v56, 0
ds_load_b128 v[24:27], v56
v_mov_b32 v56, 4080
ds_load_b128 v[28:31], v56
s_wait_dscnt 0
fold_results
.endm

.macro gh_rdna4_flat_lds_corners cc
set_exec -1
fold_results
clear_results
; Retire both earlier waves' LDS accesses before repurposing the boundary.
s_barrier_signal -1
s_barrier_wait -1
s_mov_b64 s[16:17], src_shared_base
s_wait_alu 0xfffe
v_mov_b32 v55, s17
; Work-item zero performs single-writer probes in both wave-size variants.
v_cmpx_eq_u32 0, v0

; Aliases and unsigned range controls distinguish U17 normalization from an
; unbounded address or signed negative-offset check.
.irp offset,0,0x20000,0x80000000,0x10000,0x21000
gh_rdna4_lds_chain 32, \offset
.endr
; Normalize the address plus immediate before checking the allocation bound.
gh_rdna4_lds_chain 32, 0x1fffc, 4
gh_rdna4_lds_chain 32, 4092, 4

; Byte/halfword rejection is whole-element. Wide instructions independently
; transfer complete DWORDs; an incomplete final DWORD is zero/discarded.
.irp offset,4092,4093,4094,4095,4096,0x20ffc
gh_rdna4_lds_chain 8, \offset
gh_rdna4_lds_chain 16, \offset
.endr
.irp offset,4080,4084,4088,4092,4093,4094,4095,4096,0x20ffc
gh_rdna4_lds_chain 32, \offset
gh_rdna4_lds_chain 64, \offset
gh_rdna4_lds_chain 128, \offset
.endr
; Every physical atomic control is naturally eight-byte aligned. Allocation
; granularity supplies no aligned half-valid atomic64 case to claim here.
.irp offset,0,4088,4096,0x20ff8,0x80000ff8
gh_rdna4_lds_atomic \offset
.endr

set_exec -1
s_barrier_signal -1
s_barrier_wait -1
; Mixed global/local lanes own disjoint 16-byte records in each address space.
; Partial EXEC leaves initialized inactive records available for observation.
clear_results
v_lshlrev_b32 v56, 4, v0
v_or_b32 v16, 0x11223300, v0
v_or_b32 v17, 0x44556600, v0
v_or_b32 v18, 0x77889900, v0
v_or_b32 v19, 0xaabbcc00, v0
ds_store_b128 v56, v[16:19]
global_store_b128 v53, v[16:19], s[14:15]
s_wait_dscnt 0
s_wait_storecnt 0
s_barrier_signal -1
s_barrier_wait -1
v_and_b32 v57, 1, v0
v_cmp_eq_u32 \cc, 0, v57
v_mov_b32 v57, s17
s_wait_alu 0xfffd
v_cndmask_b32 v54, v50, v56, \cc
v_cndmask_b32 v55, v51, v57, \cc
.irp r,16,17,18,19
v_mov_b32 v\r, 0xa5a5a5a5
.endr
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_b128 v[16:19], v[54:55]
s_wait_loadcnt 0
s_wait_dscnt 0
v_xor_b32 v16, 0x10203040, v16
v_xor_b32 v17, 0x50607080, v17
v_xor_b32 v18, 0x90a0b0c0, v18
v_xor_b32 v19, 0xd0e0f000, v19
flat_store_b128 v[54:55], v[16:19]
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[24:27], v56
global_load_b128 v[28:31], v53, s[14:15]
s_wait_dscnt 0
s_wait_loadcnt 0
fold_results
s_barrier_signal -1
s_barrier_wait -1
set_exec -1
.endm

; Select the low/high halves independently when the test requests a partial
; mask. With no high operand, zero or -1 is broadcast to the complete EXEC.
.macro set_exec lo, hi
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, \lo
.else
.ifb \hi
s_mov_b64 exec, \lo
.else
s_mov_b32 exec_lo, \lo
s_mov_b32 exec_hi, \hi
.endif
.endif
.endm

; A checkpoint records the mask word for the lane's half of a wave64 mask.
; The optional encoding argument retains explicit e64 coverage in wave32.
.macro mask_result dest, lo, hi, e64=0
.if GUITAR_HERO_WAVE_SIZE == 32
.if \e64
v_mov_b32_e64 \dest, \lo
.else
v_mov_b32 \dest, \lo
.endif
.else
s_wait_alu 0xfffc
v_mov_b32 \dest, \lo
v_mov_b32 v63, \hi
v_cndmask_b32 \dest, \dest, v63, s[58:59]
.endif
.endm

.macro save_exec_mask lo, hi
s_mov_b32 \lo, exec_lo
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 \hi, exec_hi
.endif
.endm

; Wave64 mask_result waits before reading both scalar halves. These waits
; retain the corresponding dependency guards for direct wave32 observations.
.macro wait_wave32_alu count
.if GUITAR_HERO_WAVE_SIZE == 32
s_wait_alu \count
.endif
.endm

.macro clear_results
.irp r,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
v_mov_b32 v\r, 0
.endr
.endm

; Fold under the current EXEC so every active iteration affects the rolling hashes.
.macro fold_results
.irp r,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
v_xor_b32 v60, v60, v\r
v_mul_lo_u32 v60, 0x01000193, v60
v_alignbit_b32 v61, v61, v61, 27
v_add_nc_u32 v61, v61, v\r
v_xor_b32 v61, 0x9e3779b9, v61
.endr
.endm

; A deterministic avalanche hash selects different masks for each seed,
; region and iteration. The two wave64 halves use independent mixing.
; s72=iteration, s73=limit, s74:75=mask, s76:77=scratch, s78:79=previous.
.macro mix_mask word
s_lshr_b32 s76, \word, 16
s_xor_b32 \word, \word, s76
s_mul_i32 \word, \word, 0x7feb352d
s_lshr_b32 s76, \word, 15
s_xor_b32 \word, \word, s76
s_mul_i32 \word, \word, 0x846ca68b
s_lshr_b32 s76, \word, 16
s_xor_b32 \word, \word, s76
.endm

.macro masked_begin id
s_xor_b32 s73, s8, \id
s_and_b32 s73, s73, 3
s_add_u32 s73, s73, 5
s_mov_b32 s72, 0
s_mov_b64 s[78:79], 0
.Lmasked_loop\id:
s_mul_i32 s74, s72, 0x9e3779b9
s_xor_b32 s74, s74, s8
s_xor_b32 s74, s74, ((\id+1)*0x85ebca6b)&0xffffffff
mix_mask s74
s_xor_b32 s75, s74, 0xa511e9b3
mix_mask s75
; Iterations 1/2 retain mixed masks, 3 is sparse, 4 selects one lane,
; 5 is dense, 6 is empty, and 7 selects every lane except one.
s_cmp_eq_u32 s72, 3
s_cbranch_scc0 .Lmask_not_sparse\@
s_lshr_b32 s76, s74, 1
s_and_b32 s74, s74, s76
s_lshr_b32 s76, s75, 1
s_and_b32 s75, s75, s76
.Lmask_not_sparse\@:
s_cmp_eq_u32 s72, 5
s_cbranch_scc0 .Lmask_not_dense\@
s_lshr_b32 s76, s74, 1
s_or_b32 s74, s74, s76
s_lshr_b32 s76, s75, 1
s_or_b32 s75, s75, s76
s_or_b32 s74, s74, 0x80000001
.Lmask_not_dense\@:
s_cmp_eq_u32 s72, 4
s_cbranch_scc1 .Lmask_single\@
s_cmp_eq_u32 s72, 7
s_cbranch_scc0 .Lmask_not_single\@
.Lmask_single\@:
.if GUITAR_HERO_WAVE_SIZE == 64
s_and_b32 s76, s74, 63
s_mov_b64 s[74:75], 1
s_lshl_b64 s[74:75], s[74:75], s76
.else
s_and_b32 s76, s74, 31
s_lshl_b32 s74, 1, s76
s_mov_b32 s75, 0
.endif
s_cmp_eq_u32 s72, 7
s_cbranch_scc0 .Lmask_not_single\@
s_not_b32 s74, s74
s_not_b32 s75, s75
.Lmask_not_single\@:
s_cmp_eq_u32 s72, 6
s_cselect_b32 s74, 0, s74
s_cselect_b32 s75, 0, s75
s_cmp_eq_u32 s72, 0
s_cselect_b32 s74, -1, s74
s_cselect_b32 s75, -1, s75
.if GUITAR_HERO_WAVE_SIZE == 64
s_cmp_eq_u64 s[74:75], s[78:79]
.else
s_cmp_eq_u32 s74, s78
.endif
; Avoid adjacent repeats even if two hash outputs collide.
s_cbranch_scc0 .Lmask_distinct\@
s_cmp_eq_u32 s72, 4
s_cbranch_scc0 .Lmask_flip_bit\@
.if GUITAR_HERO_WAVE_SIZE == 64
s_lshr_b64 s[76:77], s[74:75], 63
s_lshl_b64 s[74:75], s[74:75], 1
s_or_b64 s[74:75], s[74:75], s[76:77]
.else
s_lshr_b32 s76, s74, 31
s_lshl_b32 s74, s74, 1
s_or_b32 s74, s74, s76
.endif
s_branch .Lmask_distinct\@
.Lmask_flip_bit\@:
s_xor_b32 s74, s74, 1
.Lmask_distinct\@:
s_mov_b64 s[78:79], s[74:75]
s_wait_alu 0xf1fc
set_exec s74, s75
.endm

.macro masked_end id
fold_results
s_add_u32 s72, s72, 1
s_cmp_lt_u32 s72, s73
s_cbranch_scc1 .Lmasked_loop\id
s_wait_alu 0xf1fc
set_exec -1
.endm

.macro checkpoint id
; The same binary supports smoke checks, timing and checkpoint dumps.
s_cmp_eq_u32 s9, \id+1
s_cbranch_scc0 .Lno_trace\@
v_lshlrev_b32 v62, 6, v0
global_store_b128 v62, v[16:19], s[6:7] offset:0
global_store_b128 v62, v[20:23], s[6:7] offset:16
global_store_b128 v62, v[24:27], s[6:7] offset:32
global_store_b128 v62, v[28:31], s[6:7] offset:48
.Lno_trace\@:
; Ordered rolling hashes observe result bits, including inactive lanes.
fold_results
v_lshlrev_b32 v62, 3, v0
v_add_nc_u32 v62, 512*\id, v62
global_store_b64 v62, v[60:61], s[4:5]
s_cmp_eq_u32 s11, \id+1
s_cbranch_scc0 .Lcontinue\@
s_wait_storecnt 0
s_endpgm
.Lcontinue\@:
.endm

.macro sweep_inputs kind
.ifc \kind,half
v_cvt_f16_f32 v8, v4
v_cvt_f16_f32 v9, v5
v_pack_b32_f16 v10, v8, v9
v_pack_b32_f16 v8, v8, v9
v_pack_b32_f16 v9, v9, v8
.else
.ifc \kind,float
v_mov_b32 v8, v4
v_mov_b32 v9, v5
v_mov_b32 v10, v6
.else
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v0
.endif
.endif
s_mov_b32 m0, 0
s_mov_b32 s23, 0x96966969
s_wait_alu 0xfffe
s_mov_b32 vcc_lo, s23
.if GUITAR_HERO_WAVE_SIZE == 64
s_not_b32 vcc_hi, s23
.endif
s_mov_b32 s20, 0
.endm

.macro guitar_hero_kernel name, cc, wave_size, sgpr_count
; gfx1201, both wave sizes, exactly 64 work-items per independent workgroup.
; v0=local id, v1:2=integer inputs, v3=lane, v4:6=finite FP inputs.
; v16:31=checkpoint results, v32:47=matrix operands, v60:61=rolling digest.
; s4:5=group output, s6:7=optional raw checkpoint, s8=seed, s9=trace id.
; RDNA4 SGPR reuse guards follow ISA 5.7: 0xfffe waits for SALU writes,
; 0xfffd for VALU VCC writes, and 0xf1ff for other VALU SGPR writes.
; Local control-flow boundaries use 0xf1fc to cover all three classes.
.text
.protected \name
.globl \name
.p2align 8
.type \name,@function
\name:
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 s58, 0
s_mov_b32 s59, -1
.endif
s_load_b128 s[4:7], s[0:1], 0
s_load_b64 s[8:9], s[0:1], 16
s_load_b32 s11, s[0:1], 24
s_wait_kmcnt 0
; gfx12 delivers workgroup id X in ttmp9.
s_mul_i32 s12, ttmp9, 332800
s_wait_alu 0xfffe
s_add_u32 s4, s4, s12
s_addc_u32 s5, s5, 0
v_mul_lo_u32 v1, 0x2c9277b5, v0
v_xor_b32 v1, s8, v1
v_bfrev_b32 v2, v1
v_and_b32 v3, GUITAR_HERO_WAVE_SIZE-1, v0
v_cvt_f32_u32 v4, v3
v_fma_f32 v4, v4, 0.25, -2.0
v_add_f32 v5, |v4|, 1.0
v_mul_f32 v6, v4, 0.0625
s_mov_b32 s10, 0x3f000000
v_mov_b32 v60, 0x811c9dc5
v_mov_b32 v61, 0x243f6a88

; Checkpoint 0: integer
clear_results
masked_begin 0
v_add_nc_u32 v16, v1, v2
v_sub_nc_u32 v17, v1, v2
v_mul_lo_u32 v18, v1, v2
v_mul_hi_u32 v19, v1, v2
v_mul_hi_i32 v20, v1, v2
v_mul_i32_i24 v21, v1, v2
v_mul_hi_i32_i24 v22, v1, v2
v_mul_u32_u24 v23, v1, v2
v_mad_i32_i24 v24, v1, v2, v0
v_mad_u32_u24 v25, v1, v2, v0
v_min_i32 v26, v1, v2
v_max_u32 v27, v1, v2
v_min3_i32 v28, v1, v2, v0
v_max3_u32 v29, v1, v2, v0
v_med3_i32 v30, v1, v2, v0
v_add3_u32 v31, v1, v2, v0
masked_end 0
checkpoint 0


; Checkpoint 1: bits
clear_results
masked_begin 1
v_and_b32 v16, v1, v2
v_or_b32 v17, v1, v2
v_xor_b32 v18, v1, v2
v_not_b32 v19, v1
v_bfrev_b32 v20, v1
v_bcnt_u32_b32 v21, v1, 0
v_ffbh_u32 v22, v1
v_ffbl_b32 v23, v1
v_bfe_u32 v24, v1, 3, 11
v_bfe_i32 v25, v1, 5, 17
v_bfi_b32 v26, v1, v2, v0
v_lshlrev_b32 v27, v0, v1
v_lshrrev_b32 v28, v0, v1
v_ashrrev_i32 v29, v0, v1
v_alignbit_b32 v30, v1, v2, v0
v_perm_b32 v31, v1, v2, 0x05040200
masked_end 1
checkpoint 1


; Checkpoint 2: carry
clear_results
masked_begin 2
v_add_co_u32 v16, \cc, v1, v2
s_wait_alu 0xfffd
v_add_co_ci_u32 v17, \cc, v2, v1, \cc
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
v_sub_co_u32 v19, \cc, v1, v2
s_wait_alu 0xfffd
v_sub_co_ci_u32 v20, \cc, v2, v1, \cc
wait_wave32_alu 0xfffd
mask_result v21, vcc_lo, vcc_hi
.if GUITAR_HERO_WAVE_SIZE == 32
v_mad_u64_u32 v[22:23], s20, v1, v2, v[16:17]
v_mad_i64_i32 v[24:25], s21, v1, v2, v[16:17]
.else
v_mad_u64_u32 v[22:23], s[64:65], v1, v2, v[16:17]
s_mov_b32 s20, s64
v_mad_i64_i32 v[24:25], s[66:67], v1, v2, v[16:17]
s_mov_b32 s21, s66
.endif
v_lshlrev_b64 v[26:27], v0, v[1:2]
v_lshrrev_b64 v[28:29], v0, v[1:2]
v_ashrrev_i64 v[30:31], v0, v[1:2]
masked_end 2
checkpoint 2


; Checkpoint 3: scalar
clear_results
s_add_u32 s16, s8, 0x76543210
s_wait_alu 0xfffe
v_mov_b32 v16, s16
s_addc_u32 s17, s16, -1
s_wait_alu 0xfffe
v_mov_b32 v17, s17
s_sub_u32 s18, s16, s8
s_wait_alu 0xfffe
v_mov_b32 v18, s18
s_subb_u32 s19, 0, s8
s_wait_alu 0xfffe
v_mov_b32 v19, s19
s_mul_i32 s20, s8, 31337
s_wait_alu 0xfffe
v_mov_b32 v20, s20
s_brev_b32 s21, s20
s_wait_alu 0xfffe
v_mov_b32 v21, s21
s_bcnt1_i32_b32 s22, s21
s_wait_alu 0xfffe
v_mov_b32 v22, s22
s_ff1_i32_b32 s23, s21
s_wait_alu 0xfffe
v_mov_b32 v23, s23
s_bfe_i32 s24, s20, 0x000d0007
s_wait_alu 0xfffe
v_mov_b32 v24, s24
s_min_i32 s25, s20, s21
s_wait_alu 0xfffe
v_mov_b32 v25, s25
s_max_u32 s26, s20, s21
s_wait_alu 0xfffe
v_mov_b32 v26, s26
s_lshl_b64 s[28:29], s[20:21], 17
s_wait_alu 0xfffe
v_mov_b32 v28, s28
v_mov_b32 v29, s29
s_bitcmp1_b32 s20, 5
s_mov_b32 s31, 0x9876
s_wait_alu 0xfffe
s_cselect_b32 s30, 0x1234, s31
s_wait_alu 0xfffe
v_mov_b32 v30, s30
v_mov_b32 v31, src_scc
checkpoint 3


; Checkpoint 4: fp32
clear_results
masked_begin 4
v_add_f32 v16, v4, v5
v_sub_f32 v17, v4, v5
v_mul_f32 v18, v4, v5
v_fma_f32 v19, v4, v5, v6
v_fmac_f32 v20, v4, v5
v_min_f32 v21, v4, v5
v_max_f32 v22, v4, v5
v_min3_f32 v23, v4, v5, v6
v_max3_f32 v24, v4, v5, v6
v_med3_f32 v25, v4, v5, v6
v_fma_f32 v26, -v4, |v5|, -|v6| mul:2
v_add_f32 v27, |v4|, -v5 div:2
v_mul_f32 v28, -|v4|, -v5 mul:4
v_fma_f32 v29, v4, v5, v6 clamp
v_mul_legacy_f32 v30, v4, v5
v_fma_legacy_f32 v31, v4, v5, v6
masked_end 4
checkpoint 4


; Checkpoint 5: transcendental
clear_results
masked_begin 5
v_rcp_f32 v16, v5
v_rsq_f32 v17, v5
v_sqrt_f32 v18, v5
v_exp_f32 v19, v4
v_log_f32 v20, v5
v_sin_f32 v21, v6
v_cos_f32 v22, v6
v_fract_f32 v23, v4
v_floor_f32 v24, v4
v_ceil_f32 v25, v4
v_trunc_f32 v26, v4
v_rndne_f32 v27, v4
v_ldexp_f32 v28, v4, 3
v_frexp_exp_i32_f32 v29, v5
v_frexp_mant_f32 v30, v5
v_cvt_i32_f32 v31, v4
masked_end 5
checkpoint 5


; Checkpoint 6: conversion
clear_results
masked_begin 6
v_cvt_f32_i32 v16, v1
v_cvt_f32_u32 v17, v2
v_cvt_u32_f32 v18, v5
v_cvt_f16_f32 v19, v4
v_cvt_f32_f16 v20, v19
v_cvt_pkrtz_f16_f32 v21, v4, v5
v_cvt_pk_i16_i32 v22, v1, v2
v_cvt_pk_u16_u32 v23, v1, v2
v_cvt_f32_ubyte0 v24, v1
v_cvt_f32_ubyte1 v25, v1
v_cvt_f32_ubyte2 v26, v1
v_cvt_f32_ubyte3 v27, v1
v_cvt_pk_fp8_f32 v28, v4, v5
v_cvt_pk_bf8_f32 v29, v4, v5
v_cvt_f32_fp8 v30, v28
v_cvt_f32_bf8 v31, v29
masked_end 6
checkpoint 6


; Checkpoint 7: fp16
clear_results
masked_begin 7
; Nonzero untouched halves make partial-register clobbering observable.
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v22, 0xa5a5a5a5
v_mov_b32 v23, 0xa5a5a5a5
v_cvt_pkrtz_f16_f32 v8, v4, v5
v_cvt_pkrtz_f16_f32 v9, v5, v6
v_add_f16 v16, v8, v9
v_sub_f16 v17, v8, v9
v_mul_f16 v18, v8, v9
v_fma_f16 v19, v8, v9, v8
v_min_f16 v20, v8, v9
v_max_f16 v21, v8, v9
v_add_f16_e64 v22.h, v8.h, v9.l clamp
v_fma_f16 v23, -v8, |v9|, v8 op_sel:[1,0,1,1] div:2
v_rcp_f16 v24, v9
v_sqrt_f16 v25, v9
v_rsq_f16 v26, v9
v_exp_f16 v27, v8
v_log_f16 v28, v9
v_floor_f16 v29, v8
v_ceil_f16 v30, v8
v_rndne_f16 v31, v8
masked_end 7
checkpoint 7


; Checkpoint 8: packed
clear_results
masked_begin 8
v_pk_add_f16 v16, v8, v9
v_pk_mul_f16 v17, v8, v9
v_pk_fma_f16 v18, v8, v9, v8
v_pk_min_f16 v19, v8, v9
v_pk_max_f16 v20, v8, v9
v_pk_add_f16 v21, v8, v9 op_sel:[1,0] op_sel_hi:[0,1] neg_lo:[1,0] neg_hi:[0,1] clamp
v_pk_fma_f16 v22, v8, v9, v8 op_sel:[1,0,1] op_sel_hi:[0,1,0] neg_lo:[1,0,1] neg_hi:[0,1,0]
v_pk_add_u16 v23, v1, v2
v_pk_sub_i16 v24, v1, v2 clamp
v_pk_mul_lo_u16 v25, v1, v2
v_pk_min_i16 v26, v1, v2
v_pk_max_u16 v27, v1, v2
v_pk_lshlrev_b16 v28, v1, v2
v_pk_ashrrev_i16 v29, v1, v2
v_fma_mix_f32 v30, v8, v9, v6 op_sel_hi:[1,1,0]
v_fma_mixlo_f16 v31, v8, v9, v6 op_sel_hi:[1,1,0]
masked_end 8
checkpoint 8


; Checkpoint 9: dot
clear_results
masked_begin 9
v_dot2_f32_f16 v16, v8, v9, 0
v_dot2_f32_bf16 v17, 0x3f003f80, v9, v6
v_dot4_i32_iu8 v18, v1, v2, v0
v_dot4_i32_iu8 v19, v1, v2, v0 neg_lo:[1,1,0] clamp
v_dot8_i32_iu4 v20, v1, v2, v0
v_dot8_i32_iu4 v21, v1, v2, v0 neg_lo:[1,0,0]
v_dot4_u32_u8 v22, v1, v2, v0
v_dot8_u32_u4 v23, v1, v2, v0
v_dot4_f32_fp8_fp8 v24, 0x30384020, v1, v6
v_dot4_f32_bf8_bf8 v25, 0x30384020, v1, v6
v_dot4_f32_fp8_bf8 v26, 0x30384020, v1, v6
v_dot4_f32_bf8_fp8 v27, 0x30384020, v1, v6
v_sad_u8 v28, v1, v2, v0
v_sad_u16 v29, v1, v2, v0
v_sad_u32 v30, v1, v2, v0
v_msad_u8 v31, v1, v2, v0
masked_end 9
checkpoint 9


; Checkpoint 10: fp64
clear_results
masked_begin 10
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_add_f64 v[16:17], v[8:9], v[10:11]
v_mul_f64 v[18:19], v[8:9], v[10:11]
v_fma_f64 v[20:21], v[8:9], v[10:11], v[16:17]
v_min_f64 v[22:23], v[8:9], v[10:11]
v_max_f64 v[24:25], v[8:9], v[10:11]
v_ldexp_f64 v[26:27], v[8:9], 3
v_floor_f64 v[28:29], v[8:9]
v_fract_f64 v[30:31], v[8:9]
masked_end 10
checkpoint 10


; Checkpoint 11: divergent_loops
clear_results
; Each iteration rotates and changes the wave mask before lane trip filtering.
; The scalar induction variable advances even when no lanes participate.
v_xor_b32 v12, s8, v0
v_and_b32 v12, 15, v12
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_u32 \cc, 31, v3
.else
v_cmp_eq_u32 \cc, 63, v3
.endif
s_wait_alu 0xfffd
v_cndmask_b32 v12, v12, 16, \cc
v_mov_b32 v13, 0
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 s12, exec_lo
.else
s_mov_b64 s[48:49], exec
.endif
s_mov_b32 s14, 0
s_and_b32 s15, s8, 15
s_wait_alu 0xfffe
s_add_u32 s15, s15, 1
s_xor_b32 s16, s8, 0xa5a50001
.if GUITAR_HERO_WAVE_SIZE == 64
s_xor_b32 s52, s8, 0x5a5a8000
.endif
.Lloop:
s_wait_alu 0xf1fc
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s12
.else
s_mov_b64 exec, s[48:49]
.endif
v_cmp_gt_u32 \cc, v12, s14
s_lshl_b32 s18, s16, 5
s_lshr_b32 s19, s16, 27
s_wait_alu 0xfffe
s_or_b32 s16, s18, s19
s_wait_alu 0xfffe
s_xor_b32 s16, s16, 0x9e3779b9
.if GUITAR_HERO_WAVE_SIZE == 64
s_lshl_b32 s18, s52, 7
s_lshr_b32 s19, s52, 25
.endif
s_wait_alu 0xfffe
.if GUITAR_HERO_WAVE_SIZE == 64
s_or_b32 s52, s18, s19
s_wait_alu 0xfffe
s_xor_b32 s52, s52, 0x7f4a7c15
.endif
s_and_b32 exec_lo, s16, vcc_lo
.if GUITAR_HERO_WAVE_SIZE == 64
s_wait_alu 0xfffe
s_and_b32 exec_hi, s52, vcc_hi
.endif
v_add_nc_u32 v16, v1, s14
v_xor_b32 v17, v16, v2
v_and_b32 v14, 1, v17
v_cmp_eq_u32 \cc, 0, v14
.if GUITAR_HERO_WAVE_SIZE == 32
s_and_saveexec_b32 s13, vcc_lo
.else
s_and_saveexec_b64 s[50:51], vcc
.endif
v_fma_f32 v18, v4, 0.5, v18
v_xor_b32 v19, v19, v17
s_wait_alu 0xfffe
.if GUITAR_HERO_WAVE_SIZE == 32
s_xor_b32 exec_lo, exec_lo, s13
.else
s_xor_b64 exec, exec, s[50:51]
.endif
v_add_f32 v18, v18, v5
v_add_nc_u32 v19, v19, v17
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s13
.else
s_mov_b64 exec, s[50:51]
.endif
v_add_nc_u32 v13, 1, v13
.if GUITAR_HERO_WAVE_SIZE == 32
v_xor_b32 v22, v22, s16
.else
mask_result v14, s16, s52
v_xor_b32 v22, v22, v14
.endif
s_add_u32 s14, s14, 1
s_wait_alu 0xfffe
s_cmp_lt_u32 s14, s15
s_cbranch_scc1 .Lloop
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s12
.else
s_mov_b64 exec, s[48:49]
.endif
v_mov_b32 v20, v13
v_mov_b32 v21, v12
v_mov_b32 v23, s14
; A second loop changes EXEC from full through progressively shifted masks.
s_mov_b32 s14, 0
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 s16, -1
.else
s_mov_b64 s[52:53], -1
.endif
.Luniform:
s_wait_alu 0xf1fc
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s16
.else
s_mov_b64 exec, s[52:53]
.endif
v_xor_b32 v24, v24, v19
v_add_nc_u32 v25, v25, v1
v_add_nc_u32 v26, 1, v26
.if GUITAR_HERO_WAVE_SIZE == 32
s_lshl_b32 s16, s16, 1
.else
s_lshl_b64 s[52:53], s[52:53], 1
.endif
s_add_u32 s14, s14, 1
s_wait_alu 0xfffe
s_cmp_lt_u32 s14, s15
s_cbranch_scc1 .Luniform
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s12
.else
s_mov_b64 exec, s[48:49]
.endif
checkpoint 11


; Checkpoint 12: exec_full
clear_results
; Inactive destinations must retain their initialized values.
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
v_mov_b32 v20, 0xa5a5a5a5
v_mov_b32 v21, 0xa5a5a5a5
v_mov_b32 v22, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 s12, exec_lo
.else
s_mov_b64 s[48:49], exec
.endif
set_exec -1
v_add_f32 v16, v4, s10
v_fma_f32 v17, v4, 0x3f800001, v6
v_mul_lo_u32 v18, v1, s8
v_cmp_lt_f32 \cc, v4, v5
s_wait_alu 0xfffd
v_cndmask_b32 v19, v1, v2, \cc
mask_result v20, vcc_lo, vcc_hi
v_pk_add_f16 v21, 0x3c003800, v1 op_sel:[1,0] op_sel_hi:[0,1]
v_bcnt_u32_b32 v22, v1, 0
save_exec_mask s16, s54
.if GUITAR_HERO_WAVE_SIZE == 32
s_bcnt1_i32_b32 s17, exec_lo
.else
s_bcnt1_i32_b64 s17, exec
.endif
s_wait_alu 0xfffe
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s12
.else
s_mov_b64 exec, s[48:49]
.endif
mask_result v23, s16, s54
v_mov_b32 v24, s17
checkpoint 12


; Checkpoint 13: exec_alternating
clear_results
; Inactive destinations must retain their initialized values.
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
v_mov_b32 v20, 0xa5a5a5a5
v_mov_b32 v21, 0xa5a5a5a5
v_mov_b32 v22, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 s12, exec_lo
set_exec 0x55555555, 0x55555555
.else
s_mov_b64 s[48:49], exec
set_exec 0x55555555, 0xaaaaaaaa
.endif
v_add_f32 v16, v4, s10
v_fma_f32 v17, v4, 0x3f800001, v6
v_mul_lo_u32 v18, v1, s8
v_cmp_lt_f32 \cc, v4, v5
s_wait_alu 0xfffd
v_cndmask_b32 v19, v1, v2, \cc
mask_result v20, vcc_lo, vcc_hi
v_pk_add_f16 v21, 0x3c003800, v1 op_sel:[1,0] op_sel_hi:[0,1]
v_bcnt_u32_b32 v22, v1, 0
save_exec_mask s16, s54
.if GUITAR_HERO_WAVE_SIZE == 32
s_bcnt1_i32_b32 s17, exec_lo
.else
s_bcnt1_i32_b64 s17, exec
.endif
s_wait_alu 0xfffe
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s12
.else
s_mov_b64 exec, s[48:49]
.endif
mask_result v23, s16, s54
v_mov_b32 v24, s17
checkpoint 13


; Checkpoint 14: exec_sparse
clear_results
; Inactive destinations must retain their initialized values.
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
v_mov_b32 v20, 0xa5a5a5a5
v_mov_b32 v21, 0xa5a5a5a5
v_mov_b32 v22, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 s12, exec_lo
.else
s_mov_b64 s[48:49], exec
.endif
set_exec 0x80010081, 0x40800803
v_add_f32 v16, v4, s10
v_fma_f32 v17, v4, 0x3f800001, v6
v_mul_lo_u32 v18, v1, s8
v_cmp_lt_f32 \cc, v4, v5
s_wait_alu 0xfffd
v_cndmask_b32 v19, v1, v2, \cc
mask_result v20, vcc_lo, vcc_hi
v_pk_add_f16 v21, 0x3c003800, v1 op_sel:[1,0] op_sel_hi:[0,1]
v_bcnt_u32_b32 v22, v1, 0
save_exec_mask s16, s54
.if GUITAR_HERO_WAVE_SIZE == 32
s_bcnt1_i32_b32 s17, exec_lo
.else
s_bcnt1_i32_b64 s17, exec
.endif
s_wait_alu 0xfffe
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s12
.else
s_mov_b64 exec, s[48:49]
.endif
mask_result v23, s16, s54
v_mov_b32 v24, s17
checkpoint 14


; Checkpoint 15: exec_last_lane
clear_results
; Inactive destinations must retain their initialized values.
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
v_mov_b32 v20, 0xa5a5a5a5
v_mov_b32 v21, 0xa5a5a5a5
v_mov_b32 v22, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 s12, exec_lo
s_mov_b32 exec_lo, 0x80000000
.else
s_mov_b64 s[48:49], exec
set_exec 0, 0x80000000
.endif
v_add_f32 v16, v4, s10
v_fma_f32 v17, v4, 0x3f800001, v6
v_mul_lo_u32 v18, v1, s8
v_cmp_lt_f32 \cc, v4, v5
s_wait_alu 0xfffd
v_cndmask_b32 v19, v1, v2, \cc
mask_result v20, vcc_lo, vcc_hi
v_pk_add_f16 v21, 0x3c003800, v1 op_sel:[1,0] op_sel_hi:[0,1]
v_bcnt_u32_b32 v22, v1, 0
save_exec_mask s16, s54
.if GUITAR_HERO_WAVE_SIZE == 32
s_bcnt1_i32_b32 s17, exec_lo
.else
s_bcnt1_i32_b64 s17, exec
.endif
s_wait_alu 0xfffe
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s12
.else
s_mov_b64 exec, s[48:49]
.endif
mask_result v23, s16, s54
v_mov_b32 v24, s17
checkpoint 15


; Checkpoint 16: exec_empty
clear_results
; Inactive destinations must retain their initialized values.
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
v_mov_b32 v20, 0xa5a5a5a5
v_mov_b32 v21, 0xa5a5a5a5
v_mov_b32 v22, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 s12, exec_lo
set_exec 0, 0x80000000
.else
s_mov_b64 s[48:49], exec
set_exec 0
.endif
v_add_f32 v16, v4, s10
v_fma_f32 v17, v4, 0x3f800001, v6
v_mul_lo_u32 v18, v1, s8
v_cmp_lt_f32 \cc, v4, v5
s_wait_alu 0xfffd
v_cndmask_b32 v19, v1, v2, \cc
mask_result v20, vcc_lo, vcc_hi
v_pk_add_f16 v21, 0x3c003800, v1 op_sel:[1,0] op_sel_hi:[0,1]
v_bcnt_u32_b32 v22, v1, 0
save_exec_mask s16, s54
.if GUITAR_HERO_WAVE_SIZE == 32
s_bcnt1_i32_b32 s17, exec_lo
.else
s_bcnt1_i32_b64 s17, exec
.endif
s_wait_alu 0xfffe
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s12
.else
s_mov_b64 exec, s[48:49]
.endif
mask_result v23, s16, s54
v_mov_b32 v24, s17
checkpoint 16


; Checkpoint 17: cross_lane
clear_results
v_mov_b32 v16, v1
v_mov_b32 v17, v1 quad_perm:[3,2,1,0]
v_mov_b32 v18, v1 row_mirror
v_mov_b32 v19, v1 dpp8:[7,6,5,4,3,2,1,0]
s_mov_b32 s18, 0x76543210
s_mov_b32 s19, 0xfedcba98
s_wait_alu 0xfffe
v_permlane16_b32 v20, v1, s18, s19
v_permlanex16_b32 v21, v1, s18, s19
v_xor_b32 v12, 31, v3
v_lshlrev_b32 v12, 2, v12
ds_bpermute_b32 v22, v12, v1
ds_swizzle_b32 v23, v1 offset:0x041f
s_wait_dscnt 0
v_readfirstlane_b32 s16, v1
v_readlane_b32 s17, v1, 31
s_wait_alu 0xf1ff
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_writelane_b32 v26, s8, 17
v_mbcnt_lo_u32_b32 v27, -1, 0
v_mbcnt_hi_u32_b32 v28, -1, v27
.if GUITAR_HERO_WAVE_SIZE == 64
v_permlane64_b32 v29, v1
v_readlane_b32 s17, v1, 63
s_wait_alu 0xf1ff
v_mov_b32 v30, s17
v_writelane_b32 v31, s8, 63
.endif
checkpoint 17


; Checkpoint 18: reduction
clear_results
v_mov_b32 v16, v0
; XOR butterfly: all lanes see the sum of their wave.
.irp shift,1,2,4,8,16
v_xor_b32 v12, \shift, v3
v_lshlrev_b32 v12, 2, v12
ds_bpermute_b32 v17, v12, v16
s_wait_dscnt 0
v_add_nc_u32 v16, v16, v17
.endr
.if GUITAR_HERO_WAVE_SIZE == 32
; Cross-wave exchange through LDS, with converged barriers.
.else
v_permlane64_b32 v17, v16
v_add_nc_u32 v16, v16, v17
; Exchange between the two 32-lane halves through LDS, with converged barriers.
.endif
v_lshlrev_b32 v12, 2, v0
ds_store_b32 v12, v16
s_wait_dscnt 0
s_barrier_signal -1
s_barrier_wait -1
v_xor_b32 v13, 128, v12
ds_load_b32 v18, v13
s_wait_dscnt 0
v_add_nc_u32 v19, v16, v18
; Finish all peer reads before changing their LDS values.
s_barrier_signal -1
s_barrier_wait -1
; Per-lane atomics avoid ordering-dependent returned values.
ds_add_rtn_u32 v20, v12, v0
s_wait_dscnt 0
ds_load_b32 v21, v12
s_wait_dscnt 0
s_barrier_signal -1
s_barrier_wait -1
checkpoint 18


.if GUITAR_HERO_WAVE_SIZE == 32
; Checkpoint 19: dual_issue
.else
; Checkpoint 19: serial_valu
.endif
clear_results
.if GUITAR_HERO_WAVE_SIZE == 32
v_dual_add_f32 v16, v4, v5 :: v_dual_mul_f32 v17, v5, v4
v_dual_sub_f32 v18, v4, v5 :: v_dual_subrev_f32 v19, v5, v4
v_dual_max_num_f32 v20, v4, v5 :: v_dual_min_num_f32 v21, v5, v4
v_dual_mov_b32 v22, v1 :: v_dual_add_nc_u32 v23, v2, v1
v_dual_fmac_f32 v24, v4, v5 :: v_dual_fmac_f32 v25, v5, v4
.else
v_add_f32 v16, v4, v5
v_mul_f32 v17, v5, v4
v_sub_f32 v18, v4, v5
v_subrev_f32 v19, v5, v4
v_max_num_f32 v20, v4, v5
v_min_num_f32 v21, v5, v4
v_mov_b32 v22, v1
v_add_nc_u32 v23, v2, v1
v_fmac_f32 v24, v4, v5
v_fmac_f32 v25, v5, v4
.endif
checkpoint 19


; Checkpoint 20: wmma_f32_f16
clear_results
.irp r,32,33,34,35,36,37,38,39
v_add_nc_u32 v\r, v0, \r
v_and_b32 v\r, 3, v\r
v_cvt_f32_u32 v\r, v\r
v_cvt_pkrtz_f16_f32 v\r, v\r, v5
.endr
.if GUITAR_HERO_WAVE_SIZE == 32
v_wmma_f32_16x16x16_f16 v[16:23], v[32:35], v[36:39], v[16:23]
v_wmma_f32_16x16x16_f16 v[24:31], v[32:35], v[36:39], v[16:23] neg_lo:[1,0,1] neg_hi:[0,1,1]
.else
v_wmma_f32_16x16x16_f16 v[16:19], v[32:33], v[36:37], v[16:19]
v_wmma_f32_16x16x16_f16 v[24:27], v[32:33], v[36:37], v[16:19] neg_lo:[1,0,1] neg_hi:[0,1,1]
.endif
checkpoint 20


; Checkpoint 21: wmma_f16
clear_results
.if GUITAR_HERO_WAVE_SIZE == 32
v_wmma_f16_16x16x16_f16 v[16:19], v[32:35], v[36:39], v[16:19]
v_wmma_f16_16x16x16_f16 v[20:23], v[32:35], v[36:39], v[16:19] neg_lo:[1,0,1] neg_hi:[0,1,1]
.else
v_wmma_f16_16x16x16_f16 v[16:17], v[32:33], v[36:37], v[16:17]
v_wmma_f16_16x16x16_f16 v[20:21], v[32:33], v[36:37], v[16:17] neg_lo:[1,0,1] neg_hi:[0,1,1]
.endif
checkpoint 21


; Checkpoint 22: wmma_f32_bf16
clear_results
.irp r,32,33,34,35,36,37,38,39
v_add_nc_u32 v\r, v0, \r
v_and_b32 v\r, 3, v\r
v_cvt_f32_u32 v\r, v\r
v_lshrrev_b32 v\r, 16, v\r
.endr
.if GUITAR_HERO_WAVE_SIZE == 32
v_wmma_f32_16x16x16_bf16 v[16:23], v[32:35], v[36:39], v[16:23]
v_wmma_f32_16x16x16_bf16 v[24:31], v[32:35], v[36:39], v[16:23] neg_lo:[1,0,1] neg_hi:[0,1,1]
.else
v_wmma_f32_16x16x16_bf16 v[16:19], v[32:33], v[36:37], v[16:19]
v_wmma_f32_16x16x16_bf16 v[24:27], v[32:33], v[36:37], v[16:19] neg_lo:[1,0,1] neg_hi:[0,1,1]
.endif
checkpoint 22


; Checkpoint 23: wmma_bf16
clear_results
.if GUITAR_HERO_WAVE_SIZE == 32
v_wmma_bf16_16x16x16_bf16 v[16:19], v[32:35], v[36:39], v[16:19]
v_wmma_bf16_16x16x16_bf16 v[20:23], v[32:35], v[36:39], v[16:19] neg_lo:[1,0,1] neg_hi:[0,1,1]
.else
v_wmma_bf16_16x16x16_bf16 v[16:17], v[32:33], v[36:37], v[16:17]
v_wmma_bf16_16x16x16_bf16 v[20:21], v[32:33], v[36:37], v[16:17] neg_lo:[1,0,1] neg_hi:[0,1,1]
.endif
checkpoint 23


; Checkpoint 24: wmma_iu8_k16
clear_results
v_xor_b32 v32, v1, 0x10203040
v_xor_b32 v33, v2, 0xfedcba98
v_xor_b32 v36, v1, 0x80706050
v_xor_b32 v37, v2, 0x12345678
.if GUITAR_HERO_WAVE_SIZE == 32
v_wmma_i32_16x16x16_iu8 v[16:23], v[32:33], v[36:37], v[16:23]
v_wmma_i32_16x16x16_iu8 v[24:31], v[32:33], v[36:37], v[16:23] neg_lo:[1,1,0] clamp
.else
v_wmma_i32_16x16x16_iu8 v[16:19], v32, v36, v[16:19]
v_wmma_i32_16x16x16_iu8 v[24:27], v32, v36, v[16:19] neg_lo:[1,1,0] clamp
.endif
checkpoint 24


; Checkpoint 25: wmma_iu4_k16
clear_results
v_xor_b32 v32, v1, 0x10203040
v_xor_b32 v33, v2, 0xfedcba98
v_xor_b32 v36, v1, 0x80706050
v_xor_b32 v37, v2, 0x12345678
.if GUITAR_HERO_WAVE_SIZE == 32
v_wmma_i32_16x16x16_iu4 v[16:23], v32, v36, v[16:23]
v_wmma_i32_16x16x16_iu4 v[24:31], v32, v36, v[16:23] neg_lo:[1,1,0] clamp
.else
v_wmma_i32_16x16x16_iu4 v[16:19], v32, v36, v[16:19]
v_wmma_i32_16x16x16_iu4 v[24:27], v32, v36, v[16:19] neg_lo:[1,1,0] clamp
.endif
checkpoint 25


; Checkpoint 26: wmma_iu4_k32
clear_results
v_xor_b32 v32, v1, 0x10203040
v_xor_b32 v33, v2, 0xfedcba98
v_xor_b32 v36, v1, 0x80706050
v_xor_b32 v37, v2, 0x12345678
.if GUITAR_HERO_WAVE_SIZE == 32
v_wmma_i32_16x16x32_iu4 v[16:23], v[32:33], v[36:37], v[16:23]
v_wmma_i32_16x16x32_iu4 v[24:31], v[32:33], v[36:37], v[16:23] neg_lo:[1,1,0] clamp
.else
v_wmma_i32_16x16x32_iu4 v[16:19], v32, v36, v[16:19]
v_wmma_i32_16x16x32_iu4 v[24:27], v32, v36, v[16:19] neg_lo:[1,1,0] clamp
.endif
checkpoint 26


; Checkpoint 27: wmma_fp8_fp8
clear_results
v_and_b32 v32, 0x03030303, v1
v_or_b32 v32, 0x30303030, v32
v_xor_b32 v33, 0x08080808, v32
v_and_b32 v36, 0x03030303, v2
v_or_b32 v36, 0x30303030, v36
v_xor_b32 v37, 0x08080808, v36
.if GUITAR_HERO_WAVE_SIZE == 32
v_wmma_f32_16x16x16_fp8_fp8 v[16:23], v[32:33], v[36:37], v[16:23]
v_wmma_f32_16x16x16_fp8_fp8 v[24:31], v[32:33], v[36:37], v[16:23]
.else
v_wmma_f32_16x16x16_fp8_fp8 v[16:19], v32, v36, v[16:19]
v_wmma_f32_16x16x16_fp8_fp8 v[24:27], v32, v36, v[16:19]
.endif
checkpoint 27


; Checkpoint 28: wmma_fp8_bf8
clear_results
v_and_b32 v32, 0x03030303, v1
v_or_b32 v32, 0x30303030, v32
v_xor_b32 v33, 0x08080808, v32
v_and_b32 v36, 0x03030303, v2
v_or_b32 v36, 0x30303030, v36
v_xor_b32 v37, 0x08080808, v36
.if GUITAR_HERO_WAVE_SIZE == 32
v_wmma_f32_16x16x16_fp8_bf8 v[16:23], v[32:33], v[36:37], v[16:23]
v_wmma_f32_16x16x16_fp8_bf8 v[24:31], v[32:33], v[36:37], v[16:23]
.else
v_wmma_f32_16x16x16_fp8_bf8 v[16:19], v32, v36, v[16:19]
v_wmma_f32_16x16x16_fp8_bf8 v[24:27], v32, v36, v[16:19]
.endif
checkpoint 28


; Checkpoint 29: wmma_bf8_fp8
clear_results
v_and_b32 v32, 0x03030303, v1
v_or_b32 v32, 0x30303030, v32
v_xor_b32 v33, 0x08080808, v32
v_and_b32 v36, 0x03030303, v2
v_or_b32 v36, 0x30303030, v36
v_xor_b32 v37, 0x08080808, v36
.if GUITAR_HERO_WAVE_SIZE == 32
v_wmma_f32_16x16x16_bf8_fp8 v[16:23], v[32:33], v[36:37], v[16:23]
v_wmma_f32_16x16x16_bf8_fp8 v[24:31], v[32:33], v[36:37], v[16:23]
.else
v_wmma_f32_16x16x16_bf8_fp8 v[16:19], v32, v36, v[16:19]
v_wmma_f32_16x16x16_bf8_fp8 v[24:27], v32, v36, v[16:19]
.endif
checkpoint 29


; Checkpoint 30: wmma_bf8_bf8
clear_results
v_and_b32 v32, 0x03030303, v1
v_or_b32 v32, 0x30303030, v32
v_xor_b32 v33, 0x08080808, v32
v_and_b32 v36, 0x03030303, v2
v_or_b32 v36, 0x30303030, v36
v_xor_b32 v37, 0x08080808, v36
.if GUITAR_HERO_WAVE_SIZE == 32
v_wmma_f32_16x16x16_bf8_bf8 v[16:23], v[32:33], v[36:37], v[16:23]
v_wmma_f32_16x16x16_bf8_bf8 v[24:31], v[32:33], v[36:37], v[16:23]
.else
v_wmma_f32_16x16x16_bf8_bf8 v[16:19], v32, v36, v[16:19]
v_wmma_f32_16x16x16_bf8_bf8 v[24:27], v32, v36, v[16:19]
.endif
checkpoint 30


; Checkpoint 31: fp_mode_r0_d0
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 0
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 31


; Checkpoint 32: fp_mode_r1_d0
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 5
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 32


; Checkpoint 33: fp_mode_r2_d0
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 10
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 33


; Checkpoint 34: fp_mode_r3_d0
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 15
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 34


; Checkpoint 35: fp_mode_r0_d1
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 80
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 35


; Checkpoint 36: fp_mode_r1_d1
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 85
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 36


; Checkpoint 37: fp_mode_r2_d1
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 90
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 37


; Checkpoint 38: fp_mode_r3_d1
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 95
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 38


; Checkpoint 39: fp_mode_r0_d2
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 160
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 39


; Checkpoint 40: fp_mode_r1_d2
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 165
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 40


; Checkpoint 41: fp_mode_r2_d2
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 170
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 41


; Checkpoint 42: fp_mode_r3_d2
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 175
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 42


; Checkpoint 43: fp_mode_r0_d3
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 43


; Checkpoint 44: fp_mode_r1_d3
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 245
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 44


; Checkpoint 45: fp_mode_r2_d3
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 250
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 45


; Checkpoint 46: fp_mode_r3_d3
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 255
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 46


; Checkpoint 47: fp_mode_mixed_0
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 228
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 47


; Checkpoint 48: fp_mode_mixed_1
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 57
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 48


; Checkpoint 49: fp_mode_mixed_2
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 78
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 49


; Checkpoint 50: fp_mode_mixed_3
clear_results
; Signed denormal input, rounding, and tiny output.
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 147
v_and_b32 v12, 1, v0
v_lshlrev_b32 v12, 31, v12
v_or_b32 v13, 0x00012345, v12
v_or_b32 v14, 0x00800001, v12
v_add_f32 v16, v13, v14
v_mul_f32 v17, v14, 0.5
v_fma_f32 v18, v14, 0.5, v13
v_add_f32 v19, v4, 0x33000000
v_cvt_f16_f32 v20, v19
v_add_f16 v21, 1, 0x0400
v_mul_f16 v22, 0x0401, 0.5
v_mov_b32 v15, 0x38003800
v_pk_mul_f16 v23, 0x04018001, v15
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v10, 0
v_mov_b32 v11, 0x3ca00000
v_add_f64 v[24:25], v[8:9], v[10:11]
v_mul_f64 v[26:27], v[8:9], 0.5
v_cvt_f32_f64 v28, v[24:25]
v_cvt_i32_f32 v29, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 50


; Checkpoint 51: special_values
clear_results
masked_begin 51
; Lane classes include both zeros, infinities, NaNs and denormals.
v_and_b32 v12, 3, v0
v_cmp_eq_u32 \cc, 0, v12
s_wait_alu 0xfffd
v_cndmask_b32 v8, 0x7f800000, 0, \cc
v_cmp_eq_u32 \cc, 2, v12
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, 0x7fc12345, \cc
v_cmp_eq_u32 \cc, 3, v12
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, 1, \cc
v_and_b32 v12, 4, v0
v_lshlrev_b32 v12, 29, v12
v_xor_b32 v8, v8, v12
v_min_f32 v16, v8, v4
v_max_f32 v17, v4, v8
v_add_f32 v18, v8, v4
v_mul_f32 v19, v8, 0
v_mul_legacy_f32 v20, v8, 0
v_add_f32 v21, v8, 0 clamp
v_cmp_class_f32 \cc, v8, 3
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
v_cmp_class_f32 \cc, v8, 0x3fc
wait_wave32_alu 0xfffd
mask_result v23, vcc_lo, vcc_hi
v_cmp_u_f32 \cc, v8, v4
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
v_cmp_o_f32 \cc, v8, v4
wait_wave32_alu 0xfffd
mask_result v25, vcc_lo, vcc_hi
v_cvt_f16_f32 v26, v8
v_cvt_f32_f16 v27, v26
v_cvt_f64_f32 v[28:29], v8
v_rcp_f32 v30, v8
v_sqrt_f32 v31, v8
masked_end 51
checkpoint 51


; Checkpoint 52: compare_f32
clear_results
masked_begin 52
v_mov_b32 v8, 0.5
v_cmp_lt_f32 \cc, v4, v8
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
v_cmp_eq_f32 \cc, v4, v8
wait_wave32_alu 0xfffd
mask_result v17, vcc_lo, vcc_hi
v_cmp_le_f32 \cc, v4, v8
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
v_cmp_gt_f32 \cc, v4, v8
wait_wave32_alu 0xfffd
mask_result v19, vcc_lo, vcc_hi
v_cmp_lg_f32 \cc, v4, v8
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
v_cmp_ge_f32 \cc, v4, v8
wait_wave32_alu 0xfffd
mask_result v21, vcc_lo, vcc_hi
v_cmp_o_f32 \cc, v4, v8
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
v_cmp_u_f32 \cc, v4, v8
wait_wave32_alu 0xfffd
mask_result v23, vcc_lo, vcc_hi
v_cmp_nge_f32 \cc, v4, v8
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
v_cmp_nlg_f32 \cc, v4, v8
wait_wave32_alu 0xfffd
mask_result v25, vcc_lo, vcc_hi
v_cmp_ngt_f32 \cc, v4, v8
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
v_cmp_nle_f32 \cc, v4, v8
wait_wave32_alu 0xfffd
mask_result v27, vcc_lo, vcc_hi
v_cmp_neq_f32 \cc, v4, v8
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
v_cmp_nlt_f32 \cc, v4, v8
wait_wave32_alu 0xfffd
mask_result v29, vcc_lo, vcc_hi
masked_end 52
checkpoint 52


; Checkpoint 53: compare_f16
clear_results
masked_begin 53
v_cvt_f16_f32 v8, v4
v_mov_b32 v9, 0x3800
v_cmp_lt_f16 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
v_cmp_eq_f16 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v17, vcc_lo, vcc_hi
v_cmp_le_f16 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
v_cmp_gt_f16 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v19, vcc_lo, vcc_hi
v_cmp_lg_f16 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
v_cmp_ge_f16 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v21, vcc_lo, vcc_hi
v_cmp_o_f16 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
v_cmp_u_f16 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v23, vcc_lo, vcc_hi
v_cmp_nge_f16 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
v_cmp_nlg_f16 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v25, vcc_lo, vcc_hi
v_cmp_ngt_f16 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
v_cmp_nle_f16 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v27, vcc_lo, vcc_hi
v_cmp_neq_f16 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
v_cmp_nlt_f16 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v29, vcc_lo, vcc_hi
masked_end 53
checkpoint 53


; Checkpoint 54: compare_f64
clear_results
masked_begin 54
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], 0.5
v_cmp_lt_f64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
v_cmp_eq_f64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v17, vcc_lo, vcc_hi
v_cmp_le_f64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
v_cmp_gt_f64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v19, vcc_lo, vcc_hi
v_cmp_lg_f64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
v_cmp_ge_f64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v21, vcc_lo, vcc_hi
v_cmp_o_f64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
v_cmp_u_f64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v23, vcc_lo, vcc_hi
v_cmp_nge_f64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
v_cmp_nlg_f64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v25, vcc_lo, vcc_hi
v_cmp_ngt_f64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
v_cmp_nle_f64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v27, vcc_lo, vcc_hi
v_cmp_neq_f64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
v_cmp_nlt_f64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v29, vcc_lo, vcc_hi
; Use a VGPR class mask to retain the compact VOPC encoding.
v_mov_b32 v12, 0x1ff
v_cmp_class_f64_e32 \cc, v[8:9], v12
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
v_mov_b32 v12, 0x200
v_cmp_class_f64_e32 \cc, v[8:9], v12
wait_wave32_alu 0xfffd
mask_result v31, vcc_lo, vcc_hi
masked_end 54
checkpoint 54


; Checkpoint 55: compare_i16
clear_results
masked_begin 55
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v2
v_mov_b32 v11, v1
v_cmp_lt_i16 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
v_cmp_eq_i16 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v17, vcc_lo, vcc_hi
v_cmp_le_i16 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
v_cmp_gt_i16 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v19, vcc_lo, vcc_hi
v_cmp_ne_i16 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
v_cmp_ge_i16 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v21, vcc_lo, vcc_hi
masked_end 55
checkpoint 55


; Checkpoint 56: compare_u16
clear_results
masked_begin 56
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v2
v_mov_b32 v11, v1
v_cmp_lt_u16 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
v_cmp_eq_u16 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v17, vcc_lo, vcc_hi
v_cmp_le_u16 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
v_cmp_gt_u16 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v19, vcc_lo, vcc_hi
v_cmp_ne_u16 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
v_cmp_ge_u16 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v21, vcc_lo, vcc_hi
masked_end 56
checkpoint 56


; Checkpoint 57: compare_i32
clear_results
masked_begin 57
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v2
v_mov_b32 v11, v1
v_cmp_lt_i32 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
v_cmp_eq_i32 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v17, vcc_lo, vcc_hi
v_cmp_le_i32 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
v_cmp_gt_i32 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v19, vcc_lo, vcc_hi
v_cmp_ne_i32 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
v_cmp_ge_i32 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v21, vcc_lo, vcc_hi
masked_end 57
checkpoint 57


; Checkpoint 58: compare_u32
clear_results
masked_begin 58
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v2
v_mov_b32 v11, v1
v_cmp_lt_u32 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
v_cmp_eq_u32 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v17, vcc_lo, vcc_hi
v_cmp_le_u32 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
v_cmp_gt_u32 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v19, vcc_lo, vcc_hi
v_cmp_ne_u32 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
v_cmp_ge_u32 \cc, v1, v2
wait_wave32_alu 0xfffd
mask_result v21, vcc_lo, vcc_hi
masked_end 58
checkpoint 58


; Checkpoint 59: compare_i64
clear_results
masked_begin 59
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v2
v_mov_b32 v11, v1
v_cmp_lt_i64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
v_cmp_eq_i64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v17, vcc_lo, vcc_hi
v_cmp_le_i64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
v_cmp_gt_i64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v19, vcc_lo, vcc_hi
v_cmp_ne_i64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
v_cmp_ge_i64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v21, vcc_lo, vcc_hi
masked_end 59
checkpoint 59


; Checkpoint 60: compare_u64
clear_results
masked_begin 60
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v2
v_mov_b32 v11, v1
v_cmp_lt_u64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
v_cmp_eq_u64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v17, vcc_lo, vcc_hi
v_cmp_le_u64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
v_cmp_gt_u64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v19, vcc_lo, vcc_hi
v_cmp_ne_u64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
v_cmp_ge_u64 \cc, v[8:9], v[10:11]
wait_wave32_alu 0xfffd
mask_result v21, vcc_lo, vcc_hi
masked_end 60
checkpoint 60


; Checkpoint 61: compare_exec
clear_results
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 s12, exec_lo
.else
s_mov_b64 s[48:49], exec
.endif
v_cmpx_lt_u32 16, v3
mask_result v16, exec_lo, exec_hi
v_add_nc_u32 v17, v1, v2
s_wait_alu 0xfffe
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s12
.else
s_mov_b64 exec, s[48:49]
.endif
v_cmpx_eq_u32 0, v3
mask_result v18, exec_lo, exec_hi
v_mul_f32 v19, v4, v5
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s12
.else
s_mov_b64 exec, s[48:49]
.endif
v_cmpx_eq_u32 64, v3
v_add_nc_u32 v20, v1, v2
save_exec_mask s16, s54
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s12
s_wait_alu 0xfffe
.else
s_mov_b64 exec, s[48:49]
.endif
mask_result v21, s16, s54
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v12, 0x108
v_cmpx_class_f64_e32 v[8:9], v12
save_exec_mask s16, s54
mask_result v22, exec_lo, exec_hi
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s12
s_wait_alu 0xfffe
.else
s_mov_b64 exec, s[48:49]
.endif
mask_result v23, s16, s54
checkpoint 61


; Checkpoint 62: scalar_f32
clear_results
s_mov_b32 s16, 0x3f800001
s_mov_b32 s17, 0xbf000001
s_mov_b32 s18, s10
s_wait_alu 0xfffe
s_add_f32 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v16, s18
s_mov_b32 s18, s10
s_sub_f32 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v17, s18
s_mov_b32 s18, s10
s_mul_f32 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v18, s18
s_mov_b32 s18, s10
s_min_num_f32 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v19, s18
s_mov_b32 s18, s10
s_max_num_f32 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v20, s18
s_mov_b32 s18, s10
s_minimum_f32 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v21, s18
s_mov_b32 s18, s10
s_maximum_f32 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v22, s18
s_mov_b32 s18, s10
s_wait_alu 0xfffe
s_fmac_f32 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v23, s18
checkpoint 62


; Checkpoint 63: scalar_f16
clear_results
s_mov_b32 s16, 0x3c01
s_mov_b32 s17, 0xb801
s_mov_b32 s18, s10
s_wait_alu 0xfffe
s_add_f16 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v16, s18
s_mov_b32 s18, s10
s_sub_f16 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v17, s18
s_mov_b32 s18, s10
s_mul_f16 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v18, s18
s_mov_b32 s18, s10
s_min_num_f16 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v19, s18
s_mov_b32 s18, s10
s_max_num_f16 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v20, s18
s_mov_b32 s18, s10
s_minimum_f16 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v21, s18
s_mov_b32 s18, s10
s_maximum_f16 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v22, s18
s_mov_b32 s18, s10
s_wait_alu 0xfffe
s_fmac_f16 s18, s16, s17
s_wait_alu 0xfffe
v_mov_b32 v23, s18
gh_corner_scalar_f16 4
gh_corner_pseudo_f16 4
gh_corner_raw_scalar 4
checkpoint 63


; Checkpoint 64: pseudo_scalar
clear_results
s_mov_b32 s16, 0x3f800000
s_mov_b32 s17, 0x3c00
s_wait_alu 0xfffe
v_s_rcp_f32 s18, s16
s_wait_alu 0xf1ff
v_mov_b32 v16, s18
v_s_sqrt_f32 s18, s16
s_wait_alu 0xf1ff
v_mov_b32 v17, s18
v_s_rsq_f32 s18, s16
s_wait_alu 0xf1ff
v_mov_b32 v18, s18
v_s_exp_f32 s18, s16
s_wait_alu 0xf1ff
v_mov_b32 v19, s18
v_s_log_f32 s18, s16
s_wait_alu 0xf1ff
v_mov_b32 v20, s18
v_s_rcp_f16 s18, s17
s_wait_alu 0xf1ff
v_mov_b32 v21, s18
v_s_sqrt_f16 s18, s17
s_wait_alu 0xf1ff
v_mov_b32 v22, s18
v_s_rsq_f16 s18, s17
s_wait_alu 0xf1ff
v_mov_b32 v23, s18
v_s_exp_f16 s18, s17
s_wait_alu 0xf1ff
v_mov_b32 v24, s18
v_s_log_f16 s18, s17
s_wait_alu 0xf1ff
v_mov_b32 v25, s18
; Pseudo-scalar VALU must also execute with empty EXEC.
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 s12, exec_lo
set_exec 0, 0x80000000
.else
s_mov_b64 s[48:49], exec
set_exec 0
.endif
v_s_exp_f32 s18, s16
s_wait_alu 0xfffe
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s12
.else
s_mov_b64 exec, s[48:49]
.endif
v_mov_b32 v26, s18
checkpoint 64


; Checkpoint 65: fp16_overflow_0
clear_results
masked_begin 65
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 23, 1), 0
v_mov_b32 v8, 0x7bff
v_mul_f16 v16, v8, 2.0
v_mul_f16 v17, -v8, 2.0
v_cvt_f16_f32 v18, 0x47800000
v_cvt_f16_f32 v19, 0xc7800000
v_mul_f16 v20, 0x7c00, 2.0
v_pk_mul_f16 v21, 0xfbff7bff, 2.0
v_fma_f16 v22, v8, 2.0, v8
v_cvt_pkrtz_f16_f32 v23, 0x47800000, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 23, 1)
s_wait_alu 0xfffe
v_mov_b32 v24, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 23, 1), 0
masked_end 65
checkpoint 65


; Checkpoint 66: fp16_overflow_1
clear_results
masked_begin 66
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 23, 1), 1
v_mov_b32 v8, 0x7bff
v_mul_f16 v16, v8, 2.0
v_mul_f16 v17, -v8, 2.0
v_cvt_f16_f32 v18, 0x47800000
v_cvt_f16_f32 v19, 0xc7800000
v_mul_f16 v20, 0x7c00, 2.0
v_pk_mul_f16 v21, 0xfbff7bff, 2.0
v_fma_f16 v22, v8, 2.0, v8
v_cvt_pkrtz_f16_f32 v23, 0x47800000, v4
s_getreg_b32 s16, hwreg(HW_REG_MODE, 23, 1)
s_wait_alu 0xfffe
v_mov_b32 v24, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 23, 1), 0
masked_end 66
checkpoint 66


; Checkpoint 67: dpp_masks
clear_results
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 s12, exec_lo
set_exec 0x55555555, 0x55555555
.else
s_mov_b64 s[48:49], exec
set_exec 0x55555555, 0xaaaaaaaa
.endif
v_mov_b32 v16, v1 row_shl:1 bound_ctrl:0 fi:0
v_mov_b32 v17, v1 row_shl:1 bound_ctrl:1 fi:0
v_mov_b32 v18, v1 row_shl:1 bound_ctrl:0 fi:1
v_mov_b32 v19, v1 row_shl:1 bound_ctrl:1 fi:1
v_add_f32 v20, v4, v5 row_shr:1 row_mask:0x1 bank_mask:0x5 bound_ctrl:0
v_add_f32 v21, v4, v5 row_shr:1 row_mask:0x2 bank_mask:0xa bound_ctrl:1
v_mov_b32 v22, v1 dpp8:[1,0,3,2,5,4,7,6] fi:0
v_mov_b32 v23, v1 dpp8:[1,0,3,2,5,4,7,6] fi:1
s_wait_alu 0xfffe
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 exec_lo, s12
.else
s_mov_b64 exec, s[48:49]
.endif
checkpoint 67


; Checkpoint 68: fused_literals
clear_results
masked_begin 68
v_fmamk_f32 v16, v4, 0x3f800001, v5
v_fmaak_f32 v17, v4, v5, 0x33000000
v_cvt_f16_f32 v8, v4
v_mov_b32 v9, 0x3800
v_fmamk_f16 v18, v8, 0x3c01, v9
v_fmaak_f16 v19, v8, v9, 0x3800
v_fmac_f16 v20, v8, v9
v_fma_mixhi_f16 v21, v8, v9, v6 op_sel_hi:[1,1,0]
s_mov_b32 s16, 0x40003c00
s_mov_b32 s17, 0x3800bc00
s_wait_alu 0xfffe
v_pk_add_f16 v22, s16, v8
v_pk_mul_f16 v23, v8, s17
v_pk_fma_f16 v24, s16, s17, v8
v_add_f32 v25, s10, v4
v_add_f32 v26, v4, s10
v_fma_f32 v27, s10, v4, v5
v_fma_f32 v28, v4, s10, v5
v_fma_f32 v29, v4, v5, s10
v_mad_i32_i16 v30, v1, v2, v0
v_mad_u32_u16 v31, v1, v2, v0
masked_end 68
checkpoint 68


; Checkpoint 69: wmma_sources
clear_results
; Constant accumulator, then reuse a completed matrix result as A/B.
; A/B and D must be disjoint within each WMMA instruction.
s_mov_b32 s16, 0x3c003800
s_mov_b32 s17, 0xbc003800
s_mov_b32 s18, 0x40003c00
s_mov_b32 s19, 0x3800bc00
s_wait_alu 0xfffe
v_mov_b32 v32, s16
v_mov_b32 v33, s17
v_mov_b32 v34, s18
v_mov_b32 v35, s19
v_mov_b32 v36, s19
v_mov_b32 v37, s18
v_mov_b32 v38, s17
v_mov_b32 v39, s16
.if GUITAR_HERO_WAVE_SIZE == 32
v_wmma_f32_16x16x16_f16 v[16:23], v[32:35], v[36:39], 1.0
v_wmma_f32_16x16x16_f16 v[48:55], v[32:35], v[36:39], v[16:23]
.else
v_wmma_f32_16x16x16_f16 v[16:19], v[32:33], v[36:37], 1.0
v_wmma_f32_16x16x16_f16 v[48:51], v[32:33], v[36:37], v[16:19]
.endif
v_mov_b32 v32, v48
v_mov_b32 v33, v49
v_mov_b32 v34, v50
v_mov_b32 v35, v51
.if GUITAR_HERO_WAVE_SIZE == 32
v_mov_b32 v36, v52
v_mov_b32 v37, v53
v_mov_b32 v38, v54
v_mov_b32 v39, v55
v_wmma_f32_16x16x16_f16 v[24:31], v[32:35], v[36:39], 0
.else
v_wmma_f32_16x16x16_f16 v[24:27], v[32:33], v[36:37], 0
.endif
checkpoint 69


; Checkpoint 70: sparse_f32_f16_k32
clear_results
.irp r,32,33,34,35,36,37,38,39,40,41,42,43
v_and_b32 v\r, 0x00030003, v1
v_xor_b32 v\r, 0x38003c00, v\r
.endr
; Every nibble selects two distinct members of its four-element group.
v_mov_b32 v48, 0xe4b19c72
.if GUITAR_HERO_WAVE_SIZE == 32
v_swmmac_f32_16x16x32_f16 v[16:23], v[32:35], v[36:43], v48 index_key:0
v_swmmac_f32_16x16x32_f16 v[24:31], v[32:35], v[36:43], v48 index_key:1
.else
v_swmmac_f32_16x16x32_f16 v[16:19], v[32:33], v[36:39], v48 index_key:0
v_swmmac_f32_16x16x32_f16 v[24:27], v[32:33], v[36:39], v48 index_key:1
.endif
checkpoint 70


; Checkpoint 71: sparse_f32_bf16_k32
clear_results
.irp r,32,33,34,35,36,37,38,39,40,41,42,43
v_and_b32 v\r, 0x00030003, v1
v_xor_b32 v\r, 0x3f003f80, v\r
.endr
; Every nibble selects two distinct members of its four-element group.
v_mov_b32 v48, 0xe4b19c72
.if GUITAR_HERO_WAVE_SIZE == 32
v_swmmac_f32_16x16x32_bf16 v[16:23], v[32:35], v[36:43], v48 index_key:0
v_swmmac_f32_16x16x32_bf16 v[24:31], v[32:35], v[36:43], v48 index_key:1
.else
v_swmmac_f32_16x16x32_bf16 v[16:19], v[32:33], v[36:39], v48 index_key:0
v_swmmac_f32_16x16x32_bf16 v[24:27], v[32:33], v[36:39], v48 index_key:1
.endif
checkpoint 71


; Checkpoint 72: sparse_f16_f16_k32
clear_results
.irp r,32,33,34,35,36,37,38,39,40,41,42,43
v_and_b32 v\r, 0x00030003, v1
v_xor_b32 v\r, 0x38003c00, v\r
.endr
; Every nibble selects two distinct members of its four-element group.
v_mov_b32 v48, 0xe4b19c72
.if GUITAR_HERO_WAVE_SIZE == 32
v_swmmac_f16_16x16x32_f16 v[16:19], v[32:35], v[36:43], v48 index_key:0
v_swmmac_f16_16x16x32_f16 v[24:27], v[32:35], v[36:43], v48 index_key:1
.else
v_swmmac_f16_16x16x32_f16 v[16:17], v[32:33], v[36:39], v48 index_key:0
v_swmmac_f16_16x16x32_f16 v[24:25], v[32:33], v[36:39], v48 index_key:1
.endif
checkpoint 72


; Checkpoint 73: sparse_bf16_bf16_k32
clear_results
.irp r,32,33,34,35,36,37,38,39,40,41,42,43
v_and_b32 v\r, 0x00030003, v1
v_xor_b32 v\r, 0x3f003f80, v\r
.endr
; Every nibble selects two distinct members of its four-element group.
v_mov_b32 v48, 0xe4b19c72
.if GUITAR_HERO_WAVE_SIZE == 32
v_swmmac_bf16_16x16x32_bf16 v[16:19], v[32:35], v[36:43], v48 index_key:0
v_swmmac_bf16_16x16x32_bf16 v[24:27], v[32:35], v[36:43], v48 index_key:1
.else
v_swmmac_bf16_16x16x32_bf16 v[16:17], v[32:33], v[36:39], v48 index_key:0
v_swmmac_bf16_16x16x32_bf16 v[24:25], v[32:33], v[36:39], v48 index_key:1
.endif
checkpoint 73


; Checkpoint 74: sparse_i32_iu8_k32
clear_results
.irp r,32,33,34,35,36,37,38,39,40,41,42,43
v_and_b32 v\r, 0x00030003, v1
v_xor_b32 v\r, 0x31303130, v\r
.endr
; Every nibble selects two distinct members of its four-element group.
v_mov_b32 v48, 0xe4b19c72
.if GUITAR_HERO_WAVE_SIZE == 32
v_swmmac_i32_16x16x32_iu8 v[16:23], v[32:33], v[36:39], v48 index_key:0
v_swmmac_i32_16x16x32_iu8 v[24:31], v[32:33], v[36:39], v48 index_key:1
.else
v_swmmac_i32_16x16x32_iu8 v[16:19], v32, v[36:37], v48 index_key:0
v_swmmac_i32_16x16x32_iu8 v[24:27], v32, v[36:37], v48 index_key:1
.endif
checkpoint 74


; Checkpoint 75: sparse_i32_iu4_k32
clear_results
.irp r,32,33,34,35,36,37,38,39,40,41,42,43
v_and_b32 v\r, 0x00030003, v1
v_xor_b32 v\r, 0x76543210, v\r
.endr
; Every nibble selects two distinct members of its four-element group.
v_mov_b32 v48, 0xe4b19c72
.if GUITAR_HERO_WAVE_SIZE == 32
v_swmmac_i32_16x16x32_iu4 v[16:23], v32, v[36:37], v48 index_key:0
v_swmmac_i32_16x16x32_iu4 v[24:31], v32, v[36:37], v48 index_key:1
.else
v_swmmac_i32_16x16x32_iu4 v[16:19], v32, v36, v48 index_key:0
v_swmmac_i32_16x16x32_iu4 v[24:27], v32, v36, v48 index_key:1
.endif
checkpoint 75


; Checkpoint 76: sparse_i32_iu4_k64
clear_results
.irp r,32,33,34,35,36,37,38,39,40,41,42,43
v_and_b32 v\r, 0x00030003, v1
v_xor_b32 v\r, 0x31303130, v\r
.endr
; Every nibble selects two distinct members of its four-element group.
v_mov_b32 v48, 0xe4b19c72
.if GUITAR_HERO_WAVE_SIZE == 32
v_swmmac_i32_16x16x64_iu4 v[16:23], v[32:33], v[36:39], v48
v_swmmac_i32_16x16x64_iu4 v[24:31], v[32:33], v[36:39], v48
.else
v_swmmac_i32_16x16x64_iu4 v[16:19], v32, v[36:37], v48
v_swmmac_i32_16x16x64_iu4 v[24:27], v32, v[36:37], v48
.endif
checkpoint 76


; Checkpoint 77: sparse_f32_fp8_fp8_k32
clear_results
.irp r,32,33,34,35,36,37,38,39,40,41,42,43
v_and_b32 v\r, 0x00030003, v1
v_xor_b32 v\r, 0x31303130, v\r
.endr
; Every nibble selects two distinct members of its four-element group.
v_mov_b32 v48, 0xe4b19c72
.if GUITAR_HERO_WAVE_SIZE == 32
v_swmmac_f32_16x16x32_fp8_fp8 v[16:23], v[32:33], v[36:39], v48 index_key:0
v_swmmac_f32_16x16x32_fp8_fp8 v[24:31], v[32:33], v[36:39], v48 index_key:1
.else
v_swmmac_f32_16x16x32_fp8_fp8 v[16:19], v32, v[36:37], v48 index_key:0
v_swmmac_f32_16x16x32_fp8_fp8 v[24:27], v32, v[36:37], v48 index_key:1
.endif
checkpoint 77


; Checkpoint 78: sparse_f32_fp8_bf8_k32
clear_results
.irp r,32,33,34,35,36,37,38,39,40,41,42,43
v_and_b32 v\r, 0x00030003, v1
v_xor_b32 v\r, 0x31303130, v\r
.endr
; Every nibble selects two distinct members of its four-element group.
v_mov_b32 v48, 0xe4b19c72
.if GUITAR_HERO_WAVE_SIZE == 32
v_swmmac_f32_16x16x32_fp8_bf8 v[16:23], v[32:33], v[36:39], v48 index_key:0
v_swmmac_f32_16x16x32_fp8_bf8 v[24:31], v[32:33], v[36:39], v48 index_key:1
.else
v_swmmac_f32_16x16x32_fp8_bf8 v[16:19], v32, v[36:37], v48 index_key:0
v_swmmac_f32_16x16x32_fp8_bf8 v[24:27], v32, v[36:37], v48 index_key:1
.endif
checkpoint 78


; Checkpoint 79: sparse_f32_bf8_fp8_k32
clear_results
.irp r,32,33,34,35,36,37,38,39,40,41,42,43
v_and_b32 v\r, 0x00030003, v1
v_xor_b32 v\r, 0x31303130, v\r
.endr
; Every nibble selects two distinct members of its four-element group.
v_mov_b32 v48, 0xe4b19c72
.if GUITAR_HERO_WAVE_SIZE == 32
v_swmmac_f32_16x16x32_bf8_fp8 v[16:23], v[32:33], v[36:39], v48 index_key:0
v_swmmac_f32_16x16x32_bf8_fp8 v[24:31], v[32:33], v[36:39], v48 index_key:1
.else
v_swmmac_f32_16x16x32_bf8_fp8 v[16:19], v32, v[36:37], v48 index_key:0
v_swmmac_f32_16x16x32_bf8_fp8 v[24:27], v32, v[36:37], v48 index_key:1
.endif
checkpoint 79


; Checkpoint 80: sparse_f32_bf8_bf8_k32
clear_results
.irp r,32,33,34,35,36,37,38,39,40,41,42,43
v_and_b32 v\r, 0x00030003, v1
v_xor_b32 v\r, 0x31303130, v\r
.endr
; Every nibble selects two distinct members of its four-element group.
v_mov_b32 v48, 0xe4b19c72
.if GUITAR_HERO_WAVE_SIZE == 32
v_swmmac_f32_16x16x32_bf8_bf8 v[16:23], v[32:33], v[36:39], v48 index_key:0
v_swmmac_f32_16x16x32_bf8_bf8 v[24:31], v[32:33], v[36:39], v48 index_key:1
.else
v_swmmac_f32_16x16x32_bf8_bf8 v[16:19], v32, v[36:37], v48 index_key:0
v_swmmac_f32_16x16x32_bf8_bf8 v[24:27], v32, v[36:37], v48 index_key:1
.endif
checkpoint 80


; Checkpoint 81: fp64_transcendental
clear_results
masked_begin 81
v_cvt_f64_f32 v[8:9], v5
v_rcp_f64 v[16:17], v[8:9]
v_rsq_f64 v[18:19], v[8:9]
v_sqrt_f64 v[20:21], v[8:9]
v_ceil_f64 v[22:23], v[8:9]
v_trunc_f64 v[24:25], v[8:9]
v_rndne_f64 v[26:27], v[8:9]
v_frexp_mant_f64 v[28:29], v[8:9]
v_frexp_exp_i32_f64 v30, v[8:9]
v_cvt_i32_f64 v31, v[8:9]
masked_end 81
checkpoint 81


; Checkpoint 82: division_cube
clear_results
masked_begin 82
v_div_scale_f32 v16, \cc, v4, v5, v4
wait_wave32_alu 0xfffd
mask_result v17, vcc_lo, vcc_hi
v_div_fmas_f32 v18, v4, v5, v6
v_rcp_f32 v8, v5
v_mul_f32 v8, v8, v4
v_div_fixup_f32 v19, v8, v5, v4
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_div_scale_f64 v[20:21], \cc, v[8:9], v[10:11], v[8:9]
s_wait_alu 0xfffd
v_div_fmas_f64 v[22:23], v[8:9], v[10:11], v[8:9]
v_div_fixup_f64 v[24:25], v[8:9], v[10:11], v[8:9]
v_cubeid_f32 v26, v4, v5, v6
v_cubema_f32 v27, v4, v5, v6
v_cubesc_f32 v28, v4, v5, v6
v_cubetc_f32 v29, v4, v5, v6
v_trig_preop_f64 v[30:31], v[8:9], 0
masked_end 82
checkpoint 82

; Checkpoint 83: integer_e64
clear_results
masked_begin 83
v_add_nc_u32_e64 v16, v1, v2
v_sub_nc_u32_e64 v17, v1, v2
v_mul_lo_u32 v18, v1, v2
v_mul_hi_u32 v19, v1, v2
v_mul_hi_i32 v20, v1, v2
v_mul_i32_i24_e64 v21, v1, v2
v_mul_hi_i32_i24_e64 v22, v1, v2
v_mul_u32_u24_e64 v23, v1, v2
v_mad_i32_i24 v24, v1, v2, v0
v_mad_u32_u24 v25, v1, v2, v0
v_min_i32_e64 v26, v1, v2
v_max_u32_e64 v27, v1, v2
v_min3_i32 v28, v1, v2, v0
v_max3_u32 v29, v1, v2, v0
v_med3_i32 v30, v1, v2, v0
v_add3_u32 v31, v1, v2, v0
masked_end 83
checkpoint 83

; Checkpoint 84: bits_e64
clear_results
masked_begin 84
v_and_b32_e64 v16, v1, v2
v_or_b32_e64 v17, v1, v2
v_xor_b32_e64 v18, v1, v2
v_not_b32_e64 v19, v1
v_bfrev_b32_e64 v20, v1
v_bcnt_u32_b32 v21, v1, 0
v_ffbh_u32 v22, v1
v_ffbl_b32 v23, v1
v_bfe_u32 v24, v1, 3, 11
v_bfe_i32 v25, v1, 5, 17
v_bfi_b32 v26, v1, v2, v0
v_lshlrev_b32_e64 v27, v0, v1
v_lshrrev_b32_e64 v28, v0, v1
v_ashrrev_i32_e64 v29, v0, v1
v_alignbit_b32 v30, v1, v2, v0
v_perm_b32 v31, v1, v2, 0x05040200
masked_end 84
checkpoint 84

; Checkpoint 85: carry_e64
clear_results
masked_begin 85
v_add_co_u32 v16, \cc, v1, v2
s_wait_alu 0xfffd
v_add_co_ci_u32_e64 v17, \cc, v2, v1, \cc
s_wait_alu 0xfffd
v_mov_b32_e64 v18, vcc_lo
v_sub_co_u32 v19, \cc, v1, v2
s_wait_alu 0xfffd
v_sub_co_ci_u32_e64 v20, \cc, v2, v1, \cc
s_wait_alu 0xfffd
v_mov_b32_e64 v21, vcc_lo
.if GUITAR_HERO_WAVE_SIZE == 32
v_mad_u64_u32 v[22:23], s20, v1, v2, v[16:17]
v_mad_i64_i32 v[24:25], s21, v1, v2, v[16:17]
.else
v_mad_u64_u32 v[22:23], s[64:65], v1, v2, v[16:17]
s_mov_b32 s20, s64
v_mad_i64_i32 v[24:25], s[66:67], v1, v2, v[16:17]
s_mov_b32 s21, s66
.endif
v_lshlrev_b64_e64 v[26:27], v0, v[1:2]
v_lshrrev_b64 v[28:29], v0, v[1:2]
v_ashrrev_i64 v[30:31], v0, v[1:2]
masked_end 85
checkpoint 85

; Checkpoint 86: fp32_e64
clear_results
masked_begin 86
v_add_f32_e64 v16, v4, v5
v_sub_f32_e64 v17, v4, v5
v_mul_f32_e64 v18, v4, v5
v_fma_f32 v19, v4, v5, v6
v_fmac_f32_e64 v20, v4, v5
v_min_f32_e64 v21, v4, v5
v_max_f32_e64 v22, v4, v5
v_min3_f32 v23, v4, v5, v6
v_max3_f32 v24, v4, v5, v6
v_med3_f32 v25, v4, v5, v6
v_fma_f32 v26, -v4, |v5|, -|v6| mul:2
v_add_f32_e64 v27, |v4|, -v5 div:2
v_mul_f32_e64 v28, -|v4|, -v5 mul:4
v_fma_f32 v29, v4, v5, v6 clamp
v_mul_legacy_f32_e64 v30, v4, v5
v_fma_legacy_f32 v31, v4, v5, v6
masked_end 86
checkpoint 86

; Checkpoint 87: transcendental_e64
clear_results
masked_begin 87
v_rcp_f32_e64 v16, v5
v_rsq_f32_e64 v17, v5
v_sqrt_f32_e64 v18, v5
v_exp_f32_e64 v19, v4
v_log_f32_e64 v20, v5
v_sin_f32_e64 v21, v6
v_cos_f32_e64 v22, v6
v_fract_f32_e64 v23, v4
v_floor_f32_e64 v24, v4
v_ceil_f32_e64 v25, v4
v_trunc_f32_e64 v26, v4
v_rndne_f32_e64 v27, v4
v_ldexp_f32 v28, v4, 3
v_frexp_exp_i32_f32_e64 v29, v5
v_frexp_mant_f32_e64 v30, v5
v_cvt_i32_f32_e64 v31, v4
masked_end 87
checkpoint 87

; Checkpoint 88: conversion_e64
clear_results
masked_begin 88
v_cvt_f32_i32_e64 v16, v1
v_cvt_f32_u32_e64 v17, v2
v_cvt_u32_f32_e64 v18, v5
v_cvt_f16_f32_e64 v19, v4
v_cvt_f32_f16_e64 v20, v19
v_cvt_pkrtz_f16_f32 v21, v4, v5
v_cvt_pk_i16_i32 v22, v1, v2
v_cvt_pk_u16_u32 v23, v1, v2
v_cvt_f32_ubyte0_e64 v24, v1
v_cvt_f32_ubyte1_e64 v25, v1
v_cvt_f32_ubyte2_e64 v26, v1
v_cvt_f32_ubyte3_e64 v27, v1
v_cvt_pk_fp8_f32 v28, v4, v5
v_cvt_pk_bf8_f32 v29, v4, v5
v_cvt_f32_fp8_e64 v30, v28
v_cvt_f32_bf8_e64 v31, v29
masked_end 88
checkpoint 88

; Checkpoint 89: fp16_e64
clear_results
masked_begin 89
; Nonzero untouched halves make partial-register clobbering observable.
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v22, 0xa5a5a5a5
v_mov_b32 v23, 0xa5a5a5a5
v_cvt_pkrtz_f16_f32 v8, v4, v5
v_cvt_pkrtz_f16_f32 v9, v5, v6
v_add_f16_e64 v16, v8, v9
v_sub_f16_e64 v17, v8, v9
v_mul_f16_e64 v18, v8, v9
v_fma_f16 v19, v8, v9, v8
v_min_f16_e64 v20, v8, v9
v_max_f16_e64 v21, v8, v9
v_add_f16_e64 v22.h, v8.h, v9.l clamp
v_fma_f16 v23, -v8, |v9|, v8 op_sel:[1,0,1,1] div:2
v_rcp_f16_e64 v24, v9
v_sqrt_f16_e64 v25, v9
v_rsq_f16_e64 v26, v9
v_exp_f16_e64 v27, v8
v_log_f16_e64 v28, v9
v_floor_f16_e64 v29, v8
v_ceil_f16_e64 v30, v8
v_rndne_f16_e64 v31, v8
masked_end 89
checkpoint 89

; Checkpoint 90: fp64_e64
clear_results
masked_begin 90
v_cvt_f64_f32_e64 v[8:9], v4
v_cvt_f64_f32_e64 v[10:11], v5
v_add_f64_e64 v[16:17], v[8:9], v[10:11]
v_mul_f64_e64 v[18:19], v[8:9], v[10:11]
v_fma_f64 v[20:21], v[8:9], v[10:11], v[16:17]
v_min_f64_e64 v[22:23], v[8:9], v[10:11]
v_max_f64_e64 v[24:25], v[8:9], v[10:11]
v_ldexp_f64 v[26:27], v[8:9], 3
v_floor_f64_e64 v[28:29], v[8:9]
v_fract_f64_e64 v[30:31], v[8:9]
masked_end 90
checkpoint 90

; Checkpoint 91: compare_f32_e64
clear_results
masked_begin 91
v_mov_b32_e64 v8, 0.5
v_cmp_lt_f32_e64 \cc, v4, v8
s_wait_alu 0xfffd
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_f32_e64 \cc, v4, v8
s_wait_alu 0xfffd
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_f32_e64 \cc, v4, v8
s_wait_alu 0xfffd
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_f32_e64 \cc, v4, v8
s_wait_alu 0xfffd
v_mov_b32_e64 v19, vcc_lo
v_cmp_lg_f32_e64 \cc, v4, v8
s_wait_alu 0xfffd
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_f32_e64 \cc, v4, v8
s_wait_alu 0xfffd
v_mov_b32_e64 v21, vcc_lo
v_cmp_o_f32_e64 \cc, v4, v8
s_wait_alu 0xfffd
v_mov_b32_e64 v22, vcc_lo
v_cmp_u_f32_e64 \cc, v4, v8
s_wait_alu 0xfffd
v_mov_b32_e64 v23, vcc_lo
v_cmp_nge_f32_e64 \cc, v4, v8
s_wait_alu 0xfffd
v_mov_b32_e64 v24, vcc_lo
v_cmp_nlg_f32_e64 \cc, v4, v8
s_wait_alu 0xfffd
v_mov_b32_e64 v25, vcc_lo
v_cmp_ngt_f32_e64 \cc, v4, v8
s_wait_alu 0xfffd
v_mov_b32_e64 v26, vcc_lo
v_cmp_nle_f32_e64 \cc, v4, v8
s_wait_alu 0xfffd
v_mov_b32_e64 v27, vcc_lo
v_cmp_neq_f32_e64 \cc, v4, v8
s_wait_alu 0xfffd
v_mov_b32_e64 v28, vcc_lo
v_cmp_nlt_f32_e64 \cc, v4, v8
s_wait_alu 0xfffd
v_mov_b32_e64 v29, vcc_lo
masked_end 91
checkpoint 91

; Checkpoint 92: compare_f16_e64
clear_results
masked_begin 92
v_cvt_f16_f32_e64 v8, v4
v_mov_b32_e64 v9, 0x3800
v_cmp_lt_f16_e64 \cc, v8, v9
s_wait_alu 0xfffd
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_f16_e64 \cc, v8, v9
s_wait_alu 0xfffd
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_f16_e64 \cc, v8, v9
s_wait_alu 0xfffd
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_f16_e64 \cc, v8, v9
s_wait_alu 0xfffd
v_mov_b32_e64 v19, vcc_lo
v_cmp_lg_f16_e64 \cc, v8, v9
s_wait_alu 0xfffd
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_f16_e64 \cc, v8, v9
s_wait_alu 0xfffd
v_mov_b32_e64 v21, vcc_lo
v_cmp_o_f16_e64 \cc, v8, v9
s_wait_alu 0xfffd
v_mov_b32_e64 v22, vcc_lo
v_cmp_u_f16_e64 \cc, v8, v9
s_wait_alu 0xfffd
v_mov_b32_e64 v23, vcc_lo
v_cmp_nge_f16_e64 \cc, v8, v9
s_wait_alu 0xfffd
v_mov_b32_e64 v24, vcc_lo
v_cmp_nlg_f16_e64 \cc, v8, v9
s_wait_alu 0xfffd
v_mov_b32_e64 v25, vcc_lo
v_cmp_ngt_f16_e64 \cc, v8, v9
s_wait_alu 0xfffd
v_mov_b32_e64 v26, vcc_lo
v_cmp_nle_f16_e64 \cc, v8, v9
s_wait_alu 0xfffd
v_mov_b32_e64 v27, vcc_lo
v_cmp_neq_f16_e64 \cc, v8, v9
s_wait_alu 0xfffd
v_mov_b32_e64 v28, vcc_lo
v_cmp_nlt_f16_e64 \cc, v8, v9
s_wait_alu 0xfffd
v_mov_b32_e64 v29, vcc_lo
masked_end 92
checkpoint 92

; Checkpoint 93: compare_f64_e64
clear_results
masked_begin 93
v_cvt_f64_f32_e64 v[8:9], v4
v_cvt_f64_f32_e64 v[10:11], 0.5
v_cmp_lt_f64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_f64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_f64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_f64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v19, vcc_lo
v_cmp_lg_f64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_f64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v21, vcc_lo
v_cmp_o_f64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v22, vcc_lo
v_cmp_u_f64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v23, vcc_lo
v_cmp_nge_f64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v24, vcc_lo
v_cmp_nlg_f64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v25, vcc_lo
v_cmp_ngt_f64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v26, vcc_lo
v_cmp_nle_f64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v27, vcc_lo
v_cmp_neq_f64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v28, vcc_lo
v_cmp_nlt_f64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v29, vcc_lo
v_cmp_class_f64_e64 \cc, v[8:9], 0x1ff
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
v_cmp_class_f64_e64 \cc, v[8:9], 0x200
wait_wave32_alu 0xfffd
mask_result v31, vcc_lo, vcc_hi
masked_end 93
checkpoint 93

; Checkpoint 94: compare_i16_e64
clear_results
masked_begin 94
v_mov_b32_e64 v8, v1
v_mov_b32_e64 v9, v2
v_mov_b32_e64 v10, v2
v_mov_b32_e64 v11, v1
v_cmp_lt_i16_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_i16_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_i16_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_i16_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v19, vcc_lo
v_cmp_ne_i16_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_i16_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v21, vcc_lo
masked_end 94
checkpoint 94

; Checkpoint 95: compare_u16_e64
clear_results
masked_begin 95
v_mov_b32_e64 v8, v1
v_mov_b32_e64 v9, v2
v_mov_b32_e64 v10, v2
v_mov_b32_e64 v11, v1
v_cmp_lt_u16_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_u16_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_u16_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_u16_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v19, vcc_lo
v_cmp_ne_u16_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_u16_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v21, vcc_lo
masked_end 95
checkpoint 95

; Checkpoint 96: compare_i32_e64
clear_results
masked_begin 96
v_mov_b32_e64 v8, v1
v_mov_b32_e64 v9, v2
v_mov_b32_e64 v10, v2
v_mov_b32_e64 v11, v1
v_cmp_lt_i32_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_i32_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_i32_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_i32_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v19, vcc_lo
v_cmp_ne_i32_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_i32_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v21, vcc_lo
masked_end 96
checkpoint 96

; Checkpoint 97: compare_u32_e64
clear_results
masked_begin 97
v_mov_b32_e64 v8, v1
v_mov_b32_e64 v9, v2
v_mov_b32_e64 v10, v2
v_mov_b32_e64 v11, v1
v_cmp_lt_u32_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_u32_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_u32_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_u32_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v19, vcc_lo
v_cmp_ne_u32_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_u32_e64 \cc, v1, v2
s_wait_alu 0xfffd
v_mov_b32_e64 v21, vcc_lo
masked_end 97
checkpoint 97

; Checkpoint 98: compare_i64_e64
clear_results
masked_begin 98
v_mov_b32_e64 v8, v1
v_mov_b32_e64 v9, v2
v_mov_b32_e64 v10, v2
v_mov_b32_e64 v11, v1
v_cmp_lt_i64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_i64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_i64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_i64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v19, vcc_lo
v_cmp_ne_i64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_i64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v21, vcc_lo
masked_end 98
checkpoint 98

; Checkpoint 99: compare_u64_e64
clear_results
masked_begin 99
v_mov_b32_e64 v8, v1
v_mov_b32_e64 v9, v2
v_mov_b32_e64 v10, v2
v_mov_b32_e64 v11, v1
v_cmp_lt_u64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_u64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_u64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_u64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v19, vcc_lo
v_cmp_ne_u64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_u64_e64 \cc, v[8:9], v[10:11]
s_wait_alu 0xfffd
v_mov_b32_e64 v21, vcc_lo
masked_end 99
checkpoint 99


; Each sweep operation owns a pair: result bits followed by carry/compare bits.
; Inputs include lane variation; inactive lanes and untouched halves retain a sentinel.
; Checkpoint 100: vop1_plain_00
clear_results
masked_begin 100
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_bfrev_b32 v16, v8
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_ceil_f16 v18.l, v8.l
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_ceil_f32 v20, v8
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_cls_i32 v22, v8
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_clz_i32_u32 v24, v8
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
v_cos_f16 v26.l, v8.l
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_cos_f32 v28, v8
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_ctz_i32_b32 v30, v8
masked_end 100
checkpoint 100

; Checkpoint 101: vop1_plain_01
clear_results
masked_begin 101
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cvt_f32_fp8 v16, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_cvt_f32_bf8 v18, v10
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_cvt_f16_f32 v20.l, v8
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cvt_f16_i16 v22.l, v8.l
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
v_cvt_f16_u16 v24.l, v8.l
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
v_cvt_f32_f16 v26, v8.l
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_f32_i32 v28, v8
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_f32_u32 v30, v8
masked_end 101
checkpoint 101

; Checkpoint 102: vop1_plain_02
clear_results
masked_begin 102
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
v_cvt_f32_ubyte0 v16, v8
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cvt_f32_ubyte1 v18, v8
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_cvt_f32_ubyte2 v20, v8
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cvt_f32_ubyte3 v22, v8
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
v_cvt_floor_i32_f32 v24, v8
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cvt_flr_i32_f32 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_i16_f16 v28.l, v8.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_i32_f32 v30, v8
masked_end 102
checkpoint 102

; Checkpoint 103: vop1_plain_03
clear_results
masked_begin 103
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cvt_i32_i16 v16, v8.l
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cvt_nearest_i32_f32 v18, v8
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cvt_norm_i16_f16 v20.l, v8.l
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
v_cvt_norm_u16_f16 v22.l, v8.l
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
v_cvt_off_f32_i4 v24, v8
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cvt_rpi_i32_f32 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_u16_f16 v28.l, v8.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_u32_f32 v30, v8
masked_end 103
checkpoint 103

; Checkpoint 104: vop1_plain_04
clear_results
masked_begin 104
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cvt_u32_u16 v16, v8.l
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_exp_f16 v18.l, v8.l
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_exp_f32 v20, v8
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_ffbh_i32 v22, v8
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_ffbh_u32 v24, v8
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_ffbl_b32 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_floor_f16 v28.l, v8.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_floor_f32 v30, v8
masked_end 104
checkpoint 104

; Checkpoint 105: vop1_plain_05
clear_results
masked_begin 105
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_fract_f16 v16.l, v8.l
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_fract_f32 v18, v8
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_frexp_exp_i16_f16 v20.l, v8.l
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_frexp_exp_i32_f32 v22, v8
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_frexp_mant_f16 v24.l, v8.l
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_frexp_mant_f32 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_log_f16 v28.l, v8.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_log_f32 v30, v8
masked_end 105
checkpoint 105

; Checkpoint 106: vop1_plain_06
clear_results
masked_begin 106
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v16, v8
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_movreld_b32 v18, v8
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_movrels_b32 v20, v8
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_movrelsd_2_b32 v22, v8
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_movrelsd_b32 v24, v8
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_not_b16 v26.l, v8.l
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_not_b32 v28, v8
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
v_rcp_f16 v30.l, v8.l
masked_end 106
checkpoint 106

; Checkpoint 107: vop1_plain_07
clear_results
masked_begin 107
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
v_rcp_f32 v16, v8
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_rcp_iflag_f32 v18, v8
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_rndne_f16 v20.l, v8.l
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_rndne_f32 v22, v8
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_rsq_f16 v24.l, v8.l
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_rsq_f32 v26, v8
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_sat_pk_u8_i16 v28.l, v8
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
v_sin_f16 v30.l, v8.l
masked_end 107
checkpoint 107

; Checkpoint 108: vop1_plain_08
clear_results
masked_begin 108
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
v_sin_f32 v16, v8
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_sqrt_f16 v18.l, v8.l
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_sqrt_f32 v20, v8
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
v_trunc_f16 v22.l, v8.l
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
v_trunc_f32 v24, v8
masked_end 108
checkpoint 108

; Checkpoint 109: vop1_dpp16_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_bfrev_b32 v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_ceil_f16 v18.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_ceil_f32 v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cls_i32 v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_clz_i32_u32 v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cos_f16 v26.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cos_f32 v28, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_ctz_i32_b32 v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 109

; Checkpoint 110: vop1_dpp16_01
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cvt_f32_fp8 v16, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cvt_f32_bf8 v18, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cvt_f16_f32 v20.l, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cvt_f16_i16 v22.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cvt_f16_u16 v24.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cvt_f32_f16 v26, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cvt_f32_i32 v28, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cvt_f32_u32 v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 110

; Checkpoint 111: vop1_dpp16_02
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cvt_f32_ubyte0 v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cvt_f32_ubyte1 v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cvt_f32_ubyte2 v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cvt_f32_ubyte3 v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cvt_floor_i32_f32 v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cvt_flr_i32_f32 v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cvt_i16_f16 v28.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cvt_i32_f32 v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 111

; Checkpoint 112: vop1_dpp16_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cvt_i32_i16 v16, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cvt_nearest_i32_f32 v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cvt_norm_i16_f16 v20.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cvt_norm_u16_f16 v22.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cvt_off_f32_i4 v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cvt_rpi_i32_f32 v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cvt_u16_f16 v28.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cvt_u32_f32 v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 112

; Checkpoint 113: vop1_dpp16_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cvt_u32_u16 v16, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_exp_f16 v18.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_exp_f32 v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_ffbh_i32 v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_ffbh_u32 v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_ffbl_b32 v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_floor_f16 v28.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_floor_f32 v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 113

; Checkpoint 114: vop1_dpp16_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_fract_f16 v16.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_fract_f32 v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_frexp_exp_i16_f16 v20.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_frexp_exp_i32_f32 v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_frexp_mant_f16 v24.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_frexp_mant_f32 v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_log_f16 v28.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_log_f32 v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 114

; Checkpoint 115: vop1_dpp16_06
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_mov_b32 v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_movreld_b32 v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_movrels_b32 v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_movrelsd_2_b32 v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_movrelsd_b32 v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_not_b16 v26.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_not_b32 v28, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_rcp_f16 v30.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 115

; Checkpoint 116: vop1_dpp16_07
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_rcp_f32 v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_rcp_iflag_f32 v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_rndne_f16 v20.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_rndne_f32 v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_rsq_f16 v24.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_rsq_f32 v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_sat_pk_u8_i16 v28.l, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_sin_f16 v30.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 116

; Checkpoint 117: vop1_dpp16_08
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_sin_f32 v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_sqrt_f16 v18.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_sqrt_f32 v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_trunc_f16 v22.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_trunc_f32 v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 117

; Checkpoint 118: vop1_dpp8_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_bfrev_b32 v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ceil_f16 v18.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ceil_f32 v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cls_i32 v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_clz_i32_u32 v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cos_f16 v26.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cos_f32 v28, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ctz_i32_b32 v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 118

; Checkpoint 119: vop1_dpp8_01
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_fp8 v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_bf8 v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f16_f32 v20.h, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f16_i16 v22.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f16_u16 v24.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_f16 v26, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_i32 v28, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_u32 v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 119

; Checkpoint 120: vop1_dpp8_02
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_ubyte0 v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_ubyte1 v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_ubyte2 v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_ubyte3 v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_floor_i32_f32 v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_flr_i32_f32 v26, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_i16_f16 v28.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_i32_f32 v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 120

; Checkpoint 121: vop1_dpp8_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_i32_i16 v16, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_nearest_i32_f32 v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_norm_i16_f16 v20.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_norm_u16_f16 v22.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_off_f32_i4 v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_rpi_i32_f32 v26, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_u16_f16 v28.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_u32_f32 v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 121

; Checkpoint 122: vop1_dpp8_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_u32_u16 v16, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_exp_f16 v18.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_exp_f32 v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ffbh_i32 v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ffbh_u32 v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ffbl_b32 v26, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_floor_f16 v28.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_floor_f32 v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 122

; Checkpoint 123: vop1_dpp8_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_fract_f16 v16.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_fract_f32 v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_frexp_exp_i16_f16 v20.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_frexp_exp_i32_f32 v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_frexp_mant_f16 v24.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_frexp_mant_f32 v26, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_log_f16 v28.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_log_f32 v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 123

; Checkpoint 124: vop1_dpp8_06
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mov_b32 v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_movreld_b32 v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_movrels_b32 v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_movrelsd_2_b32 v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_movrelsd_b32 v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_not_b16 v26.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_not_b32 v28, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_rcp_f16 v30.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 124

; Checkpoint 125: vop1_dpp8_07
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_rcp_f32 v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_rcp_iflag_f32 v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_rndne_f16 v20.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_rndne_f32 v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_rsq_f16 v24.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_rsq_f32 v26, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sat_pk_u8_i16 v28.h, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sin_f16 v30.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 125

; Checkpoint 126: vop1_dpp8_08
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sin_f32 v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sqrt_f16 v18.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sqrt_f32 v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_trunc_f16 v22.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_trunc_f32 v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 126

; Checkpoint 127: vop2_plain_00
clear_results
masked_begin 127
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_wait_alu 0xfffe
v_add_co_ci_u32 v16, \cc, v8, v9, \cc
wait_wave32_alu 0xfffd
mask_result v17, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_add_f16 v18.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_add_f32 v20, v8, v9
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_add_nc_u32 v22, v8, v9
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_and_b32 v24, v8, v9
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_ashrrev_i32 v26, v8, v9
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_wait_alu 0xfffe
v_cndmask_b32 v28, v8, v9, \cc
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_pk_rtz_f16_f32 v30, v8, v9
masked_end 127
checkpoint 127

; Checkpoint 128: vop2_plain_01
clear_results
masked_begin 128
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_fmac_f16 v16.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_fmac_f32 v18, v8, v9
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_and_b32 v9, 7, v0
v_ldexp_f16 v20.l, v8.l, v9.l
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_lshlrev_b32 v22, v8, v9
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_lshrrev_b32 v24, v8, v9
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
v_max_f16 v26.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_max_f32 v28, v8, v9
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_max_i32 v30, v8, v9
masked_end 128
checkpoint 128

; Checkpoint 129: vop2_plain_02
clear_results
masked_begin 129
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_max_u32 v16, v8, v9
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_min_f16 v18.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_min_f32 v20, v8, v9
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_min_i32 v22, v8, v9
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_min_u32 v24, v8, v9
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_mul_legacy_f32 v26, v8, v9
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_mul_f16 v28.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_mul_f32 v30, v8, v9
masked_end 129
checkpoint 129

; Checkpoint 130: vop2_plain_03
clear_results
masked_begin 130
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_mul_hi_i32_i24 v16, v8, v9
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_mul_hi_u32_u24 v18, v8, v9
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_mul_i32_i24 v20, v8, v9
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_mul_u32_u24 v22, v8, v9
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_or_b32 v24, v8, v9
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_wait_alu 0xfffe
v_sub_co_ci_u32 v26, \cc, v8, v9, \cc
wait_wave32_alu 0xfffd
mask_result v27, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_sub_f16 v28.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_sub_f32 v30, v8, v9
masked_end 130
checkpoint 130

; Checkpoint 131: vop2_plain_04
clear_results
masked_begin 131
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_sub_nc_u32 v16, v8, v9
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_wait_alu 0xfffe
v_subrev_co_ci_u32 v18, \cc, v8, v9, \cc
wait_wave32_alu 0xfffd
mask_result v19, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_subrev_f16 v20.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_subrev_f32 v22, v8, v9
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_subrev_nc_u32 v24, v8, v9
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_xnor_b32 v26, v8, v9
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_xor_b32 v28, v8, v9
masked_end 131
checkpoint 131

; Checkpoint 132: vop2_dpp16_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
s_wait_alu 0xfffe
v_add_co_ci_u32 v16, \cc, v8, v9, \cc row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v17, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_add_f16 v18.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_add_f32 v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_add_nc_u32 v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_and_b32 v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_ashrrev_i32 v26, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
s_wait_alu 0xfffe
v_cndmask_b32 v28, v8, v9, \cc row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cvt_pk_rtz_f16_f32 v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 132

; Checkpoint 133: vop2_dpp16_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_fmac_f16 v16.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_fmac_f32 v18, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_and_b32 v9, 7, v0
set_exec -1
v_ldexp_f16 v20.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_lshlrev_b32 v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_lshrrev_b32 v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_max_f16 v26.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_max_f32 v28, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_max_i32 v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 133

; Checkpoint 134: vop2_dpp16_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_max_u32 v16, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_min_f16 v18.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_min_f32 v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_min_i32 v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_min_u32 v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_mul_legacy_f32 v26, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_mul_f16 v28.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_mul_f32 v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 134

; Checkpoint 135: vop2_dpp16_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_mul_hi_i32_i24 v16, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_mul_hi_u32_u24 v18, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_mul_i32_i24 v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_mul_u32_u24 v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_or_b32 v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
s_wait_alu 0xfffe
v_sub_co_ci_u32 v26, \cc, v8, v9, \cc row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v27, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_sub_f16 v28.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_sub_f32 v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 135

; Checkpoint 136: vop2_dpp16_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_sub_nc_u32 v16, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
s_wait_alu 0xfffe
v_subrev_co_ci_u32 v18, \cc, v8, v9, \cc row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v19, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_subrev_f16 v20.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_subrev_f32 v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_subrev_nc_u32 v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_xnor_b32 v26, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_xor_b32 v28, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 136

; Checkpoint 137: vop2_dpp8_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
s_wait_alu 0xfffe
v_add_co_ci_u32 v16, \cc, v8, v9, \cc dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v17, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_add_f16 v18.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_add_f32 v20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_add_nc_u32 v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_and_b32 v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ashrrev_i32 v26, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
s_wait_alu 0xfffe
v_cndmask_b32 v28, v8, v9, \cc dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_pk_rtz_f16_f32 v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 137

; Checkpoint 138: vop2_dpp8_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_fmac_f16 v16.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_fmac_f32 v18, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_and_b32 v9, 7, v0
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ldexp_f16 v20.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_lshlrev_b32 v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_lshrrev_b32 v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max_f16 v26.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max_f32 v28, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max_i32 v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 138

; Checkpoint 139: vop2_dpp8_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max_u32 v16, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min_f16 v18.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min_f32 v20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min_i32 v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min_u32 v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_legacy_f32 v26, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_f16 v28.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_f32 v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 139

; Checkpoint 140: vop2_dpp8_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_hi_i32_i24 v16, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_hi_u32_u24 v18, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_i32_i24 v20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_u32_u24 v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_or_b32 v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
s_wait_alu 0xfffe
v_sub_co_ci_u32 v26, \cc, v8, v9, \cc dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v27, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sub_f16 v28.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sub_f32 v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 140

; Checkpoint 141: vop2_dpp8_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sub_nc_u32 v16, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
s_wait_alu 0xfffe
v_subrev_co_ci_u32 v18, \cc, v8, v9, \cc dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v19, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_subrev_f16 v20.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_subrev_f32 v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_subrev_nc_u32 v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_xnor_b32 v26, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_xor_b32 v28, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 141

; Checkpoint 142: vop3_plain_00
clear_results
masked_begin 142
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_add3_u32_e64 v16, v8, v9, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_add_co_u32_e64 v18, s20, v8, v9
.else
v_add_co_u32_e64 v18, s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v19, s20, s65
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_add_lshl_u32_e64 v20, v8, v9, v10
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_add_nc_i16_e64 v22.l, v8.l, v9.l
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_add_nc_i32_e64 v24, v8, v9
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_add_nc_u16_e64 v26.l, v8.l, v9.l
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_alignbit_b32_e64 v28, v8, v9, v10.l
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_alignbyte_b32_e64 v30, v8, v9, v10.l
masked_end 142
gh_corner_vector16 4
gh_corner_b16 4
checkpoint 142

; Checkpoint 143: vop3_plain_01
clear_results
masked_begin 143
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_and_b16_e64 v16.l, v8.l, v9.l
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_and_or_b32_e64 v18, v8, v9, v10
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_ashrrev_i16_e64 v20.l, v8.l, v9.l
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_bcnt_u32_b32_e64 v22, v8, v9
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_bfe_i32_e64 v24, v8, v9, v10
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_bfe_u32_e64 v26, v8, v9, v10
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_bfi_b32_e64 v28, v8, v9, v10
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_bfm_b32_e64 v30, v8, v9
masked_end 143
checkpoint 143

; Checkpoint 144: vop3_plain_02
clear_results
masked_begin 144
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cndmask_b16_e64 v16.l, v8.l, v9.l, s23
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_cndmask_b16_e64 v16.l, v8.l, v9.l, s[70:71]
.endif
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cubeid_f32_e64 v18, v8, v9, v10
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_cubema_f32_e64 v20, v8, v9, v10
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cubesc_f32_e64 v22, v8, v9, v10
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
v_cubetc_f32_e64 v24, v8, v9, v10
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_cvt_pk_bf8_f32_e64 v26.l, v8, v9
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_pk_fp8_f32_e64 v28.l, v8, v9
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_pk_i16_f32_e64 v30, v8, v9
masked_end 144
checkpoint 144

; Checkpoint 145: vop3_plain_03
clear_results
masked_begin 145
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cvt_pk_i16_i32_e64 v16, v8, v9
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_cvt_pk_norm_i16_f16_e64 v18, v8.l, v9.l
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_cvt_pk_norm_i16_f32_e64 v20, v8, v9
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
v_cvt_pk_norm_u16_f16_e64 v22, v8.l, v9.l
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
v_cvt_pk_norm_u16_f32_e64 v24, v8, v9
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cvt_pk_u16_f32_e64 v26, v8, v9
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_pk_u16_u32_e64 v28, v8, v9
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_pk_u8_f32_e64 v30, v8, v9, v10
masked_end 145
checkpoint 145

; Checkpoint 146: vop3_plain_04
clear_results
masked_begin 146
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, v1
v_cvt_sr_bf8_f32_e64 v16, v8, v9
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, v1
v_cvt_sr_fp8_f32_e64 v18, v8, v9
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_div_fixup_f16_e64 v20.l, v8.l, v9.l, v10.l
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_dot2_bf16_bf16_e64 v22.l, v8, v9, v10.l
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_dot2_f16_f16_e64 v24.l, v8, v9, v10.l
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_dot2_f32_bf16_e64 v26, v8, v9, v10
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_fma_f16_e64 v28.l, v8.l, v9.l, v10.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_fma_f32_e64 v30, v8, v9, v10
masked_end 146
gh_corner_bf16 4
checkpoint 146

; Checkpoint 147: vop3_plain_05
clear_results
masked_begin 147
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
v_and_b32 v9, 7, v0
v_ldexp_f32_e64 v16, v8, v9
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_lerp_u8_e64 v18, v8, v9, v10
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_lshl_add_u32_e64 v20, v8, v9, v10
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_lshl_or_b32_e64 v22, v8, v9, v10
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_lshlrev_b16_e64 v24.l, v8.l, v9.l
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_lshrrev_b16_e64 v26.l, v8.l, v9.l
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_mad_i16_e64 v28.l, v8.l, v9.l, v10.l
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_mad_i32_i16_e64 v30, v8.l, v9.l, v10
masked_end 147
checkpoint 147

; Checkpoint 148: vop3_plain_06
clear_results
masked_begin 148
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_mad_i32_i24_e64 v16, v8, v9, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_mad_u16_e64 v18.l, v8.l, v9.l, v10.l
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_mad_u32_u16_e64 v20, v8.l, v9.l, v10
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_mad_u32_u24_e64 v22, v8, v9, v10
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_max3_f16_e64 v24.l, v8.l, v9.l, v10.l
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_max3_f32_e64 v26, v8, v9, v10
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_max3_i16_e64 v28.l, v8.l, v9.l, v10.l
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_max3_i32_e64 v30, v8, v9, v10
masked_end 148
checkpoint 148

; Checkpoint 149: vop3_plain_07
clear_results
masked_begin 149
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_max3_u16_e64 v16.l, v8.l, v9.l, v10.l
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_max3_u32_e64 v18, v8, v9, v10
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_max_i16_e64 v20.l, v8.l, v9.l
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_max_u16_e64 v22.l, v8.l, v9.l
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_maxmin_f16_e64 v24.l, v8.l, v9.l, v10.l
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_maxmin_f32_e64 v26, v8, v9, v10
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_maxmin_i32_e64 v28, v8, v9, v10
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_maxmin_u32_e64 v30, v8, v9, v10
masked_end 149
checkpoint 149

; Checkpoint 150: vop3_plain_08
clear_results
masked_begin 150
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_maximum_f16 v16.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_maximum_f32 v18, v8, v9
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_maximum3_f16 v20.l, v8.l, v9.l, v10.l
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_maximum3_f32 v22, v8, v9, v10
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_maximumminimum_f16 v24.l, v8.l, v9.l, v10.l
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_maximumminimum_f32 v26, v8, v9, v10
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_mbcnt_hi_u32_b32_e64 v28, v8, v9
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_mbcnt_lo_u32_b32_e64 v30, v8, v9
masked_end 150
checkpoint 150

; Checkpoint 151: vop3_plain_09
clear_results
masked_begin 151
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_med3_f16_e64 v16.l, v8.l, v9.l, v10.l
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_med3_f32_e64 v18, v8, v9, v10
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_med3_i16_e64 v20.l, v8.l, v9.l, v10.l
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_med3_i32_e64 v22, v8, v9, v10
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_med3_u16_e64 v24.l, v8.l, v9.l, v10.l
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_med3_u32_e64 v26, v8, v9, v10
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_min3_f16_e64 v28.l, v8.l, v9.l, v10.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_min3_f32_e64 v30, v8, v9, v10
masked_end 151
checkpoint 151

; Checkpoint 152: vop3_plain_10
clear_results
masked_begin 152
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_min3_i16_e64 v16.l, v8.l, v9.l, v10.l
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_min3_i32_e64 v18, v8, v9, v10
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_min3_u16_e64 v20.l, v8.l, v9.l, v10.l
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_min3_u32_e64 v22, v8, v9, v10
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_min_i16_e64 v24.l, v8.l, v9.l
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_min_u16_e64 v26.l, v8.l, v9.l
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_minmax_f16_e64 v28.l, v8.l, v9.l, v10.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_minmax_f32_e64 v30, v8, v9, v10
masked_end 152
checkpoint 152

; Checkpoint 153: vop3_plain_11
clear_results
masked_begin 153
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_minmax_i32_e64 v16, v8, v9, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_minmax_u32_e64 v18, v8, v9, v10
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_minimum_f16 v20.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_minimum_f32 v22, v8, v9
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_minimum3_f16 v24.l, v8.l, v9.l, v10.l
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_minimum3_f32 v26, v8, v9, v10
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_minimummaximum_f16 v28.l, v8.l, v9.l, v10.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_minimummaximum_f32 v30, v8, v9, v10
masked_end 153
checkpoint 153

; Checkpoint 154: vop3_plain_12
clear_results
masked_begin 154
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_msad_u8_e64 v16, v8, v9, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_mul_lo_u16_e64 v18.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_mullit_f32_e64 v20, v8, v9, v10
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_or3_b32_e64 v22, v8, v9, v10
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_or_b16_e64 v24.l, v8.l, v9.l
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
v_pack_b32_f16_e64 v26, v8.l, v9.l
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_perm_b32_e64 v28, v8, v9, v10
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_sad_hi_u8_e64 v30, v8, v9, v10
masked_end 154
checkpoint 154

; Checkpoint 155: vop3_plain_13
clear_results
masked_begin 155
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_sad_u16_e64 v16, v8, v9, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_sad_u32_e64 v18, v8, v9, v10
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_sad_u8_e64 v20, v8, v9, v10
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_sub_co_u32_e64 v22, s20, v8, v9
.else
v_sub_co_u32_e64 v22, s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v23, s20, s65
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_sub_nc_i16_e64 v24.l, v8.l, v9.l
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_sub_nc_i32_e64 v26, v8, v9
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_sub_nc_u16_e64 v28.l, v8.l, v9.l
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_subrev_co_u32_e64 v30, s20, v8, v9
.else
v_subrev_co_u32_e64 v30, s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v31, s20, s65
masked_end 155
checkpoint 155

; Checkpoint 156: vop3_plain_14
clear_results
masked_begin 156
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_xad_u32_e64 v16, v8, v9, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_xor3_b32_e64 v18, v8, v9, v10
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_xor_b16_e64 v20.l, v8.l, v9.l
masked_end 156
checkpoint 156

; Checkpoint 157: vop3_dpp16_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_add3_u32_e64_dpp v16, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_add_co_u32_e64_dpp v18, s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_add_co_u32_e64_dpp v18, s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v19, s20, s65
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_add_lshl_u32_e64_dpp v20, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_add_nc_i16_e64_dpp v22.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_add_nc_i32_e64_dpp v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_add_nc_u16_e64_dpp v26.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_alignbit_b32_e64_dpp v28, v8, v9, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_alignbyte_b32_e64_dpp v30, v8, v9, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 157

; Checkpoint 158: vop3_dpp16_01
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_and_b16_e64_dpp v16.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_and_or_b32_e64_dpp v18, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_ashrrev_i16_e64_dpp v20.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_bcnt_u32_b32_e64_dpp v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_bfe_i32_e64_dpp v24, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_bfe_u32_e64_dpp v26, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_bfi_b32_e64_dpp v28, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_bfm_b32_e64_dpp v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 158

; Checkpoint 159: vop3_dpp16_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cndmask_b16_e64_dpp v16.l, v8.l, v9.l, s23 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_cndmask_b16_e64_dpp v16.l, v8.l, v9.l, s[70:71] row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.endif
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cubeid_f32_e64_dpp v18, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cubema_f32_e64_dpp v20, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cubesc_f32_e64_dpp v22, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cubetc_f32_e64_dpp v24, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cvt_pk_bf8_f32_e64_dpp v26.l, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cvt_pk_fp8_f32_e64_dpp v28.l, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cvt_pk_i16_f32_e64_dpp v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 159

; Checkpoint 160: vop3_dpp16_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cvt_pk_i16_i32_e64_dpp v16, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cvt_pk_norm_i16_f16_e64_dpp v18, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cvt_pk_norm_i16_f32_e64_dpp v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cvt_pk_norm_u16_f16_e64_dpp v22, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cvt_pk_norm_u16_f32_e64_dpp v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cvt_pk_u16_f32_e64_dpp v26, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cvt_pk_u16_u32_e64_dpp v28, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cvt_pk_u8_f32_e64_dpp v30, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 160

; Checkpoint 161: vop3_dpp16_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, v1
set_exec -1
v_cvt_sr_bf8_f32_e64_dpp v16, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, v1
set_exec -1
v_cvt_sr_fp8_f32_e64_dpp v18, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_div_fixup_f16_e64_dpp v20.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_dot2_bf16_bf16_e64_dpp v22.l, v8, v9, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_dot2_f16_f16_e64_dpp v24.l, v8, v9, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_fma_f16_e64_dpp v26.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_fma_f32_e64_dpp v28, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_and_b32 v9, 7, v0
set_exec -1
v_ldexp_f32_e64_dpp v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 161

; Checkpoint 162: vop3_dpp16_05
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_lerp_u8_e64_dpp v16, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_lshl_add_u32_e64_dpp v18, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_lshl_or_b32_e64_dpp v20, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_lshlrev_b16_e64_dpp v22.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_lshrrev_b16_e64_dpp v24.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_mad_i16_e64_dpp v26.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_mad_i32_i16_e64_dpp v28, v8.l, v9.l, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_mad_i32_i24_e64_dpp v30, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 162

; Checkpoint 163: vop3_dpp16_06
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_mad_u16_e64_dpp v16.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_mad_u32_u16_e64_dpp v18, v8.l, v9.l, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_mad_u32_u24_e64_dpp v20, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_max3_f16_e64_dpp v22.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_max3_f32_e64_dpp v24, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_max3_i16_e64_dpp v26.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_max3_i32_e64_dpp v28, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_max3_u16_e64_dpp v30.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 163

; Checkpoint 164: vop3_dpp16_07
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_max3_u32_e64_dpp v16, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_max_i16_e64_dpp v18.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_max_u16_e64_dpp v20.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_maxmin_f16_e64_dpp v22.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_maxmin_f32_e64_dpp v24, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_maxmin_i32_e64_dpp v26, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_maxmin_u32_e64_dpp v28, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_maximum_f16 v30.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 164

; Checkpoint 165: vop3_dpp16_08
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_maximum_f32 v16, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_maximum3_f16 v18.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_maximum3_f32 v20, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_maximumminimum_f16 v22.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_maximumminimum_f32 v24, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_mbcnt_hi_u32_b32_e64_dpp v26, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_mbcnt_lo_u32_b32_e64_dpp v28, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_med3_f16_e64_dpp v30.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 165

; Checkpoint 166: vop3_dpp16_09
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_med3_f32_e64_dpp v16, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_med3_i16_e64_dpp v18.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_med3_i32_e64_dpp v20, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_med3_u16_e64_dpp v22.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_med3_u32_e64_dpp v24, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_min3_f16_e64_dpp v26.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_min3_f32_e64_dpp v28, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_min3_i16_e64_dpp v30.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 166

; Checkpoint 167: vop3_dpp16_10
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_min3_i32_e64_dpp v16, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_min3_u16_e64_dpp v18.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_min3_u32_e64_dpp v20, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_min_i16_e64_dpp v22.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_min_u16_e64_dpp v24.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_minmax_f16_e64_dpp v26.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_minmax_f32_e64_dpp v28, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_minmax_i32_e64_dpp v30, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 167

; Checkpoint 168: vop3_dpp16_11
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_minmax_u32_e64_dpp v16, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_minimum_f16 v18.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_minimum_f32 v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_minimum3_f16 v22.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_minimum3_f32 v24, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_minimummaximum_f16 v26.l, v8.l, v9.l, v10.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_minimummaximum_f32 v28, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_msad_u8_e64_dpp v30, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 168

; Checkpoint 169: vop3_dpp16_12
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_mul_lo_u16_e64_dpp v16.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_mullit_f32_e64_dpp v18, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_or3_b32_e64_dpp v20, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_or_b16_e64_dpp v22.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_pack_b32_f16_e64_dpp v24, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_perm_b32_e64_dpp v26, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_sad_hi_u8_e64_dpp v28, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_sad_u16_e64_dpp v30, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 169

; Checkpoint 170: vop3_dpp16_13
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_sad_u32_e64_dpp v16, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_sad_u8_e64_dpp v18, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_sub_co_u32_e64_dpp v20, s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_sub_co_u32_e64_dpp v20, s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v21, s20, s65
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_sub_nc_i16_e64_dpp v22.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_sub_nc_i32_e64_dpp v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_sub_nc_u16_e64_dpp v26.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_subrev_co_u32_e64_dpp v28, s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_subrev_co_u32_e64_dpp v28, s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v29, s20, s65
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_xad_u32_e64_dpp v30, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 170

; Checkpoint 171: vop3_dpp16_14
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_xor3_b32_e64_dpp v16, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_xor_b16_e64_dpp v18.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 171

; Checkpoint 172: vop3_dpp8_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_add3_u32_e64_dpp v16, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_add_co_u32_e64_dpp v18, s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_add_co_u32_e64_dpp v18, s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v19, s20, s65
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_add_lshl_u32_e64_dpp v20, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_add_nc_i16_e64_dpp v22.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_add_nc_i32_e64_dpp v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_add_nc_u16_e64_dpp v26.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_alignbit_b32_e64_dpp v28, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_alignbyte_b32_e64_dpp v30, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 172

; Checkpoint 173: vop3_dpp8_01
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_and_b16_e64_dpp v16.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_and_or_b32_e64_dpp v18, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ashrrev_i16_e64_dpp v20.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_bcnt_u32_b32_e64_dpp v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_bfe_i32_e64_dpp v24, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_bfe_u32_e64_dpp v26, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_bfi_b32_e64_dpp v28, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_bfm_b32_e64_dpp v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 173

; Checkpoint 174: vop3_dpp8_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cndmask_b16_e64_dpp v16.h, v8.h, v9.h, s23 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_cndmask_b16_e64_dpp v16.h, v8.h, v9.h, s[70:71] dpp8:[7,6,5,4,3,2,1,0] fi:1
.endif
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cubeid_f32_e64_dpp v18, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cubema_f32_e64_dpp v20, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cubesc_f32_e64_dpp v22, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cubetc_f32_e64_dpp v24, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_pk_fp8_f32_e64_dpp v26.h, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_pk_bf8_f32_e64_dpp v28.h, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_mov_b32 v9, v1
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_sr_fp8_f32_e64_dpp v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 174

; Checkpoint 175: vop3_dpp8_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, v1
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_sr_fp8_f32 v16, v9, v10 byte_sel:0 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, v1
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_sr_bf8_f32_e64_dpp v18, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_mov_b32 v9, v1
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_sr_bf8_f32 v20, v9, v10 byte_sel:0 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_pk_i16_f32_e64_dpp v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_pk_i16_i32_e64_dpp v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_pk_norm_i16_f16_e64_dpp v26, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_pk_norm_u16_f16_e64_dpp v28, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_pk_u16_f32_e64_dpp v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 175

; Checkpoint 176: vop3_dpp8_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_pk_u16_u32_e64_dpp v16, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_pk_u8_f32_e64_dpp v18, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_pk_norm_i16_f32_e64_dpp v20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_pk_norm_u16_f32_e64_dpp v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_div_fixup_f16_e64_dpp v24.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_fma_f16_e64_dpp v26.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_fma_f32_e64_dpp v28, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_and_b32 v9, 7, v0
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ldexp_f32_e64_dpp v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 176

; Checkpoint 177: vop3_dpp8_05
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_lerp_u8_e64_dpp v16, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_lshl_add_u32_e64_dpp v18, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_lshl_or_b32_e64_dpp v20, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_lshlrev_b16_e64_dpp v22.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_lshrrev_b16_e64_dpp v24.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mad_i16_e64_dpp v26.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mad_i32_i16_e64_dpp v28, v8.h, v9.h, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mad_i32_i24_e64_dpp v30, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 177

; Checkpoint 178: vop3_dpp8_06
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mad_u16_e64_dpp v16.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mad_u32_u16_e64_dpp v18, v8.h, v9.h, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mad_u32_u24_e64_dpp v20, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max3_f16_e64_dpp v22.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max3_f32_e64_dpp v24, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max3_i16_e64_dpp v26.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max3_i32_e64_dpp v28, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max3_u16_e64_dpp v30.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 178

; Checkpoint 179: vop3_dpp8_07
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max3_u32_e64_dpp v16, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max_i16_e64_dpp v18.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max_u16_e64_dpp v20.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_maxmin_f16_e64_dpp v22.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_maxmin_f32_e64_dpp v24, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_maxmin_i32_e64_dpp v26, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_maxmin_u32_e64_dpp v28, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mbcnt_hi_u32_b32_e64_dpp v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 179

; Checkpoint 180: vop3_dpp8_08
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mbcnt_lo_u32_b32_e64_dpp v16, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_med3_f16_e64_dpp v18.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_med3_f32_e64_dpp v20, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_med3_i16_e64_dpp v22.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_med3_i32_e64_dpp v24, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_med3_u16_e64_dpp v26.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_med3_u32_e64_dpp v28, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min3_f16_e64_dpp v30.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 180

; Checkpoint 181: vop3_dpp8_09
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min3_f32_e64_dpp v16, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min3_i16_e64_dpp v18.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min3_i32_e64_dpp v20, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min3_u16_e64_dpp v22.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min3_u32_e64_dpp v24, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min_i16_e64_dpp v26.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min_u16_e64_dpp v28.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_minmax_f16_e64_dpp v30.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 181

; Checkpoint 182: vop3_dpp8_10
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_minmax_f32_e64_dpp v16, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_minmax_i32_e64_dpp v18, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_minmax_u32_e64_dpp v20, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_msad_u8_e64_dpp v22, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_lo_u16_e64_dpp v24.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mullit_f32_e64_dpp v26, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_or3_b32_e64_dpp v28, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_or_b16_e64_dpp v30.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 182

; Checkpoint 183: vop3_dpp8_11
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_pack_b32_f16_e64_dpp v16, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_perm_b32_e64_dpp v18, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sad_hi_u8_e64_dpp v20, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sad_u16_e64_dpp v22, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sad_u32_e64_dpp v24, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sad_u8_e64_dpp v26, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_sub_co_u32_e64_dpp v28, s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_sub_co_u32_e64_dpp v28, s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v29, s20, s65
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sub_nc_i16_e64_dpp v30.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 183

; Checkpoint 184: vop3_dpp8_12
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sub_nc_i32_e64_dpp v16, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sub_nc_u16_e64_dpp v18.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_subrev_co_u32_e64_dpp v20, s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_subrev_co_u32_e64_dpp v20, s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v21, s20, s65
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_xad_u32_e64_dpp v22, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_xor3_b32_e64_dpp v24, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_xor_b16_e64_dpp v26.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_dot2_f16_f16_e64_dpp v28.h, v8, v9, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_dot2_bf16_bf16_e64_dpp v30.h, v8, v9, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 184

; Checkpoint 185: vop3_dpp8_13
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_minimum_f32 v16, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_maximum_f32 v18, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_minimum_f16 v20.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_maximum_f16 v22.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_minimum3_f32 v24, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_maximum3_f32 v26, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_minimum3_f16 v28.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_maximum3_f16 v30.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 185

; Checkpoint 186: vop3_dpp8_14
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_maximumminimum_f32 v16, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_minimummaximum_f32 v18, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_maximumminimum_f16 v20.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_minimummaximum_f16 v22.h, v8.h, v9.h, v10.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 186

; Checkpoint 187: vop3_from_vop1_plain_00
clear_results
masked_begin 187
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_bfrev_b32_e64 v16, v8
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_ceil_f16_e64 v18.l, v8.l
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_ceil_f32_e64 v20, v8
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_cls_i32_e64 v22, v8
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_clz_i32_u32_e64 v24, v8
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
v_cos_f16_e64 v26.l, v8.l
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_cos_f32_e64 v28, v8
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_ctz_i32_b32_e64 v30, v8
masked_end 187
checkpoint 187

; Checkpoint 188: vop3_from_vop1_plain_01
clear_results
masked_begin 188
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
v_cvt_f16_f32_e64 v16.l, v8
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cvt_f16_i16_e64 v18.l, v8.l
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_cvt_f16_u16_e64 v20.l, v8.l
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
v_cvt_f32_f16_e64 v22, v8.l
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_cvt_f32_fp8 v24, v9
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_cvt_f32_bf8 v26, v9
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_f32_i32_e64 v28, v8
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_f32_u32_e64 v30, v8
masked_end 188
checkpoint 188

; Checkpoint 189: vop3_from_vop1_plain_02
clear_results
masked_begin 189
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
v_cvt_f32_ubyte0_e64 v16, v8
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cvt_f32_ubyte1_e64 v18, v8
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_cvt_f32_ubyte2_e64 v20, v8
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cvt_f32_ubyte3_e64 v22, v8
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
v_cvt_floor_i32_f32_e64 v24, v8
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cvt_flr_i32_f32_e64 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_i16_f16_e64 v28.l, v8.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_i32_f32_e64 v30, v8
masked_end 189
checkpoint 189

; Checkpoint 190: vop3_from_vop1_plain_03
clear_results
masked_begin 190
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cvt_i32_i16_e64 v16, v8.l
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cvt_nearest_i32_f32_e64 v18, v8
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cvt_norm_i16_f16_e64 v20.l, v8.l
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
v_cvt_norm_u16_f16_e64 v22.l, v8.l
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
v_cvt_off_f32_i4_e64 v24, v8
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cvt_rpi_i32_f32_e64 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_u16_f16_e64 v28.l, v8.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_u32_f32_e64 v30, v8
masked_end 190
checkpoint 190

; Checkpoint 191: vop3_from_vop1_plain_04
clear_results
masked_begin 191
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cvt_u32_u16_e64 v16, v8.l
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_exp_f16_e64 v18.l, v8.l
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_exp_f32_e64 v20, v8
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_ffbh_i32_e64 v22, v8
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_ffbh_u32_e64 v24, v8
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_ffbl_b32_e64 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_floor_f16_e64 v28.l, v8.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_floor_f32_e64 v30, v8
masked_end 191
checkpoint 191

; Checkpoint 192: vop3_from_vop1_plain_05
clear_results
masked_begin 192
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_fract_f16_e64 v16.l, v8.l
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_fract_f32_e64 v18, v8
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_frexp_exp_i16_f16_e64 v20.l, v8.l
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_frexp_exp_i32_f32_e64 v22, v8
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_frexp_mant_f16_e64 v24.l, v8.l
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_frexp_mant_f32_e64 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_log_f16_e64 v28.l, v8.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_log_f32_e64 v30, v8
masked_end 192
checkpoint 192

; Checkpoint 193: vop3_from_vop1_plain_06
clear_results
masked_begin 193
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32_e64 v16, v8
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_movrels_b32_e64 v18, v8
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_not_b16_e64 v20.l, v8.l
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_not_b32_e64 v22, v8
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_rcp_f16_e64 v24.l, v8.l
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_rcp_f32_e64 v26, v8
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_rcp_iflag_f32_e64 v28, v8
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
v_rndne_f16_e64 v30.l, v8.l
masked_end 193
checkpoint 193

; Checkpoint 194: vop3_from_vop1_plain_07
clear_results
masked_begin 194
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
v_rndne_f32_e64 v16, v8
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_rsq_f16_e64 v18.l, v8.l
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_rsq_f32_e64 v20, v8
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_sat_pk_u8_i16_e64 v22.l, v8
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_sin_f16_e64 v24.l, v8.l
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_sin_f32_e64 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_sqrt_f16_e64 v28.l, v8.l
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_sqrt_f32_e64 v30, v8
masked_end 194
checkpoint 194

; Checkpoint 195: vop3_from_vop1_plain_08
clear_results
masked_begin 195
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_trunc_f16_e64 v16.l, v8.l
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_trunc_f32_e64 v18, v8
masked_end 195
checkpoint 195

; Checkpoint 196: vop3_from_vop1_dpp16_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_bfrev_b32_e64_dpp v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_ceil_f16_e64_dpp v18.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_ceil_f32_e64_dpp v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cls_i32_e64_dpp v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_clz_i32_u32_e64_dpp v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cos_f16_e64_dpp v26.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cos_f32_e64_dpp v28, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_ctz_i32_b32_e64_dpp v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 196

; Checkpoint 197: vop3_from_vop1_dpp16_01
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cvt_f16_f32_e64_dpp v16.l, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cvt_f16_i16_e64_dpp v18.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cvt_f16_u16_e64_dpp v20.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cvt_f32_f16_e64_dpp v22, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cvt_f32_fp8 v24, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cvt_f32_bf8 v26, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cvt_f32_i32_e64_dpp v28, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cvt_f32_u32_e64_dpp v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 197

; Checkpoint 198: vop3_from_vop1_dpp16_02
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cvt_f32_ubyte0_e64_dpp v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cvt_f32_ubyte1_e64_dpp v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cvt_f32_ubyte2_e64_dpp v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cvt_f32_ubyte3_e64_dpp v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cvt_floor_i32_f32_e64_dpp v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cvt_flr_i32_f32_e64_dpp v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cvt_i16_f16_e64_dpp v28.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cvt_i32_f32_e64_dpp v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 198

; Checkpoint 199: vop3_from_vop1_dpp16_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cvt_i32_i16_e64_dpp v16, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cvt_nearest_i32_f32_e64_dpp v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cvt_norm_i16_f16_e64_dpp v20.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cvt_norm_u16_f16_e64_dpp v22.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cvt_off_f32_i4_e64_dpp v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cvt_rpi_i32_f32_e64_dpp v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cvt_u16_f16_e64_dpp v28.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cvt_u32_f32_e64_dpp v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 199

; Checkpoint 200: vop3_from_vop1_dpp16_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cvt_u32_u16_e64_dpp v16, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_exp_f16_e64_dpp v18.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_exp_f32_e64_dpp v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_ffbh_i32_e64_dpp v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_ffbh_u32_e64_dpp v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_ffbl_b32_e64_dpp v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_floor_f16_e64_dpp v28.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_floor_f32_e64_dpp v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 200

; Checkpoint 201: vop3_from_vop1_dpp16_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_fract_f16_e64_dpp v16.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_fract_f32_e64_dpp v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_frexp_exp_i16_f16_e64_dpp v20.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_frexp_exp_i32_f32_e64_dpp v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_frexp_mant_f16_e64_dpp v24.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_frexp_mant_f32_e64_dpp v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_log_f16_e64_dpp v28.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_log_f32_e64_dpp v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 201

; Checkpoint 202: vop3_from_vop1_dpp16_06
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_mov_b32_e64_dpp v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_movrels_b32_e64_dpp v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_not_b16_e64_dpp v20.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_not_b32_e64_dpp v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_rcp_f16_e64_dpp v24.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_rcp_f32_e64_dpp v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_rcp_iflag_f32_e64_dpp v28, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_rndne_f16_e64_dpp v30.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 202

; Checkpoint 203: vop3_from_vop1_dpp16_07
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_rndne_f32_e64_dpp v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_rsq_f16_e64_dpp v18.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_rsq_f32_e64_dpp v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_sat_pk_u8_i16_e64_dpp v22.l, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_sin_f16_e64_dpp v24.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_sin_f32_e64_dpp v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_sqrt_f16_e64_dpp v28.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_sqrt_f32_e64_dpp v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 203

; Checkpoint 204: vop3_from_vop1_dpp16_08
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_trunc_f16_e64_dpp v16.l, v8.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_trunc_f32_e64_dpp v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 204

; Checkpoint 205: vop3_from_vop1_dpp8_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_bfrev_b32_e64_dpp v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ceil_f16_e64_dpp v18.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ceil_f32_e64_dpp v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cls_i32_e64_dpp v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_clz_i32_u32_e64_dpp v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cos_f16_e64_dpp v26.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cos_f32_e64_dpp v28, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ctz_i32_b32_e64_dpp v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 205

; Checkpoint 206: vop3_from_vop1_dpp8_01
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_fp8_e64_dpp v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_bf8_e64_dpp v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f16_f32_e64_dpp v20.h, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f16_i16_e64_dpp v22.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f16_u16_e64_dpp v24.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_f16_e64_dpp v26, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_fp8 v28, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_bf8 v30, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 206

; Checkpoint 207: vop3_from_vop1_dpp8_02
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_i32_e64_dpp v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_u32_e64_dpp v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_ubyte0_e64_dpp v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_ubyte1_e64_dpp v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_ubyte2_e64_dpp v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_f32_ubyte3_e64_dpp v26, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_floor_i32_f32_e64_dpp v28, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_flr_i32_f32_e64_dpp v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 207

; Checkpoint 208: vop3_from_vop1_dpp8_03
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_i16_f16_e64_dpp v16.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_i32_f32_e64_dpp v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_i32_i16_e64_dpp v20, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_nearest_i32_f32_e64_dpp v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_norm_i16_f16_e64_dpp v24.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_norm_u16_f16_e64_dpp v26.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_off_f32_i4_e64_dpp v28, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_rpi_i32_f32_e64_dpp v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 208

; Checkpoint 209: vop3_from_vop1_dpp8_04
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_u16_f16_e64_dpp v16.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_u32_f32_e64_dpp v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_u32_u16_e64_dpp v20, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_exp_f16_e64_dpp v22.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_exp_f32_e64_dpp v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ffbh_i32_e64_dpp v26, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ffbh_u32_e64_dpp v28, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ffbl_b32_e64_dpp v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 209

; Checkpoint 210: vop3_from_vop1_dpp8_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_floor_f16_e64_dpp v16.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_floor_f32_e64_dpp v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_fract_f16_e64_dpp v20.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_fract_f32_e64_dpp v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_frexp_exp_i16_f16_e64_dpp v24.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_frexp_exp_i32_f32_e64_dpp v26, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_frexp_mant_f16_e64_dpp v28.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_frexp_mant_f32_e64_dpp v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 210

; Checkpoint 211: vop3_from_vop1_dpp8_06
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_log_f16_e64_dpp v16.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_log_f32_e64_dpp v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mov_b32_e64_dpp v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_movrels_b32_e64_dpp v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_not_b16_e64_dpp v24.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_not_b32_e64_dpp v26, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_rcp_f16_e64_dpp v28.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_rcp_f32_e64_dpp v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 211

; Checkpoint 212: vop3_from_vop1_dpp8_07
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_rcp_iflag_f32_e64_dpp v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_rndne_f16_e64_dpp v18.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_rndne_f32_e64_dpp v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_rsq_f16_e64_dpp v22.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_rsq_f32_e64_dpp v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sat_pk_u8_i16_e64_dpp v26.h, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sin_f16_e64_dpp v28.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sin_f32_e64_dpp v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 212

; Checkpoint 213: vop3_from_vop1_dpp8_08
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sqrt_f16_e64_dpp v16.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sqrt_f32_e64_dpp v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_trunc_f16_e64_dpp v20.h, v8.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_trunc_f32_e64_dpp v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 213

; Checkpoint 214: vop3_from_vop2_plain_00
clear_results
masked_begin 214
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_add_co_ci_u32_e64 v16, s20, v8, v9, s23
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_add_co_ci_u32_e64 v16, s[64:65], v8, v9, s[70:71]
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v17, s20, s65
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_add_f16_e64 v18.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_add_f32_e64 v20, v8, v9
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_add_nc_u32_e64 v22, v8, v9
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_and_b32_e64 v24, v8, v9
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_ashrrev_i32_e64 v26, v8, v9
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cndmask_b32_e64 v28, v8, v9, s23
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_cndmask_b32_e64 v28, v8, v9, s[70:71]
.endif
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_pk_rtz_f16_f32_e64 v30, v8, v9
masked_end 214
checkpoint 214

; Checkpoint 215: vop3_from_vop2_plain_01
clear_results
masked_begin 215
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_fmac_f16_e64 v16.l, v8.l, v9.l
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_and_b32 v9, 7, v0
v_ldexp_f16_e64 v18.l, v8.l, v9.l
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_lshlrev_b32_e64 v20, v8, v9
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_lshrrev_b32_e64 v22, v8, v9
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_max_f16_e64 v24.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_max_f32_e64 v26, v8, v9
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_max_i32_e64 v28, v8, v9
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_max_u32_e64 v30, v8, v9
masked_end 215
checkpoint 215

; Checkpoint 216: vop3_from_vop2_plain_02
clear_results
masked_begin 216
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_min_f16_e64 v16.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_min_f32_e64 v18, v8, v9
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_min_i32_e64 v20, v8, v9
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_min_u32_e64 v22, v8, v9
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
v_mul_legacy_f32_e64 v24, v8, v9
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
v_mul_f16_e64 v26.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_mul_f32_e64 v28, v8, v9
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_mul_hi_i32_i24_e64 v30, v8, v9
masked_end 216
checkpoint 216

; Checkpoint 217: vop3_from_vop2_plain_03
clear_results
masked_begin 217
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_mul_hi_u32_u24_e64 v16, v8, v9
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_mul_i32_i24_e64 v18, v8, v9
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_mul_u32_u24_e64 v20, v8, v9
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_or_b32_e64 v22, v8, v9
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_sub_co_ci_u32_e64 v24, s20, v8, v9, s23
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_sub_co_ci_u32_e64 v24, s[64:65], v8, v9, s[70:71]
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v25, s20, s65
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
v_sub_f16_e64 v26.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_sub_f32_e64 v28, v8, v9
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_sub_nc_u32_e64 v30, v8, v9
masked_end 217
checkpoint 217

; Checkpoint 218: vop3_from_vop2_plain_04
clear_results
masked_begin 218
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_subrev_co_ci_u32_e64 v16, s20, v8, v9, s23
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_subrev_co_ci_u32_e64 v16, s[64:65], v8, v9, s[70:71]
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v17, s20, s65
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_subrev_f16_e64 v18.l, v8.l, v9.l
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_subrev_f32_e64 v20, v8, v9
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_subrev_nc_u32_e64 v22, v8, v9
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_xnor_b32_e64 v24, v8, v9
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_xor_b32_e64 v26, v8, v9
masked_end 218
checkpoint 218

; Checkpoint 219: vop3_from_vop2_dpp16_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_add_co_ci_u32_e64_dpp v16, s20, v8, v9, s23 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_add_co_ci_u32_e64_dpp v16, s[64:65], v8, v9, s[70:71] row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v17, s20, s65
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_add_f16_e64_dpp v18.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_add_f32_e64_dpp v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_add_nc_u32_e64_dpp v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_and_b32_e64_dpp v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_ashrrev_i32_e64_dpp v26, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cndmask_b32_e64_dpp v28, v8, v9, s23 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_cndmask_b32_e64_dpp v28, v8, v9, s[70:71] row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.endif
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cvt_pk_rtz_f16_f32_e64_dpp v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 219

; Checkpoint 220: vop3_from_vop2_dpp16_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_fmac_f16_e64_dpp v16.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_and_b32 v9, 7, v0
set_exec -1
v_ldexp_f16_e64_dpp v18.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_lshlrev_b32_e64_dpp v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_lshrrev_b32_e64_dpp v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_max_f16_e64_dpp v24.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_max_f32_e64_dpp v26, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_max_i32_e64_dpp v28, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_max_u32_e64_dpp v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 220

; Checkpoint 221: vop3_from_vop2_dpp16_02
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_min_f16_e64_dpp v16.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_min_f32_e64_dpp v18, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_min_i32_e64_dpp v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_min_u32_e64_dpp v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_mul_legacy_f32_e64_dpp v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_mul_f16_e64_dpp v26.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_mul_f32_e64_dpp v28, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_mul_hi_i32_i24_e64_dpp v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 221

; Checkpoint 222: vop3_from_vop2_dpp16_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_mul_hi_u32_u24_e64_dpp v16, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_mul_i32_i24_e64_dpp v18, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_mul_u32_u24_e64_dpp v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_or_b32_e64_dpp v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_sub_co_ci_u32_e64_dpp v24, s20, v8, v9, s23 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_sub_co_ci_u32_e64_dpp v24, s[64:65], v8, v9, s[70:71] row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v25, s20, s65
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_sub_f16_e64_dpp v26.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_sub_f32_e64_dpp v28, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_sub_nc_u32_e64_dpp v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 222

; Checkpoint 223: vop3_from_vop2_dpp16_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_subrev_co_ci_u32_e64_dpp v16, s20, v8, v9, s23 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_subrev_co_ci_u32_e64_dpp v16, s[64:65], v8, v9, s[70:71] row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v17, s20, s65
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_subrev_f16_e64_dpp v18.l, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_subrev_f32_e64_dpp v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_subrev_nc_u32_e64_dpp v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_xnor_b32_e64_dpp v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_xor_b32_e64_dpp v26, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 223

; Checkpoint 224: vop3_from_vop2_dpp8_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_add_co_ci_u32_e64_dpp v16, s20, v8, v9, s23 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_add_co_ci_u32_e64_dpp v16, s[64:65], v8, v9, s[70:71] dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v17, s20, s65
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_add_f16_e64_dpp v18.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_add_f32_e64_dpp v20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_add_nc_u32_e64_dpp v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_and_b32_e64_dpp v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ashrrev_i32_e64_dpp v26, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cndmask_b32_e64_dpp v28, v8, v9, s23 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_cndmask_b32_e64_dpp v28, v8, v9, s[70:71] dpp8:[7,6,5,4,3,2,1,0] fi:1
.endif
set_exec -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cvt_pk_rtz_f16_f32_e64_dpp v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 224

; Checkpoint 225: vop3_from_vop2_dpp8_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_fmac_f16_e64_dpp v16.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_and_b32 v9, 7, v0
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_ldexp_f16_e64_dpp v18.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_lshlrev_b32_e64_dpp v20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_lshrrev_b32_e64_dpp v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max_f16_e64_dpp v24.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max_f32_e64_dpp v26, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max_i32_e64_dpp v28, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_max_u32_e64_dpp v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 225

; Checkpoint 226: vop3_from_vop2_dpp8_02
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min_f16_e64_dpp v16.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min_f32_e64_dpp v18, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min_i32_e64_dpp v20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_min_u32_e64_dpp v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_legacy_f32_e64_dpp v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_f16_e64_dpp v26.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_f32_e64_dpp v28, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_hi_i32_i24_e64_dpp v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 226

; Checkpoint 227: vop3_from_vop2_dpp8_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_hi_u32_u24_e64_dpp v16, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_i32_i24_e64_dpp v18, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_mul_u32_u24_e64_dpp v20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_or_b32_e64_dpp v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_sub_co_ci_u32_e64_dpp v24, s20, v8, v9, s23 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_sub_co_ci_u32_e64_dpp v24, s[64:65], v8, v9, s[70:71] dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v25, s20, s65
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sub_f16_e64_dpp v26.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sub_f32_e64_dpp v28, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_sub_nc_u32_e64_dpp v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 227

; Checkpoint 228: vop3_from_vop2_dpp8_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_subrev_co_ci_u32_e64_dpp v16, s20, v8, v9, s23 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
s_mov_b32 s70, s23
s_not_b32 s71, s23
s_wait_alu 0xfffe
v_subrev_co_ci_u32_e64_dpp v16, s[64:65], v8, v9, s[70:71] dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v17, s20, s65
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_subrev_f16_e64_dpp v18.h, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_subrev_f32_e64_dpp v20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_subrev_nc_u32_e64_dpp v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_xnor_b32_e64_dpp v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_xor_b32_e64_dpp v26, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 228

; Checkpoint 229: vopc_plain_00
clear_results
masked_begin 229
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
v_cmp_class_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
v_cmp_class_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_eq_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_eq_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_eq_i16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_eq_i32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_eq_u16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_eq_u32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
masked_end 229
checkpoint 229

; Checkpoint 230: vopc_plain_01
clear_results
masked_begin 230
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_ge_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_ge_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_ge_i16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_ge_i32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_ge_u16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_ge_u32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_gt_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_gt_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
masked_end 230
checkpoint 230

; Checkpoint 231: vopc_plain_02
clear_results
masked_begin 231
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_gt_i16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_gt_i32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_gt_u16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_gt_u32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_le_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_le_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_le_i16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_le_i32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
masked_end 231
checkpoint 231

; Checkpoint 232: vopc_plain_03
clear_results
masked_begin 232
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_le_u16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_le_u32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_lg_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_lg_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_lt_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_lt_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_lt_i16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_lt_i32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
masked_end 232
checkpoint 232

; Checkpoint 233: vopc_plain_04
clear_results
masked_begin 233
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_lt_u16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_lt_u32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_ne_i16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_ne_i32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_ne_u16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_ne_u32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_neq_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_neq_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
masked_end 233
checkpoint 233

; Checkpoint 234: vopc_plain_05
clear_results
masked_begin 234
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_nge_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_nge_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_ngt_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_ngt_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_nle_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_nle_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_nlg_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_nlg_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
masked_end 234
checkpoint 234

; Checkpoint 235: vopc_plain_06
clear_results
masked_begin 235
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_nlt_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_nlt_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_o_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_o_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_u_f16 \cc, v8.l, v9.l
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_u_f32 \cc, v8, v9
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
masked_end 235
checkpoint 235

; Checkpoint 236: vopc_dpp16_00
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec -1
v_cmp_class_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec -1
v_cmp_class_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmp_eq_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmp_eq_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmp_eq_i16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmp_eq_i32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmp_eq_u16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmp_eq_u32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
checkpoint 236

; Checkpoint 237: vopc_dpp16_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmp_ge_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmp_ge_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmp_ge_i16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmp_ge_i32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmp_ge_u16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmp_ge_u32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmp_gt_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmp_gt_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
checkpoint 237

; Checkpoint 238: vopc_dpp16_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmp_gt_i16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmp_gt_i32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmp_gt_u16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmp_gt_u32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmp_le_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmp_le_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmp_le_i16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmp_le_i32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
checkpoint 238

; Checkpoint 239: vopc_dpp16_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmp_le_u16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmp_le_u32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmp_lg_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmp_lg_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmp_lt_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmp_lt_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmp_lt_i16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmp_lt_i32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
checkpoint 239

; Checkpoint 240: vopc_dpp16_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmp_lt_u16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmp_lt_u32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmp_ne_i16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmp_ne_i32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmp_ne_u16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmp_ne_u32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmp_neq_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmp_neq_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
checkpoint 240

; Checkpoint 241: vopc_dpp16_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmp_nge_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmp_nge_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmp_ngt_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmp_ngt_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmp_nle_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmp_nle_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmp_nlg_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmp_nlg_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
checkpoint 241

; Checkpoint 242: vopc_dpp16_06
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmp_nlt_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmp_nlt_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmp_o_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmp_o_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmp_u_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmp_u_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
checkpoint 242

; Checkpoint 243: vopc_dpp8_00
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_class_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_class_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_eq_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_eq_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_eq_i16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_eq_i32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_eq_u16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_eq_u32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
checkpoint 243

; Checkpoint 244: vopc_dpp8_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_ge_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_ge_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_ge_i16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_ge_i32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_ge_u16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_ge_u32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_gt_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_gt_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
checkpoint 244

; Checkpoint 245: vopc_dpp8_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_gt_i16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_gt_i32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_gt_u16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_gt_u32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_le_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_le_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_le_i16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_le_i32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
checkpoint 245

; Checkpoint 246: vopc_dpp8_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_le_u16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_le_u32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_lg_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_lg_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_lt_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_lt_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_lt_i16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_lt_i32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
checkpoint 246

; Checkpoint 247: vopc_dpp8_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_lt_u16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_lt_u32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_ne_i16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_ne_i32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_ne_u16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_ne_u32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_neq_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_neq_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
checkpoint 247

; Checkpoint 248: vopc_dpp8_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_nge_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_nge_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_ngt_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_ngt_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_nle_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_nle_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_nlg_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v28, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_nlg_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v30, vcc_lo, vcc_hi
checkpoint 248

; Checkpoint 249: vopc_dpp8_06
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_nlt_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v16, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_nlt_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v18, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_o_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v20, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_o_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v22, vcc_lo, vcc_hi
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_u_f16 \cc, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v24, vcc_lo, vcc_hi
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmp_u_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
checkpoint 249

; Checkpoint 250: vopcx_plain_00
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec -1
v_cmpx_class_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec -1
v_cmpx_class_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_i16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_i32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_u16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_u32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 250

; Checkpoint 251: vopcx_plain_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_i16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_i32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_u16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_u32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 251

; Checkpoint 252: vopcx_plain_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_i16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_i32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_u16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_u32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_le_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_le_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_le_i16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_le_i32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 252

; Checkpoint 253: vopcx_plain_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_le_u16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_le_u32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_lg_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_lg_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_i16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_i32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 253

; Checkpoint 254: vopcx_plain_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_u16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_u32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_i16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_i32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_u16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_u32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_neq_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_neq_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 254

; Checkpoint 255: vopcx_plain_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_nge_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_nge_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_ngt_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_ngt_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_nle_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_nle_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_nlg_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_nlg_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 255

; Checkpoint 256: vopcx_plain_06
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_nlt_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_nlt_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_o_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_o_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_u_f16 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_u_f32 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
checkpoint 256

; Checkpoint 257: vopcx_dpp16_00
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec -1
v_cmpx_class_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec -1
v_cmpx_class_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_i16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_i32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_u16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_u32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 257

; Checkpoint 258: vopcx_dpp16_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_i16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_i32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_u16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_u32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 258

; Checkpoint 259: vopcx_dpp16_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_i16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_i32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_u16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_u32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_le_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_le_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_le_i16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_le_i32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 259

; Checkpoint 260: vopcx_dpp16_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_le_u16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_le_u32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_lg_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_lg_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_i16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_i32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 260

; Checkpoint 261: vopcx_dpp16_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_u16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_u32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_i16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_i32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_u16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_u32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_neq_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_neq_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 261

; Checkpoint 262: vopcx_dpp16_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_nge_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_nge_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_ngt_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_ngt_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_nle_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_nle_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_nlg_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_nlg_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 262

; Checkpoint 263: vopcx_dpp16_06
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_nlt_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_nlt_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_o_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_o_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_u_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_u_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
checkpoint 263

; Checkpoint 264: vopcx_dpp8_00
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_class_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_class_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_eq_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_eq_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_eq_i16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_eq_i32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_eq_u16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_eq_u32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 264

; Checkpoint 265: vopcx_dpp8_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ge_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ge_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ge_i16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ge_i32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ge_u16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ge_u32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_gt_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_gt_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 265

; Checkpoint 266: vopcx_dpp8_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_gt_i16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_gt_i32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_gt_u16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_gt_u32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_le_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_le_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_le_i16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_le_i32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 266

; Checkpoint 267: vopcx_dpp8_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_le_u16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_le_u32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lg_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lg_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lt_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lt_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lt_i16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lt_i32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 267

; Checkpoint 268: vopcx_dpp8_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lt_u16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lt_u32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ne_i16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ne_i32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ne_u16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ne_u32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_neq_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_neq_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 268

; Checkpoint 269: vopcx_dpp8_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nge_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nge_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ngt_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ngt_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nle_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nle_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nlg_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nlg_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 269

; Checkpoint 270: vopcx_dpp8_06
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nlt_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nlt_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_o_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_o_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_u_f16 v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_u_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
checkpoint 270

; Checkpoint 271: vop3c_plain_00
clear_results
masked_begin 271
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_class_f16_e64 s20, v8.l, v9.l
.else
v_cmp_class_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_class_f32_e64 s20, v8, v9
.else
v_cmp_class_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_f16_e64 s20, v8.l, v9.l
.else
v_cmp_eq_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_f32_e64 s20, v8, v9
.else
v_cmp_eq_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_i16_e64 s20, v8.l, v9.l
.else
v_cmp_eq_i16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_i32_e64 s20, v8, v9
.else
v_cmp_eq_i32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_u16_e64 s20, v8.l, v9.l
.else
v_cmp_eq_u16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_u32_e64 s20, v8, v9
.else
v_cmp_eq_u32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
masked_end 271
checkpoint 271

; Checkpoint 272: vop3c_plain_01
clear_results
masked_begin 272
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_f16_e64 s20, v8.l, v9.l
.else
v_cmp_ge_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_f32_e64 s20, v8, v9
.else
v_cmp_ge_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_i16_e64 s20, v8.l, v9.l
.else
v_cmp_ge_i16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_i32_e64 s20, v8, v9
.else
v_cmp_ge_i32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_u16_e64 s20, v8.l, v9.l
.else
v_cmp_ge_u16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_u32_e64 s20, v8, v9
.else
v_cmp_ge_u32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_f16_e64 s20, v8.l, v9.l
.else
v_cmp_gt_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_f32_e64 s20, v8, v9
.else
v_cmp_gt_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
masked_end 272
checkpoint 272

; Checkpoint 273: vop3c_plain_02
clear_results
masked_begin 273
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_i16_e64 s20, v8.l, v9.l
.else
v_cmp_gt_i16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_i32_e64 s20, v8, v9
.else
v_cmp_gt_i32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_u16_e64 s20, v8.l, v9.l
.else
v_cmp_gt_u16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_u32_e64 s20, v8, v9
.else
v_cmp_gt_u32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_f16_e64 s20, v8.l, v9.l
.else
v_cmp_le_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_f32_e64 s20, v8, v9
.else
v_cmp_le_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_i16_e64 s20, v8.l, v9.l
.else
v_cmp_le_i16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_i32_e64 s20, v8, v9
.else
v_cmp_le_i32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
masked_end 273
checkpoint 273

; Checkpoint 274: vop3c_plain_03
clear_results
masked_begin 274
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_u16_e64 s20, v8.l, v9.l
.else
v_cmp_le_u16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_u32_e64 s20, v8, v9
.else
v_cmp_le_u32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lg_f16_e64 s20, v8.l, v9.l
.else
v_cmp_lg_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lg_f32_e64 s20, v8, v9
.else
v_cmp_lg_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_f16_e64 s20, v8.l, v9.l
.else
v_cmp_lt_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_f32_e64 s20, v8, v9
.else
v_cmp_lt_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_i16_e64 s20, v8.l, v9.l
.else
v_cmp_lt_i16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_i32_e64 s20, v8, v9
.else
v_cmp_lt_i32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
masked_end 274
checkpoint 274

; Checkpoint 275: vop3c_plain_04
clear_results
masked_begin 275
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_u16_e64 s20, v8.l, v9.l
.else
v_cmp_lt_u16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_u32_e64 s20, v8, v9
.else
v_cmp_lt_u32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ne_i16_e64 s20, v8.l, v9.l
.else
v_cmp_ne_i16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ne_i32_e64 s20, v8, v9
.else
v_cmp_ne_i32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ne_u16_e64 s20, v8.l, v9.l
.else
v_cmp_ne_u16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ne_u32_e64 s20, v8, v9
.else
v_cmp_ne_u32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_neq_f16_e64 s20, v8.l, v9.l
.else
v_cmp_neq_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_neq_f32_e64 s20, v8, v9
.else
v_cmp_neq_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
masked_end 275
checkpoint 275

; Checkpoint 276: vop3c_plain_05
clear_results
masked_begin 276
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nge_f16_e64 s20, v8.l, v9.l
.else
v_cmp_nge_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nge_f32_e64 s20, v8, v9
.else
v_cmp_nge_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ngt_f16_e64 s20, v8.l, v9.l
.else
v_cmp_ngt_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ngt_f32_e64 s20, v8, v9
.else
v_cmp_ngt_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nle_f16_e64 s20, v8.l, v9.l
.else
v_cmp_nle_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nle_f32_e64 s20, v8, v9
.else
v_cmp_nle_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nlg_f16_e64 s20, v8.l, v9.l
.else
v_cmp_nlg_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nlg_f32_e64 s20, v8, v9
.else
v_cmp_nlg_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
masked_end 276
checkpoint 276

; Checkpoint 277: vop3c_plain_06
clear_results
masked_begin 277
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nlt_f16_e64 s20, v8.l, v9.l
.else
v_cmp_nlt_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nlt_f32_e64 s20, v8, v9
.else
v_cmp_nlt_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_o_f16_e64 s20, v8.l, v9.l
.else
v_cmp_o_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_o_f32_e64 s20, v8, v9
.else
v_cmp_o_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_u_f16_e64 s20, v8.l, v9.l
.else
v_cmp_u_f16_e64 s[64:65], v8.l, v9.l
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_u_f32_e64 s20, v8, v9
.else
v_cmp_u_f32_e64 s[64:65], v8, v9
s_mov_b32 s20, s64
.endif
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
masked_end 277
checkpoint 277

; Checkpoint 278: vop3c_dpp16_00
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_class_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_class_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_class_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_class_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_eq_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_eq_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_i16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_eq_i16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_i32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_eq_i32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_u16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_eq_u16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_u32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_eq_u32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
checkpoint 278

; Checkpoint 279: vop3c_dpp16_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_ge_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_ge_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_i16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_ge_i16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_i32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_ge_i32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_u16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_ge_u16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_u32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_ge_u32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_gt_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_gt_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
checkpoint 279

; Checkpoint 280: vop3c_dpp16_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_i16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_gt_i16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_i32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_gt_i32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_u16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_gt_u16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_u32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_gt_u32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_le_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_le_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_i16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_le_i16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_i32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_le_i32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
checkpoint 280

; Checkpoint 281: vop3c_dpp16_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_u16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_le_u16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_u32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_le_u32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lg_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_lg_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lg_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_lg_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_lt_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_lt_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_i16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_lt_i16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_i32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_lt_i32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
checkpoint 281

; Checkpoint 282: vop3c_dpp16_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_u16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_lt_u16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_u32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_lt_u32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ne_i16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_ne_i16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ne_i32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_ne_i32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ne_u16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_ne_u16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ne_u32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_ne_u32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_neq_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_neq_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_neq_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_neq_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
checkpoint 282

; Checkpoint 283: vop3c_dpp16_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nge_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_nge_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nge_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_nge_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ngt_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_ngt_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ngt_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_ngt_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nle_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_nle_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nle_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_nle_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nlg_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_nlg_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nlg_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_nlg_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
checkpoint 283

; Checkpoint 284: vop3c_dpp16_06
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nlt_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_nlt_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nlt_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_nlt_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_o_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_o_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_o_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_o_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_u_f16_e64_dpp s20, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_u_f16_e64_dpp s[64:65], v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_u_f32_e64_dpp s20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
.else
v_cmp_u_f32_e64_dpp s[64:65], v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
checkpoint 284

; Checkpoint 285: vop3c_dpp8_00
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_class_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_class_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_class_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_class_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_eq_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_eq_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_i16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_eq_i16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_i32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_eq_i32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_u16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_eq_u16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_eq_u32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_eq_u32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
checkpoint 285

; Checkpoint 286: vop3c_dpp8_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_ge_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_ge_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_i16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_ge_i16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_i32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_ge_i32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_u16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_ge_u16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ge_u32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_ge_u32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_gt_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_gt_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
checkpoint 286

; Checkpoint 287: vop3c_dpp8_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_i16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_gt_i16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_i32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_gt_i32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_u16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_gt_u16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_gt_u32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_gt_u32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_le_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_le_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_i16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_le_i16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_i32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_le_i32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
checkpoint 287

; Checkpoint 288: vop3c_dpp8_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_u16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_le_u16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_le_u32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_le_u32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lg_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_lg_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lg_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_lg_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_lt_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_lt_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_i16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_lt_i16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_i32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_lt_i32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
checkpoint 288

; Checkpoint 289: vop3c_dpp8_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_u16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_lt_u16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_lt_u32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_lt_u32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ne_i16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_ne_i16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ne_i32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_ne_i32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ne_u16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_ne_u16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ne_u32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_ne_u32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_neq_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_neq_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_neq_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_neq_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
checkpoint 289

; Checkpoint 290: vop3c_dpp8_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nge_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_nge_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nge_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_nge_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ngt_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_ngt_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_ngt_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_ngt_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nle_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_nle_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nle_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_nle_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nlg_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_nlg_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v28, s20, s65
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nlg_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_nlg_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v30, s20, s65
checkpoint 290

; Checkpoint 291: vop3c_dpp8_06
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nlt_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_nlt_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v16, s20, s65
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_nlt_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_nlt_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v18, s20, s65
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_o_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_o_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v20, s20, s65
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_o_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_o_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v22, s20, s65
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_u_f16_e64_dpp s20, v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_u_f16_e64_dpp s[64:65], v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v24, s20, s65
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_cmp_u_f32_e64_dpp s20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
.else
v_cmp_u_f32_e64_dpp s[64:65], v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, s64
.endif
set_exec -1
wait_wave32_alu 0xf1fe
mask_result v26, s20, s65
checkpoint 291

; Checkpoint 292: vop3cx_plain_00
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec -1
v_cmpx_class_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec -1
v_cmpx_class_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_i16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_i32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_u16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_u32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 292

; Checkpoint 293: vop3cx_plain_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_i16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_i32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_u16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_u32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 293

; Checkpoint 294: vop3cx_plain_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_i16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_i32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_u16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_u32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_le_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_le_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_le_i16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_le_i32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 294

; Checkpoint 295: vop3cx_plain_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_le_u16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_le_u32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_lg_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_lg_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_i16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_i32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 295

; Checkpoint 296: vop3cx_plain_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_u16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_u32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_i16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_i32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_u16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_u32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_neq_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_neq_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 296

; Checkpoint 297: vop3cx_plain_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_nge_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_nge_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_ngt_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_ngt_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_nle_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_nle_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_nlg_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_nlg_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 297

; Checkpoint 298: vop3cx_plain_06
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_nlt_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_nlt_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_o_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_o_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_u_f16_e64 v8.l, v9.l
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_u_f32_e64 v8, v9
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
checkpoint 298

; Checkpoint 299: vop3cx_dpp16_00
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec -1
v_cmpx_class_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec -1
v_cmpx_class_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_i16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_i32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_u16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_eq_u32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 299

; Checkpoint 300: vop3cx_dpp16_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_i16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_i32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_u16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_ge_u32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 300

; Checkpoint 301: vop3cx_dpp16_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_i16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_i32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_u16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_gt_u32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_le_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_le_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_le_i16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_le_i32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 301

; Checkpoint 302: vop3cx_dpp16_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_le_u16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_le_u32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_lg_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_lg_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_i16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_i32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 302

; Checkpoint 303: vop3cx_dpp16_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_u16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_lt_u32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_i16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_i32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_u16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_ne_u32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_neq_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_neq_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 303

; Checkpoint 304: vop3cx_dpp16_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_nge_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_nge_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_ngt_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_ngt_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_nle_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_nle_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_cmpx_nlg_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec -1
v_cmpx_nlg_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 304

; Checkpoint 305: vop3cx_dpp16_06
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_cmpx_nlt_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_cmpx_nlt_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_cmpx_o_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_cmpx_o_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_cmpx_u_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_cmpx_u_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
checkpoint 305

; Checkpoint 306: vop3cx_dpp8_00
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_class_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_class_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_eq_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_eq_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_eq_i16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_eq_i32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_eq_u16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_eq_u32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 306

; Checkpoint 307: vop3cx_dpp8_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ge_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ge_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ge_i16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ge_i32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ge_u16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ge_u32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_gt_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_gt_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 307

; Checkpoint 308: vop3cx_dpp8_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_gt_i16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_gt_i32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_gt_u16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_gt_u32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_le_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_le_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_le_i16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_le_i32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 308

; Checkpoint 309: vop3cx_dpp8_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_le_u16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_le_u32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lg_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lg_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lt_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lt_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lt_i16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lt_i32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 309

; Checkpoint 310: vop3cx_dpp8_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lt_u16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_lt_u32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ne_i16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ne_i32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ne_u16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ne_u32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_neq_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_neq_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 310

; Checkpoint 311: vop3cx_dpp8_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nge_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nge_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ngt_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_ngt_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nle_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nle_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nlg_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s22, s57
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nlg_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s22, s57
checkpoint 311

; Checkpoint 312: vop3cx_dpp8_06
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nlt_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s22, s57
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_nlt_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s22, s57
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_o_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s22, s57
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_o_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s22, s57
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_u_f16_e64_dpp v8.h, v9.h dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s22, s57
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_cmpx_u_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s22, s57
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s22, s57
checkpoint 312

; Checkpoint 313: vop3p_plain_00
clear_results
masked_begin 313
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_dot2_f32_f16 v16, v8, v9, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_dot4_f32_bf8_bf8 v18, v8, v9, v10
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_dot4_f32_bf8_fp8 v20, v8, v9, v10
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_dot4_f32_fp8_bf8 v22, v8, v9, v10
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_dot4_f32_fp8_fp8 v24, v8, v9, v10
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_fma_mix_f32 v26, v8, v9, v10
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_fma_mixhi_f16 v28, v8, v9, v10
masked_end 313
checkpoint 313

; Checkpoint 314: vop3p_dpp16_00
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_fma_mix_f32 v16, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec -1
v_fma_mixhi_f16 v18, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
checkpoint 314

; Checkpoint 315: vop3p_dpp8_00
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_fma_mix_f32 v16, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_fma_mixlo_f16 v18, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 315


; Repartition LDS only after both waves have completed the earlier exchange.
s_barrier_signal -1
s_barrier_wait -1
; Each lane owns sixteen LDS bytes in each of two arrays, and 64 global bytes.
; Both arrays and every atomic target are initialized before observation.
s_load_b64 s[14:15], s[0:1], 32
s_wait_kmcnt 0
s_lshl_b32 s12, ttmp9, 12
s_wait_alu 0xfffe
s_add_u32 s14, s14, s12
s_addc_u32 s15, s15, 0
v_lshlrev_b32 v52, 4, v0
v_lshlrev_b32 v53, 6, v0
s_wait_alu 0xfffe
v_add_co_u32 v50, \cc, s14, v53
s_wait_alu 0xfffd
v_add_co_ci_u32 v51, \cc, s15, 0, \cc
v_or_b32 v8, 0x3f000000, v0
v_mov_b32 v9, 0x3ff00000
v_xor_b32 v10, v1, v2
v_mov_b32 v11, 0x40000000
v_xor_b32 v32, 0x12345678, v1
v_mov_b32 v33, 0x3fe00000
v_mov_b32 v34, v8
v_mov_b32 v35, v9
s_mov_b32 m0, 0
; Checkpoint 316: lds_operations_00
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_add_f32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_add_rtn_f32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 316

; Checkpoint 317: lds_operations_01
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_add_rtn_u32 v16, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_add_rtn_u64 v[24:25], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 317

; Checkpoint 318: lds_operations_02
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_add_u32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_add_u64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 318

; Checkpoint 319: lds_operations_03
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_and_b32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_and_b64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 319

; Checkpoint 320: lds_operations_04
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_and_rtn_b32 v16, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_and_rtn_b64 v[24:25], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 320

; Checkpoint 321: lds_operations_05
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
ds_cmpstore_b32 v52, v40, v41
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_cmpstore_b64 v52, v[32:33], v[34:35]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 321

; Checkpoint 322: lds_operations_06
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
ds_cmpstore_rtn_b32 v16, v52, v40, v41
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_cmpstore_rtn_b64 v[24:25], v52, v[32:33], v[34:35]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 322

; Checkpoint 323: lds_operations_07
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_cond_sub_rtn_u32 v16, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_cond_sub_u32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 323

; Checkpoint 324: lds_operations_08
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_condxchg32_rtn_b64 v[16:17], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_dec_rtn_u32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 324

; Checkpoint 325: lds_operations_09
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_dec_rtn_u64 v[16:17], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_dec_u32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 325

; Checkpoint 326: lds_operations_10
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_dec_u64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_inc_rtn_u32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 326

; Checkpoint 327: lds_operations_11
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_inc_rtn_u64 v[16:17], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_inc_u32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 327

; Checkpoint 328: lds_operations_12
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_inc_u64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_2addr_b32 v[24:25], v52 offset0:0 offset1:1
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 328

; Checkpoint 329: lds_operations_13
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_2addr_b64 v[16:19], v52 offset0:0 offset1:1
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_2addr_stride64_b32 v[24:25], v52 offset0:0 offset1:4
s_wait_dscnt 0
set_exec -1
ds_load_b64 v[28:29], v52
ds_load_b64 v[30:31], v52 offset:1024
s_wait_dscnt 0
checkpoint 329

; Checkpoint 330: lds_operations_14
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_2addr_stride64_b64 v[16:19], v52 offset0:0 offset1:2
s_wait_dscnt 0
set_exec -1
ds_load_b64 v[20:21], v52
ds_load_b64 v[22:23], v52 offset:1024
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_b128 v[24:27], v52
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 330

; Checkpoint 331: lds_operations_15
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_b32 v16, v52
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_b64 v[24:25], v52
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 331

; Checkpoint 332: lds_operations_16
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_b96 v[16:18], v52
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_i16 v24, v52
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 332

; Checkpoint 333: lds_operations_17
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_i8 v16, v52
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_i8_d16 v24, v52
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 333

; Checkpoint 334: lds_operations_18
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_i8_d16_hi v16, v52
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_u16 v24, v52
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 334

; Checkpoint 335: lds_operations_19
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_u16_d16 v16, v52
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_u16_d16_hi v24, v52
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 335

; Checkpoint 336: lds_operations_20
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_u8 v16, v52
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_u8_d16 v24, v52
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 336

; Checkpoint 337: lds_operations_21
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_load_u8_d16_hi v16, v52
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_max_i32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 337

; Checkpoint 338: lds_operations_22
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_max_i64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_max_num_f32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 338

; Checkpoint 339: lds_operations_23
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_max_num_f64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_max_num_rtn_f32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 339

; Checkpoint 340: lds_operations_24
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_max_num_rtn_f64 v[16:17], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_max_rtn_i32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 340

; Checkpoint 341: lds_operations_25
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_max_rtn_i64 v[16:17], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_max_rtn_u32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 341

; Checkpoint 342: lds_operations_26
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_max_rtn_u64 v[16:17], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_max_u32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 342

; Checkpoint 343: lds_operations_27
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_max_u64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_min_i32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 343

; Checkpoint 344: lds_operations_28
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_min_i64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_min_num_f32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 344

; Checkpoint 345: lds_operations_29
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_min_num_f64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_min_num_rtn_f32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 345

; Checkpoint 346: lds_operations_30
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_min_num_rtn_f64 v[16:17], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_min_rtn_i32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 346

; Checkpoint 347: lds_operations_31
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_min_rtn_i64 v[16:17], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_min_rtn_u32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 347

; Checkpoint 348: lds_operations_32
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_min_rtn_u64 v[16:17], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_min_u32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 348

; Checkpoint 349: lds_operations_33
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_min_u64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_mskor_b32 v52, v32, v33
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 349

; Checkpoint 350: lds_operations_34
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_mskor_b64 v52, v[32:33], v[34:35]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_mskor_rtn_b32 v24, v52, v32, v33
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 350

; Checkpoint 351: lds_operations_35
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_mskor_rtn_b64 v[16:17], v52, v[32:33], v[34:35]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_or_b32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 351

; Checkpoint 352: lds_operations_36
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_or_b64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_or_rtn_b32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 352

; Checkpoint 353: lds_operations_37
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_or_rtn_b64 v[16:17], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_pk_add_bf16 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 353

; Checkpoint 354: lds_operations_38
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_pk_add_f16 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_pk_add_rtn_bf16 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 354

; Checkpoint 355: lds_operations_39
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_pk_add_rtn_f16 v16, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_rsub_rtn_u32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 355

; Checkpoint 356: lds_operations_40
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_rsub_rtn_u64 v[16:17], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_rsub_u32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 356

; Checkpoint 357: lds_operations_41
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_rsub_u64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_store_2addr_b32 v52, v32, v33 offset0:0 offset1:1
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 357

; Checkpoint 358: lds_operations_42
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_store_2addr_b64 v52, v[32:33], v[34:35] offset0:0 offset1:1
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_store_2addr_stride64_b32 v52, v32, v33 offset0:0 offset1:4
s_wait_dscnt 0
set_exec -1
ds_load_b64 v[28:29], v52
ds_load_b64 v[30:31], v52 offset:1024
s_wait_dscnt 0
checkpoint 358

; Checkpoint 359: lds_operations_43
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_store_2addr_stride64_b64 v52, v[32:33], v[34:35] offset0:0 offset1:2
s_wait_dscnt 0
set_exec -1
ds_load_b64 v[20:21], v52
ds_load_b64 v[22:23], v52 offset:1024
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_store_b128 v52, v[32:35]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 359

; Checkpoint 360: lds_operations_44
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_store_b16 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_store_b16_d16_hi v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 360

; Checkpoint 361: lds_operations_45
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_store_b32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_store_b64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 361

; Checkpoint 362: lds_operations_46
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_store_b8 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_store_b8_d16_hi v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 362

; Checkpoint 363: lds_operations_47
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_store_b96 v52, v[32:34]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_storexchg_2addr_rtn_b32 v[24:25], v52, v32, v33 offset0:0 offset1:1
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 363

; Checkpoint 364: lds_operations_48
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_storexchg_2addr_rtn_b64 v[16:19], v52, v[32:33], v[34:35] offset0:0 offset1:1
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_storexchg_2addr_stride64_rtn_b32 v[24:25], v52, v32, v33 offset0:0 offset1:4
s_wait_dscnt 0
set_exec -1
ds_load_b64 v[28:29], v52
ds_load_b64 v[30:31], v52 offset:1024
s_wait_dscnt 0
checkpoint 364

; Checkpoint 365: lds_operations_49
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_storexchg_2addr_stride64_rtn_b64 v[16:19], v52, v[32:33], v[34:35] offset0:0 offset1:2
s_wait_dscnt 0
set_exec -1
ds_load_b64 v[20:21], v52
ds_load_b64 v[22:23], v52 offset:1024
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_storexchg_rtn_b32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 365

; Checkpoint 366: lds_operations_50
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_storexchg_rtn_b64 v[16:17], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_sub_clamp_rtn_u32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 366

; Checkpoint 367: lds_operations_51
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_sub_clamp_u32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_sub_rtn_u32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 367

; Checkpoint 368: lds_operations_52
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_sub_rtn_u64 v[16:17], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_sub_u32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 368

; Checkpoint 369: lds_operations_53
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_sub_u64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_xor_b32 v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 369

; Checkpoint 370: lds_operations_54
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_xor_b64 v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_xor_rtn_b32 v24, v52, v32
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[28:31], v52
s_wait_dscnt 0
checkpoint 370

; Checkpoint 371: lds_operations_55
clear_results
ds_store_b128 v52, v[8:11]
ds_store_b128 v52, v[8:11] offset:1024
s_wait_dscnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_xor_rtn_b64 v[16:17], v52, v[32:33]
s_wait_dscnt 0
set_exec -1
ds_load_b128 v[20:23], v52
s_wait_dscnt 0
checkpoint 371

; Checkpoint 372: global_operations_00
gh_corner_gfx12_atomic_hints rdna4, GUITAR_HERO_WAVE_SIZE
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_add_f32 v16, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_add_u32 v24, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 372

; Checkpoint 373: global_operations_01
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_add_u64 v[16:17], v53, v[32:33], s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_and_b32 v24, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 373

; Checkpoint 374: global_operations_02
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_and_b64 v[16:17], v53, v[32:33], s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
global_atomic_cmpswap_b32 v24, v53, v[40:41], s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 374

; Checkpoint 375: global_operations_03
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_cmpswap_b64 v[16:17], v53, v[32:35], s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_cond_sub_u32 v24, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 375

; Checkpoint 376: global_operations_04
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_dec_u32 v16, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_dec_u64 v[24:25], v53, v[32:33], s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 376

; Checkpoint 377: global_operations_05
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_inc_u32 v16, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_inc_u64 v[24:25], v53, v[32:33], s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 377

; Checkpoint 378: global_operations_06
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_max_i32 v16, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_max_i64 v[24:25], v53, v[32:33], s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 378

; Checkpoint 379: global_operations_07
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_max_num_f32 v16, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_max_u32 v24, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 379

; Checkpoint 380: global_operations_08
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_max_u64 v[16:17], v53, v[32:33], s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_min_i32 v24, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 380

; Checkpoint 381: global_operations_09
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_min_i64 v[16:17], v53, v[32:33], s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_min_num_f32 v24, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 381

; Checkpoint 382: global_operations_10
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_min_u32 v16, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_min_u64 v[24:25], v53, v[32:33], s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 382

; Checkpoint 383: global_operations_11
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_or_b32 v16, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_or_b64 v[24:25], v53, v[32:33], s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 383

; Checkpoint 384: global_operations_12
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_pk_add_bf16 v16, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_pk_add_f16 v24, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 384

; Checkpoint 385: global_operations_13
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_sub_clamp_u32 v16, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_sub_u32 v24, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 385

; Checkpoint 386: global_operations_14
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_sub_u64 v[16:17], v53, v[32:33], s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_swap_b32 v24, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 386

; Checkpoint 387: global_operations_15
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_swap_b64 v[16:17], v53, v[32:33], s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_xor_b32 v24, v53, v32, s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 387

; Checkpoint 388: global_operations_16
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_xor_b64 v[16:17], v53, v[32:33], s[14:15] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_load_b128 v[24:27], v53, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 388

; Checkpoint 389: global_operations_17
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_load_b32 v16, v53, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_load_b64 v[24:25], v53, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 389

; Checkpoint 390: global_operations_18
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_load_b96 v[16:18], v53, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_load_d16_b16 v24, v53, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 390

; Checkpoint 391: global_operations_19
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_load_d16_hi_b16 v16, v53, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_load_d16_hi_i8 v24, v53, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 391

; Checkpoint 392: global_operations_20
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_load_d16_hi_u8 v16, v53, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_load_d16_i8 v24, v53, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 392

; Checkpoint 393: global_operations_21
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_load_d16_u8 v16, v53, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_load_i16 v24, v53, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 393

; Checkpoint 394: global_operations_22
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_load_i8 v16, v53, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_load_u16 v24, v53, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 394

; Checkpoint 395: global_operations_23
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_load_u8 v16, v53, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_store_b128 v53, v[32:35], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 395

; Checkpoint 396: global_operations_24
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_store_b16 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_store_b32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 396

; Checkpoint 397: global_operations_25
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_store_b64 v53, v[32:33], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_store_b8 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 397

; Checkpoint 398: global_operations_26
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_store_b96 v53, v[32:34], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_store_d16_hi_b16 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 398

; Checkpoint 399: global_operations_27
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_store_d16_hi_b8 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 399

; Checkpoint 400: global_no_return_00
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_add_f32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_add_u32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 400

; Checkpoint 401: global_no_return_01
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_add_u64 v53, v[32:33], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_and_b32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 401

; Checkpoint 402: global_no_return_02
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_and_b64 v53, v[32:33], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
global_atomic_cmpswap_b32 v53, v[40:41], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 402

; Checkpoint 403: global_no_return_03
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_cmpswap_b64 v53, v[32:35], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_cond_sub_u32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 403

; Checkpoint 404: global_no_return_04
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_dec_u32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_dec_u64 v53, v[32:33], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 404

; Checkpoint 405: global_no_return_05
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_inc_u32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_inc_u64 v53, v[32:33], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 405

; Checkpoint 406: global_no_return_06
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_max_i32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_max_i64 v53, v[32:33], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 406

; Checkpoint 407: global_no_return_07
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_max_num_f32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_max_u32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 407

; Checkpoint 408: global_no_return_08
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_max_u64 v53, v[32:33], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_min_i32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 408

; Checkpoint 409: global_no_return_09
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_min_i64 v53, v[32:33], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_min_num_f32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 409

; Checkpoint 410: global_no_return_10
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_min_u32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_min_u64 v53, v[32:33], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 410

; Checkpoint 411: global_no_return_11
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_or_b32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_or_b64 v53, v[32:33], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 411

; Checkpoint 412: global_no_return_12
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_pk_add_bf16 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_pk_add_f16 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 412

; Checkpoint 413: global_no_return_13
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_sub_clamp_u32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_sub_u32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 413

; Checkpoint 414: global_no_return_14
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_sub_u64 v53, v[32:33], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_swap_b32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 414

; Checkpoint 415: global_no_return_15
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_swap_b64 v53, v[32:33], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_xor_b32 v53, v32, s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 415

; Checkpoint 416: global_no_return_16
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_atomic_xor_b64 v53, v[32:33], s[14:15]
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 416

; Checkpoint 417: flat_operations_00
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_add_f32 v16, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_add_u32 v24, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 417

; Checkpoint 418: flat_operations_01
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_add_u64 v[16:17], v[50:51], v[32:33] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_and_b32 v24, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 418

; Checkpoint 419: flat_operations_02
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_and_b64 v[16:17], v[50:51], v[32:33] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
flat_atomic_cmpswap_b32 v24, v[50:51], v[40:41] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 419

; Checkpoint 420: flat_operations_03
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_cmpswap_b64 v[16:17], v[50:51], v[32:35] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_cond_sub_u32 v24, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 420

; Checkpoint 421: flat_operations_04
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_dec_u32 v16, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_dec_u64 v[24:25], v[50:51], v[32:33] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 421

; Checkpoint 422: flat_operations_05
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_inc_u32 v16, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_inc_u64 v[24:25], v[50:51], v[32:33] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 422

; Checkpoint 423: flat_operations_06
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_max_i32 v16, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_max_i64 v[24:25], v[50:51], v[32:33] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 423

; Checkpoint 424: flat_operations_07
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_max_num_f32 v16, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_max_u32 v24, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 424

; Checkpoint 425: flat_operations_08
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_max_u64 v[16:17], v[50:51], v[32:33] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_min_i32 v24, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 425

; Checkpoint 426: flat_operations_09
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_min_i64 v[16:17], v[50:51], v[32:33] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_min_num_f32 v24, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 426

; Checkpoint 427: flat_operations_10
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_min_u32 v16, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_min_u64 v[24:25], v[50:51], v[32:33] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 427

; Checkpoint 428: flat_operations_11
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_or_b32 v16, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_or_b64 v[24:25], v[50:51], v[32:33] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 428

; Checkpoint 429: flat_operations_12
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_pk_add_bf16 v16, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_pk_add_f16 v24, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 429

; Checkpoint 430: flat_operations_13
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_sub_clamp_u32 v16, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_sub_u32 v24, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 430

; Checkpoint 431: flat_operations_14
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_sub_u64 v[16:17], v[50:51], v[32:33] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_swap_b32 v24, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 431

; Checkpoint 432: flat_operations_15
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_swap_b64 v[16:17], v[50:51], v[32:33] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_xor_b32 v24, v[50:51], v32 th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 432

; Checkpoint 433: flat_operations_16
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_xor_b64 v[16:17], v[50:51], v[32:33] th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_b128 v[24:27], v[50:51]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 433

; Checkpoint 434: flat_operations_17
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_b32 v16, v[50:51]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_b64 v[24:25], v[50:51]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
gh_rdna4_flat_lds_corners \cc
checkpoint 434

; Checkpoint 435: flat_operations_18
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_b96 v[16:18], v[50:51]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_d16_b16 v24, v[50:51]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 435

; Checkpoint 436: flat_operations_19
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_d16_hi_b16 v16, v[50:51]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_d16_hi_i8 v24, v[50:51]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 436

; Checkpoint 437: flat_operations_20
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_d16_hi_u8 v16, v[50:51]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_d16_i8 v24, v[50:51]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 437

; Checkpoint 438: flat_operations_21
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_d16_u8 v16, v[50:51]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_i16 v24, v[50:51]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 438

; Checkpoint 439: flat_operations_22
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_i8 v16, v[50:51]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_u16 v24, v[50:51]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 439

; Checkpoint 440: flat_operations_23
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_load_u8 v16, v[50:51]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_store_b128 v[50:51], v[32:35]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 440

; Checkpoint 441: flat_operations_24
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_store_b16 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_store_b32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 441

; Checkpoint 442: flat_operations_25
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_store_b64 v[50:51], v[32:33]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_store_b8 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 442

; Checkpoint 443: flat_operations_26
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_store_b96 v[50:51], v[32:34]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_store_d16_hi_b16 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 443

; Checkpoint 444: flat_operations_27
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_store_d16_hi_b8 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 444

; Checkpoint 445: flat_no_return_00
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_add_f32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_add_u32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 445

; Checkpoint 446: flat_no_return_01
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_add_u64 v[50:51], v[32:33]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_and_b32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 446

; Checkpoint 447: flat_no_return_02
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_and_b64 v[50:51], v[32:33]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
flat_atomic_cmpswap_b32 v[50:51], v[40:41]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 447

; Checkpoint 448: flat_no_return_03
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_cmpswap_b64 v[50:51], v[32:35]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_cond_sub_u32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 448

; Checkpoint 449: flat_no_return_04
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_dec_u32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_dec_u64 v[50:51], v[32:33]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 449

; Checkpoint 450: flat_no_return_05
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_inc_u32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_inc_u64 v[50:51], v[32:33]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 450

; Checkpoint 451: flat_no_return_06
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_max_i32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_max_i64 v[50:51], v[32:33]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 451

; Checkpoint 452: flat_no_return_07
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_max_num_f32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_max_u32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 452

; Checkpoint 453: flat_no_return_08
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_max_u64 v[50:51], v[32:33]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_min_i32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 453

; Checkpoint 454: flat_no_return_09
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_min_i64 v[50:51], v[32:33]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_min_num_f32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 454

; Checkpoint 455: flat_no_return_10
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_min_u32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_min_u64 v[50:51], v[32:33]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 455

; Checkpoint 456: flat_no_return_11
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_or_b32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_or_b64 v[50:51], v[32:33]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 456

; Checkpoint 457: flat_no_return_12
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_pk_add_bf16 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_pk_add_f16 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 457

; Checkpoint 458: flat_no_return_13
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_sub_clamp_u32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_sub_u32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 458

; Checkpoint 459: flat_no_return_14
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_sub_u64 v[50:51], v[32:33]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_swap_b32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 459

; Checkpoint 460: flat_no_return_15
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_swap_b64 v[50:51], v[32:33]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_xor_b32 v[50:51], v32
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 460

; Checkpoint 461: flat_no_return_16
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
flat_atomic_xor_b64 v[50:51], v[32:33]
s_wait_loadcnt 0
s_wait_storecnt 0
s_wait_dscnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 461

s_mov_b32 s24, s14
s_mov_b32 s25, s15
s_mov_b32 s26, 4096
s_mov_b32 s27, 0x3003ffac
s_mov_b32 s28, 0
; Checkpoint 462: buffer_operations_00
gh_corner_buffer_bounds rdna4, GUITAR_HERO_WAVE_SIZE
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_b32 v16, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_b64 v[24:25], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 462

; Checkpoint 463: buffer_operations_01
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_b96 v[16:18], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_b128 v[24:27], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 463

; Checkpoint 464: buffer_operations_02
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_d16_b16 v16, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_d16_format_x v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 464

; Checkpoint 465: buffer_operations_03
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_d16_format_xy v16, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_d16_format_xyz v[24:25], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 465

; Checkpoint 466: buffer_operations_04
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_d16_format_xyzw v[16:17], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_d16_hi_b16 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 466

; Checkpoint 467: buffer_operations_05
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_d16_hi_format_x v16, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_d16_hi_i8 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 467

; Checkpoint 468: buffer_operations_06
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_d16_hi_u8 v16, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_d16_i8 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 468

; Checkpoint 469: buffer_operations_07
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_d16_u8 v16, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_format_x v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 469

; Checkpoint 470: buffer_operations_08
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_format_xy v[16:17], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_format_xyz v[24:26], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 470

; Checkpoint 471: buffer_operations_09
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_format_xyzw v[16:19], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_i8 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 471

; Checkpoint 472: buffer_operations_10
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_i16 v16, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_u8 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 472

; Checkpoint 473: buffer_operations_11
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_load_u16 v16, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_b8 v32, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 473

; Checkpoint 474: buffer_operations_12
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_b16 v32, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_b32 v32, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 474

; Checkpoint 475: buffer_operations_13
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_b64 v[32:33], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_b96 v[32:34], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 475

; Checkpoint 476: buffer_operations_14
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_b128 v[32:35], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_d16_format_x v32, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 476

; Checkpoint 477: buffer_operations_15
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_d16_format_xy v32, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_d16_format_xyz v[32:33], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 477

; Checkpoint 478: buffer_operations_16
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_d16_format_xyzw v[32:33], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_d16_hi_b8 v32, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 478

; Checkpoint 479: buffer_operations_17
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_d16_hi_b16 v32, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_d16_hi_format_x v32, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 479

; Checkpoint 480: buffer_operations_18
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_format_x v32, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_format_xy v[32:33], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 480

; Checkpoint 481: buffer_operations_19
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_format_xyz v[32:34], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_store_format_xyzw v[32:35], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 481

; Checkpoint 482: buffer_operations_20
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_pk_add_f16 v16, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_pk_add_bf16 v24, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 482

; Checkpoint 483: buffer_operations_21
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_add_f32 v16, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_add_u32 v24, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 483

; Checkpoint 484: buffer_operations_22
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_add_u64 v[16:17], v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_and_b32 v24, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 484

; Checkpoint 485: buffer_operations_23
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_and_b64 v[16:17], v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
v_mov_b32 v24, v40
v_mov_b32 v25, v41
buffer_atomic_cmpswap_b32 v[24:25], v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 485

; Checkpoint 486: buffer_operations_24
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_cmpswap_b64 v[16:19], v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_sub_clamp_u32 v24, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 486

; Checkpoint 487: buffer_operations_25
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_cond_sub_u32 v16, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_dec_u32 v24, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 487

; Checkpoint 488: buffer_operations_26
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_dec_u64 v[16:17], v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_inc_u32 v24, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 488

; Checkpoint 489: buffer_operations_27
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_inc_u64 v[16:17], v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_max_num_f32 v24, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 489

; Checkpoint 490: buffer_operations_28
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_max_i32 v16, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_max_i64 v[24:25], v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 490

; Checkpoint 491: buffer_operations_29
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_max_u32 v16, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_max_u64 v[24:25], v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 491

; Checkpoint 492: buffer_operations_30
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_min_num_f32 v16, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_min_i32 v24, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 492

; Checkpoint 493: buffer_operations_31
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_min_i64 v[16:17], v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_min_u32 v24, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 493

; Checkpoint 494: buffer_operations_32
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_min_u64 v[16:17], v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_or_b32 v24, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 494

; Checkpoint 495: buffer_operations_33
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_or_b64 v[16:17], v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_sub_u32 v24, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 495

; Checkpoint 496: buffer_operations_34
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_sub_u64 v[16:17], v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_swap_b32 v24, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 496

; Checkpoint 497: buffer_operations_35
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_swap_b64 v[16:17], v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_xor_b32 v24, v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 497

; Checkpoint 498: buffer_operations_36
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_xor_b64 v[16:17], v53, s[24:27], s28 offen th:TH_ATOMIC_RETURN
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_load_d16_format_x v24, v53, s[24:27], s28 format:[BUF_FMT_8_UNORM] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 498

; Checkpoint 499: buffer_operations_37
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_load_d16_format_xy v16, v53, s[24:27], s28 format:[BUF_FMT_8_SINT] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_load_d16_format_xyz v[24:25], v53, s[24:27], s28 format:[BUF_FMT_16_UINT] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 499

; Checkpoint 500: buffer_operations_38
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_load_d16_format_xyzw v[16:17], v53, s[24:27], s28 format:[BUF_FMT_8_8_USCALED] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_load_format_x v24, v53, s[24:27], s28 format:[BUF_FMT_32_SINT] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 500

; Checkpoint 501: buffer_operations_39
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_load_format_xy v[16:17], v53, s[24:27], s28 format:[BUF_FMT_16_16_SSCALED] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_load_format_xyz v[24:26], v53, s[24:27], s28 format:[BUF_FMT_11_11_10_FLOAT] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 501

; Checkpoint 502: buffer_operations_40
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_load_format_xyzw v[16:19], v53, s[24:27], s28 format:[BUF_FMT_2_10_10_10_UNORM] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_store_d16_format_x v32, v53, s[24:27], s28 format:[BUF_FMT_2_10_10_10_SINT] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 502

; Checkpoint 503: buffer_operations_41
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_store_d16_format_xy v32, v53, s[24:27], s28 format:[BUF_FMT_8_8_8_8_UINT] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_store_d16_format_xyz v[32:33], v53, s[24:27], s28 format:[BUF_FMT_16_16_16_16_UNORM] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 503

; Checkpoint 504: buffer_operations_42
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_store_d16_format_xyzw v[32:33], v53, s[24:27], s28 format:[BUF_FMT_16_16_16_16_SINT] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_store_format_x v32, v53, s[24:27], s28 format:[BUF_FMT_32_32_32_32_UINT] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 504

; Checkpoint 505: buffer_operations_43
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_store_format_xy v[32:33], v53, s[24:27], s28 format:[BUF_FMT_16_UNORM] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_store_format_xyz v[32:34], v53, s[24:27], s28 format:[BUF_FMT_32_FLOAT] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 505

; Checkpoint 506: buffer_operations_44
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
tbuffer_store_format_xyzw v[32:35], v53, s[24:27], s28 format:[BUF_FMT_2_10_10_10_SNORM] offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 506

; Checkpoint 507: buffer_no_return_00
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_pk_add_f16 v16, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_pk_add_bf16 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 507

; Checkpoint 508: buffer_no_return_01
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_add_f32 v16, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_add_u32 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 508

; Checkpoint 509: buffer_no_return_02
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_add_u64 v[16:17], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_and_b32 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 509

; Checkpoint 510: buffer_no_return_03
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_and_b64 v[16:17], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
v_mov_b32 v24, v40
v_mov_b32 v25, v41
buffer_atomic_cmpswap_b32 v[24:25], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 510

; Checkpoint 511: buffer_no_return_04
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_cmpswap_b64 v[16:19], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_sub_clamp_u32 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 511

; Checkpoint 512: buffer_no_return_05
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_cond_sub_u32 v16, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_dec_u32 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 512

; Checkpoint 513: buffer_no_return_06
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_dec_u64 v[16:17], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_inc_u32 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 513

; Checkpoint 514: buffer_no_return_07
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_inc_u64 v[16:17], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_max_num_f32 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 514

; Checkpoint 515: buffer_no_return_08
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_max_i32 v16, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_max_i64 v[24:25], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 515

; Checkpoint 516: buffer_no_return_09
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_max_u32 v16, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_max_u64 v[24:25], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 516

; Checkpoint 517: buffer_no_return_10
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_min_num_f32 v16, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_min_i32 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 517

; Checkpoint 518: buffer_no_return_11
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_min_i64 v[16:17], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_min_u32 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 518

; Checkpoint 519: buffer_no_return_12
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_min_u64 v[16:17], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_or_b32 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 519

; Checkpoint 520: buffer_no_return_13
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_or_b64 v[16:17], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_sub_u32 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 520

; Checkpoint 521: buffer_no_return_14
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_sub_u64 v[16:17], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_swap_b32 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 521

; Checkpoint 522: buffer_no_return_15
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_swap_b64 v[16:17], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_xor_b32 v24, v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[28:31], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 522

; Checkpoint 523: buffer_no_return_16
clear_results
global_store_b128 v53, v[8:11], s[14:15]
s_wait_storecnt 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
set_exec 0xa5a55a5a, 0x5a5aa5a5
buffer_atomic_xor_b64 v[16:17], v53, s[24:27], s28 offen
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
global_load_b128 v[20:23], v53, s[14:15]
s_wait_loadcnt 0
checkpoint 523

; Checkpoint 524: scalar_sop1_00
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cvt_f32_i32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cvt_f32_u32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cvt_u32_f32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cvt_i32_f32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 524

; Checkpoint 525: scalar_sop1_01
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cvt_f16_f32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cvt_f32_f16 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cvt_hi_f32_f16 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_trunc_f32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 525

; Checkpoint 526: scalar_sop1_02
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_ceil_f32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_rndne_f32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_floor_f32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_floor_f16 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 526

; Checkpoint 527: scalar_sop1_03
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_ceil_f16 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_trunc_f16 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_rndne_f16 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_mov_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 527

; Checkpoint 528: scalar_sop1_04
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_mov_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmov_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmov_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_not_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 528

; Checkpoint 529: scalar_sop1_05
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_not_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_wqm_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_wqm_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_brev_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 529

; Checkpoint 530: scalar_sop1_06
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_brev_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bcnt0_i32_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bcnt0_i32_b64 s16, s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bcnt1_i32_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 530

; Checkpoint 531: scalar_sop1_07
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bcnt1_i32_b64 s16, s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_ff1_i32_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_ff1_i32_b64 s16, s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_flbit_i32_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 531

; Checkpoint 532: scalar_sop1_08
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_flbit_i32_b64 s16, s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_flbit_i32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_flbit_i32_i64 s16, s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_sext_i32_i8 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 532

; Checkpoint 533: scalar_sop1_09
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_sext_i32_i16 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bitset0_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bitset0_b64 s[16:17], s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bitset1_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 533

; Checkpoint 534: scalar_sop1_10
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bitset1_b64 s[16:17], s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_and_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_or_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_xor_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 534

; Checkpoint 535: scalar_sop1_11
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_andn2_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_orn2_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_nand_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_nor_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 535

; Checkpoint 536: scalar_sop1_12
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_xnor_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_quadmask_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_quadmask_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_movrels_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 536

; Checkpoint 537: scalar_sop1_13
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_movrels_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_movreld_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_movreld_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_abs_i32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 537

; Checkpoint 538: scalar_sop1_14
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_andn1_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_orn1_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_andn1_wrexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_andn2_wrexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 538

; Checkpoint 539: scalar_sop1_15
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bitreplicate_b64_b32 s[16:17], s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_and_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_or_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_xor_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 539

; Checkpoint 540: scalar_sop1_16
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_andn2_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_orn2_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_nand_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_nor_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 540

; Checkpoint 541: scalar_sop1_17
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_xnor_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_andn1_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_orn1_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_andn1_wrexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 541

; Checkpoint 542: scalar_sop1_18
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s25, 0
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_andn2_wrexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_movrelsd_2_b32 s16, s24
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
checkpoint 542

; Checkpoint 543: scalar_sop2_00
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_add_nc_u64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_sub_nc_u64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_mul_u64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_add_f32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 543

; Checkpoint 544: scalar_sop2_01
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_sub_f32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_mul_f32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_min_num_f32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_max_num_f32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 544

; Checkpoint 545: scalar_sop2_02
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_minimum_f32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_maximum_f32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_fmac_f32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_fmamk_f32 s16, s24, 0x11213141, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 545

; Checkpoint 546: scalar_sop2_03
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_fmaak_f32 s16, s24, s26, 0x11213141
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cvt_pk_rtz_f16_f32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_add_f16 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_sub_f16 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 546

; Checkpoint 547: scalar_sop2_04
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_mul_f16 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_fmac_f16 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_max_num_f16 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_min_num_f16 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 547

; Checkpoint 548: scalar_sop2_05
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_maximum_f16 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_minimum_f16 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_add_co_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_sub_co_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 548

; Checkpoint 549: scalar_sop2_06
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_add_co_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_sub_co_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_add_co_ci_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_sub_co_ci_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 549

; Checkpoint 550: scalar_sop2_07
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_min_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_min_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_max_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_max_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 550

; Checkpoint 551: scalar_sop2_08
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cselect_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cselect_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_and_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_and_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 551

; Checkpoint 552: scalar_sop2_09
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_or_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_or_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_xor_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_xor_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 552

; Checkpoint 553: scalar_sop2_10
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_andn2_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_andn2_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_orn2_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_orn2_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 553

; Checkpoint 554: scalar_sop2_11
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_nand_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_nand_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_nor_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_nor_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 554

; Checkpoint 555: scalar_sop2_12
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_xnor_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_xnor_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_lshl_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_lshl_b64 s[16:17], s[24:25], s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 555

; Checkpoint 556: scalar_sop2_13
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_lshr_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_lshr_b64 s[16:17], s[24:25], s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_ashr_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_ashr_i64 s[16:17], s[24:25], s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 556

; Checkpoint 557: scalar_sop2_14
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bfm_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bfm_b64 s[16:17], s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_mul_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bfe_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 557

; Checkpoint 558: scalar_sop2_15
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bfe_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bfe_u64 s[16:17], s[24:25], s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bfe_i64 s[16:17], s[24:25], s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_absdiff_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 558

; Checkpoint 559: scalar_sop2_16
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_lshl1_add_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_lshl2_add_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_lshl3_add_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_lshl4_add_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 559

; Checkpoint 560: scalar_sop2_17
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_pack_ll_b32_b16 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_pack_lh_b32_b16 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_pack_hh_b32_b16 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_mul_hi_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 560

; Checkpoint 561: scalar_sop2_18
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_mul_hi_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_pack_hl_b32_b16 s16, s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
s_wait_alu 0xfffe
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
mask_result v23, s21, s56
checkpoint 561

; Checkpoint 562: scalar_sopc_00
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_lt_f32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
s_wait_alu 0xfffe
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_eq_f32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
s_wait_alu 0xfffe
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_le_f32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
s_wait_alu 0xfffe
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_gt_f32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
s_wait_alu 0xfffe
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 562

; Checkpoint 563: scalar_sopc_01
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_lg_f32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
s_wait_alu 0xfffe
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_ge_f32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
s_wait_alu 0xfffe
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_o_f32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
s_wait_alu 0xfffe
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_u_f32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
s_wait_alu 0xfffe
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 563

; Checkpoint 564: scalar_sopc_02
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_nge_f32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
s_wait_alu 0xfffe
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_nlg_f32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
s_wait_alu 0xfffe
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_ngt_f32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
s_wait_alu 0xfffe
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_nle_f32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
s_wait_alu 0xfffe
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 564

; Checkpoint 565: scalar_sopc_03
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_neq_f32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
s_wait_alu 0xfffe
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_nlt_f32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
s_wait_alu 0xfffe
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_lt_f16 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
s_wait_alu 0xfffe
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_eq_f16 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
s_wait_alu 0xfffe
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 565

; Checkpoint 566: scalar_sopc_04
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_le_f16 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
s_wait_alu 0xfffe
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_gt_f16 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
s_wait_alu 0xfffe
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_lg_f16 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
s_wait_alu 0xfffe
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_ge_f16 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
s_wait_alu 0xfffe
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 566

; Checkpoint 567: scalar_sopc_05
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_o_f16 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
s_wait_alu 0xfffe
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_u_f16 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
s_wait_alu 0xfffe
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_nge_f16 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
s_wait_alu 0xfffe
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_nlg_f16 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
s_wait_alu 0xfffe
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 567

; Checkpoint 568: scalar_sopc_06
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_ngt_f16 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
s_wait_alu 0xfffe
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_nle_f16 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
s_wait_alu 0xfffe
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_neq_f16 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
s_wait_alu 0xfffe
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_mov_b32 s16, 0x3f000000
s_mov_b32 s24, 0x3fa00000
s_mov_b32 s26, 0xc0200000
s_mov_b32 s24, 0x3d00
s_mov_b32 s26, 0xc100
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_nlt_f16 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
s_wait_alu 0xfffe
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 568

; Checkpoint 569: scalar_sopc_07
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_eq_i32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
s_wait_alu 0xfffe
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_lg_i32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
s_wait_alu 0xfffe
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_gt_i32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
s_wait_alu 0xfffe
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_ge_i32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
s_wait_alu 0xfffe
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 569

; Checkpoint 570: scalar_sopc_08
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_lt_i32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
s_wait_alu 0xfffe
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_le_i32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
s_wait_alu 0xfffe
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_eq_u32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
s_wait_alu 0xfffe
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_lg_u32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
s_wait_alu 0xfffe
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 570

; Checkpoint 571: scalar_sopc_09
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_gt_u32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
s_wait_alu 0xfffe
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_ge_u32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
s_wait_alu 0xfffe
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_lt_u32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
s_wait_alu 0xfffe
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_le_u32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
s_wait_alu 0xfffe
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 571

; Checkpoint 572: scalar_sopc_10
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bitcmp0_b32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
s_wait_alu 0xfffe
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bitcmp1_b32 s24, s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
s_wait_alu 0xfffe
v_mov_b32 v22, s22
mask_result v23, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bitcmp0_b64 s[24:25], s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
s_wait_alu 0xfffe
v_mov_b32 v26, s22
mask_result v27, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_bitcmp1_b64 s[24:25], s26
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
s_wait_alu 0xfffe
v_mov_b32 v30, s22
mask_result v31, s21, s56
checkpoint 572

; Checkpoint 573: scalar_sopc_11
clear_results
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_eq_u64 s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
s_wait_alu 0xfffe
v_mov_b32 v18, s22
mask_result v19, s21, s56
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wait_alu 0xfffe
s_cmp_lg_u64 s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
save_exec_mask s21, s56
set_exec -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
s_wait_alu 0xfffe
v_mov_b32 v22, s22
mask_result v23, s21, s56
checkpoint 573

; Checkpoint 574: comparex_f64_e32
clear_results
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_mov_b32 v12, 0x3ff
v_cmpx_lt_f64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s20, s55
v_cmpx_eq_f64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v17, s20, s55
v_cmpx_le_f64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s20, s55
v_cmpx_gt_f64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v19, s20, s55
v_cmpx_lg_f64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s20, s55
v_cmpx_ge_f64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v21, s20, s55
v_cmpx_o_f64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s20, s55
v_cmpx_u_f64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v23, s20, s55
v_cmpx_nge_f64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s20, s55
v_cmpx_nlg_f64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v25, s20, s55
v_cmpx_ngt_f64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s20, s55
v_cmpx_nle_f64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v27, s20, s55
v_cmpx_neq_f64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s20, s55
v_cmpx_nlt_f64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v29, s20, s55
v_cmpx_class_f64_e32 v[8:9], v12
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s20, s55
checkpoint 574

; Checkpoint 575: comparex_i64_e32
clear_results
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_mov_b32 v12, 0x3ff
v_cmpx_lt_i64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s20, s55
v_cmpx_eq_i64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v17, s20, s55
v_cmpx_le_i64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s20, s55
v_cmpx_gt_i64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v19, s20, s55
v_cmpx_ne_i64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s20, s55
v_cmpx_ge_i64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v21, s20, s55
checkpoint 575

; Checkpoint 576: comparex_u64_e32
clear_results
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_mov_b32 v12, 0x3ff
v_cmpx_lt_u64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s20, s55
v_cmpx_eq_u64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v17, s20, s55
v_cmpx_le_u64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s20, s55
v_cmpx_gt_u64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v19, s20, s55
v_cmpx_ne_u64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s20, s55
v_cmpx_ge_u64_e32 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v21, s20, s55
checkpoint 576

; Checkpoint 577: comparex_f64_e64
clear_results
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_mov_b32 v12, 0x3ff
v_cmpx_lt_f64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s20, s55
v_cmpx_eq_f64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v17, s20, s55
v_cmpx_le_f64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s20, s55
v_cmpx_gt_f64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v19, s20, s55
v_cmpx_lg_f64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s20, s55
v_cmpx_ge_f64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v21, s20, s55
v_cmpx_o_f64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v22, s20, s55
v_cmpx_u_f64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v23, s20, s55
v_cmpx_nge_f64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v24, s20, s55
v_cmpx_nlg_f64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v25, s20, s55
v_cmpx_ngt_f64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v26, s20, s55
v_cmpx_nle_f64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v27, s20, s55
v_cmpx_neq_f64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v28, s20, s55
v_cmpx_nlt_f64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v29, s20, s55
v_cmpx_class_f64_e64 v[8:9], v12
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v30, s20, s55
checkpoint 577

; Checkpoint 578: comparex_i64_e64
clear_results
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_mov_b32 v12, 0x3ff
v_cmpx_lt_i64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s20, s55
v_cmpx_eq_i64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v17, s20, s55
v_cmpx_le_i64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s20, s55
v_cmpx_gt_i64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v19, s20, s55
v_cmpx_ne_i64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s20, s55
v_cmpx_ge_i64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v21, s20, s55
checkpoint 578

; Checkpoint 579: comparex_u64_e64
clear_results
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_mov_b32 v12, 0x3ff
v_cmpx_lt_u64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v16, s20, s55
v_cmpx_eq_u64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v17, s20, s55
v_cmpx_le_u64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v18, s20, s55
v_cmpx_gt_u64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v19, s20, s55
v_cmpx_ne_u64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v20, s20, s55
v_cmpx_ge_u64_e64 v[8:9], v[10:11]
save_exec_mask s20, s55
set_exec -1
wait_wave32_alu 0xfffe
mask_result v21, s20, s55
checkpoint 579

; Checkpoint 580: packed_complete_0_00
clear_results
masked_begin 580
v_or_b32 v8, 0x3c003800, v0
v_mov_b32 v9, 0xc0003e00
v_mov_b32 v10, 0x3800bc00
v_pk_add_f16 v16, v8, v9
v_pk_add_i16 v17, v8, v9
v_pk_add_u16 v18, v8, v9
v_pk_ashrrev_i16 v19, v8, v9
v_pk_fma_f16 v20, v8, v9, v10
v_pk_lshlrev_b16 v21, v8, v9
v_pk_lshrrev_b16 v22, v8, v9
v_pk_mad_i16 v23, v8, v9, v10
v_pk_mad_u16 v24, v8, v9, v10
v_pk_max_i16 v25, v8, v9
v_pk_max_num_f16 v26, v8, v9
v_pk_max_u16 v27, v8, v9
v_pk_maximum_f16 v28, v8, v9
v_pk_min_i16 v29, v8, v9
v_pk_min_num_f16 v30, v8, v9
v_pk_min_u16 v31, v8, v9
masked_end 580
checkpoint 580

; Checkpoint 581: packed_complete_0_01
clear_results
masked_begin 581
v_or_b32 v8, 0x3c003800, v0
v_mov_b32 v9, 0xc0003e00
v_mov_b32 v10, 0x3800bc00
v_pk_minimum_f16 v16, v8, v9
v_pk_mul_f16 v17, v8, v9
v_pk_mul_lo_u16 v18, v8, v9
v_pk_sub_i16 v19, v8, v9
v_pk_sub_u16 v20, v8, v9
v_pk_fmac_f16 v21, v8, v9
masked_end 581
checkpoint 581

; Checkpoint 582: packed_complete_1_00
clear_results
masked_begin 582
v_or_b32 v8, 0x3c003800, v0
v_mov_b32 v9, 0xc0003e00
v_mov_b32 v10, 0x3800bc00
v_pk_add_f16 v16, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] neg_lo:[1,1] neg_hi:[0,0] clamp
v_pk_add_i16 v17, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] clamp
v_pk_add_u16 v18, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] clamp
v_pk_ashrrev_i16 v19, v8, v9 op_sel:[0,1] op_sel_hi:[1,0]
v_pk_fma_f16 v20, v8, v9, v10 op_sel:[0,1,0] op_sel_hi:[1,0,1] neg_lo:[1,1,1] neg_hi:[0,0,0] clamp
v_pk_lshlrev_b16 v21, v8, v9 op_sel:[0,1] op_sel_hi:[1,0]
v_pk_lshrrev_b16 v22, v8, v9 op_sel:[0,1] op_sel_hi:[1,0]
v_pk_mad_i16 v23, v8, v9, v10 op_sel:[0,1,0] op_sel_hi:[1,0,1] clamp
v_pk_mad_u16 v24, v8, v9, v10 op_sel:[0,1,0] op_sel_hi:[1,0,1] clamp
v_pk_max_i16 v25, v8, v9 op_sel:[0,1] op_sel_hi:[1,0]
v_pk_max_num_f16 v26, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] neg_lo:[1,1] neg_hi:[0,0] clamp
v_pk_max_u16 v27, v8, v9 op_sel:[0,1] op_sel_hi:[1,0]
v_pk_maximum_f16 v28, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] neg_lo:[1,1] neg_hi:[0,0] clamp
v_pk_min_i16 v29, v8, v9 op_sel:[0,1] op_sel_hi:[1,0]
v_pk_min_num_f16 v30, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] neg_lo:[1,1] neg_hi:[0,0] clamp
v_pk_min_u16 v31, v8, v9 op_sel:[0,1] op_sel_hi:[1,0]
masked_end 582
checkpoint 582

; Checkpoint 583: packed_complete_1_01
clear_results
masked_begin 583
v_or_b32 v8, 0x3c003800, v0
v_mov_b32 v9, 0xc0003e00
v_mov_b32 v10, 0x3800bc00
v_pk_minimum_f16 v16, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] neg_lo:[1,1] neg_hi:[0,0] clamp
v_pk_mul_f16 v17, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] neg_lo:[1,1] neg_hi:[0,0] clamp
v_pk_mul_lo_u16 v18, v8, v9 op_sel:[0,1] op_sel_hi:[1,0]
v_pk_sub_i16 v19, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] clamp
v_pk_sub_u16 v20, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] clamp
v_pk_fmac_f16 v21, v8, v9
masked_end 583
checkpoint 583

; Checkpoint 584: private_memory_00
gh_corner_signed_scratch rdna4, GUITAR_HERO_WAVE_SIZE
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_load_b128 v[16:19], off, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[20:23], off, off
s_wait_loadcnt 0
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_load_b32 v24, off, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[28:31], off, off
s_wait_loadcnt 0
checkpoint 584

; Checkpoint 585: private_memory_01
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_load_b64 v[16:17], off, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[20:23], off, off
s_wait_loadcnt 0
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_load_b96 v[24:26], off, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[28:31], off, off
s_wait_loadcnt 0
checkpoint 585

; Checkpoint 586: private_memory_02
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_load_d16_b16 v16, off, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[20:23], off, off
s_wait_loadcnt 0
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_load_d16_hi_b16 v24, off, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[28:31], off, off
s_wait_loadcnt 0
checkpoint 586

; Checkpoint 587: private_memory_03
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_load_d16_hi_i8 v16, off, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[20:23], off, off
s_wait_loadcnt 0
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_load_d16_hi_u8 v24, off, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[28:31], off, off
s_wait_loadcnt 0
checkpoint 587

; Checkpoint 588: private_memory_04
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_load_d16_i8 v16, off, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[20:23], off, off
s_wait_loadcnt 0
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_load_d16_u8 v24, off, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[28:31], off, off
s_wait_loadcnt 0
checkpoint 588

; Checkpoint 589: private_memory_05
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_load_i16 v16, off, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[20:23], off, off
s_wait_loadcnt 0
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_load_i8 v24, off, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[28:31], off, off
s_wait_loadcnt 0
checkpoint 589

; Checkpoint 590: private_memory_06
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_load_u16 v16, off, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[20:23], off, off
s_wait_loadcnt 0
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_load_u8 v24, off, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[28:31], off, off
s_wait_loadcnt 0
checkpoint 590

; Checkpoint 591: private_memory_07
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_store_b128 off, v[8:11], off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[20:23], off, off
s_wait_loadcnt 0
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_store_b16 off, v8, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[28:31], off, off
s_wait_loadcnt 0
checkpoint 591

; Checkpoint 592: private_memory_08
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_store_b32 off, v8, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[20:23], off, off
s_wait_loadcnt 0
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_store_b64 off, v[8:9], off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[28:31], off, off
s_wait_loadcnt 0
checkpoint 592

; Checkpoint 593: private_memory_09
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_store_b8 off, v8, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[20:23], off, off
s_wait_loadcnt 0
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_store_b96 off, v[8:10], off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[28:31], off, off
s_wait_loadcnt 0
checkpoint 593

; Checkpoint 594: private_memory_10
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_store_d16_hi_b16 off, v8, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[20:23], off, off
s_wait_loadcnt 0
scratch_store_b128 off, v[8:11], off
s_wait_storecnt 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
scratch_store_d16_hi_b8 off, v8, off
s_wait_loadcnt 0
s_wait_storecnt 0
set_exec -1
scratch_load_b128 v[28:31], off, off
s_wait_loadcnt 0
checkpoint 594

s_load_b64 s[14:15], s[0:1], 32
s_wait_kmcnt 0
s_lshl_b32 s12, ttmp9, 12
s_wait_alu 0xfffe
s_add_u32 s14, s14, s12
s_addc_u32 s15, s15, 0
v_lshlrev_b32 v53, 6, v0
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v4
v_mov_b32 v11, v5
global_store_b128 v53, v[8:11], s[14:15] offset:0
global_store_b128 v53, v[8:11], s[14:15] offset:16
global_store_b128 v53, v[8:11], s[14:15] offset:32
global_store_b128 v53, v[8:11], s[14:15] offset:48
s_wait_storecnt 0
s_dcache_inv
; Complete scalar-cache invalidation before any dependent SMEM load.
s_wait_kmcnt 0
v_readfirstlane_b32 s28, v53
s_add_u32 s16, s14, s28
s_addc_u32 s17, s15, 0
s_wait_alu 0xfffe
s_mov_b64 s[20:21], s[16:17]
s_mov_b32 s22, 64
s_mov_b32 s23, 0x30000000
; Checkpoint 595: s_buffer_load_b128
clear_results
s_buffer_load_b128 s[32:35], s[20:23], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
v_mov_b32 v17, s33
v_mov_b32 v18, s34
v_mov_b32 v19, s35
checkpoint 595

; Checkpoint 596: s_buffer_load_b256
clear_results
s_buffer_load_b256 s[32:39], s[20:23], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
v_mov_b32 v17, s33
v_mov_b32 v18, s34
v_mov_b32 v19, s35
v_mov_b32 v20, s36
v_mov_b32 v21, s37
v_mov_b32 v22, s38
v_mov_b32 v23, s39
checkpoint 596

; Checkpoint 597: s_buffer_load_b32
clear_results
s_buffer_load_b32 s32, s[20:23], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
checkpoint 597

; Checkpoint 598: s_buffer_load_b512
clear_results
s_buffer_load_b512 s[32:47], s[20:23], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
v_mov_b32 v17, s33
v_mov_b32 v18, s34
v_mov_b32 v19, s35
v_mov_b32 v20, s36
v_mov_b32 v21, s37
v_mov_b32 v22, s38
v_mov_b32 v23, s39
v_mov_b32 v24, s40
v_mov_b32 v25, s41
v_mov_b32 v26, s42
v_mov_b32 v27, s43
v_mov_b32 v28, s44
v_mov_b32 v29, s45
v_mov_b32 v30, s46
v_mov_b32 v31, s47
checkpoint 598

; Checkpoint 599: s_buffer_load_b64
clear_results
s_buffer_load_b64 s[32:33], s[20:23], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
v_mov_b32 v17, s33
checkpoint 599

; Checkpoint 600: s_buffer_load_b96
clear_results
s_buffer_load_b96 s[32:34], s[20:23], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
v_mov_b32 v17, s33
v_mov_b32 v18, s34
checkpoint 600

; Checkpoint 601: s_buffer_load_i16
clear_results
s_buffer_load_i16 s32, s[20:23], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
checkpoint 601

; Checkpoint 602: s_buffer_load_i8
clear_results
s_buffer_load_i8 s32, s[20:23], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
checkpoint 602

; Checkpoint 603: s_buffer_load_u16
clear_results
s_buffer_load_u16 s32, s[20:23], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
checkpoint 603

; Checkpoint 604: s_buffer_load_u8
clear_results
s_buffer_load_u8 s32, s[20:23], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
checkpoint 604

; Checkpoint 605: s_load_b128
clear_results
s_load_b128 s[32:35], s[16:17], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
v_mov_b32 v17, s33
v_mov_b32 v18, s34
v_mov_b32 v19, s35
checkpoint 605

; Checkpoint 606: s_load_b256
clear_results
s_load_b256 s[32:39], s[16:17], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
v_mov_b32 v17, s33
v_mov_b32 v18, s34
v_mov_b32 v19, s35
v_mov_b32 v20, s36
v_mov_b32 v21, s37
v_mov_b32 v22, s38
v_mov_b32 v23, s39
checkpoint 606

; Checkpoint 607: s_load_b32
clear_results
s_load_b32 s32, s[16:17], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
checkpoint 607

; Checkpoint 608: s_load_b512
clear_results
s_load_b512 s[32:47], s[16:17], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
v_mov_b32 v17, s33
v_mov_b32 v18, s34
v_mov_b32 v19, s35
v_mov_b32 v20, s36
v_mov_b32 v21, s37
v_mov_b32 v22, s38
v_mov_b32 v23, s39
v_mov_b32 v24, s40
v_mov_b32 v25, s41
v_mov_b32 v26, s42
v_mov_b32 v27, s43
v_mov_b32 v28, s44
v_mov_b32 v29, s45
v_mov_b32 v30, s46
v_mov_b32 v31, s47
checkpoint 608

; Checkpoint 609: s_load_b64
clear_results
s_load_b64 s[32:33], s[16:17], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
v_mov_b32 v17, s33
checkpoint 609

; Checkpoint 610: s_load_b96
clear_results
s_load_b96 s[32:34], s[16:17], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
v_mov_b32 v17, s33
v_mov_b32 v18, s34
checkpoint 610

; Checkpoint 611: s_load_i16
clear_results
s_load_i16 s32, s[16:17], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
checkpoint 611

; Checkpoint 612: s_load_i8
clear_results
s_load_i8 s32, s[16:17], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
checkpoint 612

; Checkpoint 613: s_load_u16
clear_results
s_load_u16 s32, s[16:17], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
checkpoint 613

; Checkpoint 614: s_load_u8
clear_results
s_load_u8 s32, s[16:17], 0
s_wait_kmcnt 0
v_mov_b32 v16, s32
checkpoint 614

; Checkpoint 615: class_all_f16
v_and_b32 v12, 15, v0
v_mov_b32 v8, 31744
v_cmp_eq_u32 \cc, 0, v12
v_mov_b32 v13, 32001
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 1, v12
v_mov_b32 v13, 32257
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 2, v12
v_mov_b32 v13, 64512
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 3, v12
v_mov_b32 v13, 48128
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 4, v12
v_mov_b32 v13, 32769
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 5, v12
v_mov_b32 v13, 32768
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 6, v12
v_mov_b32 v13, 0
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 7, v12
v_mov_b32 v13, 1
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 8, v12
v_mov_b32 v13, 15360
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_mov_b32 v9, 0x3ff
clear_results
masked_begin 615
v_cmp_class_f16 \cc, v8.l, v9.l
s_mov_b32 s20, vcc_lo
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 s55, vcc_hi
.endif
wait_wave32_alu 0xfffe
mask_result v16, s20, s55
v_cmpx_class_f16 v8.l, v9.l
save_exec_mask s20, s55
wait_wave32_alu 0xfffe
mask_result v17, s20, s55
v_cmp_class_f16 \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
s_mov_b32 s20, vcc_lo
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 s55, vcc_hi
.endif
wait_wave32_alu 0xfffe
mask_result v18, s20, s55
v_cmpx_class_f16 v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
save_exec_mask s20, s55
wait_wave32_alu 0xfffe
mask_result v19, s20, s55
v_cmp_class_f16 \cc, v8.l, v9.l dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, vcc_lo
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 s55, vcc_hi
.endif
wait_wave32_alu 0xfffe
mask_result v20, s20, s55
v_cmpx_class_f16 v8.l, v9.l dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s20, s55
wait_wave32_alu 0xfffe
mask_result v21, s20, s55
v_cmp_class_f16_e64 \cc, v8.l, v9.l
s_mov_b32 s20, vcc_lo
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 s55, vcc_hi
.endif
wait_wave32_alu 0xfffe
mask_result v22, s20, s55
v_cmpx_class_f16_e64 v8.l, v9.l
save_exec_mask s20, s55
wait_wave32_alu 0xfffe
mask_result v23, s20, s55
v_cmp_class_f16_e64_dpp \cc, v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
s_mov_b32 s20, vcc_lo
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 s55, vcc_hi
.endif
wait_wave32_alu 0xfffe
mask_result v24, s20, s55
v_cmpx_class_f16_e64_dpp v8.l, v9.l row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
save_exec_mask s20, s55
wait_wave32_alu 0xfffe
mask_result v25, s20, s55
v_cmp_class_f16_e64_dpp \cc, v8.l, v9.l dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, vcc_lo
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 s55, vcc_hi
.endif
wait_wave32_alu 0xfffe
mask_result v26, s20, s55
v_cmpx_class_f16_e64_dpp v8.l, v9.l dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s20, s55
wait_wave32_alu 0xfffe
mask_result v27, s20, s55
masked_end 615
checkpoint 615

; Checkpoint 616: class_all_f32
v_and_b32 v12, 15, v0
v_mov_b32 v8, 2139095040
v_cmp_eq_u32 \cc, 0, v12
v_mov_b32 v13, 2139095041
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 1, v12
v_mov_b32 v13, 2143289345
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 2, v12
v_mov_b32 v13, 4286578688
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 3, v12
v_mov_b32 v13, 3212836864
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 4, v12
v_mov_b32 v13, 2147483649
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 5, v12
v_mov_b32 v13, 2147483648
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 6, v12
v_mov_b32 v13, 0
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 7, v12
v_mov_b32 v13, 1
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_cmp_eq_u32 \cc, 8, v12
v_mov_b32 v13, 1065353216
s_wait_alu 0xfffd
v_cndmask_b32 v8, v8, v13, \cc
v_mov_b32 v9, 0x3ff
clear_results
masked_begin 616
v_cmp_class_f32 \cc, v8, v9
s_mov_b32 s20, vcc_lo
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 s55, vcc_hi
.endif
wait_wave32_alu 0xfffe
mask_result v16, s20, s55
v_cmpx_class_f32 v8, v9
save_exec_mask s20, s55
wait_wave32_alu 0xfffe
mask_result v17, s20, s55
v_cmp_class_f32 \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
s_mov_b32 s20, vcc_lo
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 s55, vcc_hi
.endif
wait_wave32_alu 0xfffe
mask_result v18, s20, s55
v_cmpx_class_f32 v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
save_exec_mask s20, s55
wait_wave32_alu 0xfffe
mask_result v19, s20, s55
v_cmp_class_f32 \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, vcc_lo
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 s55, vcc_hi
.endif
wait_wave32_alu 0xfffe
mask_result v20, s20, s55
v_cmpx_class_f32 v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s20, s55
wait_wave32_alu 0xfffe
mask_result v21, s20, s55
v_cmp_class_f32_e64 \cc, v8, v9
s_mov_b32 s20, vcc_lo
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 s55, vcc_hi
.endif
wait_wave32_alu 0xfffe
mask_result v22, s20, s55
v_cmpx_class_f32_e64 v8, v9
save_exec_mask s20, s55
wait_wave32_alu 0xfffe
mask_result v23, s20, s55
v_cmp_class_f32_e64_dpp \cc, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
s_mov_b32 s20, vcc_lo
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 s55, vcc_hi
.endif
wait_wave32_alu 0xfffe
mask_result v24, s20, s55
v_cmpx_class_f32_e64_dpp v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
save_exec_mask s20, s55
wait_wave32_alu 0xfffe
mask_result v25, s20, s55
v_cmp_class_f32_e64_dpp \cc, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 s20, vcc_lo
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 s55, vcc_hi
.endif
wait_wave32_alu 0xfffe
mask_result v26, s20, s55
v_cmpx_class_f32_e64_dpp v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
save_exec_mask s20, s55
wait_wave32_alu 0xfffe
mask_result v27, s20, s55
masked_end 616
checkpoint 616

; Checkpoint 617: wide_conversions_e32
clear_results
masked_begin 617
v_cvt_f64_f32 v[8:9], v4
v_cvt_i32_f64_e32 v16, v[8:9]
v_cvt_f64_i32_e32 v[18:19], v1
v_cvt_f32_f64_e32 v20, v[8:9]
v_cvt_u32_f64_e32 v21, v[8:9]
v_cvt_f64_u32_e32 v[22:23], v1
v_cvt_pk_f32_fp8_e32 v[24:25], v1.l
v_cvt_pk_f32_bf8_e32 v[26:27], v2.h
v_trunc_f64_e32 v[28:29], v[8:9]
v_ceil_f64_e32 v[30:31], v[8:9]
masked_end 617
checkpoint 617

; Checkpoint 618: wide_unary_e32
clear_results
masked_begin 618
v_cvt_f64_f32 v[8:9], v5
v_rndne_f64_e32 v[16:17], v[8:9]
v_rcp_f64_e32 v[18:19], v[8:9]
v_rsq_f64_e32 v[20:21], v[8:9]
v_sqrt_f64_e32 v[22:23], v[8:9]
v_frexp_exp_i32_f64_e32 v24, v[8:9]
v_frexp_mant_f64_e32 v[26:27], v[8:9]
masked_end 618
checkpoint 618

; Checkpoint 619: relative_moves_e32_plain
clear_results
s_mov_b32 m0, 0
v_mov_b32 v8, v1
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b16_e32 v16.h, v8.l
v_mov_b32 v18, 0xa5a5a5a5
v_movreld_b32_e32 v18, v8
v_mov_b32 v20, 0xa5a5a5a5
v_movrelsd_b32_e32 v20, v8
v_mov_b32 v22, 0xa5a5a5a5
v_movrelsd_2_b32_e32 v22, v8
checkpoint 619

; Checkpoint 620: relative_moves_e32_dpp16
clear_results
s_mov_b32 m0, 0
v_mov_b32 v8, v1
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b16_dpp v16.h, v8.l row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
v_mov_b32 v18, 0xa5a5a5a5
v_movreld_b32_dpp v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
v_mov_b32 v20, 0xa5a5a5a5
v_movrelsd_b32_dpp v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
v_mov_b32 v22, 0xa5a5a5a5
v_movrelsd_2_b32_dpp v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
checkpoint 620

; Checkpoint 621: relative_moves_e32_dpp8
clear_results
s_mov_b32 m0, 0
v_mov_b32 v8, v1
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b16_dpp v16.h, v8.l dpp8:[7,6,5,4,3,2,1,0] fi:1
v_mov_b32 v18, 0xa5a5a5a5
v_movreld_b32_dpp v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
v_mov_b32 v20, 0xa5a5a5a5
v_movrelsd_b32_dpp v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
v_mov_b32 v22, 0xa5a5a5a5
v_movrelsd_2_b32_dpp v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
checkpoint 621

; Checkpoint 622: wide_conversions_e64
clear_results
masked_begin 622
v_cvt_f64_f32 v[8:9], v4
v_cvt_i32_f64_e64 v16, v[8:9]
v_cvt_f64_i32_e64 v[18:19], v1
v_cvt_f32_f64_e64 v20, v[8:9]
v_cvt_u32_f64_e64 v21, v[8:9]
v_cvt_f64_u32_e64 v[22:23], v1
v_cvt_pk_f32_fp8_e64 v[24:25], v1.l
v_cvt_pk_f32_bf8_e64 v[26:27], v2.h
v_trunc_f64_e64 v[28:29], v[8:9]
v_ceil_f64_e64 v[30:31], v[8:9]
masked_end 622
checkpoint 622

; Checkpoint 623: wide_unary_e64
clear_results
masked_begin 623
v_cvt_f64_f32 v[8:9], v5
v_rndne_f64_e64 v[16:17], v[8:9]
v_rcp_f64_e64 v[18:19], v[8:9]
v_rsq_f64_e64 v[20:21], v[8:9]
v_sqrt_f64_e64 v[22:23], v[8:9]
v_frexp_exp_i32_f64_e64 v24, v[8:9]
v_frexp_mant_f64_e64 v[26:27], v[8:9]
masked_end 623
checkpoint 623

; Checkpoint 624: relative_moves_e64_plain
clear_results
s_mov_b32 m0, 0
v_mov_b32 v8, v1
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b16_e64 v16.h, v8.l
v_mov_b32 v18, 0xa5a5a5a5
v_movreld_b32_e64 v18, v8
v_mov_b32 v20, 0xa5a5a5a5
v_movrelsd_b32_e64 v20, v8
v_mov_b32 v22, 0xa5a5a5a5
v_movrelsd_2_b32_e64 v22, v8
checkpoint 624

; Checkpoint 625: relative_moves_e64_dpp16
clear_results
s_mov_b32 m0, 0
v_mov_b32 v8, v1
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b16_e64_dpp v16.h, v8.l row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
v_mov_b32 v18, 0xa5a5a5a5
v_movreld_b32_e64_dpp v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
v_mov_b32 v20, 0xa5a5a5a5
v_movrelsd_b32_e64_dpp v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
v_mov_b32 v22, 0xa5a5a5a5
v_movrelsd_2_b32_e64_dpp v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
checkpoint 625

; Checkpoint 626: relative_moves_e64_dpp8
clear_results
s_mov_b32 m0, 0
v_mov_b32 v8, v1
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b16_e64_dpp v16.h, v8.l dpp8:[7,6,5,4,3,2,1,0] fi:1
v_mov_b32 v18, 0xa5a5a5a5
v_movreld_b32_e64_dpp v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
v_mov_b32 v20, 0xa5a5a5a5
v_movrelsd_b32_e64_dpp v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
v_mov_b32 v22, 0xa5a5a5a5
v_movrelsd_2_b32_e64_dpp v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
checkpoint 626

; Checkpoint 627: swaps_and_variable_permute
clear_results
s_mov_b32 m0, 0
v_mov_b32 v8, v1
v_mov_b32 v16, v2
v_swap_b32 v16, v8
v_mov_b32 v17, v8
v_mov_b32 v18, v2
v_swap_b16 v18.h, v8.l
v_mov_b32 v19, v8
v_mov_b32 v20, v2
v_swaprel_b32 v20, v8
v_mov_b32 v21, v8
v_permlane16_var_b32 v22, v1, v0
v_permlanex16_var_b32 v23, v2, v0
checkpoint 627

; Checkpoint 628: wide_sad_and_minmax
clear_results
masked_begin 628
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v2
v_mov_b32 v11, v1
v_mov_b32 v12, 17
v_mov_b32 v13, 23
v_qsad_pk_u16_u8 v[16:17], v[8:9], v10, v[12:13]
v_mqsad_pk_u16_u8 v[18:19], v[8:9], v10, v[12:13]
v_mqsad_u32_u8 v[20:23], v[8:9], v10, v[8:11]
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_minimum_f64 v[24:25], v[8:9], v[10:11]
v_maximum_f64 v[26:27], v[8:9], v[10:11]
masked_end 628
checkpoint 628

; Checkpoint 629: fused_dpp16
clear_results
v_fmac_f32_e64_dpp v16, v4, v5 row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
checkpoint 629

; Checkpoint 630: fused_dpp8
clear_results
v_fmac_f32_e64_dpp v16, v4, v5 dpp8:[7,6,5,4,3,2,1,0] fi:1
checkpoint 630

.if GUITAR_HERO_WAVE_SIZE == 32
; Checkpoint 631: dual_issue_complete
.else
; Checkpoint 631: serial_valu_complete
.endif
clear_results
s_mov_b32 vcc_lo, 0xa5a55a5a
.if GUITAR_HERO_WAVE_SIZE == 64
s_mov_b32 vcc_hi, 0x5a5aa5a5
.endif
set_exec 0xa5a55a5a, 0x5a5aa5a5
.if GUITAR_HERO_WAVE_SIZE == 32
v_dual_fmaak_f32 v16, v4, v5, 0x3e800000 :: v_dual_fmamk_f32 v17, v5, 0x3e800000, v4
; Commit the SALU-written VCC before the implicit VOPD condition read.
s_wait_alu 0xfffe
v_dual_cndmask_b32 v18, v4, v5 :: v_dual_mul_dx9_zero_f32 v19, v5, v4
v_dual_mov_b32 v20, v1 :: v_dual_and_b32 v21, v2, v1
v_dual_mov_b32 v22, v1 :: v_dual_lshlrev_b32 v23, v2, v1
v_dual_dot2acc_f32_f16 v24, 0.5, v5 :: v_dual_dot2acc_f32_bf16 v25, 0.5, v4
.else
v_fmaak_f32 v16, v4, v5, 0x3e800000
v_fmamk_f32 v17, v5, 0x3e800000, v4
s_wait_alu 0xfffe
v_cndmask_b32 v18, v4, v5, \cc
v_mul_dx9_zero_f32 v19, v5, v4
v_mov_b32 v20, v1
v_and_b32 v21, v2, v1
v_mov_b32 v22, v1
v_lshlrev_b32 v23, v2, v1
v_dot2_f32_f16 v24, 0.5, v5, v24
v_dot2_f32_bf16 v25, 0.5, v4, v25
.endif
set_exec -1
checkpoint 631

; Checkpoint 632: implicit_lane_addresses
clear_results
v_readfirstlane_b32 s20, v0
s_lshl_b32 s20, s20, 2
s_wait_alu 0xfffe
s_add_u32 m0, s20, 2048
ds_store_addtid_b32 v1
s_wait_dscnt 0
set_exec 0xa5a55a5a, 0x5a5aa5a5
ds_store_addtid_b32 v2
s_wait_dscnt 0
ds_load_addtid_b32 v16
s_wait_dscnt 0
set_exec -1
ds_load_addtid_b32 v17
s_wait_dscnt 0
s_lshl_b32 s21, s20, 4
s_wait_alu 0xfffe
s_add_u32 s16, s14, s21
s_addc_u32 s17, s15, 0
global_store_addtid_b32 v1, s[16:17]
s_wait_storecnt 0
set_exec 0xa5a55a5a, 0x5a5aa5a5
global_store_addtid_b32 v2, s[16:17]
s_wait_storecnt 0
global_load_addtid_b32 v18, s[16:17]
s_wait_loadcnt 0
set_exec -1
global_load_addtid_b32 v19, s[16:17]
s_wait_loadcnt 0
v_lshlrev_b32 v8, 2, v0
ds_bpermute_fi_b32 v20, v8, v1
s_wait_dscnt 0
s_mov_b32 m0, 0
checkpoint 632

; Checkpoint 633: scalar_literal_slots
clear_results
s_mov_b32 s16, 0x12345678
s_not_b32 s17, 0x13579bdf
s_wait_alu 0xfffe
v_mov_b32 v16, s17
s_add_u32 s17, 0x12345678, s8
s_wait_alu 0xfffe
v_mov_b32 v17, s17
s_add_u32 s17, s8, 0x12345678
s_wait_alu 0xfffe
v_mov_b32 v18, s17
s_xor_b32 s17, 0x12345678, 0x12345678
s_wait_alu 0xfffe
v_mov_b32 v19, s17
s_cmp_eq_u32 0x12345678, s8
s_cselect_b32 s17, 1, 0
s_wait_alu 0xfffe
v_mov_b32 v20, s17
s_cmp_eq_u32 s8, 0x12345678
s_cselect_b32 s17, 1, 0
s_wait_alu 0xfffe
v_mov_b32 v21, s17
s_cmp_eq_u32 0x12345678, 0x12345678
s_cselect_b32 s17, 1, 0
s_wait_alu 0xfffe
v_mov_b32 v22, s17
s_mov_b64 s[16:17], 0x12345678
s_wait_alu 0xfffe
v_mov_b32 v23, s16
v_mov_b32 v24, s17
s_and_b64 s[16:17], s[16:17], 0xfedcba98
s_wait_alu 0xfffe
v_mov_b32 v25, s16
v_mov_b32 v26, s17
checkpoint 633

; Checkpoint 634: vector_literal_slots
clear_results
masked_begin 634
v_not_b32_e32 v16, 0x12345678
v_xor_b32_e32 v17, 0x12345678, v1
v_xor_b32_e64 v18, v1, 0x12345678
v_xor_b32_e64 v19, 0x12345678, v1
v_xor_b32_e64 v20, 0x12345678, 0x12345678
v_bfi_b32 v21, 0x12345678, v1, v2
v_bfi_b32 v22, v1, 0x12345678, v2
v_bfi_b32 v23, v1, v2, 0x12345678
v_bfi_b32 v24, 0x12345678, v1, 0x12345678
v_cmp_eq_u32_e32 \cc, 0x12345678, v1
wait_wave32_alu 0xfffd
mask_result v25, vcc_lo, vcc_hi
v_cmp_eq_u32_e64 \cc, v1, 0x12345678
wait_wave32_alu 0xfffd
mask_result v26, vcc_lo, vcc_hi
v_cmp_eq_u32_e64 \cc, 0x12345678, 0x12345678
wait_wave32_alu 0xfffd
mask_result v27, vcc_lo, vcc_hi
v_fma_f32 v28, 0x3eaaaaab, v4, v5
v_fma_f32 v29, v4, 0x3eaaaaab, v5
v_fma_f32 v30, v4, v5, 0x3eaaaaab
v_fma_f32 v31, 0x3eaaaaab, v4, 0x3eaaaaab
masked_end 634
checkpoint 634

; Checkpoint 635: inline_constant_selectors
clear_results
masked_begin 635
; Identical values in different slots exercise the inline selector encodings.
v_mov_b32_e32 v16, 0.5
v_mov_b32_e32 v17, -0.5
v_mov_b32_e32 v18, 1.0
v_mov_b32_e32 v19, -1.0
v_mov_b32_e32 v20, 2.0
v_mov_b32_e32 v21, -2.0
v_mov_b32_e32 v22, 4.0
v_mov_b32_e32 v23, -4.0
v_mov_b32_e32 v24, 0.15915494
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v26, 64
v_mov_b32_e32 v27, -1
v_mov_b32_e32 v28, -16
v_add_f32_e64 v29, -0.5, v4
v_add_f32_e64 v30, v4, -4.0
v_fma_f32 v31, v4, v5, 0.15915494
masked_end 635
checkpoint 635

; Checkpoint 636: ds_permute_masks
clear_results
; Unique destinations avoid a lane-collision ordering dependency.
v_xor_b32 v8, 31, v3
v_lshlrev_b32 v8, 2, v8
ds_permute_b32 v16, v8, v1
s_wait_dscnt 0
v_mov_b32 v17, v16
set_exec 0x55555555, 0x55555555
v_xor_b32 v8, 2, v3
v_lshlrev_b32 v8, 2, v8
ds_permute_b32 v18, v8, v2
s_wait_dscnt 0
set_exec -1
checkpoint 636

; Checkpoint 637: scalar_mask_branches
clear_results
; Each condition is taken once and falls through once. No lane data is lost.
s_mov_b32 s16, 0
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 vcc_lo, 0
.else
s_mov_b64 vcc, 0
.endif
s_wait_alu 0xfffe
s_cbranch_vccz .Lzero_vcc
s_add_u32 s16, s16, 100
.Lzero_vcc:
s_wait_alu 0xf1fc
s_add_u32 s16, s16, 1
.if GUITAR_HERO_WAVE_SIZE == 32
s_mov_b32 vcc_lo, -1
.else
s_mov_b64 vcc, -1
.endif
s_wait_alu 0xfffe
s_cbranch_vccz .Lnonzero_vcc
s_add_u32 s16, s16, 2
.Lnonzero_vcc:
s_wait_alu 0xf1fc
.if GUITAR_HERO_WAVE_SIZE == 32
set_exec 0, 0x80000000
.else
set_exec 0
.endif
s_cbranch_execnz .Lempty_exec
s_add_u32 s16, s16, 4
.Lempty_exec:
s_wait_alu 0xf1fc
set_exec -1
s_cbranch_execnz .Lnonempty_exec
s_add_u32 s16, s16, 100
.Lnonempty_exec:
s_wait_alu 0xf1fc
v_mov_b32 v16, s16
s_nop 0
v_nop
checkpoint 637

; Checkpoint 638: scalar_local_calls
clear_results
; PC values remain internal; only deterministic control-flow results are hashed.
s_getpc_b64 s[16:17]
.Lcall_base:
s_wait_alu 0xf1fc
s_add_u32 s16, s16, .Lswap_body-.Lcall_base
s_addc_u32 s17, s17, 0
s_mov_b32 s20, 0
s_wait_alu 0xf1fc
s_swappc_b64 s[18:19], s[16:17]
s_wait_alu 0xf1fc
v_mov_b32 v16, s20
s_wait_alu 0xf1fc
s_call_b64 s[18:19], .Lcall_body
s_wait_alu 0xf1fc
v_mov_b32 v17, s20
s_branch .Lcalls_done
.Lswap_body:
s_wait_alu 0xf1fc
s_add_u32 s20, s20, 7
s_wait_alu 0xf1fc
s_setpc_b64 s[18:19]
.Lcall_body:
s_wait_alu 0xf1fc
s_mul_i32 s20, s20, 13
s_wait_alu 0xf1fc
s_setpc_b64 s[18:19]
.Lcalls_done:
s_wait_alu 0xf1fc
v_readfirstlane_b32 s16, v1
s_wait_alu 0xf1ff
v_mov_b32 v18, s16
s_movk_i32 s16, 0x1234
s_wait_alu 0xfffe
s_addk_i32 s16, 7
s_wait_alu 0xfffe
s_mulk_i32 s16, 13
s_wait_alu 0xfffe
v_mov_b32 v19, s16
s_cmp_eq_u32 s8, 1
s_cmovk_i32 s16, 0x5678
s_wait_alu 0xfffe
v_mov_b32 v20, s16
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
s_setreg_b32 hwreg(HW_REG_MODE, 0, 8), s16
s_round_mode 0
s_denorm_mode 15
s_getreg_b32 s17, hwreg(HW_REG_MODE, 0, 8)
s_wait_alu 0xfffe
v_mov_b32 v21, s17
gh_pc_corners 48, GUITAR_HERO_WAVE_SIZE, 1, 0
checkpoint 638

; Checkpoint 639: packed_dot_permutations_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec -1
v_dot2_f32_bf16_e64_dpp v16, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_dot2_f32_bf16_e64_dpp v18, v8, v9, s23 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
set_exec -1
v_dot2_f32_f16 v20, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec -1
v_dot4_f32_bf8_bf8 v22, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
set_exec -1
v_dot4_f32_bf8_fp8 v24, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
set_exec -1
v_dot4_f32_fp8_bf8 v26, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
set_exec -1
v_dot4_f32_fp8_fp8 v28, v8, v9, v10 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
set_exec -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_dot2_f32_f16 v30, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 639

; Checkpoint 640: packed_dot_permutations_01
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_dot4_f32_bf8_bf8 v16, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_dot4_f32_bf8_fp8 v18, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_dot4_f32_fp8_bf8 v20, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
set_exec 0xa5a55a5a, 0x5a5aa5a5
v_dot4_f32_fp8_fp8 v22, v8, v9, v10 dpp8:[7,6,5,4,3,2,1,0] fi:1
set_exec -1
checkpoint 640

; Operand-sensitive boundary probes. Keep existing checkpoint indices stable.
; Checkpoint 641: trigger_cvt_f64_modifiers_full
set_exec -1
clear_results
; Distinct negative quarter-integers make ABS and NEG observable.
v_and_b32 v8, 7, v0
v_cvt_f32_u32 v8, v8
v_mov_b32 v10, 0.75
v_add_f32 v8, v8, v10
v_mul_f32 v8, v8, -1.0
.irp r,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
v_mov_b32 v\r, 0xa5a5a5a5
.endr
v_cvt_f64_f32_e64 v[16:17], v8
v_cvt_f64_f32_e64 v[18:19], |v8|
v_cvt_f64_f32_e64 v[20:21], -v8
v_cvt_f64_f32_e64 v[22:23], -|v8|
v_cvt_f64_f32_e64 v[24:25], -v8 div:2
v_cvt_f64_f32_e64 v[26:27], -v8 mul:2
v_cvt_f64_f32_e64 v[28:29], |v8| clamp
v_cvt_f64_f32_e64 v[30:31], -|v8| clamp
set_exec -1
checkpoint 641

; Checkpoint 642: trigger_cvt_f64_modifiers_partial
set_exec -1
clear_results
; Distinct negative quarter-integers make ABS and NEG observable.
v_and_b32 v8, 7, v0
v_cvt_f32_u32 v8, v8
v_mov_b32 v10, 0.75
v_add_f32 v8, v8, v10
v_mul_f32 v8, v8, -1.0
.irp r,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
v_mov_b32 v\r, 0xa5a5a5a5
.endr
set_exec 0x55555555, 0xaaaaaaaa
v_cvt_f64_f32_e64 v[16:17], v8
v_cvt_f64_f32_e64 v[18:19], |v8|
v_cvt_f64_f32_e64 v[20:21], -v8
v_cvt_f64_f32_e64 v[22:23], -|v8|
v_cvt_f64_f32_e64 v[24:25], -v8 div:2
v_cvt_f64_f32_e64 v[26:27], -v8 mul:2
v_cvt_f64_f32_e64 v[28:29], |v8| clamp
v_cvt_f64_f32_e64 v[30:31], -|v8| clamp
set_exec -1
checkpoint 642

; Checkpoint 643: trigger_signed_mad_carry_full
set_exec -1
clear_results
; Observe signed bit 64 separately from 64-bit result saturation.
set_exec -1
v_mov_b32 v16, 0
v_mov_b32 v17, 0
v_mov_b32 v8, 3
v_mov_b32 v9, -4
s_mov_b32 s20, 0
s_mov_b32 s21, 0x13579bdf
s_wait_alu 0xf1fc
.if GUITAR_HERO_WAVE_SIZE == 32
v_mad_i64_i32 v[16:17], s20, v8, v9, v[16:17]
.else
v_mad_i64_i32 v[16:17], s[20:21], v8, v9, v[16:17]
.endif
s_wait_alu 0xf1fc
set_exec -1
v_mov_b32 v18, s20
v_mov_b32 v19, s21
set_exec -1
v_mov_b32 v20, 4294967295
v_mov_b32 v21, 2147483647
v_mov_b32 v8, 1
v_mov_b32 v9, 1
s_mov_b32 s20, 0
s_mov_b32 s21, 0x13579bdf
s_wait_alu 0xf1fc
.if GUITAR_HERO_WAVE_SIZE == 32
v_mad_i64_i32 v[20:21], s20, v8, v9, v[20:21]
.else
v_mad_i64_i32 v[20:21], s[20:21], v8, v9, v[20:21]
.endif
s_wait_alu 0xf1fc
set_exec -1
v_mov_b32 v22, s20
v_mov_b32 v23, s21
set_exec -1
v_mov_b32 v24, 4294967295
v_mov_b32 v25, 2147483647
v_mov_b32 v8, 1
v_mov_b32 v9, 1
s_mov_b32 s20, 0
s_mov_b32 s21, 0x13579bdf
s_wait_alu 0xf1fc
.if GUITAR_HERO_WAVE_SIZE == 32
v_mad_i64_i32 v[24:25], s20, v8, v9, v[24:25] clamp
.else
v_mad_i64_i32 v[24:25], s[20:21], v8, v9, v[24:25] clamp
.endif
s_wait_alu 0xf1fc
set_exec -1
v_mov_b32 v26, s20
v_mov_b32 v27, s21
set_exec -1
v_mov_b32 v28, 0
v_mov_b32 v29, 2147483648
v_mov_b32 v8, -1
v_mov_b32 v9, 1
s_mov_b32 s20, 0
s_mov_b32 s21, 0x13579bdf
s_wait_alu 0xf1fc
.if GUITAR_HERO_WAVE_SIZE == 32
v_mad_i64_i32 v[28:29], s20, v8, v9, v[28:29]
.else
v_mad_i64_i32 v[28:29], s[20:21], v8, v9, v[28:29]
.endif
s_wait_alu 0xf1fc
set_exec -1
v_mov_b32 v30, s20
v_mov_b32 v31, s21
set_exec -1
checkpoint 643

; Checkpoint 644: trigger_signed_mad_carry_partial
set_exec -1
clear_results
; Observe signed bit 64 separately from 64-bit result saturation.
set_exec 0x55555555, 0xaaaaaaaa
set_exec -1
v_mov_b32 v16, 0
v_mov_b32 v17, 0
v_mov_b32 v8, 3
v_mov_b32 v9, -4
s_mov_b32 s20, 0
s_mov_b32 s21, 0x13579bdf
s_wait_alu 0xf1fc
set_exec 0x55555555, 0xaaaaaaaa
.if GUITAR_HERO_WAVE_SIZE == 32
v_mad_i64_i32 v[16:17], s20, v8, v9, v[16:17]
.else
v_mad_i64_i32 v[16:17], s[20:21], v8, v9, v[16:17]
.endif
s_wait_alu 0xf1fc
set_exec -1
v_mov_b32 v18, s20
v_mov_b32 v19, s21
set_exec -1
v_mov_b32 v20, 4294967295
v_mov_b32 v21, 2147483647
v_mov_b32 v8, 1
v_mov_b32 v9, 1
s_mov_b32 s20, 0
s_mov_b32 s21, 0x13579bdf
s_wait_alu 0xf1fc
set_exec 0x55555555, 0xaaaaaaaa
.if GUITAR_HERO_WAVE_SIZE == 32
v_mad_i64_i32 v[20:21], s20, v8, v9, v[20:21]
.else
v_mad_i64_i32 v[20:21], s[20:21], v8, v9, v[20:21]
.endif
s_wait_alu 0xf1fc
set_exec -1
v_mov_b32 v22, s20
v_mov_b32 v23, s21
set_exec -1
v_mov_b32 v24, 4294967295
v_mov_b32 v25, 2147483647
v_mov_b32 v8, 1
v_mov_b32 v9, 1
s_mov_b32 s20, 0
s_mov_b32 s21, 0x13579bdf
s_wait_alu 0xf1fc
set_exec 0x55555555, 0xaaaaaaaa
.if GUITAR_HERO_WAVE_SIZE == 32
v_mad_i64_i32 v[24:25], s20, v8, v9, v[24:25] clamp
.else
v_mad_i64_i32 v[24:25], s[20:21], v8, v9, v[24:25] clamp
.endif
s_wait_alu 0xf1fc
set_exec -1
v_mov_b32 v26, s20
v_mov_b32 v27, s21
set_exec -1
v_mov_b32 v28, 0
v_mov_b32 v29, 2147483648
v_mov_b32 v8, -1
v_mov_b32 v9, 1
s_mov_b32 s20, 0
s_mov_b32 s21, 0x13579bdf
s_wait_alu 0xf1fc
set_exec 0x55555555, 0xaaaaaaaa
.if GUITAR_HERO_WAVE_SIZE == 32
v_mad_i64_i32 v[28:29], s20, v8, v9, v[28:29]
.else
v_mad_i64_i32 v[28:29], s[20:21], v8, v9, v[28:29]
.endif
s_wait_alu 0xf1fc
set_exec -1
v_mov_b32 v30, s20
v_mov_b32 v31, s21
set_exec -1
checkpoint 644

; Checkpoint 645: trigger_minmax_nan_zero
set_exec -1
clear_results
; Signed-zero order and NaN priority need specific operand bit patterns.
v_mov_b32 v8, 0x80000000
v_mov_b32 v9, 0
v_mov_b32 v10, 0x7fc12345
v_mov_b32 v11, 0x3f800000
v_mov_b32 v12, 0x7f800123
v_mov_b32 v13, 0xc0000000
v_min_num_f32 v16, v8, v9
v_min_num_f32 v17, v9, v8
v_max_num_f32 v18, v8, v9
v_max_num_f32 v19, v9, v8
v_min_num_f32 v20, v10, v11
v_min_num_f32 v21, v11, v10
v_max_num_f32 v22, v12, v11
v_max_num_f32 v23, v11, v12
v_med3_f32 v24, v10, v11, v13
v_med3_f32 v25, v11, v10, v13
v_med3_f32 v26, v11, v13, v10
v_med3_f32 v27, v12, v11, v13
v_med3_f32 v28, v8, v9, v8
v_med3_f32 v29, v9, v8, v9
set_exec -1
checkpoint 645

; Checkpoint 646: trigger_packed_minmax_denorm
set_exec -1
clear_results
; Input preservation with output flushing must retain selected denormals.
s_getreg_b32 s32, hwreg(HW_REG_MODE)
v_mov_b32 v8, 0x80010001
v_mov_b32 v9, 0x00018001
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 6, 2), 1
s_wait_alu 0xf1fc
v_pk_min_f16 v16, v8, v9
v_pk_max_f16 v17, v8, v9
v_pk_min_f16 v18, v8, v9 clamp
v_pk_max_f16 v19, v8, v9 clamp
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 6, 2), 0
s_wait_alu 0xf1fc
v_pk_min_f16 v20, v8, v9
v_pk_max_f16 v21, v8, v9
s_setreg_b32 hwreg(HW_REG_MODE), s32
s_wait_alu 0xf1fc
set_exec -1
checkpoint 646

; Checkpoint 647: trigger_swizzle_fft_rotate_full
set_exec -1
clear_results
v_add_nc_u32 v8, 0x1000, v0
.irp r,16,17,18,19,20,21,22,23
v_mov_b32 v\r, 0xa5a5a5a5
.endr
ds_swizzle_b32 v16, v8 offset:0xe000
s_wait_dscnt 0
ds_swizzle_b32 v17, v8 offset:0xe010
s_wait_dscnt 0
ds_swizzle_b32 v18, v8 offset:0xe01f
s_wait_dscnt 0
ds_swizzle_b32 v19, v8 offset:0xc020
s_wait_dscnt 0
ds_swizzle_b32 v20, v8 offset:0xc420
s_wait_dscnt 0
ds_swizzle_b32 v21, v8 offset:0xc021
s_wait_dscnt 0
ds_swizzle_b32 v22, v8 offset:0xc421
s_wait_dscnt 0
ds_swizzle_b32 v23, v8 offset:0x80b1
s_wait_dscnt 0
set_exec -1
checkpoint 647

; Checkpoint 648: trigger_swizzle_fft_rotate_partial
set_exec -1
clear_results
v_add_nc_u32 v8, 0x1000, v0
.irp r,16,17,18,19,20,21,22,23
v_mov_b32 v\r, 0xa5a5a5a5
.endr
set_exec 0x55555555, 0xaaaaaaaa
ds_swizzle_b32 v16, v8 offset:0xe000
s_wait_dscnt 0
ds_swizzle_b32 v17, v8 offset:0xe010
s_wait_dscnt 0
ds_swizzle_b32 v18, v8 offset:0xe01f
s_wait_dscnt 0
ds_swizzle_b32 v19, v8 offset:0xc020
s_wait_dscnt 0
ds_swizzle_b32 v20, v8 offset:0xc420
s_wait_dscnt 0
ds_swizzle_b32 v21, v8 offset:0xc021
s_wait_dscnt 0
ds_swizzle_b32 v22, v8 offset:0xc421
s_wait_dscnt 0
ds_swizzle_b32 v23, v8 offset:0x80b1
s_wait_dscnt 0
set_exec -1
checkpoint 648

; Checkpoint 649: trigger_scalar_relative_high_offset
set_exec -1
clear_results
; Keep every relative target inside the allocated SGPR range.
s_mov_b32 s64, 0x12345678
s_mov_b32 s65, 0x76543210
s_mov_b32 m0, 64
s_wait_alu 0xf1fc
s_movrels_b32 s16, s0
s_movrels_b64 s[18:19], s[0:1]
s_wait_alu 0xf1fc
v_mov_b32 v16, s16
v_mov_b32 v17, s18
v_mov_b32 v18, s19
s_mov_b32 s24, 0x0badcafe
s_mov_b32 s25, 0x13579bdf
s_wait_alu 0xf1fc
s_movreld_b32 s0, s24
s_movreld_b64 s[0:1], s[24:25]
s_wait_alu 0xf1fc
v_mov_b32 v19, s64
v_mov_b32 v20, s65
s_mov_b32 m0, 0
s_mov_b32 s24, 0x7fffffff
s_mov_b32 s25, 0xffffffff
s_wait_alu 0xf1fc
s_absdiff_i32 s26, s24, s25
s_wait_alu 0xf1fc
v_mov_b32 v21, s26
; Wrapped -1 distinguishes the result from a wide absolute difference.
s_mov_b32 s25, 0x80000000
s_wait_alu 0xf1fc
s_absdiff_i32 s26, s24, s25
s_wait_alu 0xf1fc
v_mov_b32 v22, s26
set_exec -1
checkpoint 649

.Lfinish:
s_wait_storecnt 0
s_endpgm
.Lend:
.size \name, .Lend-\name
.rodata
.p2align 6
.amdhsa_kernel \name
  .amdhsa_group_segment_fixed_size 4096
  .amdhsa_private_segment_fixed_size 64
  .amdhsa_kernarg_size 40
  .amdhsa_user_sgpr_count 2
  .amdhsa_user_sgpr_kernarg_segment_ptr 1
  .amdhsa_wavefront_size32 (64-GUITAR_HERO_WAVE_SIZE)/32
  .amdhsa_enable_private_segment 1
  .amdhsa_system_sgpr_workgroup_id_x 1
  .amdhsa_system_vgpr_workitem_id 0
  .amdhsa_next_free_vgpr 64
  .amdhsa_next_free_sgpr \sgpr_count
  .amdhsa_reserve_vcc 1
  .amdhsa_float_round_mode_32 0
  .amdhsa_float_round_mode_16_64 0
  .amdhsa_float_denorm_mode_32 3
  .amdhsa_float_denorm_mode_16_64 3
  .amdhsa_workgroup_processor_mode 1
  .amdhsa_memory_ordered 1
  .amdhsa_forward_progress 1
.end_amdhsa_kernel
.amdgpu_metadata
---
amdhsa.version: [1, 2]
amdhsa.target: amdgcn-amd-amdhsa--gfx1201
amdhsa.kernels:
  - .name: \name
    .symbol: \name\().kd
    .kernarg_segment_size: 40
    .kernarg_segment_align: 8
    .group_segment_fixed_size: 4096
    .private_segment_fixed_size: 64
    .wavefront_size: \wave_size
    .sgpr_count: \sgpr_count
    .vgpr_count: 64
    .max_flat_workgroup_size: 64
    .reqd_workgroup_size: [64, 1, 1]
    .args:
      - { .name: output, .offset: 0, .size: 8, .value_kind: global_buffer, .address_space: global }
      - { .name: trace, .offset: 8, .size: 8, .value_kind: global_buffer, .address_space: global }
      - { .name: seed, .offset: 16, .size: 4, .value_kind: by_value }
      - { .name: checkpoint, .offset: 20, .size: 4, .value_kind: by_value }
      - { .name: stop, .offset: 24, .size: 4, .value_kind: by_value }
      - { .name: workspace, .offset: 32, .size: 8, .value_kind: global_buffer, .address_space: global }
...
.end_amdgpu_metadata
.section .note.GNU-stack,"",@progbits
.endm

.if GUITAR_HERO_WAVE_SIZE == 32
guitar_hero_kernel guitar_hero, vcc_lo, 32, 80
.elseif GUITAR_HERO_WAVE_SIZE == 64
guitar_hero_kernel guitar_hero_wave64, vcc, 64, 80
.else
.error "GUITAR_HERO_WAVE_SIZE must be 32 or 64"
.endif
