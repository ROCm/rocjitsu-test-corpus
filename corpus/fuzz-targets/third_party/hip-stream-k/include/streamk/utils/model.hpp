/**
 * @copyright Copyright 2024 Advanced Micro Devices, Inc.
 */

#pragma once

#include <cstddef>
#include <iostream>
#include <vector>
#include <utility> // for std::pair
#include <algorithm> // for std::min_element

#include <streamk/utils/math.hpp>

namespace streamk {

template <int BLK_M, int BLK_N, int BLK_K>
constexpr int num_iters_per_cta(int m, int n, int k, int g) {
  return math::ceil_div(math::ceil_div(m, BLK_M) * math::ceil_div(n, BLK_N) * math::ceil_div(k, BLK_K), g);
}

template <int BLK_M, int BLK_N>
constexpr int number_of_output_tiles(int m, int n) {
  int m_tiles =  math::ceil_div(m, BLK_M);
  int n_tiles = math::ceil_div(n, BLK_N);
  return m_tiles * n_tiles;
}

template <int BLK_K>
constexpr int num_fixup_peers(int k, int g, int iters_per_cta) {
  return math::ceil_div(math::ceil_div(k, BLK_K), iters_per_cta);
}

template <int BLK_M, int BLK_N, int BLK_K>
std::tuple<double,int,int>
predicted_runtime(int m, int n, int k, int g, int a, int b, int c, int d) {
  int iters_per_cta = num_iters_per_cta<BLK_M, BLK_N, BLK_K>(m, n, k, g);
  int fixup_peers = num_fixup_peers<BLK_K>(k, g, iters_per_cta);

  return {a + (b * (fixup_peers > 1)) + (c * iters_per_cta) + (d * (fixup_peers - 1)), iters_per_cta, fixup_peers};
}

template <int BLK_M, int BLK_N, int BLK_K>
int best_predicted_grid_size(int m,
                             int n,
                             int k,
                             int grid_start = 1,
                             int grid_end = 304) {
  // Timing in us @ 1100/900 MHz
  double a = 5.04 + 8.3; // 5544 + 9136;  // 5.04 us
  double b = 28; // 30800;  // 28 us
  double c = 4.17; // 4592;  // 4.17 us
  double d = 30; // 39600;  // 36 us

  // std::vector<double> runtimes;
  std::pair<int,double> temp;
  std::vector<std::pair<int,double>> runtimes;
  int g = grid_start;
  // Predict the number of CTAs to use between 1 and 304
  for (; g <= grid_end; ++g) {
    auto [runtime, iters_per_cta, fixup_peers] =
        predicted_runtime<BLK_M, BLK_N, BLK_K>(m, n, k, g, a, b, c, d);
    temp.first = g;
    temp.second = runtime;
    runtimes.push_back(temp);
    std::cout << "grid size: " << g 
              << ", runtime: " << runtime 
              << ", iters_per_cta: " << iters_per_cta
              << ", fixup_peers: " << fixup_peers  
              << ", m: " << m
              << ", n: " << n 
              << ", k: " << k 
              << ", a: " << a 
              << ", b: " << b
              << ", c: " << c 
              << ", d: " << d << std::endl;
  }

  auto min_grid_runtime = std::min_element(runtimes.begin(), runtimes.end(),
      [](const auto& pair1, const auto& pair2) {
          return pair1.second < pair2.second;
      });

  if (min_grid_runtime->first > 608)
    min_grid_runtime->first = number_of_output_tiles<BLK_M, BLK_N>(m, n) / 2;

  std::cout << "Number of Output Tiles: " << number_of_output_tiles<BLK_M, BLK_N>(m, n) << std::endl;
  std::cout << "Minimum runtime: " << min_grid_runtime->second << " @ grid size: " << min_grid_runtime->first << std::endl;

  return min_grid_runtime->first;
}

}  // namespace streamk