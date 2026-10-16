	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx950"
	.amdhsa_code_object_version 6
	.text
	.protected	_Z9trans_ldsPKfPfj      ; -- Begin function _Z9trans_ldsPKfPfj
	.globl	_Z9trans_ldsPKfPfj
	.p2align	8
	.type	_Z9trans_ldsPKfPfj,@function
_Z9trans_ldsPKfPfj:                     ; @_Z9trans_ldsPKfPfj
	.cfi_startproc
; %bb.0:
	.cfi_escape 0x0f, 0x04, 0x30, 0x36, 0xe9, 0x02 ; CFA is 0 in private_wave aspace
	.cfi_undefined 16
	s_load_dword s3, s[0:1], 0x24
	s_load_dword s8, s[0:1], 0x10
	s_load_dwordx4 s[4:7], s[0:1], 0x0
	v_mov_b32_e32 v3, 0
	s_waitcnt lgkmcnt(0)
	s_and_b32 s3, s3, 0xffff
	s_mul_i32 s2, s2, s3
	v_add_u32_e32 v2, s2, v0
	v_cmp_gt_u32_e32 vcc, s8, v2
	s_and_saveexec_b64 s[0:1], vcc
	s_cbranch_execz .LBB0_2
; %bb.1:
	v_mov_b32_e32 v4, s4
	v_mov_b32_e32 v5, s5
	v_lshl_add_u64 v[4:5], v[2:3], 2, v[4:5]
	global_load_dword v3, v[4:5], off
.LBB0_2:
	s_or_b64 exec, exec, s[0:1]
	v_lshlrev_b32_e32 v1, 2, v0
	s_waitcnt vmcnt(0)
	ds_write_b32 v1, v3
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_and_saveexec_b64 s[0:1], vcc
	s_cbranch_execz .LBB0_4
; %bb.3:
	v_cvt_f32_u32_e32 v3, s3
	v_add_u16_e32 v4, 1, v0
	v_cvt_f32_u32_e32 v5, v4
	v_mov_b32_e32 v7, 2
	v_rcp_f32_e32 v6, v3
	s_mov_b32 s0, 0x800000
	v_mov_b32_e32 v0, s6
	s_mov_b32 s1, 0x3f317217
	v_mul_f32_e32 v6, v5, v6
	v_trunc_f32_e32 v6, v6
	v_cvt_u32_f32_e32 v8, v6
	v_fma_f32 v5, -v6, v3, v5
	v_cmp_ge_f32_e64 vcc, |v5|, v3
	s_nop 1
	v_addc_co_u32_e32 v3, vcc, 0, v8, vcc
	v_mul_lo_u32 v3, v3, s3
	v_sub_u32_e32 v3, v4, v3
	v_lshlrev_b32_sdwa v3, v7, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
	ds_read_b32 v4, v1
	ds_read_b32 v5, v3
	v_mov_b32_e32 v1, s7
	v_mov_b32_e32 v3, 0
	v_lshl_add_u64 v[0:1], v[2:3], 2, v[0:1]
	s_waitcnt lgkmcnt(1)
	v_mul_f32_e32 v2, 0x3fb8aa3b, v4
	s_waitcnt lgkmcnt(0)
	v_add_f32_e32 v5, 1.0, v5
	v_cmp_gt_f32_e32 vcc, s0, v5
	v_exp_f32_e32 v2, v2
	s_mov_b32 s0, 0x7f800000
	v_cndmask_b32_e64 v6, 0, 32, vcc
	v_ldexp_f32 v5, v5, v6
	v_log_f32_e32 v5, v5
	s_nop 0
	v_mul_f32_e32 v3, 0x3f317217, v5
	v_fma_f32 v4, v5, s1, -v3
	v_fmamk_f32 v4, v5, 0x3377d1cf, v4
	v_add_f32_e32 v3, v3, v4
	v_cmp_lt_f32_e64 s[0:1], |v5|, s0
	v_mov_b32_e32 v4, 0x41b17218
	v_cndmask_b32_e32 v4, 0, v4, vcc
	v_cndmask_b32_e64 v3, v5, v3, s[0:1]
	v_sub_f32_e32 v3, v3, v4
	v_add_f32_e32 v2, v2, v3
	global_store_dword v[0:1], v2, off
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
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 9
		.amdhsa_next_free_sgpr 9
		.amdhsa_accum_offset 12
		.amdhsa_reserve_vcc 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
		.amdhsa_tg_split 0
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
	.set .L_Z9trans_ldsPKfPfj.num_vgpr, 9
	.set .L_Z9trans_ldsPKfPfj.num_agpr, 0
	.set .L_Z9trans_ldsPKfPfj.numbered_sgpr, 9
	.set .L_Z9trans_ldsPKfPfj.num_named_barrier, 0
	.set .L_Z9trans_ldsPKfPfj.private_seg_size, 0
	.set .L_Z9trans_ldsPKfPfj.uses_vcc, 1
	.set .L_Z9trans_ldsPKfPfj.uses_flat_scratch, 0
	.set .L_Z9trans_ldsPKfPfj.has_dyn_sized_stack, 0
	.set .L_Z9trans_ldsPKfPfj.has_recursion, 0
	.set .L_Z9trans_ldsPKfPfj.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 384
; TotalNumSgprs: 15
; NumVgprs: 9
; NumAgprs: 0
; TotalNumVgprs: 9
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 1024 bytes/workgroup (compile time only)
; SGPRBlocks: 1
; VGPRBlocks: 1
; NumSGPRsForWavesPerEU: 15
; NumVGPRsForWavesPerEU: 9
; AccumOffset: 12
; Occupancy: 8
; WaveLimiterHint : 0
; COMPUTE_PGM_RSRC2:SCRATCH_EN: 0
; COMPUTE_PGM_RSRC2:USER_SGPR: 2
; COMPUTE_PGM_RSRC2:TRAP_HANDLER: 0
; COMPUTE_PGM_RSRC2:TGID_X_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Y_EN: 0
; COMPUTE_PGM_RSRC2:TGID_Z_EN: 0
; COMPUTE_PGM_RSRC2:TIDIG_COMP_CNT: 0
; COMPUTE_PGM_RSRC3_GFX90A:ACCUM_OFFSET: 2
; COMPUTE_PGM_RSRC3_GFX90A:TG_SPLIT: 0
	.text
	.p2alignl 6, 3212836864
	.fill 256, 4, 3212836864
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
  - .agpr_count:     0
    .args:
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
    .sgpr_count:     15
    .sgpr_spill_count: 0
    .symbol:         _Z9trans_ldsPKfPfj.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     9
    .vgpr_spill_count: 0
    .wavefront_size: 64
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx950
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
