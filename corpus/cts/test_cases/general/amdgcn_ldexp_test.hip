// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "fpsan/amdgcn_math.hpp"
#include "fpsan/fpsan.hpp"
#include "fpsan_hip_test_common.hpp"
#include "fpsan_test_common.hpp"

#include <hip/hip_runtime.h>

#include <cmath>
#include <cstdint>
#include <vector>

using fpsan::Conversions;
using fpsan::Semantics;
using fpsan::Value;

static constexpr Conversions kCC = Conversions::Explicit;

namespace
{
    constexpr int kExps[] = {-6, -3, -1, 0, 1, 2, 5};
    constexpr int kNExp   = static_cast<int>(sizeof(kExps) / sizeof(kExps[0]));
} // namespace

template <Semantics S, class Out>
__global__ void k_ldexpf(const float* in, Out* out, int n)
{
    int                  l = threadIdx.x;
    Value<float, S, kCC> v{in[l]};
    auto                 r = fpsan::amdgcn_ldexpf<S, kCC>(v, n);
    if constexpr(S == Semantics::Native)
        out[l] = r.to_float();
    else
        out[l] = r.fpsan_payload();
}

template <Semantics S, class Out>
__global__ void k_ldexp(const double* in, Out* out, int n)
{
    int                   l = threadIdx.x;
    Value<double, S, kCC> v{in[l]};
    auto                  r = fpsan::amdgcn_ldexp<S, kCC>(v, n);
    if constexpr(S == Semantics::Native)
        out[l] = r.to_float();
    else
        out[l] = r.fpsan_payload();
}

template <Semantics S, class Out>
__global__ void k_ldexph(const float* in, Out* out, int n)
{
    int                     l = threadIdx.x;
    Value<_Float16, S, kCC> v{static_cast<_Float16>(in[l])};
    auto                    r = fpsan::amdgcn_ldexph<S, kCC>(v, n);
    if constexpr(S == Semantics::Native)
        out[l] = static_cast<float>(r.to_float());
    else
        out[l] = r.fpsan_payload();
}

namespace
{
    int run_f32()
    {
        const int          N = 64;
        std::vector<float> in(N);
        std::mt19937       rng = fpsan_test::make_rng();
        for(auto& x : in)
            x = fpsan_test::pick_int_valued<float>(rng, -8, 8);

        float* dIn = nullptr;
        FPSAN_ASSERT_EQ(to_dev(in, &dIn), 0);
        for(int e = 0; e < kNExp; ++e)
        {
            const int n = kExps[e];
            {
                float* dO = nullptr;
                FPSAN_HIP_ASSERT(hipMalloc(&dO, N * sizeof(float)));
                k_ldexpf<Semantics::Native, float><<<1, N>>>(dIn, dO, n);
                FPSAN_HIP_ASSERT(hipDeviceSynchronize());
                std::vector<float> got;
                FPSAN_ASSERT_EQ(from_dev(dO, N, got), 0);
                for(int i = 0; i < N; ++i)
                    FPSAN_ASSERT_EQ(got[i], std::ldexp(in[i], n));
                (void)hipFree(dO);
            }
            {
                using VF = Value<float, Semantics::Triton, kCC>;
                std::vector<std::uint32_t> ref(N);
                for(int i = 0; i < N; ++i)
                    ref[i] = (VF(in[i]) * VF(std::ldexp(1.0f, n))).fpsan_payload();

                std::uint32_t* dO = nullptr;
                FPSAN_HIP_ASSERT(hipMalloc(&dO, N * sizeof(std::uint32_t)));
                k_ldexpf<Semantics::Triton, std::uint32_t><<<1, N>>>(dIn, dO, n);
                FPSAN_HIP_ASSERT(hipDeviceSynchronize());
                std::vector<std::uint32_t> got;
                FPSAN_ASSERT_EQ(from_dev(dO, N, got), 0);
                for(int i = 0; i < N; ++i)
                    FPSAN_ASSERT_EQ(got[i], ref[i]);
                (void)hipFree(dO);
            }
        }
        (void)hipFree(dIn);
        return 0;
    }

