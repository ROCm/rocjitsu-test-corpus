// Purpose: Stress SDMA copy traffic across multiple queues and repeated command-ring wraps.
// Exercise short, unaligned and page-crossing copies; check every destination byte
// and untouched guards for missing transfers, corruption or out-of-range writes.
// sdma_copy_boundaries selects 4 MiB, 4 MiB+1 and 4 MiB+17 transfers, split
// at the supported 22-bit count-minus-one limit. Its default is three rounds.
//
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on SDMA queues.
//   --iterations N: rounds.
//     Default 128 (3 for sdma_copy_boundaries); range 1..100000.
//   --queues N: SDMA queues.
//     Default 2; range 1..4.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/libamdf/cts/gpu/sdma_queue_test.cc
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDQMTest.cpp
#include <algorithm>
#include <cstring>
#include <memory>

#include "support/sdma.h"
using namespace cts;

int main(int argc, char** argv) {
#ifdef DMA_BOUNDARIES
  constexpr const char* name = "sdma_copy_boundaries";
  constexpr uint32_t default_rounds = 3;
#else
  constexpr const char* name = "sdma_flood";
  constexpr uint32_t default_rounds = 128;
#endif
  Start(argc, argv, name);
  const uint32_t rounds = Option(argc, argv, "--iterations", default_rounds, 100000);
  const uint32_t count = Option(argc, argv, "--queues", 2, 4);
  Device device;
  constexpr uint32_t kChunk = 1u << 22;
#ifdef DMA_BOUNDARIES
  constexpr size_t kStride = kChunk + 8192;
  const uint32_t sizes[] = {kChunk, kChunk + 1, kChunk + 17};
#else
  constexpr size_t kStride = 131072;
  const uint32_t sizes[] = {1, 3, 64, 65, 4095, 4096, 4097, 65535};
#endif
  Buffer source(device, count * kStride), target(device, count * kStride), done(device, 4096);
  std::vector<std::unique_ptr<SdmaQueue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new SdmaQueue(device));
  std::vector<unsigned char> pattern(count * kStride), expected(kStride);
  for (uint32_t round = 1; round <= rounds; ++round) {
    auto* src = static_cast<unsigned char*>(source.data);
    auto* dst = static_cast<unsigned char*>(target.data);
    for (size_t i = 0; i < pattern.size(); ++i) pattern[i] = (i * 17 + (i >> 8) + round) & 255;
    std::memcpy(src, pattern.data(), pattern.size());
    std::memset(dst, 0xa5, target.size);
    for (uint32_t q = 0; q < count; ++q) {
      const uint32_t bytes = sizes[(round - 1 + q) % std::size(sizes)];
      Sdma commands(device.gfx);
      commands.Acquire();
      for (uint32_t offset = 0; offset < bytes;) {
        const uint32_t chunk = std::min(kChunk, bytes - offset);
        commands.Copy(source.address(q * kStride + 4093 + offset),
                      target.address(q * kStride + 7 + offset), chunk);
        offset += chunk;
      }
      commands.Finish(done.address(q * 64), round);
      queues[q]->Submit(commands.words);
    }
    for (uint32_t q = 0; q < count; ++q) {
      done.Wait(q * 16, round);
      const size_t bytes = sizes[(round - 1 + q) % std::size(sizes)];
      std::fill(expected.begin(), expected.end(), 0xa5);
      std::copy_n(pattern.data() + q * kStride + 4093, bytes, expected.data() + 7);
      Check(std::memcmp(dst + q * kStride, expected.data(), kStride) == 0,
            "SDMA payload or guard mismatch");
    }
  }
  for (auto& queue : queues) queue->Drain();
  Pass(name, uint64_t(rounds) * count);
}
