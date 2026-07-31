#include "resource_pressure.hpp"
#include "test_support.hpp"

#include <cstdint>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winline-asm"
extern "C" __global__ void scale16_vgpr_pressure(float *values,
                                                 uint32_t *status) {
  uint32_t lane;
  uint32_t mismatch;
  float value;
  asm volatile(CORPUS_VGPR_PRESSURE_INIT
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

               CORPUS_VGPR_PRESSURE_BEGIN_CHECK
               CORPUS_VGPR_PRESSURE_CHECK_SENTINEL_RANGE(0, 16)
               CORPUS_VGPR_PRESSURE_CHECK_SENTINEL_RANGE(24, 8)
               CORPUS_VGPR_PRESSURE_CHECK_SENTINEL_RANGE(40, 8)
               CORPUS_VGPR_PRESSURE_CHECK_SENTINEL_RANGE(56, 8)
               CORPUS_VGPR_PRESSURE_CHECK_SENTINEL_RANGE(68, 28)
               CORPUS_VGPR_PRESSURE_CHECK_SENTINEL_RANGE(104, 150)
               CORPUS_VGPR_PRESSURE_CHECK_SENTINEL_RANGE(255, 1)
               CORPUS_VGPR_PRESSURE_CHECK_CONSTANT_RANGE(16, 8, 0x22222222)
               CORPUS_VGPR_PRESSURE_CHECK_CONSTANT_RANGE(32, 8, 0x22222222)
               CORPUS_VGPR_PRESSURE_CHECK_CONSTANT_RANGE(48, 8, 0)
               CORPUS_VGPR_PRESSURE_CHECK_CONSTANT_RANGE(64, 4, 0x7f7f7f7f)
               CORPUS_VGPR_PRESSURE_CHECK_CONSTANT_RANGE(96, 8, 0x43000000)
               CORPUS_VGPR_PRESSURE_CHECK_AND_RESTORE_LANE
               "v_mov_b32 %0, v254\n\t"
               "v_mov_b32 %1, s20\n\t"
               "v_mov_b32 %2, v96"
               : "=&v"(lane), "=&v"(mismatch), "=&v"(value)
               :
               : CORPUS_VGPR_PRESSURE_CLOBBERS, "v96", "memory");
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
  hipLaunchKernelGGL(scale16_vgpr_pressure, dim3(1), dim3(lanes), 0, 0,
                     values.device, status.device);
  values.target_to_host();
  status.target_to_host();

  if (!corpus::expect_near("Scale16 full-VGPR GEMM", values.host,
                           std::vector<float>(lanes, 128.0f)))
    return 1;
  return corpus::expect_equal("Scale16 full-VGPR preservation", status.host,
                              std::vector<uint32_t>(lanes, 0))
             ? 0
             : 1;
}
