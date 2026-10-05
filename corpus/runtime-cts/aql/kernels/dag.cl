// Consume every ordered predecessor after a five-handle AQL barrier.
// Inputs remain immutable until all consumers retire. Output includes a generation marker.
__kernel void cts_work(__global const uint* p0, __global const uint* p1, __global const uint* p2,
                       __global const uint* p3, __global const uint* p4, __global uint* target,
                       uint count, uint tag) {
  uint value = tag;
  if (count > 0) value = (value ^ p0[0]) * 16777619u;
  if (count > 1) value = (value ^ p1[0]) * 16777619u + 1;
  if (count > 2) value = (value ^ p2[0]) * 16777619u + 2;
  if (count > 3) value = (value ^ p3[0]) * 16777619u + 3;
  if (count > 4) value = (value ^ p4[0]) * 16777619u + 4;
  target[0] = value;
  target[1] = tag;
}
