// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#pragma once

// Integer matrix CTS constructs logical A/B/C matrices, packs them through an
// architecture-specific fragment layout, calls the raw LLVM builtin, and
// compares against a scalar ISA oracle. The scalar contraction validates the
// arithmetic semantics; separate mapping tests pin layouts because a common K
// permutation of A and B is invisible to A*B.

#include "hip_test_utils.hpp"
#include "int_isa_test_utils.hpp"

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include <cstdint>
#include <limits>
#include <memory>
#include <type_traits>
#include <vector>

namespace {
constexpr int kM = 16;
constexpr int kN = 16;

#if defined(INT_ISA_TEST_WAVE64)
constexpr int kWaveLanes = 64;
constexpr int kCValuesPerLane = 4;
#else
constexpr int kWaveLanes = 32;
constexpr int kCValuesPerLane = 8;
#endif

using v2i32 = int __attribute__((ext_vector_type(2)));
using v4i32 = int __attribute__((ext_vector_type(4)));
using v8i32 = int __attribute__((ext_vector_type(8)));
using v16i32 = int __attribute__((ext_vector_type(16)));

#if defined(INT_ISA_TEST_WAVE64)
using cfrag_t = v4i32;
#else
using cfrag_t = v8i32;
#endif

struct HipDeviceDeleter {
  template <class T> void operator()(T *device) const noexcept {
    if (device != nullptr)
      (void)hipFree(device);
  }
};

template <class T> using DevicePtr = std::unique_ptr<T, HipDeviceDeleter>;

template <class T> DevicePtr<T> allocate_device(std::size_t count) {
  T *device = nullptr;
  const hipError_t status = hipMalloc(&device, count * sizeof(T));
  EXPECT_EQ(status, hipSuccess) << hipGetErrorString(status);
  if (status != hipSuccess)
    return {};

  return DevicePtr<T>(device);
}

template <class T> DevicePtr<T> to_device(const std::vector<T> &host) {
  DevicePtr<T> device = allocate_device<T>(host.size());
  if (!device)
    return {};

  const hipError_t status =
      hipMemcpy(device.get(), host.data(), host.size() * sizeof(T), hipMemcpyHostToDevice);
  EXPECT_EQ(status, hipSuccess) << hipGetErrorString(status);
  if (status != hipSuccess)
    return {};

  return device;
}

template <class Frag> __device__ void set_frag_word(Frag &frag, int word, std::uint32_t value) {
  if constexpr (std::is_same<Frag, int>::value)
    frag = static_cast<int>(value);
  else
    frag[word] = static_cast<int>(value);
}

template <class Frag> __device__ Frag make_zero_frag() {
  Frag frag{};
  return frag;
}

__host__ __device__ constexpr std::uint32_t packed_bits(std::int32_t value, int bits) {
  return bits == 8 ? (static_cast<std::uint32_t>(value) & 0xffu)
                   : (static_cast<std::uint32_t>(value) & 0xfu);
}

__host__ __device__ constexpr std::int32_t matrix_value(bool is_signed, int bits, int a, int b,
                                                        int seed) {
  const int raw = (a * 11 + b * 7 + seed) % 9;
  if (is_signed)
    return bits == 8 ? raw - 4 : (raw % 7) - 3;
  return bits == 8 ? raw + 1 : (raw % 7) + 1;
}

__host__ __device__ constexpr int lane_k_block(int lane, int block_count) {
  const int block = lane >> 4;
  if (block >= block_count)
    return -1;
#if defined(INT_ISA_TEST_WAVE64)
  if (block_count == 4)
    return ((block & 1) << 1) | (block >> 1);
#endif
  return block;
}

struct ContiguousMatrixInputLayout {
  __host__ __device__ static constexpr int logical_index(int lane, int slot, int logical_count,
                                                         int values_per_lane) {
    const int block = lane_k_block(lane, logical_count / values_per_lane);
    return block < 0 ? -1 : block * values_per_lane + slot;
  }
};

// CDNA5 dense 8-bit 16x64 matrix input layout (wave32). For each row of A,
// or column of B, consecutive K=8 blocks alternate between lane halves while
// consecutive K=16 blocks advance through the fragment register slots.
// CDNA5 ISA manual section 7.12.2, "8-bit A-Matrix 16x64".
struct Gfx1250Iu8MatrixInputLayout {
  __host__ __device__ static constexpr int lane(int row_or_col, int logical) {
    return row_or_col + 16 * ((logical >> 3) & 1);
  }

