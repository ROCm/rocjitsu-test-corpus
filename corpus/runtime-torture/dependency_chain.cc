// Purpose: Test wait-before-signal progress through a chain of PM4 queues.
// Submit consumers before producers, then check that every queue completes and
// observes the current payload propagated through its predecessor.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds.
//     Default 32; range 1..100000.
//   --queues N: PM4 queues.
//     Default 16; range 1..128.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/queue/semaphore_submission_test.cc
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocprofiler-sdk/tests/bin/hsa-queue-dependency/multiqueue_app.cpp
#include <memory>

#include "support/pm4.h"

using namespace torture;

int main(int argc, char** argv) {
  Start(argc, argv, "dependency_chain");
  const uint32_t count = Option(argc, argv, "--queues", 16, 128);
  const uint32_t iterations = Option(argc, argv, "--iterations", 32, 100000);
  Device device(TEST_GFX);
  Buffer result(device, count * 4096);
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new Queue(device));
  for (uint32_t round = 1; round <= iterations; ++round) {
    // Submit consumers first: progress requires scheduling the last submitted
    // producer even when more waiting queues exist than hardware queue slots.
    for (uint32_t q = count; q-- > 0;) {
      Pm4 commands;
      if (q) {
        commands.Wait(result.address((q - 1) * 4096 + 64), round);
        commands.Barrier();
        commands.Copy(result.address((q - 1) * 4096), result.address(q * 4096));
      } else {
        commands.Write(result.address(), 0x12340000u + round);
      }
      commands.Finish(result.address(q * 4096 + 64), round);
      queues[q]->Submit(commands.words);
    }
    for (uint32_t q = 0; q < count; ++q) {
      result.Wait(q * 1024 + 16, round);
      Check(result.Load(q * 1024) == 0x12340000u + round,
            "dependency completed with stale payload");
    }
  }
  for (auto& queue : queues) queue->Drain();
  Pass("dependency_chain", uint64_t(count) * iterations);
}
