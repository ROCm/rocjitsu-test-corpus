// Purpose: Test seeded acyclic cross-queue dependency graphs with changing
// predecessors and fan-out and up to five distinct parents per join. Publish
// consumers first, hold one root while independent parents finish, observe a
// reached join, prove descendants remain blocked, then release. Check every
// input edge (PM4 witnesses) or an ordered hash of all inputs (AQL shader).
// One node per queue keeps reverse submission acyclic, including FIFO edges.
//
// Queue count defaults to the native CP capacity minus companion queues.
// Explicit --queues above that budget fails before queue creation.
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --mode pm4: default pm4; use the AQL suite for AQL coverage.
//   --iterations N: rounds.
//     Default 32; range 1..100000.
//   --queues N: PM4 queues.
//     Default/maximum: native capacity minus companion queues.
//   --fan-in N: maximum parents per node; default min(5, queues - 1).
//     Range 1..min(5, queues - 1); queue capacity and graph width are separate.
//   --seed N: seed for the dependency graph.
//     Default 12345; range 1..4294967295.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/fuzz_graph.py
// https://github.com/ROCm/hip-tests/blob/99d824ccba3dade7ddd5b267cc420db3f42ba9b7/catch/perftests/graph/parallelGraph.cc
#include <algorithm>
#include <array>
#include <cstdio>
#include <memory>
#include <thread>

#include "pm4.h"
using namespace cts;
int main(int argc, char** argv) {
  Check(!AqlMode(argc, argv),
        "use the AQL suite for this scenario in AQL mode");
  Start(argc, argv, "random_dag", true);
  const uint32_t count = QueueCount(argc, argv, 0);
  const uint32_t max_fanin = Option(
      argc, argv, "--fan-in", std::min(count - 1, 5u), std::min(count - 1, 5u));
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  const uint32_t seed = Option(argc, argv, "--seed", 12345, 0xffffffffu);
  uint32_t random = seed;
  auto next = [&] {
    random ^= random << 13;
    random ^= random >> 17;
    random ^= random << 5;
    return random;
  };
  std::printf("seed=%u queues=%u rounds=%u\n", seed, count, rounds);
  Device device;
  Buffer result(device, count * 256), control(device, 4096);
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new Queue(device));

  for (uint32_t round = 1; round <= rounds; ++round) {
    // The first round reaches the maximum available fan-in. Later rounds keep
    // two roots, one held and one free, followed by randomized reconverging
    // joins.
    const uint32_t roots =
        count < 3 ? 1 : (round == 1 ? std::min(count - 1, max_fanin) : 2);
    std::vector<std::array<uint32_t, 5>> parents(count);
    std::vector<uint32_t> fanin(count), tags(count);
    for (uint32_t q = 0; q < count; ++q) {
      tags[q] = round * 31337u + q * 65537u;
      if (q >= roots) {
        const uint32_t limit = std::min(q, max_fanin);
        fanin[q] = round == 1 || limit == 1 ? limit : 2 + next() % (limit - 1);
        parents[q][0] =
            0;  // Every join has the held root as a decisive parent.
        for (uint32_t d = 1; d < fanin[q]; ++d) {
          uint32_t parent;
          do {
            parent = next() % q;
          } while (std::find(parents[q].begin(), parents[q].begin() + d,
                             parent) != parents[q].begin() + d);
          parents[q][d] = parent;
        }
      }
      for (uint32_t word = 0; word < 16; ++word) result.Store(q * 64 + word, 0);
    }
    control.Store(0, 0);
    for (uint32_t q = count; q-- > 0;) {
      Pm4 commands;
      if (q == roots) commands.Write(control.address(128), round);
      if (!q) {
        commands.Write(control.address(64), round);
        commands.Wait(control.address(), round);
      }
      for (uint32_t d = 0; d < fanin[q]; ++d) {
        const uint32_t parent = parents[q][d];
        commands.Wait(result.address(parent * 256 + 64), round);
        commands.Barrier();
        commands.Copy(result.address(parent * 256),
                      result.address(q * 256 + 4 + d * 4));
      }
      commands.Write(result.address(q * 256), tags[q]);
      commands.Finish(result.address(q * 256 + 64), round);
      queues[q]->Submit(commands.words);
    }
    control.Wait(16, round, 10000, queues[0].get());
    for (uint32_t q = 1; q < roots; ++q)
      result.Wait(q * 64 + 16, round, 10000, queues[q].get());
    if (roots < count) control.Wait(32, round, 10000, queues[roots].get());
    const uint64_t deadline = NowNs() + 1000000;
    do {
      for (uint32_t q = 0; q < count; ++q) {
        if (q > 0 && q < roots) continue;
        Check(result.Load(q * 64) == 0 && result.Load(q * 64 + 16) == round - 1,
              "DAG descendant escaped held root");
      }
      std::this_thread::yield();
    } while (NowNs() < deadline);
    control.Store(0, round);
    for (uint32_t q = 0; q < count; ++q) {
      result.Wait(q * 64 + 16, round, 10000, queues[q].get());
      Check(result.Load(q * 64) == tags[q], "DAG node payload mismatch");
      for (uint32_t d = 0; d < fanin[q]; ++d) {
        const uint32_t parent = parents[q][d];
        const uint32_t observed = result.Load(q * 64 + 1 + d);
        if (observed != tags[parent])
          Fail(
              "DAG seed=%u round=%u queue=%u edge=%u parent=%u expected=%x "
              "observed=%x",
              seed, round, q, d, parent, tags[parent], observed);
      }
      for (uint32_t word = 1 + fanin[q]; word < 16; ++word)
        Check(result.Load(q * 64 + word) == 0, "DAG output guard corrupted");
    }
    for (auto& queue : queues) queue->Drain();
  }
  Pass("random_dag", uint64_t(count) * rounds);
}
