// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "memory_test_harness.hpp"

#include <cstddef>
#include <cstdint>
#include <cstring>
#include <vector>

namespace {
using namespace memory_isa_test;

constexpr unsigned kStoreRegionBytes = 192;
constexpr unsigned kStoreSlotBytes = 32;
constexpr unsigned kStorePayloadOffset = 8;
constexpr unsigned kLoadRegionBytes = 64;
constexpr unsigned kLaneBytes = kStoreRegionBytes + kLoadRegionBytes;

struct LdsResult {
  std::uint32_t u8;
  std::uint32_t i8;
  std::uint32_t u16;
  std::uint32_t i16;
  std::uint32_t b32;
  u32x2 b64;
  u32x3 b96;
  u32x4 b128;
};

__device__ void seed_word(volatile std::uint8_t *lds, unsigned address, std::uint32_t value) {
  for (unsigned byte = 0; byte < 4; ++byte)
    lds[address + byte] = static_cast<std::uint8_t>(value >> (8 * byte));
}

__global__ void lds_width_kernel(LdsResult *load_output, std::uint8_t *store_output) {
  __shared__ __align__(16) std::uint8_t lds[kWaveLanes * kLaneBytes];
  volatile std::uint8_t *volatile_lds = lds;
  const unsigned lane = threadIdx.x;
  const std::uint32_t address = lane * kLaneBytes;
  for (unsigned byte = 0; byte < kLaneBytes; ++byte)
    volatile_lds[address + byte] = kByteCanary;
  __syncthreads();

  const std::uint32_t b8 = lane == 0 ? 0x81u : coordinate_byte(0, lane);
  const std::uint32_t b16 = lane == 0 ? 0x8001u : 0x1200u + lane;
  const std::uint32_t b32 = lane_word(lane, 0);
  const u32x2 b64{lane_word(lane, 1), lane_word(lane, 2)};
  const u32x3 b96{lane_word(lane, 3), lane_word(lane, 4), lane_word(lane, 5)};
  const u32x4 b128{lane_word(lane, 6), lane_word(lane, 7), lane_word(lane, 8), lane_word(lane, 9)};
  asm volatile("ds_store_b8 %0, %1 offset:8\n\t"
               "ds_store_b16 %0, %2 offset:40\n\t"
               "ds_store_b32 %0, %3 offset:72\n\t"
               "ds_store_b64 %0, %4 offset:104\n\t"
               "ds_store_b96 %0, %5 offset:136\n\t"
               "ds_store_b128 %0, %6 offset:168\n\t"
               "s_wait_dscnt 0"
               :
               : "v"(address), "v"(b8), "v"(b16), "v"(b32), "v"(b64), "v"(b96), "v"(b128)
               : "memory");
  __syncthreads();
  for (unsigned byte = 0; byte < kStoreRegionBytes; ++byte)
    store_output[lane * kStoreRegionBytes + byte] = volatile_lds[address + byte];

  const unsigned load_address = address + kStoreRegionBytes;
  volatile_lds[load_address] = static_cast<std::uint8_t>(b8);
  volatile_lds[load_address + 2] = static_cast<std::uint8_t>(b16);
  volatile_lds[load_address + 3] = static_cast<std::uint8_t>(b16 >> 8);
  seed_word(volatile_lds, load_address + 4, b32);
  for (unsigned i = 0; i < 2; ++i)
    seed_word(volatile_lds, load_address + 8 + 4 * i, b64[i]);
  for (unsigned i = 0; i < 3; ++i)
    seed_word(volatile_lds, load_address + 16 + 4 * i, b96[i]);
  for (unsigned i = 0; i < 4; ++i)
    seed_word(volatile_lds, load_address + 32 + 4 * i, b128[i]);
  __syncthreads();

  LdsResult result{};
  asm volatile("ds_load_u8 %0, %8 offset:0\n\t"
               "ds_load_i8 %1, %8 offset:0\n\t"
               "ds_load_u16 %2, %8 offset:2\n\t"
               "ds_load_i16 %3, %8 offset:2\n\t"
               "ds_load_b32 %4, %8 offset:4\n\t"
               "ds_load_b64 %5, %8 offset:8\n\t"
               "ds_load_b96 %6, %8 offset:16\n\t"
               "ds_load_b128 %7, %8 offset:32\n\t"
               "s_wait_dscnt 0"
               : "=v"(result.u8), "=v"(result.i8), "=v"(result.u16), "=v"(result.i16),
                 "=v"(result.b32), "=v"(result.b64), "=v"(result.b96), "=v"(result.b128)
               : "v"(load_address)
               : "memory");
  load_output[lane] = result;
}

template <class T>
void copy_payload(std::vector<std::uint8_t> &bytes, std::size_t offset, const T &value,
                  std::size_t width = sizeof(T)) {
  std::memcpy(bytes.data() + offset, &value, width);
}
} // namespace

