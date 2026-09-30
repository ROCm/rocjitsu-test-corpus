// Purpose: Test seeded acyclic cross-queue dependency graphs with changing predecessors and joins.
// Publish consumers before producers and check completion plus the payload copied
// through every node for stale reads or broken wait/signal ordering.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds.
//     Default 32; range 1..100000.
//   --queues N: PM4 queues.
//     Default 16; range 1..64.
//   --seed N: seed for the dependency graph.
//     Default 12345; range 1..4294967295.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/fuzz_graph.py
// https://github.com/ROCm/hip-tests/blob/99d824ccba3dade7ddd5b267cc420db3f42ba9b7/catch/perftests/graph/parallelGraph.cc
#include <cstdio>
#include <memory>

#include "support/pm4.h"

using namespace torture;

int main(int argc, char** argv) {
  Start(argc, argv, "random_dag");
  const uint32_t count = Option(argc, argv, "--queues", 16, 64);
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  uint32_t random = Option(argc, argv, "--seed", 12345, 0xffffffffu);
  std::printf("seed=%u queues=%u rounds=%u\n", random, count, rounds);
  Device device(TEST_GFX);
  Buffer result(device, count * 4096);
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new Queue(device));
  for (uint32_t round = 1; round <= rounds; ++round) {
    std::vector<uint32_t> parent(count);
    for (uint32_t q = 1; q < count; ++q) {
      random ^= random << 13;
      random ^= random >> 17;
      random ^= random << 5;
      parent[q] = random % q;
    }
    for (uint32_t q = count; q-- > 0;) {
      Pm4 commands;
      if (q) {
        commands.Wait(result.address(parent[q] * 4096 + 64), round);
        // A second predecessor creates joins while edges always point to a
        // lower-numbered queue: no generated graph can contain a cycle.
        commands.Wait(result.address((q - 1) * 4096 + 64), round);
        commands.Barrier();
        commands.Copy(result.address(parent[q] * 4096), result.address(q * 4096));
      } else
        commands.Write(result.address(), round * 31337);
      commands.Finish(result.address(q * 4096 + 64), round);
      queues[q]->Submit(commands.words);
    }
    for (uint32_t q = 0; q < count; ++q) {
      result.Wait(q * 1024 + 16, round);
      if (result.Load(q * 1024) != round * 31337)
        Fail("DAG mismatch round=%u queue=%u parent=%u", round, q, parent[q]);
    }
  }
  for (auto& queue : queues) queue->Drain();
  Pass("random_dag", uint64_t(rounds) * count);
}
