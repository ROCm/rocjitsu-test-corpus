// Purpose: Shuffle data across waves through LDS with workgroup barriers.
// Used by lds_dispatch with 256 threads and 32 KiB dynamic LDS per workgroup.
// Kernargs: output holds 4096 words per group; done[group] receives token; seed
// initializes the data; iterations controls shuffle rounds; arena is the LDS
// allocation. Runtime CLI parameters belong to the host test.
// Inspiration: independently written local-memory/barrier workload.
// https://github.com/KhronosGroup/OpenCL-CTS/blob/9feccbb8fcb8eefeebf86a48036173a8155f9d21/test_conformance/basic/test_local.cpp
static inline void sync_group(void) {
  __builtin_amdgcn_fence(__ATOMIC_RELEASE, "workgroup");
  __builtin_amdgcn_s_barrier();
  __builtin_amdgcn_fence(__ATOMIC_ACQUIRE, "workgroup");
}
__attribute__((reqd_work_group_size(256, 1, 1))) kernel void cts_work(
    global uint* output, global volatile uint* done, uint seed, uint iterations, uint token,
    local uint* arena) {
  local uint* a = arena;
  local uint* b = arena + 4096;
  uint group = __builtin_amdgcn_workgroup_id_x();
  uint lane = __builtin_amdgcn_workitem_id_x();
  for (uint j = lane; j < 4096; j += 256) a[j] = seed ^ (group * 4096 + j);
  sync_group();
  for (uint step = 0; step < iterations; ++step) {
    for (uint j = lane; j < 4096; j += 256) b[j] = a[(j + 17) & 4095] * 1664525u + 1013904223u;
    sync_group();
    for (uint j = lane; j < 4096; j += 256) a[j] = b[j];
    sync_group();
  }
  for (uint j = lane; j < 4096; j += 256) output[group * 4096 + j] = a[j];
  __builtin_amdgcn_fence(__ATOMIC_RELEASE, "");
  if (lane == 0) done[group] = token;
}
