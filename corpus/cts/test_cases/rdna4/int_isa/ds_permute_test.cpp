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

struct DsCrossLaneTrait
{
    struct Output
    {
        std::uint32_t bpermute_rotate;
        std::uint32_t permute_rotate;
        std::uint32_t shuffle_rotate;
        std::uint32_t bpermute_fi_rotate;
        std::uint32_t bpermute_half;
        std::uint32_t permute_half;
        std::uint32_t bpermute_inactive;
        std::uint32_t bpermute_fi_inactive;
    };

    __device__ static Output device(unsigned lane)
    {
        constexpr unsigned      kHalfOffset       = int_isa_test::kWaveLanes / 2;
        constexpr std::uint32_t kInactiveSentinel = 0xc001d00du;
        const std::uint32_t     src               = lane_value(lane);
        const unsigned          next_lane = (lane + 1u) % int_isa_test::kWaveLanes;
        const unsigned          half_lane = lane ^ kHalfOffset;
        Output out{static_cast<std::uint32_t>(
                       __builtin_amdgcn_ds_bpermute(next_lane * 4, static_cast<int>(src))),
                   static_cast<std::uint32_t>(
                       __builtin_amdgcn_ds_permute(next_lane * 4, static_cast<int>(src))),
                   static_cast<std::uint32_t>(
                       __builtin_amdgcn_wave_shuffle(static_cast<int>(src), next_lane)),
                   static_cast<std::uint32_t>(
                       __builtin_amdgcn_ds_bpermute_fi_b32(next_lane * 4, static_cast<int>(src))),
                   static_cast<std::uint32_t>(
                       __builtin_amdgcn_ds_bpermute(half_lane * 4, static_cast<int>(src))),
                   static_cast<std::uint32_t>(
                       __builtin_amdgcn_ds_permute(half_lane * 4, static_cast<int>(src))),
                   kInactiveSentinel,
                   kInactiveSentinel};

        // Even lanes gather from inactive odd lanes. The ordinary form returns
        // zero; the gfx12 FI form fetches the source VGPR despite its EXEC bit.
        if((lane & 1u) == 0)
        {
            out.bpermute_inactive = static_cast<std::uint32_t>(
                __builtin_amdgcn_ds_bpermute(next_lane * 4, static_cast<int>(src)));
            out.bpermute_fi_inactive = static_cast<std::uint32_t>(
                __builtin_amdgcn_ds_bpermute_fi_b32(next_lane * 4, static_cast<int>(src)));
        }
        return out;
    }

    static Output oracle(unsigned lane)
    {
        constexpr std::uint32_t kInactiveSentinel = 0xc001d00du;
        const unsigned next_lane = (lane + 1u) % int_isa_test::kWaveLanes;
        const unsigned previous_lane =
            (lane + int_isa_test::kWaveLanes - 1u) % int_isa_test::kWaveLanes;
        const std::uint32_t gather  = lane_value(next_lane);
        const std::uint32_t scatter = lane_value(previous_lane);
        const std::uint32_t half = lane_value(lane ^ (int_isa_test::kWaveLanes / 2u));
        const bool          active = (lane & 1u) == 0;
        return {gather,
                scatter,
                gather,
                gather,
                half,
                half,
                active ? 0u : kInactiveSentinel,
                active ? gather : kInactiveSentinel};
    }

    static void expect(const Output& actual, const Output& expected, unsigned lane)
    {
        EXPECT_EQ(actual.bpermute_rotate, expected.bpermute_rotate) << "lane " << lane;
        EXPECT_EQ(actual.permute_rotate, expected.permute_rotate) << "lane " << lane;
        EXPECT_EQ(actual.shuffle_rotate, expected.shuffle_rotate) << "lane " << lane;
        EXPECT_EQ(actual.bpermute_fi_rotate, expected.bpermute_fi_rotate) << "lane " << lane;
        EXPECT_EQ(actual.bpermute_half, expected.bpermute_half) << "lane " << lane;
        EXPECT_EQ(actual.permute_half, expected.permute_half) << "lane " << lane;
        EXPECT_EQ(actual.bpermute_inactive, expected.bpermute_inactive) << "lane " << lane;
        EXPECT_EQ(actual.bpermute_fi_inactive, expected.bpermute_fi_inactive) << "lane " << lane;
    }
};
} // namespace

TEST(Rdna4IntIsaDsPermute, BuiltinsMatchOracles)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_lane_test<DsCrossLaneTrait>();
}
