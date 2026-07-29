#include "test_support.hpp"

extern "C" __global__ void run_unbounded_monitor_sleep(unsigned *out,
                                                       const unsigned *in) {
  const unsigned lane = threadIdx.x;
  // RocJITsu's simulator treats monitor-sleep as an immediate operation. The
  // B0-to-A0 runtime path must still prepend the required s_wait_xcnt guard.
  asm volatile("s_monitor_sleep 0x8000" ::: "memory");
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
  hipLaunchKernelGGL(run_unbounded_monitor_sleep, dim3(1), dim3(lanes), 0, 0,
                     output.device, input.device);
  output.target_to_host();
  return corpus::expect_equal("unbounded monitor-sleep continuation",
                              output.host, expected)
             ? 0
             : 1;
}
