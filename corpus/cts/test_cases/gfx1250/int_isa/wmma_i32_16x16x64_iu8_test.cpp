// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "../../general/int_isa/matrix_test_parts.hpp"

namespace {
template <bool ASign, bool BSign, bool Saturate> struct WmmaI32Iu8K64 {
  static constexpr const char *Name = "wmma_i32_16x16x64_iu8";
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

  __device__ static CFrag call(AFrag a, BFrag b, CFrag c) {
    if constexpr (Saturate)
      return __builtin_amdgcn_wmma_i32_16x16x64_iu8(ASigned, a, BSigned, b, c, false, false, true);
    else
      return __builtin_amdgcn_wmma_i32_16x16x64_iu8(ASigned, a, BSigned, b, c, false, false, false);
  }
};

template <class Trait>
std::vector<std::uint8_t> make_transpose_load_a_tiles(const MatrixData<Trait> &data) {
  std::vector<std::uint8_t> tiles((Trait::K / 16) * 16 * 16);
  for (int tile = 0; tile < Trait::K / 16; ++tile)
    for (int k = 0; k < 16; ++k)
      for (int row = 0; row < kM; ++row)
        tiles[(tile * 16 + k) * 16 + row] = static_cast<std::uint8_t>(
            packed_bits(data.A[row * Trait::K + tile * 16 + k], Trait::Bits));
  return tiles;
}

template <class Trait>
std::vector<std::uint8_t> make_transpose_load_b_tiles(const MatrixData<Trait> &data) {
  std::vector<std::uint8_t> tiles((Trait::K / 16) * 16 * 16);
  for (int tile = 0; tile < Trait::K / 16; ++tile)
    for (int k = 0; k < 16; ++k)
      for (int col = 0; col < kN; ++col)
        tiles[(tile * 16 + k) * 16 + col] =
            static_cast<std::uint8_t>(packed_bits(data.B[(tile * 16 + k) * kN + col], Trait::Bits));
  return tiles;
}

template <class Trait>
__global__ void transpose_load_wmma_kernel(const std::uint8_t *a_tiles, const std::uint8_t *b_tiles,
                                           const std::int32_t *C, std::int32_t *D) {
  const int lane = threadIdx.x;
  const int source_k = (lane & 7) + 8 * (lane >> 4);
  const int source_dim = 8 * ((lane >> 3) & 1);
  typename Trait::AFrag a{};
  typename Trait::BFrag b{};
#ifdef __HIP_DEVICE_COMPILE__
  for (int tile = 0; tile < Trait::K / 16; ++tile) {
    const int offset = tile * 16 * 16 + source_k * 16 + source_dim;
    const v2i32 a_part = __builtin_amdgcn_global_load_tr8_b64_v2i32(
        (v2i32 __attribute__((address_space(1))) *)(&a_tiles[offset]));
    const v2i32 b_part = __builtin_amdgcn_global_load_tr8_b64_v2i32(
        (v2i32 __attribute__((address_space(1))) *)(&b_tiles[offset]));
    a[2 * tile] = a_part[0];
    a[2 * tile + 1] = a_part[1];
    b[2 * tile] = b_part[0];
    b[2 * tile + 1] = b_part[1];
  }
#endif
  auto c = load_c_frag<Trait>(C, lane);
  store_d_frag<Trait>(Trait::call(a, b, c), D, lane);
}

template <class Trait> void run_transpose_load_wmma_case(int seed) {
  MatrixData<Trait> data = make_dense_inputs<Trait>(seed);
  std::vector<std::int32_t> ref = dense_reference<Trait>(data);
  std::vector<std::uint8_t> a_tiles = make_transpose_load_a_tiles(data);
  std::vector<std::uint8_t> b_tiles = make_transpose_load_b_tiles(data);
  auto dA = to_device(a_tiles);
  auto dB = to_device(b_tiles);
  auto dC = to_device(data.C);
  if (!dA || !dB || !dC)
    FAIL() << "failed to initialize transpose-load matrix inputs on device";

  auto dD = allocate_device<std::int32_t>(ref.size());
  if (!dD)
    return;

  transpose_load_wmma_kernel<Trait><<<1, kWaveLanes>>>(dA.get(), dB.get(), dC.get(), dD.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());

  std::vector<std::int32_t> got(ref.size());
  HIP_CHECK(
      hipMemcpy(got.data(), dD.get(), got.size() * sizeof(std::int32_t), hipMemcpyDeviceToHost));
  for (std::size_t i = 0; i < ref.size(); ++i)
    EXPECT_EQ(static_cast<std::uint32_t>(got[i]), static_cast<std::uint32_t>(ref[i]))
        << Trait::Name << " transpose-load producer element " << i;
}
} // namespace

TEST(Gfx1250IntIsaWmmaI32Iu8K64, InputLayoutMatchesCdna5Manual) {
  struct Anchor {
    int k;
    int lane_half;
    int slot;
  };
  constexpr Anchor anchors[] = {
      {0, 0, 0},   {7, 0, 7},   {8, 1, 0},   {15, 1, 7},  {16, 0, 8},  {24, 1, 8},
      {32, 0, 16}, {40, 1, 16}, {48, 0, 24}, {56, 1, 24}, {63, 1, 31},
  };
  for (const Anchor &anchor : anchors) {
    EXPECT_EQ(Gfx1250Iu8MatrixInputLayout::lane(3, anchor.k), 3 + 16 * anchor.lane_half);
    EXPECT_EQ(Gfx1250Iu8MatrixInputLayout::slot(anchor.k), anchor.slot);
  }

  bool seen[64]{};
  for (int k = 0; k < 64; ++k) {
    const int lane = Gfx1250Iu8MatrixInputLayout::lane(0, k);
    const int slot = Gfx1250Iu8MatrixInputLayout::slot(k);
    ASSERT_TRUE(lane == 0 || lane == 16);
    ASSERT_GE(slot, 0);
    ASSERT_LT(slot, 32);
    const int physical = (lane / 16) * 32 + slot;
    EXPECT_FALSE(seen[physical]) << "duplicate physical location for K=" << k;
    seen[physical] = true;
    EXPECT_EQ(Gfx1250Iu8MatrixInputLayout::logical_index(lane, slot, 64, 32), k);
  }
  for (bool occupied : seen)
    EXPECT_TRUE(occupied);

  // The old contiguous-half packer put K=8 in lane 0, slot 8. This
  // directed anchor makes that shared-permutation layout fail explicitly.
  EXPECT_NE(Gfx1250Iu8MatrixInputLayout::lane(0, 8), 0);
  EXPECT_NE(Gfx1250Iu8MatrixInputLayout::slot(8), 8);
}

TEST(Gfx1250IntIsaWmmaI32Iu8K64, BuiltinMatchesScalarOracle) {
  if (!have_device())
    GTEST_SKIP() << "no HIP device available";
  run_dense_matrix_modes<WmmaI32Iu8K64, Gfx1250Iu8MatrixInputLayout>(61);
}

TEST(Gfx1250IntIsaWmmaI32Iu8K64, TransposeLoadProducerMatchesScalarOracle) {
  if (!have_device())
    GTEST_SKIP() << "no HIP device available";
  run_transpose_load_wmma_case<WmmaI32Iu8K64<false, false, false>>(83);
  run_transpose_load_wmma_case<WmmaI32Iu8K64<true, true, true>>(89);
}
