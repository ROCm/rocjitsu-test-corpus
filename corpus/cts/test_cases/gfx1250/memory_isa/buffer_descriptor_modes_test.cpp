// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "memory_test_harness.hpp"

#include <array>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <vector>

namespace {
using namespace memory_isa_test;

constexpr std::array<std::uint32_t, 4> kStrideMultipliers = {1, 4, 8, 32};
constexpr std::size_t kDescriptorModeBytes = 4096;

__global__ void buffer_stride_scale_kernel(u32x4 input_resource, u32x4 output_resource,
                                           std::uint32_t tag, std::uint32_t *load_results) {
  const std::uint32_t index = threadIdx.x;
  const std::uint32_t store_value = lane_word(index, tag);
  std::uint32_t load_value = 0;
  asm volatile("buffer_load_b32 %0, %2, %3, null idxen offset:4\n\t"
               "buffer_store_b32 %1, %2, %4, null idxen offset:8\n\t"
               "s_wait_loadcnt 0\n\t"
               "s_wait_storecnt 0"
               : "=&v"(load_value)
               : "v"(store_value), "v"(index), "s"(input_resource), "s"(output_resource)
               : "memory");
  load_results[index] = load_value;
}

__global__ void buffer_swizzle_kernel(u32x4 input_resource, u32x4 output_resource,
                                      std::uint32_t *load_results) {
  const std::uint32_t lane = threadIdx.x;
  const std::uint32_t index = lane + ((lane & 1u) != 0 ? 32u : 0u);
  const std::uint32_t voffset = (lane & 3u) * 8u;
  const u32x2 address{index, voffset};
  const std::uint32_t store_value = lane_word(lane, 21);
  const std::uint32_t soffset = 12;
  std::uint32_t load_value = 0;
  asm volatile("buffer_load_b32 %0, %2, %3, %4 idxen offen offset:4\n\t"
               "buffer_store_b32 %1, %2, %5, %4 idxen offen offset:4\n\t"
               "s_wait_loadcnt 0\n\t"
               "s_wait_storecnt 0"
               : "=&v"(load_value)
               : "v"(store_value), "v"(address), "s"(input_resource), "s"(soffset),
                 "s"(output_resource)
               : "memory");
  load_results[lane] = load_value;
}

std::uint32_t word_at(const std::vector<std::uint8_t> &bytes, std::size_t offset) {
  std::uint32_t value = 0;
  std::memcpy(&value, bytes.data() + offset, sizeof(value));
  return value;
}

void write_word(std::vector<std::uint8_t> &bytes, std::size_t offset, std::uint32_t value) {
  std::memcpy(bytes.data() + offset, &value, sizeof(value));
}

std::uint64_t swizzled_buffer_offset(std::uint32_t index, std::uint32_t stride,
                                     std::uint32_t voffset, std::uint32_t ioffset,
                                     std::uint32_t soffset) {
  constexpr std::uint64_t index_stride = 32;
  constexpr std::uint64_t element_size = 16;
  constexpr std::uint64_t offset_mask = (std::uint64_t{1} << 45) - 1;
  const std::uint64_t total_offset =
      (static_cast<std::uint64_t>(voffset) + ioffset + soffset) & offset_mask;
  const std::uint64_t index_msb = index / index_stride;
  const std::uint64_t index_lsb = index % index_stride;
  const std::uint64_t offset_msb = total_offset / element_size;
  const std::uint64_t offset_lsb = total_offset % element_size;
  return (index_msb * stride + offset_msb * element_size) * index_stride +
         index_lsb * element_size + offset_lsb;
}
} // namespace

