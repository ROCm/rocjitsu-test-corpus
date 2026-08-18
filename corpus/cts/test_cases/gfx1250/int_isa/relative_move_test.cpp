// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "wave_test_harness.hpp"

#include <cstdint>

namespace
{
constexpr std::uint32_t lane_value(unsigned lane, std::uint32_t tag)
{
    return tag | (lane * 0x101u + 0x35u);
}

struct RelativeMoveTrait
{
    struct Output
    {
        std::uint32_t same_offset_move;
        std::uint32_t split_offset_move;
        std::uint32_t swapped_destination;
        std::uint32_t swapped_source;
        std::uint32_t zero_offset_move;
        std::uint32_t out_of_range_source;
        std::uint32_t suppressed_destination;
        std::uint32_t suppressed_swap_first;
        std::uint32_t suppressed_swap_second;
        std::uint32_t suppressed_full_width_destination;
        std::uint32_t suppressed_swap_high_first;
        std::uint32_t suppressed_swap_high_second;
    };

    __device__ static Output device(unsigned lane)
    {
        const std::uint32_t same_source = lane_value(lane, 0x11000000u);
        const std::uint32_t split_source = lane_value(lane, 0x22000000u);
        const std::uint32_t swap_dest = lane_value(lane, 0x33000000u);
        const std::uint32_t swap_source = lane_value(lane, 0x44000000u);
        std::uint32_t saved_m0;
        Output out{};
        asm volatile("s_mov_b32 %4, m0\n\t"
                     "v_mov_b32 v20, 0\n\t"
                     "v_mov_b32 v21, %5\n\t"
                     "s_mov_b32 m0, 1\n\t"
                     "v_movrelsd_b32 v19, v20\n\t"
                     "v_mov_b32 %0, v20\n\t"
                     "v_mov_b32 v32, 0\n\t"
                     "v_mov_b32 v34, %6\n\t"
                     "s_mov_b32 m0, 0x20001\n\t"
                     "v_movrelsd_2_b32 v30, v33\n\t"
                     "v_mov_b32 %1, v32\n\t"
                     "v_mov_b32 v42, %7\n\t"
                     "v_mov_b32 v44, %8\n\t"
                     "v_swaprel_b32 v40, v43\n\t"
                     "v_mov_b32 %2, v42\n\t"
                     "v_mov_b32 %3, v44\n\t"
                     "s_mov_b32 m0, %4"
                     : "=&v"(out.same_offset_move), "=&v"(out.split_offset_move),
                       "=&v"(out.swapped_destination), "=&v"(out.swapped_source), "=&s"(saved_m0)
                     : "v"(same_source), "v"(split_source), "v"(swap_dest), "v"(swap_source)
                     : "v19", "v20", "v21", "v30", "v32", "v33", "v34", "v40", "v42", "v43", "v44");
        const std::uint32_t zero_source = lane_value(lane, 0x55000000u);
        const std::uint32_t fallback = lane_value(lane, 0x66000000u);
        const std::uint32_t source_base = lane_value(lane, 0x77000000u);
        const std::uint32_t destination_base = lane_value(lane, 0x88000000u);
        const std::uint32_t valid_source = lane_value(lane, 0x99000000u);
        const std::uint32_t swap_first = lane_value(lane, 0xaa000000u);
        const std::uint32_t swap_second = lane_value(lane, 0xbb000000u);
        asm volatile("s_mov_b32 %5, m0\n\t"
                     "v_mov_b32 v10, 0\n\t"
                     "v_mov_b32 v11, %6\n\t"
                     "s_mov_b32 m0, 0\n\t"
                     "v_movrelsd_b32 v10, v11\n\t"
                     "v_mov_b32 %0, v10\n\t"
                     "v_mov_b32 v0, %7\n\t"
                     "v_mov_b32 v1, %8\n\t"
                     "v_mov_b32 v12, %9\n\t"
                     "s_mov_b32 m0, 0x3ff\n\t"
                     "v_movrelsd_2_b32 v12, v1\n\t"
                     "v_mov_b32 %1, v12\n\t"
                     "v_mov_b32 v1, %9\n\t"
                     "v_mov_b32 v12, %10\n\t"
                     "s_mov_b32 m0, 0x3ff0000\n\t"
                     "v_movrelsd_2_b32 v1, v12\n\t"
                     "v_mov_b32 %2, v1\n\t"
                     "v_mov_b32 v1, %11\n\t"
                     "v_mov_b32 v2, %12\n\t"
                     "s_mov_b32 m0, 0x3ff\n\t"
                     "v_swaprel_b32 v1, v2\n\t"
                     "v_mov_b32 %3, v1\n\t"
                     "v_mov_b32 %4, v2\n\t"
                     "s_mov_b32 m0, %5"
                     : "=&v"(out.zero_offset_move), "=&v"(out.out_of_range_source),
                       "=&v"(out.suppressed_destination), "=&v"(out.suppressed_swap_first),
                       "=&v"(out.suppressed_swap_second), "=&s"(saved_m0)
                     : "v"(zero_source), "v"(fallback), "v"(source_base), "v"(destination_base),
                       "v"(valid_source), "v"(swap_first), "v"(swap_second)
                     : "v0", "v1", "v2", "v10", "v11", "v12");
        const std::uint32_t full_width_destination = lane_value(lane, 0xcc000000u);
        const std::uint32_t full_width_source = lane_value(lane, 0xdd000000u);
        const std::uint32_t swap_high_first = lane_value(lane, 0xee000000u);
        const std::uint32_t swap_high_second = lane_value(lane, 0xff000000u);
        // Keep both operand bases in fixed low VGPRs. M0=1024 must suppress the
        // full-width move instead of wrapping, while M0[25:16]=1023 makes only
        // the swap destination out of range and must suppress both writes.
        asm volatile("s_mov_b32 %3, m0\n\t"
                     "v_mov_b32 v13, %4\n\t"
                     "v_mov_b32 v14, %5\n\t"
                     "s_mov_b32 m0, 0x400\n\t"
                     "v_movrelsd_b32 v13, v14\n\t"
                     "v_mov_b32 %0, v13\n\t"
                     "v_mov_b32 v3, %6\n\t"
                     "v_mov_b32 v4, %7\n\t"
                     "s_mov_b32 m0, 0x3ff0000\n\t"
                     "v_swaprel_b32 v3, v4\n\t"
                     "v_mov_b32 %1, v3\n\t"
                     "v_mov_b32 %2, v4\n\t"
                     "s_mov_b32 m0, %3"
                     : "=&v"(out.suppressed_full_width_destination),
                       "=&v"(out.suppressed_swap_high_first),
                       "=&v"(out.suppressed_swap_high_second), "=&s"(saved_m0)
                     : "v"(full_width_destination), "v"(full_width_source), "v"(swap_high_first),
                       "v"(swap_high_second)
                     : "v3", "v4", "v13", "v14");
        return out;
    }

