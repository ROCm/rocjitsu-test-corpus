/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <hip/hip_runtime.h>

namespace streamk {

// Helper macro for HIP errors
#ifndef CHECK_HIP_ERROR
#define CHECK_HIP_ERROR(status)                                     \
  if (status != hipSuccess) {                                       \
    fprintf(stderr, "hip error: '%s'(%d) at %s:%d\n",               \
            hipGetErrorString(status), status, __FILE__, __LINE__); \
    exit(EXIT_FAILURE);                                             \
  }
#endif

}  // namespace streamk