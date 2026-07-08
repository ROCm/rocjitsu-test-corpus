// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "hip_test_utils.hpp"
#include "int_isa_test_utils.hpp"

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include <cstdint>
#include <limits>
#include <vector>

namespace
{
#ifdef INT_ISA_TEST_WAVE64
constexpr int kWaveLanes = 64;
#else
constexpr int kWaveLanes = 32;
#endif

// AMDGCN compare builtins take LLVM ICmp predicate enum values.
constexpr int kIcmpEq  = 32;
constexpr int kIcmpUge = 35;
constexpr int kIcmpUlt = 36;
constexpr int kIcmpSge = 39;
constexpr int kIcmpSlt = 40;

// Lane-value generators are constexpr so the device kernels and host oracles use
// the same deterministic input sequence without sharing any GPU builtin logic.
constexpr std::int32_t readlane_value(unsigned lane)
{
    return 1000 + static_cast<std::int32_t>(lane) * 17;
}

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

constexpr std::uint32_t permlane_value(unsigned lane)
{
    return 0x9e370000u | ((lane * 0x21u + 0x13u) & 0xffffu);
}

constexpr std::uint32_t permlane_var_index(unsigned lane)
{
    return (lane & 15u) ^ 3u;
}

template <class Trait>
__global__ void wave_trait_kernel(typename Trait::Output* outputs)
{
    outputs[threadIdx.x] = Trait::device(threadIdx.x);
}

template <class Trait>
void run_wave_trait()
{
    using Output = typename Trait::Output;

    // These cases compile once per wavefront mode. The block size is the
    // semantic wave width, not just a scheduling choice, so host oracles see
    // the same lane set as the tested AMDGCN builtins.
    Output* d_outputs = nullptr;
    HIP_CHECK(hipMalloc(&d_outputs, kWaveLanes * sizeof(Output)));

    wave_trait_kernel<Trait><<<dim3(1), dim3(kWaveLanes)>>>(d_outputs);
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());

    std::vector<Output> actual(kWaveLanes);
    HIP_CHECK(
        hipMemcpy(actual.data(), d_outputs, actual.size() * sizeof(Output), hipMemcpyDeviceToHost));

    const Output expected = Trait::oracle();
    for(const Output& lane : actual)
        Trait::expect(lane, expected);

    HIP_CHECK(hipFree(d_outputs));
}

template <class Trait>
void run_wave_lane_trait()
{
    using Output = typename Trait::Output;

    Output* d_outputs = nullptr;
    HIP_CHECK(hipMalloc(&d_outputs, kWaveLanes * sizeof(Output)));

    wave_trait_kernel<Trait><<<dim3(1), dim3(kWaveLanes)>>>(d_outputs);
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());

    std::vector<Output> actual(kWaveLanes);
    HIP_CHECK(
        hipMemcpy(actual.data(), d_outputs, actual.size() * sizeof(Output), hipMemcpyDeviceToHost));

    for(unsigned lane = 0; lane < kWaveLanes; ++lane)
        Trait::expect(actual[lane], Trait::oracle(lane), lane);

    HIP_CHECK(hipFree(d_outputs));
}

template <class Trait> std::uint64_t ballot_mask()
{
    std::uint64_t mask = 0;
    for(unsigned lane = 0; lane < kWaveLanes; ++lane)
    {
        if(Trait::predicate(lane))
            mask |= 1ull << lane;
    }
    return mask;
}

struct LaneMoveTrait
{
    struct Output
    {
        std::uint32_t wavefront_size;
        std::int32_t  readfirstlane;
        std::int32_t  readlane7;
    };

    __device__ static Output device(unsigned lane)
    {
        const std::int32_t lane_value = readlane_value(lane);
        return {__builtin_amdgcn_wavefrontsize(),
                __builtin_amdgcn_readfirstlane(lane_value),
                __builtin_amdgcn_readlane(lane_value, 7)};
    }

    static Output oracle()
    {
        return {kWaveLanes, readlane_value(0), readlane_value(7)};
    }

    static void expect(const Output& actual, const Output& expected)
    {
        EXPECT_EQ(actual.wavefront_size, expected.wavefront_size);
        EXPECT_EQ(actual.readfirstlane, expected.readfirstlane);
        EXPECT_EQ(actual.readlane7, expected.readlane7);
    }
};

struct MbcntTrait
{
    struct Output
    {
        std::uint32_t lo_count;
        std::uint32_t hi_count;
    };

    __device__ static Output device(unsigned lane)
    {
        constexpr std::uint32_t kLoMask = 0xb6db6db6u;
        constexpr std::uint32_t kHiMask = 0x6db6db6du;
        const std::uint32_t     add     = 5u + (lane % 4u);
        const std::uint32_t     lo      = __builtin_amdgcn_mbcnt_lo(kLoMask, add);
        return {lo, __builtin_amdgcn_mbcnt_hi(kHiMask, lo)};
    }

