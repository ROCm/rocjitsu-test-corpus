// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "memory_test_harness.hpp"

#include <cstdint>
#include <vector>

namespace {
using namespace memory_isa_test;

constexpr unsigned kClusterWorkgroups = 2;
constexpr int kAllWorkgroupsMask = 0b11;
constexpr int kFirstWorkgroupMask = 0b01;

__attribute__((cluster_dims(2, 1, 1))) __global__ void
cluster_memory_kernel(std::int32_t *input, std::uint32_t *direct_output,
                      std::uint32_t *multicast_output, std::uint32_t *selected_output,
                      std::uint32_t *rank_output) {
  __shared__ std::int32_t multicast_lds[kWaveLanes];
  __shared__ std::int32_t selected_lds[kWaveLanes];
  const unsigned lane = threadIdx.x;
  const unsigned workgroup = blockIdx.x;
  const unsigned cluster_rank = __builtin_amdgcn_cluster_workgroup_id_x();

  multicast_lds[lane] = static_cast<std::int32_t>(kWordCanary);
  selected_lds[lane] = static_cast<std::int32_t>(kWordCanary);
  __syncthreads();
  if (lane == 0)
    rank_output[workgroup] = cluster_rank;

  const std::uint32_t direct =
      __builtin_amdgcn_cluster_load_b32(input + lane, 0, kAllWorkgroupsMask);
  asm volatile("s_wait_loadcnt 0" : : : "memory");
  direct_output[workgroup * kWaveLanes + lane] = direct;

  __builtin_amdgcn_cluster_load_async_to_lds_b32(
      input + lane, multicast_lds + lane, 0, 0, kAllWorkgroupsMask);
  asm volatile("s_wait_asynccnt 0" : : : "memory");
  __builtin_amdgcn_s_cluster_barrier();
  __syncthreads();
  multicast_output[workgroup * kWaveLanes + lane] = multicast_lds[lane];

  if (cluster_rank == 0)
    __builtin_amdgcn_cluster_load_async_to_lds_b32(
        input + lane, selected_lds + lane, 0, 0, kFirstWorkgroupMask);
  asm volatile("s_wait_asynccnt 0" : : : "memory");
  __builtin_amdgcn_s_cluster_barrier();
  __syncthreads();
  selected_output[workgroup * kWaveLanes + lane] = selected_lds[lane];
}

void launch_cluster_memory_test(std::int32_t *input, std::uint32_t *direct_output,
                                std::uint32_t *multicast_output,
                                std::uint32_t *selected_output, std::uint32_t *rank_output) {
  hipLaunchAttribute cluster_attribute{};
  cluster_attribute.id = hipLaunchAttributeClusterDimension;
  cluster_attribute.value.clusterDim.x = kClusterWorkgroups;
  cluster_attribute.value.clusterDim.y = 1;
  cluster_attribute.value.clusterDim.z = 1;

  hipLaunchConfig_t config{};
  config.gridDim = dim3(kClusterWorkgroups, 1, 1);
  config.blockDim = dim3(kWaveLanes, 1, 1);
  config.attrs = &cluster_attribute;
  config.numAttrs = 1;
  HIP_CHECK(hipLaunchKernelEx(&config, cluster_memory_kernel, input, direct_output,
                             multicast_output, selected_output, rank_output));
}
} // namespace

TEST(Gfx1250MemoryIsaCluster, B32LoadsAndMaskedLdsMulticastMatchManual) {
  REQUIRE_GFX1250_DEVICE();
  int device = 0;
  HIP_CHECK(hipGetDevice(&device));
  hipDeviceProp_t properties{};
  HIP_CHECK(hipGetDeviceProperties(&properties, device));
  ASSERT_NE(properties.clusterLaunch, 0) << "gfx1250 runtime must advertise clustered launch";

  std::vector<std::int32_t> input(kWaveLanes);
  for (unsigned lane = 0; lane < kWaveLanes; ++lane)
    input[lane] = static_cast<std::int32_t>(lane_word(lane, 0));
  auto device_input = DeviceBuffer<std::int32_t>::from_host(input);
  auto device_direct = DeviceBuffer<std::uint32_t>::allocate(kClusterWorkgroups * kWaveLanes);
  auto device_multicast = DeviceBuffer<std::uint32_t>::allocate(kClusterWorkgroups * kWaveLanes);
  auto device_selected = DeviceBuffer<std::uint32_t>::allocate(kClusterWorkgroups * kWaveLanes);
  auto device_ranks = DeviceBuffer<std::uint32_t>::allocate(kClusterWorkgroups);
  ASSERT_TRUE(device_input);
  ASSERT_TRUE(device_direct);
  ASSERT_TRUE(device_multicast);
  ASSERT_TRUE(device_selected);
  ASSERT_TRUE(device_ranks);

  launch_cluster_memory_test(device_input.get(), device_direct.get(), device_multicast.get(),
                             device_selected.get(), device_ranks.get());
  HIP_CHECK(hipDeviceSynchronize());
  const auto actual_direct = device_direct.to_host();
  const auto actual_multicast = device_multicast.to_host();
  const auto actual_selected = device_selected.to_host();
  const auto actual_ranks = device_ranks.to_host();

  ASSERT_EQ(actual_ranks.size(), kClusterWorkgroups);
  EXPECT_EQ(actual_ranks[0], 0u);
  EXPECT_EQ(actual_ranks[1], 1u);
  for (unsigned workgroup = 0; workgroup < kClusterWorkgroups; ++workgroup) {
    for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
      const std::size_t index = workgroup * kWaveLanes + lane;
      EXPECT_EQ(actual_direct[index], static_cast<std::uint32_t>(input[lane]))
          << "direct cluster load, workgroup " << workgroup << ", lane " << lane;
      EXPECT_EQ(actual_multicast[index], static_cast<std::uint32_t>(input[lane]))
          << "all-workgroup multicast, workgroup " << workgroup << ", lane " << lane;
      const std::uint32_t expected_selected =
          workgroup == 0 ? static_cast<std::uint32_t>(input[lane]) : kWordCanary;
      EXPECT_EQ(actual_selected[index], expected_selected)
          << "selected multicast, workgroup " << workgroup << ", lane " << lane;
    }
  }
}
