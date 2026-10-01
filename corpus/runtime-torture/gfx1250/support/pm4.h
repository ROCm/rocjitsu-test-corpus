#ifndef TORTURE_TESTS_SUPPORT_PM4_H_
#define TORTURE_TESTS_SUPPORT_PM4_H_

#include <initializer_list>

#include "support/kfd.h"

namespace torture {
// Small encoders for gfx1250 MEC type-3 packet forms. These are
// deliberately explicit: scenarios own ordering and storage lifetime.
// gfx12.5-specific WRITE_DATA scope and ACQUIRE_MEM GCR fields:
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/libhsakmt/tests/kfdtest/include/pm4_pkt_struct_gfx125x.h
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/PM4Packet.cpp
// Other packet forms retain the public MEC encoding; smoke defaults pass on native gfx1250.
// Public encoding references:
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/libamdf/cts/gpu/pm4_queue_test.cc
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/drivers/amdgpu/util/pm4_atomic.h
// https://github.com/ROCm/rocm-systems/blob/96f1528fa5c5a0e12d706dbf4507c441c456f6eb/projects/rocr-runtime/runtime/hsa-runtime/core/inc/amd_gpu_pm4.h
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
    Packet(0x37, {(2u << 8) | (3u << 12) | (1u << 20), uint32_t(address), uint32_t(address >> 32),
                  value});
  }
  void Copy(uint64_t source, uint64_t target) {
    Packet(0x40, {2u | (2u << 8) | (1u << 20), uint32_t(source), uint32_t(source >> 32),
                  uint32_t(target), uint32_t(target >> 32)});
  }
  void Wait(uint64_t address, uint32_t value) {
    // Dependency waits follow public KFD PM4WaitRegMemPacket: equal, memory
    // space, 32-bit mask, ACE offload enabled in the poll-interval dword.
    // With offload clear, an eight-queue reverse chain stalled on its second
    // round on the test system (fw 2380). INVESTIGATE reproducer:
    // pm4_dependency_chain_no_offload_gfx1250 --queues 8 --iterations 4.
    // WaitCompare leaves this bit clear; precise firmware behavior is unresolved.
    Packet(0x3c, {3u | (1u << 4), uint32_t(address), uint32_t(address >> 32), value, 0xffffffffu,
                  4u | (1u << 31)});
  }
  void WaitCompare(uint64_t address, uint32_t value, uint32_t function, uint32_t mask) {
    Check(function >= 1 && function <= 6 && !(address & 3), "invalid wait comparison");
    Packet(0x3c,
           {function | (1u << 4), uint32_t(address), uint32_t(address >> 32), value, mask, 4});
  }
  void Wait64(uint64_t address, uint64_t value) {
    Check(!(address & 7), "unaligned 64-bit wait");
    // WAIT_REG_MEM64, unsigned >=. Leave the ACE-offload optimization bit clear.
    Packet(0x93, {5u | (1u << 4), uint32_t(address), uint32_t(address >> 32), uint32_t(value),
                  uint32_t(value >> 32), 0xffffffffu, 0xffffffffu, 4});
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
  void Add(uint64_t address, uint64_t value, bool wide) {
    Check(!(address & (wide ? 7 : 3)), "misaligned atomic");
    Packet(0x1e, {wide ? 0x2fu : 0x0fu, uint32_t(address), uint32_t(address >> 32), uint32_t(value),
                  uint32_t(value >> 32), 0, 0, 0});
  }
  void Barrier() {
    Packet(0x46, {7u | (4u << 8)});  // CS_PARTIAL_FLUSH.
    // This helper is also a release before cross-engine fences, so include
    // GL2_WB (bit 15) as well as the public KFD acquire/invalidate recipe.
    const uint32_t gcr = (1u << 15) | (1u << 14) | (1u << 8) | (1u << 7) | (1u << 4) | 1u;
    Packet(0x58, {0, 0xffffffffu, 0, 0, 0, 4, gcr});
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
}  // namespace torture
#endif
