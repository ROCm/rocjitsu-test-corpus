#include "test_support.hpp"
#include "wmma_m32_fp4_differential.hpp"

using f32x16 = float __attribute__((ext_vector_type(16)));
using i32x2 = int __attribute__((ext_vector_type(2)));
using i32x8 = int __attribute__((ext_vector_type(8)));
using i32x16 = int __attribute__((ext_vector_type(16)));

extern "C" __global__ void wmma_scale16_m32_fp4_differential(
    float *out, const int *packed_a, const int *packed_b, int probe) {
  const int lane = static_cast<int>(threadIdx.x);
  i32x16 a, b;
  for (int reg = 0; reg < 16; ++reg) {
    a[reg] = packed_a[lane * 16 + reg];
    b[reg] = packed_b[lane * 16 + reg];
  }

  f32x16 acc;
  for (int reg = 0; reg < 16; ++reg) {
    const int row = wmma_m32_fp4::dbt_row(lane, reg);
    acc[reg] = probe == 0 ? static_cast<float>(4096 + 256 * row) : 0.0f;
  }
  const i32x2 scale_a{
      probe == 1 ? wmma_m32_fp4::scale_word_for_lane(lane, -16, 0)
                 : wmma_m32_fp4::neutral_scale_word,
      probe == 1 ? wmma_m32_fp4::scale_word_for_lane(lane, -16, 4)
                 : wmma_m32_fp4::neutral_scale_word};
  const i32x2 scale_b{
      probe == 2 ? wmma_m32_fp4::scale_word_for_lane(lane, -8, 0)
                 : wmma_m32_fp4::neutral_scale_word,
      probe == 2 ? wmma_m32_fp4::scale_word_for_lane(lane, -8, 4)
                 : wmma_m32_fp4::neutral_scale_word};

  asm volatile("v_wmma_scale16_f32_32x16x128_f4 "
               "%0, %1, %2, %0, %3, %4"
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
  hipLaunchKernelGGL(wmma_scale16_m32_fp4_differential, dim3(1),
                     dim3(wmma_m32_fp4::lanes), 0, 0, output.device, a.device,
                     b.device, 0);
  output.target_to_host();
  if (!corpus::expect_near(
          "Scale16 M32 FP4 packed row and column layout", output.host,
          wmma_m32_fp4::row_fingerprint_expected()))
    return 1;

  wmma_m32_fp4::make_scale_probe_inputs(a.host, b.host,
                                         /*scale_bytes=*/8);
  a.host_to_target();
  b.host_to_target();
  output.clear();
  hipLaunchKernelGGL(wmma_scale16_m32_fp4_differential, dim3(1),
                     dim3(wmma_m32_fp4::lanes), 0, 0, output.device, a.device,
                     b.device, 1);
  output.target_to_host();
  if (!corpus::expect_near(
          "Scale16 M32 FP4 aggregate A-scale byte groups and lanes",
          output.host,
          wmma_m32_fp4::scale_probe_expected(/*scale_bytes=*/8,
                                              /*matrix_a=*/true)))
    return 1;

  output.clear();
  hipLaunchKernelGGL(wmma_scale16_m32_fp4_differential, dim3(1),
                     dim3(wmma_m32_fp4::lanes), 0, 0, output.device, a.device,
                     b.device, 2);
  output.target_to_host();
  return corpus::expect_near(
             "Scale16 M32 FP4 aggregate B-scale byte groups and lanes",
             output.host,
             wmma_m32_fp4::scale_probe_expected(/*scale_bytes=*/8,
                                                 /*matrix_a=*/false))
             ? 0
             : 1;
}
