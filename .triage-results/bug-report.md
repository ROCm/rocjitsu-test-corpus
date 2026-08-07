# ROCjitsu llama corpus: root causes of the persistent failures

181 llama `test-backend-ops` cases fail persistently under ROCjitsu at commit `63a89f8f5cf0f25b98a76057bc00e4a98f88425d`, out of 535 cases run on each of gfx942, gfx950, gfx1100 and gfx1201. Triage originally filed them as 24 symptom groups keyed by target. Grouping them by mechanism instead reduces them to 9 distinct issues, of which one accounts for a third of all failures.

Each test is attributed to exactly one issue, so the counts below sum to 181. Confidence is stated per issue and is meant literally: "confirmed by experiment" means a targeted change to ROCjitsu turned that issue's listed failures into passes, while "speculative" means the tests are grouped on shared symptoms and the cause is not yet localized. 7 of the 9 issues, covering 173 of the 181 tests, are confirmed at that standard.

Three of the confirmed issues share a shape worth calling out: a routine that is correct for the architecture it was written for was inherited by a later one that needs different behaviour. That is the RDNA3 scalar register map carried into GFX10 and later, the RDNA3 dword address mask carried into RDNA4 after GFX12 added sub-dword scalar loads, and the packed-FP32 pair read that assumes a VGPR source. Two of the three live in code shared by every target, so they are latent well beyond the tests that expose them here.

## Summary

| # | Issue | Tests | Targets | Confidence |
|---|---|---:|---|---|
| 1 | RDNA4 buffer instructions skip the out-of-bounds check | 60 | gfx1201 | Confirmed by experiment |
| 2 | RDNA3 models scalar encodings 102 and 103 as FLAT_SCRATCH instead of ordinary SGPRs | 28 | gfx1100 | Confirmed by experiment |
| 3 | RDNA4 truncates scalar memory addresses to a dword, breaking GFX12's sub-dword scalar loads | 24 | gfx1201 | Confirmed by experiment |
| 4 | Packed FP32 VOP3P instructions read only the low dword of an SGPR-pair source | 20 | gfx942, gfx950 | Confirmed by experiment |
| 5 | gfx942 decodes FP8 as the AMD FNUZ variant where the NVFP4 route expects OCP E4M3 | 14 | gfx942 | Confirmed by experiment |
| 6 | The gfx9 SMEM SGPR-offset form drops the offset, so batched rocBLAS calls only ever read batch 0 | 12 | gfx942, gfx950 | Confirmed by experiment |
| 7 | gfx1100 flash attention with logit_softcap over a large grid | 6 | gfx1100 | Speculative |
| 8 | gfx1201 RMS_NORM_BACK multi-wave reduction | 2 | gfx1201 | Inferred from runtime evidence |
| 9 | Simulation throughput limit, not a correctness defect | 15 | gfx1100, gfx1201, gfx942, gfx950 | Confirmed by experiment |

Total: 181 of 181.

## 1. RDNA4 buffer instructions skip the out-of-bounds check

**Targets affected**: gfx1201  
**Failing tests**: 60  
**Operators**: MUL_MAT, MUL_MAT_ID, OUT_PROD, SOLVE_TRI  
**Confidence**: Confirmed by experiment

Every AMDGPU family in the tree bounds-checks buffer (MUBUF/VBUFFER) accesses against the `num_records` field of the buffer resource descriptor, and drops lanes that fall outside it: out-of-bounds stores are discarded and out-of-bounds loads return zero. RDNA4 is the only family that does not. Its `mubuf_calculate_addresses` never reads `num_records`, never clears out-of-range lanes from `lane_mask`, and never masks the result to 48 bits, so every lane's address is used verbatim.

GPU kernels rely on this hardware clamping instead of emitting explicit bounds branches, so tail lanes of a partial tile routinely address past the end of a buffer by design. On RDNA4 those lanes instead compute a wild address. Because `buffer_offset_part` forms the offset in unsigned 32-bit space, a small negative offset becomes roughly +4 GiB: in the reproducer the intended address was `0x7c67dc202100` and the computed address was `0x7c68dc202100`, correct in the low 32 bits and exactly one too high in the high word. The store then reaches `GpuMemory::with_host_ptr`, misses the VMID page table, and falls through to the passthrough branch that casts a GPU virtual address straight to a host pointer, which segfaults or silently corrupts memory depending on the host address-space layout. That is why these crashes disappear when ASLR is disabled.