TEST(Gfx1250MemoryIsaLds, WidthPackingAndExtensionMatchManual) {
  REQUIRE_GFX1250_DEVICE();
  auto device_load_output = DeviceBuffer<LdsResult>::allocate(kWaveLanes);
  auto device_store_output = DeviceBuffer<std::uint8_t>::allocate(kWaveLanes * kStoreRegionBytes);
  ASSERT_TRUE(device_load_output);
  ASSERT_TRUE(device_store_output);
  lds_width_kernel<<<1, kWaveLanes>>>(device_load_output.get(), device_store_output.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const auto actual = device_load_output.to_host();
  std::vector<std::uint8_t> expected_store(kWaveLanes * kStoreRegionBytes, kByteCanary);
  for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
    const std::uint32_t b8 = lane == 0 ? 0x81u : coordinate_byte(0, lane);
    const std::uint32_t b16 = lane == 0 ? 0x8001u : 0x1200u + lane;
    const std::uint32_t b32 = lane_word(lane, 0);
    const u32x2 b64{lane_word(lane, 1), lane_word(lane, 2)};
    const u32x3 b96{lane_word(lane, 3), lane_word(lane, 4), lane_word(lane, 5)};
    const u32x4 b128{lane_word(lane, 6), lane_word(lane, 7), lane_word(lane, 8),
                     lane_word(lane, 9)};
    const std::size_t store_base = lane * kStoreRegionBytes + kStorePayloadOffset;
    copy_payload(expected_store, store_base, b8, 1);
    copy_payload(expected_store, store_base + kStoreSlotBytes, b16, 2);
    copy_payload(expected_store, store_base + 2 * kStoreSlotBytes, b32);
    copy_payload(expected_store, store_base + 3 * kStoreSlotBytes, b64);
    copy_payload(expected_store, store_base + 4 * kStoreSlotBytes, b96, 12);
    copy_payload(expected_store, store_base + 5 * kStoreSlotBytes, b128);

    EXPECT_EQ(actual[lane].u8, b8 & 0xffu);
    EXPECT_EQ(actual[lane].i8,
              static_cast<std::uint32_t>(static_cast<std::int32_t>(static_cast<std::int8_t>(b8))));
    EXPECT_EQ(actual[lane].u16, b16 & 0xffffu);
    EXPECT_EQ(actual[lane].i16, static_cast<std::uint32_t>(
                                    static_cast<std::int32_t>(static_cast<std::int16_t>(b16))));
    EXPECT_EQ(actual[lane].b32, b32);
    for (unsigned i = 0; i < 2; ++i)
      EXPECT_EQ(actual[lane].b64[i], b64[i]);
    for (unsigned i = 0; i < 3; ++i)
      EXPECT_EQ(actual[lane].b96[i], b96[i]);
    for (unsigned i = 0; i < 4; ++i)
      EXPECT_EQ(actual[lane].b128[i], b128[i]);
  }
  expect_bytes_equal(device_store_output.to_host(), expected_store, "LDS stores");
}
