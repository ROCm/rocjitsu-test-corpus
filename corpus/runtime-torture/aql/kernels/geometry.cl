// Purpose: Make dispatch dimensions and partial workgroups observable.
// Used by dispatch_geometry; kernargs carry nominal group/grid sizes and token.
// Host checks every active element and untouched tail against a CPU oracle.
// Inspiration: tinygrad update_exec (see host test for pinned public reference).
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_test_hcq.py
kernel void torture_work(global uint* output, global uint* markers, uint seed, uint wx, uint wy,
                         uint wz, uint gx, uint gy, uint gz, uint token) {
  uint bx = __builtin_amdgcn_workgroup_id_x();
  uint by = __builtin_amdgcn_workgroup_id_y();
  uint bz = __builtin_amdgcn_workgroup_id_z();
  uint x = bx * wx + __builtin_amdgcn_workitem_id_x();
  uint y = by * wy + __builtin_amdgcn_workitem_id_y();
  uint z = bz * wz + __builtin_amdgcn_workitem_id_z();
  if (x < gx && y < gy && z < gz) {
    uint id = x + gx * (y + gy * z);
    uint value = seed ^ id ^ (bx << 16) ^ (by << 20) ^ (bz << 24);
    for (uint i = 0; i < 3; ++i) value = value * 1664525u + 1013904223u;
    output[id] = value;
    markers[id] = token;
  }
}
