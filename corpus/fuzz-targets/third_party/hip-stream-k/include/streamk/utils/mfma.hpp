#pragma once

#include <cstddef>
#include <cstdint>
#include <type_traits>

#include <hip/hip_fp16.h>
#include <hip/hip_runtime.h>

namespace streamk {

using float16_t = _Float16;
using float32_t = float;

struct matrix_a {};
struct matrix_b {};
struct accumulator {};
struct row_major {};
struct col_major {};

struct coord2d {
  uint32_t x;
  uint32_t y;
};

__host__ __device__ constexpr coord2d make_coord2d(uint32_t x, uint32_t y) {
  return {x, y};
}

template <int I>
__host__ __device__ constexpr uint32_t get(coord2d c) {
  static_assert(I == 0 || I == 1);
  if constexpr (I == 0) {
    return c.x;
  } else {
    return c.y;
  }
}

__host__ __device__ constexpr coord2d operator+(coord2d lhs, coord2d rhs) {
  return {lhs.x + rhs.x, lhs.y + rhs.y};
}

struct Constants {
  static constexpr uint32_t AMDGCN_WAVE_SIZE = 64;
};

namespace detail {

template <typename T>
struct input_values_per_thread;

template <>
struct input_values_per_thread<float32_t> {
  static constexpr uint32_t value(uint32_t k) { return k / 2; }
};

template <>
struct input_values_per_thread<float16_t> {
  static constexpr uint32_t value(uint32_t k) { return k / 2; }
};

template <typename T, uint32_t M, uint32_t N>
struct accumulator_values_per_thread {
  static constexpr uint32_t value = (M * N) / Constants::AMDGCN_WAVE_SIZE;
};

template <typename T>
__device__ inline T zero_value() {
  return static_cast<T>(0);
}

template <typename T>
__device__ inline uint32_t matrix_offset(uint32_t row, uint32_t col,
                                         uint32_t ld) {
  if constexpr (std::is_same_v<T, row_major>) {
    return row * ld + col;
  } else {
    return row + col * ld;
  }
}

__device__ inline uint32_t lane_id() {
  return threadIdx.x & (Constants::AMDGCN_WAVE_SIZE - 1);
}

__device__ inline void accumulator_coord(uint32_t elem, uint32_t& row,
                                         uint32_t& col) {
  const uint32_t lane = lane_id();
  row = (elem & 3u) + 4u * (lane >> 5) + 8u * (elem >> 2);
  col = lane & 31u;
}

using f32x16_t = float __attribute__((ext_vector_type(16)));
using f16x4_t = _Float16 __attribute__((ext_vector_type(4)));

}  // namespace detail

template <typename MatrixT,
          uint32_t BlockM,
          uint32_t BlockN,
          uint32_t BlockK,
          typename DataT,
          typename DataLayoutT = void,
          bool Transposed = false>
struct fragment {
  using matrix_type = MatrixT;
  using data_type = DataT;
  using layout_type = DataLayoutT;

  static constexpr uint32_t M = BlockM;
  static constexpr uint32_t N = BlockN;
  static constexpr uint32_t K = BlockK;
  static constexpr bool transposed = Transposed;

  static constexpr uint32_t BlockHeight =
      std::is_same_v<MatrixT, matrix_a>
          ? BlockM
          : (std::is_same_v<MatrixT, matrix_b> ? (Transposed ? BlockN : BlockK)
                                               : BlockM);
  static constexpr uint32_t BlockWidth =
      std::is_same_v<MatrixT, matrix_a>
          ? BlockK
          : (std::is_same_v<MatrixT, matrix_b> ? (Transposed ? BlockK : BlockN)
                                               : BlockN);
  static constexpr uint32_t InputElements =
      std::is_same_v<MatrixT, accumulator>
          ? 0u
          : detail::input_values_per_thread<DataT>::value(BlockK);
  static constexpr uint32_t AccElements =
      std::is_same_v<MatrixT, accumulator>
          ? detail::accumulator_values_per_thread<DataT, BlockM, BlockN>::value
          : 0u;
  static constexpr uint32_t num_elements =
      (InputElements > AccElements ? InputElements : AccElements);

