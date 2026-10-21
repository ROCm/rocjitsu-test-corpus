; gfx1030, wave32, exactly 64 work-items per independent workgroup.
; v0=local id, v1:2=integer inputs, v3=lane, v4:6=finite FP inputs.
; v16:31=checkpoint results, v32:47=auxiliary operands, v60:61=rolling digest.
; s4:5=group output, s6:7=optional raw checkpoint, s8=seed, s9=trace id.
.amdgcn_target "amdgcn-amd-amdhsa--gfx1030"
.amdhsa_code_object_version 6
.text
.protected guitar_hero_rdna2
.globl guitar_hero_rdna2
.p2align 8
.type guitar_hero_rdna2,@function
.macro clear_results
.irp r,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
v_mov_b32 v\r, 0
.endr
.endm
; Fold under the current EXEC so every active loop iteration affects the rolling hashes.
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
; region and iteration.
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
s_and_b32 s76, s74, 31
s_lshl_b32 s74, 1, s76
s_mov_b32 s75, 0
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
s_cmp_eq_u32 s74, s78
; Avoid adjacent repeats even if two hash outputs collide.
s_cbranch_scc0 .Lmask_distinct\@
s_cmp_eq_u32 s72, 4
s_cbranch_scc0 .Lmask_flip_bit\@
s_lshr_b32 s76, s74, 31
s_lshl_b32 s74, s74, 1
s_or_b32 s74, s74, s76
s_branch .Lmask_distinct\@
.Lmask_flip_bit\@:
s_xor_b32 s74, s74, 1
.Lmask_distinct\@:
s_mov_b64 s[78:79], s[74:75]
s_mov_b32 exec_lo, s74
.endm

.macro masked_end id
fold_results
s_add_u32 s72, s72, 1
s_cmp_lt_u32 s72, s73
s_cbranch_scc1 .Lmasked_loop\id
s_mov_b32 exec_lo, -1
.endm

.macro checkpoint id
; The same binary performs validation, recording, timing and diagnosis.
s_cmp_eq_u32 s9, \id+1
s_cbranch_scc0 .Lno_trace\@
v_lshlrev_b32 v62, 6, v0
global_store_dwordx4 v62, v[16:19], s[6:7] offset:0
global_store_dwordx4 v62, v[20:23], s[6:7] offset:16
global_store_dwordx4 v62, v[24:27], s[6:7] offset:32
global_store_dwordx4 v62, v[28:31], s[6:7] offset:48
.Lno_trace\@:
; Ordered rolling hashes observe result bits, including inactive lanes.
fold_results
v_lshlrev_b32 v62, 3, v0
v_add_nc_u32 v62, 512*\id, v62
global_store_dwordx2 v62, v[60:61], s[4:5]
s_cmp_eq_u32 s11, \id+1
s_cbranch_scc0 .Lcontinue\@
s_waitcnt_vscnt null, 0
s_endpgm
.Lcontinue\@:
.endm
guitar_hero_rdna2:
s_add_u32 s2, s2, s5
s_addc_u32 s3, s3, 0
s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s2
s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s3
s_mov_b32 s48, s4
s_load_dwordx4 s[4:7], s[0:1], 0
s_load_dwordx2 s[8:9], s[0:1], 16
s_load_dword s11, s[0:1], 24
s_waitcnt lgkmcnt(0)
; With four user SGPRs, gfx10 delivers workgroup id X in s4.
; Preserve it before the instruction sweep reuses the input registers.
s_mul_i32 s12, s48, 250368
s_add_u32 s4, s4, s12
s_addc_u32 s5, s5, 0
v_mul_lo_u32 v1, 0x2c9277b5, v0
v_xor_b32 v1, s8, v1
v_bfrev_b32 v2, v1
v_and_b32 v3, 31, v0
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
v_add_co_u32 v16, vcc_lo, v1, v2
v_add_co_ci_u32 v17, vcc_lo, v2, v1, vcc_lo
v_mov_b32 v18, vcc_lo
v_sub_co_u32 v19, vcc_lo, v1, v2
v_sub_co_ci_u32 v20, vcc_lo, v2, v1, vcc_lo
v_mov_b32 v21, vcc_lo
v_mad_u64_u32 v[22:23], s20, v1, v2, v[16:17]
v_mad_i64_i32 v[24:25], s21, v1, v2, v[16:17]
v_lshlrev_b64 v[26:27], v0, v[1:2]
v_lshrrev_b64 v[28:29], v0, v[1:2]
v_ashrrev_i64 v[30:31], v0, v[1:2]
masked_end 2
checkpoint 2


; Checkpoint 3: scalar
clear_results
s_add_u32 s16, s8, 0x76543210
v_mov_b32 v16, s16
s_addc_u32 s17, s16, -1
v_mov_b32 v17, s17
s_sub_u32 s18, s16, s8
v_mov_b32 v18, s18
s_subb_u32 s19, 0, s8
v_mov_b32 v19, s19
s_mul_i32 s20, s8, 31337
v_mov_b32 v20, s20
s_brev_b32 s21, s20
v_mov_b32 v21, s21
s_bcnt1_i32_b32 s22, s21
v_mov_b32 v22, s22
s_ff1_i32_b32 s23, s21
v_mov_b32 v23, s23
s_bfe_i32 s24, s20, 0x000d0007
v_mov_b32 v24, s24
s_min_i32 s25, s20, s21
v_mov_b32 v25, s25
s_max_u32 s26, s20, s21
v_mov_b32 v26, s26
s_lshl_b64 s[28:29], s[20:21], 17
v_mov_b32 v28, s28
v_mov_b32 v29, s29
s_bitcmp1_b32 s20, 5
s_mov_b32 s31, 0x9876
s_cselect_b32 s30, 0x1234, s31
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
v_dot4_i32_i8 v18, v1, v2, v0
v_dot4_i32_i8 v19, v1, v2, v0 neg_lo:[1,1,0] clamp
v_dot8_i32_i4 v20, v1, v2, v0
v_dot8_i32_i4 v21, v1, v2, v0 neg_lo:[1,0,0]
v_dot4_u32_u8 v22, v1, v2, v0
v_dot8_u32_u4 v23, v1, v2, v0
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
v_cmp_eq_u32 vcc_lo, 31, v3
v_cndmask_b32 v12, v12, 16, vcc_lo
v_mov_b32 v13, 0
s_mov_b32 s12, exec_lo
s_mov_b32 s14, 0
s_and_b32 s15, s8, 15
s_add_u32 s15, s15, 1
s_xor_b32 s16, s8, 0xa5a50001
.Lloop:
s_mov_b32 exec_lo, s12
v_cmp_gt_u32 vcc_lo, v12, s14
s_lshl_b32 s18, s16, 5
s_lshr_b32 s19, s16, 27
s_or_b32 s16, s18, s19
s_xor_b32 s16, s16, 0x9e3779b9
s_and_b32 exec_lo, s16, vcc_lo
v_add_nc_u32 v16, v1, s14
v_xor_b32 v17, v16, v2
v_and_b32 v14, 1, v17
v_cmp_eq_u32 vcc_lo, 0, v14
s_and_saveexec_b32 s13, vcc_lo
v_fma_f32 v18, v4, 0.5, v18
v_xor_b32 v19, v19, v17
s_xor_b32 exec_lo, exec_lo, s13
v_add_f32 v18, v18, v5
v_add_nc_u32 v19, v19, v17
s_mov_b32 exec_lo, s13
v_add_nc_u32 v13, 1, v13
v_xor_b32 v22, v22, s16
s_add_u32 s14, s14, 1
s_cmp_lt_u32 s14, s15
s_cbranch_scc1 .Lloop
s_mov_b32 exec_lo, s12
v_mov_b32 v20, v13
v_mov_b32 v21, v12
v_mov_b32 v23, s14
; A second loop changes EXEC from full through progressively shifted masks.
s_mov_b32 s14, 0
s_mov_b32 s16, -1
.Luniform:
s_mov_b32 exec_lo, s16
v_xor_b32 v24, v24, v19
v_add_nc_u32 v25, v25, v1
v_add_nc_u32 v26, 1, v26
s_lshl_b32 s16, s16, 1
s_add_u32 s14, s14, 1
s_cmp_lt_u32 s14, s15
s_cbranch_scc1 .Luniform
s_mov_b32 exec_lo, s12
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
s_mov_b32 s12, exec_lo
s_mov_b32 exec_lo, -1
v_add_f32 v16, v4, s10
v_fma_f32 v17, v4, 0x3f800001, v6
v_mul_lo_u32 v18, v1, s8
v_cmp_lt_f32 vcc_lo, v4, v5
v_cndmask_b32 v19, v1, v2, vcc_lo
v_mov_b32 v20, vcc_lo
v_pk_add_f16 v21, 0x3c003800, v1 op_sel:[1,0] op_sel_hi:[0,1]
v_bcnt_u32_b32 v22, v1, 0
s_mov_b32 s16, exec_lo
s_bcnt1_i32_b32 s17, exec_lo
s_mov_b32 exec_lo, s12
v_mov_b32 v23, s16
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
s_mov_b32 s12, exec_lo
s_mov_b32 exec_lo, 0x55555555
v_add_f32 v16, v4, s10
v_fma_f32 v17, v4, 0x3f800001, v6
v_mul_lo_u32 v18, v1, s8
v_cmp_lt_f32 vcc_lo, v4, v5
v_cndmask_b32 v19, v1, v2, vcc_lo
v_mov_b32 v20, vcc_lo
v_pk_add_f16 v21, 0x3c003800, v1 op_sel:[1,0] op_sel_hi:[0,1]
v_bcnt_u32_b32 v22, v1, 0
s_mov_b32 s16, exec_lo
s_bcnt1_i32_b32 s17, exec_lo
s_mov_b32 exec_lo, s12
v_mov_b32 v23, s16
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
s_mov_b32 s12, exec_lo
s_mov_b32 exec_lo, 0x80010081
v_add_f32 v16, v4, s10
v_fma_f32 v17, v4, 0x3f800001, v6
v_mul_lo_u32 v18, v1, s8
v_cmp_lt_f32 vcc_lo, v4, v5
v_cndmask_b32 v19, v1, v2, vcc_lo
v_mov_b32 v20, vcc_lo
v_pk_add_f16 v21, 0x3c003800, v1 op_sel:[1,0] op_sel_hi:[0,1]
v_bcnt_u32_b32 v22, v1, 0
s_mov_b32 s16, exec_lo
s_bcnt1_i32_b32 s17, exec_lo
s_mov_b32 exec_lo, s12
v_mov_b32 v23, s16
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
s_mov_b32 s12, exec_lo
s_mov_b32 exec_lo, 0x80000000
v_add_f32 v16, v4, s10
v_fma_f32 v17, v4, 0x3f800001, v6
v_mul_lo_u32 v18, v1, s8
v_cmp_lt_f32 vcc_lo, v4, v5
v_cndmask_b32 v19, v1, v2, vcc_lo
v_mov_b32 v20, vcc_lo
v_pk_add_f16 v21, 0x3c003800, v1 op_sel:[1,0] op_sel_hi:[0,1]
v_bcnt_u32_b32 v22, v1, 0
s_mov_b32 s16, exec_lo
s_bcnt1_i32_b32 s17, exec_lo
s_mov_b32 exec_lo, s12
v_mov_b32 v23, s16
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
s_mov_b32 s12, exec_lo
s_mov_b32 exec_lo, 0
v_add_f32 v16, v4, s10
v_fma_f32 v17, v4, 0x3f800001, v6
v_mul_lo_u32 v18, v1, s8
v_cmp_lt_f32 vcc_lo, v4, v5
v_cndmask_b32 v19, v1, v2, vcc_lo
v_mov_b32 v20, vcc_lo
v_pk_add_f16 v21, 0x3c003800, v1 op_sel:[1,0] op_sel_hi:[0,1]
v_bcnt_u32_b32 v22, v1, 0
s_mov_b32 s16, exec_lo
s_bcnt1_i32_b32 s17, exec_lo
s_mov_b32 exec_lo, s12
v_mov_b32 v23, s16
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
v_permlane16_b32 v20, v1, s18, s19
v_permlanex16_b32 v21, v1, s18, s19
v_xor_b32 v12, 31, v3
v_lshlrev_b32 v12, 2, v12
ds_bpermute_b32 v22, v12, v1
ds_swizzle_b32 v23, v1 offset:0x041f
s_waitcnt lgkmcnt(0)
v_readfirstlane_b32 s16, v1
v_readlane_b32 s17, v1, 31
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_writelane_b32 v26, s8, 17
v_mbcnt_lo_u32_b32 v27, -1, 0
v_mbcnt_hi_u32_b32 v28, -1, v27
checkpoint 17


; Checkpoint 18: reduction
clear_results
v_mov_b32 v16, v0
; XOR butterfly: all lanes see the sum of their wave.
.irp shift,1,2,4,8,16
v_xor_b32 v12, \shift, v3
v_lshlrev_b32 v12, 2, v12
ds_bpermute_b32 v17, v12, v16
s_waitcnt lgkmcnt(0)
v_add_nc_u32 v16, v16, v17
.endr
; Cross-wave exchange through LDS, with converged barriers.
v_lshlrev_b32 v12, 2, v0
ds_write_b32 v12, v16
s_waitcnt lgkmcnt(0)
s_barrier
v_xor_b32 v13, 128, v12
ds_read_b32 v18, v13
s_waitcnt lgkmcnt(0)
v_add_nc_u32 v19, v16, v18
; Finish all peer reads before changing their LDS values.
s_barrier
; Per-lane atomics avoid ordering-dependent returned values.
ds_add_rtn_u32 v20, v12, v0
s_waitcnt lgkmcnt(0)
ds_read_b32 v21, v12
s_waitcnt lgkmcnt(0)
s_barrier
checkpoint 18










; Checkpoint 19: fp_mode_r0_d0
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 19


; Checkpoint 20: fp_mode_r1_d0
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 20


; Checkpoint 21: fp_mode_r2_d0
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 21


; Checkpoint 22: fp_mode_r3_d0
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 22


; Checkpoint 23: fp_mode_r0_d1
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 23


; Checkpoint 24: fp_mode_r1_d1
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 24


; Checkpoint 25: fp_mode_r2_d1
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 25


; Checkpoint 26: fp_mode_r3_d1
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 26


; Checkpoint 27: fp_mode_r0_d2
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 27


; Checkpoint 28: fp_mode_r1_d2
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 28


; Checkpoint 29: fp_mode_r2_d2
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 29


; Checkpoint 30: fp_mode_r3_d2
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 30


; Checkpoint 31: fp_mode_r0_d3
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 31


; Checkpoint 32: fp_mode_r1_d3
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 32


; Checkpoint 33: fp_mode_r2_d3
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 33


; Checkpoint 34: fp_mode_r3_d3
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 34


; Checkpoint 35: fp_mode_mixed_0
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 35


; Checkpoint 36: fp_mode_mixed_1
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 36


; Checkpoint 37: fp_mode_mixed_2
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 37


; Checkpoint 38: fp_mode_mixed_3
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
v_mov_b32 v30, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 0, 8), 240
checkpoint 38


; Checkpoint 39: special_values
clear_results
masked_begin 39
; Lane classes include both zeros, infinities, NaNs and denormals.
v_and_b32 v12, 3, v0
v_cmp_eq_u32 vcc_lo, 0, v12
v_cndmask_b32 v8, 0x7f800000, 0, vcc_lo
v_cmp_eq_u32 vcc_lo, 2, v12
v_cndmask_b32 v8, v8, 0x7fc12345, vcc_lo
v_cmp_eq_u32 vcc_lo, 3, v12
v_cndmask_b32 v8, v8, 1, vcc_lo
v_and_b32 v12, 4, v0
v_lshlrev_b32 v12, 29, v12
v_xor_b32 v8, v8, v12
v_min_f32 v16, v8, v4
v_max_f32 v17, v4, v8
v_add_f32 v18, v8, v4
v_mul_f32 v19, v8, 0
v_mul_legacy_f32 v20, v8, 0
v_add_f32 v21, v8, 0 clamp
v_cmp_class_f32 vcc_lo, v8, 3
v_mov_b32 v22, vcc_lo
v_cmp_class_f32 vcc_lo, v8, 0x3fc
v_mov_b32 v23, vcc_lo
v_cmp_u_f32 vcc_lo, v8, v4
v_mov_b32 v24, vcc_lo
v_cmp_o_f32 vcc_lo, v8, v4
v_mov_b32 v25, vcc_lo
v_cvt_f16_f32 v26, v8
v_cvt_f32_f16 v27, v26
v_cvt_f64_f32 v[28:29], v8
v_rcp_f32 v30, v8
v_sqrt_f32 v31, v8
masked_end 39
checkpoint 39


; Checkpoint 40: compare_f32
clear_results
masked_begin 40
v_mov_b32 v8, 0.5
v_cmp_lt_f32 vcc_lo, v4, v8
v_mov_b32 v16, vcc_lo
v_cmp_eq_f32 vcc_lo, v4, v8
v_mov_b32 v17, vcc_lo
v_cmp_le_f32 vcc_lo, v4, v8
v_mov_b32 v18, vcc_lo
v_cmp_gt_f32 vcc_lo, v4, v8
v_mov_b32 v19, vcc_lo
v_cmp_lg_f32 vcc_lo, v4, v8
v_mov_b32 v20, vcc_lo
v_cmp_ge_f32 vcc_lo, v4, v8
v_mov_b32 v21, vcc_lo
v_cmp_o_f32 vcc_lo, v4, v8
v_mov_b32 v22, vcc_lo
v_cmp_u_f32 vcc_lo, v4, v8
v_mov_b32 v23, vcc_lo
v_cmp_nge_f32 vcc_lo, v4, v8
v_mov_b32 v24, vcc_lo
v_cmp_nlg_f32 vcc_lo, v4, v8
v_mov_b32 v25, vcc_lo
v_cmp_ngt_f32 vcc_lo, v4, v8
v_mov_b32 v26, vcc_lo
v_cmp_nle_f32 vcc_lo, v4, v8
v_mov_b32 v27, vcc_lo
v_cmp_neq_f32 vcc_lo, v4, v8
v_mov_b32 v28, vcc_lo
v_cmp_nlt_f32 vcc_lo, v4, v8
v_mov_b32 v29, vcc_lo
masked_end 40
checkpoint 40


; Checkpoint 41: compare_f16
clear_results
masked_begin 41
v_cvt_f16_f32 v8, v4
v_mov_b32 v9, 0x3800
v_cmp_lt_f16 vcc_lo, v8, v9
v_mov_b32 v16, vcc_lo
v_cmp_eq_f16 vcc_lo, v8, v9
v_mov_b32 v17, vcc_lo
v_cmp_le_f16 vcc_lo, v8, v9
v_mov_b32 v18, vcc_lo
v_cmp_gt_f16 vcc_lo, v8, v9
v_mov_b32 v19, vcc_lo
v_cmp_lg_f16 vcc_lo, v8, v9
v_mov_b32 v20, vcc_lo
v_cmp_ge_f16 vcc_lo, v8, v9
v_mov_b32 v21, vcc_lo
v_cmp_o_f16 vcc_lo, v8, v9
v_mov_b32 v22, vcc_lo
v_cmp_u_f16 vcc_lo, v8, v9
v_mov_b32 v23, vcc_lo
v_cmp_nge_f16 vcc_lo, v8, v9
v_mov_b32 v24, vcc_lo
v_cmp_nlg_f16 vcc_lo, v8, v9
v_mov_b32 v25, vcc_lo
v_cmp_ngt_f16 vcc_lo, v8, v9
v_mov_b32 v26, vcc_lo
v_cmp_nle_f16 vcc_lo, v8, v9
v_mov_b32 v27, vcc_lo
v_cmp_neq_f16 vcc_lo, v8, v9
v_mov_b32 v28, vcc_lo
v_cmp_nlt_f16 vcc_lo, v8, v9
v_mov_b32 v29, vcc_lo
masked_end 41
checkpoint 41


