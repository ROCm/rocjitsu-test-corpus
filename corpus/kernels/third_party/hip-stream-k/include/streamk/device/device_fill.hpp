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
 * @brief Broadcast value to fragments in warp tile.
 *
 * @tparam BLOCKS
 * @tparam fragment_t
 * @param value
 * @return __device__
 */
template <typename BLOCKS, typename fragment_t>
__device__ static inline void fill(fragment_t (&frags)[BLOCKS::M][BLOCKS::N],
                                   GetDataType_t<fragment_t> value) {
#pragma unroll
  for (int i = 0; i < BLOCKS::M; i++) {
#pragma unroll
    for (int j = 0; j < BLOCKS::N; j++) {
      fill_fragment(frags[i][j], value);
    }
  }
}

}  // namespace streamk