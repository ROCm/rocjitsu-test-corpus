// Purpose: Stress packet consumption and ring reuse through PM4 or AQL.
// PM4 varies write-batch lengths across a small ring and checks all payloads.
// AQL (formerly dispatch_flood) varies finite shader work across several queues;
// check CPU-oracle results, shader markers, firmware completions and guards.
//
// Parameters (decimal integers; ranges inclusive):
//   --mode pm4|aql: default pm4.
//   --iterations N: batches/rounds; default PM4 256, AQL 32; range 1..100000.
//   --queues N: AQL queues; default 4; range 1..128. Unused for PM4.
//   --seed N: AQL shader seed; default 12345; range 1..4294967295. Unused for PM4.
//   --timeout N: watchdog seconds; default 45; range 1..3600.
// Progress waits retain a separate 10-second deadline.
// Investigation: --mode aql --queues 8 --iterations 1 has shown intermittent
// gfx1201 timeouts; higher queue counts are not qualified oversubscription coverage.
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
#include "support/pm4.h"
#include "work_kernel.inc"

using namespace torture;

static int RunPm4(int argc, char** argv) {
  Start(argc, argv, "packet_flood", true);
  const uint32_t iterations = Option(argc, argv, "--iterations", 256, 100000);
  Device device(1201);
  Buffer result(device, 4096);
  Queue queue(device);
  constexpr uint32_t kWords = 128;
  for (uint32_t round = 1; round <= iterations; ++round) {
    Pm4 commands;
    // Vary stream length so packet starts migrate across the physical ring end.
    const uint32_t count = kWords - round % 7;
    for (uint32_t i = 0; i < count; ++i) commands.Write(result.address(i * 4), round * kWords + i);
    commands.Finish(result.address(2048), round);
    queue.Submit(commands.words);
    result.Wait(512, round);
    for (uint32_t i = 0; i < count; ++i)
      Check(result.Load(i) == round * kWords + i, "packet lost, reordered, or corrupted");
    Check(result.Load(kWords) == 0 && result.Load(511) == 0, "packet flood guard overwritten");
  }
  queue.Drain();
  std::printf("submitted_dwords=%llu ring_wraps=%llu\n", (unsigned long long)queue.producer(),
              (unsigned long long)(queue.producer() / 1024));
  Pass("packet_flood", iterations);
  return 0;
}

using namespace torture;

static int RunAql(int argc, char** argv) {
  Start(argc, argv, "packet_flood", true);
  const uint32_t count = Option(argc, argv, "--queues", 4, 128);
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  const uint32_t seed = Option(argc, argv, "--seed", 12345, 0xffffffffu);
  Device device(1201);
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
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new Queue(device, 4096, 7, true));
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t q = 0; q < count; ++q) {
      for (uint32_t batch = 0; batch < kBatch; ++batch) {
        const uint32_t slot = q * kBatch + batch;
        signals.Store(slot * 16, 1);      // AMD_SIGNAL_KIND_USER.
        signals.Store(slot * 16 + 2, 1);  // 64-bit value; high half stays zero.
        Arguments arguments{result.address(slot * kSlotBytes),
                            result.address(slot * kSlotBytes + 512), seed ^ (round * 65536 + slot),
                            1024u + (q % 4) * 4096u, round};
        std::memcpy(static_cast<char*>(args.data) + slot * kArgumentBytes, &arguments,
                    sizeof(arguments));
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
            Fail("dispatch completion timeout round=%u queue=%u batch=%u", round, q, batch);
          }
          std::this_thread::yield();
        }
        Check(signals.Load(slot * 16 + 3) == 0, "completion signal underflow");
        for (uint32_t group = 0; group < kGroups; ++group) {
          result.Wait(slot * kSlotBytes / 4 + 128 + group, round, 10000, queues[q].get());
          uint32_t expected = seed ^ (round * 65536 + slot) ^ group;
          for (uint32_t i = 0; i < 1024u + (q % 4) * 4096u; ++i)
            expected = expected * 1664525u + 1013904223u;
          Check(result.Load(slot * kSlotBytes / 4 + group) == expected, "dispatch result mismatch");
        }
        Check(result.Load(slot * kSlotBytes / 4 + 64) == 0, "dispatch guard corrupted");
      }
      // Do not recycle kernargs until firmware has consumed those dispatches.
      queues[q]->Drain();
    }
  }
  Pass("packet_flood", uint64_t(count) * rounds * kBatch * kGroups);
  return 0;
}

int main(int argc, char** argv) {
  return AqlMode(argc, argv) ? RunAql(argc, argv) : RunPm4(argc, argv);
}