  __host__ __device__ static constexpr int slot(int logical) {
    return (logical & 7) + 8 * (logical >> 4);
  }

  __host__ __device__ static constexpr int logical_index(int lane_value, int slot_value,
                                                         int logical_count, int values_per_lane) {
    (void)logical_count;
    (void)values_per_lane;
    return 16 * (slot_value >> 3) + 8 * (lane_value >> 4) + (slot_value & 7);
  }

  __host__ __device__ static constexpr int index_word(int logical) { return slot(logical) / 16; }

  __host__ __device__ static constexpr int index_bit(int logical) {
    return 2 * (slot(logical) % 16);
  }
};

// CDNA5 sparse 8-bit B-matrix input layout (wave32). Consecutive K=16 blocks
// alternate between lane halves and consecutive K=32 blocks advance through
// the VGPR slots. This follows the explicit 128x16 B-matrix table in ISA
// manual section 7.12.5. Compressed A and its index use the ordinary 16x64
// layout above; sparse A and dense B therefore must not share a layout policy.
struct Gfx1250Iu8SparseBMatrixInputLayout {
  __host__ __device__ static constexpr int lane(int row_or_col, int logical) {
    return row_or_col + 16 * ((logical >> 4) & 1);
  }

  __host__ __device__ static constexpr int slot(int logical) {
    return (logical & 15) + 16 * (logical >> 5);
  }

