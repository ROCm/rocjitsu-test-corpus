// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "int_isa_test_utils.hpp"
#include "value_test_harness.hpp"

#include <cstdint>
#include <vector>

namespace
{
using v2i16 = short __attribute__((ext_vector_type(2)));
using v2u16 = unsigned short __attribute__((ext_vector_type(2)));

struct CvtPkI16Trait
{
    struct Input
    {
        std::int32_t lo;
        std::int32_t hi;
    };
    struct Output
    {
        std::uint32_t packed_bits;
    };

    __device__ static Output device(const Input& in)
    {
        const v2i16 packed = __builtin_amdgcn_cvt_pk_i16(in.lo, in.hi);
        return {__builtin_bit_cast(std::uint32_t, packed)};
    }

    static Output oracle(const Input& in)
    {
        return {int_isa_test::cvt_pk_i16_pair(in.lo, in.hi)};
    }

    static void expect(const Output& actual, const Output& expected, std::size_t case_index)
    {
        int_isa_test::expect_equal(
            "cvt_pk_i16_bits", actual.packed_bits, expected.packed_bits, case_index);
    }
};

struct CvtPkU16Trait
{
    struct Input
    {
        std::uint32_t lo;
        std::uint32_t hi;
    };
    struct Output
    {
        std::uint32_t packed_bits;
    };

    __device__ static Output device(const Input& in)
    {
        const v2u16 packed = __builtin_amdgcn_cvt_pk_u16(in.lo, in.hi);
        return {__builtin_bit_cast(std::uint32_t, packed)};
    }

    static Output oracle(const Input& in)
    {
        return {int_isa_test::cvt_pk_u16_pair(in.lo, in.hi)};
    }

    static void expect(const Output& actual, const Output& expected, std::size_t case_index)
    {
        int_isa_test::expect_equal(
            "cvt_pk_u16_bits", actual.packed_bits, expected.packed_bits, case_index);
    }
};

struct FloatPackInput
{
    float         lo;
    float         hi;
    float         u8_value;
    std::uint32_t u8_select;
    std::uint32_t u8_src;
};

struct FloatPackTrait
{
    using Input = FloatPackInput;
    struct Output
    {
        std::uint32_t pknorm_i16_bits;
        std::uint32_t pknorm_u16_bits;
        std::uint32_t pk_u8_bits;
    };

    __device__ static Output device(const Input& in)
    {
        const v2i16 pki16 = __builtin_amdgcn_cvt_pknorm_i16(in.lo, in.hi);
        const v2u16 pku16 = __builtin_amdgcn_cvt_pknorm_u16(in.lo, in.hi);
        return {__builtin_bit_cast(std::uint32_t, pki16),
                __builtin_bit_cast(std::uint32_t, pku16),
                __builtin_amdgcn_cvt_pk_u8_f32(in.u8_value, in.u8_select, in.u8_src)};
    }

    static Output oracle(const Input& in)
    {
        return {int_isa_test::cvt_pknorm_i16_pair(in.lo, in.hi),
                int_isa_test::cvt_pknorm_u16_pair(in.lo, in.hi),
                int_isa_test::cvt_pk_u8_f32(in.u8_value, in.u8_select, in.u8_src)};
    }

    static void expect(const Output& actual, const Output& expected, std::size_t case_index)
    {
        int_isa_test::expect_equal(
            "cvt_pknorm_i16_bits", actual.pknorm_i16_bits, expected.pknorm_i16_bits, case_index);
        int_isa_test::expect_equal(
            "cvt_pknorm_u16_bits", actual.pknorm_u16_bits, expected.pknorm_u16_bits, case_index);
        int_isa_test::expect_equal(
            "cvt_pk_u8_f32_bits", actual.pk_u8_bits, expected.pk_u8_bits, case_index);
    }
};

std::vector<CvtPkI16Trait::Input> cvt_i16_inputs()
{
    return {{0, 1},
            {-1, 1},
            {-32768, 32767},
            {-12345, 23456},
            {0x1234, -0x1234},
            {0x00010000, -32769},
            {static_cast<std::int32_t>(0x80008000u), static_cast<std::int32_t>(0xffffffffu)}};
}

std::vector<CvtPkU16Trait::Input> cvt_u16_inputs()
{
    return {{0u, 1u},
            {0xffffu, 0u},
            {0x8000u, 0x7fffu},
            {0x1234u, 0xabcdu},
            {0x00010000u, 0xffffffffu},
            {0x80008000u, 32768u},
            {static_cast<std::uint32_t>(-32769), 0x0000ffffu}};
}

std::vector<FloatPackInput> float_pack_inputs()
{
    return {{0.0f, 1.0f, 0.0f, 0u, 0x11223344u},
            {0.25f, 0.5f, 1.0f, 1u, 0x11223344u},
            {-0.25f, 0.25f, 127.0f, 2u, 0xaabbccddu},
            {-0.5f, 0.5f, 255.0f, 3u, 0x01020304u},
            {0.5f, 0.25f, -1.0f, 0u, 0xffffffffu},
            {-0.25f, -0.5f, 260.0f, 3u, 0x00000000u}};
}
} // namespace

TEST(Rdna4IntIsaPackedConvert, CvtPkI16MatchesOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_value_test_cases<CvtPkI16Trait>(cvt_i16_inputs());
}

TEST(Rdna4IntIsaPackedConvert, CvtPkU16MatchesOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_value_test_cases<CvtPkU16Trait>(cvt_u16_inputs());
}

TEST(Rdna4IntIsaPackedConvert, FloatToIntegerBuiltinsMatchOracles)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_value_test_cases<FloatPackTrait>(float_pack_inputs());
}
