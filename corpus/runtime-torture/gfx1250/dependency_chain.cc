// Purpose: Submit a cross-queue dependency chain in reverse order and check
// that every stage observes the producer's current data. PM4 propagates a GTT
// payload with memory waits/copies. AQL (formerly shader_dependency_chain)
// transforms VRAM data in shaders, with SDMA upload/download and AQL barriers.
// AQL alternates agent/system scopes on interior links; transfer edges retain
// system scope. Verify every stage and guards, not just final completion.
// Reproducer: pm4_dependency_chain_no_offload_gfx1250 builds this same scenario
// with WAIT_REG_MEM optimize_ace_offload_mode clear. Only PM4 is accepted.
// Reproducer: --queues 8 --iterations 4. On fw 2380 it stalled on round 2 and
// subsequent queue progress/recovery failed. The cause and scheduling guarantees
// remain unresolved; a host reboot may be needed. Checks are identical to smoke.
//
// Parameters (decimal integers; ranges inclusive):
//   --mode pm4|aql: default pm4.
//   --iterations N: rounds; default PM4 32, AQL 64; range 1..100000.
//   --queues N: stages; PM4 default 16, range 1..128; AQL default 4, range 2..4.
//   --timeout N: watchdog seconds; default 45; range 1..3600.
//   --seed: accepted but unused. Progress waits have a 10-second deadline.
//
// Inspiration: independent direct-KFD adaptations of these public patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/queue/semaphore_submission_test.cc
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocprofiler-sdk/tests/bin/hsa-queue-dependency/multiqueue_app.cpp
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/clr/opencl/tests/ocltst/module/runtime/OCLMemDependency.cpp
#include <cstdio>
#include <cstring>
#include <memory>

#include "pipeline_kernel.inc"
#include "support/aql.h"
#include "support/pm4.h"
#include "support/sdma.h"

using namespace torture;

static int RunPm4(int argc, char** argv) {
  Start(argc, argv, "dependency_chain", true);
  const uint32_t count = Option(argc, argv, "--queues", 16, 128);
  const uint32_t iterations = Option(argc, argv, "--iterations", 32, 100000);
#ifdef REPRO_PM4_NO_OFFLOAD
  std::puts("Reproducer: dependency waits with optimize_ace_offload_mode=0");
  std::fflush(stdout);
#endif
  Device device(1250);
  Buffer result(device, count * 4096);
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new Queue(device));
  for (uint32_t round = 1; round <= iterations; ++round) {
    // Submit consumers first: progress requires scheduling the last submitted
    // producer even when more waiting queues exist than hardware queue slots.
    for (uint32_t q = count; q-- > 0;) {
      Pm4 commands;
      if (q) {
#ifdef REPRO_PM4_NO_OFFLOAD
        // Identical comparison and poll interval; only ordinal7 bit 31 differs.
        commands.WaitCompare(result.address((q - 1) * 4096 + 64), round, 3, 0xffffffffu);
#else
        commands.Wait(result.address((q - 1) * 4096 + 64), round);
#endif
        commands.Barrier();
        commands.Copy(result.address((q - 1) * 4096), result.address(q * 4096));
      } else {
        commands.Write(result.address(), 0x12340000u + round);
      }
      commands.Finish(result.address(q * 4096 + 64), round);
      queues[q]->Submit(commands.words);
    }
    for (uint32_t q = 0; q < count; ++q) {
      result.Wait(q * 1024 + 16, round, 10000, queues[q].get());
      Check(result.Load(q * 1024) == 0x12340000u + round,
            "dependency completed with stale payload");
    }
  }
  for (auto& queue : queues) queue->Drain();
  Pass("dependency_chain", uint64_t(count) * iterations);
  return 0;
}

using namespace torture;
struct PipelineArguments {
  uint64_t input, output;
  uint32_t salt, count, token;
};
struct BarrierPacket {
  uint64_t header, dependencies[5], reserved, completion;
};
static_assert(sizeof(BarrierPacket) == 64);
static int RunAql(int argc, char** argv) {
  Start(argc, argv, "dependency_chain", true);
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  const uint32_t count = Option(argc, argv, "--queues", 4, 4);
  Check(count >= 2, "shader chain requires at least two queues");
  constexpr uint32_t kWords = 256, kGuard = 0xdeadbeef;
  const uint32_t bytes = (count + 1) * 4096;
  Device device(1250);
  Buffer code(device, sizeof(kKernelImage), true), args(device, count * 512);
  Buffer source(device, bytes), snapshot(device, bytes), local(device, bytes, false, true);
  Buffer signals(device, 4096);
  Check(kKernargBytes <= 512, "kernel arguments too large");
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new Queue(device, 4096, 7, true));
  SdmaQueue upload(device), download(device);
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t word = 0; word < bytes / 4; ++word)
      source.Store(word, word < kWords ? round * 65536 + word : kGuard);
    for (uint32_t s = 0; s <= count; ++s) ResetSignal(signals, s * 64);
    Sdma receive(device.gfx);
    receive.Wait(signals.address(count * 64 + 8), 0);
    receive.Acquire();
    receive.Copy(local.address(), snapshot.address(), bytes);
    receive.Finish(signals.address(1024), round);
    download.Submit(receive.words);
    for (uint32_t remaining = count; remaining; --remaining) {
      const uint32_t q = remaining - 1;
      const uint32_t acquire = q && (round & 1) ? 1 : 2;
      const uint32_t release = q + 1 < count && (round & 1) ? 1 : 2;
      BarrierPacket wait{};
      wait.header = 3u | (1u << 8) | (acquire << 9) | (release << 11);
      wait.dependencies[0] = signals.address(q * 64);
      queues[q]->SubmitAql(&wait);
      PipelineArguments a{local.address(q * 4096), local.address((q + 1) * 4096), round ^ q, kWords,
                          round};
      std::memcpy(static_cast<char*>(args.data) + q * 512, &a, sizeof(a));
      Dispatch packet = OneGroup(code.address(kDescriptorOffset), args.address(q * 512),
                                 signals.address((q + 1) * 64), true);
      packet.header_setup = 2u | (1u << 8) | (acquire << 9) | (release << 11) | (1u << 16);
      packet.workgroup_x = 64;
      packet.grid_x = kWords;
      queues[q]->SubmitAql(&packet);
    }
    Sdma send(device.gfx);
    send.Acquire();
    send.Copy(source.address(), local.address(), bytes);
    send.Finish(signals.address(8), 0);
    upload.Submit(send.words);
    signals.Wait(256, round);
    for (uint32_t word = 0; word < 1024; ++word) {
      uint32_t expected = word < kWords ? round * 65536 + word : kGuard;
      for (uint32_t stage = 0; stage <= count; ++stage) {
        Check(snapshot.Load(stage * 1024 + word) == expected, "shader chain data/guard mismatch");
        if (word < kWords && stage < count) expected = Advance(expected ^ (round ^ stage), 3);
      }
    }
    for (uint32_t q = 0; q < count; ++q) {
      WaitSignal(signals, (q + 1) * 64, *queues[q]);
      queues[q]->Drain();
    }
    upload.Drain();
    download.Drain();
  }
  Pass("dependency_chain", uint64_t(rounds) * count * kWords);
  return 0;
}

int main(int argc, char** argv) {
#ifdef REPRO_PM4_NO_OFFLOAD
  Check(!AqlMode(argc, argv), "non-offloaded wait investigation requires --mode pm4");
#endif
  return AqlMode(argc, argv) ? RunAql(argc, argv) : RunPm4(argc, argv);
}
