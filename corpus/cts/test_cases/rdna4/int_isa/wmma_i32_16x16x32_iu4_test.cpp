// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "matrix_test_parts.hpp"

namespace
{
template <bool ASign, bool BSign, bool Saturate>
struct WmmaI32Iu4K32
{
    static constexpr const char* Name          = "wmma_i32_16x16x32_iu4";
    static constexpr int         K             = 32;
    static constexpr int         Bits          = 4;
    static constexpr int         ValuesPerWord = 8;
#if defined(INT_ISA_TEST_WAVE64)
    static constexpr int AValuesPerLane = 8;
    static constexpr int BValuesPerLane = 8;
    static constexpr int AWords         = 1;
    static constexpr int BWords         = 1;
    using AFrag                         = int;
    using BFrag                         = int;
#else
    static constexpr int AValuesPerLane = 16;
    static constexpr int BValuesPerLane = 16;
    static constexpr int AWords         = 2;
    static constexpr int BWords         = 2;
    using AFrag                         = v2i32;
    using BFrag                         = v2i32;
#endif
    static constexpr int  CValuesPerLane = kCValuesPerLane;
    static constexpr bool ASigned        = ASign;
    static constexpr bool BSigned        = BSign;
    static constexpr bool Clamp          = Saturate;
    using CFrag                          = cfrag_t;

    __device__ static CFrag call(AFrag a, BFrag b, CFrag c)
    {
#if defined(INT_ISA_TEST_WAVE64)
        return __builtin_amdgcn_wmma_i32_16x16x32_iu4_w64_gfx12(
            ASigned, a, BSigned, b, c, Clamp);
#else
        return __builtin_amdgcn_wmma_i32_16x16x32_iu4_w32_gfx12(
            ASigned, a, BSigned, b, c, Clamp);
#endif
    }
};
} // namespace

TEST(Rdna4IntIsaWmmaI32Iu4K32, BuiltinMatchesScalarOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_dense_matrix_modes<WmmaI32Iu4K32>(31);
}
