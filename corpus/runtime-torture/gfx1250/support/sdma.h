// Public gfx1250 SDMA GCR (six dwords) and copy/fence packet references:
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/runtime/hsa-runtime/core/runtime/amd_blit_sdma.cpp
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/runtime/hsa-runtime/core/inc/sdma_registers.h
#ifndef TORTURE_TESTS_SUPPORT_SDMA_H_
#define TORTURE_TESTS_SUPPORT_SDMA_H_
#include "support/kfd.h"

namespace torture {
class Sdma {
 public:
  explicit Sdma(uint32_t gfx) { Check(gfx == 120500, "wrong SDMA target"); }
  std::vector<uint32_t> words;
  void Acquire() { words.insert(words.end(), {0x111, 0, 0, (1u << 4) | (1u << 14), 0, 0}); }
  void Copy(uint64_t src, uint64_t dst, uint32_t bytes) {
    Check(bytes && bytes <= (1u << 22), "invalid SDMA copy size");
    // Keep NPD clear: preserve dependencies on earlier copies in this ring.
    words.insert(words.end(), {1, bytes - 1, (3u << 18) | (3u << 26), uint32_t(src),
                               uint32_t(src >> 32), uint32_t(dst), uint32_t(dst >> 32)});
  }
  void Wait(uint64_t address, uint32_t token) {
    Check(!(address & 3), "unaligned SDMA poll");
    words.insert(words.end(),
                 {8u | (3u << 28) | (1u << 31), uint32_t(address), uint32_t(address >> 32), token,
                  0xffffffffu, 4u | (0xfffu << 16) | (3u << 28)});
  }
  // gfx1250 native 64-bit signal packets, system scope. No pair of 32-bit polls.
  void Wait64(uint64_t address, uint64_t token) {
    Check(!(address & 7), "unaligned SDMA 64-bit poll");
    words.insert(words.end(),
                 {0x508u | (1u << 20) | (3u << 28), uint32_t(address), uint32_t(address >> 32),
                  uint32_t(token), uint32_t(token >> 32), 0xffffffffu, 0xffffffffu, 3u << 28});
  }
  void Fence64(uint64_t address, uint64_t token) {
    Check(!(address & 7), "unaligned SDMA 64-bit fence");
    words.insert(words.end(), {0x03130205u, uint32_t(address), uint32_t(address >> 32),
                               uint32_t(token), uint32_t(token >> 32)});
  }
  void Finish(uint64_t address, uint32_t token) {
    words.insert(words.end(), {0x111, 0, 0, (1u << 4) | (1u << 15), 0, 0});
    words.insert(words.end(), {0x03130005u, uint32_t(address), uint32_t(address >> 32), token});
    // Zero is a one-dword SDMA NOP. Fixed 128-byte slots avoid packet straddles.
    words.resize((words.size() + 31) & ~size_t{31}, 0);
  }
};

class SdmaQueue {
 public:
  explicit SdmaQueue(Device& device);
  ~SdmaQueue();
  SdmaQueue(const SdmaQueue&) = delete;
  SdmaQueue& operator=(const SdmaQueue&) = delete;
  void Submit(const std::vector<uint32_t>& words);
  void Drain();
  void SetEnabled(bool enabled);

 private:
  Device& device_;
  Buffer ring_, pointers_;
  uint32_t id_ = 0;
  uint64_t producer_ = 0;
  uint64_t* doorbell_ = nullptr;
  uint64_t Consumed() const;
};
}  // namespace torture
#endif
