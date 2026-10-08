// Purpose: Test cross-queue fan-out and fan-in with the join submitted before
// its producers. Branches wait for a common root, copy its payload and add
// their branch index. The join waits for every branch and copies its distinct
// result. Check for stale data, wrong-branch reads or prematurely satisfied
// dependencies.
//
// Queue count defaults to the native CP capacity minus companion queues.
// Explicit --queues above that budget fails before queue creation.
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --mode pm4: default pm4; use the AQL suite for AQL coverage.
//   --iterations N: rounds.
//     Default 32; range 1..100000.
//   --queues N: branches; also creates a root and a join queue.
//     Default/maximum: native capacity minus companion queues.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/queue/semaphore_submission_test.cc
// https://github.com/KhronosGroup/VK-GL-CTS/blob/3905c821f43ded89284713187ffb3c7a1072afdb/external/vulkancts/modules/vulkan/synchronization/vktSynchronizationOperationMultiQueueTests.cpp
#include <atomic>
#include <memory>
#include <thread>

#include "pm4.h"
#include "support/aql_payload.h"

using namespace cts;

static int RunPm4(int argc, char** argv) {
  Start(argc, argv, "dependency_diamond", true);
  const uint32_t width = QueueCount(argc, argv, 2);
  const uint32_t iterations = Option(argc, argv, "--iterations", 32, 100000);
  Device device;
  Buffer result(device, (width + 2) * 4096);
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < width + 2; ++q)
    queues.emplace_back(new Queue(device));
  for (uint32_t round = 1; round <= iterations; ++round) {
    Pm4 join;
    for (uint32_t q = 1; q <= width; ++q) {
      join.Wait(result.address(q * 4096 + 64), round);
      join.Barrier();
      join.Copy(result.address(q * 4096),
                result.address((width + 1) * 4096 + q * 4));
    }
    join.Finish(result.address((width + 1) * 4096 + 2048), round);
    queues.back()->Submit(join.words);
    for (uint32_t q = 1; q <= width; ++q) {
      Pm4 branch;
      branch.Wait(result.address(64), round);
      branch.Barrier();
      branch.Copy(result.address(), result.address(q * 4096));
      branch.Barrier();
      branch.Add(result.address(q * 4096), q, false);
      branch.Finish(result.address(q * 4096 + 64), round);
      queues[q]->Submit(branch.words);
    }
    Pm4 root;
    root.Write(result.address(), round * 17);
    root.Finish(result.address(64), round);
    queues[0]->Submit(root.words);
    result.Wait((width + 1) * 1024 + 512, round);
    for (uint32_t q = 1; q <= width; ++q)
      Check(result.Load((width + 1) * 1024 + q) == round * 17 + q,
            "fan-in read stale or incorrect branch data");
  }
  for (auto& queue : queues) queue->Drain();
  Pass("dependency_diamond", uint64_t(width + 2) * iterations);
  return 0;
}

int main(int argc, char** argv) {
  Check(!AqlMode(argc, argv),
        "use the AQL suite for this scenario in AQL mode");
  return RunPm4(argc, argv);
}
