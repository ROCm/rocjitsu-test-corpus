// Purpose: Reuse plain/metadata AQL rings with 0, 1, 15, 16, 29 and 30
// preloaded kernarg dwords. Alternate descriptors and AND/OR barriers, change
// every argument generation, and check full output and guards. Inspect all four
// companion headers after each completed dispatch/barrier and before reuse.
// Each descriptor's preload length/offset is checked against the compiled variant.
// Kernarg pointers occupy two user SGPRs; the final two-dword companion block
// and nonzero preload offsets are not exercised by these compiler-generated kernels.
// Kernarg backing is executable for plain-queue preload fetches.
// Reproducer: aql_metadata_nonexec_kernargs_<target> uses the 30-dword variant
// without executable kernarg backing. Plain-AQL preload previously caused a CP
// fetch fault on a different gfx1250 machine; not rerun on the current machine.
// This preserves the permission difference for diagnosis, not a confirmed bug.
// A host reboot may be needed after a fault. All result checks remain enabled.
//
// Parameters (decimal integers; ranges inclusive):
//   --aql-metadata off|on: gfx1250 only; both queue types are always tested.
//   --iterations N: batches of 32 dispatch/barrier pairs per queue; default 64;
//     range 1..100000.
//   --timeout N: watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted but unused. Progress waits have a 10s deadline.
// Inspiration/ABI: public ROCr metadata companion ring and dispatch/barrier layouts.
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/runtime/hsa-runtime/inc/hsa_ext_amd.h
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/runtime/hsa-runtime/core/runtime/amd_aql_queue.cpp
#include <cstdio>
#include <cstring>
#include <memory>

