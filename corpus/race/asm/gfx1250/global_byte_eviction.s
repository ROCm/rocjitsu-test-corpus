	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1250"
	.amdhsa_code_object_version 6
	.text
	.protected	_Z20global_byte_evictionPVKhPi ; -- Begin function _Z20global_byte_evictionPVKhPi
	.globl	_Z20global_byte_evictionPVKhPi
	.p2align	8
	.type	_Z20global_byte_evictionPVKhPi,@function
_Z20global_byte_evictionPVKhPi:         ; @_Z20global_byte_evictionPVKhPi
	.cfi_startproc
; %bb.0:
	s_mov_b64 s[64:65], 0
	v_nop
	global_prefetch_b8 v0, s[64:65] scope:SCOPE_SE
	.cfi_escape 0x0f, 0x04, 0x30, 0x36, 0xe9, 0x02 ; CFA is 0 in private_wave aspace
	.cfi_undefined 16
	s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1 ;  msbs: dst=0 src0=0 src1=0 src2=0
	s_load_b128 s[0:3], s[0:1], 0x0 nv
	s_bfe_u32 s4, ttmp6, 0x4000c
	s_and_b32 s5, ttmp6, 15
	s_add_co_i32 s4, s4, 1
	s_getreg_b32 s6, hwreg(HW_REG_IB_STS2, 6, 4)
	s_mul_i32 s4, ttmp9, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s5, s5, s4
	s_cmp_eq_u32 s6, 0
	s_mov_b32 s4, 0
	s_cselect_b32 s6, ttmp9, s5
	s_cmp_lt_u32 s6, 7
	s_cbranch_scc1 .LBB0_9
; %bb.1:
	s_cmp_lt_i32 s6, 8
	s_mov_b32 s5, -1
	s_cbranch_scc1 .LBB0_3
; %bb.2:
	s_cmp_lg_u32 s6, 8
	s_mov_b32 s5, 0
	s_cselect_b32 s4, -1, 0
.LBB0_3:
	s_and_b32 s5, s5, exec_lo
	s_cselect_b32 s5, 1, 0
	s_mov_b32 s7, 0
	s_cmp_lg_u32 s5, 1
	s_cbranch_scc1 .LBB0_5
; %bb.4:
	s_cmp_lg_u32 s6, 7
	s_mov_b32 s7, -1
	s_cselect_b32 s4, -1, 0
.LBB0_5:
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_and_b32 s4, s4, exec_lo
	s_cselect_b32 s4, 1, 0
	s_cmp_lg_u32 s4, 1
	s_wait_kmcnt 0x0
	s_add_nc_u64 s[4:5], s[0:1], 1
	s_cbranch_scc1 .LBB0_7
; %bb.6:
	s_add_nc_u64 s[0:1], s[0:1], 1
	s_mov_b32 s7, 0
.LBB0_7:
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_and_b32 s7, s7, exec_lo
	s_cselect_b32 s7, 1, 0
	s_cmp_lg_u32 s7, 1
	s_cbranch_scc1 .LBB0_9
; %bb.8:
	s_mov_b64 s[0:1], s[4:5]
.LBB0_9:
	v_dual_mov_b32 v0, 0 :: v_dual_mov_b32 v1, s6
	s_wait_kmcnt 0x0
	flat_load_u8 v0, v0, s[0:1] scope:SCOPE_SYS
	s_wait_loadcnt_dscnt 0x0
	global_store_b32 v1, v0, s[2:3] scale_offset
	s_endpgm
.Lfunc_end0:
	.size	_Z20global_byte_evictionPVKhPi, .Lfunc_end0-_Z20global_byte_evictionPVKhPi
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _Z20global_byte_evictionPVKhPi
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 16
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
		.amdhsa_next_free_vgpr 2
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
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-_Z20global_byte_evictionPVKhPi)<<4)&4080)>>4
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
	.set .L_Z20global_byte_evictionPVKhPi.num_vgpr, 2
	.set .L_Z20global_byte_evictionPVKhPi.num_agpr, 0
	.set .L_Z20global_byte_evictionPVKhPi.numbered_sgpr, 66
	.set .L_Z20global_byte_evictionPVKhPi.num_named_barrier, 0
	.set .L_Z20global_byte_evictionPVKhPi.private_seg_size, 0
	.set .L_Z20global_byte_evictionPVKhPi.uses_vcc, 0
	.set .L_Z20global_byte_evictionPVKhPi.uses_flat_scratch, 0
	.set .L_Z20global_byte_evictionPVKhPi.has_dyn_sized_stack, 0
	.set .L_Z20global_byte_evictionPVKhPi.has_recursion, 0
	.set .L_Z20global_byte_evictionPVKhPi.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 248
; TotalNumSgprs: 66
; NumVgprs: 2
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 0 bytes/workgroup (compile time only)
; SGPRBlocks: 0
; VGPRBlocks: 0
; NumSGPRsForWavesPerEU: 66
; NumVGPRsForWavesPerEU: 2
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
    .gfx1250_revision: B0
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 16
    .language:       OpenCL C
    .language_version:
      - 2
      - 0
    .max_flat_workgroup_size: 1024
    .name:           _Z20global_byte_evictionPVKhPi
    .private_segment_fixed_size: 0
    .sgpr_count:     66
    .sgpr_spill_count: 0
    .symbol:         _Z20global_byte_evictionPVKhPi.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     2
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1250
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
