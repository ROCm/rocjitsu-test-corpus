// Purpose: Test cross-queue fan-out and fan-in with the join submitted before its producers.
// Branches wait for a common root, copy its payload and add their branch index.
// The join waits for every branch and copies its distinct result. Check for
// stale data, wrong-branch reads or prematurely satisfied dependencies.
//
// Parameters (decimal integers; ranges are inclusive):
//   Queue protocol: AQL only.
//   Defaults to 2 branches (4 queues); allows 1..32.
//   --iterations N: rounds.
//     Default 32; range 1..100000.
//   --queues N: branches; also creates a root and a join queue.
//     Default 2; range 1..32.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
//   --aql-metadata off|on: gfx1250 only; default off.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/queue/semaphore_submission_test.cc
// https://github.com/KhronosGroup/VK-GL-CTS/blob/3905c821f43ded89284713187ffb3c7a1072afdb/external/vulkancts/modules/vulkan/synchronization/vktSynchronizationOperationMultiQueueTests.cpp
#include <atomic>
#include <memory>
#include <thread>

#include "support/aql_payload.h"

using namespace cts;

int main(int argc, char** argv) {
  Start(argc, argv, "dependency_diamond");
  const uint32_t width = Option(argc, argv, "--queues", 2, 32);
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  Device device;
  Buffer result(device, (width + 2) * 4096);
  AqlPayload work(device, width * 2 + 1);
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < width + 2; ++q) queues.emplace_back(new Queue(device, 4096, 7, true));
  for (uint32_t round = 1; round <= rounds; ++round) {
    work.Prepare(0, result.address(), round * 17);
    for (uint32_t q = 1; q <= width; ++q) {
      work.Prepare(q, result.address(q * 4096), q, 1, result.address());
      work.Prepare(width + q, result.address((width + 1) * 4096 + q * 4), 0, 1,
                   result.address(q * 4096));
    }
    // One dependency barrier per branch also supports joins wider than five signals.
    for (uint32_t q = 1; q <= width; ++q) {
      AqlWait(*queues.back(), work.Signal(q));
      work.Submit(*queues.back(), width + q);
    }
    for (uint32_t q = 1; q <= width; ++q) {
      AqlWait(*queues[q], work.Signal(0));
      work.Submit(*queues[q], q);
    }
    work.Submit(*queues[0], 0);
    for (uint32_t q = 1; q <= width; ++q) {
      work.Wait(*queues.back(), width + q);
      work.Wait(*queues[q], q);
      Check(result.Load((width + 1) * 1024 + q) == round * 17 + q,
            "AQL join read wrong branch data");
    }
    work.Wait(*queues[0], 0);
    for (auto& queue : queues) queue->Drain();
  }
  Pass("dependency_diamond", uint64_t(width + 2) * rounds);
  return 0;
}