  __host__ __device__ static constexpr int logical_index(int lane_value, int slot_value,
                                                         int logical_count, int values_per_lane) {
    (void)logical_count;
    (void)values_per_lane;
    return 32 * (slot_value >> 4) + 16 * (lane_value >> 4) + (slot_value & 15);
  }
};

__host__ __device__ constexpr int cd_row_from_lane(int lane, int element) {
#if defined(INT_ISA_TEST_WAVE64)
  return element + 8 * ((lane >> 4) & 1) + 4 * (lane >> 5);
#else
  return element + 8 * (lane >> 4);
#endif
}

template <class Trait> struct MatrixData {
  std::vector<std::int32_t> A;
  std::vector<std::int32_t> B;
  std::vector<std::int32_t> C;
};

template <class Trait> void apply_dense_overflow_cases(MatrixData<Trait> &data) {
  // Preserve the general input pattern while reserving outputs that
  // distinguish signed saturation from modulo-2^32 wrap.
  for (int k = 0; k < Trait::K; ++k) {
    data.A[k] = 1;
    data.B[k * kN] = 1;
    if constexpr (Trait::ASigned)
      data.A[Trait::K + k] = -1;
    if constexpr (Trait::BSigned)
      data.B[k * kN + 1] = -1;
  }

  data.C[0] = std::numeric_limits<std::int32_t>::max() - 4;
  if constexpr (Trait::ASigned)
    data.C[kN] = std::numeric_limits<std::int32_t>::min() + 4;
  if constexpr (Trait::BSigned)
    data.C[1] = std::numeric_limits<std::int32_t>::min() + 4;
}

template <class Trait> MatrixData<Trait> make_dense_inputs(int seed) {
  MatrixData<Trait> data;
  data.A.resize(kM * Trait::K);
  data.B.resize(Trait::K * kN);
  data.C.resize(kM * kN);
  for (int m = 0; m < kM; ++m)
    for (int k = 0; k < Trait::K; ++k)
      data.A[m * Trait::K + k] = matrix_value(Trait::ASigned, Trait::Bits, m, k, seed);
  for (int k = 0; k < Trait::K; ++k)
    for (int n = 0; n < kN; ++n)
      data.B[k * kN + n] = matrix_value(Trait::BSigned, Trait::Bits, k, n, seed + 3);
  for (int m = 0; m < kM; ++m)
    for (int n = 0; n < kN; ++n)
      data.C[m * kN + n] = ((m * 5 + n * 3 + seed) % 11) - 5;
  apply_dense_overflow_cases<Trait>(data);
  return data;
}

template <class Trait> std::vector<std::int32_t> dense_reference(const MatrixData<Trait> &data) {
  std::vector<std::int32_t> ref(kM * kN);
  for (int m = 0; m < kM; ++m)
    for (int n = 0; n < kN; ++n) {
      std::int64_t acc = data.C[m * kN + n];
      for (int k = 0; k < Trait::K; ++k)
        acc += static_cast<std::int64_t>(data.A[m * Trait::K + k]) * data.B[k * kN + n];
      if (m == 0 && n == 0)
        EXPECT_GT(acc, std::numeric_limits<std::int32_t>::max());
      if constexpr (Trait::ASigned)
        if (m == 1 && n == 0)
          EXPECT_LT(acc, std::numeric_limits<std::int32_t>::min());
      if constexpr (Trait::BSigned)
        if (m == 0 && n == 1)
          EXPECT_LT(acc, std::numeric_limits<std::int32_t>::min());
      const std::uint32_t bits =
          Trait::Clamp ? int_isa_test::clamp_i32_bits(acc) : static_cast<std::uint32_t>(acc);
      ref[m * kN + n] = static_cast<std::int32_t>(bits);
    }
  return ref;
}

template <class Trait, class InputLayout>
__device__ typename Trait::AFrag load_dense_a_frag(const std::int32_t *A, int lane) {
  typename Trait::AFrag frag = make_zero_frag<typename Trait::AFrag>();
  std::uint32_t words[Trait::AWords]{};
  const int row = lane & 15;
  for (int idx = 0; idx < Trait::AValuesPerLane; ++idx) {
    const int k = InputLayout::logical_index(lane, idx, Trait::K, Trait::AValuesPerLane);
    if (k < 0 || k >= Trait::K)
      continue;
    const int word = idx / Trait::ValuesPerWord;
    const int shift = (idx % Trait::ValuesPerWord) * Trait::Bits;
    words[word] |= packed_bits(A[row * Trait::K + k], Trait::Bits) << shift;
  }
  for (int word = 0; word < Trait::AWords; ++word)
    set_frag_word(frag, word, words[word]);
  return frag;
}

template <class Trait, class InputLayout>
__device__ typename Trait::BFrag load_dense_b_frag(const std::int32_t *B, int lane) {
  typename Trait::BFrag frag = make_zero_frag<typename Trait::BFrag>();
  std::uint32_t words[Trait::BWords]{};
  const int col = lane & 15;
  for (int idx = 0; idx < Trait::BValuesPerLane; ++idx) {
    const int k = InputLayout::logical_index(lane, idx, Trait::K, Trait::BValuesPerLane);
    if (k < 0 || k >= Trait::K)
      continue;
    const int word = idx / Trait::ValuesPerWord;
    const int shift = (idx % Trait::ValuesPerWord) * Trait::Bits;
    words[word] |= packed_bits(B[k * kN + col], Trait::Bits) << shift;
  }
  for (int word = 0; word < Trait::BWords; ++word)
    set_frag_word(frag, word, words[word]);
  return frag;
}

template <class Trait>
__device__ typename Trait::CFrag load_c_frag(const std::int32_t *C, int lane) {
  typename Trait::CFrag c{};
  const int col = lane & 15;
  for (int e = 0; e < Trait::CValuesPerLane; ++e)
    c[e] = C[cd_row_from_lane(lane, e) * kN + col];
  return c;
}

template <class Trait>
__device__ void store_d_frag(const typename Trait::CFrag &d, std::int32_t *D, int lane) {
  const int col = lane & 15;
  for (int e = 0; e < Trait::CValuesPerLane; ++e)
    D[cd_row_from_lane(lane, e) * kN + col] = d[e];
}

template <class Trait, class InputLayout>
__global__ void dense_matrix_kernel(const std::int32_t *A, const std::int32_t *B,
                                    const std::int32_t *C, std::int32_t *D) {
  const int lane = threadIdx.x;
  auto a = load_dense_a_frag<Trait, InputLayout>(A, lane);
  auto b = load_dense_b_frag<Trait, InputLayout>(B, lane);
  auto c = load_c_frag<Trait>(C, lane);
  store_d_frag<Trait>(Trait::call(a, b, c), D, lane);
}

template <class Trait, class InputLayout> void run_dense_matrix_case(int seed) {
  MatrixData<Trait> data = make_dense_inputs<Trait>(seed);
  std::vector<std::int32_t> ref = dense_reference<Trait>(data);
  auto dA = to_device(data.A);
  auto dB = to_device(data.B);
  auto dC = to_device(data.C);
  if (!dA || !dB || !dC)
    FAIL() << "failed to initialize matrix inputs on device";

  auto dD = allocate_device<std::int32_t>(ref.size());
  if (!dD)
    return;

  dense_matrix_kernel<Trait, InputLayout>
      <<<1, kWaveLanes>>>(dA.get(), dB.get(), dC.get(), dD.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());

  std::vector<std::int32_t> got(ref.size());
  HIP_CHECK(
      hipMemcpy(got.data(), dD.get(), got.size() * sizeof(std::int32_t), hipMemcpyDeviceToHost));
  for (std::size_t i = 0; i < ref.size(); ++i)
    EXPECT_EQ(static_cast<std::uint32_t>(got[i]), static_cast<std::uint32_t>(ref[i]))
        << Trait::Name << " asigned=" << Trait::ASigned << " bsigned=" << Trait::BSigned
        << " clamp=" << Trait::Clamp << " element " << i;
}

template <class Trait> struct SparseData {
  std::vector<std::int32_t> A;
  std::vector<std::int32_t> B;
  std::vector<std::int32_t> C;
  std::vector<std::uint32_t> idx;
  std::vector<std::int32_t> p0;
  std::vector<std::int32_t> p1;
};

template <class Trait> void set_sparse_a_row(SparseData<Trait> &data, int row, std::int32_t value) {
  for (int g = 0; g < Trait::Groups; ++g) {
    data.A[row * Trait::K + 4 * g + data.p0[row * Trait::Groups + g]] = value;
    data.A[row * Trait::K + 4 * g + data.p1[row * Trait::Groups + g]] = value;
  }
}

template <class Trait> void apply_sparse_overflow_cases(SparseData<Trait> &data) {
  set_sparse_a_row(data, 0, 1);
  for (int k = 0; k < Trait::K; ++k) {
    data.B[k * kN] = 1;
    if constexpr (Trait::BSigned)
      data.B[k * kN + 1] = -1;
  }
  data.C[0] = std::numeric_limits<std::int32_t>::max() - 4;

  if constexpr (Trait::ASigned) {
    set_sparse_a_row(data, 1, -1);
    data.C[kN] = std::numeric_limits<std::int32_t>::min() + 4;
  }
  if constexpr (Trait::BSigned)
    data.C[1] = std::numeric_limits<std::int32_t>::min() + 4;
}

constexpr int sparse_selector_pair(int row, int group, int seed) {
  // The first six groups provide directed coverage of every legal pair.
  // Remaining groups use a deterministic integer hash instead of the old
  // period-two sequence, which could preserve an incorrect K permutation.
  if (group < 6)
    return (row + group + seed) % 6;

  std::uint32_t value = static_cast<std::uint32_t>(seed) ^
                        (static_cast<std::uint32_t>(row) * 0x9e3779b9u) ^
                        (static_cast<std::uint32_t>(group) * 0x85ebca6bu);
  value ^= value >> 16;
  value *= 0x7feb352du;
  value ^= value >> 15;
  return static_cast<int>(value % 6u);
}

template <class Trait, class AInputLayout> SparseData<Trait> make_sparse_inputs(int seed) {
  SparseData<Trait> data;
  data.A.assign(kM * Trait::K, 0);
  data.B.resize(Trait::K * kN);
  data.C.resize(kM * kN);
  data.idx.assign(kWaveLanes * Trait::IndexWords, 0);
  data.p0.resize(kM * Trait::Groups);
  data.p1.resize(kM * Trait::Groups);

  for (int k = 0; k < Trait::K; ++k)
    for (int n = 0; n < kN; ++n)
      data.B[k * kN + n] = matrix_value(Trait::BSigned, Trait::Bits, k, n, seed + 17);
  for (int m = 0; m < kM; ++m)
    for (int n = 0; n < kN; ++n)
      data.C[m * kN + n] = ((m * 3 + n * 5 + seed) % 13) - 6;
  constexpr int selector_pairs[6][2] = {{0, 1}, {0, 2}, {0, 3}, {1, 2}, {1, 3}, {2, 3}};
  for (int m = 0; m < kM; ++m)
    for (int g = 0; g < Trait::Groups; ++g) {
      const int pair = sparse_selector_pair(m, g, seed);
      const int first = selector_pairs[pair][0];
      const int second = selector_pairs[pair][1];
      data.p0[m * Trait::Groups + g] = first;
      data.p1[m * Trait::Groups + g] = second;
      data.A[m * Trait::K + 4 * g + first] =
          matrix_value(Trait::ASigned, Trait::Bits, m, 4 * g + first, seed + 23);
      data.A[m * Trait::K + 4 * g + second] =
          matrix_value(Trait::ASigned, Trait::Bits, m, 4 * g + second, seed + 29);
    }

  apply_sparse_overflow_cases<Trait>(data);

  constexpr int kCompressedValuesPerLane = 2 * Trait::GroupsPerLane;
  constexpr int kCompressedValues = 2 * Trait::Groups;
  for (int lane = 0; lane < kWaveLanes; ++lane) {
    const int row = lane & 15;
    for (int slot = 0; slot < kCompressedValuesPerLane; ++slot) {
      const int compressed =
          AInputLayout::logical_index(lane, slot, kCompressedValues, kCompressedValuesPerLane);
      if (compressed < 0 || compressed >= kCompressedValues)
        continue;
      const int group = compressed / 2;
      const int selector = compressed & 1 ? data.p1[row * Trait::Groups + group]
                                          : data.p0[row * Trait::Groups + group];
      const int bit = 2 * slot;
      data.idx[lane * Trait::IndexWords + bit / 32] |= static_cast<std::uint32_t>(selector & 3)
                                                       << (bit % 32);
    }
  }
  return data;
}

template <class Trait> std::vector<std::int32_t> sparse_reference(const SparseData<Trait> &data) {
  std::vector<std::int32_t> ref(kM * kN);
  for (int m = 0; m < kM; ++m)
    for (int n = 0; n < kN; ++n) {
      std::int64_t acc = data.C[m * kN + n];
      for (int g = 0; g < Trait::Groups; ++g) {
        const int k0 = 4 * g + data.p0[m * Trait::Groups + g];
        const int k1 = 4 * g + data.p1[m * Trait::Groups + g];
        acc += static_cast<std::int64_t>(data.A[m * Trait::K + k0]) * data.B[k0 * kN + n];
        acc += static_cast<std::int64_t>(data.A[m * Trait::K + k1]) * data.B[k1 * kN + n];
      }
      if (m == 0 && n == 0)
        EXPECT_GT(acc, std::numeric_limits<std::int32_t>::max());
      if constexpr (Trait::ASigned)
        if (m == 1 && n == 0)
          EXPECT_LT(acc, std::numeric_limits<std::int32_t>::min());
      if constexpr (Trait::BSigned)
        if (m == 0 && n == 1)
          EXPECT_LT(acc, std::numeric_limits<std::int32_t>::min());
      const std::uint32_t bits =
          Trait::Clamp ? int_isa_test::clamp_i32_bits(acc) : static_cast<std::uint32_t>(acc);
      ref[m * kN + n] = static_cast<std::int32_t>(bits);
    }
  return ref;
}

template <class Trait, class AInputLayout>
__device__ typename Trait::AFrag load_sparse_a_frag(const std::int32_t *A, const std::int32_t *p0,
                                                    const std::int32_t *p1, int lane) {
  typename Trait::AFrag frag = make_zero_frag<typename Trait::AFrag>();
  std::uint32_t words[Trait::AWords]{};
  const int row = lane & 15;
  constexpr int kCompressedValuesPerLane = 2 * Trait::GroupsPerLane;
  constexpr int kCompressedValues = 2 * Trait::Groups;
  for (int slot = 0; slot < kCompressedValuesPerLane; ++slot) {
    const int compressed =
        AInputLayout::logical_index(lane, slot, kCompressedValues, kCompressedValuesPerLane);
    if (compressed < 0 || compressed >= kCompressedValues)
      continue;
    const int group = compressed / 2;
    const int selector =
        compressed & 1 ? p1[row * Trait::Groups + group] : p0[row * Trait::Groups + group];
    const int k = 4 * group + selector;
    const int word = slot / Trait::ValuesPerWord;
    const int shift = (slot % Trait::ValuesPerWord) * Trait::Bits;
    words[word] |= packed_bits(A[row * Trait::K + k], Trait::Bits) << shift;
  }
  for (int word = 0; word < Trait::AWords; ++word)
    set_frag_word(frag, word, words[word]);
  return frag;
}

template <class Trait, class BInputLayout>
__device__ typename Trait::BFrag load_sparse_b_frag(const std::int32_t *B, int lane) {
  typename Trait::BFrag frag = make_zero_frag<typename Trait::BFrag>();
  std::uint32_t words[Trait::BWords]{};
  const int col = lane & 15;
  for (int idx = 0; idx < Trait::BValuesPerLane; ++idx) {
    const int k = BInputLayout::logical_index(lane, idx, Trait::K, Trait::BValuesPerLane);
    if (k < 0 || k >= Trait::K)
      continue;
    const int word = idx / Trait::ValuesPerWord;
    const int shift = (idx % Trait::ValuesPerWord) * Trait::Bits;
    words[word] |= packed_bits(B[k * kN + col], Trait::Bits) << shift;
  }
  for (int word = 0; word < Trait::BWords; ++word)
    set_frag_word(frag, word, words[word]);
  return frag;
}

template <class Trait>
__device__ typename Trait::IndexFrag load_sparse_index(const std::uint32_t *idx, int lane) {
  typename Trait::IndexFrag frag = make_zero_frag<typename Trait::IndexFrag>();
  for (int word = 0; word < Trait::IndexWords; ++word)
    set_frag_word(frag, word, idx[lane * Trait::IndexWords + word]);
  return frag;
}

template <class Trait, class AInputLayout, class BInputLayout>
__global__ void sparse_matrix_kernel(const std::int32_t *A, const std::int32_t *B,
                                     const std::int32_t *C, const std::int32_t *p0,
                                     const std::int32_t *p1, const std::uint32_t *idx,
                                     std::int32_t *D) {
  const int lane = threadIdx.x;
  auto a = load_sparse_a_frag<Trait, AInputLayout>(A, p0, p1, lane);
  auto b = load_sparse_b_frag<Trait, BInputLayout>(B, lane);
  auto c = load_c_frag<Trait>(C, lane);
  auto index = load_sparse_index<Trait>(idx, lane);
  store_d_frag<Trait>(Trait::call(a, b, c, index), D, lane);
}

template <class Trait, class AInputLayout, class BInputLayout>
void run_sparse_matrix_case(int seed) {
  SparseData<Trait> data = make_sparse_inputs<Trait, AInputLayout>(seed);
  std::vector<std::int32_t> ref = sparse_reference<Trait>(data);
  auto dA = to_device(data.A);
  auto dB = to_device(data.B);
  auto dC = to_device(data.C);
  auto dP0 = to_device(data.p0);
  auto dP1 = to_device(data.p1);
  auto dIdx = to_device(data.idx);
  if (!dA || !dB || !dC || !dP0 || !dP1 || !dIdx)
    FAIL() << "failed to initialize sparse matrix inputs on device";

  auto dD = allocate_device<std::int32_t>(ref.size());
  if (!dD)
    return;

  sparse_matrix_kernel<Trait, AInputLayout, BInputLayout>
      <<<1, kWaveLanes>>>(dA.get(), dB.get(), dC.get(), dP0.get(), dP1.get(), dIdx.get(), dD.get());
  HIP_CHECK(hipGetLastError());
  HIP_CHECK(hipDeviceSynchronize());

  std::vector<std::int32_t> got(ref.size());
  HIP_CHECK(
      hipMemcpy(got.data(), dD.get(), got.size() * sizeof(std::int32_t), hipMemcpyDeviceToHost));
  for (std::size_t i = 0; i < ref.size(); ++i)
    EXPECT_EQ(static_cast<std::uint32_t>(got[i]), static_cast<std::uint32_t>(ref[i]))
        << Trait::Name << " asigned=" << Trait::ASigned << " bsigned=" << Trait::BSigned
        << " clamp=" << Trait::Clamp << " element " << i;
}

template <template <bool, bool, bool> class Trait, class InputLayout = ContiguousMatrixInputLayout>
void run_dense_matrix_modes(int seed) {
  run_dense_matrix_case<Trait<false, false, false>, InputLayout>(seed + 0);
  run_dense_matrix_case<Trait<false, false, true>, InputLayout>(seed + 1);
  run_dense_matrix_case<Trait<false, true, false>, InputLayout>(seed + 2);
  run_dense_matrix_case<Trait<false, true, true>, InputLayout>(seed + 3);
  run_dense_matrix_case<Trait<true, false, false>, InputLayout>(seed + 4);
  run_dense_matrix_case<Trait<true, false, true>, InputLayout>(seed + 5);
  run_dense_matrix_case<Trait<true, true, false>, InputLayout>(seed + 6);
  run_dense_matrix_case<Trait<true, true, true>, InputLayout>(seed + 7);
}

template <template <bool, bool, bool> class Trait, class AInputLayout = ContiguousMatrixInputLayout,
          class BInputLayout = ContiguousMatrixInputLayout>
void run_sparse_matrix_modes(int seed) {
  run_sparse_matrix_case<Trait<false, false, false>, AInputLayout, BInputLayout>(seed + 0);
  run_sparse_matrix_case<Trait<false, false, true>, AInputLayout, BInputLayout>(seed + 1);
  run_sparse_matrix_case<Trait<false, true, false>, AInputLayout, BInputLayout>(seed + 2);
  run_sparse_matrix_case<Trait<false, true, true>, AInputLayout, BInputLayout>(seed + 3);
  run_sparse_matrix_case<Trait<true, false, false>, AInputLayout, BInputLayout>(seed + 4);
  run_sparse_matrix_case<Trait<true, false, true>, AInputLayout, BInputLayout>(seed + 5);
  run_sparse_matrix_case<Trait<true, true, false>, AInputLayout, BInputLayout>(seed + 6);
  run_sparse_matrix_case<Trait<true, true, true>, AInputLayout, BInputLayout>(seed + 7);
}
} // namespace
