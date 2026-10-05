// Purpose: Exercise queue creation, first submission, destruction and reuse
// while a persistent queue survives. PM4 checks writes on transient queues and
// the survivor, destroying transient queues in reverse order. Check guards
// and reuse storage only after completion and retirement.
// Record observed queue-ID/doorbell reuse without requiring a specific
// allocator choice. Change the first submission extent each generation. The
// public simulator regression is inspiration, not a claimed gfx12 defect.
//
// Parameters (decimal integers; ranges inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --mode pm4: default pm4; use the AQL suite for AQL coverage.
//   --iterations N: rounds; default 32; range 1..100000.
//   --queues N: transient queues plus one survivor; default 8;
//     range 1..128.
//   --timeout N: watchdog seconds; default 45; range 1..3600.
//   --seed: accepted but unused. Progress waits have a 10-second deadline.
//
// Inspiration: independent direct-KFD adaptations of these public patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDQMTest.cpp
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/libamdf/cts/gpu/user_queue_memory.cc
// https://github.com/ROCm/rocm-systems/issues/8818
#include <cstdio>
#include <cstring>
#include <memory>
#include <set>

#include "pm4.h"
#include "support/aql.h"
#include "work_kernel.inc"

using namespace cts;

static int RunPm4(int argc, char** argv) {
  Start(argc, argv, "queue_churn", true);
  const uint32_t count = Option(argc, argv, "--queues", 8, 128);
  const uint32_t iterations = Option(argc, argv, "--iterations", 32, 100000);
  Device device;
  Buffer result(device, (count + 1) * 4096);
  Queue survivor(device);
  std::set<uint32_t> seen_ids;
  std::set<uint64_t> seen_doorbells;
  uint32_t reused_ids = 0, reused_doorbells = 0;
  auto record = [&](Queue& queue, uint32_t generation) {
    const bool id_reused = !seen_ids.insert(queue.id()).second;
    const bool doorbell_reused =
        !seen_doorbells.insert(queue.doorbell_offset()).second;
    if ((id_reused || doorbell_reused) && !(reused_ids || reused_doorbells))
      std::printf(
          "first_reuse generation=%u queue_id=%u doorbell_offset=%llu\n",
          generation, queue.id(), (unsigned long long)queue.doorbell_offset());
    reused_ids += id_reused;
    reused_doorbells += doorbell_reused;
  };
  for (uint32_t round = 1; round <= iterations; ++round) {
    std::vector<std::unique_ptr<Queue>> queues;
    Pm4 background;
    for (uint32_t i = 0; i < 128; ++i)
      background.Write(result.address(i * 4), round + i);
    background.Finish(result.address(2048), round);
    survivor.Submit(background.words);
    for (uint32_t q = 0; q < count; ++q) {
      queues.emplace_back(new Queue(device, 4096, (round + q) % 16));
      record(*queues.back(), round);
      const uint32_t words = 1 + (round + q) % 7;
      for (uint32_t i = 0; i < 16; ++i) result.Store((q + 1) * 1024 + i, 0);
      Pm4 commands;
      for (uint32_t i = 0; i < words; ++i)
        commands.Write(result.address((q + 1) * 4096 + i * 4),
                       round * 256 + q + i * 65536);
      commands.Finish(result.address((q + 1) * 4096 + 64), round);
      queues.back()->Submit(commands.words);
    }
    // Reverse destruction encourages doorbell/queue-ID reuse on the next round.
    for (uint32_t q = count; q-- > 0;) {
      result.Wait((q + 1) * 1024 + 16, round);
      const uint32_t words = 1 + (round + q) % 7;
      for (uint32_t i = 0; i < 16; ++i)
        Check(result.Load((q + 1) * 1024 + i) ==
                  (i < words ? round * 256 + q + i * 65536 : 0),
              "replacement queue first-work payload or guard mismatch");
      queues[q].reset();
    }
    result.Wait(512, round);
    for (uint32_t i = 0; i < 128; ++i)
      Check(result.Load(i) == round + i, "survivor queue corrupted");
  }
  survivor.Drain();
  std::printf("reused_queue_ids=%u reused_doorbells=%u\n", reused_ids,
              reused_doorbells);
  Pass("queue_churn", uint64_t(count) * iterations);
  return 0;
}

using namespace cts;

int main(int argc, char** argv) {
  Check(!AqlMode(argc, argv),
        "use the AQL suite for this scenario in AQL mode");
  return RunPm4(argc, argv);
}