    static Output oracle(unsigned lane)
    {
        constexpr std::uint32_t kLoMask = 0xb6db6db6u;
        constexpr std::uint32_t kHiMask = 0x6db6db6du;
        const std::uint32_t     add     = 5u + (lane % 4u);
        const std::uint32_t     lo      = int_isa_test::mbcnt_lo_u32(kLoMask, add, lane);
        return {lo, int_isa_test::mbcnt_hi_u32(kHiMask, lo, lane)};
    }

    static void expect(const Output& actual, const Output& expected, unsigned lane)
    {
        EXPECT_EQ(actual.lo_count, expected.lo_count) << "lane " << lane;
        EXPECT_EQ(actual.hi_count, expected.hi_count) << "lane " << lane;
    }
};

struct PermlaneVarTrait
{
    struct Output
    {
        std::uint32_t own_row;
        std::uint32_t other_row;
    };

    __device__ static Output device(unsigned lane)
    {
        const std::uint32_t src = permlane_value(lane);
        const std::uint32_t idx = permlane_var_index(lane);
        return {__builtin_amdgcn_permlane16_var(0xdeadbeefu, src, idx, false, false),
                __builtin_amdgcn_permlanex16_var(0xfeedfaceu, src, idx, false, false)};
    }

    static Output oracle(unsigned lane)
    {
        const unsigned idx        = permlane_var_index(lane);
        const unsigned own_lane   = (lane & ~15u) + idx;
        const unsigned other_lane = ((lane & ~15u) ^ 16u) + idx;
        return {permlane_value(own_lane), permlane_value(other_lane)};
    }

    static void expect(const Output& actual, const Output& expected, unsigned lane)
    {
        EXPECT_EQ(actual.own_row, expected.own_row) << "lane " << lane;
        EXPECT_EQ(actual.other_row, expected.other_row) << "lane " << lane;
    }
};

template <class Trait> struct CompareOutputTrait
{
    struct Output
    {
        std::uint64_t mask;
    };

    static Output oracle()
    {
        return {ballot_mask<Trait>()};
    }

    static void expect(const Output& actual, const Output& expected)
    {
        EXPECT_EQ(actual.mask, expected.mask);
    }
};

struct U32EqCompare : CompareOutputTrait<U32EqCompare>
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

struct U32UltCompare : CompareOutputTrait<U32UltCompare>
{
    __device__ static Output device(unsigned lane)
    {
        return {__builtin_amdgcn_uicmp(add_u32_value(lane) * 3u, 50u, kIcmpUlt)};
    }

    static bool predicate(unsigned lane)
    {
        return add_u32_value(lane) * 3u < 50u;
    }
};

struct I32SltCompare : CompareOutputTrait<I32SltCompare>
{
    __device__ static Output device(unsigned lane)
    {
        return {__builtin_amdgcn_sicmp(ordered_i32_value(lane), -3, kIcmpSlt)};
    }

    static bool predicate(unsigned lane)
    {
        return ordered_i32_value(lane) < -3;
    }
};

struct U64UgeCompare : CompareOutputTrait<U64UgeCompare>
{
    __device__ static Output device(unsigned lane)
    {
        return {__builtin_amdgcn_uicmpl(add_u64_value(lane), 20000060ull, kIcmpUge)};
    }

    static bool predicate(unsigned lane)
    {
        return add_u64_value(lane) >= 20000060ull;
    }
};

struct I64SgeCompare : CompareOutputTrait<I64SgeCompare>
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
        for(unsigned lane = 0; lane < kWaveLanes; ++lane)
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
        for(unsigned lane = 0; lane < kWaveLanes; ++lane)
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
        for(unsigned lane = 0; lane < kWaveLanes; ++lane)
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
        for(unsigned lane = 0; lane < kWaveLanes; ++lane)
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

TEST(Rdna4IntIsaWave, LaneMovesMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_wave_trait<LaneMoveTrait>();
}

TEST(Rdna4IntIsaWave, MbcntMatchesOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_wave_lane_trait<MbcntTrait>();
}

TEST(Rdna4IntIsaWave, PermlaneVarMatchesOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_wave_lane_trait<PermlaneVarTrait>();
}

TEST(Rdna4IntIsaWave, U32ComparesMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_wave_trait<U32EqCompare>();
    run_wave_trait<U32UltCompare>();
}

TEST(Rdna4IntIsaWave, I32ComparesMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_wave_trait<I32SltCompare>();
}

TEST(Rdna4IntIsaWave, U64ComparesMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_wave_trait<U64UgeCompare>();
}

TEST(Rdna4IntIsaWave, I64ComparesMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_wave_trait<I64SgeCompare>();
}

TEST(Rdna4IntIsaWave, U32ReductionsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_wave_trait<U32ReductionTrait>();
}

TEST(Rdna4IntIsaWave, I32ReductionsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_wave_trait<I32ReductionTrait>();
}

TEST(Rdna4IntIsaWave, U64ReductionsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_wave_trait<U64ReductionTrait>();
}

TEST(Rdna4IntIsaWave, I64ReductionsMatchOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_wave_trait<I64ReductionTrait>();
}
