// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "wave_test_harness.hpp"

#include <cstdint>

namespace
{
struct BallotTrait
{
    struct Output
    {
        std::uint64_t mask;
        std::uint32_t inverse;
    };

    static constexpr bool predicate(unsigned lane)
    {
        return (lane % 5u) == 2u || lane == int_isa_test::kWaveLanes - 1u;
    }

    static std::uint64_t expected_mask()
    {
        std::uint64_t mask = 0;
        for(unsigned lane = 0; lane < int_isa_test::kWaveLanes; ++lane)
            if(predicate(lane))
                mask |= 1ull << lane;
        return mask;
    }

    __device__ static Output device(unsigned lane)
    {
#ifdef INT_ISA_TEST_WAVE64
        const std::uint64_t mask = __builtin_amdgcn_ballot_w64(predicate(lane));
        return {mask, __builtin_amdgcn_inverse_ballot_w64(mask) ? 1u : 0u};
#else
        const std::uint32_t mask = __builtin_amdgcn_ballot_w32(predicate(lane));
        return {mask, __builtin_amdgcn_inverse_ballot_w32(mask) ? 1u : 0u};
#endif
    }

    static Output oracle(unsigned lane)
    {
        return {expected_mask(), predicate(lane) ? 1u : 0u};
    }

    static void expect(const Output& actual, const Output& expected, unsigned lane)
    {
        EXPECT_EQ(actual.mask, expected.mask) << "lane " << lane;
        EXPECT_EQ(actual.inverse, expected.inverse) << "lane " << lane;
    }
};
} // namespace

TEST(IntIsaBallot, BuiltinsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_lane_test<BallotTrait>();
}
