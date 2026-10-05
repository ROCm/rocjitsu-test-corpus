// Purpose: Transform SDMA-uploaded data in VRAM for AQL engine_pipeline/dependency_chain tests.
// Kernargs: input/output pointers, salt, element count, reserved token.
// One 64-thread workgroup per tile; the host checks all data and guards.
// Inspiration: tinygrad interleave_compute_and_copy (see host test for URL).
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_test_hcq.py
kernel void cts_work(global const uint* input, global uint* output, uint salt, uint count,
                         uint token) {
  uint id = __builtin_amdgcn_workgroup_id_x() * 64 + __builtin_amdgcn_workitem_id_x();
  if (id < count) {
    uint value = input[id] ^ salt;
    for (uint i = 0; i < 3; ++i) value = value * 1664525u + 1013904223u;
    output[id] = value;
  }
}
