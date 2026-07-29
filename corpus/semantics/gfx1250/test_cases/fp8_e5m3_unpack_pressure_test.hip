#include "test_support.hpp"

#include <cstdint>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winline-asm"
extern "C" __global__ void e5m3_unpack_pressure(float *values,
                                                uint32_t *status) {
  uint32_t lane;
  uint32_t mismatch;
  float value;
  asm volatile("v_mov_b32 v254, v0\n\t"
               ".set pressure_reg, 0\n\t"
               ".rept 254\n\t"
               "v_mov_b32 v[pressure_reg], pressure_reg\n\t"
               ".set pressure_reg, pressure_reg + 1\n\t"
               ".endr\n\t"
               "v_mov_b32 v255, 255\n\t"
               "v_mov_b32 v22, 0x00780000\n\t"

               "v_cvt_f32_fp8 v30, v22 byte_sel:2 clamp\n\t"

               ".set pressure_reg, 0\n\t"
               ".rept 256\n\t"
               "v_mov_b32 v[pressure_reg], v[pressure_reg]\n\t"
               ".set pressure_reg, pressure_reg + 1\n\t"
               ".endr\n\t"

               "v_xor_b32 v0, 0, v0\n\t"
               "v_xor_b32 v1, 1, v1\n\t"
               "v_or_b32 v255, v0, v1\n\t"
               "v_mov_b32 %0, v254\n\t"
               "v_mov_b32 %1, v255\n\t"
               "v_mov_b32 %2, v30"
               : "=&v"(lane), "=&v"(mismatch), "=&v"(value)
               :
               : "v254", "v255", "memory");
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
  hipLaunchKernelGGL(e5m3_unpack_pressure, dim3(1), dim3(lanes), 0, 0,
                     values.device, status.device);
  values.target_to_host();
  status.target_to_host();

  if (!corpus::expect_near("UE5M3 full-VGPR conversion", values.host,
                           std::vector<float>(lanes, 1.0f)))
    return 1;
  return corpus::expect_equal("UE5M3 full-VGPR spill preservation", status.host,
                              std::vector<uint32_t>(lanes, 0))
             ? 0
             : 1;
}
