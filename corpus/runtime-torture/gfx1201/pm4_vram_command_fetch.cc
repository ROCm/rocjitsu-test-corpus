// Purpose: Fetch changing indirect command buffers from private VRAM.
// Upload through CP DMA, explicitly synchronize, execute and verify every word.
// Rewrite the same VRAM addresses only after retirement; alternate IB offsets.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/libamdf/cts/gpu/kernel_queue_test.cc
#include <cstring>

#include "support/pm4.h"
using namespace torture;
int main(int argc, char** argv) {
  Start(argc, argv, "pm4_vram_command_fetch");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device(1201);
  Buffer staging(device, 4096), local(device, 4096, true, true), result(device, 4096);
  Queue queue(device);
  for (uint32_t round = 1; round <= rounds; ++round) {
    Pm4 ib;
    for (uint32_t word = 0; word < 31; ++word)
      ib.Write(result.address(word * 4), round * 65536 + word);
    ib.Pad();
    std::memcpy(staging.data, ib.words.data(), ib.words.size() * 4);
    const uint32_t offset = (round & 1) * 2048;
    Pm4 commands;
    commands.DmaCopy(staging.address(), local.address(offset), ib.words.size() * 4);
    commands.Barrier();
    commands.Indirect(local.address(offset), ib.words.size());
    commands.Finish(result.address(256), round);
    queue.Submit(commands.words);
    result.Wait(64, round, 10000, &queue);
    for (uint32_t word = 0; word < 31; ++word)
      Check(result.Load(word) == round * 65536 + word, "VRAM IB data missing or stale");
    Check(result.Load(31) == 0, "IB output guard corrupted");
    queue.Drain();
  }
  Pass("pm4_vram_command_fetch", rounds);
}
