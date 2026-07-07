// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "fpsan/fpsan.hpp"
#include "fpsan_generic.hpp"
#include "fpsan_test_common.hpp"

#include <cmath>
#include <cstdint>
#include <vector>

using fpsan::Value;

namespace
{
    std::vector<float> xs()
    {
        std::vector<float> s   = {0.f, 1.f, -1.f};
        std::mt19937       rng = fpsan_test::make_rng();
        while(s.size() < 14)
            s.push_back(fpsan_test::pick_quarter<float>(rng, -36, 36));
        return s;
    }

    int run_exp_ground_truth()
    {
        using F         = Value<float, fpsan::Semantics::Triton, fpsan::Conversions::Explicit>;
        const auto& fmt = fpsan_generic::formats::F32;
        for(float x : xs())
        {
            auto gen = fpsan_generic::FPSanFloat::embed(fmt, static_cast<std::uint32_t>(bits_of(x)));
            FPSAN_ASSERT_EQ(fpsan::exp2(F(x)).fpsan_payload(), gen.exp2().payload());
            FPSAN_ASSERT_EQ(fpsan::exp(F(x)).fpsan_payload(), gen.exp().payload());
        }
        return 0;
    }

    int run_identities()
    {
        using F = Value<float, fpsan::Semantics::Triton, fpsan::Conversions::Explicit>;
        for(float a : xs())
            for(float b : xs())
            {
                F A(a), B(b);
                FPSAN_ASSERT_TRUE(fpsan::exp(A + B) == fpsan::exp(A) * fpsan::exp(B));
                FPSAN_ASSERT_TRUE(fpsan::exp2(A + B) == fpsan::exp2(A) * fpsan::exp2(B));

                F cosA = fpsan::cos(A), sinA = fpsan::sin(A);
                F cosB = fpsan::cos(B), sinB = fpsan::sin(B);
                FPSAN_ASSERT_TRUE(fpsan::cos(A + B) == cosA * cosB - sinA * sinB);
                FPSAN_ASSERT_TRUE(fpsan::sin(A + B) == sinA * cosB + cosA * sinB);
            }
        FPSAN_ASSERT_EQ(fpsan::exp(F(0.f)).fpsan_payload(), 1u);
        FPSAN_ASSERT_EQ(fpsan::exp2(F(0.f)).fpsan_payload(), 1u);
        FPSAN_ASSERT_EQ(fpsan::cos(F(0.f)).fpsan_payload(), 1u);
        FPSAN_ASSERT_EQ(fpsan::sin(F(0.f)).fpsan_payload(), 0u);
        return 0;
    }

    int run_tagged_ops()
    {
        using F = Value<float, fpsan::Semantics::Triton, fpsan::Conversions::Explicit>;
        for(float x : xs())
        {
            F a(x), b(x);
            FPSAN_ASSERT_TRUE(fpsan::log(a) == fpsan::log(b));
            if(x != 0.f)
            {
                FPSAN_ASSERT_TRUE(fpsan::log(a) != fpsan::sqrt(a));
                FPSAN_ASSERT_TRUE(fpsan::sqrt(a) != fpsan::rsqrt(a));
                FPSAN_ASSERT_TRUE(fpsan::precise_sqrt(a) != fpsan::sqrt(a));
                FPSAN_ASSERT_TRUE(fpsan::precise_sqrt(a) != fpsan::rsqrt(a));
                FPSAN_ASSERT_TRUE(fpsan::floor(a) != fpsan::ceil(a));
                FPSAN_ASSERT_TRUE(fpsan::erf(a) != fpsan::log2(a));
                FPSAN_ASSERT_TRUE(fpsan::rcp(a) != fpsan::sqrt(a));
                FPSAN_ASSERT_TRUE(fpsan::fract(a) != fpsan::rcp(a));
                FPSAN_ASSERT_TRUE(fpsan::tanh(a) != fpsan::fract(a));
            }
        }
        return 0;
    }

    int run_native_parity()
    {
        using F = Value<float, fpsan::Semantics::Native, fpsan::Conversions::Explicit>;
        for(float x : xs())
        {
            F a(x);
            FPSAN_ASSERT_EQ(bits_of(static_cast<float>(fpsan::exp(a))), bits_of(std::exp(x)));
            FPSAN_ASSERT_EQ(bits_of(static_cast<float>(fpsan::exp2(a))), bits_of(std::exp2(x)));
            FPSAN_ASSERT_EQ(bits_of(static_cast<float>(fpsan::sin(a))), bits_of(std::sin(x)));
            FPSAN_ASSERT_EQ(bits_of(static_cast<float>(fpsan::cos(a))), bits_of(std::cos(x)));
            FPSAN_ASSERT_EQ(bits_of(static_cast<float>(fpsan::floor(a))), bits_of(std::floor(x)));
            FPSAN_ASSERT_EQ(bits_of(static_cast<float>(fpsan::ceil(a))), bits_of(std::ceil(x)));
            if(x > 0.f)
            {
                FPSAN_ASSERT_EQ(bits_of(static_cast<float>(fpsan::log(a))), bits_of(std::log(x)));
                FPSAN_ASSERT_EQ(bits_of(static_cast<float>(fpsan::sqrt(a))), bits_of(std::sqrt(x)));
                FPSAN_ASSERT_EQ(bits_of(static_cast<float>(fpsan::precise_sqrt(a))),
                                bits_of(std::sqrt(x)));
            }
        }
        return 0;
    }
} // namespace

int main()
{
    if(run_exp_ground_truth() != 0)
        return 1;
    if(run_identities() != 0)
        return 1;
    if(run_tagged_ops() != 0)
        return 1;
    if(run_native_parity() != 0)
        return 1;
    return 0;
}
