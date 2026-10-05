#ifdef CTS_AQL_ONLY
#error "PM4 packet encoders are forbidden in the AQL suite"
#endif
// Shared MEC packets. Version-specific fields are in support/*/packets.h.
// Public references and capabilities: REFERENCES.md.
#ifndef CTS_TESTS_SUPPORT_PM4_H_
#define CTS_TESTS_SUPPORT_PM4_H_

#include <initializer_list>
#include <iterator>

#include "packets.h"
#include "support/kfd.h"

namespace cts {
class Pm4 {
 public:
  std::vector<uint32_t> words;
  static uint32_t Header(uint32_t opcode, uint32_t count) {
    Check(count >= 2 && count <= 16385, "invalid PM4 packet length");
    return 0xc0000000u | ((count - 2) << 16) | (opcode << 8);
  }
  void Packet(uint32_t opcode, std::initializer_list<uint32_t> body) {
    words.push_back(Header(opcode, body.size() + 1));
    words.insert(words.end(), body);
  }
  void Write(uint64_t address, uint32_t value) {
    Packet(0x37, {(2u << 8) | pm4_encoding::kWriteScope | (1u << 20), uint32_t(address),
                  uint32_t(address >> 32), value});
  }
  void Copy(uint64_t source, uint64_t target) {
    Packet(0x40, {2u | (2u << 8) | (1u << 20), uint32_t(source), uint32_t(source >> 32),
                  uint32_t(target), uint32_t(target >> 32)});
  }
  void Wait(uint64_t address, uint32_t value) {
    // Equal memory wait; offload policy is selected by the support group.
    Packet(0x3c, {3u | (1u << 4), uint32_t(address), uint32_t(address >> 32), value, 0xffffffffu,
                  4u | pm4_encoding::kWaitOffload});
  }
  void WaitCompare(uint64_t address, uint32_t value, uint32_t function, uint32_t mask) {
    Check(function >= 1 && function <= 6 && !(address & 3), "invalid wait comparison");
    Packet(0x3c,
           {function | (1u << 4), uint32_t(address), uint32_t(address >> 32), value, mask, 4});
  }
  void Wait64(uint64_t address, uint64_t value) { Wait64Compare(address, value, 5, ~uint64_t{0}); }
  void Wait64Compare(uint64_t address, uint64_t value, uint32_t function, uint64_t mask) {
    Check(!(address & 7) && function >= 1 && function <= 6, "invalid 64-bit wait");
    Packet(0x93, {function | (1u << 4), uint32_t(address), uint32_t(address >> 32), uint32_t(value),
                  uint32_t(value >> 32), uint32_t(mask), uint32_t(mask >> 32), 4});
  }
  void Exchange64(uint64_t address, uint64_t value) {
    Check(!(address & 7), "unaligned 64-bit exchange");
    Packet(0x1e, {0x27u, uint32_t(address), uint32_t(address >> 32), uint32_t(value),
                  uint32_t(value >> 32), 0, 0, 0});
  }
  void DmaCopy(uint64_t source, uint64_t target, uint32_t bytes) {
    Check(bytes && bytes < (1u << 26), "invalid CP DMA byte count");
    // DMA_DATA memory-to-memory, CP_SYNC waits for DMA completion.
    Packet(0x50, {1u << 31, uint32_t(source), uint32_t(source >> 32), uint32_t(target),
                  uint32_t(target >> 32), bytes});
  }
  void Add(uint64_t address, uint64_t value, bool wide) { Atomic(0x0f, address, value, wide); }
  void Atomic(uint32_t operation, uint64_t address, uint64_t value, bool wide) {
    Check(!(address & (wide ? 7 : 3)), "misaligned atomic");
    Packet(0x1e, {operation + (wide ? 0x20u : 0u), uint32_t(address), uint32_t(address >> 32),
                  uint32_t(value), uint32_t(value >> 32), 0, 0, 0});
  }
  void Barrier() {
    Packet(0x46, {7u | (4u << 8)});  // CS_PARTIAL_FLUSH.
    words.push_back(Header(0x58, std::size(pm4_encoding::kAcquire) + 1));
    words.insert(words.end(), std::begin(pm4_encoding::kAcquire), std::end(pm4_encoding::kAcquire));
  }
  void Release64(uint64_t address, uint64_t value) {
    Release(address, value, 3, 0);  // Data after write confirmation, no interrupt.
  }
  void Interrupt(uint64_t address, uint32_t event) {
    Release(address, event, 2, event);  // Interrupt after write confirmation.
  }
  void Release(uint64_t address, uint64_t value, uint32_t interrupt, uint32_t context) {
    Check(!(address & 7), "unaligned release");
    const size_t first = words.size();
    Packet(0x49, {pm4_encoding::kReleaseControl, (interrupt << 24) | (2u << 29), uint32_t(address),
                  uint32_t(address >> 32), uint32_t(value), uint32_t(value >> 32), context});
    words[first] |= 2;  // Compute shader type.
  }
  void Indirect(uint64_t address, uint32_t count) {
    Check(!(address & 3) && count && count < (1u << 20), "invalid indirect buffer");
    Packet(0x3f, {uint32_t(address), uint32_t(address >> 32), count | (1u << 23)});
  }
  void Pad() {
    size_t count = 8 - words.size() % 8;
    if (count == 1) count += 8;
    words.push_back(Header(0x10, count));
    words.insert(words.end(), count - 1, 0);
  }
  void Finish(uint64_t fence, uint32_t value) {
    Barrier();
    Write(fence, value);
    Pad();
  }
};
}  // namespace cts
#endif
