#include "resource_pressure.hpp"
#include "test_support.hpp"

#include <cstdint>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winline-asm"
extern "C" __global__ void e5m3_unpack_vgpr_pressure(float *values,
                                                     uint32_t *status) {
  uint32_t lane;
  uint32_t mismatch;
  float value;
  asm volatile(CORPUS_VGPR_PRESSURE_INIT
               "v_mov_b32 v22, 0x00780000\n\t"

               "v_cvt_f32_fp8 v30, v22 byte_sel:2 clamp\n\t"

               CORPUS_VGPR_PRESSURE_BEGIN_CHECK
               CORPUS_VGPR_PRESSURE_CHECK_SENTINEL_RANGE(0, 22)
               CORPUS_VGPR_PRESSURE_CHECK_SENTINEL_RANGE(23, 7)
               CORPUS_VGPR_PRESSURE_CHECK_SENTINEL_RANGE(31, 223)
               CORPUS_VGPR_PRESSURE_CHECK_SENTINEL_RANGE(255, 1)
               CORPUS_VGPR_PRESSURE_CHECK_CONSTANT_RANGE(22, 1, 0x00780000)
               CORPUS_VGPR_PRESSURE_CHECK_CONSTANT_RANGE(30, 1, 0x3f800000)
               CORPUS_VGPR_PRESSURE_CHECK_AND_RESTORE_LANE
               "v_mov_b32 %0, v254\n\t"
               "v_mov_b32 %1, s20\n\t"
               "v_mov_b32 %2, v30"
               : "=&v"(lane), "=&v"(mismatch), "=&v"(value)
               :
               : CORPUS_VGPR_PRESSURE_CLOBBERS, "v30", "memory");
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
  hipLaunchKernelGGL(e5m3_unpack_vgpr_pressure, dim3(1), dim3(lanes), 0, 0,
                     values.device, status.device);
  values.target_to_host();
  status.target_to_host();

  if (!corpus::expect_near("UE5M3 full-VGPR conversion", values.host,
                           std::vector<float>(lanes, 1.0f)))
    return 1;
  return corpus::expect_equal("UE5M3 full-VGPR preservation", status.host,
                              std::vector<uint32_t>(lanes, 0))
             ? 0
             : 1;
}
