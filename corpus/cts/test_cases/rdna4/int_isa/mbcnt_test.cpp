// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "int_isa_test_utils.hpp"
#include "wave_test_harness.hpp"

#include <cstdint>

namespace
{
struct MbcntTrait
{
    struct Output
    {
        std::uint32_t lo_count;
        std::uint32_t hi_count;
    };

    __device__ static Output device(unsigned lane)
    {
        constexpr std::uint32_t kLoMask = 0xb6db6db6u;
        constexpr std::uint32_t kHiMask = 0x6db6db6du;
        const std::uint32_t     add     = 5u + (lane % 4u);
        const std::uint32_t     lo      = __builtin_amdgcn_mbcnt_lo(kLoMask, add);
        return {lo, __builtin_amdgcn_mbcnt_hi(kHiMask, lo)};
    }

    static Output oracle(unsigned lane)
    {
        constexpr std::uint32_t kLoMask = 0xb6db6db6u;
        constexpr std::uint32_t kHiMask = 0x6db6db6du;
        const std::uint32_t     add     = 5u + (lane % 4u);
        const std::uint32_t     lo      = int_isa_test::mbcnt_lo_u32(kLoMask, add, lane);
        return {lo, int_isa_test::mbcnt_hi_u32(kHiMask, lo, lane)};
    }

    static void expect(const Output& actual, const Output& expected, unsigned lane)
    {
        EXPECT_EQ(actual.lo_count, expected.lo_count) << "lane " << lane;
        EXPECT_EQ(actual.hi_count, expected.hi_count) << "lane " << lane;
    }
};
} // namespace

TEST(Rdna4IntIsaMbcnt, BuiltinsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_lane_test<MbcntTrait>();
}
