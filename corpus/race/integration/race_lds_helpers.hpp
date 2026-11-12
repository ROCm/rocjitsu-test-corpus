// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#pragma once

#include <hip/hip_runtime.h>

namespace rocjitsu::test {

/// LDS instruction spelling and workgroup barrier protocol. Legacy covers
/// CDNA1-4 and RDNA1-3.5; Gfx12 covers RDNA4 and CDNA5, including gfx1251.
enum class LdsIsa { Legacy, Gfx12 };

inline constexpr LdsIsa kTargetLdsIsa =
    __builtin_amdgcn_processor_is("gfx1200") || __builtin_amdgcn_processor_is("gfx1201") ||
            __builtin_amdgcn_processor_is("gfx1250") || __builtin_amdgcn_processor_is("gfx1251")
        ? LdsIsa::Gfx12
        : LdsIsa::Legacy;

/// Explicit LDS operations for tests that need to control memory ordering.
/// Addresses are byte offsets in LDS, as obtained by truncating an LDS pointer.
/// The template discards instructions unsupported by the selected ISA; it does
/// not branch at runtime. The default selects the current compilation target.
template <LdsIsa Isa = kTargetLdsIsa> class LdsInstructions {
public:
  /// Issue a 32-bit store without waiting for completion. The memory clobber
  /// preserves its order relative to the other test operations.
  __device__ static __forceinline__ void write(unsigned address, unsigned value) {
    if constexpr (Isa == LdsIsa::Gfx12)
      asm volatile("ds_store_b32 %0, %1" ::"v"(address), "v"(value) : "memory");
    else
      asm volatile("ds_write_b32 %0, %1" ::"v"(address), "v"(value) : "memory");
  }

  /// Complete the issuing wave's LDS operations. This supplies no ordering
  /// between waves; that requires a suitable barrier.
  __device__ static __forceinline__ void wait() {
    if constexpr (Isa == LdsIsa::Gfx12)
      asm volatile("s_wait_dscnt 0" ::: "memory");
    else
      asm volatile("s_waitcnt lgkmcnt(0)" ::: "memory");
  }

  /// Issue a 32-bit load and wait before returning its value, so a missing
  /// cross-wave dependency reports an LDS race rather than a VGPR-use race.
  __device__ static __forceinline__ unsigned read(unsigned address) {
    unsigned value;
    if constexpr (Isa == LdsIsa::Gfx12)
      asm volatile("ds_load_b32 %0, %1\ns_wait_dscnt 0" : "=v"(value) : "v"(address) : "memory");
    else
      asm volatile("ds_read_b32 %0, %1\ns_waitcnt lgkmcnt(0)"
                   : "=v"(value)
                   : "v"(address)
                   : "memory");
    return value;
  }

  /// ISA workgroup rendezvous with no additional memory-counter waits.
  /// Each whole wave must arrive or terminate. A departing wave's s_endpgm
  /// implicitly waits for its memory operations; a continuing wave must wait
  /// explicitly before arriving if its preceding LDS accesses need ordering.
  /// This permits whole-wave exits and is not a HIP __syncthreads() collective.
  __device__ static __forceinline__ void barrier() {
    if constexpr (Isa == LdsIsa::Gfx12)
      asm volatile("s_barrier_signal -1\ns_barrier_wait -1" ::: "memory");
    else
      asm volatile("s_barrier" ::: "memory");
  }
};

} // namespace rocjitsu::test
