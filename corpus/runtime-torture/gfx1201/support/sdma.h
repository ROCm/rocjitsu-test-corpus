#ifndef TORTURE_TESTS_SUPPORT_SDMA_H_
#define TORTURE_TESTS_SUPPORT_SDMA_H_
#include "support/kfd.h"

namespace torture {
// Public gfx1201 packet reference:
// https://github.com/ROCm/rocm-systems/blob/96f1528fa5c5a0e12d706dbf4507c441c456f6eb/projects/rocr-runtime/runtime/hsa-runtime/core/runtime/amd_blit_sdma.cpp
class Sdma {
 public:
  explicit Sdma(uint32_t gfx) { Check(gfx == 120001, "wrong SDMA target"); }
  std::vector<uint32_t> words;
  void Acquire() { words.insert(words.end(), {0x111, 0, 0xc3c00000, 0, 0}); }
  void Copy(uint64_t src, uint64_t dst, uint32_t bytes) {
    Check(bytes && bytes <= (1u << 22), "invalid SDMA copy size");
    // Keep NPD clear: preserve dependencies on earlier copies in this ring.
    words.insert(words.end(), {1, bytes - 1, 0, uint32_t(src), uint32_t(src >> 32), uint32_t(dst),
                               uint32_t(dst >> 32)});
  }
  void Wait(uint64_t address, uint32_t token) {
    Check(!(address & 3), "unaligned SDMA poll");
    words.insert(words.end(), {8u | (3u << 28) | (1u << 31), uint32_t(address),
                               uint32_t(address >> 32), token, 0xffffffffu, 4u | (0xfffu << 16)});
  }
  void Finish(uint64_t address, uint32_t token) {
    words.insert(words.end(), {0x111, 0, 0x80400000, 0, 0});
    words.insert(words.end(), {0x00130005u, uint32_t(address), uint32_t(address >> 32), token});
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
