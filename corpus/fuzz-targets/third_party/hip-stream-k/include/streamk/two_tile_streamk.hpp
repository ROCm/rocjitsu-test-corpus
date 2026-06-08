/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <thrust/host_vector.h>
#include <thrust/device_vector.h>

#include <streamk/utils/macros.hpp>
#include <streamk/utils/shape.hpp>
#include <streamk/utils/device.hpp>
#include <streamk/utils/mfma.hpp>
#include <streamk/kernel/kernel_two_tile_streamk.hpp>

#include "../../benchmarks/timing.hpp"

namespace streamk {

template <typename input_t, typename output_t, typename compute_t>
double two_tile_streamk(uint32_t m,
                        uint32_t n,
                        uint32_t k,
                        input_t const* a,
                        input_t const* b,
                        input_t const* c,
                        output_t* d,
                        uint32_t lda,
                        uint32_t ldb,
                        uint32_t ldc,
                        uint32_t ldd,
                        compute_t alpha,
                        compute_t beta,
                        int grid,
                        int num_runs = 10,
                        int numWarmup = 2) {
  // Wavefront size (SIMD width).
  constexpr uint32_t WAVE_SIZE = streamk::Constants::AMDGCN_WAVE_SIZE;

  using THREAD_TILE = gemm_shape_t<2u, 2u>;
  using THREAD_BLOCK_SIZE = gemm_shape_t<2u * WAVE_SIZE, 2u>;
  using WMMA = gemm_shape_t<32u, 32u, 16u>;
  using NUM_WAVES =
      gemm_shape_t<THREAD_BLOCK_SIZE::M / WAVE_SIZE, THREAD_BLOCK_SIZE::N>;
  using WAVE_TILE =
      gemm_shape_t<(THREAD_TILE::M * WMMA::M), (THREAD_TILE::N * WMMA::N)>;
  using MACRO_TILE = gemm_shape_t<WAVE_TILE::M * NUM_WAVES::M,
                                  WAVE_TILE::N * NUM_WAVES::N, WMMA::K>;

  // Misc. allocations.
  // Flags are initialised to 1 ("locked"); helper CTAs call `unlock` (writes
  // 0) after publishing partials, and owners spin via `wait_for_unlock`. They
  // must be reset to 1 before every launch.
  thrust::device_vector<int> flags(grid, 1);
  thrust::device_vector<compute_t> partials(
      grid * MACRO_TILE::M * MACRO_TILE::N, static_cast<compute_t>(0.f));

  dim3 dimBlock(THREAD_BLOCK_SIZE::M, THREAD_BLOCK_SIZE::N);
  dim3 dimGrid(grid);

  auto reset_flags = [&]() {
    thrust::fill(flags.begin(), flags.end(), 1);
  };

  for (int i = 0; i < numWarmup; i++) {
    reset_flags();
    hipExtLaunchKernelGGL(
        two_tile_streamk_kernel<WAVE_SIZE, THREAD_BLOCK_SIZE::MNK, MACRO_TILE,
                                WMMA, WAVE_TILE, NUM_WAVES, THREAD_TILE,
                                input_t, output_t, compute_t>,
        dimGrid, dimBlock, 0, 0, nullptr, nullptr, 0, m, n, k, a, b, c, d, m, n,
        m, m, alpha, beta, flags.data().get(), partials.data().get());
  }

  auto elapsedTimeUs = get_time_us_sync_device();

  for (int i = 0; i < num_runs; i++) {
    reset_flags();
    hipExtLaunchKernelGGL(
        two_tile_streamk_kernel<WAVE_SIZE, THREAD_BLOCK_SIZE::MNK, MACRO_TILE,
                                WMMA, WAVE_TILE, NUM_WAVES, THREAD_TILE,
                                input_t, output_t, compute_t>,
        dimGrid, dimBlock, 0, 0, nullptr, nullptr, 0, m, n, k, a, b, c, d, m, n,
        m, m, alpha, beta, flags.data().get(), partials.data().get());
  }
  elapsedTimeUs = get_time_us_sync_device() - elapsedTimeUs;
  return elapsedTimeUs / num_runs;
}

}  // namespace streamk