#include "test_support.hpp"

#include <cstdint>

constexpr uint32_t kAddtidLanes = 32;
constexpr uint32_t kAddtidOffset = 64;
constexpr uint32_t kAddtidLdsBytes =
    kAddtidOffset + kAddtidLanes * sizeof(uint32_t);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winline-asm"
extern "C" __global__ void ds_addtid_vgpr_pressure(uint32_t *values,
                                                   uint32_t *status) {
  uint32_t lane;
  uint32_t mismatch;
  uint32_t value;
  asm volatile("v_mov_b32 v254, v0\n\t"
               ".set pressure_vgpr, 0\n\t"
               ".rept 254\n\t"
               "v_mov_b32 v[pressure_vgpr], pressure_vgpr\n\t"
               ".set pressure_vgpr, pressure_vgpr + 1\n\t"
               ".endr\n\t"
               "v_mov_b32 v255, 255\n\t"
               "v_add_nc_u32 v8, 0x12340000, v254\n\t"
               "s_mov_b32 m0, 0\n\t"

               "ds_store_addtid_b32 v8 offset:64\n\t"
               "s_wait_dscnt 0\n\t"

               ".set pressure_vgpr, 0\n\t"
               ".rept 256\n\t"
               "v_mov_b32 v[pressure_vgpr], v[pressure_vgpr]\n\t"
               ".set pressure_vgpr, pressure_vgpr + 1\n\t"
               ".endr\n\t"
               "v_lshlrev_b32 v250, 2, v254\n\t"
               "ds_load_b32 v251, v250 offset:64\n\t"
               "s_wait_dscnt 0\n\t"
               "v_mov_b32 v255, 0\n\t"
               ".set pressure_vgpr, 0\n\t"
               ".rept 8\n\t"
               "v_xor_b32 v252, pressure_vgpr, v[pressure_vgpr]\n\t"
               "v_or_b32 v255, v255, v252\n\t"
               ".set pressure_vgpr, pressure_vgpr + 1\n\t"
               ".endr\n\t"
               "v_add_nc_u32 v252, 0x12340000, v254\n\t"
               "v_xor_b32 v252, v252, v8\n\t"
               "v_or_b32 v255, v255, v252\n\t"
               ".set pressure_vgpr, 9\n\t"
               ".rept 55\n\t"
               "v_xor_b32 v252, pressure_vgpr, v[pressure_vgpr]\n\t"
               "v_or_b32 v255, v255, v252\n\t"
               ".set pressure_vgpr, pressure_vgpr + 1\n\t"
               ".endr\n\t"
               "v_mov_b32 %0, v254\n\t"
               "v_mov_b32 %1, v255\n\t"
               "v_mov_b32 %2, v251"
               : "=&v"(lane), "=&v"(mismatch), "=&v"(value)
               :
               : "v254", "v255", "memory");
  values[lane] = value;
  status[lane] = mismatch;
}
#pragma clang diagnostic pop

int main() {
  corpus::DeviceBuffer<uint32_t> values(kAddtidLanes);
  corpus::DeviceBuffer<uint32_t> status(kAddtidLanes);
  values.clear();
  status.clear();
  hipLaunchKernelGGL(ds_addtid_vgpr_pressure, dim3(1), dim3(kAddtidLanes),
                     kAddtidLdsBytes, 0, values.device, status.device);
  values.target_to_host();
  status.target_to_host();

  std::vector<uint32_t> expected(kAddtidLanes);
  for (uint32_t lane = 0; lane < kAddtidLanes; ++lane)
    expected[lane] = 0x12340000u + lane;
  if (!corpus::expect_equal("ADDTID full-VGPR store", values.host, expected))
    return 1;
  return corpus::expect_equal("ADDTID full-VGPR preservation", status.host,
                              std::vector<uint32_t>(kAddtidLanes, 0))
             ? 0
             : 1;
}
