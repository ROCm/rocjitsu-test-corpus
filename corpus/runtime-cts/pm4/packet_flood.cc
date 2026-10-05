// Purpose: Stress packet consumption and ring reuse through PM4.
// PM4 varies write-batch lengths across a small ring and checks all payloads.
//
// Parameters (decimal integers; ranges inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --mode pm4: default pm4; use the AQL suite for AQL coverage.
//   --iterations N: batches/rounds; default 256; range 1..100000.
//   --queues and --seed: accepted by the common parser but unused.
//   --timeout N: watchdog seconds; default 45; range 1..3600.
// Progress waits retain a separate 10-second deadline.
//
// Inspiration: independent direct-KFD adaptations of these public patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/command_buffer/stress_test.cc
// https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/blob/26513be3e0f711ed835ec50d5cdcb723ef224105/tests/amdgpu/amd_cs_nop.c
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_test_hcq.py
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/queue/queue_dispatch_concurrency_test.cc
#include <cstdio>
#include <cstring>
#include <memory>
#include <thread>

#include "support/aql.h"
#include "pm4.h"
#include "work_kernel.inc"

using namespace cts;

static int RunPm4(int argc, char** argv) {
  Start(argc, argv, "packet_flood", true);
  const uint32_t iterations = Option(argc, argv, "--iterations", 256, 100000);
  Device device;
  Buffer result(device, 4096);
  Queue queue(device);
  constexpr uint32_t kWords = 128;
  for (uint32_t round = 1; round <= iterations; ++round) {
    Pm4 commands;
    // Vary stream length so packet starts migrate across the physical ring end.
    const uint32_t count = kWords - round % 7;
    for (uint32_t i = 0; i < count; ++i) commands.Write(result.address(i * 4), round * kWords + i);
    commands.Finish(result.address(2048), round);
    queue.Submit(commands.words);
    result.Wait(512, round);
    for (uint32_t i = 0; i < count; ++i)
      Check(result.Load(i) == round * kWords + i, "packet lost, reordered, or corrupted");
    Check(result.Load(kWords) == 0 && result.Load(511) == 0, "packet flood guard overwritten");
  }
  queue.Drain();
  std::printf("submitted_dwords=%llu ring_wraps=%llu\n", (unsigned long long)queue.producer(),
              (unsigned long long)(queue.producer() / 1024));
  Pass("packet_flood", iterations);
  return 0;
}

using namespace cts;



int main(int argc, char** argv) {
  Check(!AqlMode(argc, argv), "use the AQL suite for this scenario in AQL mode");
  return RunPm4(argc, argv);
}
