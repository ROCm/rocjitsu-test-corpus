// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "hip_test_utils.hpp"
#include "int_isa_test_utils.hpp"

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include <cstddef>
#include <cstdint>
#include <iostream>
#include <vector>

namespace
{
using u32x4 = unsigned int __attribute__((ext_vector_type(4)));
using v2i16 = short __attribute__((ext_vector_type(2)));
using v2u16 = unsigned short __attribute__((ext_vector_type(2)));

template <class T>
void expect_equal(const char* name, T actual, T expected, std::size_t case_index)
{
    if(actual != expected)
    {
        std::cerr << "case " << case_index << " " << name << " actual=0x" << std::hex
                  << static_cast<unsigned long long>(actual) << " expected=0x"
                  << static_cast<unsigned long long>(expected) << std::dec << "\n";
    }
    EXPECT_EQ(actual, expected);
}

template <class Trait>
__global__ void trait_kernel(const typename Trait::Input* inputs,
                             typename Trait::Output*      outputs,
                             int                          count)
{
    const int i = blockIdx.x * blockDim.x + threadIdx.x;
    if(i < count)
        outputs[i] = Trait::device(inputs[i]);
}

template <class Trait>
void run_trait_cases(const std::vector<typename Trait::Input>& inputs)
{
    using Input  = typename Trait::Input;
    using Output = typename Trait::Output;

    const int count = static_cast<int>(inputs.size());
    Input*    d_inputs  = nullptr;
    Output*   d_outputs = nullptr;
    HIP_CHECK(hipMalloc(&d_inputs, inputs.size() * sizeof(Input)));
    HIP_CHECK(hipMalloc(&d_outputs, inputs.size() * sizeof(Output)));
    HIP_CHECK(
        hipMemcpy(d_inputs, inputs.data(), inputs.size() * sizeof(Input), hipMemcpyHostToDevice));

    trait_kernel<Trait><<<dim3(1), dim3(64)>>>(d_inputs, d_outputs, count);
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());

    std::vector<Output> actual(inputs.size());
    HIP_CHECK(
        hipMemcpy(actual.data(), d_outputs, actual.size() * sizeof(Output), hipMemcpyDeviceToHost));

    for(std::size_t i = 0; i < inputs.size(); ++i)
        Trait::expect(actual[i], Trait::oracle(inputs[i]), i);

    HIP_CHECK(hipFree(d_inputs));
    HIP_CHECK(hipFree(d_outputs));
}

struct SadInput
{
    std::uint32_t lerp_a;
    std::uint32_t lerp_b;
    std::uint32_t lerp_rounding;
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
    std::uint32_t lerp_u8;
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

    // Unsigned packed-byte and packed-halfword instructions. The physical
    // carrier is u32/u64, while the semantic lanes are u8 or u16.
    __device__ static Output device(const Input& in)
    {
        Output out{};
        out.lerp_u8   = __builtin_amdgcn_lerp(in.lerp_a, in.lerp_b, in.lerp_rounding);
        out.sad_u8    = __builtin_amdgcn_sad_u8(in.sad_a, in.sad_b, in.sad_accum);
        out.sad_hi_u8 = __builtin_amdgcn_sad_hi_u8(in.sad_a, in.sad_b, in.sad_accum);
        out.sad_u16   = __builtin_amdgcn_sad_u16(in.sad_a, in.sad_b, in.sad_accum);
        out.msad_u8   = __builtin_amdgcn_msad_u8(in.sad_a, in.sad_b, in.sad_accum);
        out.qsad_pk_u16_u8 =
            __builtin_amdgcn_qsad_pk_u16_u8(in.qsad_a, in.qsad_b, in.qsad_accum16);
        out.mqsad_pk_u16_u8 =
            __builtin_amdgcn_mqsad_pk_u16_u8(in.qsad_a, in.qsad_b, in.qsad_accum16);

        const u32x4 mqsad_accum = {in.mqsad_accum0, in.mqsad_accum1, in.mqsad_accum2,
                                   in.mqsad_accum3};
        const u32x4 mqsad =
            __builtin_amdgcn_mqsad_u32_u8(in.qsad_a, in.qsad_b, mqsad_accum);
        out.mqsad_u32_u8[0] = mqsad[0];
        out.mqsad_u32_u8[1] = mqsad[1];
        out.mqsad_u32_u8[2] = mqsad[2];
        out.mqsad_u32_u8[3] = mqsad[3];
        return out;
    }

