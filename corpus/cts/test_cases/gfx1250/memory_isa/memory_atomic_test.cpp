// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "memory_test_harness.hpp"

#include <algorithm>
#include <array>
#include <cstdint>
#include <vector>

namespace {
using namespace memory_isa_test;

struct GlobalAtomicResult {
  std::uint32_t add_old;
  std::uint32_t cas_old;
  std::uint32_t add_f32_old;
  std::uint32_t min_nan_old;
  std::uint32_t max_zero_old;
  std::uint32_t add_inf_old;
  std::uint32_t max_denorm_old;
};

__global__ void global_atomic_kernel(std::uint32_t *values, GlobalAtomicResult *result) {
  if (threadIdx.x != 0)
    return;

  const std::uint32_t one = 1;
  std::uint32_t add_old;
  asm volatile("global_atomic_add_u32 %0, %1, %2, off th:TH_ATOMIC_RETURN\n\t"
               "s_wait_loadcnt 0"
               : "=v"(add_old)
               : "v"(values), "v"(one)
               : "memory");

  constexpr std::uint32_t cas_replacement = 0x76543210u;
  constexpr std::uint32_t cas_comparison = 0x12345679u;
  const std::uint64_t compare_and_swap =
      (std::uint64_t{cas_comparison} << 32) | cas_replacement;
  std::uint32_t cas_old;
  asm volatile("global_atomic_cmpswap_b32 %0, %1, %2, off th:TH_ATOMIC_RETURN\n\t"
               "s_wait_loadcnt 0"
               : "=v"(cas_old)
               : "v"(values), "v"(compare_and_swap)
               : "memory");

  const std::uint32_t neg_zero = 0x80000000u;
  std::uint32_t add_f32_old;
  asm volatile("global_atomic_add_f32 %0, %1, %2, off offset:4 th:TH_ATOMIC_RETURN\n\t"
               "s_wait_loadcnt 0"
               : "=v"(add_f32_old)
               : "v"(values), "v"(neg_zero)
               : "memory");

  const std::uint32_t quiet_nan = 0x7fc12345u;
  std::uint32_t min_nan_old;
  asm volatile("global_atomic_min_num_f32 %0, %1, %2, off offset:8 th:TH_ATOMIC_RETURN\n\t"
               "s_wait_loadcnt 0"
               : "=v"(min_nan_old)
               : "v"(values), "v"(quiet_nan)
               : "memory");

  std::uint32_t max_zero_old;
  asm volatile("global_atomic_max_num_f32 %0, %1, %2, off offset:12 th:TH_ATOMIC_RETURN\n\t"
               "s_wait_loadcnt 0"
               : "=v"(max_zero_old)
               : "v"(values), "v"(neg_zero)
               : "memory");

  const std::uint32_t negative_infinity = 0xff800000u;
  std::uint32_t add_inf_old;
  asm volatile("global_atomic_add_f32 %0, %1, %2, off offset:16 th:TH_ATOMIC_RETURN\n\t"
               "s_wait_loadcnt 0"
               : "=v"(add_inf_old)
               : "v"(values), "v"(negative_infinity)
               : "memory");

  const std::uint32_t smallest_denorm = 1;
  std::uint32_t max_denorm_old;
  asm volatile("global_atomic_max_num_f32 %0, %1, %2, off offset:20 th:TH_ATOMIC_RETURN\n\t"
               "s_wait_loadcnt 0"
               : "=v"(max_denorm_old)
               : "v"(values), "v"(smallest_denorm)
               : "memory");

  *result = {add_old, cas_old, add_f32_old, min_nan_old, max_zero_old, add_inf_old, max_denorm_old};
}

struct LdsAtomicResult {
  std::uint32_t integer_old;
  std::uint32_t add_nan_old;
  std::uint32_t min_zero_old;
  std::uint32_t max_zero_old;
  std::uint32_t values[4];
};

struct ContendedAtomicResult {
  std::uint32_t old_values[kWaveLanes];
  std::uint32_t final_value;
};

__global__ void global_contended_atomic_kernel(std::uint32_t *value,
                                               ContendedAtomicResult *result) {
  const std::uint32_t one = 1;
  std::uint32_t old;
  asm volatile("global_atomic_add_u32 %0, %1, %2, off th:TH_ATOMIC_RETURN\n\t"
               "s_wait_loadcnt 0"
               : "=v"(old)
               : "v"(value), "v"(one)
               : "memory");
  result->old_values[threadIdx.x] = old;
  __syncthreads();
  if (threadIdx.x == 0)
    result->final_value = *value;
}

__global__ void lds_contended_atomic_kernel(ContendedAtomicResult *result) {
  __shared__ std::uint32_t value;
  if (threadIdx.x == 0)
    value = 100;
  __syncthreads();
  const std::uint32_t one = 1;
  std::uint32_t old;
  asm volatile("ds_add_rtn_u32 %0, %1, %2\n\t"
               "s_wait_dscnt 0"
               : "=v"(old)
               : "v"(std::uint32_t{0}), "v"(one)
               : "memory");
  result->old_values[threadIdx.x] = old;
  __syncthreads();
  if (threadIdx.x == 0)
    result->final_value = value;
}

__global__ void lds_atomic_kernel(LdsAtomicResult *result) {
  __shared__ std::uint32_t lds[4];
  if (threadIdx.x == 0) {
    lds[0] = 41;
    lds[1] = 0x7f812345u; // signaling NaN
    lds[2] = 0x80000000u; // -0
    lds[3] = 0x00000000u; // +0
  }
  __syncthreads();
  if (threadIdx.x != 0)
    return;

  const std::uint32_t one = 1;
  const std::uint32_t quiet_nan = 0x7fc54321u;
  const std::uint32_t positive_zero = 0;
  const std::uint32_t negative_zero = 0x80000000u;
  std::uint32_t integer_old;
  std::uint32_t add_nan_old;
  std::uint32_t min_zero_old;
  std::uint32_t max_zero_old;
  asm volatile("ds_add_rtn_u32 %0, %4, %8\n\t"
               "ds_add_rtn_f32 %1, %5, %9\n\t"
               "ds_min_num_rtn_f32 %2, %6, %10\n\t"
               "ds_max_num_rtn_f32 %3, %7, %11\n\t"
               "s_wait_dscnt 0"
               : "=&v"(integer_old), "=&v"(add_nan_old), "=&v"(min_zero_old),
                 "=&v"(max_zero_old)
               : "v"(std::uint32_t{0}), "v"(std::uint32_t{4}), "v"(std::uint32_t{8}),
                 "v"(std::uint32_t{12}), "v"(one), "v"(quiet_nan), "v"(positive_zero),
                 "v"(negative_zero)
               : "memory");
  result->integer_old = integer_old;
  result->add_nan_old = add_nan_old;
  result->min_zero_old = min_zero_old;
  result->max_zero_old = max_zero_old;
  for (unsigned i = 0; i < 4; ++i)
    result->values[i] = lds[i];
}
} // namespace

