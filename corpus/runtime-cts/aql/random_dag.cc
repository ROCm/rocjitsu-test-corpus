// Purpose: Test seeded acyclic cross-queue dependency graphs with changing
// predecessors and fan-out and up to five distinct parents per join. Publish
// consumers first, hold one root while independent parents finish, observe a
// reached join, prove descendants remain blocked, then release. Check every
// input edge (PM4 witnesses) or an ordered hash of all inputs (AQL shader).
// One node per queue keeps reverse submission acyclic, including FIFO edges.
//
// Parameters (decimal integers; ranges are inclusive):
//   Queue protocol: AQL only.
//   Defaults to 4 queues; use at least 6 for five-parent joins.
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
#include <algorithm>
#include <array>
#include <cstdio>
#include <cstring>
#include <memory>
#include <thread>

#include "dag_kernel.inc"
#include "support/aql.h"
using namespace cts;
struct DagArgs {
  uint64_t parents[5], target;
  uint32_t count, tag;
};
struct Barrier {
  uint64_t header = 3u | (1u << 8) | (2u << 9) | (2u << 11);
  uint64_t dependencies[5]{}, reserved = 0, completion = 0;
};
static_assert(sizeof(Barrier) == 64);
int main(int argc, char** argv) {
  Start(argc, argv, "random_dag");
  const uint32_t count = Option(argc, argv, "--queues", 4, 64);
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
  for (uint32_t q = 0; q < count; ++q)
    queues.emplace_back(new Queue(device, 4096, 7, true));
  Buffer code(device, sizeof(kKernelImage), true), args(device, count * 512),
      signals(device, count * 64);
  Check(kKernargBytes >= sizeof(DagArgs) && kKernargBytes <= 512,
        "DAG kernarg size");
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  for (uint32_t round = 1; round <= rounds; ++round) {
    // The first round reaches the maximum available fan-in. Later rounds keep
    // two roots, one held and one free, followed by randomized reconverging
    // joins.
    const uint32_t roots =
        count < 3 ? 1 : (round == 1 ? std::min(count - 1, 5u) : 2);
    std::vector<std::array<uint32_t, 5>> parents(count);
    std::vector<uint32_t> fanin(count), tags(count), expected(count);
    for (uint32_t q = 0; q < count; ++q) {
      tags[q] = round * 31337u + q * 65537u;
      expected[q] = tags[q];
      if (q >= roots) {
        const uint32_t limit = std::min(q, 5u);
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
      ResetSignal(signals, q * 64);
      DagArgs a{};
      a.target = result.address(q * 256);
      a.count = fanin[q];
      a.tag = tags[q];
      for (uint32_t d = 0; d < fanin[q]; ++d) {
        a.parents[d] = result.address(parents[q][d] * 256);
        expected[q] = (expected[q] ^ expected[parents[q][d]]) * 16777619u + d;
      }
      std::memcpy(static_cast<char*>(args.data) + q * 512, &a, sizeof(a));
    }
    ResetSignal(control, 0);
    ResetSignal(control, 64);
    ResetSignal(control, 128);
    for (uint32_t q = count; q-- > 0;) {
      Barrier wait;
      if (q == roots) {
        Barrier reached;
        reached.completion = control.address(128);
        queues[q]->SubmitAql(&reached);
      }
      if (q) {
        for (uint32_t d = 0; d < fanin[q]; ++d)
          wait.dependencies[d] = signals.address(parents[q][d] * 64);
      } else {
        Barrier reached;
        reached.completion = control.address(64);
        queues[q]->SubmitAql(&reached);
        wait.dependencies[0] = control.address();
      }
      queues[q]->SubmitAql(&wait);
      Dispatch packet =
          OneGroup(code.address(kDescriptorOffset), args.address(q * 512),
                   signals.address(q * 64), true);
      queues[q]->SubmitAql(&packet);
    }
    WaitSignal(control, 64, *queues[0]);
    for (uint32_t q = 1; q < roots; ++q)
      WaitSignal(signals, q * 64, *queues[q]);
    if (roots < count) WaitSignal(control, 128, *queues[roots]);
    const uint64_t deadline = NowNs() + 1000000;
    do {
      for (uint32_t q = 0; q < count; ++q) {
        if (q > 0 && q < roots) continue;
        Check(signals.Load64(q * 64 + 8) == 1 && result.Load(q * 64 + 1) == 0,
              "DAG descendant escaped held root");
      }
      std::this_thread::yield();
    } while (NowNs() < deadline);
    control.Store64(8, 0);
    for (uint32_t q = 0; q < count; ++q) {
      WaitSignal(signals, q * 64, *queues[q]);
      if (result.Load(q * 64) != expected[q] ||
          result.Load(q * 64 + 1) != tags[q]) {
        std::fprintf(stderr, "seed=%u round=%u queue=%u parents=", seed, round,
                     q);
        for (uint32_t d = 0; d < fanin[q]; ++d)
          std::fprintf(stderr, "%u,", parents[q][d]);
        Fail(" DAG hash expected=%x observed=%x", expected[q],
             result.Load(q * 64));
      }
      for (uint32_t word = 2; word < 16; ++word)
        Check(result.Load(q * 64 + word) == 0, "DAG output guard corrupted");
    }
    for (auto& queue : queues) queue->Drain();
  }
  Pass("random_dag", uint64_t(count) * rounds);
}
