// Purpose: Require a high-priority PM4 consumer to progress through
// a low-priority producer while a medium-priority queue is active. Submit the
// consumer first and hold the producer behind a host gate; verify independent
// progress, blocked consumer, then data visibility after release. Alternate
// priorities between retired rounds. No relative-latency guarantee is assumed.
//
// Parameters (decimal integers; ranges are inclusive):
//   --mode pm4|aql: queue protocol; default pm4.
//   AQL uses ordinary dispatches and completion-signal barriers.
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDQMTest.cpp
#include <atomic>
#include <memory>
#include <thread>

#include "support/aql_payload.h"
#include "pm4.h"
using namespace cts;
static int RunPm4(int argc, char** argv) {
  Start(argc, argv, "priority_dependency", true);
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device;
  Buffer memory(device, 4096);
  Queue low(device, 4096, 0), high(device, 4096, 15), medium(device, 4096, 7);
  for (uint32_t round = 1; round <= rounds; ++round) {
    low.SetPriority(round & 1 ? 0 : 1);
    high.SetPriority(round & 1 ? 15 : 14);
    Pm4 consume;
    consume.Wait(memory.address(64), round);
    consume.Barrier();
    consume.Copy(memory.address(256), memory.address(320));
    consume.Finish(memory.address(128), round);
    high.Submit(consume.words);
    Pm4 produce;
    produce.Wait(memory.address(), round);
    produce.Write(memory.address(256), round * 17);
    produce.Finish(memory.address(64), round);
    low.Submit(produce.words);
    Pm4 background;
    for (uint32_t i = 0; i < 63; ++i) background.Write(memory.address(512 + i * 4), round + i);
    background.Finish(memory.address(192), round);
    medium.Submit(background.words);
    memory.Wait(48, round, 10000, &medium);
    const uint64_t deadline = NowNs() + 1000000;
    do {
      Check(memory.Load(32) == round - 1, "priority consumer ignored producer gate");
      std::this_thread::yield();
    } while (NowNs() < deadline);
    memory.Store(0, round);
    memory.Wait(32, round, 10000, &high);
    Check(memory.Load(80) == round * 17, "priority dependency consumed stale data");
    for (uint32_t i = 0; i < 63; ++i)
      Check(memory.Load(128 + i) == round + i, "medium-priority queue data mismatch");
    Check(memory.Load(191) == 0, "priority output guard corrupted");
    low.Drain();
    high.Drain();
    medium.Drain();
  }
  Pass("priority_dependency", rounds);
  return 0;
}



int main(int argc, char** argv) {
  Check(!AqlMode(argc, argv), "use the AQL suite for this scenario in AQL mode");
  return RunPm4(argc, argv);
}
