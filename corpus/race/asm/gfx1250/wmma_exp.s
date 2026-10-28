	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1250"
	.amdhsa_code_object_version 6
	.text
	.protected	_Z8wmma_expPKDF16_S0_Pfj ; -- Begin function _Z8wmma_expPKDF16_S0_Pfj
	.globl	_Z8wmma_expPKDF16_S0_Pfj
	.p2align	8
	.type	_Z8wmma_expPKDF16_S0_Pfj,@function
_Z8wmma_expPKDF16_S0_Pfj:               ; @_Z8wmma_expPKDF16_S0_Pfj
	.cfi_startproc
; %bb.0:
	s_mov_b64 s[64:65], 0
	v_nop
	global_prefetch_b8 v0, s[64:65] scope:SCOPE_SE
	.cfi_escape 0x0f, 0x04, 0x30, 0x36, 0xe9, 0x02 ; CFA is 0 in private_wave aspace
	.cfi_undefined 16
	s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1 ;  msbs: dst=0 src0=0 src1=0 src2=0
	s_clause 0x1
	s_load_b96 s[8:10], s[0:1], 0x10 nv
	s_load_b128 s[4:7], s[0:1], 0x0 nv
	v_lshlrev_b32_e32 v18, 4, v0
	v_mov_b16_e32 v2.l, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v10.l, v2.l
	s_wait_kmcnt 0x0
	s_mul_i32 s0, s10, s10
	v_cmp_gt_u32_e32 vcc_lo, s0, v18
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_2
; %bb.1:
	global_load_u16 v10, v18, s[4:5] scale_offset
.LBB0_2:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_4
; %bb.3:
	global_load_u16 v2, v18, s[6:7] scale_offset
.LBB0_4:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v3, 1, v18
	v_mov_b16_e32 v1.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v3
	v_mov_b16_e32 v19.l, v1.l
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_6
; %bb.5:
	global_load_u16 v19, v18, s[4:5] offset:2 scale_offset
.LBB0_6:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_8
; %bb.7:
	global_load_u16 v1, v18, s[6:7] offset:2 scale_offset
.LBB0_8:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v4, 2, v18
	v_mov_b16_e32 v3.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v4
	v_mov_b16_e32 v11.l, v3.l
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_10
; %bb.9:
	global_load_u16 v11, v18, s[4:5] offset:4 scale_offset
.LBB0_10:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_12
; %bb.11:
	global_load_u16 v3, v18, s[6:7] offset:4 scale_offset
.LBB0_12:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v4, 3, v18
	v_mov_b16_e32 v20.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v4
	v_mov_b16_e32 v21.l, v20.l
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_14
; %bb.13:
	global_load_u16 v21, v18, s[4:5] offset:6 scale_offset
.LBB0_14:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_16
; %bb.15:
	global_load_u16 v20, v18, s[6:7] offset:6 scale_offset
.LBB0_16:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v5, 4, v18
	v_mov_b16_e32 v4.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v5
	v_mov_b16_e32 v12.l, v4.l
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_18
; %bb.17:
	global_load_u16 v12, v18, s[4:5] offset:8 scale_offset
.LBB0_18:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_20
; %bb.19:
	global_load_u16 v4, v18, s[6:7] offset:8 scale_offset
.LBB0_20:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v5, 5, v18
	v_mov_b16_e32 v22.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v5
	v_mov_b16_e32 v23.l, v22.l
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_22
; %bb.21:
	global_load_u16 v23, v18, s[4:5] offset:10 scale_offset
.LBB0_22:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_24
; %bb.23:
	global_load_u16 v22, v18, s[6:7] offset:10 scale_offset
.LBB0_24:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v6, 6, v18
	v_mov_b16_e32 v5.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v6
	v_mov_b16_e32 v13.l, v5.l
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_26
; %bb.25:
	global_load_u16 v13, v18, s[4:5] offset:12 scale_offset
.LBB0_26:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_28
; %bb.27:
	global_load_u16 v5, v18, s[6:7] offset:12 scale_offset
.LBB0_28:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v6, 7, v18
	v_mov_b16_e32 v24.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v6
	v_mov_b16_e32 v25.l, v24.l
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_30
; %bb.29:
	global_load_u16 v25, v18, s[4:5] offset:14 scale_offset
.LBB0_30:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_32
; %bb.31:
	global_load_u16 v24, v18, s[6:7] offset:14 scale_offset
.LBB0_32:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v7, 8, v18
	v_mov_b16_e32 v6.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v7
	v_mov_b16_e32 v14.l, v6.l
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_34
; %bb.33:
	global_load_u16 v14, v18, s[4:5] offset:16 scale_offset
.LBB0_34:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_36
; %bb.35:
	global_load_u16 v6, v18, s[6:7] offset:16 scale_offset
.LBB0_36:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v7, 9, v18
	v_mov_b16_e32 v26.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v7
	v_mov_b16_e32 v27.l, v26.l
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_38
; %bb.37:
	global_load_u16 v27, v18, s[4:5] offset:18 scale_offset
