// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include "race_test_support.hpp"

#include <cstdint>
#include <cstdio>
#include <vector>

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  int rc = RUN_ALL_TESTS();
  const hipError_t reset_status = hipDeviceReset();
  if (reset_status != hipSuccess) {
    std::fprintf(stderr, "hipDeviceReset failed: %s\n", hipGetErrorString(reset_status));
    return 1;
  }
  return rc;
}

namespace {

using Gfx942RaceTest = rocjitsu::test::RaceTestBase;

// --- LDS writer that ends before the barrier ---

// Wave 1 writes LDS and ends without reaching the barrier; wave 0 then passes
// s_barrier and reads the bytes. The barrier resolves only after wave 1 has
// ended, so it orders a write that wave 1 waited for. Without the wait, the
// write may still be in flight when wave 0 reads it.
template <bool WaitBeforeExit>
__attribute__((amdgpu_flat_work_group_size(128, 128)))
__global__ void exited_lds_writer_kernel(unsigned *out) {
  __shared__ unsigned tile[128];
  const unsigned tid = threadIdx.x;
  const unsigned address = static_cast<unsigned>(reinterpret_cast<uintptr_t>(&tile[tid]));
  if (__builtin_amdgcn_readfirstlane(tid) >= 64) {
    if constexpr (WaitBeforeExit)
      asm volatile("ds_write_b32 %[address], %[value]\n"
                   "s_waitcnt lgkmcnt(0)\n"
                   :
                   : [address] "v"(address), [value] "v"(tid + 11)
                   : "memory");
    else
      asm volatile("ds_write_b32 %[address], %[value]\n"
                   :
                   : [address] "v"(address), [value] "v"(tid + 11)
                   : "memory");
    return;
  }
  unsigned value;
  // Wave 0 reads the dword wave 1 wrote, 64 dwords (256 bytes) further on.
  asm volatile("s_barrier\n"
               "ds_read_b32 %[value], %[address] offset:256\n"
               "s_waitcnt lgkmcnt(0)\n"
               : [value] "=v"(value)
               : [address] "v"(address)
               : "memory");
  out[tid] = value;
}

TEST_F(Gfx942RaceTest, exited_lds_writer) {
  unsigned *out = alloc<unsigned>(64);
  exited_lds_writer_kernel<true><<<1, 128>>>(out);
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  std::vector<unsigned> expected(64);
  for (unsigned tid = 0; tid < expected.size(); ++tid)
    expected[tid] = 64 + tid + 11;
  ExpectValues(out, expected);
  ExpectNoRace();
}

TEST_F(Gfx942RaceTest, exited_lds_writer_race) {
  exited_lds_writer_kernel<false><<<1, 128>>>(alloc<unsigned>(64));
  RACE_HIP_CHECK(hipGetLastError());
  sync();
  ExpectRace({.kernel = "exited_lds_writer_kernel",
              .type = "LDS",
              .access = "read",
              .wave = 0,
              .lane = 0,
              .producer = "ds_write_b32",
              .consumer = "ds_read_b32"});
}

} // namespace
