#include "test_support.hpp"

#include <cstdint>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winline-asm"
extern "C" __global__ void scale16_spill_pressure(uint32_t *out) {
  uint32_t lane;
  uint32_t mismatch;
  asm volatile("v_mov_b32 v254, v0\n\t"
               ".set pressure_reg, 0\n\t"
               ".rept 254\n\t"
               "v_mov_b32 v[pressure_reg], pressure_reg\n\t"
               ".set pressure_reg, pressure_reg + 1\n\t"
               ".endr\n\t"
               "v_mov_b32 v255, 255\n\t"

               ".set matrix_reg, 16\n\t"
               ".rept 8\n\t"
               "v_mov_b32 v[matrix_reg], 0x22222222\n\t"
               ".set matrix_reg, matrix_reg + 1\n\t"
               ".endr\n\t"
               ".set matrix_reg, 32\n\t"
               ".rept 8\n\t"
               "v_mov_b32 v[matrix_reg], 0x22222222\n\t"
               ".set matrix_reg, matrix_reg + 1\n\t"
               ".endr\n\t"
               ".set matrix_reg, 48\n\t"
               ".rept 8\n\t"
               "v_mov_b32 v[matrix_reg], 0\n\t"
               ".set matrix_reg, matrix_reg + 1\n\t"
               ".endr\n\t"
               ".set scale_reg, 64\n\t"
               ".rept 4\n\t"
               "v_mov_b32 v[scale_reg], 0x7f7f7f7f\n\t"
               ".set scale_reg, scale_reg + 1\n\t"
               ".endr\n\t"

               "v_wmma_scale16_f32_16x16x128_f8f6f4 "
               "v[96:103], v[16:23], v[32:39], v[48:55], v[64:65], v[66:67] "
               "matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4\n\t"

               ".set pressure_reg, 0\n\t"
               ".rept 256\n\t"
               "v_mov_b32 v[pressure_reg], v[pressure_reg]\n\t"
               ".set pressure_reg, pressure_reg + 1\n\t"
               ".endr\n\t"

               "v_mov_b32 v255, 0\n\t"
               ".set check_reg, 0\n\t"
               ".rept 13\n\t"
               "v_xor_b32 v[check_reg], check_reg, v[check_reg]\n\t"
               "v_or_b32 v255, v255, v[check_reg]\n\t"
               ".set check_reg, check_reg + 1\n\t"
               ".endr\n\t"
               "v_mov_b32 %0, v254\n\t"
               "v_mov_b32 %1, v255"
               : "=&v"(lane), "=&v"(mismatch)
               :
               : "v254", "v255", "memory");
  out[lane] = mismatch;
}
#pragma clang diagnostic pop

int main() {
  constexpr size_t lanes = 32;
  corpus::DeviceBuffer<uint32_t> output(lanes);
  output.clear();
  hipLaunchKernelGGL(scale16_spill_pressure, dim3(1), dim3(lanes), 0, 0,
                     output.device);
  output.target_to_host();
  return corpus::expect_equal("Scale16 full-VGPR spill preservation",
                              output.host, std::vector<uint32_t>(lanes, 0))
             ? 0
             : 1;
}
