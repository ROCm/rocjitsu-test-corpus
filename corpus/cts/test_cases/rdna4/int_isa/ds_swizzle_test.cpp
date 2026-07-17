// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "wave_test_harness.hpp"

#include <cstdint>

namespace
{
constexpr std::uint32_t lane_value(unsigned lane)
{
    return 0x9e370000u | ((lane * 0x21u + 0x13u) & 0xffffu);
}

constexpr unsigned swizzle_source(unsigned lane, unsigned pattern)
{
    if((pattern & 0x8000u) != 0)
    {
        const unsigned quad_base = lane & ~3u;
        const unsigned selector  = (pattern >> (2u * (lane & 3u))) & 3u;
        return quad_base + selector;
    }

    const unsigned row_base = lane & ~31u;
    const unsigned row_lane = lane & 31u;
    const unsigned and_mask = pattern & 0x1fu;
    const unsigned or_mask  = (pattern >> 5u) & 0x1fu;
    const unsigned xor_mask = (pattern >> 10u) & 0x1fu;
    return row_base + (((row_lane & and_mask) | or_mask) ^ xor_mask);
}

struct DsSwizzleTrait
{
    struct Output
    {
        std::uint32_t xor_pairs;
        std::uint32_t quad_swap;
    };

    __device__ static Output device(unsigned lane)
    {
        const std::uint32_t src = lane_value(lane);
        return {
            static_cast<std::uint32_t>(__builtin_amdgcn_ds_swizzle(static_cast<int>(src), 0x041f)),
            static_cast<std::uint32_t>(__builtin_amdgcn_ds_swizzle(static_cast<int>(src), 0x80b1))};
    }

    static Output oracle(unsigned lane)
    {
        return {lane_value(swizzle_source(lane, 0x041f)),
                lane_value(swizzle_source(lane, 0x80b1))};
    }

    static void expect(const Output& actual, const Output& expected, unsigned lane)
    {
        EXPECT_EQ(actual.xor_pairs, expected.xor_pairs) << "lane " << lane;
        EXPECT_EQ(actual.quad_swap, expected.quad_swap) << "lane " << lane;
    }
};
} // namespace

TEST(Rdna4IntIsaDsSwizzle, BuiltinMatchesOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_lane_test<DsSwizzleTrait>();
}
