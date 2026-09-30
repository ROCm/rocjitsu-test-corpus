// Purpose: Stress PM4 packet consumption and repeated wrapping of a small command ring.
// Vary batch lengths so packet positions move across the physical ring boundary.
// Check every written payload, completion and guards for lost or corrupted packets.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: packet batches.
//     Default 256; range 1..100000.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/command_buffer/stress_test.cc
// https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/blob/26513be3e0f711ed835ec50d5cdcb723ef224105/tests/amdgpu/amd_cs_nop.c
#include <cstdio>

#include "support/pm4.h"

using namespace torture;

int main(int argc, char** argv) {
  Start(argc, argv, "packet_flood");
  const uint32_t iterations = Option(argc, argv, "--iterations", 256, 100000);
  Device device(TEST_GFX);
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
}
