// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "race_test_support.hpp"

#include <cstdint>
#include <vector>

namespace {

using Gfx1250RaceTest = rocjitsu::test::RaceTestBase;
using rocjitsu::test::FindingCount;
using rocjitsu::test::RaceExpectation;

// These kernels are safe, but the detector reports races because it does not
// carry the leaving wave's completed LDS accesses through S_BARRIER_LEAVE.
// The tests deliberately expect those false reports so they pass with the
// current detector. Once LEAVE ordering is modeled, all three ExpectRace
// assertions should become ExpectNoRace. The data checks should stay.
//
// In each kernel, A, B and C mean waves 0, 1 and 2. All three join the same
// named barrier. Its threshold counts arrivals, not joined waves: JOIN does
// not increase it. LEAVE stops listening and decreases the threshold by one,
// which can complete the round. It does not wait for LDS accesses to finish.
// See CDNA5 ISA (27 July 2026), 5.6 Table 22 and S_BARRIER_LEAVE in 15.5.
constexpr int kWave = 32;
constexpr int kThreads = 3 * kWave;
constexpr int kTileBytes = kWave * sizeof(int);

__device__ int wave() { return __builtin_amdgcn_readfirstlane(threadIdx.x) / kWave; }
__device__ int lane() { return threadIdx.x % kWave; }
__device__ uint32_t tileSlot() { return lane() * sizeof(int); }
__device__ void waitDscnt() { asm volatile("s_wait_dscnt 0" ::: "memory"); }
__device__ void workgroupBarrier() {
  asm volatile("s_barrier_signal -1\ns_barrier_wait -1" ::: "memory");
}
__device__ void namedWait() { asm volatile("s_barrier_wait 1" ::: "memory"); }
__device__ void ldsWrite(uint32_t address, int value) {
  asm volatile("ds_store_b32 %0, %1" ::"v"(address), "v"(value) : "memory");
}
__device__ int ldsReadAndWait(uint32_t address) {
  int value;
  asm volatile("ds_load_b32 %0, %1\ns_wait_dscnt 0" : "=v"(value) : "v"(address) : "memory");
  return value;
}

std::vector<int> tileValues() {
  std::vector<int> result(kWave);
  for (int i = 0; i < kWave; ++i)
    result[i] = 100 + i;
  return result;
}

constexpr RaceExpectation kFalseRawReport{
    .findings = FindingCount::One,
    .type = "LDS",
    .access = "read",
    .producer = "ds_store_b32",
    .consumer = "ds_load_b32",
};
constexpr RaceExpectation kFalseWarReport{
    .findings = FindingCount::One,
    .type = "LDS",
    .access = "write",
    .producer = "ds_load_b32",
    .consumer = "ds_store_b32",
};

// A signals once. B completes its write, then leaves. C waits, then reads.
//
// The threshold starts at two, but only A signals. C therefore cannot pass
// its wait until B's LEAVE reduces the threshold to one. This holds whether
// A signals before or after B leaves. B's write is complete before it leaves,
// so C reads the completed write. The detector's RAW report is a false positive.
// The workgroup barriers only establish setup and keep waves alive until the
// tested accesses finish; the named barrier provides the ordering between them.
__global__ __attribute__((amdgpu_flat_work_group_size(kThreads, kThreads))) void
named_leave_writer_kernel(int *out) {
  __shared__ __amdgpu_named_workgroup_barrier_t ready;
  if (wave() == 0)
    __builtin_amdgcn_s_barrier_init(&ready, 2);
  __builtin_amdgcn_s_barrier_join(&ready);
  workgroupBarrier();

  if (wave() == 0) {
    __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
  } else if (wave() == 1) {
    ldsWrite(tileSlot(), 100 + lane());
    waitDscnt();
    asm volatile("s_barrier_leave\ns_wait_kmcnt 0" ::: "scc", "memory");
  } else {
    namedWait();
    out[lane()] = ldsReadAndWait(tileSlot());
  }
  workgroupBarrier();
}

TEST_F(Gfx1250RaceTest, named_leave_orders_writer) {
  int *out = allocFilled<int>(kWave, -7);
  named_leave_writer_kernel<<<1, kThreads, kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kFalseRawReport);
  ExpectValues(out, tileValues());
}

// A signals once. B signals, then completes a write, then leaves. C waits
// before reading B's tile.
//
// The threshold starts at three. A and B provide only two signals, so B's
// LEAVE must lower the threshold to two before C can pass its wait. B's write
// is complete by then. The earlier signal does not cover B's later write,
// but the necessary LEAVE does. Recording only B's state at its signal misses
// this ordering and produces the false RAW report.
__global__ __attribute__((amdgpu_flat_work_group_size(kThreads, kThreads))) void
named_signal_then_leave_kernel(int *out) {
  __shared__ __amdgpu_named_workgroup_barrier_t ready;
  if (wave() == 0)
    __builtin_amdgcn_s_barrier_init(&ready, 3);
  __builtin_amdgcn_s_barrier_join(&ready);
  workgroupBarrier();

  if (wave() == 0) {
    __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
  } else if (wave() == 1) {
    __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
    ldsWrite(tileSlot(), 100 + lane());
    waitDscnt();
    asm volatile("s_barrier_leave\ns_wait_kmcnt 0" ::: "scc", "memory");
  } else {
    namedWait();
    out[lane()] = ldsReadAndWait(tileSlot());
  }
  workgroupBarrier();
}

TEST_F(Gfx1250RaceTest, named_signal_then_leave_orders_later_write) {
  int *out = allocFilled<int>(kWave, -7);
  named_signal_then_leave_kernel<<<1, kThreads, kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kFalseRawReport);
  ExpectValues(out, tileValues());
}

// A signals once. B completes a read, then leaves. C waits, then overwrites
// the tile. The tile is initialized before the setup barrier.
//
// As in the first case, threshold two needs both A's signal and B's LEAVE.
// C cannot overwrite the tile until B leaves, and B's read has completed
// before that happens. C therefore cannot overwrite data that B is still
// reading. This is a false WAR report: LEAVE must carry completed reads as
// well as completed writes through to the waves that pass their waits.
__global__ __attribute__((amdgpu_flat_work_group_size(kThreads, kThreads))) void
named_leave_read_kernel(int *out) {
  __shared__ __amdgpu_named_workgroup_barrier_t ready;
  if (wave() == 0)
    __builtin_amdgcn_s_barrier_init(&ready, 2);
  if (wave() == 1) {
    ldsWrite(tileSlot(), 100 + lane());
    waitDscnt();
  }
  __builtin_amdgcn_s_barrier_join(&ready);
  workgroupBarrier();

  if (wave() == 0) {
    __builtin_amdgcn_s_barrier_signal_var(&ready, 0);
  } else if (wave() == 1) {
    const int value = ldsReadAndWait(tileSlot());
    asm volatile("s_barrier_leave\ns_wait_kmcnt 0" ::: "scc", "memory");
    out[lane()] = value;
  } else {
    namedWait();
    ldsWrite(tileSlot(), -1);
    waitDscnt();
  }
  workgroupBarrier();
}

TEST_F(Gfx1250RaceTest, named_leave_orders_read_before_overwrite) {
  int *out = allocFilled<int>(kWave, -7);
  named_leave_read_kernel<<<1, kThreads, kTileBytes>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kFalseWarReport);
  ExpectValues(out, tileValues());
}

} // namespace
