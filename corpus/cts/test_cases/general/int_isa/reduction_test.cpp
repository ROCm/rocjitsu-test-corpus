// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "wave_test_harness.hpp"

#include <cstdint>
#include <limits>

namespace
{
constexpr std::uint32_t add_u32_value(unsigned lane)
{
    return lane + 1;
}

constexpr std::int32_t add_i32_value(unsigned lane)
{
    return static_cast<std::int32_t>(lane) - 16;
}

constexpr std::uint32_t unordered_u32_value(unsigned lane)
{
    return ((lane * 17u) ^ 0x5au) & 0xffu;
}

constexpr std::int32_t ordered_i32_value(unsigned lane)
{
    return static_cast<std::int32_t>(lane) - 16;
}

constexpr std::uint32_t bitwise_u32_value(unsigned lane)
{
    return 0xffff0000u | ((lane * 37u) & 0xffffu);
}

constexpr std::uint64_t add_u64_value(unsigned lane)
{
    return (static_cast<std::uint64_t>(lane) + 1ull) * 1000003ull;
}

constexpr std::uint64_t unordered_u64_value(unsigned lane)
{
    return (static_cast<std::uint64_t>(lane) * 0x100000001ull) ^ 0x5a5a5a5a12345678ull;
}

constexpr std::int64_t ordered_i64_value(unsigned lane)
{
    const std::int64_t base = static_cast<std::int64_t>(lane) * 1000000003ll + 17;
    return (lane % 3u) == 0 ? -base : base - 12000000000ll;
}

struct U32ReductionTrait
{
    struct Output
    {
        std::uint32_t add_s0;
        std::uint32_t add_s2;
        std::uint32_t sub_s0;
        std::uint32_t sub_s2;
        std::uint32_t min;
        std::uint32_t max;
        std::uint32_t bit_and;
        std::uint32_t bit_or;
        std::uint32_t bit_xor;
    };

    __device__ static Output device(unsigned lane)
    {
        const std::uint32_t add     = add_u32_value(lane);
        const std::uint32_t ordered = unordered_u32_value(lane);
        const std::uint32_t bits    = bitwise_u32_value(lane);
        return {__builtin_amdgcn_wave_reduce_add_u32(add, 0),
                __builtin_amdgcn_wave_reduce_add_u32(add, 2),
                __builtin_amdgcn_wave_reduce_sub_u32(add, 0),
                __builtin_amdgcn_wave_reduce_sub_u32(add, 2),
                __builtin_amdgcn_wave_reduce_min_u32(ordered, 0),
                __builtin_amdgcn_wave_reduce_max_u32(ordered, 0),
                static_cast<std::uint32_t>(
                    __builtin_amdgcn_wave_reduce_and_b32(static_cast<std::int32_t>(bits), 0)),
                static_cast<std::uint32_t>(
                    __builtin_amdgcn_wave_reduce_or_b32(static_cast<std::int32_t>(bits), 0)),
                static_cast<std::uint32_t>(
                    __builtin_amdgcn_wave_reduce_xor_b32(static_cast<std::int32_t>(bits), 0))};
    }

    static Output oracle()
    {
        Output out{0u,
                   0u,
                   0u,
                   0u,
                   std::numeric_limits<std::uint32_t>::max(),
                   0u,
                   0xffffffffu,
                   0u,
                   0u};
        for(unsigned lane = 0; lane < int_isa_test::kWaveLanes; ++lane)
        {
            const std::uint32_t add     = add_u32_value(lane);
            const std::uint32_t ordered = unordered_u32_value(lane);
            const std::uint32_t bits    = bitwise_u32_value(lane);
            out.add_s0 += add;
            out.add_s2 += add;
            out.sub_s0 -= add;
            out.sub_s2 -= add;
            out.min = ordered < out.min ? ordered : out.min;
            out.max = ordered > out.max ? ordered : out.max;
            out.bit_and &= bits;
            out.bit_or |= bits;
            out.bit_xor ^= bits;
        }
        return out;
    }

    static void expect(const Output& actual, const Output& expected)
    {
        EXPECT_EQ(actual.add_s0, expected.add_s0);
        EXPECT_EQ(actual.add_s2, expected.add_s2);
        EXPECT_EQ(actual.sub_s0, expected.sub_s0);
        EXPECT_EQ(actual.sub_s2, expected.sub_s2);
        EXPECT_EQ(actual.min, expected.min);
        EXPECT_EQ(actual.max, expected.max);
        EXPECT_EQ(actual.bit_and, expected.bit_and);
        EXPECT_EQ(actual.bit_or, expected.bit_or);
        EXPECT_EQ(actual.bit_xor, expected.bit_xor);
    }
};

struct I32ReductionTrait
{
    struct Output
    {
        std::uint32_t add_bits;
        std::int32_t  min;
        std::int32_t  max;
    };

    __device__ static Output device(unsigned lane)
    {
        const std::int32_t add     = add_i32_value(lane);
        const std::int32_t ordered = ordered_i32_value(lane);
        return {__builtin_amdgcn_wave_reduce_add_u32(static_cast<std::uint32_t>(add), 0),
                __builtin_amdgcn_wave_reduce_min_i32(ordered, 0),
                __builtin_amdgcn_wave_reduce_max_i32(ordered, 0)};
    }

