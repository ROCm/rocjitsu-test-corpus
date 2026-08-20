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

constexpr unsigned kStoreRegionBytes = 256;
constexpr unsigned kStoreSlotBytes = 32;
constexpr unsigned kStorePayloadOffset = 8;

struct BufferLoads {
  std::uint32_t u8;
  std::uint32_t i8;
  std::uint32_t u16;
  std::uint32_t i16;
  std::uint32_t b32;
  u32x2 b64;
  u32x3 b96;
  u32x4 b128;
};

__global__ void buffer_width_kernel(u32x4 input_resource, u32x4 output_resource,
                                    BufferLoads *load_results) {
  const std::uint32_t input_offset = threadIdx.x * 64;
  const std::uint32_t output_offset = threadIdx.x * kStoreRegionBytes;
  BufferLoads values{};
  asm volatile("buffer_load_u8 %0, %8, %9, null offen offset:0\n\t"
               "buffer_load_i8 %1, %8, %9, null offen offset:1\n\t"
               "buffer_load_u16 %2, %8, %9, null offen offset:2\n\t"
               "buffer_load_i16 %3, %8, %9, null offen offset:4\n\t"
               "buffer_load_b32 %4, %8, %9, null offen offset:8\n\t"
               "buffer_load_b64 %5, %8, %9, null offen offset:12\n\t"
               "buffer_load_b96 %6, %8, %9, null offen offset:20\n\t"
               "buffer_load_b128 %7, %8, %9, null offen offset:32\n\t"
               "s_wait_loadcnt 0"
               : "=v"(values.u8), "=v"(values.i8), "=v"(values.u16), "=v"(values.i16),
                 "=v"(values.b32), "=v"(values.b64), "=v"(values.b96), "=v"(values.b128)
               : "v"(input_offset), "s"(input_resource)
               : "memory");
  load_results[threadIdx.x] = values;
  asm volatile("buffer_store_b8 %0, %8, %9, null offen offset:8\n\t"
               "buffer_store_b16 %1, %8, %9, null offen offset:40\n\t"
               "buffer_store_b32 %2, %8, %9, null offen offset:72\n\t"
               "buffer_store_b64 %3, %8, %9, null offen offset:104\n\t"
               "buffer_store_b96 %4, %8, %9, null offen offset:136\n\t"
               "buffer_store_b128 %5, %8, %9, null offen offset:168\n\t"
               "buffer_store_b8 %6, %8, %9, null offen offset:200\n\t"
               "buffer_store_b16 %7, %8, %9, null offen offset:232\n\t"
               "s_wait_storecnt 0"
               :
               : "v"(values.u8), "v"(values.u16), "v"(values.b32), "v"(values.b64), "v"(values.b96),
                 "v"(values.b128), "v"(values.i8), "v"(values.i16), "v"(output_offset),
                 "s"(output_resource)
               : "memory");
}

__global__ void buffer_partial_oob_kernel(u32x4 resource, u32x4 *result) {
  const std::uint32_t offset = 56;
  u32x4 value{kWordCanary, kWordCanary, kWordCanary, kWordCanary};
  asm volatile("buffer_load_b128 %0, %1, %2, null offen\n\t"
               "s_wait_loadcnt 0"
               : "=v"(value)
               : "v"(offset), "s"(resource)
               : "memory");
  if (threadIdx.x == 0)
    *result = value;
}

std::uint32_t word_at(const std::vector<std::uint8_t> &bytes, std::size_t offset) {
  std::uint32_t value = 0;
  std::memcpy(&value, bytes.data() + offset, sizeof(value));
  return value;
}
} // namespace

