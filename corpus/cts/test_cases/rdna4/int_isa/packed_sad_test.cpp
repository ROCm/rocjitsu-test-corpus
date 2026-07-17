// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "int_isa_test_utils.hpp"
#include "value_test_harness.hpp"

#include <cstdint>
#include <vector>

namespace
{
using u32x4 = unsigned int __attribute__((ext_vector_type(4)));

struct SadInput
{
    std::uint32_t sad_a;
    std::uint32_t sad_b;
    std::uint32_t sad_accum;
    std::uint64_t qsad_a;
    std::uint32_t qsad_b;
    std::uint64_t qsad_accum16;
    std::uint32_t mqsad_accum0;
    std::uint32_t mqsad_accum1;
    std::uint32_t mqsad_accum2;
    std::uint32_t mqsad_accum3;
};

struct SadOutput
{
    std::uint32_t sad_u8;
    std::uint32_t sad_hi_u8;
    std::uint32_t sad_u16;
    std::uint32_t msad_u8;
    std::uint64_t qsad_pk_u16_u8;
    std::uint64_t mqsad_pk_u16_u8;
    std::uint32_t mqsad_u32_u8[4];
};

struct SadTrait
{
    using Input  = SadInput;
    using Output = SadOutput;

    // The physical carriers are u32/u64 while the semantic lanes are u8/u16.
    __device__ static Output device(const Input& in)
    {
        Output out{};
        out.sad_u8    = __builtin_amdgcn_sad_u8(in.sad_a, in.sad_b, in.sad_accum);
        out.sad_hi_u8 = __builtin_amdgcn_sad_hi_u8(in.sad_a, in.sad_b, in.sad_accum);
        out.sad_u16   = __builtin_amdgcn_sad_u16(in.sad_a, in.sad_b, in.sad_accum);
        out.msad_u8   = __builtin_amdgcn_msad_u8(in.sad_a, in.sad_b, in.sad_accum);
        out.qsad_pk_u16_u8 =
            __builtin_amdgcn_qsad_pk_u16_u8(in.qsad_a, in.qsad_b, in.qsad_accum16);
        out.mqsad_pk_u16_u8 =
            __builtin_amdgcn_mqsad_pk_u16_u8(in.qsad_a, in.qsad_b, in.qsad_accum16);

        const u32x4 accum = {in.mqsad_accum0, in.mqsad_accum1, in.mqsad_accum2,
                             in.mqsad_accum3};
        const u32x4 mqsad = __builtin_amdgcn_mqsad_u32_u8(in.qsad_a, in.qsad_b, accum);
        out.mqsad_u32_u8[0] = mqsad[0];
        out.mqsad_u32_u8[1] = mqsad[1];
        out.mqsad_u32_u8[2] = mqsad[2];
        out.mqsad_u32_u8[3] = mqsad[3];
        return out;
    }

    static Output oracle(const Input& in)
    {
        Output out{};
        out.sad_u8    = int_isa_test::sad_u8_sum(in.sad_a, in.sad_b) + in.sad_accum;
        out.sad_hi_u8 = (int_isa_test::sad_u8_sum(in.sad_a, in.sad_b) << 16) + in.sad_accum;
        out.sad_u16   = int_isa_test::sad_u16_sum(in.sad_a, in.sad_b) + in.sad_accum;
        out.msad_u8   = int_isa_test::msad_u8_sum(in.sad_a, in.sad_b) + in.sad_accum;
        out.qsad_pk_u16_u8 =
            int_isa_test::qsad_pk_u16_u8(in.qsad_a, in.qsad_b, in.qsad_accum16);
        out.mqsad_pk_u16_u8 =
            int_isa_test::mqsad_pk_u16_u8(in.qsad_a, in.qsad_b, in.qsad_accum16);
        out.mqsad_u32_u8[0] =
            int_isa_test::mqsad_u8_window_sum(in.qsad_a, in.qsad_b, 0) + in.mqsad_accum0;
        out.mqsad_u32_u8[1] =
            int_isa_test::mqsad_u8_window_sum(in.qsad_a, in.qsad_b, 1) + in.mqsad_accum1;
        out.mqsad_u32_u8[2] =
            int_isa_test::mqsad_u8_window_sum(in.qsad_a, in.qsad_b, 2) + in.mqsad_accum2;
        out.mqsad_u32_u8[3] =
            int_isa_test::mqsad_u8_window_sum(in.qsad_a, in.qsad_b, 3) + in.mqsad_accum3;
        return out;
    }

