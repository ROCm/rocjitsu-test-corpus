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

// --- LDS accesses in flight at a barrier ---
//
// A workgroup barrier makes each wave wait for the others to arrive. The
// CDNA5 ISA specifies no wait for a memory counter at a barrier signal (5.6
// and 15.3, S_BARRIER_SIGNAL), and rocjitsu models the single s_barrier of the
// other targets as a signal and a wait that coincide. So an LDS access a wave
// has not waited for is still in flight when the wave arrives, and the barrier
// orders nothing about it for the other waves. Another wave that passes the
// barrier and touches those
// bytes races with it, and the report of that race names the wave that
// arrived with the access in flight, the barrier, and the counter to wait for
// before it. A wave that leaves an access in flight and whose bytes no other
// wave touches has no race, and nothing is reported.

// The expectations are host code, so they cannot ask the device compiler which
// target this is; the build defines RACE_TARGET_SPLIT_BARRIER for the targets
// with s_barrier_signal and the split wait counters.
#ifdef RACE_TARGET_SPLIT_BARRIER
/// The instruction at which a wave arrives at the workgroup barrier.
constexpr const char *kBarrier = "s_barrier_signal -1";
/// The counter an LDS access completes on.
constexpr const char *kLdsCounter = "dscnt";
#else
constexpr const char *kBarrier = "s_barrier";
constexpr const char *kLdsCounter = "lgkmcnt";
#endif

/// Whether a wave waits for its LDS access before it arrives at the barrier.
enum class BarrierWait { Before, Missing };
/// Which slice a wave reads back after the barrier.
enum class ReadSlice { Own, Neighbour };

/// Each of two waves writes its own LDS slice, crosses the barrier and reads a
/// slice back. Reading its own slice, a wave conflicts with no other on any
/// schedule; reading its neighbour's, it depends on the barrier having ordered
/// the neighbour's write.
template <BarrierWait Wait, ReadSlice Read>
__attribute__((amdgpu_flat_work_group_size(64, 128))) __global__ void
write_barrier_read_kernel(unsigned *out) {
  __shared__ unsigned tile[128];
  const unsigned tid = threadIdx.x;
  const unsigned threads = 2 * warpSize;
  const unsigned address = static_cast<unsigned>(reinterpret_cast<uintptr_t>(&tile[tid]));
  const unsigned source =
      Read == ReadSlice::Own
          ? address
          : static_cast<unsigned>(reinterpret_cast<uintptr_t>(&tile[(tid + warpSize) % threads]));
  Lds::write(address, tid + 11);
  if constexpr (Wait == BarrierWait::Before)
    Lds::wait();
  Lds::barrier();
  out[tid] = Lds::read(source);
}

/// The values write_barrier_read_kernel() reads back.
std::vector<unsigned> writeBarrierReadValues(ReadSlice read) {
  const unsigned waveSize = hostWaveSize();
  const unsigned threads = 2 * waveSize;
  std::vector<unsigned> expected(threads);
  for (unsigned tid = 0; tid < threads; ++tid)
    expected[tid] = (read == ReadSlice::Own ? tid : (tid + waveSize) % threads) + 11;
  return expected;
}

TEST_F(BarrierRaceTest, neighbour_slot_write_waited) {
  const unsigned threads = 2 * hostWaveSize();
  unsigned *out = alloc<unsigned>(threads);
  write_barrier_read_kernel<BarrierWait::Before, ReadSlice::Neighbour><<<1, threads>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectValues(out, writeBarrierReadValues(ReadSlice::Neighbour));
  ExpectNoRace();
}

// Without the wait each write is in flight when its wave arrives at the
// barrier, so the barrier does not order it for the neighbour's read. Both
// waves run the same instructions, so the two races are one report.
TEST_F(BarrierRaceTest, neighbour_slot_write_in_flight_race) {
  const unsigned threads = 2 * hostWaveSize();
  write_barrier_read_kernel<BarrierWait::Missing, ReadSlice::Neighbour>
      <<<1, threads>>>(alloc<unsigned>(threads));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace({.kernel = "write_barrier_read_kernel",
              .type = "LDS",
              .access = "read",
              .lane = 0,
              .producer = "ds_",
              .between = "s_barrier",
              .consumer = "ds_",
              .barrier = kBarrier,
              .barrier_wait = kLdsCounter});
}

