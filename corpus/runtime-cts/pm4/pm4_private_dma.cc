// Purpose: Test CP DMA copies through GTT, private VRAM and a second VRAM allocation.
// Exercise byte-sized, unaligned and page-crossing transfers, then copy back to GTT.
// Check the entire destination and guards for incorrect lengths or data corruption.
// pm4_private_dma_boundaries selects 2^26-1, 2^26 and 2^26+16 bytes, splitting
// at the 26-bit packet limit. The manifest selects three rounds and a 150s watchdog.
//
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --iterations N: rounds.
//     Default 32 (3 for pm4_private_dma_boundaries); range 1..100000.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/blob/26513be3e0f711ed835ec50d5cdcb723ef224105/tests/amdgpu/amd_cp_dma_misc.c
#include <algorithm>
#include <cstring>

#include "pm4.h"
using namespace cts;

int main(int argc, char** argv) {
#ifdef DMA_BOUNDARIES
  constexpr const char* name = "pm4_private_dma_boundaries";
  constexpr uint32_t default_rounds = 3;
#else
  constexpr const char* name = "pm4_private_dma";
  constexpr uint32_t default_rounds = 32;
#endif
  Start(argc, argv, name);
  const uint32_t rounds = Option(argc, argv, "--iterations", default_rounds, 100000);
  Device device;
  constexpr uint32_t kChunk = (1u << 26) - 1;
#ifdef DMA_BOUNDARIES
  constexpr size_t kBytes = size_t(kChunk) + 16384;
  const uint32_t lengths[] = {kChunk, kChunk + 1, kChunk + 17};
#else
  constexpr size_t kBytes = 131072;
  const uint32_t lengths[] = {1, 3, 4, 63, 64, 65, 4095, 4096, 4097, 65535, 65536};
#endif
  Buffer source(device, kBytes), target(device, kBytes), completion(device, 4096);
  Buffer local_a(device, kBytes, false, true), local_b(device, kBytes, false, true);
  Queue queue(device);
  std::vector<unsigned char> pattern(kBytes), expected(kBytes);
  for (uint32_t round = 1; round <= rounds; ++round) {
    auto* src = static_cast<unsigned char*>(source.data);
    auto* dst = static_cast<unsigned char*>(target.data);
    for (size_t i = 0; i < kBytes; ++i) pattern[i] = (i * 37 + (i >> 8) + round * 13) & 255;
    std::memcpy(src, pattern.data(), kBytes);
    std::memset(dst, 0xa5, kBytes);
    const uint32_t bytes = lengths[(round - 1) % (sizeof(lengths) / sizeof(lengths[0]))];
    const size_t source_offset = 4093 + round % 4;
    const size_t target_offset = 8191 + round % 4;
    Pm4 commands;
    commands.Barrier();
    auto copy = [&](uint64_t from, uint64_t to) {
      for (uint32_t offset = 0; offset < bytes;) {
        const uint32_t chunk = std::min(kChunk, bytes - offset);
        commands.DmaCopy(from + offset, to + offset, chunk);
        offset += chunk;
      }
    };
    copy(source.address(source_offset), local_a.address(7));
    commands.Barrier();
    copy(local_a.address(7), local_b.address(4093));
    commands.Barrier();
    copy(local_b.address(4093), target.address(target_offset));
    commands.Finish(completion.address(), round);
    queue.Submit(commands.words);
    completion.Wait(0, round, 10000, &queue);
    std::fill(expected.begin(), expected.end(), 0xa5);
    std::copy_n(pattern.data() + source_offset, bytes, expected.data() + target_offset);
    Check(std::memcmp(dst, expected.data(), kBytes) == 0, "CP DMA payload or guard mismatch");
  }
  queue.Drain();
  Pass(name, rounds * 3);
}
