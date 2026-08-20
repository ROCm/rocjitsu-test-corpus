// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "memory_test_harness.hpp"

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <iterator>
#include <vector>

namespace {
using namespace memory_isa_test;

using TensorGroup0 = u32x4;
using TensorGroup1 = u32x8;
using TensorGroup2 = u32x4;
using TensorGroup3 = u32x4;

__device__ TensorGroup0 tensor_group0(const void *global, std::uint32_t lds_address,
                                      bool gather = false, bool index32 = false) {
  const std::uint64_t address = reinterpret_cast<std::uint64_t>(global);
  return {1u | (std::uint32_t{gather} << 31) | (std::uint32_t{index32} << 30), lds_address,
          static_cast<std::uint32_t>(address),
          static_cast<std::uint32_t>((address >> 32) & 0x01ffffffu) | 0x80000000u};
}

__device__ TensorGroup1 tensor_group1(unsigned data_size_log2, unsigned tensor0, unsigned tensor1,
                                      unsigned tile0, unsigned tile1 = 1, unsigned tile2 = 1,
                                      std::uint64_t stride0 = 0, std::uint64_t stride1 = 0,
                                      std::uint32_t flags = 0, unsigned barrier_address = 0) {
  return {(data_size_log2 << 16) | flags,
          (tensor0 << 16) | (barrier_address >> 3),
          (tensor0 >> 16) | (tensor1 << 16),
          (tensor1 >> 16) | (tile0 << 16),
          tile1 | (tile2 << 16),
          static_cast<std::uint32_t>(stride0),
          static_cast<std::uint32_t>((stride0 >> 32) | (stride1 << 16)),
          static_cast<std::uint32_t>(stride1 >> 16)};
}

__device__ TensorGroup2 tensor_group2(unsigned tensor2, unsigned tensor3, std::uint64_t stride2,
                                      unsigned tile3) {
  return {tensor2, tensor3, static_cast<std::uint32_t>(stride2),
          static_cast<std::uint32_t>((stride2 >> 32) | (std::uint64_t{tile3} << 16))};
}

__device__ TensorGroup3 tensor_group3(std::uint64_t stride3, unsigned tensor4, unsigned tile4) {
  return {static_cast<std::uint32_t>(stride3),
          static_cast<std::uint32_t>((stride3 >> 32) | (std::uint64_t{tensor4} << 16)),
          (tensor4 >> 16) | (tile4 << 16), 0};
}

__device__ void tensor_load(TensorGroup0 group0, TensorGroup1 group1, TensorGroup2 group2 = {},
                            TensorGroup3 group3 = {}) {
  const u32x8 unused{};
  __builtin_amdgcn_tensor_load_to_lds(group0, group1, group2, group3, unused, 0);
}

__device__ void tensor_store(TensorGroup0 group0, TensorGroup1 group1, TensorGroup2 group2 = {},
                             TensorGroup3 group3 = {}) {
  const u32x8 unused{};
  __builtin_amdgcn_tensor_store_from_lds(group0, group1, group2, group3, unused, 0);
}

__device__ void wait_tensor() { __builtin_amdgcn_s_wait_tensorcnt(0); }

__device__ void wait_async() { __builtin_amdgcn_s_wait_asynccnt(0); }

struct BasicTensorResult {
  std::uint8_t two_d[15];
  std::uint16_t two_d_u16[6];
  std::uint32_t three_d[8];
  std::uint64_t five_d[8];
};

__global__ void basic_tensor_kernel(const std::uint8_t *two_d, const std::uint16_t *two_d_u16,
                                    const std::uint32_t *three_d, const std::uint64_t *five_d,
                                    std::uint32_t *store_output, BasicTensorResult *result) {
  __shared__ __align__(16) std::uint8_t lds[512];
  const unsigned lane = threadIdx.x;
  if (lane < 6)
    reinterpret_cast<std::uint32_t *>(lds + 384)[lane] = 0x61000000u + lane;
  __syncthreads();

  tensor_load(tensor_group0(two_d, 0), tensor_group1(0, 7, 4, 5, 3, 0, 11));
  tensor_load(tensor_group0(two_d_u16, 256), tensor_group1(1, 4, 2, 3, 2, 0, 6));
  tensor_load(tensor_group0(three_d, 64), tensor_group1(2, 3, 3, 2, 2, 2, 5, 20),
              tensor_group2(2, 1, 0, 1), tensor_group3(0, 1, 1));
  tensor_load(tensor_group0(five_d, 128), tensor_group1(3, 2, 2, 2, 1, 2, 3, 9),
              tensor_group2(2, 2, 27, 1), tensor_group3(81, 2, 2));
  tensor_store(tensor_group0(store_output, 384), tensor_group1(2, 3, 2, 3, 2, 0, 3));
  wait_tensor();
  __syncthreads();

  if (lane < 15)
    result->two_d[lane] = lds[lane];
  if (lane < 6)
    result->two_d_u16[lane] = reinterpret_cast<std::uint16_t *>(lds + 256)[lane];
  if (lane < 8) {
    result->three_d[lane] = reinterpret_cast<std::uint32_t *>(lds + 64)[lane];
    result->five_d[lane] = reinterpret_cast<std::uint64_t *>(lds + 128)[lane];
  }
}

struct EdgeTensorResult {
  std::uint32_t padded[10];
  std::uint32_t oob[12];
  std::uint64_t barrier;
};

__global__ void edge_tensor_kernel(const std::uint32_t *padding_input,
                                   const std::uint32_t *oob_input,
                                   std::uint32_t *padding_store_output,
                                   std::uint32_t *oob_store_output, EdgeTensorResult *result) {
  __shared__ __align__(16) std::uint8_t lds[384];
  const unsigned lane = threadIdx.x;
  if (lane < 10)
    reinterpret_cast<std::uint32_t *>(lds)[lane] = kWordCanary;
  if (lane < 12)
    reinterpret_cast<std::uint32_t *>(lds + 64)[lane] = kWordCanary;
  if (lane < 8)
    reinterpret_cast<std::uint32_t *>(lds + 128)[lane] = 0x66000000u + lane;
  if (lane < 12)
    reinterpret_cast<std::uint32_t *>(lds + 192)[lane] = 0x67000000u + lane;
  if (lane == 0)
    *reinterpret_cast<std::uint64_t *>(lds + 320) = 0x0000000200000002ull;
  __syncthreads();

  constexpr std::uint32_t padding_flags = (1u << 20) | (1u << 22) | (1u << 25);
  tensor_load(tensor_group0(padding_input, 0),
              tensor_group1(2, 8, 1, 8, 1, 0, 8, 0, padding_flags));
  constexpr std::uint32_t barrier_flag = 1u << 18;
  tensor_load(tensor_group0(oob_input, 64),
              tensor_group1(2, 3, 2, 4, 3, 0, 3, 0, barrier_flag, 320));
  tensor_store(tensor_group0(padding_store_output, 128),
               tensor_group1(2, 8, 1, 8, 1, 0, 8, 0, padding_flags));
  tensor_store(tensor_group0(oob_store_output, 192), tensor_group1(2, 3, 2, 4, 3, 0, 3));
  wait_tensor();
  wait_async();
  __syncthreads();
  if (lane < 10)
    result->padded[lane] = reinterpret_cast<std::uint32_t *>(lds)[lane];
  if (lane < 12)
    result->oob[lane] = reinterpret_cast<std::uint32_t *>(lds + 64)[lane];
  if (lane == 0)
    result->barrier = *reinterpret_cast<std::uint64_t *>(lds + 320);
}

struct GatherTensorResult {
  std::uint32_t gather16[6];
  std::uint32_t gather32[6];
};

__global__ void gather_tensor_kernel(const std::uint32_t *input, std::uint32_t *scatter16,
                                     std::uint32_t *scatter32, GatherTensorResult *result) {
  __shared__ __align__(16) std::uint32_t lds[64];
  const unsigned lane = threadIdx.x;
  if (lane < 6) {
    lds[32 + lane] = 0x71000000u + lane;
    lds[40 + lane] = 0x72000000u + lane;
  }
  __syncthreads();

  const TensorGroup2 indices16 = {1u | (4u << 16), 5u, 0, 0};
  const TensorGroup2 indices32 = {0u, 2u, 5u, 0};
  const TensorGroup3 no_more_indices{};
  const auto dimensions = tensor_group1(2, 2, 6, 2, 3, 0, 2);
  tensor_load(tensor_group0(input, 0, true, false), dimensions, indices16, no_more_indices);
  tensor_load(tensor_group0(input, 32, true, true), dimensions, indices32, no_more_indices);
  tensor_store(tensor_group0(scatter16, 32 * sizeof(std::uint32_t), true, false), dimensions,
               indices16, no_more_indices);
  tensor_store(tensor_group0(scatter32, 40 * sizeof(std::uint32_t), true, true), dimensions,
               indices32, no_more_indices);
  wait_tensor();
  __syncthreads();
  if (lane < 6) {
    result->gather16[lane] = lds[lane];
    result->gather32[lane] = lds[8 + lane];
  }
}

__global__ void iterate_tensor_kernel(const std::uint32_t *input, std::uint32_t *output) {
  __shared__ __align__(16) std::uint32_t lds[16];
  const unsigned lane = threadIdx.x;
  if (lane < 8)
    lds[lane] = kWordCanary;
  __syncthreads();
  constexpr std::uint32_t iterate_flag = 1u << 19;
  const auto dimensions = tensor_group1(2, 2, 3, 2, 2, 0, 2, 0, iterate_flag);
  const TensorGroup2 iteration = {0, 4, 4, 1u << 16};
  tensor_load(tensor_group0(input, 0), dimensions, iteration, {});
  wait_tensor();
  __syncthreads();
  if (lane < 8)
    output[lane] = lds[lane];
}

template <class T> std::vector<T> patterned(std::size_t count, T base) {
  std::vector<T> values(count);
  for (std::size_t i = 0; i < count; ++i)
    values[i] = static_cast<T>(base + static_cast<T>(i));
  return values;
}
} // namespace