; Checkpoint 42: compare_f64
clear_results
masked_begin 42
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], 0.5
v_cmp_lt_f64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v16, vcc_lo
v_cmp_eq_f64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v17, vcc_lo
v_cmp_le_f64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v18, vcc_lo
v_cmp_gt_f64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v19, vcc_lo
v_cmp_lg_f64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v20, vcc_lo
v_cmp_ge_f64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v21, vcc_lo
v_cmp_o_f64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v22, vcc_lo
v_cmp_u_f64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v23, vcc_lo
v_cmp_nge_f64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v24, vcc_lo
v_cmp_nlg_f64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v25, vcc_lo
v_cmp_ngt_f64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v26, vcc_lo
v_cmp_nle_f64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v27, vcc_lo
v_cmp_neq_f64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v28, vcc_lo
v_cmp_nlt_f64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v29, vcc_lo
; Use a VGPR class mask to retain the compact VOPC encoding.
v_mov_b32 v12, 0x1ff
v_cmp_class_f64_e32 vcc_lo, v[8:9], v12
v_mov_b32 v30, vcc_lo
v_mov_b32 v12, 0x200
v_cmp_class_f64_e32 vcc_lo, v[8:9], v12
v_mov_b32 v31, vcc_lo
masked_end 42
checkpoint 42


; Checkpoint 43: compare_i16
clear_results
masked_begin 43
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v2
v_mov_b32 v11, v1
v_cmp_lt_i16 vcc_lo, v1, v2
v_mov_b32 v16, vcc_lo
v_cmp_eq_i16 vcc_lo, v1, v2
v_mov_b32 v17, vcc_lo
v_cmp_le_i16 vcc_lo, v1, v2
v_mov_b32 v18, vcc_lo
v_cmp_gt_i16 vcc_lo, v1, v2
v_mov_b32 v19, vcc_lo
v_cmp_ne_i16 vcc_lo, v1, v2
v_mov_b32 v20, vcc_lo
v_cmp_ge_i16 vcc_lo, v1, v2
v_mov_b32 v21, vcc_lo
masked_end 43
checkpoint 43


; Checkpoint 44: compare_u16
clear_results
masked_begin 44
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v2
v_mov_b32 v11, v1
v_cmp_lt_u16 vcc_lo, v1, v2
v_mov_b32 v16, vcc_lo
v_cmp_eq_u16 vcc_lo, v1, v2
v_mov_b32 v17, vcc_lo
v_cmp_le_u16 vcc_lo, v1, v2
v_mov_b32 v18, vcc_lo
v_cmp_gt_u16 vcc_lo, v1, v2
v_mov_b32 v19, vcc_lo
v_cmp_ne_u16 vcc_lo, v1, v2
v_mov_b32 v20, vcc_lo
v_cmp_ge_u16 vcc_lo, v1, v2
v_mov_b32 v21, vcc_lo
masked_end 44
checkpoint 44


; Checkpoint 45: compare_i32
clear_results
masked_begin 45
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v2
v_mov_b32 v11, v1
v_cmp_lt_i32 vcc_lo, v1, v2
v_mov_b32 v16, vcc_lo
v_cmp_eq_i32 vcc_lo, v1, v2
v_mov_b32 v17, vcc_lo
v_cmp_le_i32 vcc_lo, v1, v2
v_mov_b32 v18, vcc_lo
v_cmp_gt_i32 vcc_lo, v1, v2
v_mov_b32 v19, vcc_lo
v_cmp_ne_i32 vcc_lo, v1, v2
v_mov_b32 v20, vcc_lo
v_cmp_ge_i32 vcc_lo, v1, v2
v_mov_b32 v21, vcc_lo
masked_end 45
checkpoint 45


; Checkpoint 46: compare_u32
clear_results
masked_begin 46
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v2
v_mov_b32 v11, v1
v_cmp_lt_u32 vcc_lo, v1, v2
v_mov_b32 v16, vcc_lo
v_cmp_eq_u32 vcc_lo, v1, v2
v_mov_b32 v17, vcc_lo
v_cmp_le_u32 vcc_lo, v1, v2
v_mov_b32 v18, vcc_lo
v_cmp_gt_u32 vcc_lo, v1, v2
v_mov_b32 v19, vcc_lo
v_cmp_ne_u32 vcc_lo, v1, v2
v_mov_b32 v20, vcc_lo
v_cmp_ge_u32 vcc_lo, v1, v2
v_mov_b32 v21, vcc_lo
masked_end 46
checkpoint 46


; Checkpoint 47: compare_i64
clear_results
masked_begin 47
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v2
v_mov_b32 v11, v1
v_cmp_lt_i64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v16, vcc_lo
v_cmp_eq_i64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v17, vcc_lo
v_cmp_le_i64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v18, vcc_lo
v_cmp_gt_i64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v19, vcc_lo
v_cmp_ne_i64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v20, vcc_lo
v_cmp_ge_i64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v21, vcc_lo
masked_end 47
checkpoint 47


; Checkpoint 48: compare_u64
clear_results
masked_begin 48
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v2
v_mov_b32 v11, v1
v_cmp_lt_u64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v16, vcc_lo
v_cmp_eq_u64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v17, vcc_lo
v_cmp_le_u64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v18, vcc_lo
v_cmp_gt_u64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v19, vcc_lo
v_cmp_ne_u64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v20, vcc_lo
v_cmp_ge_u64 vcc_lo, v[8:9], v[10:11]
v_mov_b32 v21, vcc_lo
masked_end 48
checkpoint 48


; Checkpoint 49: compare_exec
clear_results
s_mov_b32 s12, exec_lo
v_cmpx_lt_u32 16, v3
v_mov_b32 v16, exec_lo
v_add_nc_u32 v17, v1, v2
s_mov_b32 exec_lo, s12
v_cmpx_eq_u32 0, v3
v_mov_b32 v18, exec_lo
v_mul_f32 v19, v4, v5
s_mov_b32 exec_lo, s12
v_cmpx_eq_u32 64, v3
v_add_nc_u32 v20, v1, v2
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, s12
v_mov_b32 v21, s16
v_cvt_f64_f32 v[8:9], v4
v_mov_b32 v12, 0x108
v_cmpx_class_f64_e32 v[8:9], v12
s_mov_b32 s16, exec_lo
v_mov_b32 v22, exec_lo
s_mov_b32 exec_lo, s12
v_mov_b32 v23, s16
checkpoint 49








; Checkpoint 50: fp16_overflow_0
clear_results
masked_begin 50
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
v_mov_b32 v24, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 23, 1), 0
masked_end 50
checkpoint 50


; Checkpoint 51: fp16_overflow_1
clear_results
masked_begin 51
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
v_mov_b32 v24, s16
s_setreg_imm32_b32 hwreg(HW_REG_MODE, 23, 1), 0
masked_end 51
checkpoint 51


; Checkpoint 52: dpp_masks
clear_results
s_mov_b32 s12, exec_lo
s_mov_b32 exec_lo, 0x55555555
v_mov_b32 v16, v1 row_shl:1 bound_ctrl:0 fi:0
v_mov_b32 v17, v1 row_shl:1 bound_ctrl:1 fi:0
v_mov_b32 v18, v1 row_shl:1 bound_ctrl:0 fi:1
v_mov_b32 v19, v1 row_shl:1 bound_ctrl:1 fi:1
v_add_f32 v20, v4, v5 row_shr:1 row_mask:0x1 bank_mask:0x5 bound_ctrl:0
v_add_f32 v21, v4, v5 row_shr:1 row_mask:0x2 bank_mask:0xa bound_ctrl:1
v_mov_b32 v22, v1 dpp8:[1,0,3,2,5,4,7,6] fi:0
v_mov_b32 v23, v1 dpp8:[1,0,3,2,5,4,7,6] fi:1
s_mov_b32 exec_lo, s12
checkpoint 52


; Checkpoint 53: fused_literals
clear_results
masked_begin 53
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
masked_end 53
checkpoint 53



; Checkpoint 54: fp64_transcendental
clear_results
masked_begin 54
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
masked_end 54
checkpoint 54


; Checkpoint 55: division_cube
clear_results
masked_begin 55
v_div_scale_f32 v16, vcc_lo, v4, v5, v4
v_mov_b32 v17, vcc_lo
v_div_fmas_f32 v18, v4, v5, v6
v_rcp_f32 v8, v5
s_waitcnt_depctr depctr_va_vdst(0)
v_mul_f32 v8, v8, v4
v_div_fixup_f32 v19, v8, v5, v4
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_div_scale_f64 v[20:21], vcc_lo, v[8:9], v[10:11], v[8:9]
v_div_fmas_f64 v[22:23], v[8:9], v[10:11], v[8:9]
v_div_fixup_f64 v[24:25], v[8:9], v[10:11], v[8:9]
v_cubeid_f32 v26, v4, v5, v6
v_cubema_f32 v27, v4, v5, v6
v_cubesc_f32 v28, v4, v5, v6
v_cubetc_f32 v29, v4, v5, v6
v_trig_preop_f64 v[30:31], v[8:9], 0
masked_end 55
checkpoint 55

; Checkpoint 56: integer_e64
clear_results
masked_begin 56
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
masked_end 56
checkpoint 56

; Checkpoint 57: bits_e64
clear_results
masked_begin 57
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
masked_end 57
checkpoint 57

; Checkpoint 58: carry_e64
clear_results
masked_begin 58
v_add_co_u32 v16, vcc_lo, v1, v2
v_add_co_ci_u32_e64 v17, vcc_lo, v2, v1, vcc_lo
v_mov_b32_e64 v18, vcc_lo
v_sub_co_u32 v19, vcc_lo, v1, v2
v_sub_co_ci_u32_e64 v20, vcc_lo, v2, v1, vcc_lo
v_mov_b32_e64 v21, vcc_lo
v_mad_u64_u32 v[22:23], s20, v1, v2, v[16:17]
v_mad_i64_i32 v[24:25], s21, v1, v2, v[16:17]
v_lshlrev_b64_e64 v[26:27], v0, v[1:2]
v_lshrrev_b64 v[28:29], v0, v[1:2]
v_ashrrev_i64 v[30:31], v0, v[1:2]
masked_end 58
checkpoint 58

; Checkpoint 59: fp32_e64
clear_results
masked_begin 59
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
masked_end 59
checkpoint 59

; Checkpoint 60: transcendental_e64
clear_results
masked_begin 60
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
masked_end 60
checkpoint 60

; Checkpoint 61: conversion_e64
clear_results
masked_begin 61
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
masked_end 61
checkpoint 61

; Checkpoint 62: fp16_e64
clear_results
masked_begin 62
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
v_fma_f16 v23, -v8, |v9|, v8 op_sel:[1,0,1,1] div:2
v_rcp_f16_e64 v24, v9
v_sqrt_f16_e64 v25, v9
v_rsq_f16_e64 v26, v9
v_exp_f16_e64 v27, v8
v_log_f16_e64 v28, v9
v_floor_f16_e64 v29, v8
v_ceil_f16_e64 v30, v8
v_rndne_f16_e64 v31, v8
masked_end 62
checkpoint 62

; Checkpoint 63: fp64_e64
clear_results
masked_begin 63
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
masked_end 63
checkpoint 63

; Checkpoint 64: compare_f32_e64
clear_results
masked_begin 64
v_mov_b32_e64 v8, 0.5
v_cmp_lt_f32_e64 vcc_lo, v4, v8
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_f32_e64 vcc_lo, v4, v8
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_f32_e64 vcc_lo, v4, v8
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_f32_e64 vcc_lo, v4, v8
v_mov_b32_e64 v19, vcc_lo
v_cmp_lg_f32_e64 vcc_lo, v4, v8
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_f32_e64 vcc_lo, v4, v8
v_mov_b32_e64 v21, vcc_lo
v_cmp_o_f32_e64 vcc_lo, v4, v8
v_mov_b32_e64 v22, vcc_lo
v_cmp_u_f32_e64 vcc_lo, v4, v8
v_mov_b32_e64 v23, vcc_lo
v_cmp_nge_f32_e64 vcc_lo, v4, v8
v_mov_b32_e64 v24, vcc_lo
v_cmp_nlg_f32_e64 vcc_lo, v4, v8
v_mov_b32_e64 v25, vcc_lo
v_cmp_ngt_f32_e64 vcc_lo, v4, v8
v_mov_b32_e64 v26, vcc_lo
v_cmp_nle_f32_e64 vcc_lo, v4, v8
v_mov_b32_e64 v27, vcc_lo
v_cmp_neq_f32_e64 vcc_lo, v4, v8
v_mov_b32_e64 v28, vcc_lo
v_cmp_nlt_f32_e64 vcc_lo, v4, v8
v_mov_b32_e64 v29, vcc_lo
masked_end 64
checkpoint 64

; Checkpoint 65: compare_f16_e64
clear_results
masked_begin 65
v_cvt_f16_f32_e64 v8, v4
v_mov_b32_e64 v9, 0x3800
v_cmp_lt_f16_e64 vcc_lo, v8, v9
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_f16_e64 vcc_lo, v8, v9
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_f16_e64 vcc_lo, v8, v9
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_f16_e64 vcc_lo, v8, v9
v_mov_b32_e64 v19, vcc_lo
v_cmp_lg_f16_e64 vcc_lo, v8, v9
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_f16_e64 vcc_lo, v8, v9
v_mov_b32_e64 v21, vcc_lo
v_cmp_o_f16_e64 vcc_lo, v8, v9
v_mov_b32_e64 v22, vcc_lo
v_cmp_u_f16_e64 vcc_lo, v8, v9
v_mov_b32_e64 v23, vcc_lo
v_cmp_nge_f16_e64 vcc_lo, v8, v9
v_mov_b32_e64 v24, vcc_lo
v_cmp_nlg_f16_e64 vcc_lo, v8, v9
v_mov_b32_e64 v25, vcc_lo
v_cmp_ngt_f16_e64 vcc_lo, v8, v9
v_mov_b32_e64 v26, vcc_lo
v_cmp_nle_f16_e64 vcc_lo, v8, v9
v_mov_b32_e64 v27, vcc_lo
v_cmp_neq_f16_e64 vcc_lo, v8, v9
v_mov_b32_e64 v28, vcc_lo
v_cmp_nlt_f16_e64 vcc_lo, v8, v9
v_mov_b32_e64 v29, vcc_lo
masked_end 65
checkpoint 65

; Checkpoint 66: compare_f64_e64
clear_results
masked_begin 66
v_cvt_f64_f32_e64 v[8:9], v4
v_cvt_f64_f32_e64 v[10:11], 0.5
v_cmp_lt_f64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_f64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_f64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_f64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v19, vcc_lo
v_cmp_lg_f64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_f64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v21, vcc_lo
v_cmp_o_f64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v22, vcc_lo
v_cmp_u_f64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v23, vcc_lo
v_cmp_nge_f64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v24, vcc_lo
v_cmp_nlg_f64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v25, vcc_lo
v_cmp_ngt_f64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v26, vcc_lo
v_cmp_nle_f64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v27, vcc_lo
v_cmp_neq_f64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v28, vcc_lo
v_cmp_nlt_f64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v29, vcc_lo
v_cmp_class_f64_e64 vcc_lo, v[8:9], 0x1ff
v_mov_b32 v30, vcc_lo
v_cmp_class_f64_e64 vcc_lo, v[8:9], 0x200
v_mov_b32 v31, vcc_lo
masked_end 66
checkpoint 66

; Checkpoint 67: compare_i16_e64
clear_results
masked_begin 67
v_mov_b32_e64 v8, v1
v_mov_b32_e64 v9, v2
v_mov_b32_e64 v10, v2
v_mov_b32_e64 v11, v1
v_cmp_lt_i16_e64 vcc_lo, v1, v2
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_i16_e64 vcc_lo, v1, v2
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_i16_e64 vcc_lo, v1, v2
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_i16_e64 vcc_lo, v1, v2
v_mov_b32_e64 v19, vcc_lo
v_cmp_ne_i16_e64 vcc_lo, v1, v2
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_i16_e64 vcc_lo, v1, v2
v_mov_b32_e64 v21, vcc_lo
masked_end 67
checkpoint 67

; Checkpoint 68: compare_u16_e64
clear_results
masked_begin 68
v_mov_b32_e64 v8, v1
v_mov_b32_e64 v9, v2
v_mov_b32_e64 v10, v2
v_mov_b32_e64 v11, v1
v_cmp_lt_u16_e64 vcc_lo, v1, v2
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_u16_e64 vcc_lo, v1, v2
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_u16_e64 vcc_lo, v1, v2
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_u16_e64 vcc_lo, v1, v2
v_mov_b32_e64 v19, vcc_lo
v_cmp_ne_u16_e64 vcc_lo, v1, v2
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_u16_e64 vcc_lo, v1, v2
v_mov_b32_e64 v21, vcc_lo
masked_end 68
checkpoint 68

; Checkpoint 69: compare_i32_e64
clear_results
masked_begin 69
v_mov_b32_e64 v8, v1
v_mov_b32_e64 v9, v2
v_mov_b32_e64 v10, v2
v_mov_b32_e64 v11, v1
v_cmp_lt_i32_e64 vcc_lo, v1, v2
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_i32_e64 vcc_lo, v1, v2
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_i32_e64 vcc_lo, v1, v2
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_i32_e64 vcc_lo, v1, v2
v_mov_b32_e64 v19, vcc_lo
v_cmp_ne_i32_e64 vcc_lo, v1, v2
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_i32_e64 vcc_lo, v1, v2
v_mov_b32_e64 v21, vcc_lo
masked_end 69
checkpoint 69

; Checkpoint 70: compare_u32_e64
clear_results
masked_begin 70
v_mov_b32_e64 v8, v1
v_mov_b32_e64 v9, v2
v_mov_b32_e64 v10, v2
v_mov_b32_e64 v11, v1
v_cmp_lt_u32_e64 vcc_lo, v1, v2
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_u32_e64 vcc_lo, v1, v2
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_u32_e64 vcc_lo, v1, v2
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_u32_e64 vcc_lo, v1, v2
v_mov_b32_e64 v19, vcc_lo
v_cmp_ne_u32_e64 vcc_lo, v1, v2
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_u32_e64 vcc_lo, v1, v2
v_mov_b32_e64 v21, vcc_lo
masked_end 70
checkpoint 70

; Checkpoint 71: compare_i64_e64
clear_results
masked_begin 71
v_mov_b32_e64 v8, v1
v_mov_b32_e64 v9, v2
v_mov_b32_e64 v10, v2
v_mov_b32_e64 v11, v1
v_cmp_lt_i64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_i64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_i64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_i64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v19, vcc_lo
v_cmp_ne_i64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_i64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v21, vcc_lo
masked_end 71
checkpoint 71

; Checkpoint 72: compare_u64_e64
clear_results
masked_begin 72
v_mov_b32_e64 v8, v1
v_mov_b32_e64 v9, v2
v_mov_b32_e64 v10, v2
v_mov_b32_e64 v11, v1
v_cmp_lt_u64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v16, vcc_lo
v_cmp_eq_u64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v17, vcc_lo
v_cmp_le_u64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v18, vcc_lo
v_cmp_gt_u64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v19, vcc_lo
v_cmp_ne_u64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v20, vcc_lo
v_cmp_ge_u64_e64 vcc_lo, v[8:9], v[10:11]
v_mov_b32_e64 v21, vcc_lo
masked_end 72
checkpoint 72


; Each sweep operation owns a pair: result bits followed by carry/compare bits.
; Inputs include lane variation; inactive lanes and untouched halves retain a sentinel.
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
s_mov_b32 vcc_lo, s23
s_mov_b32 s20, 0
.endm
; Checkpoint 73: vop1_plain_00
clear_results
masked_begin 73
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_bfrev_b32 v16, v8
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_ceil_f16 v18, v8
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_ceil_f32 v20, v8
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
v_cos_f16 v26, v8
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_cos_f32 v28, v8
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
masked_end 73
checkpoint 73

; Checkpoint 74: vop1_plain_01
clear_results
masked_begin 74
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_cvt_f16_f32 v20, v8
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cvt_f16_i16 v22, v8
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
v_cvt_f16_u16 v24, v8
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
v_cvt_f32_f16 v26, v8
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_f32_i32 v28, v8
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_f32_u32 v30, v8
masked_end 74
checkpoint 74

; Checkpoint 75: vop1_plain_02
clear_results
masked_begin 75
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
v_cvt_flr_i32_f32 v24, v8
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cvt_flr_i32_f32 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_i16_f16 v28, v8
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_i32_f32 v30, v8
masked_end 75
checkpoint 75

; Checkpoint 76: vop1_plain_03
clear_results
masked_begin 76
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cvt_norm_i16_f16 v20, v8
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
v_cvt_norm_u16_f16 v22, v8
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
v_cvt_off_f32_i4 v24, v8
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cvt_rpi_i32_f32 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_u16_f16 v28, v8
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_u32_f32 v30, v8
masked_end 76
checkpoint 76

