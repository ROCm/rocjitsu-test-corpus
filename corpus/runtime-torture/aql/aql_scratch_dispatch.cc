// Purpose: Exercise wave32 private scratch with fixed queue backing.
// Force a volatile private array into scratch, validate a per-thread checksum,
// and switch between two backing allocations only after retirement. Check
// that the selected backing was used, the inactive backing stayed untouched,
// and neither guard page was written. No dynamic allocator, reclaim callback
// or scratch-fault recovery is installed.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 32; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDMemoryTest.cpp
#include <cstring>

#include "scratch_kernel.inc"
#include "support/aql.h"
using namespace torture;
int main(int argc, char** argv) {
  Start(argc, argv, "aql_scratch_dispatch");
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  constexpr uint32_t kThreads = 1024, kSentinel = 0xa5a5a5a5;
  Device device;
  Check(kPrivateBytes > 0 && kPrivateBytes <= 4096,
        "kernel did not produce bounded private scratch");
  Check(kKernargBytes <= 512, "kernel arguments too large");
  const uint32_t lane_bytes = (kPrivateBytes + 15) & ~15u;
  const uint32_t wave_bytes = (lane_bytes * 32 + 255) & ~255u;
  const uint32_t engines =
      device.Property("array_count") / device.Property("simd_arrays_per_engine");
  const uint32_t scratch_bytes = wave_bytes * engines * 16;
  Buffer first(device, scratch_bytes + 4096), second(device, scratch_bytes + 4096);
  Buffer* backing[] = {&first, &second};
  Buffer code(device, sizeof(kKernelImage), true), args(device, 4096);
  Buffer result(device, kThreads * 8 + 4096), signals(device, 4096);
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  Queue queue(device, 4096, 7, true);
  for (uint32_t round = 1; round <= rounds; ++round) {
    const uint32_t selected = round & 1, steps = 3 + round % 5;
    for (auto* buffer : backing) std::memset(buffer->data, 0xa5, buffer->size);
    queue.SetScratch(*backing[selected], lane_bytes);
    ResetSignal(signals, 0);
    Arguments a{result.address(), result.address(kThreads * 4), round * 17, steps, round};
    std::memcpy(args.data, &a, sizeof(a));
    Dispatch packet =
        OneGroup(code.address(kDescriptorOffset), args.address(), signals.address(), true);
    packet.workgroup_x = 64;
    packet.grid_x = kThreads;
    packet.private_bytes = kPrivateBytes;
    queue.SubmitAql(&packet);
    WaitSignal(signals, 0, queue);
    for (uint32_t thread = 0; thread < kThreads; ++thread) {
      uint32_t state[64];
      for (uint32_t j = 0; j < 64; ++j) state[j] = (round * 17) ^ thread ^ j;
      for (uint32_t step = 0; step < steps; ++step) {
        const uint32_t index = ((round * 17) + thread + step * 17) & 63;
        state[index] = Advance(state[index], 1);
      }
      uint32_t checksum = 0;
      for (uint32_t j = 0; j < 64; ++j) checksum += state[j] * (j + 1);
      Check(result.Load(thread) == checksum, "private scratch checksum mismatch");
      Check(result.Load(kThreads + thread) == round, "private scratch marker missing");
    }
    queue.Drain();
    bool touched = false;
    for (uint32_t word = 0; word < scratch_bytes / 4; ++word) {
      touched |= backing[selected]->Load(word) != kSentinel;
      Check(backing[selected ^ 1]->Load(word) == kSentinel, "dispatch used stale scratch backing");
    }
    Check(touched, "dispatch did not use configured scratch backing");
    for (auto* buffer : backing)
      for (size_t word = scratch_bytes / 4; word < buffer->size / 4; ++word)
        Check(buffer->Load(word) == kSentinel, "scratch guard page corrupted");
    for (uint32_t word = kThreads * 2; word < result.size / 4; ++word)
      Check(result.Load(word) == 0, "scratch output guard corrupted");
  }
  Pass("aql_scratch_dispatch", uint64_t(rounds) * kThreads);
}
