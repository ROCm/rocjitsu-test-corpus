// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

/// @file hip_race_gfx1250_test.hip
/// @brief gfx1250 HIP race detector tests: GFX12 split wait counters and tensor
///        DMA (tensor_load_to_lds, tensor_store_from_lds).
///
/// A tensor load writes LDS and a tensor store reads it, asynchronously, until
/// s_wait_tensorcnt retires the transfer. Transfers from one wave complete in
/// issue order and independently of DS operations; other waves see their LDS
/// effects only after the issuing wave waits and the workgroup passes a
/// barrier. Each race case is its clean partner with one step removed. Clean
/// cases also check the data moved; raced values are unconstrained.

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

constexpr int kWave = 32;     // gfx1250 runs wave32.
constexpr int kElements = 32; // One int per lane; one tile is one row of this.
constexpr int kTileBytes = kElements * static_cast<int>(sizeof(int));
constexpr int kSentinel = -7;

class Gfx1250RaceTest : public rocjitsu::test::RaceTestBase {
protected:
  void ExpectValues(const int *device, const std::vector<int> &expected) {
    std::vector<int> host(expected.size());
    RACE_HIP_CHECK(
        hipMemcpy(host.data(), device, host.size() * sizeof(int), hipMemcpyDeviceToHost));
    EXPECT_EQ(host, expected);
  }

  int *allocFilled(int count, int value) {
    std::vector<int> host(count, value);
    int *device = alloc<int>(count);
    RACE_HIP_CHECK(hipMemcpy(device, host.data(), count * sizeof(int), hipMemcpyHostToDevice));
    return device;
  }
};

/// `count` consecutive ints starting at `first`.
std::vector<int> range(int first, int count = kElements) {
  std::vector<int> values(count);
  for (int index = 0; index < count; ++index)
    values[index] = first + index;
  return values;
}

// --- Tensor DMA descriptors ---

typedef int v4i __attribute__((ext_vector_type(4)));
typedef int v8i __attribute__((ext_vector_type(8)));

/// Descriptor groups 0 and 1 (CDNA5 ISA, Tables 79 and 80). Kernels take them
/// by value, so they arrive in SGPRs; groups 2 and 3 are NULL.
struct TensorDesc {
  v4i group0;
  v8i group1;
};

