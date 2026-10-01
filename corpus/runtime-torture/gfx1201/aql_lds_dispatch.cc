// Purpose: Stress multi-wave dispatches with 256 threads and 32 KiB of LDS per workgroup.
// Run repeated cross-wave shuffles and workgroup barriers across multiple AQL queues.
// Check every output against a CPU oracle, completion signals, markers and guards;
// this tests LDS use and barriers, not save/restore across preemption.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds.
//     Default 16; range 1..100000.
//   --queues N: AQL queues.
//     Default 4; range 1..128.
//   --seed N: seed for shader input values.
//     Default 4321; range 1..4294967295.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: local-memory reductions/barriers and concurrent queue dispatch.
// https://github.com/KhronosGroup/OpenCL-CTS/blob/9feccbb8fcb8eefeebf86a48036173a8155f9d21/test_conformance/basic/test_local.cpp
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/queue/queue_dispatch_concurrency_test.cc
#include <cstring>
#include <memory>

#include "lds_kernel.inc"
#include "support/aql.h"
using namespace torture;
// An LDS pointer kernarg is a 32-bit offset in the dispatch's group segment.
// https://llvm.org/docs/AMDGPUUsage.html#address-spaces
struct LdsArguments {
  uint64_t output, completion;
  uint32_t seed, iterations, token, local_offset;
};
static_assert(offsetof(LdsArguments, local_offset) == 28);
int main(int argc, char** argv) {
  Start(argc, argv, "aql_lds_dispatch");
  const uint32_t rounds = Option(argc, argv, "--iterations", 16, 100000);
  const uint32_t count = Option(argc, argv, "--queues", 4, 128);
  const uint32_t seed = Option(argc, argv, "--seed", 4321, 0xffffffffu);
  constexpr uint32_t kGroups = 8, kWords = kGroups * 4096, kStride = (kWords + 64) * 4;
  Device device(1201);
  Buffer code(device, sizeof(kKernelImage), true), args(device, count * 512);
  Buffer result(device, count * kStride), done(device, count * 64), signals(device, count * 64);
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  Check(kKernargBytes >= sizeof(LdsArguments) && kKernargBytes <= 512 && kGroupBytes == 0,
        "unexpected LDS kernel layout");
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new Queue(device, 4096, 7, true));
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t q = 0; q < count; ++q) {
      ResetSignal(signals, q * 64);
      LdsArguments a{result.address(q * kStride),
                     done.address(q * 64),
                     seed ^ (round * 256 + q),
                     4 + q % 4,
                     round,
                     0};
      std::memcpy(static_cast<char*>(args.data) + q * 512, &a, sizeof(a));
      Dispatch p = OneGroup(code.address(kDescriptorOffset), args.address(q * 512),
                            signals.address(q * 64), false);
      p.workgroup_x = 256;
      p.grid_x = kGroups * 256;
      p.group_bytes = 32768;
      queues[q]->SubmitAql(&p);
    }
    for (uint32_t q = 0; q < count; ++q) {
      WaitSignal(signals, q * 64, *queues[q]);
      const uint32_t steps = 4 + q % 4;
      for (uint32_t group = 0; group < kGroups; ++group) {
        done.Wait(q * 16 + group, round, 10000, queues[q].get());
        for (uint32_t j = 0; j < 4096; ++j) {
          const uint32_t original =
              (seed ^ (round * 256 + q)) ^ (group * 4096 + ((j + 17 * steps) & 4095));
          Check(result.Load(q * kStride / 4 + group * 4096 + j) == Advance(original, steps),
                "LDS shuffle output mismatch");
        }
      }
      for (uint32_t j = 0; j < 64; ++j)
        Check(result.Load(q * kStride / 4 + kWords + j) == 0, "LDS dispatch guard corrupted");
      queues[q]->Drain();
    }
  }
  Pass("aql_lds_dispatch", uint64_t(rounds) * count * kGroups * 256);
}
