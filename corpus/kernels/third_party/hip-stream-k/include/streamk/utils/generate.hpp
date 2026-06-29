/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <chrono>
#include <thrust/random.h>
#include <thrust/distance.h>
#include <thrust/transform.h>
#include <thrust/execution_policy.h>
#include <thrust/iterator/counting_iterator.h>

namespace streamk {
namespace generate {
/**
 * @brief Hash function for random numbers.
 *
 * @param a The number to hash.
 * @return unsigned int The hashed number.
 */
__forceinline__ __host__ __device__ unsigned int hash(unsigned int a) {
  a = (a + 0x7ed55d16) + (a << 12);
  a = (a ^ 0xc761c23c) ^ (a >> 19);
  a = (a + 0x165667b1) + (a << 5);
  a = (a + 0xd3a2646c) ^ (a << 9);
  a = (a + 0xfd7046c5) + (a << 3);
  a = (a ^ 0xb55a4f09) ^ (a >> 16);
  return a;
}

/**
 * @brief Generate a vector with uniform distribution of random numbers between
 * [begin, end].
 *
 * @tparam vector_t vector type.
 * @tparam vector_t::value_type value type.
 * @param input thrust host or device vector.
 * @param begin range begin value.
 * @param end range end value.
 * @param seed random seed.
 */
template <typename iterator_t, typename type_t>
void uniform_distribution(iterator_t begin_it,
                          iterator_t end_it,
                          type_t begin,
                          type_t end,
                          unsigned int useed = std::chrono::system_clock::now()
                                                   .time_since_epoch()
                                                   .count()) {
  int size = thrust::distance(begin_it, end_it);
  auto generate_random = [=] __host__ __device__(std::size_t i) -> type_t {
    unsigned int seed = hash(i) * useed;
    thrust::default_random_engine rng(seed);
    // thrust::uniform_int_distribution<int> uniform(begin, end);
    thrust::uniform_real_distribution<double> uniform(begin, end);
    return static_cast<type_t>(static_cast<int>(uniform(rng)));
  };

  thrust::transform(thrust::make_counting_iterator<std::size_t>(0),
                    thrust::make_counting_iterator<std::size_t>(size), begin_it,
                    generate_random);
}
}  // namespace generate
}  // namespace streamk