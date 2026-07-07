/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <hip/hip_runtime.h>

#include <algorithm>
#include <iostream>
#include <string>
#include <iomanip>

#include <streamk/utils/device.hpp>

namespace streamk {

template <typename T>
std::string statistics(uint64_t m,
                       uint64_t n,
                       uint64_t k,
                       double runtime,
                       std::string algorithm,
                       bool log = true) {
  hipDeviceProp_t properties = device_properties();

  // Device information.
  // TODO: For better comparison, use measured clock-rate (or externally fix it)
  int cores_per_mp = properties.warpSize;
  int hip_cores = properties.multiProcessorCount * cores_per_mp;
  double max_clock_rate = properties.clockRate * 1e-6f;

  int flop_per_core = (8 / sizeof(T) * 2);
  flop_per_core = (8 / sizeof(T)) == 4 ? flop_per_core * 2 : flop_per_core;
  double max_perf_dp = hip_cores * max_clock_rate * flop_per_core;

  // Maximum theoretical memory bandwidth = Frequency * Pumprate * BusWidth/8
  // Pumprate = 2 (based on the memory type)
  double max_bandwidth = (properties.memoryClockRate * 1e-6f) * 2 *
                         (properties.memoryBusWidth / 8);

  // Peak floating-goint operations for a given matrix size
  // 2 (Multiply-Add Ops) * A-Rows * B-Cols * B-Rows
  double gflop = (2 * m * n * k) * 1e-9;

  // Peak memory read/written for a given matrix size
  // A reads (m * k) + B reads (k * n) + C writes (m * n)
  // TODO: Improve this by using proper types for reads/writes
  double gbyte = ((m * n) + (m * k) + (k * n)) * 1e-9 * sizeof(T);

  // Peak possible runtime for a given device
  double peak_runtime =
      gflop / std::min(max_perf_dp, max_bandwidth * gflop / gbyte);

  // Peak achievable throughput of the device
  double peak_throughput = gflop / peak_runtime;

  // Arithmetic intensity for a given matrix size
  double arithmetic_intensity = gflop / gbyte;

  // Achieved throughput gflop_per_second
  double achieved_throughput = gflop / runtime;

  // Output to build a simple CSV
  std::stringstream ss;
  ss << algorithm << "," << m << "," << n << "," << k << "," << std::fixed
     << std::setprecision(12) << gflop << "," << gbyte << "," << peak_throughput
     << "," << runtime << "," << achieved_throughput << ","
     << arithmetic_intensity << std::endl;

  if (log)
    std::cout << ss.str();
  return ss.str();
}

}  // namespace streamk