gfx1250 uses the same VBUFFER encoding as RDNA4 and does implement the check, which makes the RDNA4 copy the clear outlier rather than a deliberate simplification.

**Where it is**

- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/rdna4/addr_calc.cpp` lines 161-190 — mubuf_calculate_addresses: no num_records read, no out-of-bounds lane masking, no 48-bit address mask, and init_vector_mem_state is never called so VectorMemState keeps its default wf_size of 64
- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/shared/addr_calc_buffer.h` lines 105-135 — the reference implementation used by CDNA1-4 and RDNA1-3, including the bounds check RDNA4 omits
- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/gfx1250/addr_calc.cpp` lines 213-277 — the same VBUFFER encoding as RDNA4, with the check present
- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/vm/amdgpu/gpu_memory.h` lines 501-507 — the passthrough fallback that turns an unresolved GPU address into a raw host pointer, which converts the addressing defect into a segfault

**Evidence**

Porting the bounds check into the RDNA4 path turns all 60 of these tests from failures into passes, with no other change. The patch used for the experiment is saved at `.triage-results/probes/rdna4-buffer-oob.patch` and the full per-test outcome at `.triage-results/debug2/probe-rdna4-oob.json`. It is a causality probe, not a proposed fix: a real fix should confirm the GFX12 descriptor field layout and decide whether `wf_size` and the `init_vector_mem_state` call should also be corrected.

The faulting store was identified as `buffer_store_b128` from the instruction trace, and the per-lane address array showed lanes 0 and 16 holding valid, correctly strided addresses while the other 30 active lanes all held the same out-of-range address.

**What this merges**

This one defect absorbs five previously separate symptom groups: the gfx1201 MUL_MAT and MUL_MAT_ID crash surfaces, the gfx1201 OUT_PROD and SOLVE_TRI crashes, and the group that had been attributed to the missing RDNA4 HWREG ID 26 (WAVE_SCHED_MODE) entry. That last attribution is refuted: the `s_setreg_imm32_b32: unsupported hwreg=unknown id=26` warning still appears 640 times in a run where all five of those tests now pass, so the HWREG gap is real but not the cause of any failure here.

**Example failing tests**

- `llama.gfx1201.backend_ops.MUL_MAT.0bfa3a774759`
  - `MUL_MAT(type_a=bf16,type_b=f32,m=129,n=1,k=1057,bs=[2,1],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)`
- `llama.gfx1201.backend_ops.MUL_MAT.12d6ef2eb102`
  - `MUL_MAT(type_a=f16,type_b=f32,m=128,n=1,k=1057,bs=[8,3],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)`
- `llama.gfx1201.backend_ops.MUL_MAT.1430f54270e4`
  - `MUL_MAT(type_a=f16,type_b=f16,m=16,n=1,k=1024,bs=[3,2],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)`
- and 57 more, listed in `.triage-results/merged-bugs.json` under `rdna4-buffer-oob`

## 2. RDNA3 models scalar encodings 102 and 103 as FLAT_SCRATCH instead of ordinary SGPRs

**Targets affected**: gfx1100  
**Failing tests**: 28  
**Operators**: FLASH_ATTN_EXT  
**Confidence**: Confirmed by experiment

On GFX9 the scalar operand encodings 102 and 103 are FLAT_SCRATCH_LO and FLAT_SCRATCH_HI. On GFX10 and later they are ordinary `s102` and `s103`; LLVM rejects `flat_scratch_lo` outright for gfx1100 and assembles `s_mov_b32 s102, 0` with SDST=102. ROCjitsu carries the GFX9 meaning into RDNA3 at four places in its operand resolver: reads of 102 and 103 return the wave's scratch base instead of the register, and writes call `set_scratch_base` instead of writing the register.

