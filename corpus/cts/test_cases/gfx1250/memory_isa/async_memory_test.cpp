// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "memory_test_harness.hpp"

#include <algorithm>
#include <cstdint>
#include <vector>

namespace {
using namespace memory_isa_test;

constexpr unsigned kRegionBytes = 128;
constexpr unsigned kSlotBytes = 32;
constexpr unsigned kPayloadOffset = 8;

__global__ void async_transfer_kernel(const std::uint8_t *input, std::uint8_t *load_output,
                                      std::uint8_t *round_trip_output, std::uint8_t *store_output) {
  __shared__ __align__(16) std::uint8_t lds[kWaveLanes * kRegionBytes];
  const unsigned lane = threadIdx.x;
  const unsigned base = lane * kRegionBytes;
  for (unsigned byte = 0; byte < kRegionBytes; ++byte)
    lds[base + byte] = kByteCanary;
  __syncthreads();

  const std::uint64_t global_base = reinterpret_cast<std::uint64_t>(input + base + kPayloadOffset);
  const std::uint32_t lds_base = base + kPayloadOffset;
  asm volatile("global_load_async_to_lds_b8 %0, %4, off\n\t"
               "global_load_async_to_lds_b32 %1, %5, off\n\t"
               "global_load_async_to_lds_b64 %2, %6, off\n\t"
               "global_load_async_to_lds_b128 %3, %7, off\n\t"
               "s_wait_asynccnt 0"
               :
               : "v"(lds_base), "v"(lds_base + kSlotBytes), "v"(lds_base + 2 * kSlotBytes),
                 "v"(lds_base + 3 * kSlotBytes), "v"(global_base), "v"(global_base + kSlotBytes),
                 "v"(global_base + 2 * kSlotBytes), "v"(global_base + 3 * kSlotBytes)
               : "memory");
  __syncthreads();

  for (unsigned byte = 0; byte < kRegionBytes; ++byte)
    load_output[base + byte] = lds[base + byte];

  const std::uint64_t round_trip_base =
      reinterpret_cast<std::uint64_t>(round_trip_output + base + kPayloadOffset);
  asm volatile("global_store_async_from_lds_b8 %0, %4, off\n\t"
               "global_store_async_from_lds_b32 %1, %5, off\n\t"
               "global_store_async_from_lds_b64 %2, %6, off\n\t"
               "global_store_async_from_lds_b128 %3, %7, off\n\t"
               "s_wait_asynccnt 0"
               :
               : "v"(round_trip_base), "v"(round_trip_base + kSlotBytes),
                 "v"(round_trip_base + 2 * kSlotBytes), "v"(round_trip_base + 3 * kSlotBytes),
                 "v"(lds_base), "v"(lds_base + kSlotBytes), "v"(lds_base + 2 * kSlotBytes),
                 "v"(lds_base + 3 * kSlotBytes)
               : "memory");

  for (unsigned byte = 0; byte < kRegionBytes; ++byte)
    lds[base + byte] = kByteCanary;
  lds[lds_base] = input[base + kPayloadOffset];
  for (unsigned byte = 0; byte < 4; ++byte)
    lds[lds_base + kSlotBytes + byte] = input[base + kSlotBytes + kPayloadOffset + byte];
  for (unsigned byte = 0; byte < 8; ++byte)
    lds[lds_base + 2 * kSlotBytes + byte] = input[base + 2 * kSlotBytes + kPayloadOffset + byte];
  for (unsigned byte = 0; byte < 16; ++byte)
    lds[lds_base + 3 * kSlotBytes + byte] = input[base + 3 * kSlotBytes + kPayloadOffset + byte];
  __syncthreads();

  const std::uint64_t store_base =
      reinterpret_cast<std::uint64_t>(store_output + base + kPayloadOffset);
  asm volatile("global_store_async_from_lds_b8 %0, %4, off\n\t"
               "global_store_async_from_lds_b32 %1, %5, off\n\t"
               "global_store_async_from_lds_b64 %2, %6, off\n\t"
               "global_store_async_from_lds_b128 %3, %7, off\n\t"
               "s_wait_asynccnt 0"
               :
               : "v"(store_base), "v"(store_base + kSlotBytes), "v"(store_base + 2 * kSlotBytes),
                 "v"(store_base + 3 * kSlotBytes), "v"(lds_base), "v"(lds_base + kSlotBytes),
                 "v"(lds_base + 2 * kSlotBytes), "v"(lds_base + 3 * kSlotBytes)
               : "memory");
}

std::vector<std::uint8_t> expected_transfer(const std::vector<std::uint8_t> &input) {
  std::vector<std::uint8_t> expected(input.size(), kByteCanary);
  constexpr unsigned widths[] = {1, 4, 8, 16};
  for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
    const unsigned base = lane * kRegionBytes;
    for (unsigned slot = 0; slot < 4; ++slot)
      std::copy_n(input.begin() + base + slot * kSlotBytes + kPayloadOffset, widths[slot],
                  expected.begin() + base + slot * kSlotBytes + kPayloadOffset);
  }
  return expected;
}
} // namespace

TEST(Gfx1250MemoryIsaAsync, WidthsTransferIndependentlyToAndFromLds) {
  REQUIRE_GFX1250_DEVICE();
  std::vector<std::uint8_t> input(kWaveLanes * kRegionBytes);
  for (unsigned lane = 0; lane < kWaveLanes; ++lane)
    for (unsigned byte = 0; byte < kRegionBytes; ++byte)
      input[lane * kRegionBytes + byte] = coordinate_byte(byte, lane);
  const auto expected = expected_transfer(input);
  std::vector<std::uint8_t> canaries(input.size(), kByteCanary);
  auto device_input = DeviceBuffer<std::uint8_t>::from_host(input);
  auto device_load_output = DeviceBuffer<std::uint8_t>::from_host(canaries);
  auto device_round_trip_output = DeviceBuffer<std::uint8_t>::from_host(canaries);
  auto device_store_output = DeviceBuffer<std::uint8_t>::from_host(canaries);
  ASSERT_TRUE(device_input);
  ASSERT_TRUE(device_load_output);
  ASSERT_TRUE(device_round_trip_output);
  ASSERT_TRUE(device_store_output);
  async_transfer_kernel<<<1, kWaveLanes>>>(device_input.get(), device_load_output.get(),
                                           device_round_trip_output.get(),
                                           device_store_output.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  expect_bytes_equal(device_load_output.to_host(), expected, "load-to-LDS");
  expect_bytes_equal(device_round_trip_output.to_host(), expected, "round trip");
  expect_bytes_equal(device_store_output.to_host(), expected, "LDS-to-global");
}
