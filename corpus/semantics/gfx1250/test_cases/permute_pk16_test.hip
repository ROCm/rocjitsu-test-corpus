#include "test_support.hpp"

#include <cstdint>

using u32x2 = unsigned __attribute__((ext_vector_type(2)));
using u32x3 = unsigned __attribute__((ext_vector_type(3)));
using u32x4 = unsigned __attribute__((ext_vector_type(4)));

extern "C" __global__ void
preserve_masked_permute_destinations(unsigned *out, unsigned enable) {
  const unsigned lane = threadIdx.x;
  u32x2 result_b4 = {0x10400000u + lane, 0x10410000u + lane};
  u32x3 result_b6 = {
      0x10600000u + lane,
      0x10610000u + lane,
      0x10620000u + lane,
  };
  u32x4 result_b8 = {
      0x10800000u + lane,
      0x10810000u + lane,
      0x10820000u + lane,
      0x10830000u + lane,
  };
  const unsigned source32_a = 0x01234567u ^ lane;
  const unsigned source32_b = 0x89abcdefu ^ lane;
  const uint64_t source64_a = UINT64_C(0x0123456789abcdef) ^ lane;
  const uint64_t source64_b = UINT64_C(0xfedcba9876543210) ^ lane;
  const u32x2 selectors = {0x76543210u, 0xfedcba98u};
  uint64_t saved_exec;

  asm volatile("s_cmp_eq_u32 %9, 0\n\t"
               "s_cbranch_scc1 1f\n\t"
               "s_mov_b64 %0, exec\n\t"
               "s_mov_b64 exec, 0\n\t"
               "v_perm_pk16_b4_u4 %1, %4, %5, %8\n\t"
               "v_perm_pk16_b6_u4 %2, %4, %6, %8\n\t"
               "v_perm_pk16_b8_u4 %3, %6, %7, %8\n\t"
               "s_mov_b64 exec, %0\n\t"
               "1:"
               : "=&s"(saved_exec), "+v"(result_b4), "+v"(result_b6),
                 "+v"(result_b8)
               : "v"(source32_a), "v"(source32_b), "v"(source64_a),
                 "v"(source64_b), "v"(selectors), "s"(enable)
               : "scc", "memory");

  unsigned *lane_out = out + lane * 9;
  for (int i = 0; i < 2; ++i)
    lane_out[i] = result_b4[i];
  for (int i = 0; i < 3; ++i)
    lane_out[2 + i] = result_b6[i];
  for (int i = 0; i < 4; ++i)
    lane_out[5 + i] = result_b8[i];
}

int main() {
  constexpr unsigned lanes = 32;
  corpus::DeviceBuffer<unsigned> output(lanes * 9);
  std::vector<unsigned> expected(lanes * 9);
  for (unsigned lane = 0; lane < lanes; ++lane) {
    expected[lane * 9] = 0x10400000u + lane;
    expected[lane * 9 + 1] = 0x10410000u + lane;
    expected[lane * 9 + 2] = 0x10600000u + lane;
    expected[lane * 9 + 3] = 0x10610000u + lane;
    expected[lane * 9 + 4] = 0x10620000u + lane;
    expected[lane * 9 + 5] = 0x10800000u + lane;
    expected[lane * 9 + 6] = 0x10810000u + lane;
    expected[lane * 9 + 7] = 0x10820000u + lane;
    expected[lane * 9 + 8] = 0x10830000u + lane;
  }

  output.clear();
  hipLaunchKernelGGL(preserve_masked_permute_destinations, dim3(1), dim3(lanes),
                     0, 0, output.device, 0);
  output.target_to_host();
  return corpus::expect_equal("empty EXEC preserves permute destinations",
                              output.host, expected)
             ? 0
             : 1;
}
