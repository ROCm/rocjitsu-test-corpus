	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx950"
	.amdhsa_code_object_version 6
	.text
	.protected	_Z14scratch_accessPKiPij ; -- Begin function _Z14scratch_accessPKiPij
	.globl	_Z14scratch_accessPKiPij
	.p2align	8
	.type	_Z14scratch_accessPKiPij,@function
_Z14scratch_accessPKiPij:               ; @_Z14scratch_accessPKiPij
	.cfi_startproc
; %bb.0:
	.cfi_escape 0x0f, 0x04, 0x30, 0x36, 0xe9, 0x02 ; CFA is 0 in private_wave aspace
	.cfi_undefined 16
	s_load_dword s3, s[0:1], 0x24
	s_load_dword s4, s[0:1], 0x10
	s_waitcnt lgkmcnt(0)
	s_and_b32 s3, s3, 0xffff
	s_mul_i32 s2, s2, s3
	v_add_u32_e32 v0, s2, v0
	v_cmp_gt_u32_e32 vcc, s4, v0
	s_and_saveexec_b64 s[2:3], vcc
	s_cbranch_execz .LBB0_2
; %bb.1:
	s_load_dwordx4 s[0:3], s[0:1], 0x0
	v_mov_b32_e32 v1, 0
	v_lshlrev_b64 v[8:9], 2, v[0:1]
	s_waitcnt lgkmcnt(0)
	v_lshl_add_u64 v[0:1], s[0:1], 0, v[8:9]
	global_load_dword v0, v[0:1], off
	s_waitcnt vmcnt(0)
	v_add_u32_e32 v1, 1, v0
	v_add_u32_e32 v3, 3, v0
	v_add_u32_e32 v2, 2, v0
	v_add_u32_e32 v11, 5, v0
	v_add_u32_e32 v10, 4, v0
	v_add_u32_e32 v13, 7, v0
	v_add_u32_e32 v12, 6, v0
	v_add_u32_e32 v5, 9, v0
	v_add_u32_e32 v4, 8, v0
	v_add_u32_e32 v7, 11, v0
	v_add_u32_e32 v6, 10, v0
	v_add_u32_e32 v15, 13, v0
	v_add_u32_e32 v14, 12, v0
	v_add_u32_e32 v17, 15, v0
	v_add_u32_e32 v16, 14, v0
	v_add_u32_e32 v19, 17, v0
	v_add_u32_e32 v18, 16, v0
	v_add_u32_e32 v21, 19, v0
	v_add_u32_e32 v20, 18, v0
	v_add_u32_e32 v23, 21, v0
	v_add_u32_e32 v22, 20, v0
	v_add_u32_e32 v25, 23, v0
	v_add_u32_e32 v24, 22, v0
	v_add_u32_e32 v27, 25, v0
	v_add_u32_e32 v26, 24, v0
	v_add_u32_e32 v29, 27, v0
	v_add_u32_e32 v28, 26, v0
	v_add_u32_e32 v31, 29, v0
	v_add_u32_e32 v30, 28, v0
	v_add_u32_e32 v33, 31, v0
	v_add_u32_e32 v32, 30, v0
	v_add_u32_e32 v35, 33, v0
	v_add_u32_e32 v34, 32, v0
	v_add_u32_e32 v37, 35, v0
	v_add_u32_e32 v36, 34, v0
	v_add_u32_e32 v39, 37, v0
	v_add_u32_e32 v38, 36, v0
	v_add_u32_e32 v41, 39, v0
	v_add_u32_e32 v40, 38, v0
	v_add_u32_e32 v43, 41, v0
	v_add_u32_e32 v42, 40, v0
	v_add_u32_e32 v45, 43, v0
	v_add_u32_e32 v44, 42, v0
	v_add_u32_e32 v47, 45, v0
	v_add_u32_e32 v46, 44, v0
	v_add_u32_e32 v49, 47, v0
	v_add_u32_e32 v48, 46, v0
	v_add_u32_e32 v51, 49, v0
	v_add_u32_e32 v50, 48, v0
	v_add_u32_e32 v53, 51, v0
	v_add_u32_e32 v52, 50, v0
	v_add_u32_e32 v55, 53, v0
	v_add_u32_e32 v54, 52, v0
	v_add_u32_e32 v57, 55, v0
	v_add_u32_e32 v56, 54, v0
	scratch_store_dwordx4 off, v[10:13], off offset:16
	v_add_u32_e32 v59, 61, v0
	v_add_u32_e32 v58, 60, v0
	v_add_u32_e32 v11, 57, v0
	v_add_u32_e32 v10, 56, v0
	v_add_u32_e32 v13, 59, v0
	v_add_u32_e32 v12, 58, v0
	v_add_u32_e32 v61, 63, v0
	v_add_u32_e32 v60, 62, v0
	scratch_store_dwordx4 off, v[0:3], off
	scratch_store_dwordx4 off, v[4:7], off offset:32
	scratch_store_dwordx4 off, v[14:17], off offset:48
	scratch_store_dwordx4 off, v[18:21], off offset:64
	scratch_store_dwordx4 off, v[22:25], off offset:80
	scratch_store_dwordx4 off, v[26:29], off offset:96
	scratch_store_dwordx4 off, v[30:33], off offset:112
	scratch_store_dwordx4 off, v[34:37], off offset:128
	scratch_store_dwordx4 off, v[38:41], off offset:144
	scratch_store_dwordx4 off, v[42:45], off offset:160
	scratch_store_dwordx4 off, v[46:49], off offset:176
	scratch_store_dwordx4 off, v[50:53], off offset:192
	scratch_store_dwordx4 off, v[54:57], off offset:208
	scratch_store_dwordx4 off, v[10:13], off offset:224
	scratch_store_dwordx4 off, v[58:61], off offset:240
	v_and_b32_e32 v0, 63, v0
	v_lshlrev_b32_e32 v0, 2, v0
	scratch_load_dword v2, v0, off
	v_lshl_add_u64 v[0:1], s[2:3], 0, v[8:9]
	s_waitcnt vmcnt(0)
	global_store_dword v[0:1], v2, off
