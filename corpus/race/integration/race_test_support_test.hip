// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "race_test_support.hpp"

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include <cstddef>
#include <stdexcept>
#include <string>

namespace {
hipError_t allocation_status = hipSuccess;
hipError_t copy_status = hipSuccess;
hipError_t sync_status = hipSuccess;
int copy_calls = 0;
int storage;

class FixtureProbe : public rocjitsu::test::RaceTestBase {
public:
  using RaceTestBase::allocWithData;
  using RaceTestBase::sync;
  void TestBody() override {}
};
} // namespace

// These fixture tests inject runtime failures without initializing a GPU.
extern "C" hipError_t hipMalloc(void **pointer, size_t) {
  *pointer = allocation_status == hipSuccess ? &storage : nullptr;
  return allocation_status;
}
extern "C" hipError_t hipMemcpy(void *, const void *, size_t, hipMemcpyKind) {
  ++copy_calls;
  return copy_status;
}
extern "C" hipError_t hipDeviceSynchronize() { return sync_status; }

TEST(RaceFixtureHipErrors, FailedAllocationStopsBeforeCopy) {
  allocation_status = hipErrorOutOfMemory;
  copy_status = hipSuccess;
  copy_calls = 0;
  FixtureProbe fixture;
  EXPECT_THROW(fixture.allocWithData<int>(1), std::runtime_error);
  EXPECT_EQ(copy_calls, 0);
  allocation_status = hipSuccess;
}

TEST(RaceFixtureHipErrors, FailedCopyStopsDependentUse) {
  copy_status = hipErrorInvalidValue;
  FixtureProbe fixture;
  bool used_result = false;
  try {
    (void)fixture.allocWithData<int>(1);
    used_result = true;
  } catch (const std::runtime_error &error) {
    EXPECT_NE(std::string(error.what()).find("hipMemcpy"), std::string::npos);
  }
  EXPECT_FALSE(used_result);
  copy_status = hipSuccess;
}

TEST(RaceFixtureHipErrors, FailedSynchronizationCannotReachNoRaceAssertion) {
  sync_status = hipErrorLaunchFailure;
  FixtureProbe fixture;
  EXPECT_THROW(fixture.sync(), std::runtime_error);
  sync_status = hipSuccess;
}

TEST(RaceFixtureHipErrors, FailedLaunchReportsOperationAndError) {
  try {
    rocjitsu::test::checkHip(hipErrorNoBinaryForGpu, "hipGetLastError()", __FILE__, __LINE__);
    FAIL() << "Expected the failed launch to stop the test";
  } catch (const std::runtime_error &error) {
    EXPECT_NE(std::string(error.what()).find("hipGetLastError() failed:"), std::string::npos);
    EXPECT_NE(std::string(error.what()).find(hipGetErrorString(hipErrorNoBinaryForGpu)),
              std::string::npos);
  }
}

TEST(RaceFixtureHipErrors, SuccessfulRuntimeOperationsRemainUsable) {
  FixtureProbe fixture;
  EXPECT_EQ(fixture.allocWithData<int>(1), &storage);
  EXPECT_NO_THROW(fixture.sync());
}
