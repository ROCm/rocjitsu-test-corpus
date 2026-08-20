// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "memory_test_harness.hpp"

#include <cstddef>
#include <cstdint>
#include <cstring>
#include <vector>

namespace {
using namespace memory_isa_test;

struct TransposeResult {
  std::uint8_t tr4[8];
  std::uint8_t tr6[12];
  std::uint8_t tr8[8];
  std::uint8_t tr16[16];
};

static_assert(sizeof(u32x3) == 16, "three-component vectors use four-component storage");
static_assert(sizeof(TransposeResult{}.tr6) == 12, "TR6 has a 96-bit architectural payload");

__global__ void global_transpose_kernel(const std::uint8_t *tr4, const std::uint8_t *tr6,
                                        const std::uint8_t *tr8, const std::uint8_t *tr16,
                                        TransposeResult *output) {
  const unsigned lane = threadIdx.x;
  const unsigned row_half = (lane >> 3) & 1u;
  const unsigned column16 = (lane & 7u) + 8u * (lane >> 4);
  const unsigned pass6 = (lane >> 2) & 1u;
  const unsigned column6 = 4u * (lane >> 3) + (lane & 3u) + 16u * pass6;
  u32x2 r4;
  u32x3 r6;
  u32x2 r8;
  u32x4 r16;
  asm volatile("global_load_tr4_b64 %0, %4, off\n\t"
               "global_load_tr6_b96 %1, %5, off\n\t"
               "global_load_tr8_b64 %2, %6, off\n\t"
               "global_load_tr16_b128 %3, %7, off\n\t"
               "s_wait_loadcnt 0"
               : "=v"(r4), "=v"(r6), "=v"(r8), "=v"(r16)
               : "v"(reinterpret_cast<std::uint64_t>(tr4 + lane * 8)),
                 "v"(reinterpret_cast<std::uint64_t>(tr6 + column6 * 12)),
                 "v"(reinterpret_cast<std::uint64_t>(tr8 + column16 * 16 + row_half * 8)),
                 "v"(reinterpret_cast<std::uint64_t>(tr16 + column16 * 32 + row_half * 16))
               : "memory");
  __builtin_memcpy(output[lane].tr4, &r4, sizeof(r4));
  __builtin_memcpy(output[lane].tr6, &r6, sizeof(output[lane].tr6));
  __builtin_memcpy(output[lane].tr8, &r8, sizeof(r8));
  __builtin_memcpy(output[lane].tr16, &r16, sizeof(r16));
}

__global__ void lds_transpose_kernel(const std::uint8_t *tr4, const std::uint8_t *tr6,
                                     const std::uint8_t *tr8, const std::uint8_t *tr16,
                                     TransposeResult *output) {
  __shared__ __align__(16) std::uint8_t lds4[kWaveLanes * 8];
  __shared__ __align__(16) std::uint8_t lds6[kWaveLanes * 12];
  __shared__ __align__(16) std::uint8_t lds8[kWaveLanes * 8];
  __shared__ __align__(16) std::uint8_t lds16[kWaveLanes * 16];
  const unsigned lane = threadIdx.x;
  const unsigned row_half = (lane >> 3) & 1u;
  const unsigned column16 = (lane & 7u) + 8u * (lane >> 4);
  const unsigned pass6 = (lane >> 2) & 1u;
  const unsigned column6 = 4u * (lane >> 3) + (lane & 3u) + 16u * pass6;
  for (unsigned i = 0; i < 8; ++i) {
    lds4[lane * 8 + i] = tr4[lane * 8 + i];
    lds8[lane * 8 + i] = tr8[lane * 8 + i];
  }
  for (unsigned i = 0; i < 12; ++i)
    lds6[lane * 12 + i] = tr6[lane * 12 + i];
  for (unsigned i = 0; i < 16; ++i)
    lds16[lane * 16 + i] = tr16[lane * 16 + i];
  __syncthreads();

  u32x2 r4;
  u32x3 r6;
  u32x2 r8;
  u32x4 r16;
  using i32x2 = int __attribute__((ext_vector_type(2)));
  using i32x3 = int __attribute__((ext_vector_type(3)));
  using f16x8 = __fp16 __attribute__((ext_vector_type(8)));
  const auto b4 = __builtin_amdgcn_ds_load_tr4_b64_v2i32(
      (i32x2 __attribute__((address_space(3))) *)(lds4 + lane * 8));
  const auto b6 = __builtin_amdgcn_ds_load_tr6_b96_v3i32(
      (i32x3 __attribute__((address_space(3))) *)(lds6 + column6 * 12));
  const auto b8 = __builtin_amdgcn_ds_load_tr8_b64_v2i32(
      (i32x2 __attribute__((address_space(3))) *)(lds8 + column16 * 16 + row_half * 8));
  const auto b16 = __builtin_amdgcn_ds_load_tr16_b128_v8f16(
      (f16x8 __attribute__((address_space(3))) *)(lds16 + column16 * 32 + row_half * 16));
  __builtin_memcpy(&r4, &b4, sizeof(r4));
  __builtin_memcpy(&r6, &b6, sizeof(r6));
  __builtin_memcpy(&r8, &b8, sizeof(r8));
  __builtin_memcpy(&r16, &b16, sizeof(r16));
  __builtin_memcpy(output[lane].tr4, &r4, sizeof(r4));
  __builtin_memcpy(output[lane].tr6, &r6, sizeof(output[lane].tr6));
  __builtin_memcpy(output[lane].tr8, &r8, sizeof(r8));
  __builtin_memcpy(output[lane].tr16, &r16, sizeof(r16));
}

std::uint32_t coordinate_value(unsigned element_bits, unsigned m, unsigned k, unsigned trial) {
  const std::uint32_t mask = (1u << element_bits) - 1u;
  const std::uint32_t coordinate_id = 16u * k + m;
  const unsigned shift = trial * element_bits;
  return shift < 32 ? (coordinate_id >> shift) & mask : 0;
}

std::vector<std::uint8_t> pack_column_major(unsigned element_bits, unsigned columns,
                                            unsigned trial) {
  const std::size_t byte_count = 16u * columns * element_bits / 8u;
  std::vector<std::uint8_t> packed(byte_count, 0);
  for (unsigned k = 0; k < columns; ++k) {
    for (unsigned m = 0; m < 16; ++m) {
      const std::uint32_t value = coordinate_value(element_bits, m, k, trial);
      const std::size_t bit = (k * 16u + m) * element_bits;
      for (unsigned b = 0; b < element_bits; ++b)
        packed[(bit + b) / 8] |= ((value >> b) & 1u) << ((bit + b) % 8);
    }
  }
  return packed;
}

std::vector<std::uint8_t> expected_row_major(unsigned element_bits, unsigned columns,
                                             unsigned trial) {
  std::vector<std::uint8_t> packed(kWaveLanes * columns * element_bits / 16u, 0);
  const unsigned elements_per_lane = columns / 2;
  for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
    const unsigned m = lane % 16;
    const unsigned first_k = (lane / 16) * elements_per_lane;
    const std::size_t lane_bit_base = lane * elements_per_lane * element_bits;
    for (unsigned i = 0; i < elements_per_lane; ++i) {
      const std::uint32_t value = coordinate_value(element_bits, m, first_k + i, trial);
      const std::size_t bit = lane_bit_base + i * element_bits;
      for (unsigned b = 0; b < element_bits; ++b)
        packed[(bit + b) / 8] |= ((value >> b) & 1u) << ((bit + b) % 8);
    }
  }
  return packed;
}

