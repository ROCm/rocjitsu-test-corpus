// One work-item per workgroup, with a distinct output and completion slot.
// Builtins lower to instructions; no OpenCL, HIP, or device-library dependency.
// Used by packet_flood AQL mode and AQL-specific scenarios. Kernargs: output[group] receives the
// LCG result; done[group] receives token after a release fence; seed is XORed with group ID;
// iterations controls the LCG steps. Runtime CLI parameters belong to the host test.
// Inspiration: batched small-kernel execution in tinygrad HCQ tests.
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_test_hcq.py
typedef unsigned int uint;
kernel void torture_work(global uint* output, global volatile uint* done, uint seed,
                         uint iterations, uint token) {
  uint id = __builtin_amdgcn_workgroup_id_x();
  uint value = seed ^ id;
  for (uint i = 0; i < iterations; ++i) value = value * 1664525u + 1013904223u;
  output[id] = value;
  __builtin_amdgcn_fence(__ATOMIC_RELEASE, "");
  done[id] = token;
}