  DataT x[num_elements == 0 ? 1 : num_elements];
};

template <typename FragT>
using GetDataType_t = typename FragT::data_type;

template <typename FragT>
struct GetIOShape {
  static constexpr uint32_t BlockHeight = FragT::BlockHeight;
  static constexpr uint32_t BlockWidth = FragT::BlockWidth;
};

template <typename FragT>
using GetIOShape_t = GetIOShape<FragT>;

template <typename FragT>
struct GetDataLayout {
  __host__ __device__ static constexpr uint32_t fromMatrixCoord(coord2d coord,
                                                                uint32_t ld) {
    return detail::matrix_offset<typename FragT::layout_type>(coord.x, coord.y,
                                                              ld);
  }
};

template <typename FragT>
using GetDataLayout_t = GetDataLayout<FragT>;

template <typename FragT>
struct GetIOTraits {
  static constexpr uint32_t IOCount = FragT::num_elements;
};

template <typename FragT>
using GetIOTraits_t = GetIOTraits<FragT>;

template <typename FragT, typename NewLayoutT>
struct ApplyDataLayout;

template <typename MatrixT,
          uint32_t BlockM,
          uint32_t BlockN,
          uint32_t BlockK,
          typename DataT,
          typename OldLayoutT,
          bool Transposed,
          typename NewLayoutT>
struct ApplyDataLayout<
    fragment<MatrixT, BlockM, BlockN, BlockK, DataT, OldLayoutT, Transposed>,
    NewLayoutT> {
  using type =
      fragment<MatrixT, BlockM, BlockN, BlockK, DataT, NewLayoutT, Transposed>;
};

template <typename FragT, typename NewLayoutT>
using ApplyDataLayout_t = typename ApplyDataLayout<FragT, NewLayoutT>::type;

template <typename FragT>
struct ApplyTranspose;

template <typename MatrixT,
          uint32_t BlockM,
          uint32_t BlockN,
          uint32_t BlockK,
          typename DataT,
          typename LayoutT,
          bool Transposed>
struct ApplyTranspose<
    fragment<MatrixT, BlockM, BlockN, BlockK, DataT, LayoutT, Transposed>> {
  using type =
      fragment<MatrixT, BlockM, BlockN, BlockK, DataT, LayoutT, !Transposed>;
};

template <typename FragT>
using ApplyTranspose_t = typename ApplyTranspose<FragT>::type;

template <typename NewLayoutT, typename FragT>
__device__ inline ApplyDataLayout_t<FragT, NewLayoutT> applyDataLayout(
    FragT const& frag) {
  ApplyDataLayout_t<FragT, NewLayoutT> out;
#pragma unroll
  for (uint32_t i = 0; i < FragT::num_elements; ++i) {
    out.x[i] = frag.x[i];
  }
  return out;
}

template <typename FragT>
__device__ inline ApplyTranspose_t<FragT> applyTranspose(FragT const& frag) {
  ApplyTranspose_t<FragT> out;
#pragma unroll
  for (uint32_t i = 0; i < FragT::num_elements; ++i) {
    out.x[i] = frag.x[i];
  }
  return out;
}

template <typename FragT, typename DataT>
__device__ inline void fill_fragment(FragT& frag, DataT value) {
#pragma unroll
  for (uint32_t i = 0; i < FragT::num_elements; ++i) {
    frag.x[i] = static_cast<typename FragT::data_type>(value);
  }
}

template <typename FragT, typename DataT>
__device__ inline void load_matrix_sync(FragT& frag, DataT const* data,
                                        uint32_t ld) {
  static_assert(std::is_same_v<typename FragT::matrix_type, accumulator>);
#pragma unroll
  for (uint32_t i = 0; i < FragT::num_elements; ++i) {
    uint32_t row;
    uint32_t col;
    detail::accumulator_coord(i, row, col);
    frag.x[i] = static_cast<typename FragT::data_type>(
        data[detail::matrix_offset<typename FragT::layout_type>(row, col, ld)]);
  }
}

template <typename DataT, typename FragT>
__device__ inline void store_matrix_sync(DataT* data, FragT const& frag,
                                         uint32_t ld) {
  static_assert(std::is_same_v<typename FragT::matrix_type, accumulator>);
#pragma unroll
  for (uint32_t i = 0; i < FragT::num_elements; ++i) {
    uint32_t row;
    uint32_t col;
    detail::accumulator_coord(i, row, col);
    data[detail::matrix_offset<typename FragT::layout_type>(row, col, ld)] =
        static_cast<DataT>(frag.x[i]);
  }
}

}  // namespace streamk
