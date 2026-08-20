// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "memory_test_harness.hpp"

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <vector>

namespace {
using namespace memory_isa_test;

constexpr unsigned kStoreRegionBytes = 160;
constexpr unsigned kStoreSlotBytes = 32;
constexpr unsigned kStorePayloadOffset = 8;

struct GlobalResult {
  std::uint32_t b32;
  u32x2 b64;
  u32x3 b96;
  u32x4 b128;
  std::uint32_t flat;
};

__global__ void global_flat_kernel(const std::uint8_t *input, std::uint8_t *output,
                                   GlobalResult *load_results) {
  const unsigned lane = threadIdx.x;
  if ((lane & 1u) != 0)
    return;

  const std::uint64_t input_address = reinterpret_cast<std::uint64_t>(input + lane * 64);
  GlobalResult values{};
  asm volatile("global_load_b32 %0, %5, off offset:0\n\t"
               "global_load_b64 %1, %5, off offset:4\n\t"
               "global_load_b96 %2, %5, off offset:12\n\t"
               "global_load_b128 %3, %5, off offset:24\n\t"
               "flat_load_b32 %4, %5 offset:40\n\t"
               "s_wait_loadcnt 0\n\t"
               "s_wait_dscnt 0"
               : "=v"(values.b32), "=v"(values.b64), "=v"(values.b96), "=v"(values.b128),
                 "=v"(values.flat)
               : "v"(input_address)
               : "memory");
  load_results[lane] = values;

  const std::uint64_t output_address =
      reinterpret_cast<std::uint64_t>(output + lane * kStoreRegionBytes);
  asm volatile("global_store_b32 %0, %1, off offset:8\n\t"
               "global_store_b64 %0, %2, off offset:40\n\t"
               "global_store_b96 %0, %3, off offset:72\n\t"
               "global_store_b128 %0, %4, off offset:104\n\t"
               "flat_store_b32 %0, %5 offset:136\n\t"
               "s_wait_storecnt 0\n\t"
               "s_wait_dscnt 0"
               :
               : "v"(output_address), "v"(values.b32), "v"(values.b64), "v"(values.b96),
                 "v"(values.b128), "v"(values.flat)
               : "memory");
}

std::uint32_t word_at(const std::vector<std::uint8_t> &bytes, std::size_t offset) {
  std::uint32_t value = 0;
  std::memcpy(&value, bytes.data() + offset, sizeof(value));
  return value;
}
} // namespace

TEST(Gfx1250MemoryIsaGlobalFlat, WidthsOffsetsAndExecMaskMatchManual) {
  REQUIRE_GFX1250_DEVICE();
  std::vector<std::uint8_t> input(kWaveLanes * 64);
  for (unsigned lane = 0; lane < kWaveLanes; ++lane)
    for (unsigned byte = 0; byte < 64; ++byte)
      input[lane * 64 + byte] = coordinate_byte(byte, lane);
  std::vector<std::uint8_t> initial(kWaveLanes * kStoreRegionBytes, kByteCanary);

  auto device_input = DeviceBuffer<std::uint8_t>::from_host(input);
  auto device_output = DeviceBuffer<std::uint8_t>::from_host(initial);
  auto device_load_results = DeviceBuffer<GlobalResult>::allocate(kWaveLanes);
  ASSERT_TRUE(device_input);
  ASSERT_TRUE(device_output);
  ASSERT_TRUE(device_load_results);
  global_flat_kernel<<<1, kWaveLanes>>>(device_input.get(), device_output.get(),
                                        device_load_results.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const std::vector<std::uint8_t> actual = device_output.to_host();
  const auto load_results = device_load_results.to_host();
  std::vector<std::uint8_t> expected(initial);

  for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
    if ((lane & 1u) != 0)
      continue;
    const std::size_t input_base = lane * 64;
    const std::size_t store_base = lane * kStoreRegionBytes;
    const GlobalResult &loads = load_results[lane];
    EXPECT_EQ(loads.b32, word_at(input, input_base));
    for (unsigned i = 0; i < 2; ++i)
      EXPECT_EQ(loads.b64[i], word_at(input, input_base + 4 + 4 * i));
    for (unsigned i = 0; i < 3; ++i)
      EXPECT_EQ(loads.b96[i], word_at(input, input_base + 12 + 4 * i));
    for (unsigned i = 0; i < 4; ++i)
      EXPECT_EQ(loads.b128[i], word_at(input, input_base + 24 + 4 * i));
    EXPECT_EQ(loads.flat, word_at(input, input_base + 40));
    constexpr unsigned widths[] = {4, 8, 12, 16, 4};
    constexpr unsigned source_offsets[] = {0, 4, 12, 24, 40};
    for (unsigned slot = 0; slot < 5; ++slot)
      std::copy_n(input.begin() + input_base + source_offsets[slot], widths[slot],
                  expected.begin() + store_base + slot * kStoreSlotBytes + kStorePayloadOffset);
  }
  expect_bytes_equal(actual, expected, "global and FLAT stores");
}
