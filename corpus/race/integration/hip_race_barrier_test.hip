// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include "race_lds_helpers.hpp"
#include "race_test_support.hpp"

#include <cstdint>
#include <vector>

namespace {

using Lds = rocjitsu::test::LdsInstructions<>;
enum class ExitWait { Explicit, Implicit };
enum class ReadOrder { AfterBarrier, BeforeBarrier };

/// Host-side wave size for launches and expected values; device code uses warpSize.
unsigned hostWaveSize() {
  int device = 0, size = 0;
  RACE_HIP_CHECK(hipGetDevice(&device));
  RACE_HIP_CHECK(hipDeviceGetAttribute(&size, hipDeviceAttributeWarpSize, device));
  return size;
}

/// Wave 1 writes its LDS slice and ends; wave 0 reads it after a workgroup
/// barrier. Both an explicit wait and s_endpgm's implicit wait make the write
/// complete before that barrier resolves. Reading before the barrier races.
template <ExitWait Wait, ReadOrder Order = ReadOrder::AfterBarrier>
__attribute__((amdgpu_flat_work_group_size(64, 128))) __global__ void
exited_lds_writer_kernel(unsigned *out) {
  __shared__ unsigned tile[128];
  const unsigned tid = threadIdx.x;
  const unsigned address = static_cast<unsigned>(reinterpret_cast<uintptr_t>(&tile[tid]));
  if (__builtin_amdgcn_readfirstlane(tid) >= warpSize) {
    Lds::write(address, tid + 11);
    if constexpr (Wait == ExitWait::Explicit)
      Lds::wait();
    return;
  }
  if constexpr (Order == ReadOrder::AfterBarrier)
    Lds::barrier();
  const unsigned value = Lds::read(address + warpSize * sizeof(unsigned));
  if constexpr (Order == ReadOrder::BeforeBarrier)
    Lds::barrier();
  out[tid] = value;
}

/// Exercise repeated workgroup barriers as whole waves finish at different times.
/// Each wave owns an LDS slice and runs wave_id + 1 iterations. In phase p,
/// every surviving wave writes its slice. Wave p ends; the survivors wait for
/// their writes, cross a barrier, and read wave p's final slice.
///
/// \code
/// Phase   Waves that write   Wave that ends   Waves that barrier and read
///   0        0, 1, 2, 3            0                  1, 2, 3
///   1           1, 2, 3            1                     2, 3
///   2              2, 3            2                        3
///   3                 3            3                     none
/// \endcode
///
/// The departing wave completes its write through an explicit wait or the
/// implicit wait in s_endpgm. The next workgroup barrier orders that write
/// before the survivors' reads. From phase 1 onward, the final write follows
/// a previous barrier, so it needs retirement at the next barrier even though
/// its issuing wave has ended. Phase-specific values detect stale reads.
///
/// EarlyReadPhase = -1 keeps every read after its barrier. The racing control
/// uses 2: after two successful rounds, wave 3 reads wave 2's final slice before
/// the third barrier. Either the read or the write can report the LDS conflict,
/// depending on execution order. Ending wave 2 alone supplies no synchronization
/// with that early read.
template <ExitWait Wait, int EarlyReadPhase = -1>
__attribute__((amdgpu_flat_work_group_size(128, 256))) __global__ void
staggered_wave_exit_kernel(unsigned *out) {
  __shared__ unsigned tile[256]; // Space for four waves of either supported size.
  const unsigned tid = threadIdx.x;
  const unsigned threads = 4 * warpSize;
  const int wave = __builtin_amdgcn_readfirstlane(tid) / warpSize;
  const unsigned address = static_cast<unsigned>(reinterpret_cast<uintptr_t>(&tile[tid]));
#pragma unroll 1
  for (int phase = 0; phase <= wave; ++phase) {
    Lds::write(address, phase * threads + tid + 1);
    if (Wait == ExitWait::Explicit || phase != wave)
      Lds::wait();
    if (phase == wave)
      return;

    const unsigned source = static_cast<unsigned>(
        reinterpret_cast<uintptr_t>(&tile[phase * warpSize + tid % warpSize]));
    if (phase != EarlyReadPhase)
      Lds::barrier();
    const unsigned value = Lds::read(source);
    if (phase == EarlyReadPhase)
      Lds::barrier();
    out[phase * threads + tid] = value;
  }
}

class BarrierRaceTest : public rocjitsu::test::RaceTestBase {
protected:
  template <ExitWait Wait> void checkExitedWriter() {
    const unsigned waveSize = hostWaveSize();
    unsigned *out = alloc<unsigned>(waveSize);
    exited_lds_writer_kernel<Wait><<<1, 2 * waveSize>>>(out);
    RACE_HIP_CHECK(hipGetLastError());
    sync();
    std::vector<unsigned> expected(waveSize);
    for (unsigned tid = 0; tid < waveSize; ++tid)
      expected[tid] = waveSize + tid + 11;
    ExpectValues(out, expected);
    ExpectNoRace();
  }

