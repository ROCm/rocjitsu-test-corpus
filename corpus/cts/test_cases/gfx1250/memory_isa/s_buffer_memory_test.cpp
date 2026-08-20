// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "memory_test_harness.hpp"

#include <cstddef>
#include <cstdint>
#include <vector>

namespace {
using namespace memory_isa_test;

struct SBufferLoads {
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

struct SBufferBounds {
  u32x4 stride_zero;
  u32x4 stride_scale_one;
  u32x4 ignored_descriptor_modes;
};

struct SBufferAlignment {
  std::uint32_t u8;
  std::uint32_t u16;
  std::uint32_t b32;
};

__global__ void s_buffer_width_kernel(u32x4 resource, SBufferLoads *result) {
  SBufferLoads values{};
  asm volatile("s_buffer_load_b32 %0, %10, null offset:0\n\t"
               "s_buffer_load_b64 %1, %10, null offset:4\n\t"
               "s_buffer_load_b96 %2, %10, null offset:12\n\t"
               "s_buffer_load_b128 %3, %10, null offset:24\n\t"
               "s_buffer_load_b256 %4, %10, null offset:40\n\t"
               "s_buffer_load_b512 %5, %10, null offset:72\n\t"
               "s_buffer_load_i8 %6, %10, null offset:136\n\t"
               "s_buffer_load_u8 %7, %10, null offset:137\n\t"
               "s_buffer_load_i16 %8, %10, null offset:138\n\t"
               "s_buffer_load_u16 %9, %10, null offset:140\n\t"
               "s_wait_kmcnt 0"
               : "=&s"(values.b32), "=&s"(values.b64), "=&s"(values.b96), "=&s"(values.b128),
                 "=&s"(values.b256), "=&s"(values.b512), "=&s"(values.i8), "=&s"(values.u8),
                 "=&s"(values.i16), "=&s"(values.u16)
               : "s"(resource)
               : "memory");
  if (threadIdx.x == 0)
    *result = values;
}

__global__ void s_buffer_soffset_kernel(u32x4 resource, std::uint32_t soffset,
                                        std::uint32_t *result) {
  std::uint32_t value = 0;
  asm volatile("s_buffer_load_b32 %0, %1, %2 offset:12\n\t"
               "s_wait_kmcnt 0"
               : "=&s"(value)
               : "s"(resource), "s"(soffset)
               : "memory");
  if (threadIdx.x == 0)
    *result = value;
}

__global__ void s_buffer_bounds_kernel(u32x4 stride_zero, u32x4 stride_scale_one,
                                       u32x4 ignored_descriptor_modes, SBufferBounds *result) {
  SBufferBounds values{};
  asm volatile("s_buffer_load_b128 %0, %3, null offset:24\n\t"
               "s_buffer_load_b128 %1, %4, null offset:24\n\t"
               "s_buffer_load_b128 %2, %5, null offset:24\n\t"
               "s_wait_kmcnt 0"
               : "=&s"(values.stride_zero), "=&s"(values.stride_scale_one),
                 "=&s"(values.ignored_descriptor_modes)
               : "s"(stride_zero), "s"(stride_scale_one), "s"(ignored_descriptor_modes)
               : "memory");
  if (threadIdx.x == 0)
    *result = values;
}

__global__ void s_buffer_alignment_kernel(u32x4 resource, SBufferAlignment *result) {
  SBufferAlignment values{};
  asm volatile("s_buffer_load_u8 %0, %3, null offset:5\n\t"
               "s_buffer_load_u16 %1, %3, null offset:3\n\t"
               "s_buffer_load_b32 %2, %3, null offset:7\n\t"
               "s_wait_kmcnt 0"
               : "=&s"(values.u8), "=&s"(values.u16), "=&s"(values.b32)
               : "s"(resource)
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

TEST(Gfx1250MemoryIsaSBuffer, WidthExtensionAndImmediateAddressingMatchManual) {
  REQUIRE_GFX1250_DEVICE();
  std::vector<std::uint8_t> input(160);
  for (std::size_t i = 0; i < input.size(); ++i)
    input[i] = coordinate_byte(i, 11);
  input[136] = 0x81;
  input[137] = 0xfe;
  input[138] = 0x01;
  input[139] = 0x80;
  input[140] = 0xfe;
  input[141] = 0xca;

  auto device_input = DeviceBuffer<std::uint8_t>::from_host(input);
  auto device_result = DeviceBuffer<SBufferLoads>::allocate(1);
  ASSERT_TRUE(device_input);
  ASSERT_TRUE(device_result);
  const u32x4 resource =
      make_buffer_resource(reinterpret_cast<std::uint64_t>(device_input.get()), input.size())
          .vector();

  s_buffer_width_kernel<<<1, kWaveLanes>>>(resource, device_result.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const SBufferLoads actual = device_result.to_host()[0];

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

TEST(Gfx1250MemoryIsaSBuffer, ScalarAndImmediateOffsetsAreAddedInBytes) {
  REQUIRE_GFX1250_DEVICE();
  std::vector<std::uint8_t> input(64);
  for (std::size_t i = 0; i < input.size(); ++i)
    input[i] = coordinate_byte(i, 12);
  auto device_input = DeviceBuffer<std::uint8_t>::from_host(input);
  auto device_result = DeviceBuffer<std::uint32_t>::allocate(1);
  ASSERT_TRUE(device_input);
  ASSERT_TRUE(device_result);
  const u32x4 resource =
      make_buffer_resource(reinterpret_cast<std::uint64_t>(device_input.get()), input.size())
          .vector();

  s_buffer_soffset_kernel<<<1, kWaveLanes>>>(resource, 20, device_result.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  EXPECT_EQ(device_result.to_host()[0], word_at(input, 32));
}

TEST(Gfx1250MemoryIsaSBuffer, StrideControlsBoundsAndOtherDescriptorModesAreIgnored) {
  REQUIRE_GFX1250_DEVICE();
  std::vector<std::uint8_t> input(48);
  for (std::size_t i = 0; i < input.size(); ++i)
    input[i] = coordinate_byte(i, 13);
  auto device_input = DeviceBuffer<std::uint8_t>::from_host(input);
  auto device_result = DeviceBuffer<SBufferBounds>::allocate(1);
  ASSERT_TRUE(device_input);
  ASSERT_TRUE(device_result);
  const std::uint64_t base = reinterpret_cast<std::uint64_t>(device_input.get());
  const u32x4 stride_zero = make_buffer_resource(base, 32).vector();
  const u32x4 stride_scale_one = make_buffer_resource(base, 8, 4, 0).vector();
  const u32x4 ignored_descriptor_modes = make_buffer_resource(base, 8, 4, 3, true, true).vector();

  s_buffer_bounds_kernel<<<1, kWaveLanes>>>(stride_zero, stride_scale_one, ignored_descriptor_modes,
                                            device_result.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const SBufferBounds actual = device_result.to_host()[0];
  for (unsigned i = 0; i < 4; ++i) {
    const std::uint32_t expected = i < 2 ? word_at(input, 24 + 4 * i) : 0;
    EXPECT_EQ(actual.stride_zero[i], expected);
    EXPECT_EQ(actual.stride_scale_one[i], expected);
    EXPECT_EQ(actual.ignored_descriptor_modes[i], expected);
  }
}

TEST(Gfx1250MemoryIsaSBuffer, BaseAndImmediateAlignmentFollowElementWidth) {
  REQUIRE_GFX1250_DEVICE();
  std::vector<std::uint8_t> input(32);
  for (std::size_t i = 0; i < input.size(); ++i)
    input[i] = coordinate_byte(i, 14);
  auto device_input = DeviceBuffer<std::uint8_t>::from_host(input);
  auto device_result = DeviceBuffer<SBufferAlignment>::allocate(1);
  ASSERT_TRUE(device_input);
  ASSERT_TRUE(device_result);
  const std::uint64_t unaligned_base = reinterpret_cast<std::uint64_t>(device_input.get()) + 3;
  const u32x4 resource = make_buffer_resource(unaligned_base, input.size() - 3).vector();

  s_buffer_alignment_kernel<<<1, kWaveLanes>>>(resource, device_result.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const SBufferAlignment actual = device_result.to_host()[0];
  EXPECT_EQ(actual.u8, input[8]);
  EXPECT_EQ(actual.u16, word_at(input, 4) & 0xffffu);
  EXPECT_EQ(actual.b32, word_at(input, 4));
}