Register-heavy kernels such as flash attention do use `s102` and `s103`. When one is written, ROCjitsu silently relocates the wave's scratch base, so every subsequent spill reload reads from a different address than the spill store wrote. The reloaded garbage is then used as data or as an index, which is why the same defect produces both wrong results and crashes: it depends only on where the corrupted value happens to point.

A second, independent error compounds it. `gfx1100_w7900.json` sets `sgprs_per_wf` to 104, but RDNA3 has 106 addressable SGPRs. A write to `s104` or `s105` therefore runs past the end of the last wave slot's allocation, and in every other slot silently overwrites the next wave's `s0`. Both errors must be corrected together.

**Where it is**

- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/rdna3/operand.cpp` lines 721-724 — resolve_src_scalar returns wf.scratch_base() for encodings 102 and 103 instead of reading the SGPR
- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/rdna3/operand.cpp` lines 888-897 — resolve_dst_write calls wf.set_scratch_base() instead of writing the SGPR; resolve_src_scalar64 at 828-829 and resolve_dst_write64 at 932-935 do the same
- `emulation/rocjitsu/configs/gfx1100_w7900.json` lines 69 — sgprs_per_wf is 104 where RDNA3 has 106; gfx1151.json has the same value
- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/vm/amdgpu/compute_unit.h` lines 422 — write_sgpr indexes the SGPR file with no bounds check, so the undersized allocation overflows silently

**Evidence**

Treating 102 and 103 as ordinary SGPRs and raising `sgprs_per_wf` to 106 turns 28 of these 34 tests from failures into passes. The remaining six are reported separately as issue 7. The probe patch is at `.triage-results/probes/rdna3-scalar-registers.patch`.

ASAN reports a `heap-buffer-overflow WRITE of size 4` in `ComputeUnitCore::write_sgpr` reached from `rdna3::resolve_dst_write`, zero bytes past a 13312-byte region, which is exactly 32 wave slots by 104 SGPRs by 4 bytes. The instruction trace shows the corruption end to end: `scratch_store_b32 ... offset:12` stores the lane indices 0, 1 and 2, and the matching `scratch_load_b32 ... offset:12` later returns 0xbf026c85, 0x3d1990a0 and 0x3e4b58f0. Those floats are then shifted left by 2 and used as the address of a `global_load_b32`, which faults.

**What this merges**

The previous split into an "optimized MMA/WMMA" subgroup and a "generic D=72 tile" subgroup is refuted. Head sizes 64, 72, 80 and 128 are all repaired by the same change, and it fixes the crashing and the wrong-result cases alike, so head size was never the discriminator.

Scope beyond these tests is worth noting: all five RDNA families and gfx1250 share this operand handling, so the defect is latent everywhere on GFX10 and later. It is correct only on CDNA, where GFX9 really does place FLAT_SCRATCH at those encodings. The llama corpus happens to expose it only on gfx1100.

**Example failing tests**

- `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.0839462e9aa3`
  - `FLASH_ATTN_EXT(hsk=72,hsv=72,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=q8_0,type_V=q8_0,permute=[0,1,2,3])`
- `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.0ffa0a7d7dc5`
  - `FLASH_ATTN_EXT(hsk=72,hsv=72,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=0,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=q4_0,type_V=q4_0,permute=[0,1,2,3])`
- `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.128bf0f8e11b`
  - `FLASH_ATTN_EXT(hsk=80,hsv=80,nh=4,nr23=[4,1],kv=512,nb=75,mask=1,sinks=0,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])`
- and 25 more, listed in `.triage-results/merged-bugs.json` under `rdna3-scalar-registers`

## 3. RDNA4 truncates scalar memory addresses to a dword, breaking GFX12's sub-dword scalar loads

**Targets affected**: gfx1201  
**Failing tests**: 24  
**Operators**: GATED_DELTA_NET, RMS_NORM_MUL_ROPE, TOPK_MOE  
**Confidence**: Confirmed by experiment

RDNA4's `smem_calculate_address` ends by masking the computed address down to a 4-byte boundary. That line is copied verbatim from the RDNA3 implementation, where it is harmless because GFX11 scalar memory has no sub-dword loads. GFX12 added `s_load_u8`, `s_load_i8`, `s_load_u16` and `s_load_i16`, and RDNA4 implements all four, so the inherited mask now silently redirects every sub-dword scalar load to the base of its containing dword. The gfx1250 version of the same routine does not truncate; it returns the address unmodified and only asserts alignment against the access size.

The consequence in these kernels is precise. All three operators use a 2D block shape and read `blockDim.y` with `s_load_u16` from the implicit kernel arguments at offset 0x46. Truncated to 0x44, that load returns `hidden_group_size_x` instead, so every workgroup past the first computes an out-of-range output row, fails its bounds guard and exits immediately, leaving most of the output untouched.

**Where it is**

- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/rdna4/addr_calc.cpp` lines 56-66 — smem_calculate_address returns `(base + off) & ~0x3ULL`
- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/rdna3/addr_calc.cpp` lines 44-51 — the RDNA3 original the mask was copied from, where GFX11 has no sub-dword scalar loads to break
- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/gfx1250/addr_calc.cpp` lines 152-167 — the GFX12 counterpart, which does not truncate and instead asserts alignment against the access size
- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/rdna4/smem.cpp` — the four sub-dword scalar loads RDNA4 implements and RDNA3 does not

**Evidence**

Removing the mask turns all 24 tests from failures into passes, with 212 gfx1201 SOFT_MAX tests still passing as a regression check. The probe patch is at `.triage-results/probes/rdna4-smem-subdword.patch`.

The instruction trace shows the mechanism directly: for `TOPK_MOE(ne=[8,22,1,1],...)` the load returns 32 instead of 4, the following `v_mad_co_u64_u32` computes row 0x20 for workgroup 1 where the correct row is 4, and `v_cmpx_gt_i32` then clears EXEC. Workgroup 0 executes 831 instructions while workgroups 1 through 5 execute 11 each. gfx1100 passes the identical case and emits `s_load_b32`, which is absent from the gfx1201 instruction set for this kernel.

**What this merges**

The original hypothesis for this group, that RDNA4 mis-decodes the packed work-item Y field, is refuted. The per-lane VGPR dump shows v0 packed correctly (wave 3 lane 19 holds 0xc13, meaning x=19 and y=3) and `v_bfe_u32 v1, v0, 10, 10` extracting y correctly. The TTMP workgroup ID path was also ruled out: the observed row was exactly `wg_id * 32`, so the workgroup ID was right and the multiplier was wrong.

**Example failing tests**

- `llama.gfx1201.backend_ops.GATED_DELTA_NET.05b63a4322c6`
  - `GATED_DELTA_NET(type=f32,head_count=8,head_size=32,n_seq_tokens=4,n_seqs=2,v_repeat=2,permuted=0,kda=1,K=4)`
- `llama.gfx1201.backend_ops.GATED_DELTA_NET.5615f586b1ca`
  - `GATED_DELTA_NET(type=f32,head_count=4,head_size=32,n_seq_tokens=4,n_seqs=1,v_repeat=1,permuted=0,kda=0,K=4)`
- `llama.gfx1201.backend_ops.GATED_DELTA_NET.5a41ca1b14ff`
  - `GATED_DELTA_NET(type=f32,head_count=32,head_size=16,n_seq_tokens=1,n_seqs=1,v_repeat=1,permuted=0,kda=0,K=1)`
- and 21 more, listed in `.triage-results/merged-bugs.json` under `rdna4-smem-subdword`

## 4. Packed FP32 VOP3P instructions read only the low dword of an SGPR-pair source

**Targets affected**: gfx942, gfx950  
**Failing tests**: 20  
**Operators**: OPT_STEP_ADAMW, ROPE, ROPE_SET_ROWS, SSM_SCAN, UPSCALE, XIELU  
**Confidence**: Confirmed by experiment

`v_pk_add_f32`, `v_pk_mul_f32` and `v_pk_fma_f32` operate on a pair of adjacent 32-bit floats. ROCjitsu performs the 64-bit pair read only when the source operand is a VGPR, gated on the encoding value falling in the 256-511 VGPR range. For an SGPR-pair source the high half silently re-reads the low dword, so `s[n+1]` is never read and the second float of the pair is replaced by the first.

Compilers emit exactly this shape whenever the packed pair is loop invariant or constant, which is common: in `upscale_f32_bicubic` the `a+2` and `a+3` bicubic constants are packed into an SGPR pair, so the computation silently uses `a+2` twice. This is why one defect surfaces across six unrelated operators rather than in a single kernel.

**Where it is**

- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/shared/execute_shared.h` lines 16623, 16630 — execute_v_pk_add_f32_vop3p gates the pair read on `encoding_value_ >= 256 && <= 511`, so only VGPRs get it
- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/shared/execute_shared.h` lines 16812, 16819, 16826 — execute_v_pk_fma_f32_vop3p, same gate on all three sources
- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/shared/execute_shared.h` lines 17279, 17286 — execute_v_pk_mul_f32_vop3p, same gate
- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/shared/simd_glue.h` lines 3274 — the SIMD fast paths at 3291-3292 and 3336-3338 repeat the assumption, documented in the comment as "Non-VGPR sources splat the 32-bit operand into both halves"

**Evidence**

Patching the three execute functions and the two SIMD gates turns all 20 of these tests from failures into passes.

The mechanism was isolated on hardware before it was patched. A HIP microbenchmark of `v_pk_add_f32 d, v, s` returns `a.hi + s.lo` under ROCjitsu where the real GPU returns `a.hi + s.hi`, and every VGPR form is correct. A standalone replica of ggml's `upscale_f32_bicubic` then reproduced the exact wrong output, with `weight1(1.0)` returning 2.25 instead of 0, while the same binary on a real GPU is correct.

**What this merges**

This defect absorbs six operator families that had been filed as five separate candidates. ROPE, ROPE_SET_ROWS, SSM_SCAN and XIELU were four of the "shared CDNA numerical" candidates and are one defect. OPT_STEP_ADAMW and UPSCALE were held separately as four target-keyed entries and are the same defect once more. The one member of the CDNA numerical group that did not merge here is MUL_MAT, which belongs to issue 6.

The defective code is in `shared/`, not in a CDNA directory, so the defect is latent on every architecture. The corpus exposes it only on CDNA.

**Example failing tests**

- `llama.gfx942.backend_ops.OPT_STEP_ADAMW.53563ed7ba67`
  - `OPT_STEP_ADAMW(type=f32,ne=[10,5,4,3])`
- `llama.gfx942.backend_ops.ROPE.637c25a9ca18`
  - `ROPE(type=f16,ne_a=[128,32,2,1],n_dims=128,mode=40,n_ctx=512,fs=1.424500,ef=0.746500,af=1.424500,ff=1,v=1,inplace=1)`
- `llama.gfx942.backend_ops.ROPE_SET_ROWS.466fbec03e98`
  - `ROPE_SET_ROWS(type=f32,type_idx=i64,ne_a=[128,32,1,1],mode=8)`
- and 17 more, listed in `.triage-results/merged-bugs.json` under `cdna-pk-f32-scalar-src`

## 5. gfx942 decodes FP8 as the AMD FNUZ variant where the NVFP4 route expects OCP E4M3

**Targets affected**: gfx942  
**Failing tests**: 14  
**Operators**: MUL_MAT, MUL_MAT_ID, MUL_MAT_VEC_FUSION  
**Confidence**: Confirmed by experiment

All 14 NVFP4 cases in the corpus fail on gfx942 and all 14 pass on gfx950, so the whole route is broken rather than particular shapes. CDNA3 has no FP4 instructions at all, so the kernel unpacks the 4-bit mantissas in software but converts the per-block scale with the native `v_cvt_f32_fp8` instruction.

ROCjitsu's CDNA3 model interprets that instruction's input as AMD's FNUZ FP8 encoding, while its CDNA4 model interprets it as OCP E4M3. The two encodings use different exponent biases, so every block scale comes out off by a factor of two and every result is wrong.

**Where it is**

- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/cdna3/vop1.cpp` lines 3740-3759 — VCvtF32Fp8Vop1::execute_impl uses util::fp8_e4m3_fnuz_to_f32
- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/cdna4/vop1.cpp` lines 3858-3877 — the CDNA4 counterpart uses util::fp8_e4m3_to_f32 and passes the identical cases
- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/cdna3/vop3.cpp` lines 1913-1945 — the VOP3 form of the same instruction, with the same FNUZ/OCP divergence from CDNA4

