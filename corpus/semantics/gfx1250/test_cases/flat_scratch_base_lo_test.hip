#include "test_support.hpp"

#include <cstdint>

extern "C" __global__ void check_flat_scratch_base_lo(uint64_t *out) {
  const unsigned lane = threadIdx.x;
  uint64_t scalar_move;
  uint64_t scalar_shift;

  asm volatile("s_mov_b64 %0, src_flat_scratch_base_lo" : "=s"(scalar_move));
  asm volatile("s_lshl_b64 %0, src_flat_scratch_base_lo, 0"
               : "=s"(scalar_shift));

  out[lane] = scalar_move ^ scalar_shift;
}

int main() {
  constexpr unsigned lanes = 32;
  corpus::DeviceBuffer<uint64_t> output(lanes);
  std::vector<uint64_t> expected(lanes, 0);

  output.clear();
  hipLaunchKernelGGL(check_flat_scratch_base_lo, dim3(1), dim3(lanes), 0, 0,
                     output.device);
  output.target_to_host();
  return corpus::expect_equal("scalar flat-scratch-base low selector",
                              output.host, expected)
             ? 0
             : 1;
}
