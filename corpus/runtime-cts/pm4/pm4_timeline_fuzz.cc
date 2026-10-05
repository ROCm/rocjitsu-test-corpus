// Purpose: Stress a seeded streaming graph of 64-bit timeline waits and signals across queues.
// Wait only on previously published work to avoid cycles, with sparse host waits
// and timeline values crossing the low-word boundary. Check every payload, final
// timeline and the exact operation count. Every wait copies its producer
// payload into an immutable edge witness. A held producer first proves that
// a reached consumer cannot complete before release.
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
#include <array>
#include <cstdio>
#include <memory>
#include <thread>

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
  Buffer timelines(device, count * 64), witnesses(device, size_t(steps) * 4 * 4);
  Buffer control(device, 4096);
  Buffer result(device, (size_t(steps) + count + 1) * 4);
  std::vector<std::unique_ptr<Queue>> queues;
  std::vector<uint64_t> values(count, 0xfffffff0ull);
  for (uint32_t q = 0; q < count; ++q) {
    timelines.Store64(q * 64, values[q]);
    queues.emplace_back(new Queue(device));
  }
  // A separate pair keeps the controlled negative phase meaningful even with one stream queue.
  Queue held(device), dependent(device);
  Pm4 source;
  source.Write(control.address(64), 1);
  source.Wait(control.address(), 1);
  source.Write(control.address(128), 0x13579bdf);
  source.Barrier();
  source.Exchange64(control.address(192), 0x100000001ull);
  source.Pad();
  held.Submit(source.words);
  Pm4 sink;
  sink.Write(control.address(256), 1);
  sink.Wait64(control.address(192), 0x100000001ull);
  sink.Barrier();
  sink.Copy(control.address(128), control.address(320));
  sink.Finish(control.address(384), 1);
  dependent.Submit(sink.words);
  control.Wait(16, 1, 10000, &held);
  control.Wait(64, 1, 10000, &dependent);
  const uint64_t deadline = NowNs() + 1000000;
  do {
    Check(control.Load(80) == 0 && control.Load(96) == 0, "held timeline dependency escaped");
    std::this_thread::yield();
  } while (NowNs() < deadline);
  control.Store(0, 1);
  control.Wait(96, 1, 10000, &dependent);
  Check(control.Load(80) == 0x13579bdf, "timeline dependency data mismatch");
  held.Drain();
  dependent.Drain();
  std::vector<uint32_t> last(count, steps);  // steps denotes the initialized generation zero.
  std::vector<std::array<uint32_t, 4>> parents(steps);
  std::vector<uint32_t> fanin(steps);
  for (uint32_t step = 0; step < steps; ++step) {
    uint32_t q = next() % count;
    Pm4 commands;
    const uint32_t dependencies = fanin[step] = 1 + next() % 4;
    for (uint32_t d = 0; d < dependencies; ++d) {
      const uint32_t other = next() % count;
      // Snapshot previously published work only, so global ordering is acyclic.
      commands.Wait64(timelines.address(other * 64), values[other]);
      parents[step][d] = last[other];
      commands.Barrier();
      // Initial timelines refer to the untouched zero word in control, never the count word.
      commands.Copy(last[other] == steps ? control.address(448) : result.address(last[other] * 4),
                    witnesses.address((size_t(step) * 4 + d) * 4));
    }
    commands.Write(result.address(step * 4), step + 1);
    commands.Add(result.address(size_t(steps) * 4), 1, false);
    commands.Barrier();
    commands.Exchange64(timelines.address(q * 64), ++values[q]);
    commands.Pad();
    queues[q]->Submit(commands.words);
    last[q] = step;
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
  for (uint32_t step = 0; step < steps; ++step)
    for (uint32_t d = 0; d < fanin[step]; ++d) {
      const uint32_t parent = parents[step][d];
      const uint32_t expected = parent == steps ? 0 : parent + 1;
      const uint32_t observed = witnesses.Load(size_t(step) * 4 + d);
      if (observed != expected)
        Fail("timeline edge step=%u edge=%u parent=%u expected=%x observed=%x", step, d, parent,
             expected, observed);
    }
  Check(result.Load(steps) == steps, "timeline graph lost or duplicated operations");
  Pass("pm4_timeline_fuzz", steps);
}
