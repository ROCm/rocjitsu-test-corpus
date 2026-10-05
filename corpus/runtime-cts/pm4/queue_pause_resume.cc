// Purpose: Test disabling a PM4 or AQL queue before publishing work, updating priority while
// paused, and re-enabling it. Require independent queue progress while pending work stays blocked,
// then check that resumed work executes exactly once; no live shader is paused.
//
// Parameters (decimal integers; ranges are inclusive):
//   --mode pm4|aql: queue protocol; default pm4.
//   AQL uses ordinary dispatches and completion-signal barriers.
//   --iterations N: rounds.
//     Default 32; range 1..100000.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDQMTest.cpp
#include <atomic>
#include <memory>
#include <thread>

#include "support/aql_payload.h"
#include "pm4.h"
using namespace cts;

static int RunPm4(int argc, char** argv) {
  Start(argc, argv, "queue_pause_resume", true);
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  Device device;
  Buffer result(device, 4096);
  Queue paused(device), active(device);
  for (uint32_t round = 1; round <= rounds; ++round) {
    paused.Drain();
    paused.SetEnabled(false);
    const uint64_t stopped = paused.consumed();
    Pm4 commands;
    commands.Add(result.address(), 1, false);
    commands.Finish(result.address(64), round);
    paused.Submit(commands.words);
    // UPDATE_QUEUE must preserve the disabled state even when priority changes.
    paused.SetPriority(round % 16);
    Pm4 control;
    control.Finish(result.address(128), round);
    active.Submit(control.words);
    result.Wait(32, round, 10000, &active);
    const uint64_t deadline = NowNs() + 1000000;
    while (NowNs() < deadline) {
      Check(result.Load(0) == round - 1 && result.Load(16) == round - 1,
            "disabled queue executed pending work");
      Check(paused.consumed() == stopped, "disabled queue advanced its read pointer");
      std::this_thread::yield();
    }
    paused.SetEnabled(true);
    result.Wait(16, round, 10000, &paused);
    Check(result.Load(0) == round, "resume lost or duplicated work");
  }
  paused.Drain();
  active.Drain();
  Pass("queue_pause_resume", rounds);
  return 0;
}



int main(int argc, char** argv) {
  Check(!AqlMode(argc, argv), "use the AQL suite for this scenario in AQL mode");
  return RunPm4(argc, argv);
}
