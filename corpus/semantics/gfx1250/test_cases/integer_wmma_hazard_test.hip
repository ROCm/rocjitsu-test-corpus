#include "test_support.hpp"

using i32x2 = int __attribute__((ext_vector_type(2)));
using i32x8 = int __attribute__((ext_vector_type(8)));
using i32x16 = int __attribute__((ext_vector_type(16)));

// Quantized GEMM followed immediately by an elementwise bias. The adjacent
// read/write of every D register is the co-execution hazard; storing all eight
// accumulators makes lost or stale results visible.
extern "C" __global__ void quantized_gemm_bias(int *out, int sparse) {
  const int lane = static_cast<int>(threadIdx.x);
  const i32x8 a{0x01010101, 0x01010101, 0x01010101, 0x01010101,
                0x01010101, 0x01010101, 0x01010101, 0x01010101};
  const i32x16 b{0x01010101, 0x01010101, 0x01010101, 0x01010101,
                 0x01010101, 0x01010101, 0x01010101, 0x01010101,
                 0x01010101, 0x01010101, 0x01010101, 0x01010101,
                 0x01010101, 0x01010101, 0x01010101, 0x01010101};
  i32x8 acc{};
  const i32x2 sparse_selector{};
  if (!sparse)
    asm volatile("v_wmma_i32_16x16x64_iu8 %0, %1, %2, %0"
                 : "+v"(acc) : "v"(a), "v"(a));
  else
    asm volatile("v_swmmac_i32_16x16x128_iu8 %0, %1, %2, %3"
                 : "+v"(acc) : "v"(a), "v"(b), "v"(sparse_selector));
  acc += i32x8{1, 1, 1, 1, 1, 1, 1, 1};
  for (int i = 0; i < 8; ++i)
    out[lane * 8 + i] = acc[i];
}

int main() {
  constexpr int count = 32 * 8;
  corpus::DeviceBuffer<int> output(count);
  const std::vector<int> expected(count, 65);
  for (int sparse = 0; sparse < 2; ++sparse) {
    output.clear();
    hipLaunchKernelGGL(quantized_gemm_bias, dim3(1), dim3(32), 0, 0,
                       output.device, sparse);
    output.target_to_host();
    if (!corpus::expect_equal(sparse ? "sparse quantized GEMM+bias"
                                     : "dense quantized GEMM+bias",
                              output.host, expected))
      return 1;
  }
  return 0;
}
