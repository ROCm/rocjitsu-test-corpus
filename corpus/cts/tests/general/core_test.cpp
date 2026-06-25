// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "fpsan/fpsan.hpp"
#include "fpsan_generic.hpp"
#include "fpsan_test_common.hpp"

#include <cstdint>
#include <cstring>
#include <vector>

using fpsan::Conversions;
using fpsan::Semantics;
using fpsan::Value;

namespace
{
    template <class T>
    std::vector<T> samples()
    {
        std::vector<T> s   = {T(0), T(1), T(-1), T(100), T(-100)};
        std::mt19937   rng = fpsan_test::make_rng();
        while(s.size() < 16)
            s.push_back(fpsan_test::pick_quarter<T>(rng, -400, 400));
        return s;
    }

    template <class FT, Semantics S, Conversions C>
    int run_core_cfg()
    {
        using F = Value<FT, S, C>;

        F z{};
        FPSAN_ASSERT_EQ(bits_of(static_cast<FT>(z.to_float())), bits_of(FT(0)));

        for(FT x : samples<FT>())
        {
            F a(x);
            FPSAN_ASSERT_EQ(bits_of(a.to_float()), bits_of(x));
        }

        if constexpr(S == Semantics::Triton)
        {
            using B = typename F::bits_type;
            FPSAN_ASSERT_EQ(F(FT(0)).fpsan_payload(), B(0));
            FPSAN_ASSERT_EQ(F(FT(1)).fpsan_payload(), B(1));
            FPSAN_ASSERT_EQ(F(FT(-1)).fpsan_payload(), static_cast<B>(~B(0)));
        }

        F zero(FT(0)), one(FT(1));
        for(FT x : samples<FT>())
        {
            F a(x);
            FPSAN_ASSERT_TRUE(a + zero == a);
            FPSAN_ASSERT_TRUE(a * one == a);
            FPSAN_ASSERT_TRUE(a - a == zero);
            FPSAN_ASSERT_TRUE(a + (-a) == zero);
        }

        auto s = samples<FT>();
        for(FT xa : s)
            for(FT xb : s)
                for(FT xc : s)
                {
                    F a(xa), b(xb), c(xc);
                    if constexpr(S == Semantics::Triton)
                    {
                        FPSAN_ASSERT_TRUE((a + b) + c == a + (b + c));
                        FPSAN_ASSERT_TRUE((a * b) * c == a * (b * c));
                        FPSAN_ASSERT_TRUE(a * (b + c) == (a * b) + (a * c));
                    }
                    FPSAN_ASSERT_TRUE(a + b == b + a);
                    FPSAN_ASSERT_TRUE(a * b == b * a);
                }

        if constexpr(S == Semantics::Native)
        {
            for(FT x : s)
                for(FT y : s)
                {
                    F u(x), v(y);
                    FPSAN_ASSERT_EQ(bits_of((u + v).to_float()), bits_of(static_cast<FT>(x + y)));
                    FPSAN_ASSERT_EQ(bits_of((u - v).to_float()), bits_of(static_cast<FT>(x - y)));
                    FPSAN_ASSERT_EQ(bits_of((u * v).to_float()), bits_of(static_cast<FT>(x * y)));
                    if(bits_of(y) != bits_of(FT(0)))
                        FPSAN_ASSERT_EQ(bits_of((u / v).to_float()),
                                        bits_of(static_cast<FT>(x / y)));
                    FPSAN_ASSERT_EQ(u < v, x < y);
                    FPSAN_ASSERT_EQ(u == v, x == y);
                }
        }

        return 0;
    }

    template <class FT>
    int run_all_modes_for_type()
    {
        if(run_core_cfg<FT, Semantics::Native, Conversions::Implicit>() != 0)
            return 1;
        if(run_core_cfg<FT, Semantics::Native, Conversions::Explicit>() != 0)
            return 1;
        if(run_core_cfg<FT, Semantics::Triton, Conversions::Implicit>() != 0)
            return 1;
        if(run_core_cfg<FT, Semantics::Triton, Conversions::Explicit>() != 0)
            return 1;
        return 0;
    }

