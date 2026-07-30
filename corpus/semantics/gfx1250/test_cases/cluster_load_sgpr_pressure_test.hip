#include "resource_pressure.hpp"
#include "test_support.hpp"

#include <bit>
#include <cstdint>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winline-asm"
extern "C" __global__ void cluster_load_sgpr_pressure(
    float *values, uint32_t *status, const float *input) {
  const uint32_t tid =
      static_cast<uint32_t>(blockIdx.x * blockDim.x + threadIdx.x);
  const uint64_t address = reinterpret_cast<uint64_t>(input + tid);
  uint32_t output_tid;
  uint32_t mismatch;
  float value;
  asm volatile("v_mov_b64 v[112:113], %3\n\t"
               "v_mov_b32 v115, %4\n\t"
               CORPUS_SGPR_PRESSURE_SAVE
               CORPUS_SGPR_PRESSURE_INIT
               "s_mov_b32 m0, 0x12340000\n\t"

               "cluster_load_b32 v114, v[112:113], off\n\t"
               "s_wait_loadcnt 0\n\t"

               CORPUS_SGPR_PRESSURE_BEGIN_CHECK
               "v_mov_b32 v104, m0\n\t"
               "v_xor_b32 v104, 0x12340000, v104\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               CORPUS_SGPR_PRESSURE_ACCUMULATE_ALL
               CORPUS_SGPR_PRESSURE_RESTORE
               "v_mov_b32 %0, v115\n\t"
               "v_mov_b32 %1, v103\n\t"
               "v_mov_b32 %2, v114"
               : "=&v"(output_tid), "=&v"(mismatch), "=&v"(value)
               : "v"(address), "v"(tid)
               : "s101", "v112", "v113", "v114", "v115", "v155",
                 "memory");
  values[output_tid] = value;
  status[output_tid] = mismatch;
}
#pragma clang diagnostic pop

int main() {
  constexpr int blocks = 2;
  constexpr int lanes = 32;
  constexpr int count = blocks * lanes;
  corpus::DeviceBuffer<float> input(count);
  corpus::DeviceBuffer<float> values(count);
  corpus::DeviceBuffer<uint32_t> status(count);
  for (int i = 0; i < count; ++i)
    input.host[i] =
        std::bit_cast<float>(0x3f000000u | (static_cast<uint32_t>(i) + 1u));
  input.host_to_target();
  values.clear();
  status.clear();

  hipLaunchConfig_t config{};
  config.gridDim = dim3(blocks);
  config.blockDim = dim3(lanes);
  hipLaunchAttribute attribute{};
  attribute.id = hipLaunchAttributeClusterDimension;
  attribute.value.clusterDim.x = blocks;
  attribute.value.clusterDim.y = 1;
  attribute.value.clusterDim.z = 1;
  config.attrs = &attribute;
  config.numAttrs = 1;
  HIP_CHECK(hipLaunchKernelEx(&config, cluster_load_sgpr_pressure,
                              values.device, status.device, input.device));
  values.target_to_host();
  status.target_to_host();

  if (!corpus::expect_near("cluster full-SGPR load", values.host, input.host))
    return 1;
  return corpus::expect_equal("cluster full-SGPR and M0 preservation",
                              status.host,
                              std::vector<uint32_t>(count, 0))
             ? 0
             : 1;
}
