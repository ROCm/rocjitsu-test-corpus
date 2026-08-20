// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "memory_test_harness.hpp"

#include <cstdint>
#include <vector>

namespace {
using namespace memory_isa_test;

constexpr std::uint32_t kGlobalMask = 0x80018089u;
constexpr std::uint32_t kScratchLoadMask = 0x80018089u;
constexpr std::uint32_t kScratchStoreMask = 0x42100412u;

__device__ u32x32 make_lane_block(unsigned lane, unsigned tag) {
  u32x32 values{};
  for (unsigned i = 0; i < 32; ++i)
    values[i] = lane_word(lane, i) ^ (tag * 0x11111111u);
  return values;
}

__global__ void block_transfer_kernel(const std::uint32_t *input, std::uint32_t *load_output,
                                      std::uint32_t *store_output,
                                      std::uint32_t *scratch_load_output,
                                      std::uint32_t *scratch_store_output) {
  volatile std::uint32_t reserve[64];
  reserve[threadIdx.x & 63] = kWordCanary;
  const unsigned lane = threadIdx.x;
  const std::uint64_t input_address = reinterpret_cast<std::uint64_t>(input + lane * 32);
  const std::uint64_t load_output_address =
      reinterpret_cast<std::uint64_t>(load_output + lane * 32);
  const std::uint64_t store_output_address =
      reinterpret_cast<std::uint64_t>(store_output + lane * 32);
  std::uint32_t saved_m0;

  u32x32 loaded{};
  for (unsigned i = 0; i < 32; ++i)
    loaded[i] = kWordCanary;
  asm volatile("s_mov_b32 %1, m0\n\t"
               "s_mov_b32 m0, %4\n\t"
               "global_load_block %0, %2, off\n\t"
               "s_wait_loadcnt 0\n\t"
               "s_mov_b32 m0, -1\n\t"
               "global_store_block %3, %0, off\n\t"
               "s_wait_storecnt 0\n\t"
               "s_mov_b32 m0, %1"
               : "+v"(loaded), "=&s"(saved_m0)
               : "v"(input_address), "v"(load_output_address), "s"(kGlobalMask)
               : "memory");

  const u32x32 store_values = make_lane_block(lane, 7);
  asm volatile("s_mov_b32 %0, m0\n\t"
               "s_mov_b32 m0, %3\n\t"
               "global_store_block %1, %2, off\n\t"
               "s_wait_storecnt 0\n\t"
               "s_mov_b32 m0, %0"
               : "=&s"(saved_m0)
               : "v"(store_output_address), "v"(store_values), "s"(kGlobalMask)
               : "memory");

  for (unsigned i = 0; i < 32; ++i) {
    const std::uint32_t offset = i * sizeof(std::uint32_t);
    const std::uint32_t value = lane_word(lane, i) ^ 0x33333333u;
    asm volatile("scratch_store_b32 %0, %1, off\n\t" : : "v"(offset), "v"(value) : "memory");
  }
  asm volatile("s_wait_storecnt 0" : : : "memory");

  u32x32 scratch_loaded{};
  for (unsigned i = 0; i < 32; ++i)
    scratch_loaded[i] = kWordCanary;
  const std::uint32_t scratch_offset = 0;
  asm volatile("s_mov_b32 %1, m0\n\t"
               "s_mov_b32 m0, %3\n\t"
               "scratch_load_block %0, %2, off\n\t"
               "s_wait_loadcnt 0\n\t"
               "s_mov_b32 m0, %1"
               : "+v"(scratch_loaded), "=&s"(saved_m0)
               : "v"(scratch_offset), "s"(kScratchLoadMask)
               : "memory");
  for (unsigned i = 0; i < 32; ++i)
    scratch_load_output[lane * 32 + i] = scratch_loaded[i];

  for (unsigned i = 0; i < 32; ++i) {
    const std::uint32_t offset = i * sizeof(std::uint32_t);
    asm volatile("scratch_store_b32 %0, %1, off\n\t" : : "v"(offset), "v"(kWordCanary) : "memory");
  }
  asm volatile("s_wait_storecnt 0" : : : "memory");

  const u32x32 scratch_values = make_lane_block(lane, 5);
  asm volatile("s_mov_b32 %0, m0\n\t"
               "s_mov_b32 m0, %3\n\t"
               "scratch_store_block %1, %2, off\n\t"
               "s_wait_storecnt 0\n\t"
               "s_mov_b32 m0, %0"
               : "=&s"(saved_m0)
               : "v"(scratch_offset), "v"(scratch_values), "s"(kScratchStoreMask)
               : "memory");
  for (unsigned i = 0; i < 32; ++i) {
    const std::uint32_t offset = i * sizeof(std::uint32_t);
    std::uint32_t value;
    asm volatile("scratch_load_b32 %0, %1, off\n\t"
                 "s_wait_loadcnt 0"
                 : "=v"(value)
                 : "v"(offset)
                 : "memory");
    scratch_store_output[lane * 32 + i] = value;
  }
  asm volatile("" : : "v"(reserve[threadIdx.x & 63]) : "memory");
}
} // namespace