/// A one-row transfer of 4-byte elements between global memory and LDS.
struct Tile {
  const void *global = nullptr;
  uint32_t lds_offset = 0;
  uint32_t tensor_elements = kElements; ///< Elements past this are out of the tensor.
  uint32_t tile_elements = kElements;   ///< Zero makes the tile a NOP.
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
  words[9] = kElements;                                        // tensor_dim0_stride.
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

/// Let other waves run first, so a missing barrier shows a fixed interleaving.
__device__ inline void yieldToOtherWaves() { asm volatile("s_sleep 4" ::: "memory"); }

/// Read an int from LDS and wait for it, so a case reports only the LDS race
/// it is about and never a race on the destination register.
__device__ inline int ldsRead(uint32_t byte_offset) {
  int value;
  asm volatile("ds_load_b32 %0, %1\n"
               "s_wait_dscnt 0"
               : "=v"(value)
               : "v"(byte_offset)
               : "memory");
  return value;
}

__device__ inline void ldsWrite(uint32_t byte_offset, int value) {
  asm volatile("ds_store_b32 %0, %1" ::"v"(byte_offset), "v"(value) : "memory");
}

/// Fill one tile of LDS with `value` and wait for the writes.
__device__ inline void ldsFill(uint32_t byte_offset, int value) {
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
  dst[threadIdx.x] = ldsRead(threadIdx.x * 4);
  waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_load_tensorcnt) {
  auto *src = allocWithData<int>(kElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_same_wave_kernel<Wait::Tensorcnt><<<1, kWave, kTileBytes>>>(describe({.global = src}),
                                                                          dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

TEST_F(Gfx1250RaceTest, tensor_load_missing_tensorcnt_race) {
  auto *src = allocWithData<int>(kElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_same_wave_kernel<Wait::None><<<1, kWave, kTileBytes>>>(describe({.global = src}),
                                                                     dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRace);
}

// LOADcnt and DScnt waits do not cover tensor DMA.
TEST_F(Gfx1250RaceTest, tensor_load_other_counters_race) {
  auto *src = allocWithData<int>(kElements);
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
  else if (wave == 1)
    yieldToOtherWaves();
  if (wave == 1)
    dst[lane()] = ldsRead(lane() * 4);
  if (wave == 0)
    waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_load_cross_wave) {
  auto *src = allocWithData<int>(kElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_cross_wave_kernel<Sync::WaitAndBarrier>
      <<<1, 2 * kWave, kTileBytes>>>(describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

TEST_F(Gfx1250RaceTest, tensor_load_cross_wave_no_barrier_race) {
  auto *src = allocWithData<int>(kElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_cross_wave_kernel<Sync::WaitOnly>
      <<<1, 2 * kWave, kTileBytes>>>(describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRace);
}

// A barrier retires only transfers their wave has already waited for.
TEST_F(Gfx1250RaceTest, tensor_load_cross_wave_no_tensorcnt_race) {
  auto *src = allocWithData<int>(kElements);
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
    dst[lane()] = ldsRead(ReadOffset + lane() * 4);
  if (wave == 0)
    waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_load_pipeline_oldest) {
  auto *older = allocWithData<int>(kElements);
  auto *newer = allocWithData<int>(kElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_pipeline_kernel<0><<<1, 2 * kWave, 2 * kTileBytes>>>(
      describe({.global = older}), describe({.global = newer, .lds_offset = kTileBytes}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

TEST_F(Gfx1250RaceTest, tensor_load_pipeline_newest_race) {
  auto *older = allocWithData<int>(kElements);
  auto *newer = allocWithData<int>(kElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_pipeline_kernel<kTileBytes><<<1, 2 * kWave, 2 * kTileBytes>>>(
      describe({.global = older}), describe({.global = newer, .lds_offset = kTileBytes}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRace);
}

// --- A tensor store's LDS source ---

// Wave 0 stores the tile; wave 1 then overwrites it in LDS.
template <bool Synchronized>
__global__ __attribute__((amdgpu_flat_work_group_size(2 * kWave, 2 * kWave))) void
tensor_store_source_overwrite_kernel(TensorDesc desc) {
  const int wave = waveIndex();
  if (wave == 0) {
    ldsFill(0, 100 + lane());
    tensorStore(desc);
    if (Synchronized)
      waitTensorcnt<0>();
  }
  if (Synchronized)
    barrier();
  else if (wave == 1)
    yieldToOtherWaves();
  if (wave == 1)
    ldsFill(0, -1);
  if (wave == 0)
    waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_store_source_overwrite) {
  auto *dst = alloc<int>(kElements);
  tensor_store_source_overwrite_kernel<true>
      <<<1, 2 * kWave, kTileBytes>>>(describe({.global = dst}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(100));
}

TEST_F(Gfx1250RaceTest, tensor_store_source_overwrite_race) {
  auto *dst = alloc<int>(kElements);
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
  auto *dst = alloc<int>(kElements);
  tensor_store_after_ds_write_kernel<true><<<1, kWave, kTileBytes>>>(describe({.global = dst}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(100));
}

TEST_F(Gfx1250RaceTest, tensor_store_missing_dscnt_race) {
  auto *dst = alloc<int>(kElements);
  tensor_store_after_ds_write_kernel<false><<<1, kWave, kTileBytes>>>(describe({.global = dst}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kDsWriteThenTensorStoreRace);
}

// --- Same-wave tensor transfers stay in issue order ---

// A load may overwrite the LDS tile an earlier store from the same wave is
// still reading: tensor loads and stores stay in order (CDNA5 ISA 4.10.1).
__global__ void tensor_store_then_load_same_wave_kernel(TensorDesc store, TensorDesc load,
                                                        int *dst) {
  ldsFill(0, 100 + lane());
  tensorStore(store);
  tensorLoad(load);
  waitTensorcnt<0>();
  dst[lane()] = ldsRead(lane() * 4);
}

TEST_F(Gfx1250RaceTest, tensor_store_then_load_same_wave) {
  auto *stored = alloc<int>(kElements);
  auto *src = allocWithData<int>(kElements);
  auto *dst = alloc<int>(kWave);
  tensor_store_then_load_same_wave_kernel<<<1, kWave, kTileBytes>>>(
      describe({.global = stored}), describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(stored, range(100));
  ExpectValues(dst, range(0));
}

// --- Tensor instructions that move no data still count on TENSORCNT ---

// A real load, then an instruction that moves nothing, then a wait that lets
// one transfer remain outstanding: that one is the empty instruction, so the
// real load is complete. Pipelines turn a prefetch past the end of a tensor
// into such an instruction.
template <int WaitCount>
__global__ void tensor_load_then_empty_kernel(TensorDesc real, TensorDesc empty, int *loaded,
                                              int *untouched) {
  ldsFill(kTileBytes, kSentinel);
  tensorLoad(real);
  tensorLoad(empty);
  waitTensorcnt<WaitCount>();
  loaded[lane()] = ldsRead(lane() * 4);
  untouched[lane()] = ldsRead(kTileBytes + lane() * 4);
  waitTensorcnt<0>();
}

// count = 0: a NULL tensor (CDNA5 ISA, Table 79).
TEST_F(Gfx1250RaceTest, tensor_load_null_tensor_counts) {
  auto *src = allocWithData<int>(kElements);
  auto *loaded = alloc<int>(kWave);
  auto *untouched = alloc<int>(kWave);
  tensor_load_then_empty_kernel<1><<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = src}),
      describe({.global = src, .lds_offset = kTileBytes, .count = 0}), loaded, untouched);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(loaded, range(0));
  ExpectValues(untouched, std::vector<int>(kWave, kSentinel));
}

// With two transfers outstanding, waiting for two leaves the real load pending.
TEST_F(Gfx1250RaceTest, tensor_load_null_tensor_uncounted_race) {
  auto *src = allocWithData<int>(kElements);
  auto *loaded = alloc<int>(kWave);
  auto *untouched = alloc<int>(kWave);
  tensor_load_then_empty_kernel<2><<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = src}),
      describe({.global = src, .lds_offset = kTileBytes, .count = 0}), loaded, untouched);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRace);
}

// tile_dim0 = 0: a NOP tile (CDNA5 ISA, Table 80).
TEST_F(Gfx1250RaceTest, tensor_load_empty_tile_counts) {
  auto *src = allocWithData<int>(kElements);
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
  ExpectValues(untouched, std::vector<int>(kWave, kSentinel));
}

// A store whose tile lies wholly outside the tensor writes nothing to global
// memory, but still counts.
__global__ void tensor_load_then_empty_store_kernel(TensorDesc real, TensorDesc empty,
                                                    int *loaded) {
  tensorLoad(real);
  tensorStore(empty);
  waitTensorcnt<1>();
  loaded[lane()] = ldsRead(lane() * 4);
  waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_store_outside_tensor_counts) {
  auto *src = allocWithData<int>(kElements);
  auto *untouched = allocFilled(kElements, kSentinel);
  auto *loaded = alloc<int>(kWave);
  tensor_load_then_empty_store_kernel<<<1, kWave, 2 * kTileBytes>>>(
      describe({.global = src}),
      describe({.global = untouched, .lds_offset = kTileBytes, .tensor_elements = 0}), loaded);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(loaded, range(0));
  ExpectValues(untouched, std::vector<int>(kElements, kSentinel));
}

// --- Elements outside the tensor are zero-filled in LDS ---

constexpr uint32_t kTensorHalf = kElements / 2;

// The tile is twice as wide as the tensor; the second half reads as zero
// (CDNA5 ISA 4.10.7). Wave 1 reads the zero-filled half. The sentinel fill is
// synchronized first, so it cannot race with that read.
template <bool Synchronized>
__global__ __attribute__((amdgpu_flat_work_group_size(2 * kWave, 2 * kWave))) void
tensor_load_zero_fill_kernel(TensorDesc desc, int *dst) {
  const int wave = waveIndex();
  if (wave == 0)
    ldsFill(0, kSentinel);
  barrier();
  if (wave == 0) {
    tensorLoad(desc);
    if (Synchronized)
      waitTensorcnt<0>();
  }
  if (Synchronized)
    barrier();
  else if (wave == 1)
    yieldToOtherWaves();
  if (wave == 1)
    dst[lane()] = ldsRead(lane() * 4);
  if (wave == 0)
    waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_load_zero_fill) {
  auto *src = allocWithData<int>(kElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_zero_fill_kernel<true><<<1, 2 * kWave, kTileBytes>>>(
      describe({.global = src, .tensor_elements = kTensorHalf}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  std::vector<int> expected = range(0, kTensorHalf);
  expected.resize(kElements, 0);
  ExpectValues(dst, expected);
}

TEST_F(Gfx1250RaceTest, tensor_load_zero_fill_cross_wave_race) {
  auto *src = allocWithData<int>(kElements);
  auto *dst = alloc<int>(kWave);
  tensor_load_zero_fill_kernel<false><<<1, 2 * kWave, kTileBytes>>>(
      describe({.global = src, .tensor_elements = kTensorHalf}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRace);
}

// --- LDS padding is not written ---

// 16 dwords of data, then 4 dwords of padding, then the other 16.
constexpr uint32_t kPadOffset = 64;
constexpr uint32_t kPadBytes = 16;

// Wave 1 reads LDS at `ReadOffset` while wave 0's padded load is outstanding.
template <uint32_t ReadOffset>
__global__ __attribute__((amdgpu_flat_work_group_size(2 * kWave, 2 * kWave))) void
tensor_load_padding_kernel(TensorDesc desc, int *loaded, int *concurrent) {
  const int wave = waveIndex();
  if (wave == 0)
    tensorLoad(desc);
  else {
    yieldToOtherWaves();
    concurrent[lane()] = ldsRead(ReadOffset);
  }
  if (wave == 0) {
    waitTensorcnt<0>();
    const uint32_t offset = lane() * 4 + (lane() < 16 ? 0 : kPadBytes);
    loaded[lane()] = ldsRead(offset);
  }
}

TEST_F(Gfx1250RaceTest, tensor_load_padding_gap) {
  auto *src = allocWithData<int>(kElements);
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
  auto *src = allocWithData<int>(kElements);
  auto *loaded = alloc<int>(kWave);
  auto *concurrent = alloc<int>(kWave);
  tensor_load_padding_kernel<kPadOffset + kPadBytes><<<1, 2 * kWave, kTileBytes + kPadBytes>>>(
      describe({.global = src, .pad = true, .pad_interval = 3, .pad_amount = 3}), loaded,
      concurrent);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace(kTensorLoadThenReadRace);
}

// --- LDS addresses past the workgroup's allocation ---

// A 2048-byte allocation, one LDS block, with the tile's second half past it.
// Out-of-range LDS addresses do not abort a tensor operation (CDNA5 ISA
// 4.10.7); the in-range half transfers normally.
constexpr int kLdsAllocation = 2048;
constexpr uint32_t kStraddlingOffset = kLdsAllocation - kTileBytes / 2;

__global__ void tensor_load_past_lds_allocation_kernel(TensorDesc desc, int *dst) {
  tensorLoad(desc);
  waitTensorcnt<0>();
  if (lane() < 16)
    dst[lane()] = ldsRead(kStraddlingOffset + lane() * 4);
}

TEST_F(Gfx1250RaceTest, tensor_load_past_lds_allocation) {
  auto *src = allocWithData<int>(kElements);
  auto *dst = allocFilled(kElements / 2, kSentinel);
  tensor_load_past_lds_allocation_kernel<<<1, kWave, kLdsAllocation>>>(
      describe({.global = src, .lds_offset = kStraddlingOffset}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0, kElements / 2));
}

__global__ void tensor_store_past_lds_allocation_kernel(TensorDesc desc) {
  if (lane() < 16)
    ldsWrite(kStraddlingOffset + lane() * 4, 100 + lane());
  waitDscnt();
  tensorStore(desc);
  waitTensorcnt<0>();
}

TEST_F(Gfx1250RaceTest, tensor_store_past_lds_allocation) {
  auto *dst = alloc<int>(kElements);
  tensor_store_past_lds_allocation_kernel<<<1, kWave, kLdsAllocation>>>(
      describe({.global = dst, .lds_offset = kStraddlingOffset}));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  // The guide does not define the global values written from out-of-range LDS.
  std::vector<int> stored(kElements);
  RACE_HIP_CHECK(hipMemcpy(stored.data(), dst, kTileBytes, hipMemcpyDeviceToHost));
  stored.resize(kElements / 2);
  EXPECT_EQ(stored, range(100, kElements / 2));
}

// --- Compiler-generated tensor load ---

// The builtin issues the load; the compiler emits no s_wait_tensorcnt for it,
// so the kernel adds one, and schedules the LDS accesses and their waits.
__global__ void tensor_load_builtin_kernel(TensorDesc desc, int *dst) {
  __shared__ int tile[kElements];
  tile[threadIdx.x] = kSentinel;
  __syncthreads();
  const v4i zero4 = {0, 0, 0, 0};
  const v8i zero8 = {0, 0, 0, 0, 0, 0, 0, 0};
  __builtin_amdgcn_tensor_load_to_lds(desc.group0, desc.group1, zero4, zero4, zero8, 0);
  waitTensorcnt<0>();
  dst[threadIdx.x] = tile[threadIdx.x];
}

TEST_F(Gfx1250RaceTest, tensor_load_builtin) {
  auto *src = allocWithData<int>(kElements);
  auto *dst = alloc<int>(kWave);
  // `tile` is the kernel's only LDS allocation, so it starts at offset 0.
  tensor_load_builtin_kernel<<<1, kWave>>>(describe({.global = src}), dst);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectNoRace();
  ExpectValues(dst, range(0));
}

} // namespace
