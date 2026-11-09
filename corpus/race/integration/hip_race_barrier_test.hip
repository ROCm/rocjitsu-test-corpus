// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include "race_test_support.hpp"

#include <cstdint>
#include <vector>

namespace {

using BarrierRaceTest = rocjitsu::test::RaceTestBase;

unsigned hostWaveSize() {
  int device = 0, size = 0;
  RACE_HIP_CHECK(hipGetDevice(&device));
  RACE_HIP_CHECK(hipDeviceGetAttribute(&size, hipDeviceAttributeWarpSize, device));
  return size;
}

__device__ __forceinline__ void ldsWrite(unsigned address, unsigned value) {
#if defined(__gfx1250__)
  asm volatile("ds_store_b32 %0, %1" ::"v"(address), "v"(value) : "memory");
#else
  asm volatile("ds_write_b32 %0, %1" ::"v"(address), "v"(value) : "memory");
#endif
}

__device__ __forceinline__ void waitLds() {
#if defined(__gfx1250__)
  asm volatile("s_wait_dscnt 0" ::: "memory");
#else
  asm volatile("s_waitcnt lgkmcnt(0)" ::: "memory");
#endif
}

__device__ __forceinline__ unsigned barrierReadLds(unsigned address) {
  unsigned value;
#if defined(__gfx1250__)
  asm volatile("s_barrier_signal -1\n"
               "s_barrier_wait -1\n"
               "ds_load_b32 %0, %1\n"
               "s_wait_dscnt 0"
#else
  asm volatile("s_barrier\n"
               "ds_read_b32 %0, %1\n"
               "s_waitcnt lgkmcnt(0)"
#endif
               : "=v"(value)
               : "v"(address)
               : "memory");
  return value;
}

/// Exercise repeated workgroup barriers as whole waves finish at different
/// times. Each wave owns a separate LDS slice and runs wave_id + 1 iterations.
/// In each phase, every surviving wave writes its slice and waits for the
/// write. Wave p then ends in phase p; the survivors cross a barrier and read
/// wave p's slice.
///
/// \code
/// Phase   Waves that write   Wave that ends   Waves that barrier and read
///   0        0, 1, 2, 3            0                  1, 2, 3
///   1           1, 2, 3            1                     2, 3
///   2              2, 3            2                        3
///   3                 3            3                     none
/// \endcode
///
/// A workgroup barrier resolves after every wave has arrived or ended, ordering
/// the departing wave's waited write before the survivors' reads. From phase 1
/// onward, that final write follows a previous barrier, so it must be retired
/// at the next barrier even though its issuing wave has ended. Each phase
/// writes different values to the same slice, so the result checks detect stale
/// reads. Explicit ISA barriers exercise whole-wave termination;
/// __syncthreads() is a block-wide HIP collective. Explicit LDS operations also
/// prevent compiler-added waits from hiding the missing-wait control.
///
/// UnwaitedWave = -1 waits for every write. The racing control uses 2 to omit
/// only wave 2's final wait, after two successful barrier rounds. The third
/// barrier must leave that unwaited write pending, and wave 3 must report an
/// LDS read race.
template <int UnwaitedWave>
__attribute__((amdgpu_flat_work_group_size(128, 256))) __global__ void
staggered_wave_exit_kernel(unsigned *out) {
  __shared__ unsigned tile[256]; // Space for four waves of either supported size.
  const unsigned tid = threadIdx.x;
  const unsigned threads = 4 * warpSize;
  const int wave = __builtin_amdgcn_readfirstlane(tid) / warpSize;
  const unsigned address = static_cast<unsigned>(reinterpret_cast<uintptr_t>(&tile[tid]));
#pragma unroll 1
  for (int phase = 0; phase <= wave; ++phase) {
    ldsWrite(address, phase * threads + tid + 1);
    if (wave != UnwaitedWave || phase != wave)
      waitLds();
    if (phase == wave)
      return;

    const unsigned source = static_cast<unsigned>(
        reinterpret_cast<uintptr_t>(&tile[phase * warpSize + tid % warpSize]));
    out[phase * threads + tid] = barrierReadLds(source);
  }
}

TEST_F(BarrierRaceTest, staggered_wave_exit) {
  const unsigned waveSize = hostWaveSize();
  const unsigned threads = 4 * waveSize;
  unsigned *out = allocFilled<unsigned>(3 * threads, 0);
  staggered_wave_exit_kernel<-1><<<1, threads>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  std::vector<unsigned> expected(3 * threads, 0);
  for (unsigned phase = 0; phase < 3; ++phase)
    for (unsigned tid = (phase + 1) * waveSize; tid < threads; ++tid)
      expected[phase * threads + tid] = phase * threads + phase * waveSize + tid % waveSize + 1;
  ExpectValues(out, expected);
  ExpectNoRace();
}

TEST_F(BarrierRaceTest, staggered_wave_exit_race) {
  // Only wave 2 omits its final wait, after two successful barrier rounds.
  const unsigned threads = 4 * hostWaveSize();
  staggered_wave_exit_kernel<2><<<1, threads>>>(alloc<unsigned>(3 * threads));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace({.kernel = "staggered_wave_exit_kernel",
              .type = "LDS",
              .access = "read",
              .wave = 3,
              .lane = 0,
              .producer = "ds_",
              .consumer = "ds_"});
}

} // namespace
