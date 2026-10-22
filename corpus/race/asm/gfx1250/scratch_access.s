	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1250"
	.amdhsa_code_object_version 6
	.text
	.protected	_Z14scratch_accessPKiPij ; -- Begin function _Z14scratch_accessPKiPij
	.globl	_Z14scratch_accessPKiPij
	.p2align	8
	.type	_Z14scratch_accessPKiPij,@function
_Z14scratch_accessPKiPij:               ; @_Z14scratch_accessPKiPij
	.cfi_startproc
; %bb.0:
	s_mov_b64 s[64:65], 0
	v_nop
	global_prefetch_b8 v0, s[64:65] scope:SCOPE_SE
	.cfi_escape 0x0f, 0x04, 0x30, 0x36, 0xe9, 0x02 ; CFA is 0 in private_wave aspace
	.cfi_undefined 16
	s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1 ;  msbs: dst=0 src0=0 src1=0 src2=0
	s_clause 0x1
	s_load_b32 s2, s[0:1], 0x24 nv
	s_load_b32 s3, s[0:1], 0x10 nv
	s_bfe_u32 s4, ttmp6, 0x4000c
	s_and_b32 s5, ttmp6, 15
	s_add_co_i32 s4, s4, 1
	s_getreg_b32 s6, hwreg(HW_REG_IB_STS2, 6, 4)
	s_mul_i32 s4, ttmp9, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_4) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s5, s5, s4
	s_wait_kmcnt 0x0
	s_and_b32 s2, s2, 0xffff
	s_cmp_eq_u32 s6, 0
	s_cselect_b32 s4, ttmp9, s5
	v_mad_u32 v7, s4, s2, v0
	s_mov_b32 s2, exec_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_cmpx_gt_u32_e32 s3, v7
	s_cbranch_execz .LBB0_2
