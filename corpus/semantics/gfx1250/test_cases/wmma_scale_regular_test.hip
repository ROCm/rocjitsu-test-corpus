#include "test_support.hpp"

using f32x8 = float __attribute__((ext_vector_type(8)));
using f32x16 = float __attribute__((ext_vector_type(16)));
using i32x2 = int __attribute__((ext_vector_type(2)));
using i32x8 = int __attribute__((ext_vector_type(8)));
using i32x16 = int __attribute__((ext_vector_type(16)));

// Keep regular-scale M=16 and M=32 plus the bare mixed-format WMMA in one
// independently runnable object. Scale16 uses separate fixtures because its
// operand and output layouts differ.
extern "C" __global__ void regular_scaled_gemm(
    float *out, const int *packed_a, const int *packed_b, int variant,
    bool nonuniform) {
  const int lane = static_cast<int>(threadIdx.x);
  i32x16 a, b;
  for (int i = 0; i < 16; ++i) {
    a[i] = packed_a[lane * 16 + i];
    b[i] = packed_b[lane * 16 + i];
  }
  f32x8 acc;
  f32x16 acc_m32;
  for (int i = 0; i < 8; ++i)
    acc[i] = static_cast<float>(lane * 8 + i);
  for (int i = 0; i < 16; ++i)
    acc_m32[i] = static_cast<float>(lane * 16 + i);
  const int scale_a_word =
      nonuniform ? ((lane & 1) ? 0x7e7f7e7f : 0x7f7e7f7e) : 0x7f7f7f7f;
  const int scale_b_word =
      nonuniform ? ((lane & 2) ? 0x7f7f7e7e : 0x7e7e7f7f) : 0x7f7f7f7f;
  const i32x2 scale_a{scale_a_word, scale_b_word};
  const i32x2 scale_b{scale_b_word, scale_a_word};
  if (variant == 0)
    asm volatile("v_wmma_scale_f32_16x16x128_f8f6f4 %0, %1, %2, %0, %3, %4"
                 : "+v"(acc)
                 : "v"(a), "v"(b), "v"(scale_a[0]), "v"(scale_b[0]));
  else if (variant == 1)
    asm volatile("v_wmma_scale_f32_32x16x128_f4 %0, %1, %2, %0, %3, %4"
                 : "+v"(acc_m32)
                 : "v"(a), "v"(*reinterpret_cast<i32x8 *>(&b)),
                   "v"(scale_a[0]), "v"(scale_b[0]));
  else
    asm volatile("v_wmma_f32_16x16x128_f8f6f4 %0, %1, %2, %0 "
                 "matrix_a_fmt:MATRIX_FMT_FP4 matrix_b_fmt:MATRIX_FMT_FP4"
                 : "+v"(acc)
                 : "v"(*reinterpret_cast<i32x8 *>(&a)),
                   "v"(*reinterpret_cast<i32x8 *>(&b)));
  if (variant == 1)
    for (int i = 0; i < 16; ++i)
      out[lane * 16 + i] = acc_m32[i];
  else
    for (int i = 0; i < 8; ++i)
      out[lane * 8 + i] = acc[i];
}

int main() {
  constexpr int lanes = 32;
  corpus::DeviceBuffer<int> a(lanes * 16), b(lanes * 16);
  corpus::DeviceBuffer<float> output(lanes * 16);
  for (int variant = 0; variant < 3; ++variant) {
    const int one = variant == 0 ? 0x38383838 : 0x22222222;
    std::fill(a.host.begin(), a.host.end(), one);
    std::fill(b.host.begin(), b.host.end(), one);
    a.host_to_target();
    b.host_to_target();
    output.clear();
    hipLaunchKernelGGL(regular_scaled_gemm, dim3(1), dim3(lanes), 0, 0,
                       output.device, a.device, b.device, variant, false);
    output.target_to_host();
    const size_t count = lanes * (variant == 1 ? 16 : 8);
    std::vector<float> actual(output.host.begin(), output.host.begin() + count);
    std::vector<float> expected(count);
    for (size_t i = 0; i < count; ++i)
      expected[i] = 128.0f + static_cast<float>(i);
    if (!corpus::expect_near("regular-scale GEMM tile", actual, expected, 0.0,
                             variant))
      return 1;

    for (size_t i = 0; i < a.host.size(); ++i) {
      a.host[i] = (i % 3) ? one : 0;
      b.host[i] = (i % 5) ? one : 0;
    }
    a.host_to_target();
    b.host_to_target();
    output.clear();
    hipLaunchKernelGGL(regular_scaled_gemm, dim3(1), dim3(lanes), 0, 0,
                       output.device, a.device, b.device, variant, true);
    output.target_to_host();
    std::vector<float> observed(output.host.begin(),
                                output.host.begin() + count);
    if (!corpus::expect_nonconstant_observation(
            "regular-scale nonuniform tile", observed, variant))
      return 1;
  }
  return 0;
}
