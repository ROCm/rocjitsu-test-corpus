// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "hip_test_utils.hpp"
#include "int_isa_test_utils.hpp"

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include <cstddef>
#include <cstdint>
#include <iostream>
#include <vector>

namespace
{
struct BfeInput
{
    std::uint32_t src;
    std::uint32_t offset;
    std::uint32_t width;
};

struct BfeOutput
{
    std::uint32_t ubfe;
    std::uint32_t sbfe_bits;
};

// Scalar VALU path under test: the same source bits feed unsigned and signed
// bitfield extract so sign-extension differences are isolated in the result.
__global__ void bfe_kernel(const BfeInput* inputs, BfeOutput* outputs, int count)
{
    const int i = blockIdx.x * blockDim.x + threadIdx.x;
    if(i >= count)
        return;

    const BfeInput in = inputs[i];
    outputs[i]        = {__builtin_amdgcn_ubfe(in.src, in.offset, in.width),
                         static_cast<std::uint32_t>(
                             __builtin_amdgcn_sbfe(in.src, in.offset, in.width))};
}

BfeOutput host_oracle(const BfeInput& in)
{
    return {int_isa_test::bfe_u32(in.src, in.offset, in.width),
            int_isa_test::bfe_i32_bits(in.src, in.offset, in.width)};
}

std::vector<BfeInput> test_inputs()
{
    return {
        {0xf0e1d2c3u, 0u, 8u},
        {0x8abc0ff0u, 4u, 12u},
        {0x80010000u, 16u, 16u},
        {0x87654321u, 0u, 31u},
        {0x12345678u, 8u, 0u},
        {0x80000000u, 31u, 1u},
        {0x7fffffffu, 27u, 5u},
        {0x0000f000u, 12u, 4u},
    };
}

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

void expect_output_eq(const BfeOutput& actual, const BfeOutput& expected, std::size_t case_index)
{
    expect_equal("ubfe", actual.ubfe, expected.ubfe, case_index);
    expect_equal("sbfe_bits", actual.sbfe_bits, expected.sbfe_bits, case_index);
}

} // namespace

TEST(Rdna4IntIsaScalarValu, BfeMatchesPublishedOracles)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";

    const std::vector<BfeInput> inputs = test_inputs();
    const int                   count  = static_cast<int>(inputs.size());

    BfeInput*  d_inputs  = nullptr;
    BfeOutput* d_outputs = nullptr;
    HIP_CHECK(hipMalloc(&d_inputs, inputs.size() * sizeof(BfeInput)));
    HIP_CHECK(hipMalloc(&d_outputs, inputs.size() * sizeof(BfeOutput)));
    HIP_CHECK(hipMemcpy(d_inputs,
                        inputs.data(),
                        inputs.size() * sizeof(BfeInput),
                        hipMemcpyHostToDevice));

    bfe_kernel<<<dim3(1), dim3(64)>>>(d_inputs, d_outputs, count);
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());

    std::vector<BfeOutput> actual(inputs.size());
    HIP_CHECK(hipMemcpy(actual.data(),
                        d_outputs,
                        actual.size() * sizeof(BfeOutput),
                        hipMemcpyDeviceToHost));

    for(std::size_t i = 0; i < inputs.size(); ++i)
        expect_output_eq(actual[i], host_oracle(inputs[i]), i);

    HIP_CHECK(hipFree(d_inputs));
    HIP_CHECK(hipFree(d_outputs));
}
