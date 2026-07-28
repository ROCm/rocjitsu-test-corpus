#include "test_support.hpp"

#include <cstdint>

constexpr int kLanes = 32;
constexpr unsigned kLdsBase = 64 * 1024;
constexpr unsigned kInstructionOffset = 64;
constexpr unsigned kLdsBytes =
    kLdsBase + kInstructionOffset + kLanes * sizeof(float);
static_assert(kInstructionOffset == 64,
              "inline ADDTID instructions below encode offset:64");

// A fused activation staging pass. The affected load consumes an ordinary LDS
// store, then the affected store is consumed by an ordinary LDS load.
extern "C" __global__ void ds_addtid_stage(float *out, const float *in) {
  const int lane = static_cast<int>(threadIdx.x);
  const unsigned low_address = kInstructionOffset + lane * sizeof(float);
  const unsigned high_address = kLdsBase + low_address;
  const float low_initial = -1000.0f - static_cast<float>(lane);
  const float high_initial = 1000.0f + static_cast<float>(lane);
  // This kernel declares no static shared storage, so dynamic LDS starts at
  // byte offset zero and matches the absolute addresses used below. Initialize
  // the complete window so any unexpected address still produces a
  // deterministic observation.
  constexpr float unaddressed = -4096.0f;
  for (unsigned word = static_cast<unsigned>(lane); word < kLdsBytes / 4;
       word += blockDim.x) {
    asm volatile("ds_store_b32 %0, %1"
                 :
                 : "v"(word * 4), "v"(unaddressed)
                 : "memory");
  }
  asm volatile("ds_store_b32 %0, %1"
               :
               : "v"(low_address), "v"(low_initial)
               : "memory");
  asm volatile("ds_store_b32 %0, %1"
               :
               : "v"(high_address), "v"(high_initial)
               : "memory");
  asm volatile("s_wait_dscnt 0" ::: "memory");
  __syncthreads();

  // gfx1250 VDS ADDTID uses
  //   ((M0 + wave-local TID * 4) & 0xfffff) + offset16.
  // Exercise an M0 byte base above 64 KiB. The low alias is initialized to a
  // different lane-varying value so truncation and high/low confusion are
  // independently observable.
  asm volatile("s_mov_b32 m0, %0" : : "s"(kLdsBase) : "memory");
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
  float observed_high;
  float observed_low;
  asm volatile("ds_load_b32 %0, %1\n\t"
               "s_wait_dscnt 0"
               : "=v"(observed_high)
               : "v"(high_address)
               : "memory");
  asm volatile("ds_load_b32 %0, %1\n\t"
               "s_wait_dscnt 0"
               : "=v"(observed_low)
               : "v"(low_address)
               : "memory");
  out[lane] = first;
  out[kLanes + lane] = observed_high;
  out[2 * kLanes + lane] = observed_low;
}

int main() {
  // ADDTID's TID is wave-local (0..31), so one wave owns this staging tile.
  corpus::DeviceBuffer<float> input(kLanes);
  corpus::DeviceBuffer<float> output(3 * kLanes);
  std::vector<float> expected(3 * kLanes);
  for (int i = 0; i < kLanes; ++i) {
    input.host[i] = static_cast<float>(i) * 0.125f - 2.0f;
    expected[i] = 1000.0f + static_cast<float>(i);
    expected[kLanes + i] = input.host[i] + 2.0f;
    expected[2 * kLanes + i] = -1000.0f - static_cast<float>(i);
  }
  input.host_to_target();
  output.clear();
  HIP_CHECK(hipFuncSetAttribute(reinterpret_cast<void *>(ds_addtid_stage),
                                hipFuncAttributeMaxDynamicSharedMemorySize,
                                static_cast<int>(kLdsBytes)));
  hipLaunchKernelGGL(ds_addtid_stage, dim3(1), dim3(kLanes), kLdsBytes, 0,
                     output.device, input.device);
  output.target_to_host();
  return corpus::expect_near("addtid activation stage", output.host, expected)
             ? 0
             : 1;
}
