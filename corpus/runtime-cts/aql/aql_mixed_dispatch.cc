// Purpose: Alternate kernel descriptors, workgroup sizes and LDS requirements
// on the SAME AQL queue without host waits between packets. LDS and scalar
// kernels use different arguments and output extents. Change group counts and
// LDS sizes cross 32 KiB allocation boundaries and reach 64 KiB before
// returning to zero on the next scalar dispatch; verify every output,
// completion, marker and guard. Scratch remains disabled; this does not claim
// scratch-switch coverage.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
//   --aql-metadata off|on: gfx1250 only; default off.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_test_hcq.py
#include <cstring>

#include "support/aql.h"
namespace scalar {
#include "work_kernel.inc"
}
namespace lds {
#include "lds_kernel.inc"
}
using namespace cts;
struct LdsArguments {
  uint64_t output, completion;
  uint32_t seed, iterations, token, local_offset;
};
int main(int argc, char** argv) {
  Start(argc, argv, "aql_mixed_dispatch");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  constexpr uint32_t kSlots = 8, kStride = 65536, kGuard = 0xdeadbeef;
  Device device;
  Buffer small_code(device, sizeof(scalar::kKernelImage), true);
  Buffer lds_code(device, sizeof(lds::kKernelImage), true);
  Buffer args(device, kSlots * 512), result(device, kSlots * kStride);
  Buffer markers(device, kSlots * 256), signals(device, kSlots * 64);
  Check(scalar::kKernargBytes <= 512 && lds::kKernargBytes <= 512,
        "kernel args too large");
  std::memcpy(small_code.data, scalar::kKernelImage,
              sizeof(scalar::kKernelImage));
  std::memcpy(lds_code.data, lds::kKernelImage, sizeof(lds::kKernelImage));
  Queue queue(device, 4096, 7, true);
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t slot = 0; slot < kSlots; ++slot) {
      const bool large = (round + slot) & 1;
      const uint32_t groups =
          large ? 1 + (round + slot) % 3 : 1 + (round + slot) % 31;
      constexpr uint32_t offsets[] = {0, 256, 32768};
      const uint32_t offset = offsets[(round + slot) % 3];
      ResetSignal(signals, slot * 64);
      for (uint32_t word = 0; word < kStride / 4; ++word)
        result.Store(slot * kStride / 4 + word, kGuard);
      for (uint32_t word = 0; word < 64; ++word)
        markers.Store(slot * 64 + word, 0);
      LdsArguments arguments{result.address(slot * kStride),
                             markers.address(slot * 256),
                             round * 17 + slot,
                             1 + slot % 3,
                             round,
                             offset};
      std::memcpy(static_cast<char*>(args.data) + slot * 512, &arguments,
                  sizeof(arguments));
      Dispatch packet =
          OneGroup(large ? lds_code.address(lds::kDescriptorOffset)
                         : small_code.address(scalar::kDescriptorOffset),
                   args.address(slot * 512), signals.address(slot * 64), true);
      packet.workgroup_x = large ? 256 : 1;
      packet.grid_x = groups * packet.workgroup_x;
      packet.group_bytes = large ? 32768 + offset : 0;
      queue.SubmitAql(&packet);
    }
    for (uint32_t slot = 0; slot < kSlots; ++slot) {
      WaitSignal(signals, slot * 64, queue);
      const bool large = (round + slot) & 1;
      const uint32_t groups =
          large ? 1 + (round + slot) % 3 : 1 + (round + slot) % 31;
      const uint32_t steps = 1 + slot % 3, seed = round * 17 + slot;
      const uint32_t words = large ? groups * 4096 : groups;
      for (uint32_t word = 0; word < kStride / 4; ++word) {
        uint32_t expected = kGuard;
        if (word < words) {
          const uint32_t original =
              large ? (word / 4096) * 4096 + ((word + 17 * steps) & 4095)
                    : word;
          expected = Advance(seed ^ original, steps);
        }
        Check(result.Load(slot * kStride / 4 + word) == expected,
              "mixed dispatch result/guard mismatch");
      }
      for (uint32_t group = 0; group < 64; ++group)
        Check(markers.Load(slot * 64 + group) == (group < groups ? round : 0),
              "mixed dispatch marker mismatch");
    }
    queue.Drain();
  }
  Pass("aql_mixed_dispatch", uint64_t(rounds) * kSlots);
}
