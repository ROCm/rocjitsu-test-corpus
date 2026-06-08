#pragma once

#include <hip/hip_runtime.h>
#include <chrono>

double get_time_us_sync_device(void) {
  hipDeviceSynchronize();

  auto now = std::chrono::steady_clock::now();
  // now.time_since_epoch() is the duration since epoch
  // which is converted to microseconds
  auto duration = std::chrono::duration_cast<std::chrono::microseconds>(
                      now.time_since_epoch())
                      .count();
  return (static_cast<double>(duration));
};