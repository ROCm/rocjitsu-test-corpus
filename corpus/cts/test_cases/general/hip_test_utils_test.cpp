// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "hip_test_utils.hpp"

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include <array>
#include <cstddef>
#include <cstring>
#include <stdexcept>
#include <string>
#include <vector>

namespace {
struct RuntimeState {
  hipError_t allocation_status = hipSuccess;
  hipError_t copy_status = hipSuccess;
  hipError_t free_status = hipSuccess;
  int copy_calls = 0;
  int free_calls = 0;
  std::size_t allocation_bytes = 0;
  hipMemcpyKind copy_kind = hipMemcpyDefault;
  void *freed_pointer = nullptr;
  std::array<int, 3> storage{};
} runtime;

class HipTransferTest : public testing::Test {
  void SetUp() override { runtime = RuntimeState{}; }
};

// Verify both the diagnostic and that dependent code is never reached.
template <class F> void expect_failure(F operation, const char *name, hipError_t error) {
  try {
    operation();
    FAIL() << "Failed HIP transfer returned to its caller";
  } catch (const std::runtime_error &failure) {
    const std::string message = failure.what();
    EXPECT_NE(message.find(name), std::string::npos);
    EXPECT_NE(message.find(hipGetErrorString(error)), std::string::npos);
  }
}
} // namespace

// Interpose only the operations under test. No GPU is initialized or required.
extern "C" hipError_t hipMalloc(void **pointer, std::size_t bytes) {
  runtime.allocation_bytes = bytes;
  *pointer = runtime.allocation_status == hipSuccess ? runtime.storage.data() : nullptr;
  return runtime.allocation_status;
}
extern "C" hipError_t hipMemcpy(void *destination, const void *source, std::size_t bytes,
                                 hipMemcpyKind kind) {
  ++runtime.copy_calls;
  runtime.copy_kind = kind;
  if (runtime.copy_status != hipSuccess)
    return runtime.copy_status;
  if (destination == nullptr || source == nullptr)
    return hipErrorInvalidValue;
  std::memcpy(destination, source, bytes);
  return hipSuccess;
}
extern "C" hipError_t hipFree(void *pointer) {
  ++runtime.free_calls;
  runtime.freed_pointer = pointer;
  return runtime.free_status;
}

TEST_F(HipTransferTest, AllocationFailureStopsBeforeCopy) {
  runtime.allocation_status = hipErrorOutOfMemory;
  expect_failure([] { (void)to_dev(std::vector<int>{1, 2, 3}); }, "hipMalloc",
                 hipErrorOutOfMemory);
  EXPECT_EQ(runtime.copy_calls, 0);
  EXPECT_EQ(runtime.free_calls, 0);
}

TEST_F(HipTransferTest, UploadFailureReleasesAllocation) {
  runtime.copy_status = hipErrorInvalidValue;
  expect_failure([] { (void)to_dev(std::vector<int>{1, 2, 3}); }, "hipMemcpy (host to device)",
                 hipErrorInvalidValue);
  EXPECT_EQ(runtime.copy_calls, 1);
  EXPECT_EQ(runtime.copy_kind, hipMemcpyHostToDevice);
  EXPECT_EQ(runtime.free_calls, 1);
  EXPECT_EQ(runtime.freed_pointer, runtime.storage.data());
}

TEST_F(HipTransferTest, ReleaseFailurePreservesUploadDiagnostic) {
  runtime.copy_status = hipErrorInvalidValue;
  runtime.free_status = hipErrorInvalidDevicePointer;
  expect_failure([] { (void)to_dev(std::vector<int>{1, 2, 3}); }, "hipMemcpy (host to device)",
                 hipErrorInvalidValue);
  EXPECT_EQ(runtime.free_calls, 1);
}

TEST_F(HipTransferTest, DownloadFailureStopsBeforeComparison) {
  runtime.copy_status = hipErrorInvalidValue;
  expect_failure([] { (void)from_dev(runtime.storage.data(), runtime.storage.size()); },
                 "hipMemcpy (device to host)", hipErrorInvalidValue);
  EXPECT_EQ(runtime.copy_calls, 1);
  EXPECT_EQ(runtime.copy_kind, hipMemcpyDeviceToHost);
  EXPECT_EQ(runtime.free_calls, 0); // The caller still owns the source buffer.
}

TEST_F(HipTransferTest, SuccessfulTransfersPreserveValuesAndOwnership) {
  const std::vector<int> values{11, 22, 33};
  int *device = to_dev(values);
  ASSERT_EQ(device, runtime.storage.data());
  EXPECT_EQ(runtime.allocation_bytes, values.size() * sizeof(int));
  EXPECT_EQ(runtime.copy_kind, hipMemcpyHostToDevice);
  EXPECT_EQ(from_dev(device, values.size()), values);
  EXPECT_EQ(runtime.copy_kind, hipMemcpyDeviceToHost);
  EXPECT_EQ(runtime.copy_calls, 2);
  EXPECT_EQ(runtime.free_calls, 0);
  EXPECT_EQ(hipFree(device), hipSuccess);
  EXPECT_EQ(runtime.free_calls, 1);
}
