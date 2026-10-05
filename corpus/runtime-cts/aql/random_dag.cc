// Purpose: Test seeded acyclic cross-queue dependency graphs with changing predecessors and
// fan-out. Publish consumers before producers and check completion plus the payload copied through
// every node for stale reads or broken wait/signal ordering.
//
// Parameters (decimal integers; ranges are inclusive):
//   Queue protocol: AQL only.
//   Defaults to 4 queues. Seeded parent edges form a tree DAG.
//   --iterations N: rounds.
//     Default 32; range 1..100000.
//   --queues N: AQL queues.
//     Default 4; range 1..64.
//   --seed N: seed for the dependency graph.
//     Default 12345; range 1..4294967295.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --aql-metadata off|on: gfx1250 only; default off.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/fuzz_graph.py
// https://github.com/ROCm/hip-tests/blob/99d824ccba3dade7ddd5b267cc420db3f42ba9b7/catch/perftests/graph/parallelGraph.cc
#include <atomic>
#include <cstdio>
#include <memory>
#include <thread>

#include "support/aql_payload.h"

using namespace cts;

int main(int argc, char** argv) {
  Start(argc, argv, "random_dag");
  const uint32_t count = Option(argc, argv, "--queues", 4, 64);
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  uint32_t random = Option(argc, argv, "--seed", 12345, 0xffffffffu);
  std::printf("seed=%u queues=%u rounds=%u\n", random, count, rounds);
  Device device;
  Buffer result(device, count * 4096);
  AqlPayload work(device, count);
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new Queue(device, 4096, 7, true));
  for (uint32_t round = 1; round <= rounds; ++round) {
    std::vector<uint32_t> parent(count), expected(count);
    expected[0] = round * 31337;
    work.Prepare(0, result.address(), expected[0]);
    for (uint32_t q = 1; q < count; ++q) {
      random ^= random << 13;
      random ^= random >> 17;
      random ^= random << 5;
      parent[q] = random % q;
      expected[q] = expected[parent[q]] + q;
      work.Prepare(q, result.address(q * 4096), q, 1, result.address(parent[q] * 4096));
    }
    for (uint32_t q = count; q-- > 0;) {
      if (q) AqlWait(*queues[q], work.Signal(parent[q]));
      work.Submit(*queues[q], q);
    }
    for (uint32_t q = 0; q < count; ++q) {
      work.Wait(*queues[q], q);
      Check(result.Load(q * 1024) == expected[q], "AQL DAG parent data mismatch");
    }
    for (auto& queue : queues) queue->Drain();
  }
  Pass("random_dag", uint64_t(count) * rounds);
  return 0;
}