// The same missing wait with each wave reading back only its own slice. No
// access conflicts on any schedule, so it is not a race and nothing is
// reported.
TEST_F(BarrierRaceTest, own_slot_write_in_flight_is_not_reported) {
  const unsigned threads = 2 * hostWaveSize();
  unsigned *out = alloc<unsigned>(threads);
  write_barrier_read_kernel<BarrierWait::Missing, ReadSlice::Own><<<1, threads>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectValues(out, writeBarrierReadValues(ReadSlice::Own));
  ExpectNoRace();
}

/// Every wave loads wave 0's slice, which a first barrier has ordered, and
/// crosses a second barrier; wave 0 then overwrites its slice. A load in
/// flight at the second barrier is not ordered before that overwrite.
template <BarrierWait Wait>
__attribute__((amdgpu_flat_work_group_size(64, 128))) __global__ void
read_barrier_overwrite_kernel(unsigned *out) {
  __shared__ unsigned tile[128];
  const unsigned tid = threadIdx.x;
  const unsigned address = static_cast<unsigned>(reinterpret_cast<uintptr_t>(&tile[tid]));
  Lds::write(address, tid + 7);
  Lds::wait();
  Lds::barrier();
  const unsigned source = static_cast<unsigned>(reinterpret_cast<uintptr_t>(&tile[tid % warpSize]));
  unsigned value;
  if constexpr (Wait == BarrierWait::Before) {
    value = Lds::read(source);
    Lds::barrier();
  } else {
    value = Lds::readAcrossBarrier(source);
  }
  if (__builtin_amdgcn_readfirstlane(tid) < warpSize) {
    Lds::write(address, tid + 100);
    Lds::wait();
  }
  out[tid] = value;
}

TEST_F(BarrierRaceTest, read_waited_then_overwritten) {
  const unsigned waveSize = hostWaveSize();
  const unsigned threads = 2 * waveSize;
  unsigned *out = alloc<unsigned>(threads);
  read_barrier_overwrite_kernel<BarrierWait::Before><<<1, threads>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  std::vector<unsigned> expected(threads);
  for (unsigned tid = 0; tid < threads; ++tid)
    expected[tid] = tid % waveSize + 7;
  ExpectValues(out, expected);
  ExpectNoRace();
}

// Wave 1's load is in flight when wave 1 arrives at the second barrier, so the
// barrier does not order it before wave 0's overwrite. The report names wave
// 1, whose load it is.
TEST_F(BarrierRaceTest, read_in_flight_overwritten_race) {
  const unsigned threads = 2 * hostWaveSize();
  read_barrier_overwrite_kernel<BarrierWait::Missing><<<1, threads>>>(alloc<unsigned>(threads));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace({.kernel = "read_barrier_overwrite_kernel",
              .type = "LDS",
              .access = "write",
              .wave = 0,
              .lane = 0,
              .producer = "ds_",
              .consumer = "ds_",
              .barrier = kBarrier,
              .barrier_wave = 1,
              .barrier_wait = kLdsCounter});
}

/// Each wave writes its slice, waits for the write, and reads its neighbour's,
/// with no barrier at all.
__attribute__((amdgpu_flat_work_group_size(64, 128))) __global__ void
write_read_without_barrier_kernel(unsigned *out) {
  __shared__ unsigned tile[128];
  const unsigned tid = threadIdx.x;
  const unsigned threads = 2 * warpSize;
  Lds::write(static_cast<unsigned>(reinterpret_cast<uintptr_t>(&tile[tid])), tid + 11);
  Lds::wait();
  out[tid] = Lds::read(
      static_cast<unsigned>(reinterpret_cast<uintptr_t>(&tile[(tid + warpSize) % threads])));
}

// A race with no barrier between its accesses names none. Either wave can run
// first, so the race is reported at the read or at the write.
TEST_F(BarrierRaceTest, missing_barrier_race_names_no_barrier) {
  const unsigned threads = 2 * hostWaveSize();
  write_read_without_barrier_kernel<<<1, threads>>>(alloc<unsigned>(threads));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectAnyRace({{.kernel = "write_read_without_barrier_kernel",
                  .type = "LDS",
                  .access = "read",
                  .lane = 0,
                  .producer = "ds_",
                  .consumer = "ds_",
                  .no_barrier = true},
                 {.kernel = "write_read_without_barrier_kernel",
                  .type = "LDS",
                  .access = "write",
                  .lane = 0,
                  .producer = "ds_",
                  .consumer = "ds_",
                  .no_barrier = true}});
}

} // namespace