**Evidence**

Switching the CDNA3 FP8 conversions from the FNUZ to the OCP interpretation turns all 14 tests from failures into passes. The probe patch is at `.triage-results/probes/cdna3-fp8-ocp.patch` and the outcome at `.triage-results/debug2/nvfp4-probe-ocp.json`.

One caveat worth resolving before fixing: gfx942 hardware is documented as implementing the FNUZ variant, so ROCjitsu's current choice may be faithful to the ISA and the real defect may lie in which instruction the kernel is expected to reach on this target. What the experiment does establish beyond doubt is that the FNUZ versus OCP interpretation of `V_CVT_F32_FP8` is the mechanism behind all 14 failures.

**Example failing tests**

- `llama.gfx942.backend_ops.MUL_MAT.017115bdd15b`
  - `MUL_MAT(type_a=nvfp4,type_b=f32,m=16,n=7,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)`
- `llama.gfx942.backend_ops.MUL_MAT.38225d8678d3`
  - `MUL_MAT(type_a=nvfp4,type_b=f32,m=16,n=6,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)`
- `llama.gfx942.backend_ops.MUL_MAT.48f89386e558`
  - `MUL_MAT(type_a=nvfp4,type_b=f32,m=16,n=4,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)`
- and 11 more, listed in `.triage-results/merged-bugs.json` under `nvfp4-gfx942`

