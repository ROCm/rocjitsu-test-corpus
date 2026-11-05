// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

/// @file hip_race_gfx1250_test.hip
/// @brief gfx1250 HIP race detector tests: GFX12 split wait counters and tensor
///        DMA (tensor_load_to_lds, tensor_store_from_lds).
///
/// A tensor load writes LDS and a tensor store reads it, asynchronously, until
/// s_wait_tensorcnt retires the transfer. Transfers from one wave complete in
/// issue order and independently of DS operations, but may access LDS out of
/// order, so overlapping transfers from one wave also need a TENSORcnt wait
/// between them. Other waves see their LDS effects only after the issuing wave
/// waits and the workgroup passes a barrier. Each race case is its clean
/// partner with one step removed. Clean cases also check the data moved; raced
/// values are unconstrained.

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include "race_test_support.hpp"

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
constexpr int kTileBytes = kTileElements * static_cast<int>(sizeof(int));
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
  uint32_t count = 1;                   ///< Zero makes this a NULL tensor.
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
  words[5] = (tile.tensor_elements & 0xffffu) << 16;          // tensor_dim0[15:0].
  words[6] = (tile.tensor_elements >> 16) | (1u << 16);        // tensor_dim1 = 1.
  words[7] = (tile.tile_elements & 0xffffu) << 16;             // tile_dim0.
  words[8] = 1;                                                // tile_dim1.
  words[9] = kTileElements;                                        // tensor_dim0_stride.
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

/// Fill one tile of LDS with `value` and wait for the writes.
__device__ inline void ldsFillAndWait(uint32_t byte_offset, int value) {
  ldsWrite(byte_offset + lane() * 4, value);
  waitDscnt();
}

static constexpr RaceExpectation kTensorLoadThenReadRace{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "read",
    .producer = "tensor_load_to_lds",
    .consumer = "ds_load_b32",
};

static constexpr RaceExpectation kReadThenTensorLoadRace{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "write",
    .producer = "ds_load_b32",
    .consumer = "tensor_load_to_lds",
};

static constexpr RaceExpectation kTensorStoreThenWriteRace{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "write",
    .producer = "tensor_store_from_lds",
    .consumer = "ds_store_b32",
};

static constexpr RaceExpectation kDsWriteThenTensorStoreRace{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "read",
    .producer = "ds_store_b32",
    .consumer = "tensor_store_from_lds",
};

static constexpr RaceExpectation kTensorLoadThenTensorStoreRace{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "read",
    .producer = "tensor_load_to_lds",
    .consumer = "tensor_store_from_lds",
};

static constexpr RaceExpectation kTensorStoreThenTensorLoadRace{
    .findings = FindingCount::OneOrMore,
    .type = "LDS",
    .access = "write",
    .producer = "tensor_store_from_lds",
    .consumer = "tensor_load_to_lds",
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
  ExpectRace({.findings = FindingCount::OneOrMore,
              .type = "VGPR",
              .producer = "global_load_b32",
              .consumer = "global_store_b32"});
}

// --- The issuing wave must wait for TENSORCNT, and only TENSORCNT ---

enum class Wait { Tensorcnt, None, OtherCounters };

template <Wait W> __global__ void tensor_load_same_wave_kernel(TensorDesc desc, int *dst) {
  tensorLoad(desc);
  if (W == Wait::Tensorcnt)
    waitTensorcnt<0>();
  if (W == Wait::OtherCounters)
    asm volatile("s_wait_loadcnt 0\n"
                 "s_wait_dscnt 0" ::: "memory");
  dst[threadIdx.x] = ldsReadAndWait(threadIdx.x * 4);
  waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_load_tensorcnt) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_same_wave_kernel<Wait::Tensorcnt><<<1, kWave, kTileBytes>>>(describe({.global = src}),
                                                                          dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

TEST_F(Gfx1250RaceTest, tensor_load_missing_tensorcnt_race) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_same_wave_kernel<Wait::None><<<1, kWave, kTileBytes>>>(describe({.global = src}),
                                                                     dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRace);
}