.LBB0_2:
	s_endpgm
.Lfunc_end0:
	.size	_Z14scratch_accessPKiPij, .Lfunc_end0-_Z14scratch_accessPKiPij
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _Z14scratch_accessPKiPij
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 272
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
		.amdhsa_enable_private_segment 1
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 62
		.amdhsa_next_free_sgpr 5
		.amdhsa_accum_offset 64
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
	.set .L_Z14scratch_accessPKiPij.num_vgpr, 62
	.set .L_Z14scratch_accessPKiPij.num_agpr, 0
	.set .L_Z14scratch_accessPKiPij.numbered_sgpr, 5
	.set .L_Z14scratch_accessPKiPij.num_named_barrier, 0
	.set .L_Z14scratch_accessPKiPij.private_seg_size, 272
	.set .L_Z14scratch_accessPKiPij.uses_vcc, 1
	.set .L_Z14scratch_accessPKiPij.uses_flat_scratch, 0
	.set .L_Z14scratch_accessPKiPij.has_dyn_sized_stack, 0
	.set .L_Z14scratch_accessPKiPij.has_recursion, 0
	.set .L_Z14scratch_accessPKiPij.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 512
; TotalNumSgprs: 11
; NumVgprs: 62
; NumAgprs: 0
; TotalNumVgprs: 62
; ScratchSize: 272
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 0 bytes/workgroup (compile time only)
; SGPRBlocks: 1
; VGPRBlocks: 7
; NumSGPRsForWavesPerEU: 11
; NumVGPRsForWavesPerEU: 62
; AccumOffset: 64
; Occupancy: 8
; WaveLimiterHint : 0
; COMPUTE_PGM_RSRC2:SCRATCH_EN: 1
; COMPUTE_PGM_RSRC2:USER_SGPR: 2
; COMPUTE_PGM_RSRC2:TRAP_HANDLER: 0
; COMPUTE_PGM_RSRC2:TGID_X_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Y_EN: 0
; COMPUTE_PGM_RSRC2:TGID_Z_EN: 0
; COMPUTE_PGM_RSRC2:TIDIG_COMP_CNT: 0
; COMPUTE_PGM_RSRC3_GFX90A:ACCUM_OFFSET: 15
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
      - .address_space:  global
        .offset:         0
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
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
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 280
    .language:       OpenCL C
    .language_version:
      - 2
      - 0
    .max_flat_workgroup_size: 1024
    .name:           _Z14scratch_accessPKiPij
    .private_segment_fixed_size: 272
    .sgpr_count:     11
    .sgpr_spill_count: 0
    .symbol:         _Z14scratch_accessPKiPij.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     62
    .vgpr_spill_count: 0
    .wavefront_size: 64
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx950
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
