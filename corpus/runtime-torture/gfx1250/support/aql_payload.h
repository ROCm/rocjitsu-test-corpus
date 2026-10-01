// Packet/signal ABI references:
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/runtime/hsa-runtime/inc/hsa.h
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/runtime/hsa-runtime/inc/amd_hsa_signal.h
// Small AQL payload and barrier helpers for the dual-mode scenarios.
// A slot owns one kernarg and completion signal. Caller must retire every
// dispatch AND dependency referencing a slot before preparing that slot again.
// No queue ownership, scheduling, allocation policy, or automatic signal reuse.
#ifndef TORTURE_AQL_PAYLOAD_H_
#define TORTURE_AQL_PAYLOAD_H_
#include <cstring>

#include "payload_kernel.inc"
#include "support/aql.h"
namespace torture {
struct AqlBarrier {
  uint64_t header = 3u | (1u << 8) | (2u << 9) | (2u << 11);
  uint64_t dependencies[5]{};
  uint64_t reserved = 0, completion = 0;
};
static_assert(sizeof(AqlBarrier) == 64);
inline void AqlWait(Queue& queue, uint64_t dependency, uint64_t completion = 0) {
  AqlBarrier packet;
  packet.dependencies[0] = dependency;
  packet.completion = completion;
  queue.SubmitAql(&packet);
}
struct PayloadArgs {
  uint64_t source, target;
  uint32_t value, count;
};
class AqlPayload {
 public:
  AqlPayload(Device& device, uint32_t slots)
      : code(device, sizeof(kKernelImage), true),
        args(device, size_t(slots) * 512),
        signals(device, size_t(slots) * 64),
        slots_(slots) {
    Check(kKernargBytes >= sizeof(PayloadArgs) && kKernargBytes <= 512,
          "payload kernarg size mismatch");
    std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  }
  void Prepare(uint32_t slot, uint64_t target, uint32_t value, uint32_t count = 1,
               uint64_t source = 0) {
    Check(slot < slots_, "payload slot out of range");
    ResetSignal(signals, size_t(slot) * 64);
    PayloadArgs a{source, target, value, count};
    std::memcpy(static_cast<char*>(args.data) + size_t(slot) * 512, &a, sizeof(a));
  }
  uint64_t Signal(uint32_t slot) const { return signals.address(size_t(slot) * 64); }
  void Submit(Queue& queue, uint32_t slot, uint64_t completion = 0) {
    auto packet = OneGroup(code.address(kDescriptorOffset), args.address(size_t(slot) * 512),
                           completion ? completion : Signal(slot), true);
    queue.SubmitAql(&packet);
  }
  void Wait(Queue& queue, uint32_t slot) { WaitSignal(signals, size_t(slot) * 64, queue); }
  Buffer code, args, signals;

 private:
  uint32_t slots_;
};
}  // namespace torture
#endif
