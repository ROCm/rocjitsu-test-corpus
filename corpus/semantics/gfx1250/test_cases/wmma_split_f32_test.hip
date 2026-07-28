#include "test_support.hpp"

using f32x8 = float __attribute__((ext_vector_type(8)));
using i32x16 = int __attribute__((ext_vector_type(16)));

// Keep the four f32 K=128 forms in one independently runnable object with a
// uniform output layout.
extern "C" __global__ void wmma_k128_f32(float *out, const int *packed_a,
                                         const int *packed_b, int variant) {
  const int lane = static_cast<int>(threadIdx.x);
  i32x16 a, b;
  for (int i = 0; i < 16; ++i) {
    a[i] = packed_a[lane * 16 + i];
    b[i] = packed_b[lane * 16 + i];
  }
  f32x8 acc;
  for (int i = 0; i < 8; ++i)
    acc[i] = static_cast<float>(lane * 8 + i);
  if (variant == 0)
    asm volatile("v_wmma_f32_16x16x128_fp8_fp8 %0, %1, %2, %0"
                 : "+v"(acc)
                 : "v"(a), "v"(b));
  else if (variant == 1)
    asm volatile("v_wmma_f32_16x16x128_fp8_bf8 %0, %1, %2, %0"
                 : "+v"(acc)
                 : "v"(a), "v"(b));
  else if (variant == 2)
    asm volatile("v_wmma_f32_16x16x128_bf8_fp8 %0, %1, %2, %0"
                 : "+v"(acc)
                 : "v"(a), "v"(b));
  else
    asm volatile("v_wmma_f32_16x16x128_bf8_bf8 %0, %1, %2, %0"
                 : "+v"(acc)
                 : "v"(a), "v"(b));
  for (int i = 0; i < 8; ++i)
    out[lane * 8 + i] = acc[i];
}

int main() {
  constexpr int lanes = 32;
  corpus::DeviceBuffer<int> a(lanes * 16), b(lanes * 16);
  corpus::DeviceBuffer<float> output(lanes * 8);
  std::vector<float> expected(lanes * 8);
  for (int i = 0; i < lanes * 8; ++i)
    expected[i] = 128.0f + static_cast<float>(i);
  for (int variant = 0; variant < 4; ++variant) {
    const int a_word = variant >= 2 ? 0x3c3c3c3c : 0x38383838;
    const int b_word = (variant & 1) ? 0x3c3c3c3c : 0x38383838;
    std::fill(a.host.begin(), a.host.end(), a_word);
    std::fill(b.host.begin(), b.host.end(), b_word);
    a.host_to_target();
    b.host_to_target();
    output.clear();
    hipLaunchKernelGGL(wmma_k128_f32, dim3(1), dim3(lanes), 0, 0,
                       output.device, a.device, b.device, variant);
    output.target_to_host();
    if (!corpus::expect_near("K128 f32 WMMA tile", output.host, expected, 0.0,
                             variant))
      return 1;

    for (size_t i = 0; i < a.host.size(); ++i) {
      const int a_one = variant >= 2 ? 0x3c3c3c3c : 0x38383838;
      const int b_one = (variant & 1) ? 0x3c3c3c3c : 0x38383838;
      a.host[i] = ((i + variant) % 3) ? a_one : 0;
      b.host[i] = ((2 * i + variant) % 5) ? b_one : 0;
    }
    a.host_to_target();
    b.host_to_target();
    output.clear();
    hipLaunchKernelGGL(wmma_k128_f32, dim3(1), dim3(lanes), 0, 0,
                       output.device, a.device, b.device, variant);
    output.target_to_host();
    if (!corpus::expect_nonconstant_observation(
            "K128 f32 nonuniform tile", output.host, variant))
      return 1;
  }
  return 0;
}