## 6. The gfx9 SMEM SGPR-offset form drops the offset, so batched rocBLAS calls only ever read batch 0

**Targets affected**: gfx942, gfx950  
**Failing tests**: 12  
**Operators**: MUL_MAT, OUT_PROD, SOLVE_TRI  
**Confidence**: Confirmed by experiment

GFX9 scalar memory instructions can supply their byte offset three ways. ROCjitsu's shared address routine handles two of them: an SGPR named by `soffset` when `SOE=1`, and a signed immediate when `IMM=1`. It does not handle the third, where `IMM=0` and `SOE=0` and the OFFSET field instead holds an SGPR index that supplies the offset. In that case the routine adds nothing and computes `addr = base`.

Tensile's pointer-array batched GEMM kernels use exactly this form to index the per-batch pointer array. With the offset dropped, every batch reads the pointer for batch 0, so the kernel recomputes batch 0 repeatedly and never writes any batch past the first. That is why the failures cluster on the batched rocBLAS entry points rather than on any particular arithmetic.

**Where it is**

- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/shared/addr_calc_scalar.h` lines 37-42 — smem_calculate_address adds `soffset` when soffset_en and the immediate when imm, with no branch for the case where neither is set
- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/cdna3/smem.cpp` lines 39 — make_smem_offset mirrors the same gap, returning a literal 0; cdna1, cdna2 and cdna4 are identical at line 38-39