namespace preload0 {
#include "metadata_0_kernel.inc"
}
namespace preload1 {
#include "metadata_1_kernel.inc"
}
namespace preload15 {
#include "metadata_15_kernel.inc"
}
namespace preload16 {
#include "metadata_16_kernel.inc"
}
namespace preload29 {
#include "metadata_29_kernel.inc"
}
namespace preload30 {
#include "metadata_30_kernel.inc"
}
#include "support/aql.h"
using namespace cts;
struct PreloadArgs {
  uint32_t values[32];
  uint64_t output;
  uint32_t token;
};
struct MetadataBarrier {
  uint64_t header, dependencies[5], reserved, completion;
};
static_assert(sizeof(MetadataBarrier) == 64);
int main(int argc, char** argv) {
  Start(argc, argv, "aql_metadata_reuse");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  constexpr uint32_t batch = 32, slots = batch * 2;
  Device device;
#ifdef REPRO_NONEXEC_KERNARGS
  std::puts("Reproducer: plain/metadata AQL preload with non-executable kernargs");
  std::fflush(stdout);
  constexpr bool executable_args = false;
#else
  constexpr bool executable_args = true;
#endif
  struct Kernel {
    const unsigned char* image;
    size_t size;
    uint32_t descriptor, args, preload;
  };
  const Kernel kernels[] = {
      {preload0::kKernelImage, sizeof(preload0::kKernelImage), preload0::kDescriptorOffset,
       preload0::kKernargBytes, 0},
      {preload1::kKernelImage, sizeof(preload1::kKernelImage), preload1::kDescriptorOffset,
       preload1::kKernargBytes, 1},
      {preload15::kKernelImage, sizeof(preload15::kKernelImage), preload15::kDescriptorOffset,
       preload15::kKernargBytes, 15},
      {preload16::kKernelImage, sizeof(preload16::kKernelImage), preload16::kDescriptorOffset,
       preload16::kKernargBytes, 16},
      {preload29::kKernelImage, sizeof(preload29::kKernelImage), preload29::kDescriptorOffset,
       preload29::kKernargBytes, 29},
      {preload30::kKernelImage, sizeof(preload30::kKernelImage), preload30::kDescriptorOffset,
       preload30::kKernargBytes, 30},
  };
  std::vector<std::unique_ptr<Buffer>> code;
  for (const auto& kernel : kernels) {
    Check(kernel.args <= 256, "metadata kernarg exceeds slot");
    uint16_t preload;
    std::memcpy(&preload, kernel.image + kernel.descriptor + 58, sizeof(preload));
    Check((preload & 127) == kernel.preload && (preload >> 7) == 0,
          "metadata descriptor preload length/offset mismatch");
    code.emplace_back(new Buffer(device, kernel.size, true));
    std::memcpy(code.back()->data, kernel.image, kernel.size);
  }
  Buffer args(device, slots * 256, executable_args);
  Buffer result(device, slots * 256), signals(device, slots * 128);
  uint64_t metadata_slots[batch * 2]{};
  Queue plain(device, 4096, 7, true, false, false), metadata(device, 4096, 7, true, false, true);
  Check(!plain.has_metadata() && metadata.has_metadata(), "metadata queue selection failed");
  Queue* queues[] = {&plain, &metadata};
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t q = 0; q < 2; ++q) {
      for (uint32_t i = 0; i < batch; ++i) {
        const uint32_t slot = q * batch + i, token = round * batch + i;
        ResetSignal(signals, slot * 128);
        ResetSignal(signals, slot * 128 + 64);
        PreloadArgs a{};
        a.output = result.address(slot * 256);
        a.token = token;
        for (uint32_t word = 0; word < 32; ++word) a.values[word] = token ^ (word * 31337);
        std::memcpy(static_cast<char*>(args.data) + slot * 256, &a, sizeof(a));
#ifdef REPRO_NONEXEC_KERNARGS
        const uint32_t variant = 5;
#else
        const uint32_t variant = (round + i) % 6;
#endif
        Dispatch p = OneGroup(code[variant]->address(kernels[variant].descriptor),
                              args.address(slot * 256), signals.address(slot * 128), true);
        uint64_t index = queues[q]->producer();
        queues[q]->SubmitAql(&p);
        if (q) metadata_slots[i * 2] = queues[q]->AqlMetadataSlotAddress(index);
        MetadataBarrier after{};
        after.header = (((round + i) & 1) ? 5u : 3u) | (1u << 8) | (2u << 9) | (2u << 11);
        for (auto& dependency : after.dependencies) dependency = signals.address(slot * 128);
        after.completion = signals.address(slot * 128 + 64);
        index = queues[q]->producer();
        queues[q]->SubmitAql(&after);
        if (q) metadata_slots[i * 2 + 1] = queues[q]->AqlMetadataSlotAddress(index);
      }
    }
    for (uint32_t q = 0; q < 2; ++q) {
      for (uint32_t i = 0; i < batch; ++i) {
        const uint32_t slot = q * batch + i, token = round * batch + i;
        WaitSignal(signals, slot * 128 + 64, *queues[q]);
        WaitSignal(signals, slot * 128, *queues[q]);
        if (q)
          for (uint32_t packet = 0; packet < 2; ++packet)
            for (uint32_t block = 0; block < 4; ++block) {
              const auto* header =
                  reinterpret_cast<const uint32_t*>(metadata_slots[i * 2 + packet] + block * 64);
              if ((__atomic_load_n(header, __ATOMIC_ACQUIRE) & 0xff) != 1)
                Fail("metadata not invalidated round=%u slot=%u packet=%u block=%u", round, i,
                     packet, block);
            }
        for (uint32_t word = 0; word < 32; ++word)
          Check(result.Load(slot * 64 + word) == (token ^ (word * 31337)) + token * (word + 1),
                "metadata preload output missing or stale");
        for (uint32_t word = 32; word < 64; ++word)
          Check(result.Load(slot * 64 + word) == 0, "metadata output guard corrupted");
      }
      queues[q]->Drain();
    }
  }
  Pass("aql_metadata_reuse", uint64_t(rounds) * slots);
}