; %bb.1:
	s_load_b128 s[0:3], s[0:1], 0x0 nv
	s_wait_kmcnt 0x0
	global_load_b32 v4, v7, s[0:1] scale_offset
	s_wait_loadcnt 0x0
	v_dual_add_nc_u32 v6, 2, v4 :: v_dual_add_nc_u32 v5, 1, v4
	v_dual_add_nc_u32 v9, 4, v4 :: v_dual_add_nc_u32 v8, 3, v4
	v_dual_add_nc_u32 v11, 6, v4 :: v_dual_add_nc_u32 v10, 5, v4
	v_dual_add_nc_u32 v1, 8, v4 :: v_dual_add_nc_u32 v0, 7, v4
	v_dual_add_nc_u32 v3, 10, v4 :: v_dual_add_nc_u32 v2, 9, v4
	v_dual_add_nc_u32 v13, 12, v4 :: v_dual_add_nc_u32 v12, 11, v4
	v_dual_add_nc_u32 v15, 14, v4 :: v_dual_add_nc_u32 v14, 13, v4
	v_dual_add_nc_u32 v17, 16, v4 :: v_dual_add_nc_u32 v16, 15, v4
	v_dual_add_nc_u32 v19, 18, v4 :: v_dual_add_nc_u32 v18, 17, v4
	v_dual_add_nc_u32 v21, 20, v4 :: v_dual_add_nc_u32 v20, 19, v4
	v_dual_add_nc_u32 v23, 22, v4 :: v_dual_add_nc_u32 v22, 21, v4
	v_dual_add_nc_u32 v25, 24, v4 :: v_dual_add_nc_u32 v24, 23, v4
	v_dual_add_nc_u32 v27, 26, v4 :: v_dual_add_nc_u32 v26, 25, v4
	v_dual_add_nc_u32 v29, 28, v4 :: v_dual_add_nc_u32 v28, 27, v4
	v_dual_add_nc_u32 v31, 30, v4 :: v_dual_add_nc_u32 v30, 29, v4
	v_dual_add_nc_u32 v33, 32, v4 :: v_dual_add_nc_u32 v32, 31, v4
	v_dual_add_nc_u32 v35, 34, v4 :: v_dual_add_nc_u32 v34, 33, v4
	v_dual_add_nc_u32 v37, 36, v4 :: v_dual_add_nc_u32 v36, 35, v4
	v_dual_add_nc_u32 v39, 38, v4 :: v_dual_add_nc_u32 v38, 37, v4
	v_dual_add_nc_u32 v41, 40, v4 :: v_dual_add_nc_u32 v40, 39, v4
	v_dual_add_nc_u32 v43, 42, v4 :: v_dual_add_nc_u32 v42, 41, v4
	v_dual_add_nc_u32 v45, 44, v4 :: v_dual_add_nc_u32 v44, 43, v4
	v_dual_add_nc_u32 v47, 46, v4 :: v_dual_add_nc_u32 v46, 45, v4
	v_dual_add_nc_u32 v49, 48, v4 :: v_dual_add_nc_u32 v48, 47, v4
	v_dual_add_nc_u32 v51, 50, v4 :: v_dual_add_nc_u32 v50, 49, v4
	v_dual_add_nc_u32 v53, 52, v4 :: v_dual_add_nc_u32 v52, 51, v4
	v_dual_add_nc_u32 v55, 54, v4 :: v_dual_add_nc_u32 v54, 53, v4
	v_dual_add_nc_u32 v57, 56, v4 :: v_dual_add_nc_u32 v56, 55, v4
	v_dual_add_nc_u32 v59, 58, v4 :: v_dual_add_nc_u32 v58, 57, v4
	s_clause 0x1
	scratch_store_b96 off, v[4:6], off
	scratch_store_b128 off, v[8:11], off offset:12
	s_wait_xcnt 0x0
	v_dual_add_nc_u32 v9, 60, v4 :: v_dual_add_nc_u32 v8, 59, v4
	v_dual_add_nc_u32 v11, 62, v4 :: v_dual_add_nc_u32 v10, 61, v4
	v_dual_add_nc_u32 v5, 63, v4 :: v_dual_bitop2_b32 v4, 63, v4 bitop3:0x40
	s_clause 0xe
	scratch_store_b128 off, v[0:3], off offset:28
	scratch_store_b128 off, v[12:15], off offset:44
	scratch_store_b128 off, v[16:19], off offset:60
	scratch_store_b128 off, v[20:23], off offset:76
	scratch_store_b128 off, v[24:27], off offset:92
	scratch_store_b128 off, v[28:31], off offset:108
	scratch_store_b128 off, v[32:35], off offset:124
	scratch_store_b128 off, v[36:39], off offset:140
	scratch_store_b128 off, v[40:43], off offset:156
	scratch_store_b128 off, v[44:47], off offset:172
	scratch_store_b128 off, v[48:51], off offset:188
	scratch_store_b128 off, v[52:55], off offset:204
	scratch_store_b128 off, v[56:59], off offset:220
	scratch_store_b128 off, v[8:11], off offset:236
	scratch_store_b32 off, v5, off offset:252
	scratch_load_b32 v0, v4, off scale_offset
	s_wait_loadcnt 0x0
	global_store_b32 v7, v0, s[2:3] scale_offset
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
		.amdhsa_wavefront_size32 1
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 1
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 60
		.amdhsa_next_free_sgpr 66
		.amdhsa_named_barrier_count 0
		.amdhsa_reserve_vcc 0
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_fp16_overflow 0
		.amdhsa_memory_ordered 1
		.amdhsa_forward_progress 1
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-_Z14scratch_accessPKiPij)<<4)&4080)>>4
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
	.set .L_Z14scratch_accessPKiPij.num_vgpr, 60
	.set .L_Z14scratch_accessPKiPij.num_agpr, 0
	.set .L_Z14scratch_accessPKiPij.numbered_sgpr, 66
	.set .L_Z14scratch_accessPKiPij.num_named_barrier, 0
	.set .L_Z14scratch_accessPKiPij.private_seg_size, 272
	.set .L_Z14scratch_accessPKiPij.uses_vcc, 0
	.set .L_Z14scratch_accessPKiPij.uses_flat_scratch, 1
	.set .L_Z14scratch_accessPKiPij.has_dyn_sized_stack, 0
	.set .L_Z14scratch_accessPKiPij.has_recursion, 0
	.set .L_Z14scratch_accessPKiPij.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 784
; TotalNumSgprs: 66
; NumVgprs: 60
; ScratchSize: 272
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 0 bytes/workgroup (compile time only)
; SGPRBlocks: 0
; VGPRBlocks: 3
; NumSGPRsForWavesPerEU: 66
; NumVGPRsForWavesPerEU: 60
; NamedBarCnt: 0
; Occupancy: 16
; WaveLimiterHint : 0
; COMPUTE_PGM_RSRC2:SCRATCH_EN: 1
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
    .sgpr_count:     66
    .sgpr_spill_count: 0
    .symbol:         _Z14scratch_accessPKiPij.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     60
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1250
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
