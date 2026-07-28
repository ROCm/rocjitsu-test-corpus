#include "test_support.hpp"

#include <cstdint>

constexpr unsigned kLdsBytes = 5 * 1024;

// A fused activation staging pass. The affected load consumes an ordinary LDS
// store, then the affected store is consumed by an ordinary LDS load.
extern "C" __global__ void ds_addtid_stage(float *out, const float *in) {
  const int lane = static_cast<int>(threadIdx.x);
  constexpr unsigned offset = 64;
  constexpr unsigned lane_stride = 128;
  const unsigned strided_address = offset + lane * lane_stride;
  const unsigned linear_address = offset + lane * 4;
  constexpr float initial = 7.0f;
  // This kernel declares no static shared storage, so dynamic LDS starts at
  // byte offset zero and is exactly the window addressed by the inline DS ops.
  for (unsigned word = static_cast<unsigned>(lane); word < kLdsBytes / 4;
       word += blockDim.x) {
    asm volatile("ds_store_b32 %0, %1"
                 :
                 : "v"(word * 4), "v"(initial)
                 : "memory");
  }
  asm volatile("s_wait_dscnt 0" ::: "memory");
  __syncthreads();

  // M0[24:16] selects a nonzero per-thread dword stride. Observe both the
  // strided location and the corresponding linear location so the captured
  // result makes the chosen address behavior visible.
  asm volatile("s_mov_b32 m0, %0" : : "s"(2u << 20) : "memory");
  float first;
  asm volatile("ds_load_addtid_b32 %0 offset:64\n\t"
               "s_wait_dscnt 0"
               : "=v"(first)
               :
               : "memory");

  const float second = in[lane] + 2.0f;
  asm volatile("ds_store_addtid_b32 %0 offset:64\n\t"
               "s_wait_dscnt 0"
               :
               : "v"(second)
               : "memory");
  float observed_strided;
  float observed_linear;
  asm volatile("ds_load_b32 %0, %1\n\t"
               "s_wait_dscnt 0"
               : "=v"(observed_strided)
               : "v"(strided_address)
               : "memory");
  asm volatile("ds_load_b32 %0, %1\n\t"
               "s_wait_dscnt 0"
               : "=v"(observed_linear)
               : "v"(linear_address)
               : "memory");
  out[lane] = first + observed_strided + observed_linear;
}

int main() {
  // ADDTID's TID is wave-local (0..31), so one wave owns this staging tile.
  constexpr int lanes = 32;
  corpus::DeviceBuffer<float> input(lanes);
  corpus::DeviceBuffer<float> output(lanes);
  std::vector<float> expected(lanes);
  for (int i = 0; i < lanes; ++i) {
    input.host[i] = static_cast<float>(i) * 0.125f - 2.0f;
    // Lane zero aliases the two layouts, so both observations see the store;
    // every other lane sees one updated layout and one initialized layout.
    expected[i] =
        i == 0 ? 2.0f * input.host[i] + 11.0f : input.host[i] + 16.0f;
  }
  input.upload();
  output.clear();
  hipLaunchKernelGGL(ds_addtid_stage, dim3(1), dim3(lanes), kLdsBytes, 0,
                     output.device, input.device);
  output.download();
  return corpus::expect_near("addtid activation stage", output.host, expected) ? 0 : 1;
}