TEST(Gfx1250MemoryIsaBufferModes, EveryStrideScaleEncodingChangesAddressFormation) {
  REQUIRE_GFX1250_DEVICE();
  std::vector<std::uint8_t> input(kDescriptorModeBytes);
  for (std::size_t offset = 0; offset < input.size(); offset += sizeof(std::uint32_t))
    write_word(input, offset, 0x31000000u ^ static_cast<std::uint32_t>(offset / 4));
  auto device_input = DeviceBuffer<std::uint8_t>::from_host(input);
  ASSERT_TRUE(device_input);

  constexpr std::uint32_t raw_stride = 4;
  for (std::uint32_t encoding = 0; encoding < kStrideMultipliers.size(); ++encoding) {
    std::vector<std::uint8_t> output(kDescriptorModeBytes, kByteCanary);
    auto device_output = DeviceBuffer<std::uint8_t>::from_host(output);
    auto device_load_results = DeviceBuffer<std::uint32_t>::allocate(kWaveLanes);
    ASSERT_TRUE(device_output);
    ASSERT_TRUE(device_load_results);
    const u32x4 input_resource =
        make_buffer_resource(reinterpret_cast<std::uint64_t>(device_input.get()), input.size(),
                             raw_stride, encoding)
            .vector();
    const u32x4 output_resource =
        make_buffer_resource(reinterpret_cast<std::uint64_t>(device_output.get()), output.size(),
                             raw_stride, encoding)
            .vector();

    buffer_stride_scale_kernel<<<1, kWaveLanes>>>(input_resource, output_resource, encoding,
                                                  device_load_results.get());
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());
    const auto loads = device_load_results.to_host();
    const auto actual_output = device_output.to_host();
    const std::uint32_t stride = raw_stride * kStrideMultipliers[encoding];
    std::vector<std::uint8_t> expected_output(output.size(), kByteCanary);
    for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
      EXPECT_EQ(loads[lane], word_at(input, lane * stride + 4))
          << "stride-scale encoding " << encoding << ", lane " << lane;
      write_word(expected_output, lane * stride + 8, lane_word(lane, encoding));
    }
    expect_bytes_equal(actual_output, expected_output, "stride-scaled buffer stores");
  }
}

TEST(Gfx1250MemoryIsaBufferModes, SwizzleMapsIndexAndOffsetCoordinatesPerManual) {
  REQUIRE_GFX1250_DEVICE();
  std::vector<std::uint8_t> input(kDescriptorModeBytes);
  for (std::size_t offset = 0; offset < input.size(); offset += sizeof(std::uint32_t))
    write_word(input, offset, 0x32000000u ^ static_cast<std::uint32_t>(offset / 4));
  std::vector<std::uint8_t> output(kDescriptorModeBytes, kByteCanary);
  auto device_input = DeviceBuffer<std::uint8_t>::from_host(input);
  auto device_output = DeviceBuffer<std::uint8_t>::from_host(output);
  auto device_load_results = DeviceBuffer<std::uint32_t>::allocate(kWaveLanes);
  ASSERT_TRUE(device_input);
  ASSERT_TRUE(device_output);
  ASSERT_TRUE(device_load_results);

  constexpr std::uint32_t raw_stride = 16;
  constexpr std::uint32_t stride_scale_encoding = 1;
  constexpr std::uint32_t stride = raw_stride * kStrideMultipliers[stride_scale_encoding];
  const u32x4 input_resource =
      make_buffer_resource(reinterpret_cast<std::uint64_t>(device_input.get()), 1, raw_stride,
                           stride_scale_encoding, true)
          .vector();
  const u32x4 output_resource =
      make_buffer_resource(reinterpret_cast<std::uint64_t>(device_output.get()), 1, raw_stride,
                           stride_scale_encoding, true)
          .vector();

  buffer_swizzle_kernel<<<1, kWaveLanes>>>(input_resource, output_resource,
                                           device_load_results.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const auto loads = device_load_results.to_host();
  const auto actual_output = device_output.to_host();
  std::vector<std::uint8_t> expected_output(output.size(), kByteCanary);
  std::vector<bool> touched_words(output.size() / sizeof(std::uint32_t), false);
  for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
    const std::uint32_t index = lane + ((lane & 1u) != 0 ? 32u : 0u);
    const std::uint32_t voffset = (lane & 3u) * 8u;
    const std::size_t offset = swizzled_buffer_offset(index, stride, voffset, 4, 12);
    ASSERT_LE(offset + sizeof(std::uint32_t), input.size());
    ASSERT_FALSE(touched_words[offset / sizeof(std::uint32_t)]);
    touched_words[offset / sizeof(std::uint32_t)] = true;
    EXPECT_EQ(loads[lane], word_at(input, offset)) << "lane " << lane;
    write_word(expected_output, offset, lane_word(lane, 21));
  }
  expect_bytes_equal(actual_output, expected_output, "swizzled buffer stores");
}
