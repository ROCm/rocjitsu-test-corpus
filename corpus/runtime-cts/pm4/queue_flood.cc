// Purpose: Exercise many independent PM4 queues, mixed priorities and priority
// updates. Submit work to all queues before host waits, then check each queue's
// payloads and completion for lost work or cross-queue result corruption.
// Multiprocess workers hold their queues at ready/start and done/release
// rendezvous. Submission to all queues does not guarantee simultaneous pending
// work.
//
// Queue count defaults to the native CP capacity minus companion queues.
// Explicit --queues above that budget fails before queue creation.
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --mode pm4: default pm4; use the AQL suite for AQL coverage.
//   --iterations N: rounds.
//     Default 9; range 1..100000.
//   --queues N: PM4 queues.
//     Default/maximum: native capacity minus companion queues.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDHWSTest.cpp
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/hip-tests/catch/unit/stream/hipStreamCreateWithPriority.cc
#include <atomic>
#include <memory>
#include <thread>

#include "pm4.h"
#include "support/aql_payload.h"
#include "support/process_group.h"
using namespace cts;

static int RunPm4(int argc, char** argv) {
  Start(argc, argv, "queue_flood", true);
  const uint32_t count = QueueCount(argc, argv, 0);
  const uint32_t iterations = Option(argc, argv, "--iterations", 9, 100000);
  Device device;
  Buffer result(device, count * 4096);
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q)
    queues.emplace_back(new Queue(device, 4096, q % 16));
  WorkerPhase('R');
  for (uint32_t round = 1; round <= iterations; ++round) {
    for (uint32_t q = 0; q < count; ++q) {
      Pm4 commands;
      for (uint32_t i = 0; i < 128; ++i)
        commands.Write(result.address(q * 4096 + i * 4),
                       round * 65536 + q * 128 + i);
      commands.Finish(result.address(q * 4096 + 2048), round);
      queues[q]->Submit(commands.words);
    }
    // Every queue has been submitted; earlier work may already have completed.
    for (uint32_t q = 0; q < count; ++q) {
      result.Wait(q * 1024 + 512, round);
      for (uint32_t i = 0; i < 128; ++i)
        Check(result.Load(q * 1024 + i) == round * 65536 + q * 128 + i,
              "queue flood payload mismatch");
      Check(result.Load(q * 1024 + 128) == 0, "queue flood guard corrupted");
      if (!(round % 8)) queues[q]->SetPriority((q + round / 8) % 16);
    }
  }
  for (auto& queue : queues) queue->Drain();
  WorkerPhase('D');
  Pass("queue_flood", uint64_t(count) * iterations * 128);
  return 0;
}

int main(int argc, char** argv) {
  Check(!AqlMode(argc, argv),
        "use the AQL suite for this scenario in AQL mode");
  return RunPm4(argc, argv);
}
