/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <type_traits>
#include <hip/hip_runtime.h>

namespace streamk {
namespace math {
/**
 * Performs `(n + d - 1) / d` (unsafe).
 */
template <typename N, typename D>
__host__ __device__ inline constexpr N ceil_div(N n, D d) {
  // Static cast to undo integral promotion.
  return static_cast<N>((n + d - 1) / d);
}

/**
 * Performs `(n + d - 1) / d`, but is robust against the case where
 * `(n + d - 1)` would overflow.
 */
template <typename N, typename D>
__host__ __device__ inline constexpr N safe_ceil_div(N n, D d) {
  // Static cast to undo integral promotion.
  return static_cast<N>(n / d + (n % d != 0 ? 1 : 0));
}

}  // namespace math
}  // namespace streamk