; Checkpoint 77: vop1_plain_04
clear_results
masked_begin 77
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_exp_f16 v18, v8
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
v_floor_f16 v28, v8
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_floor_f32 v30, v8
masked_end 77
checkpoint 77

; Checkpoint 78: vop1_plain_05
clear_results
masked_begin 78
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_fract_f16 v16, v8
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_fract_f32 v18, v8
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_frexp_exp_i16_f16 v20, v8
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_frexp_exp_i32_f32 v22, v8
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_frexp_mant_f16 v24, v8
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_frexp_mant_f32 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_log_f16 v28, v8
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_log_f32 v30, v8
masked_end 78
checkpoint 78

; Checkpoint 79: vop1_plain_06
clear_results
masked_begin 79
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
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_not_b32 v28, v8
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
v_rcp_f16 v30, v8
masked_end 79
checkpoint 79

; Checkpoint 80: vop1_plain_07
clear_results
masked_begin 80
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
v_rcp_f32 v16, v8
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_rcp_iflag_f32 v18, v8
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_rndne_f16 v20, v8
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_rndne_f32 v22, v8
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_rsq_f16 v24, v8
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_rsq_f32 v26, v8
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_sat_pk_u8_i16 v28, v8
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
v_sin_f16 v30, v8
masked_end 80
checkpoint 80

; Checkpoint 81: vop1_plain_08
clear_results
masked_begin 81
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
v_sin_f32 v16, v8
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_sqrt_f16 v18, v8
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_sqrt_f32 v20, v8
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
v_trunc_f16 v22, v8
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
v_trunc_f32 v24, v8
masked_end 81
checkpoint 81

; Checkpoint 82: vop1_dpp16_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_bfrev_b32 v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_ceil_f16 v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_ceil_f32 v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cos_f16 v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cos_f32 v28, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
s_mov_b32 exec_lo, -1
checkpoint 82

; Checkpoint 83: vop1_dpp16_01
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_f16_f32 v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_f16_i16 v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_f16_u16 v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_f32_f16 v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_f32_i32 v28, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_f32_u32 v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
checkpoint 83

; Checkpoint 84: vop1_dpp16_02
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_f32_ubyte0 v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_f32_ubyte1 v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_f32_ubyte2 v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_f32_ubyte3 v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_flr_i32_f32 v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_flr_i32_f32 v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_i16_f16 v28, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_i32_f32 v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
checkpoint 84

; Checkpoint 85: vop1_dpp16_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_norm_i16_f16 v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_norm_u16_f16 v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_off_f32_i4 v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_rpi_i32_f32 v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_u16_f16 v28, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_u32_f32 v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
checkpoint 85

; Checkpoint 86: vop1_dpp16_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_exp_f16 v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_exp_f32 v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_ffbh_i32 v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_ffbh_u32 v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_ffbl_b32 v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_floor_f16 v28, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_floor_f32 v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
checkpoint 86

; Checkpoint 87: vop1_dpp16_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_fract_f16 v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_fract_f32 v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_frexp_exp_i16_f16 v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_frexp_exp_i32_f32 v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_frexp_mant_f16 v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_frexp_mant_f32 v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_log_f16 v28, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_log_f32 v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
checkpoint 87

; Checkpoint 88: vop1_dpp16_06
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_mov_b32 v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_movreld_b32 v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_movrels_b32 v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_movrelsd_2_b32 v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_movrelsd_b32 v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_not_b32 v28, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_rcp_f16 v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
checkpoint 88

; Checkpoint 89: vop1_dpp16_07
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_rcp_f32 v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_rcp_iflag_f32 v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_rndne_f16 v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_rndne_f32 v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_rsq_f16 v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_rsq_f32 v26, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_sat_pk_u8_i16 v28, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_sin_f16 v30, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
checkpoint 89

; Checkpoint 90: vop1_dpp16_08
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_sin_f32 v16, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_sqrt_f16 v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_sqrt_f32 v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_trunc_f16 v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_trunc_f32 v24, v8 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
checkpoint 90

; Checkpoint 91: vop1_dpp8_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_bfrev_b32 v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_ceil_f32 v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cos_f32 v28, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
checkpoint 91

; Checkpoint 92: vop1_dpp8_01
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cvt_f32_i32 v28, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cvt_f32_u32 v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
checkpoint 92

; Checkpoint 93: vop1_dpp8_02
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cvt_f32_ubyte0 v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cvt_f32_ubyte1 v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cvt_f32_ubyte2 v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cvt_f32_ubyte3 v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cvt_flr_i32_f32 v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cvt_flr_i32_f32 v26, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cvt_i32_f32 v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
checkpoint 93

; Checkpoint 94: vop1_dpp8_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cvt_off_f32_i4 v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cvt_rpi_i32_f32 v26, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cvt_u32_f32 v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
checkpoint 94

; Checkpoint 95: vop1_dpp8_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_exp_f32 v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_ffbh_i32 v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_ffbh_u32 v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_ffbl_b32 v26, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_floor_f32 v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
checkpoint 95

; Checkpoint 96: vop1_dpp8_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_fract_f32 v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_frexp_exp_i32_f32 v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_frexp_mant_f32 v26, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_log_f32 v30, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
checkpoint 96

; Checkpoint 97: vop1_dpp8_06
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_mov_b32 v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_movreld_b32 v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_movrels_b32 v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_movrelsd_2_b32 v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_movrelsd_b32 v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_not_b32 v28, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
checkpoint 97

; Checkpoint 98: vop1_dpp8_07
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_rcp_f32 v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_rcp_iflag_f32 v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_rndne_f32 v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_rsq_f32 v26, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
checkpoint 98

; Checkpoint 99: vop1_dpp8_08
clear_results
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_sin_f32 v16, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_sqrt_f32 v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_trunc_f32 v24, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
checkpoint 99

; Checkpoint 100: vop2_plain_00
clear_results
masked_begin 100
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_add_co_ci_u32 v16, vcc_lo, v8, v9, vcc_lo
v_mov_b32 v17, vcc_lo
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_add_f16 v18, v8, v9
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
v_cndmask_b32 v28, v8, v9, vcc_lo
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_pkrtz_f16_f32 v30, v8, v9
masked_end 100
checkpoint 100

; Checkpoint 101: vop2_plain_01
clear_results
masked_begin 101
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_fmac_f16 v16, v8, v9
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_fmac_f32 v18, v8, v9
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_and_b32 v9, 7, v0
v_ldexp_f16 v20, v8, v9
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_lshlrev_b32 v22, v8, v9
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_lshrrev_b32 v24, v8, v9
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
v_max_f16 v26, v8, v9
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_max_f32 v28, v8, v9
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_max_i32 v30, v8, v9
masked_end 101
checkpoint 101

; Checkpoint 102: vop2_plain_02
clear_results
masked_begin 102
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_max_u32 v16, v8, v9
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_min_f16 v18, v8, v9
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
v_mul_f16 v28, v8, v9
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_mul_f32 v30, v8, v9
masked_end 102
checkpoint 102

; Checkpoint 103: vop2_plain_03
clear_results
masked_begin 103
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
v_sub_co_ci_u32 v26, vcc_lo, v8, v9, vcc_lo
v_mov_b32 v27, vcc_lo
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_sub_f16 v28, v8, v9
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_sub_f32 v30, v8, v9
masked_end 103
checkpoint 103

; Checkpoint 104: vop2_plain_04
clear_results
masked_begin 104
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_sub_nc_u32 v16, v8, v9
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_subrev_co_ci_u32 v18, vcc_lo, v8, v9, vcc_lo
v_mov_b32 v19, vcc_lo
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_subrev_f16 v20, v8, v9
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
masked_end 104
checkpoint 104

; Checkpoint 105: vop2_dpp16_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_add_co_ci_u32 v16, vcc_lo, v8, v9, vcc_lo row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
v_mov_b32 v17, vcc_lo
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_add_f16 v18, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_add_f32 v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_add_nc_u32 v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_and_b32 v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_ashrrev_i32 v26, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cndmask_b32 v28, v8, v9, vcc_lo row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cvt_pkrtz_f16_f32 v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
checkpoint 105

; Checkpoint 106: vop2_dpp16_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_fmac_f16 v16, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_fmac_f32 v18, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_and_b32 v9, 7, v0
s_mov_b32 exec_lo, -1
v_ldexp_f16 v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_lshlrev_b32 v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_lshrrev_b32 v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_max_f16 v26, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_max_f32 v28, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_max_i32 v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
checkpoint 106

; Checkpoint 107: vop2_dpp16_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_max_u32 v16, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_min_f16 v18, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_min_f32 v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_min_i32 v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_min_u32 v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_mul_legacy_f32 v26, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_mul_f16 v28, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_mul_f32 v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
checkpoint 107

; Checkpoint 108: vop2_dpp16_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_mul_hi_i32_i24 v16, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_mul_hi_u32_u24 v18, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_mul_i32_i24 v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_mul_u32_u24 v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_or_b32 v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_sub_co_ci_u32 v26, vcc_lo, v8, v9, vcc_lo row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
v_mov_b32 v27, vcc_lo
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_sub_f16 v28, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_sub_f32 v30, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
checkpoint 108

; Checkpoint 109: vop2_dpp16_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_sub_nc_u32 v16, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_subrev_co_ci_u32 v18, vcc_lo, v8, v9, vcc_lo row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
v_mov_b32 v19, vcc_lo
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_subrev_f16 v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_subrev_f32 v22, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_subrev_nc_u32 v24, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_xnor_b32 v26, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_xor_b32 v28, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
checkpoint 109

; Checkpoint 110: vop2_dpp8_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_add_co_ci_u32 v16, vcc_lo, v8, v9, vcc_lo dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
v_mov_b32 v17, vcc_lo
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_add_f32 v20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_add_nc_u32 v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_and_b32 v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_ashrrev_i32 v26, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cndmask_b32 v28, v8, v9, vcc_lo dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_cvt_pkrtz_f16_f32 v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
checkpoint 110

; Checkpoint 111: vop2_dpp8_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_fmac_f32 v18, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_and_b32 v9, 7, v0
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_lshlrev_b32 v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_lshrrev_b32 v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_max_f32 v28, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_max_i32 v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
checkpoint 111

; Checkpoint 112: vop2_dpp8_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_max_u32 v16, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_min_f32 v20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_min_i32 v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_min_u32 v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_mul_legacy_f32 v26, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_mul_f32 v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
checkpoint 112

; Checkpoint 113: vop2_dpp8_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_mul_hi_i32_i24 v16, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_mul_hi_u32_u24 v18, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_mul_i32_i24 v20, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_mul_u32_u24 v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_or_b32 v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_sub_co_ci_u32 v26, vcc_lo, v8, v9, vcc_lo dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
v_mov_b32 v27, vcc_lo
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_sub_f32 v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
checkpoint 113

; Checkpoint 114: vop2_dpp8_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_sub_nc_u32 v16, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_subrev_co_ci_u32 v18, vcc_lo, v8, v9, vcc_lo dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
v_mov_b32 v19, vcc_lo
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_subrev_f32 v22, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_subrev_nc_u32 v24, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_xnor_b32 v26, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_xor_b32 v28, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
checkpoint 114

; Checkpoint 115: vop3_plain_00
clear_results
masked_begin 115
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_add3_u32_e64 v16, v8, v9, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_add_co_u32_e64 v18, s20, v8, v9
v_mov_b32 v19, s20
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_add_lshl_u32_e64 v20, v8, v9, v10
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_add_nc_i16_e64 v22, v8, v9
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_add_nc_i32_e64 v24, v8, v9
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_add_nc_u16_e64 v26, v8, v9
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_alignbit_b32_e64 v28, v8, v9, v10
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_alignbyte_b32_e64 v30, v8, v9, v10
masked_end 115
checkpoint 115

; Checkpoint 116: vop3_plain_01
clear_results
masked_begin 116
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_and_or_b32_e64 v18, v8, v9, v10
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_ashrrev_i16_e64 v20, v8, v9
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
masked_end 116
checkpoint 116

; Checkpoint 117: vop3_plain_02
clear_results
masked_begin 117
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
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
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
masked_end 117
checkpoint 117

; Checkpoint 118: vop3_plain_03
clear_results
masked_begin 118
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cvt_pk_i16_i32_e64 v16, v8, v9
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_pk_u16_u32_e64 v28, v8, v9
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_pk_u8_f32_e64 v30, v8, v9, v10
masked_end 118
checkpoint 118

; Checkpoint 119: vop3_plain_04
clear_results
masked_begin 119
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, v1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, v1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_div_fixup_f16_e64 v20, v8, v9, v10
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_fma_f16_e64 v28, v8, v9, v10
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_fma_f32_e64 v30, v8, v9, v10
masked_end 119
checkpoint 119

; Checkpoint 120: vop3_plain_05
clear_results
masked_begin 120
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
v_lshlrev_b16_e64 v24, v8, v9
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_lshrrev_b16_e64 v26, v8, v9
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_mad_i16_e64 v28, v8, v9, v10
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_mad_i32_i16_e64 v30, v8, v9, v10
masked_end 120
checkpoint 120

; Checkpoint 121: vop3_plain_06
clear_results
masked_begin 121
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_mad_i32_i24_e64 v16, v8, v9, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_mad_u16_e64 v18, v8, v9, v10
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_mad_u32_u16_e64 v20, v8, v9, v10
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_mad_u32_u24_e64 v22, v8, v9, v10
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_max3_f16_e64 v24, v8, v9, v10
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_max3_f32_e64 v26, v8, v9, v10
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_max3_i16_e64 v28, v8, v9, v10
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_max3_i32_e64 v30, v8, v9, v10
masked_end 121
checkpoint 121

; Checkpoint 122: vop3_plain_07
clear_results
masked_begin 122
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_max3_u16_e64 v16, v8, v9, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_max3_u32_e64 v18, v8, v9, v10
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_max_i16_e64 v20, v8, v9
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_max_u16_e64 v22, v8, v9
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
masked_end 122
checkpoint 122

; Checkpoint 123: vop3_plain_08
clear_results
masked_begin 123
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_mbcnt_hi_u32_b32_e64 v28, v8, v9
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_mbcnt_lo_u32_b32_e64 v30, v8, v9
masked_end 123
checkpoint 123

; Checkpoint 124: vop3_plain_09
clear_results
masked_begin 124
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_med3_f16_e64 v16, v8, v9, v10
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_med3_f32_e64 v18, v8, v9, v10
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_med3_i16_e64 v20, v8, v9, v10
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_med3_i32_e64 v22, v8, v9, v10
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_med3_u16_e64 v24, v8, v9, v10
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_med3_u32_e64 v26, v8, v9, v10
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_min3_f16_e64 v28, v8, v9, v10
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_min3_f32_e64 v30, v8, v9, v10
masked_end 124
checkpoint 124

; Checkpoint 125: vop3_plain_10
clear_results
masked_begin 125
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_min3_i16_e64 v16, v8, v9, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_min3_i32_e64 v18, v8, v9, v10
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_min3_u16_e64 v20, v8, v9, v10
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_min3_u32_e64 v22, v8, v9, v10
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_min_i16_e64 v24, v8, v9
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_min_u16_e64 v26, v8, v9
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
masked_end 125
checkpoint 125

; Checkpoint 126: vop3_plain_11
clear_results
masked_begin 126
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
masked_end 126
checkpoint 126

; Checkpoint 127: vop3_plain_12
clear_results
masked_begin 127
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_msad_u8_e64 v16, v8, v9, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_mul_lo_u16_e64 v18, v8, v9
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_mullit_f32_e64 v20, v8, v9, v10
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_or3_b32_e64 v22, v8, v9, v10
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
v_pack_b32_f16_e64 v26, v8, v9
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_perm_b32_e64 v28, v8, v9, v10
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_sad_hi_u8_e64 v30, v8, v9, v10
masked_end 127
checkpoint 127

; Checkpoint 128: vop3_plain_13
clear_results
masked_begin 128
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
v_sub_co_u32_e64 v22, s20, v8, v9
v_mov_b32 v23, s20
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_sub_nc_i16_e64 v24, v8, v9
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_sub_nc_i32_e64 v26, v8, v9
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_sub_nc_u16_e64 v28, v8, v9
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_subrev_co_u32_e64 v30, s20, v8, v9
v_mov_b32 v31, s20
masked_end 128
checkpoint 128

; Checkpoint 129: vop3_plain_14
clear_results
masked_begin 129
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_xad_u32_e64 v16, v8, v9, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_xor3_b32_e64 v18, v8, v9, v10
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
masked_end 129
checkpoint 129

































; Checkpoint 130: vop3_from_vop1_plain_00
clear_results
masked_begin 130
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_bfrev_b32_e64 v16, v8
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_ceil_f16_e64 v18, v8
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_ceil_f32_e64 v20, v8
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
v_cos_f16_e64 v26, v8
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_cos_f32_e64 v28, v8
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
masked_end 130
checkpoint 130

; Checkpoint 131: vop3_from_vop1_plain_01
clear_results
masked_begin 131
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
v_cvt_f16_f32_e64 v16, v8
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cvt_f16_i16_e64 v18, v8
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_cvt_f16_u16_e64 v20, v8
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
v_cvt_f32_f16_e64 v22, v8
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_f32_i32_e64 v28, v8
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_f32_u32_e64 v30, v8
masked_end 131
checkpoint 131

; Checkpoint 132: vop3_from_vop1_plain_02
clear_results
masked_begin 132
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
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cvt_flr_i32_f32_e64 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_i16_f16_e64 v28, v8
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_i32_f32_e64 v30, v8
masked_end 132
checkpoint 132

; Checkpoint 133: vop3_from_vop1_plain_03
clear_results
masked_begin 133
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cvt_norm_i16_f16_e64 v20, v8
sweep_inputs half
v_mov_b32 v22, 0xa5a5a5a5
v_cvt_norm_u16_f16_e64 v22, v8
sweep_inputs float
v_mov_b32 v24, 0xa5a5a5a5
v_cvt_off_f32_i4_e64 v24, v8
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cvt_rpi_i32_f32_e64 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cvt_u16_f16_e64 v28, v8
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cvt_u32_f32_e64 v30, v8
masked_end 133
checkpoint 133

; Checkpoint 134: vop3_from_vop1_plain_04
clear_results
masked_begin 134
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_exp_f16_e64 v18, v8
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
v_floor_f16_e64 v28, v8
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_floor_f32_e64 v30, v8
masked_end 134
checkpoint 134

; Checkpoint 135: vop3_from_vop1_plain_05
clear_results
masked_begin 135
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_fract_f16_e64 v16, v8
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_fract_f32_e64 v18, v8
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_frexp_exp_i16_f16_e64 v20, v8
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_frexp_exp_i32_f32_e64 v22, v8
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_frexp_mant_f16_e64 v24, v8
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_frexp_mant_f32_e64 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_log_f16_e64 v28, v8
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_log_f32_e64 v30, v8
masked_end 135
checkpoint 135

; Checkpoint 136: vop3_from_vop1_plain_06
clear_results
masked_begin 136
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32_e64 v16, v8
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_movrels_b32_e64 v18, v8
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_not_b32_e64 v22, v8
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_rcp_f16_e64 v24, v8
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_rcp_f32_e64 v26, v8
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_rcp_iflag_f32_e64 v28, v8
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
v_rndne_f16_e64 v30, v8
masked_end 136
checkpoint 136

; Checkpoint 137: vop3_from_vop1_plain_07
clear_results
masked_begin 137
sweep_inputs float
v_mov_b32 v16, 0xa5a5a5a5
v_rndne_f32_e64 v16, v8
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_rsq_f16_e64 v18, v8
sweep_inputs float
v_mov_b32 v20, 0xa5a5a5a5
v_rsq_f32_e64 v20, v8
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_sat_pk_u8_i16_e64 v22, v8
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_sin_f16_e64 v24, v8
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_sin_f32_e64 v26, v8
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_sqrt_f16_e64 v28, v8
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_sqrt_f32_e64 v30, v8
masked_end 137
checkpoint 137

; Checkpoint 138: vop3_from_vop1_plain_08
clear_results
masked_begin 138
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_trunc_f16_e64 v16, v8
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_trunc_f32_e64 v18, v8
masked_end 138
checkpoint 138



















; Checkpoint 139: vop3_from_vop2_plain_00
clear_results
masked_begin 139
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_add_co_ci_u32_e64 v16, s20, v8, v9, s23
v_mov_b32 v17, s20
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_add_f16_e64 v18, v8, v9
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
v_cndmask_b32_e64 v28, v8, v9, s23
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
masked_end 139
checkpoint 139

