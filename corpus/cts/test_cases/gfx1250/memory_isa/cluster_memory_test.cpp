// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "memory_test_harness.hpp"

#include <cstdint>
#include <vector>

namespace {
using namespace memory_isa_test;

constexpr unsigned kClusterWorkgroups = 2;
constexpr int kNoMulticastMask = 0b00;
constexpr int kAllWorkgroupsMask = 0b11;
constexpr int kRank0Mask = 0b01;
constexpr int kRank1Mask = 0b10;

__attribute__((cluster_dims(2, 1, 1))) __global__ void
cluster_memory_kernel(std::int32_t *input, std::uint32_t *direct_output,
                      std::uint32_t *no_multicast_output,
                      std::uint32_t *rank0_mask_output, std::uint32_t *rank1_mask_output,
                      std::uint32_t *all_workgroups_output, std::uint32_t *rank_output) {
  __shared__ std::int32_t no_multicast_lds[kWaveLanes];
  __shared__ std::int32_t rank0_mask_lds[kWaveLanes];
  __shared__ std::int32_t rank1_mask_lds[kWaveLanes];
  __shared__ std::int32_t all_workgroups_lds[kWaveLanes];
  const unsigned lane = threadIdx.x;
  const unsigned workgroup = blockIdx.x;
  const unsigned cluster_rank = __builtin_amdgcn_cluster_workgroup_id_x();

  no_multicast_lds[lane] = static_cast<std::int32_t>(kWordCanary);
  rank0_mask_lds[lane] = static_cast<std::int32_t>(kWordCanary);
  rank1_mask_lds[lane] = static_cast<std::int32_t>(kWordCanary);
  all_workgroups_lds[lane] = static_cast<std::int32_t>(kWordCanary);
  __syncthreads();
  if (lane == 0)
    rank_output[workgroup] = cluster_rank;

  const std::uint32_t direct =
      __builtin_amdgcn_cluster_load_b32(input + lane, 0, kAllWorkgroupsMask);
  asm volatile("s_wait_loadcnt 0" : : : "memory");
  direct_output[workgroup * kWaveLanes + lane] = direct;

  if (cluster_rank == 0)
    __builtin_amdgcn_cluster_load_async_to_lds_b32(
        input + lane, no_multicast_lds + lane, 0, 0, kNoMulticastMask);
  asm volatile("s_wait_asynccnt 0" : : : "memory");
  __builtin_amdgcn_s_cluster_barrier();
  __syncthreads();
  no_multicast_output[workgroup * kWaveLanes + lane] = no_multicast_lds[lane];

  __builtin_amdgcn_cluster_load_async_to_lds_b32(
      input + lane, rank0_mask_lds + lane, 0, 0, kRank0Mask);
  asm volatile("s_wait_asynccnt 0" : : : "memory");
  __builtin_amdgcn_s_cluster_barrier();
  __syncthreads();
  rank0_mask_output[workgroup * kWaveLanes + lane] = rank0_mask_lds[lane];

  __builtin_amdgcn_cluster_load_async_to_lds_b32(
      input + lane, rank1_mask_lds + lane, 0, 0, kRank1Mask);
  asm volatile("s_wait_asynccnt 0" : : : "memory");
  __builtin_amdgcn_s_cluster_barrier();
  __syncthreads();
  rank1_mask_output[workgroup * kWaveLanes + lane] = rank1_mask_lds[lane];

  __builtin_amdgcn_cluster_load_async_to_lds_b32(
      input + lane, all_workgroups_lds + lane, 0, 0, kAllWorkgroupsMask);
  asm volatile("s_wait_asynccnt 0" : : : "memory");
  __builtin_amdgcn_s_cluster_barrier();
  __syncthreads();
  all_workgroups_output[workgroup * kWaveLanes + lane] = all_workgroups_lds[lane];
}

void launch_cluster_memory_test(std::int32_t *input, std::uint32_t *direct_output,
                                std::uint32_t *no_multicast_output,
                                std::uint32_t *rank0_mask_output,
                                std::uint32_t *rank1_mask_output,
                                std::uint32_t *all_workgroups_output,
                                std::uint32_t *rank_output) {
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
                             no_multicast_output, rank0_mask_output, rank1_mask_output,
                             all_workgroups_output, rank_output));
}
} // namespace

TEST(Gfx1250MemoryIsaCluster, B32LoadsAndAllMasksProduceVisibleResults) {
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
  auto device_no_multicast =
      DeviceBuffer<std::uint32_t>::allocate(kClusterWorkgroups * kWaveLanes);
  auto device_rank0_mask =
      DeviceBuffer<std::uint32_t>::allocate(kClusterWorkgroups * kWaveLanes);
  auto device_rank1_mask =
      DeviceBuffer<std::uint32_t>::allocate(kClusterWorkgroups * kWaveLanes);
  auto device_all_workgroups =
      DeviceBuffer<std::uint32_t>::allocate(kClusterWorkgroups * kWaveLanes);
  auto device_ranks = DeviceBuffer<std::uint32_t>::allocate(kClusterWorkgroups);
  ASSERT_TRUE(device_input);
  ASSERT_TRUE(device_direct);
  ASSERT_TRUE(device_no_multicast);
  ASSERT_TRUE(device_rank0_mask);
  ASSERT_TRUE(device_rank1_mask);
  ASSERT_TRUE(device_all_workgroups);
  ASSERT_TRUE(device_ranks);

  launch_cluster_memory_test(device_input.get(), device_direct.get(), device_no_multicast.get(),
                             device_rank0_mask.get(), device_rank1_mask.get(),
                             device_all_workgroups.get(), device_ranks.get());
  HIP_CHECK(hipDeviceSynchronize());
  const auto actual_direct = device_direct.to_host();
  const auto actual_no_multicast = device_no_multicast.to_host();
  const auto actual_rank0_mask = device_rank0_mask.to_host();
  const auto actual_rank1_mask = device_rank1_mask.to_host();
  const auto actual_all_workgroups = device_all_workgroups.to_host();
  const auto actual_ranks = device_ranks.to_host();

  ASSERT_EQ(actual_ranks.size(), kClusterWorkgroups);
  EXPECT_EQ(actual_ranks[0], 0u);
  EXPECT_EQ(actual_ranks[1], 1u);
  for (unsigned workgroup = 0; workgroup < kClusterWorkgroups; ++workgroup) {
    for (unsigned lane = 0; lane < kWaveLanes; ++lane) {
      const std::size_t index = workgroup * kWaveLanes + lane;
      const std::uint32_t input_value = static_cast<std::uint32_t>(input[lane]);
      EXPECT_EQ(actual_direct[index], static_cast<std::uint32_t>(input[lane]))
          << "direct cluster load, workgroup " << workgroup << ", lane " << lane;
      const std::uint32_t expected_rank0 = workgroup == 0 ? input_value : kWordCanary;
      const std::uint32_t expected_rank1 = workgroup == 1 ? input_value : kWordCanary;
      EXPECT_EQ(actual_no_multicast[index], expected_rank0)
          << "M0=0 requester-local result, workgroup " << workgroup << ", lane " << lane;
      EXPECT_EQ(actual_rank0_mask[index], expected_rank0)
          << "M0=1 rank-0-mask result, workgroup " << workgroup << ", lane " << lane;
      EXPECT_EQ(actual_rank1_mask[index], expected_rank1)
          << "M0=2 rank-1-mask result, workgroup " << workgroup << ", lane " << lane;
      EXPECT_EQ(actual_all_workgroups[index], input_value)
          << "M0=3 all-ranks result, workgroup " << workgroup << ", lane " << lane;
    }
  }
}
