// Reproducer: Live-wave pause is unresolved and can require host recovery.
// Purpose: Investigate suspension and resumption of a queue while its shader is still running.
// Check that shader progress stops while an independent queue advances, then resumes
// with intact arithmetic state. Live-queue update failed on gfx1201 and gfx1250.
// This is an investigation case, not a qualified CWSR test or part of fast CI.
//
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; default off for AQL queues.
//   --iterations N: shader launches, each with four pause/resume attempts.
//     Default 32; range 1..100000.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
// gfx1201 live-queue UPDATE_QUEUE returned EACCES; trap/preemption setup is unqualified.
// gfx1250 (KFD 1.23, fw 2380) also returned EACCES, with a privileged SQC instruction-fetch
// fault at 0x01ffffffffbf0000 followed by failed MES removal and GPU reset. That address
// matches the public kernel's reserved trap-code VA (2^57 minus 4 MiB minus 64 KiB).
// The cause remains unresolved; do not classify this as a firmware bug or enable in CI.
// https://github.com/torvalds/linux/blob/master/drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c
// https://github.com/torvalds/linux/blob/master/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
//
// Inspiration: disable/re-enable a live kernel and validate its surviving state.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDCWSRTest.cpp
#include <cstdio>
#include <cstring>
#include <thread>

#include "gate_kernel.inc"
#include "support/aql.h"
#include "pm4.h"
using namespace cts;
int main(int argc, char** argv) {
  Start(argc, argv, "aql_running_queue_pause");
  std::puts("Reproducer: live-wave queue pause/resume; trap/preemption setup unqualified");
  std::fflush(stdout);
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  Device device;
  Buffer code(device, sizeof(kKernelImage), true), args(device, 4096);
  Buffer result(device, 4096), control(device, 4096), signals(device, 4096);
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  Check(kKernargBytes <= 512, "kernel argument image too large");
  Queue queue(device, 4096, 7, true), independent(device);
  for (uint32_t round = 1; round <= rounds; ++round) {
    const uint32_t seed = round ^ 0xbadc0ffe;
    control.Store(0, 0);
    control.Store(1, 0);
    control.Store(2, 0);
    ResetSignal(signals, 0);
    Arguments a{result.address(), control.address(), seed, 1, round};
    std::memcpy(args.data, &a, sizeof(a));
    Dispatch p =
        OneGroup(code.address(kDescriptorOffset), args.address(), signals.address(), false);
    queue.SubmitAql(&p);
    control.Wait(0, round, 10000, &queue);
    // Repeat suspension on the same live wave before allowing it to finish.
    for (uint32_t pause = 0; pause < 4; ++pause) {
      queue.SetEnabled(false);
      Pm4 stream;
      stream.Finish(result.address(64), round * 4 + pause);
      independent.Submit(stream.words);
      result.Wait(16, round * 4 + pause, 10000, &independent);
      const uint32_t stopped = control.Load(2);
      const uint64_t deadline = NowNs() + 1000000;
      while (NowNs() < deadline) {
        Check(control.Load(2) == stopped, "disabled shader kept executing");
        Check(signals.Load64(8) == 1, "disabled shader completed unexpectedly");
        std::this_thread::yield();
      }
      if (pause == 3) control.Store(1, round);
      queue.SetEnabled(true);
      if (pause != 3) {
        const uint64_t progress_deadline = NowNs() + 10000000000ull;
        while (control.Load(2) == stopped) {
          if (NowNs() >= progress_deadline) {
            queue.Dump();
            Fail("resumed shader made no progress");
          }
          std::this_thread::yield();
        }
      }
    }
    WaitSignal(signals, 0, queue);
    Check(result.Load(1) != 0 && result.Load(0) == Advance(seed, result.Load(1)),
          "resumed shader state mismatch");
    Check(result.Load(2) == 0, "dispatch guard corrupted");
    queue.Drain();
    independent.Drain();
  }
  Pass("aql_running_queue_pause", uint64_t(rounds) * 4);
}