// LOADcnt and DScnt waits do not cover tensor DMA.
TEST_F(Gfx1250RaceTest, tensor_load_other_counters_race) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_same_wave_kernel<Wait::OtherCounters>
      <<<1, kWave, kTileBytes>>>(describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRace);
}

// --- Other waves need the issuing wave's wait and a barrier ---

enum class Sync { WaitAndBarrier, WaitOnly, BarrierOnly };

// Wave 0 loads the tile; wave 1 reads it.
template <Sync S>
__global__ __attribute__((amdgpu_flat_work_group_size(2 * kWave, 2 * kWave))) void
tensor_load_cross_wave_kernel(TensorDesc desc, int *dst) {
  const int wave = waveIndex();
  if (wave == 0) {
    tensorLoad(desc);
    if (S != Sync::BarrierOnly)
      waitTensorcnt<0>();
  }
  if (S != Sync::WaitOnly)
    barrier();
  if (wave == 1)
    dst[lane()] = ldsReadAndWait(lane() * 4);
  if (wave == 0)
    waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_load_cross_wave) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_cross_wave_kernel<Sync::WaitAndBarrier>
      <<<1, 2 * kWave, kTileBytes>>>(describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

TEST_F(Gfx1250RaceTest, tensor_load_cross_wave_no_barrier_race) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_cross_wave_kernel<Sync::WaitOnly>
      <<<1, 2 * kWave, kTileBytes>>>(describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  // Without a barrier the waves run in either order, so the race may be
  // reported in either direction.
  ExpectAnyRace({kTensorLoadThenReadRace, kReadThenTensorLoadRace});
}

// A barrier retires only transfers their wave has already waited for.
TEST_F(Gfx1250RaceTest, tensor_load_cross_wave_no_tensorcnt_race) {
  auto *src = allocWithData<int>(kTileElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_cross_wave_kernel<Sync::BarrierOnly>
      <<<1, 2 * kWave, kTileBytes>>>(describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRace);
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
    dst[lane()] = ldsReadAndWait(ReadOffset + lane() * 4);
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
  ExpectRace(kTensorLoadThenReadRace);
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
  ExpectRace(kTensorLoadThenReadRace);
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
  dst[lane()] = ldsReadAndWait(Probe + lane() * 4);
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
  ExpectRace(kTensorLoadThenReadRace);
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
  ExpectRace(kTensorLoadThenReadRace);
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
  ExpectRace(kTensorLoadThenReadRace);
}

// --- LDS addresses past the workgroup's allocation ---

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
  ExpectRace(kTensorStoreThenWriteRace);
}

// DS writes and tensor DMA complete independently, so storing a tile the wave
// just wrote takes a DScnt wait first.
template <bool WaitDscnt> __global__ void tensor_store_after_ds_write_kernel(TensorDesc desc) {
  ldsWrite(lane() * 4, 100 + lane());
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
  ExpectRace(kDsWriteThenTensorStoreRace);
}

// The DS write and the tensor store share only one interior word: either a
// single DS-written word inside the full tile the store reads, or a one-word
// store inside the full tile the DS writes. Races are reported at that word.
constexpr int kInteriorElement = 13;
constexpr int kInteriorByte = kInteriorElement * 4;
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
  ExpectRace(kDsWriteThenTensorStoreRace);
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
  ExpectRace(kDsWriteThenTensorStoreRace);
  ExpectEveryRaceAtLdsByte(kInteriorByte);
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
  dst[lane()] = ldsReadAndWait(lane() * 4);
  dst[kWave + lane()] = ldsReadAndWait(kTileBytes + lane() * 4);
}

