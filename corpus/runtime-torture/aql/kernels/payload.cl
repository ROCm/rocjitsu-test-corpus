// Kernel ABI and kernarg preload reference:
// https://llvm.org/docs/AMDGPUUsage.html
// Tiny payload for queue/lifetime tests. One lane fills consecutive words,
// or copies words from a non-null source and adds a constant to each.
__kernel void torture_work(__global const uint* source, __global uint* target, uint value,
                           uint count) {
  for (uint i = 0; i < count; ++i) target[i] = source ? source[i] + value : value + i;
}
