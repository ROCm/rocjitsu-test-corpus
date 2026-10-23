// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#pragma once

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include "race_log_expectation.hpp"

#include <cstdint>
#include <cstdio>
#include <stdexcept>
#include <string>
#include <vector>

namespace rocjitsu::test {

// Throwing stops the current GoogleTest body, including callers of pointer-
// returning fixture helpers. A nonfatal expectation would continue with an
// invalid allocation or incomplete copy. Deliberately racy kernels still
// require successful HIP operations; only their detector findings may differ.
inline void checkHip(hipError_t status, const char *operation, const char *file, int line) {
  if (status != hipSuccess)
    throw std::runtime_error(std::string(operation) + " failed: " + hipGetErrorString(status) +
                             " (" + std::to_string(status) + ") at " + file + ":" +
                             std::to_string(line));
}

#define RACE_HIP_CHECK(operation)                                                                  \
  ::rocjitsu::test::checkHip((operation), #operation, __FILE__, __LINE__)

/// Common issue-capacity probes. Target suites instantiate these with their
/// architectural counter capacities and keep target-specific expectations.
template <int YoungerLoads> __global__ void vmcnt_capacity_kernel(const float *src, float *dst) {
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  float producer, younger, result;
  asm volatile("global_load_dword %[producer], %[address], off\n"
               ".rept %c[younger_loads]\n"
               "global_load_dword %[younger], %[address], off\n"
               ".endr\n"
               "v_mov_b32 %[result], %[producer]\n"
               : [producer] "=&v"(producer), [younger] "=&v"(younger), [result] "=&v"(result)
               : [address] "v"(&src[tid]), [younger_loads] "n"(YoungerLoads)
               : "memory");
  dst[tid] = result;
}

/// The younger LGKMCNT operations are LDS writes of the value already stored.
/// They complete in order with the producer read, but unlike repeated loads
/// into one VGPR they leave no destination overwrite hazards of their own.
template <int YoungerWrites> __global__ void lgkmcnt_capacity_kernel(int *dst) {
  __shared__ int lds[64];
  int tid = threadIdx.x;
  lds[tid] = tid + 1;
  __syncthreads();

  int producer, result;
  asm volatile("ds_read_b32 %[producer], %[address]\n"
               ".rept %c[younger_writes]\n"
               "ds_write_b32 %[address], %[value]\n"
               ".endr\n"
               "v_mov_b32 %[result], %[producer]\n"
               : [producer] "=&v"(producer), [result] "=&v"(result)
               : [address] "v"(tid * 4), [value] "v"(tid + 1), [younger_writes] "n"(YoungerWrites)
               : "memory");
  dst[tid] = result;
}

/// Fill LGKMCNT with ordered LDS operations, then issue an unordered scalar
/// load. At capacity, the scalar issue proves that the oldest LDS read
/// completed; one token below capacity, consuming that LDS result must still
/// race.
template <int YoungerWrites>
__global__ void mixed_lgkmcnt_capacity_kernel(const int *scalar_src, int *dst) {
  __shared__ int lds[64];
  int tid = threadIdx.x;
  lds[tid] = tid + 1;
  __syncthreads();

  int producer, scalar_result, result;
  asm volatile(
      "ds_read_b32 %[producer], %[lds_address]\n"
      ".rept %c[younger_writes]\n"
      "ds_write_b32 %[lds_address], %[value]\n"
      ".endr\n"
      "s_load_dword %[scalar_result], %[scalar_address], 0x0\n"
      "v_mov_b32 %[result], %[producer]\n"
      : [producer] "=&v"(producer), [scalar_result] "=s"(scalar_result), [result] "=&v"(result)
      : [lds_address] "v"(tid * 4), [value] "v"(tid + 1), [scalar_address] "s"(scalar_src),
        [younger_writes] "n"(YoungerWrites)
      : "memory");
  dst[tid] = result;
}

/// Exercise the decoded two-token count for a wide scalar load. With one
/// fewer LDS token than the one-DWORD case, the wide issue still forces the
/// oldest ordered LDS read to complete.
template <int YoungerWrites>
__global__ void wide_scalar_lgkmcnt_capacity_kernel(const uint64_t *scalar_src, int *dst) {
  __shared__ int lds[64];
  int tid = threadIdx.x;
  lds[tid] = tid + 1;
  __syncthreads();

  int producer, result;
  uint64_t scalar_result;
  asm volatile(
      "ds_read_b32 %[producer], %[lds_address]\n"
      ".rept %c[younger_writes]\n"
      "ds_write_b32 %[lds_address], %[value]\n"
      ".endr\n"
      "s_load_dwordx2 %[scalar_result], %[scalar_address], 0x0\n"
      "v_mov_b32 %[result], %[producer]\n"
      : [producer] "=&v"(producer), [scalar_result] "=s"(scalar_result), [result] "=&v"(result)
      : [lds_address] "v"(tid * 4), [value] "v"(tid + 1), [scalar_address] "s"(scalar_src),
        [younger_writes] "n"(YoungerWrites)
      : "memory");
  dst[tid] = result;
}

class RaceTestBase : public ::testing::Test {
protected:
  template <typename T> T *alloc(int count) {
    T *pointer = nullptr;
    RACE_HIP_CHECK(hipMalloc(&pointer, count * sizeof(T)));
    return pointer;
  }

  template <typename T> T *allocWithData(int count) {
    T *pointer = alloc<T>(count);
    std::vector<T> host(count);
    for (int index = 0; index < count; ++index)
      host[index] = static_cast<T>(index);
    RACE_HIP_CHECK(hipMemcpy(pointer, host.data(), count * sizeof(T), hipMemcpyHostToDevice));
    return pointer;
  }

  void sync() { RACE_HIP_CHECK(hipDeviceSynchronize()); }

  void ExpectNoRace() {
    const RaceLogParseResult parsed = parseRaceLogFromEnvironment();
    ASSERT_TRUE(parsed.ok()) << parsed.error;
    if (!parsed.records.empty()) {
      for (const auto &record : parsed.records) {
        std::fprintf(stderr, "  [%s symbol=%s dispatch=%d %s reg=%d wg=%s] %s\n",
                     record.kernel.c_str(), record.symbol.c_str(), record.dispatch,
                     record.type.c_str(), record.reg, record.workgroup.c_str(),
                     record.message.c_str());
      }
    }
    EXPECT_TRUE(parsed.records.empty()) << "Expected no races, got " << parsed.records.size();
  }

  void ExpectRace(const RaceExpectation &expected) {
    const RaceLogParseResult parsed = parseRaceLogFromEnvironment();
    ASSERT_TRUE(parsed.ok()) << parsed.error;
    const RaceExpectationMatchResult matched = matchRaceExpectation(parsed.records, expected);
    EXPECT_TRUE(matched.ok()) << matched.message();
  }

  /// For register-hazard cases, which the corpus adapter checks through the
  /// core's memory-wait diagnostics. Older race plugins also report these
  /// hazards as register records, so only LDS records are rejected here.
  void ExpectNoLdsRace() {
    const RaceLogParseResult parsed = parseRaceLogFromEnvironment();
    ASSERT_TRUE(parsed.ok()) << parsed.error;
    for (const auto &record : parsed.records)
      EXPECT_NE(record.type, "LDS") << record.message;
  }
};

} // namespace rocjitsu::test
