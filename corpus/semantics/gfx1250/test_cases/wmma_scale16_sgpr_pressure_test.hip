#include "resource_pressure.hpp"
#include "test_support.hpp"

#include <cstdint>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winline-asm"
extern "C" __global__ void scale16_sgpr_pressure(float *values,
                                                 uint32_t *status) {
  uint32_t lane;
  uint32_t mismatch;
  float value;
  asm volatile(CORPUS_SGPR_PRESSURE_SAVE
               CORPUS_SGPR_PRESSURE_INIT
               ".set matrix_reg, 112\n\t"
               ".rept 32\n\t"
               "v_mov_b32 v[matrix_reg], 0x38383838\n\t"
               ".set matrix_reg, matrix_reg + 1\n\t"
               ".endr\n\t"
               ".set accumulator_reg, 144\n\t"
               ".rept 8\n\t"
               "v_mov_b32 v[accumulator_reg], 0\n\t"
               ".set accumulator_reg, accumulator_reg + 1\n\t"
               ".endr\n\t"
               ".set scale_reg, 152\n\t"
               ".rept 4\n\t"
               "v_mov_b32 v[scale_reg], 0x7f7f7f7f\n\t"
               ".set scale_reg, scale_reg + 1\n\t"
               ".endr\n\t"

               "v_wmma_scale16_f32_16x16x128_f8f6f4 "
               "v[144:151], v[112:127], v[128:143], v[144:151], "
               "v[152:153], v[154:155]\n\t"

               CORPUS_SGPR_PRESSURE_BEGIN_CHECK
               CORPUS_SGPR_PRESSURE_ACCUMULATE_ALL
               CORPUS_SGPR_PRESSURE_RESTORE
               "v_mov_b32 %0, v102\n\t"
               "v_mov_b32 %1, v103\n\t"
               "v_mov_b32 %2, v144"
               : "=&v"(lane), "=&v"(mismatch), "=&v"(value)
               :
               : CORPUS_SGPR_PRESSURE_CLOBBERS, "v144", "memory");
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
  hipLaunchKernelGGL(scale16_sgpr_pressure, dim3(1), dim3(lanes), 0, 0,
                     values.device, status.device);
  values.target_to_host();
  status.target_to_host();

  if (!corpus::expect_near("Scale16 full-SGPR GEMM", values.host,
                           std::vector<float>(lanes, 128.0f)))
    return 1;
  return corpus::expect_equal("Scale16 full-SGPR preservation", status.host,
                              std::vector<uint32_t>(lanes, 0))
             ? 0
             : 1;
}
