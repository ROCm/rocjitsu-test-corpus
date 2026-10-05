# Common PM4 scenarios and capability evidence

The scenario is the portable unit; the executable still targets a concrete GPU.
These tests exercise **MEC compute queues**, not the complete graphics PM4 ABI.
Public driver/test implementations document the packet subset used here; this
is not a claim of a complete PM4 specification for every CDNA or RDNA chip.

## Reference audit

- **KFDTest**: [PM4Packet.cpp](https://github.com/ROCm/rocm-systems/blob/5216a640f55d8bad7f9ec9489203dba6074fca9f/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/PM4Packet.cpp)
  selects AI (gfx9), NV (gfx10 through pre-gfx12.5), and GFX125X encodings for
  acquire/release packets. Its write, DMA and indirect-buffer builders share
  layouts. This is directly relevant to our direct-KFD compute queues.
- **IGT AMDGPU tests**: [amd_ip_blocks.c](https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/blob/5f6b3e4a1f60308ed068b61b4a6b3d7fac126bc8/lib/amdgpu/amd_ip_blocks.c), especially
  `setup_amdgpu_ip_blocks` and the write/wait/atomic emitters, reuses function
  tables across gfx7–gfx12 and selects ASIC-specific behavior where required.
  We follow that shared-scenario model without importing its DRM submission API.
- **Mesa/Vulkan**: [RADV command buffers](https://gitlab.freedesktop.org/mesa/mesa/-/blob/b39d173ca9369c19fda2635be6655d308067e52d/src/amd/vulkan/radv_cmd_buffer.c),
  [RADV command streams](https://gitlab.freedesktop.org/mesa/mesa/-/blob/b39d173ca9369c19fda2635be6655d308067e52d/src/amd/vulkan/radv_cs.c), and
  [common cache barriers](https://gitlab.freedesktop.org/mesa/mesa/-/blob/b39d173ca9369c19fda2635be6655d308067e52d/src/amd/common/ac_barrier.c) translate Vulkan operations
  into version-aware PM4. Vulkan specifies observable synchronization behavior;
  RADV provides the concrete RDNA packet implementation. Graphics-only
  workarounds and PFP behavior do not establish MEC requirements.
- **Linux AMDGPU**: [IB self-tests](https://github.com/torvalds/linux/blob/a90ee4305c4a5df72c11b31dacfdc76e00fcf78a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c) dispatch through each
  ring's test callbacks. The [gfx9 implementation](https://github.com/torvalds/linux/blob/a90ee4305c4a5df72c11b31dacfdc76e00fcf78a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c),
  [gfx9.4/gfx9.5 CDNA implementation](https://github.com/torvalds/linux/blob/a90ee4305c4a5df72c11b31dacfdc76e00fcf78a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c), and
  [gfx11 implementation](https://github.com/torvalds/linux/blob/a90ee4305c4a5df72c11b31dacfdc76e00fcf78a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c) expose compute fence, IB,
  cache-flush and ring-test programming. CDNA support here is grounded in those
  implementations, not extrapolated from Vulkan graphics support.

## Why there are three support directories

| Directory | Targets sharing this test subset | Actual difference |
| --- | --- | --- |
| `support/gfx9/` | gfx9.0, gfx9.4, gfx9.5, including CDNA | Seven-dword ACQUIRE_MEM with CP_COHER_CNTL; legacy RELEASE_MEM TC cache bits |
| `support/gfx11/` | gfx11 and gfx12.0 | Eight-dword GCR ACQUIRE_MEM and NV RELEASE_MEM layout |
| `support/gfx125/` | gfx12.5 | Revised GCR fields, explicit WRITE_DATA memory scope, dependency-wait offload policy |

The gfx11 directory name identifies the oldest supported member of its group.
KFDTest uses the NV release form before gfx12.5, including gfx11 and gfx12.0.
These GPUs need no separate directory for the MEC operations emitted here;
this does not imply that all their registers or graphics packets are identical.
Likewise Linux's gfx9.4/9.5 compute cache flush uses the same legacy acquire
layout as gfx9.0, so CDNA does not get a duplicate packet directory.
The selected fields are in `packets.h`; the common encoder owns lengths,
addresses and ordering. Scenarios never choose their GPU's packet fields.

## Capability boundaries

| Gate | Evidence and scope |
| --- | --- |
| `pm4` | KFDTest PM4 builders and Linux compute ring functions above; WRITE_DATA, COPY_DATA, ATOMIC_MEM, WAIT_REG_MEM, DMA_DATA, INDIRECT_BUFFER, CS_PARTIAL_FLUSH and ACQUIRE_MEM for these three groups |
| `pm4_wait64` | [ROCr PM4 definitions](https://github.com/ROCm/rocm-systems/blob/5216a640f55d8bad7f9ec9489203dba6074fca9f/projects/rocr-runtime/libhsakmt/include/impl/pm4_cmds.h), gfx9 and gfx10 `PM4_MEC_WAIT_REG_MEM64`; nine dwords with full 64-bit value/mask, opcode 0x93. The existing gfx12 scenarios use the same form. |
| `pm4_release_mem` | KFDTest `PM4ReleaseMemoryPacket` and Linux `ring_emit_fence`; eight-dword release, group-specific cache control, 64-bit data and write-confirmed interrupt selection |
| `aql_pm4_ib` | [ROCr AqlQueue::ExecutePM4](https://github.com/ROCm/rocm-systems/blob/5216a640f55d8bad7f9ec9489203dba6074fca9f/projects/rocr-runtime/runtime/hsa-runtime/core/runtime/amd_aql_queue.cpp) selects vendor format 1 for ISA major >= 9; the IB body uses the chosen PM4 group |
| `pm4_wait_offload` | [gfx12.5 MEC definitions](https://github.com/ROCm/rocm-systems/blob/5216a640f55d8bad7f9ec9489203dba6074fca9f/projects/rocr-runtime/libhsakmt/tests/kfdtest/include/pm4_pkt_struct_gfx125x.h) and KFDTest wait builder define `optimize_ace_offload_mode`; enabled for dependency waits on gfx1250 following the existing verified suite. The disabled-offload variant remains a skipped reproducer. This gate describes the tested policy, not the earliest hardware exposing the bit. |
| `aql_metadata` | [ROCr queue implementation](https://github.com/ROCm/rocm-systems/blob/5216a640f55d8bad7f9ec9489203dba6074fca9f/projects/rocr-runtime/runtime/hsa-runtime/core/runtime/amd_aql_queue.cpp) and [AMD HSA extensions](https://github.com/ROCm/rocm-systems/blob/5216a640f55d8bad7f9ec9489203dba6074fca9f/projects/rocr-runtime/runtime/hsa-runtime/inc/hsa_ext_amd.h); gfx1250 companion metadata and KFD 1.19 queue tail |
| `sdma_signal64` | [ROCr SDMA implementation](https://github.com/ROCm/rocm-systems/blob/5216a640f55d8bad7f9ec9489203dba6074fca9f/projects/rocr-runtime/runtime/hsa-runtime/core/runtime/amd_blit_sdma.cpp); gfx12.5 native 64-bit poll/fence packets |
| `wave32_scratch`, `wgp_placement` | [ROCr scratch setup](https://github.com/ROCm/rocm-systems/blob/5216a640f55d8bad7f9ec9489203dba6074fca9f/projects/rocr-runtime/runtime/hsa-runtime/core/runtime/amd_aql_queue.cpp) and [KFDTest identity shaders](https://github.com/ROCm/rocm-systems/blob/5216a640f55d8bad7f9ec9489203dba6074fca9f/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/ShaderStore.cpp); our helpers implement gfx12 layouts only, so these tests skip on gfx9/gfx11 |

Capability selection lives in `../cmake/Platforms.cmake`. Both shared manifests
use `requires`; the generated inventory preserves coverage checking and
reports unsupported scenarios as skips. Existing fault/hang skips are separate
from capability availability. No new group should be enabled solely because
its GPU name resembles an existing target.

## Shared KFD/AQL/SDMA support

[ROCr queues.c](https://github.com/ROCm/rocm-systems/blob/5216a640f55d8bad7f9ec9489203dba6074fca9f/projects/rocr-runtime/libhsakmt/src/queues.c) documents queue context sizing,
per-XCC headers, doorbells and the sysfs-size override. The fallback uses
wave64 limits and VGPR capacities for gfx9/CDNA and the corresponding gfx11/12
capacities; kernels are compiled separately for each concrete ISA.
[HSA packet definitions](https://github.com/ROCm/rocm-systems/blob/5216a640f55d8bad7f9ec9489203dba6074fca9f/projects/rocr-runtime/runtime/hsa-runtime/inc/hsa.h) define common AQL
packets. Compiler target support does not imply native GPU verification.

[ROCr SDMA builders](https://github.com/ROCm/rocm-systems/blob/5216a640f55d8bad7f9ec9489203dba6074fca9f/projects/rocr-runtime/runtime/hsa-runtime/core/runtime/amd_blit_sdma.cpp)
and [packet definitions](https://github.com/ROCm/rocm-systems/blob/5216a640f55d8bad7f9ec9489203dba6074fca9f/projects/rocr-runtime/runtime/hsa-runtime/core/inc/sdma_registers.h)
show that gfx9 omits GCR, gfx11/gfx12.0 use five-dword GCR, and gfx12.5 uses
six-dword GCR with revised control fields and memory scope. Fence fields also
vary by generation. These small selections live in `../common/support/sdma.h`;
they do not require duplicate scenario or PM4 directories. Submissions use
256-byte alignment on gfx9, covering early SDMA's minimum submission size.

See [the suite README](../README.md) for build, CPU and native validation records.
