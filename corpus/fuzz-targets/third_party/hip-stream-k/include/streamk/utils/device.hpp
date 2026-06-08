/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */
#pragma once

#include <hip/hip_runtime.h>

namespace streamk {

hipDeviceProp_t device_properties() {
  int dev;
  hipGetDevice(&dev);
  hipDeviceProp_t prop;
  hipGetDeviceProperties(&prop, dev);
  return prop;
}

}  // namespace streamk