#include "test_support.hpp"

using f32x16 = float __attribute__((ext_vector_type(16)));
using i32x2 = int __attribute__((ext_vector_type(2)));
using i32x8 = int __attribute__((ext_vector_type(8)));
using i32x16 = int __attribute__((ext_vector_type(16)));

// Combined M=32, K=128 Scale16 shape with uniform and lane-varying scales.
extern "C" __global__ void scale16_m32_gemm(
    float *out, const int *packed_a, const int *packed_b, bool nonuniform) {
  const int lane = static_cast<int>(threadIdx.x);
  i32x16 a, b;
  for (int i = 0; i < 16; ++i) {
    a[i] = packed_a[lane * 16 + i];
    b[i] = packed_b[lane * 16 + i];
  }
  f32x16 acc;
  for (int i = 0; i < 16; ++i)
    acc[i] = static_cast<float>(lane * 16 + i);
  const int scale_a_word =
      nonuniform ? ((lane & 1) ? 0x7e7f7e7f : 0x7f7e7f7e) : 0x7f7f7f7f;
  const int scale_b_word =
      nonuniform ? ((lane & 2) ? 0x7f7f7e7e : 0x7e7e7f7f) : 0x7f7f7f7f;
  const i32x2 scale_a{scale_a_word, scale_b_word};
  const i32x2 scale_b{scale_b_word, scale_a_word};
  asm volatile("v_wmma_scale16_f32_32x16x128_f4 "
               "%0, %1, %2, %0, %3, %4"
               : "+v"(acc)
               : "v"(a), "v"(*reinterpret_cast<i32x8 *>(&b)), "v"(scale_a),
                 "v"(scale_b));
  for (int i = 0; i < 16; ++i)
    out[lane * 16 + i] = acc[i];
}

int main() {
  constexpr int lanes = 32;
  corpus::DeviceBuffer<int> a(lanes * 16), b(lanes * 16);
  corpus::DeviceBuffer<float> output(lanes * 16);
  std::fill(a.host.begin(), a.host.end(), 0x22222222);
  std::fill(b.host.begin(), b.host.end(), 0x22222222);
  a.host_to_target();
  b.host_to_target();
  output.clear();
  hipLaunchKernelGGL(scale16_m32_gemm, dim3(1), dim3(lanes), 0, 0,
                     output.device, a.device, b.device, false);
  output.target_to_host();
  std::vector<float> expected(lanes * 16);
  for (int i = 0; i < lanes * 16; ++i)
    expected[i] = 128.0f + static_cast<float>(i);
  if (!corpus::expect_near("Scale16 M32 GEMM tile", output.host, expected))
    return 1;
  for (size_t i = 0; i < a.host.size(); ++i) {
    a.host[i] = (i % 3) ? 0x22222222 : 0;
    b.host[i] = (i % 5) ? 0x22222222 : 0;
  }
  a.host_to_target();
  b.host_to_target();
  output.clear();
  hipLaunchKernelGGL(scale16_m32_gemm, dim3(1), dim3(lanes), 0, 0,
                     output.device, a.device, b.device, true);
  output.target_to_host();
  return corpus::expect_nonconstant_observation(
             "Scale16 M32 nonuniform tile", output.host)
             ? 0
             : 1;
}
