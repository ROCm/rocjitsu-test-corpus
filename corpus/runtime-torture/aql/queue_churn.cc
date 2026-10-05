// Purpose: Exercise queue creation, first submission, destruction and reuse
// while a persistent queue survives. Check first-dispatch arithmetic, shader markers, firmware
// completion and guards. Reuse storage only after completion and retirement.
// The public simulator regression is inspiration, not a claimed gfx12 defect.
//
// Parameters (decimal integers; ranges inclusive):
//   Queue protocol: AQL only.
//   --iterations N: rounds; default 64; range 1..100000.
//   --queues N: transient queues plus one survivor; default PM4 8, AQL 1;
//     range 1..128. Higher AQL counts are not qualified oversubscription coverage.
//   --timeout N: watchdog seconds; default 45; range 1..3600.
//   --seed: accepted but unused. Progress waits have a 10-second deadline.
//
// Inspiration: independent direct-KFD adaptations of these public patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDQMTest.cpp
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/libamdf/cts/gpu/user_queue_memory.cc
// https://github.com/ROCm/rocm-systems/issues/8818
#include <cstring>
#include <memory>

#include "support/aql.h"
#include "work_kernel.inc"

using namespace torture;

using namespace torture;
int main(int argc, char** argv) {
  Start(argc, argv, "queue_churn");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  const uint32_t count = Option(argc, argv, "--queues", 1, 128);
  Device device;
  Buffer code(device, sizeof(kKernelImage), true), args(device, (count + 1) * 512);
  Buffer result(device, (count + 1) * 1024), signals(device, (count + 1) * 64);
  Check(kKernargBytes <= 512, "kernel arguments too large");
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  Queue survivor(device, 4096, 7, true);
  for (uint32_t round = 1; round <= rounds; ++round) {
    std::vector<std::unique_ptr<Queue>> replacements;
    std::vector<Queue*> queues;
    for (uint32_t q = 0; q < count; ++q) {
      replacements.emplace_back(new Queue(device, 4096, 7, true));
      queues.push_back(replacements.back().get());
    }
    queues.push_back(&survivor);
    for (uint32_t q = 0; q < count + 1; ++q) {
      ResetSignal(signals, q * 64);
      for (uint32_t word = 0; word < 128; ++word) result.Store(q * 256 + word, 0xdeadbeef);
      Arguments arguments{result.address(q * 1024), result.address(q * 1024 + 256), round * 17 + q,
                          31 + round % 97, round};
      std::memcpy(static_cast<char*>(args.data) + q * 512, &arguments, sizeof(arguments));
      Dispatch packet = OneGroup(code.address(kDescriptorOffset), args.address(q * 512),
                                 signals.address(q * 64), false);
      packet.grid_x = 63;
      queues[q]->SubmitAql(&packet);
    }
    for (uint32_t q = 0; q < count + 1; ++q) {
      WaitSignal(signals, q * 64, *queues[q]);
      for (uint32_t group = 0; group < 63; ++group) {
        Check(result.Load(q * 256 + group) == Advance((round * 17 + q) ^ group, 31 + round % 97),
              "first-dispatch output missing or stale");
        Check(result.Load(q * 256 + 64 + group) == round, "shader marker missing");
      }
      Check(result.Load(q * 256 + 63) == 0xdeadbeef && result.Load(q * 256 + 127) == 0xdeadbeef,
            "dispatch guard overwritten");
      queues[q]->Drain();
    }
  }
  Pass("queue_churn", uint64_t(rounds) * (count + 1));
  return 0;
}