.LBB0_38:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_40
; %bb.39:
	global_load_u16 v26, v18, s[6:7] offset:18 scale_offset
.LBB0_40:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v8, 10, v18
	v_mov_b16_e32 v7.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v8
	v_mov_b16_e32 v15.l, v7.l
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_42
; %bb.41:
	global_load_u16 v15, v18, s[4:5] offset:20 scale_offset
.LBB0_42:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_44
; %bb.43:
	global_load_u16 v7, v18, s[6:7] offset:20 scale_offset
.LBB0_44:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v8, 11, v18
	v_mov_b16_e32 v28.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v8
	v_mov_b16_e32 v29.l, v28.l
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_46
; %bb.45:
	global_load_u16 v29, v18, s[4:5] offset:22 scale_offset
.LBB0_46:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_48
; %bb.47:
	global_load_u16 v28, v18, s[6:7] offset:22 scale_offset
.LBB0_48:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v9, 12, v18
	v_mov_b16_e32 v8.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v9
	v_mov_b16_e32 v16.l, v8.l
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_50
; %bb.49:
	global_load_u16 v16, v18, s[4:5] offset:24 scale_offset
.LBB0_50:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_52
; %bb.51:
	global_load_u16 v8, v18, s[6:7] offset:24 scale_offset
.LBB0_52:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v9, 13, v18
	v_mov_b16_e32 v30.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v9
	v_mov_b16_e32 v31.l, v30.l
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_54
; %bb.53:
	global_load_u16 v31, v18, s[4:5] offset:26 scale_offset
.LBB0_54:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_56
; %bb.55:
	global_load_u16 v30, v18, s[6:7] offset:26 scale_offset
.LBB0_56:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v17, 14, v18
	v_mov_b16_e32 v9.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v17
	v_mov_b16_e32 v17.l, v9.l
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_58
; %bb.57:
	global_load_u16 v17, v18, s[4:5] offset:28 scale_offset
.LBB0_58:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_60
; %bb.59:
	global_load_u16 v9, v18, s[6:7] offset:28 scale_offset
.LBB0_60:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_or_b32_e32 v33, 15, v18
	v_mov_b16_e32 v32.l, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s0, v33
	v_mov_b16_e32 v33.l, v32.l
	s_and_saveexec_b32 s0, vcc_lo
	s_cbranch_execz .LBB0_62
; %bb.61:
	global_load_u16 v33, v18, s[4:5] offset:30 scale_offset
.LBB0_62:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s0
	s_and_saveexec_b32 s0, vcc_lo
	s_cbranch_execz .LBB0_64
; %bb.63:
	global_load_u16 v32, v18, s[6:7] offset:30 scale_offset
.LBB0_64:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s0
	s_wait_loadcnt 0x0
	v_mov_b16_e32 v17.h, v33.l
	v_mov_b16_e32 v16.h, v31.l
	v_mov_b16_e32 v15.h, v29.l
	v_mov_b16_e32 v14.h, v27.l
	v_mov_b16_e32 v13.h, v25.l
	v_mov_b16_e32 v12.h, v23.l
	v_mov_b16_e32 v11.h, v21.l
	v_mov_b16_e32 v10.h, v19.l
	v_mov_b16_e32 v9.h, v32.l
	v_mov_b16_e32 v8.h, v30.l
	v_mov_b16_e32 v7.h, v28.l
	v_mov_b16_e32 v6.h, v26.l
	v_mov_b16_e32 v5.h, v24.l
	v_mov_b16_e32 v4.h, v22.l
	v_mov_b16_e32 v3.h, v20.l
	v_mov_b16_e32 v2.h, v1.l
	s_delay_alu instid0(VALU_DEP_1)
	v_wmma_f32_16x16x32_f16 v[18:25], v[10:17], v[2:9], 0
	s_mov_b32 s0, 0x3fb8aa3b
	v_lshlrev_b32_e32 v0, 5, v0
	v_nop
	v_nop
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_pk_mul_f32 v[2:3], v[18:19], s[0:1] op_sel_hi:[1,0]
	v_pk_mul_f32 v[4:5], v[20:21], s[0:1] op_sel_hi:[1,0]
	v_pk_mul_f32 v[6:7], v[22:23], s[0:1] op_sel_hi:[1,0]
	v_pk_mul_f32 v[8:9], v[24:25], s[0:1] op_sel_hi:[1,0]
	s_delay_alu instid0(VALU_DEP_4)
	v_exp_f32_e32 v2, v2
	v_exp_f32_e32 v3, v3
	v_exp_f32_e32 v4, v4
	v_exp_f32_e32 v5, v5
	v_exp_f32_e32 v6, v6
	v_exp_f32_e32 v7, v7
	v_exp_f32_e32 v8, v8
	v_exp_f32_e32 v9, v9
	s_clause 0x1
	global_store_b128 v0, v[2:5], s[8:9]
	global_store_b128 v0, v[6:9], s[8:9] offset:16
	s_endpgm
