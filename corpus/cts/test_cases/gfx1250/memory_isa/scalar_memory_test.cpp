// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "memory_test_harness.hpp"

#include <cstddef>
#include <cstdint>
#include <vector>

namespace {
using namespace memory_isa_test;

struct ScalarResults {
  std::uint32_t b32;
  u32x2 b64;
  u32x3 b96;
  u32x4 b128;
  u32x8 b256;
  u32x16 b512;
  std::uint32_t i8;
  std::uint32_t u8;
  std::uint32_t i16;
  std::uint32_t u16;
};

__global__ void scalar_load_kernel(const std::uint8_t *input, ScalarResults *result) {
  const std::uint64_t address = reinterpret_cast<std::uint64_t>(input);
  ScalarResults values{};
  asm volatile("s_load_b32 %0, %10, 0\n\t"
               "s_load_b64 %1, %10, 4\n\t"
               "s_load_b96 %2, %10, 12\n\t"
               "s_load_b128 %3, %10, 24\n\t"
               "s_load_b256 %4, %10, 40\n\t"
               "s_load_b512 %5, %10, 72\n\t"
               "s_load_i8 %6, %10, 136\n\t"
               "s_load_u8 %7, %10, 137\n\t"
               "s_load_i16 %8, %10, 138\n\t"
               "s_load_u16 %9, %10, 140\n\t"
               "s_wait_kmcnt 0"
               : "=&s"(values.b32), "=&s"(values.b64), "=&s"(values.b96), "=&s"(values.b128),
                 "=&s"(values.b256), "=&s"(values.b512), "=&s"(values.i8), "=&s"(values.u8),
                 "=&s"(values.i16), "=&s"(values.u16)
               : "s"(address)
               : "memory");
  if (threadIdx.x == 0)
    *result = values;
}

std::uint32_t word_at(const std::vector<std::uint8_t> &bytes, std::size_t offset) {
  return static_cast<std::uint32_t>(bytes[offset]) |
         (static_cast<std::uint32_t>(bytes[offset + 1]) << 8) |
         (static_cast<std::uint32_t>(bytes[offset + 2]) << 16) |
         (static_cast<std::uint32_t>(bytes[offset + 3]) << 24);
}
} // namespace

TEST(Gfx1250MemoryIsaScalar, WidthExtensionAndImmediateAddressingMatchManual) {
  REQUIRE_GFX1250_DEVICE();
  std::vector<std::uint8_t> input(160);
  for (std::size_t i = 0; i < input.size(); ++i)
    input[i] = static_cast<std::uint8_t>(3u + 37u * i);
  input[136] = 0x81;
  input[137] = 0xfe;
  input[138] = 0x01;
  input[139] = 0x80;
  input[140] = 0xfe;
  input[141] = 0xca;

  auto device_input = DeviceBuffer<std::uint8_t>::from_host(input);
  auto device_result = DeviceBuffer<ScalarResults>::allocate(1);
  ASSERT_TRUE(device_input);
  ASSERT_TRUE(device_result);

  scalar_load_kernel<<<1, kWaveLanes>>>(device_input.get(), device_result.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const ScalarResults actual = device_result.to_host()[0];

  EXPECT_EQ(actual.b32, word_at(input, 0));
  for (unsigned i = 0; i < 2; ++i)
    EXPECT_EQ(actual.b64[i], word_at(input, 4 + 4 * i));
  for (unsigned i = 0; i < 3; ++i)
    EXPECT_EQ(actual.b96[i], word_at(input, 12 + 4 * i));
  for (unsigned i = 0; i < 4; ++i)
    EXPECT_EQ(actual.b128[i], word_at(input, 24 + 4 * i));
  for (unsigned i = 0; i < 8; ++i)
    EXPECT_EQ(actual.b256[i], word_at(input, 40 + 4 * i));
  for (unsigned i = 0; i < 16; ++i)
    EXPECT_EQ(actual.b512[i], word_at(input, 72 + 4 * i));
  EXPECT_EQ(actual.i8, 0xffffff81u);
  EXPECT_EQ(actual.u8, 0xfeu);
  EXPECT_EQ(actual.i16, 0xffff8001u);
  EXPECT_EQ(actual.u16, 0xcafeu);
}
