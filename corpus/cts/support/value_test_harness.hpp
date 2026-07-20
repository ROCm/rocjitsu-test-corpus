// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#pragma once

#include "hip_test_utils.hpp"

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include <cstddef>
#include <iostream>
#include <vector>

namespace int_isa_test
{
template <class T>
void expect_equal(const char* name, T actual, T expected, std::size_t case_index)
{
    if(actual != expected)
    {
        std::cerr << "case " << case_index << " " << name << " actual=0x" << std::hex
                  << static_cast<unsigned long long>(actual) << " expected=0x"
                  << static_cast<unsigned long long>(expected) << std::dec << "\n";
    }
    EXPECT_EQ(actual, expected);
}

template <class Trait>
__global__ void value_test_kernel(const typename Trait::Input* inputs,
                                  typename Trait::Output*      outputs,
                                  int                          count)
{
    const int i = blockIdx.x * blockDim.x + threadIdx.x;
    if(i < count)
        outputs[i] = Trait::device(inputs[i]);
}

template <class Trait>
void run_value_test_cases(const std::vector<typename Trait::Input>& inputs)
{
    using Input  = typename Trait::Input;
    using Output = typename Trait::Output;

    const int count = static_cast<int>(inputs.size());
    Input*    d_inputs  = nullptr;
    Output*   d_outputs = nullptr;
    HIP_CHECK(hipMalloc(&d_inputs, inputs.size() * sizeof(Input)));
    HIP_CHECK(hipMalloc(&d_outputs, inputs.size() * sizeof(Output)));
    HIP_CHECK(
        hipMemcpy(d_inputs, inputs.data(), inputs.size() * sizeof(Input), hipMemcpyHostToDevice));

    value_test_kernel<Trait><<<dim3(1), dim3(64)>>>(d_inputs, d_outputs, count);
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());

    std::vector<Output> actual(inputs.size());
    HIP_CHECK(
        hipMemcpy(actual.data(), d_outputs, actual.size() * sizeof(Output), hipMemcpyDeviceToHost));

    for(std::size_t i = 0; i < inputs.size(); ++i)
        Trait::expect(actual[i], Trait::oracle(inputs[i]), i);

    HIP_CHECK(hipFree(d_inputs));
    HIP_CHECK(hipFree(d_outputs));
}
} // namespace int_isa_test
