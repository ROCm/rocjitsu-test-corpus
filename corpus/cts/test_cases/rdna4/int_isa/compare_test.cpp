// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "wave_test_harness.hpp"

#include <cstdint>

namespace
{
// AMDGCN compare builtins take LLVM ICmp predicate enum values.
constexpr int kIcmpEq  = 32;
constexpr int kIcmpUge = 35;
constexpr int kIcmpUlt = 36;
constexpr int kIcmpSge = 39;
constexpr int kIcmpSlt = 40;

constexpr std::uint32_t u32_value(unsigned lane)
{
    return lane + 1;
}

constexpr std::int32_t i32_value(unsigned lane)
{
    return static_cast<std::int32_t>(lane) - 16;
}

constexpr std::uint64_t u64_value(unsigned lane)
{
    return (static_cast<std::uint64_t>(lane) + 1ull) * 1000003ull;
}

template <class Trait>
std::uint64_t expected_mask()
{
    std::uint64_t mask = 0;
    for(unsigned lane = 0; lane < int_isa_test::kWaveLanes; ++lane)
        if(Trait::predicate(lane))
            mask |= 1ull << lane;
    return mask;
}

template <class Trait>
struct CompareTraitBase
{
    struct Output
    {
        std::uint64_t mask;
    };

    static Output oracle()
    {
        return {expected_mask<Trait>()};
    }

    static void expect(const Output& actual, const Output& expected)
    {
        EXPECT_EQ(actual.mask, expected.mask);
    }
};

struct U32EqCompare : CompareTraitBase<U32EqCompare>
{
    __device__ static Output device(unsigned lane)
    {
        return {__builtin_amdgcn_uicmp(lane % 7u, 3u, kIcmpEq)};
    }

    static bool predicate(unsigned lane)
    {
        return lane % 7u == 3u;
    }
};

struct U32UltCompare : CompareTraitBase<U32UltCompare>
{
    __device__ static Output device(unsigned lane)
    {
        return {__builtin_amdgcn_uicmp(u32_value(lane) * 3u, 50u, kIcmpUlt)};
    }

    static bool predicate(unsigned lane)
    {
        return u32_value(lane) * 3u < 50u;
    }
};

struct I32SltCompare : CompareTraitBase<I32SltCompare>
{
    __device__ static Output device(unsigned lane)
    {
        return {__builtin_amdgcn_sicmp(i32_value(lane), -3, kIcmpSlt)};
    }

    static bool predicate(unsigned lane)
    {
        return i32_value(lane) < -3;
    }
};

struct U64UgeCompare : CompareTraitBase<U64UgeCompare>
{
    __device__ static Output device(unsigned lane)
    {
        return {__builtin_amdgcn_uicmpl(u64_value(lane), 20000060ull, kIcmpUge)};
    }

    static bool predicate(unsigned lane)
    {
        return u64_value(lane) >= 20000060ull;
    }
};

struct I64SgeCompare : CompareTraitBase<I64SgeCompare>
{
    __device__ static Output device(unsigned lane)
    {
        return {__builtin_amdgcn_sicmpl(static_cast<std::int64_t>(lane) - 12, 0, kIcmpSge)};
    }

    static bool predicate(unsigned lane)
    {
        return static_cast<std::int64_t>(lane) - 12 >= 0;
    }
};
} // namespace

TEST(Rdna4IntIsaCompare, U32BuiltinsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_uniform_test<U32EqCompare>();
    int_isa_test::run_wave_uniform_test<U32UltCompare>();
}

TEST(Rdna4IntIsaCompare, I32BuiltinsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_uniform_test<I32SltCompare>();
}

TEST(Rdna4IntIsaCompare, U64BuiltinsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_uniform_test<U64UgeCompare>();
}

TEST(Rdna4IntIsaCompare, I64BuiltinsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    int_isa_test::run_wave_uniform_test<I64SgeCompare>();
}
