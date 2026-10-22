	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1250"
	.amdhsa_code_object_version 6
	.text
	.protected	_Z12wmma_rocwmmaPK6__halfS1_Pfjjj ; -- Begin function _Z12wmma_rocwmmaPK6__halfS1_Pfjjj
	.globl	_Z12wmma_rocwmmaPK6__halfS1_Pfjjj
	.p2align	8
	.type	_Z12wmma_rocwmmaPK6__halfS1_Pfjjj,@function
_Z12wmma_rocwmmaPK6__halfS1_Pfjjj:      ; @_Z12wmma_rocwmmaPK6__halfS1_Pfjjj
	.cfi_startproc
; %bb.0:
	s_mov_b64 s[64:65], 0
	v_nop
	global_prefetch_b8 v0, s[64:65] scope:SCOPE_SE
	.cfi_escape 0x0f, 0x04, 0x30, 0x36, 0xe9, 0x02 ; CFA is 0 in private_wave aspace
	.cfi_undefined 16
	s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1 ;  msbs: dst=0 src0=0 src1=0 src2=0
	s_clause 0x1
	s_load_b32 s2, s[0:1], 0x34 nv
	s_load_b96 s[8:10], s[0:1], 0x18 nv
	s_bfe_u32 s3, ttmp6, 0x4000c
	s_and_b32 s4, ttmp6, 15
	s_add_co_i32 s3, s3, 1
	s_getreg_b32 s5, hwreg(HW_REG_IB_STS2, 6, 4)
	s_mul_i32 s3, ttmp9, s3
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_co_i32 s4, s4, s3
	s_wait_kmcnt 0x0
	s_and_b32 s2, s2, 0xffff
	s_cmp_eq_u32 s5, 0
	s_cselect_b32 s3, ttmp9, s4
	s_lshr_b32 s4, s9, 4
	v_mad_u32 v1, s3, s2, v0
	s_cvt_f32_u32 s5, s4
	s_sub_co_i32 s3, 0, s4
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_s_rcp_f32 s5, s5
	v_lshrrev_b32_e32 v1, 5, v1
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(SALU_CYCLE_3)
	s_mul_f32 s5, s5, 0x4f7ffffe
	s_cvt_u32_f32 s2, s5
	s_delay_alu instid0(SALU_CYCLE_3) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s3, s3, s2
	s_mul_hi_u32 s3, s2, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s2, s2, s3
	v_mul_hi_u32 v2, v1, s2
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_lo_u32 v3, v2, s4
	v_dual_add_nc_u32 v4, 1, v2 :: v_dual_sub_nc_u32 v3, v1, v3
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_le_u32_e32 vcc_lo, s4, v3
	v_cndmask_b32_e32 v2, v2, v4, vcc_lo
	v_subrev_nc_u32_e32 v5, s4, v3
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_cndmask_b32 v3, v3, v5 :: v_dual_add_nc_u32 v4, 1, v2
	v_cmp_le_u32_e32 vcc_lo, s4, v3
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v2, v2, v4, vcc_lo
	v_mul_lo_u32 v3, v2, s4
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_sub_nc_u32 v1, v1, v3 :: v_dual_lshlrev_b32 v22, 4, v2
	v_lshlrev_b32_e32 v16, 4, v1
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_u32_e32 vcc_lo, s8, v22
	v_cmp_gt_u32_e64 s2, s9, v16
	s_and_b32 s2, vcc_lo, s2
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s3, s2
	s_cbranch_execz .LBB0_7
; %bb.1:
	s_clause 0x1
	s_load_b128 s[4:7], s[0:1], 0x0 nv
	s_load_b64 s[2:3], s[0:1], 0x10 nv
	v_dual_lshrrev_b32 v26, 1, v0 :: v_dual_bitop2_b32 v25, 15, v0 bitop3:0x40
	s_cmp_lg_u32 s10, 0
	s_cbranch_scc0 .LBB0_8
