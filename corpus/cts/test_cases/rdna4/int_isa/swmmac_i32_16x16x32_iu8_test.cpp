// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "matrix_test_parts.hpp"

namespace
{
template <bool ASign, bool BSign, bool Saturate>
struct SwmmacI32Iu8K32
{
    static constexpr const char* Name            = "swmmac_i32_16x16x32_iu8";
    static constexpr int         K               = 32;
    static constexpr int         Bits            = 8;
    static constexpr int         ValuesPerWord   = 4;
    static constexpr int         SparseGroupBits = 16;
    static constexpr int         Groups          = K / 4;
#if defined(INT_ISA_TEST_WAVE64)
    static constexpr int GroupsPerLane  = 2;
    static constexpr int BValuesPerLane = 8;
    static constexpr int AWords         = 1;
    static constexpr int BWords         = 2;
    using AFrag                         = int;
    using BFrag                         = v2i32;
#else
    static constexpr int GroupsPerLane  = 4;
    static constexpr int BValuesPerLane = 16;
    static constexpr int AWords         = 2;
    static constexpr int BWords         = 4;
    using AFrag                         = v2i32;
    using BFrag                         = v4i32;
#endif
    static constexpr int  CValuesPerLane = kCValuesPerLane;
    static constexpr bool ASigned        = ASign;
    static constexpr bool BSigned        = BSign;
    static constexpr bool Clamp          = Saturate;
    using CFrag                          = cfrag_t;

    __device__ static CFrag call(AFrag a, BFrag b, CFrag c, int idx)
    {
#if defined(INT_ISA_TEST_WAVE64)
        return __builtin_amdgcn_swmmac_i32_16x16x32_iu8_w64(
            ASigned, a, BSigned, b, c, idx, Clamp);
#else
        return __builtin_amdgcn_swmmac_i32_16x16x32_iu8_w32(
            ASigned, a, BSigned, b, c, idx, Clamp);
#endif
    }
};
} // namespace

TEST(Rdna4IntIsaSwmmacI32Iu8K32, BuiltinMatchesSparseScalarOracle)
{
    if(!have_device())
        GTEST_SKIP() << "no HIP device available";
    run_sparse_matrix_modes<SwmmacI32Iu8K32>(43);
}
