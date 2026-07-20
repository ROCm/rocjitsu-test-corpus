// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "wave_test_harness.hpp"

#include <cstdint>

namespace
{
constexpr std::int32_t readlane_value(unsigned lane)
{
    return 1000 + static_cast<std::int32_t>(lane) * 17;
}

struct LaneMoveTrait
{
    struct Output
    {
        std::uint32_t wavefront_size;
        std::int32_t  readfirstlane;
        std::int32_t  readlane7;
    };

    __device__ static Output device(unsigned lane)
    {
        const std::int32_t lane_value = readlane_value(lane);
        return {__builtin_amdgcn_wavefrontsize(),
                __builtin_amdgcn_readfirstlane(lane_value),
                __builtin_amdgcn_readlane(lane_value, 7)};
    }

    static Output oracle()
    {
        return {int_isa_test::kWaveLanes, readlane_value(0), readlane_value(7)};
    }

    static void expect(const Output& actual, const Output& expected)
    {
        EXPECT_EQ(actual.wavefront_size, expected.wavefront_size);
        EXPECT_EQ(actual.readfirstlane, expected.readfirstlane);
        EXPECT_EQ(actual.readlane7, expected.readlane7);
    }
};
} // namespace

TEST(IntIsaLaneRead, BuiltinsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_uniform_test<LaneMoveTrait>();
}
