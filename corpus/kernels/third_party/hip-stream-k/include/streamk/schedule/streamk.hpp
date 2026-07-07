/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <hip/hip_ext.h>
#include <hip/hip_fp16.h>
#include <hip/hip_runtime.h>

#include <streamk/device/device_fma.hpp>
#include <streamk/device/device_read_write.hpp>
#include <streamk/device/device_locks.hpp>
#include <streamk/device/device_partials.hpp>
#include <streamk/device/device_common.hpp>
#include <streamk/device/device_fill.hpp>
#include <streamk/utils/math.hpp>

namespace streamk {

template <typename MACRO_TILE, typename compute_t>
class streamk_schedule_t {
 public:
  __host__ __device__ streamk_schedule_t(uint32_t m,
                                         uint32_t n,
                                         uint32_t k,
                                         int grid_size,
                                         int* _flags,
                                         compute_t* _partials)
      : iters_per_cta(ceil_iterations_per_cta<MACRO_TILE>(m, n, k, grid_size)),
        extra_iters(extra_iterations<MACRO_TILE>(m, n, k, grid_size)),
        iters_per_tile(iterations_per_tile<MACRO_TILE::K>(k)),
        total_iters(static_cast<int>(
            math::ceil_div(m, static_cast<uint32_t>(MACRO_TILE::M)) *
            math::ceil_div(n, static_cast<uint32_t>(MACRO_TILE::N)) *
            math::ceil_div(k, static_cast<uint32_t>(MACRO_TILE::K)))),
        iter(0),
        iter_end(0),
        tile(0),
        tile_iter(0),
        tile_iter_end(0),
        local_iter(0),
        local_iter_end(0),
        flags(_flags),
        partials(_partials) {}

  // Computed only once for the kernel.
  __device__ void compute_sk_meta() {
    iter_id();
    iter_end_id();
  }

  // Recomputed every iteration.
  __device__ void compute_sk_iteration_data() {
    tile_id();
    tile_iter_id();
    tile_iter_end_id();
  }

  __device__ void compute_sk_local_data() {
    local_iter_id();
    local_iter_end_id();
  }

 private:
  // Computed only once for the kernel.
  __device__ inline void iter_id() { iter = blockIdx.x * iters_per_cta; }
  // iters_per_cta is computed via ceil(total/grid), so the last few CTAs may
  // claim iters past the end of the actual work.  Clamp `iter_end` to
  // `total_iters` to avoid running on phantom tiles.
  __device__ inline void iter_end_id() {
    iter_end = iter + iters_per_cta;
    if (iter_end > total_iters) iter_end = total_iters;
    if (iter > total_iters) iter = total_iters;
  }

  // Recomputed every iteration.
  __device__ inline void tile_id() { tile = iter / iters_per_tile; }
  __device__ inline void tile_iter_id() { tile_iter = tile * iters_per_tile; }
  __device__ inline void tile_iter_end_id() {
    tile_iter_end = tile_iter + iters_per_tile;
  }

  __device__ inline void local_iter_id() { local_iter = iter - tile_iter; }
  __device__ inline void local_iter_end_id() {
    local_iter_end = std::min(iter_end, tile_iter_end) - tile_iter;
  }

 public:
  int iters_per_cta;
  int extra_iters;
  int iters_per_tile;
  int total_iters;

  int iter;
  int iter_end;

  int tile;
  int tile_iter;
  int tile_iter_end;

  int local_iter;
  int local_iter_end;

  int* flags;
  compute_t* partials;
};

}  // namespace streamk