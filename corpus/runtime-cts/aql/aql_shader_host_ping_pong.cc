// Purpose: Exchange request/reply payloads with a live shader.
// A finite GPU loop publishes a payload before each request; the CPU checks it,
// writes a reply payload and releases the shader. System acquire/release
// fences connect payloads to sequence words. Verify every request plus final
// shader state and completion. This is a workload pattern, not a hostcall ABI.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --seed N: initial shader state; default 12345; range 1..4294967295.
//   --queues: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/libhrx/cts/tests/queue_ops/queue_ops_test.cpp
#include <cstring>

#include "host_exchange_kernel.inc"
#include "support/aql.h"
using namespace cts;
int main(int argc, char** argv) {
  Start(argc, argv, "aql_shader_host_ping_pong");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  const uint32_t seed = Option(argc, argv, "--seed", 12345, 0xffffffffu);
  Device device;
  Buffer code(device, sizeof(kKernelImage), true), args(device, 4096);
  Buffer result(device, 4096), control(device, 4096), signals(device, 4096);
  Check(kKernargBytes <= 512, "kernel arguments too large");
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  Queue queue(device, 4096, 7, true);
  ResetSignal(signals, 0);
  Arguments a{result.address(), control.address(), seed, rounds, 1};
  std::memcpy(args.data, &a, sizeof(a));
  Dispatch packet =
      OneGroup(code.address(kDescriptorOffset), args.address(), signals.address(), true);
  queue.SubmitAql(&packet);
  uint32_t expected = seed;
  for (uint32_t round = 1; round <= rounds; ++round) {
    control.Wait(0, round, 10000, &queue);
    for (uint32_t word = 0; word < 32; ++word) {
      Check(control.Load(64 + word) == (expected ^ word), "shader request payload stale");
      control.Store(128 + word, (expected ^ word) + round);
    }
    // The GPU folds reply words into its previous state in order.
    uint32_t next = expected;
    for (uint32_t word = 0; word < 32; ++word)
      next = Advance(next ^ ((expected ^ word) + round), 1);
    expected = next;
    __asm__ __volatile__("sfence" ::: "memory");
    control.Store(16, round);
  }
  WaitSignal(signals, 0, queue);
  Check(result.Load(0) == expected && result.Load(1) == rounds,
        "shader reply/final state mismatch");
  Check(control.Load(96) == 0 && control.Load(160) == 0 && result.Load(2) == 0,
        "host/shader exchange guard corrupted");
  queue.Drain();
  Pass("aql_shader_host_ping_pong", rounds);
}
