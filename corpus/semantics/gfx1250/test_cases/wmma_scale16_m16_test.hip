#include "test_support.hpp"

using f32x8 = float __attribute__((ext_vector_type(8)));
using i32x2 = int __attribute__((ext_vector_type(2)));
using i32x8 = int __attribute__((ext_vector_type(8)));
using i32x16 = int __attribute__((ext_vector_type(16)));

// Default FP8, BF8, and FP4 inputs cover the M=16 Scale16 lane-mask and
// compact-VGPR behaviors.
extern "C" __global__ void scale16_m16_gemm(
    float *out, const int *packed_a, const int *packed_b, int variant,
    bool nonuniform) {
  const int lane = static_cast<int>(threadIdx.x);
  i32x16 a, b;
  for (int i = 0; i < 16; ++i) {
    a[i] = packed_a[lane * 16 + i];
    b[i] = packed_b[lane * 16 + i];
  }
  f32x8 acc;
  for (int i = 0; i < 8; ++i)
    acc[i] = static_cast<float>(lane * 8 + i);
  const int scale_a_word =
      nonuniform ? ((lane & 1) ? 0x7e7f7e7f : 0x7f7e7f7e) : 0x7f7f7f7f;
  const int scale_b_word =
      nonuniform ? ((lane & 2) ? 0x7f7f7e7e : 0x7e7e7f7f) : 0x7f7f7f7f;
  const i32x2 scale_a{scale_a_word, scale_b_word};
  const i32x2 scale_b{scale_b_word, scale_a_word};
  if (variant == 0)
    asm volatile("v_wmma_scale16_f32_16x16x128_f8f6f4 "
                 "%0, %1, %2, %0, %3, %4"
                 : "+v"(acc)
                 : "v"(a), "v"(b), "v"(scale_a), "v"(scale_b));
  else if (variant == 1)
    asm volatile("v_wmma_scale16_f32_16x16x128_f8f6f4 "
                 "%0, %1, %2, %0, %3, %4 "
                 "matrix_a_fmt:MATRIX_FMT_BF8 matrix_b_fmt:MATRIX_FMT_BF8"
                 : "+v"(acc)
                 : "v"(a), "v"(b), "v"(scale_a), "v"(scale_b));
  else
    asm volatile("v_wmma_scale16_f32_16x16x128_f8f6f4 "
                 "%0, %1, %2, %0, %3, %4 "
                 "matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4"
                 : "+v"(acc)
                 : "v"(*reinterpret_cast<i32x8 *>(&a)),
                   "v"(*reinterpret_cast<i32x8 *>(&b)), "v"(scale_a),
                   "v"(scale_b));
  for (int i = 0; i < 8; ++i)
    out[lane * 8 + i] = acc[i];
}

int main() {
  constexpr int lanes = 32;
  corpus::DeviceBuffer<int> a(lanes * 16), b(lanes * 16);
  corpus::DeviceBuffer<float> output(lanes * 8);
  for (int variant = 0; variant < 3; ++variant) {
    const int one = variant == 0 ? 0x38383838
                    : variant == 1 ? 0x3c3c3c3c
                                   : 0x22222222;
    std::fill(a.host.begin(), a.host.end(), one);
    std::fill(b.host.begin(), b.host.end(), one);
    a.host_to_target();
    b.host_to_target();
    output.clear();
    hipLaunchKernelGGL(scale16_m16_gemm, dim3(1), dim3(lanes), 0, 0,
                       output.device, a.device, b.device, variant, false);
    output.target_to_host();
    std::vector<float> expected(lanes * 8);
    for (int i = 0; i < lanes * 8; ++i)
      expected[i] = 128.0f + static_cast<float>(i);
    if (!corpus::expect_near("Scale16 M16 GEMM tile", output.host, expected,
                             0.0, variant))
      return 1;

    for (size_t i = 0; i < a.host.size(); ++i) {
      a.host[i] = (i % 3) ? one : 0;
      b.host[i] = (i % 5) ? one : 0;
    }
    a.host_to_target();
    b.host_to_target();
    output.clear();
    hipLaunchKernelGGL(scale16_m16_gemm, dim3(1), dim3(lanes), 0, 0,
                       output.device, a.device, b.device, variant, true);
    output.target_to_host();
    if (!corpus::expect_nonconstant_observation(
            "Scale16 M16 nonuniform tile", output.host, variant))
      return 1;
  }
  return 0;
}