    static void expect(const Output& actual, const Output& expected, std::size_t case_index)
    {
        int_isa_test::expect_equal("sad_u8", actual.sad_u8, expected.sad_u8, case_index);
        int_isa_test::expect_equal("sad_hi_u8", actual.sad_hi_u8, expected.sad_hi_u8, case_index);
        int_isa_test::expect_equal("sad_u16", actual.sad_u16, expected.sad_u16, case_index);
        int_isa_test::expect_equal("msad_u8", actual.msad_u8, expected.msad_u8, case_index);
        int_isa_test::expect_equal(
            "qsad_pk_u16_u8", actual.qsad_pk_u16_u8, expected.qsad_pk_u16_u8, case_index);
        int_isa_test::expect_equal(
            "mqsad_pk_u16_u8", actual.mqsad_pk_u16_u8, expected.mqsad_pk_u16_u8, case_index);
        int_isa_test::expect_equal(
            "mqsad_u32_u8[0]", actual.mqsad_u32_u8[0], expected.mqsad_u32_u8[0], case_index);
        int_isa_test::expect_equal(
            "mqsad_u32_u8[1]", actual.mqsad_u32_u8[1], expected.mqsad_u32_u8[1], case_index);
        int_isa_test::expect_equal(
            "mqsad_u32_u8[2]", actual.mqsad_u32_u8[2], expected.mqsad_u32_u8[2], case_index);
        int_isa_test::expect_equal(
            "mqsad_u32_u8[3]", actual.mqsad_u32_u8[3], expected.mqsad_u32_u8[3], case_index);
    }
};

std::vector<SadInput> sad_inputs()
{
    return {
        {0x00010203u, 0x03020100u, 7u, 0x0706050403020100ull, 0x03020100u,
         0x0004000300020001ull, 11u, 13u, 17u, 19u},
        {0xff00aa55u, 0x0010aa00u, 0xfffffff0u, 0x8877665544332211ull, 0x00004422u,
         0xfffefffdf00f0001ull, 0xffffff00u, 0xffffff10u, 0xffffff20u, 0xffffff30u},
        {0x12345678u, 0x87654321u, 0x1000u, 0x0101010101010101ull, 0x01000100u,
         0x1000200030004000ull, 0u, 1u, 2u, 3u},
        {0x7fff8000u, 0x80007fffu, 0x80000000u, 0xff00ee11dd22cc33ull, 0x11220033u,
         0x0000000100020003ull, 0x80000000u, 0x7fffffffu, 0x12345678u, 0x9abcdef0u},
        {0x0f0e0d0cu, 0x01020304u, 0x55aa55aau, 0x0010203040506070ull, 0x10203040u,
         0xaaaa55550000ffffull, 5u, 8u, 13u, 21u},
        {0x0000ffffu, 0xffff0000u, 0u, 0xfedcba9876543210ull, 0x08060402u,
         0x7fff800100020003ull, 0xffff0001u, 0x0000ffffu, 0x13579bdfu, 0x2468ace0u},
        {0x11223344u, 0x00003300u, 0x1234u, 0x0123456789abcdefull, 0x00ff0080u,
         0x0011002200330044ull, 0x101u, 0x202u, 0x303u, 0x404u},
        {0xffffffffu, 0x01010101u, 1u, 0x0f1e2d3c4b5a6978ull, 0x00000000u,
         0xffffeeee11112222ull, 0u, 0x10000u, 0x20000u, 0x30000u},
    };
}
} // namespace

TEST(Rdna4IntIsaPackedSad, UnsignedPackedSadStyleBuiltinsMatchOracles)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_value_test_cases<SadTrait>(sad_inputs());
}
