#include "test_support.hpp"

#include <cstdint>

extern "C" __global__ void check_flat_scratch_vector_lo(uint32_t *out) {
  const unsigned lane = threadIdx.x;
  unsigned base_lo;
  unsigned base_hi;
  uint64_t vector_value;
  const uint64_t offset = UINT64_C(0x10203040) + lane;

  asm volatile("s_mov_b32 %0, src_flat_scratch_base_lo\n\t"
               "s_mov_b32 %1, src_flat_scratch_base_hi\n\t"
               "v_add_nc_u64_e64 %2, src_flat_scratch_base_lo, %3"
               : "=s"(base_lo), "=s"(base_hi), "=&v"(vector_value)
               : "v"(offset)
               : "memory");

  const uint64_t reconstructed =
      (static_cast<uint64_t>(base_hi) << 32) | base_lo;
  const uint64_t expected_value = reconstructed + offset;
  uint32_t status = 0;
  status |= static_cast<uint32_t>(reconstructed != 0) << 0;
  status |= static_cast<uint32_t>(vector_value == expected_value) << 1;
  status |= static_cast<uint32_t>(vector_value != offset) << 2;
  out[lane] = status;
}

int main() {
  constexpr unsigned lanes = 32;
  constexpr uint32_t all_checks_passed = 0x7u;
  corpus::DeviceBuffer<uint32_t> output(lanes);
  std::vector<uint32_t> expected(lanes, all_checks_passed);

  output.clear();
  hipLaunchKernelGGL(check_flat_scratch_vector_lo, dim3(1), dim3(lanes), 0, 0,
                     output.device);
  output.target_to_host();
  return corpus::expect_equal("vector flat-scratch-base LO semantics",
                              output.host, expected)
             ? 0
             : 1;
}
