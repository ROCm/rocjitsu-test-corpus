// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "../../general/int_isa/matrix_test_parts.hpp"

namespace
{
template <bool ASign, bool BSign, bool Saturate> struct SwmmacI32Iu8K128
{
    static constexpr const char* Name = "swmmac_i32_16x16x128_iu8";
    static constexpr int K = 128;
    static constexpr int Bits = 8;
    static constexpr int ValuesPerWord = 4;
    static constexpr int SparseGroupBits = 16;
    static constexpr int Groups = K / 4;
    static constexpr int GroupsPerLane = 16;
    static constexpr int BValuesPerLane = 64;
    static constexpr int AWords = 8;
    static constexpr int BWords = 16;
    static constexpr int IndexWords = 2;
    static constexpr int CValuesPerLane = kCValuesPerLane;
    static constexpr bool ASigned = ASign;
    static constexpr bool BSigned = BSign;
    static constexpr bool Clamp = Saturate;
    using AFrag = v8i32;
    using BFrag = v16i32;
    using CFrag = cfrag_t;
    using IndexFrag = v2i32;

    __device__ static CFrag call(AFrag a, BFrag b, CFrag c, IndexFrag idx)
    {
        if constexpr(Saturate)
            return __builtin_amdgcn_swmmac_i32_16x16x128_iu8(ASigned, a, BSigned, b, c, idx, false,
                                                             false, true);
        else
            return __builtin_amdgcn_swmmac_i32_16x16x128_iu8(ASigned, a, BSigned, b, c, idx, false,
                                                             false, false);
    }
};
} // namespace

TEST(Gfx1250IntIsaSwmmacI32Iu8K128, BuiltinMatchesSparseScalarOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_sparse_matrix_modes<SwmmacI32Iu8K128>(127);
}
