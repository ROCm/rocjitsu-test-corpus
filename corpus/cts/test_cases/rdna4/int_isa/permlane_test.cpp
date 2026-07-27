// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "wave_test_harness.hpp"

#include <cstdint>

namespace
{
constexpr std::uint32_t permlane_value(unsigned lane)
{
    return 0x9e370000u | ((lane * 0x21u + 0x13u) & 0xffffu);
}

constexpr std::uint32_t permlane_var_index(unsigned lane)
{
    return (lane & 15u) ^ 3u;
}

struct PermlaneVarTrait
{
    struct Output
    {
        std::uint32_t own_row;
        std::uint32_t other_row;
    };

    __device__ static Output device(unsigned lane)
    {
        const std::uint32_t src = permlane_value(lane);
        const std::uint32_t idx = permlane_var_index(lane);
        return {__builtin_amdgcn_permlane16_var(0xdeadbeefu, src, idx, false, false),
                __builtin_amdgcn_permlanex16_var(0xfeedfaceu, src, idx, false, false)};
    }

    static Output oracle(unsigned lane)
    {
        const unsigned idx        = permlane_var_index(lane);
        const unsigned own_lane   = (lane & ~15u) + idx;
        const unsigned other_lane = ((lane & ~15u) ^ 16u) + idx;
        return {permlane_value(own_lane), permlane_value(other_lane)};
    }

    static void expect(const Output& actual, const Output& expected, unsigned lane)
    {
        EXPECT_EQ(actual.own_row, expected.own_row) << "lane " << lane;
        EXPECT_EQ(actual.other_row, expected.other_row) << "lane " << lane;
    }
};

struct PermlaneFixedTrait
{
    struct Output
    {
        std::uint32_t own_row;
        std::uint32_t other_row;
        std::uint32_t half_swap;
    };

    __device__ static Output device(unsigned lane)
    {
        constexpr std::uint32_t kSwapLow  = 0x67452301u;
        constexpr std::uint32_t kSwapHigh = 0xefcdab89u;
        const std::uint32_t     src       = permlane_value(lane);
        return {__builtin_amdgcn_permlane16(0xdeadbeefu, src, kSwapLow, kSwapHigh, false, false),
                __builtin_amdgcn_permlanex16(0xfeedfaceu, src, kSwapLow, kSwapHigh, false, false),
                __builtin_amdgcn_permlane64(src)};
    }

    static Output oracle(unsigned lane)
    {
        const unsigned index      = (lane & 15u) ^ 1u;
        const unsigned own_lane   = (lane & ~15u) + index;
        const unsigned other_lane = ((lane & ~15u) ^ 16u) + index;
#ifdef INT_ISA_TEST_WAVE64
        const unsigned half_lane = lane ^ 32u;
#else
        const unsigned half_lane = lane;
#endif
        return {permlane_value(own_lane), permlane_value(other_lane), permlane_value(half_lane)};
    }

    static void expect(const Output& actual, const Output& expected, unsigned lane)
    {
        EXPECT_EQ(actual.own_row, expected.own_row) << "lane " << lane;
        EXPECT_EQ(actual.other_row, expected.other_row) << "lane " << lane;
        EXPECT_EQ(actual.half_swap, expected.half_swap) << "lane " << lane;
    }
};
} // namespace

TEST(Rdna4IntIsaPermlane, VariableBuiltinsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_lane_test<PermlaneVarTrait>();
}

TEST(Rdna4IntIsaPermlane, FixedBuiltinsMatchOracles)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_lane_test<PermlaneFixedTrait>();
}
