// Public HSA packet ABI, independently populated by these tests.
// https://github.com/ROCm/rocm-systems/blob/96f1528fa5c5a0e12d706dbf4507c441c456f6eb/projects/rocr-runtime/runtime/hsa-runtime/inc/hsa.h
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/runtime/hsa-runtime/inc/amd_hsa_signal.h
#ifndef TORTURE_TESTS_SUPPORT_AQL_H_
#define TORTURE_TESTS_SUPPORT_AQL_H_
#include "support/kfd.h"

namespace torture {
struct Dispatch {
  uint32_t header_setup;
  uint16_t workgroup_x, workgroup_y, workgroup_z, reserved0;
  uint32_t grid_x, grid_y, grid_z, private_bytes, group_bytes;
  uint64_t kernel, arguments, reserved1, completion_signal;
};
static_assert(sizeof(Dispatch) == 64);
struct Arguments {
  uint64_t output, completion;
  uint32_t seed, iterations, token;
};
static_assert(offsetof(Arguments, token) == 24);

inline Dispatch OneGroup(uint64_t kernel, uint64_t arguments, uint64_t signal, bool barrier) {
  Dispatch p{};
  p.header_setup = 2u | (uint32_t(barrier) << 8) | (2u << 9) | (2u << 11) | (1u << 16);
  p.workgroup_x = p.workgroup_y = p.workgroup_z = 1;
  p.grid_x = p.grid_y = p.grid_z = 1;
  p.kernel = kernel;
  p.arguments = arguments;
  p.completion_signal = signal;
  return p;
}
inline void ResetSignal(Buffer& signals, size_t offset) {
  signals.Store64(offset, 1);
  signals.Store64(offset + 8, 1);
}
inline void WaitSignal(Buffer& signals, size_t offset, Queue& queue) {
  signals.Wait((offset + 8) / 4, 0, 10000, &queue);
  Check(signals.Load64(offset + 8) == 0, "completion signal underflow");
}
// LCG oracle in O(log n), including uint32 overflow, for a variable-duration shader.
inline uint32_t Advance(uint32_t value, uint32_t count) {
  uint32_t a = 1664525u, b = 1013904223u;
  while (count) {
    if (count & 1) value = a * value + b;
    b = a * b + b;
    a *= a;
    count >>= 1;
  }
  return value;
}
}  // namespace torture
#endif
