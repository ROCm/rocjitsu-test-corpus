#include "resource_pressure.hpp"
#include "test_support.hpp"

#include <cstdint>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winline-asm"
extern "C" __global__ void tensor_load_sgpr_pressure(
    uint32_t *values, uint32_t *status, const uint32_t *input) {
  const uint64_t address = reinterpret_cast<uint64_t>(input);
  uint32_t lane;
  uint32_t mismatch;
  uint32_t value;
  asm volatile("v_mov_b64 v[112:113], %3\n\t"
               CORPUS_SGPR_PRESSURE_SAVE
               CORPUS_SGPR_PRESSURE_INIT
               "s_mov_b32 s64, 1\n\t"
               "s_mov_b32 s65, 0\n\t"
               "v_readfirstlane_b32 s66, v112\n\t"
               "v_readfirstlane_b32 s67, v113\n\t"
               "s_or_b32 s67, s67, 0x80000000\n\t"
               "s_mov_b32 s72, 0x00020000\n\t"
               "s_mov_b32 s73, 0x00200000\n\t"
               "s_mov_b32 s74, 0\n\t"
               "s_mov_b32 s75, 0x00200000\n\t"
               "s_mov_b32 s76, 0\n\t"
               "s_mov_b32 s77, 0\n\t"
               "s_mov_b32 s78, 0\n\t"
               "s_mov_b32 s79, 0\n\t"

               "tensor_load_to_lds s[64:67], s[72:79]\n\t"
               "s_wait_tensorcnt 0\n\t"

               "v_lshlrev_b32 v114, 2, v102\n\t"
               "ds_load_b32 v115, v114\n\t"
               "s_wait_dscnt 0\n\t"
               CORPUS_SGPR_PRESSURE_BEGIN_CHECK
               "v_mov_b32 v104, s64\n\t"
               "v_xor_b32 v104, 1, v104\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               "v_mov_b32 v104, s65\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               "v_mov_b32 v104, s66\n\t"
               "v_xor_b32 v104, v112, v104\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               "v_or_b32 v116, 0x80000000, v113\n\t"
               "v_mov_b32 v104, s67\n\t"
               "v_xor_b32 v104, v116, v104\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               "v_mov_b32 v104, s72\n\t"
               "v_xor_b32 v104, 0x00020000, v104\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               "v_mov_b32 v104, s73\n\t"
               "v_xor_b32 v104, 0x00200000, v104\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               "v_mov_b32 v104, s74\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               "v_mov_b32 v104, s75\n\t"
               "v_xor_b32 v104, 0x00200000, v104\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               "v_mov_b32 v104, s76\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               "v_mov_b32 v104, s77\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               "v_mov_b32 v104, s78\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               "v_mov_b32 v104, s79\n\t"
               "v_or_b32 v103, v103, v104\n\t"
               ".set descriptor_sgpr, 64\n\t"
               ".rept 4\n\t"
               "s_mov_b32 s[descriptor_sgpr], descriptor_sgpr\n\t"
               ".set descriptor_sgpr, descriptor_sgpr + 1\n\t"
               ".endr\n\t"
               ".set descriptor_sgpr, 72\n\t"
               ".rept 8\n\t"
               "s_mov_b32 s[descriptor_sgpr], descriptor_sgpr\n\t"
               ".set descriptor_sgpr, descriptor_sgpr + 1\n\t"
               ".endr\n\t"
               CORPUS_SGPR_PRESSURE_ACCUMULATE_ALL
               CORPUS_SGPR_PRESSURE_RESTORE
               "v_mov_b32 %0, v102\n\t"
               "v_mov_b32 %1, v103\n\t"
               "v_mov_b32 %2, v115"
               : "=&v"(lane), "=&v"(mismatch), "=&v"(value)
               : "v"(address)
               : "s101", "v112", "v113", "v114", "v115", "v116", "v155",
                 "memory");
  values[lane] = value;
  status[lane] = mismatch;
}
#pragma clang diagnostic pop

int main() {
  constexpr uint32_t lanes = 32;
  corpus::DeviceBuffer<uint32_t> input(lanes);
  corpus::DeviceBuffer<uint32_t> values(lanes);
  corpus::DeviceBuffer<uint32_t> status(lanes);
  for (uint32_t lane = 0; lane < lanes; ++lane)
    input.host[lane] = 7u + 3u * lane;
  input.host_to_target();
  values.clear();
  status.clear();
  hipLaunchKernelGGL(tensor_load_sgpr_pressure, dim3(1), dim3(lanes),
                     lanes * sizeof(uint32_t), 0, values.device, status.device,
                     input.device);
  values.target_to_host();
  status.target_to_host();

  if (!corpus::expect_equal("tensor-load full-SGPR tile", values.host,
                            input.host))
    return 1;
  return corpus::expect_equal("tensor-load full-SGPR preservation", status.host,
                              std::vector<uint32_t>(lanes, 0))
             ? 0
             : 1;
}