; Checkpoint 140: vop3_from_vop2_plain_01
clear_results
masked_begin 140
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_fmac_f16_e64 v16, v8, v9
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_and_b32 v9, 7, v0
v_ldexp_f16_e64 v18, v8, v9
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_lshlrev_b32_e64 v20, v8, v9
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_lshrrev_b32_e64 v22, v8, v9
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_max_f16_e64 v24, v8, v9
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_max_f32_e64 v26, v8, v9
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_max_i32_e64 v28, v8, v9
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_max_u32_e64 v30, v8, v9
masked_end 140
checkpoint 140

; Checkpoint 141: vop3_from_vop2_plain_02
clear_results
masked_begin 141
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_min_f16_e64 v16, v8, v9
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
v_mul_f16_e64 v26, v8, v9
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_mul_f32_e64 v28, v8, v9
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_mul_hi_i32_i24_e64 v30, v8, v9
masked_end 141
checkpoint 141

; Checkpoint 142: vop3_from_vop2_plain_03
clear_results
masked_begin 142
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
v_sub_co_ci_u32_e64 v24, s20, v8, v9, s23
v_mov_b32 v25, s20
sweep_inputs half
v_mov_b32 v26, 0xa5a5a5a5
v_sub_f16_e64 v26, v8, v9
sweep_inputs float
v_mov_b32 v28, 0xa5a5a5a5
v_sub_f32_e64 v28, v8, v9
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_sub_nc_u32_e64 v30, v8, v9
masked_end 142
checkpoint 142

; Checkpoint 143: vop3_from_vop2_plain_04
clear_results
masked_begin 143
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_subrev_co_ci_u32_e64 v16, s20, v8, v9, s23
v_mov_b32 v17, s20
sweep_inputs half
v_mov_b32 v18, 0xa5a5a5a5
v_subrev_f16_e64 v18, v8, v9
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
masked_end 143
checkpoint 143











; Checkpoint 144: vopc_plain_00
clear_results
masked_begin 144
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
v_cmp_class_f16 vcc_lo, v8, v9
v_mov_b32 v16, vcc_lo
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
v_cmp_class_f32 vcc_lo, v8, v9
v_mov_b32 v18, vcc_lo
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_eq_f16 vcc_lo, v8, v9
v_mov_b32 v20, vcc_lo
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_eq_f32 vcc_lo, v8, v9
v_mov_b32 v22, vcc_lo
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_eq_i16 vcc_lo, v8, v9
v_mov_b32 v24, vcc_lo
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_eq_i32 vcc_lo, v8, v9
v_mov_b32 v26, vcc_lo
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_eq_u16 vcc_lo, v8, v9
v_mov_b32 v28, vcc_lo
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_eq_u32 vcc_lo, v8, v9
v_mov_b32 v30, vcc_lo
masked_end 144
checkpoint 144

; Checkpoint 145: vopc_plain_01
clear_results
masked_begin 145
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_ge_f16 vcc_lo, v8, v9
v_mov_b32 v16, vcc_lo
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_ge_f32 vcc_lo, v8, v9
v_mov_b32 v18, vcc_lo
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_ge_i16 vcc_lo, v8, v9
v_mov_b32 v20, vcc_lo
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_ge_i32 vcc_lo, v8, v9
v_mov_b32 v22, vcc_lo
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_ge_u16 vcc_lo, v8, v9
v_mov_b32 v24, vcc_lo
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_ge_u32 vcc_lo, v8, v9
v_mov_b32 v26, vcc_lo
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_gt_f16 vcc_lo, v8, v9
v_mov_b32 v28, vcc_lo
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_gt_f32 vcc_lo, v8, v9
v_mov_b32 v30, vcc_lo
masked_end 145
checkpoint 145

; Checkpoint 146: vopc_plain_02
clear_results
masked_begin 146
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_gt_i16 vcc_lo, v8, v9
v_mov_b32 v16, vcc_lo
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_gt_i32 vcc_lo, v8, v9
v_mov_b32 v18, vcc_lo
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_gt_u16 vcc_lo, v8, v9
v_mov_b32 v20, vcc_lo
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_gt_u32 vcc_lo, v8, v9
v_mov_b32 v22, vcc_lo
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_le_f16 vcc_lo, v8, v9
v_mov_b32 v24, vcc_lo
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_le_f32 vcc_lo, v8, v9
v_mov_b32 v26, vcc_lo
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_le_i16 vcc_lo, v8, v9
v_mov_b32 v28, vcc_lo
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_le_i32 vcc_lo, v8, v9
v_mov_b32 v30, vcc_lo
masked_end 146
checkpoint 146

; Checkpoint 147: vopc_plain_03
clear_results
masked_begin 147
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_le_u16 vcc_lo, v8, v9
v_mov_b32 v16, vcc_lo
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_le_u32 vcc_lo, v8, v9
v_mov_b32 v18, vcc_lo
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_lg_f16 vcc_lo, v8, v9
v_mov_b32 v20, vcc_lo
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_lg_f32 vcc_lo, v8, v9
v_mov_b32 v22, vcc_lo
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_lt_f16 vcc_lo, v8, v9
v_mov_b32 v24, vcc_lo
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_lt_f32 vcc_lo, v8, v9
v_mov_b32 v26, vcc_lo
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_lt_i16 vcc_lo, v8, v9
v_mov_b32 v28, vcc_lo
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_lt_i32 vcc_lo, v8, v9
v_mov_b32 v30, vcc_lo
masked_end 147
checkpoint 147

; Checkpoint 148: vopc_plain_04
clear_results
masked_begin 148
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_lt_u16 vcc_lo, v8, v9
v_mov_b32 v16, vcc_lo
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_lt_u32 vcc_lo, v8, v9
v_mov_b32 v18, vcc_lo
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_ne_i16 vcc_lo, v8, v9
v_mov_b32 v20, vcc_lo
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_ne_i32 vcc_lo, v8, v9
v_mov_b32 v22, vcc_lo
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_ne_u16 vcc_lo, v8, v9
v_mov_b32 v24, vcc_lo
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_ne_u32 vcc_lo, v8, v9
v_mov_b32 v26, vcc_lo
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_neq_f16 vcc_lo, v8, v9
v_mov_b32 v28, vcc_lo
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_neq_f32 vcc_lo, v8, v9
v_mov_b32 v30, vcc_lo
masked_end 148
checkpoint 148

; Checkpoint 149: vopc_plain_05
clear_results
masked_begin 149
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_nge_f16 vcc_lo, v8, v9
v_mov_b32 v16, vcc_lo
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_nge_f32 vcc_lo, v8, v9
v_mov_b32 v18, vcc_lo
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_ngt_f16 vcc_lo, v8, v9
v_mov_b32 v20, vcc_lo
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_ngt_f32 vcc_lo, v8, v9
v_mov_b32 v22, vcc_lo
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_nle_f16 vcc_lo, v8, v9
v_mov_b32 v24, vcc_lo
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_nle_f32 vcc_lo, v8, v9
v_mov_b32 v26, vcc_lo
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_nlg_f16 vcc_lo, v8, v9
v_mov_b32 v28, vcc_lo
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_nlg_f32 vcc_lo, v8, v9
v_mov_b32 v30, vcc_lo
masked_end 149
checkpoint 149

; Checkpoint 150: vopc_plain_06
clear_results
masked_begin 150
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_nlt_f16 vcc_lo, v8, v9
v_mov_b32 v16, vcc_lo
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_nlt_f32 vcc_lo, v8, v9
v_mov_b32 v18, vcc_lo
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_o_f16 vcc_lo, v8, v9
v_mov_b32 v20, vcc_lo
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_o_f32 vcc_lo, v8, v9
v_mov_b32 v22, vcc_lo
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_u_f16 vcc_lo, v8, v9
v_mov_b32 v24, vcc_lo
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_u_f32 vcc_lo, v8, v9
v_mov_b32 v26, vcc_lo
masked_end 150
checkpoint 150















; Checkpoint 151: vopcx_plain_00
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
s_mov_b32 exec_lo, -1
v_cmpx_class_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s22
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
s_mov_b32 exec_lo, -1
v_cmpx_class_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s22
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_eq_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s22
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_eq_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s22
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_eq_i16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s22
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_eq_i32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s22
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_eq_u16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s22
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_eq_u32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v30, s22
checkpoint 151

; Checkpoint 152: vopcx_plain_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ge_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s22
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ge_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s22
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ge_i16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s22
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ge_i32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s22
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ge_u16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s22
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ge_u32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s22
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_gt_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s22
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_gt_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v30, s22
checkpoint 152

; Checkpoint 153: vopcx_plain_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_gt_i16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s22
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_gt_i32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s22
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_gt_u16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s22
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_gt_u32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s22
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_le_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s22
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_le_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s22
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_le_i16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s22
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_le_i32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v30, s22
checkpoint 153

; Checkpoint 154: vopcx_plain_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_le_u16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s22
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_le_u32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s22
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lg_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s22
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lg_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s22
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lt_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s22
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lt_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s22
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lt_i16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s22
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lt_i32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v30, s22
checkpoint 154

; Checkpoint 155: vopcx_plain_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lt_u16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s22
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lt_u32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s22
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ne_i16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s22
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ne_i32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s22
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ne_u16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s22
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ne_u32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s22
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_neq_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s22
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_neq_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v30, s22
checkpoint 155

; Checkpoint 156: vopcx_plain_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nge_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s22
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nge_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s22
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ngt_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s22
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ngt_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s22
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nle_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s22
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nle_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s22
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nlg_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s22
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nlg_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v30, s22
checkpoint 156

; Checkpoint 157: vopcx_plain_06
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nlt_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s22
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nlt_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s22
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_o_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s22
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_o_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s22
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_u_f16 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s22
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_u_f32 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s22
checkpoint 157















; Checkpoint 158: vop3c_plain_00
clear_results
masked_begin 158
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
v_cmp_class_f16_e64 s20, v8, v9
v_mov_b32 v16, s20
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
v_cmp_class_f32_e64 s20, v8, v9
v_mov_b32 v18, s20
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_eq_f16_e64 s20, v8, v9
v_mov_b32 v20, s20
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_eq_f32_e64 s20, v8, v9
v_mov_b32 v22, s20
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_eq_i16_e64 s20, v8, v9
v_mov_b32 v24, s20
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_eq_i32_e64 s20, v8, v9
v_mov_b32 v26, s20
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_eq_u16_e64 s20, v8, v9
v_mov_b32 v28, s20
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_eq_u32_e64 s20, v8, v9
v_mov_b32 v30, s20
masked_end 158
checkpoint 158

; Checkpoint 159: vop3c_plain_01
clear_results
masked_begin 159
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_ge_f16_e64 s20, v8, v9
v_mov_b32 v16, s20
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_ge_f32_e64 s20, v8, v9
v_mov_b32 v18, s20
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_ge_i16_e64 s20, v8, v9
v_mov_b32 v20, s20
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_ge_i32_e64 s20, v8, v9
v_mov_b32 v22, s20
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_ge_u16_e64 s20, v8, v9
v_mov_b32 v24, s20
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_ge_u32_e64 s20, v8, v9
v_mov_b32 v26, s20
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_gt_f16_e64 s20, v8, v9
v_mov_b32 v28, s20
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_gt_f32_e64 s20, v8, v9
v_mov_b32 v30, s20
masked_end 159
checkpoint 159

; Checkpoint 160: vop3c_plain_02
clear_results
masked_begin 160
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_gt_i16_e64 s20, v8, v9
v_mov_b32 v16, s20
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_gt_i32_e64 s20, v8, v9
v_mov_b32 v18, s20
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_gt_u16_e64 s20, v8, v9
v_mov_b32 v20, s20
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_gt_u32_e64 s20, v8, v9
v_mov_b32 v22, s20
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_le_f16_e64 s20, v8, v9
v_mov_b32 v24, s20
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_le_f32_e64 s20, v8, v9
v_mov_b32 v26, s20
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_le_i16_e64 s20, v8, v9
v_mov_b32 v28, s20
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_le_i32_e64 s20, v8, v9
v_mov_b32 v30, s20
masked_end 160
checkpoint 160

; Checkpoint 161: vop3c_plain_03
clear_results
masked_begin 161
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_le_u16_e64 s20, v8, v9
v_mov_b32 v16, s20
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_le_u32_e64 s20, v8, v9
v_mov_b32 v18, s20
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_lg_f16_e64 s20, v8, v9
v_mov_b32 v20, s20
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_lg_f32_e64 s20, v8, v9
v_mov_b32 v22, s20
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_lt_f16_e64 s20, v8, v9
v_mov_b32 v24, s20
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_lt_f32_e64 s20, v8, v9
v_mov_b32 v26, s20
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_lt_i16_e64 s20, v8, v9
v_mov_b32 v28, s20
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_lt_i32_e64 s20, v8, v9
v_mov_b32 v30, s20
masked_end 161
checkpoint 161

; Checkpoint 162: vop3c_plain_04
clear_results
masked_begin 162
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_lt_u16_e64 s20, v8, v9
v_mov_b32 v16, s20
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_lt_u32_e64 s20, v8, v9
v_mov_b32 v18, s20
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_ne_i16_e64 s20, v8, v9
v_mov_b32 v20, s20
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_ne_i32_e64 s20, v8, v9
v_mov_b32 v22, s20
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_ne_u16_e64 s20, v8, v9
v_mov_b32 v24, s20
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_ne_u32_e64 s20, v8, v9
v_mov_b32 v26, s20
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_neq_f16_e64 s20, v8, v9
v_mov_b32 v28, s20
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_neq_f32_e64 s20, v8, v9
v_mov_b32 v30, s20
masked_end 162
checkpoint 162

; Checkpoint 163: vop3c_plain_05
clear_results
masked_begin 163
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_nge_f16_e64 s20, v8, v9
v_mov_b32 v16, s20
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_nge_f32_e64 s20, v8, v9
v_mov_b32 v18, s20
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_ngt_f16_e64 s20, v8, v9
v_mov_b32 v20, s20
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_ngt_f32_e64 s20, v8, v9
v_mov_b32 v22, s20
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_nle_f16_e64 s20, v8, v9
v_mov_b32 v24, s20
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_nle_f32_e64 s20, v8, v9
v_mov_b32 v26, s20
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_cmp_nlg_f16_e64 s20, v8, v9
v_mov_b32 v28, s20
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
v_cmp_nlg_f32_e64 s20, v8, v9
v_mov_b32 v30, s20
masked_end 163
checkpoint 163

; Checkpoint 164: vop3c_plain_06
clear_results
masked_begin 164
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_cmp_nlt_f16_e64 s20, v8, v9
v_mov_b32 v16, s20
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_cmp_nlt_f32_e64 s20, v8, v9
v_mov_b32 v18, s20
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
v_cmp_o_f16_e64 s20, v8, v9
v_mov_b32 v20, s20
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
v_cmp_o_f32_e64 s20, v8, v9
v_mov_b32 v22, s20
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
v_cmp_u_f16_e64 s20, v8, v9
v_mov_b32 v24, s20
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_cmp_u_f32_e64 s20, v8, v9
v_mov_b32 v26, s20
masked_end 164
checkpoint 164















; Checkpoint 165: vop3cx_plain_00
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
s_mov_b32 exec_lo, -1
v_cmpx_class_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s22
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v9, 0x3ff
s_mov_b32 exec_lo, -1
v_cmpx_class_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s22
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_eq_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s22
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_eq_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s22
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_eq_i16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s22
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_eq_i32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s22
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_eq_u16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s22
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_eq_u32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v30, s22
checkpoint 165

; Checkpoint 166: vop3cx_plain_01
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ge_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s22
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ge_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s22
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ge_i16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s22
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ge_i32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s22
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ge_u16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s22
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ge_u32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s22
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_gt_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s22
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_gt_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v30, s22
checkpoint 166

; Checkpoint 167: vop3cx_plain_02
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_gt_i16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s22
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_gt_i32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s22
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_gt_u16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s22
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_gt_u32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s22
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_le_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s22
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_le_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s22
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_le_i16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s22
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_le_i32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v30, s22
checkpoint 167

; Checkpoint 168: vop3cx_plain_03
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_le_u16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s22
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_le_u32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s22
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lg_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s22
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lg_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s22
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lt_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s22
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lt_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s22
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lt_i16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s22
sweep_inputs int
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lt_i32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v30, s22
checkpoint 168

; Checkpoint 169: vop3cx_plain_04
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lt_u16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s22
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_lt_u32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s22
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ne_i16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s22
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ne_i32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s22
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ne_u16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s22
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ne_u32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s22
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_neq_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s22
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_neq_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v30, s22
checkpoint 169

; Checkpoint 170: vop3cx_plain_05
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nge_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s22
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nge_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s22
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ngt_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s22
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_ngt_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s22
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nle_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s22
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nle_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s22
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nlg_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s22
sweep_inputs float
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nlg_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v30, s22
checkpoint 170

; Checkpoint 171: vop3cx_plain_06
clear_results
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nlt_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s22
sweep_inputs float
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_nlt_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s22
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_o_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s22
sweep_inputs float
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_o_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s22
sweep_inputs half
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_u_f16_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s22
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_cmpx_u_f32_e64 v8, v9
s_mov_b32 s22, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s22
checkpoint 171















; Checkpoint 172: vop3p_plain_00
clear_results
masked_begin 172
sweep_inputs half
v_mov_b32 v16, 0xa5a5a5a5
v_dot2_f32_f16 v16, v8, v9, v10
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v20, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
sweep_inputs float
v_mov_b32 v26, 0xa5a5a5a5
v_fma_mix_f32 v26, v8, v9, v10
sweep_inputs half
v_mov_b32 v28, 0xa5a5a5a5
v_fma_mixhi_f16 v28, v8, v9, v10
masked_end 172
checkpoint 172




; Repartition LDS only after both waves have completed the earlier exchange.
s_barrier
; Each lane owns sixteen LDS bytes in each of two arrays, and 64 global bytes.
; Both arrays and every atomic target are initialized before observation.
s_load_dwordx2 s[14:15], s[0:1], 32
s_waitcnt lgkmcnt(0)
s_lshl_b32 s12, s48, 12
s_add_u32 s14, s14, s12
s_addc_u32 s15, s15, 0
v_lshlrev_b32 v52, 4, v0
v_lshlrev_b32 v53, 6, v0
v_add_co_u32 v50, vcc_lo, s14, v53
v_add_co_ci_u32 v51, vcc_lo, s15, 0, vcc_lo
v_or_b32 v8, 0x3f000000, v0
v_mov_b32 v9, 0x3ff00000
v_xor_b32 v10, v1, v2
v_mov_b32 v11, 0x40000000
v_xor_b32 v32, 0x12345678, v1
v_mov_b32 v33, 0x3fe00000
v_mov_b32 v34, v8
v_mov_b32 v35, v9
s_mov_b32 m0, 0
; Checkpoint 173: lds_operations_00
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_add_f32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_add_rtn_f32 v24, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 173

; Checkpoint 174: lds_operations_01
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_add_rtn_u32 v16, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_add_rtn_u64 v[24:25], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 174

; Checkpoint 175: lds_operations_02
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_add_u32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_add_u64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 175

; Checkpoint 176: lds_operations_03
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_and_b32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_and_b64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 176

; Checkpoint 177: lds_operations_04
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_and_rtn_b32 v16, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_and_rtn_b64 v[24:25], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 177

; Checkpoint 178: lds_operations_05
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
ds_cmpst_b32 v52, v41, v40
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_and_b32 v36, 1, v0
v_xor_b32 v34, v36, v8
ds_cmpst_b64 v52, v[34:35], v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 178

; Checkpoint 179: lds_operations_06
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
ds_cmpst_rtn_b32 v16, v52, v41, v40
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_and_b32 v36, 1, v0
v_xor_b32 v34, v36, v8
ds_cmpst_rtn_b64 v[24:25], v52, v[34:35], v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 179



; Checkpoint 180: lds_operations_08
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_condxchg32_rtn_b64 v[16:17], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_dec_rtn_u32 v24, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 180

; Checkpoint 181: lds_operations_09
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_dec_rtn_u64 v[16:17], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_dec_u32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 181

; Checkpoint 182: lds_operations_10
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_dec_u64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_inc_rtn_u32 v24, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 182

; Checkpoint 183: lds_operations_11
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_inc_rtn_u64 v[16:17], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_inc_u32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 183

; Checkpoint 184: lds_operations_12
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_inc_u64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read2_b32 v[24:25], v52 offset0:0 offset1:1
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 184

