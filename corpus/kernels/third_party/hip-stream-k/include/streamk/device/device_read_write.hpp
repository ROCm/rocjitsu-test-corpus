/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <cassert>
#include <type_traits>

#include <hip/hip_ext.h>
#include <hip/hip_fp16.h>
#include <hip/hip_runtime.h>

#include <streamk/utils/mfma.hpp>

namespace streamk {

template <typename BLOCKS, typename fragment_t, typename output_t>
__device__ static inline void global_read(
    fragment_t (&frag)[BLOCKS::M][BLOCKS::N],
    output_t const* address,
    uint32_t ld) {
  using FragShape = GetIOShape_t<fragment_t>;
  using Mapper1d = GetDataLayout_t<fragment_t>;

  // Iterative offsets for each C block in the wave tile
  auto blockStepX =
      Mapper1d::fromMatrixCoord(make_coord2d(FragShape::BlockHeight, 0u), ld);
  auto blockStepY =
      Mapper1d::fromMatrixCoord(make_coord2d(0u, FragShape::BlockWidth), ld);

#pragma unroll
  for (int i = 0; i < BLOCKS::M; i++) {
    auto offsetY = 0u;
#pragma unroll
    for (int j = 0; j < BLOCKS::N; j++) {
      load_matrix_sync(frag[i][j], address + offsetY, ld);
      offsetY += blockStepY;
    }
    address += blockStepX;
  }
}

// Global D reads for warp tile gemm, non-cooperative
template <typename BLOCKS, typename fragment_t, typename output_t>
__device__ static inline void global_write(
    output_t* address,
    fragment_t const (&frag)[BLOCKS::M][BLOCKS::N],
    uint32_t ld) {
  using FragShape = GetIOShape_t<fragment_t>;
  using Mapper1d = GetDataLayout_t<fragment_t>;

  // Iterative offsets for each D block in the warp tile
  auto blockStepX =
      Mapper1d::fromMatrixCoord(make_coord2d(FragShape::BlockHeight, 0u), ld);
  auto blockStepY =
      Mapper1d::fromMatrixCoord(make_coord2d(0u, FragShape::BlockWidth), ld);

#pragma unroll
  for (int i = 0; i < BLOCKS::M; i++) {
    auto offsetY = 0u;
#pragma unroll
    for (int j = 0; j < BLOCKS::N; j++) {
      store_matrix_sync(address + offsetY, frag[i][j], ld);
      offsetY += blockStepY;
    }
    address += blockStepX;
  }
}

// Global reads in cooperative mode (macro tile)
template <uint32_t WaveCount,
          uint32_t SplitCount,
          typename fragment_t,
          typename input_t>
__device__ static inline void global_read_cooperative(fragment_t& frag,
                                                      input_t const* address,
                                                      uint32_t ld,
                                                      uint32_t wave_index) {
  constexpr uint32_t element_count =
      fragment_t::BlockHeight * fragment_t::BlockWidth;
  const uint32_t lane = threadIdx.x & (streamk::Constants::AMDGCN_WAVE_SIZE - 1);
  const uint32_t coop_lane = wave_index * streamk::Constants::AMDGCN_WAVE_SIZE + lane;
  constexpr uint32_t coop_threads = WaveCount * streamk::Constants::AMDGCN_WAVE_SIZE;

#pragma unroll
  for (uint32_t i = 0; i < fragment_t::num_elements; ++i) {
    const uint32_t idx = coop_lane + i * coop_threads;
    if (idx < element_count) {
      const uint32_t row = idx / fragment_t::BlockWidth;
      const uint32_t col = idx - row * fragment_t::BlockWidth;
      frag.x[i] =
          address[detail::matrix_offset<typename fragment_t::layout_type>(
              row, col, ld)];
    }
  }
}

/**
 * @brief
 *
 * @tparam WaveCount
 * @tparam SplitCount
 * @tparam fragment_t
 * @tparam input_t
 * @param lds_address
 * @param frag LDS data layout applied fragment.
 * @param WMMA_K
 * @param waveIndex
 * @return __device__
 */
template <uint32_t WaveCount,
          uint32_t SplitCount,
          typename fragment_t,
          typename input_t>
__device__ static inline void local_write_cooperative(input_t* lds_address,
                                                      fragment_t const& frag,
                                                      uint32_t WMMA_K,
                                                      uint32_t wave_index) {
  const uint32_t lane = threadIdx.x & (streamk::Constants::AMDGCN_WAVE_SIZE - 1);
  const uint32_t coop_lane = wave_index * streamk::Constants::AMDGCN_WAVE_SIZE + lane;
  constexpr uint32_t coop_threads = WaveCount * streamk::Constants::AMDGCN_WAVE_SIZE;

  if constexpr (fragment_t::transposed &&
                std::is_same_v<typename fragment_t::matrix_type, matrix_b>) {
    constexpr uint32_t original_height = fragment_t::K;
    constexpr uint32_t original_width = fragment_t::N;
    constexpr uint32_t element_count = original_height * original_width;
#pragma unroll
    for (uint32_t i = 0; i < fragment_t::num_elements; ++i) {
      const uint32_t idx = coop_lane + i * coop_threads;
      if (idx < element_count) {
        const uint32_t k = idx / original_width;
        const uint32_t n = idx - k * original_width;
        lds_address[n * WMMA_K + k] = frag.x[i];
      }
    }
  } else {
    constexpr uint32_t element_count =
        fragment_t::BlockHeight * fragment_t::BlockWidth;
#pragma unroll
    for (uint32_t i = 0; i < fragment_t::num_elements; ++i) {
      const uint32_t idx = coop_lane + i * coop_threads;
      if (idx < element_count) {
        const uint32_t row = idx / fragment_t::BlockWidth;
        const uint32_t col = idx - row * fragment_t::BlockWidth;
        lds_address[row * WMMA_K + col] = frag.x[i];
      }
    }
  }
}

/**
 * @brief Local reads for warp tile GEMM, non-cooperative.
 *
 * @tparam TRANSPOSED
 * @tparam BLOCKS
 * @tparam fragment_t
 * @tparam input_t
 * @tparam data_layout_t
 * @param lds_address
 * @return __device__
 */
template <bool TRANSPOSED,
          uint32_t BLOCKS_X,
          uint32_t WMMA_K,
          typename lds_data_layout_t,
          typename fragment_data_layout_t,
          typename fragment_t,
          typename input_t,
          std::enable_if_t<TRANSPOSED == false, int> = 0>
__device__ static inline void local_read(fragment_t (&f)[BLOCKS_X],
                                         input_t const* lds_address) {
  const uint32_t lane = threadIdx.x & (streamk::Constants::AMDGCN_WAVE_SIZE - 1);
  const uint32_t dim = lane & 31u;
  const uint32_t k_group = lane >> 5;

#pragma unroll
  for (int i = 0; i < BLOCKS_X; i++) {
    if constexpr (std::is_same_v<input_t, float32_t>) {
#pragma unroll
      for (uint32_t k = 0; k < WMMA_K / 2; ++k) {
        f[i].x[k] = lds_address[dim * WMMA_K + k * 2 + k_group];
      }
    } else {
#pragma unroll
      for (uint32_t k = 0; k < WMMA_K / 8; ++k) {
#pragma unroll
        for (uint32_t v = 0; v < 4; ++v) {
          f[i].x[k * 4 + v] =
              lds_address[dim * WMMA_K + k * 8 + k_group * 4 + v];
        }
      }
    }

    lds_address += fragment_t::M * WMMA_K;
  }
}

template <bool TRANSPOSED,
          uint32_t BLOCKS_X,
          uint32_t WMMA_K,
          typename lds_data_layout_t,
          typename fragment_data_layout_t,
          typename fragment_t,
          typename input_t,
          std::enable_if_t<TRANSPOSED == true, int> = 0>
__device__ static inline void local_read(fragment_t (&f)[BLOCKS_X],
                                         input_t const* lds_address) {
  const uint32_t lane = threadIdx.x & (streamk::Constants::AMDGCN_WAVE_SIZE - 1);
  const uint32_t dim = lane & 31u;
  const uint32_t k_group = lane >> 5;

#pragma unroll
  for (int i = 0; i < BLOCKS_X; i++) {
    if constexpr (std::is_same_v<input_t, float32_t>) {
#pragma unroll
      for (uint32_t k = 0; k < WMMA_K / 2; ++k) {
        f[i].x[k] = lds_address[dim * WMMA_K + k * 2 + k_group];
      }
    } else {
#pragma unroll
      for (uint32_t k = 0; k < WMMA_K / 8; ++k) {
#pragma unroll
        for (uint32_t v = 0; v < 4; ++v) {
          f[i].x[k * 4 + v] =
              lds_address[dim * WMMA_K + k * 8 + k_group * 4 + v];
        }
      }
    }

    lds_address += fragment_t::N * WMMA_K;
  }
}

}  // namespace streamk