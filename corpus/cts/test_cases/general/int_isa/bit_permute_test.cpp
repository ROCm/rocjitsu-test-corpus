// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "int_isa_test_utils.hpp"
#include "value_test_harness.hpp"

#include <cstdint>
#include <vector>

namespace
{
struct BitPermuteInput
{
    std::uint32_t src0;
    std::uint32_t src1;
    std::uint32_t selector;
};

struct BitPermuteTrait
{
    using Input = BitPermuteInput;
    struct Output
    {
        std::uint32_t alignbit;
        std::uint32_t alignbyte;
        std::uint32_t perm;
    };

    // Invoke the named ISA builtins directly so compiler-generated shuffles do
    // not accidentally stand in for the operations under test.
    __device__ static Output device(const Input& in)
    {
        return {__builtin_amdgcn_alignbit(in.src0, in.src1, in.selector),
                __builtin_amdgcn_alignbyte(in.src0, in.src1, in.selector),
                __builtin_amdgcn_perm(in.src0, in.src1, in.selector)};
    }

    static Output oracle(const Input& in)
    {
        return {int_isa_test::alignbit_u32(in.src0, in.src1, in.selector),
                int_isa_test::alignbyte_u32(in.src0, in.src1, in.selector),
                int_isa_test::perm_b32(in.src0, in.src1, in.selector)};
    }

    static void expect(const Output& actual, const Output& expected, std::size_t case_index)
    {
        int_isa_test::expect_equal("alignbit", actual.alignbit, expected.alignbit, case_index);
        int_isa_test::expect_equal("alignbyte", actual.alignbyte, expected.alignbyte, case_index);
        int_isa_test::expect_equal("perm", actual.perm, expected.perm, case_index);
    }
};

std::vector<BitPermuteInput> bit_permute_inputs()
{
    return {{0x01234567u, 0x89abcdefu, 0x00010203u},
            {0x00112233u, 0x44556677u, 0x07060504u},
            {0xff00aa55u, 0x807f0102u, 0x08090a0bu},
            {0x10203040u, 0x50607080u, 0x0d0c0700u},
            {0x7f80aa55u, 0x807f0102u, 0x0f0e0d0cu},
            {0xdeadbeefu, 0x12345678u, 5u},
            {0x00000000u, 0xffffffffu, 31u},
            {0xf0e1d2c3u, 0xb4a59687u, 7u},
            {0x13579bdfu, 0x2468ace0u, 0x04050607u}};
}
} // namespace

TEST(IntIsaBitPermute, BuiltinsMatchOracles)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_value_test_cases<BitPermuteTrait>(bit_permute_inputs());
}