; Checkpoint 185: lds_operations_13
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read2_b64 v[16:19], v52 offset0:0 offset1:1
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read2st64_b32 v[24:25], v52 offset0:0 offset1:4
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b64 v[28:29], v52
ds_read_b64 v[30:31], v52 offset:1024
s_waitcnt lgkmcnt(0)
checkpoint 185

; Checkpoint 186: lds_operations_14
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read2st64_b64 v[16:19], v52 offset0:0 offset1:2
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b64 v[20:21], v52
ds_read_b64 v[22:23], v52 offset:1024
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read_b128 v[24:27], v52
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 186

; Checkpoint 187: lds_operations_15
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read_b32 v16, v52
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read_b64 v[24:25], v52
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 187

; Checkpoint 188: lds_operations_16
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read_b96 v[16:18], v52
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read_i16 v24, v52
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 188

; Checkpoint 189: lds_operations_17
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read_i8 v16, v52
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read_i8_d16 v24, v52
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 189

; Checkpoint 190: lds_operations_18
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read_i8_d16_hi v16, v52
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read_u16 v24, v52
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 190

; Checkpoint 191: lds_operations_19
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read_u16_d16 v16, v52
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read_u16_d16_hi v24, v52
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 191

; Checkpoint 192: lds_operations_20
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read_u8 v16, v52
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read_u8_d16 v24, v52
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 192

; Checkpoint 193: lds_operations_21
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_read_u8_d16_hi v16, v52
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_max_i32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 193

; Checkpoint 194: lds_operations_22
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_max_i64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_max_f32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 194

; Checkpoint 195: lds_operations_23
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_max_f64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_max_rtn_f32 v24, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 195

; Checkpoint 196: lds_operations_24
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_max_rtn_f64 v[16:17], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_max_rtn_i32 v24, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 196

; Checkpoint 197: lds_operations_25
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_max_rtn_i64 v[16:17], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_max_rtn_u32 v24, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 197

; Checkpoint 198: lds_operations_26
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_max_rtn_u64 v[16:17], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_max_u32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 198

; Checkpoint 199: lds_operations_27
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_max_u64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_min_i32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 199

; Checkpoint 200: lds_operations_28
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_min_i64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_min_f32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 200

; Checkpoint 201: lds_operations_29
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_min_f64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_min_rtn_f32 v24, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 201

; Checkpoint 202: lds_operations_30
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_min_rtn_f64 v[16:17], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_min_rtn_i32 v24, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 202

; Checkpoint 203: lds_operations_31
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_min_rtn_i64 v[16:17], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_min_rtn_u32 v24, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 203

; Checkpoint 204: lds_operations_32
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_min_rtn_u64 v[16:17], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_min_u32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 204

; Checkpoint 205: lds_operations_33
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_min_u64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_mskor_b32 v52, v32, v33
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 205

; Checkpoint 206: lds_operations_34
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_mskor_b64 v52, v[32:33], v[34:35]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_mskor_rtn_b32 v24, v52, v32, v33
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 206

; Checkpoint 207: lds_operations_35
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_mskor_rtn_b64 v[16:17], v52, v[32:33], v[34:35]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_or_b32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 207

; Checkpoint 208: lds_operations_36
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_or_b64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_or_rtn_b32 v24, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 208

; Checkpoint 209: lds_operations_37
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_or_rtn_b64 v[16:17], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 209



; Checkpoint 210: lds_operations_39
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_rsub_rtn_u32 v24, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 210

; Checkpoint 211: lds_operations_40
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_rsub_rtn_u64 v[16:17], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_rsub_u32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 211

; Checkpoint 212: lds_operations_41
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_rsub_u64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_write2_b32 v52, v32, v33 offset0:0 offset1:1
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 212

; Checkpoint 213: lds_operations_42
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_write2_b64 v52, v[32:33], v[34:35] offset0:0 offset1:1
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_write2st64_b32 v52, v32, v33 offset0:0 offset1:4
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b64 v[28:29], v52
ds_read_b64 v[30:31], v52 offset:1024
s_waitcnt lgkmcnt(0)
checkpoint 213

; Checkpoint 214: lds_operations_43
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_write2st64_b64 v52, v[32:33], v[34:35] offset0:0 offset1:2
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b64 v[20:21], v52
ds_read_b64 v[22:23], v52 offset:1024
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_write_b128 v52, v[32:35]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 214

; Checkpoint 215: lds_operations_44
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_write_b16 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_write_b16_d16_hi v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 215

; Checkpoint 216: lds_operations_45
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_write_b32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_write_b64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 216

; Checkpoint 217: lds_operations_46
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_write_b8 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_write_b8_d16_hi v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 217

; Checkpoint 218: lds_operations_47
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_write_b96 v52, v[32:34]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_wrxchg2_rtn_b32 v[24:25], v52, v32, v33 offset0:0 offset1:1
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 218

; Checkpoint 219: lds_operations_48
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_wrxchg2_rtn_b64 v[16:19], v52, v[32:33], v[34:35] offset0:0 offset1:1
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_wrxchg2st64_rtn_b32 v[24:25], v52, v32, v33 offset0:0 offset1:4
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b64 v[28:29], v52
ds_read_b64 v[30:31], v52 offset:1024
s_waitcnt lgkmcnt(0)
checkpoint 219

; Checkpoint 220: lds_operations_49
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_wrxchg2st64_rtn_b64 v[16:19], v52, v[32:33], v[34:35] offset0:0 offset1:2
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b64 v[20:21], v52
ds_read_b64 v[22:23], v52 offset:1024
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_wrxchg_rtn_b32 v24, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 220

; Checkpoint 221: lds_operations_50
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_wrxchg_rtn_b64 v[16:17], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 221

; Checkpoint 222: lds_operations_51
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_sub_rtn_u32 v24, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 222

; Checkpoint 223: lds_operations_52
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_sub_rtn_u64 v[16:17], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_sub_u32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 223

; Checkpoint 224: lds_operations_53
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_sub_u64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_xor_b32 v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 224

; Checkpoint 225: lds_operations_54
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_xor_b64 v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_xor_rtn_b32 v24, v52, v32
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[28:31], v52
s_waitcnt lgkmcnt(0)
checkpoint 225

; Checkpoint 226: lds_operations_55
clear_results
ds_write_b128 v52, v[8:11]
ds_write_b128 v52, v[8:11] offset:1024
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
ds_xor_rtn_b64 v[16:17], v52, v[32:33]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b128 v[20:23], v52
s_waitcnt lgkmcnt(0)
checkpoint 226

; Checkpoint 227: global_operations_00
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_add v16, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_add v24, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 227

; Checkpoint 228: global_operations_01
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_add_x2 v[16:17], v53, v[32:33], s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_and v24, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 228

; Checkpoint 229: global_operations_02
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_and_x2 v[16:17], v53, v[32:33], s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
global_atomic_cmpswap v24, v53, v[40:41], s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 229

; Checkpoint 230: global_operations_03
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_cmpswap_x2 v[16:17], v53, v[32:35], s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_csub v24, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 230

; Checkpoint 231: global_operations_04
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_dec v16, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_dec_x2 v[24:25], v53, v[32:33], s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 231

; Checkpoint 232: global_operations_05
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_inc v16, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_inc_x2 v[24:25], v53, v[32:33], s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 232

; Checkpoint 233: global_operations_06
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_smax v16, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_smax_x2 v[24:25], v53, v[32:33], s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 233

; Checkpoint 234: global_operations_07
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_fmax v16, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_umax v24, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 234

; Checkpoint 235: global_operations_08
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_umax_x2 v[16:17], v53, v[32:33], s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_smin v24, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 235

; Checkpoint 236: global_operations_09
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_smin_x2 v[16:17], v53, v[32:33], s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_fmin v24, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 236

; Checkpoint 237: global_operations_10
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_umin v16, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_umin_x2 v[24:25], v53, v[32:33], s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 237

; Checkpoint 238: global_operations_11
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_or v16, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_or_x2 v[24:25], v53, v[32:33], s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 238



; Checkpoint 239: global_operations_13
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_sub v24, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 239

; Checkpoint 240: global_operations_14
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_sub_x2 v[16:17], v53, v[32:33], s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_swap v24, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 240

; Checkpoint 241: global_operations_15
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_swap_x2 v[16:17], v53, v[32:33], s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_xor v24, v53, v32, s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 241

; Checkpoint 242: global_operations_16
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_xor_x2 v[16:17], v53, v[32:33], s[14:15] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_load_dwordx4 v[24:27], v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 242

; Checkpoint 243: global_operations_17
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_load_dword v16, v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_load_dwordx2 v[24:25], v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 243

; Checkpoint 244: global_operations_18
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_load_dwordx3 v[16:18], v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_load_short_d16 v24, v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 244

; Checkpoint 245: global_operations_19
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_load_short_d16_hi v16, v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_load_sbyte_d16_hi v24, v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 245

; Checkpoint 246: global_operations_20
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_load_ubyte_d16_hi v16, v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_load_sbyte_d16 v24, v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 246

; Checkpoint 247: global_operations_21
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_load_ubyte_d16 v16, v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_load_sshort v24, v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 247

; Checkpoint 248: global_operations_22
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_load_sbyte v16, v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_load_ushort v24, v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 248

; Checkpoint 249: global_operations_23
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_load_ubyte v16, v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_store_dwordx4 v53, v[32:35], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 249

; Checkpoint 250: global_operations_24
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_store_short v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_store_dword v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 250

; Checkpoint 251: global_operations_25
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_store_dwordx2 v53, v[32:33], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_store_byte v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 251

; Checkpoint 252: global_operations_26
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_store_dwordx3 v53, v[32:34], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_store_short_d16_hi v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 252

; Checkpoint 253: global_operations_27
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_store_byte_d16_hi v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 253

; Checkpoint 254: global_no_return_00
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_add v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_add v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 254

; Checkpoint 255: global_no_return_01
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_add_x2 v53, v[32:33], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_and v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 255

; Checkpoint 256: global_no_return_02
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_and_x2 v53, v[32:33], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
global_atomic_cmpswap v53, v[40:41], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 256

; Checkpoint 257: global_no_return_03
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_cmpswap_x2 v53, v[32:35], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_csub v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 257

; Checkpoint 258: global_no_return_04
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_dec v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_dec_x2 v53, v[32:33], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 258

; Checkpoint 259: global_no_return_05
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_inc v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_inc_x2 v53, v[32:33], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 259

; Checkpoint 260: global_no_return_06
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_smax v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_smax_x2 v53, v[32:33], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 260

; Checkpoint 261: global_no_return_07
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_fmax v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_umax v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 261

; Checkpoint 262: global_no_return_08
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_umax_x2 v53, v[32:33], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_smin v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 262

; Checkpoint 263: global_no_return_09
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_smin_x2 v53, v[32:33], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_fmin v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 263

; Checkpoint 264: global_no_return_10
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_umin v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_umin_x2 v53, v[32:33], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 264

; Checkpoint 265: global_no_return_11
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_or v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_or_x2 v53, v[32:33], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 265



; Checkpoint 266: global_no_return_13
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_sub v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 266

; Checkpoint 267: global_no_return_14
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_sub_x2 v53, v[32:33], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_swap v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 267

; Checkpoint 268: global_no_return_15
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_swap_x2 v53, v[32:33], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_xor v53, v32, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 268

; Checkpoint 269: global_no_return_16
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
global_atomic_xor_x2 v53, v[32:33], s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 269

; Checkpoint 270: flat_operations_00
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_add v16, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_add v24, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 270

; Checkpoint 271: flat_operations_01
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_add_x2 v[16:17], v[50:51], v[32:33] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_and v24, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 271

; Checkpoint 272: flat_operations_02
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_and_x2 v[16:17], v[50:51], v[32:33] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
flat_atomic_cmpswap v24, v[50:51], v[40:41] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 272

; Checkpoint 273: flat_operations_03
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_cmpswap_x2 v[16:17], v[50:51], v[32:35] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 273

; Checkpoint 274: flat_operations_04
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_dec v16, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_dec_x2 v[24:25], v[50:51], v[32:33] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 274

; Checkpoint 275: flat_operations_05
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_inc v16, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_inc_x2 v[24:25], v[50:51], v[32:33] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 275

; Checkpoint 276: flat_operations_06
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_smax v16, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_smax_x2 v[24:25], v[50:51], v[32:33] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 276

; Checkpoint 277: flat_operations_07
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_fmax v16, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_umax v24, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 277

; Checkpoint 278: flat_operations_08
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_umax_x2 v[16:17], v[50:51], v[32:33] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_smin v24, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 278

; Checkpoint 279: flat_operations_09
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_smin_x2 v[16:17], v[50:51], v[32:33] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_fmin v24, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 279

; Checkpoint 280: flat_operations_10
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_umin v16, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_umin_x2 v[24:25], v[50:51], v[32:33] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 280

; Checkpoint 281: flat_operations_11
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_or v16, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_or_x2 v[24:25], v[50:51], v[32:33] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 281



; Checkpoint 282: flat_operations_13
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_sub v24, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 282

; Checkpoint 283: flat_operations_14
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_sub_x2 v[16:17], v[50:51], v[32:33] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_swap v24, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 283

; Checkpoint 284: flat_operations_15
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_swap_x2 v[16:17], v[50:51], v[32:33] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_xor v24, v[50:51], v32 glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 284

; Checkpoint 285: flat_operations_16
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_xor_x2 v[16:17], v[50:51], v[32:33] glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_load_dwordx4 v[24:27], v[50:51]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 285

; Checkpoint 286: flat_operations_17
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_load_dword v16, v[50:51]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_load_dwordx2 v[24:25], v[50:51]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 286

; Checkpoint 287: flat_operations_18
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_load_dwordx3 v[16:18], v[50:51]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_load_short_d16 v24, v[50:51]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 287

; Checkpoint 288: flat_operations_19
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_load_short_d16_hi v16, v[50:51]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_load_sbyte_d16_hi v24, v[50:51]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 288

; Checkpoint 289: flat_operations_20
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_load_ubyte_d16_hi v16, v[50:51]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_load_sbyte_d16 v24, v[50:51]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 289

; Checkpoint 290: flat_operations_21
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_load_ubyte_d16 v16, v[50:51]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_load_sshort v24, v[50:51]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 290

; Checkpoint 291: flat_operations_22
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_load_sbyte v16, v[50:51]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_load_ushort v24, v[50:51]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 291

; Checkpoint 292: flat_operations_23
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_load_ubyte v16, v[50:51]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_store_dwordx4 v[50:51], v[32:35]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 292

; Checkpoint 293: flat_operations_24
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_store_short v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_store_dword v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 293

; Checkpoint 294: flat_operations_25
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_store_dwordx2 v[50:51], v[32:33]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_store_byte v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 294

; Checkpoint 295: flat_operations_26
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_store_dwordx3 v[50:51], v[32:34]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_store_short_d16_hi v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 295

; Checkpoint 296: flat_operations_27
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_store_byte_d16_hi v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 296

; Checkpoint 297: flat_no_return_00
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_add v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_add v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 297

; Checkpoint 298: flat_no_return_01
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_add_x2 v[50:51], v[32:33]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_and v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 298

; Checkpoint 299: flat_no_return_02
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_and_x2 v[50:51], v[32:33]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
flat_atomic_cmpswap v[50:51], v[40:41]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 299

; Checkpoint 300: flat_no_return_03
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_cmpswap_x2 v[50:51], v[32:35]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 300

; Checkpoint 301: flat_no_return_04
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_dec v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_dec_x2 v[50:51], v[32:33]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 301

; Checkpoint 302: flat_no_return_05
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_inc v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_inc_x2 v[50:51], v[32:33]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 302

; Checkpoint 303: flat_no_return_06
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_smax v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_smax_x2 v[50:51], v[32:33]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 303

; Checkpoint 304: flat_no_return_07
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_fmax v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_umax v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 304

; Checkpoint 305: flat_no_return_08
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_umax_x2 v[50:51], v[32:33]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_smin v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 305

; Checkpoint 306: flat_no_return_09
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_smin_x2 v[50:51], v[32:33]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_fmin v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 306

; Checkpoint 307: flat_no_return_10
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_umin v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_umin_x2 v[50:51], v[32:33]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 307

; Checkpoint 308: flat_no_return_11
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_or v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_or_x2 v[50:51], v[32:33]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 308



; Checkpoint 309: flat_no_return_13
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_sub v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 309

; Checkpoint 310: flat_no_return_14
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_sub_x2 v[50:51], v[32:33]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_swap v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 310

; Checkpoint 311: flat_no_return_15
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_swap_x2 v[50:51], v[32:33]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_xor v[50:51], v32
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 311

; Checkpoint 312: flat_no_return_16
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
flat_atomic_xor_x2 v[50:51], v[32:33]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 312

s_mov_b32 s24, s14
s_mov_b32 s25, s15
s_mov_b32 s26, 4096
s_mov_b32 s27, 0x3003ffac
s_mov_b32 s28, 0
; Checkpoint 313: buffer_operations_00
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_dword v16, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_dwordx2 v[24:25], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 313

; Checkpoint 314: buffer_operations_01
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_dwordx3 v[16:18], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_dwordx4 v[24:27], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 314

; Checkpoint 315: buffer_operations_02
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_short_d16 v16, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_format_d16_x v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 315

; Checkpoint 316: buffer_operations_03
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_format_d16_xy v16, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_format_d16_xyz v[24:25], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 316

; Checkpoint 317: buffer_operations_04
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_format_d16_xyzw v[16:17], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_short_d16_hi v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 317

; Checkpoint 318: buffer_operations_05
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_format_d16_hi_x v16, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_sbyte_d16_hi v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 318

; Checkpoint 319: buffer_operations_06
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_ubyte_d16_hi v16, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_sbyte_d16 v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 319

; Checkpoint 320: buffer_operations_07
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_ubyte_d16 v16, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_format_x v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 320

; Checkpoint 321: buffer_operations_08
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_format_xy v[16:17], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_format_xyz v[24:26], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 321

; Checkpoint 322: buffer_operations_09
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_format_xyzw v[16:19], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_sbyte v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 322

; Checkpoint 323: buffer_operations_10
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_sshort v16, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_ubyte v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 323

; Checkpoint 324: buffer_operations_11
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_load_ushort v16, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_byte v32, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 324

; Checkpoint 325: buffer_operations_12
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_short v32, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_dword v32, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 325

; Checkpoint 326: buffer_operations_13
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_dwordx2 v[32:33], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_dwordx3 v[32:34], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 326

; Checkpoint 327: buffer_operations_14
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_dwordx4 v[32:35], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_format_d16_x v32, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 327

; Checkpoint 328: buffer_operations_15
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_format_d16_xy v32, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_format_d16_xyz v[32:33], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 328

; Checkpoint 329: buffer_operations_16
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_format_d16_xyzw v[32:33], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_byte_d16_hi v32, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 329

; Checkpoint 330: buffer_operations_17
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_short_d16_hi v32, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_format_d16_hi_x v32, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 330

; Checkpoint 331: buffer_operations_18
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_format_x v32, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_format_xy v[32:33], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 331

; Checkpoint 332: buffer_operations_19
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_format_xyz v[32:34], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_store_format_xyzw v[32:35], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 332



; Checkpoint 333: buffer_operations_21
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_add v16, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_add v24, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 333

; Checkpoint 334: buffer_operations_22
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_add_x2 v[16:17], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_and v24, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 334

; Checkpoint 335: buffer_operations_23
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_and_x2 v[16:17], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
v_mov_b32 v24, v40
v_mov_b32 v25, v41
buffer_atomic_cmpswap v[24:25], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 335

; Checkpoint 336: buffer_operations_24
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_cmpswap_x2 v[16:19], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 336

; Checkpoint 337: buffer_operations_25
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_csub v16, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_dec v24, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 337

; Checkpoint 338: buffer_operations_26
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_dec_x2 v[16:17], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_inc v24, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 338

; Checkpoint 339: buffer_operations_27
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_inc_x2 v[16:17], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_fmax v24, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 339

; Checkpoint 340: buffer_operations_28
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_smax v16, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_smax_x2 v[24:25], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 340

; Checkpoint 341: buffer_operations_29
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_umax v16, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_umax_x2 v[24:25], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 341

; Checkpoint 342: buffer_operations_30
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_fmin v16, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_smin v24, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 342

; Checkpoint 343: buffer_operations_31
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_smin_x2 v[16:17], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_umin v24, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 343

; Checkpoint 344: buffer_operations_32
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_umin_x2 v[16:17], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_or v24, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 344

; Checkpoint 345: buffer_operations_33
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_or_x2 v[16:17], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_sub v24, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 345

