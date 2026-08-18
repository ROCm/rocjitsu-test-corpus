// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "../../general/int_isa/matrix_test_parts.hpp"

namespace
{
template <bool ASign, bool BSign, bool Saturate> struct WmmaI32Iu8K64
{
    static constexpr const char* Name = "wmma_i32_16x16x64_iu8";
    static constexpr int K = 64;
    static constexpr int Bits = 8;
    static constexpr int ValuesPerWord = 4;
    static constexpr int AValuesPerLane = 32;
    static constexpr int BValuesPerLane = 32;
    static constexpr int AWords = 8;
    static constexpr int BWords = 8;
    static constexpr int CValuesPerLane = kCValuesPerLane;
    static constexpr bool ASigned = ASign;
    static constexpr bool BSigned = BSign;
    static constexpr bool Clamp = Saturate;
    using AFrag = v8i32;
    using BFrag = v8i32;
    using CFrag = cfrag_t;

    __device__ static CFrag call(AFrag a, BFrag b, CFrag c)
    {
        if constexpr(Saturate)
            return __builtin_amdgcn_wmma_i32_16x16x64_iu8(ASigned, a, BSigned, b, c, false, false,
                                                          true);
        else
            return __builtin_amdgcn_wmma_i32_16x16x64_iu8(ASigned, a, BSigned, b, c, false, false,
                                                          false);
    }
};
} // namespace

TEST(Gfx1250IntIsaWmmaI32Iu8K64, BuiltinMatchesScalarOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_dense_matrix_modes<WmmaI32Iu8K64>(61);
}
