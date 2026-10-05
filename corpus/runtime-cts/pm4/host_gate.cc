// Purpose: Test ring backpressure while a PM4 queue is blocked on a host-controlled gate.
// A host producer submits more work than the ring can hold while another queue
// must progress. Observe an actual full-ring reservation before the negative
// phase; then release and verify all payloads or exact operation counts.
//
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --mode pm4: default pm4; use the AQL suite for AQL coverage.
//   --iterations N: rounds.
//     Default 16; range 1..100000.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/KhronosGroup/OpenCL-CTS/blob/9feccbb8fcb8eefeebf86a48036173a8155f9d21/test_conformance/events/test_userevents_multithreaded.cpp
// https://github.com/torvalds/linux/blob/551c722f40809618230001baccf219193e22fc5a/drivers/gpu/drm/scheduler/tests/tests_scheduler.c
#include <atomic>
#include <memory>
#include <thread>

#include "pm4.h"
#include "support/aql_payload.h"
using namespace cts;

static int RunPm4(int argc, char** argv) {
  Start(argc, argv, "host_gate", true);
  const uint32_t rounds = Option(argc, argv, "--iterations", 16, 100000);
  Device device;
  Buffer result(device, 4096);
  Queue blocked(device), independent(device);
  for (uint32_t round = 1; round <= rounds; ++round) {
    result.Store(0, 0);
    Pm4 head;
    head.Write(result.address(64), round);
    head.Wait(result.address(), round);
    head.Pad();
    blocked.Submit(head.words);
    result.Wait(16, round, 10000, &blocked);
    const uint64_t initial_backpressure = blocked.backpressure_count();
    std::atomic<bool> entered{false}, finished{false};
    // More work than a ring can hold forces real producer backpressure while
    // the GPU is waiting. Only this thread uses the blocked queue until join.
    std::thread producer([&] {
      entered.store(true, std::memory_order_release);
      for (uint32_t i = 0; i < 256; ++i) {
        Pm4 commands;
        commands.Add(result.address(128), 1, false);
        commands.Pad();
        blocked.Submit(commands.words);
      }
      Pm4 done;
      done.Finish(result.address(192), round);
      blocked.Submit(done.words);
      finished.store(true, std::memory_order_release);
    });
    while (!entered.load(std::memory_order_acquire)) std::this_thread::yield();
    const uint64_t full_deadline = NowNs() + 10000000000ull;
    while (blocked.backpressure_count() == initial_backpressure) {
      Check(NowNs() < full_deadline, "producer did not reach ring capacity");
      std::this_thread::yield();
    }
    Pm4 control;
    control.Finish(result.address(256), round);
    independent.Submit(control.words);
    result.Wait(64, round, 10000, &independent);
    const uint64_t deadline = NowNs() + 1000000;
    while (NowNs() < deadline) {
      Check(!finished.load(std::memory_order_acquire), "producer overran a blocked ring");
      Check(result.Load(32) == (round - 1) * 256, "work escaped the host gate");
      std::this_thread::yield();
    }
    result.Store(0, round);
    producer.join();
    result.Wait(48, round, 10000, &blocked);
    Check(result.Load(32) == round * 256, "backpressure lost or duplicated queued work");
    blocked.Drain();
  }
  independent.Drain();
  Pass("host_gate", rounds * 256);
  return 0;
}

int main(int argc, char** argv) {
  Check(!AqlMode(argc, argv), "use the AQL suite for this scenario in AQL mode");
  return RunPm4(argc, argv);
}
