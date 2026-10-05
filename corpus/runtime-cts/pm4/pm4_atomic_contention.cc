// Purpose: Stress contended 32-bit and 64-bit PM4 atomic increments from multiple queues.
// Check exact totals for lost/duplicate operations, carry across the low 32-bit word,
// and adjacent guards for unintended writes.
//
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --iterations N: rounds.
//     Default 64; range 1..100000.
//   --queues N: PM4 queues.
//     Default 16; range 1..128.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/queue/queue_atomic_test.cc
#include <memory>

#include "pm4.h"

using namespace cts;

int main(int argc, char** argv) {
  Start(argc, argv, "pm4_atomic_contention");
  const uint32_t count = Option(argc, argv, "--queues", 16, 128);
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device;
  Buffer result(device, 4096);
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new Queue(device));
  constexpr uint32_t kAdds = 32;
  // Cross the 32-bit boundary in the 64-bit counter on the first round.
  result.Store(2, 0xfffffff0u);
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t q = 0; q < count; ++q) {
      Pm4 commands;
      for (uint32_t i = 0; i < kAdds; ++i) {
        commands.Add(result.address(), 1, false);
        commands.Add(result.address(8), 1, true);
      }
      commands.Finish(result.address(64 + q * 4), round);
      queues[q]->Submit(commands.words);
    }
    for (uint32_t q = 0; q < count; ++q) result.Wait(16 + q, round);
    uint64_t expected = uint64_t(round) * count * kAdds;
    Check(result.Load(0) == uint32_t(expected), "32-bit atomics lost or duplicated");
    const uint64_t wide = result.Load(2) | (uint64_t(result.Load(3)) << 32);
    Check(wide == 0xfffffff0ull + expected, "64-bit atomics lost, duplicated, or bad carry");
    Check(result.Load(1) == 0 && result.Load(4) == 0, "atomic guard overwritten");
  }
  for (auto& queue : queues) queue->Drain();
  Pass("pm4_atomic_contention", uint64_t(rounds) * count * kAdds * 2);
}
