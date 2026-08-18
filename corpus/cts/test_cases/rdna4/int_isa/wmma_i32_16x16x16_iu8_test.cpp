// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "../../general/int_isa/matrix_test_parts.hpp"

namespace
{
template <bool ASign, bool BSign, bool Saturate>
struct WmmaI32Iu8K16
{
    static constexpr const char* Name          = "wmma_i32_16x16x16_iu8";
    static constexpr int         K             = 16;
    static constexpr int         Bits          = 8;
    static constexpr int         ValuesPerWord = 4;
#if defined(INT_ISA_TEST_WAVE64)
    static constexpr int AValuesPerLane = 4;
    static constexpr int BValuesPerLane = 4;
    static constexpr int AWords         = 1;
    static constexpr int BWords         = 1;
    using AFrag                         = int;
    using BFrag                         = int;
#else
    static constexpr int AValuesPerLane = 8;
    static constexpr int BValuesPerLane = 8;
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
        return __builtin_amdgcn_wmma_i32_16x16x16_iu8_w64_gfx12(
            ASigned, a, BSigned, b, c, Clamp);
#else
        return __builtin_amdgcn_wmma_i32_16x16x16_iu8_w32_gfx12(
            ASigned, a, BSigned, b, c, Clamp);
#endif
    }
};
} // namespace

TEST(Rdna4IntIsaWmmaI32Iu8K16, BuiltinMatchesScalarOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_dense_matrix_modes<WmmaI32Iu8K16>(3);
}