  template <ExitWait Wait> void checkStaggeredExits() {
    const unsigned waveSize = hostWaveSize();
    const unsigned threads = 4 * waveSize;
    unsigned *out = allocFilled<unsigned>(3 * threads, 0);
    staggered_wave_exit_kernel<Wait><<<1, threads>>>(out);
    RACE_HIP_CHECK(hipGetLastError());
    sync();
    std::vector<unsigned> expected(3 * threads, 0);
    for (unsigned phase = 0; phase < 3; ++phase)
      for (unsigned tid = (phase + 1) * waveSize; tid < threads; ++tid)
        expected[phase * threads + tid] = phase * threads + phase * waveSize + tid % waveSize + 1;
    ExpectValues(out, expected);
    ExpectNoRace();
  }
};

TEST_F(BarrierRaceTest, exited_lds_writer) { checkExitedWriter<ExitWait::Explicit>(); }

TEST_F(BarrierRaceTest, exited_lds_writer_implicit_wait) {
  checkExitedWriter<ExitWait::Implicit>();
}

TEST_F(BarrierRaceTest, exited_lds_writer_race) {
  const unsigned waveSize = hostWaveSize();
  exited_lds_writer_kernel<ExitWait::Implicit, ReadOrder::BeforeBarrier>
      <<<1, 2 * waveSize>>>(alloc<unsigned>(waveSize));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectAnyRace({{.kernel = "exited_lds_writer_kernel",
                  .type = "LDS",
                  .access = "read",
                  .wave = 0,
                  .lane = 0,
                  .producer = "ds_",
                  .consumer = "ds_"},
                 {.kernel = "exited_lds_writer_kernel",
                  .type = "LDS",
                  .access = "write",
                  .wave = 1,
                  .lane = 0,
                  .producer = "ds_",
                  .consumer = "ds_"}});
}

TEST_F(BarrierRaceTest, staggered_wave_exit) { checkStaggeredExits<ExitWait::Explicit>(); }

TEST_F(BarrierRaceTest, staggered_wave_exit_implicit_wait) {
  checkStaggeredExits<ExitWait::Implicit>();
}

TEST_F(BarrierRaceTest, staggered_wave_exit_race) {
  const unsigned threads = 4 * hostWaveSize();
  staggered_wave_exit_kernel<ExitWait::Implicit, 2><<<1, threads>>>(alloc<unsigned>(3 * threads));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectAnyRace({{.kernel = "staggered_wave_exit_kernel",
                  .type = "LDS",
                  .access = "read",
                  .wave = 3,
                  .lane = 0,
                  .producer = "ds_",
                  .consumer = "ds_"},
                 {.kernel = "staggered_wave_exit_kernel",
                  .type = "LDS",
                  .access = "write",
                  .wave = 2,
                  .lane = 0,
                  .producer = "ds_",
                  .consumer = "ds_"}});
}

} // namespace
