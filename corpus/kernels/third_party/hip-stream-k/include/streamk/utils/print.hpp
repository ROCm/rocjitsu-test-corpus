/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <string.h>
#include <iostream>

#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/copy.h>

namespace streamk {

/**
 * @brief Print the first k elements of a vector.
 *
 * @tparam vector_t
 * @param x vector to print.
 * @param k number of elements to print.
 */
template <typename VectorT>
void print_head(VectorT& x, int k, std::string name = "") {
  using type_t = typename VectorT::value_type;
  if (x.size() < k)
    k = x.size();

  if (name.size() > 0)
    std::cout << name << "[:" << k << "] = ";

  thrust::copy(x.begin(), x.begin() + k,
               std::ostream_iterator<type_t>(std::cout, " "));
  std::cout << std::endl;
}

}  // namespace streamk