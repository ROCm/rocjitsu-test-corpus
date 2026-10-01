// Purpose: Submit deep AQL bursts with one shared counted completion
// signal across multiple queues. Publish each 128-dispatch burst with ONE
// doorbell; SDMA waits for the final decrement and snapshots all shader output.
// Verify every result and untouched guard after the snapshot. Detect lost
// decrements, premature zero, stale shader stores and ring-reuse errors.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 16; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues N: AQL producer queues; default 2; range 1..4.
//   --seed N: input seed; default 12345; range 1..4294967295.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/KhronosGroup/VK-GL-CTS/blob/3905c821f43ded89284713187ffb3c7a1072afdb/external/vulkancts/modules/vulkan/synchronization/vktSynchronizationSignalOrderTests.cpp
#include <cstring>
#include <memory>

#include "support/aql.h"
#include "support/sdma.h"
#include "work_kernel.inc"
using namespace torture;
int main(int argc, char** argv) {
  Start(argc, argv, "aql_counted_completion");
  const uint32_t rounds = Option(argc, argv, "--iterations", 16, 100000);
  const uint32_t count = Option(argc, argv, "--queues", 2, 4);
  const uint32_t seed = Option(argc, argv, "--seed", 12345, 0xffffffffu);
  constexpr uint32_t kBatch = 128;
  const uint32_t slots = count * kBatch;
  Device device(1250);
  Buffer code(device, sizeof(kKernelImage), true), args(device, slots * 512);
  Buffer output(device, slots * 64), snapshot(device, slots * 64), signals(device, 4096);
  Check(kKernargBytes <= 512, "kernel arguments too large");
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new Queue(device, 16384, 7, true));
  SdmaQueue consumer(device);
  for (uint32_t round = 1; round <= rounds; ++round) {
    signals.Store64(0, 1);
    signals.Store64(8, slots);
    Sdma copy(device.gfx);
    copy.Wait(signals.address(8), 0);
    copy.Acquire();
    copy.Copy(output.address(), snapshot.address(), slots * 64);
    copy.Finish(signals.address(64), round);
    consumer.Submit(copy.words);
    for (uint32_t q = 0; q < count; ++q) {
      const uint64_t first = queues[q]->ReserveAql(kBatch);
      for (uint32_t i = 0; i < kBatch; ++i) {
        const uint32_t slot = q * kBatch + i;
        output.Store(slot * 16, 0);
        output.Store(slot * 16 + 1, 0);
        Arguments arguments{output.address(slot * 64), output.address(slot * 64 + 4),
                            seed ^ (round * 65536 + slot), 3 + slot % 31, round};
        std::memcpy(static_cast<char*>(args.data) + slot * 512, &arguments, sizeof(arguments));
        Dispatch packet = OneGroup(code.address(kDescriptorOffset), args.address(slot * 512),
                                   signals.address(), false);
        queues[q]->PublishAql(first + i, &packet);
      }
      queues[q]->NotifyAql();
    }
    signals.Wait(16, round);
    Check(signals.Load64(8) == 0, "counted completion underflow");
    for (uint32_t slot = 0; slot < slots; ++slot) {
      Check(snapshot.Load(slot * 16) == Advance(seed ^ (round * 65536 + slot), 3 + slot % 31),
            "counted signal released consumer before all shader stores");
      Check(snapshot.Load(slot * 16 + 1) == round, "counted completion marker missing");
      for (uint32_t guard = 2; guard < 16; ++guard)
        Check(snapshot.Load(slot * 16 + guard) == 0, "counted dispatch guard corrupted");
    }
    for (auto& queue : queues) queue->Drain();
    consumer.Drain();
  }
  Pass("aql_counted_completion", uint64_t(rounds) * slots);
}
