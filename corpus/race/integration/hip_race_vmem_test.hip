// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include "race_test_support.hpp"

#include <cstdint>
#include <vector>

namespace {

// Cases ending in _race must report a race; all other cases must remain clean.
using VmemRaceTest = rocjitsu::test::RaceTestBase;

__global__ void compiler_atomic_kernel(unsigned *values, unsigned *output) {
  const unsigned lane = threadIdx.x;
  output[lane] = atomicAdd(values + lane, 1u) * 3u;
}

// Keep the producer, explicit wait, and result use together so a compiler-added
// wait cannot hide the missing-wait controls or the VM-only regression.
template <bool VmWait, bool ExpWait>
__global__ void explicit_atomic_kernel(unsigned *values, unsigned *output) {
  const unsigned lane = threadIdx.x;
  unsigned old;
#if defined(__gfx1151__)
  asm volatile("global_atomic_add_u32 %[old], %[address], %[increment], off glc\n"
               "s_waitcnt vmcnt(%c[vm]) expcnt(%c[exp]) lgkmcnt(63)\n"
#else
  asm volatile("global_atomic_add %[old], %[address], %[increment], off sc0\n"
               "s_waitcnt vmcnt(%c[vm]) expcnt(%c[exp]) lgkmcnt(15)\n"
#endif
               "v_mov_b32 %[old], %[old]\n"
               : [old] "=&v"(old)
               : [address] "v"(values + lane), [increment] "v"(1u), [vm] "n"(VmWait ? 0 : 63),
                 [exp] "n"(ExpWait ? 0 : 7)
               : "memory");
  output[lane] = old * 3u;
}

template <bool CheckResult, typename Launch> void check_atomic_values(Launch launch) {
  // One full wave32 or half a wave64. Every case has one independently checked
  // dispatch and one expected report for an unsafe result use.
  constexpr unsigned lanes = 32;
  std::vector<unsigned> input(lanes), result(lanes);
  for (unsigned lane = 0; lane < lanes; ++lane)
    input[lane] = 17 + lane;
  unsigned *values = nullptr, *output = nullptr;
  RACE_HIP_CHECK(hipMalloc(&values, input.size() * sizeof(unsigned)));
  RACE_HIP_CHECK(hipMalloc(&output, result.size() * sizeof(unsigned)));
  RACE_HIP_CHECK(
      hipMemcpy(values, input.data(), input.size() * sizeof(unsigned), hipMemcpyHostToDevice));
  launch(values, output, lanes);
  RACE_HIP_CHECK(hipGetLastError());
  RACE_HIP_CHECK(hipDeviceSynchronize());
  RACE_HIP_CHECK(
      hipMemcpy(input.data(), values, input.size() * sizeof(unsigned), hipMemcpyDeviceToHost));
  RACE_HIP_CHECK(
      hipMemcpy(result.data(), output, result.size() * sizeof(unsigned), hipMemcpyDeviceToHost));
  for (unsigned lane = 0; lane < lanes; ++lane) {
    EXPECT_EQ(input[lane], 18 + lane);
    // A premature result read has no required numerical value.
    if constexpr (CheckResult)
      EXPECT_EQ(result[lane], (17 + lane) * 3u);
  }
  RACE_HIP_CHECK(hipFree(output));
  RACE_HIP_CHECK(hipFree(values));
}

TEST_F(VmemRaceTest, compiler_generated) {
  ASSERT_NO_FATAL_FAILURE(
      check_atomic_values<true>([](unsigned *values, unsigned *output, unsigned lanes) {
        compiler_atomic_kernel<<<1, lanes>>>(values, output);
      }));
  ExpectNoRace();
}

TEST_F(VmemRaceTest, vmcnt_only) {
  ASSERT_NO_FATAL_FAILURE(
      check_atomic_values<true>([](unsigned *values, unsigned *output, unsigned lanes) {
        explicit_atomic_kernel<true, false><<<1, lanes>>>(values, output);
      }));
  ExpectNoRace();
}

static constexpr rocjitsu::test::RaceExpectation kMissingVmWait{
    .kernel = "explicit_atomic_kernel",
    .type = "VGPR",
    .access = "read",
    .wave = 0,
    .lane = 0,
    .producer = "global_atomic_add",
    .consumer = "v_mov_b32",
};

TEST_F(VmemRaceTest, no_wait_race) {
  ASSERT_NO_FATAL_FAILURE(
      check_atomic_values<false>([](unsigned *values, unsigned *output, unsigned lanes) {
        explicit_atomic_kernel<false, false><<<1, lanes>>>(values, output);
      }));
  ExpectRace(kMissingVmWait);
}

TEST_F(VmemRaceTest, expcnt_only_race) {
  ASSERT_NO_FATAL_FAILURE(
      check_atomic_values<false>([](unsigned *values, unsigned *output, unsigned lanes) {
        explicit_atomic_kernel<false, true><<<1, lanes>>>(values, output);
      }));
  ExpectRace(kMissingVmWait);
}

// Keep both writes to the same VGPR inside one asm block. The atomic result
// must remain pending when the second producer issues; only the final wait
// precedes the result read. GLOBAL writeback shares the atomic's VMEM ordering
// class, while a VALU overwrite has no such ordering guarantee.
template <bool GlobalOverwrite>
__global__ void atomic_waw_kernel(unsigned *values, const unsigned *loaded, unsigned *output) {
  const unsigned lane = threadIdx.x;
  unsigned value;
  if constexpr (GlobalOverwrite) {
#if defined(__gfx1151__)
    asm volatile("global_atomic_add_u32 %[value], %[atomic_address], "
                 "%[increment], off glc\n"
                 "global_load_b32 %[value], %[load_address], off\n"
#else
    asm volatile("global_atomic_add %[value], %[atomic_address], %[increment], off sc0\n"
                 "global_load_dword %[value], %[load_address], off\n"
#endif
                 "s_waitcnt vmcnt(0) expcnt(7)\n"
                 : [value] "=&v"(value)
                 : [atomic_address] "v"(values + lane), [increment] "v"(1u),
                   [load_address] "v"(loaded + lane)
                 : "memory");
  } else {
#if defined(__gfx1151__)
    asm volatile("global_atomic_add_u32 %[value], %[atomic_address], "
                 "%[increment], off glc\n"
#else
    asm volatile("global_atomic_add %[value], %[atomic_address], %[increment], off sc0\n"
#endif
                 "v_mov_b32 %[value], 101\n"
                 "s_waitcnt vmcnt(0) expcnt(7)\n"
                 : [value] "=&v"(value)
                 : [atomic_address] "v"(values + lane), [increment] "v"(1u)
                 : "memory");
  }
  output[lane] = value;
}

template <bool GlobalOverwrite> void check_atomic_waw_values() {
  constexpr unsigned lanes = 32;
  std::vector<unsigned> input(lanes), loaded(lanes), result(lanes);
  for (unsigned lane = 0; lane < lanes; ++lane) {
    input[lane] = 17 + lane;
    loaded[lane] = 101 + lane;
  }
  unsigned *values = nullptr, *load_source = nullptr, *output = nullptr;
  RACE_HIP_CHECK(hipMalloc(&values, lanes * sizeof(unsigned)));
  RACE_HIP_CHECK(hipMalloc(&load_source, lanes * sizeof(unsigned)));
  RACE_HIP_CHECK(hipMalloc(&output, lanes * sizeof(unsigned)));
  RACE_HIP_CHECK(hipMemcpy(values, input.data(), lanes * sizeof(unsigned), hipMemcpyHostToDevice));
  RACE_HIP_CHECK(
      hipMemcpy(load_source, loaded.data(), lanes * sizeof(unsigned), hipMemcpyHostToDevice));
  atomic_waw_kernel<GlobalOverwrite><<<1, lanes>>>(values, load_source, output);
  RACE_HIP_CHECK(hipGetLastError());
  RACE_HIP_CHECK(hipDeviceSynchronize());
  RACE_HIP_CHECK(hipMemcpy(input.data(), values, lanes * sizeof(unsigned), hipMemcpyDeviceToHost));
  RACE_HIP_CHECK(hipMemcpy(result.data(), output, lanes * sizeof(unsigned), hipMemcpyDeviceToHost));
  for (unsigned lane = 0; lane < lanes; ++lane) {
    EXPECT_EQ(input[lane], 18 + lane);
    // The unordered VALU overwrite can lose to the atomic writeback.
    if constexpr (GlobalOverwrite)
      EXPECT_EQ(result[lane], loaded[lane]);
  }
  RACE_HIP_CHECK(hipFree(output));
  RACE_HIP_CHECK(hipFree(load_source));
  RACE_HIP_CHECK(hipFree(values));
}

TEST_F(VmemRaceTest, atomic_global_same_vgpr) {
  ASSERT_NO_FATAL_FAILURE(check_atomic_waw_values<true>());
  ExpectNoRace();
}

TEST_F(VmemRaceTest, atomic_valu_overwrite_race) {
  ASSERT_NO_FATAL_FAILURE(check_atomic_waw_values<false>());
  ExpectRace({.kernel = "atomic_waw_kernel",
              .type = "VGPR",
              .access = "write",
              .wave = 0,
              .lane = 0,
              .producer = "global_atomic_add",
              .consumer = "v_mov_b32"});
}

// Exchange data across waves through generic FLAT accesses. Drain the memory
// counters without waiting on EXP; the synchronized case must retire its LDS
// writes at the barrier, while the missing-barrier case must still report.
template <bool Synchronized> __global__ void flat_lds_exchange_kernel(unsigned *output) {
  __shared__ unsigned tile[128];
  const unsigned tid = threadIdx.x;
  const uint64_t write_address = reinterpret_cast<uint64_t>(&tile[tid]);
#if defined(__gfx1151__)
  asm volatile("flat_store_b32 %[address], %[value]\n"
               "s_waitcnt vmcnt(0) lgkmcnt(0) expcnt(7)\n"
               "s_waitcnt_vscnt null, 0\n"
#else
  asm volatile("flat_store_dword %[address], %[value]\n"
               "s_waitcnt vmcnt(0) lgkmcnt(0) expcnt(7)\n"
#endif
               :
               : [address] "v"(write_address), [value] "v"(tid + 11)
               : "memory");
  if constexpr (Synchronized)
    __syncthreads();
  const uint64_t read_address = reinterpret_cast<uint64_t>(&tile[127 - tid]);
  unsigned value;
#if defined(__gfx1151__)
  asm volatile("flat_load_b32 %[value], %[address]\n"
#else
  asm volatile("flat_load_dword %[value], %[address]\n"
#endif
               "s_waitcnt vmcnt(0) lgkmcnt(0) expcnt(7)\n"
               : [value] "=v"(value)
               : [address] "v"(read_address)
               : "memory");
  output[tid] = value;
}

template <bool Synchronized> void check_flat_lds_exchange() {
  unsigned *output = nullptr;
  std::vector<unsigned> result(128);
  RACE_HIP_CHECK(hipMalloc(&output, result.size() * sizeof(unsigned)));
  flat_lds_exchange_kernel<Synchronized><<<1, 128>>>(output);
  RACE_HIP_CHECK(hipGetLastError());
  RACE_HIP_CHECK(hipDeviceSynchronize());
  RACE_HIP_CHECK(
      hipMemcpy(result.data(), output, result.size() * sizeof(unsigned), hipMemcpyDeviceToHost));
  if constexpr (Synchronized) {
    for (unsigned tid = 0; tid < result.size(); ++tid)
      EXPECT_EQ(result[tid], 127 - tid + 11);
  }
  RACE_HIP_CHECK(hipFree(output));
}

TEST_F(VmemRaceTest, flat_lds_exchange) {
  ASSERT_NO_FATAL_FAILURE(check_flat_lds_exchange<true>());
  ExpectNoRace();
}

TEST_F(VmemRaceTest, flat_lds_exchange_race) {
  ASSERT_NO_FATAL_FAILURE(check_flat_lds_exchange<false>());
  ExpectRace({.kernel = "flat_lds_exchange_kernel",
              .type = "LDS",
              .access = "read",
              .producer = "flat_store",
              .consumer = "flat_load"});
}

} // namespace
