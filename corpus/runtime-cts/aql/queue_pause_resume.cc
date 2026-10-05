// Purpose: Test disabling an AQL queue before publishing work, updating priority while
// paused, and re-enabling it. Require independent queue progress while pending work stays blocked,
// then check that resumed work executes exactly once; no live shader is paused.
//
// Parameters (decimal integers; ranges are inclusive):
//   Queue protocol: AQL only.
//   AQL uses ordinary dispatches and completion-signal barriers.
//   --iterations N: rounds.
//     Default 32; range 1..100000.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused here.
//   --aql-metadata off|on: gfx1250 only; default off.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDQMTest.cpp
#include <atomic>
#include <memory>
#include <thread>

#include "support/aql_payload.h"
using namespace cts;

int main(int argc, char** argv) {
  Start(argc, argv, "queue_pause_resume");
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  Device device;
  Buffer result(device, 4096);
  AqlPayload work(device, 2);
  Queue paused(device, 4096, 7, true), active(device, 4096, 7, true);
  for (uint32_t round = 1; round <= rounds; ++round) {
    paused.Drain();
    paused.SetEnabled(false);
    const uint64_t stopped = paused.consumed();
    work.Prepare(0, result.address(), 1, 1, result.address());
    work.Submit(paused, 0);
    paused.SetPriority(round % 16);
    work.Prepare(1, result.address(64), round);
    work.Submit(active, 1);
    work.Wait(active, 1);
    const uint64_t deadline = NowNs() + 1000000;
    do {
      Check(result.Load(0) == round - 1 && work.signals.Load64(8) == 1,
            "disabled AQL queue executed work");
      Check(paused.consumed() == stopped, "disabled AQL read pointer advanced");
      std::this_thread::yield();
    } while (NowNs() < deadline);
    paused.SetEnabled(true);
    work.Wait(paused, 0);
    Check(result.Load(0) == round && result.Load(16) == round, "AQL resume data mismatch");
    paused.Drain();
    active.Drain();
  }
  Pass("queue_pause_resume", rounds);
  return 0;
}
