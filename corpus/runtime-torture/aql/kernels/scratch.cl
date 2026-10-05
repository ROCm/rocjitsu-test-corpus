// Purpose: Force private scratch stores and dynamically indexed loads.
// Used by scratch_dispatch. Common kernargs: output, markers, seed, iterations,
// token. Each work-item owns 64 private words and returns a checked checksum.
// Inspiration: KFDMemoryTest FlatScratchAccess; see the host test for reference.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDMemoryTest.cpp
kernel void torture_work(global uint* output, global uint* markers, uint seed, uint iterations,
                         uint token) {
  uint id = __builtin_amdgcn_workgroup_id_x() * 64 + __builtin_amdgcn_workitem_id_x();
  volatile uint state[64];
  for (uint j = 0; j < 64; ++j) state[j] = seed ^ id ^ j;
  for (uint step = 0; step < iterations; ++step) {
    uint index = (seed + id + step * 17) & 63;
    state[index] = state[index] * 1664525u + 1013904223u;
  }
  uint checksum = 0;
  for (uint j = 0; j < 64; ++j) checksum += state[j] * (j + 1);
  output[id] = checksum;
  markers[id] = token;
}
