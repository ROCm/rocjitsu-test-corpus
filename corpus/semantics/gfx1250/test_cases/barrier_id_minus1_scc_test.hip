#include "test_support.hpp"

// The s_get_barrier_state instruction itself does not modify SCC.
extern "C" __global__ void check_barrier_id_minus1_scc(unsigned *out,
                                                       unsigned initial_scc) {
  const unsigned lane = threadIdx.x;
  unsigned ignored_state;
  unsigned preserved_scc;

  asm volatile("s_cmp_lg_u32 %2, 0\n\t"
               "s_get_barrier_state %0, -1\n\t"
               "s_cselect_b32 %1, 1, 0"
               : "=s"(ignored_state), "=s"(preserved_scc)
               : "s"(initial_scc)
               : "scc", "memory");

  out[lane] = preserved_scc;
}

int main() {
  constexpr unsigned lanes = 32;
  corpus::DeviceBuffer<unsigned> output(lanes);
  std::vector<unsigned> expected(lanes);
  bool ok = true;

  for (unsigned initial_scc = 0; initial_scc < 2; ++initial_scc) {
    std::fill(expected.begin(), expected.end(), initial_scc);
    output.clear();
    hipLaunchKernelGGL(check_barrier_id_minus1_scc, dim3(1), dim3(lanes), 0, 0,
                       output.device, initial_scc);
    output.target_to_host();
    ok &= corpus::expect_equal("barrier ID -1 SCC preservation", output.host,
                               expected, initial_scc);
  }
  return ok ? 0 : 1;
}
