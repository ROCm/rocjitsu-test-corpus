/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <hip/hip_fp16.h>
#include <hip/hip_runtime.h>

#include <streamk/utils/mfma.hpp>

#include <cstddef>
#include <cstdint>

#include <thrust/host_vector.h>

namespace streamk {

/**
 * @brief c = alpha*op( a )*op( b ) + beta*c,
 *
 * @param m number or rows of matrices op( a ) and c.
 * @param n number of columns of matrices op( B ) and C.
 * @param k number of columns of matrix op( A ) and number of rows of matrix op(
 * B ).
 * @param a device pointer storing matrix A.
 * @param b device pointer storing matrix B.
 * @param c device pointer storing matrix C.
 * @param beta scalar beta.
 * @param alpha scalar alpha.
 *
 * This CPU reference matches the rocBLAS call that used
 * rocblas_operation_none for A and rocblas_operation_transpose for B.
 */
template <typename input_t, typename output_t, typename compute_t>
void validate(uint32_t m,
              uint32_t n,
              uint32_t k,
              input_t const* a,
              input_t const* b,
              output_t* c,
              compute_t alpha,
              compute_t beta) {
  const std::size_t size_a = static_cast<std::size_t>(m) * k;
  const std::size_t size_b = static_cast<std::size_t>(k) * n;
  const std::size_t size_c = static_cast<std::size_t>(m) * n;

  thrust::host_vector<input_t> a_host(size_a);
  thrust::host_vector<input_t> b_host(size_b);
  thrust::host_vector<output_t> c_host(size_c);

  hipMemcpy(a_host.data(), a, size_a * sizeof(input_t), hipMemcpyDeviceToHost);
  hipMemcpy(b_host.data(), b, size_b * sizeof(input_t), hipMemcpyDeviceToHost);
  hipMemcpy(c_host.data(), c, size_c * sizeof(output_t), hipMemcpyDeviceToHost);

  for (uint32_t col = 0; col < n; ++col) {
    for (uint32_t row = 0; row < m; ++row) {
      compute_t acc = static_cast<compute_t>(0);
      for (uint32_t inner = 0; inner < k; ++inner) {
        const compute_t a_value =
            static_cast<compute_t>(a_host[row + inner * m]);
        const compute_t b_value =
            static_cast<compute_t>(b_host[col + inner * n]);
        acc += a_value * b_value;
      }
      const std::size_t offset = row + static_cast<std::size_t>(col) * m;
      c_host[offset] =
          static_cast<output_t>(alpha * acc + beta * c_host[offset]);
    }
  }

  hipMemcpy(c, c_host.data(), size_c * sizeof(output_t), hipMemcpyHostToDevice);
}

}  // namespace streamk