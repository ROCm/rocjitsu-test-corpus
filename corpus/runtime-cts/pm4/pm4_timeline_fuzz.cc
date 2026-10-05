// Purpose: Stress a seeded streaming graph of 64-bit timeline waits and signals across queues.
// Wait only on previously published work to avoid cycles, with sparse host waits
// and timeline values crossing the low-word boundary. Check every payload, final
// timeline and the exact operation count.
//
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --iterations N: graph submission steps.
//     Default 1024; range 1..1000000.
//   --queues N: PM4 queues.
//     Default 8; range 1..64.
//   --seed N: seed for the dependency graph.
//     Default 1337; range 1..4294967295.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_fuzz_hcq_signals.py
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_test_amd.py
#include <cstdio>
#include <memory>

#include "pm4.h"
using namespace cts;

int main(int argc, char** argv) {
  Start(argc, argv, "pm4_timeline_fuzz");
  const uint32_t count = Option(argc, argv, "--queues", 8, 64);
  const uint32_t steps = Option(argc, argv, "--iterations", 1024, 1000000);
  uint32_t random = Option(argc, argv, "--seed", 1337, 0xffffffffu);
  std::printf("seed=%u queues=%u steps=%u\n", random, count, steps);
  auto next = [&] {
    random ^= random << 13;
    random ^= random >> 17;
    random ^= random << 5;
    return random;
  };
  Device device;
  Buffer timelines(device, count * 64);
  Buffer result(device, (size_t(steps) + count + 1) * 4);
  std::vector<std::unique_ptr<Queue>> queues;
  std::vector<uint64_t> values(count, 0xfffffff0ull);
  for (uint32_t q = 0; q < count; ++q) {
    timelines.Store64(q * 64, values[q]);
    queues.emplace_back(new Queue(device));
  }
  for (uint32_t step = 0; step < steps; ++step) {
    uint32_t q = next() % count;
    Pm4 commands;
    const uint32_t dependencies = 1 + next() % 4;
    for (uint32_t d = 0; d < dependencies; ++d) {
      const uint32_t other = next() % count;
      // Snapshot previously published work only, so global ordering is acyclic.
      commands.Wait64(timelines.address(other * 64), values[other]);
    }
    commands.Write(result.address(step * 4), step + 1);
    commands.Add(result.address(size_t(steps) * 4), 1, false);
    commands.Barrier();
    commands.Exchange64(timelines.address(q * 64), ++values[q]);
    commands.Pad();
    queues[q]->Submit(commands.words);
    if (!(next() % 17)) result.Wait(step, step + 1, 10000, queues[q].get());
  }
  for (uint32_t q = 0; q < count; ++q) {
    Pm4 finish;
    finish.Finish(result.address((size_t(steps) + 1 + q) * 4), 1);
    queues[q]->Submit(finish.words);
  }
  for (uint32_t q = 0; q < count; ++q) {
    result.Wait(steps + 1 + q, 1, 10000, queues[q].get());
    Check(timelines.Load64(q * 64) == values[q], "final timeline mismatch");
    queues[q]->Drain();
  }
  for (uint32_t step = 0; step < steps; ++step)
    Check(result.Load(step) == step + 1, "timeline graph lost a payload");
  Check(result.Load(steps) == steps, "timeline graph lost or duplicated operations");
  Pass("pm4_timeline_fuzz", steps);
}
