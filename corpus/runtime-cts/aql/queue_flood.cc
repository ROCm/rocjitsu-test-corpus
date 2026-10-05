// Purpose: Exercise many independent AQL queues, mixed priorities and priority updates.
// Submit work to all queues before host waits, then check each queue's payloads
// and completion for lost work or cross-queue result corruption.
// Submission to all queues does not guarantee simultaneous pending work.
//
// Parameters (decimal integers; ranges are inclusive):
//   Queue protocol: AQL only.
//   AQL uses ordinary dispatches and completion-signal barriers.
//   --iterations N: rounds.
//     Default 64; range 1..100000.
//   --queues N: AQL queues.
//     Default 16; range 1..128.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
//   --aql-metadata off|on: gfx1250 only; default off.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDHWSTest.cpp
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/hip-tests/catch/unit/stream/hipStreamCreateWithPriority.cc
#include <atomic>
#include <memory>
#include <thread>

#include "support/aql_payload.h"

using namespace cts;

int main(int argc, char** argv) {
  Start(argc, argv, "queue_flood");
  const uint32_t count = Option(argc, argv, "--queues", 16, 128);
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device;
  Buffer result(device, count * 4096);
  AqlPayload work(device, count);
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new Queue(device, 4096, q % 16, true));
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t q = 0; q < count; ++q) {
      work.Prepare(q, result.address(q * 4096), round * 65536 + q * 128, 128);
      work.Submit(*queues[q], q);
    }
    for (uint32_t q = 0; q < count; ++q) {
      work.Wait(*queues[q], q);
      queues[q]->Drain();
      for (uint32_t i = 0; i < 128; ++i)
        Check(result.Load(q * 1024 + i) == round * 65536 + q * 128 + i,
              "AQL queue payload mismatch");
      Check(result.Load(q * 1024 + 128) == 0, "AQL queue guard corrupted");
      if (!(round % 8)) queues[q]->SetPriority((q + round / 8) % 16);
    }
  }
  Pass("queue_flood", uint64_t(count) * rounds * 128);
  return 0;
}