    static Output oracle(const Input& in)
    {
        Output out{};
        out.lerp_u8   = int_isa_test::lerp_u8(in.lerp_a, in.lerp_b, in.lerp_rounding);
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
        expect_equal("lerp_u8", actual.lerp_u8, expected.lerp_u8, case_index);
        expect_equal("sad_u8", actual.sad_u8, expected.sad_u8, case_index);
        expect_equal("sad_hi_u8", actual.sad_hi_u8, expected.sad_hi_u8, case_index);
        expect_equal("sad_u16", actual.sad_u16, expected.sad_u16, case_index);
        expect_equal("msad_u8", actual.msad_u8, expected.msad_u8, case_index);
        expect_equal(
            "qsad_pk_u16_u8", actual.qsad_pk_u16_u8, expected.qsad_pk_u16_u8, case_index);
        expect_equal("mqsad_pk_u16_u8",
                     actual.mqsad_pk_u16_u8,
                     expected.mqsad_pk_u16_u8,
                     case_index);
        expect_equal(
            "mqsad_u32_u8[0]", actual.mqsad_u32_u8[0], expected.mqsad_u32_u8[0], case_index);
        expect_equal(
            "mqsad_u32_u8[1]", actual.mqsad_u32_u8[1], expected.mqsad_u32_u8[1], case_index);
        expect_equal(
            "mqsad_u32_u8[2]", actual.mqsad_u32_u8[2], expected.mqsad_u32_u8[2], case_index);
        expect_equal(
            "mqsad_u32_u8[3]", actual.mqsad_u32_u8[3], expected.mqsad_u32_u8[3], case_index);
    }
};

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

    // These VOP3 byte/bit rearrangement instructions are easy to accidentally
    // test through compiler-generated shuffles. Calling the builtins directly
    // keeps the CTS assertion tied to the named ISA surface.
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
        expect_equal("alignbit", actual.alignbit, expected.alignbit, case_index);
        expect_equal("alignbyte", actual.alignbyte, expected.alignbyte, case_index);
        expect_equal("perm", actual.perm, expected.perm, case_index);
    }
};

std::vector<SadInput> sad_inputs()
{
    return {
        {0x00112233u, 0xffeeddccu, 0x01000100u, 0x00010203u, 0x03020100u, 7u,
         0x0706050403020100ull, 0x03020100u, 0x0004000300020001ull, 11u, 13u, 17u, 19u},
        {0x7f80fe01u, 0x801001ffu, 0x00010100u, 0xff00aa55u, 0x0010aa00u,
         0xfffffff0u, 0x8877665544332211ull, 0x00004422u, 0xfffefffdf00f0001ull,
         0xffffff00u, 0xffffff10u, 0xffffff20u, 0xffffff30u},
        {0x10203040u, 0x11213141u, 0xffffffffu, 0x12345678u, 0x87654321u, 0x1000u,
         0x0101010101010101ull, 0x01000100u, 0x1000200030004000ull, 0u, 1u, 2u, 3u},
        {0xffffffffu, 0x00000000u, 0x01010101u, 0x7fff8000u, 0x80007fffu, 0x80000000u,
         0xff00ee11dd22cc33ull, 0x11220033u, 0x0000000100020003ull, 0x80000000u,
         0x7fffffffu, 0x12345678u, 0x9abcdef0u},
        {0x01030507u, 0x02040608u, 0x00000000u, 0x0f0e0d0cu, 0x01020304u, 0x55aa55aau,
         0x0010203040506070ull, 0x10203040u, 0xaaaa55550000ffffull, 5u, 8u, 13u, 21u},
        {0x000102feu, 0xfffefd01u, 0x01000001u, 0x0000ffffu, 0xffff0000u, 0u,
         0xfedcba9876543210ull, 0x08060402u, 0x7fff800100020003ull, 0xffff0001u,
         0x0000ffffu, 0x13579bdfu, 0x2468ace0u},
        {0x89abcdefu, 0x76543210u, 0x10101010u, 0x11223344u, 0x00003300u, 0x1234u,
         0x0123456789abcdefull, 0x00ff0080u, 0x0011002200330044ull, 0x101u, 0x202u,
         0x303u, 0x404u},
        {0x80808080u, 0x7f7f7f7fu, 0x01000100u, 0xffffffffu, 0x01010101u, 1u,
         0x0f1e2d3c4b5a6978ull, 0x00000000u, 0xffffeeee11112222ull, 0u, 0x10000u,
         0x20000u, 0x30000u},
    };
}

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

