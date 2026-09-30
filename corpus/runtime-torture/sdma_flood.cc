// Purpose: Stress SDMA copy traffic across multiple queues and repeated command-ring wraps.
// Exercise short, unaligned and page-crossing copies; check every destination byte
// and untouched guards for missing transfers, corruption or out-of-range writes.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds.
//     Default 128; range 1..100000.
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
#include <cstring>
#include <memory>

#include "support/sdma.h"
using namespace torture;

int main(int argc, char** argv) {
  Start(argc, argv, "sdma_flood");
  const uint32_t rounds = Option(argc, argv, "--iterations", 128, 100000);
  const uint32_t count = Option(argc, argv, "--queues", 2, 4);
  Device device(TEST_GFX);
  constexpr size_t kStride = 131072;
  Buffer source(device, count * kStride), target(device, count * kStride), done(device, 4096);
  std::vector<std::unique_ptr<SdmaQueue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new SdmaQueue(device));
  const uint32_t sizes[] = {1, 3, 64, 65, 4095, 4096, 4097, 65535};
  for (uint32_t round = 1; round <= rounds; ++round) {
    auto* src = static_cast<unsigned char*>(source.data);
    auto* dst = static_cast<unsigned char*>(target.data);
    for (size_t i = 0; i < source.size; ++i) src[i] = (i * 17 + (i >> 8) + round) & 255;
    std::memset(dst, 0xa5, target.size);
    for (uint32_t q = 0; q < count; ++q) {
      const uint32_t bytes = sizes[(round + q) % 8];
      Sdma commands(device.gfx);
      commands.Acquire();
      commands.Copy(source.address(q * kStride + 4093), target.address(q * kStride + 7), bytes);
      commands.Finish(done.address(q * 64), round);
      queues[q]->Submit(commands.words);
    }
    for (uint32_t q = 0; q < count; ++q) {
      done.Wait(q * 16, round);
      const size_t bytes = sizes[(round + q) % 8];
      for (size_t i = 0; i < kStride; ++i) {
        unsigned char expected = i >= 7 && i < 7 + bytes ? src[q * kStride + 4093 + i - 7] : 0xa5;
        Check(dst[q * kStride + i] == expected, "SDMA payload or guard mismatch");
      }
    }
  }
  for (auto& queue : queues) queue->Drain();
  Pass("sdma_flood", uint64_t(rounds) * count);
}
