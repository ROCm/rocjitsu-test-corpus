/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <hip/hip_ext.h>
#include <hip/hip_fp16.h>
#include <hip/hip_runtime.h>

#include <streamk/utils/mfma.hpp>

namespace streamk {

/**
 * @brief Performs a warp tile MFMA.
 *
 * @tparam BLOCKS
 * @tparam WMMA
 * @tparam input_t
 * @tparam compute_t
 * @tparam layout_a_t
 * @tparam layout_b_t
 * @return __device__
 */
template <typename BLOCKS,
          typename WMMA,
          typename input_t,
          typename compute_t,
          typename layout_a_t,
          typename layout_b_t>
__device__ static inline void mfma(
    fragment<accumulator, WMMA::M, WMMA::N, WMMA::K, compute_t> (
        &out)[BLOCKS::M][BLOCKS::N],
    fragment<matrix_a, WMMA::M, WMMA::N, WMMA::K, input_t, layout_a_t> const (
        &a)[BLOCKS::M],
    fragment<matrix_b, WMMA::M, WMMA::N, WMMA::K, input_t, layout_b_t> const (
        &b)[BLOCKS::N],
    fragment<accumulator, WMMA::M, WMMA::N, WMMA::K, compute_t> const (
        &in)[BLOCKS::M][BLOCKS::N]) {
#pragma unroll
  for (int i = 0; i < BLOCKS::M; i++) {
#pragma unroll
    for (int j = 0; j < BLOCKS::N; j++) {
      detail::f32x16_t acc =
          *reinterpret_cast<detail::f32x16_t const*>(in[i][j].x);
      if constexpr (std::is_same_v<input_t, float32_t>) {
#pragma unroll
        for (uint32_t k = 0; k < WMMA::K / 2; ++k) {
          acc = __builtin_amdgcn_mfma_f32_32x32x2f32(a[i].x[k], b[j].x[k],
                                                     acc, 0, 0, 0);
        }
      } else {
#pragma unroll
        for (uint32_t k = 0; k < WMMA::K / 8; ++k) {
          detail::f16x4_t av = {a[i].x[k * 4], a[i].x[k * 4 + 1],
                                a[i].x[k * 4 + 2], a[i].x[k * 4 + 3]};
          detail::f16x4_t bv = {b[j].x[k * 4], b[j].x[k * 4 + 1],
                                b[j].x[k * 4 + 2], b[j].x[k * 4 + 3]};
          acc = __builtin_amdgcn_mfma_f32_32x32x8f16(av, bv, acc, 0, 0, 0);
        }
      }
      *reinterpret_cast<detail::f32x16_t*>(out[i][j].x) = acc;
    }
  }
}

/**
 * @brief Performs D = alpha * acc + beta * C, where alpha, beta are uniform
 * scalars.
 *
 * @tparam BLOCKS
 * @tparam WMMA
 * @tparam output_t
 * @tparam compute_t
 * @tparam layout_c_t
 * @tparam layout_d_t
 * @param alpha
 * @param beta
 * @return __device__
 */
template <typename BLOCKS,
          typename WMMA,
          typename output_t,
          typename compute_t,
          typename layout_c_t,
          typename layout_d_t>
__device__ void fma(
    fragment<accumulator, WMMA::M, WMMA::N, WMMA::K, output_t, layout_d_t> (
        &d)[BLOCKS::M][BLOCKS::N],
    compute_t alpha,
    fragment<accumulator, WMMA::M, WMMA::N, WMMA::K, compute_t> const (
        &acc)[BLOCKS::M][BLOCKS::N],
    compute_t beta,
    fragment<accumulator,
             WMMA::M,
             WMMA::N,
             WMMA::K,
             output_t,
             layout_c_t> const (&c)[BLOCKS::M][BLOCKS::N]) {
#pragma unroll
  for (int i = 0; i < BLOCKS::M; i++) {
#pragma unroll
    for (int j = 0; j < BLOCKS::N; j++) {
      for (int k = 0; k < d[i][j].num_elements; k++) {
        // Perform computation in compute type and cast back to output type.
        d[i][j].x[k] =
            static_cast<output_t>(alpha * acc[i][j].x[k] +
                                  beta * static_cast<compute_t>(c[i][j].x[k]));
      }
    }
  }
}

/**
 * @brief For beta = 0, Performs D = alpha * acc, where alpha is uniform a
 * scalar.
 *
 * @tparam BLOCKS
 * @tparam WMMA
 * @tparam output_t
 * @tparam compute_t
 * @tparam layout_d_t
 * @param alpha
 * @return __device__
 */
template <typename BLOCKS,
          typename WMMA,
          typename output_t,
          typename compute_t,
          typename layout_d_t>
__device__ void fma(
    fragment<accumulator, WMMA::M, WMMA::N, WMMA::K, output_t, layout_d_t> (
        &d)[BLOCKS::M][BLOCKS::N],
    compute_t alpha,
    fragment<accumulator, WMMA::M, WMMA::N, WMMA::K, compute_t> const (
        &acc)[BLOCKS::M][BLOCKS::N]) {
#pragma unroll
  for (int i = 0; i < BLOCKS::M; i++) {
#pragma unroll
    for (int j = 0; j < BLOCKS::N; j++) {
      for (int k = 0; k < d[i][j].num_elements; k++) {
        // Perform computation in compute type and cast back to output type.
        d[i][j].x[k] = static_cast<output_t>(alpha * acc[i][j].x[k]);
      }
    }
  }
}

}  // namespace streamk