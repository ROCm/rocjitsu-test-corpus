#include "resource_pressure.hpp"
#include "test_support.hpp"

#include <cstdint>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winline-asm"
extern "C" __global__ void e5m3_unpack_sgpr_pressure(float *values,
                                                     uint32_t *status) {
  uint32_t lane;
  uint32_t mismatch;
  float value;
  asm volatile(CORPUS_SGPR_PRESSURE_SAVE
               CORPUS_SGPR_PRESSURE_INIT
               "v_mov_b32 v112, 0x00780000\n\t"

               "v_cvt_f32_fp8 v113, v112 byte_sel:2 clamp\n\t"

               CORPUS_SGPR_PRESSURE_BEGIN_CHECK
               CORPUS_SGPR_PRESSURE_ACCUMULATE_ALL
               CORPUS_SGPR_PRESSURE_RESTORE
               "v_mov_b32 %0, v102\n\t"
               "v_mov_b32 %1, v103\n\t"
               "v_mov_b32 %2, v113"
               : "=&v"(lane), "=&v"(mismatch), "=&v"(value)
               :
               : "s101", "v155", "memory");
  values[lane] = value;
  status[lane] = mismatch;
}
#pragma clang diagnostic pop

int main() {
  constexpr size_t lanes = 32;
  corpus::DeviceBuffer<float> values(lanes);
  corpus::DeviceBuffer<uint32_t> status(lanes);
  values.clear();
  status.clear();
  hipLaunchKernelGGL(e5m3_unpack_sgpr_pressure, dim3(1), dim3(lanes), 0, 0,
                     values.device, status.device);
  values.target_to_host();
  status.target_to_host();

  if (!corpus::expect_near("UE5M3 full-SGPR conversion", values.host,
                           std::vector<float>(lanes, 1.0f)))
    return 1;
  return corpus::expect_equal("UE5M3 full-SGPR preservation", status.host,
                              std::vector<uint32_t>(lanes, 0))
             ? 0
             : 1;
}
