// Purpose: Change a live AQL queue between disjoint single-WGP masks.
// Retire each dispatch before updating the mask. Every workgroup reports its
// hardware WGP identity; all reports for one mask must match, different masks
// must select distinct identities, and later visits must reproduce them.
// Masks use paired CU bits on the supported single-XCC topology.
// WGP identity provides the placement oracle without relying on timing.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 16; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues N: disjoint WGP masks on ONE queue; default 4; range 2..64,
//     additionally limited by the device WGP count.
//   --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDQMTest.cpp
#include <algorithm>
#include <cstring>

#include "placement_kernel.inc"
#include "support/aql.h"
using namespace torture;
int main(int argc, char** argv) {
  Start(argc, argv, "aql_cu_mask_switch");
  const uint32_t rounds = Option(argc, argv, "--iterations", 16, 100000);
  const uint32_t count = Option(argc, argv, "--queues", 4, 64);
  Device device(1201);
  const uint32_t cus = device.Property("simd_count") / device.Property("simd_per_cu");
  Check(count >= 2 && count <= cus / 2, "requires 2..available WGP masks");
  Buffer code(device, sizeof(kKernelImage), true), args(device, 4096);
  Buffer output(device, 4096), signals(device, 4096);
  Check(kKernargBytes <= 512, "kernel arguments too large");
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  Queue queue(device, 4096, 7, true);
  std::vector<uint32_t> identities(count, 0xffffffffu), mask((cus + 31) / 32);
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t step = 0; step < count; ++step) {
      const uint32_t selected = round & 1 ? step : count - 1 - step;
      std::fill(mask.begin(), mask.end(), 0);
      mask[(selected * 2) / 32] = 3u << ((selected * 2) % 32);
      queue.SetCuMask(mask);
      ResetSignal(signals, 0);
      for (uint32_t group = 0; group < 64; ++group) output.Store(group, 0xffffffffu);
      Arguments a{output.address(), output.address(512), 0, 0, round};
      std::memcpy(args.data, &a, sizeof(a));
      Dispatch packet =
          OneGroup(code.address(kDescriptorOffset), args.address(), signals.address(), true);
      packet.grid_x = 64;
      queue.SubmitAql(&packet);
      WaitSignal(signals, 0, queue);
      const uint32_t identity = output.Load(0);
      Check(identity != 0xffffffffu, "placement shader did not write");
      for (uint32_t group = 0; group < 64; ++group) {
        Check(output.Load(group) == identity, "single-WGP mask allowed another WGP");
        Check(output.Load(128 + group) == round, "placement marker missing");
      }
      if (round == 1) {
        for (uint32_t other = 0; other < selected; ++other)
          Check(identities[other] != identity, "disjoint CU masks selected the same WGP");
        identities[selected] = identity;
      } else
        Check(identities[selected] == identity, "CU mask update selected stale WGP");
      Check(output.Load(64) == 0 && output.Load(192) == 0, "placement guard corrupted");
      queue.Drain();
    }
  }
  Pass("aql_cu_mask_switch", uint64_t(rounds) * count);
}
