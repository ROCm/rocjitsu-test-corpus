// Purpose: Exercise gfx1250 metadata prefetch with 30 preloaded kernarg dwords.
// Run identical batches through a plain AQL queue and a metadata queue. Dispatch
// and barrier packets alternate; every batch wraps their 64-slot rings. Change
// all arguments on each reuse and check every result, both firmware completion
// signals and guards. The descriptor must fill the first two 15-dword preload
// blocks; the final five kernarg dwords are loaded from memory by the shader.
// LLVM reserves two of the 32 user SGPRs for the kernarg pointer. This kernel
// does not exercise the companion's final two-dword preload block.
// This checks metadata-path data integrity, not a metadata performance benefit.
// Kernarg backing is executable for the plain queue's CP preload fetches.
// Reproducer: aql_metadata_nonexec_kernargs_gfx1250 builds this same scenario
// without executable kernarg backing. Plain-AQL preload previously caused a CP
// fetch fault on a different gfx1250 machine; not rerun on the current machine.
// This preserves the permission difference for diagnosis, not a confirmed bug.
// A host reboot may be needed after a fault. All result checks remain enabled.
//
// Parameters (decimal integers; ranges inclusive):
//   --iterations N: batches of 32 dispatch/barrier pairs per queue; default 64;
//     range 1..100000.
//   --timeout N: watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted but unused. Progress waits have a 10s deadline.
// Inspiration/ABI: public ROCr metadata companion ring and dispatch/barrier layouts.
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/runtime/hsa-runtime/inc/hsa_ext_amd.h
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/runtime/hsa-runtime/core/runtime/amd_aql_queue.cpp
#include <cstdio>
#include <cstring>

#include "metadata_kernel.inc"
#include "support/aql.h"
using namespace torture;
struct PreloadArgs {
  uint64_t output;
  uint32_t values[32], token;
};
struct MetadataBarrier {
  uint64_t header, dependencies[5], reserved, completion;
};
static_assert(sizeof(MetadataBarrier) == 64);
int main(int argc, char** argv) {
  Start(argc, argv, "aql_metadata_reuse");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  constexpr uint32_t batch = 32, slots = batch * 2;
  Device device(1250);
#ifdef REPRO_NONEXEC_KERNARGS
  std::puts("Reproducer: plain/metadata AQL preload with non-executable kernargs");
  std::fflush(stdout);
  constexpr bool executable_args = false;
#else
  constexpr bool executable_args = true;
#endif
  Buffer code(device, sizeof(kKernelImage), true), args(device, slots * 256, executable_args);
  Buffer result(device, slots * 256), signals(device, slots * 128);
  Check(kKernargBytes <= 256, "metadata kernarg exceeds slot");
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  uint16_t preload;
  std::memcpy(&preload, kKernelImage + kDescriptorOffset + 58, sizeof(preload));
  Check((preload & 127) == 30, "metadata kernel must preload exactly 30 dwords");
  Queue plain(device, 4096, 7, true, false, false), metadata(device, 4096, 7, true);
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
        Dispatch p = OneGroup(code.address(kDescriptorOffset), args.address(slot * 256),
                              signals.address(slot * 128), true);
        queues[q]->SubmitAql(&p);
        MetadataBarrier after{};
        after.header = 3u | (1u << 8) | (2u << 9) | (2u << 11);
        after.dependencies[0] = signals.address(slot * 128);
        after.completion = signals.address(slot * 128 + 64);
        queues[q]->SubmitAql(&after);
      }
    }
    for (uint32_t q = 0; q < 2; ++q) {
      for (uint32_t i = 0; i < batch; ++i) {
        const uint32_t slot = q * batch + i, token = round * batch + i;
        WaitSignal(signals, slot * 128 + 64, *queues[q]);
        WaitSignal(signals, slot * 128, *queues[q]);
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