    int run_f64()
    {
        const int           N = 64;
        std::vector<double> in(N);
        std::mt19937        rng = fpsan_test::make_rng();
        for(auto& x : in)
            x = fpsan_test::pick_int_valued<double>(rng, -8, 8);

        double* dIn = nullptr;
        FPSAN_ASSERT_EQ(to_dev(in, &dIn), 0);
        for(int e = 0; e < kNExp; ++e)
        {
            const int n = kExps[e];
            {
                double* dO = nullptr;
                FPSAN_HIP_ASSERT(hipMalloc(&dO, N * sizeof(double)));
                k_ldexp<Semantics::Native, double><<<1, N>>>(dIn, dO, n);
                FPSAN_HIP_ASSERT(hipDeviceSynchronize());
                std::vector<double> got;
                FPSAN_ASSERT_EQ(from_dev(dO, N, got), 0);
                for(int i = 0; i < N; ++i)
                    FPSAN_ASSERT_EQ(got[i], std::ldexp(in[i], n));
                (void)hipFree(dO);
            }
            {
                using VD = Value<double, Semantics::Triton, kCC>;
                std::vector<std::uint64_t> ref(N);
                for(int i = 0; i < N; ++i)
                    ref[i] = (VD(in[i]) * VD(std::ldexp(1.0, n))).fpsan_payload();

                std::uint64_t* dO = nullptr;
                FPSAN_HIP_ASSERT(hipMalloc(&dO, N * sizeof(std::uint64_t)));
                k_ldexp<Semantics::Triton, std::uint64_t><<<1, N>>>(dIn, dO, n);
                FPSAN_HIP_ASSERT(hipDeviceSynchronize());
                std::vector<std::uint64_t> got;
                FPSAN_ASSERT_EQ(from_dev(dO, N, got), 0);
                for(int i = 0; i < N; ++i)
                    FPSAN_ASSERT_EQ(got[i], ref[i]);
                (void)hipFree(dO);
            }
        }
        (void)hipFree(dIn);
        return 0;
    }

    int run_f16()
    {
        const int          N = 64;
        std::vector<float> in(N);
        std::mt19937       rng = fpsan_test::make_rng();
        for(auto& x : in)
            x = fpsan_test::pick_int_valued<float>(rng, -8, 8);

        float* dIn = nullptr;
        FPSAN_ASSERT_EQ(to_dev(in, &dIn), 0);
        for(int e = 0; e < kNExp; ++e)
        {
            const int n = kExps[e];
            {
                float* dO = nullptr;
                FPSAN_HIP_ASSERT(hipMalloc(&dO, N * sizeof(float)));
                k_ldexph<Semantics::Native, float><<<1, N>>>(dIn, dO, n);
                FPSAN_HIP_ASSERT(hipDeviceSynchronize());
                std::vector<float> got;
                FPSAN_ASSERT_EQ(from_dev(dO, N, got), 0);
                for(int i = 0; i < N; ++i)
                {
                    _Float16 ref = static_cast<_Float16>(
                        std::ldexp(static_cast<float>(static_cast<_Float16>(in[i])), n));
                    FPSAN_ASSERT_EQ(got[i], static_cast<float>(ref));
                }
                (void)hipFree(dO);
            }
            {
                using VH = Value<_Float16, Semantics::Triton, kCC>;
                std::vector<std::uint32_t> ref(N);
                for(int i = 0; i < N; ++i)
                    ref[i] = (VH(static_cast<_Float16>(in[i]))
                              * VH(static_cast<_Float16>(std::ldexp(1.0f, n))))
                                 .fpsan_payload();

                std::uint32_t* dO = nullptr;
                FPSAN_HIP_ASSERT(hipMalloc(&dO, N * sizeof(std::uint32_t)));
                k_ldexph<Semantics::Triton, std::uint32_t><<<1, N>>>(dIn, dO, n);
                FPSAN_HIP_ASSERT(hipDeviceSynchronize());
                std::vector<std::uint32_t> got;
                FPSAN_ASSERT_EQ(from_dev(dO, N, got), 0);
                for(int i = 0; i < N; ++i)
                    FPSAN_ASSERT_EQ(got[i], ref[i]);
                (void)hipFree(dO);
            }
        }
        (void)hipFree(dIn);
        return 0;
    }
} // namespace

int main()
{
    FPSAN_ASSERT_TRUE(have_device());
    if(run_f32() != 0)
        return 1;
    if(run_f64() != 0)
        return 1;
    if(run_f16() != 0)
        return 1;
    return 0;
}
