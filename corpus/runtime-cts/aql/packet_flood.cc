// Purpose: Stress packet consumption and ring reuse through AQL.
// AQL varies finite shader work across several queues;
// check CPU-oracle results, shader markers, firmware completions and guards.
//
// Parameters (decimal integers; ranges inclusive):
//   Queue protocol: AQL only.
//   --iterations N: batches/rounds; default 32; range 1..100000.
//   --queues N: AQL queues; default 4; range 1..128.
//   --seed N: AQL shader seed; default 12345; range 1..4294967295.
//   --timeout N: watchdog seconds; default 45; range 1..3600.
//   --aql-metadata off|on: gfx1250 only; default off.
// Progress waits retain a separate 10-second deadline.
// Investigation: --queues 8 --iterations 1 has shown intermittent
// gfx1201 timeouts but passes on gfx1250 (KFD 1.23, fw 2380). Higher queue
// counts are not qualified oversubscription coverage.
//
// Inspiration: independent direct-KFD adaptations of these public patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/command_buffer/stress_test.cc
// https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/blob/26513be3e0f711ed835ec50d5cdcb723ef224105/tests/amdgpu/amd_cs_nop.c
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_test_hcq.py
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/queue/queue_dispatch_concurrency_test.cc
#include <cstdio>
#include <cstring>
#include <memory>
#include <thread>

#include "support/aql.h"
#include "work_kernel.inc"

using namespace cts;

using namespace cts;

int main(int argc, char** argv) {
  Start(argc, argv, "packet_flood");
  const uint32_t count = Option(argc, argv, "--queues", 4, 128);
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  const uint32_t seed = Option(argc, argv, "--seed", 12345, 0xffffffffu);
  Device device;
  Buffer code(device, sizeof(kKernelImage), true);
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  constexpr uint32_t kGroups = 64;
  constexpr uint32_t kBatch = 8;
  constexpr uint32_t kSlotBytes = 1024;
  constexpr uint32_t kArgumentBytes = 512;
  Check(kKernargBytes <= kArgumentBytes, "kernel argument image too large");
  Buffer result(device, count * kBatch * kSlotBytes);
  Buffer args(device, count * kBatch * kArgumentBytes);
  Buffer signals(device, count * kBatch * 64);
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q)
    queues.emplace_back(new Queue(device, 4096, 7, true));
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t q = 0; q < count; ++q) {
      for (uint32_t batch = 0; batch < kBatch; ++batch) {
        const uint32_t slot = q * kBatch + batch;
        signals.Store(slot * 16, 1);      // AMD_SIGNAL_KIND_USER.
        signals.Store(slot * 16 + 2, 1);  // 64-bit value; high half stays zero.
        Arguments arguments{result.address(slot * kSlotBytes),
                            result.address(slot * kSlotBytes + 512),
                            seed ^ (round * 65536 + slot),
                            1024u + (q % 4) * 4096u, round};
        std::memcpy(static_cast<char*>(args.data) + slot * kArgumentBytes,
                    &arguments, sizeof(arguments));
        Dispatch packet{};
        // AQL dispatch, system acquire/release scopes, one-dimensional grid.
        packet.header_setup = 2u | (2u << 9) | (2u << 11) | (1u << 16);
        packet.workgroup_x = packet.workgroup_y = packet.workgroup_z = 1;
        packet.grid_x = kGroups;
        packet.grid_y = packet.grid_z = 1;
        packet.kernel = code.address(kDescriptorOffset);
        packet.arguments = args.address(slot * kArgumentBytes);
        packet.completion_signal = signals.address(slot * 64);
        queues[q]->SubmitAql(&packet);
      }
    }
    for (uint32_t q = 0; q < count; ++q) {
      for (uint32_t batch = 0; batch < kBatch; ++batch) {
        const uint32_t slot = q * kBatch + batch;
        const uint64_t deadline = NowNs() + 10000000000ull;
        while (signals.Load(slot * 16 + 2)) {
          if (NowNs() >= deadline) {
            for (uint32_t other = 0; other < count; ++other) {
              queues[other]->Dump();
              std::fprintf(stderr, "first_signal=%u first_shader_marker=%u\n",
                           signals.Load(other * kBatch * 16 + 2),
                           result.Load(other * kBatch * kSlotBytes / 4 + 128));
            }
            Fail("dispatch completion timeout round=%u queue=%u batch=%u",
                 round, q, batch);
          }
          std::this_thread::yield();
        }
        Check(signals.Load(slot * 16 + 3) == 0, "completion signal underflow");
        for (uint32_t group = 0; group < kGroups; ++group) {
          result.Wait(slot * kSlotBytes / 4 + 128 + group, round, 10000,
                      queues[q].get());
          uint32_t expected = seed ^ (round * 65536 + slot) ^ group;
          for (uint32_t i = 0; i < 1024u + (q % 4) * 4096u; ++i)
            expected = expected * 1664525u + 1013904223u;
          Check(result.Load(slot * kSlotBytes / 4 + group) == expected,
                "dispatch result mismatch");
        }
        Check(result.Load(slot * kSlotBytes / 4 + 64) == 0,
              "dispatch guard corrupted");
      }
      // Do not recycle kernargs until firmware has consumed those dispatches.
      queues[q]->Drain();
    }
  }
  Pass("packet_flood", uint64_t(count) * rounds * kBatch * kGroups);
  return 0;
}
