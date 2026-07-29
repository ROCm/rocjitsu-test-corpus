#include "resource_pressure.hpp"
#include "test_support.hpp"

#include <cstdint>

extern "C" __global__ void barrier_state_sgpr_pressure(
    uint32_t *states, uint32_t *status) {
  uint32_t lane;
  uint32_t mismatch;
  uint32_t state;
  asm volatile(CORPUS_SGPR_PRESSURE_SAVE
               CORPUS_SGPR_PRESSURE_INIT

               ".long 0xbe9450c1\n\t"
               "s_wait_kmcnt 0\n\t"

               CORPUS_SGPR_PRESSURE_BEGIN_CHECK
               "v_mov_b32 v112, s20\n\t"
               "s_mov_b32 s20, 20\n\t"
               CORPUS_SGPR_PRESSURE_ACCUMULATE_ALL
               CORPUS_SGPR_PRESSURE_RESTORE
               "v_mov_b32 %0, v102\n\t"
               "v_mov_b32 %1, v103\n\t"
               "v_mov_b32 %2, v112"
               : "=&v"(lane), "=&v"(mismatch), "=&v"(state)
               :
               : "s101", "v155", "memory");
  states[lane] = state;
  status[lane] = mismatch;
}
#pragma clang diagnostic pop

int main() {
  constexpr size_t lanes = 32;
  corpus::DeviceBuffer<uint32_t> states(lanes);
  corpus::DeviceBuffer<uint32_t> status(lanes);
  states.clear();
  status.clear();
  hipLaunchKernelGGL(barrier_state_sgpr_pressure, dim3(1), dim3(lanes), 0, 0,
                     states.device, status.device);
  states.target_to_host();
  status.target_to_host();

  if (!corpus::expect_equal("unused barrier full-SGPR state", states.host,
                            std::vector<uint32_t>(lanes, 0)))
    return 1;
  return corpus::expect_equal("barrier-state full-SGPR preservation",
                              status.host,
                              std::vector<uint32_t>(lanes, 0))
             ? 0
             : 1;
}
