/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <hip/hip_ext.h>
#include <hip/hip_fp16.h>
#include <hip/hip_runtime.h>

#include <streamk/device/device_common.hpp>
#include <streamk/utils/mfma.hpp>

namespace streamk {

// The partials buffer is treated as a sequence of per-CTA macro tiles, each of
// shape MACRO_TILE::M x MACRO_TILE::N stored in column-major order.  This
// matches the canonical accumulator data-layout (DataLayoutC == col_major).

/**
 * @brief Store this CTA's accumulator fragments into the per-CTA slot of the
 * partials buffer so that each lane writes the cells it actually owns.
 */
template <typename BLOCKS,
          typename MACRO_TILE,
          typename WMMA,
          uint32_t WAVE_SIZE,
          typename WAVE_TILE,
          typename compute_t>
__device__ inline void store_partials(
    compute_t* partials,
    int cta_index,
    fragment<accumulator, WMMA::M, WMMA::N, WMMA::K, compute_t> const (
        &acc)[BLOCKS::M][BLOCKS::N]) {
  const uint32_t ld = MACRO_TILE::M;
  compute_t* base =
      partials + static_cast<size_t>(cta_index) * MACRO_TILE::M * MACRO_TILE::N;

  auto waveCoord = local_wave_offset<WAVE_SIZE, WAVE_TILE>();
  const uint32_t waveRow = get<0>(waveCoord);
  const uint32_t waveCol = get<1>(waveCoord);

#pragma unroll
  for (uint32_t i = 0; i < BLOCKS::M; ++i) {
    const uint32_t rowOff = waveRow + i * WMMA::M;
#pragma unroll
    for (uint32_t j = 0; j < BLOCKS::N; ++j) {
      const uint32_t colOff = waveCol + j * WMMA::N;
      // col-major: address = base + row + col * ld
      compute_t* addr = base + rowOff + static_cast<size_t>(colOff) * ld;

#pragma unroll
      for (uint32_t k = 0; k < acc[i][j].num_elements; ++k) {
        uint32_t row;
        uint32_t col;
        detail::accumulator_coord(k, row, col);
        addr[row + static_cast<size_t>(col) * ld] = acc[i][j].x[k];
      }
    }
  }
}

/**
 * @brief Load partials from another CTA's slot and add into this CTA's
 * accumulator.
 */
template <typename BLOCKS,
          typename MACRO_TILE,
          typename WMMA,
          uint32_t WAVE_SIZE,
          typename WAVE_TILE,
          typename compute_t>
__device__ static inline void fixup_partials(
    const compute_t* partials,
    int cta_index,
    fragment<accumulator, WMMA::M, WMMA::N, WMMA::K, compute_t> (
        &acc)[BLOCKS::M][BLOCKS::N]) {
  const uint32_t ld = MACRO_TILE::M;
  const compute_t* base = partials + static_cast<size_t>(cta_index) *
                                         MACRO_TILE::M * MACRO_TILE::N;

  auto waveCoord = local_wave_offset<WAVE_SIZE, WAVE_TILE>();
  const uint32_t waveRow = get<0>(waveCoord);
  const uint32_t waveCol = get<1>(waveCoord);

#pragma unroll
  for (uint32_t i = 0; i < BLOCKS::M; ++i) {
    const uint32_t rowOff = waveRow + i * WMMA::M;
#pragma unroll
    for (uint32_t j = 0; j < BLOCKS::N; ++j) {
      const uint32_t colOff = waveCol + j * WMMA::N;
      const compute_t* addr =
          base + rowOff + static_cast<size_t>(colOff) * ld;

#pragma unroll
      for (uint32_t k = 0; k < acc[i][j].num_elements; ++k) {
        uint32_t row;
        uint32_t col;
        detail::accumulator_coord(k, row, col);
        acc[i][j].x[k] += addr[row + static_cast<size_t>(col) * ld];
      }
    }
  }
}

}  // namespace streamk