.Lfunc_end0:
	.size	_Z8wmma_expPKDF16_S0_Pfj, .Lfunc_end0-_Z8wmma_expPKDF16_S0_Pfj
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _Z8wmma_expPKDF16_S0_Pfj
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 28
		.amdhsa_user_sgpr_count 2
		.amdhsa_user_sgpr_dispatch_ptr 0
		.amdhsa_user_sgpr_queue_ptr 0
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_dispatch_id 0
		.amdhsa_user_sgpr_kernarg_preload_length 0
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_user_sgpr_private_segment_size 0
		.amdhsa_wavefront_size32 1
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 34
		.amdhsa_next_free_sgpr 66
		.amdhsa_named_barrier_count 0
		.amdhsa_reserve_vcc 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_fp16_overflow 0
		.amdhsa_memory_ordered 1
		.amdhsa_forward_progress 1
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-_Z8wmma_expPKDF16_S0_Pfj)<<4)&4080)>>4
		.amdhsa_round_robin_scheduling 0
		.amdhsa_exception_fp_ieee_invalid_op 0
		.amdhsa_exception_fp_denorm_src 0
		.amdhsa_exception_fp_ieee_div_zero 0
		.amdhsa_exception_fp_ieee_overflow 0
		.amdhsa_exception_fp_ieee_underflow 0
		.amdhsa_exception_fp_ieee_inexact 0
		.amdhsa_exception_int_div_zero 0
	.end_amdhsa_kernel
	.text
                                        ; -- End function
	.set .L_Z8wmma_expPKDF16_S0_Pfj.num_vgpr, 34
	.set .L_Z8wmma_expPKDF16_S0_Pfj.num_agpr, 0
	.set .L_Z8wmma_expPKDF16_S0_Pfj.numbered_sgpr, 66
	.set .L_Z8wmma_expPKDF16_S0_Pfj.num_named_barrier, 0
	.set .L_Z8wmma_expPKDF16_S0_Pfj.private_seg_size, 0
	.set .L_Z8wmma_expPKDF16_S0_Pfj.uses_vcc, 1
	.set .L_Z8wmma_expPKDF16_S0_Pfj.uses_flat_scratch, 0
	.set .L_Z8wmma_expPKDF16_S0_Pfj.has_dyn_sized_stack, 0
	.set .L_Z8wmma_expPKDF16_S0_Pfj.has_recursion, 0
	.set .L_Z8wmma_expPKDF16_S0_Pfj.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 1480
; TotalNumSgprs: 68
; NumVgprs: 34
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 0 bytes/workgroup (compile time only)
; SGPRBlocks: 0
; VGPRBlocks: 2
; NumSGPRsForWavesPerEU: 68
; NumVGPRsForWavesPerEU: 34
; NamedBarCnt: 0
; Occupancy: 16
; WaveLimiterHint : 0
; COMPUTE_PGM_RSRC2:SCRATCH_EN: 0
; COMPUTE_PGM_RSRC2:USER_SGPR: 2
; COMPUTE_PGM_RSRC2:TRAP_HANDLER: 0
; COMPUTE_PGM_RSRC2:TGID_X_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Y_EN: 0
; COMPUTE_PGM_RSRC2:TGID_Z_EN: 0
; COMPUTE_PGM_RSRC2:TIDIG_COMP_CNT: 0
	.text
	.p2alignl 7, 3214868480
	.fill 96, 4, 3214868480
	.section	.AMDGPU.gpr_maximums,"",@progbits
	.set amdgpu.max_num_vgpr, 0
	.set amdgpu.max_num_agpr, 0
	.set amdgpu.max_num_sgpr, 0
	.set amdgpu.max_num_named_barrier, 0
	.text
	.type	__hip_cuid_corpus,@object ; @__hip_cuid_corpus
	.section	.bss,"aw",@nobits
	.globl	__hip_cuid_corpus
__hip_cuid_corpus:
	.byte	0                               ; 0x0
	.size	__hip_cuid_corpus, 1

	.ident	"AMD clang version 23.0.0git (https://github.com/ROCm/llvm-project.git 0bace1908348b840e6aa1b4b6e12151dae208158)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym __hip_cuid_corpus
	.amdgpu_metadata
---
amdhsa.kernels:
  - .args:
      - .actual_access:  read_only
        .address_space:  global
        .offset:         0
        .size:           8
        .value_kind:     global_buffer
      - .actual_access:  read_only
        .address_space:  global
        .offset:         8
        .size:           8
        .value_kind:     global_buffer
      - .actual_access:  write_only
        .address_space:  global
        .offset:         16
        .size:           8
        .value_kind:     global_buffer
      - .offset:         24
        .size:           4
        .value_kind:     by_value
    .gfx1250_revision: B0
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 28
    .language:       OpenCL C
    .language_version:
      - 2
      - 0
    .max_flat_workgroup_size: 1024
    .name:           _Z8wmma_expPKDF16_S0_Pfj
    .private_segment_fixed_size: 0
    .sgpr_count:     68
    .sgpr_spill_count: 0
    .symbol:         _Z8wmma_expPKDF16_S0_Pfj.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     34
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1250
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
