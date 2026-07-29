#include "test_support.hpp"

#include <cstdint>

extern "C" __global__ void
preserve_skipped_flat_scratch_sources(uint64_t *out, unsigned enable) {
  const unsigned lane = threadIdx.x;
  uint64_t scalar_move = UINT64_C(0x5100000000000001);
  uint64_t scalar_shift = UINT64_C(0x5100000000000002);
  uint64_t vector_add = UINT64_C(0x5100000000000100) + lane;
  const uint64_t zero = 0;

  asm volatile("s_cmp_eq_u32 %3, 0\n\t"
               "s_cbranch_scc1 1f\n\t"
               "s_mov_b64 %0, src_flat_scratch_base_hi\n\t"
               "s_lshl_b64 %1, src_flat_scratch_base_hi, 0\n\t"
               "v_add_nc_u64_e64 %2, src_flat_scratch_base_hi, %4\n\t"
               "1:"
               : "+s"(scalar_move), "+s"(scalar_shift), "+v"(vector_add)
               : "s"(enable), "v"(zero)
               : "scc", "memory");

  out[lane * 3] = scalar_move;
  out[lane * 3 + 1] = scalar_shift;
  out[lane * 3 + 2] = vector_add;
}

int main() {
  constexpr unsigned lanes = 32;
  corpus::DeviceBuffer<uint64_t> output(lanes * 3);
  std::vector<uint64_t> expected(lanes * 3);
  for (unsigned lane = 0; lane < lanes; ++lane) {
    expected[lane * 3] = UINT64_C(0x5100000000000001);
    expected[lane * 3 + 1] = UINT64_C(0x5100000000000002);
    expected[lane * 3 + 2] = UINT64_C(0x5100000000000100) + lane;
  }

  output.clear();
  hipLaunchKernelGGL(preserve_skipped_flat_scratch_sources, dim3(1),
                     dim3(lanes), 0, 0, output.device, 0);
  output.target_to_host();
  return corpus::expect_equal("skipped 64-bit flat-scratch-base sources",
                              output.host, expected)
             ? 0
             : 1;
}