    static Output oracle()
    {
        Output out{0u, std::numeric_limits<std::int32_t>::max(),
                   std::numeric_limits<std::int32_t>::min()};
        for(unsigned lane = 0; lane < int_isa_test::kWaveLanes; ++lane)
        {
            const std::int32_t add     = add_i32_value(lane);
            const std::int32_t ordered = ordered_i32_value(lane);
            out.add_bits += static_cast<std::uint32_t>(add);
            out.min = ordered < out.min ? ordered : out.min;
            out.max = ordered > out.max ? ordered : out.max;
        }
        return out;
    }

    static void expect(const Output& actual, const Output& expected)
    {
        EXPECT_EQ(actual.add_bits, expected.add_bits);
        EXPECT_EQ(actual.min, expected.min);
        EXPECT_EQ(actual.max, expected.max);
    }
};

struct U64ReductionTrait
{
    struct Output
    {
        std::uint64_t add;
        std::uint64_t sub;
        std::uint64_t min;
        std::uint64_t max;
        std::uint64_t bit_and;
        std::uint64_t bit_or;
        std::uint64_t bit_xor;
    };

    __device__ static Output device(unsigned lane)
    {
        const std::uint64_t add     = add_u64_value(lane);
        const std::uint64_t ordered = unordered_u64_value(lane);
        return {__builtin_amdgcn_wave_reduce_add_u64(add, 0),
                __builtin_amdgcn_wave_reduce_sub_u64(add, 0),
                __builtin_amdgcn_wave_reduce_min_u64(ordered, 0),
                __builtin_amdgcn_wave_reduce_max_u64(ordered, 0),
                static_cast<std::uint64_t>(
                    __builtin_amdgcn_wave_reduce_and_b64(static_cast<std::int64_t>(ordered), 0)),
                static_cast<std::uint64_t>(
                    __builtin_amdgcn_wave_reduce_or_b64(static_cast<std::int64_t>(ordered), 0)),
                static_cast<std::uint64_t>(
                    __builtin_amdgcn_wave_reduce_xor_b64(static_cast<std::int64_t>(ordered), 0))};
    }

    static Output oracle()
    {
        Output out{0ull,
                   0ull,
                   std::numeric_limits<std::uint64_t>::max(),
                   0ull,
                   0xffffffffffffffffull,
                   0ull,
                   0ull};
        for(unsigned lane = 0; lane < int_isa_test::kWaveLanes; ++lane)
        {
            const std::uint64_t add     = add_u64_value(lane);
            const std::uint64_t ordered = unordered_u64_value(lane);
            out.add += add;
            out.sub -= add;
            out.min = ordered < out.min ? ordered : out.min;
            out.max = ordered > out.max ? ordered : out.max;
            out.bit_and &= ordered;
            out.bit_or |= ordered;
            out.bit_xor ^= ordered;
        }
        return out;
    }

    static void expect(const Output& actual, const Output& expected)
    {
        EXPECT_EQ(actual.add, expected.add);
        EXPECT_EQ(actual.sub, expected.sub);
        EXPECT_EQ(actual.min, expected.min);
        EXPECT_EQ(actual.max, expected.max);
        EXPECT_EQ(actual.bit_and, expected.bit_and);
        EXPECT_EQ(actual.bit_or, expected.bit_or);
        EXPECT_EQ(actual.bit_xor, expected.bit_xor);
    }
};

struct I64ReductionTrait
{
    struct Output
    {
        std::int64_t min;
        std::int64_t max;
    };

    __device__ static Output device(unsigned lane)
    {
        const std::int64_t ordered = ordered_i64_value(lane);
        return {__builtin_amdgcn_wave_reduce_min_i64(ordered, 0),
                __builtin_amdgcn_wave_reduce_max_i64(ordered, 0)};
    }

    static Output oracle()
    {
        Output out{std::numeric_limits<std::int64_t>::max(),
                   std::numeric_limits<std::int64_t>::min()};
        for(unsigned lane = 0; lane < int_isa_test::kWaveLanes; ++lane)
        {
            const std::int64_t ordered = ordered_i64_value(lane);
            out.min = ordered < out.min ? ordered : out.min;
            out.max = ordered > out.max ? ordered : out.max;
        }
        return out;
    }

    static void expect(const Output& actual, const Output& expected)
    {
        EXPECT_EQ(actual.min, expected.min);
        EXPECT_EQ(actual.max, expected.max);
    }
};
} // namespace

TEST(IntIsaReduction, U32BuiltinsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_uniform_test<U32ReductionTrait>();
}

TEST(IntIsaReduction, I32BuiltinsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_uniform_test<I32ReductionTrait>();
}

TEST(IntIsaReduction, U64BuiltinsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_uniform_test<U64ReductionTrait>();
}

TEST(IntIsaReduction, I64BuiltinsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_uniform_test<I64ReductionTrait>();
}
