/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <iostream>

#include <thrust/host_vector.h>
#include <thrust/device_vector.h>

namespace streamk {

auto default_comparator = [](auto& a, auto& b) -> bool { return a != b; };

/**
 * @brief Pulls two device buffers to the host and prints rich numerical
 * statistics comparing them: min/max/mean of the streamk output, the
 * reference, max absolute diff, max relative diff, mean absolute diff, and
 * a small sample of corresponding element pairs.  Helps verify that the
 * kernels are producing genuinely correct values, not just that they happen
 * to match the reference within `epsilon`.
 */
template <typename type_t>
void compare_stats(const type_t* x_dev,
                   const type_t* y_dev,
                   const std::size_t n,
                   const std::size_t num_samples = 8) {
  thrust::host_vector<type_t> x(n);
  thrust::host_vector<type_t> y(n);
  hipMemcpy(x.data(), x_dev, n * sizeof(type_t), hipMemcpyDeviceToHost);
  hipMemcpy(y.data(), y_dev, n * sizeof(type_t), hipMemcpyDeviceToHost);

  double x_min = std::numeric_limits<double>::infinity();
  double x_max = -std::numeric_limits<double>::infinity();
  double y_min = x_min, y_max = x_max;
  double x_sum = 0.0, y_sum = 0.0;
  double max_abs = 0.0;
  double max_rel = 0.0;
  double sum_abs = 0.0;
  double max_abs_x = 0.0, max_abs_y = 0.0;  // values at the worst spot
  std::size_t max_abs_idx = 0;

  for (std::size_t i = 0; i < n; ++i) {
    double xv = static_cast<double>(static_cast<float>(x[i]));
    double yv = static_cast<double>(static_cast<float>(y[i]));
    x_min = std::min(x_min, xv);
    x_max = std::max(x_max, xv);
    y_min = std::min(y_min, yv);
    y_max = std::max(y_max, yv);
    x_sum += xv;
    y_sum += yv;
    double diff = std::abs(xv - yv);
    sum_abs += diff;
    if (diff > max_abs) {
      max_abs = diff;
      max_abs_x = xv;
      max_abs_y = yv;
      max_abs_idx = i;
    }
    double denom = std::max(std::abs(yv), 1e-12);
    double rel = diff / denom;
    if (rel > max_rel) max_rel = rel;
  }

  std::cout << "  streamk    : min=" << x_min << " max=" << x_max
            << " mean=" << (x_sum / static_cast<double>(n)) << "\n";
  std::cout << "  reference  : min=" << y_min << " max=" << y_max
            << " mean=" << (y_sum / static_cast<double>(n)) << "\n";
  std::cout << "  max |diff| : " << max_abs << "  (streamk=" << max_abs_x
            << ", ref=" << max_abs_y << ", idx=" << max_abs_idx << ")\n";
  std::cout << "  mean |diff|: " << (sum_abs / static_cast<double>(n)) << "\n";
  std::cout << "  max rel    : " << max_rel << "\n";

  std::cout << "  samples (streamk, ref):";
  std::size_t step = std::max<std::size_t>(1, n / num_samples);
  for (std::size_t i = 0, k = 0; k < num_samples && i < n; i += step, ++k) {
    std::cout << "  [" << i << "]=("
              << static_cast<float>(x[i]) << ", "
              << static_cast<float>(y[i]) << ")";
  }
  std::cout << std::endl;
}

/**
 * @brief Compares values between a device pointer and a device pointer of same
 * length, and returns number of errors/mismatches found.
 *
 * @tparam type_t Type of the values to be compared.
 * @tparam comp_t Type of the error comparator function.
 * @param x device pointer
 * @param y device pointer
 * @param n number of elements to compare
 * @param error_op lambda function to compare two value that result in a
 * mismatch count to increment (default a != b).
 * @param verbose if true, prints out the mismatches
 * @return std::size_t number of mismatches found
 */
template <typename type_t, typename comp_t = decltype(default_comparator)>
std::size_t compare(const type_t* x,
                    const type_t* y,
                    const std::size_t n,
                    comp_t error_op = default_comparator,
                    const bool verbose = false) {
  thrust::host_vector<type_t> x_vec(n);
  hipMemcpy(x_vec.data(), x, n * sizeof(type_t), hipMemcpyDeviceToHost);

  thrust::host_vector<type_t> y_vec(n);
  hipMemcpy(y_vec.data(), y, n * sizeof(type_t), hipMemcpyDeviceToHost);

  std::size_t error_count = 0;
  for (std::size_t i = 0; i < n; ++i) {
    if (error_op(x_vec[i], y_vec[i])) {
      if (verbose)
        std::cout << "Error: " << static_cast<float>(x_vec[i])
                  << " != " << static_cast<float>(y_vec[i]) << std::endl;
      ++error_count;
    }
  }
  return error_count;
}

}  // namespace streamk