TEST(Gfx1250MemoryIsaAtomic, GlobalReturnCompareSwapAndExceptionalFloatRules) {
  REQUIRE_GFX1250_DEVICE();
  const std::vector<std::uint32_t> initial = {0x12345678u, 0x80000000u, 0x3f800000u,
                                              0x00000000u, 0x7f800000u, 0x00000000u};
  auto values = DeviceBuffer<std::uint32_t>::from_host(initial);
  auto result = DeviceBuffer<GlobalAtomicResult>::allocate(1);
  ASSERT_TRUE(values);
  ASSERT_TRUE(result);
  global_atomic_kernel<<<1, kWaveLanes>>>(values.get(), result.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const auto actual = result.to_host().front();
  const auto final_values = values.to_host();
  EXPECT_EQ(actual.add_old, 0x12345678u);
  EXPECT_EQ(actual.cas_old, 0x12345679u);
  EXPECT_EQ(actual.add_f32_old, 0x80000000u);
  EXPECT_EQ(actual.min_nan_old, 0x3f800000u);
  EXPECT_EQ(actual.max_zero_old, 0x00000000u);
  EXPECT_EQ(actual.add_inf_old, 0x7f800000u);
  EXPECT_EQ(actual.max_denorm_old, 0x00000000u);
  EXPECT_EQ(final_values[0], 0x76543210u);
  EXPECT_EQ(final_values[1], 0x80000000u); // -0 + -0 preserves -0
  EXPECT_EQ(final_values[2], 0x3f800000u); // minNum(1, NaN) selects the number
  EXPECT_EQ(final_values[3], 0x00000000u); // maxNum(+0, -0) selects +0
  EXPECT_EQ(final_values[4], 0xffc00000u); // +inf + -inf is the canonical negative qNaN
  EXPECT_EQ(final_values[5], 0x00000001u); // global atomics do not flush denormals
}

TEST(Gfx1250MemoryIsaAtomic, LdsReturnNaNQuietingAndSignedZeroOrdering) {
  REQUIRE_GFX1250_DEVICE();
  auto result = DeviceBuffer<LdsAtomicResult>::allocate(1);
  ASSERT_TRUE(result);
  lds_atomic_kernel<<<1, kWaveLanes>>>(result.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());
  const auto actual = result.to_host().front();
  EXPECT_EQ(actual.integer_old, 41u);
  EXPECT_EQ(actual.add_nan_old, 0x7f812345u);
  EXPECT_EQ(actual.min_zero_old, 0x80000000u);
  EXPECT_EQ(actual.max_zero_old, 0x00000000u);
  EXPECT_EQ(actual.values[0], 42u);
  EXPECT_EQ(actual.values[1], 0x7fc12345u); // first NaN wins and signaling NaN is quieted
  EXPECT_EQ(actual.values[2], 0x80000000u); // minNum(-0, +0) is -0
  EXPECT_EQ(actual.values[3], 0x00000000u); // maxNum(+0, -0) is +0
}

TEST(Gfx1250MemoryIsaAtomic, ContendedGlobalAndLdsAddsSerializeAllLanes) {
  REQUIRE_GFX1250_DEVICE();
  auto global_value = DeviceBuffer<std::uint32_t>::from_host({100});
  auto global_result = DeviceBuffer<ContendedAtomicResult>::allocate(1);
  auto lds_result = DeviceBuffer<ContendedAtomicResult>::allocate(1);
  ASSERT_TRUE(global_value);
  ASSERT_TRUE(global_result);
  ASSERT_TRUE(lds_result);

  global_contended_atomic_kernel<<<1, kWaveLanes>>>(global_value.get(), global_result.get());
  HIP_CHECK(hipGetLastError());
  lds_contended_atomic_kernel<<<1, kWaveLanes>>>(lds_result.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());

  const ContendedAtomicResult global_actual = global_result.to_host().front();
  const ContendedAtomicResult lds_actual = lds_result.to_host().front();
  for (const ContendedAtomicResult *actual : {&global_actual, &lds_actual}) {
    EXPECT_EQ(actual->final_value, 100u + kWaveLanes);
    std::array<std::uint32_t, kWaveLanes> sorted{};
    std::copy_n(actual->old_values, kWaveLanes, sorted.begin());
    std::sort(sorted.begin(), sorted.end());
    for (unsigned i = 0; i < kWaveLanes; ++i)
      EXPECT_EQ(sorted[i], 100u + i) << "old-value rank " << i;
  }
}
