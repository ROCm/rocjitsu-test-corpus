// A single live wave retains its LCG state until the host opens a gate.
// Used by dispatch_barrier and running_queue_pause. Kernargs: output[0:2] receives
// the final LCG value and step count; seed initializes the value; persistent=0
// returns immediately, otherwise control[1]==token releases the loop. The loop
// writes token to control[0] and its progress count to control[2]. Runtime CLI
// parameters belong to the host tests.
// Inspired by KFD's persistent CWSR workload and ROCr's barrier-bit test.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDCWSRTest.cpp
kernel void torture_work(global uint* output, global volatile uint* control, uint seed,
                         uint persistent, uint token) {
  uint value = seed, count = 0;
  if (persistent) {
    do {
      for (uint j = 0; j < 256; ++j) {
        value = value * 1664525u + 1013904223u;
        ++count;
      }
      control[2] = count;
      __builtin_amdgcn_fence(__ATOMIC_RELEASE, "");
      control[0] = token;
    } while (control[1] != token);
  }
  output[0] = value;
  output[1] = count;
}