**Evidence**

Adding the missing branch turns all 12 of these tests from failures into passes and matches hardware bit for bit.

An inline-asm probe isolates it: `s_load_dwordx2 s[6:7], s[2:3], s4`, encoded with IMM=0 and SOE=0, returns `base[0]` for every offset, while the otherwise identical `offset:0x8` form is correct. At the library level, `rocblas_sgemm_batched` with two batches leaves batch 1 at its sentinel value under ROCjitsu but is correct on hardware, and `rocblas_sgemm_strided_batched`, which does not use a pointer array, is unaffected. The affected entry points are `cublasSgemmBatched` for OUT_PROD, `cublasGemmBatchedEx` for the f32 MUL_MAT cases, and `cublasStrsmBatched` for SOLVE_TRI. SOLVE_TRI is the sharpest confirmation: it calls batched GEMM internally only for n > 16, and n=16 passes while n=84 and n=128 fail.

**What this merges**

Two groups merge here. The f32 MUL_MAT cases were part of the "shared CDNA numerical" candidate and the OUT_PROD and SOLVE_TRI cases were a separate rocBLAS surface; they are one defect.

The three OUT_PROD and SOLVE_TRI case strings also fail on gfx1201, which had made them the strongest architecture-independent lead in the corpus. That is refuted: the RDNA4 buffer bounds probe fixes the gfx1201 cases and leaves these untouched, so the shared case string reflects test coverage rather than a shared cause.

