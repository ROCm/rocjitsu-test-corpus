// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

/// @file hip_race_gfx1250_test.hip
/// @brief gfx1250 HIP race detector tests: split wait counters, barriers, tensor
///        DMA (tensor_load_to_lds, tensor_store_from_lds) and async copies
///        (global_load_async_to_lds, global_store_async_from_lds).
///
/// A tensor load writes LDS and a tensor store reads it, asynchronously, until
/// s_wait_tensorcnt retires the transfer. Transfers from one wave complete in
/// issue order and independently of DS operations, but may access LDS out of
/// order, so overlapping transfers from one wave also need a TENSORcnt wait
/// between them. Async copies do the same on ASYNCcnt, with a per-lane LDS
/// address.
/// Other waves see their LDS effects only after the issuing wave waits and the
/// workgroup passes a barrier. Each race case is its clean partner with one
/// step removed. Clean cases also check the data moved; raced values are
/// unconstrained.

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include "race_test_support.hpp"

#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <vector>

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  int rc = RUN_ALL_TESTS();
  const hipError_t reset_status = hipDeviceReset();
  if (reset_status != hipSuccess) {
    std::fprintf(stderr, "hipDeviceReset failed: %s\n", hipGetErrorString(reset_status));
    return 1;
  }
  return rc;
}

namespace {

using rocjitsu::test::FindingCount;
using rocjitsu::test::RaceExpectation;

constexpr int kWave = 32; // gfx1250 runs wave32.
/// The ints in one tile: a single row with one int per lane. The tests' tensors
/// are this wide too, unless a case narrows them.
constexpr int kTileElements = kWave;
constexpr int kElementBytes = static_cast<int>(sizeof(int));
constexpr int kTileBytes = kTileElements * kElementBytes;
/// A value no transfer in these tests produces. Memory filled with it shows
/// whether a transfer wrote there.
constexpr int kUnwrittenValue = -7;

using Gfx1250RaceTest = rocjitsu::test::RaceTestBase;

/// `count` consecutive ints starting at `first`.
std::vector<int> range(int first, int count = kTileElements) {
  std::vector<int> values(count);
  for (int index = 0; index < count; ++index)
    values[index] = first + index;
  return values;
}

// --- Tensor DMA descriptors ---

typedef int v4i __attribute__((ext_vector_type(4)));
typedef int v8i __attribute__((ext_vector_type(8)));

/// Descriptor groups 0 and 1 (CDNA5 ISA 10.11.4, Tables 62 and 63). Kernels take them
/// by value, so they arrive in SGPRs; groups 2 and 3 are NULL.
struct TensorDesc {
  v4i group0;
  v8i group1;
};

/// A one-row transfer of 4-byte elements between global memory and LDS.
struct Tile {
  const void *global = nullptr;
  uint32_t lds_offset = 0;
  uint32_t tensor_elements = kTileElements; ///< Elements past this are out of the tensor.
  uint32_t tile_elements = kTileElements;   ///< Zero makes the tile a NOP.
  uint32_t count = 1;                       ///< Zero makes this a NULL tensor.
  bool pad = false;
  uint32_t pad_interval = 0; ///< 2 << pad_interval dwords between pads.
  uint32_t pad_amount = 0;   ///< pad_amount + 1 dwords of padding.
};

TensorDesc describe(const Tile &tile) {
  uint32_t words[12] = {};
  const uint64_t address = reinterpret_cast<uint64_t>(tile.global);
  words[0] = tile.count;
  words[1] = tile.lds_offset;
  words[2] = static_cast<uint32_t>(address);
  words[3] = static_cast<uint32_t>((address >> 32) & 0x1ffffffu) | (2u << 30); // type 2.
  words[4] = (2u << 16) | (uint32_t{tile.pad} << 20) | (tile.pad_interval << 22) |
             (tile.pad_amount << 25);
  words[5] = (tile.tensor_elements & 0xffffu) << 16;    // tensor_dim0[15:0].
  words[6] = (tile.tensor_elements >> 16) | (1u << 16); // tensor_dim1 = 1.
  words[7] = (tile.tile_elements & 0xffffu) << 16;      // tile_dim0.
  words[8] = 1;                                         // tile_dim1.
  words[9] = kTileElements;                             // tensor_dim0_stride.
  TensorDesc desc;
  std::memcpy(&desc.group0, &words[0], sizeof(desc.group0));
  std::memcpy(&desc.group1, &words[4], sizeof(desc.group1));
  return desc;
}

// --- Device helpers. Every wait is explicit; nothing here lets the compiler
// --- add one. ---

/// This wave's index in the workgroup, as a scalar so branches on it are
/// uniform and the tensor instructions they guard issue once per wave.
__device__ inline int waveIndex() { return __builtin_amdgcn_readfirstlane(threadIdx.x) / kWave; }

__device__ inline int lane() { return threadIdx.x % kWave; }

__device__ inline void tensorLoad(const TensorDesc &desc) {
  asm volatile("tensor_load_to_lds %0, %1" ::"s"(desc.group0), "s"(desc.group1) : "memory");
}

__device__ inline void tensorStore(const TensorDesc &desc) {
  asm volatile("tensor_store_from_lds %0, %1" ::"s"(desc.group0), "s"(desc.group1) : "memory");
}

template <int Count> __device__ inline void waitTensorcnt() {
  asm volatile("s_wait_tensorcnt %0" ::"n"(Count) : "memory");
}

__device__ inline void waitDscnt() { asm volatile("s_wait_dscnt 0" ::: "memory"); }

/// A workgroup barrier with no implied waits, unlike __syncthreads().
__device__ inline void barrier() {
  asm volatile("s_barrier_signal -1\n"
               "s_barrier_wait -1" ::: "memory");
}

/// Read an int from LDS and wait for it, so a case reports only the LDS race
/// it is about and never a race on the destination register.
__device__ inline int ldsReadAndWait(uint32_t byte_offset) {
  int value;
  asm volatile("ds_load_b32 %0, %1\n"
               "s_wait_dscnt 0"
               : "=v"(value)
               : "v"(byte_offset)
               : "memory");
  return value;
}

/// Issue one LDS write and return without waiting for it; wait with waitDscnt()
/// where the write must have completed.
__device__ inline void ldsWrite(uint32_t byte_offset, int value) {
  asm volatile("ds_store_b32 %0, %1" ::"v"(byte_offset), "v"(value) : "memory");
}

/// Copy `src[lane]` into the LDS int at `tile_offset + lane * 4` without
/// waiting; wait with waitAsynccnt().
__device__ inline void asyncLoadToLds(const int *src, uint32_t tile_offset) {
  asm volatile("global_load_async_to_lds_b32 %[lds], %[offset], %[base]"
               :
               : [lds] "v"(tile_offset + lane() * kElementBytes),
                 [offset] "v"(lane() * kElementBytes), [base] "s"(src)
               : "memory");
}

/// Copy the LDS int at `tile_offset + lane * 4` to `dst[lane]` without waiting;
/// wait with waitAsynccnt().
__device__ inline void asyncStoreFromLds(int *dst, uint32_t tile_offset) {
  asm volatile("global_store_async_from_lds_b32 %[offset], %[lds], %[base]"
               :
               : [offset] "v"(lane() * kElementBytes),
                 [lds] "v"(tile_offset + lane() * kElementBytes), [base] "s"(dst)
               : "memory");
}

template <int Count> __device__ inline void waitAsynccnt() {
  asm volatile("s_wait_asynccnt %0" ::"n"(Count) : "memory");
}

/// Fill one tile of LDS with `value` and wait for the writes.
__device__ inline void ldsFillAndWait(uint32_t byte_offset, int value) {
  ldsWrite(byte_offset + lane() * kElementBytes, value);
  waitDscnt();
}

static constexpr RaceExpectation kVgprLoadcntRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "VGPR",
    .producer = "global_load_b32",
    .consumer = "global_store_b32",
};

static constexpr RaceExpectation kTensorLoadThenReadRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "read",
    .producer = "tensor_load_to_lds",
    .consumer = "ds_load_b32",
};

static constexpr RaceExpectation kReadThenTensorLoadRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "write",
    .producer = "ds_load_b32",
    .consumer = "tensor_load_to_lds",
};

static constexpr RaceExpectation kTensorStoreThenWriteRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "write",
    .producer = "tensor_store_from_lds",
    .consumer = "ds_store_b32",
};

static constexpr RaceExpectation kDsWriteThenTensorStoreRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "read",
    .producer = "ds_store_b32",
    .consumer = "tensor_store_from_lds",
};

static constexpr RaceExpectation kTensorLoadThenTensorStoreRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "read",
    .producer = "tensor_load_to_lds",
    .consumer = "tensor_store_from_lds",
};

static constexpr RaceExpectation kAsyncLoadThenTensorStoreRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "read",
    .producer = "global_load_async_to_lds_b32",
    .consumer = "tensor_store_from_lds",
};

static constexpr RaceExpectation kTensorStoreThenTensorLoadRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "write",
    .producer = "tensor_store_from_lds",
    .consumer = "tensor_load_to_lds",
};

static constexpr RaceExpectation kAsyncStoreThenWriteRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "write",
    .producer = "global_store_async_from_lds_b32",
    .consumer = "ds_store_b32",
};

static constexpr RaceExpectation kAsyncStoreB128ThenWriteRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "write",
    .producer = "global_store_async_from_lds_b128",
    .consumer = "ds_store_b32",
};

static constexpr RaceExpectation kAsyncStoreB8ThenByteWriteRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "write",
    .producer = "global_store_async_from_lds_b8",
    .consumer = "ds_store_b8",
};

static constexpr RaceExpectation kDsWriteThenAsyncStoreRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "read",
    .producer = "ds_store_b32",
    .consumer = "global_store_async_from_lds_b32",
};

static constexpr RaceExpectation kAsyncLoadThenAsyncStoreRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "read",
    .producer = "global_load_async_to_lds_b32",
    .consumer = "global_store_async_from_lds_b32",
};

static constexpr RaceExpectation kAsyncStoreThenAsyncLoadRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "write",
    .producer = "global_store_async_from_lds_b32",
    .consumer = "global_load_async_to_lds_b32",
};

static constexpr RaceExpectation kAsyncLoadThenReadRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "read",
    .producer = "global_load_async_to_lds_b32",
    .consumer = "ds_load_b32",
};

static constexpr RaceExpectation kAsyncStoreThenTensorLoadRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "write",
    .producer = "global_store_async_from_lds_b32",
    .consumer = "tensor_load_to_lds",
};

static constexpr RaceExpectation kTensorLoadThenAsyncStoreRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "read",
    .producer = "tensor_load_to_lds",
    .consumer = "global_store_async_from_lds_b32",
};

// --- GFX12 split wait counters ---

template <bool Wait> __global__ void vgpr_loadcnt_kernel(const int *src, int *dst) {
  int value;
  if (Wait)
    asm volatile("global_load_b32 %0, %1, off\n"
                 "s_wait_loadcnt 0"
                 : "=v"(value)
                 : "v"(&src[threadIdx.x]));
  else
    asm volatile("global_load_b32 %0, %1, off\n"
                 "s_nop 0"
                 : "=v"(value)
                 : "v"(&src[threadIdx.x]));
  dst[threadIdx.x] = value;
}

TEST_F(Gfx1250RaceTest, vgpr_loadcnt) {
  auto *src = allocWithData<int>(kWave);
  auto *dst = alloc<int>(kWave);
  vgpr_loadcnt_kernel<true><<<1, kWave>>>(src, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0, kWave));
}

TEST_F(Gfx1250RaceTest, vgpr_loadcnt_race) {
  auto *src = allocWithData<int>(kWave);
  auto *dst = alloc<int>(kWave);
  vgpr_loadcnt_kernel<false><<<1, kWave>>>(src, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kVgprLoadcntRaceExpectation);
}

// --- The issuing wave must wait for TENSORCNT, and only TENSORCNT ---

enum class WaitMode { Tensorcnt, None, OtherCounters };

