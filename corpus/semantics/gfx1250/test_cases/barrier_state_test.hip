#include "test_support.hpp"

extern "C" __global__ void observe_barrier_state(unsigned *out) {
  const unsigned lane = threadIdx.x;
  unsigned state_minus_one;
  unsigned state_minus_two;
  unsigned first_scc;
  unsigned second_scc;

  asm volatile("s_cmp_eq_u32 0, 0\n\t"
               "s_get_barrier_state %0, -1\n\t"
               "s_cselect_b32 %2, 1, 0\n\t"
               "s_cmp_eq_u32 0, 0\n\t"
               "s_get_barrier_state %1, -2\n\t"
               "s_cselect_b32 %3, 1, 0"
               : "=s"(state_minus_one), "=s"(state_minus_two), "=s"(first_scc),
                 "=s"(second_scc)
               :
               : "scc", "memory");

  out[lane * 4] = state_minus_one;
  out[lane * 4 + 1] = state_minus_two;
  out[lane * 4 + 2] = first_scc;
  out[lane * 4 + 3] = second_scc;
}

int main() {
  constexpr unsigned lanes = 32;
  corpus::DeviceBuffer<unsigned> output(lanes * 4);
  std::vector<unsigned> expected(lanes * 4);
  for (unsigned lane = 0; lane < lanes; ++lane) {
    expected[lane * 4] = 0;
    expected[lane * 4 + 1] = 0;
    expected[lane * 4 + 2] = 1;
    expected[lane * 4 + 3] = 1;
  }

  output.clear();
  hipLaunchKernelGGL(observe_barrier_state, dim3(1), dim3(lanes), 0, 0,
                     output.device);
  output.target_to_host();
  return corpus::expect_equal("barrier-state fields and SCC", output.host,
                              expected)
             ? 0
             : 1;
}