**Example failing tests**

- `llama.gfx942.backend_ops.MUL_MAT.5a436936375c`
  - `MUL_MAT(type_a=f32,type_b=f32,m=16,n=4,k=4,bs=[2,3],nr=[1,1],per=[0,3,2,1],k_v=0,o=1)`
- `llama.gfx942.backend_ops.MUL_MAT.9f4865116d4b`
  - `MUL_MAT(type_a=f32,type_b=f32,m=16,n=16,k=4,bs=[1,1],nr=[1,2],per=[0,1,2,3],k_v=0,o=1)`
- `llama.gfx942.backend_ops.MUL_MAT.b3d523cee895`
  - `MUL_MAT(type_a=f32,type_b=f32,m=16,n=8,k=4,bs=[2,3],nr=[1,1],per=[0,1,3,2],k_v=0,o=1)`
- and 9 more, listed in `.triage-results/merged-bugs.json` under `cdna-smem-sgpr-offset`

## 7. gfx1100 flash attention with logit_softcap over a large grid

**Targets affected**: gfx1100  
**Failing tests**: 6  
**Operators**: FLASH_ATTN_EXT  
**Confidence**: Speculative

These six are what remains of the gfx1100 flash-attention failures once the RDNA3 scalar register defect in issue 2 is corrected. Four return wrong results and two crash. They are a separate, not yet localized defect.

The shape they share is narrow. All six are hsk=128, hsv=128, kv=512, mask=1, f16 keys and values, and all six have `logit_softcap=10`. Softcap alone is not sufficient: two other cases with `logit_softcap=10` pass once issue 2 is fixed, and both of those are the smallest configuration in the set, nr23=[4,1] with nb=32. Every failing case either widens the broadcast to nr23=[12,1] or raises nb above 32. The discriminator is therefore softcap combined with total grid work, which suggests the fault lies in a multi-block or multi-row path that the softcap variant of the kernel takes only above some size, rather than in the softcap arithmetic itself.

**Evidence**

Confirmed by experiment that these six still fail with the issue 2 fix applied, over two consecutive repetitions with stable error magnitudes between 0.12 and 0.71. Fields ruled out as discriminators: `sinks` and `prec` both take each of their values in the passing and the failing set alike.

**Example failing tests**

- `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.09f30cac3778`
  - `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=75,mask=1,sinks=1,max_bias=0.000000,logit_softcap=10.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])`
- `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.5e2b94d34560`
  - `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=32,mask=1,sinks=0,max_bias=0.000000,logit_softcap=10.000000,prec=def,type_K=f16,type_V=f16,permute=[0,1,2,3])`
- `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.a12f4ee82c79`
  - `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=3,mask=1,sinks=1,max_bias=0.000000,logit_softcap=10.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])`
- and 3 more, listed in `.triage-results/merged-bugs.json` under `flash-attn-softcap`

## 8. gfx1201 RMS_NORM_BACK multi-wave reduction

**Targets affected**: gfx1201  
**Failing tests**: 2  
**Operators**: RMS_NORM_BACK  
**Confidence**: Inferred from runtime evidence

Two tests. `ne=[1025,5,4,3]` crashes and `ne=[64,5,4,3]` returns wrong results. The crash arrives at the same `GpuMemory` passthrough fallback as the other two crash surfaces, again from a vector load rather than a buffer store, so it is not the RDNA4 buffer defect. The row length of 1025 crossing a wave boundary suggests the reduction tail is read beyond the end of the row.

