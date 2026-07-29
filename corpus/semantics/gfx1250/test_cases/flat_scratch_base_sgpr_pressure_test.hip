#include "resource_pressure.hpp"
#include "test_support.hpp"

#include <cstdint>

extern "C" __global__ void flat_scratch_base_sgpr_pressure(uint32_t *status) {
  uint32_t lane;
  uint32_t mismatch;
  asm volatile(CORPUS_SGPR_PRESSURE_SAVE
               "s_mov_b64 s[100:101], src_flat_scratch_base_lo\n\t"
               "v_mov_b32 v112, s100\n\t"
               "v_mov_b32 v113, s101\n\t"
               CORPUS_SGPR_PRESSURE_INIT
               "v_mov_b32 v114, 0\n\t"
               "v_mov_b32 v115, 0\n\t"

               "v_add_nc_u64 v[116:117], src_flat_scratch_base_lo, "
               "v[114:115]\n\t"

               CORPUS_SGPR_PRESSURE_BEGIN_CHECK
               "v_xor_b32 v104, v112, v116\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               "v_xor_b32 v104, v113, v117\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               CORPUS_SGPR_PRESSURE_ACCUMULATE_ALL
               CORPUS_SGPR_PRESSURE_RESTORE
               "v_mov_b32 %0, v102\n\t"
               "v_mov_b32 %1, v103"
               : "=&v"(lane), "=&v"(mismatch)
               :
               : "s101", "v155", "memory");
  status[lane] = mismatch;
}
#pragma clang diagnostic pop

int main() {
  constexpr size_t lanes = 32;
  corpus::DeviceBuffer<uint32_t> status(lanes);
  status.clear();
  hipLaunchKernelGGL(flat_scratch_base_sgpr_pressure, dim3(1), dim3(lanes), 0,
                     0, status.device);
  status.target_to_host();

  return corpus::expect_equal("flat-scratch full-SGPR preservation", status.host,
                              std::vector<uint32_t>(lanes, 0))
             ? 0
             : 1;
}
