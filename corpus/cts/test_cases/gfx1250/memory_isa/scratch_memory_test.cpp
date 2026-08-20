// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "memory_test_harness.hpp"

#include <cstddef>
#include <cstdint>
#include <cstring>
#include <vector>

namespace {
using namespace memory_isa_test;

constexpr unsigned kScratchRegionBytes = 192;
constexpr unsigned kScratchSlotBytes = 32;
constexpr unsigned kScratchPayloadOffset = 8;
constexpr unsigned kMisalignedSlotBase = 96;
constexpr unsigned kMisalignedImmediate = 61;
static_assert(kMisalignedSlotBase + kMisalignedImmediate == 157);

struct ScratchResult {
  std::uint32_t b32;
  u32x2 b64;
  u32x4 b128;
  std::uint32_t misaligned;
};

__device__ void store_scratch_byte(std::uint32_t offset, std::uint32_t value) {
  asm volatile("scratch_store_b8 %0, %1, off" : : "v"(offset), "v"(value) : "memory");
}

__device__ std::uint32_t load_scratch_byte(std::uint32_t offset) {
  std::uint32_t value;
  asm volatile("scratch_load_u8 %0, %1, off\n\t"
               "s_wait_loadcnt 0"
               : "=v"(value)
               : "v"(offset)
               : "memory");
  return value;
}

__device__ void seed_scratch_word(std::uint32_t offset, std::uint32_t value) {
  for (unsigned byte = 0; byte < 4; ++byte)
    store_scratch_byte(offset + byte, value >> (8 * byte));
}

__global__ void scratch_width_kernel(ScratchResult *load_output, std::uint8_t *store_output) {
  volatile std::uint8_t reserve[256];
  reserve[threadIdx.x & 255] = kByteCanary;
  const unsigned lane = threadIdx.x;
  for (unsigned byte = 0; byte < kScratchRegionBytes; ++byte)
    store_scratch_byte(byte, kByteCanary);
  asm volatile("s_wait_storecnt 0" : : : "memory");

  const std::uint32_t b32 = lane_word(lane, 0);
  const u32x2 b64{lane_word(lane, 1), lane_word(lane, 2)};
  const u32x4 b128{lane_word(lane, 3), lane_word(lane, 4), lane_word(lane, 5), lane_word(lane, 6)};
  const std::uint32_t misaligned = lane_word(lane, 7);
  const std::uint32_t base = 0;
  const std::uint32_t misaligned_base = kMisalignedSlotBase;
  // The offset-157 access intentionally pins SH_MEM_CONFIG.alignment_mode=UNALIGNED behavior.
  asm volatile("scratch_store_b32 %0, %1, off offset:8\n\t"
               "scratch_store_b64 %0, %2, off offset:40\n\t"
               "scratch_store_b128 %0, %3, off offset:72\n\t"
               "scratch_store_b32 %4, %5, off offset:61\n\t"
               "s_wait_storecnt 0"
               :
               : "v"(base), "v"(b32), "v"(b64), "v"(b128), "v"(misaligned_base), "v"(misaligned)
               : "memory");
  for (unsigned byte = 0; byte < kScratchRegionBytes; ++byte)
    store_output[lane * kScratchRegionBytes + byte] = load_scratch_byte(byte);

  for (unsigned byte = 0; byte < kScratchRegionBytes; ++byte)
    store_scratch_byte(byte, kByteCanary);
  seed_scratch_word(kScratchPayloadOffset, b32);
  for (unsigned i = 0; i < 2; ++i)
    seed_scratch_word(kScratchSlotBytes + kScratchPayloadOffset + 4 * i, b64[i]);
  for (unsigned i = 0; i < 4; ++i)
    seed_scratch_word(2 * kScratchSlotBytes + kScratchPayloadOffset + 4 * i, b128[i]);
  seed_scratch_word(kMisalignedSlotBase + kMisalignedImmediate, misaligned);
  asm volatile("s_wait_storecnt 0" : : : "memory");

  ScratchResult result{};
  asm volatile("scratch_load_b32 %0, %4, off offset:8\n\t"
               "scratch_load_b64 %1, %4, off offset:40\n\t"
               "scratch_load_b128 %2, %4, off offset:72\n\t"
               "scratch_load_b32 %3, %5, off offset:61\n\t"
               "s_wait_loadcnt 0"
               : "=v"(result.b32), "=v"(result.b64), "=v"(result.b128), "=v"(result.misaligned)
               : "v"(base), "v"(misaligned_base)
               : "memory");
  load_output[lane] = result;
}

template <class T>
void copy_payload(std::vector<std::uint8_t> &bytes, std::size_t offset, const T &value,
                  std::size_t width = sizeof(T)) {
  std::memcpy(bytes.data() + offset, &value, width);
}
} // namespace

TEST(Gfx1250MemoryIsaScratch, PerLaneWidthsAndMisalignmentMatchManual) {
  REQUIRE_GFX1250_DEVICE();
  auto device_load_output = DeviceBuffer<ScratchResult>::allocate(kWaveLanes);
  auto device_store_output = DeviceBuffer<std::uint8_t>::allocate(kWaveLanes * kScratchRegionBytes);
  ASSERT_TRUE(device_load_output);
  ASSERT_TRUE(device_store_output);
  scratch_width_kernel<<<1, kWaveLanes>>>(device_load_output.get(), device_store_output.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const auto actual = device_load_output.to_host();
  std::vector<std::uint8_t> expected_store(kWaveLanes * kScratchRegionBytes, kByteCanary);
  for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
    const std::uint32_t b32 = lane_word(lane, 0);
    const u32x2 b64{lane_word(lane, 1), lane_word(lane, 2)};
    const u32x4 b128{lane_word(lane, 3), lane_word(lane, 4), lane_word(lane, 5),
                     lane_word(lane, 6)};
    const std::uint32_t misaligned = lane_word(lane, 7);
    const std::size_t store_base = lane * kScratchRegionBytes;
    copy_payload(expected_store, store_base + kScratchPayloadOffset, b32);
    copy_payload(expected_store, store_base + kScratchSlotBytes + kScratchPayloadOffset, b64);
    copy_payload(expected_store, store_base + 2 * kScratchSlotBytes + kScratchPayloadOffset, b128);
    copy_payload(expected_store, store_base + kMisalignedSlotBase + kMisalignedImmediate,
                 misaligned);

    EXPECT_EQ(actual[lane].b32, b32);
    for (unsigned i = 0; i < 2; ++i)
      EXPECT_EQ(actual[lane].b64[i], b64[i]);
    for (unsigned i = 0; i < 4; ++i)
      EXPECT_EQ(actual[lane].b128[i], b128[i]);
    EXPECT_EQ(actual[lane].misaligned, misaligned);
  }
  expect_bytes_equal(device_store_output.to_host(), expected_store, "scratch stores");
}
