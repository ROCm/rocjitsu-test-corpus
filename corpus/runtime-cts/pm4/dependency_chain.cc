// Purpose: Submit a cross-queue dependency chain in reverse order and check
// that every stage observes the producer's current data. Propagate a GTT
// payload with PM4 memory waits/copies. Verify every stage and guards,
// not just final completion.
// Reproducer: pm4_dependency_chain_no_offload_gfx1250 builds this same scenario
// with WAIT_REG_MEM optimize_ace_offload_mode clear. Only PM4 is accepted.
// Reproducer: --iterations 4 at the native queue budget. fw 2390 also
// stalled; an earlier 8-queue fw 2380 run failed subsequent GPU recovery.
// The cause and scheduling
// guarantees remain unresolved; a host reboot may be needed. Checks are
// identical to smoke.
//
// Queue count defaults to the native CP capacity minus companion queues.
// Explicit --queues above that budget fails before queue creation.
// Parameters (decimal integers; ranges inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --mode pm4: default pm4; use the AQL suite for AQL coverage.
//   --iterations N: rounds; default 32; range 1..100000.
//   --queues N: stages.
//   --timeout N: watchdog seconds; default 45; range 1..3600.
//   --seed: accepted but unused. Progress waits have a 10-second deadline.
//
// Inspiration: independent direct-KFD adaptations of these public patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/queue/semaphore_submission_test.cc
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocprofiler-sdk/tests/bin/hsa-queue-dependency/multiqueue_app.cpp
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/clr/opencl/tests/ocltst/module/runtime/OCLMemDependency.cpp
#include <cstdio>
#include <cstring>
#include <memory>

#include "pipeline_kernel.inc"
#include "pm4.h"
#include "support/aql.h"
#include "support/sdma.h"

using namespace cts;

static int RunPm4(int argc, char** argv) {
  Start(argc, argv, "dependency_chain", true);
  const uint32_t count = QueueCount(argc, argv, 0);
  const uint32_t iterations = Option(argc, argv, "--iterations", 32, 100000);
#ifdef REPRO_PM4_NO_OFFLOAD
  std::puts("Reproducer: dependency waits with optimize_ace_offload_mode=0");
  std::fflush(stdout);
#endif
  Device device;
  Buffer result(device, count * 4096);
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new Queue(device));
  for (uint32_t round = 1; round <= iterations; ++round) {
    // Submit consumers first: progress requires scheduling the last submitted
    // producer while the other resident queues are waiting.
    for (uint32_t q = count; q-- > 0;) {
      Pm4 commands;
      if (q) {
#ifdef REPRO_PM4_NO_OFFLOAD
        // Identical comparison and poll interval; only ordinal7 bit 31 differs.
        commands.WaitCompare(result.address((q - 1) * 4096 + 64), round, 3,
                             0xffffffffu);
#else
        commands.Wait(result.address((q - 1) * 4096 + 64), round);
#endif
        commands.Barrier();
        commands.Copy(result.address((q - 1) * 4096), result.address(q * 4096));
      } else {
        commands.Write(result.address(), 0x12340000u + round);
      }
      commands.Finish(result.address(q * 4096 + 64), round);
      queues[q]->Submit(commands.words);
    }
    for (uint32_t q = 0; q < count; ++q) {
      result.Wait(q * 1024 + 16, round, 10000, queues[q].get());
      Check(result.Load(q * 1024) == 0x12340000u + round,
            "dependency completed with stale payload");
    }
  }
  for (auto& queue : queues) queue->Drain();
  Pass("dependency_chain", uint64_t(count) * iterations);
  return 0;
}

using namespace cts;
struct PipelineArguments {
  uint64_t input, output;
  uint32_t salt, count, token;
};
struct BarrierPacket {
  uint64_t header, dependencies[5], reserved, completion;
};
static_assert(sizeof(BarrierPacket) == 64);

int main(int argc, char** argv) {
#ifdef REPRO_PM4_NO_OFFLOAD
  Check(!AqlMode(argc, argv),
        "non-offloaded wait investigation requires --mode pm4");
#endif
  Check(!AqlMode(argc, argv),
        "use the AQL suite for this scenario in AQL mode");
  return RunPm4(argc, argv);
}
