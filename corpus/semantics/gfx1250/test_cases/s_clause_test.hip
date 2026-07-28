#include "test_support.hpp"

#include <cstdint>

extern "C" __global__ void hard_clause_loads(float *out, const float *in) {
  const int tid = static_cast<int>(blockIdx.x * blockDim.x + threadIdx.x);
  const unsigned long first_address =
      reinterpret_cast<unsigned long>(in + 2 * tid);
  const unsigned long second_address =
      reinterpret_cast<unsigned long>(in + 2 * tid + 1);
  int first;
  int second;
  asm volatile("s_clause 1\n\t"
               "global_load_b32 %0, %2, off\n\t"
               "global_load_b32 %1, %3, off"
      : "=&v"(first), "=&v"(second)
               : "v"(first_address), "v"(second_address)
               : "memory");
  asm volatile("s_wait_loadcnt 0" ::: "memory");
  out[tid] = __int_as_float(first) + __int_as_float(second);
}

int main() {
  constexpr int count = 64;
  corpus::DeviceBuffer<float> input(2 * count);
  corpus::DeviceBuffer<float> output(count);
  std::vector<float> expected(count);
  for (int i = 0; i < 2 * count; ++i)
    input.host[i] = static_cast<float>(i % 19) - 4.0f;
  for (int i = 0; i < count; ++i)
    expected[i] = input.host[2 * i] + input.host[2 * i + 1];
  input.upload();
  output.clear();
  hipLaunchKernelGGL(hard_clause_loads, dim3(1), dim3(count), 0, 0,
                     output.device, input.device);
  output.download();
  return corpus::expect_near("hard-clause global loads", output.host, expected)
             ? 0
             : 1;
}
