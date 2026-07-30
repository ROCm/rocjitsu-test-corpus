#include "test_support.hpp"
#include "wmma_m32_fp4_differential.hpp"

using f32x16 = float __attribute__((ext_vector_type(16)));
using i32x8 = int __attribute__((ext_vector_type(8)));
using i32x16 = int __attribute__((ext_vector_type(16)));

extern "C" __global__ void wmma_scale_m32_fp4_differential(
    float *out, const int *packed_a, const int *packed_b, bool scale_probe) {
  const int lane = static_cast<int>(threadIdx.x);
  i32x16 a, b;
  for (int reg = 0; reg < 16; ++reg) {
    a[reg] = packed_a[lane * 16 + reg];
    b[reg] = packed_b[lane * 16 + reg];
  }

  f32x16 acc;
  for (int reg = 0; reg < 16; ++reg) {
    const int row = wmma_m32_fp4::dbt_row(lane, reg);
    const int col = lane % 16;
    acc[reg] =
        scale_probe ? 0.0f : static_cast<float>(1024 + 32 * row + col);
  }
  const int scale_a =
      scale_probe ? wmma_m32_fp4::scale_word_for_lane(lane)
                  : wmma_m32_fp4::neutral_scale_word;
  const int scale_b = wmma_m32_fp4::neutral_scale_word;

  asm volatile("v_wmma_scale_f32_32x16x128_f4 %0, %1, %2, %0, %3, %4"
               : "+v"(acc)
               : "v"(a), "v"(*reinterpret_cast<i32x8 *>(&b)), "v"(scale_a),
                 "v"(scale_b));

  for (int reg = 0; reg < 16; ++reg)
    out[lane * 16 + reg] = acc[reg];
}

int main() {
  constexpr int values = wmma_m32_fp4::lanes * wmma_m32_fp4::matrix_regs;
  corpus::DeviceBuffer<int> a(values), b(values);
  corpus::DeviceBuffer<float> output(values);

  wmma_m32_fp4::make_row_fingerprint_inputs(a.host, b.host);
  a.host_to_target();
  b.host_to_target();
  output.clear();
  hipLaunchKernelGGL(wmma_scale_m32_fp4_differential, dim3(1),
                     dim3(wmma_m32_fp4::lanes), 0, 0, output.device, a.device,
                     b.device, false);
  output.target_to_host();
  if (!corpus::expect_near("regular-Scale M32 FP4 consecutive-M16 row layout",
                           output.host,
                           wmma_m32_fp4::row_fingerprint_expected()))
    return 1;

  wmma_m32_fp4::make_scale_probe_inputs(a.host, b.host);
  a.host_to_target();
  b.host_to_target();
  output.clear();
  hipLaunchKernelGGL(wmma_scale_m32_fp4_differential, dim3(1),
                     dim3(wmma_m32_fp4::lanes), 0, 0, output.device, a.device,
                     b.device, true);
  output.target_to_host();
  return corpus::expect_near(
             "regular-Scale M32 FP4 direct A-scale lanes", output.host,
             wmma_m32_fp4::scale_probe_expected())
             ? 0
             : 1;
}
