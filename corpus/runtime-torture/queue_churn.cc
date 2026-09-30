// Purpose: Stress queue creation, first submission, reverse destruction and queue/doorbell reuse.
// Keep a surviving queue active while transient queues are replaced each round.
// Check each new queue's first payload and the survivor's data and completion.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds.
//     Default 32; range 1..100000.
//   --queues N: transient queues, plus one persistent survivor.
//     Default 8; range 1..128.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDQMTest.cpp
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/libamdf/cts/gpu/user_queue_memory.cc
#include <memory>

#include "support/pm4.h"

using namespace torture;

int main(int argc, char** argv) {
  Start(argc, argv, "queue_churn");
  const uint32_t count = Option(argc, argv, "--queues", 8, 128);
  const uint32_t iterations = Option(argc, argv, "--iterations", 32, 100000);
  Device device(TEST_GFX);
  Buffer result(device, (count + 1) * 4096);
  Queue survivor(device);
  for (uint32_t round = 1; round <= iterations; ++round) {
    std::vector<std::unique_ptr<Queue>> queues;
    Pm4 background;
    for (uint32_t i = 0; i < 128; ++i) background.Write(result.address(i * 4), round + i);
    background.Finish(result.address(2048), round);
    survivor.Submit(background.words);
    for (uint32_t q = 0; q < count; ++q) {
      queues.emplace_back(new Queue(device, 4096, (round + q) % 16));
      Pm4 commands;
      commands.Write(result.address((q + 1) * 4096), round * 256 + q);
      commands.Finish(result.address((q + 1) * 4096 + 64), round);
      queues.back()->Submit(commands.words);
    }
    // Reverse destruction encourages doorbell/queue-ID reuse on the next round.
    for (uint32_t q = count; q-- > 0;) {
      result.Wait((q + 1) * 1024 + 16, round);
      Check(result.Load((q + 1) * 1024) == round * 256 + q,
            "replacement queue lost its first work");
      queues[q].reset();
    }
    result.Wait(512, round);
    for (uint32_t i = 0; i < 128; ++i)
      Check(result.Load(i) == round + i, "survivor queue corrupted");
  }
  survivor.Drain();
  Pass("queue_churn", uint64_t(count) * iterations);
}
