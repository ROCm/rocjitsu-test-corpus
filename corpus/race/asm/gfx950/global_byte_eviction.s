	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx950"
	.amdhsa_code_object_version 6
	.text
	.protected	_Z20global_byte_evictionPKhPi ; -- Begin function _Z20global_byte_evictionPKhPi
	.globl	_Z20global_byte_evictionPKhPi
	.p2align	8
	.type	_Z20global_byte_evictionPKhPi,@function
_Z20global_byte_evictionPKhPi:          ; @_Z20global_byte_evictionPKhPi
	.cfi_startproc
; %bb.0:
	.cfi_escape 0x0f, 0x04, 0x30, 0x36, 0xe9, 0x02 ; CFA is 0 in private_wave aspace
	.cfi_undefined 16
	s_load_dwordx4 s[4:7], s[0:1], 0x0
	s_cmp_gt_u32 s2, 6
	s_cbranch_scc0 .LBB0_4
; %bb.1:
	s_cmp_lt_i32 s2, 8
	s_mov_b64 s[0:1], 0
	s_cbranch_scc1 .LBB0_5
; %bb.2:
	s_cmp_eq_u32 s2, 8
	s_cbranch_scc0 .LBB0_6
; %bb.3:
	v_mov_b32_e32 v0, 0
	s_waitcnt lgkmcnt(0)
	global_load_ubyte v0, v0, s[4:5]
	;;#ASMSTART
	; evict
	;;#ASMEND
	s_mov_b64 s[8:9], 0
	s_branch .LBB0_7
.LBB0_4:
                                        ; implicit-def: $vgpr0
	s_cbranch_execnz .LBB0_13
	s_branch .LBB0_14
.LBB0_5:
                                        ; implicit-def: $vgpr0
	s_mov_b64 s[8:9], 0
	s_cbranch_execnz .LBB0_8
	s_branch .LBB0_9
.LBB0_6:
	s_mov_b64 s[8:9], -1
                                        ; implicit-def: $vgpr0
.LBB0_7:
	s_branch .LBB0_9
.LBB0_8:
	s_cmp_lg_u32 s2, 7
	s_mov_b64 s[0:1], -1
	s_cselect_b64 s[8:9], -1, 0
.LBB0_9:
	s_and_b64 s[8:9], s[8:9], exec
	s_cselect_b32 s3, 1, 0
	s_cmp_lg_u32 s3, 1
	s_cbranch_scc0 .LBB0_15
; %bb.10:
	s_and_b64 s[0:1], s[0:1], exec
	s_cselect_b32 s0, 1, 0
	s_cmp_lg_u32 s0, 1
	s_cbranch_scc1 .LBB0_12
.LBB0_11:
	s_waitcnt vmcnt(0)
	v_mov_b32_e32 v0, 0
	s_waitcnt lgkmcnt(0)
	global_load_ubyte v0, v0, s[4:5] offset:1
	;;#ASMSTART
	; retained
	;;#ASMEND
.LBB0_12:
	s_branch .LBB0_14
.LBB0_13:
	s_waitcnt vmcnt(0)
	v_mov_b32_e32 v0, 0
	s_waitcnt lgkmcnt(0)
	global_load_ubyte v0, v0, s[4:5]
	;;#ASMSTART
	; flood
	;;#ASMEND
.LBB0_14:
	s_mov_b32 s3, 0
	s_lshl_b64 s[0:1], s[2:3], 2
	s_waitcnt lgkmcnt(0)
	s_add_u32 s0, s6, s0
	s_waitcnt vmcnt(0)
	v_and_b32_e32 v0, 0xff, v0
	s_addc_u32 s1, s7, s1
	v_mov_b32_e32 v1, 0
	global_store_dword v1, v0, s[0:1]
	s_endpgm
.LBB0_15:
	s_waitcnt vmcnt(0)
	v_mov_b32_e32 v0, 0
	s_waitcnt lgkmcnt(0)
	global_load_ubyte v0, v0, s[4:5] offset:1
	;;#ASMSTART
	; probe
	;;#ASMEND
	s_mov_b64 s[0:1], 0
	s_and_b64 s[0:1], s[0:1], exec
	s_cselect_b32 s0, 1, 0
	s_cmp_lg_u32 s0, 1
	s_cbranch_scc0 .LBB0_11
	s_branch .LBB0_12
.Lfunc_end0:
	.size	_Z20global_byte_evictionPKhPi, .Lfunc_end0-_Z20global_byte_evictionPKhPi
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _Z20global_byte_evictionPKhPi
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
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 2
		.amdhsa_next_free_sgpr 10
		.amdhsa_accum_offset 4
		.amdhsa_reserve_vcc 0
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
	.set .L_Z20global_byte_evictionPKhPi.num_vgpr, 2
	.set .L_Z20global_byte_evictionPKhPi.num_agpr, 0
	.set .L_Z20global_byte_evictionPKhPi.numbered_sgpr, 10
	.set .L_Z20global_byte_evictionPKhPi.num_named_barrier, 0
	.set .L_Z20global_byte_evictionPKhPi.private_seg_size, 0
	.set .L_Z20global_byte_evictionPKhPi.uses_vcc, 0
	.set .L_Z20global_byte_evictionPKhPi.uses_flat_scratch, 0
	.set .L_Z20global_byte_evictionPKhPi.has_dyn_sized_stack, 0
	.set .L_Z20global_byte_evictionPKhPi.has_recursion, 0
	.set .L_Z20global_byte_evictionPKhPi.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 268
; TotalNumSgprs: 16
; NumVgprs: 2
; NumAgprs: 0
; TotalNumVgprs: 2
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 0 bytes/workgroup (compile time only)
; SGPRBlocks: 1
; VGPRBlocks: 0
; NumSGPRsForWavesPerEU: 16
; NumVGPRsForWavesPerEU: 2
; AccumOffset: 4
; Occupancy: 8
; WaveLimiterHint : 0
; COMPUTE_PGM_RSRC2:SCRATCH_EN: 0
; COMPUTE_PGM_RSRC2:USER_SGPR: 2
; COMPUTE_PGM_RSRC2:TRAP_HANDLER: 0
; COMPUTE_PGM_RSRC2:TGID_X_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Y_EN: 0
; COMPUTE_PGM_RSRC2:TGID_Z_EN: 0
; COMPUTE_PGM_RSRC2:TIDIG_COMP_CNT: 0
; COMPUTE_PGM_RSRC3_GFX90A:ACCUM_OFFSET: 0
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
    .gfx1250_revision: B0
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 16
    .language:       OpenCL C
    .language_version:
      - 2
      - 0
    .max_flat_workgroup_size: 1024
    .name:           _Z20global_byte_evictionPKhPi
    .private_segment_fixed_size: 0
    .sgpr_count:     16
    .sgpr_spill_count: 0
    .symbol:         _Z20global_byte_evictionPKhPi.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     2
    .vgpr_spill_count: 0
    .wavefront_size: 64
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx950
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