; Checkpoint 346: buffer_operations_34
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_sub_x2 v[16:17], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_swap v24, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 346

; Checkpoint 347: buffer_operations_35
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_swap_x2 v[16:17], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_xor v24, v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 347

; Checkpoint 348: buffer_operations_36
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_xor_x2 v[16:17], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_load_format_d16_x v24, v53, s[24:27], s28 format:[BUF_FMT_8_UNORM] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 348

; Checkpoint 349: buffer_operations_37
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_load_format_d16_xy v16, v53, s[24:27], s28 format:[BUF_FMT_8_SINT] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_load_format_d16_xyz v[24:25], v53, s[24:27], s28 format:[BUF_FMT_16_UINT] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 349

; Checkpoint 350: buffer_operations_38
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_load_format_d16_xyzw v[16:17], v53, s[24:27], s28 format:[BUF_FMT_8_8_USCALED] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_load_format_x v24, v53, s[24:27], s28 format:[BUF_FMT_32_SINT] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 350

; Checkpoint 351: buffer_operations_39
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_load_format_xy v[16:17], v53, s[24:27], s28 format:[BUF_FMT_16_16_SSCALED] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_load_format_xyz v[24:26], v53, s[24:27], s28 format:[BUF_FMT_11_11_10_FLOAT] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 351

; Checkpoint 352: buffer_operations_40
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_load_format_xyzw v[16:19], v53, s[24:27], s28 format:[BUF_FMT_2_10_10_10_UNORM] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_store_format_d16_x v32, v53, s[24:27], s28 format:[BUF_FMT_2_10_10_10_SINT] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 352

; Checkpoint 353: buffer_operations_41
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_store_format_d16_xy v32, v53, s[24:27], s28 format:[BUF_FMT_8_8_8_8_UINT] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_store_format_d16_xyz v[32:33], v53, s[24:27], s28 format:[BUF_FMT_16_16_16_16_UNORM] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 353

; Checkpoint 354: buffer_operations_42
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_store_format_d16_xyzw v[32:33], v53, s[24:27], s28 format:[BUF_FMT_16_16_16_16_SINT] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_store_format_x v32, v53, s[24:27], s28 format:[BUF_FMT_32_32_32_32_UINT] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 354

; Checkpoint 355: buffer_operations_43
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_store_format_xy v[32:33], v53, s[24:27], s28 format:[BUF_FMT_16_UNORM] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_store_format_xyz v[32:34], v53, s[24:27], s28 format:[BUF_FMT_32_FLOAT] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 355

; Checkpoint 356: buffer_operations_44
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
tbuffer_store_format_xyzw v[32:35], v53, s[24:27], s28 format:[BUF_FMT_2_10_10_10_SNORM] offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 356



; Checkpoint 357: buffer_no_return_01
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_add v16, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_add v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 357

; Checkpoint 358: buffer_no_return_02
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_add_x2 v[16:17], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_and v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 358

; Checkpoint 359: buffer_no_return_03
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_and_x2 v[16:17], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
v_mov_b32 v24, v40
v_mov_b32 v25, v41
buffer_atomic_cmpswap v[24:25], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 359

; Checkpoint 360: buffer_no_return_04
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_cmpswap_x2 v[16:19], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 360

; Checkpoint 361: buffer_no_return_05
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_csub v16, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_dec v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 361

; Checkpoint 362: buffer_no_return_06
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_dec_x2 v[16:17], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_inc v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 362

; Checkpoint 363: buffer_no_return_07
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_inc_x2 v[16:17], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_fmax v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 363

; Checkpoint 364: buffer_no_return_08
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_smax v16, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_smax_x2 v[24:25], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 364

; Checkpoint 365: buffer_no_return_09
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_umax v16, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_umax_x2 v[24:25], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 365

; Checkpoint 366: buffer_no_return_10
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_fmin v16, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_smin v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 366

; Checkpoint 367: buffer_no_return_11
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_smin_x2 v[16:17], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_umin v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 367

; Checkpoint 368: buffer_no_return_12
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_umin_x2 v[16:17], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_or v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 368

; Checkpoint 369: buffer_no_return_13
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_or_x2 v[16:17], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_sub v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 369

; Checkpoint 370: buffer_no_return_14
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_sub_x2 v[16:17], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_swap v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 370

; Checkpoint 371: buffer_no_return_15
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_swap_x2 v[16:17], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v24, v32
v_mov_b32 v25, v33
v_mov_b32 v26, v34
v_mov_b32 v27, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_xor v24, v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[28:31], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 371

; Checkpoint 372: buffer_no_return_16
clear_results
global_store_dwordx4 v53, v[8:11], s[14:15]
s_waitcnt_vscnt null, 0
v_mov_b32 v16, v32
v_mov_b32 v17, v33
v_mov_b32 v18, v34
v_mov_b32 v19, v35
s_mov_b32 exec_lo, 0xa5a55a5a
buffer_atomic_xor_x2 v[16:17], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dwordx4 v[20:23], v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 372







; Checkpoint 373: scalar_sop1_03
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
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
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
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
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
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_mov_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 373

; Checkpoint 374: scalar_sop1_04
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
s_mov_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_cmov_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_cmov_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_not_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 374

; Checkpoint 375: scalar_sop1_05
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
s_not_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wqm_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_wqm_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_brev_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 375

; Checkpoint 376: scalar_sop1_06
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
s_brev_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_bcnt0_i32_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_bcnt0_i32_b64 s16, s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_bcnt1_i32_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 376

; Checkpoint 377: scalar_sop1_07
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
s_bcnt1_i32_b64 s16, s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_ff1_i32_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_ff1_i32_b64 s16, s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_flbit_i32_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 377

; Checkpoint 378: scalar_sop1_08
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
s_flbit_i32_b64 s16, s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_flbit_i32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_flbit_i32_i64 s16, s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_sext_i32_i8 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 378

; Checkpoint 379: scalar_sop1_09
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
s_sext_i32_i16 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_bitset0_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_bitset0_b64 s[16:17], s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_bitset1_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 379

; Checkpoint 380: scalar_sop1_10
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
s_bitset1_b64 s[16:17], s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
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
s_and_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
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
s_or_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
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
s_xor_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 380

; Checkpoint 381: scalar_sop1_11
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
s_andn2_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
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
s_orn2_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
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
s_nand_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
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
s_nor_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 381

; Checkpoint 382: scalar_sop1_12
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
s_xnor_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_quadmask_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_quadmask_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_movrels_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 382

; Checkpoint 383: scalar_sop1_13
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
s_movrels_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_movreld_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_movreld_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_abs_i32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 383

; Checkpoint 384: scalar_sop1_14
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
s_andn1_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
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
s_orn1_saveexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
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
s_andn1_wrexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
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
s_andn2_wrexec_b64 s[16:17], s[24:25]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 384

; Checkpoint 385: scalar_sop1_15
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
s_bitreplicate_b64_b32 s[16:17], s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
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
s_and_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
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
s_or_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
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
s_xor_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 385

; Checkpoint 386: scalar_sop1_16
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
s_andn2_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
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
s_orn2_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
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
s_nand_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
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
s_nor_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 386

; Checkpoint 387: scalar_sop1_17
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
s_xnor_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
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
s_andn1_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
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
s_orn1_saveexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
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
s_andn1_wrexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 387

; Checkpoint 388: scalar_sop1_18
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
s_andn2_wrexec_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_movrelsd_2_b32 s16, s24
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
checkpoint 388











; Checkpoint 389: scalar_sop2_05
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
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
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
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_add_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_sub_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 389

; Checkpoint 390: scalar_sop2_06
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
s_add_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_sub_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_addc_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_subb_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 390

; Checkpoint 391: scalar_sop2_07
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
s_min_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_min_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_max_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_max_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 391

; Checkpoint 392: scalar_sop2_08
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
s_cselect_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_cselect_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_and_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_and_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 392

; Checkpoint 393: scalar_sop2_09
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
s_or_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_or_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_xor_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_xor_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 393

; Checkpoint 394: scalar_sop2_10
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
s_andn2_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_andn2_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_orn2_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_orn2_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 394

; Checkpoint 395: scalar_sop2_11
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
s_nand_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_nand_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_nor_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_nor_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 395

; Checkpoint 396: scalar_sop2_12
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
s_xnor_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_xnor_b64 s[16:17], s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_lshl_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_lshl_b64 s[16:17], s[24:25], s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 396

; Checkpoint 397: scalar_sop2_13
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
s_lshr_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_lshr_b64 s[16:17], s[24:25], s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_ashr_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_ashr_i64 s[16:17], s[24:25], s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 397

; Checkpoint 398: scalar_sop2_14
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
s_bfm_b32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_bfm_b64 s[16:17], s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_mul_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_bfe_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 398

; Checkpoint 399: scalar_sop2_15
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
s_bfe_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_bfe_u64 s[16:17], s[24:25], s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_bfe_i64 s[16:17], s[24:25], s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_absdiff_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 399

; Checkpoint 400: scalar_sop2_16
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
s_lshl1_add_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_lshl2_add_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_lshl3_add_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_lshl4_add_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 400

; Checkpoint 401: scalar_sop2_17
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
s_pack_ll_b32_b16 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_pack_lh_b32_b16 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_pack_hh_b32_b16 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_mul_hi_u32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 401

; Checkpoint 402: scalar_sop2_18
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
s_mul_hi_i32 s16, s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
checkpoint 402















; Checkpoint 403: scalar_sopc_07
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
s_cmp_eq_i32 s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_cmp_lg_i32 s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_cmp_gt_i32 s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_cmp_ge_i32 s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 403

; Checkpoint 404: scalar_sopc_08
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
s_cmp_lt_i32 s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_cmp_le_i32 s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_cmp_eq_u32 s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_cmp_lg_u32 s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 404

; Checkpoint 405: scalar_sopc_09
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
s_cmp_gt_u32 s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_cmp_ge_u32 s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_cmp_lt_u32 s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_cmp_le_u32 s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 405

; Checkpoint 406: scalar_sopc_10
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
s_bitcmp0_b32 s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_bitcmp1_b32 s24, s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_bitcmp0_b64 s[24:25], s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s16
v_mov_b32 v25, s17
v_mov_b32 v26, s22
v_mov_b32 v27, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_bitcmp1_b64 s[24:25], s26
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s16
v_mov_b32 v29, s17
v_mov_b32 v30, s22
v_mov_b32 v31, s21
checkpoint 406

; Checkpoint 407: scalar_sopc_11
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
s_cmp_eq_u64 s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
v_mov_b32 v17, s17
v_mov_b32 v18, s22
v_mov_b32 v19, s21
s_mov_b32 m0, 0
s_mov_b32 s16, s8
s_mov_b32 s17, 0xa5a5a5a5
s_mov_b32 s24, s8
s_not_b32 s25, s8
s_xor_b32 s26, s8, 0x80000001
s_mov_b32 s27, 0x12345678
s_mov_b32 s28, 0x000b0003
s_cmp_lg_u32 s8, 1
s_cmp_lg_u64 s[24:25], s[26:27]
s_cselect_b32 s22, 1, 0
s_mov_b32 s21, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s16
v_mov_b32 v21, s17
v_mov_b32 v22, s22
v_mov_b32 v23, s21
checkpoint 407

; Checkpoint 408: comparex_f64_e32
clear_results
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_mov_b32 v12, 0x3ff
v_cmpx_lt_f64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s20
v_cmpx_eq_f64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s20
v_cmpx_le_f64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s20
v_cmpx_gt_f64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s20
v_cmpx_lg_f64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s20
v_cmpx_ge_f64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v21, s20
v_cmpx_o_f64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s20
v_cmpx_u_f64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v23, s20
v_cmpx_nge_f64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s20
v_cmpx_nlg_f64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v25, s20
v_cmpx_ngt_f64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s20
v_cmpx_nle_f64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v27, s20
v_cmpx_neq_f64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s20
v_cmpx_nlt_f64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v29, s20
v_cmpx_class_f64_e32 v[8:9], v12
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v30, s20
checkpoint 408

; Checkpoint 409: comparex_i64_e32
clear_results
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_mov_b32 v12, 0x3ff
v_cmpx_lt_i64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s20
v_cmpx_eq_i64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s20
v_cmpx_le_i64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s20
v_cmpx_gt_i64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s20
v_cmpx_ne_i64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s20
v_cmpx_ge_i64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v21, s20
checkpoint 409

; Checkpoint 410: comparex_u64_e32
clear_results
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_mov_b32 v12, 0x3ff
v_cmpx_lt_u64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s20
v_cmpx_eq_u64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s20
v_cmpx_le_u64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s20
v_cmpx_gt_u64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s20
v_cmpx_ne_u64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s20
v_cmpx_ge_u64_e32 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v21, s20
checkpoint 410

; Checkpoint 411: comparex_f64_e64
clear_results
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_mov_b32 v12, 0x3ff
v_cmpx_lt_f64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s20
v_cmpx_eq_f64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s20
v_cmpx_le_f64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s20
v_cmpx_gt_f64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s20
v_cmpx_lg_f64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s20
v_cmpx_ge_f64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v21, s20
v_cmpx_o_f64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s20
v_cmpx_u_f64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v23, s20
v_cmpx_nge_f64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s20
v_cmpx_nlg_f64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v25, s20
v_cmpx_ngt_f64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s20
v_cmpx_nle_f64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v27, s20
v_cmpx_neq_f64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v28, s20
v_cmpx_nlt_f64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v29, s20
v_cmpx_class_f64_e64 v[8:9], v12
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v30, s20
checkpoint 411

; Checkpoint 412: comparex_i64_e64
clear_results
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_mov_b32 v12, 0x3ff
v_cmpx_lt_i64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s20
v_cmpx_eq_i64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s20
v_cmpx_le_i64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s20
v_cmpx_gt_i64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s20
v_cmpx_ne_i64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s20
v_cmpx_ge_i64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v21, s20
checkpoint 412

; Checkpoint 413: comparex_u64_e64
clear_results
v_cvt_f64_f32 v[8:9], v4
v_cvt_f64_f32 v[10:11], v5
v_mov_b32 v12, 0x3ff
v_cmpx_lt_u64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s20
v_cmpx_eq_u64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s20
v_cmpx_le_u64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s20
v_cmpx_gt_u64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s20
v_cmpx_ne_u64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s20
v_cmpx_ge_u64_e64 v[8:9], v[10:11]
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v21, s20
checkpoint 413

; Checkpoint 414: packed_complete_0_00
clear_results
masked_begin 414
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
v_pk_max_f16 v26, v8, v9
v_pk_max_u16 v27, v8, v9
v_pk_min_i16 v29, v8, v9
v_pk_min_f16 v30, v8, v9
v_pk_min_u16 v31, v8, v9
masked_end 414
checkpoint 414

; Checkpoint 415: packed_complete_0_01
clear_results
masked_begin 415
v_or_b32 v8, 0x3c003800, v0
v_mov_b32 v9, 0xc0003e00
v_mov_b32 v10, 0x3800bc00
v_pk_mul_f16 v17, v8, v9
v_pk_mul_lo_u16 v18, v8, v9
v_pk_sub_i16 v19, v8, v9
v_pk_sub_u16 v20, v8, v9
v_pk_fmac_f16 v21, v8, v9
masked_end 415
checkpoint 415

; Checkpoint 416: packed_complete_1_00
clear_results
masked_begin 416
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
v_pk_max_f16 v26, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] neg_lo:[1,1] neg_hi:[0,0] clamp
v_pk_max_u16 v27, v8, v9 op_sel:[0,1] op_sel_hi:[1,0]
v_pk_min_i16 v29, v8, v9 op_sel:[0,1] op_sel_hi:[1,0]
v_pk_min_f16 v30, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] neg_lo:[1,1] neg_hi:[0,0] clamp
v_pk_min_u16 v31, v8, v9 op_sel:[0,1] op_sel_hi:[1,0]
masked_end 416
checkpoint 416

; Checkpoint 417: packed_complete_1_01
clear_results
masked_begin 417
v_or_b32 v8, 0x3c003800, v0
v_mov_b32 v9, 0xc0003e00
v_mov_b32 v10, 0x3800bc00
v_pk_mul_f16 v17, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] neg_lo:[1,1] neg_hi:[0,0] clamp
v_pk_mul_lo_u16 v18, v8, v9 op_sel:[0,1] op_sel_hi:[1,0]
v_pk_sub_i16 v19, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] clamp
v_pk_sub_u16 v20, v8, v9 op_sel:[0,1] op_sel_hi:[1,0] clamp
v_pk_fmac_f16 v21, v8, v9
masked_end 417
checkpoint 417

; Checkpoint 418: private_memory_00
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_load_dwordx4 v[16:19], off, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[20:23], off, off
s_waitcnt vmcnt(0)
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_load_dword v24, off, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[28:31], off, off
s_waitcnt vmcnt(0)
checkpoint 418

; Checkpoint 419: private_memory_01
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_load_dwordx2 v[16:17], off, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[20:23], off, off
s_waitcnt vmcnt(0)
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_load_dwordx3 v[24:26], off, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[28:31], off, off
s_waitcnt vmcnt(0)
checkpoint 419

; Checkpoint 420: private_memory_02
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_load_short_d16 v16, off, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[20:23], off, off
s_waitcnt vmcnt(0)
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_load_short_d16_hi v24, off, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[28:31], off, off
s_waitcnt vmcnt(0)
checkpoint 420

; Checkpoint 421: private_memory_03
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_load_sbyte_d16_hi v16, off, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[20:23], off, off
s_waitcnt vmcnt(0)
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_load_ubyte_d16_hi v24, off, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[28:31], off, off
s_waitcnt vmcnt(0)
checkpoint 421

; Checkpoint 422: private_memory_04
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_load_sbyte_d16 v16, off, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[20:23], off, off
s_waitcnt vmcnt(0)
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_load_ubyte_d16 v24, off, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[28:31], off, off
s_waitcnt vmcnt(0)
checkpoint 422

; Checkpoint 423: private_memory_05
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_load_sshort v16, off, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[20:23], off, off
s_waitcnt vmcnt(0)
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_load_sbyte v24, off, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[28:31], off, off
s_waitcnt vmcnt(0)
checkpoint 423

; Checkpoint 424: private_memory_06
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_load_ushort v16, off, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[20:23], off, off
s_waitcnt vmcnt(0)
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_load_ubyte v24, off, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[28:31], off, off
s_waitcnt vmcnt(0)
checkpoint 424

; Checkpoint 425: private_memory_07
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[20:23], off, off
s_waitcnt vmcnt(0)
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_store_short off, v8, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[28:31], off, off
s_waitcnt vmcnt(0)
checkpoint 425

; Checkpoint 426: private_memory_08
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_store_dword off, v8, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[20:23], off, off
s_waitcnt vmcnt(0)
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_store_dwordx2 off, v[8:9], off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[28:31], off, off
s_waitcnt vmcnt(0)
checkpoint 426

; Checkpoint 427: private_memory_09
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_store_byte off, v8, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[20:23], off, off
s_waitcnt vmcnt(0)
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_store_dwordx3 off, v[8:10], off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[28:31], off, off
s_waitcnt vmcnt(0)
checkpoint 427

; Checkpoint 428: private_memory_10
clear_results
v_mov_b32 v8, 0x89abcdef
v_mov_b32 v9, 0x12345678
v_mov_b32 v10, v1
v_mov_b32 v11, v2
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v17, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_mov_b32 v19, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_store_short_d16_hi off, v8, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[20:23], off, off
s_waitcnt vmcnt(0)
scratch_store_dwordx4 off, v[8:11], off
s_waitcnt_vscnt null, 0
v_mov_b32 v24, 0xa5a5a5a5
v_mov_b32 v25, 0xa5a5a5a5
v_mov_b32 v26, 0xa5a5a5a5
v_mov_b32 v27, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
scratch_store_byte_d16_hi off, v8, off
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
scratch_load_dwordx4 v[28:31], off, off
s_waitcnt vmcnt(0)
checkpoint 428

