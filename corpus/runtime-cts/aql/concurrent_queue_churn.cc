// Purpose: Stress concurrent KFD queue creation, submission and destruction by
// host threads. Start equal-priority queues behind a host gate while a
// persistent queue progresses. Check per-thread completion, exact operation
// counts, guards and queue retirement.
//
// Queue count defaults to the native CP capacity minus companion queues.
// Explicit --queues above that budget fails before queue creation.
// Parameters (decimal integers; ranges are inclusive):
//   Queue protocol: AQL only.
//   --iterations N: rounds.
//     Default 2; range 1..100000.
//   --queues N: host threads, each owning a transient queue.
//     Default/maximum: native capacity minus companion queues.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
//   --aql-metadata off|on: gfx1250 only; default off.
// Progress waits retain their separate 10-second deadline.
// Mixed-priority gated churn stalled during bring-up; this test uses equal
// priorities.
//
// Inspiration: concurrent stream creation and enqueue stress, recreated as KFD
// queues.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/hip-tests/catch/stress/stream/Stress_hipStreamCreate.cc
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/hip-tests/catch/stress/stream/streamEnqueue.cc
#include <atomic>
#include <memory>
#include <thread>

#include "support/aql_payload.h"
using namespace cts;

int main(int argc, char** argv) {
  Start(argc, argv, "concurrent_queue_churn");
  const uint32_t count = QueueCount(argc, argv, 1);
  const uint32_t rounds = Option(argc, argv, "--iterations", 2, 100000);
  Device device;
  Buffer result(device, (count + 1) * 64), gate(device, 4096);
  AqlPayload work(device, count + 1);
  Queue anchor(device, 4096, 7, true);
  for (uint32_t round = 1; round <= rounds; ++round) {
    ResetSignal(gate, 0);
    std::atomic<uint32_t> ready{0};
    std::vector<std::thread> workers;
    for (uint32_t id = 0; id < count; ++id)
      workers.emplace_back([&, id] {
        Queue queue(device, 4096, 7, true);
        work.Prepare(id, result.address(id * 64), 1, 1,
                     result.address(id * 64));
        AqlWait(queue, gate.address());
        work.Submit(queue, id);
        ready.fetch_add(1, std::memory_order_release);
        work.Wait(queue, id);
        Check(result.Load(id * 16) == round,
              "AQL churn lost or duplicated work");
        Check(result.Load(id * 16 + 1) == 0, "AQL churn guard corrupted");
        queue.Drain();
      });
    const uint64_t deadline = NowNs() + 10000000000ull;
    while (ready.load(std::memory_order_acquire) != count) {
      Check(NowNs() < deadline, "AQL concurrent creation stalled");
      std::this_thread::yield();
    }
    work.Prepare(count, result.address(count * 64), round);
    work.Submit(anchor, count);
    work.Wait(anchor, count);
    gate.Store64(8, 0);
    for (auto& worker : workers) worker.join();
    anchor.Drain();
  }
  Pass("concurrent_queue_churn", uint64_t(count) * rounds);
  return 0;
}
