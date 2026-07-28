#include "test_support.hpp"

using f32x16 = float __attribute__((ext_vector_type(16)));
using i32x8 = int __attribute__((ext_vector_type(8)));
using i32x16 = int __attribute__((ext_vector_type(16)));

// Standalone M=32 FP4 shape with an independently observable output tile.
extern "C" __global__ void wmma_m32_fp4(float *out, const int *packed_a,
                                        const int *packed_b) {
  const int lane = static_cast<int>(threadIdx.x);
  i32x16 a, b;
  for (int i = 0; i < 16; ++i) {
    a[i] = packed_a[lane * 16 + i];
    b[i] = packed_b[lane * 16 + i];
  }
  f32x16 acc;
  for (int i = 0; i < 16; ++i)
    acc[i] = static_cast<float>(lane * 16 + i);
  asm volatile("v_wmma_f32_32x16x128_f4 %0, %1, %2, %0"
               : "+v"(acc)
               : "v"(a), "v"(*reinterpret_cast<i32x8 *>(&b)));
  for (int i = 0; i < 16; ++i)
    out[lane * 16 + i] = acc[i];
}

int main() {
  constexpr int lanes = 32;
  corpus::DeviceBuffer<int> a(lanes * 16), b(lanes * 16);
  corpus::DeviceBuffer<float> output(lanes * 16);
  std::fill(a.host.begin(), a.host.end(), 0x22222222);
  std::fill(b.host.begin(), b.host.end(), 0x22222222);
  a.upload();
  b.upload();
  output.clear();
  hipLaunchKernelGGL(wmma_m32_fp4, dim3(1), dim3(lanes), 0, 0, output.device,
                     a.device, b.device);
  output.download();
  std::vector<float> expected(lanes * 16);
  for (int i = 0; i < lanes * 16; ++i)
    expected[i] = 128.0f + static_cast<float>(i);
  if (!corpus::expect_near("M32 FP4 WMMA tile", output.host, expected))
    return 1;
  for (size_t i = 0; i < a.host.size(); ++i) {
    a.host[i] = (i % 3) ? 0x22222222 : 0;
    b.host[i] = (i % 5) ? 0x22222222 : 0;
  }
  a.upload();
  b.upload();
  output.clear();
  hipLaunchKernelGGL(wmma_m32_fp4, dim3(1), dim3(lanes), 0, 0, output.device,
                     a.device, b.device);
  output.download();
  return corpus::expect_nonconstant_observation("M32 FP4 nonuniform tile",
                                                 output.host)
             ? 0
             : 1;
}
