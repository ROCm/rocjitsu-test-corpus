	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1250"
	.amdhsa_code_object_version 6
	.text
	.protected	_Z13collatz_stepsPKjPjm ; -- Begin function _Z13collatz_stepsPKjPjm
	.globl	_Z13collatz_stepsPKjPjm
	.p2align	8
	.type	_Z13collatz_stepsPKjPjm,@function
_Z13collatz_stepsPKjPjm:                ; @_Z13collatz_stepsPKjPjm
	.cfi_startproc
; %bb.0:
	s_mov_b64 s[64:65], 0
	v_nop
	global_prefetch_b8 v0, s[64:65] scope:SCOPE_SE
	.cfi_escape 0x0f, 0x04, 0x30, 0x36, 0xe9, 0x02 ; CFA is 0 in private_wave aspace
	.cfi_undefined 16
	s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1 ;  msbs: dst=0 src0=0 src1=0 src2=0
	s_clause 0x1
	s_load_b32 s4, s[0:1], 0x24 nv
	s_load_b64 s[2:3], s[0:1], 0x10 nv
	s_bfe_u32 s5, ttmp6, 0x4000c
	s_and_b32 s6, ttmp6, 15
	s_add_co_i32 s5, s5, 1
	s_getreg_b32 s7, hwreg(HW_REG_IB_STS2, 6, 4)
	s_mul_i32 s5, ttmp9, s5
	v_mov_b32_e32 v3, 0
	s_add_co_i32 s6, s6, s5
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_4) | instid1(SALU_CYCLE_1)
	v_mov_b32_e32 v1, v3
	s_wait_kmcnt 0x0
	s_and_b32 s4, s4, 0xffff
	s_cmp_eq_u32 s7, 0
	s_cselect_b32 s5, ttmp9, s6
	v_mad_u32 v0, s5, s4, v0
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_gt_u64_e32 vcc_lo, s[2:3], v[0:1]
	s_and_saveexec_b32 s2, vcc_lo
	s_cbranch_execz .LBB0_10
; %bb.1:
	s_load_b128 s[0:3], s[0:1], 0x0 nv
	s_wait_kmcnt 0x0
	v_lshl_add_u64 v[4:5], v[0:1], 2, s[0:1]
	s_mov_b32 s0, exec_lo
	global_load_b32 v2, v[4:5], off
	s_wait_loadcnt 0x0
	v_cmpx_ne_u32_e32 1, v2
	s_cbranch_execz .LBB0_9
; %bb.2:
	s_mov_b32 s5, 0
	s_mov_b32 s1, 0
                                        ; implicit-def: $sgpr4
	s_branch .LBB0_4
.LBB0_3:                                ;   in Loop: Header=BB0_4 Depth=1
	s_or_b32 exec_lo, exec_lo, s6
	s_add_co_i32 s6, s5, 1
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)
	v_cmp_eq_u32_e32 vcc_lo, 1, v2
	s_cmp_gt_u32 s5, 0xfffe
	v_mov_b32_e32 v3, s6
	s_cselect_b32 s5, -1, 0
	s_or_b32 s5, vcc_lo, s5
	v_cmp_ne_u32_e32 vcc_lo, 1, v2
	s_and_b32 s5, exec_lo, s5
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_or_b32 s1, s5, s1
	s_and_not1_b32 s4, s4, exec_lo
	s_and_b32 s5, vcc_lo, exec_lo
	s_or_b32 s4, s4, s5
	s_mov_b32 s5, s6
	s_and_not1_b32 exec_lo, exec_lo, s1
	s_cbranch_execz .LBB0_8
.LBB0_4:                                ; =>This Inner Loop Header: Depth=1
	v_and_b32_e32 v3, 1, v2
	s_mov_b32 s6, exec_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_cmpx_eq_u32_e32 1, v3
	s_xor_b32 s6, exec_lo, s6
; %bb.5:                                ;   in Loop: Header=BB0_4 Depth=1
	v_mad_u32 v2, v2, 3, 1
; %bb.6:                                ;   in Loop: Header=BB0_4 Depth=1
	s_and_not1_saveexec_b32 s6, s6
	s_cbranch_execz .LBB0_3
; %bb.7:                                ;   in Loop: Header=BB0_4 Depth=1
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v2, 1, v2
	s_branch .LBB0_3
.LBB0_8:
	s_or_b32 exec_lo, exec_lo, s1
	v_cndmask_b32_e64 v3, v3, 0x10001, s4
.LBB0_9:
	s_or_b32 exec_lo, exec_lo, s0
	v_lshl_add_u64 v[0:1], v[0:1], 2, s[2:3]
	global_store_b32 v[0:1], v3, off
.LBB0_10:
	s_endpgm
.Lfunc_end0:
	.size	_Z13collatz_stepsPKjPjm, .Lfunc_end0-_Z13collatz_stepsPKjPjm
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _Z13collatz_stepsPKjPjm
		.amdhsa_group_segment_fixed_size 0
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
		.amdhsa_next_free_vgpr 6
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
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-_Z13collatz_stepsPKjPjm)<<4)&4080)>>4
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
	.set .L_Z13collatz_stepsPKjPjm.num_vgpr, 6
	.set .L_Z13collatz_stepsPKjPjm.num_agpr, 0
	.set .L_Z13collatz_stepsPKjPjm.numbered_sgpr, 66
	.set .L_Z13collatz_stepsPKjPjm.num_named_barrier, 0
	.set .L_Z13collatz_stepsPKjPjm.private_seg_size, 0
	.set .L_Z13collatz_stepsPKjPjm.uses_vcc, 1
	.set .L_Z13collatz_stepsPKjPjm.uses_flat_scratch, 0
	.set .L_Z13collatz_stepsPKjPjm.has_dyn_sized_stack, 0
	.set .L_Z13collatz_stepsPKjPjm.has_recursion, 0
	.set .L_Z13collatz_stepsPKjPjm.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 360
; TotalNumSgprs: 68
; NumVgprs: 6
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 0 bytes/workgroup (compile time only)
; SGPRBlocks: 0
; VGPRBlocks: 0
; NumSGPRsForWavesPerEU: 68
; NumVGPRsForWavesPerEU: 6
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
      - .address_space:  global
        .offset:         0
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         8
        .size:           8
        .value_kind:     global_buffer
      - .offset:         16
        .size:           8
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
    .name:           _Z13collatz_stepsPKjPjm
    .private_segment_fixed_size: 0
    .sgpr_count:     68
    .sgpr_spill_count: 0
    .symbol:         _Z13collatz_stepsPKjPjm.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     6
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1250
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
