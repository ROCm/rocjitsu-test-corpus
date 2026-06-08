/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

/**
 * If this is not set, rocBLAS creates a struct for rocblas_half and uses that
 * as a half type. It is defined as following:
 *
 * ```
 * typedef struct rocblas_half
 * {
 *     uint16_t data;
 * } rocblas_half;
 * ```
 */
#define ROCM_USE_FLOAT16

#include <hip/hip_ext.h>
#include <hip/hip_fp16.h>
#include <hip/hip_runtime.h>

#include <rocblas/rocblas.h>
#include <streamk/utils/mfma.hpp>

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
 * @param transpose_a specifies the form of op( A ).
 * @param transpose_b specifies the form of op( B ).
 */
template <typename input_t, typename output_t, typename compute_t>
void validate(uint32_t m,
              uint32_t n,
              uint32_t k,
              input_t const* a,
              input_t const* b,
              output_t* c,
              compute_t alpha,
              compute_t beta,
              rocblas_operation transpose_a = rocblas_operation_none,
              rocblas_operation transpose_b = rocblas_operation_transpose);

template <>
void validate(uint32_t m,
              uint32_t n,
              uint32_t k,
              double const* a,
              double const* b,
              double* c,
              double alpha,
              double beta,
              rocblas_operation transpose_a,
              rocblas_operation transpose_b) {
  rocblas_int lda, ldb, ldc;

  if (transpose_a == rocblas_operation_none) {
    lda = m;
  } else {
    lda = k;
  }

  if (transpose_b == rocblas_operation_none) {
    ldb = k;
  } else {
    ldb = n;
  }

  ldc = m;

  rocblas_handle handle;
  rocblas_create_handle(&handle);
  rocblas_dgemm(handle, transpose_a, transpose_b, m, n, k, &alpha, a, lda, b,
                ldb, &beta, c, ldc);
  hipDeviceSynchronize();
  rocblas_destroy_handle(handle);
}

template <>
void validate(uint32_t m,
              uint32_t n,
              uint32_t k,
              float const* a,
              float const* b,
              float* c,
              float alpha,
              float beta,
              rocblas_operation transpose_a,
              rocblas_operation transpose_b) {
  rocblas_int lda, ldb, ldc;

  if (transpose_a == rocblas_operation_none) {
    lda = m;
  } else {
    lda = k;
  }

  if (transpose_b == rocblas_operation_none) {
    ldb = k;
  } else {
    ldb = n;
  }

  ldc = m;

  rocblas_handle handle;
  rocblas_create_handle(&handle);
  rocblas_sgemm(handle, transpose_a, transpose_b, m, n, k, &alpha, a, lda, b,
                ldb, &beta, c, ldc);
  hipDeviceSynchronize();
  rocblas_destroy_handle(handle);
}

template <>
void validate(uint32_t m,
              uint32_t n,
              uint32_t k,
              float16_t const* a,
              float16_t const* b,
              float16_t* c,
              float32_t alpha,
              float32_t beta,
              rocblas_operation transpose_a,
              rocblas_operation transpose_b) {
  rocblas_int lda, ldb, ldc;

  if (transpose_a == rocblas_operation_none) {
    lda = m;
  } else {
    lda = k;
  }

  if (transpose_b == rocblas_operation_none) {
    ldb = k;
  } else {
    ldb = n;
  }

  ldc = m;

  rocblas_half roc_alpha = static_cast<rocblas_half>(alpha);
  rocblas_half roc_beta = static_cast<rocblas_half>(beta);

  rocblas_handle handle;
  rocblas_create_handle(&handle);
  rocblas_hgemm(handle, transpose_a, transpose_b, m, n, k, &roc_alpha, a, lda,
                b, ldb, &roc_beta, c, ldc);
  hipDeviceSynchronize();
  rocblas_destroy_handle(handle);
}

}  // namespace streamk