    template <class FT>
    int cross_check_all_bits(const fpsan_generic::FPFormat& fmt)
    {
        using F          = Value<FT, fpsan::Semantics::Triton, fpsan::Conversions::Explicit>;
        using B          = typename F::bits_type;
        const std::uint64_t n = std::uint64_t{1} << (sizeof(FT) * 8);
        for(std::uint64_t b = 0; b < n; ++b)
        {
            B  bb = static_cast<B>(b);
            FT v;
            std::memcpy(&v, &bb, sizeof v);
            B lib = F(v).fpsan_payload();
            B gen = static_cast<B>(
                fpsan_generic::FPSanFloat::embed(fmt, static_cast<std::uint32_t>(b)).payload());
            FPSAN_ASSERT_EQ(lib, gen);
        }
        return 0;
    }

    int run_ground_truth()
    {
#if FPSAN_HAS_FLOAT16
        if(cross_check_all_bits<_Float16>({"half", 16, 5, 10, 15, true}) != 0)
            return 1;
#endif
#if FPSAN_HAS_BF16
        if(cross_check_all_bits<__bf16>({"bf16", 16, 8, 7, 127, true}) != 0)
            return 1;
#endif
        const auto& fmt = fpsan_generic::formats::F32;
        for(float x : samples<float>())
        {
            std::uint32_t lib
                = Value<float, fpsan::Semantics::Triton, fpsan::Conversions::Explicit>(x)
                      .fpsan_payload();
            std::uint32_t gen
                = fpsan_generic::FPSanFloat::embed(fmt, static_cast<std::uint32_t>(bits_of(x)))
                      .payload();
            FPSAN_ASSERT_EQ(lib, gen);
        }
        return 0;
    }

    int run_float16_bijection()
    {
#if FPSAN_HAS_FLOAT16
        using F = Value<_Float16, fpsan::Semantics::Triton, fpsan::Conversions::Explicit>;
        std::vector<int> hit(1 << 16, 0);
        for(std::uint32_t b = 0; b < (1u << 16); ++b)
        {
            std::uint16_t bb = static_cast<std::uint16_t>(b);
            _Float16      v;
            std::memcpy(&v, &bb, sizeof v);
            std::uint16_t p = F(v).fpsan_payload();
            ++hit[p];
            if((bb & 0x7FFF) != 0)
            {
                std::uint16_t negb = bb ^ 0x8000;
                _Float16      nv;
                std::memcpy(&nv, &negb, sizeof nv);
                FPSAN_ASSERT_EQ(F(nv).fpsan_payload(), static_cast<std::uint16_t>(-p));
            }
        }
        for(int h : hit)
            FPSAN_ASSERT_EQ(h, 1);
#endif
        return 0;
    }

    int run_mixed_pod()
    {
        using Ff = Value<float, fpsan::Semantics::Native, fpsan::Conversions::Implicit>;
        Ff u(1.0f);
        FPSAN_ASSERT_EQ(bits_of((u + 2.0f).to_float()), bits_of(3.0f));
        FPSAN_ASSERT_EQ(bits_of((2.0f + u).to_float()), bits_of(3.0f));
        FPSAN_ASSERT_EQ(bits_of((u * 4).to_float()), bits_of(4.0f));
        FPSAN_ASSERT_TRUE(u < 2.0f);
        FPSAN_ASSERT_TRUE(2.0f > u);

        using Ft = Value<float, fpsan::Semantics::Triton, fpsan::Conversions::Implicit>;
        Ft p(2.0f), three(3.0f);
        FPSAN_ASSERT_TRUE(p + 3.0f == p + three);
        FPSAN_ASSERT_TRUE(p * 3.0f == p * three);
        return 0;
    }
} // namespace

int main()
{
    if(run_all_modes_for_type<float>() != 0)
        return 1;
    if(run_all_modes_for_type<double>() != 0)
        return 1;
#if FPSAN_HAS_FLOAT16
    if(run_all_modes_for_type<_Float16>() != 0)
        return 1;
#endif
#if FPSAN_HAS_BF16
    if(run_all_modes_for_type<__bf16>() != 0)
        return 1;
#endif
    if(run_ground_truth() != 0)
        return 1;
    if(run_float16_bijection() != 0)
        return 1;
    if(run_mixed_pod() != 0)
        return 1;
    return 0;
}
