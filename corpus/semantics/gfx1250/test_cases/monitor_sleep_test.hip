#include "test_support.hpp"

// This kernel is compiled but never launched.
// It keeps the affected instruction in the code object for source-coverage and
// translation checks without risking an indefinite sleep.
extern "C" __global__ void unbounded_monitor_sleep_fixture() {
  asm volatile("s_monitor_sleep 0x8000" ::: "memory");
}

extern "C" __global__ void
run_monitor_sleep_translation_test(unsigned *out, const unsigned *in) {
  const unsigned lane = threadIdx.x;
  out[lane] = (in[lane] * 17u) ^ (0x9e3779b9u + lane);
}

int main() {
  constexpr unsigned lanes = 32;
  corpus::DeviceBuffer<unsigned> input(lanes);
  corpus::DeviceBuffer<unsigned> output(lanes);
  std::vector<unsigned> expected(lanes);
  for (unsigned lane = 0; lane < lanes; ++lane) {
    input.host[lane] = lane * lane + 3u;
    expected[lane] = (input.host[lane] * 17u) ^ (0x9e3779b9u + lane);
  }

  input.host_to_target();
  output.clear();
  hipLaunchKernelGGL(run_monitor_sleep_translation_test, dim3(1), dim3(lanes),
                     0, 0, output.device, input.device);
  output.target_to_host();
  return corpus::expect_equal("unbounded monitor-sleep translation fixture",
                              output.host, expected)
             ? 0
             : 1;
}
