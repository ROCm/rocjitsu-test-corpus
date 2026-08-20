// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "int_isa_test_utils.hpp"
#include "value_test_harness.hpp"

#include <array>
#include <cstdint>
#include <vector>

namespace
{
using u32x2 = std::uint32_t __attribute__((ext_vector_type(2)));
using u32x3 = std::uint32_t __attribute__((ext_vector_type(3)));
using u32x4 = std::uint32_t __attribute__((ext_vector_type(4)));

struct PackedPermuteInput
{
    u32x2 table_b4;
    u32x3 table_b6;
    u32x4 table_b8;
    u32x2 selectors;
};

struct PackedPermuteOutput
{
    u32x2 b4;
    u32x3 b6;
    u32x4 b8;
};

template <unsigned Width, std::size_t Words>
std::array<std::uint32_t, Words> lookup(const std::array<std::uint32_t, Words>& table,
                                        const u32x2& selectors)
{
    std::array<std::uint32_t, Words> out{};
    constexpr std::uint32_t mask = (1u << Width) - 1u;
    for(unsigned output_lane = 0; output_lane < 16; ++output_lane)
    {
        const unsigned selector = (selectors[output_lane / 8] >> ((output_lane % 8) * 4)) & 0xfu;
        const unsigned source_bit = selector * Width;
        const unsigned source_word = source_bit / 32;
        const unsigned source_shift = source_bit % 32;
        std::uint64_t value = table[source_word] >> source_shift;
        if(source_shift + Width > 32)
            value |= static_cast<std::uint64_t>(table[source_word + 1]) << (32 - source_shift);
        const unsigned output_bit = output_lane * Width;
        const unsigned output_word = output_bit / 32;
        const unsigned output_shift = output_bit % 32;
        out[output_word] |= static_cast<std::uint32_t>(value & mask) << output_shift;
        if(output_shift + Width > 32)
            out[output_word + 1] |= static_cast<std::uint32_t>(value & mask) >> (32 - output_shift);
    }
    return out;
}

struct PackedPermuteTrait
{
    using Input = PackedPermuteInput;
    using Output = PackedPermuteOutput;

    __device__ static Output device(const Input& in)
    {
        Output out{};
        const u32x2 table_b6_lo = {in.table_b6[0], in.table_b6[1]};
        const u32x2 table_b8_lo = {in.table_b8[0], in.table_b8[1]};
        const u32x2 table_b8_hi = {in.table_b8[2], in.table_b8[3]};
        // CDNA5 concatenates SRC0 above SRC1. Keep the host tables in natural
        // least-significant-word-first order and pass their high part first.
        asm volatile("v_perm_pk16_b4_u4 %0, %1, %2, %3"
                     : "=v"(out.b4)
                     : "v"(in.table_b4[1]), "v"(in.table_b4[0]), "v"(in.selectors));
        asm volatile("v_perm_pk16_b6_u4 %0, %1, %2, %3"
                     : "=v"(out.b6)
                     : "v"(in.table_b6[2]), "v"(table_b6_lo), "v"(in.selectors));
        asm volatile("v_perm_pk16_b8_u4 %0, %1, %2, %3"
                     : "=v"(out.b8)
                     : "v"(table_b8_hi), "v"(table_b8_lo), "v"(in.selectors));
        return out;
    }

    static Output oracle(const Input& in)
    {
        const auto b4 =
            lookup<4>(std::array<std::uint32_t, 2>{in.table_b4[0], in.table_b4[1]}, in.selectors);
        const auto b6 =
            lookup<6>(std::array<std::uint32_t, 3>{in.table_b6[0], in.table_b6[1], in.table_b6[2]},
                      in.selectors);
        const auto b8 = lookup<8>(std::array<std::uint32_t, 4>{in.table_b8[0], in.table_b8[1],
                                                               in.table_b8[2], in.table_b8[3]},
                                  in.selectors);
        return {{b4[0], b4[1]}, {b6[0], b6[1], b6[2]}, {b8[0], b8[1], b8[2], b8[3]}};
    }

    static void expect(const Output& actual, const Output& expected, std::size_t case_index)
    {
        for(unsigned word = 0; word < 2; ++word)
            int_isa_test::expect_equal("perm_pk16_b4", actual.b4[word], expected.b4[word],
                                       case_index);
        for(unsigned word = 0; word < 3; ++word)
            int_isa_test::expect_equal("perm_pk16_b6", actual.b6[word], expected.b6[word],
                                       case_index);
        for(unsigned word = 0; word < 4; ++word)
            int_isa_test::expect_equal("perm_pk16_b8", actual.b8[word], expected.b8[word],
                                       case_index);
    }
};

std::vector<PackedPermuteInput> inputs()
{
    return {{{0x01234567u, 0x89abcdefu},
             {0x01234567u, 0x89abcdefu, 0xfedcba98u},
             {0x01234567u, 0x89abcdefu, 0x76543210u, 0xfedcba98u},
             {0x76543210u, 0xfedcba98u}},
            {{0x89abcdefu, 0x01234567u},
             {0xdeadbeefu, 0x13579bdfu, 0x2468ace0u},
             {0x00112233u, 0x44556677u, 0x8899aabbu, 0xccddeeffu},
             {0x00000000u, 0xffffffffu}},
            {{0xfedcba98u, 0x76543210u},
             {0xffffffffu, 0x00000000u, 0xaaaaaaaau},
             {0xffffffffu, 0x00000000u, 0xaaaaaaaau, 0x55555555u},
             {0x01234567u, 0x89abcdefu}},
            {{0x80000001u, 0x10000008u},
             {0x80000001u, 0x00000002u, 0x10000008u},
             {0x80000001u, 0x00000002u, 0x00000004u, 0x10000008u},
             {0x0000f870u, 0x0123456fu}}};
}
} // namespace

TEST(Gfx1250IntIsaPackedPermute, LookupTablesMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_value_test_cases<PackedPermuteTrait>(inputs());
}