TEST(Gfx1250MemoryIsaTensor, TwoThreeAndFiveDimensionalAddressingAndStore) {
  REQUIRE_GFX1250_DEVICE();
  auto host2 = patterned<std::uint8_t>(44, 0x10);
  auto host2u16 = patterned<std::uint16_t>(12, 0x4100);
  auto host3 = patterned<std::uint32_t>(40, 0x51000000u);
  auto host5 = patterned<std::uint64_t>(164, 0x5200000000000000ull);
  auto input2 = DeviceBuffer<std::uint8_t>::from_host(host2);
  auto input2u16 = DeviceBuffer<std::uint16_t>::from_host(host2u16);
  auto input3 = DeviceBuffer<std::uint32_t>::from_host(host3);
  auto input5 = DeviceBuffer<std::uint64_t>::from_host(host5);
  auto store = DeviceBuffer<std::uint32_t>::from_host(std::vector<std::uint32_t>(8, kWordCanary));
  auto result = DeviceBuffer<BasicTensorResult>::allocate(1);
  ASSERT_TRUE(input2 && input2u16 && input3 && input5 && store && result);
  basic_tensor_kernel<<<1, kWaveLanes>>>(input2.get(), input2u16.get(), input3.get(), input5.get(),
                                         store.get(), result.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const auto actual = result.to_host().front();
  for (unsigned y = 0; y < 3; ++y)
    for (unsigned x = 0; x < 5; ++x)
      EXPECT_EQ(actual.two_d[y * 5 + x], host2[y * 11 + x]) << "2D (" << x << ',' << y << ')';
  for (unsigned y = 0; y < 2; ++y)
    for (unsigned x = 0; x < 3; ++x)
      EXPECT_EQ(actual.two_d_u16[y * 3 + x], host2u16[y * 6 + x]);
  unsigned compact = 0;
  for (unsigned z = 0; z < 2; ++z)
    for (unsigned y = 0; y < 2; ++y)
      for (unsigned x = 0; x < 2; ++x)
        EXPECT_EQ(actual.three_d[compact++], host3[z * 20 + y * 5 + x]);
  compact = 0;
  for (unsigned q = 0; q < 2; ++q)
    for (unsigned w = 0; w < 1; ++w)
      for (unsigned z = 0; z < 2; ++z)
        for (unsigned y = 0; y < 1; ++y)
          for (unsigned x = 0; x < 2; ++x)
            EXPECT_EQ(actual.five_d[compact++], host5[q * 81 + w * 27 + z * 9 + y * 3 + x]);
  const auto stored = store.to_host();
  for (unsigned i = 0; i < 6; ++i)
    EXPECT_EQ(stored[i], 0x61000000u + i);
  EXPECT_EQ(stored[6], kWordCanary);
  EXPECT_EQ(stored[7], kWordCanary);
}

TEST(Gfx1250MemoryIsaTensor, PaddingOobZeroFillAndBarrierArrival) {
  REQUIRE_GFX1250_DEVICE();
  auto padding = DeviceBuffer<std::uint32_t>::from_host(patterned<std::uint32_t>(8, 0x62000000u));
  auto oob = DeviceBuffer<std::uint32_t>::from_host(patterned<std::uint32_t>(8, 0x63000000u));
  auto result = DeviceBuffer<EdgeTensorResult>::allocate(1);
  auto padding_store =
      DeviceBuffer<std::uint32_t>::from_host(std::vector<std::uint32_t>(10, kWordCanary));
  auto oob_store =
      DeviceBuffer<std::uint32_t>::from_host(std::vector<std::uint32_t>(12, kWordCanary));
  ASSERT_TRUE(padding && oob && padding_store && oob_store && result);
  edge_tensor_kernel<<<1, kWaveLanes>>>(padding.get(), oob.get(), padding_store.get(),
                                        oob_store.get(), result.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const auto actual = result.to_host().front();
  for (unsigned i = 0; i < 4; ++i)
    EXPECT_EQ(actual.padded[i], 0x62000000u + i);
  EXPECT_EQ(actual.padded[4], kWordCanary);
  EXPECT_EQ(actual.padded[5], kWordCanary);
  for (unsigned i = 0; i < 4; ++i)
    EXPECT_EQ(actual.padded[6 + i], 0x62000004u + i);
  EXPECT_EQ(actual.barrier, 0x0000000200000001ull);
  for (unsigned y = 0; y < 3; ++y)
    for (unsigned x = 0; x < 4; ++x) {
      const std::uint32_t expected = x < 3 && y < 2 ? 0x63000000u + y * 3 + x : 0;
      EXPECT_EQ(actual.oob[y * 4 + x], expected) << "(" << x << ',' << y << ')';
    }
  const auto stored_padding = padding_store.to_host();
  for (unsigned i = 0; i < 8; ++i)
    EXPECT_EQ(stored_padding[i], 0x66000000u + i);
  EXPECT_EQ(stored_padding[8], kWordCanary);
  EXPECT_EQ(stored_padding[9], kWordCanary);
  const auto stored_oob = oob_store.to_host();
  for (unsigned y = 0; y < 2; ++y)
    for (unsigned x = 0; x < 3; ++x)
      EXPECT_EQ(stored_oob[y * 3 + x], 0x67000000u + y * 4 + x);
  for (unsigned i = 6; i < 12; ++i)
    EXPECT_EQ(stored_oob[i], kWordCanary);
}

TEST(Gfx1250MemoryIsaTensor, GatherAndScatterUseSixteenAndThirtyTwoBitIndices) {
  REQUIRE_GFX1250_DEVICE();
  auto input = DeviceBuffer<std::uint32_t>::from_host(patterned<std::uint32_t>(12, 0x64000000u));
  auto scatter16 =
      DeviceBuffer<std::uint32_t>::from_host(std::vector<std::uint32_t>(12, kWordCanary));
  auto scatter32 =
      DeviceBuffer<std::uint32_t>::from_host(std::vector<std::uint32_t>(12, kWordCanary));
  auto result = DeviceBuffer<GatherTensorResult>::allocate(1);
  ASSERT_TRUE(input && scatter16 && scatter32 && result);
  gather_tensor_kernel<<<1, kWaveLanes>>>(input.get(), scatter16.get(), scatter32.get(),
                                          result.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const auto actual = result.to_host().front();
  const unsigned index16[] = {1, 4, 5};
  const unsigned index32[] = {0, 2, 5};
  for (unsigned row = 0; row < 3; ++row)
    for (unsigned x = 0; x < 2; ++x) {
      EXPECT_EQ(actual.gather16[row * 2 + x], 0x64000000u + index16[row] * 2 + x);
      EXPECT_EQ(actual.gather32[row * 2 + x], 0x64000000u + index32[row] * 2 + x);
    }
  const auto scattered16 = scatter16.to_host();
  const auto scattered32 = scatter32.to_host();
  for (unsigned row = 0; row < 6; ++row)
    for (unsigned x = 0; x < 2; ++x) {
      const auto at16 = std::find(std::begin(index16), std::end(index16), row);
      const auto at32 = std::find(std::begin(index32), std::end(index32), row);
      const std::uint32_t expected16 = at16 == std::end(index16)
                                           ? kWordCanary
                                           : 0x71000000u + (at16 - std::begin(index16)) * 2 + x;
      const std::uint32_t expected32 = at32 == std::end(index32)
                                           ? kWordCanary
                                           : 0x72000000u + (at32 - std::begin(index32)) * 2 + x;
      EXPECT_EQ(scattered16[row * 2 + x], expected16);
      EXPECT_EQ(scattered32[row * 2 + x], expected32);
    }
}

TEST(Gfx1250MemoryIsaTensor, IterationCompactsRowsAndZeroFillsPastTensorExtent) {
  REQUIRE_GFX1250_DEVICE();
  auto input = DeviceBuffer<std::uint32_t>::from_host(patterned<std::uint32_t>(8, 0x65000000u));
  auto output = DeviceBuffer<std::uint32_t>::allocate(8);
  ASSERT_TRUE(input && output);
  iterate_tensor_kernel<<<1, kWaveLanes>>>(input.get(), output.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const auto actual = output.to_host();
  for (unsigned i = 0; i < 6; ++i)
    EXPECT_EQ(actual[i], 0x65000000u + i);
  EXPECT_EQ(actual[6], 0u);
  EXPECT_EQ(actual[7], 0u);
}
