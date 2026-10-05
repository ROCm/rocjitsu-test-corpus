// Purpose: Stress repeated GPU-to-GPU handshakes between two AQL queues without host gating
// between turns. Each side waits for its peer's token before incrementing a shared
// counter in PM4 mode; AQL propagates a per-turn payload through dispatches.
// Check PM4 totals and every AQL turn, plus all completions.
//
// Parameters (decimal integers; ranges are inclusive):
//   Queue protocol: AQL only.
//   AQL uses ordinary dispatches and completion-signal barriers.
//   --iterations N: batches of eight turns per queue.
//     Default 64; range 1..100000.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/torvalds/linux/blob/551c722f40809618230001baccf219193e22fc5a/drivers/gpu/drm/scheduler/tests/tests_scheduler.c
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/clr/opencl/tests/ocltst/module/runtime/OCLMemDependency.cpp
#include <atomic>
#include <memory>
#include <thread>

#include "support/aql_payload.h"
using namespace cts;

int main(int argc, char** argv) {
  Start(argc, argv, "gpu_ping_pong");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device;
  Buffer result(device, 4096);
  AqlPayload work(device, 16);
  Queue a(device, 4096, 7, true), b(device, 4096, 7, true);
  for (uint32_t round = 1; round <= rounds; ++round) {
    result.Store(0, round * 65536);
    for (uint32_t step = 0; step < 16; ++step)
      work.Prepare(step, result.address((step + 1) * 4), 1, 1, result.address(step * 4));
    // Separate signal/storage per turn: no reset can race a queued consumer.
    for (uint32_t step = 1; step < 16; step += 2) {
      AqlWait(b, work.Signal(step - 1));
      work.Submit(b, step);
    }
    for (uint32_t step = 0; step < 16; step += 2) {
      if (step) AqlWait(a, work.Signal(step - 1));
      work.Submit(a, step);
    }
    for (uint32_t step = 0; step < 16; ++step) {
      work.Wait(step & 1 ? b : a, step);
      Check(result.Load(step + 1) == round * 65536 + step + 1, "AQL handshake ordering mismatch");
    }
    a.Drain();
    b.Drain();
  }
  Pass("gpu_ping_pong", uint64_t(rounds) * 16);
  return 0;
}
