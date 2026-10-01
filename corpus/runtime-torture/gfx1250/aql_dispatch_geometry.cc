// Purpose: Alternate 1D/2D/3D AQL dispatch geometry on one queue.
// Use non-power-of-two workgroups, partial final groups and multi-wave groups.
// Kernels encode workgroup coordinates into every result; check all active
// elements and untouched tails. This reaches dimension/setup and partial-group
// paths absent from the fixed 1D scalar and 256-thread LDS workloads.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 32; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_test_hcq.py
#include <cstring>

#include "geometry_kernel.inc"
#include "support/aql.h"
using namespace torture;
struct Geometry {
  uint32_t dimensions, wx, wy, wz, gx, gy, gz;
};
struct GeometryArguments {
  uint64_t output, markers;
  uint32_t seed, wx, wy, wz, gx, gy, gz, token;
};
int main(int argc, char** argv) {
  Start(argc, argv, "aql_dispatch_geometry");
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  constexpr Geometry cases[] = {{1, 1, 1, 1, 63, 1, 1},    {1, 31, 1, 1, 97, 1, 1},
                                {1, 256, 1, 1, 513, 1, 1}, {2, 17, 3, 1, 35, 7, 1},
                                {3, 7, 3, 2, 35, 7, 5},    {3, 4, 4, 4, 9, 9, 9}};
  constexpr uint32_t kCount = 6, kWords = 2048, kStride = kWords * 8, kGuard = 0xdeadbeef;
  Device device(1250);
  Buffer code(device, sizeof(kKernelImage), true), args(device, kCount * 512);
  Buffer result(device, kCount * kStride), signals(device, kCount * 64);
  Check(kKernargBytes <= 512, "kernel arguments too large");
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  Queue queue(device, 4096, 7, true);
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t slot = 0; slot < kCount; ++slot) {
      const auto& g = cases[(round + slot) % kCount];
      ResetSignal(signals, slot * 64);
      for (uint32_t word = 0; word < kWords; ++word) {
        result.Store(slot * kStride / 4 + word, kGuard);
        result.Store(slot * kStride / 4 + kWords + word, 0);
      }
      GeometryArguments a{result.address(slot * kStride),
                          result.address(slot * kStride + kWords * 4),
                          round * 17 + slot,
                          g.wx,
                          g.wy,
                          g.wz,
                          g.gx,
                          g.gy,
                          g.gz,
                          round};
      std::memcpy(static_cast<char*>(args.data) + slot * 512, &a, sizeof(a));
      Dispatch packet = OneGroup(code.address(kDescriptorOffset), args.address(slot * 512),
                                 signals.address(slot * 64), true);
      packet.header_setup = (packet.header_setup & 0xffffu) | (g.dimensions << 16);
      packet.workgroup_x = g.wx;
      packet.workgroup_y = g.wy;
      packet.workgroup_z = g.wz;
      packet.grid_x = g.gx;
      packet.grid_y = g.gy;
      packet.grid_z = g.gz;
      queue.SubmitAql(&packet);
    }
    for (uint32_t slot = 0; slot < kCount; ++slot) {
      const auto& g = cases[(round + slot) % kCount];
      WaitSignal(signals, slot * 64, queue);
      for (uint32_t word = 0; word < kWords; ++word) {
        const bool active = word < g.gx * g.gy * g.gz;
        uint32_t expected = kGuard;
        if (active) {
          const uint32_t x = word % g.gx, y = (word / g.gx) % g.gy, z = word / (g.gx * g.gy);
          expected = Advance((round * 17 + slot) ^ word ^ ((x / g.wx) << 16) ^ ((y / g.wy) << 20) ^
                                 ((z / g.wz) << 24),
                             3);
        }
        Check(result.Load(slot * kStride / 4 + word) == expected,
              "dispatch geometry result/guard mismatch");
        Check(result.Load(slot * kStride / 4 + kWords + word) == (active ? round : 0),
              "dispatch geometry marker mismatch");
      }
    }
    queue.Drain();
  }
  Pass("aql_dispatch_geometry", uint64_t(rounds) * kCount);
}
