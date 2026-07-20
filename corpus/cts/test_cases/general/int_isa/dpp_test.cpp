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

constexpr unsigned quad_source(unsigned lane, unsigned control)
{
    return (lane & ~3u) + ((control >> (2u * (lane & 3u))) & 3u);
}

struct DppTrait
{
    struct Output
    {
        std::uint32_t mov_quad_swap;
        std::uint32_t update_quad_swap;
        std::uint32_t mov_dpp8_swap;
    };

    __device__ static Output device(unsigned lane)
    {
        const std::uint32_t src = lane_value(lane);
        const std::uint32_t old = src ^ 0xffffffffu;
        return {static_cast<std::uint32_t>(__builtin_amdgcn_mov_dpp(src, 0x00b1, 0xf, 0xf, false)),
                static_cast<std::uint32_t>(
                    __builtin_amdgcn_update_dpp(old, src, 0x00b1, 0x5, 0xf, false)),
                __builtin_amdgcn_mov_dpp8(src, 0xde54c1u)};
    }

    static Output oracle(unsigned lane)
    {
        const unsigned swapped_lane = quad_source(lane, 0x00b1);
        const unsigned row          = (lane >> 4u) & 3u;
        const bool     row_enabled  = (0x5u & (1u << row)) != 0;
        const unsigned dpp8_lane    = (lane & ~7u) | ((lane & 7u) ^ 1u);
        return {lane_value(swapped_lane),
                row_enabled ? lane_value(swapped_lane) : (lane_value(lane) ^ 0xffffffffu),
                lane_value(dpp8_lane)};
    }

    static void expect(const Output& actual, const Output& expected, unsigned lane)
    {
        EXPECT_EQ(actual.mov_quad_swap, expected.mov_quad_swap) << "lane " << lane;
        EXPECT_EQ(actual.update_quad_swap, expected.update_quad_swap) << "lane " << lane;
        EXPECT_EQ(actual.mov_dpp8_swap, expected.mov_dpp8_swap) << "lane " << lane;
    }
};
} // namespace

TEST(IntIsaDpp, BuiltinsMatchOracles)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_lane_test<DppTrait>();
}
