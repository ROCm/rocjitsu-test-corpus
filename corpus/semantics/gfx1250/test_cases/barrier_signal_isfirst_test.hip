#include "test_support.hpp"

// Two waves stage independent halves of a block and then consume the other
// half, like a block-local feature mixing pass. The SCC "is first" result is
// intentionally irrelevant; only the barrier arrival semantics matter.
extern "C" __global__ void cooperative_feature_mix(float *out, const float *in) {
  __shared__ float stage[64];
  const int lane = static_cast<int>(threadIdx.x);
  stage[lane] = 2.0f * in[lane] + 1.0f;
  asm volatile("s_barrier_signal_isfirst -1" ::: "memory", "scc");
  asm volatile("s_barrier_wait -1" ::: "memory");
  out[lane] = stage[lane] + stage[(lane + 32) & 63];
}

int main() {
  constexpr int lanes = 64;
  corpus::DeviceBuffer<float> input(lanes);
  corpus::DeviceBuffer<float> output(lanes);
  std::vector<float> expected(lanes);
  for (int i = 0; i < lanes; ++i)
    input.host[i] = static_cast<float>(i) * 0.25f - 4.0f;
  for (int i = 0; i < lanes; ++i)
    expected[i] = (2.0f * input.host[i] + 1.0f) +
                  (2.0f * input.host[(i + 32) & 63] + 1.0f);
  input.upload();
  output.clear();
  hipLaunchKernelGGL(cooperative_feature_mix, dim3(1), dim3(lanes), 0, 0,
                     output.device, input.device);
  output.download();
  return corpus::expect_near("two-wave feature mix", output.host, expected) ? 0 : 1;
}
