#include "test_support.hpp"

#include <cmath>
#include <cstdint>
#include <limits>

// Isolated v_cvt_f32_fp8 CLAMP=1 coverage with every byte-select variant in
// one independently runnable object.
extern "C" __global__ void e5m3_unpack(float *out, const unsigned *packed,
                                       int byte_sel, int n) {
  const int tid = static_cast<int>(blockIdx.x * blockDim.x + threadIdx.x);
  if (tid >= n)
    return;
  const unsigned word = packed[tid];
  float value = 0.0f;
  if (byte_sel == 0)
    asm volatile("v_cvt_f32_fp8 %0, %1 byte_sel:0 clamp"
                 : "=v"(value)
                 : "v"(word));
  else if (byte_sel == 1)
    asm volatile("v_cvt_f32_fp8 %0, %1 byte_sel:1 clamp"
                 : "=v"(value)
                 : "v"(word));
  else if (byte_sel == 2)
    asm volatile("v_cvt_f32_fp8 %0, %1 byte_sel:2 clamp"
                 : "=v"(value)
                 : "v"(word));
  else
    asm volatile("v_cvt_f32_fp8 %0, %1 byte_sel:3 clamp"
                 : "=v"(value)
                 : "v"(word));
  out[tid] = value;
}

int main() {
  constexpr int n = 64;
  constexpr unsigned codes[] = {
      0x00, 0x01, 0x07, 0x08, 0x38, 0x3c, 0x78, 0x80,
      0xb7, 0xf0, 0xf7, 0xf8, 0xfa, 0xfc, 0xfe, 0xff,
  };
  corpus::DeviceBuffer<unsigned> packed(n);
  corpus::DeviceBuffer<float> output(n);

  for (int byte_sel = 0; byte_sel < 4; ++byte_sel) {
    std::vector<float> expected(n);
    for (int i = 0; i < n; ++i) {
      unsigned word = 0;
      for (int byte = 0; byte < 4; ++byte)
        word |= codes[(i + byte) % 16] << (8 * byte);
      packed.host[i] = word;
      expected[i] = corpus::decode_ue5m3((word >> (8 * byte_sel)) & 0xffu);
    }
    packed.upload();
    output.clear();
    hipLaunchKernelGGL(e5m3_unpack, dim3(1), dim3(64), 0, 0, output.device,
                       packed.device, byte_sel, n);
    output.download();
    if (!corpus::expect_near("UE5M3 unpack byte selection", output.host,
                             expected, 0.0, byte_sel))
      return 1;
  }
  return 0;
}