s_load_dwordx2 s[14:15], s[0:1], 32
s_waitcnt lgkmcnt(0)
s_lshl_b32 s12, s48, 12
s_add_u32 s14, s14, s12
s_addc_u32 s15, s15, 0
v_lshlrev_b32 v53, 6, v0
v_mov_b32 v8, v1
v_mov_b32 v9, v2
v_mov_b32 v10, v4
v_mov_b32 v11, v5
global_store_dwordx4 v53, v[8:11], s[14:15] offset:0
global_store_dwordx4 v53, v[8:11], s[14:15] offset:16
global_store_dwordx4 v53, v[8:11], s[14:15] offset:32
global_store_dwordx4 v53, v[8:11], s[14:15] offset:48
s_waitcnt_vscnt null, 0
s_dcache_inv
; Complete scalar-cache invalidation before any dependent SMEM load.
s_waitcnt lgkmcnt(0)
v_readfirstlane_b32 s28, v53
s_add_u32 s16, s14, s28
s_addc_u32 s17, s15, 0
s_mov_b64 s[20:21], s[16:17]
s_mov_b32 s22, 64
s_mov_b32 s23, 0x30000000
; Checkpoint 429: s_buffer_load_dwordx4
clear_results
s_buffer_load_dwordx4 s[32:35], s[20:23], 0
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, s32
v_mov_b32 v17, s33
v_mov_b32 v18, s34
v_mov_b32 v19, s35
checkpoint 429

; Checkpoint 430: s_buffer_load_dwordx8
clear_results
s_buffer_load_dwordx8 s[32:39], s[20:23], 0
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, s32
v_mov_b32 v17, s33
v_mov_b32 v18, s34
v_mov_b32 v19, s35
v_mov_b32 v20, s36
v_mov_b32 v21, s37
v_mov_b32 v22, s38
v_mov_b32 v23, s39
checkpoint 430

; Checkpoint 431: s_buffer_load_dword
clear_results
s_buffer_load_dword s32, s[20:23], 0
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, s32
checkpoint 431

; Checkpoint 432: s_buffer_load_dwordx16
clear_results
s_buffer_load_dwordx16 s[32:47], s[20:23], 0
s_waitcnt lgkmcnt(0)
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
checkpoint 432

; Checkpoint 433: s_buffer_load_dwordx2
clear_results
s_buffer_load_dwordx2 s[32:33], s[20:23], 0
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, s32
v_mov_b32 v17, s33
checkpoint 433











; Checkpoint 434: s_load_dwordx4
clear_results
s_load_dwordx4 s[32:35], s[16:17], 0
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, s32
v_mov_b32 v17, s33
v_mov_b32 v18, s34
v_mov_b32 v19, s35
checkpoint 434

; Checkpoint 435: s_load_dwordx8
clear_results
s_load_dwordx8 s[32:39], s[16:17], 0
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, s32
v_mov_b32 v17, s33
v_mov_b32 v18, s34
v_mov_b32 v19, s35
v_mov_b32 v20, s36
v_mov_b32 v21, s37
v_mov_b32 v22, s38
v_mov_b32 v23, s39
checkpoint 435

; Checkpoint 436: s_load_dword
clear_results
s_load_dword s32, s[16:17], 0
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, s32
checkpoint 436

; Checkpoint 437: s_load_dwordx16
clear_results
s_load_dwordx16 s[32:47], s[16:17], 0
s_waitcnt lgkmcnt(0)
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
checkpoint 437

; Checkpoint 438: s_load_dwordx2
clear_results
s_load_dwordx2 s[32:33], s[16:17], 0
s_waitcnt lgkmcnt(0)
v_mov_b32 v16, s32
v_mov_b32 v17, s33
checkpoint 438











; Checkpoint 439: class_all_f16
v_and_b32 v12, 15, v0
v_mov_b32 v8, 31744
v_cmp_eq_u32 vcc_lo, 0, v12
v_mov_b32 v13, 32001
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 1, v12
v_mov_b32 v13, 32257
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 2, v12
v_mov_b32 v13, 64512
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 3, v12
v_mov_b32 v13, 48128
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 4, v12
v_mov_b32 v13, 32769
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 5, v12
v_mov_b32 v13, 32768
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 6, v12
v_mov_b32 v13, 0
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 7, v12
v_mov_b32 v13, 1
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 8, v12
v_mov_b32 v13, 15360
v_cndmask_b32 v8, v8, v13, vcc_lo
v_mov_b32 v9, 0x3ff
clear_results
v_cmp_class_f16 vcc_lo, v8, v9
s_mov_b32 s20, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s20
v_cmpx_class_f16 v8, v9
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s20
s_mov_b32 s20, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s20
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s20
s_mov_b32 s20, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s20
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v21, s20
v_cmp_class_f16_e64 vcc_lo, v8, v9
s_mov_b32 s20, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s20
v_cmpx_class_f16_e64 v8, v9
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v23, s20
s_mov_b32 s20, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s20
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v25, s20
s_mov_b32 s20, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s20
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v27, s20
checkpoint 439

; Checkpoint 440: class_all_f32
v_and_b32 v12, 15, v0
v_mov_b32 v8, 2139095040
v_cmp_eq_u32 vcc_lo, 0, v12
v_mov_b32 v13, 2139095041
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 1, v12
v_mov_b32 v13, 2143289345
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 2, v12
v_mov_b32 v13, 4286578688
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 3, v12
v_mov_b32 v13, 3212836864
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 4, v12
v_mov_b32 v13, 2147483649
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 5, v12
v_mov_b32 v13, 2147483648
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 6, v12
v_mov_b32 v13, 0
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 7, v12
v_mov_b32 v13, 1
v_cndmask_b32 v8, v8, v13, vcc_lo
v_cmp_eq_u32 vcc_lo, 8, v12
v_mov_b32 v13, 1065353216
v_cndmask_b32 v8, v8, v13, vcc_lo
v_mov_b32 v9, 0x3ff
clear_results
v_cmp_class_f32 vcc_lo, v8, v9
s_mov_b32 s20, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s20
v_cmpx_class_f32 v8, v9
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s20
s_mov_b32 s20, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s20
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s20
s_mov_b32 s20, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v20, s20
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v21, s20
v_cmp_class_f32_e64 vcc_lo, v8, v9
s_mov_b32 s20, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v22, s20
v_cmpx_class_f32_e64 v8, v9
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v23, s20
s_mov_b32 s20, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v24, s20
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v25, s20
s_mov_b32 s20, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v26, s20
s_mov_b32 s20, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v27, s20
checkpoint 440

; Checkpoint 441: wide_conversions_e32
clear_results
masked_begin 441
v_cvt_f64_f32 v[8:9], v4
v_cvt_i32_f64_e32 v16, v[8:9]
v_cvt_f64_i32_e32 v[18:19], v1
v_cvt_f32_f64_e32 v20, v[8:9]
v_cvt_u32_f64_e32 v21, v[8:9]
v_cvt_f64_u32_e32 v[22:23], v1
v_trunc_f64_e32 v[28:29], v[8:9]
v_ceil_f64_e32 v[30:31], v[8:9]
masked_end 441
checkpoint 441

; Checkpoint 442: wide_unary_e32
clear_results
masked_begin 442
v_cvt_f64_f32 v[8:9], v5
v_rndne_f64_e32 v[16:17], v[8:9]
v_rcp_f64_e32 v[18:19], v[8:9]
v_rsq_f64_e32 v[20:21], v[8:9]
v_sqrt_f64_e32 v[22:23], v[8:9]
v_frexp_exp_i32_f64_e32 v24, v[8:9]
v_frexp_mant_f64_e32 v[26:27], v[8:9]
masked_end 442
checkpoint 442

; Checkpoint 443: relative_moves_e32_plain
clear_results
s_mov_b32 m0, 0
v_mov_b32 v8, v1
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_movreld_b32_e32 v18, v8
v_mov_b32 v20, 0xa5a5a5a5
v_movrelsd_b32_e32 v20, v8
v_mov_b32 v22, 0xa5a5a5a5
v_movrelsd_2_b32_e32 v22, v8
checkpoint 443

; Checkpoint 444: relative_moves_e32_dpp16
clear_results
s_mov_b32 m0, 0
v_mov_b32 v8, v1
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_movreld_b32_dpp v18, v8 row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
v_mov_b32 v20, 0xa5a5a5a5
v_movrelsd_b32_dpp v20, v8 row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
v_mov_b32 v22, 0xa5a5a5a5
v_movrelsd_2_b32_dpp v22, v8 row_shr:1 row_mask:0x3 bank_mask:0xf bound_ctrl:1
checkpoint 444

; Checkpoint 445: relative_moves_e32_dpp8
clear_results
s_mov_b32 m0, 0
v_mov_b32 v8, v1
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_movreld_b32_dpp v18, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
v_mov_b32 v20, 0xa5a5a5a5
v_movrelsd_b32_dpp v20, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
v_mov_b32 v22, 0xa5a5a5a5
v_movrelsd_2_b32_dpp v22, v8 dpp8:[7,6,5,4,3,2,1,0] fi:1
checkpoint 445

; Checkpoint 446: wide_conversions_e64
clear_results
masked_begin 446
v_cvt_f64_f32 v[8:9], v4
v_cvt_i32_f64_e64 v16, v[8:9]
v_cvt_f64_i32_e64 v[18:19], v1
v_cvt_f32_f64_e64 v20, v[8:9]
v_cvt_u32_f64_e64 v21, v[8:9]
v_cvt_f64_u32_e64 v[22:23], v1
v_trunc_f64_e64 v[28:29], v[8:9]
v_ceil_f64_e64 v[30:31], v[8:9]
masked_end 446
checkpoint 446

; Checkpoint 447: wide_unary_e64
clear_results
masked_begin 447
v_cvt_f64_f32 v[8:9], v5
v_rndne_f64_e64 v[16:17], v[8:9]
v_rcp_f64_e64 v[18:19], v[8:9]
v_rsq_f64_e64 v[20:21], v[8:9]
v_sqrt_f64_e64 v[22:23], v[8:9]
v_frexp_exp_i32_f64_e64 v24, v[8:9]
v_frexp_mant_f64_e64 v[26:27], v[8:9]
masked_end 447
checkpoint 447

; Checkpoint 448: relative_moves_e64_plain
clear_results
s_mov_b32 m0, 0
v_mov_b32 v8, v1
v_mov_b32 v16, 0xa5a5a5a5
v_mov_b32 v18, 0xa5a5a5a5
v_movreld_b32_e64 v18, v8
v_mov_b32 v20, 0xa5a5a5a5
v_movrelsd_b32_e64 v20, v8
v_mov_b32 v22, 0xa5a5a5a5
v_movrelsd_2_b32_e64 v22, v8
checkpoint 448



; Checkpoint 449: swaps_and_variable_permute
clear_results
s_mov_b32 m0, 0
v_mov_b32 v8, v1
v_mov_b32 v16, v2
v_swap_b32 v16, v8
v_mov_b32 v17, v8
v_mov_b32 v18, v2
v_mov_b32 v19, v8
v_mov_b32 v20, v2
v_swaprel_b32 v20, v8
v_mov_b32 v21, v8
checkpoint 449

; Checkpoint 450: wide_sad_and_minmax
clear_results
masked_begin 450
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
masked_end 450
checkpoint 450




; Checkpoint 451: implicit_lane_addresses
clear_results
v_readfirstlane_b32 s20, v0
s_lshl_b32 s20, s20, 2
s_add_u32 m0, s20, 2048
ds_write_addtid_b32 v1
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, 0xa5a55a5a
ds_write_addtid_b32 v2
s_waitcnt lgkmcnt(0)
ds_read_addtid_b32 v16
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_addtid_b32 v17
s_waitcnt lgkmcnt(0)
s_mov_b32 m0, 0
checkpoint 451

; Checkpoint 452: packed_dot_permutations_00
clear_results
sweep_inputs int
v_mov_b32 v16, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v18, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v20, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
v_dot2c_f32_f16 v20, v8, v9 row_shr:1 row_mask:0x3 bank_mask:0xd bound_ctrl:1 fi:0
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v22, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v24, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v26, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
s_mov_b32 exec_lo, -1
sweep_inputs int
v_mov_b32 v28, 0xa5a5a5a5
s_mov_b32 exec_lo, -1
s_mov_b32 exec_lo, -1
sweep_inputs half
v_mov_b32 v30, 0xa5a5a5a5
s_mov_b32 exec_lo, 0xa5a55a5a
v_dot2c_f32_f16 v30, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
checkpoint 452



; Checkpoint 453: rdna2_immediate_compares_0
clear_results
s_mov_b32 s16, 0x1234
s_cmpk_eq_i32 s16, 0x1234
v_mov_b32 v16, src_scc
s_mov_b32 s16, s8
s_cmpk_eq_i32 s16, 0x1234
v_mov_b32 v17, src_scc
s_mov_b32 s16, -1
s_cmpk_eq_i32 s16, 0x1234
v_mov_b32 v18, src_scc
s_mov_b32 s16, 0
s_cmpk_eq_i32 s16, 0x1234
v_mov_b32 v19, src_scc
s_mov_b32 s16, 0x1234
s_cmpk_lg_i32 s16, 0x1234
v_mov_b32 v20, src_scc
s_mov_b32 s16, s8
s_cmpk_lg_i32 s16, 0x1234
v_mov_b32 v21, src_scc
s_mov_b32 s16, -1
s_cmpk_lg_i32 s16, 0x1234
v_mov_b32 v22, src_scc
s_mov_b32 s16, 0
s_cmpk_lg_i32 s16, 0x1234
v_mov_b32 v23, src_scc
s_mov_b32 s16, 0x1234
s_cmpk_gt_i32 s16, 0x1234
v_mov_b32 v24, src_scc
s_mov_b32 s16, s8
s_cmpk_gt_i32 s16, 0x1234
v_mov_b32 v25, src_scc
s_mov_b32 s16, -1
s_cmpk_gt_i32 s16, 0x1234
v_mov_b32 v26, src_scc
s_mov_b32 s16, 0
s_cmpk_gt_i32 s16, 0x1234
v_mov_b32 v27, src_scc
s_mov_b32 s16, 0x1234
s_cmpk_ge_i32 s16, 0x1234
v_mov_b32 v28, src_scc
s_mov_b32 s16, s8
s_cmpk_ge_i32 s16, 0x1234
v_mov_b32 v29, src_scc
s_mov_b32 s16, -1
s_cmpk_ge_i32 s16, 0x1234
v_mov_b32 v30, src_scc
s_mov_b32 s16, 0
s_cmpk_ge_i32 s16, 0x1234
v_mov_b32 v31, src_scc
checkpoint 453

; Checkpoint 454: rdna2_immediate_compares_1
clear_results
s_mov_b32 s16, 0x1234
s_cmpk_lt_i32 s16, 0x1234
v_mov_b32 v16, src_scc
s_mov_b32 s16, s8
s_cmpk_lt_i32 s16, 0x1234
v_mov_b32 v17, src_scc
s_mov_b32 s16, -1
s_cmpk_lt_i32 s16, 0x1234
v_mov_b32 v18, src_scc
s_mov_b32 s16, 0
s_cmpk_lt_i32 s16, 0x1234
v_mov_b32 v19, src_scc
s_mov_b32 s16, 0x1234
s_cmpk_le_i32 s16, 0x1234
v_mov_b32 v20, src_scc
s_mov_b32 s16, s8
s_cmpk_le_i32 s16, 0x1234
v_mov_b32 v21, src_scc
s_mov_b32 s16, -1
s_cmpk_le_i32 s16, 0x1234
v_mov_b32 v22, src_scc
s_mov_b32 s16, 0
s_cmpk_le_i32 s16, 0x1234
v_mov_b32 v23, src_scc
s_mov_b32 s16, 0x1234
s_cmpk_eq_u32 s16, 0x1234
v_mov_b32 v24, src_scc
s_mov_b32 s16, s8
s_cmpk_eq_u32 s16, 0x1234
v_mov_b32 v25, src_scc
s_mov_b32 s16, -1
s_cmpk_eq_u32 s16, 0x1234
v_mov_b32 v26, src_scc
s_mov_b32 s16, 0
s_cmpk_eq_u32 s16, 0x1234
v_mov_b32 v27, src_scc
s_mov_b32 s16, 0x1234
s_cmpk_lg_u32 s16, 0x1234
v_mov_b32 v28, src_scc
s_mov_b32 s16, s8
s_cmpk_lg_u32 s16, 0x1234
v_mov_b32 v29, src_scc
s_mov_b32 s16, -1
s_cmpk_lg_u32 s16, 0x1234
v_mov_b32 v30, src_scc
s_mov_b32 s16, 0
s_cmpk_lg_u32 s16, 0x1234
v_mov_b32 v31, src_scc
checkpoint 454

; Checkpoint 455: rdna2_immediate_compares_2
clear_results
s_mov_b32 s16, 0x1234
s_cmpk_gt_u32 s16, 0x1234
v_mov_b32 v16, src_scc
s_mov_b32 s16, s8
s_cmpk_gt_u32 s16, 0x1234
v_mov_b32 v17, src_scc
s_mov_b32 s16, -1
s_cmpk_gt_u32 s16, 0x1234
v_mov_b32 v18, src_scc
s_mov_b32 s16, 0
s_cmpk_gt_u32 s16, 0x1234
v_mov_b32 v19, src_scc
s_mov_b32 s16, 0x1234
s_cmpk_ge_u32 s16, 0x1234
v_mov_b32 v20, src_scc
s_mov_b32 s16, s8
s_cmpk_ge_u32 s16, 0x1234
v_mov_b32 v21, src_scc
s_mov_b32 s16, -1
s_cmpk_ge_u32 s16, 0x1234
v_mov_b32 v22, src_scc
s_mov_b32 s16, 0
s_cmpk_ge_u32 s16, 0x1234
v_mov_b32 v23, src_scc
s_mov_b32 s16, 0x1234
s_cmpk_lt_u32 s16, 0x1234
v_mov_b32 v24, src_scc
s_mov_b32 s16, s8
s_cmpk_lt_u32 s16, 0x1234
v_mov_b32 v25, src_scc
s_mov_b32 s16, -1
s_cmpk_lt_u32 s16, 0x1234
v_mov_b32 v26, src_scc
s_mov_b32 s16, 0
s_cmpk_lt_u32 s16, 0x1234
v_mov_b32 v27, src_scc
s_mov_b32 s16, 0x1234
s_cmpk_le_u32 s16, 0x1234
v_mov_b32 v28, src_scc
s_mov_b32 s16, s8
s_cmpk_le_u32 s16, 0x1234
v_mov_b32 v29, src_scc
s_mov_b32 s16, -1
s_cmpk_le_u32 s16, 0x1234
v_mov_b32 v30, src_scc
s_mov_b32 s16, 0
s_cmpk_le_u32 s16, 0x1234
v_mov_b32 v31, src_scc
checkpoint 455

; Checkpoint 456: rdna2_legacy_accumulators_e32_plain
clear_results
v_cvt_pkrtz_f16_f32 v8, v4, v5
v_cvt_pkrtz_f16_f32 v9, v5, v6
v_mov_b32 v16, v6
v_mov_b32 v17, v4
s_mov_b32 exec_lo, 0xa5a55a5a
v_dot2c_f32_f16 v16, v8, v9
s_mov_b32 exec_lo, -1
checkpoint 456

; Checkpoint 457: rdna2_legacy_accumulators_e32_dpp16
clear_results
v_cvt_pkrtz_f16_f32 v8, v4, v5
v_cvt_pkrtz_f16_f32 v9, v5, v6
v_mov_b32 v16, v6
v_mov_b32 v17, v4
s_mov_b32 exec_lo, 0xa5a55a5a
v_dot2c_f32_f16 v16, v8, v9 row_shr:1 row_mask:0xf bank_mask:0xd bound_ctrl:1 fi:1
s_mov_b32 exec_lo, -1
checkpoint 457

; Checkpoint 458: rdna2_legacy_accumulators_e32_dpp8
clear_results
v_cvt_pkrtz_f16_f32 v8, v4, v5
v_cvt_pkrtz_f16_f32 v9, v5, v6
v_mov_b32 v16, v6
v_mov_b32 v17, v4
s_mov_b32 exec_lo, 0xa5a55a5a
v_dot2c_f32_f16 v16, v8, v9 dpp8:[7,6,5,4,3,2,1,0] fi:1
s_mov_b32 exec_lo, -1
checkpoint 458

; Checkpoint 459: rdna2_constant_cmpx_f16_e32
clear_results
v_mov_b32 v8, v4
v_mov_b32 v9, 0
v_mov_b32 v10, v5
v_mov_b32 v11, 0
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_f_f16_e32 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_tru_f16_e32 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_f_f16_e32 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_tru_f16_e32 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s16
checkpoint 459

; Checkpoint 460: rdna2_constant_cmpx_f32_e32
clear_results
v_mov_b32 v8, v4
v_mov_b32 v9, 0
v_mov_b32 v10, v5
v_mov_b32 v11, 0
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_f_f32_e32 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_tru_f32_e32 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_f_f32_e32 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_tru_f32_e32 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s16
checkpoint 460