; %bb.2:
	v_dual_mov_b32 v12, 0 :: v_dual_bitop2_b32 v23, 15, v0 bitop3:0x40
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_and_b32_e32 v24, 8, v26
	v_mul_lo_u32 v2, v22, s10
	s_mov_b32 s1, 0
	v_mov_b32_e32 v1, v12
	s_delay_alu instid0(VALU_DEP_3)
	v_mad_u32 v0, s10, v23, v24
	v_dual_mov_b32 v3, v12 :: v_dual_mov_b32 v17, v12
	v_mad_u32 v6, s9, v23, v24
	v_dual_mov_b32 v7, v12 :: v_dual_mov_b32 v5, v12
	s_mov_b32 s0, s1
	s_wait_kmcnt 0x0
	v_lshl_add_u64 v[8:9], v[16:17], 1, s[6:7]
	v_lshlrev_b64_e32 v[0:1], 1, v[0:1]
	v_mov_b32_e32 v4, v12
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_lshl_add_u64 v[2:3], v[2:3], 1, v[0:1]
	v_dual_mov_b32 v0, v12 :: v_dual_mov_b32 v1, v12
	v_lshl_add_u64 v[18:19], v[6:7], 1, v[8:9]
	v_mov_b32_e32 v6, v12
	v_add_nc_u64_e32 v[10:11], s[4:5], v[2:3]
	v_dual_mov_b32 v2, v12 :: v_dual_mov_b32 v3, v12
	s_lshl_b32 s4, s9, 4
	s_mov_b32 s5, s1
	s_delay_alu instid0(VALU_DEP_2)
	v_add_nc_u64_e32 v[20:21], 12, v[10:11]
.LBB0_3:                                ; =>This Inner Loop Header: Depth=1
	v_nop
	v_nop
	v_nop
	v_nop
	v_lshl_add_u64 v[14:15], s[0:1], 1, v[18:19]
	v_dual_mov_b32 v13, v12 :: v_dual_mov_b32 v33, v12
	v_mov_b32_e32 v34, v12
	global_load_b128 v[8:11], v[20:21], off offset:-12
	global_load_b128 v[28:31], v[14:15], off
	s_wait_xcnt 0x0
	v_dual_mov_b32 v14, v12 :: v_dual_mov_b32 v15, v12
	v_dual_mov_b32 v32, v12 :: v_dual_mov_b32 v35, v12
	v_add_nc_u64_e32 v[20:21], 32, v[20:21]
	s_add_co_i32 s5, s5, 16
	s_add_co_i32 s0, s0, s4
	s_cmp_ge_u32 s5, s10
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x32_f16 v[0:7], v[8:15], v[28:35], v[0:7]
	s_cbranch_scc0 .LBB0_3
; %bb.4:
	s_branch .LBB0_6
.LBB0_5:
	v_dual_mov_b32 v17, 0 :: v_dual_bitop2_b32 v24, 8, v26 bitop3:0x40
	s_delay_alu instid0(VALU_DEP_1)
	v_dual_mov_b32 v23, v25 :: v_dual_mov_b32 v0, v17
	v_dual_mov_b32 v1, v17 :: v_dual_mov_b32 v2, v17
	v_dual_mov_b32 v3, v17 :: v_dual_mov_b32 v4, v17
	v_dual_mov_b32 v5, v17 :: v_dual_mov_b32 v6, v17
	v_mov_b32_e32 v7, v17
.LBB0_6:
	v_nop
	v_nop
	v_nop
	v_nop
	v_mul_lo_u32 v8, v22, s9
	v_mov_b32_e32 v9, 0
	s_mov_b32 s0, 0x3fb8aa3b
	s_delay_alu instid0(SALU_CYCLE_1)
	v_pk_mul_f32 v[0:1], v[0:1], s[0:1] op_sel_hi:[1,0]
	v_pk_mul_f32 v[2:3], v[2:3], s[0:1] op_sel_hi:[1,0]
	v_pk_mul_f32 v[4:5], v[4:5], s[0:1] op_sel_hi:[1,0]
	v_pk_mul_f32 v[6:7], v[6:7], s[0:1] op_sel_hi:[1,0]
	s_wait_kmcnt 0x0
	v_lshl_add_u64 v[10:11], v[8:9], 2, s[2:3]
	v_mad_u32 v8, s9, v24, v23
	v_exp_f32_e32 v22, v0
	v_exp_f32_e32 v23, v1
	v_exp_f32_e32 v25, v3
	v_lshl_add_u64 v[10:11], v[16:17], 2, v[10:11]
	v_exp_f32_e32 v26, v4
	v_exp_f32_e32 v24, v2
	v_exp_f32_e32 v27, v5
	v_exp_f32_e32 v6, v6
	v_lshl_add_u64 v[12:13], v[8:9], 2, v[10:11]
	v_add_nc_u32_e32 v8, s9, v8
	v_exp_f32_e32 v7, v7
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_lshl_add_u64 v[14:15], v[8:9], 2, v[10:11]
	v_add_nc_u32_e32 v8, s9, v8
	v_lshl_add_u64 v[16:17], v[8:9], 2, v[10:11]
	v_add_nc_u32_e32 v8, s9, v8
	s_clause 0x2
	global_store_b32 v[12:13], v22, off
	global_store_b32 v[14:15], v23, off
	global_store_b32 v[16:17], v24, off
	v_lshl_add_u64 v[18:19], v[8:9], 2, v[10:11]
	v_add_nc_u32_e32 v8, s9, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_lshl_add_u64 v[20:21], v[8:9], 2, v[10:11]
	v_add_nc_u32_e32 v8, s9, v8
	v_lshl_add_u64 v[0:1], v[8:9], 2, v[10:11]
	v_add_nc_u32_e32 v8, s9, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_lshl_add_u64 v[2:3], v[8:9], 2, v[10:11]
	v_add_nc_u32_e32 v8, s9, v8
	v_lshl_add_u64 v[4:5], v[8:9], 2, v[10:11]
	s_clause 0x4
	global_store_b32 v[18:19], v25, off
	global_store_b32 v[20:21], v26, off
	global_store_b32 v[0:1], v27, off
	global_store_b32 v[2:3], v6, off
	global_store_b32 v[4:5], v7, off
