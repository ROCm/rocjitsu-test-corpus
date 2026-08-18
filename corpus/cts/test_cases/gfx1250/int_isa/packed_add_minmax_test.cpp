// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "int_isa_test_utils.hpp"
#include "value_test_harness.hpp"

#include <algorithm>
#include <cstdint>
#include <limits>
#include <vector>

namespace
{
struct PackedAddInput
{
    std::uint32_t a;
    std::uint32_t b;
    std::uint32_t c;
};

struct PackedAddOutput
{
    std::uint32_t max_i16;
    std::uint32_t max_u16;
    std::uint32_t min_i16;
    std::uint32_t min_u16;
};

constexpr std::int32_t saturated_add_i16(std::int32_t a, std::int32_t b)
{
    const std::int32_t sum = a + b;
    return sum > std::numeric_limits<std::int16_t>::max() ? std::numeric_limits<std::int16_t>::max()
           : sum < std::numeric_limits<std::int16_t>::min()
               ? std::numeric_limits<std::int16_t>::min()
               : sum;
}

constexpr std::uint32_t saturated_add_u16(std::uint32_t a, std::uint32_t b)
{
    const std::uint32_t sum = a + b;
    return sum > std::numeric_limits<std::uint16_t>::max()
               ? std::numeric_limits<std::uint16_t>::max()
               : sum;
}

template <bool Signed, bool SelectMax> constexpr std::uint32_t oracle(const PackedAddInput& in)
{
    std::uint32_t out = 0;
    for(unsigned lane = 0; lane < 2; ++lane)
    {
        std::uint32_t result = 0;
        if constexpr(Signed)
        {
            const std::int32_t sum = saturated_add_i16(int_isa_test::i16_lane(in.a, lane),
                                                       int_isa_test::i16_lane(in.b, lane));
            const std::int32_t c = int_isa_test::i16_lane(in.c, lane);
            result = static_cast<std::uint32_t>(SelectMax ? std::max(sum, c) : std::min(sum, c));
        }
        else
        {
            const std::uint32_t sum = saturated_add_u16(int_isa_test::half32(in.a, lane),
                                                        int_isa_test::half32(in.b, lane));
            const std::uint32_t c = int_isa_test::half32(in.c, lane);
            result = SelectMax ? std::max(sum, c) : std::min(sum, c);
        }
        out |= (result & 0xffffu) << (lane * 16);
    }
    return out;
}

struct PackedAddTrait
{
    using Input = PackedAddInput;
    using Output = PackedAddOutput;

    __device__ static Output device(const Input& in)
    {
        Output out{};
        asm volatile("v_pk_add_max_i16 %0, %1, %2, %3"
                     : "=v"(out.max_i16)
                     : "v"(in.a), "v"(in.b), "v"(in.c));
        asm volatile("v_pk_add_max_u16 %0, %1, %2, %3"
                     : "=v"(out.max_u16)
                     : "v"(in.a), "v"(in.b), "v"(in.c));
        asm volatile("v_pk_add_min_i16 %0, %1, %2, %3"
                     : "=v"(out.min_i16)
                     : "v"(in.a), "v"(in.b), "v"(in.c));
        asm volatile("v_pk_add_min_u16 %0, %1, %2, %3"
                     : "=v"(out.min_u16)
                     : "v"(in.a), "v"(in.b), "v"(in.c));
        return out;
    }

    static Output oracle(const Input& in)
    {
        return {::oracle<true, true>(in), ::oracle<false, true>(in), ::oracle<true, false>(in),
                ::oracle<false, false>(in)};
    }

    static void expect(const Output& actual, const Output& expected, std::size_t case_index)
    {
        int_isa_test::expect_equal("pk_add_max_i16", actual.max_i16, expected.max_i16, case_index);
        int_isa_test::expect_equal("pk_add_max_u16", actual.max_u16, expected.max_u16, case_index);
        int_isa_test::expect_equal("pk_add_min_i16", actual.min_i16, expected.min_i16, case_index);
        int_isa_test::expect_equal("pk_add_min_u16", actual.min_u16, expected.min_u16, case_index);
    }
};

std::vector<PackedAddInput> inputs()
{
    return {{0x00010002u, 0x00030004u, 0x00050001u}, {0x7fff7fffu, 0x00010002u, 0x7ffe8000u},
            {0x80008000u, 0xfffffffEu, 0x80017fffu}, {0xffffffffu, 0x00010001u, 0x1234abcdu},
            {0x7fff0000u, 0x7fff0001u, 0x4000ffffu}, {0x0000ffffu, 0xffff0001u, 0x80007fffu}};
}
} // namespace

TEST(Gfx1250IntIsaPackedAddMinMax, SaturationAndSelectionMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_value_test_cases<PackedAddTrait>(inputs());
}
