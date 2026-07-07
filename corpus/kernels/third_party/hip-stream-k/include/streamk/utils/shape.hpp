/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

namespace streamk {

template <int _M = 1, int _N = 1, int _K = 1>
struct gemm_shape_t {
  static int const M = _M;
  static int const N = _N;
  static int const K = _K;
  static int const MNK = M * N * K;
};

}  // namespace streamk