.LBB0_7:
	s_endpgm
.LBB0_8:
                                        ; implicit-def: $vgpr7
                                        ; implicit-def: $vgpr23
                                        ; implicit-def: $vgpr24
	s_cbranch_execnz .LBB0_5
	s_branch .LBB0_6
.Lfunc_end0:
	.size	_Z12wmma_rocwmmaPK6__halfS1_Pfjjj, .Lfunc_end0-_Z12wmma_rocwmmaPK6__halfS1_Pfjjj
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _Z12wmma_rocwmmaPK6__halfS1_Pfjjj
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 296
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
		.amdhsa_next_free_vgpr 36
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
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-_Z12wmma_rocwmmaPK6__halfS1_Pfjjj)<<4)&4080)>>4
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
	.set .L_Z12wmma_rocwmmaPK6__halfS1_Pfjjj.num_vgpr, 36
	.set .L_Z12wmma_rocwmmaPK6__halfS1_Pfjjj.num_agpr, 0
	.set .L_Z12wmma_rocwmmaPK6__halfS1_Pfjjj.numbered_sgpr, 66
	.set .L_Z12wmma_rocwmmaPK6__halfS1_Pfjjj.num_named_barrier, 0
	.set .L_Z12wmma_rocwmmaPK6__halfS1_Pfjjj.private_seg_size, 0
	.set .L_Z12wmma_rocwmmaPK6__halfS1_Pfjjj.uses_vcc, 1
	.set .L_Z12wmma_rocwmmaPK6__halfS1_Pfjjj.uses_flat_scratch, 0
	.set .L_Z12wmma_rocwmmaPK6__halfS1_Pfjjj.has_dyn_sized_stack, 0
	.set .L_Z12wmma_rocwmmaPK6__halfS1_Pfjjj.has_recursion, 0
	.set .L_Z12wmma_rocwmmaPK6__halfS1_Pfjjj.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 1032
; TotalNumSgprs: 68
; NumVgprs: 36
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 0 bytes/workgroup (compile time only)
; SGPRBlocks: 0
; VGPRBlocks: 2
; NumSGPRsForWavesPerEU: 68
; NumVGPRsForWavesPerEU: 36
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
      - .offset:         28
        .size:           4
        .value_kind:     by_value
      - .offset:         32
        .size:           4
        .value_kind:     by_value
      - .offset:         40
        .size:           4
        .value_kind:     hidden_block_count_x
      - .offset:         44
        .size:           4
        .value_kind:     hidden_block_count_y
      - .offset:         48
        .size:           4
        .value_kind:     hidden_block_count_z
      - .offset:         52
        .size:           2
        .value_kind:     hidden_group_size_x
      - .offset:         54
        .size:           2
        .value_kind:     hidden_group_size_y
      - .offset:         56
        .size:           2
        .value_kind:     hidden_group_size_z
      - .offset:         58
        .size:           2
        .value_kind:     hidden_remainder_x
      - .offset:         60
        .size:           2
        .value_kind:     hidden_remainder_y
      - .offset:         62
        .size:           2
        .value_kind:     hidden_remainder_z
      - .offset:         80
        .size:           8
        .value_kind:     hidden_global_offset_x
      - .offset:         88
        .size:           8
        .value_kind:     hidden_global_offset_y
      - .offset:         96
        .size:           8
        .value_kind:     hidden_global_offset_z
      - .offset:         104
        .size:           2
        .value_kind:     hidden_grid_dims
    .gfx1250_revision: B0
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 296
    .language:       OpenCL C
    .language_version:
      - 2
      - 0
    .max_flat_workgroup_size: 1024
    .name:           _Z12wmma_rocwmmaPK6__halfS1_Pfjjj
    .private_segment_fixed_size: 0
    .sgpr_count:     68
    .sgpr_spill_count: 0
    .symbol:         _Z12wmma_rocwmmaPK6__halfS1_Pfjjj.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     36
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1250
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
