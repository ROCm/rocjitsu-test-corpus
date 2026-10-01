// Purpose: Stress multiple host producers sharing one PM4 or AQL ring with serialized publication.
// Check each producer's payload and completion so ring reuse and host contention
// cannot silently lose work or mix up results.
//
// Parameters (decimal integers; ranges are inclusive):
//   --mode pm4|aql: queue protocol; default pm4.
//   Both modes serialize publication; this does not test concurrent AQL reservation.
//   --iterations N: submissions per producer thread.
//     Default 128; range 1..100000.
//   --queues N: host producer threads sharing one queue.
//     Default 8; range 1..64.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/rocrtst/suites/stress/queue_write_index_concurrent_tests.cc
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/hip-tests/catch/stress/stream/streamEnqueue.cc
#include <atomic>
#include <memory>
#include <mutex>
#include <thread>

#include "support/aql_payload.h"
#include "support/pm4.h"

using namespace torture;

static int RunPm4(int argc, char** argv) {
  Start(argc, argv, "concurrent_submit", true);
  const uint32_t count = Option(argc, argv, "--queues", 8, 64);
  const uint32_t iterations = Option(argc, argv, "--iterations", 128, 100000);
  Device device(1201);
  Buffer result(device, count * 4096);
  Queue queue(device);
  std::mutex producer;
  std::vector<std::thread> threads;
  for (uint32_t t = 0; t < count; ++t)
    threads.emplace_back([&, t] {
      for (uint32_t round = 1; round <= iterations; ++round) {
        Pm4 commands;
        commands.Write(result.address(t * 4096), round * 64 + t);
        commands.Finish(result.address(t * 4096 + 64), round);
        {
          // PM4 has no AQL-style per-slot commit header: serialize publication.
          std::lock_guard<std::mutex> lock(producer);
          queue.Submit(commands.words);
        }
        result.Wait(t * 1024 + 16, round);
        Check(result.Load(t * 1024) == round * 64 + t, "concurrent producer data mismatch");
      }
    });
  for (auto& thread : threads) thread.join();
  queue.Drain();
  Pass("concurrent_submit", uint64_t(count) * iterations);
  return 0;
}

static int RunAql(int argc, char** argv) {
  Start(argc, argv, "concurrent_submit", true);
  const uint32_t count = Option(argc, argv, "--queues", 8, 64);
  const uint32_t rounds = Option(argc, argv, "--iterations", 128, 100000);
  Device device(1201);
  Buffer result(device, count * 4096);
  AqlPayload work(device, count);
  Queue queue(device, 4096, 7, true);
  std::mutex producer;
  std::vector<std::thread> threads;
  for (uint32_t t = 0; t < count; ++t)
    threads.emplace_back([&, t] {
      for (uint32_t round = 1; round <= rounds; ++round) {
        work.Prepare(t, result.address(t * 4096), round * 64 + t);
        {
          std::lock_guard<std::mutex> lock(producer);
          work.Submit(queue, t);
        }
        // Wait without Queue diagnostics: its software counters belong to producer.
        work.signals.Wait((t * 64 + 8) / 4, 0);
        Check(work.signals.Load64(t * 64 + 8) == 0, "completion underflow");
        Check(result.Load(t * 1024) == round * 64 + t, "AQL producer data mismatch");
      }
    });
  for (auto& thread : threads) thread.join();
  queue.Drain();
  Pass("concurrent_submit", uint64_t(count) * rounds);
  return 0;
}

int main(int argc, char** argv) {
  return AqlMode(argc, argv) ? RunAql(argc, argv) : RunPm4(argc, argv);
}