TEST(Gfx1250MemoryIsaBuffer, WidthExtensionStoresAndCanariesMatchManual) {
  REQUIRE_GFX1250_DEVICE();
  std::vector<std::uint8_t> input(kWaveLanes * 64);
  for (unsigned lane = 0; lane < kWaveLanes; ++lane)
    for (unsigned byte = 0; byte < 64; ++byte)
      input[lane * 64 + byte] = coordinate_byte(byte, lane);
  input[1] = 0x81;
  input[4] = 0x01;
  input[5] = 0x80;
  std::vector<std::uint8_t> output(kWaveLanes * kStoreRegionBytes, kByteCanary);
  auto device_input = DeviceBuffer<std::uint8_t>::from_host(input);
  auto device_output = DeviceBuffer<std::uint8_t>::from_host(output);
  auto device_load_results = DeviceBuffer<BufferLoads>::allocate(kWaveLanes);
  ASSERT_TRUE(device_input);
  ASSERT_TRUE(device_output);
  ASSERT_TRUE(device_load_results);
  const u32x4 input_resource =
      make_buffer_resource(reinterpret_cast<std::uint64_t>(device_input.get()), input.size())
          .vector();
  const u32x4 output_resource =
      make_buffer_resource(reinterpret_cast<std::uint64_t>(device_output.get()), output.size())
          .vector();

  buffer_width_kernel<<<1, kWaveLanes>>>(input_resource, output_resource,
                                         device_load_results.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const auto actual = device_output.to_host();
  const auto load_results = device_load_results.to_host();
  std::vector<std::uint8_t> expected(output.size(), kByteCanary);
  for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
    const std::size_t base = lane * 64;
    const std::size_t store_base = lane * kStoreRegionBytes;
    const BufferLoads &loads = load_results[lane];
    const std::uint32_t expected_i8 = static_cast<std::uint32_t>(
        static_cast<std::int32_t>(static_cast<std::int8_t>(input[base + 1])));
    const std::uint32_t expected_u16 = word_at(input, base + 2) & 0xffffu;
    const std::uint32_t expected_i16 = static_cast<std::uint32_t>(
        static_cast<std::int32_t>(static_cast<std::int16_t>(word_at(input, base + 4))));
    EXPECT_EQ(loads.u8, input[base]);
    EXPECT_EQ(loads.i8, expected_i8);
    EXPECT_EQ(loads.u16, expected_u16);
    EXPECT_EQ(loads.i16, expected_i16);
    EXPECT_EQ(loads.b32, word_at(input, base + 8));
    for (unsigned i = 0; i < 2; ++i)
      EXPECT_EQ(loads.b64[i], word_at(input, base + 12 + 4 * i));
    for (unsigned i = 0; i < 3; ++i)
      EXPECT_EQ(loads.b96[i], word_at(input, base + 20 + 4 * i));
    for (unsigned i = 0; i < 4; ++i)
      EXPECT_EQ(loads.b128[i], word_at(input, base + 32 + 4 * i));

    constexpr unsigned widths[] = {1, 2, 4, 8, 12, 16, 1, 2};
    constexpr unsigned source_offsets[] = {0, 2, 8, 12, 20, 32, 1, 4};
    for (unsigned slot = 0; slot < 8; ++slot)
      std::copy_n(input.begin() + base + source_offsets[slot], widths[slot],
                  expected.begin() + store_base + slot * kStoreSlotBytes + kStorePayloadOffset);
  }
  expect_bytes_equal(actual, expected, "buffer stores");
}

TEST(Gfx1250MemoryIsaBuffer, PartialOobLoadZeroFillsEachDword) {
  REQUIRE_GFX1250_DEVICE();
  std::vector<std::uint8_t> input(64);
  for (unsigned i = 0; i < input.size(); ++i)
    input[i] = coordinate_byte(i, 7);
  auto device_input = DeviceBuffer<std::uint8_t>::from_host(input);
  auto device_result = DeviceBuffer<u32x4>::allocate(1);
  ASSERT_TRUE(device_input);
  ASSERT_TRUE(device_result);
  const u32x4 resource =
      make_buffer_resource(reinterpret_cast<std::uint64_t>(device_input.get()), input.size())
          .vector();
  buffer_partial_oob_kernel<<<1, kWaveLanes>>>(resource, device_result.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const u32x4 actual = device_result.to_host()[0];
  EXPECT_EQ(actual[0], word_at(input, 56));
  EXPECT_EQ(actual[1], word_at(input, 60));
  EXPECT_EQ(actual[2], 0u);
  EXPECT_EQ(actual[3], 0u);
}

TEST(Gfx1250MemoryIsaBuffer, DescriptorFieldsMatchCdna5Manual) {
  constexpr auto resource =
      make_buffer_resource(0x0123456789abcdefULL, 0x123456789abULL, 0x2345, 2, true, true);
  EXPECT_EQ(resource.words[0], 0x89abcdefu);
  EXPECT_EQ(resource.words[1] & 0x01ffffffu, 0x01234567u);
  EXPECT_EQ((resource.words[3] >> 12) & 0x3fffu, 0x2345u);
  EXPECT_EQ((resource.words[3] >> 26) & 0x3u, 2u);
  EXPECT_NE(resource.words[3] & (1u << 28), 0u);
  EXPECT_NE(resource.words[3] & (1u << 29), 0u);
}
