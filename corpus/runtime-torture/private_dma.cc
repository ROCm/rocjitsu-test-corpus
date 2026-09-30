// Purpose: Test CP DMA copies through GTT, private VRAM and a second VRAM allocation.
// Exercise byte-sized, unaligned and page-crossing transfers, then copy back to GTT.
// Check the entire destination and guards for incorrect lengths or data corruption.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds.
//     Default 32; range 1..100000.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/blob/26513be3e0f711ed835ec50d5cdcb723ef224105/tests/amdgpu/amd_cp_dma_misc.c
#include <cstring>

#include "support/pm4.h"
using namespace torture;

int main(int argc, char** argv) {
  Start(argc, argv, "private_dma");
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  Device device(TEST_GFX);
  constexpr size_t kBytes = 131072;
  Buffer source(device, kBytes), target(device, kBytes), completion(device, 4096);
  Buffer local_a(device, kBytes, false, true), local_b(device, kBytes, false, true);
  Queue queue(device);
  const uint32_t lengths[] = {1, 3, 4, 63, 64, 65, 4095, 4096, 4097, 65535, 65536};
  for (uint32_t round = 1; round <= rounds; ++round) {
    auto* src = static_cast<unsigned char*>(source.data);
    auto* dst = static_cast<unsigned char*>(target.data);
    for (size_t i = 0; i < kBytes; ++i) src[i] = (i * 37 + (i >> 8) + round * 13) & 255;
    std::memset(dst, 0xa5, kBytes);
    const uint32_t bytes = lengths[(round - 1) % (sizeof(lengths) / sizeof(lengths[0]))];
    const size_t source_offset = 4093 + round % 4;
    const size_t target_offset = 8191 + round % 4;
    Pm4 commands;
    commands.Barrier();
    commands.DmaCopy(source.address(source_offset), local_a.address(7), bytes);
    commands.Barrier();
    commands.DmaCopy(local_a.address(7), local_b.address(4093), bytes);
    commands.Barrier();
    commands.DmaCopy(local_b.address(4093), target.address(target_offset), bytes);
    commands.Finish(completion.address(), round);
    queue.Submit(commands.words);
    completion.Wait(0, round, 10000, &queue);
    for (size_t i = 0; i < kBytes; ++i) {
      unsigned char expected = i >= target_offset && i < target_offset + bytes
                                   ? src[source_offset + i - target_offset]
                                   : 0xa5;
      Check(dst[i] == expected, "CP DMA payload or guard mismatch");
    }
  }
  queue.Drain();
  Pass("private_dma", rounds * 3);
}
