// Purpose: Test ring backpressure while a PM4 or AQL queue is blocked on a host-controlled gate.
// A host producer submits more work than the ring can hold while another queue
// must progress. Check that gated work stays blocked, then completes exactly once.
//
// Parameters (decimal integers; ranges are inclusive):
//   --mode pm4|aql: queue protocol; default pm4.
//   AQL uses ordinary dispatches and completion-signal barriers.
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

#include "support/aql_payload.h"
#include "support/pm4.h"
using namespace torture;

static int RunPm4(int argc, char** argv) {
  Start(argc, argv, "host_gate", true);
  const uint32_t rounds = Option(argc, argv, "--iterations", 16, 100000);
  Device device(1201);
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

static int RunAql(int argc, char** argv) {
  Start(argc, argv, "host_gate", true);
  const uint32_t rounds = Option(argc, argv, "--iterations", 16, 100000);
  Device device(1201);
  Buffer result(device, 4096), gate(device, 4096);
  AqlPayload work(device, 257);
  Queue blocked(device, 4096, 7, true), independent(device, 4096, 7, true);
  for (uint32_t round = 1; round <= rounds; ++round) {
    ResetSignal(gate, 0);
    for (uint32_t i = 0; i < 256; ++i) work.Prepare(i, result.address(i * 4), round * 256 + i);
    AqlWait(blocked, gate.address());
    std::atomic<bool> entered{false}, finished{false};
    std::thread producer([&] {
      entered.store(true, std::memory_order_release);
      for (uint32_t i = 0; i < 256; ++i) work.Submit(blocked, i);
      finished.store(true, std::memory_order_release);
    });
    while (!entered.load(std::memory_order_acquire)) std::this_thread::yield();
    work.Prepare(256, result.address(2048), round);
    work.Submit(independent, 256);
    work.Wait(independent, 256);
    const uint64_t deadline = NowNs() + 1000000;
    do {
      Check(!finished.load(std::memory_order_acquire), "AQL producer overran blocked ring");
      for (uint32_t i = 0; i < 256; ++i)
        Check(work.signals.Load64(i * 64 + 8) == 1, "AQL work escaped host gate");
      std::this_thread::yield();
    } while (NowNs() < deadline);
    gate.Store64(8, 0);
    producer.join();
    for (uint32_t i = 0; i < 256; ++i) {
      work.Wait(blocked, i);
      Check(result.Load(i) == round * 256 + i, "AQL backpressure lost payload");
    }
    Check(result.Load(256) == 0, "AQL gate guard corrupted");
    blocked.Drain();
    independent.Drain();
  }
  Pass("host_gate", uint64_t(rounds) * 256);
  return 0;
}

int main(int argc, char** argv) {
  return AqlMode(argc, argv) ? RunAql(argc, argv) : RunPm4(argc, argv);
}