struct DotUnsignedInput
{
    std::uint32_t a;
    std::uint32_t b;
    std::uint32_t accum;
};

struct DotSignedInput
{
    std::uint32_t a;
    std::uint32_t b;
    std::int32_t  accum;
};

template <bool Clamp> struct DotU8Trait
{
    using Input = DotUnsignedInput;
    struct Output
    {
        std::uint32_t result;
    };

    __device__ static Output device(const Input& in)
    {
        return {static_cast<std::uint32_t>(__builtin_amdgcn_udot4(in.a, in.b, in.accum, Clamp))};
    }

    static Output oracle(const Input& in)
    {
        return {int_isa_test::dot_u8x4(in.a, in.b, in.accum, Clamp)};
    }

    static void expect(const Output& actual, const Output& expected, std::size_t case_index)
    {
        expect_equal("udot4_result", actual.result, expected.result, case_index);
    }
};

template <bool ASigned, bool BSigned, bool Clamp> struct DotIu8Trait
{
    using Input = DotSignedInput;
    struct Output
    {
        std::uint32_t result_bits;
    };

    __device__ static Output device(const Input& in)
    {
        return {static_cast<std::uint32_t>(
            __builtin_amdgcn_sudot4(ASigned, in.a, BSigned, in.b, in.accum, Clamp))};
    }

    static Output oracle(const Input& in)
    {
        return {int_isa_test::dot_iu8x4_bits(in.a, ASigned, in.b, BSigned, in.accum, Clamp)};
    }

    static void expect(const Output& actual, const Output& expected, std::size_t case_index)
    {
        expect_equal("sudot4_result_bits", actual.result_bits, expected.result_bits, case_index);
    }
};

template <bool Clamp> struct DotU4Trait
{
    using Input = DotUnsignedInput;
    struct Output
    {
        std::uint32_t result;
    };

    __device__ static Output device(const Input& in)
    {
        return {static_cast<std::uint32_t>(__builtin_amdgcn_udot8(in.a, in.b, in.accum, Clamp))};
    }

    static Output oracle(const Input& in)
    {
        return {int_isa_test::dot_u4x8(in.a, in.b, in.accum, Clamp)};
    }

    static void expect(const Output& actual, const Output& expected, std::size_t case_index)
    {
        expect_equal("udot8_result", actual.result, expected.result, case_index);
    }
};

template <bool ASigned, bool BSigned, bool Clamp> struct DotIu4Trait
{
    using Input = DotSignedInput;
    struct Output
    {
        std::uint32_t result_bits;
    };

    __device__ static Output device(const Input& in)
    {
        return {static_cast<std::uint32_t>(
            __builtin_amdgcn_sudot8(ASigned, in.a, BSigned, in.b, in.accum, Clamp))};
    }

    static Output oracle(const Input& in)
    {
        return {int_isa_test::dot_iu4x8_bits(in.a, ASigned, in.b, BSigned, in.accum, Clamp)};
    }

    static void expect(const Output& actual, const Output& expected, std::size_t case_index)
    {
        expect_equal("sudot8_result_bits", actual.result_bits, expected.result_bits, case_index);
    }
};

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
        expect_equal("cvt_pk_i16_bits", actual.packed_bits, expected.packed_bits, case_index);
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
        expect_equal("cvt_pk_u16_bits", actual.packed_bits, expected.packed_bits, case_index);
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
        expect_equal(
            "cvt_pknorm_i16_bits", actual.pknorm_i16_bits, expected.pknorm_i16_bits, case_index);
        expect_equal(
            "cvt_pknorm_u16_bits", actual.pknorm_u16_bits, expected.pknorm_u16_bits, case_index);
        expect_equal("cvt_pk_u8_f32_bits", actual.pk_u8_bits, expected.pk_u8_bits, case_index);
    }
};

std::vector<DotUnsignedInput> dot_u8_inputs()
{
    return {{0x00010203u, 0x04050607u, 0u},
            {0xff00aa55u, 0x0010aa00u, 17u},
            {0xffffffffu, 0x01010101u, 0xffff0000u},
            {0x800000ffu, 0x02030405u, 0x7ffffff0u},
            {0xffffffffu, 0xffffffffu, 0xfffffff0u}};
}

