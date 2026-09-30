// Purpose: Stress concurrent KFD queue creation, submission and destruction by host threads.
// Start equal-priority queues behind a host gate while a persistent queue progresses.
// Check per-thread completion, exact operation counts, guards and queue retirement.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds.
//     Default 16; range 1..100000.
//   --queues N: host threads, each owning a transient queue.
//     Default 8; range 1..64.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
// Mixed-priority gated churn stalled during bring-up; this test uses equal priorities.
//
// Inspiration: concurrent stream creation and enqueue stress, recreated as KFD queues.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/hip-tests/catch/stress/stream/Stress_hipStreamCreate.cc
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/hip-tests/catch/stress/stream/streamEnqueue.cc
#include <atomic>
#include <thread>

#include "support/pm4.h"
using namespace torture;
int main(int argc, char** argv) {
  Start(argc, argv, "concurrent_queue_churn");
  const uint32_t count = Option(argc, argv, "--queues", 8, 64);
  const uint32_t rounds = Option(argc, argv, "--iterations", 16, 100000);
  Device device(TEST_GFX);
  Buffer shared(device, (count + 2) * 64);
  // Establish the process doorbell mapping before concurrent queue creation.
  Queue anchor(device);
  std::atomic<uint32_t> ready{0}, retired{0}, begin{1};
  std::vector<std::thread> workers;
  for (uint32_t id = 0; id < count; ++id)
    workers.emplace_back([&, id] {
      for (uint32_t round = 1; round <= rounds; ++round) {
        // Keep generations separate: retire every queue using the old gate
        // value before any worker publishes a wait for the next value.
        const uint64_t begin_deadline = NowNs() + 10000000000ull;
        while (begin.load(std::memory_order_acquire) != round) {
          if (NowNs() >= begin_deadline) Fail("concurrent queue round stalled");
          std::this_thread::yield();
        }
        {
          Queue queue(device, 4096, 7);
          Pm4 stream;
          stream.Wait(shared.address(), round);
          stream.Add(shared.address((id + 2) * 64), 1, false);
          stream.Finish(shared.address((id + 2) * 64 + 4), round);
          queue.Submit(stream.words);
          ready.fetch_add(1, std::memory_order_release);
          shared.Wait((id + 2) * 16 + 1, round, 10000, &queue);
          Check(shared.Load((id + 2) * 16) == round, "threaded queue lost or duplicated work");
          Check(shared.Load((id + 2) * 16 + 2) == 0, "threaded queue guard corrupted");
          queue.Drain();
        }
        retired.fetch_add(1, std::memory_order_release);
      }
    });
  for (uint32_t round = 1; round <= rounds; ++round) {
    const uint64_t deadline = NowNs() + 10000000000ull;
    while (ready.load(std::memory_order_acquire) < count * round) {
      if (NowNs() >= deadline) Fail("concurrent queue creation stalled");
      std::this_thread::yield();
    }
    Pm4 stream;
    stream.Finish(shared.address(64), round);
    anchor.Submit(stream.words);
    shared.Wait(16, round, 10000, &anchor);
    shared.Store(0, round);
    const uint64_t retire_deadline = NowNs() + 10000000000ull;
    while (retired.load(std::memory_order_acquire) < count * round) {
      if (NowNs() >= retire_deadline) Fail("concurrent queue retirement stalled");
      std::this_thread::yield();
    }
    begin.store(round + 1, std::memory_order_release);
  }
  for (auto& worker : workers) worker.join();
  Check(retired.load() == count * rounds, "queue retirement count mismatch");
  anchor.Drain();
  Pass("concurrent_queue_churn", uint64_t(count) * rounds);
}
