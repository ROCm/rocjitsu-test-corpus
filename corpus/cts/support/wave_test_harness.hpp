// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#pragma once

#include "hip_test_utils.hpp"

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include <vector>

namespace int_isa_test
{
#ifdef INT_ISA_TEST_WAVE64
constexpr int kWaveLanes = 64;
#else
constexpr int kWaveLanes = 32;
#endif

template <class Trait>
__global__ void wave_test_kernel(typename Trait::Output* outputs)
{
    outputs[threadIdx.x] = Trait::device(threadIdx.x);
}

// Use this harness when every lane should observe one wave-wide result.
template <class Trait>
void run_wave_uniform_test()
{
    using Output = typename Trait::Output;

    Output* d_outputs = nullptr;
    HIP_CHECK(hipMalloc(&d_outputs, kWaveLanes * sizeof(Output)));

    wave_test_kernel<Trait><<<dim3(1), dim3(kWaveLanes)>>>(d_outputs);
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());

    std::vector<Output> actual(kWaveLanes);
    HIP_CHECK(
        hipMemcpy(actual.data(), d_outputs, actual.size() * sizeof(Output), hipMemcpyDeviceToHost));

    const Output expected = Trait::oracle();
    for(const Output& lane : actual)
        Trait::expect(lane, expected);

    HIP_CHECK(hipFree(d_outputs));
}

// Use this harness when the ISA operation produces a distinct result per lane.
template <class Trait>
void run_wave_lane_test()
{
    using Output = typename Trait::Output;

    Output* d_outputs = nullptr;
    HIP_CHECK(hipMalloc(&d_outputs, kWaveLanes * sizeof(Output)));

    wave_test_kernel<Trait><<<dim3(1), dim3(kWaveLanes)>>>(d_outputs);
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());

    std::vector<Output> actual(kWaveLanes);
    HIP_CHECK(
        hipMemcpy(actual.data(), d_outputs, actual.size() * sizeof(Output), hipMemcpyDeviceToHost));

    for(unsigned lane = 0; lane < kWaveLanes; ++lane)
        Trait::expect(actual[lane], Trait::oracle(lane), lane);

    HIP_CHECK(hipFree(d_outputs));
}
} // namespace int_isa_test
