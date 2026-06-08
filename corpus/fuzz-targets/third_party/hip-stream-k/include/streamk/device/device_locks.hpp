/**
 * @copyright Copyright 2023 Advanced Micro Devices, Inc.
 */

#pragma once

#include <hip/hip_runtime.h>

namespace streamk {

__device__ inline void signal(bool& flag) {
  if (threadIdx.x == 0 && threadIdx.y == 0) {
    flag = true;
  }
  __syncthreads();
}

__device__ inline void wait(bool& flag) {
  while (!flag) {
  }
}

__device__ inline void lock(int* mutex) {
  if (threadIdx.x == 0 && threadIdx.y == 0) {
    while (atomicCAS(mutex, 0, 1) != 0)
      ;
  }
  __syncthreads();
}
// Publish flag=0 with release semantics.  The release-ordered atomic store
// makes every prior write by this thread visible to any CU that observes a
// matching acquire load of this flag, so callers no longer need a separate
// __threadfence().  Callers must still place a __syncthreads() between the
// data writes and unlock() so that *all* waves in the block have reached this
// point before lane 0 publishes the flag.
__device__ inline void unlock(int* mutex) {
  if (threadIdx.x == 0 && threadIdx.y == 0) {
    __hip_atomic_store(mutex, 0, __ATOMIC_RELEASE,
                       __HIP_MEMORY_SCOPE_AGENT);
  }
}

// Acquire-ordered load: pairs with the release-store above so that any data
// written by the producer before its unlock is guaranteed to be visible here.
// A plain `while (*volatile_ptr)` spin is not enough on gfx942 / ROCm 7 — a
// wake-up published by another CU can be missed (the volatile read is not
// guaranteed to bypass this CU's L1).
__device__ inline void wait_for_unlock(int* mutex) {
  while (__hip_atomic_load(mutex, __ATOMIC_ACQUIRE,
                           __HIP_MEMORY_SCOPE_AGENT) != 0) {
  }
}

}  // namespace streamk