std::vector<std::uint8_t> expected_tr4(unsigned trial) {
  std::vector<std::uint8_t> packed(kWaveLanes * 8, 0);
  for (unsigned m = 0; m < 16; ++m) {
    for (unsigned k = 0; k < 32; ++k) {
      const unsigned lane = m + 16u * ((k >> 3) & 1u);
      const unsigned slot = (k & 7u) + 8u * (k >> 4);
      const std::uint8_t value = static_cast<std::uint8_t>(coordinate_value(4, m, k, trial));
      const std::size_t bit = lane * 64u + slot * 4u;
      packed[bit / 8] |= value << (bit % 8);
    }
  }
  return packed;
}

void check_results(const std::vector<TransposeResult> &actual, const char *space, unsigned trial) {
  const auto expected4 = expected_tr4(trial);
  const auto expected6 = expected_row_major(6, 32, trial);
  const auto expected8 = expected_row_major(8, 16, trial);
  const auto expected16 = expected_row_major(16, 16, trial);
  for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
    EXPECT_EQ(std::memcmp(actual[lane].tr4, expected4.data() + lane * 8, 8), 0)
        << space << " tr4 trial " << trial << " lane " << lane;
    EXPECT_EQ(std::memcmp(actual[lane].tr6, expected6.data() + lane * 12, 12), 0)
        << space << " tr6 trial " << trial << " lane " << lane;
    EXPECT_EQ(std::memcmp(actual[lane].tr8, expected8.data() + lane * 8, 8), 0)
        << space << " tr8 trial " << trial << " lane " << lane;
    EXPECT_EQ(std::memcmp(actual[lane].tr16, expected16.data() + lane * 16, 16), 0)
        << space << " tr16 trial " << trial << " lane " << lane;
  }
}

template <class Kernel> void run_transpose_test(Kernel kernel, const char *space) {
  for (unsigned trial = 0; trial < 3; ++trial) {
    const auto host4 = pack_column_major(4, 32, trial);
    const auto host6 = pack_column_major(6, 32, trial);
    const auto host8 = pack_column_major(8, 16, trial);
    const auto host16 = pack_column_major(16, 16, trial);
    auto device4 = DeviceBuffer<std::uint8_t>::from_host(host4);
    auto device6 = DeviceBuffer<std::uint8_t>::from_host(host6);
    auto device8 = DeviceBuffer<std::uint8_t>::from_host(host8);
    auto device16 = DeviceBuffer<std::uint8_t>::from_host(host16);
    auto output = DeviceBuffer<TransposeResult>::allocate(kWaveLanes);
    ASSERT_TRUE(device4);
    ASSERT_TRUE(device6);
    ASSERT_TRUE(device8);
    ASSERT_TRUE(device16);
    ASSERT_TRUE(output);
    kernel<<<1, kWaveLanes>>>(device4.get(), device6.get(), device8.get(), device16.get(),
                              output.get());
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());
    check_results(output.to_host(), space, trial);
  }
}
} // namespace

TEST(Gfx1250MemoryIsaTranspose, GlobalLoadsProduceDocumentedWmmaCoordinates) {
  REQUIRE_GFX1250_DEVICE();
  run_transpose_test(global_transpose_kernel, "global");
}

TEST(Gfx1250MemoryIsaTranspose, LdsLoadsProduceDocumentedWmmaCoordinates) {
  REQUIRE_GFX1250_DEVICE();
  run_transpose_test(lds_transpose_kernel, "lds");
}
