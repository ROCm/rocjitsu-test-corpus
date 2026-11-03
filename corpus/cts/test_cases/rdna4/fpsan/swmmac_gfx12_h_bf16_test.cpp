// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "hip_test_utils.hpp"
#include "swmmac_gfx12_parts.hpp"

__global__ void k_swmmac_bf16_float(const float *A, const float *B, const float *C, const int *p0,
                                    const int *p1, const std::uint16_t *idx, float *D) {
  auto fn = [](auto av, auto bv, auto cv, std::uint16_t i) {
    return fpsan::amdgcn_swmmac_f32_16x16x32_bf16_w32<Semantics::Native, kCC>(av, bv, cv, i);
  };
  swmmac_h_dataflow<Semantics::Native, __bf16, __bf16, float, float>(A, B, C, p0, p1, idx, D, fn);
}

template <Semantics S>
__global__ void k_swmmac_bf16_fpsan(const float *A, const float *B, const float *C, const int *p0,
                                    const int *p1, const std::uint16_t *idx, std::uint32_t *D) {
  auto fn = [](auto av, auto bv, auto cv, std::uint16_t i) {
    return fpsan::amdgcn_swmmac_f32_16x16x32_bf16_w32<S, kCC>(av, bv, cv, i);
  };
  swmmac_h_dataflow<S, __bf16, __bf16, float, std::uint32_t>(A, B, C, p0, p1, idx, D, fn);
}

TEST(SwmmacGfx12, F32_BF16_LayoutMatchesHardware) {
  DeviceAllocations device_allocations;
  if (!have_device())
    GTEST_SKIP() << "no HIP device";
  SwData d = make_sw_data(0x200, encode_idx_h);
  std::vector<float> ref = sw_reference_h<float>(d);
  float *dA = device_allocations.to_dev(d.A), *dB = device_allocations.to_dev(d.B),
        *dC = device_allocations.to_dev(d.C);
  int *dp0 = device_allocations.to_dev(d.p0), *dp1 = device_allocations.to_dev(d.p1);
  std::uint16_t *dI = device_allocations.to_dev(d.idx);
  float *dD = device_allocations.allocate<float>(kSwM * kSwN);
  k_swmmac_bf16_float<<<1, WAVE>>>(dA, dB, dC, dp0, dp1, dI, dD);
  HIP_CHECK(hipDeviceSynchronize());
  std::vector<float> got(kSwM * kSwN);
  HIP_CHECK(hipMemcpy(got.data(), dD, kSwM * kSwN * sizeof(float), hipMemcpyDeviceToHost));
  for (int t = 0; t < kSwM * kSwN; ++t)
    EXPECT_EQ(bits_of(got[t]), bits_of(ref[t])) << "at " << t;
}

TEST(SwmmacGfx12, F32_BF16_FpsanMatchesScalarReference) {
  DeviceAllocations device_allocations;
  if (!have_device())
    GTEST_SKIP() << "no HIP device";
  SwData d = make_sw_data(0x200, encode_idx_h);
  float *dA = device_allocations.to_dev(d.A), *dB = device_allocations.to_dev(d.B),
        *dC = device_allocations.to_dev(d.C);
  int *dp0 = device_allocations.to_dev(d.p0), *dp1 = device_allocations.to_dev(d.p1);
  std::uint16_t *dI = device_allocations.to_dev(d.idx);
  fpsan_test::for_matrix_fpsan_semantics([&](auto sem) {
    constexpr Semantics S = decltype(sem)::value;
    std::vector<std::uint64_t> ref = sw_reference_fpsan_h<S, __bf16, __bf16, float>(d);
    DeviceAllocations iteration_allocations;
    std::uint32_t *dD = iteration_allocations.allocate<std::uint32_t>(kSwM * kSwN);
    k_swmmac_bf16_fpsan<S><<<1, WAVE>>>(dA, dB, dC, dp0, dp1, dI, dD);
    HIP_CHECK(hipDeviceSynchronize());
    std::vector<std::uint32_t> got(kSwM * kSwN);
    HIP_CHECK(
        hipMemcpy(got.data(), dD, kSwM * kSwN * sizeof(std::uint32_t), hipMemcpyDeviceToHost));
    for (int t = 0; t < kSwM * kSwN; ++t)
      EXPECT_EQ(static_cast<std::uint64_t>(got[t]), ref[t]) << "at " << t;
  });
}