TEST(Gfx1250MemoryIsaBlock, SparseMasksPreserveRegisterAndMemoryHoles) {
  REQUIRE_GFX1250_DEVICE();
  std::vector<std::uint32_t> input(kWaveLanes * 32);
  for (unsigned lane = 0; lane < kWaveLanes; ++lane)
    for (unsigned i = 0; i < 32; ++i)
      input[lane * 32 + i] = lane_word(lane, i);
  std::vector<std::uint32_t> canaries(input.size(), kWordCanary);
  auto device_input = DeviceBuffer<std::uint32_t>::from_host(input);
  auto device_load = DeviceBuffer<std::uint32_t>::from_host(canaries);
  auto device_store = DeviceBuffer<std::uint32_t>::from_host(canaries);
  auto device_scratch_load = DeviceBuffer<std::uint32_t>::from_host(canaries);
  auto device_scratch_store = DeviceBuffer<std::uint32_t>::from_host(canaries);
  ASSERT_TRUE(device_input);
  ASSERT_TRUE(device_load);
  ASSERT_TRUE(device_store);
  ASSERT_TRUE(device_scratch_load);
  ASSERT_TRUE(device_scratch_store);

  block_transfer_kernel<<<1, kWaveLanes>>>(device_input.get(), device_load.get(),
                                           device_store.get(), device_scratch_load.get(),
                                           device_scratch_store.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const auto load = device_load.to_host();
  const auto store = device_store.to_host();
  const auto scratch_load = device_scratch_load.to_host();
  const auto scratch_store = device_scratch_store.to_host();
  for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
    for (unsigned i = 0; i < 32; ++i) {
      const bool global_selected = ((kGlobalMask >> i) & 1u) != 0;
      const bool scratch_load_selected = ((kScratchLoadMask >> i) & 1u) != 0;
      const bool scratch_store_selected = ((kScratchStoreMask >> i) & 1u) != 0;
      EXPECT_EQ(load[lane * 32 + i], global_selected ? lane_word(lane, i) : kWordCanary)
          << "global load lane=" << lane << " slot=" << i;
      EXPECT_EQ(store[lane * 32 + i],
                global_selected ? (lane_word(lane, i) ^ 0x77777777u) : kWordCanary)
          << "global store lane=" << lane << " slot=" << i;
      EXPECT_EQ(scratch_load[lane * 32 + i],
                scratch_load_selected ? (lane_word(lane, i) ^ 0x33333333u) : kWordCanary)
          << "scratch load lane=" << lane << " slot=" << i;
      EXPECT_EQ(scratch_store[lane * 32 + i],
                scratch_store_selected ? (lane_word(lane, i) ^ 0x55555555u) : kWordCanary)
          << "scratch store lane=" << lane << " slot=" << i;
    }
  }
}
