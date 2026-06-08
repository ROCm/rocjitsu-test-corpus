/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <thrust/host_vector.h>
#include <thrust/device_vector.h>

#include <streamk/schedule/streamk.hpp>
#include <streamk/utils/macros.hpp>
#include <streamk/utils/shape.hpp>
#include <streamk/utils/device.hpp>
#include <streamk/utils/mfma.hpp>
#include <streamk/kernel/kernel_simple_streamk.hpp>
#include "../../benchmarks/timing.hpp"

namespace streamk {

template <typename input_t, typename output_t, typename compute_t>
double simple_streamk(uint32_t m,
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

  // No clear documentation on how large Thread tile for X, Y could be.
  // THREAD_TILE::X * WMMA::M must be the WAVE's tile size.
  // 2u here implies it will process 2x the data per wave.
  using THREAD_TILE = gemm_shape_t<2u, 2u>;

  // Keep the original hip-stream-k four-wave thread-block shape.
  // WS = Wave Size
  // <WS, 1>
  // <WS, 2>
  // <WS, 4>
  // <WS * 2, 1>
  // <WS * 2, 2> <== [Selected]
  // <WS * 4, 1>
  using THREAD_BLOCK_SIZE = gemm_shape_t<2u * WAVE_SIZE, 2u>;

  // WMMA support heavily depends on the architecture.
  // Note: gfx11 only supports BlockM/N = 16
  // clang-format off
  /**
   * | Ti / To / Tc              | WMMA_M | WMMA_N   | WMMA_K Range  (powers of 2) | Notes                                                |
   * |---------------------------|--------|----------|-----------------------------|------------------------------------------------------|
   * | i8 / i32 / i32            | 16     | 16       | [16, 256]                   |                                                      |
   * |                           | 32     | 32       | [8, 128]                    |                                                      |
   * | i8 / i8 / i32             | 16     | 16       | [16, 256]                   |                                                      |
   * |                           | 32     | 32       | [8, 128]                    |                                                      |
   * | f16 / f32 / f32           | 16     | 16       | [16, 256]                   |                                                      |
   * |                           | 32     | 32       | [8, 128]                    |                                                      |
   * | f16 / f16 / f32           | 16     | 16       | [16, 256]                   |                                                      |
   * |                           | 32     | 32       | [8, 128]                    |                                                      |
   * | f16 / f16 / f16*          | 16     | 16       | [16, 256]                   | *= CDNA native f32 accumulation downcasted to fp16   |
   * |                           | 32     | 32       | [8, 128]                    |                                                      |
   * | __half / f32 / f32        | 16     | 16       | [16, 256]                   |                                                      |
   * |                           | 32     | 32       | [8, 128]                    |                                                      |
   * | __half / __half / f32     | 16     | 16       | [16, 256]                   |                                                      |
   * |                           | 32     | 32       | [8, 128]                    |                                                      |
   * | __half / __half / __half* | 16     | 16       | [16, 256]                   | *= CDNA native f32 accumulation downcasted to __half |
   * |                           | 32     | 32       | [8, 128]                    |                                                      |
   * | bf16 / f32 / f32          | 16     | 16       | [8, 256]                    |                                                      |
   * |                           | 32     | 32       | [4, 128]                    |                                                      |
   * | bf16 / bf16 / f32         | 16     | 16       | [8, 256]                    |                                                      |
   * |                           | 32     | 32       | [4, 128]                    |                                                      |
   * | bf16 / bf16 / bf16*       | 16     | 16       | [8, 256]                    | *= CDNA native f32 accumulation downcasted to bf16   |
   * |                           | 32     | 32       | [4, 128]                    |                                                      |
   * | f32 / f32 / f32*          | 16     | 16       | [4, 256]                    | *= Supported only on gfx9                            |
   * |                           | 32     | 32       | [2, 128]                    |                                                      |
   * | f64 / f64 / f64*          | 16     | 16       | [4, 256]                    | *= Supported only on gfx90a +                        |
   */
  // clang-format on
  using WMMA = gemm_shape_t<32u, 32u, 8u>;

  // Calculate the number of waves based on the selected thread-block size and
  // wave_size.
  using NUM_WAVES =
      gemm_shape_t<THREAD_BLOCK_SIZE::M / WAVE_SIZE, THREAD_BLOCK_SIZE::N>;

  // WMMA size * THREAD_TILE gives the actual wave tile size.
  using WAVE_TILE =
      gemm_shape_t<(THREAD_TILE::M * WMMA::M), (THREAD_TILE::N * WMMA::N)>;

  // The final macro tile size becomes dependent on the number of waves and the
  // wave tile size.
  using MACRO_TILE = gemm_shape_t<WAVE_TILE::M * NUM_WAVES::M,
                                  WAVE_TILE::N * NUM_WAVES::N, WMMA::K>;

  // Misc. allocations.
  // Flags are initialised to 1 ("locked"). A helper CTA publishes its partials
  // and then calls `unlock`, which writes 0. The owner CTA spins on
  // `wait_for_unlock` (while *mutex). If flags started at 0 the owner would
  // see an already-unlocked state and read garbage partials. The buffer must
  // be reset back to 1 before each subsequent launch.
  thrust::device_vector<int> flags(grid, 1);
  thrust::device_vector<compute_t> partials(
      grid * MACRO_TILE::M * MACRO_TILE::N, static_cast<compute_t>(0.f));

  // Set-up Stream-K Schedule
  streamk_schedule_t<MACRO_TILE, compute_t> sk(
      m, n, k, grid, flags.data().get(), partials.data().get());

  dim3 dimBlock(THREAD_BLOCK_SIZE::M, THREAD_BLOCK_SIZE::N);
  dim3 dimGrid(grid);

  auto reset_flags = [&]() {
    thrust::fill(flags.begin(), flags.end(), 1);
  };

  for (int i = 0; i < numWarmup; i++) {
    reset_flags();
    hipExtLaunchKernelGGL(
        simple_streamk_kernel<WAVE_SIZE, THREAD_BLOCK_SIZE::MNK, MACRO_TILE,
                              WMMA, WAVE_TILE, NUM_WAVES, THREAD_TILE, input_t,
                              output_t, compute_t>,
        dimGrid, dimBlock, 0, 0, nullptr, nullptr, 0, m, n, k, a, b, c, d, m, n,
        m, m, alpha, beta, sk);
  }

  auto elapsedTimeUs = get_time_us_sync_device();

  for (int i = 0; i < num_runs; i++) {
    reset_flags();
    hipExtLaunchKernelGGL(
        simple_streamk_kernel<WAVE_SIZE, THREAD_BLOCK_SIZE::MNK, MACRO_TILE,
                              WMMA, WAVE_TILE, NUM_WAVES, THREAD_TILE, input_t,
                              output_t, compute_t>,
        dimGrid, dimBlock, 0, 0, nullptr, nullptr, 0, m, n, k, a, b, c, d, m, n,
        m, m, alpha, beta, sk);
  }
  elapsedTimeUs = get_time_us_sync_device() - elapsedTimeUs;
  return elapsedTimeUs / num_runs;
}

}  // namespace streamk