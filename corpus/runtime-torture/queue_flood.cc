// Purpose: Stress many PM4 queues with outstanding work, mixed priorities and priority updates.
// Submit work to all queues before host waits, then check each queue's payloads
// and completion for lost work or cross-queue result corruption.
//
// Parameters (decimal integers; ranges are inclusive):
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
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDHWSTest.cpp
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/hip-tests/catch/unit/stream/hipStreamCreateWithPriority.cc
#include <memory>

#include "support/pm4.h"

using namespace torture;

int main(int argc, char** argv) {
  Start(argc, argv, "queue_flood");
  const uint32_t count = Option(argc, argv, "--queues", 16, 128);
  const uint32_t iterations = Option(argc, argv, "--iterations", 64, 100000);
  Device device(TEST_GFX);
  Buffer result(device, count * 4096);
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new Queue(device, 4096, q % 16));
  for (uint32_t round = 1; round <= iterations; ++round) {
    for (uint32_t q = 0; q < count; ++q) {
      Pm4 commands;
      for (uint32_t i = 0; i < 128; ++i)
        commands.Write(result.address(q * 4096 + i * 4), round * 65536 + q * 128 + i);
      commands.Finish(result.address(q * 4096 + 2048), round);
      queues[q]->Submit(commands.words);
    }
    // All queues have outstanding work before any host completion wait.
    for (uint32_t q = 0; q < count; ++q) {
      result.Wait(q * 1024 + 512, round);
      for (uint32_t i = 0; i < 128; ++i)
        Check(result.Load(q * 1024 + i) == round * 65536 + q * 128 + i,
              "queue flood payload mismatch");
      if (!(round % 8)) queues[q]->SetPriority((q + round / 8) % 16);
    }
  }
  for (auto& queue : queues) queue->Drain();
  Pass("queue_flood", uint64_t(count) * iterations * 128);
}
