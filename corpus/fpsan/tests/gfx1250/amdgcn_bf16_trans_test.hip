// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "fpsan/amdgcn_math.hpp"
#include "fpsan/fpsan.hpp"
#include "fpsan_hip_test_common.hpp"
#include "fpsan_test_common.hpp"

#include <hip/hip_runtime.h>

#include <cstdint>
#include <cstring>
#include <vector>

using fpsan::Conversions;
using fpsan::Semantics;
using fpsan::Value;

static constexpr Conversions kCC = Conversions::Explicit;

namespace
{
    std::uint16_t bits_u16(__bf16 v)
    {
        std::uint16_t u = 0;
        std::memcpy(&u, &v, sizeof u);
        return u;
    }

    std::vector<__bf16> make_inputs()
    {
        std::vector<__bf16> v(32);
        std::mt19937        rng = fpsan_test::make_rng();
        for(auto& x : v)
            x = static_cast<__bf16>(fpsan_test::pick_quarter<float>(rng, 4, 36));
        return v;
    }
} // namespace

#define BF16_TRANS_KERNEL(name, FPSAN_OP)                                                          \
    __global__ void k_##name##_pair(const __bf16*  in,                                             \
                                    __bf16*        direct,                                         \
                                    __bf16*        via_wrapper,                                    \
                                    std::uint16_t* pay_direct,                                     \
                                    std::uint16_t* pay_wrapper)                                    \
    {                                                                                              \
        int    i  = threadIdx.x;                                                                   \
        __bf16 x  = in[i];                                                                         \
        direct[i] = __builtin_##name(x);                                                           \
        Value<__bf16, Semantics::Native, kCC> vf{x};                                               \
        via_wrapper[i] = static_cast<__bf16>(fpsan::name<Semantics::Native, kCC>(vf));             \
        Value<__bf16, Semantics::Triton, kCC> vp{x};                                               \
        pay_direct[i] = static_cast<std::uint16_t>(fpsan::FPSAN_OP(vp).fpsan_payload());           \
        pay_wrapper[i]                                                                             \
            = static_cast<std::uint16_t>(fpsan::name<Semantics::Triton, kCC>(vp).fpsan_payload()); \
    }

BF16_TRANS_KERNEL(amdgcn_rcp_bf16, rcp)
BF16_TRANS_KERNEL(amdgcn_rsq_bf16, rsqrt)
BF16_TRANS_KERNEL(amdgcn_sqrt_bf16, sqrt)
BF16_TRANS_KERNEL(amdgcn_sin_bf16, sin)
BF16_TRANS_KERNEL(amdgcn_cos_bf16, cos)
BF16_TRANS_KERNEL(amdgcn_exp2_bf16, exp2)
BF16_TRANS_KERNEL(amdgcn_log_bf16, log)
BF16_TRANS_KERNEL(amdgcn_tanh_bf16, tanh)

#define BF16_TRANS_RUN(name)                                                                      \
    int run_##name()                                                                              \
    {                                                                                             \
        auto      in = make_inputs();                                                            \
        const int N  = static_cast<int>(in.size());                                               \
        __bf16*   dIn = nullptr;                                                                  \
        FPSAN_ASSERT_EQ(to_dev(in, &dIn), 0);                                                     \
        __bf16 *       dDirect = nullptr, *dWrap = nullptr;                                       \
        std::uint16_t *dPdir = nullptr, *dPwrap = nullptr;                                        \
        FPSAN_HIP_ASSERT(hipMalloc(&dDirect, N * sizeof(__bf16)));                                \
        FPSAN_HIP_ASSERT(hipMalloc(&dWrap, N * sizeof(__bf16)));                                  \
        FPSAN_HIP_ASSERT(hipMalloc(&dPdir, N * sizeof(std::uint16_t)));                           \
        FPSAN_HIP_ASSERT(hipMalloc(&dPwrap, N * sizeof(std::uint16_t)));                          \
        k_##name##_pair<<<1, N>>>(dIn, dDirect, dWrap, dPdir, dPwrap);                            \
        FPSAN_HIP_ASSERT(hipDeviceSynchronize());                                                 \
        std::vector<__bf16>        direct, wrap;                                                  \
        std::vector<std::uint16_t> pdir, pwrap;                                                   \
        FPSAN_ASSERT_EQ(from_dev(dDirect, N, direct), 0);                                         \
        FPSAN_ASSERT_EQ(from_dev(dWrap, N, wrap), 0);                                             \
        FPSAN_ASSERT_EQ(from_dev(dPdir, N, pdir), 0);                                             \
        FPSAN_ASSERT_EQ(from_dev(dPwrap, N, pwrap), 0);                                           \
        for(int i = 0; i < N; ++i)                                                                \
        {                                                                                         \
            FPSAN_ASSERT_EQ(bits_u16(wrap[i]), bits_u16(direct[i]));                              \
            FPSAN_ASSERT_EQ(pwrap[i], pdir[i]);                                                   \
        }                                                                                         \
        (void)hipFree(dIn);                                                                       \
        (void)hipFree(dDirect);                                                                   \
        (void)hipFree(dWrap);                                                                     \
        (void)hipFree(dPdir);                                                                     \
        (void)hipFree(dPwrap);                                                                    \
        return 0;                                                                                 \
    }

BF16_TRANS_RUN(amdgcn_rcp_bf16)
BF16_TRANS_RUN(amdgcn_rsq_bf16)
BF16_TRANS_RUN(amdgcn_sqrt_bf16)
BF16_TRANS_RUN(amdgcn_sin_bf16)
BF16_TRANS_RUN(amdgcn_cos_bf16)
BF16_TRANS_RUN(amdgcn_exp2_bf16)
BF16_TRANS_RUN(amdgcn_log_bf16)
BF16_TRANS_RUN(amdgcn_tanh_bf16)

int main()
{
    FPSAN_ASSERT_TRUE(have_device());
    if(run_amdgcn_rcp_bf16() != 0)
        return 1;
    if(run_amdgcn_rsq_bf16() != 0)
        return 1;
    if(run_amdgcn_sqrt_bf16() != 0)
        return 1;
    if(run_amdgcn_sin_bf16() != 0)
        return 1;
    if(run_amdgcn_cos_bf16() != 0)
        return 1;
    if(run_amdgcn_exp2_bf16() != 0)
        return 1;
    if(run_amdgcn_log_bf16() != 0)
        return 1;
    if(run_amdgcn_tanh_bf16() != 0)
        return 1;
    return 0;
}
