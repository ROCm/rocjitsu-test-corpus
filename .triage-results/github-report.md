# ROCjitsu llama backend-ops triage: 181 persistent failures on four targets

Every llama `test-backend-ops` case in the corpus inventory was run under ROCjitsu on each supported target, once with a 30-second per-case timeout and then again on every failure with a 60-second timeout. Only failures that survived both runs are reported here. Each section below lists the affected tests first, then the likely ROCjitsu root cause with an explicit confidence level, the supporting evidence, and one command that reproduces the group's representative case.

## Environment

| Item | Value |
| --- | --- |
| ROCjitsu / rocm-systems | [`63a89f8f5cf0`](https://github.com/ROCm/rocm-systems/commit/63a89f8f5cf0f25b98a76057bc00e4a98f88425d) |
| Corpus | [`a6640a2139bf`](https://github.com/ROCm/rocjitsu-test-corpus/commit/a6640a2139bf8e39e27125ad7e14c0b04746dedf) |
| Inventory | [`selected_llama_backend_ops_tests.json`](https://github.com/ROCm/rocjitsu-test-corpus/blob/a6640a2139bf8e39e27125ad7e14c0b04746dedf/corpus/llama/selected_llama_backend_ops_tests.json) |
| Suite | `llama` only |
| Cases per target | 535 |
| Execution | functional mode, eight pytest-xdist workers |

`gfx1250` is excluded because the llama inventory does not list it as a supported target.

## Results

| Target | Simulated device | Config | Passed | Persistent failures | SIGSEGV | Wrong result | Timeout |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `gfx942` | AMD Instinct MI300A (CDNA3) | `gfx942_cdna3.json` | 503 | 32 | 0 | 30 | 2 |
| `gfx950` | AMD Radeon Graphics (CDNA4) | `gfx950_cdna4.json` | 517 | 18 | 0 | 16 | 2 |
| `gfx1100` | AMD Radeon Pro W7900 (RDNA3) | `gfx1100_w7900.json` | 495 | 40 | 21 | 13 | 6 |
| `gfx1201` | AMD Radeon AI PRO R9700 (RDNA4) | `gfx1201_r9700.json` | 444 | 91 | 61 | 25 | 5 |
| **Total** | | | 1959 | 181 | 82 | 84 | 15 |

All 82 SIGSEGV cases share one crash mechanism, described in its own section below. The passed column includes 12 cases that failed only against the 30-second timeout and passed on the 60-second rerun.

## Running the reproducers

Every reproducer in this report uses these three variables:

```bash
export ROCJITSU=<rocm-systems build>/tools/rocjitsu/rocjitsu
export ROCJITSU_CONFIGS=<rocm-systems>/emulation/rocjitsu/configs
export CORPUS=<rocjitsu-test-corpus checkout>
```

`$CORPUS/corpus/llama/build/test-backend-ops` is produced by `corpus/llama/build_llama_tests.sh`. The `ERR` values quoted below come from the recorded run; the harness generates random inputs, so a rerun reproduces the same pass or fail verdict with a slightly different magnitude. To rerun a whole target through the pytest harness instead, from `$CORPUS`:

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx1201_r9700.json" -- \
  python -m pytest tests/test_corpus.py --target gfx1201 \
  --suite llama --timeout 60 -n 8 -o timeout_func_only=true
```

## Candidate bugs (19)

Ordered by number of affected tests.

### 1. gfx1201 `MUL_MAT` faults on an unbacked GPU address

`gfx1201.matrix-crash-surface.MUL_MAT` — 44 tests on gfx1201 (44 segfault)

**Affected tests**

<details>
<summary>44 affected tests</summary>

| Test ID | Case |
| --- | --- |
| `llama.gfx1201.backend_ops.MUL_MAT.0bfa3a774759` | `MUL_MAT(type_a=bf16,type_b=f32,m=129,n=1,k=1057,bs=[2,1],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.12d6ef2eb102` | `MUL_MAT(type_a=f16,type_b=f32,m=128,n=1,k=1057,bs=[8,3],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.1430f54270e4` | `MUL_MAT(type_a=f16,type_b=f16,m=16,n=1,k=1024,bs=[3,2],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.1c37272d4207` | `MUL_MAT(type_a=bf16,type_b=f32,m=129,n=1,k=1057,bs=[4,1],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.21597cf05866` | `MUL_MAT(type_a=bf16,type_b=f32,m=128,n=1,k=1057,bs=[4,3],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.2740bcfad2c3` | `MUL_MAT(type_a=f16,type_b=f32,m=128,n=1,k=1057,bs=[4,3],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.2bb9de5014b7` | `MUL_MAT(type_a=bf16,type_b=f32,m=128,n=1,k=1057,bs=[2,3],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.2f847bd0f72c` | `MUL_MAT(type_a=bf16,type_b=f32,m=1056,n=1,k=129,bs=[2,1],nr=[1,1],per=[0,2,1,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.3b9e72804d6c` | `MUL_MAT(type_a=f16,type_b=f16,m=16,n=1,k=256,bs=[3,2],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.3e329e5b475c` | `MUL_MAT(type_a=f16,type_b=f32,m=1057,n=1,k=129,bs=[2,1],nr=[1,1],per=[0,2,1,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.3f2054def40b` | `MUL_MAT(type_a=f16,type_b=f32,m=129,n=1,k=1057,bs=[8,3],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.427bd256bceb` | `MUL_MAT(type_a=bf16,type_b=f32,m=16,n=7,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.4292d4689b42` | `MUL_MAT(type_a=f16,type_b=f32,m=16,n=6,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.4468e13bf5f3` | `MUL_MAT(type_a=f16,type_b=f32,m=129,n=1,k=1057,bs=[4,1],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.4529cc72e450` | `MUL_MAT(type_a=f16,type_b=f32,m=129,n=1,k=1057,bs=[2,1],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.4791e7191823` | `MUL_MAT(type_a=f16,type_b=f16,m=16,n=1,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.56a3ebecef08` | `MUL_MAT(type_a=f16,type_b=f32,m=128,n=1,k=1057,bs=[4,1],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.5a2e0296c82c` | `MUL_MAT(type_a=f16,type_b=f16,m=16,n=1,k=4,bs=[3,2],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.67a24d655c21` | `MUL_MAT(type_a=bf16,type_b=f32,m=16,n=1,k=1,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.67c2b413a2ab` | `MUL_MAT(type_a=bf16,type_b=f32,m=1,n=64,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.68fbfd9c3ec5` | `MUL_MAT(type_a=iq1_m,type_b=f32,m=16,n=9,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.757a865e7da5` | `MUL_MAT(type_a=iq1_m,type_b=f32,m=1,n=64,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.7fe4bfa5cc2f` | `MUL_MAT(type_a=f16,type_b=f32,m=129,n=1,k=1057,bs=[2,3],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.965b6be4d678` | `MUL_MAT(type_a=bf16,type_b=f32,m=16,n=5,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.9a612f547630` | `MUL_MAT(type_a=bf16,type_b=f32,m=128,n=1,k=1057,bs=[2,1],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.9c792f73463d` | `MUL_MAT(type_a=f16,type_b=f16,m=16,n=1,k=256,bs=[3,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.a78a57b1b164` | `MUL_MAT(type_a=bf16,type_b=f32,m=129,n=1,k=1057,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.adeb0e6159c1` | `MUL_MAT(type_a=bf16,type_b=f32,m=128,n=1,k=1057,bs=[8,3],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.af983043c5ee` | `MUL_MAT(type_a=bf16,type_b=f32,m=1056,n=1,k=129,bs=[1,1],nr=[1,1],per=[0,2,1,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.b4ed18f10c28` | `MUL_MAT(type_a=f16,type_b=f32,m=16,n=7,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.be4d79581943` | `MUL_MAT(type_a=f16,type_b=f32,m=1056,n=1,k=129,bs=[1,1],nr=[1,1],per=[0,2,1,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.c58ade49b398` | `MUL_MAT(type_a=f16,type_b=f32,m=129,n=1,k=1057,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.ccf3f0be1c60` | `MUL_MAT(type_a=bf16,type_b=f32,m=128,n=1,k=1057,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.d8793c3beaab` | `MUL_MAT(type_a=f16,type_b=f32,m=16,n=9,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.d8d5f3069b98` | `MUL_MAT(type_a=bf16,type_b=f32,m=1057,n=1,k=129,bs=[2,1],nr=[1,1],per=[0,2,1,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.da65cf942bdb` | `MUL_MAT(type_a=f16,type_b=f32,m=128,n=1,k=1057,bs=[2,3],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.dae71e0e75e6` | `MUL_MAT(type_a=bf16,type_b=f32,m=129,n=1,k=1057,bs=[8,3],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.e52b5d823289` | `MUL_MAT(type_a=f16,type_b=f16,m=16,n=1,k=4,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.e5d32efbe803` | `MUL_MAT(type_a=f16,type_b=f32,m=128,n=1,k=1057,bs=[1,1],nr=[4,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.eb1434025ead` | `MUL_MAT(type_a=bf16,type_b=f32,m=16,n=9,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.f678c43ff6f4` | `MUL_MAT(type_a=bf16,type_b=f32,m=129,n=1,k=1057,bs=[2,3],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.f8941f74071b` | `MUL_MAT(type_a=f16,type_b=f32,m=1056,n=1,k=129,bs=[2,1],nr=[1,1],per=[0,2,1,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.faa09334a5c1` | `MUL_MAT(type_a=bf16,type_b=f32,m=16,n=4,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.fbddae989c1d` | `MUL_MAT(type_a=bf16,type_b=f32,m=128,n=1,k=1057,bs=[4,1],nr=[1,1],per=[0,1,2,3],k_v=2113,o=1)` |

</details>

**Likely root cause**

The simulator computes an operand address that no VMID page-table entry backs, then dereferences the GPU virtual address as a host pointer and takes SIGSEGV. The fallback explains how the process dies; it does not identify which earlier address computation produced the bad address. The 44 cases span f16, bf16, f32, and quantized `type_a` values with no shared shape, which points at an address or descriptor computation ahead of the matmul kernel rather than at one kernel variant. The crash is deterministic under normal address-space randomization, but the representative case did pass once in a GDB session with randomization disabled, so the faulting address is sensitive to host memory layout.

*Confidence: Confirmed ROCjitsu crash; initiating address defect not localized.*

**Evidence**

- Fault path: [`gpu_memory.h` VMID walk and passthrough fallback](https://github.com/ROCm/rocm-systems/blob/63a89f8f5cf0f25b98a76057bc00e4a98f88425d/emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/vm/amdgpu/gpu_memory.h#L484-L511).
- `debug/gfx1201-mul-mat-gdb-aslr.log` faults in `GpuMemory::read_mapped()`; the source address is absent from `/proc/<pid>/maps` while the destination is writable.
- `debug/gfx1201-mul-mat-repeat-status.tsv`: 20 consecutive command-line runs all exited 139 (SIGSEGV).
- Not fixed by [rocm-systems#9003](https://github.com/ROCm/rocm-systems/pull/9003); all 44 cases still fault with that branch built.

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx1201_r9700.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'MUL_MAT(type_a=bf16,type_b=f32,m=16,n=1,k=1,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)' \
  -b ROCm0 -j 1 --output csv
```

### 2. gfx1100 `FLASH_ATTN_EXT` optimized WMMA path is wrong and can fault

`gfx1100.flash-attn.optimized-mma-wmma` — 29 tests on gfx1100 (18 segfault, 11 test-failure)

**Affected tests**

<details>
<summary>29 affected tests</summary>

| Test ID | Outcome | Case |
| --- | --- | --- |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.09f30cac3778` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=75,mask=1,sinks=1,max_bias=0.000000,logit_softcap=10.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.128bf0f8e11b` | test-failure | `FLASH_ATTN_EXT(hsk=80,hsv=80,nh=4,nr23=[4,1],kv=512,nb=75,mask=1,sinks=0,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.199f26f43bd8` | test-failure | `FLASH_ATTN_EXT(hsk=64,hsv=64,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=bf16,type_V=bf16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.2b8c93acdf59` | test-failure | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=1,max_bias=0.000000,logit_softcap=10.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.2dce6045f861` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=75,mask=1,sinks=0,max_bias=0.000000,logit_softcap=0.000000,prec=def,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.3011acacd940` | test-failure | `FLASH_ATTN_EXT(hsk=64,hsv=64,nh=4,nr23=[4,3],kv=512,nb=32,mask=1,sinks=0,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=q4_0,type_V=q4_0,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.308462dc53da` | test-failure | `FLASH_ATTN_EXT(hsk=80,hsv=80,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=0,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.3cb3400551f5` | test-failure | `FLASH_ATTN_EXT(hsk=64,hsv=64,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=0,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=q4_0,type_V=q4_0,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.3e3b001724ad` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=3,mask=1,sinks=0,max_bias=0.000000,logit_softcap=0.000000,prec=def,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.3f4c31a640cf` | test-failure | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=0,max_bias=0.000000,logit_softcap=0.000000,prec=def,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.42d8b5a9a8e6` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[4,1],kv=512,nb=75,mask=1,sinks=0,max_bias=0.000000,logit_softcap=0.000000,prec=def,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.56b8d3aa98d7` | test-failure | `FLASH_ATTN_EXT(hsk=64,hsv=64,nh=4,nr23=[4,1],kv=512,nb=75,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=f32,type_V=f32,permute=[0,2,1,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.5e2b94d34560` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=32,mask=1,sinks=0,max_bias=0.000000,logit_softcap=10.000000,prec=def,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.6db37d5b0bbd` | test-failure | `FLASH_ATTN_EXT(hsk=64,hsv=64,nh=4,nr23=[4,1],kv=512,nb=75,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=bf16,type_V=bf16,permute=[0,2,1,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.74edc47aa39a` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.78086d5cc78b` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=32,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.7fc0eebb6b21` | segfault | `FLASH_ATTN_EXT(hsk=80,hsv=80,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.8722d0937d99` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[4,1],kv=512,nb=75,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,2,1,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.926dbedf6cda` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=3,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,2,1,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.a12f4ee82c79` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=3,mask=1,sinks=1,max_bias=0.000000,logit_softcap=10.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.a845b89cd4f0` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=3,mask=1,sinks=0,max_bias=0.000000,logit_softcap=10.000000,prec=def,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.afceae33b0b7` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=32,mask=1,sinks=0,max_bias=0.000000,logit_softcap=0.000000,prec=def,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.b951a29db5dd` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=75,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,2,1,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.c94907bea454` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=32,mask=1,sinks=1,max_bias=0.000000,logit_softcap=10.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.da5c646e799e` | test-failure | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=0,max_bias=0.000000,logit_softcap=10.000000,prec=def,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.e024795e26c2` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[4,1],kv=512,nb=75,mask=1,sinks=1,max_bias=0.000000,logit_softcap=10.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.e397786c8f00` | segfault | `FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[12,1],kv=512,nb=3,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.e5e7712c889c` | segfault | `FLASH_ATTN_EXT(hsk=80,hsv=80,nh=4,nr23=[4,1],kv=512,nb=75,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,2,1,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.eb5de146e0b8` | test-failure | `FLASH_ATTN_EXT(hsk=64,hsv=64,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=f32,type_V=f32,permute=[0,1,2,3])` |

</details>

**Likely root cause**

All 29 cases use head sizes of 64, 80, or 128, which llama.cpp maps to its optimized MMA/WMMA flash-attention kernels on RDNA3 rather than to the generic tile kernel that the D=72 group below uses. Eleven return reproducible numerical error and 18 escalate to SIGSEGV as mask, sink, and permute parameters change. A single incorrect index or accumulator computation in ROCjitsu's WMMA emulation explains that gradient better than 29 independent defects.

*Confidence: Likely one ROCjitsu bug family; high confidence in the grouping, medium in the mechanism.*

**Evidence**

- `debug/gfx1100-flash-attn-gdb-aslr.log` faults in the same [`GpuMemory::read_mapped()` path](https://github.com/ROCm/rocm-systems/blob/63a89f8f5cf0f25b98a76057bc00e4a98f88425d/emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/vm/amdgpu/gpu_memory.h#L484-L511) as the gfx1201 matmul crashes.
- `RJ_FORCE_SCALAR=1` reproduces the numerical failures unchanged, so the SIMD executor fast path is not the cause.
- No `FLASH_ATTN_EXT` case fails on gfx942, gfx950, or gfx1201.

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx1100_w7900.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'FLASH_ATTN_EXT(hsk=128,hsv=128,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=f16,type_V=f16,permute=[0,1,2,3])' \
  -b ROCm0 -j 1 --output csv
```

### 3. gfx1201 kernels indexed on `threadIdx.y` return sentinels

`gfx1201.packed-workitem-y-surface` — 24 tests on gfx1201 (24 test-failure)

**Affected tests**

<details>
<summary>24 affected tests</summary>

| Test ID | Case |
| --- | --- |
| `llama.gfx1201.backend_ops.GATED_DELTA_NET.05b63a4322c6` | `GATED_DELTA_NET(type=f32,head_count=8,head_size=32,n_seq_tokens=4,n_seqs=2,v_repeat=2,permuted=0,kda=1,K=4)` |
| `llama.gfx1201.backend_ops.GATED_DELTA_NET.5615f586b1ca` | `GATED_DELTA_NET(type=f32,head_count=4,head_size=32,n_seq_tokens=4,n_seqs=1,v_repeat=1,permuted=0,kda=0,K=4)` |
| `llama.gfx1201.backend_ops.GATED_DELTA_NET.5a41ca1b14ff` | `GATED_DELTA_NET(type=f32,head_count=32,head_size=16,n_seq_tokens=1,n_seqs=1,v_repeat=1,permuted=0,kda=0,K=1)` |
| `llama.gfx1201.backend_ops.GATED_DELTA_NET.6f2073224190` | `GATED_DELTA_NET(type=f32,head_count=4,head_size=64,n_seq_tokens=4,n_seqs=2,v_repeat=1,permuted=0,kda=1,K=4)` |
| `llama.gfx1201.backend_ops.GATED_DELTA_NET.71f1f886bdeb` | `GATED_DELTA_NET(type=f32,head_count=8,head_size=32,n_seq_tokens=4,n_seqs=2,v_repeat=2,permuted=0,kda=0,K=1)` |
| `llama.gfx1201.backend_ops.GATED_DELTA_NET.7bad0bbc2812` | `GATED_DELTA_NET(type=f32,head_count=4,head_size=64,n_seq_tokens=4,n_seqs=1,v_repeat=1,permuted=0,kda=0,K=1)` |
| `llama.gfx1201.backend_ops.GATED_DELTA_NET.7cb9b00606cb` | `GATED_DELTA_NET(type=f32,head_count=4,head_size=64,n_seq_tokens=1,n_seqs=1,v_repeat=1,permuted=0,kda=1,K=1)` |
| `llama.gfx1201.backend_ops.GATED_DELTA_NET.bafb44a169ef` | `GATED_DELTA_NET(type=f32,head_count=4,head_size=16,n_seq_tokens=2,n_seqs=1,v_repeat=1,permuted=0,kda=0,K=2)` |
| `llama.gfx1201.backend_ops.GATED_DELTA_NET.bbcb01f66416` | `GATED_DELTA_NET(type=f32,head_count=8,head_size=128,n_seq_tokens=4,n_seqs=1,v_repeat=1,permuted=0,kda=0,K=4)` |
| `llama.gfx1201.backend_ops.GATED_DELTA_NET.bdcf60346537` | `GATED_DELTA_NET(type=f32,head_count=4,head_size=32,n_seq_tokens=4,n_seqs=1,v_repeat=1,permuted=0,kda=1,K=1)` |
| `llama.gfx1201.backend_ops.GATED_DELTA_NET.d35f9c8ff08d` | `GATED_DELTA_NET(type=f32,head_count=32,head_size=128,n_seq_tokens=1,n_seqs=1,v_repeat=1,permuted=0,kda=0,K=1)` |
| `llama.gfx1201.backend_ops.GATED_DELTA_NET.f029d1f5b7d0` | `GATED_DELTA_NET(type=f32,head_count=4,head_size=64,n_seq_tokens=4,n_seqs=2,v_repeat=1,permuted=0,kda=0,K=4)` |
| `llama.gfx1201.backend_ops.GATED_DELTA_NET.f1ead0d94ad7` | `GATED_DELTA_NET(type=f32,head_count=4,head_size=16,n_seq_tokens=1,n_seqs=2,v_repeat=1,permuted=0,kda=1,K=1)` |
| `llama.gfx1201.backend_ops.RMS_NORM_MUL_ROPE.a61604d8ebe1` | `RMS_NORM_MUL_ROPE(ne=[8192,2,2,1],eps=0.000001,multi_add=0,set_rows=0,mode=0)` |
| `llama.gfx1201.backend_ops.RMS_NORM_MUL_ROPE.c9137b08fd08` | `RMS_NORM_MUL_ROPE(ne=[8192,2,2,1],eps=0.000001,multi_add=0,set_rows=1,mode=2)` |
| `llama.gfx1201.backend_ops.TOPK_MOE.0e270f70f362` | `TOPK_MOE(ne=[8,22,1,1],n_expert_used=4,with_norm=0,bias_probs=1,gating_func=0,scale_w=0.000000)` |
| `llama.gfx1201.backend_ops.TOPK_MOE.2a02b005d62f` | `TOPK_MOE(ne=[288,22,1,1],n_expert_used=8,with_norm=0,bias_probs=1,gating_func=0,scale_w=0.000000)` |
| `llama.gfx1201.backend_ops.TOPK_MOE.2e7ea640edeb` | `TOPK_MOE(ne=[256,22,1,1],n_expert_used=6,with_norm=0,bias_probs=0,gating_func=0,scale_w=0.000000)` |
| `llama.gfx1201.backend_ops.TOPK_MOE.5cb8fc0cd986` | `TOPK_MOE(ne=[288,22,1,1],n_expert_used=8,with_norm=0,bias_probs=0,gating_func=0,scale_w=0.000000)` |
| `llama.gfx1201.backend_ops.TOPK_MOE.6ec8af8002fa` | `TOPK_MOE(ne=[8,22,1,1],n_expert_used=4,with_norm=0,bias_probs=0,gating_func=0,scale_w=0.000000)` |
| `llama.gfx1201.backend_ops.TOPK_MOE.898147839f3e` | `TOPK_MOE(ne=[32,22,1,1],n_expert_used=8,with_norm=0,bias_probs=1,gating_func=0,scale_w=0.000000)` |
| `llama.gfx1201.backend_ops.TOPK_MOE.91b601cce199` | `TOPK_MOE(ne=[8,22,1,1],n_expert_used=4,with_norm=0,bias_probs=0,gating_func=2,scale_w=2.000000)` |
| `llama.gfx1201.backend_ops.TOPK_MOE.ba01fa21e49a` | `TOPK_MOE(ne=[32,22,1,1],n_expert_used=8,with_norm=0,bias_probs=0,gating_func=0,scale_w=0.000000)` |
| `llama.gfx1201.backend_ops.TOPK_MOE.fa7a6e1ee615` | `TOPK_MOE(ne=[256,22,1,1],n_expert_used=6,with_norm=0,bias_probs=1,gating_func=0,scale_w=0.000000)` |

</details>

**Likely root cause**

24 gfx1201 cases across `GATED_DELTA_NET`, `TOPK_MOE`, and fused `RMS_NORM_MUL_ROPE` fail while the same operators pass on gfx942, gfx950, and gfx1100. The failing kernels all index on `threadIdx.y`, and the reported errors are exact sentinels such as `[VIEW] ERR = 1.000000000` plus downstream corruption, which is what an incorrect packed work-item Y decode in the RDNA4 wave prologue would produce. Not source-localized.

*Confidence: Likely bug family; mechanism is a hypothesis.*

**Evidence**

- Target-exclusive: no other supported target fails these operators.
- `RJ_FORCE_SCALAR=1` reproduces all 24 failures unchanged.
- Artifacts under `hard/gfx1201/artifacts/llama/gfx1201/cases/`.

Observed for `llama.gfx1201.backend_ops.TOPK_MOE.6ec8af8002fa`:

```
[VIEW] ERR = 1.000000000 > 0.000000100
[GET_ROWS] ERR = 0.800372721 > 0.000000100
```

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx1201_r9700.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'TOPK_MOE(ne=[8,22,1,1],n_expert_used=4,with_norm=0,bias_probs=0,gating_func=0,scale_w=0.000000)' \
  -b ROCm0 -j 1 --output csv
```

### 4. gfx942 NVFP4 matmul route returns uncorrelated results

`gfx942.nvfp4-route` — 14 tests on gfx942 (14 test-failure)

**Affected tests**

<details>
<summary>14 affected tests</summary>

| Test ID | Case |
| --- | --- |
| `llama.gfx942.backend_ops.MUL_MAT.017115bdd15b` | `MUL_MAT(type_a=nvfp4,type_b=f32,m=16,n=7,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx942.backend_ops.MUL_MAT.38225d8678d3` | `MUL_MAT(type_a=nvfp4,type_b=f32,m=16,n=6,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx942.backend_ops.MUL_MAT.48f89386e558` | `MUL_MAT(type_a=nvfp4,type_b=f32,m=16,n=4,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx942.backend_ops.MUL_MAT.65b2027ab982` | `MUL_MAT(type_a=nvfp4,type_b=f32,m=16,n=3,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx942.backend_ops.MUL_MAT.9e9ba8458bfc` | `MUL_MAT(type_a=nvfp4,type_b=f32,m=16,n=2,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx942.backend_ops.MUL_MAT.a8125e58a34b` | `MUL_MAT(type_a=nvfp4,type_b=f32,m=16,n=8,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx942.backend_ops.MUL_MAT.ce78b3dca900` | `MUL_MAT(type_a=nvfp4,type_b=f32,m=16,n=5,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx942.backend_ops.MUL_MAT.fe08e494b3c4` | `MUL_MAT(type_a=nvfp4,type_b=f32,m=1,n=64,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx942.backend_ops.MUL_MAT_ID.2c2d40514bc8` | `MUL_MAT_ID(type_a=nvfp4,type_b=f32,n_mats=4,n_used=2,b=0,m=64,n=16,k=192)` |
| `llama.gfx942.backend_ops.MUL_MAT_ID.3cdbbdcd11b4` | `MUL_MAT_ID(type_a=nvfp4,type_b=f32,n_mats=4,n_used=1,b=0,m=512,n=17,k=256)` |
| `llama.gfx942.backend_ops.MUL_MAT_ID.87069c59f324` | `MUL_MAT_ID(type_a=nvfp4,type_b=f32,n_mats=4,n_used=1,b=0,m=512,n=129,k=256)` |
| `llama.gfx942.backend_ops.MUL_MAT_ID.965309d54fb6` | `MUL_MAT_ID(type_a=nvfp4,type_b=f32,n_mats=4,n_used=1,b=0,m=512,n=4,k=256)` |
| `llama.gfx942.backend_ops.MUL_MAT_ID.c9c4af69fd12` | `MUL_MAT_ID(type_a=nvfp4,type_b=f32,n_mats=4,n_used=1,b=0,m=512,n=1,k=256)` |
| `llama.gfx942.backend_ops.MUL_MAT_VEC_FUSION.64a84ca8e243` | `MUL_MAT_VEC_FUSION(type=nvfp4,glu_op=1,m=1,n=32,k=256,use_id=0,n_mats=16,n_used=8,b=0,with_bias=0,with_gate=1,with_lane_scale=0,batch_dims=[1,1])` |

</details>

**Likely root cause**

All 14 cases are `MUL_MAT`, `MUL_MAT_ID`, or `MUL_MAT_VEC_FUSION` with `type_a=nvfp4` on gfx942, and they report `ERR` at or near 1.0, meaning the output is uncorrelated with the reference rather than slightly off. The identical cases pass on gfx950, gfx1100, and gfx1201, so the NVFP4 dequantization or scale handling on the CDNA3 route is wrong rather than accumulated rounding error.

*Confidence: Likely ROCjitsu defect; high.*

**Evidence**

- `MUL_MAT.9e9ba8458bfc` reports `ERR = 0.999999932` on gfx942 and passes on gfx950, gfx1100, and gfx1201.
- `RJ_FORCE_SCALAR=1` reproduces all 14 failures unchanged.

Observed for `llama.gfx942.backend_ops.MUL_MAT.9e9ba8458bfc`:

```
[MUL_MAT] ERR = 0.999999932 > 0.000500000
```

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx942_cdna3.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'MUL_MAT(type_a=nvfp4,type_b=f32,m=16,n=2,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)' \
  -b ROCm0 -j 1 --output csv
```

### 5. gfx1201 `MUL_MAT_ID` faults on an unbacked GPU address

`gfx1201.matrix-crash-surface.MUL_MAT_ID` — 7 tests on gfx1201 (7 segfault)

**Affected tests**

<details>
<summary>7 affected tests</summary>

| Test ID | Case |
| --- | --- |
| `llama.gfx1201.backend_ops.MUL_MAT_ID.297df3b5f822` | `MUL_MAT_ID(type_a=f16,type_b=f32,n_mats=1,n_used=1,b=0,m=8,n=16,k=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT_ID.4d3788c41bef` | `MUL_MAT_ID(type_a=f32,type_b=f32,n_mats=4,n_used=2,b=0,m=512,n=17,k=256)` |
| `llama.gfx1201.backend_ops.MUL_MAT_ID.5bba4e9ee5fa` | `MUL_MAT_ID(type_a=bf16,type_b=f32,n_mats=4,n_used=2,b=0,m=64,n=16,k=3)` |
| `llama.gfx1201.backend_ops.MUL_MAT_ID.6c5a0824e9d0` | `MUL_MAT_ID(type_a=f16,type_b=f32,n_mats=4,n_used=2,b=0,m=64,n=16,k=3)` |
| `llama.gfx1201.backend_ops.MUL_MAT_ID.ce7f91ceb634` | `MUL_MAT_ID(type_a=iq1_m,type_b=f32,n_mats=4,n_used=2,b=0,m=512,n=32,k=256)` |
| `llama.gfx1201.backend_ops.MUL_MAT_ID.debb5fffb653` | `MUL_MAT_ID(type_a=iq1_m,type_b=f32,n_mats=4,n_used=2,b=0,m=64,n=16,k=768)` |
| `llama.gfx1201.backend_ops.MUL_MAT_ID.ef8683b758e2` | `MUL_MAT_ID(type_a=f32,type_b=f32,n_mats=4,n_used=2,b=0,m=64,n=16,k=3)` |

</details>

**Likely root cause**

The simulator computes an operand address that no VMID page-table entry backs, then dereferences the GPU virtual address as a host pointer and takes SIGSEGV. The fallback explains how the process dies; it does not identify which earlier address computation produced the bad address. These seven cases reach the fallback through the expert-indexed matmul route, which reads an extra index tensor before the operand addresses are formed.

*Confidence: Confirmed ROCjitsu crash; kept separate from `MUL_MAT` because the expert-indexed route differs.*

**Evidence**

- Shared fault path with the `MUL_MAT` group: [`gpu_memory.h`](https://github.com/ROCm/rocm-systems/blob/63a89f8f5cf0f25b98a76057bc00e4a98f88425d/emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/vm/amdgpu/gpu_memory.h#L484-L511).
- Not fixed by [rocm-systems#9003](https://github.com/ROCm/rocm-systems/pull/9003).

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx1201_r9700.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'MUL_MAT_ID(type_a=f16,type_b=f32,n_mats=1,n_used=1,b=0,m=8,n=16,k=1)' \
  -b ROCm0 -j 1 --output csv
```

### 6. CDNA small f32 `MUL_MAT` returns wrong values

`cdna.mmf-f32` — 6 tests on gfx942, gfx950 (6 test-failure)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx942.backend_ops.MUL_MAT.5a436936375c` | `MUL_MAT(type_a=f32,type_b=f32,m=16,n=4,k=4,bs=[2,3],nr=[1,1],per=[0,3,2,1],k_v=0,o=1)` |
| `llama.gfx942.backend_ops.MUL_MAT.9f4865116d4b` | `MUL_MAT(type_a=f32,type_b=f32,m=16,n=16,k=4,bs=[1,1],nr=[1,2],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx942.backend_ops.MUL_MAT.b3d523cee895` | `MUL_MAT(type_a=f32,type_b=f32,m=16,n=8,k=4,bs=[2,3],nr=[1,1],per=[0,1,3,2],k_v=0,o=1)` |
| `llama.gfx950.backend_ops.MUL_MAT.5a436936375c` | `MUL_MAT(type_a=f32,type_b=f32,m=16,n=4,k=4,bs=[2,3],nr=[1,1],per=[0,3,2,1],k_v=0,o=1)` |
| `llama.gfx950.backend_ops.MUL_MAT.9f4865116d4b` | `MUL_MAT(type_a=f32,type_b=f32,m=16,n=16,k=4,bs=[1,1],nr=[1,2],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx950.backend_ops.MUL_MAT.b3d523cee895` | `MUL_MAT(type_a=f32,type_b=f32,m=16,n=8,k=4,bs=[2,3],nr=[1,1],per=[0,1,3,2],k_v=0,o=1)` |

**Likely root cause**

Three `type_a=f32,type_b=f32` cases with `m=16` and `k=4` fail identically on gfx942 and gfx950 with errors far above tolerance. All three use a non-trivial `per=` permutation or broadcast `nr=`, so ROCjitsu's small-tile f32 matmul appears to mishandle permuted or broadcast source strides. gfx942 and gfx950 fail on exactly the same case strings, so the defect is in a shared CDNA path rather than in one target's model.

*Confidence: Likely ROCjitsu defect; medium-high.*

**Evidence**

- `MUL_MAT.5a436936375c` reports `ERR = 1.644854360` against a 0.0005 tolerance on both CDNA targets.
- `RJ_FORCE_SCALAR=1` reproduces all six failures unchanged.

Observed for `llama.gfx942.backend_ops.MUL_MAT.5a436936375c`:

```
[MUL_MAT] ERR = 1.644854360 > 0.000500000
```

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx942_cdna3.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'MUL_MAT(type_a=f32,type_b=f32,m=16,n=4,k=4,bs=[2,3],nr=[1,1],per=[0,3,2,1],k_v=0,o=1)' \
  -b ROCm0 -j 1 --output csv
```

### 7. CDNA `OUT_PROD` and `SOLVE_TRI` return wrong values

`cdna.rocblas-surface` — 6 tests on gfx942, gfx950 (6 test-failure)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx942.backend_ops.OUT_PROD.7eb05239af23` | `OUT_PROD(type_a=f32,type_b=f32,m=256,n=1,k=1,bs=[1,1],nr=[1,2],trans_b=0)` |
| `llama.gfx942.backend_ops.SOLVE_TRI.4b2665c93c4f` | `SOLVE_TRI(type=f32,ne_lhs=[128,128,4,1],ne_rhs=[32,128,4,1])` |
| `llama.gfx942.backend_ops.SOLVE_TRI.efce0cf0e0d3` | `SOLVE_TRI(type=f32,ne_lhs=[84,84,4,4],ne_rhs=[32,84,4,4])` |
| `llama.gfx950.backend_ops.OUT_PROD.7eb05239af23` | `OUT_PROD(type_a=f32,type_b=f32,m=256,n=1,k=1,bs=[1,1],nr=[1,2],trans_b=0)` |
| `llama.gfx950.backend_ops.SOLVE_TRI.4b2665c93c4f` | `SOLVE_TRI(type=f32,ne_lhs=[128,128,4,1],ne_rhs=[32,128,4,1])` |
| `llama.gfx950.backend_ops.SOLVE_TRI.efce0cf0e0d3` | `SOLVE_TRI(type=f32,ne_lhs=[84,84,4,4],ne_rhs=[32,84,4,4])` |

**Likely root cause**

One `OUT_PROD` and two `SOLVE_TRI` f32 cases fail identically on gfx942 and gfx950. Both operators dispatch through the library-backed BLAS surface rather than a hand-written ggml kernel, so a shared defect in that dispatch or in the kernels the library selects is the most economical explanation. The shared-surface attribution is a hypothesis; the numerical failures are reproducible facts. All three case strings also fail on gfx1201, where they crash instead, so this is not a CDNA-only defect: the same operand shapes break on three of the four targets with two different symptoms.

*Confidence: Likely one ROCjitsu defect; medium.*

**Evidence**

- Both operators pass on gfx1100.
- The same three case strings take SIGSEGV on gfx1201; see the `OUT_PROD` and `SOLVE_TRI` crash sections.
- `RJ_FORCE_SCALAR=1` reproduces all six failures unchanged.

Observed for `llama.gfx942.backend_ops.OUT_PROD.7eb05239af23`:

```
[OUT_PROD] ERR = 1.421743086 > 0.000500000
```

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx942_cdna3.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'OUT_PROD(type_a=f32,type_b=f32,m=256,n=1,k=1,bs=[1,1],nr=[1,2],trans_b=0)' \
  -b ROCm0 -j 1 --output csv
```

### 8. CDNA `ROPE` and `ROPE_SET_ROWS` return wrong values

`cdna.rope-propagation` — 6 tests on gfx942, gfx950 (6 test-failure)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx942.backend_ops.ROPE.637c25a9ca18` | `ROPE(type=f16,ne_a=[128,32,2,1],n_dims=128,mode=40,n_ctx=512,fs=1.424500,ef=0.746500,af=1.424500,ff=1,v=1,inplace=1)` |
| `llama.gfx942.backend_ops.ROPE_SET_ROWS.466fbec03e98` | `ROPE_SET_ROWS(type=f32,type_idx=i64,ne_a=[128,32,1,1],mode=8)` |
| `llama.gfx942.backend_ops.ROPE_SET_ROWS.9fab018c060b` | `ROPE_SET_ROWS(type=f16,type_idx=i64,ne_a=[128,32,1,1],mode=24)` |
| `llama.gfx950.backend_ops.ROPE.637c25a9ca18` | `ROPE(type=f16,ne_a=[128,32,2,1],n_dims=128,mode=40,n_ctx=512,fs=1.424500,ef=0.746500,af=1.424500,ff=1,v=1,inplace=1)` |
| `llama.gfx950.backend_ops.ROPE_SET_ROWS.466fbec03e98` | `ROPE_SET_ROWS(type=f32,type_idx=i64,ne_a=[128,32,1,1],mode=8)` |
| `llama.gfx950.backend_ops.ROPE_SET_ROWS.9fab018c060b` | `ROPE_SET_ROWS(type=f16,type_idx=i64,ne_a=[128,32,1,1],mode=24)` |

**Likely root cause**

One `ROPE` case with `mode=40` and two `ROPE_SET_ROWS` cases with `mode=8` and `mode=24` fail identically on gfx942 and gfx950. All three use non-default rotary modes, so the shared suspect is ROPE mode-flag handling and its propagation into the fused set-rows variant. gfx942 and gfx950 fail on exactly the same case strings, so the defect is in a shared CDNA path rather than in one target's model.

*Confidence: Likely one ROCjitsu defect; medium.*

**Evidence**

- Default-mode ROPE cases in the same inventory pass on both CDNA targets.
- `RJ_FORCE_SCALAR=1` reproduces all six failures unchanged.

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx942_cdna3.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'ROPE(type=f16,ne_a=[128,32,2,1],n_dims=128,mode=40,n_ctx=512,fs=1.424500,ef=0.746500,af=1.424500,ff=1,v=1,inplace=1)' \
  -b ROCm0 -j 1 --output csv
```

### 9. CDNA `SSM_SCAN` returns wrong values

`cdna.ssm-scan` — 6 tests on gfx942, gfx950 (6 test-failure)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx942.backend_ops.SSM_SCAN.83b46ddc1f72` | `SSM_SCAN(type=f32,d_state=16,head_dim=1,n_head=1024,n_group=1,n_seq_tokens=32,n_seqs=4,xbc_overlap=0)` |
| `llama.gfx942.backend_ops.SSM_SCAN.8ffce5cff50e` | `SSM_SCAN(type=f32,d_state=256,head_dim=64,n_head=8,n_group=2,n_seq_tokens=32,n_seqs=4,xbc_overlap=0)` |
| `llama.gfx942.backend_ops.SSM_SCAN.b63c27fe2feb` | `SSM_SCAN(type=f32,d_state=128,head_dim=128,n_head=4,n_group=4,n_seq_tokens=16,n_seqs=2,xbc_overlap=1)` |
| `llama.gfx950.backend_ops.SSM_SCAN.83b46ddc1f72` | `SSM_SCAN(type=f32,d_state=16,head_dim=1,n_head=1024,n_group=1,n_seq_tokens=32,n_seqs=4,xbc_overlap=0)` |
| `llama.gfx950.backend_ops.SSM_SCAN.8ffce5cff50e` | `SSM_SCAN(type=f32,d_state=256,head_dim=64,n_head=8,n_group=2,n_seq_tokens=32,n_seqs=4,xbc_overlap=0)` |
| `llama.gfx950.backend_ops.SSM_SCAN.b63c27fe2feb` | `SSM_SCAN(type=f32,d_state=128,head_dim=128,n_head=4,n_group=4,n_seq_tokens=16,n_seqs=2,xbc_overlap=1)` |

**Likely root cause**

Three `SSM_SCAN` f32 cases fail identically on gfx942 and gfx950 while other `SSM_SCAN` shapes pass. The failing shapes differ in `d_state`, `head_dim`, and `n_group`, so the suspect is the state-tiling or cross-lane reduction the scan kernel uses for those shapes. gfx942 and gfx950 fail on exactly the same case strings, so the defect is in a shared CDNA path rather than in one target's model.

*Confidence: Likely one ROCjitsu defect; medium.*

**Evidence**

- Other `SSM_SCAN` shapes in the same inventory pass on both CDNA targets.
- `RJ_FORCE_SCALAR=1` reproduces all six failures unchanged.

Observed for `llama.gfx942.backend_ops.SSM_SCAN.83b46ddc1f72`:

```
[SSM_SCAN] ERR = 0.920558080 > 0.000000100
```

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx942_cdna3.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'SSM_SCAN(type=f32,d_state=16,head_dim=1,n_head=1024,n_group=1,n_seq_tokens=32,n_seqs=4,xbc_overlap=0)' \
  -b ROCm0 -j 1 --output csv
```

### 10. gfx1100 `FLASH_ATTN_EXT` D=72 generic tile path

`gfx1100.flash-attn.generic-tile-d72` — 5 tests on gfx1100 (3 segfault, 2 test-failure)

**Affected tests**

| Test ID | Outcome | Case |
| --- | --- | --- |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.0839462e9aa3` | segfault | `FLASH_ATTN_EXT(hsk=72,hsv=72,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=q8_0,type_V=q8_0,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.0ffa0a7d7dc5` | test-failure | `FLASH_ATTN_EXT(hsk=72,hsv=72,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=0,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=q4_0,type_V=q4_0,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.1d03df547de7` | segfault | `FLASH_ATTN_EXT(hsk=72,hsv=72,nh=4,nr23=[4,1],kv=512,nb=75,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=q8_0,type_V=q8_0,permute=[0,2,1,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.27a842fb2b89` | segfault | `FLASH_ATTN_EXT(hsk=72,hsv=72,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=q4_0,type_V=q4_0,permute=[0,1,2,3])` |
| `llama.gfx1100.backend_ops.FLASH_ATTN_EXT.413b9f5893c3` | test-failure | `FLASH_ATTN_EXT(hsk=72,hsv=72,nh=4,nr23=[4,1],kv=512,nb=75,mask=1,sinks=0,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=q4_0,type_V=q4_0,permute=[0,1,2,3])` |

**Likely root cause**

Five cases with `hsk=hsv=72` fail on gfx1100: two return numerical error and three take SIGSEGV. Head size 72 is not a WMMA tile multiple, so these run the generic flash-attention tile kernel rather than the optimized kernel of the group above, which is why they are tracked separately. Five other `hsk=72` cases pass and differ only in `nr23`, `kv`, or `max_bias`, so the defect needs a particular combination of head size and tiling rather than head size alone.

*Confidence: Likely a ROCjitsu defect distinct from the WMMA group; medium.*

**Evidence**

- The three crashes reach the same [`GpuMemory::read_mapped()` fallback](https://github.com/ROCm/rocm-systems/blob/63a89f8f5cf0f25b98a76057bc00e4a98f88425d/emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/vm/amdgpu/gpu_memory.h#L484-L511).
- Five of the ten `hsk=72` cases in the inventory fail, all with `nr23=[4,1]`, `kv=512`, and `max_bias=0`.
- No `FLASH_ATTN_EXT` case fails on gfx942, gfx950, or gfx1201.

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx1100_w7900.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'FLASH_ATTN_EXT(hsk=72,hsv=72,nh=4,nr23=[4,1],kv=512,nb=32,mask=1,sinks=1,max_bias=0.000000,logit_softcap=0.000000,prec=f32,type_K=q4_0,type_V=q4_0,permute=[0,1,2,3])' \
  -b ROCm0 -j 1 --output csv
```

### 11. RDNA4 HWREG ID 26 (`WAVE_SCHED_MODE`) is not modeled

`gfx1201.wave-sched-mode-gap` — 5 tests on gfx1201 (5 segfault)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx1201.backend_ops.MUL_MAT.462ccb738b08` | `MUL_MAT(type_a=f16,type_b=f16,m=16,n=8,k=256,bs=[1536,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.720ff672c8f0` | `MUL_MAT(type_a=bf16,type_b=f32,m=1056,n=1,k=129,bs=[8,1],nr=[1,1],per=[0,2,1,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.7bcc11c86355` | `MUL_MAT(type_a=f16,type_b=f32,m=1056,n=1,k=129,bs=[4,1],nr=[1,1],per=[0,2,1,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.bc1240d0e862` | `MUL_MAT(type_a=f16,type_b=f32,m=1056,n=1,k=129,bs=[8,1],nr=[1,1],per=[0,2,1,3],k_v=0,o=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT.d5d0d2415b9b` | `MUL_MAT(type_a=bf16,type_b=f32,m=1056,n=1,k=129,bs=[4,1],nr=[1,1],per=[0,2,1,3],k_v=0,o=1)` |

**Likely root cause**

ROCjitsu's RDNA4 hardware-register table has no entry for ID 26, so `s_setreg_imm32_b32` against it is dropped with a warning, while the gfx1250 table models the same ID as `WAVE_SCHED_MODE`. These five `MUL_MAT` cases are the only corpus cases that emit the warning, and all five then take SIGSEGV. The missing table entry is a confirmed gap; that it causes these crashes is not established.

*Confidence: Confirmed ISA modeling gap; causal link to these five crashes unproven.*

**Evidence**

- [RDNA4 table without ID 26](https://github.com/ROCm/rocm-systems/blob/63a89f8f5cf0f25b98a76057bc00e4a98f88425d/emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/vm/amdgpu/hwreg.cpp#L259-L282) versus [gfx1250 table with `WAVE_SCHED_MODE`](https://github.com/ROCm/rocm-systems/blob/63a89f8f5cf0f25b98a76057bc00e4a98f88425d/emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/vm/amdgpu/hwreg.cpp#L284-L312).
- Case artifacts log `[rj warn] s_setreg_imm32_b32: unsupported hwreg=unknown id=26`; no other corpus case does.

Observed for `llama.gfx1201.backend_ops.MUL_MAT.7bcc11c86355`:

```
[rj warn] s_setreg_imm32_b32: unsupported hwreg=unknown id=26
```

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx1201_r9700.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'MUL_MAT(type_a=f16,type_b=f32,m=1056,n=1,k=129,bs=[4,1],nr=[1,1],per=[0,2,1,3],k_v=0,o=1)' \
  -b ROCm0 -j 1 --output csv
```

### 12. CDNA `XIELU` returns wrong values

`cdna.xielu` — 4 tests on gfx942, gfx950 (4 test-failure)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx942.backend_ops.XIELU.925694f8c916` | `XIELU(type=f16,ne=[10,5,4,3])` |
| `llama.gfx942.backend_ops.XIELU.dc6e5386ba70` | `XIELU(type=f32,ne=[10,5,4,3])` |
| `llama.gfx950.backend_ops.XIELU.925694f8c916` | `XIELU(type=f16,ne=[10,5,4,3])` |
| `llama.gfx950.backend_ops.XIELU.dc6e5386ba70` | `XIELU(type=f32,ne=[10,5,4,3])` |

**Likely root cause**

Both f16 and f32 `XIELU` cases fail identically on gfx942 and gfx950 with error several orders above tolerance. XIELU is dominated by exponential and comparison-select math, so a transcendental or select-path defect on CDNA is the leading suspect. gfx942 and gfx950 fail on exactly the same case strings, so the defect is in a shared CDNA path rather than in one target's model.

*Confidence: Likely ROCjitsu defect; medium-high.*

**Evidence**

- `XIELU.925694f8c916` reports `ERR = 8.626576297` against a 1e-7 tolerance.
- `RJ_FORCE_SCALAR=1` reproduces all four failures unchanged, so the SIMD transcendental fast path is not the cause.
- Additional traces: `debug/gfx950-xielu-amd-log.log`, `debug/gfx950-xielu-clocked.log`.

Observed for `llama.gfx950.backend_ops.XIELU.925694f8c916`:

```
[XIELU] ERR = 8.626576297 > 0.000000100
```

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx950_cdna4.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'XIELU(type=f16,ne=[10,5,4,3])' \
  -b ROCm0 -j 1 --output csv
```

### 13. gfx1201 `OUT_PROD` faults on an unbacked GPU address

`gfx1201.matrix-crash-surface.OUT_PROD` — 2 tests on gfx1201 (2 segfault)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx1201.backend_ops.OUT_PROD.7eb05239af23` | `OUT_PROD(type_a=f32,type_b=f32,m=256,n=1,k=1,bs=[1,1],nr=[1,2],trans_b=0)` |
| `llama.gfx1201.backend_ops.OUT_PROD.f35a3e5a1843` | `OUT_PROD(type_a=f32,type_b=f32,m=256,n=1,k=1,bs=[1,1],nr=[1,1],trans_b=0)` |

**Likely root cause**

The simulator computes an operand address that no VMID page-table entry backs, then dereferences the GPU virtual address as a host pointer and takes SIGSEGV. The fallback explains how the process dies; it does not identify which earlier address computation produced the bad address. One of the two cases, `nr=[1,2]`, returns wrong values instead of crashing on gfx942 and gfx950, so the same operand shape is mishandled on three targets with two symptoms.

*Confidence: Confirmed ROCjitsu crash; separate operator route.*

**Evidence**

- Shared fault path: [`gpu_memory.h`](https://github.com/ROCm/rocm-systems/blob/63a89f8f5cf0f25b98a76057bc00e4a98f88425d/emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/vm/amdgpu/gpu_memory.h#L484-L511).
- `OUT_PROD(...,nr=[1,2],...)` appears in the CDNA BLAS-surface group above as a wrong-result failure.
- Not fixed by [rocm-systems#9003](https://github.com/ROCm/rocm-systems/pull/9003).

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx1201_r9700.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'OUT_PROD(type_a=f32,type_b=f32,m=256,n=1,k=1,bs=[1,1],nr=[1,1],trans_b=0)' \
  -b ROCm0 -j 1 --output csv
```

### 14. gfx1201 `SOLVE_TRI` faults on an unbacked GPU address

`gfx1201.matrix-crash-surface.SOLVE_TRI` — 2 tests on gfx1201 (2 segfault)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx1201.backend_ops.SOLVE_TRI.4b2665c93c4f` | `SOLVE_TRI(type=f32,ne_lhs=[128,128,4,1],ne_rhs=[32,128,4,1])` |
| `llama.gfx1201.backend_ops.SOLVE_TRI.efce0cf0e0d3` | `SOLVE_TRI(type=f32,ne_lhs=[84,84,4,4],ne_rhs=[32,84,4,4])` |

**Likely root cause**

The simulator computes an operand address that no VMID page-table entry backs, then dereferences the GPU virtual address as a host pointer and takes SIGSEGV. The fallback explains how the process dies; it does not identify which earlier address computation produced the bad address. Both case strings return wrong values instead of crashing on gfx942 and gfx950, so the same operand shapes are mishandled on three targets with two symptoms.

*Confidence: Confirmed ROCjitsu crash; separate operator route.*

**Evidence**

- Shared fault path: [`gpu_memory.h`](https://github.com/ROCm/rocm-systems/blob/63a89f8f5cf0f25b98a76057bc00e4a98f88425d/emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/vm/amdgpu/gpu_memory.h#L484-L511).
- Both case strings appear in the CDNA BLAS-surface group above as wrong-result failures.
- Not fixed by [rocm-systems#9003](https://github.com/ROCm/rocm-systems/pull/9003).

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx1201_r9700.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'SOLVE_TRI(type=f32,ne_lhs=[128,128,4,1],ne_rhs=[32,128,4,1])' \
  -b ROCm0 -j 1 --output csv
```

### 15. gfx1201 `RMS_NORM_BACK` fails at every tested shape

`gfx1201.rms-reduction` — 2 tests on gfx1201 (1 segfault, 1 test-failure)

**Affected tests**

| Test ID | Outcome | Case |
| --- | --- | --- |
| `llama.gfx1201.backend_ops.RMS_NORM_BACK.738357150297` | test-failure | `RMS_NORM_BACK(type=f32,ne=[64,5,4,3],eps=0.000000)` |
| `llama.gfx1201.backend_ops.RMS_NORM_BACK.b0eca1729a88` | segfault | `RMS_NORM_BACK(type=f32,ne=[1025,5,4,3],eps=0.000000)` |

**Likely root cause**

Both `RMS_NORM_BACK` cases in the inventory fail on gfx1201 and both pass on the other three targets. The 64-wide shape returns wrong values and the 1025-wide shape crashes, so row width changes the symptom but not the presence of the defect. The corpus offers no narrower shape to bisect against, so the failing computation is not localized.

*Confidence: Reproducible gfx1201-only defect; root cause not localized.*

**Evidence**

- Both of the inventory's two `RMS_NORM_BACK` cases fail on gfx1201 and pass on gfx942, gfx950, and gfx1100.

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx1201_r9700.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'RMS_NORM_BACK(type=f32,ne=[1025,5,4,3],eps=0.000000)' \
  -b ROCm0 -j 1 --output csv
```

### 16. gfx942 `OPT_STEP_ADAMW` returns wrong values

`unmerged.gfx942.OPT_STEP_ADAMW` — 1 test on gfx942 (1 test-failure)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx942.backend_ops.OPT_STEP_ADAMW.53563ed7ba67` | `OPT_STEP_ADAMW(type=f32,ne=[10,5,4,3])` |

**Likely root cause**

One f32 `OPT_STEP_ADAMW` case fails. The identical case fails on gfx950, so this and the gfx950 entry are very likely the same CDNA defect, but they are reported separately because no shared code path has been confirmed.

*Confidence: Reproducible failure; root cause not investigated.*

**Evidence**

- The same case string fails on gfx950 and passes on RDNA.

Observed for `llama.gfx942.backend_ops.OPT_STEP_ADAMW.53563ed7ba67`:

```
[OPT_STEP_ADAMW] ERR = 0.487972178 > 0.000000100
```

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx942_cdna3.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'OPT_STEP_ADAMW(type=f32,ne=[10,5,4,3])' \
  -b ROCm0 -j 1 --output csv
```

### 17. gfx950 `OPT_STEP_ADAMW` returns wrong values

`unmerged.gfx950.OPT_STEP_ADAMW` — 1 test on gfx950 (1 test-failure)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx950.backend_ops.OPT_STEP_ADAMW.53563ed7ba67` | `OPT_STEP_ADAMW(type=f32,ne=[10,5,4,3])` |

**Likely root cause**

Counterpart of the gfx942 `OPT_STEP_ADAMW` failure with an identical case string.

*Confidence: Reproducible failure; root cause not investigated.*

**Evidence**

- The same case string fails on gfx942 and passes on RDNA.

Observed for `llama.gfx950.backend_ops.OPT_STEP_ADAMW.53563ed7ba67`:

```
[OPT_STEP_ADAMW] ERR = 0.009307124 > 0.000000100
```

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx950_cdna4.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'OPT_STEP_ADAMW(type=f32,ne=[10,5,4,3])' \
  -b ROCm0 -j 1 --output csv
```

### 18. gfx942 bicubic `UPSCALE` with `align_corners` is wrong

`unmerged.gfx942.UPSCALE` — 1 test on gfx942 (1 test-failure)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx942.backend_ops.UPSCALE.f4497e2354a8` | `UPSCALE(type=f32,ne=[4,1,3,2],ne_tgt=[1,1,3,2],mode=bicubic|align_corners)` |

**Likely root cause**

One `mode=bicubic|align_corners` case that downscales to `ne_tgt=[1,1,3,2]` fails. The identical case fails on gfx950, so the bicubic coefficient or clamp handling for degenerate target extents is the suspect.

*Confidence: Reproducible failure; root cause not investigated.*

**Evidence**

- The same case string fails on gfx950 and passes on RDNA.

Observed for `llama.gfx942.backend_ops.UPSCALE.f4497e2354a8`:

```
[UPSCALE] ERR = 1.067948595 > 0.000000100
```

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx942_cdna3.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'UPSCALE(type=f32,ne=[4,1,3,2],ne_tgt=[1,1,3,2],mode=bicubic|align_corners)' \
  -b ROCm0 -j 1 --output csv
```

### 19. gfx950 bicubic `UPSCALE` with `align_corners` is wrong

`unmerged.gfx950.UPSCALE` — 1 test on gfx950 (1 test-failure)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx950.backend_ops.UPSCALE.f4497e2354a8` | `UPSCALE(type=f32,ne=[4,1,3,2],ne_tgt=[1,1,3,2],mode=bicubic|align_corners)` |

**Likely root cause**

Counterpart of the gfx942 `UPSCALE` failure with an identical case string.

*Confidence: Reproducible failure; root cause not investigated.*

**Evidence**

- The same case string fails on gfx942 and passes on RDNA.

Observed for `llama.gfx950.backend_ops.UPSCALE.f4497e2354a8`:

```
[UPSCALE] ERR = 1.067948673 > 0.000000100
```

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx950_cdna4.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'UPSCALE(type=f32,ne=[4,1,3,2],ne_tgt=[1,1,3,2],mode=bicubic|align_corners)' \
  -b ROCm0 -j 1 --output csv
```

## Cross-cutting crash mechanism: host SIGSEGV after an unresolved GPU address

82 of the failures above die the same way (gfx1100: 21, gfx1201: 61). This section describes the shared mechanism; the initiating defects stay in their own sections because they differ per group.

When a VMID page-table walk misses and passthrough is enabled, ROCjitsu casts the unresolved GPU virtual address to a host pointer and hands it to `memcpy()` inside `GpuMemory::read_mapped()` ([source](https://github.com/ROCm/rocm-systems/blob/63a89f8f5cf0f25b98a76057bc00e4a98f88425d/emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/vm/amdgpu/gpu_memory.h#L484-L511)). In both GDB reproductions the faulting source address was absent from `/proc/<pid>/maps` while the destination was writable, confirming the read side is the bad pointer.

*Confidence: confirmed crash mechanism; not the initiating cause of any group.*

Two facts bound the scope:

- The pending local-memory work in [rocm-systems#9003](https://github.com/ROCm/rocm-systems/pull/9003) adds a backing resolver but still falls through to the same raw pointer when no backing range matches. Rebuilding on that branch left all 82 crashes and every other persistent failure unchanged.
- The fallback only converts an already-wrong address into a host fault. Fixing it would turn these crashes into diagnosable errors, but the address computations that produce unbacked addresses would still be wrong.

Supporting logs: `debug/gfx1100-flash-attn-gdb-aslr.log`, `debug/gfx1201-mul-mat-gdb-aslr.log`, `debug/gfx1201-mul-mat-fixed-gdb-aslr.log`, `debug/gfx1201-mul-mat-fixed-mappings.log`.

## Not correctness defects: 15 timeouts

These cases exhausted the 60-second per-case budget. For the 14 throughput cases the kernels have finite trip counts and the simulator burns CPU throughout, so they are simulation cost rather than deadlock; the last entry is a scheduling artifact rather than a slow case. They are listed for completeness and for anyone tuning corpus timeouts.

### 1. `MUL_MAT_ID_FUSION` exceeds the 60 s per-case budget

`timeout.throughput.MUL_MAT_ID_FUSION` — 6 tests on gfx1100, gfx1201 (6 timeout)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx1100.backend_ops.MUL_MAT_ID_FUSION.b3d0befaa714` | `MUL_MAT_ID_FUSION(type_a=q4_0,type_b=f32,n_mats=128,n_used=8,b=0,m=768,n=512,k=2048,o=1,mul=1)` |
| `llama.gfx1100.backend_ops.MUL_MAT_ID_FUSION.dfb1ed5ca4e9` | `MUL_MAT_ID_FUSION(type_a=q4_K,type_b=f32,n_mats=128,n_used=8,b=0,m=768,n=512,k=2048,o=1,mul=1)` |
| `llama.gfx1100.backend_ops.MUL_MAT_ID_FUSION.f6f7601c1c97` | `MUL_MAT_ID_FUSION(type_a=f16,type_b=f32,n_mats=128,n_used=8,b=0,m=768,n=512,k=2048,o=1,mul=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT_ID_FUSION.b3d0befaa714` | `MUL_MAT_ID_FUSION(type_a=q4_0,type_b=f32,n_mats=128,n_used=8,b=0,m=768,n=512,k=2048,o=1,mul=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT_ID_FUSION.dfb1ed5ca4e9` | `MUL_MAT_ID_FUSION(type_a=q4_K,type_b=f32,n_mats=128,n_used=8,b=0,m=768,n=512,k=2048,o=1,mul=1)` |
| `llama.gfx1201.backend_ops.MUL_MAT_ID_FUSION.f6f7601c1c97` | `MUL_MAT_ID_FUSION(type_a=f16,type_b=f32,n_mats=128,n_used=8,b=0,m=768,n=512,k=2048,o=1,mul=1)` |

**Likely root cause**

Six fused expert-matmul cases on gfx1100 and gfx1201 do not finish within 60 seconds. The kernels have finite trip counts and the simulator stays on CPU throughout, so this is simulation cost rather than deadlock.

*Confidence: Simulator throughput limit; not a correctness defect.*

**Evidence**

- A 20-second sample of the comparable `LIGHTNING_INDEXER` timeout consumed 39.90 user seconds at 200% CPU (`debug/gfx1201-lightning-20s-time.log`), which is active execution, not a blocked wait.

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx1100_w7900.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'MUL_MAT_ID_FUSION(type_a=f16,type_b=f32,n_mats=128,n_used=8,b=0,m=768,n=512,k=2048,o=1,mul=1)' \
  -b ROCm0 -j 1 --output csv
```

### 2. `LIGHTNING_INDEXER` exceeds the 60 s per-case budget

`timeout.throughput.LIGHTNING_INDEXER` — 4 tests on gfx1100, gfx1201, gfx942, gfx950 (4 timeout)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx942.backend_ops.LIGHTNING_INDEXER.28d7def07117` | `LIGHTNING_INDEXER(hsk=128,nh=64,kv=256,nb=512,ns=4,nm=4,type_K=q4_0)` |
| `llama.gfx950.backend_ops.LIGHTNING_INDEXER.28d7def07117` | `LIGHTNING_INDEXER(hsk=128,nh=64,kv=256,nb=512,ns=4,nm=4,type_K=q4_0)` |
| `llama.gfx1100.backend_ops.LIGHTNING_INDEXER.28d7def07117` | `LIGHTNING_INDEXER(hsk=128,nh=64,kv=256,nb=512,ns=4,nm=4,type_K=q4_0)` |
| `llama.gfx1201.backend_ops.LIGHTNING_INDEXER.28d7def07117` | `LIGHTNING_INDEXER(hsk=128,nh=64,kv=256,nb=512,ns=4,nm=4,type_K=q4_0)` |

**Likely root cause**

The same `LIGHTNING_INDEXER` case times out on all four targets, which is the signature of a uniformly expensive kernel rather than a target-specific defect.

*Confidence: Simulator throughput limit; not a correctness defect.*

**Evidence**

- `debug/gfx1201-lightning-20s-time.log`: 39.90 user seconds and 200% CPU over a 20-second wall-clock window.

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx942_cdna3.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'LIGHTNING_INDEXER(hsk=128,nh=64,kv=256,nb=512,ns=4,nm=4,type_K=q4_0)' \
  -b ROCm0 -j 1 --output csv
```

### 3. Deep-batch `MUL_MAT` exceeds the 60 s per-case budget on CDNA

`timeout.throughput.MUL_MAT` — 2 tests on gfx942, gfx950 (2 timeout)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx942.backend_ops.MUL_MAT.462ccb738b08` | `MUL_MAT(type_a=f16,type_b=f16,m=16,n=8,k=256,bs=[1536,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |
| `llama.gfx950.backend_ops.MUL_MAT.462ccb738b08` | `MUL_MAT(type_a=f16,type_b=f16,m=16,n=8,k=256,bs=[1536,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)` |

**Likely root cause**

One `MUL_MAT` case with `bs=[1536,1]`, that is 1536 batched 16x8x256 products, times out on gfx942 and gfx950 while shallower batches of the same operator complete.

*Confidence: Simulator throughput limit; not a correctness defect.*

**Evidence**

- The same case string times out on both CDNA targets.
- On gfx1201 the same case string crashes instead, in the HWREG ID 26 group above.

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx950_cdna4.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'MUL_MAT(type_a=f16,type_b=f16,m=16,n=8,k=256,bs=[1536,1],nr=[1,1],per=[0,1,2,3],k_v=0,o=1)' \
  -b ROCm0 -j 1 --output csv
```

### 4. `MUL_MAT_ID` exceeds the 60 s per-case budget on gfx1100

`timeout.throughput.MUL_MAT_ID` — 2 tests on gfx1100 (2 timeout)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx1100.backend_ops.MUL_MAT_ID.4c6f0c369254` | `MUL_MAT_ID(type_a=q4_0,type_b=f32,n_mats=32,n_used=2,b=0,m=2880,n=32,k=2880)` |
| `llama.gfx1100.backend_ops.MUL_MAT_ID.dbedbadd142a` | `MUL_MAT_ID(type_a=mxfp4,type_b=f32,n_mats=32,n_used=2,b=0,m=2880,n=32,k=2880)` |

**Likely root cause**

Two expert-indexed matmul cases with `m=k=2880` exceed the budget on gfx1100 only and complete on the other three targets. No mechanism was investigated beyond confirming that the cost is CPU-bound simulation.

*Confidence: Simulator throughput limit; not a correctness defect.*

**Evidence**

- Both cases complete on gfx942, gfx950, and gfx1201.

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx1100_w7900.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'MUL_MAT_ID(type_a=q4_0,type_b=f32,n_mats=32,n_used=2,b=0,m=2880,n=32,k=2880)' \
  -b ROCm0 -j 1 --output csv
```

### 5. gfx1201 `RMS_NORM_MUL_ROPE` timed out only under load

`timeout.contention-candidate` — 1 test on gfx1201 (1 timeout)

**Affected tests**

| Test ID | Case |
| --- | --- |
| `llama.gfx1201.backend_ops.RMS_NORM_MUL_ROPE.92e31eecab55` | `RMS_NORM_MUL_ROPE(ne=[8192,2,2,1],eps=0.000001,multi_add=1,set_rows=1,mode=2)` |

**Likely root cause**

This case returns an ordinary numerical failure in the 30-second run and in the rocm-systems#9003 comparison run, and timed out only in the eight-worker 60-second run scheduled alongside three long fusion simulations. Treat it as host CPU contention. When it fails numerically it looks like the gfx1201 work-item Y group; it appears here rather than there because the outcome in the run this report covers was a timeout.

*Confidence: Not a timeout defect; scheduling artifact.*

**Evidence**

- Outcome differs by run phase: `test-failure` in the soft and fixed phases, `timeout` in the hard phase.

**Reproducer**

```bash
"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx1201_r9700.json" -- \
  "$CORPUS/corpus/llama/build/test-backend-ops" test \
  -o 'RMS_NORM_MUL_ROPE(ne=[8192,2,2,1],eps=0.000001,multi_add=1,set_rows=1,mode=2)' \
  -b ROCm0 -j 1 --output csv
```

## Hypotheses ruled out

- **The pending local-memory fix.** [rocm-systems#9003](https://github.com/ROCm/rocm-systems/pull/9003) resolves none of the persistent failures.
- **The SIMD executor fast paths.** Rerunning every wrong-result case with `RJ_FORCE_SCALAR=1` reproduced all of them unchanged, so the scalar and vector paths share the defects.
- **Flaky infrastructure.** Twelve cases that failed with a 30-second timeout passed at 60 seconds and are excluded from this report; everything reported here failed in both runs.