template <WaitMode Mode> __global__ void tensor_load_same_wave_kernel(TensorDesc desc, int *dst) {
  tensorLoad(desc);
  if (Mode == WaitMode::Tensorcnt)
    waitTensorcnt<0>();
  if (Mode == WaitMode::OtherCounters)
    asm volatile("s_wait_loadcnt 0\n"
                 "s_wait_dscnt 0" ::: "memory");
  dst[threadIdx.x] = ldsReadAndWait(threadIdx.x * kElementBytes);
  waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_load_tensorcnt) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_same_wave_kernel<WaitMode::Tensorcnt>
      <<<1, kWave, kTileBytes>>>(describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

TEST_F(Gfx1250RaceTest, tensor_load_missing_tensorcnt_race) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_same_wave_kernel<WaitMode::None>
      <<<1, kWave, kTileBytes>>>(describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

// LOADcnt and DScnt waits do not cover tensor DMA.
TEST_F(Gfx1250RaceTest, tensor_load_other_counters_race) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_same_wave_kernel<WaitMode::OtherCounters>
      <<<1, kWave, kTileBytes>>>(describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

// --- Other waves need the issuing wave's wait and a barrier ---

enum class SyncMode { WaitAndBarrier, WaitOnly, BarrierOnly };

// Wave 0 loads the tile; wave 1 reads it.
template <SyncMode Mode>
__global__ __attribute__((amdgpu_flat_work_group_size(2 * kWave, 2 * kWave))) void
tensor_load_cross_wave_kernel(TensorDesc desc, int *dst) {
  const int wave = waveIndex();
  if (wave == 0) {
    tensorLoad(desc);
    if (Mode != SyncMode::BarrierOnly)
      waitTensorcnt<0>();
  }
  if (Mode != SyncMode::WaitOnly)
    barrier();
  if (wave == 1)
    dst[lane()] = ldsReadAndWait(lane() * kElementBytes);
  if (wave == 0)
    waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_load_cross_wave) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_cross_wave_kernel<SyncMode::WaitAndBarrier>
      <<<1, 2 * kWave, kTileBytes>>>(describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

TEST_F(Gfx1250RaceTest, tensor_load_cross_wave_no_barrier_race) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_cross_wave_kernel<SyncMode::WaitOnly>
      <<<1, 2 * kWave, kTileBytes>>>(describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  // Without a barrier the waves run in either order, so the race may be
  // reported in either direction.
  ExpectAnyRace({kTensorLoadThenReadRaceExpectation, kReadThenTensorLoadRaceExpectation});
}

// A barrier retires only transfers their wave has already waited for.
TEST_F(Gfx1250RaceTest, tensor_load_cross_wave_no_tensorcnt_race) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_cross_wave_kernel<SyncMode::BarrierOnly>
      <<<1, 2 * kWave, kTileBytes>>>(describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

// --- Double-buffered pipeline ---

// Wave 0 loads two tiles, waits for all but the newest, and the workgroup
// synchronizes. The older tile is ready for wave 1; the newer one is not.
template <uint32_t ReadOffset>
__global__ __attribute__((amdgpu_flat_work_group_size(2 * kWave, 2 * kWave))) void
tensor_load_pipeline_kernel(TensorDesc older, TensorDesc newer, int *dst) {
  const int wave = waveIndex();
  if (wave == 0) {
    tensorLoad(older);
    tensorLoad(newer);
    waitTensorcnt<1>();
  }
  barrier();
  if (wave == 1)
    dst[lane()] = ldsReadAndWait(ReadOffset + lane() * kElementBytes);
  if (wave == 0)
    waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_load_pipeline_oldest) {
  auto *older = allocWithData<int>(kTileElements);
  auto *newer = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_pipeline_kernel<0><<<1, 2 * kWave, 2 * kTileBytes>>>(
      describe({.global = older}), describe({.global = newer, .lds_offset = kTileBytes}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

TEST_F(Gfx1250RaceTest, tensor_load_pipeline_newest_race) {
  auto *older = allocWithData<int>(kTileElements);
  auto *newer = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_pipeline_kernel<kTileBytes><<<1, 2 * kWave, 2 * kTileBytes>>>(
      describe({.global = older}), describe({.global = newer, .lds_offset = kTileBytes}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

// Reading from the middle of the older tile, the first half of the lanes read
// its completed second half and the rest read the pending newer tile. Only
// those later lanes, at addresses in the newer tile, may be reported.
TEST_F(Gfx1250RaceTest, tensor_load_pipeline_straddling_race) {
  auto *older = allocWithData<int>(kTileElements);
  auto *newer = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_pipeline_kernel<kTileBytes / 2><<<1, 2 * kWave, 2 * kTileBytes>>>(
      describe({.global = older}), describe({.global = newer, .lds_offset = kTileBytes}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
  const auto parsed = rocjitsu::test::parseRaceLogFromEnvironment();
  ASSERT_TRUE(parsed.ok()) << parsed.error;
  for (const auto &record : parsed.records) {
    EXPECT_EQ(record.wave, 1);
    EXPECT_GE(record.lane, kWave / 2);
    EXPECT_GE(record.reg, kTileBytes);
    EXPECT_LT(record.reg, kTileBytes + kTileBytes / 2);
  }
  // The lanes reading the completed tile get its second half.
  ExpectValues(dst, range(kTileElements / 2, kWave / 2));
}

// --- Iterations and disjoint ranges still belong to one tensor instruction ---

// One wave issues two tensor instructions, which fill three separate LDS rows:
//   multi:  copy the input row into A at byte 0 and B at byte 2 * kTileBytes.
//   single: copy the input row into C at byte 4 * kTileBytes.
// Each row occupies kTileBytes; the gaps between them remain untouched.
// Although multi performs two copies, it contributes only one TENSORcnt entry.
// Instructions complete in issue order, so waiting to one guarantees that the
// older instruction has finished, including every row it writes.
// MultiFirst chooses the issue order, WaitCount is the maximum outstanding count
// allowed by the wait, and Probe is the byte offset of the row to read afterward.
template <bool MultiFirst, int WaitCount, uint32_t Probe>
__global__ void tensor_iteration_count_kernel(TensorDesc multi, TensorDesc single, int *dst) {
  // Global increment zero copies the same input row. LDS advances by two rows.
  // The encoded iteration count in the last word's high half is 1 for two copies.
  const v4i iteration = {0, 2 * kTileElements, 0, 1 << 16};
  const v4i unused = {0, 0, 0, 0};
  if constexpr (!MultiFirst)
    tensorLoad(single);
  asm volatile("tensor_load_to_lds %0, %1, %2, %3"
               :: "s"(multi.group0), "s"(multi.group1), "s"(iteration), "s"(unused) : "memory");
  if constexpr (MultiFirst)
    tensorLoad(single);
  waitTensorcnt<WaitCount>();
  dst[lane()] = ldsReadAndWait(Probe + lane() * kElementBytes);
  waitTensorcnt<0>();
}

// multi -> single -> wait<=1 -> read B: safe.
// Completing the older multi instruction must make both A and B ready. Reading
// its second row checks that all iterations complete with the instruction.
TEST_F(Gfx1250RaceTest, tensor_iterations_oldest_all_ranges) {
  auto *src = allocWithData<int>(kTileElements), *dst = alloc<int>(kTileElements);
  auto multi = describe({.global = src});
  multi.group1[0] |= 1u << 19; // Enable the iteration descriptor.
  tensor_iteration_count_kernel<true, 1, 2 * kTileBytes>
      <<<1, kWave, 5 * kTileBytes>>>(
          multi, describe({.global = src, .lds_offset = 4 * kTileBytes}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

// multi -> single -> wait<=1 -> read C: race.
// The wait gives no completion guarantee for the younger single instruction.
TEST_F(Gfx1250RaceTest, tensor_iterations_newest_single_race) {
  auto *src = allocWithData<int>(kTileElements), *dst = alloc<int>(kTileElements);
  auto multi = describe({.global = src});
  multi.group1[0] |= 1u << 19; // Enable the iteration descriptor.
  tensor_iteration_count_kernel<true, 1, 4 * kTileBytes>
      <<<1, kWave, 5 * kTileBytes>>>(
          multi, describe({.global = src, .lds_offset = 4 * kTileBytes}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

// single -> multi -> wait<=1 -> read A: race.
// The wait guarantees that single has completed, but even the first row of the
// younger multi instruction remains unprotected.
TEST_F(Gfx1250RaceTest, tensor_iterations_newest_first_range_race) {
  auto *src = allocWithData<int>(kTileElements), *dst = alloc<int>(kTileElements);
  auto multi = describe({.global = src});
  multi.group1[0] |= 1u << 19; // Enable the iteration descriptor.
  tensor_iteration_count_kernel<false, 1, 0>
      <<<1, kWave, 5 * kTileBytes>>>(
          multi, describe({.global = src, .lds_offset = 4 * kTileBytes}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

// single -> multi -> wait<=1 -> read B: race.
// Likewise for the younger multi instruction's second row, so the detector must
// track every row of a pending iterated load, not only the first.
TEST_F(Gfx1250RaceTest, tensor_iterations_newest_second_range_race) {
  auto *src = allocWithData<int>(kTileElements), *dst = alloc<int>(kTileElements);
  auto multi = describe({.global = src});
  multi.group1[0] |= 1u << 19; // Enable the iteration descriptor.
  tensor_iteration_count_kernel<false, 1, 2 * kTileBytes>
      <<<1, kWave, 5 * kTileBytes>>>(
          multi, describe({.global = src, .lds_offset = 4 * kTileBytes}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

// single -> multi -> wait<=2 -> read C: race.
// Only two instructions were issued, so this wait requires no progress at all.
// Incorrectly counting multi's copies separately would give three entries,
// causing the detector to retire single when waiting to two and miss this race.
TEST_F(Gfx1250RaceTest, tensor_iterations_do_not_add_counter_tokens_race) {
  auto *src = allocWithData<int>(kTileElements), *dst = alloc<int>(kTileElements);
  auto multi = describe({.global = src});
  multi.group1[0] |= 1u << 19; // Enable the iteration descriptor.
  tensor_iteration_count_kernel<false, 2, 4 * kTileBytes>
      <<<1, kWave, 5 * kTileBytes>>>(
          multi, describe({.global = src, .lds_offset = 4 * kTileBytes}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

// --- A tensor store's LDS source ---

// Wave 0 stores the tile; wave 1 then overwrites it in LDS. The barrier orders
// the overwrite after the store issues. Without the wait, it does not retire
// the store, so the overwrite races with it.
template <bool Synchronized>
__global__ __attribute__((amdgpu_flat_work_group_size(2 * kWave, 2 * kWave))) void
tensor_store_source_overwrite_kernel(TensorDesc desc) {
  const int wave = waveIndex();
  if (wave == 0) {
    ldsFillAndWait(0, 100 + lane());
    tensorStore(desc);
    if (Synchronized)
      waitTensorcnt<0>();
  }
  barrier();
  if (wave == 1)
    ldsFillAndWait(0, -1);
  if (wave == 0)
    waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_store_source_overwrite) {
  auto *dst = alloc<int>(kTileElements);
  tensor_store_source_overwrite_kernel<true>
      <<<1, 2 * kWave, kTileBytes>>>(describe({.global = dst}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(100));
}

TEST_F(Gfx1250RaceTest, tensor_store_source_overwrite_race) {
  auto *dst = alloc<int>(kTileElements);
  tensor_store_source_overwrite_kernel<false>
      <<<1, 2 * kWave, kTileBytes>>>(describe({.global = dst}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorStoreThenWriteRaceExpectation);
}

// DS writes and tensor DMA complete independently, so storing a tile the wave
// just wrote takes a DScnt wait first.
template <bool WaitDscnt> __global__ void tensor_store_after_ds_write_kernel(TensorDesc desc) {
  ldsWrite(lane() * kElementBytes, 100 + lane());
  if (WaitDscnt)
    waitDscnt();
  tensorStore(desc);
  waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_store_dscnt) {
  auto *dst = alloc<int>(kTileElements);
  tensor_store_after_ds_write_kernel<true><<<1, kWave, kTileBytes>>>(describe({.global = dst}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(100));
}

TEST_F(Gfx1250RaceTest, tensor_store_missing_dscnt_race) {
  auto *dst = alloc<int>(kTileElements);
  tensor_store_after_ds_write_kernel<false><<<1, kWave, kTileBytes>>>(describe({.global = dst}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kDsWriteThenTensorStoreRaceExpectation);
}

// The DS write and the tensor store share only one interior word: either a
// single DS-written word inside the full tile the store reads, or a one-word
// store inside the full tile the DS writes. Races are reported at that word.
constexpr int kInteriorElement = 13;
constexpr int kInteriorByte = kInteriorElement * kElementBytes;
constexpr int kInteriorValue = 500;

/// Expect every reported race to be at LDS byte `byte`.
void ExpectEveryRaceAtLdsByte(int byte) {
  const auto parsed = rocjitsu::test::parseRaceLogFromEnvironment();
  ASSERT_TRUE(parsed.ok()) << parsed.error;
  for (const auto &record : parsed.records)
    EXPECT_EQ(record.reg, byte);
}

// The rest of the store's source is written and waited for first, so only the
// interior word's write can be pending.
template <bool WaitDscnt>
__global__ void tensor_store_after_interior_ds_write_kernel(TensorDesc desc) {
  ldsFillAndWait(0, 100 + lane());
  if (lane() == kInteriorElement)
    ldsWrite(kInteriorByte, kInteriorValue);
  if (WaitDscnt)
    waitDscnt();
  tensorStore(desc);
  waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_store_dscnt_interior_ds_write) {
  auto *dst = alloc<int>(kTileElements);
  tensor_store_after_interior_ds_write_kernel<true>
      <<<1, kWave, kTileBytes>>>(describe({.global = dst}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  std::vector<int> expected = range(100);
  expected[kInteriorElement] = kInteriorValue;
  ExpectValues(dst, expected);
}

TEST_F(Gfx1250RaceTest, tensor_store_missing_dscnt_interior_ds_write_race) {
  auto *dst = alloc<int>(kTileElements);
  tensor_store_after_interior_ds_write_kernel<false>
      <<<1, kWave, kTileBytes>>>(describe({.global = dst}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kDsWriteThenTensorStoreRaceExpectation);
  ExpectEveryRaceAtLdsByte(kInteriorByte);
}

TEST_F(Gfx1250RaceTest, tensor_store_one_word_dscnt) {
  auto *dst = allocFilled(kTileElements, kUnwrittenValue);
  tensor_store_after_ds_write_kernel<true><<<1, kWave, kTileBytes>>>(
      describe({.global = dst, .lds_offset = kInteriorByte, .tile_elements = 1}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  std::vector<int> expected(kTileElements, kUnwrittenValue);
  expected[0] = 100 + kInteriorElement;
  ExpectValues(dst, expected);
}

TEST_F(Gfx1250RaceTest, tensor_store_one_word_missing_dscnt_race) {
  auto *dst = allocFilled(kTileElements, kUnwrittenValue);
  tensor_store_after_ds_write_kernel<false><<<1, kWave, kTileBytes>>>(
      describe({.global = dst, .lds_offset = kInteriorByte, .tile_elements = 1}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kDsWriteThenTensorStoreRaceExpectation);
  ExpectEveryRaceAtLdsByte(kInteriorByte);
}

// An ordinary async load into LDS completes on ASYNCcnt, independently of
// tensor DMA, so a tensor store of the loaded tile needs s_wait_asynccnt first;
// s_wait_tensorcnt does not complete the load.
template <bool WaitForAsync>
__global__ void async_load_then_tensor_store_kernel(const int *src, TensorDesc store) {
  const uint32_t offset = lane() * kElementBytes;
  asm volatile("global_load_async_to_lds_b32 %[lds], %[offset], %[base]\n"
               :
               : [lds] "v"(offset), [offset] "v"(offset), [base] "s"(src)
               : "memory");
  if constexpr (WaitForAsync)
    asm volatile("s_wait_asynccnt 0" ::: "memory");
  else
    // Waiting for tensor DMA must not complete an ordinary async LDS load.
    waitTensorcnt<0>();
  tensorStore(store);
  waitTensorcnt<0>();
  asm volatile("s_wait_asynccnt 0" ::: "memory");
}

TEST_F(Gfx1250RaceTest, async_load_then_tensor_store) {
  auto *src = allocWithData<int>(kTileElements), *stored = alloc<int>(kTileElements);
  async_load_then_tensor_store_kernel<true><<<1, kWave, kTileBytes>>>(
      src, describe({.global = stored}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(stored, range(0));
}

TEST_F(Gfx1250RaceTest, async_load_then_tensor_store_wrong_wait_race) {
  auto *src = allocWithData<int>(kTileElements), *stored = alloc<int>(kTileElements);
  async_load_then_tensor_store_kernel<false><<<1, kWave, kTileBytes>>>(
      src, describe({.global = stored}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncLoadThenTensorStoreRaceExpectation);
}

// --- Same-wave tensor loads and stores over one tile need a TENSORcnt wait ---

// Tensor transfers from one wave complete on TENSORcnt in issue order (CDNA5 ISA
// 10.11.1), but that orders completion, not LDS access. A tensor load moves its
// data with async loads (10.11.3), and async loads and stores may access LDS out
// of order, even relative to each other (10.8). The detector therefore reports a
// tensor load and a tensor store from the same wave that touch the same bytes,
// in either order, until a TENSORcnt wait retires the earlier one.

// A load into a tile an earlier store is still reading may overwrite bytes the
// store has not read yet. The footprints are in dwords of a two-tile LDS
// allocation whose dword i starts as 100 + i; after both transfers the kernel
// reads back all of it.
struct SameWaveFootprint {
  int store_first;
  int store_count;
  int load_first;
  int load_count;
};

constexpr int kSameWaveLdsElements = 2 * kTileElements;

constexpr SameWaveFootprint kSameTile{
    .store_first = 0, .store_count = kTileElements, .load_first = 0, .load_count = kTileElements};
constexpr SameWaveFootprint kLoadInsideStore{
    .store_first = 0, .store_count = kTileElements, .load_first = 8, .load_count = 16};
constexpr SameWaveFootprint kStoreInsideLoad{
    .store_first = 8, .store_count = 16, .load_first = 0, .load_count = kTileElements};
constexpr SameWaveFootprint kLoadOverlapsStoreStart{
    .store_first = 16, .store_count = kTileElements, .load_first = 0, .load_count = kTileElements};
constexpr SameWaveFootprint kLoadOverlapsStoreEnd{
    .store_first = 0, .store_count = kTileElements, .load_first = 16, .load_count = kTileElements};

template <bool WaitTensorcnt>
__global__ void tensor_store_then_load_same_wave_kernel(TensorDesc store, TensorDesc load,
                                                        int *dst) {
  ldsFillAndWait(0, 100 + lane());
  ldsFillAndWait(kTileBytes, 100 + kWave + lane());
  tensorStore(store);
  if (WaitTensorcnt)
    waitTensorcnt<0>();
  tensorLoad(load);
  waitTensorcnt<0>();
  dst[lane()] = ldsReadAndWait(lane() * kElementBytes);
  dst[kWave + lane()] = ldsReadAndWait(kTileBytes + lane() * kElementBytes);
}

/// Launch the store-then-load kernel over `footprint`: the store copies LDS to
/// `stored`, the load copies `src` to LDS, and `dst` receives all of LDS.
template <bool WaitTensorcnt>
void launchStoreThenLoad(const SameWaveFootprint &footprint, int *stored, const int *src,
                         int *dst) {
  tensor_store_then_load_same_wave_kernel<WaitTensorcnt>
      <<<1, kWave, kSameWaveLdsElements * kElementBytes>>>(
          describe({.global = stored,
                    .lds_offset = static_cast<uint32_t>(footprint.store_first * kElementBytes),
                    .tile_elements = static_cast<uint32_t>(footprint.store_count)}),
          describe({.global = src,
                    .lds_offset = static_cast<uint32_t>(footprint.load_first * kElementBytes),
                    .tile_elements = static_cast<uint32_t>(footprint.load_count)}),
          dst);
  RACE_HIP_CHECK(hipGetLastError());
}

/// The LDS a synchronized store-then-load leaves: the initial values, with the
/// load's footprint replaced by `src`, which holds 0, 1, 2, ...
std::vector<int> expectedLdsAfterStoreThenLoad(const SameWaveFootprint &footprint) {
  std::vector<int> lds = range(100, kSameWaveLdsElements);
  for (int i = 0; i < footprint.load_count; ++i)
    lds[footprint.load_first + i] = i;
  return lds;
}

/// What a store-then-load writes to global memory: the store's footprint of the
/// initial LDS values.
std::vector<int> expectedStoreOutput(const SameWaveFootprint &footprint) {
  return range(100 + footprint.store_first, footprint.store_count);
}

/// The first LDS byte the store and the load share.
constexpr int firstSharedByte(const SameWaveFootprint &footprint) {
  return kElementBytes * std::max(footprint.store_first, footprint.load_first);
}

TEST_F(Gfx1250RaceTest, tensor_store_then_load_same_wave) {
  auto *stored = alloc<int>(kTileElements);
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kSameWaveLdsElements);
  launchStoreThenLoad<true>(kSameTile, stored, src, dst);
  sync();
  ExpectNoRace();
  ExpectValues(stored, range(100));
  ExpectValues(dst, expectedLdsAfterStoreThenLoad(kSameTile));
}

TEST_F(Gfx1250RaceTest, tensor_store_then_load_same_wave_race) {
  auto *stored = alloc<int>(kTileElements);
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kSameWaveLdsElements);
  launchStoreThenLoad<false>(kSameTile, stored, src, dst);
  sync();
  ExpectRace(kTensorStoreThenTensorLoadRaceExpectation);
}

TEST_F(Gfx1250RaceTest, tensor_store_then_load_same_wave_load_inside_store) {
  auto *stored = alloc<int>(kLoadInsideStore.store_count);
  auto *src = allocWithData<int>(kLoadInsideStore.load_count);
  auto *dst = alloc<int>(kSameWaveLdsElements);
  launchStoreThenLoad<true>(kLoadInsideStore, stored, src, dst);
  sync();
  ExpectNoRace();
  ExpectValues(stored, expectedStoreOutput(kLoadInsideStore));
  ExpectValues(dst, expectedLdsAfterStoreThenLoad(kLoadInsideStore));
}

TEST_F(Gfx1250RaceTest, tensor_store_then_load_same_wave_load_inside_store_race) {
  auto *stored = alloc<int>(kLoadInsideStore.store_count);
  auto *src = allocWithData<int>(kLoadInsideStore.load_count);
  auto *dst = alloc<int>(kSameWaveLdsElements);
  launchStoreThenLoad<false>(kLoadInsideStore, stored, src, dst);
  sync();
  ExpectRace(kTensorStoreThenTensorLoadRaceExpectation);
  ExpectEveryRaceAtLdsByte(firstSharedByte(kLoadInsideStore));
}

TEST_F(Gfx1250RaceTest, tensor_store_then_load_same_wave_store_inside_load) {
  auto *stored = alloc<int>(kStoreInsideLoad.store_count);
  auto *src = allocWithData<int>(kStoreInsideLoad.load_count);
  auto *dst = alloc<int>(kSameWaveLdsElements);
  launchStoreThenLoad<true>(kStoreInsideLoad, stored, src, dst);
  sync();
  ExpectNoRace();
  ExpectValues(stored, expectedStoreOutput(kStoreInsideLoad));
  ExpectValues(dst, expectedLdsAfterStoreThenLoad(kStoreInsideLoad));
}

TEST_F(Gfx1250RaceTest, tensor_store_then_load_same_wave_store_inside_load_race) {
  auto *stored = alloc<int>(kStoreInsideLoad.store_count);
  auto *src = allocWithData<int>(kStoreInsideLoad.load_count);
  auto *dst = alloc<int>(kSameWaveLdsElements);
  launchStoreThenLoad<false>(kStoreInsideLoad, stored, src, dst);
  sync();
  ExpectRace(kTensorStoreThenTensorLoadRaceExpectation);
  ExpectEveryRaceAtLdsByte(firstSharedByte(kStoreInsideLoad));
}

TEST_F(Gfx1250RaceTest, tensor_store_then_load_same_wave_load_overlaps_store_start) {
  auto *stored = alloc<int>(kLoadOverlapsStoreStart.store_count);
  auto *src = allocWithData<int>(kLoadOverlapsStoreStart.load_count);
  auto *dst = alloc<int>(kSameWaveLdsElements);
  launchStoreThenLoad<true>(kLoadOverlapsStoreStart, stored, src, dst);
  sync();
  ExpectNoRace();
  ExpectValues(stored, expectedStoreOutput(kLoadOverlapsStoreStart));
  ExpectValues(dst, expectedLdsAfterStoreThenLoad(kLoadOverlapsStoreStart));
}

TEST_F(Gfx1250RaceTest, tensor_store_then_load_same_wave_load_overlaps_store_start_race) {
  auto *stored = alloc<int>(kLoadOverlapsStoreStart.store_count);
  auto *src = allocWithData<int>(kLoadOverlapsStoreStart.load_count);
  auto *dst = alloc<int>(kSameWaveLdsElements);
  launchStoreThenLoad<false>(kLoadOverlapsStoreStart, stored, src, dst);
  sync();
  ExpectRace(kTensorStoreThenTensorLoadRaceExpectation);
  ExpectEveryRaceAtLdsByte(firstSharedByte(kLoadOverlapsStoreStart));
}

TEST_F(Gfx1250RaceTest, tensor_store_then_load_same_wave_load_overlaps_store_end) {
  auto *stored = alloc<int>(kLoadOverlapsStoreEnd.store_count);
  auto *src = allocWithData<int>(kLoadOverlapsStoreEnd.load_count);
  auto *dst = alloc<int>(kSameWaveLdsElements);
  launchStoreThenLoad<true>(kLoadOverlapsStoreEnd, stored, src, dst);
  sync();
  ExpectNoRace();
  ExpectValues(stored, expectedStoreOutput(kLoadOverlapsStoreEnd));
  ExpectValues(dst, expectedLdsAfterStoreThenLoad(kLoadOverlapsStoreEnd));
}

TEST_F(Gfx1250RaceTest, tensor_store_then_load_same_wave_load_overlaps_store_end_race) {
  auto *stored = alloc<int>(kLoadOverlapsStoreEnd.store_count);
  auto *src = allocWithData<int>(kLoadOverlapsStoreEnd.load_count);
  auto *dst = alloc<int>(kSameWaveLdsElements);
  launchStoreThenLoad<false>(kLoadOverlapsStoreEnd, stored, src, dst);
  sync();
  ExpectRace(kTensorStoreThenTensorLoadRaceExpectation);
  ExpectEveryRaceAtLdsByte(firstSharedByte(kLoadOverlapsStoreEnd));
}

// A store of the tile an earlier load is still writing may read bytes the load
// has not written yet.
template <bool WaitTensorcnt>
__global__ void tensor_load_then_store_same_wave_kernel(TensorDesc load, TensorDesc store) {
  tensorLoad(load);
  if (WaitTensorcnt)
    waitTensorcnt<0>();
  tensorStore(store);
  waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_load_then_store_same_wave) {
  auto *src = allocWithData<int>(kTileElements);
  auto *stored = allocFilled(kTileElements, kUnwrittenValue);
  tensor_load_then_store_same_wave_kernel<true><<<1, kWave, kTileBytes>>>(
      describe({.global = src}), describe({.global = stored}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  // The store copies the tile the load wrote.
  ExpectValues(stored, range(0));
}

TEST_F(Gfx1250RaceTest, tensor_load_then_store_same_wave_race) {
  auto *src = allocWithData<int>(kTileElements);
  auto *stored = allocFilled(kTileElements, kUnwrittenValue);
  tensor_load_then_store_same_wave_kernel<false><<<1, kWave, kTileBytes>>>(
      describe({.global = src}), describe({.global = stored}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenTensorStoreRaceExpectation);
}

// Tensor stores and loads from one wave share TENSORcnt and complete in issue
// order. After a store from tile 0 and then a load into tile 1, waiting until at
// most one is outstanding completes the store: overwriting its source is safe,
// but the load may still be pending, so reading its tile races.
template <bool ReadNewer>
__global__ void tensor_mixed_partial_wait_kernel(TensorDesc store, TensorDesc load, int *dst) {
  ldsFillAndWait(0, 100 + lane());
  tensorStore(store);
  tensorLoad(load);
  waitTensorcnt<1>();
  if constexpr (ReadNewer) {
    // The load can still be pending even though the older store is complete.
    dst[lane()] = ldsReadAndWait(kTileBytes + lane() * kElementBytes);
  } else {
    // Only the completed store read this tile; the younger load uses another.
    ldsFillAndWait(0, 200 + lane());
  }
  waitTensorcnt<0>();
  if constexpr (!ReadNewer)
    dst[lane()] = ldsReadAndWait(kTileBytes + lane() * kElementBytes);
}

TEST_F(Gfx1250RaceTest, tensor_mixed_partial_wait_oldest_store) {
  auto *stored = alloc<int>(kTileElements), *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kTileElements);
  tensor_mixed_partial_wait_kernel<false><<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = stored}), describe({.global = src, .lds_offset = kTileBytes}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(stored, range(100));
  ExpectValues(dst, range(0));
}

TEST_F(Gfx1250RaceTest, tensor_mixed_partial_wait_newest_load_race) {
  auto *stored = alloc<int>(kTileElements), *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kTileElements);
  tensor_mixed_partial_wait_kernel<true><<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = stored}), describe({.global = src, .lds_offset = kTileBytes}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
  ExpectValues(stored, range(100));
}

// --- Tensor instructions that move no data still count on TENSORCNT ---

// A real load, then an instruction that moves nothing, then a wait that lets
// one transfer remain outstanding: that one is the empty instruction, so the
// real load is complete. Pipelines turn a prefetch past the end of a tensor
// into such an instruction.
template <int WaitCount>
__global__ void tensor_load_then_empty_kernel(TensorDesc real, TensorDesc empty, int *loaded,
                                              int *untouched) {
  ldsFillAndWait(kTileBytes, kUnwrittenValue);
  tensorLoad(real);
  tensorLoad(empty);
  waitTensorcnt<WaitCount>();
  loaded[lane()] = ldsReadAndWait(lane() * kElementBytes);
  untouched[lane()] = ldsReadAndWait(kTileBytes + lane() * kElementBytes);
  waitTensorcnt<0>();
}

// count = 0: a NULL tensor (CDNA5 ISA 10.11.4, Table 62). That a NULL tensor takes a
// TENSORcnt slot is a RocJITsu assumption pending hardware validation; only
// under it does s_wait_tensorcnt 1 retire the real load.
TEST_F(Gfx1250RaceTest, tensor_load_null_tensor_counts) {
  auto *src = allocWithData<int>(kTileElements);
  auto *loaded = alloc<int>(kWave);
  auto *untouched = alloc<int>(kWave);
  tensor_load_then_empty_kernel<1><<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = src}),
      describe({.global = src, .lds_offset = kTileBytes, .count = 0}), loaded, untouched);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(loaded, range(0));
  ExpectValues(untouched, std::vector<int>(kWave, kUnwrittenValue));
}

// Waiting for two leaves the real load pending whether or not the NULL tensor
// takes a slot.
TEST_F(Gfx1250RaceTest, tensor_load_null_tensor_uncounted_race) {
  auto *src = allocWithData<int>(kTileElements);
  auto *loaded = alloc<int>(kWave);
  auto *untouched = alloc<int>(kWave);
  tensor_load_then_empty_kernel<2><<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = src}),
      describe({.global = src, .lds_offset = kTileBytes, .count = 0}), loaded, untouched);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

// tile_dim0 = 0: a NOP tile (CDNA5 ISA 10.11.4, Table 63).
TEST_F(Gfx1250RaceTest, tensor_load_empty_tile_counts) {
  auto *src = allocWithData<int>(kTileElements);
  auto *loaded = alloc<int>(kWave);
  auto *untouched = alloc<int>(kWave);
  tensor_load_then_empty_kernel<1><<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = src}),
      describe({.global = src, .lds_offset = kTileBytes, .tile_elements = 0}), loaded,
      untouched);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(loaded, range(0));
  ExpectValues(untouched, std::vector<int>(kWave, kUnwrittenValue));
}

// Empty gathers use the same counter slot as dense NOPs. The two shapes
// exercise zero valid rows and zero row width independently (CDNA5 ISA 10.11.4).
TensorDesc describeEmptyGather(const void *global, bool zero_width) {
  auto desc = describe({.global = global, .lds_offset = kTileBytes,
                        .tile_elements = zero_width ? 0u : uint32_t{kTileElements}});
  desc.group0[0] |= (1u << 30) | (1u << 31);
  desc.group1[4] = zero_width ? 2 : 0;
  return desc;
}

TEST_F(Gfx1250RaceTest, tensor_load_empty_gather_zero_indices_counts) {
  auto *src = allocWithData<int>(kTileElements);
  auto *loaded = alloc<int>(kWave);
  auto *untouched = alloc<int>(kWave);
  tensor_load_then_empty_kernel<1><<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = src}), describeEmptyGather(src, false), loaded, untouched);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(loaded, range(0));
  ExpectValues(untouched, std::vector<int>(kWave, kUnwrittenValue));
}

TEST_F(Gfx1250RaceTest, tensor_load_empty_gather_zero_indices_race) {
  auto *src = allocWithData<int>(kTileElements);
  auto *loaded = alloc<int>(kWave);
  auto *untouched = alloc<int>(kWave);
  tensor_load_then_empty_kernel<2><<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = src}), describeEmptyGather(src, false), loaded, untouched);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

TEST_F(Gfx1250RaceTest, tensor_load_empty_gather_zero_width_counts) {
  auto *src = allocWithData<int>(kTileElements);
  auto *loaded = alloc<int>(kWave);
  auto *untouched = alloc<int>(kWave);
  tensor_load_then_empty_kernel<1><<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = src}), describeEmptyGather(src, true), loaded, untouched);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(loaded, range(0));
  ExpectValues(untouched, std::vector<int>(kWave, kUnwrittenValue));
}

TEST_F(Gfx1250RaceTest, tensor_load_empty_gather_zero_width_race) {
  auto *src = allocWithData<int>(kTileElements);
  auto *loaded = alloc<int>(kWave);
  auto *untouched = alloc<int>(kWave);
  tensor_load_then_empty_kernel<2><<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = src}), describeEmptyGather(src, true), loaded, untouched);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

// A store whose tile lies wholly outside the tensor writes nothing to global
// memory, but still counts. It reads no LDS either, so overwriting its tile
// while it is still pending is safe.
__global__ void tensor_load_then_empty_store_kernel(TensorDesc real, TensorDesc empty,
                                                    int *loaded) {
  tensorLoad(real);
  tensorStore(empty);
  waitTensorcnt<1>();
  loaded[lane()] = ldsReadAndWait(lane() * kElementBytes);
  ldsFillAndWait(kTileBytes, 100 + lane());
  waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_store_outside_tensor_counts) {
  auto *src = allocWithData<int>(kTileElements);
  auto *untouched = allocFilled(kTileElements, kUnwrittenValue);
  auto *loaded = alloc<int>(kWave);
  tensor_load_then_empty_store_kernel<<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = src}),
      describe({.global = untouched, .lds_offset = kTileBytes, .tensor_elements = 0}), loaded);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(loaded, range(0));
  ExpectValues(untouched, std::vector<int>(kTileElements, kUnwrittenValue));
}

// A real store between two stores wholly outside the tensor, all from one LDS
// tile, then a DS overwrite of that tile. Waiting until at most one transfer is
// outstanding leaves only the trailing empty store pending, so the overwrite is
// safe; at most two leaves the real store pending, so it races. The empty
// stores read no LDS, so their sharing the tile cannot race either. This does
// not show that the leading empty store counts; the load case above does.
template <int Remaining>
__global__ void tensor_store_between_empty_stores_kernel(TensorDesc first_empty, TensorDesc real,
                                                         TensorDesc last_empty) {
  ldsFillAndWait(0, 100 + lane());
  tensorStore(first_empty);
  tensorStore(real);
  tensorStore(last_empty);
  waitTensorcnt<Remaining>();
  ldsFillAndWait(0, -1);
  waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_store_between_empty_stores_counts) {
  auto *first_untouched = allocFilled(kTileElements, kUnwrittenValue);
  auto *stored = allocFilled(kTileElements, kUnwrittenValue);
  auto *last_untouched = allocFilled(kTileElements, kUnwrittenValue);
  tensor_store_between_empty_stores_kernel<1><<<1, kWave, kTileBytes>>>(
      describe({.global = first_untouched, .tensor_elements = 0}), describe({.global = stored}),
      describe({.global = last_untouched, .tensor_elements = 0}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(stored, range(100));
  ExpectValues(first_untouched, std::vector<int>(kTileElements, kUnwrittenValue));
  ExpectValues(last_untouched, std::vector<int>(kTileElements, kUnwrittenValue));
}

TEST_F(Gfx1250RaceTest, tensor_store_between_empty_stores_wait_two_race) {
  auto *first_untouched = allocFilled(kTileElements, kUnwrittenValue);
  auto *stored = allocFilled(kTileElements, kUnwrittenValue);
  auto *last_untouched = allocFilled(kTileElements, kUnwrittenValue);
  tensor_store_between_empty_stores_kernel<2><<<1, kWave, kTileBytes>>>(
      describe({.global = first_untouched, .tensor_elements = 0}), describe({.global = stored}),
      describe({.global = last_untouched, .tensor_elements = 0}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorStoreThenWriteRaceExpectation);
  // Raced values are unconstrained, but the empty stores still write nothing.
  ExpectValues(first_untouched, std::vector<int>(kTileElements, kUnwrittenValue));
  ExpectValues(last_untouched, std::vector<int>(kTileElements, kUnwrittenValue));
}

// --- A store must omit the holes between partially in-bounds tile rows ---

// A store reads only the tile elements inside the tensor. Here the tile is two
// 32-element rows over a tensor 16 elements wide, so the store reads LDS bytes
// [0, 64) and [128, 192) and skips [64, 128) and [192, 256). Writing into a
// skipped hole while the store is pending is safe; writing the bytes it reads
// races.

TensorDesc describeStoreWithHoles(void *global) {
  auto desc = describe({.global = global, .tensor_elements = 16, .tile_elements = 32});
  desc.group1[2] = 2u << 16; // tensor_dim1 = 2.
  desc.group1[4] = 2;        // tile_dim1 = 2.
  desc.group1[5] = 16;       // Contiguous 16-element global rows.
  return desc;
}

template <bool WriteHole>
__global__ void tensor_store_holes_kernel(TensorDesc store) {
  ldsFillAndWait(0, 100 + lane());
  ldsFillAndWait(kTileBytes, 200 + lane());
  tensorStore(store);
  if (lane() < 16)
    ldsWrite((WriteHole ? 64 : 0) + lane() * kElementBytes, 300 + lane());
  waitDscnt();
  waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_store_holes) {
  auto *stored = alloc<int>(kTileElements);
  tensor_store_holes_kernel<true><<<1, kWave, 2 * kTileBytes>>>(describeStoreWithHoles(stored));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  auto expected = range(100, 16);
  const auto second = range(200, 16);
  expected.insert(expected.end(), second.begin(), second.end());
  ExpectValues(stored, expected);
}

TEST_F(Gfx1250RaceTest, tensor_store_holes_adjacent_data_race) {
  auto *stored = alloc<int>(kTileElements);
  tensor_store_holes_kernel<false><<<1, kWave, 2 * kTileBytes>>>(describeStoreWithHoles(stored));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorStoreThenWriteRaceExpectation);
}

// --- Elements outside the tensor are zero-filled in LDS ---

constexpr uint32_t kTensorHalf = kTileElements / 2;

// The tile is twice as wide as the tensor; the second half reads as zero
// (CDNA5 ISA 10.11.6). Wave 1 reads only the zero-filled half, so a race found
// there cannot come from the copied half. The kUnwrittenValue fill is
// synchronized first, so it cannot race with that read. The second barrier
// orders the read after the load issues; without the wait, it does not retire
// the load, so the read races with it.
template <bool Synchronized>
__global__ __attribute__((amdgpu_flat_work_group_size(2 * kWave, 2 * kWave))) void
tensor_load_zero_fill_kernel(TensorDesc desc, int *dst) {
  const int wave = waveIndex();
  if (wave == 0)
    ldsFillAndWait(0, kUnwrittenValue);
  barrier();
  if (wave == 0) {
    tensorLoad(desc);
    if (Synchronized)
      waitTensorcnt<0>();
  }
  barrier();
  if (wave == 1)
    dst[lane()] = ldsReadAndWait((kTensorHalf + lane() % kTensorHalf) * kElementBytes);
  if (wave == 0)
    waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_load_zero_fill) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_zero_fill_kernel<true><<<1, 2 * kWave, kTileBytes>>>(
      describe({.global = src, .tensor_elements = kTensorHalf}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, std::vector<int>(kWave, 0));
}

TEST_F(Gfx1250RaceTest, tensor_load_zero_fill_cross_wave_race) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_zero_fill_kernel<false><<<1, 2 * kWave, kTileBytes>>>(
      describe({.global = src, .tensor_elements = kTensorHalf}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

// The issuing wave, waiting for its load, reads the whole tile: the copied half
// then the zero-filled half. This keeps the value check that the cross-wave
// pair gives up by reading only zero-filled bytes. The tile starts as
// kUnwrittenValue, so a skipped zero-fill cannot pass for one.
__global__ void tensor_load_zero_fill_full_tile_kernel(TensorDesc desc, int *dst) {
  ldsFillAndWait(0, kUnwrittenValue);
  tensorLoad(desc);
  waitTensorcnt<0>();
  dst[lane()] = ldsReadAndWait(lane() * kElementBytes);
}

TEST_F(Gfx1250RaceTest, tensor_load_zero_fill_full_tile) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_zero_fill_full_tile_kernel<<<1, kWave, kTileBytes>>>(
      describe({.global = src, .tensor_elements = kTensorHalf}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  std::vector<int> expected = range(0, kTensorHalf);
  expected.resize(kTileElements, 0);
  ExpectValues(dst, expected);
}

// --- LDS padding is not written ---

// 16 dwords of data, then 4 dwords of padding, then the other 16.
constexpr uint32_t kPadOffset = 64;
constexpr uint32_t kPadBytes = 16;

// Wave 1 reads LDS at `ReadOffset` while wave 0's padded load is outstanding.
// The barrier orders the read after the load issues; with no wait before it, it
// does not retire the load.
template <uint32_t ReadOffset>
__global__ __attribute__((amdgpu_flat_work_group_size(2 * kWave, 2 * kWave))) void
tensor_load_padding_kernel(TensorDesc desc, int *loaded, int *concurrent) {
  const int wave = waveIndex();
  if (wave == 0)
    tensorLoad(desc);
  barrier();
  if (wave == 1)
    concurrent[lane()] = ldsReadAndWait(ReadOffset);
  if (wave == 0) {
    waitTensorcnt<0>();
    const uint32_t offset = lane() * kElementBytes + (lane() < 16 ? 0 : kPadBytes);
    loaded[lane()] = ldsReadAndWait(offset);
  }
}

TEST_F(Gfx1250RaceTest, tensor_load_padding_gap) {
  auto *src = allocWithData<int>(kTileElements);
  auto *loaded = alloc<int>(kWave);
  auto *concurrent = alloc<int>(kWave);
  tensor_load_padding_kernel<kPadOffset><<<1, 2 * kWave, kTileBytes + kPadBytes>>>(
      describe({.global = src, .pad = true, .pad_interval = 3, .pad_amount = 3}), loaded,
      concurrent);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(loaded, range(0));
}

TEST_F(Gfx1250RaceTest, tensor_load_padding_data_race) {
  auto *src = allocWithData<int>(kTileElements);
  auto *loaded = alloc<int>(kWave);
  auto *concurrent = alloc<int>(kWave);
  tensor_load_padding_kernel<kPadOffset + kPadBytes><<<1, 2 * kWave, kTileBytes + kPadBytes>>>(
      describe({.global = src, .pad = true, .pad_interval = 3, .pad_amount = 3}), loaded,
      concurrent);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

// Three waves each load kStripeElements dwords per stripe, kStripesPerWave
// stripes, with padding that skips the other two waves' stripes, so together
// they fill 000011112222 repeated. Every load issues before the first barrier;
// each wave then waits for its own. Reading its own stripes is safe even while
// its peers' loads are pending, because their padded footprints are disjoint
// from its; a detector that tracked a padded load as one solid interval would
// report it. Reading the next wave's stripes instead races with that wave's
// pending load.
constexpr int kStripeWaves = 3;
constexpr int kStripeElements = 4;
constexpr int kStripesPerWave = 3;
constexpr int kStripeLoadElements = kStripeElements * kStripesPerWave;
constexpr int kStripedElements = kStripeLoadElements * kStripeWaves;

/// The LDS dword where `wave`'s load puts its element `lane`.
__device__ inline uint32_t stripeDword(int wave, int lane) {
  const int stripe = lane / kStripeElements;
  return (stripe * kStripeWaves + wave) * kStripeElements + lane % kStripeElements;
}

template <bool PeerStripes>
__global__ __attribute__((amdgpu_flat_work_group_size(kStripeWaves * kWave,
                                                     kStripeWaves * kWave))) void
tensor_load_interleaved_stripes_kernel(TensorDesc wave0, TensorDesc wave1, TensorDesc wave2,
                                       int *own, int *assembled) {
  const int wave = waveIndex();
  if (wave == 0)
    tensorLoad(wave0);
  else if (wave == 1)
    tensorLoad(wave1);
  else
    tensorLoad(wave2);
  barrier();
  waitTensorcnt<0>();
  const int read_wave = PeerStripes ? (wave + 1) % kStripeWaves : wave;
  if (lane() < kStripeLoadElements) {
    const uint32_t offset = stripeDword(read_wave, lane()) * kElementBytes;
    own[wave * kStripeLoadElements + lane()] = ldsReadAndWait(offset);
  }
  barrier();
  if (wave == 0) {
    assembled[lane()] = ldsReadAndWait(lane() * kElementBytes);
    if (lane() < kStripedElements - kWave)
      assembled[kWave + lane()] = ldsReadAndWait((kWave + lane()) * kElementBytes);
  }
}

/// Launch the interleaved-stripe kernel: wave w loads src[w * 12 .. w * 12 + 11].
template <bool PeerStripes>
void launchInterleavedStripes(const int *src, int *own, int *assembled) {
  auto stripes = [&](int wave) {
    return describe({.global = src + wave * kStripeLoadElements,
                     .lds_offset = static_cast<uint32_t>(wave * kStripeElements * kElementBytes),
                     .tile_elements = kStripeLoadElements,
                     .pad = true,
                     .pad_interval = 1, // A pad after every 4 dwords.
                     .pad_amount = 7}); // 8 dwords: the other two waves' stripes.
  };
  tensor_load_interleaved_stripes_kernel<PeerStripes>
      <<<1, kStripeWaves * kWave, 2 * kTileBytes>>>(stripes(0), stripes(1), stripes(2), own,
                                                    assembled);
  RACE_HIP_CHECK(hipGetLastError());
}

TEST_F(Gfx1250RaceTest, tensor_load_padding_interleaved_stripes) {
  auto *src = allocWithData<int>(kStripedElements);
  auto *own = alloc<int>(kStripedElements);
  auto *assembled = alloc<int>(kStripedElements);
  launchInterleavedStripes<false>(src, own, assembled);
  sync();
  ExpectNoRace();
  // Each wave read back exactly what it loaded.
  ExpectValues(own, range(0, kStripedElements));
  // LDS dword d holds element d % 4 of stripe d / 4, loaded by wave
  // (d / 4) % 3 as its stripe (d / 4) / 3.
  std::vector<int> expected(kStripedElements);
  for (int d = 0; d < kStripedElements; ++d) {
    const int stripe = d / kStripeElements;
    const int wave = stripe % kStripeWaves;
    expected[d] = wave * kStripeLoadElements + (stripe / kStripeWaves) * kStripeElements +
                  d % kStripeElements;
  }
  ExpectValues(assembled, expected);
}

TEST_F(Gfx1250RaceTest, tensor_load_padding_peer_stripe_race) {
  auto *src = allocWithData<int>(kStripedElements);
  auto *own = alloc<int>(kStripedElements);
  auto *assembled = alloc<int>(kStripedElements);
  launchInterleavedStripes<true>(src, own, assembled);
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

// --- LDS addresses past the workgroup's allocation ---

// A 2048-byte allocation, one LDS block, with the tile's second half past it.
// The TDM keeps processing the whole descriptor past an out-of-range LDS
// address, so the in-range half transfers normally (CDNA5 ISA 10.11.6). With
// LDS_CONFIG.ADDR_OUT_OF_RANGE_REPORTING set, hardware also reports MEMVIOL to
// the wave once the descriptor completes; RocJITsu does not model that report.
// The ISA leaves the global values a store writes from out-of-range LDS
// undefined, so the store case checks only its in-range half.
constexpr int kLdsAllocation = 2048;
constexpr uint32_t kStraddlingOffset = kLdsAllocation - kTileBytes / 2;

__global__ void tensor_load_past_lds_allocation_kernel(TensorDesc desc, int *dst) {
  tensorLoad(desc);
  waitTensorcnt<0>();
  if (lane() < 16)
    dst[lane()] = ldsReadAndWait(kStraddlingOffset + lane() * kElementBytes);
}

TEST_F(Gfx1250RaceTest, tensor_load_past_lds_allocation) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = allocFilled(kTileElements / 2, kUnwrittenValue);
  tensor_load_past_lds_allocation_kernel<<<1, kWave, kLdsAllocation>>>(
      describe({.global = src, .lds_offset = kStraddlingOffset}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0, kTileElements / 2));
}

__global__ void tensor_store_past_lds_allocation_kernel(TensorDesc desc) {
  if (lane() < 16)
    ldsWrite(kStraddlingOffset + lane() * kElementBytes, 100 + lane());
  waitDscnt();
  tensorStore(desc);
  waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_store_past_lds_allocation) {
  auto *dst = alloc<int>(kTileElements);
  tensor_store_past_lds_allocation_kernel<<<1, kWave, kLdsAllocation>>>(
      describe({.global = dst, .lds_offset = kStraddlingOffset}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  // The CDNA5 ISA does not define the global values written from out-of-range LDS.
  std::vector<int> stored(kTileElements);
  RACE_HIP_CHECK(hipMemcpy(stored.data(), dst, kTileBytes, hipMemcpyDeviceToHost));
  stored.resize(kTileElements / 2);
  EXPECT_EQ(stored, range(100, kTileElements / 2));
}

// --- Async copies between global memory and LDS ---
//
// An async load writes LDS and an async store reads it, at a per-lane LDS
// address, until s_wait_asynccnt retires the copy (CDNA5 ISA 10.8). Async
// copies may access LDS out of order with each other (10.8), so a wave needs
// that wait before touching a copy's LDS bytes. The ISA does not specify their
// LDS order relative to DS instructions, so as a conservative rule RocJITsu
// also reports an async store that reads bytes of the same wave's pending DS
// write until s_wait_dscnt completes it. STOREcnt does not cover async stores.
// Loads complete in order with loads and stores with stores, but loads and
// stores complete out of order with each other (10.8).

/// The wait between an async store and the overwrite of its source.
enum class AsyncWait { Asynccnt, Storecnt, None };

/// Fill tile 0 with 100 + lane, store it with an async store, then overwrite
/// it. Only an ASYNCcnt wait between the store and the overwrite protects it.
template <AsyncWait Wait> __global__ void async_store_source_overwrite_kernel(int *dst) {
  ldsFillAndWait(0, 100 + lane());
  asyncStoreFromLds(dst, 0);
  if constexpr (Wait == AsyncWait::Asynccnt)
    waitAsynccnt<0>();
  else if constexpr (Wait == AsyncWait::Storecnt)
    // STOREcnt counts ordinary stores, not async stores.
    asm volatile("s_wait_storecnt 0" ::: "memory");
  ldsFillAndWait(0, -1);
  waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_store_source_overwrite) {
  auto *dst = alloc<int>(kTileElements);
  async_store_source_overwrite_kernel<AsyncWait::Asynccnt><<<1, kWave, kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(100));
}

TEST_F(Gfx1250RaceTest, async_store_source_overwrite_race) {
  auto *dst = alloc<int>(kTileElements);
  async_store_source_overwrite_kernel<AsyncWait::None><<<1, kWave, kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncStoreThenWriteRaceExpectation);
}

TEST_F(Gfx1250RaceTest, async_store_source_overwrite_storecnt_race) {
  auto *dst = alloc<int>(kTileElements);
  async_store_source_overwrite_kernel<AsyncWait::Storecnt><<<1, kWave, kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncStoreThenWriteRaceExpectation);
}

// Wave 0 stores the tile; wave 1 then overwrites it.
template <SyncMode Mode>
__global__ __attribute__((amdgpu_flat_work_group_size(2 * kWave, 2 * kWave))) void
async_store_cross_wave_kernel(int *dst) {
  const int wave = waveIndex();
  if (wave == 0) {
    ldsFillAndWait(0, 100 + lane());
    asyncStoreFromLds(dst, 0);
    if (Mode != SyncMode::BarrierOnly)
      waitAsynccnt<0>();
  }
  if (Mode != SyncMode::WaitOnly)
    barrier();
  if (wave == 1)
    ldsFillAndWait(0, -1);
  if (wave == 0)
    waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_store_cross_wave) {
  auto *dst = alloc<int>(kTileElements);
  async_store_cross_wave_kernel<SyncMode::WaitAndBarrier><<<1, 2 * kWave, kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(100));
}

TEST_F(Gfx1250RaceTest, async_store_cross_wave_no_barrier_race) {
  auto *dst = alloc<int>(kTileElements);
  async_store_cross_wave_kernel<SyncMode::WaitOnly><<<1, 2 * kWave, kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  // Without a barrier the waves run in either order, so the race may be
  // reported in either direction.
  ExpectAnyRace(
      {kAsyncStoreThenWriteRaceExpectation, kDsWriteThenAsyncStoreRaceExpectation});
}

// A barrier retires only copies their wave has already waited for.
TEST_F(Gfx1250RaceTest, async_store_cross_wave_no_asynccnt_race) {
  auto *dst = alloc<int>(kTileElements);
  async_store_cross_wave_kernel<SyncMode::BarrierOnly><<<1, 2 * kWave, kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncStoreThenWriteRaceExpectation);
}

// Wave 0 loads a tile with an async load; wave 1 then stores it out with an
// async store. Wave 1 may read the tile only after wave 0 waits and the
// workgroup passes a barrier.
template <SyncMode Mode>
__global__ __attribute__((amdgpu_flat_work_group_size(2 * kWave, 2 * kWave))) void
async_load_cross_wave_async_store_kernel(const int *src, int *dst) {
  const int wave = waveIndex();
  if (wave == 0) {
    asyncLoadToLds(src, 0);
    if (Mode != SyncMode::BarrierOnly)
      waitAsynccnt<0>();
  }
  if (Mode != SyncMode::WaitOnly)
    barrier();
  if (wave == 1)
    asyncStoreFromLds(dst, 0);
  waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_load_cross_wave_async_store) {
  auto *src = allocWithData<int>(kTileElements), *dst = alloc<int>(kTileElements);
  async_load_cross_wave_async_store_kernel<SyncMode::WaitAndBarrier>
      <<<1, 2 * kWave, kTileBytes>>>(src, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

TEST_F(Gfx1250RaceTest, async_load_cross_wave_async_store_no_barrier_race) {
  auto *src = allocWithData<int>(kTileElements), *dst = alloc<int>(kTileElements);
  async_load_cross_wave_async_store_kernel<SyncMode::WaitOnly>
      <<<1, 2 * kWave, kTileBytes>>>(src, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  // Without a barrier the waves run in either order, so the race may be
  // reported in either direction.
  ExpectAnyRace(
      {kAsyncLoadThenAsyncStoreRaceExpectation, kAsyncStoreThenAsyncLoadRaceExpectation});
}

TEST_F(Gfx1250RaceTest, async_load_cross_wave_async_store_no_asynccnt_race) {
  auto *src = allocWithData<int>(kTileElements), *dst = alloc<int>(kTileElements);
  async_load_cross_wave_async_store_kernel<SyncMode::BarrierOnly>
      <<<1, 2 * kWave, kTileBytes>>>(src, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncLoadThenAsyncStoreRaceExpectation);
}

// Accesses that only read a tile do not race with each other, so after the
// tile is written and the workgroup synchronizes, wave 0's async store and wave
// 1's async store and DS read of it need no wait between them.
__global__ __attribute__((amdgpu_flat_work_group_size(2 * kWave, 2 * kWave))) void
async_store_shared_source_kernel(int *first, int *second, int *read) {
  const int wave = waveIndex();
  if (wave == 0)
    ldsFillAndWait(0, 100 + lane());
  barrier();
  if (wave == 0) {
    asyncStoreFromLds(first, 0);
  } else {
    asyncStoreFromLds(second, 0);
    read[lane()] = ldsReadAndWait(lane() * kElementBytes);
  }
  waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_store_shared_source) {
  auto *first = alloc<int>(kTileElements), *second = alloc<int>(kTileElements),
       *read = alloc<int>(kTileElements);
  async_store_shared_source_kernel<<<1, 2 * kWave, kTileBytes>>>(first, second, read);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(first, range(100));
  ExpectValues(second, range(100));
  ExpectValues(read, range(100));
}

// The ISA does not specify the LDS order of a DS write and a later async store
// of the same bytes, so as a conservative rule RocJITsu reports the store unless
// s_wait_dscnt completes the write first.
template <bool WaitForDs> __global__ void async_store_after_ds_write_kernel(int *dst) {
  ldsWrite(lane() * kElementBytes, 100 + lane());
  if constexpr (WaitForDs)
    waitDscnt();
  asyncStoreFromLds(dst, 0);
  waitAsynccnt<0>();
  waitDscnt();
}

TEST_F(Gfx1250RaceTest, async_store_dscnt) {
  auto *dst = alloc<int>(kTileElements);
  async_store_after_ds_write_kernel<true><<<1, kWave, kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(100));
}

TEST_F(Gfx1250RaceTest, async_store_missing_dscnt_race) {
  auto *dst = alloc<int>(kTileElements);
  async_store_after_ds_write_kernel<false><<<1, kWave, kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kDsWriteThenAsyncStoreRaceExpectation);
}

// Copy global -> LDS -> global in one wave. The two copies share ASYNCcnt but
// may access LDS out of order, so the store may read the tile before the load
// writes it unless an ASYNCcnt wait completes the load first. With only the
// load outstanding, waiting until at most one copy is outstanding does not.
template <int WaitCount>
__global__ void async_copy_load_then_store_kernel(const int *src, int *dst) {
  asyncLoadToLds(src, 0);
  waitAsynccnt<WaitCount>();
  asyncStoreFromLds(dst, 0);
  waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_copy_load_then_store) {
  auto *src = allocWithData<int>(kTileElements), *dst = alloc<int>(kTileElements);
  async_copy_load_then_store_kernel<0><<<1, kWave, kTileBytes>>>(src, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

TEST_F(Gfx1250RaceTest, async_copy_load_then_store_race) {
  auto *src = allocWithData<int>(kTileElements), *dst = alloc<int>(kTileElements);
  async_copy_load_then_store_kernel<1><<<1, kWave, kTileBytes>>>(src, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncLoadThenAsyncStoreRaceExpectation);
}

// Store a tile, then load new data into it: the load may overwrite bytes the
// store has not read yet.
template <bool Wait>
__global__ void async_copy_store_then_load_kernel(const int *src, int *stored, int *loaded) {
  ldsFillAndWait(0, 100 + lane());
  asyncStoreFromLds(stored, 0);
  if constexpr (Wait)
    waitAsynccnt<0>();
  asyncLoadToLds(src, 0);
  waitAsynccnt<0>();
  loaded[lane()] = ldsReadAndWait(lane() * kElementBytes);
}

TEST_F(Gfx1250RaceTest, async_copy_store_then_load) {
  auto *src = allocWithData<int>(kTileElements), *stored = alloc<int>(kTileElements),
       *loaded = alloc<int>(kTileElements);
  async_copy_store_then_load_kernel<true><<<1, kWave, kTileBytes>>>(src, stored, loaded);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(stored, range(100));
  ExpectValues(loaded, range(0));
}

TEST_F(Gfx1250RaceTest, async_copy_store_then_load_race) {
  auto *src = allocWithData<int>(kTileElements), *stored = alloc<int>(kTileElements),
       *loaded = alloc<int>(kTileElements);
  async_copy_store_then_load_kernel<false><<<1, kWave, kTileBytes>>>(src, stored, loaded);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncStoreThenAsyncLoadRaceExpectation);
}

// Load tile 0, store tile 1, load tile 2, then wait until at most one copy is
// outstanding. Loads complete in order, so the first load has completed. Loads
// and stores complete out of order with each other, so either the store or the
// second load may be the one still pending.
enum class MixedProbe { ReadOldestLoad, OverwriteStore, ReadNewestLoad };

template <MixedProbe Probe>
__global__ void async_mixed_partial_wait_kernel(const int *src, int *stored, int *out) {
  ldsFillAndWait(kTileBytes, 100 + lane());
  asyncLoadToLds(src, 0);
  asyncStoreFromLds(stored, kTileBytes);
  asyncLoadToLds(src, 2 * kTileBytes);
  waitAsynccnt<1>();
  if constexpr (Probe == MixedProbe::ReadOldestLoad) {
    out[lane()] = ldsReadAndWait(lane() * kElementBytes);
  } else if constexpr (Probe == MixedProbe::OverwriteStore) {
    ldsFillAndWait(kTileBytes, -1);
  } else {
    out[lane()] = ldsReadAndWait(2 * kTileBytes + lane() * kElementBytes);
  }
  waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_mixed_partial_wait_oldest_load) {
  auto *src = allocWithData<int>(kTileElements), *stored = alloc<int>(kTileElements),
       *out = alloc<int>(kTileElements);
  async_mixed_partial_wait_kernel<MixedProbe::ReadOldestLoad>
      <<<1, kWave, 3 * kTileBytes>>>(src, stored, out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(out, range(0));
  ExpectValues(stored, range(100));
}

TEST_F(Gfx1250RaceTest, async_mixed_partial_wait_store_race) {
  auto *src = allocWithData<int>(kTileElements), *stored = alloc<int>(kTileElements),
       *out = alloc<int>(kTileElements);
  async_mixed_partial_wait_kernel<MixedProbe::OverwriteStore>
      <<<1, kWave, 3 * kTileBytes>>>(src, stored, out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncStoreThenWriteRaceExpectation);
}

TEST_F(Gfx1250RaceTest, async_mixed_partial_wait_newest_load_race) {
  auto *src = allocWithData<int>(kTileElements), *stored = alloc<int>(kTileElements),
       *out = alloc<int>(kTileElements);
  async_mixed_partial_wait_kernel<MixedProbe::ReadNewestLoad>
      <<<1, kWave, 3 * kTileBytes>>>(src, stored, out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncLoadThenReadRaceExpectation);
}

// A double-buffered epilogue: each iteration fills one of two LDS tiles, stores
// it with an async store, then waits until at most WaitCount stores are
// outstanding before the next iteration refills the other tile. Stores complete
// in order with each other, so waiting for all but one completes the store of
// the tile the next iteration refills; waiting for all but two does not, and
// the third iteration overwrites the first store's pending source.
constexpr int kPipelineIterations = 4;

template <int WaitCount> __global__ void async_store_pipeline_kernel(int *dst) {
  for (int iteration = 0; iteration < kPipelineIterations; ++iteration) {
    const uint32_t tile = (iteration % 2) * kTileBytes;
    ldsFillAndWait(tile, 100 * (iteration + 1) + lane());
    asyncStoreFromLds(dst + iteration * kTileElements, tile);
    waitAsynccnt<WaitCount>();
  }
  waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_store_pipeline) {
  auto *dst = alloc<int>(kPipelineIterations * kTileElements);
  async_store_pipeline_kernel<1><<<1, kWave, 2 * kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  for (int iteration = 0; iteration < kPipelineIterations; ++iteration)
    ExpectValues(dst + iteration * kTileElements, range(100 * (iteration + 1)));
}

TEST_F(Gfx1250RaceTest, async_store_pipeline_wait_two_race) {
  auto *dst = alloc<int>(kPipelineIterations * kTileElements);
  async_store_pipeline_kernel<2><<<1, kWave, 2 * kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncStoreThenWriteRaceExpectation);
}

// Async copies and tensor DMA complete on different counters, so a tensor load
// over a pending async store's source needs s_wait_asynccnt, and an async store
// of a pending tensor load's tile needs s_wait_tensorcnt.
template <bool WaitForAsync>
__global__ void async_store_then_tensor_load_kernel(int *stored, TensorDesc load) {
  ldsFillAndWait(0, 100 + lane());
  asyncStoreFromLds(stored, 0);
  if constexpr (WaitForAsync)
    waitAsynccnt<0>();
  else
    waitTensorcnt<0>();
  tensorLoad(load);
  waitTensorcnt<0>();
  waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_store_then_tensor_load) {
  auto *src = allocWithData<int>(kTileElements), *stored = alloc<int>(kTileElements);
  async_store_then_tensor_load_kernel<true>
      <<<1, kWave, kTileBytes>>>(stored, describe({.global = src}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(stored, range(100));
}

TEST_F(Gfx1250RaceTest, async_store_then_tensor_load_wrong_wait_race) {
  auto *src = allocWithData<int>(kTileElements), *stored = alloc<int>(kTileElements);
  async_store_then_tensor_load_kernel<false>
      <<<1, kWave, kTileBytes>>>(stored, describe({.global = src}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncStoreThenTensorLoadRaceExpectation);
}

template <bool WaitForTensor>
__global__ void tensor_load_then_async_store_kernel(TensorDesc load, int *stored) {
  tensorLoad(load);
  if constexpr (WaitForTensor)
    waitTensorcnt<0>();
  else
    waitAsynccnt<0>();
  asyncStoreFromLds(stored, 0);
  waitAsynccnt<0>();
  waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_load_then_async_store) {
  auto *src = allocWithData<int>(kTileElements), *stored = alloc<int>(kTileElements);
  tensor_load_then_async_store_kernel<true>
      <<<1, kWave, kTileBytes>>>(describe({.global = src}), stored);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(stored, range(0));
}

TEST_F(Gfx1250RaceTest, tensor_load_then_async_store_wrong_wait_race) {
  auto *src = allocWithData<int>(kTileElements), *stored = alloc<int>(kTileElements);
  tensor_load_then_async_store_kernel<false>
      <<<1, kWave, kTileBytes>>>(describe({.global = src}), stored);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenAsyncStoreRaceExpectation);
}

// Lane 0 stores 16 LDS bytes with one B128 store, then overwrites the int at
// `OverwriteOffset` without waiting. The store's last int, at byte 12, is part
// of its source; the int after it is not.
template <uint32_t OverwriteOffset> __global__ void async_store_b128_kernel(int *dst) {
  ldsFillAndWait(0, 100 + lane());
  if (lane() == 0) {
    asm volatile("global_store_async_from_lds_b128 %[offset], %[lds], %[base]"
                 :
                 : [offset] "v"(0), [lds] "v"(0), [base] "s"(dst)
                 : "memory");
    ldsWrite(OverwriteOffset, -1);
    waitDscnt();
  }
  waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_store_b128_next_int) {
  auto *dst = alloc<int>(4);
  async_store_b128_kernel<4 * kElementBytes><<<1, kWave, kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(100, 4));
}

TEST_F(Gfx1250RaceTest, async_store_b128_last_int_race) {
  auto *dst = alloc<int>(4);
  async_store_b128_kernel<3 * kElementBytes><<<1, kWave, kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncStoreB128ThenWriteRaceExpectation);
}

// Lane 0 stores the one LDS byte at offset 5 with a B8 store, then overwrites
// LDS without waiting. Tile byte i holds i, so the store writes 5. Only byte 5
// is its source: overwriting both neighbours, bytes 4 and 6, is safe, which a
// detector tracking a wider read starting at byte 5 would report.
template <bool OverwriteSource> __global__ void async_store_b8_kernel(uint8_t *dst) {
  ldsFillAndWait(0, 0x03020100 + 0x04040404 * lane());
  if (lane() == 0) {
    if constexpr (OverwriteSource)
      asm volatile("global_store_async_from_lds_b8 %[offset], %[lds], %[base]\n"
                   "ds_store_b8 %[source], %[value]"
                   :
                   : [offset] "v"(0), [lds] "v"(5), [base] "s"(dst), [source] "v"(5),
                     [value] "v"(0xff)
                   : "memory");
    else
      asm volatile("global_store_async_from_lds_b8 %[offset], %[lds], %[base]\n"
                   "ds_store_b8 %[before], %[value]\n"
                   "ds_store_b8 %[after], %[value]"
                   :
                   : [offset] "v"(0), [lds] "v"(5), [base] "s"(dst), [before] "v"(4),
                     [after] "v"(6), [value] "v"(0xff)
                   : "memory");
    waitDscnt();
  }
  waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_store_b8_neighbor_byte) {
  auto *dst = alloc<uint8_t>(1);
  async_store_b8_kernel<false><<<1, kWave, kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, std::vector<uint8_t>{5});
}

TEST_F(Gfx1250RaceTest, async_store_b8_source_byte_race) {
  auto *dst = alloc<uint8_t>(1);
  async_store_b8_kernel<true><<<1, kWave, kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncStoreB8ThenByteWriteRaceExpectation);
}

// IOFFSET applies to both addresses (CDNA5 ISA 10.8.1): with an offset of one
// tile, the store reads tile 1 and writes dst[kTileElements + lane]. Tile 0 is
// not part of its source.
template <uint32_t OverwriteOffset> __global__ void async_store_ioffset_kernel(int *dst) {
  ldsFillAndWait(0, 100 + lane());
  ldsFillAndWait(kTileBytes, 200 + lane());
  asm volatile("global_store_async_from_lds_b32 %[offset], %[lds], %[base] offset:%[ioffset]"
               :
               : [offset] "v"(lane() * kElementBytes), [lds] "v"(lane() * kElementBytes),
                 [base] "s"(dst), [ioffset] "n"(kTileBytes)
               : "memory");
  ldsFillAndWait(OverwriteOffset, -1);
  waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_store_ioffset_unoffset_tile) {
  auto *dst = alloc<int>(2 * kTileElements);
  async_store_ioffset_kernel<0><<<1, kWave, 2 * kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst + kTileElements, range(200));
}

TEST_F(Gfx1250RaceTest, async_store_ioffset_source_race) {
  auto *dst = alloc<int>(2 * kTileElements);
  async_store_ioffset_kernel<kTileBytes><<<1, kWave, 2 * kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncStoreThenWriteRaceExpectation);
}

// Only odd lanes store. Without a wait, overwriting an even lane's int is safe,
// since no store reads it; overwriting an odd lane's int races.
template <int OverwriteParity> __global__ void async_store_partial_exec_kernel(int *dst) {
  ldsFillAndWait(0, 100 + lane());
  if (lane() & 1)
    asyncStoreFromLds(dst, 0);
  if ((lane() & 1) == OverwriteParity)
    ldsWrite(lane() * kElementBytes, -1);
  waitDscnt();
  waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_store_partial_exec_inactive_lanes) {
  auto *dst = allocFilled(kTileElements, kUnwrittenValue);
  async_store_partial_exec_kernel<0><<<1, kWave, kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  std::vector<int> expected(kTileElements, kUnwrittenValue);
  for (int index = 1; index < kTileElements; index += 2)
    expected[index] = 100 + index;
  ExpectValues(dst, expected);
}

TEST_F(Gfx1250RaceTest, async_store_partial_exec_active_lane_race) {
  auto *dst = allocFilled(kTileElements, kUnwrittenValue);
  async_store_partial_exec_kernel<1><<<1, kWave, kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncStoreThenWriteRaceExpectation);
}

// The store's tile straddles the end of the LDS allocation: lanes 0-15 read
// inside it and lanes 16-31 past it. Lanes past it read no LDS bytes, so
// overwriting low LDS addresses while the store is pending is not a race. The
// overwrite never touches the in-range lanes' source, so this guards only
// against lanes past the allocation being tracked at a low LDS address.
__global__ void async_store_past_lds_allocation_kernel(int *dst) {
  if (lane() < 16)
    ldsWrite(kStraddlingOffset + lane() * kElementBytes, 100 + lane());
  waitDscnt();
  asyncStoreFromLds(dst, kStraddlingOffset);
  if (lane() >= 16)
    ldsWrite((lane() - 16) * kElementBytes, -1);
  waitDscnt();
  waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_store_past_lds_allocation) {
  auto *dst = alloc<int>(kTileElements);
  async_store_past_lds_allocation_kernel<<<1, kWave, kLdsAllocation>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  // CDNA5 ISA 3.3.3 specifies out-of-range LDS behavior for async loads only,
  // so the case checks only the in-range half.
  std::vector<int> stored(kTileElements);
  RACE_HIP_CHECK(hipMemcpy(stored.data(), dst, kTileBytes, hipMemcpyDeviceToHost));
  stored.resize(kTileElements / 2);
  EXPECT_EQ(stored, range(100, kTileElements / 2));
}

// Lane 0's B128 store starts two ints before the end of the LDS allocation, so
// its source is those two ints, and overwriting the second before the ASYNCcnt
// wait races.
constexpr uint32_t kB128StraddlingOffset = kLdsAllocation - 2 * kElementBytes;

template <bool Wait> __global__ void async_store_b128_past_lds_allocation_kernel(int *dst) {
  if (lane() < 2)
    ldsWrite(kB128StraddlingOffset + lane() * kElementBytes, 100 + lane());
  waitDscnt();
  if (lane() == 0) {
    asm volatile("global_store_async_from_lds_b128 %[offset], %[lds], %[base]"
                 :
                 : [offset] "v"(0), [lds] "v"(kB128StraddlingOffset), [base] "s"(dst)
                 : "memory");
    if constexpr (Wait)
      waitAsynccnt<0>();
    ldsWrite(kB128StraddlingOffset + kElementBytes, -1);
    waitDscnt();
  }
  waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_store_b128_past_lds_allocation) {
  auto *dst = alloc<int>(4);
  async_store_b128_past_lds_allocation_kernel<true><<<1, kWave, kLdsAllocation>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  // Only the in-range half is checked, as above.
  ExpectValues(dst, range(100, 2));
}

TEST_F(Gfx1250RaceTest, async_store_b128_past_lds_allocation_in_range_int_race) {
  auto *dst = alloc<int>(4);
  async_store_b128_past_lds_allocation_kernel<false><<<1, kWave, kLdsAllocation>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncStoreB128ThenWriteRaceExpectation);
}

// Store tile 0, then issue a store of tile 1 with EXEC zero, then wait until at
// most one is outstanding. The EXEC-zero store moves no data, but with another
// async copy pending it still issues and takes an ASYNCcnt slot, so the wait
// completes the tile 0 store. Its lanes read nothing, so reusing tile 1 while it
// may still be pending is safe.
template <int WaitCount>
__global__ void async_store_exec_zero_kernel(int *first, int *second) {
  ldsFillAndWait(0, 100 + lane());
  ldsFillAndWait(kTileBytes, 200 + lane());
  asyncStoreFromLds(first, 0);
  uint32_t saved_exec;
  asm volatile("s_mov_b32 %[saved], exec_lo\n"
               "s_mov_b32 exec_lo, 0\n"
               "global_store_async_from_lds_b32 %[offset], %[lds], %[base]\n"
               "s_mov_b32 exec_lo, %[saved]"
               : [saved] "=&s"(saved_exec)
               : [offset] "v"(lane() * kElementBytes),
                 [lds] "v"(kTileBytes + lane() * kElementBytes), [base] "s"(second)
               : "memory");
  waitAsynccnt<WaitCount>();
  ldsFillAndWait(0, -1);
  ldsFillAndWait(kTileBytes, -2);
  waitAsynccnt<0>();
}

TEST_F(Gfx1250RaceTest, async_store_exec_zero_counts) {
  auto *first = alloc<int>(kTileElements);
  auto *second = allocFilled(kTileElements, kUnwrittenValue);
  async_store_exec_zero_kernel<1><<<1, kWave, 2 * kTileBytes>>>(first, second);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(first, range(100));
  ExpectValues(second, std::vector<int>(kTileElements, kUnwrittenValue));
}

TEST_F(Gfx1250RaceTest, async_store_exec_zero_wait_two_race) {
  auto *first = alloc<int>(kTileElements);
  auto *second = allocFilled(kTileElements, kUnwrittenValue);
  async_store_exec_zero_kernel<2><<<1, kWave, 2 * kTileBytes>>>(first, second);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncStoreThenWriteRaceExpectation);
}

// --- Compiler-generated tensor load ---

// The builtin issues the load; the compiler emits no s_wait_tensorcnt for it,
// so the kernel adds one, and schedules the LDS accesses and their waits.
__global__ void tensor_load_builtin_kernel(TensorDesc desc, int *dst) {
  __shared__ int tile[kTileElements];
  tile[threadIdx.x] = kUnwrittenValue;
  __syncthreads();
  const v4i zero4 = {0, 0, 0, 0};
  const v8i zero8 = {0, 0, 0, 0, 0, 0, 0, 0};
  __builtin_amdgcn_tensor_load_to_lds(desc.group0, desc.group1, zero4, zero4, zero8, 0);
  waitTensorcnt<0>();
  dst[threadIdx.x] = tile[threadIdx.x];
}

TEST_F(Gfx1250RaceTest, tensor_load_builtin) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  // `tile` is the kernel's only LDS allocation, so it starts at offset 0.
  tensor_load_builtin_kernel<<<1, kWave>>>(describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

// --- Compiler-generated async copies ---
//
// The race cases in this section check the compiler's current behavior, not
// the ISA: they race only because the compiler emits no s_wait_asynccnt for the
// async copy builtins. A compiler that adds those waits makes them race-free,
// and they must then be updated.

// The compiler emits no s_wait_asynccnt for the async copy builtins, not even
// between a load and a store of the same LDS bytes, so the kernel adds it.
template <bool Wait> __global__ void async_copy_builtin_kernel(int *src, int *dst) {
  __shared__ int tile[kTileElements];
  __builtin_amdgcn_global_load_async_to_lds_b32(src + threadIdx.x, tile + threadIdx.x, 0, 0);
  if constexpr (Wait)
    __builtin_amdgcn_s_wait_asynccnt(0);
  __builtin_amdgcn_global_store_async_from_lds_b32(dst + threadIdx.x, tile + threadIdx.x, 0, 0);
  __builtin_amdgcn_s_wait_asynccnt(0);
}

TEST_F(Gfx1250RaceTest, async_copy_builtin) {
  auto *src = allocWithData<int>(kTileElements), *dst = alloc<int>(kTileElements);
  async_copy_builtin_kernel<true><<<1, kWave>>>(src, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

TEST_F(Gfx1250RaceTest, async_copy_builtin_race) {
  auto *src = allocWithData<int>(kTileElements), *dst = alloc<int>(kTileElements);
  async_copy_builtin_kernel<false><<<1, kWave>>>(src, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncLoadThenAsyncStoreRaceExpectation);
}

// __syncthreads() emits a barrier but no s_wait_asynccnt, so wave 0's async
// store is still reading its source when wave 1 overwrites it.
__global__ __attribute__((amdgpu_flat_work_group_size(2 * kWave, 2 * kWave))) void
async_store_syncthreads_kernel(int *dst) {
  __shared__ int tile[kTileElements];
  if (threadIdx.x < kWave) {
    tile[threadIdx.x] = 100 + threadIdx.x;
    waitDscnt(); // There is no DScnt wait builtin.
    __builtin_amdgcn_global_store_async_from_lds_b32(dst + threadIdx.x, tile + threadIdx.x, 0,
                                                     0);
  }
  __syncthreads();
  if (threadIdx.x >= kWave)
    tile[threadIdx.x - kWave] = -1;
  __builtin_amdgcn_s_wait_asynccnt(0);
}

TEST_F(Gfx1250RaceTest, async_store_syncthreads_race) {
  auto *dst = alloc<int>(kTileElements);
  async_store_syncthreads_kernel<<<1, 2 * kWave>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsyncStoreThenWriteRaceExpectation);
}

/// Observe that only this wave remains in a two-wave workgroup, without
/// signaling a barrier or ordering LDS accesses. CDNA5 S_GET_BARRIER_STATE
/// reports the member count in bits 10:4; its result requires a KMCNT wait.
__device__ inline void waitForWriterExit() {
  uint32_t state;
  do {
    asm volatile("s_get_barrier_state %0, -1\n"
                 "s_wait_kmcnt 0"
                 : "=s"(state)
                 :
                 : "memory");
  } while (((state >> 4) & 0x7fu) != 1);
}

// A named barrier joined only by the reader does not order the writer's LDS
// accesses, even if the writer has already ended.
// Adding a workgroup barrier supplies the missing ordering.
template <bool WorkgroupAfter>
__attribute__((amdgpu_flat_work_group_size(64, 64)))
__global__ void named_barrier_exited_writer_kernel(int *out) {
  __shared__ int tile[2 * kWave];
  __shared__ __amdgpu_named_workgroup_barrier_t named;
  const uint32_t address =
      static_cast<uint32_t>(reinterpret_cast<uintptr_t>(&tile[threadIdx.x]));
  barrier();
  if (waveIndex() == 1) {
    ldsWrite(address, threadIdx.x + 11);
    waitDscnt();
    return;
  }
  waitForWriterExit();
  // Use the barrier type and builtins so the compiler reserves a named barrier
  // in the kernel descriptor and selects its ID.
  __builtin_amdgcn_s_barrier_init(&named, 1);
  __builtin_amdgcn_s_barrier_join(&named);
  __builtin_amdgcn_s_barrier_signal_var(&named, 0);
  asm volatile("s_barrier_wait 0" ::: "memory");
  if constexpr (WorkgroupAfter)
    barrier();
  out[threadIdx.x] = ldsReadAndWait(address + kTileBytes);
}

TEST_F(Gfx1250RaceTest, named_barrier_exited_writer_race) {
  named_barrier_exited_writer_kernel<false><<<1, 2 * kWave>>>(alloc<int>(kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace({.kernel = "named_barrier_exited_writer_kernel",
              .type = "LDS",
              .access = "read",
              .wave = 0,
              .lane = 0,
              .producer = "ds_store_b32",
              .consumer = "ds_load_b32"});
}

TEST_F(Gfx1250RaceTest, named_then_workgroup_barrier_exited_writer) {
  int *out = alloc<int>(kWave);
  named_barrier_exited_writer_kernel<true><<<1, 2 * kWave>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectValues(out, range(kWave + 11));
  ExpectNoRace();
}

// The reader's cluster barrier does not order the writer's LDS accesses,
// even if the writer has already ended. A workgroup barrier supplies the ordering.
template <bool WorkgroupAfter>
__attribute__((cluster_dims(2, 1, 1), amdgpu_flat_work_group_size(64, 64)))
__global__ void cluster_barrier_exited_writer_kernel(int *out) {
  __shared__ int tile[2 * kWave];
  const uint32_t address =
      static_cast<uint32_t>(reinterpret_cast<uintptr_t>(&tile[threadIdx.x]));
  barrier();
  if (waveIndex() == 1) {
    // Only workgroup 0 accesses LDS; workgroup 1 supplies the other cluster
    // signal. One surviving race cannot hide incorrect retirement in a peer.
    if (blockIdx.x == 0) {
      ldsWrite(address, threadIdx.x + 11);
      waitDscnt();
    }
    return;
  }
  waitForWriterExit();
  asm volatile("s_barrier_signal -3\n"
               "s_barrier_wait -3" ::: "memory");
  if constexpr (WorkgroupAfter)
    barrier();
  if (blockIdx.x == 0)
    out[threadIdx.x] = ldsReadAndWait(address + kTileBytes);
}

template <bool WorkgroupAfter> void launchClusterExitedWriter(int *out) {
  hipLaunchAttribute cluster{};
  cluster.id = hipLaunchAttributeClusterDimension;
  cluster.value.clusterDim = {2, 1, 1};
  hipLaunchConfig_t config{};
  config.gridDim = dim3(2);
  config.blockDim = dim3(2 * kWave);
  config.attrs = &cluster;
  config.numAttrs = 1;
  RACE_HIP_CHECK(
      hipLaunchKernelEx(&config, cluster_barrier_exited_writer_kernel<WorkgroupAfter>, out));
}

TEST_F(Gfx1250RaceTest, cluster_barrier_exited_writer_race) {
  launchClusterExitedWriter<false>(alloc<int>(kWave));
  sync();
  ExpectRace({.kernel = "cluster_barrier_exited_writer_kernel",
              .type = "LDS",
              .access = "read",
              .wave = 0,
              .lane = 0,
              .producer = "ds_store_b32",
              .consumer = "ds_load_b32"});
}

TEST_F(Gfx1250RaceTest, cluster_then_workgroup_barrier_exited_writer) {
  int *out = alloc<int>(kWave);
  launchClusterExitedWriter<true>(out);
  sync();
  ExpectValues(out, range(kWave + 11));
  ExpectNoRace();
}

// --- Counter-capacity backpressure ---

// Each memory counter is finite, and issuing an instruction that would overflow
// one stalls the wave until the oldest operation completes (CDNA5 ISA 5.7.1).
// For a counter whose operations complete in issue order, that proves the
// oldest one complete without an explicit wait. Each case issues an oldest
// operation, then enough younger operations on the same counter to fill it
// (clean) or to stop one short (race), and uses the oldest result with no wait.

// LOADcnt, STOREcnt, DScnt, ASYNCcnt and TENSORcnt are 6-bit counters and KMcnt
// is a 5-bit counter (CDNA5 ISA 5.7.1, table "Counter Size Description"). Issue
// stalls rather than overflow a counter, so each holds 2^n - 1 tokens.
constexpr int kCounterCapacity = 63; // 2^6 - 1.
constexpr int kKmcntCapacity = 31;   // 2^5 - 1.

// Younger loads write VGPRs v64 onward, one register each, so no two pending
// loads share a destination. That keeps the clean cases independent of
// whether same-type loads write their VGPRs in order (CDNA5 ISA 5.7.1 allows
// out-of-order writeback).
#define RACE_YOUNGER_VGPR_CLOBBERS \
  "v64", "v65", "v66", "v67", "v68", "v69", "v70", "v71", "v72", "v73", \
  "v74", "v75", "v76", "v77", "v78", "v79", "v80", "v81", "v82", "v83", \
  "v84", "v85", "v86", "v87", "v88", "v89", "v90", "v91", "v92", "v93", \
  "v94", "v95", "v96", "v97", "v98", "v99", "v100", "v101", "v102", "v103", \
  "v104", "v105", "v106", "v107", "v108", "v109", "v110", "v111", "v112", "v113", \
  "v114", "v115", "v116", "v117", "v118", "v119", "v120", "v121", "v122", "v123", \
  "v124", "v125", "v126"
// Younger scalar loads write s40 onward, one register each.
#define RACE_YOUNGER_SGPR_CLOBBERS \
  "s40", "s41", "s42", "s43", "s44", "s45", "s46", "s47", "s48", "s49", \
  "s50", "s51", "s52", "s53", "s54", "s55", "s56", "s57", "s58", "s59", \
  "s60", "s61", "s62", "s63", "s64", "s65", "s66", "s67", "s68", "s69", \
  "s70"

static constexpr RaceExpectation kLoadcntCapacityRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "VGPR",
    .producer = "global_load_b32",
    .consumer = "v_mov_b32",
};

static constexpr RaceExpectation kDscntCapacityRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "VGPR",
    .producer = "ds_load_b32",
    .consumer = "v_mov_b32",
};

static constexpr RaceExpectation kKmcntCapacityRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "SGPR",
    .producer = "s_load_b32",
    .consumer = "v_mov_b32",
};

static constexpr RaceExpectation kAsynccntCapacityRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "read",
    .producer = "global_load_async_to_lds_b32",
    .consumer = "ds_load_b32",
};

static constexpr RaceExpectation kDsWriteThenReadRaceExpectation{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "read",
    .producer = "ds_store_b32",
    .consumer = "ds_load_b32",
};

// A load, `Younger` younger loads, then a use of the oldest load's result. With
// `ExecZeroLast`, the last younger load runs with EXEC zero; it still takes a
// LOADcnt slot, because VMEM is skipped only when EXEC is zero and LOADcnt,
// STOREcnt, ASYNCcnt and TENSORcnt are all zero (CDNA5 ISA 3.2.2.1).
template <int Younger, bool ExecZeroLast = false>
__global__ void loadcnt_capacity_kernel(const int *src, int *dst) {
  static_assert(Younger <= kCounterCapacity);
  constexpr int kUnmaskedYounger = ExecZeroLast ? Younger - 1 : Younger;
  int producer, result, saved_exec;
  asm volatile("global_load_b32 %[producer], %[address], off\n"
               ".set race_vgpr, 64\n"
               ".rept %c[unmasked]\n"
               "global_load_b32 v[race_vgpr], %[address], off\n"
               ".set race_vgpr, race_vgpr + 1\n"
               ".endr\n"
               ".if %c[exec_zero]\n"
               "s_mov_b32 %[saved_exec], exec_lo\n"
               "s_mov_b32 exec_lo, 0\n"
               "global_load_b32 v[race_vgpr], %[address], off\n"
               "s_mov_b32 exec_lo, %[saved_exec]\n"
               ".endif\n"
               "v_mov_b32 %[result], %[producer]\n"
               : [producer] "=&v"(producer), [result] "=&v"(result),
                 [saved_exec] "=&s"(saved_exec)
               : [address] "v"(&src[threadIdx.x]), [unmasked] "n"(kUnmaskedYounger),
                 [exec_zero] "n"(ExecZeroLast ? 1 : 0)
               : "memory", RACE_YOUNGER_VGPR_CLOBBERS);
  asm volatile("s_wait_loadcnt 0" ::: "memory");
  dst[threadIdx.x] = result;
}

TEST_F(Gfx1250RaceTest, loadcnt_capacity_boundary) {
  auto *src = allocWithData<int>(kWave);
  auto *dst = alloc<int>(kWave);
  loadcnt_capacity_kernel<kCounterCapacity><<<1, kWave>>>(src, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0, kWave));
}

TEST_F(Gfx1250RaceTest, loadcnt_below_capacity_race) {
  auto *src = allocWithData<int>(kWave);
  auto *dst = alloc<int>(kWave);
  loadcnt_capacity_kernel<kCounterCapacity - 1><<<1, kWave>>>(src, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kLoadcntCapacityRaceExpectation);
}

TEST_F(Gfx1250RaceTest, loadcnt_exec_zero_issue_counts) {
  auto *src = allocWithData<int>(kWave);
  auto *dst = alloc<int>(kWave);
  loadcnt_capacity_kernel<kCounterCapacity, true><<<1, kWave>>>(src, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0, kWave));
}

TEST_F(Gfx1250RaceTest, loadcnt_exec_zero_below_capacity_race) {
  auto *src = allocWithData<int>(kWave);
  auto *dst = alloc<int>(kWave);
  loadcnt_capacity_kernel<kCounterCapacity - 1, true><<<1, kWave>>>(src, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kLoadcntCapacityRaceExpectation);
}

// Loads and stores use separate counters (CDNA5 ISA 5.7.1), so filling STOREcnt
// says nothing about a pending load.
__global__ void storecnt_pressure_kernel(const int *src, int *scratch, int *dst) {
  int producer, result;
  asm volatile("global_load_b32 %[producer], %[load_address], off\n"
               ".rept %c[stores]\n"
               "global_store_b32 %[store_address], %[store_value], off\n"
               ".endr\n"
               "v_mov_b32 %[result], %[producer]\n"
               : [producer] "=&v"(producer), [result] "=&v"(result)
               : [load_address] "v"(&src[threadIdx.x]), [store_address] "v"(&scratch[threadIdx.x]),
                 [store_value] "v"(1), [stores] "n"(kCounterCapacity)
               : "memory");
  asm volatile("s_wait_loadcnt 0\n"
               "s_wait_storecnt 0" ::: "memory");
  dst[threadIdx.x] = result;
}

TEST_F(Gfx1250RaceTest, storecnt_pressure_does_not_advance_loadcnt_race) {
  auto *src = allocWithData<int>(kWave);
  auto *scratch = alloc<int>(kWave);
  auto *dst = alloc<int>(kWave);
  storecnt_pressure_kernel<<<1, kWave>>>(src, scratch, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kLoadcntCapacityRaceExpectation);
}

// A DS read, `Younger` younger DS reads, then a use of the oldest result. DS
// operations complete in issue order (CDNA5 ISA 5.7.1.4), so the younger reads
// may share a destination. With `ScalarLoadLast`, a scalar load follows the
// reads; it counts on KMcnt, not DScnt (CDNA5 ISA 5.7.1.1).
template <int Younger, bool ScalarLoadLast = false>
__global__ void dscnt_capacity_kernel(const int *scalar_src, int *dst) {
  static_assert(Younger <= kCounterCapacity);
  ldsFillAndWait(0, 100 + lane());
  int producer, younger, scalar_result, result;
  asm volatile("ds_load_b32 %[producer], %[address]\n"
               ".rept %c[younger_reads]\n"
               "ds_load_b32 %[younger], %[address]\n"
               ".endr\n"
               ".if %c[scalar_load]\n"
               "s_load_b32 %[scalar_result], %[scalar_address], 0x0\n"
               ".endif\n"
               "v_mov_b32 %[result], %[producer]\n"
               : [producer] "=&v"(producer), [younger] "=&v"(younger),
                 [scalar_result] "=&s"(scalar_result), [result] "=&v"(result)
               : [address] "v"(lane() * kElementBytes), [scalar_address] "s"(scalar_src),
                 [younger_reads] "n"(Younger), [scalar_load] "n"(ScalarLoadLast ? 1 : 0)
               : "memory");
  asm volatile("s_wait_dscnt 0\n"
               "s_wait_kmcnt 0" ::: "memory");
  dst[lane()] = result;
}

TEST_F(Gfx1250RaceTest, dscnt_capacity_boundary) {
  auto *dst = alloc<int>(kWave);
  dscnt_capacity_kernel<kCounterCapacity><<<1, kWave, kTileBytes>>>(allocWithData<int>(1), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(100, kWave));
}

TEST_F(Gfx1250RaceTest, dscnt_below_capacity_race) {
  dscnt_capacity_kernel<kCounterCapacity - 1>
      <<<1, kWave, kTileBytes>>>(allocWithData<int>(1), alloc<int>(kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kDscntCapacityRaceExpectation);
}

// On targets with a shared LGKMCNT, this scalar load would fill the counter
// and complete the oldest DS read. On gfx1250 it counts on KMcnt.
TEST_F(Gfx1250RaceTest, kmcnt_pressure_does_not_advance_dscnt_race) {
  dscnt_capacity_kernel<kCounterCapacity - 1, true>
      <<<1, kWave, kTileBytes>>>(allocWithData<int>(1), alloc<int>(kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kDscntCapacityRaceExpectation);
}

// Scalar memory loads return out of order (CDNA5 ISA 5.7.1.1), so a full KMcnt
// does not prove which one completed.
__global__ void kmcnt_capacity_kernel(const int *src, int *dst) {
  int producer, result;
  asm volatile("s_load_b32 %[producer], %[address], 0x0\n"
               ".set race_sgpr, 40\n"
               ".rept %c[younger_loads]\n"
               "s_load_b32 s[race_sgpr], %[address], 0x0\n"
               ".set race_sgpr, race_sgpr + 1\n"
               ".endr\n"
               "v_mov_b32 %[result], %[producer]\n"
               : [producer] "=&s"(producer), [result] "=&v"(result)
               : [address] "s"(src), [younger_loads] "n"(kKmcntCapacity)
               : "memory", RACE_YOUNGER_SGPR_CLOBBERS);
  asm volatile("s_wait_kmcnt 0" ::: "memory");
  dst[lane()] = result;
}

TEST_F(Gfx1250RaceTest, kmcnt_capacity_does_not_complete_scalar_loads_race) {
  kmcnt_capacity_kernel<<<1, kWave>>>(allocWithData<int>(1), alloc<int>(kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kKmcntCapacityRaceExpectation);
}

// An async load into tile 0, `Younger` younger async loads into tiles 1
// onward, then a DS read of tile 0. The instruction offset moves both the
// global and the LDS address (CDNA5 ISA 10.8.1), so each younger load writes
// its own tile.
template <int Younger> __global__ void asynccnt_capacity_kernel(const int *src, int *dst) {
  static_assert(Younger <= kCounterCapacity);
  const uint32_t offset = lane() * kElementBytes;
  asm volatile("global_load_async_to_lds_b32 %[lds], %[offset], %[base]\n"
               ".set race_tile, 1\n"
               ".rept %c[younger_loads]\n"
               "global_load_async_to_lds_b32 %[lds], %[offset], %[base] "
               "offset:race_tile*%c[tile_bytes]\n"
               ".set race_tile, race_tile + 1\n"
               ".endr\n"
               :
               : [lds] "v"(offset), [offset] "v"(offset), [base] "s"(src),
                 [younger_loads] "n"(Younger), [tile_bytes] "n"(kTileBytes)
               : "memory");
  dst[lane()] = ldsReadAndWait(offset);
  asm volatile("s_wait_asynccnt 0" ::: "memory");
}

TEST_F(Gfx1250RaceTest, asynccnt_capacity_boundary) {
  auto *src = allocWithData<int>((kCounterCapacity + 1) * kTileElements);
  auto *dst = alloc<int>(kWave);
  asynccnt_capacity_kernel<kCounterCapacity>
      <<<1, kWave, (kCounterCapacity + 1) * kTileBytes>>>(src, dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

TEST_F(Gfx1250RaceTest, asynccnt_below_capacity_race) {
  auto *src = allocWithData<int>(kCounterCapacity * kTileElements);
  asynccnt_capacity_kernel<kCounterCapacity - 1>
      <<<1, kWave, kCounterCapacity * kTileBytes>>>(src, alloc<int>(kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsynccntCapacityRaceExpectation);
}

// Async loads and async stores complete in order only within their own type
// (CDNA5 ISA 10.8). An async load into tile 0, then enough async stores to
// nearly fill ASYNCcnt, then one more async load: the counter is full, but
// neither type alone overflows, so the first load is not proven complete.
__global__ void asynccnt_mixed_kernel(const int *src, int *scratch, int *dst) {
  const uint32_t offset = lane() * kElementBytes;
  ldsFillAndWait(kTileBytes, 100 + lane());
  asm volatile("global_load_async_to_lds_b32 %[lds], %[offset], %[base]\n"
               ".rept %c[stores]\n"
               "global_store_async_from_lds_b32 %[offset], %[lds], %[scratch] "
               "offset:%c[tile_bytes]\n"
               ".endr\n"
               "global_load_async_to_lds_b32 %[lds], %[offset], %[base] "
               "offset:2*%c[tile_bytes]\n"
               :
               : [lds] "v"(offset), [offset] "v"(offset), [base] "s"(src),
                 [scratch] "s"(scratch), [stores] "n"(kCounterCapacity - 1),
                 [tile_bytes] "n"(kTileBytes)
               : "memory");
  dst[lane()] = ldsReadAndWait(offset);
  asm volatile("s_wait_asynccnt 0" ::: "memory");
}

TEST_F(Gfx1250RaceTest, asynccnt_mixed_types_do_not_complete_a_load_race) {
  auto *src = allocWithData<int>(3 * kTileElements);
  auto *scratch = alloc<int>(2 * kTileElements);
  asynccnt_mixed_kernel<<<1, kWave, 3 * kTileBytes>>>(src, scratch, alloc<int>(kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kAsynccntCapacityRaceExpectation);
}

// A tensor load of tile 0, `Younger` younger tensor loads with a NULL
// descriptor, then a DS read of tile 0. A NULL tensor moves no data but still
// counts on TENSORcnt (see tensor_load_null_tensor_counts).
template <int Younger>
__global__ void tensorcnt_capacity_kernel(TensorDesc oldest, TensorDesc null_tensor, int *dst) {
  static_assert(Younger <= kCounterCapacity);
  tensorLoad(oldest);
  asm volatile(".rept %c[younger_loads]\n"
               "tensor_load_to_lds %[group0], %[group1]\n"
               ".endr\n"
               :
               : [group0] "s"(null_tensor.group0), [group1] "s"(null_tensor.group1),
                 [younger_loads] "n"(Younger)
               : "memory");
  dst[lane()] = ldsReadAndWait(lane() * kElementBytes);
  waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensorcnt_capacity_boundary) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensorcnt_capacity_kernel<kCounterCapacity><<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = src}),
      describe({.global = src, .lds_offset = kTileBytes, .count = 0}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

TEST_F(Gfx1250RaceTest, tensorcnt_below_capacity_race) {
  auto *src = allocWithData<int>(kTileElements);
  tensorcnt_capacity_kernel<kCounterCapacity - 1><<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = src}),
      describe({.global = src, .lds_offset = kTileBytes, .count = 0}), alloc<int>(kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRaceExpectation);
}

// Wave 0 writes tile 0, then issues `Younger` younger DS writes to tile 1 with
// no wait, and the workgroup synchronizes. Capacity proves the first write
// complete for wave 0, so the barrier orders it before wave 1's read. Wave 1
// reads after the barrier, which follows the write's issue, so a race is
// reported at the read.
template <int Younger>
__global__ __attribute__((amdgpu_flat_work_group_size(2 * kWave, 2 * kWave))) void
dscnt_capacity_cross_wave_kernel(int *dst) {
  static_assert(Younger <= kCounterCapacity);
  const int wave = waveIndex();
  const uint32_t offset = lane() * kElementBytes;
  if (wave == 0) {
    asm volatile("ds_store_b32 %[address], %[value]\n"
                 ".rept %c[younger_writes]\n"
                 "ds_store_b32 %[address], %[value] offset:%c[tile_bytes]\n"
                 ".endr\n"
                 :
                 : [address] "v"(offset), [value] "v"(100 + lane()),
                   [younger_writes] "n"(Younger), [tile_bytes] "n"(kTileBytes)
                 : "memory");
  }
  barrier();
  if (wave == 1)
    dst[lane()] = ldsReadAndWait(offset);
  if (wave == 0)
    waitDscnt();
}

TEST_F(Gfx1250RaceTest, dscnt_capacity_cross_wave_barrier) {
  auto *dst = alloc<int>(kWave);
  dscnt_capacity_cross_wave_kernel<kCounterCapacity><<<1, 2 * kWave, 2 * kTileBytes>>>(dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(100, kWave));
}

TEST_F(Gfx1250RaceTest, dscnt_capacity_cross_wave_barrier_race) {
  dscnt_capacity_cross_wave_kernel<kCounterCapacity - 1>
      <<<1, 2 * kWave, 2 * kTileBytes>>>(alloc<int>(kWave));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kDsWriteThenReadRaceExpectation);
}

#undef RACE_YOUNGER_VGPR_CLOBBERS
#undef RACE_YOUNGER_SGPR_CLOBBERS

} // namespace
