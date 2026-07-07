/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <streamk/utils/math.hpp>
#include <streamk/utils/mfma.hpp>

namespace streamk {

/**
 * @brief
 *
 * @tparam WAVE_SIZE
 * @tparam WAVES_Y
 * @return __device__
 */
template <uint32_t WAVE_SIZE, uint32_t WAVES_Y>
__device__ static inline int wave_index() {
  return (threadIdx.x / WAVE_SIZE) * WAVES_Y + threadIdx.y;
}

/**
 * @brief
 *
 * @tparam MACRO_TILE
 * @param tile_index
 * @param n
 * @return __device__
 */
template <typename MACRO_TILE>
__device__ static inline auto macro_tile_coordinate(const int tile_index,
                                                    const uint32_t n) {
  return make_coord2d(
      (tile_index /
       (static_cast<int>(std::ceil(static_cast<float>(n) /
                                   static_cast<float>(MACRO_TILE::N))))) *
          MACRO_TILE::M,
      (tile_index %
       (static_cast<int>(std::ceil(static_cast<float>(n) /
                                   static_cast<float>(MACRO_TILE::N))))) *
          MACRO_TILE::N);
}

/**
 * @brief
 *
 * @tparam WAVE_SIZE
 * @tparam WAVE_TILE
 * @return __device__
 */
template <uint32_t WAVE_SIZE, typename WAVE_TILE>
__device__ static inline auto local_wave_offset() {
  return make_coord2d((threadIdx.x / WAVE_SIZE) * WAVE_TILE::M,
                      threadIdx.y * WAVE_TILE::N);
}

/**
 * @brief
 *
 * @tparam MACRO_TILE
 * @param m
 * @param n
 * @param k
 * @return uint32_t
 */
template <typename MACRO_TILE>
__host__ __device__ constexpr uint32_t total_iterations(const uint32_t m,
                                                        const uint32_t n,
                                                        const uint32_t k) {
  return static_cast<uint32_t>(
      math::ceil_div(m, MACRO_TILE::M) *  // m/MACRO_TILE::M
      math::ceil_div(n, MACRO_TILE::N) *  // n/MACRO_TILE::N
      math::ceil_div(k, MACRO_TILE::K)    // k/MACRO_TILE::K
  );
}

template <uint32_t MACRO_TILE_K>
__host__ __device__ constexpr uint32_t iterations_per_tile(const uint32_t k) {
  return math::ceil_div(k, MACRO_TILE_K);
}

template <typename MACRO_TILE>
__device__ constexpr uint32_t number_of_output_tiles(const uint32_t m,
                                                     const uint32_t n) {
  return math::ceil_div(m, MACRO_TILE::M) *  // m/MACRO_TILE::M
         math::ceil_div(n, MACRO_TILE::N);   // n/MACRO_TILE::N
}

/**
 * @brief
 *
 * @tparam MACRO_TILE
 * @param m
 * @param n
 * @param k
 * @return __device__ constexpr
 */
template <typename MACRO_TILE>
__device__ constexpr uint32_t extra_iterations(const uint32_t m,
                                               const uint32_t n,
                                               const uint32_t k) {
  return static_cast<uint32_t>(total_iterations<MACRO_TILE>(m, n, k) %
                               (gridDim.x));
}

template <typename MACRO_TILE>
__host__ constexpr uint32_t extra_iterations(const uint32_t m,
                                             const uint32_t n,
                                             const uint32_t k,
                                             const uint32_t grid_size) {
  return static_cast<uint32_t>(total_iterations<MACRO_TILE>(m, n, k) %
                               grid_size);
}

template <typename MACRO_TILE>
__device__ constexpr uint32_t iterations_per_cta(const uint32_t m,
                                                 const uint32_t n,
                                                 const uint32_t k,
                                                 const uint32_t cta_index) {
  uint32_t retval =
      static_cast<uint32_t>(total_iterations<MACRO_TILE>(m, n, k) / gridDim.x);

  int extraIters = extra_iterations<MACRO_TILE>(m, n, k);
  if (extraIters != 0) {
    if (cta_index < extraIters) {
      retval += 1;
    }
  }

  return retval;
}

template <typename MACRO_TILE>
__device__ constexpr uint32_t iterations_per_cta(const uint32_t m,
                                                 const uint32_t n,
                                                 const uint32_t k) {
  return iterations_per_cta<MACRO_TILE>(m, n, k, gridDim.x);
}

template <typename MACRO_TILE>
__device__ constexpr uint32_t ceil_iterations_per_cta(const uint32_t m,
                                                      const uint32_t n,
                                                      const uint32_t k) {
  return static_cast<uint32_t>(
      math::ceil_div(total_iterations<MACRO_TILE>(m, n, k), gridDim.x));
}

template <typename MACRO_TILE>
__host__ constexpr uint32_t ceil_iterations_per_cta(const uint32_t m,
                                                    const uint32_t n,
                                                    const uint32_t k,
                                                    const uint32_t grid_size) {
  return static_cast<uint32_t>(
      math::ceil_div(total_iterations<MACRO_TILE>(m, n, k), grid_size));
}

}  // namespace streamk