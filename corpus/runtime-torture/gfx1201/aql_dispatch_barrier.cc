// Purpose: Test whether an AQL dispatch's barrier bit orders it after an earlier live shader.
// Hold the earlier shader behind a host gate and require the barrier-bit follower
// to remain incomplete. Also observe optional overlap with the bit clear, then
// check both outputs and the gated shader's arithmetic state.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: paired barrier-set/barrier-clear cases.
//     Default 32; range 1..100000.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: paired barrier-bit and concurrent-dispatch controls in ROCr.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/rocrtst/suites/functional/aql_barrier_bit.cc
#include <cstdio>
#include <cstring>
#include <thread>

#include "gate_kernel.inc"
#include "support/aql.h"
using namespace torture;
int main(int argc, char** argv) {
  Start(argc, argv, "aql_dispatch_barrier");
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  Device device(1201);
  Buffer code(device, sizeof(kKernelImage), true), args(device, 4096);
  Buffer result(device, 4096), control(device, 4096), signals(device, 4096);
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  Check(kKernargBytes <= 512, "kernel argument image too large");
  Queue queue(device, 4096, 7, true);
  uint32_t concurrent_followers = 0;
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t ordered = 0; ordered < 2; ++ordered) {
      const uint32_t token = round * 2 + ordered;
      const uint32_t seed = token ^ 0x12345678;
      control.Store(0, 0);
      control.Store(1, 0);
      control.Store(2, 0);
      for (uint32_t slot = 0; slot < 2; ++slot) {
        ResetSignal(signals, slot * 64);
        Arguments a{result.address(slot * 64), control.address(), seed, slot == 0, token};
        std::memcpy(static_cast<char*>(args.data) + slot * 512, &a, sizeof(a));
        Dispatch p = OneGroup(code.address(kDescriptorOffset), args.address(slot * 512),
                              signals.address(slot * 64), ordered && slot == 1);
        queue.SubmitAql(&p);
      }
      control.Wait(0, token, 10000, &queue);
      if (ordered) {
        const uint64_t deadline = NowNs() + 1000000;
        while (NowNs() < deadline) {
          Check(signals.Load64(72) == 1, "barrier-bit follower ran before prior dispatch finished");
          std::this_thread::yield();
        }
      } else {
        // A clear barrier bit permits concurrency but does not require it.
        // Observe this case without making forward progress depend on overlap.
        const uint64_t deadline = NowNs() + 1000000;
        while (NowNs() < deadline && signals.Load64(72)) std::this_thread::yield();
        concurrent_followers += signals.Load64(72) == 0;
      }
      Check(signals.Load64(8) == 1, "gated shader finished before gate opened");
      control.Store(1, token);
      WaitSignal(signals, 0, queue);
      WaitSignal(signals, 64, queue);
      Check(result.Load(1) != 0 && result.Load(0) == Advance(seed, result.Load(1)),
            "gated shader state mismatch");
      Check(result.Load(16) == seed && result.Load(17) == 0, "follower output mismatch");
      Check(result.Load(2) == 0 && result.Load(18) == 0, "dispatch guard corrupted");
      queue.Drain();
    }
  }
  std::printf("unbarriered_followers_completed_early=%u/%u\n", concurrent_followers, rounds);
  Pass("aql_dispatch_barrier", uint64_t(rounds) * 4);
}
