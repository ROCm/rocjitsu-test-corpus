#include "test_support.hpp"

#include <cstdint>

extern "C" __global__ void check_flat_scratch_scalar_lo(uint32_t *out) {
  const unsigned lane = threadIdx.x;
  unsigned base_lo;
  unsigned base_hi;
  uint64_t full_base;
  uint64_t shifted_base;
  unsigned shift_scc;

  asm volatile("s_mov_b32 %0, src_flat_scratch_base_lo\n\t"
               "s_mov_b32 %1, src_flat_scratch_base_hi\n\t"
               "s_mov_b64 %2, src_flat_scratch_base_lo\n\t"
               "s_lshl_b64 %3, src_flat_scratch_base_lo, 1\n\t"
               "s_cselect_b32 %4, 1, 0"
               : "=s"(base_lo), "=s"(base_hi), "=s"(full_base),
                 "=s"(shifted_base), "=s"(shift_scc)
               :
               : "scc", "memory");

  const uint64_t reconstructed =
      (static_cast<uint64_t>(base_hi) << 32) | base_lo;
  uint32_t status = 0;
  status |= static_cast<uint32_t>(full_base != 0) << 0;
  status |= static_cast<uint32_t>(reconstructed != 0) << 1;
  status |= static_cast<uint32_t>(full_base == reconstructed) << 2;
  status |= static_cast<uint32_t>(shifted_base == (full_base << 1)) << 3;
  status |= static_cast<uint32_t>(shift_scc == (shifted_base != 0)) << 4;
  out[lane] = status;
}

int main() {
  constexpr unsigned lanes = 32;
  constexpr uint32_t all_checks_passed = 0x1fu;
  corpus::DeviceBuffer<uint32_t> output(lanes);
  std::vector<uint32_t> expected(lanes, all_checks_passed);

  output.clear();
  hipLaunchKernelGGL(check_flat_scratch_scalar_lo, dim3(1), dim3(lanes), 0, 0,
                     output.device);
  output.target_to_host();
  return corpus::expect_equal("scalar flat-scratch-base LO semantics",
                              output.host, expected)
             ? 0
             : 1;
}
