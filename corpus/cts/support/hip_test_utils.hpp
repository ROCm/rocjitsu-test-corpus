// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT
//
// tests/hip_test_utils.hpp
// ----------------------------------------------------------------------------
// HIP-side test helpers shared by the GPU test files: HIP error-checking
// macros, device-availability probes, scoped device allocations, and
// host<->device vector copies.
// Include only from tests compiled as HIP.
// ----------------------------------------------------------------------------
#ifndef FPSAN_TESTS_HIP_TEST_UTILS_HPP
#define FPSAN_TESTS_HIP_TEST_UTILS_HPP

#include "test_utils.hpp" // bits_of

#include <hip/hip_runtime.h>

#include <gtest/gtest.h>

#include <algorithm>
#include <cstddef>
#include <memory>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

// Assert a HIP call succeeded (prints the HIP error string on failure).
#define HIP_CHECK(e)                                                                               \
  do {                                                                                             \
    hipError_t e_ = (e);                                                                           \
    ASSERT_EQ(e_, hipSuccess) << hipGetErrorString(e_);                                            \
  } while (0)

// Throw on failure, including in helpers that return a value.
#define HIP_CHECK_EXC(expr)                                                                        \
  do {                                                                                             \
    hipError_t hip_status_ = (expr);                                                               \
    if (hip_status_ != hipSuccess)                                                                 \
      throw std::runtime_error(std::string(#expr) + " failed at " + __FILE__ + ":" +               \
                               std::to_string(__LINE__) + ": " + hipGetErrorString(hip_status_));  \
  } while (0)

// True when at least one HIP device is present (tests GTEST_SKIP otherwise).
inline bool have_device() {
  int n = 0;
  return hipGetDeviceCount(&n) == hipSuccess && n > 0;
}

// True when the current HIP device is gfx1250. gfx1250 is a DISTINCT
// architecture from the gfx12 / RDNA4 family (gfx1200/1201/1202) despite the
// shared "gfx12" prefix: it adds the permlane_{bcast,down,up,xor},
// permlane16_swap and permlane_idx_gen cross-lane ops that RDNA4 lacks. Those
// builtins are device-gated by __has_builtin in the wrappers, so their kernels
// are not emitted on RDNA4 -- a host that launches them there hits "cannot find
// symbol" at runtime. Tests of those ops must GTEST_SKIP unless this returns
// true. Match the full "gfx1250" token (not a "gfx12" prefix, which would
// wrongly accept RDNA4) and ignore any trailing :feature flags in gcnArchName.
inline bool device_is_gfx1250() {
  int dev = 0;
  if (hipGetDevice(&dev) != hipSuccess)
    return false;
  hipDeviceProp_t prop{};
  if (hipGetDeviceProperties(&prop, dev) != hipSuccess)
    return false;
  return std::string(prop.gcnArchName).compare(0, 7, "gfx1250") == 0;
}

inline bool device_is_gfx12() {
  int dev = 0;
  if (hipGetDevice(&dev) != hipSuccess)
    return false;
  hipDeviceProp_t prop{};
  if (hipGetDeviceProperties(&prop, dev) != hipSuccess)
    return false;
  return std::string(prop.gcnArchName).compare(0, 5, "gfx12") == 0;
}

inline bool device_is_gfx950() {
  int dev = 0;
  if (hipGetDevice(&dev) != hipSuccess)
    return false;
  hipDeviceProp_t prop{};
  if (hipGetDeviceProperties(&prop, dev) != hipSuccess)
    return false;
  return std::string(prop.gcnArchName).compare(0, 6, "gfx950") == 0;
}

// Own a caller's device allocations so later transfer failures and fatal
// assertions release everything acquired in that scope.
class DeviceAllocations {
  struct Deleter {
    void operator()(void *device) const noexcept {
      // Cleanup must not replace an allocation, copy, or assertion failure.
      (void)hipFree(device);
    }
  };
  std::vector<std::unique_ptr<void, Deleter>> allocations_;

public:
  template <class T> T *allocate(std::size_t count) {
    T *pointer = nullptr;
    HIP_CHECK_EXC(hipMalloc(&pointer, count * sizeof(T)));
    std::unique_ptr<void, Deleter> allocation(pointer);
    allocations_.push_back(std::move(allocation));
    return pointer;
  }

  template <class T> T *to_dev(const std::vector<T> &host) {
    T *device = allocate<T>(host.size());
    HIP_CHECK_EXC(hipMemcpy(device, host.data(), host.size() * sizeof(T), hipMemcpyHostToDevice));
    return device;
  }

  // Release an owned allocation early; ignore pointers this guard does not own.
  void free(void *device) {
    const auto allocation =
        std::find_if(allocations_.begin(), allocations_.end(),
                     [device](const auto &owned) { return owned.get() == device; });
    if (allocation != allocations_.end())
      allocations_.erase(allocation);
  }
};

// Copy n elements back from device memory into a host vector.
template <class T> std::vector<T> from_dev(const T *d, std::size_t n) {
  std::vector<T> h(n);
  HIP_CHECK_EXC(hipMemcpy(h.data(), d, n * sizeof(T), hipMemcpyDeviceToHost));
  return h;
}

#endif // FPSAN_TESTS_HIP_TEST_UTILS_HPP
