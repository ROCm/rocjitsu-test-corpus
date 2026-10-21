// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "hip_test_utils.hpp"
#include "swmmac_gfx12_parts.hpp"

TEST(SwmmacGfx12, F32_F16_LayoutMatchesHardware) {
  DeviceAllocations device_allocations;
  if (!have_device())
    GTEST_SKIP() << "no HIP device";
  SwData d = make_sw_data(0x100, encode_idx_h);
  std::vector<float> ref = sw_reference_h<float>(d);
  float *dA = device_allocations.to_dev(d.A), *dB = device_allocations.to_dev(d.B),
        *dC = device_allocations.to_dev(d.C);
  int *dp0 = device_allocations.to_dev(d.p0), *dp1 = device_allocations.to_dev(d.p1);
  std::uint16_t *dI = device_allocations.to_dev(d.idx);
  float *dD = device_allocations.allocate<float>(kSwM * kSwN);
  k_swmmac_f16_float<<<1, WAVE>>>(dA, dB, dC, dp0, dp1, dI, dD);
  HIP_CHECK(hipDeviceSynchronize());
  std::vector<float> got(kSwM * kSwN);
  HIP_CHECK(hipMemcpy(got.data(), dD, kSwM * kSwN * sizeof(float), hipMemcpyDeviceToHost));
  for (int t = 0; t < kSwM * kSwN; ++t)
    EXPECT_EQ(bits_of(got[t]), bits_of(ref[t])) << "at " << t;
}

TEST(SwmmacGfx12, F32_F16_FpsanMatchesScalarReference) {
  DeviceAllocations device_allocations;
  if (!have_device())
    GTEST_SKIP() << "no HIP device";
  SwData d = make_sw_data(0x100, encode_idx_h);
  float *dA = device_allocations.to_dev(d.A), *dB = device_allocations.to_dev(d.B),
        *dC = device_allocations.to_dev(d.C);
  int *dp0 = device_allocations.to_dev(d.p0), *dp1 = device_allocations.to_dev(d.p1);
  std::uint16_t *dI = device_allocations.to_dev(d.idx);
  fpsan_test::for_matrix_fpsan_semantics([&](auto sem) {
    constexpr Semantics S = decltype(sem)::value;
    std::vector<std::uint64_t> ref = sw_reference_fpsan_h<S, _Float16, _Float16, float>(d);
    DeviceAllocations device_allocations;
    std::uint32_t *dD = device_allocations.allocate<std::uint32_t>(kSwM * kSwN);
    k_swmmac_f16_fpsan<S><<<1, WAVE>>>(dA, dB, dC, dp0, dp1, dI, dD);
    HIP_CHECK(hipDeviceSynchronize());
    std::vector<std::uint32_t> got(kSwM * kSwN);
    HIP_CHECK(
        hipMemcpy(got.data(), dD, kSwM * kSwN * sizeof(std::uint32_t), hipMemcpyDeviceToHost));
    for (int t = 0; t < kSwM * kSwN; ++t)
      EXPECT_EQ(static_cast<std::uint64_t>(got[t]), ref[t]) << "at " << t;
  });
}
