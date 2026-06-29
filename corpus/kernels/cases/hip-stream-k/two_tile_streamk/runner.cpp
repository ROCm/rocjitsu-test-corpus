/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#include <streamk/two_tile_streamk.hpp>
#include <streamk/utils/statistics.hpp>
#include <streamk/utils/generate.hpp>
#include <streamk/utils/compare.hpp>
#include <streamk/utils/parameters.hpp>
#include <streamk/utils/validate.hpp>

#include <thrust/host_vector.h>
#include <thrust/device_vector.h>

#include <stdlib.h>

using namespace streamk;

int main(int argc, char* argv[]) {
  using input_t = float16_t;
  using output_t = float16_t;
  using compute_t = float32_t;

  parameters_t<compute_t> cli(argc, argv);
  int m = cli.m;
  int n = cli.n;
  int k = cli.k;

  int grid = cli.grid;

  compute_t alpha = cli.alpha;
  compute_t beta = cli.beta;

  std::size_t size_a = m * k;
  std::size_t size_b = k * n;
  std::size_t size_c = m * n;
  std::size_t size_d = m * n;

  // Input matrices.
  thrust::device_vector<input_t> a(size_a);
  thrust::device_vector<input_t> b(size_b);

  // Parallel Random Generator.
  generate::uniform_distribution(a.begin(), a.end(), static_cast<input_t>(-4.f),
                                 static_cast<input_t>(4.f));
  generate::uniform_distribution(b.begin(), b.end(), static_cast<input_t>(-4.f),
                                 static_cast<input_t>(4.f));

  // Create and initialize output memory.
  thrust::device_vector<output_t> c(size_c, static_cast<output_t>(1.f));
  thrust::device_vector<output_t> d(size_d, static_cast<output_t>(0.f));

  // Warm-up and then validate.
  two_tile_streamk<input_t, output_t, compute_t>(
      m, n, k, a.data().get(), b.data().get(), c.data().get(), d.data().get(),
      m, n, m, m, alpha, beta, grid, 1);

  if (cli.validate) {
    std::cout << "Performing GPU GEMM for Validation" << std::endl;

    thrust::device_vector<output_t> x(size_d, static_cast<output_t>(1.f));
    validate(m, n, k, a.data().get(), b.data().get(), x.data().get(), alpha,
             beta);

    std::cout << "Validating Results" << std::endl;
    int errors = compare(
        d.data().get(), x.data().get(), size_d,
        [cli](const output_t a, const output_t b) {
          double diff = std::abs(static_cast<float>(a - b));
          return diff > cli.epsilon;
        },
        cli.verbose);

    std::cout << "Errors: " << errors << std::endl;

    if (cli.verbose) {
      compare_stats(d.data().get(), x.data().get(), size_d);
    }
  }

  // Benchmark and output statistics in CSV.
  double elapsed = two_tile_streamk<input_t, output_t, compute_t>(
      m, n, k, a.data().get(), b.data().get(), c.data().get(), d.data().get(),
      m, n, m, m, alpha, beta, grid, cli.num_runs);
  statistics<output_t>(m, n, k, elapsed, "two_tile_streamk");
}