/// Launch the store-then-load kernel over `footprint`: the store copies LDS to
/// `stored`, the load copies `src` to LDS, and `dst` receives all of LDS.
template <bool WaitTensorcnt>
void launchStoreThenLoad(const SameWaveFootprint &footprint, int *stored, const int *src,
                         int *dst) {
  tensor_store_then_load_same_wave_kernel<WaitTensorcnt>
      <<<1, kWave, kSameWaveLdsElements * static_cast<int>(sizeof(int))>>>(
          describe({.global = stored,
                    .lds_offset = static_cast<uint32_t>(footprint.store_first * 4),
                    .tile_elements = static_cast<uint32_t>(footprint.store_count)}),
          describe({.global = src,
                    .lds_offset = static_cast<uint32_t>(footprint.load_first * 4),
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
  return 4 * (footprint.store_first > footprint.load_first ? footprint.store_first
                                                           : footprint.load_first);
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
  ExpectRace(kTensorStoreThenTensorLoadRace);
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
  ExpectRace(kTensorStoreThenTensorLoadRace);
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
  ExpectRace(kTensorStoreThenTensorLoadRace);
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
  ExpectRace(kTensorStoreThenTensorLoadRace);
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
  ExpectRace(kTensorStoreThenTensorLoadRace);
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
  ExpectRace(kTensorLoadThenTensorStoreRace);
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
  loaded[lane()] = ldsReadAndWait(lane() * 4);
  untouched[lane()] = ldsReadAndWait(kTileBytes + lane() * 4);
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
  ExpectRace(kTensorLoadThenReadRace);
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
  ExpectRace(kTensorLoadThenReadRace);
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
  ExpectRace(kTensorLoadThenReadRace);
}

// A store whose tile lies wholly outside the tensor writes nothing to global
// memory, but still counts. It reads no LDS either, so overwriting its tile
// while it is still pending is safe.
__global__ void tensor_load_then_empty_store_kernel(TensorDesc real, TensorDesc empty,
                                                    int *loaded) {
  tensorLoad(real);
  tensorStore(empty);
  waitTensorcnt<1>();
  loaded[lane()] = ldsReadAndWait(lane() * 4);
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
  ExpectRace(kTensorStoreThenWriteRace);
  // Raced values are unconstrained, but the empty stores still write nothing.
  ExpectValues(first_untouched, std::vector<int>(kTileElements, kUnwrittenValue));
  ExpectValues(last_untouched, std::vector<int>(kTileElements, kUnwrittenValue));
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
    dst[lane()] = ldsReadAndWait((kTensorHalf + lane() % kTensorHalf) * 4);
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
  ExpectRace(kTensorLoadThenReadRace);
}

// The issuing wave, waiting for its load, reads the whole tile: the copied half
// then the zero-filled half. This keeps the value check that the cross-wave
// pair gives up by reading only zero-filled bytes. The tile starts as
// kUnwrittenValue, so a skipped zero-fill cannot pass for one.
__global__ void tensor_load_zero_fill_full_tile_kernel(TensorDesc desc, int *dst) {
  ldsFillAndWait(0, kUnwrittenValue);
  tensorLoad(desc);
  waitTensorcnt<0>();
  dst[lane()] = ldsReadAndWait(lane() * 4);
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
    const uint32_t offset = lane() * 4 + (lane() < 16 ? 0 : kPadBytes);
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
  ExpectRace(kTensorLoadThenReadRace);
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
  if (lane() < kStripeLoadElements)
    own[wave * kStripeLoadElements + lane()] = ldsReadAndWait(stripeDword(read_wave, lane()) * 4);
  barrier();
  if (wave == 0) {
    assembled[lane()] = ldsReadAndWait(lane() * 4);
    if (lane() < kStripedElements - kWave)
      assembled[kWave + lane()] = ldsReadAndWait((kWave + lane()) * 4);
  }
}

/// Launch the interleaved-stripe kernel: wave w loads src[w * 12 .. w * 12 + 11].
template <bool PeerStripes>
void launchInterleavedStripes(const int *src, int *own, int *assembled) {
  auto stripes = [&](int wave) {
    return describe({.global = src + wave * kStripeLoadElements,
                     .lds_offset = static_cast<uint32_t>(wave * kStripeElements * 4),
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
  ExpectRace(kTensorLoadThenReadRace);
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
    dst[lane()] = ldsReadAndWait(kStraddlingOffset + lane() * 4);
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
    ldsWrite(kStraddlingOffset + lane() * 4, 100 + lane());
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

} // namespace
