// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "memory_test_harness.hpp"

#include <cstdint>
#include <vector>

namespace {
using namespace memory_isa_test;

constexpr unsigned kSpaceCount = 3;
constexpr unsigned kGlobalSpace = 0;
constexpr unsigned kLdsSpace = 1;
constexpr unsigned kScratchSpace = 2;

struct FlatApertureResult {
  std::uint32_t loaded[kSpaceCount];
  std::uint32_t stored[kSpaceCount];
  std::uint32_t canary[kSpaceCount];
};

__device__ std::uint32_t flat_load_word(std::uint64_t address) {
  std::uint32_t value;
  asm volatile("flat_load_b32 %0, %1\n\t"
               "s_wait_loadcnt 0\n\t"
               "s_wait_dscnt 0"
               : "=&v"(value)
               : "v"(address)
               : "memory");
  return value;
}

__device__ void flat_store_word(std::uint64_t address, std::uint32_t value) {
  asm volatile("flat_store_b32 %0, %1\n\t"
               "s_wait_storecnt 0\n\t"
               "s_wait_dscnt 0"
               :
               : "v"(address), "v"(value)
               : "memory");
}

__global__ void uniform_flat_aperture_kernel(std::uint32_t *global_values,
                                             FlatApertureResult *results) {
  __shared__ std::uint32_t lds_values[2 * kWaveLanes];
  volatile std::uint32_t scratch_values[2];
  const unsigned lane = threadIdx.x;
  const unsigned base = 2 * lane;

  lds_values[base] = lane_word(lane, kLdsSpace);
  lds_values[base + 1] = kWordCanary;
  scratch_values[0] = lane_word(lane, kScratchSpace);
  scratch_values[1] = kWordCanary;
  __syncthreads();

  const std::uint64_t addresses[kSpaceCount] = {
      reinterpret_cast<std::uint64_t>(global_values + base),
      reinterpret_cast<std::uint64_t>(lds_values + base),
      reinterpret_cast<std::uint64_t>(&scratch_values[0]),
  };
  FlatApertureResult result{};
  for (unsigned space = 0; space < kSpaceCount; ++space)
    result.loaded[space] = flat_load_word(addresses[space]);

  for (unsigned space = 0; space < kSpaceCount; ++space)
    flat_store_word(addresses[space], lane_word(lane, 3 + space));
  __syncthreads();

  result.stored[kGlobalSpace] = global_values[base];
  result.stored[kLdsSpace] = lds_values[base];
  result.stored[kScratchSpace] = scratch_values[0];
  result.canary[kGlobalSpace] = global_values[base + 1];
  result.canary[kLdsSpace] = lds_values[base + 1];
  result.canary[kScratchSpace] = scratch_values[1];
  results[lane] = result;
}

__global__ void mixed_flat_aperture_kernel(std::uint32_t *global_values,
                                           FlatApertureResult *results) {
  __shared__ std::uint32_t lds_values[2 * kWaveLanes];
  volatile std::uint32_t scratch_values[2];
  const unsigned lane = threadIdx.x;
  const unsigned base = 2 * lane;

  lds_values[base] = lane_word(lane, kLdsSpace);
  lds_values[base + 1] = kWordCanary;
  scratch_values[0] = lane_word(lane, kScratchSpace);
  scratch_values[1] = kWordCanary;
  __syncthreads();

  const std::uint64_t addresses[kSpaceCount] = {
      reinterpret_cast<std::uint64_t>(global_values + base),
      reinterpret_cast<std::uint64_t>(lds_values + base),
      reinterpret_cast<std::uint64_t>(&scratch_values[0]),
  };
  const unsigned selected_space = lane % kSpaceCount;
  FlatApertureResult result{};
  result.loaded[selected_space] = flat_load_word(addresses[selected_space]);
  flat_store_word(addresses[selected_space], lane_word(lane, 3 + selected_space));
  __syncthreads();

  result.stored[kGlobalSpace] = global_values[base];
  result.stored[kLdsSpace] = lds_values[base];
  result.stored[kScratchSpace] = scratch_values[0];
  result.canary[kGlobalSpace] = global_values[base + 1];
  result.canary[kLdsSpace] = lds_values[base + 1];
  result.canary[kScratchSpace] = scratch_values[1];
  results[lane] = result;
}

std::vector<std::uint32_t> initial_global_values() {
  std::vector<std::uint32_t> values(2 * kWaveLanes);
  for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
    values[2 * lane] = lane_word(lane, kGlobalSpace);
    values[2 * lane + 1] = kWordCanary;
  }
  return values;
}

void expect_canaries(const FlatApertureResult &result, unsigned lane) {
  for (unsigned space = 0; space < kSpaceCount; ++space)
    EXPECT_EQ(result.canary[space], kWordCanary) << "lane " << lane << ", space " << space;
}
} // namespace

TEST(Gfx1250MemoryIsaFlatAperture, UniformGlobalLdsAndScratchRoutesMatchManual) {
  REQUIRE_GFX1250_DEVICE();
  auto device_global = DeviceBuffer<std::uint32_t>::from_host(initial_global_values());
  auto device_results = DeviceBuffer<FlatApertureResult>::allocate(kWaveLanes);
  ASSERT_TRUE(device_global);
  ASSERT_TRUE(device_results);

  uniform_flat_aperture_kernel<<<1, kWaveLanes>>>(device_global.get(), device_results.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const auto actual = device_results.to_host();

  for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
    for (unsigned space = 0; space < kSpaceCount; ++space) {
      EXPECT_EQ(actual[lane].loaded[space], lane_word(lane, space))
          << "load lane " << lane << ", space " << space;
      EXPECT_EQ(actual[lane].stored[space], lane_word(lane, 3 + space))
          << "store lane " << lane << ", space " << space;
    }
    expect_canaries(actual[lane], lane);
  }
}

TEST(Gfx1250MemoryIsaFlatAperture, MixedLaneAddressesRouteIndependently) {
  REQUIRE_GFX1250_DEVICE();
  auto device_global = DeviceBuffer<std::uint32_t>::from_host(initial_global_values());
  auto device_results = DeviceBuffer<FlatApertureResult>::allocate(kWaveLanes);
  ASSERT_TRUE(device_global);
  ASSERT_TRUE(device_results);

  mixed_flat_aperture_kernel<<<1, kWaveLanes>>>(device_global.get(), device_results.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const auto actual = device_results.to_host();

  for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
    const unsigned selected_space = lane % kSpaceCount;
    EXPECT_EQ(actual[lane].loaded[selected_space], lane_word(lane, selected_space))
        << "load lane " << lane << ", space " << selected_space;
    for (unsigned space = 0; space < kSpaceCount; ++space) {
      const std::uint32_t expected =
          space == selected_space ? lane_word(lane, 3 + space) : lane_word(lane, space);
      EXPECT_EQ(actual[lane].stored[space], expected)
          << "store lane " << lane << ", space " << space;
    }
    expect_canaries(actual[lane], lane);
  }
}
