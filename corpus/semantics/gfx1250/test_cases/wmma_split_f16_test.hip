#include "test_support.hpp"

using i32x4 = int __attribute__((ext_vector_type(4)));
using i32x16 = int __attribute__((ext_vector_type(16)));

__host__ __device__ static unsigned half_seed(unsigned index) {
  constexpr unsigned values[] = {0x0000, 0x3c00, 0x4000, 0x4200};
  return values[index & 3u];
}

__host__ __device__ static unsigned half_expected(unsigned index) {
  constexpr unsigned values[] = {0x5800, 0x5808, 0x5810, 0x5818};
  return values[index & 3u];
}

// Keep all four f16 K=128 input-format combinations in one runnable object.
extern "C" __global__ void wmma_k128_f16(int *out, const int *packed_a,
                                         const int *packed_b, int variant) {
  const int lane = static_cast<int>(threadIdx.x);
  i32x16 a, b;
  for (int i = 0; i < 16; ++i) {
    a[i] = packed_a[lane * 16 + i];
    b[i] = packed_b[lane * 16 + i];
  }
  i32x4 acc;
  for (int i = 0; i < 4; ++i) {
    const unsigned element = static_cast<unsigned>(lane * 8 + 2 * i);
    acc[i] = static_cast<int>(half_seed(element) |
                              (half_seed(element + 1) << 16));
  }
  if (variant == 0)
    asm volatile("v_wmma_f16_16x16x128_fp8_fp8 %0, %1, %2, %0"
                 : "+v"(acc)
                 : "v"(a), "v"(b));
  else if (variant == 1)
    asm volatile("v_wmma_f16_16x16x128_fp8_bf8 %0, %1, %2, %0"
                 : "+v"(acc)
                 : "v"(a), "v"(b));
  else if (variant == 2)
    asm volatile("v_wmma_f16_16x16x128_bf8_fp8 %0, %1, %2, %0"
                 : "+v"(acc)
                 : "v"(a), "v"(b));
  else
    asm volatile("v_wmma_f16_16x16x128_bf8_bf8 %0, %1, %2, %0"
                 : "+v"(acc)
                 : "v"(a), "v"(b));
  for (int i = 0; i < 4; ++i)
    out[lane * 4 + i] = acc[i];
}

int main() {
  constexpr int lanes = 32;
  corpus::DeviceBuffer<int> a(lanes * 16), b(lanes * 16);
  corpus::DeviceBuffer<int> output(lanes * 4);
  std::vector<int> expected(lanes * 4);
  for (int lane = 0; lane < lanes; ++lane) {
    for (int i = 0; i < 4; ++i) {
      const unsigned element = static_cast<unsigned>(lane * 8 + 2 * i);
      expected[lane * 4 + i] = static_cast<int>(
          half_expected(element) | (half_expected(element + 1) << 16));
    }
  }
  for (int variant = 0; variant < 4; ++variant) {
    const int a_word = variant >= 2 ? 0x3c3c3c3c : 0x38383838;
    const int b_word = (variant & 1) ? 0x3c3c3c3c : 0x38383838;
    std::fill(a.host.begin(), a.host.end(), a_word);
    std::fill(b.host.begin(), b.host.end(), b_word);
    a.host_to_target();
    b.host_to_target();
    output.clear();
    hipLaunchKernelGGL(wmma_k128_f16, dim3(1), dim3(lanes), 0, 0,
                       output.device, a.device, b.device, variant);
    output.target_to_host();
    if (!corpus::expect_equal("K128 f16 WMMA tile", output.host, expected,
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
    hipLaunchKernelGGL(wmma_k128_f16, dim3(1), dim3(lanes), 0, 0,
                       output.device, a.device, b.device, variant);
    output.target_to_host();
    if (!corpus::expect_nonconstant_observation(
            "K128 f16 nonuniform tile", output.host, variant))
      return 1;
  }
  return 0;
}