    static Output oracle(unsigned lane)
    {
        return {lane_value(lane, 0x11000000u), lane_value(lane, 0x22000000u),
                lane_value(lane, 0x44000000u), lane_value(lane, 0x33000000u),
                lane_value(lane, 0x55000000u), lane_value(lane, 0x66000000u),
                lane_value(lane, 0x88000000u), lane_value(lane, 0xaa000000u),
                lane_value(lane, 0xbb000000u), lane_value(lane, 0xcc000000u),
                lane_value(lane, 0xee000000u), lane_value(lane, 0xff000000u)};
    }

    static void expect(const Output& actual, const Output& expected, unsigned lane)
    {
        EXPECT_EQ(actual.same_offset_move, expected.same_offset_move) << "lane " << lane;
        EXPECT_EQ(actual.split_offset_move, expected.split_offset_move) << "lane " << lane;
        EXPECT_EQ(actual.swapped_destination, expected.swapped_destination) << "lane " << lane;
        EXPECT_EQ(actual.swapped_source, expected.swapped_source) << "lane " << lane;
        EXPECT_EQ(actual.zero_offset_move, expected.zero_offset_move) << "lane " << lane;
        EXPECT_EQ(actual.out_of_range_source, expected.out_of_range_source) << "lane " << lane;
        EXPECT_EQ(actual.suppressed_destination, expected.suppressed_destination)
            << "lane " << lane;
        EXPECT_EQ(actual.suppressed_swap_first, expected.suppressed_swap_first) << "lane " << lane;
        EXPECT_EQ(actual.suppressed_swap_second, expected.suppressed_swap_second)
            << "lane " << lane;
        EXPECT_EQ(actual.suppressed_full_width_destination,
                  expected.suppressed_full_width_destination)
            << "lane " << lane;
        EXPECT_EQ(actual.suppressed_swap_high_first, expected.suppressed_swap_high_first)
            << "lane " << lane;
        EXPECT_EQ(actual.suppressed_swap_high_second, expected.suppressed_swap_high_second)
            << "lane " << lane;
    }
};
} // namespace

TEST(Gfx1250IntIsaRelativeMove, M0IndexedMovesAndSwapMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_lane_test<RelativeMoveTrait>();
}