std::vector<DotSignedInput> dot_iu8_inputs()
{
    return {{0x00010203u, 0x04050607u, 0},
            {0xff00aa55u, 0x0010aa00u, -19},
            {0x807f01ffu, 0x7f80ff01u, 12345},
            {0xffffffffu, 0x01010101u, -7},
            {0x80808080u, 0x80808080u, 2147483500},
            {0x80808080u, 0xffffffffu, -2147483500}};
}

std::vector<DotUnsignedInput> dot_u4_inputs()
{
    return {{0x01234567u, 0x76543210u, 0u},
            {0xffffffffu, 0x11111111u, 123u},
            {0x89abcdefu, 0xfedcba98u, 0x7ffffff0u},
            {0xffffffffu, 0xffffffffu, 0xfffffff0u}};
}

std::vector<DotSignedInput> dot_iu4_inputs()
{
    return {{0x01234567u, 0x76543210u, 0},
            {0x89abcdefu, 0xfedcba98u, -17},
            {0x88888888u, 0x88888888u, 2147483500},
            {0x88888888u, 0x77777777u, -2147483500},
            {0xffffffffu, 0x11111111u, 321}};
}

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

TEST(Rdna4IntIsaPackedValu, UnsignedPackedSadStyleBuiltinsMatchOracles)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_trait_cases<SadTrait>(sad_inputs());
}

TEST(Rdna4IntIsaPackedValu, BitPermuteBuiltinsMatchOracles)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_trait_cases<BitPermuteTrait>(bit_permute_inputs());
}

TEST(Rdna4IntIsaPackedValu, DotU8MatchesOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_trait_cases<DotU8Trait<false>>(dot_u8_inputs());
    run_trait_cases<DotU8Trait<true>>(dot_u8_inputs());
}

TEST(Rdna4IntIsaPackedValu, DotIu8SignModesMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_trait_cases<DotIu8Trait<true, true, false>>(dot_iu8_inputs());
    run_trait_cases<DotIu8Trait<true, false, false>>(dot_iu8_inputs());
    run_trait_cases<DotIu8Trait<false, true, false>>(dot_iu8_inputs());
    run_trait_cases<DotIu8Trait<false, false, false>>(dot_iu8_inputs());
}

TEST(Rdna4IntIsaPackedValu, DotIu8ClampModesMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_trait_cases<DotIu8Trait<true, true, true>>(dot_iu8_inputs());
    run_trait_cases<DotIu8Trait<true, false, true>>(dot_iu8_inputs());
    run_trait_cases<DotIu8Trait<false, true, true>>(dot_iu8_inputs());
    run_trait_cases<DotIu8Trait<false, false, true>>(dot_iu8_inputs());
}

TEST(Rdna4IntIsaPackedValu, DotU4MatchesOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_trait_cases<DotU4Trait<false>>(dot_u4_inputs());
    run_trait_cases<DotU4Trait<true>>(dot_u4_inputs());
}

TEST(Rdna4IntIsaPackedValu, DotIu4SignAndClampModesMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_trait_cases<DotIu4Trait<true, true, false>>(dot_iu4_inputs());
    run_trait_cases<DotIu4Trait<true, false, false>>(dot_iu4_inputs());
    run_trait_cases<DotIu4Trait<false, true, false>>(dot_iu4_inputs());
    run_trait_cases<DotIu4Trait<false, false, false>>(dot_iu4_inputs());
    run_trait_cases<DotIu4Trait<true, true, true>>(dot_iu4_inputs());
    run_trait_cases<DotIu4Trait<true, false, true>>(dot_iu4_inputs());
    run_trait_cases<DotIu4Trait<false, true, true>>(dot_iu4_inputs());
    run_trait_cases<DotIu4Trait<false, false, true>>(dot_iu4_inputs());
}

TEST(Rdna4IntIsaPackedValu, CvtPkI16MatchesOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_trait_cases<CvtPkI16Trait>(cvt_i16_inputs());
}

TEST(Rdna4IntIsaPackedValu, CvtPkU16MatchesOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_trait_cases<CvtPkU16Trait>(cvt_u16_inputs());
}

TEST(Rdna4IntIsaPackedValu, FloatToIntegerPackBuiltinsMatchOracles)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_trait_cases<FloatPackTrait>(float_pack_inputs());
}
