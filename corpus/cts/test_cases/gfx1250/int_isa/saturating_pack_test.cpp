// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "int_isa_test_utils.hpp"
#include "value_test_harness.hpp"

#include <algorithm>
#include <cstdint>
#include <vector>

namespace
{
struct SaturatingPackInput
{
    std::uint32_t i16x2;
    std::uint32_t i8x4;
    std::uint32_t u8x4;
};

struct SaturatingPackOutput
{
    std::uint16_t u8x2;
    std::uint16_t i4x4;
    std::uint16_t u4x4;
};

constexpr std::uint8_t saturate_u8(std::int32_t value)
{
    return value <= 0 ? 0 : value >= 255 ? 255 : static_cast<std::uint8_t>(value);
}

constexpr std::uint8_t saturate_i4(std::int32_t value)
{
    const std::int32_t clamped = value <= -8 ? -8 : value >= 7 ? 7 : value;
    return static_cast<std::uint8_t>(clamped) & 0xfu;
}

constexpr std::uint8_t saturate_u4(std::uint32_t value)
{
    return static_cast<std::uint8_t>(value >= 15 ? 15 : value);
}

struct SaturatingPackTrait
{
    using Input = SaturatingPackInput;
    using Output = SaturatingPackOutput;

    __device__ static Output device(const Input& in)
    {
        Output out{};
        asm volatile("v_sat_pk_u8_i16 %0, %1" : "=v"(out.u8x2) : "v"(in.i16x2));
        asm volatile("v_sat_pk4_i4_i8 %0, %1" : "=v"(out.i4x4) : "v"(in.i8x4));
        asm volatile("v_sat_pk4_u4_u8 %0, %1" : "=v"(out.u4x4) : "v"(in.u8x4));
        return out;
    }

    static Output oracle(const Input& in)
    {
        Output out{};
        out.u8x2 = static_cast<std::uint16_t>(
            saturate_u8(int_isa_test::i16_lane(in.i16x2, 0)) |
            (static_cast<std::uint16_t>(saturate_u8(int_isa_test::i16_lane(in.i16x2, 1))) << 8));
        for(unsigned lane = 0; lane < 4; ++lane)
        {
            out.i4x4 |=
                static_cast<std::uint16_t>(saturate_i4(int_isa_test::i8_lane(in.i8x4, lane)))
                << (lane * 4);
            out.u4x4 |= static_cast<std::uint16_t>(saturate_u4(int_isa_test::byte32(in.u8x4, lane)))
                        << (lane * 4);
        }
        return out;
    }

    static void expect(const Output& actual, const Output& expected, std::size_t case_index)
    {
        int_isa_test::expect_equal("sat_pk_u8_i16", actual.u8x2, expected.u8x2, case_index);
        int_isa_test::expect_equal("sat_pk4_i4_i8", actual.i4x4, expected.i4x4, case_index);
        int_isa_test::expect_equal("sat_pk4_u4_u8", actual.u4x4, expected.u4x4, case_index);
    }
};

std::vector<SaturatingPackInput> inputs()
{
    return {{0x00000000u, 0x00000000u, 0x00000000u},
            {0x0001ffffu, 0x01ff08f8u, 0x010f10ffu},
            {0x00ff0100u, 0x7f0780f9u, 0x7f0e0f10u},
            {0x7fff8000u, 0x807f10efu, 0xff10200au},
            {0x80017ffeu, 0xf80708f7u, 0x0f00010eu}};
}
} // namespace

TEST(Gfx1250IntIsaSaturatingPack, BoundaryValuesMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_value_test_cases<SaturatingPackTrait>(inputs());
}
