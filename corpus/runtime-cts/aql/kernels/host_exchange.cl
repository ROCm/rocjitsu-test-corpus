// Purpose: Live shader request/reply workload for shader_host_ping_pong.
// Common kernargs: output, control, seed, finite exchange count, reserved token.
// control[0]/[16] are request/reply sequence words; payloads begin at [64]/[128].
// Inspiration: HRX queue host-call workload; see host test for public reference.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/libhrx/cts/tests/queue_ops/queue_ops_test.cpp
kernel void cts_work(global uint* output, global volatile uint* control, uint seed,
                         uint iterations, uint token) {
  uint value = seed;
  for (uint step = 1; step <= iterations; ++step) {
    for (uint word = 0; word < 32; ++word) control[64 + word] = value ^ word;
    __builtin_amdgcn_fence(__ATOMIC_RELEASE, "");
    control[0] = step;
    while (control[16] != step) __builtin_amdgcn_s_sleep(1);
    __builtin_amdgcn_fence(__ATOMIC_ACQUIRE, "");
    for (uint word = 0; word < 32; ++word)
      value = (value ^ control[128 + word]) * 1664525u + 1013904223u;
  }
  output[0] = value;
  output[1] = iterations;
}
