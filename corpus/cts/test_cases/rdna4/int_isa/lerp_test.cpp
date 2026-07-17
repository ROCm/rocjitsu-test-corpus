// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "int_isa_test_utils.hpp"
#include "value_test_harness.hpp"

#include <cstdint>
#include <vector>

namespace
{
struct LerpInput
{
    std::uint32_t a;
    std::uint32_t b;
    std::uint32_t rounding;
};

struct LerpTrait
{
    using Input = LerpInput;
    struct Output
    {
        std::uint32_t result;
    };

    __device__ static Output device(const Input& in)
    {
        return {__builtin_amdgcn_lerp(in.a, in.b, in.rounding)};
    }

    static Output oracle(const Input& in)
    {
        return {int_isa_test::lerp_u8(in.a, in.b, in.rounding)};
    }

    static void expect(const Output& actual, const Output& expected, std::size_t case_index)
    {
        int_isa_test::expect_equal("lerp_u8", actual.result, expected.result, case_index);
    }
};

std::vector<LerpInput> lerp_inputs()
{
    return {{0x00112233u, 0xffeeddccu, 0x01000100u},
            {0x7f80fe01u, 0x801001ffu, 0x00010100u},
            {0x10203040u, 0x11213141u, 0xffffffffu},
            {0xffffffffu, 0x00000000u, 0x01010101u},
            {0x01030507u, 0x02040608u, 0x00000000u},
            {0x000102feu, 0xfffefd01u, 0x01000001u},
            {0x89abcdefu, 0x76543210u, 0x10101010u},
            {0x80808080u, 0x7f7f7f7fu, 0x01000100u}};
}
} // namespace

TEST(Rdna4IntIsaLerp, BuiltinMatchesOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_value_test_cases<LerpTrait>(lerp_inputs());
}
