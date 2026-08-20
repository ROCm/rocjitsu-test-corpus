// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "../../general/int_isa/matrix_test_parts.hpp"

namespace {
template <bool ASign, bool BSign, bool Saturate> struct SwmmacI32Iu8K128 {
  static constexpr const char *Name = "swmmac_i32_16x16x128_iu8";
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

  __device__ static CFrag call(AFrag a, BFrag b, CFrag c, IndexFrag idx) {
    if constexpr (Saturate)
      return __builtin_amdgcn_swmmac_i32_16x16x128_iu8(ASigned, a, BSigned, b, c, idx, false, false,
                                                       true);
    else
      return __builtin_amdgcn_swmmac_i32_16x16x128_iu8(ASigned, a, BSigned, b, c, idx, false, false,
                                                       false);
  }
};
} // namespace

TEST(Gfx1250IntIsaSwmmacI32Iu8K128, InputAndIndexLayoutsMatchCdna5Manual) {
  struct Anchor {
    int logical;
    int lane_half;
    int slot;
  };
  constexpr Anchor compressed_a_anchors[] = {
      {0, 0, 0},   {7, 0, 7},   {8, 1, 0},   {15, 1, 7},  {16, 0, 8},  {24, 1, 8},
      {32, 0, 16}, {40, 1, 16}, {48, 0, 24}, {56, 1, 24}, {63, 1, 31},
  };
  for (const Anchor &anchor : compressed_a_anchors) {
    EXPECT_EQ(Gfx1250Iu8MatrixInputLayout::lane(5, anchor.logical), 5 + 16 * anchor.lane_half);
    EXPECT_EQ(Gfx1250Iu8MatrixInputLayout::slot(anchor.logical), anchor.slot);
    EXPECT_EQ(Gfx1250Iu8MatrixInputLayout::index_word(anchor.logical), anchor.slot / 16);
    EXPECT_EQ(Gfx1250Iu8MatrixInputLayout::index_bit(anchor.logical), 2 * (anchor.slot % 16));
  }

  constexpr Anchor dense_b_anchors[] = {
      {0, 0, 0},   {15, 0, 15}, {16, 1, 0},  {31, 1, 15},  {32, 0, 16},  {48, 1, 16},
      {64, 0, 32}, {80, 1, 32}, {96, 0, 48}, {112, 1, 48}, {127, 1, 63},
  };
  bool seen[128]{};
  for (const Anchor &anchor : dense_b_anchors) {
    EXPECT_EQ(Gfx1250Iu8SparseBMatrixInputLayout::lane(7, anchor.logical),
              7 + 16 * anchor.lane_half);
    EXPECT_EQ(Gfx1250Iu8SparseBMatrixInputLayout::slot(anchor.logical), anchor.slot);
  }
  for (int k = 0; k < 128; ++k) {
    const int lane = Gfx1250Iu8SparseBMatrixInputLayout::lane(0, k);
    const int slot = Gfx1250Iu8SparseBMatrixInputLayout::slot(k);
    ASSERT_TRUE(lane == 0 || lane == 16);
    ASSERT_GE(slot, 0);
    ASSERT_LT(slot, 64);
    const int physical = (lane / 16) * 64 + slot;
    EXPECT_FALSE(seen[physical]) << "duplicate physical location for K=" << k;
    seen[physical] = true;
    EXPECT_EQ(Gfx1250Iu8SparseBMatrixInputLayout::logical_index(lane, slot, 128, 64), k);
  }
  for (bool occupied : seen)
    EXPECT_TRUE(occupied);
}

TEST(Gfx1250IntIsaSwmmacI32Iu8K128, SelectorVectorsCoverPairsWithoutShortPeriod) {
  using Trait = SwmmacI32Iu8K128<false, false, false>;
  const SparseData<Trait> data = make_sparse_inputs<Trait, Gfx1250Iu8MatrixInputLayout>(127);
  bool seen[4][4]{};
  for (int row = 0; row < kM; ++row) {
    bool differs_at_distance_two = false;
    for (int group = 0; group < Trait::Groups; ++group) {
      const int first = data.p0[row * Trait::Groups + group];
      const int second = data.p1[row * Trait::Groups + group];
      ASSERT_LT(first, second);
      seen[first][second] = true;
      for (int which = 0; which < 2; ++which) {
        const int compressed = 2 * group + which;
        const int lane = Gfx1250Iu8MatrixInputLayout::lane(row, compressed);
        const int word = Gfx1250Iu8MatrixInputLayout::index_word(compressed);
        const int bit = Gfx1250Iu8MatrixInputLayout::index_bit(compressed);
        const int actual = (data.idx[lane * Trait::IndexWords + word] >> bit) & 3u;
        EXPECT_EQ(actual, which == 0 ? first : second)
            << "row=" << row << " group=" << group << " selector=" << which;
      }
      if (group + 2 < Trait::Groups) {
        differs_at_distance_two |= first != data.p0[row * Trait::Groups + group + 2] ||
                                   second != data.p1[row * Trait::Groups + group + 2];
      }
    }
    EXPECT_TRUE(differs_at_distance_two) << "row " << row;
  }
  for (int first = 0; first < 4; ++first)
    for (int second = first + 1; second < 4; ++second)
      EXPECT_TRUE(seen[first][second]) << "missing selector pair " << first << ',' << second;
}

TEST(Gfx1250IntIsaSwmmacI32Iu8K128, BuiltinMatchesSparseScalarOracle) {
  if (!have_device())
    GTEST_SKIP() << "no HIP device available";
  run_sparse_matrix_modes<SwmmacI32Iu8K128, Gfx1250Iu8MatrixInputLayout,
                          Gfx1250Iu8SparseBMatrixInputLayout>(127);
}
