	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1250"
	.amdhsa_code_object_version 6
	.text
	.protected	_Z9trans_ldsPKfPfj      ; -- Begin function _Z9trans_ldsPKfPfj
	.globl	_Z9trans_ldsPKfPfj
	.p2align	8
	.type	_Z9trans_ldsPKfPfj,@function
_Z9trans_ldsPKfPfj:                     ; @_Z9trans_ldsPKfPfj
	.cfi_startproc
; %bb.0:
	s_mov_b64 s[64:65], 0
	v_nop
	global_prefetch_b8 v0, s[64:65] scope:SCOPE_SE
	.cfi_escape 0x0f, 0x04, 0x30, 0x36, 0xe9, 0x02 ; CFA is 0 in private_wave aspace
	.cfi_undefined 16
	s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1 ;  msbs: dst=0 src0=0 src1=0 src2=0
	s_load_b32 s2, s[0:1], 0x24 nv
	s_bfe_u32 s3, ttmp6, 0x4000c
	s_clause 0x1
	s_load_b32 s8, s[0:1], 0x10 nv
	s_load_b128 s[4:7], s[0:1], 0x0 nv
	s_add_co_i32 s3, s3, 1
	s_wait_xcnt 0x0
	s_and_b32 s0, ttmp6, 15
	s_mul_i32 s1, ttmp9, s3
	s_getreg_b32 s3, hwreg(HW_REG_IB_STS2, 6, 4)
	s_add_co_i32 s1, s0, s1
	v_mov_b32_e32 v3, 0
	s_wait_kmcnt 0x0
	s_and_b32 s0, s2, 0xffff
	s_cmp_eq_u32 s3, 0
	s_cselect_b32 s1, ttmp9, s1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mad_u32 v1, s1, s0, v0
	v_cmp_gt_u32_e32 vcc_lo, s8, v1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_2
; %bb.1:
	global_load_b32 v3, v1, s[4:5] scale_offset
.LBB0_2:
	s_wait_xcnt 0x0
	s_or_b32 exec_lo, exec_lo, s1
	v_lshlrev_b32_e32 v2, 2, v0
	s_wait_loadcnt 0x0
	ds_store_b32 v2, v3
	s_wait_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_4
; %bb.3:
	s_cvt_f32_u32 s1, s0
	v_add_nc_u16 v0.l, v0.l, 1
	v_mov_b16_e32 v0.h, 0
	ds_load_b32 v2, v2
	v_s_rcp_f32 s2, s1
	v_cvt_f32_u32_e32 v3, v0
	s_delay_alu instid0(TRANS32_DEP_1) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v4, s2, v3
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_trunc_f32_e32 v4, v4
	v_fma_f32 v3, -v4, s1, v3
	v_cvt_u32_f32_e32 v4, v4
	s_wait_dscnt 0x0
	v_mul_f32_e32 v2, 0x3fb8aa3b, v2
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_ge_f32_e64 vcc_lo, |v3|, s1
	v_exp_f32_e32 v2, v2
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v3, null, 0, v4, vcc_lo
	v_mul_lo_u32 v3, v3, s0
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_sub_nc_u32_e32 v0, v0, v3
	v_and_b32_e32 v0, 0xffff, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_1)
	v_lshlrev_b32_e32 v0, 2, v0
	ds_load_b32 v0, v0
	s_wait_dscnt 0x0
	v_add_f32_e32 v0, 1.0, v0
	v_cmp_gt_f32_e32 vcc_lo, 0x800000, v0
	v_cndmask_b32_e64 v3, 0, 32, vcc_lo
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ldexp_f32 v0, v0, v3
	v_log_f32_e32 v0, v0
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v3, 0x3f317217, v0
	v_cmp_gt_f32_e64 s0, 0x7f800000, |v0|
	v_fma_f32 v4, 0x3f317217, v0, -v3
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fmamk_f32 v4, v0, 0x3377d1cf, v4
	v_add_f32_e32 v3, v3, v4
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v0, v0, v3, s0
	v_cndmask_b32_e64 v3, 0, 0x41b17218, vcc_lo
	v_sub_f32_e32 v0, v0, v3
	s_delay_alu instid0(VALU_DEP_1)
	v_add_f32_e32 v0, v2, v0
	global_store_b32 v1, v0, s[6:7] scale_offset
.LBB0_4:
	s_endpgm
.Lfunc_end0:
	.size	_Z9trans_ldsPKfPfj, .Lfunc_end0-_Z9trans_ldsPKfPfj
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _Z9trans_ldsPKfPfj
		.amdhsa_group_segment_fixed_size 1024
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 280
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
		.amdhsa_next_free_vgpr 5
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
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-_Z9trans_ldsPKfPfj)<<4)&4080)>>4
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
	.set .L_Z9trans_ldsPKfPfj.num_vgpr, 5
	.set .L_Z9trans_ldsPKfPfj.num_agpr, 0
	.set .L_Z9trans_ldsPKfPfj.numbered_sgpr, 66
	.set .L_Z9trans_ldsPKfPfj.num_named_barrier, 0
	.set .L_Z9trans_ldsPKfPfj.private_seg_size, 0
	.set .L_Z9trans_ldsPKfPfj.uses_vcc, 1
	.set .L_Z9trans_ldsPKfPfj.uses_flat_scratch, 0
	.set .L_Z9trans_ldsPKfPfj.has_dyn_sized_stack, 0
	.set .L_Z9trans_ldsPKfPfj.has_recursion, 0
	.set .L_Z9trans_ldsPKfPfj.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 484
; TotalNumSgprs: 68
; NumVgprs: 5
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 1024 bytes/workgroup (compile time only)
; SGPRBlocks: 0
; VGPRBlocks: 0
; NumSGPRsForWavesPerEU: 68
; NumVGPRsForWavesPerEU: 5
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
      - .actual_access:  write_only
        .address_space:  global
        .offset:         8
        .size:           8
        .value_kind:     global_buffer
      - .offset:         16
        .size:           4
        .value_kind:     by_value
      - .offset:         24
        .size:           4
        .value_kind:     hidden_block_count_x
      - .offset:         28
        .size:           4
        .value_kind:     hidden_block_count_y
      - .offset:         32
        .size:           4
        .value_kind:     hidden_block_count_z
      - .offset:         36
        .size:           2
        .value_kind:     hidden_group_size_x
      - .offset:         38
        .size:           2
        .value_kind:     hidden_group_size_y
      - .offset:         40
        .size:           2
        .value_kind:     hidden_group_size_z
      - .offset:         42
        .size:           2
        .value_kind:     hidden_remainder_x
      - .offset:         44
        .size:           2
        .value_kind:     hidden_remainder_y
      - .offset:         46
        .size:           2
        .value_kind:     hidden_remainder_z
      - .offset:         64
        .size:           8
        .value_kind:     hidden_global_offset_x
      - .offset:         72
        .size:           8
        .value_kind:     hidden_global_offset_y
      - .offset:         80
        .size:           8
        .value_kind:     hidden_global_offset_z
      - .offset:         88
        .size:           2
        .value_kind:     hidden_grid_dims
    .gfx1250_revision: B0
    .group_segment_fixed_size: 1024
    .kernarg_segment_align: 8
    .kernarg_segment_size: 280
    .language:       OpenCL C
    .language_version:
      - 2
      - 0
    .max_flat_workgroup_size: 1024
    .name:           _Z9trans_ldsPKfPfj
    .private_segment_fixed_size: 0
    .sgpr_count:     68
    .sgpr_spill_count: 0
    .symbol:         _Z9trans_ldsPKfPfj.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     5
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1250
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