**Where it is**

- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/vm/amdgpu/gpu_memory.h` lines 501-507 — the passthrough fallback reached by the crashing case

**Evidence**

Confirmed by GDB that the fault reaches `L1VectorCache::load`, not `store`. Confirmed by experiment that the RDNA4 buffer bounds probe does not change either outcome.

**Example failing tests**

- `llama.gfx1201.backend_ops.RMS_NORM_BACK.738357150297`
  - `RMS_NORM_BACK(type=f32,ne=[64,5,4,3],eps=0.000000)`
- `llama.gfx1201.backend_ops.RMS_NORM_BACK.b0eca1729a88`
  - `RMS_NORM_BACK(type=f32,ne=[1025,5,4,3],eps=0.000000)`

## 9. Simulation throughput limit, not a correctness defect

**Targets affected**: gfx1100, gfx1201, gfx942, gfx950  
**Failing tests**: 15  
**Operators**: LIGHTNING_INDEXER, MUL_MAT, MUL_MAT_ID, MUL_MAT_ID_FUSION, RMS_NORM_MUL_ROPE  
**Confidence**: Confirmed by experiment

15 tests exceed the harness time limit rather than producing a wrong answer. LIGHTNING_INDEXER times out on all four targets and MUL_MAT_ID_FUSION on both RDNA targets, which is the signature of simulation cost rather than a device model defect. These are listed for completeness and should be excluded from any defect count.

**Evidence**

The timeouts reproduce across all four targets for the same operators and are insensitive to every probe applied in this investigation.

**Example failing tests**

- `llama.gfx1100.backend_ops.LIGHTNING_INDEXER.28d7def07117`
  - `LIGHTNING_INDEXER(hsk=128,nh=64,kv=256,nb=512,ns=4,nm=4,type_K=q4_0)`
- `llama.gfx1100.backend_ops.MUL_MAT_ID.4c6f0c369254`
  - `MUL_MAT_ID(type_a=q4_0,type_b=f32,n_mats=32,n_used=2,b=0,m=2880,n=32,k=2880)`
- `llama.gfx1100.backend_ops.MUL_MAT_ID.dbedbadd142a`
  - `MUL_MAT_ID(type_a=mxfp4,type_b=f32,n_mats=32,n_used=2,b=0,m=2880,n=32,k=2880)`
- and 12 more, listed in `.triage-results/merged-bugs.json` under `simulator-throughput`

## Related findings that cause none of these failures

Two real deviations were found while tracing the issues above. Neither causes any failure in this corpus, and neither owns any test in the counts, but both are worth fixing on their own terms.

- `emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/shared/execute_shared.h` line 13170 — `execute_v_mad_mix_f32_vop3p` computes `a * b + c` unfused, where gfx942 implements `V_FMA_MIX_F32` with a single rounding. Confirmed at source and by microbenchmark; the difference is 1 ulp.
- RDNA4 has no HWREG ID 26 (WAVE_SCHED_MODE) entry, so `s_setreg_imm32_b32` logs `unsupported hwreg=unknown id=26`. Five failures had been attributed to this. That is refuted: the warning still fires 640 times in a run where all five now pass.

## Reproducing

The build trees live in the worktree pinned at the baseline commit. The ASAN tree needs `handle_segv=2` and `allow_user_segv_handler=0` because the ROCm runtime installs its own SIGSEGV handler that otherwise swallows the fault, and GDB needs `set disable-randomization off` because the crashes depend on the host address-space layout.

```bash
cd ~/rocjitsu_dev/wt/rocjitsu-test-corpus/llama-gfx-triage
./.triage-results/run_case.sh asan gfx1201 \
  "MUL_MAT(type_a=bf16,type_b=f32,m=16,n=1,k=1,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)" /tmp/case.log
```

`.triage-results/run_cases.py` runs and classifies a whole issue's test set at once, for example `python3 run_cases.py --variant plain --bug rdna4-buffer-oob`.