; Checkpoint 461: rdna2_constant_cmpx_f64_e32
clear_results
v_mov_b32 v8, v4
v_mov_b32 v9, 0
v_mov_b32 v10, v5
v_mov_b32 v11, 0
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_f_f64_e32 v[8:9], v[10:11]
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_tru_f64_e32 v[8:9], v[10:11]
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_f_f64_e32 vcc_lo, v[8:9], v[10:11]
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_tru_f64_e32 vcc_lo, v[8:9], v[10:11]
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s16
checkpoint 461

; Checkpoint 462: rdna2_constant_cmpx_i32_e32
clear_results
v_mov_b32 v8, v4
v_mov_b32 v9, 0
v_mov_b32 v10, v5
v_mov_b32 v11, 0
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_f_i32_e32 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_t_i32_e32 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_f_i32_e32 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_t_i32_e32 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s16
checkpoint 462

; Checkpoint 463: rdna2_constant_cmpx_u32_e32
clear_results
v_mov_b32 v8, v4
v_mov_b32 v9, 0
v_mov_b32 v10, v5
v_mov_b32 v11, 0
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_f_u32_e32 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_t_u32_e32 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_f_u32_e32 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_t_u32_e32 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s16
checkpoint 463

; Checkpoint 464: rdna2_constant_cmpx_i64_e32
clear_results
v_mov_b32 v8, v4
v_mov_b32 v9, 0
v_mov_b32 v10, v5
v_mov_b32 v11, 0
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_f_i64_e32 v[8:9], v[10:11]
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_t_i64_e32 v[8:9], v[10:11]
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_f_i64_e32 vcc_lo, v[8:9], v[10:11]
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_t_i64_e32 vcc_lo, v[8:9], v[10:11]
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s16
checkpoint 464

; Checkpoint 465: rdna2_constant_cmpx_u64_e32
clear_results
v_mov_b32 v8, v4
v_mov_b32 v9, 0
v_mov_b32 v10, v5
v_mov_b32 v11, 0
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_f_u64_e32 v[8:9], v[10:11]
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_t_u64_e32 v[8:9], v[10:11]
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_f_u64_e32 vcc_lo, v[8:9], v[10:11]
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_t_u64_e32 vcc_lo, v[8:9], v[10:11]
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s16
checkpoint 465

; Checkpoint 466: rdna2_constant_cmpx_f16_e64
clear_results
v_mov_b32 v8, v4
v_mov_b32 v9, 0
v_mov_b32 v10, v5
v_mov_b32 v11, 0
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_f_f16_e64 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_tru_f16_e64 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_f_f16_e64 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_tru_f16_e64 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s16
checkpoint 466

; Checkpoint 467: rdna2_constant_cmpx_f32_e64
clear_results
v_mov_b32 v8, v4
v_mov_b32 v9, 0
v_mov_b32 v10, v5
v_mov_b32 v11, 0
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_f_f32_e64 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_tru_f32_e64 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_f_f32_e64 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_tru_f32_e64 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s16
checkpoint 467

; Checkpoint 468: rdna2_constant_cmpx_f64_e64
clear_results
v_mov_b32 v8, v4
v_mov_b32 v9, 0
v_mov_b32 v10, v5
v_mov_b32 v11, 0
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_f_f64_e64 v[8:9], v[10:11]
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_tru_f64_e64 v[8:9], v[10:11]
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_f_f64_e64 vcc_lo, v[8:9], v[10:11]
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_tru_f64_e64 vcc_lo, v[8:9], v[10:11]
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s16
checkpoint 468

; Checkpoint 469: rdna2_constant_cmpx_i32_e64
clear_results
v_mov_b32 v8, v4
v_mov_b32 v9, 0
v_mov_b32 v10, v5
v_mov_b32 v11, 0
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_f_i32_e64 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_t_i32_e64 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_f_i32_e64 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_t_i32_e64 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s16
checkpoint 469

; Checkpoint 470: rdna2_constant_cmpx_u32_e64
clear_results
v_mov_b32 v8, v4
v_mov_b32 v9, 0
v_mov_b32 v10, v5
v_mov_b32 v11, 0
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_f_u32_e64 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_t_u32_e64 v8, v10
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_f_u32_e64 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_t_u32_e64 vcc_lo, v8, v10
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s16
checkpoint 470

; Checkpoint 471: rdna2_constant_cmpx_i64_e64
clear_results
v_mov_b32 v8, v4
v_mov_b32 v9, 0
v_mov_b32 v10, v5
v_mov_b32 v11, 0
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_f_i64_e64 v[8:9], v[10:11]
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_t_i64_e64 v[8:9], v[10:11]
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_f_i64_e64 vcc_lo, v[8:9], v[10:11]
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_t_i64_e64 vcc_lo, v[8:9], v[10:11]
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s16
checkpoint 471

; Checkpoint 472: rdna2_constant_cmpx_u64_e64
clear_results
v_mov_b32 v8, v4
v_mov_b32 v9, 0
v_mov_b32 v10, v5
v_mov_b32 v11, 0
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_f_u64_e64 v[8:9], v[10:11]
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v16, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmpx_t_u64_e64 v[8:9], v[10:11]
s_mov_b32 s16, exec_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v17, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_f_u64_e64 vcc_lo, v[8:9], v[10:11]
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v18, s16
s_mov_b32 exec_lo, 0xa5a55a5a
v_cmp_t_u64_e64 vcc_lo, v[8:9], v[10:11]
s_mov_b32 s16, vcc_lo
s_mov_b32 exec_lo, -1
v_mov_b32 v19, s16
checkpoint 472

; Checkpoint 473: rdna2_ds_cmpstore_f32
clear_results
v_lshlrev_b32 v52, 4, v0
v_mov_b32 v8, 0x3f800000
v_mov_b32 v9, 0x3ff00000
v_mov_b32 v10, 0x40000000
v_mov_b32 v11, 0x40000000
ds_write_b32 v52, v8
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_mov_b32 v40, 0x40000000
v_mov_b32 v41, 0x40000000
v_and_b32 v44, 1, v0
v_xor_b32 v42, v44, v8
v_mov_b32 v43, v9
ds_cmpst_f32 v52, v42, v40
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b32 v20, v52
s_waitcnt lgkmcnt(0)
checkpoint 473

; Checkpoint 474: rdna2_ds_cmpstore_rtn_f32
clear_results
v_lshlrev_b32 v52, 4, v0
v_mov_b32 v8, 0x3f800000
v_mov_b32 v9, 0x3ff00000
v_mov_b32 v10, 0x40000000
v_mov_b32 v11, 0x40000000
ds_write_b32 v52, v8
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_mov_b32 v40, 0x40000000
v_mov_b32 v41, 0x40000000
v_and_b32 v44, 1, v0
v_xor_b32 v42, v44, v8
v_mov_b32 v43, v9
ds_cmpst_rtn_f32 v16, v52, v42, v40
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b32 v20, v52
s_waitcnt lgkmcnt(0)
checkpoint 474

; Checkpoint 475: rdna2_ds_cmpstore_f64
clear_results
v_lshlrev_b32 v52, 4, v0
v_mov_b32 v8, 0x3f800000
v_mov_b32 v9, 0x3ff00000
v_mov_b32 v10, 0x40000000
v_mov_b32 v11, 0x40000000
ds_write_b64 v52, v[8:9]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_mov_b32 v40, 0
v_mov_b32 v41, 0x40000000
v_and_b32 v44, 1, v0
v_xor_b32 v42, v44, v8
v_mov_b32 v43, v9
ds_cmpst_f64 v52, v[42:43], v[40:41]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b64 v[20:21], v52
s_waitcnt lgkmcnt(0)
checkpoint 475

; Checkpoint 476: rdna2_ds_cmpstore_rtn_f64
clear_results
v_lshlrev_b32 v52, 4, v0
v_mov_b32 v8, 0x3f800000
v_mov_b32 v9, 0x3ff00000
v_mov_b32 v10, 0x40000000
v_mov_b32 v11, 0x40000000
ds_write_b64 v52, v[8:9]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_mov_b32 v40, 0
v_mov_b32 v41, 0x40000000
v_and_b32 v44, 1, v0
v_xor_b32 v42, v44, v8
v_mov_b32 v43, v9
ds_cmpst_rtn_f64 v[16:17], v52, v[42:43], v[40:41]
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b64 v[20:21], v52
s_waitcnt lgkmcnt(0)
checkpoint 476

; Checkpoint 477: rdna2_lds_wrap
clear_results
v_lshlrev_b32 v52, 4, v0
v_and_b32 v8, 7, v0
v_mov_b32 v9, 4
v_mov_b32 v10, 2
ds_write_b32 v52, v8
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, 0xa5a55a5a
ds_wrap_rtn_b32 v16, v52, v9, v10
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
ds_read_b32 v17, v52
s_waitcnt lgkmcnt(0)
checkpoint 477

; Checkpoint 478: rdna2_flat_atomic_cmpswap_f32_no_return
clear_results
s_load_dwordx2 s[14:15], s[0:1], 32
s_waitcnt lgkmcnt(0)
s_lshl_b32 s12, s48, 12
s_add_u32 s14, s14, s12
s_addc_u32 s15, s15, 0
v_lshlrev_b32 v53, 6, v0
v_mov_b32 v8, 0x3f800000
v_mov_b32 v9, 0x40000000
global_store_dword v53, v8, s[14:15]
s_waitcnt_vscnt null, 0
v_add_co_u32 v50, vcc_lo, s14, v53
v_add_co_ci_u32 v51, vcc_lo, s15, 0, vcc_lo
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
flat_atomic_fcmpswap v[50:51], v[40:41]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dword v20, v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
checkpoint 478

; Checkpoint 479: rdna2_flat_atomic_cmpswap_f32_return
clear_results
s_load_dwordx2 s[14:15], s[0:1], 32
s_waitcnt lgkmcnt(0)
s_lshl_b32 s12, s48, 12
s_add_u32 s14, s14, s12
s_addc_u32 s15, s15, 0
v_lshlrev_b32 v53, 6, v0
v_mov_b32 v8, 0x3f800000
v_mov_b32 v9, 0x40000000
global_store_dword v53, v8, s[14:15]
s_waitcnt_vscnt null, 0
v_add_co_u32 v50, vcc_lo, s14, v53
v_add_co_ci_u32 v51, vcc_lo, s15, 0, vcc_lo
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
flat_atomic_fcmpswap v16, v[50:51], v[40:41] glc
s_waitcnt vmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dword v20, v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 479

; Checkpoint 480: rdna2_buffer_atomic_cmpswap_f32_no_return
clear_results
s_load_dwordx2 s[14:15], s[0:1], 32
s_waitcnt lgkmcnt(0)
s_lshl_b32 s12, s48, 12
s_add_u32 s14, s14, s12
s_addc_u32 s15, s15, 0
v_lshlrev_b32 v53, 6, v0
v_mov_b32 v8, 0x3f800000
v_mov_b32 v9, 0x40000000
global_store_dword v53, v8, s[14:15]
s_waitcnt_vscnt null, 0
s_mov_b64 s[24:25], s[14:15]
s_mov_b32 s26, 4096
s_mov_b32 s27, 0x3003ffac
s_mov_b32 s28, 0
v_mov_b32 v16, v8
v_mov_b32 v17, v9
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
v_mov_b32 v16, v40
v_mov_b32 v17, v41
buffer_atomic_fcmpswap v[16:17], v53, s[24:27], s28 offen
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
s_mov_b32 exec_lo, -1
global_load_dword v20, v53, s[14:15]
s_waitcnt vmcnt(0)
s_waitcnt_vscnt null, 0
checkpoint 480

; Checkpoint 481: rdna2_buffer_atomic_cmpswap_f32_return
clear_results
s_load_dwordx2 s[14:15], s[0:1], 32
s_waitcnt lgkmcnt(0)
s_lshl_b32 s12, s48, 12
s_add_u32 s14, s14, s12
s_addc_u32 s15, s15, 0
v_lshlrev_b32 v53, 6, v0
v_mov_b32 v8, 0x3f800000
v_mov_b32 v9, 0x40000000
global_store_dword v53, v8, s[14:15]
s_waitcnt_vscnt null, 0
s_mov_b64 s[24:25], s[14:15]
s_mov_b32 s26, 4096
s_mov_b32 s27, 0x3003ffac
s_mov_b32 s28, 0
v_mov_b32 v16, v8
v_mov_b32 v17, v9
s_mov_b32 exec_lo, 0xa5a55a5a
; Active even lanes match; active odd lanes miss. Replacement differs from memory.
v_xor_b32 v40, 0x00400000, v8
v_and_b32 v41, 1, v0
v_xor_b32 v41, v41, v8
v_mov_b32 v16, v40
v_mov_b32 v17, v41
buffer_atomic_fcmpswap v[16:17], v53, s[24:27], s28 offen glc
s_waitcnt vmcnt(0)
s_mov_b32 exec_lo, -1
global_load_dword v20, v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 481

; Checkpoint 482: rdna2_wait_and_cache
clear_results
s_waitcnt_vmcnt null, 0
s_waitcnt_lgkmcnt null, 0
s_waitcnt_expcnt null, 0
s_waitcnt_depctr 0
buffer_gl0_inv
buffer_gl1_inv
s_gl1_inv
s_waitcnt vmcnt(0) lgkmcnt(0)
global_load_dword v16, v53, s[14:15]
s_waitcnt vmcnt(0)
checkpoint 482

















; Checkpoint 483: scalar_local_calls
clear_results
; PC values remain internal; only deterministic control-flow results are hashed.
s_getpc_b64 s[16:17]
.Lcall_base:
s_add_u32 s16, s16, .Lswap_body-.Lcall_base
s_addc_u32 s17, s17, 0
s_mov_b32 s20, 0
s_swappc_b64 s[18:19], s[16:17]
v_mov_b32 v16, s20
s_call_b64 s[18:19], .Lcall_body
v_mov_b32 v17, s20
s_branch .Lcalls_done
.Lswap_body:
s_add_u32 s20, s20, 7
s_setpc_b64 s[18:19]
.Lcall_body:
s_mul_i32 s20, s20, 13
s_setpc_b64 s[18:19]
.Lcalls_done:
v_readfirstlane_b32 s16, v1
v_mov_b32 v18, s16
s_movk_i32 s16, 0x1234
s_addk_i32 s16, 7
s_mulk_i32 s16, 13
v_mov_b32 v19, s16
s_cmp_eq_u32 s8, 1
s_cmovk_i32 s16, 0x5678
v_mov_b32 v20, s16
s_getreg_b32 s16, hwreg(HW_REG_MODE, 0, 8)
s_setreg_b32 hwreg(HW_REG_MODE, 0, 8), s16
s_round_mode 0
s_denorm_mode 15
s_getreg_b32 s17, hwreg(HW_REG_MODE, 0, 8)
v_mov_b32 v21, s17
checkpoint 483

; Checkpoint 484: scalar_literal_slots
clear_results
s_mov_b32 s16, 0x12345678
s_not_b32 s17, 0x13579bdf
v_mov_b32 v16, s17
s_add_u32 s17, 0x12345678, s8
v_mov_b32 v17, s17
s_add_u32 s17, s8, 0x12345678
v_mov_b32 v18, s17
s_xor_b32 s17, 0x12345678, 0x12345678
v_mov_b32 v19, s17
s_cmp_eq_u32 0x12345678, s8
s_cselect_b32 s17, 1, 0
v_mov_b32 v20, s17
s_cmp_eq_u32 s8, 0x12345678
s_cselect_b32 s17, 1, 0
v_mov_b32 v21, s17
s_cmp_eq_u32 0x12345678, 0x12345678
s_cselect_b32 s17, 1, 0
v_mov_b32 v22, s17
s_mov_b64 s[16:17], 0x12345678
v_mov_b32 v23, s16
v_mov_b32 v24, s17
s_and_b64 s[16:17], s[16:17], 0xfedcba98
v_mov_b32 v25, s16
v_mov_b32 v26, s17
checkpoint 484

; Checkpoint 485: vector_literal_slots
clear_results
masked_begin 486
v_not_b32_e32 v16, 0x12345678
v_xor_b32_e32 v17, 0x12345678, v1
v_xor_b32_e64 v18, v1, 0x12345678
v_xor_b32_e64 v19, 0x12345678, v1
v_xor_b32_e64 v20, 0x12345678, 0x12345678
v_bfi_b32 v21, 0x12345678, v1, v2
v_bfi_b32 v22, v1, 0x12345678, v2
v_bfi_b32 v23, v1, v2, 0x12345678
v_bfi_b32 v24, 0x12345678, v1, 0x12345678
v_cmp_eq_u32_e32 vcc_lo, 0x12345678, v1
v_mov_b32 v25, vcc_lo
v_cmp_eq_u32_e64 vcc_lo, v1, 0x12345678
v_mov_b32 v26, vcc_lo
v_cmp_eq_u32_e64 vcc_lo, 0x12345678, 0x12345678
v_mov_b32 v27, vcc_lo
v_fma_f32 v28, 0x3eaaaaab, v4, v5
v_fma_f32 v29, v4, 0x3eaaaaab, v5
v_fma_f32 v30, v4, v5, 0x3eaaaaab
v_fma_f32 v31, 0x3eaaaaab, v4, 0x3eaaaaab
masked_end 486
checkpoint 485

; Checkpoint 486: inline_constant_selectors
clear_results
masked_begin 487
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
masked_end 487
checkpoint 486

; Checkpoint 487: ds_permute_masks
clear_results
; Unique destinations avoid a lane-collision ordering dependency.
v_xor_b32 v8, 31, v3
v_lshlrev_b32 v8, 2, v8
ds_permute_b32 v16, v8, v1
s_waitcnt lgkmcnt(0)
v_mov_b32 v17, v16
s_mov_b32 exec_lo, 0x55555555
v_xor_b32 v8, 2, v3
v_lshlrev_b32 v8, 2, v8
ds_permute_b32 v18, v8, v2
s_waitcnt lgkmcnt(0)
s_mov_b32 exec_lo, -1
checkpoint 487

; Checkpoint 488: scalar_mask_branches
clear_results
; Each condition is taken once and falls through once. No lane data is lost.
s_mov_b32 s16, 0
s_mov_b32 vcc_lo, 0
s_cbranch_vccz .Lzero_vcc
s_add_u32 s16, s16, 100
.Lzero_vcc:
s_add_u32 s16, s16, 1
s_mov_b32 vcc_lo, -1
s_cbranch_vccz .Lnonzero_vcc
s_add_u32 s16, s16, 2
.Lnonzero_vcc:
s_mov_b32 exec_lo, 0
s_cbranch_execnz .Lempty_exec
s_add_u32 s16, s16, 4
.Lempty_exec:
s_mov_b32 exec_lo, -1
s_cbranch_execnz .Lnonempty_exec
s_add_u32 s16, s16, 100
.Lnonempty_exec:
v_mov_b32 v16, s16
s_nop 0
v_nop
checkpoint 488

.Lfinish:
s_waitcnt_vscnt null, 0
s_endpgm
.Lend:
.size guitar_hero_rdna2, .Lend-guitar_hero_rdna2
.rodata
.p2align 6
.amdhsa_kernel guitar_hero_rdna2
  .amdhsa_group_segment_fixed_size 4096
  .amdhsa_private_segment_fixed_size 64
  .amdhsa_kernarg_size 40
  .amdhsa_user_sgpr_count 4
  .amdhsa_user_sgpr_kernarg_segment_ptr 1
  .amdhsa_user_sgpr_flat_scratch_init 1
  .amdhsa_wavefront_size32 1
  .amdhsa_system_sgpr_workgroup_id_x 1
  .amdhsa_system_sgpr_private_segment_wavefront_offset 1
  .amdhsa_system_vgpr_workitem_id 0
  .amdhsa_next_free_vgpr 64
  .amdhsa_next_free_sgpr 80
  .amdhsa_reserve_vcc 1
  .amdhsa_reserve_flat_scratch 1
  .amdhsa_dx10_clamp 1
  .amdhsa_ieee_mode 1
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
amdhsa.target: amdgcn-amd-amdhsa--gfx1030
amdhsa.kernels:
  - .name: guitar_hero_rdna2
    .symbol: guitar_hero_rdna2.kd
    .kernarg_segment_size: 40
    .kernarg_segment_align: 8
    .group_segment_fixed_size: 4096
    .private_segment_fixed_size: 64
    .wavefront_size: 32
    .sgpr_count: 80
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
