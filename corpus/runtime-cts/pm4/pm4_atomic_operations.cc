// Purpose: Check 32/64-bit PM4 swap, add, subtract, AND/OR/XOR, signed and
// unsigned min/max, and single-pass compare-swap success/failure. Compare-swap
// failure differs only in a high bit for 64-bit operands.
// Alternate two queues through GPU dependencies; snapshot each intermediate
// result before the next owner changes it. Include overflow, borrow and high
// bits, and verify narrow operations do not modify the adjacent guard word.
// Use device-local memory for the full opcode set. Uncached host atomics on
// PCIe can support only add, swap and compare-swap; other operations may NOP.
// Copy each result and its guard to host-visible memory for verification.
// https://rocm.docs.amd.com/en/docs-7.2.1/reference/gpu-atomics-operation.html
//
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/queue/queue_atomic_test.cc
// TC opcodes and MEC source/comparison operand layout:
// https://github.com/GPUOpen-Drivers/pal/blob/c5e800072a32f68b6ccc4422936d96167c6e0728/src/core/hw/gfxip/gfx9/chip/gfx9_plus_merged_enum.h
// https://github.com/GPUOpen-Drivers/pal/blob/c5e800072a32f68b6ccc4422936d96167c6e0728/src/core/hw/gfxip/gfx12/chip/gfx12_merged_f32_mec_pm4_packets.h
#include <algorithm>
#include <vector>

#include "pm4.h"
using namespace cts;
int main(int argc, char** argv) {
  Start(argc, argv, "pm4_atomic_operations");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device;
  Buffer memory(device, 4096);
  Buffer atomic(device, 4096, false, true);
  Queue first(device), second(device);
  Queue* queues[] = {&first, &second};
  uint64_t operations = 0;
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t wide = 0; wide < 2; ++wide) {
      const uint64_t mask = wide ? ~uint64_t{0} : 0xffffffffu;
      const uint64_t sign = uint64_t{1} << (wide ? 63 : 31);
      const uint64_t swapped = 0x1234567800000101ull & mask;
      struct Operation {
        uint32_t op;
        uint64_t source, compare = 0;
      };
      const Operation cases[] = {
          {0x07, ~uint64_t{0} - round},
          {0x0f, uint64_t(round) + 2},
          {0x10, 0x100000003ull},
          {0x15, 0xaaaaaaaaff00ff00ull},
          {0x16, 0x1234567800ff00ffull},
          {0x17, 0xfedcba9876543210ull},
          {0x07, sign + round},
          {0x11, 7},
          {0x11, sign + round - 1},
          {0x13, 0x42},
          {0x13, sign + round},
          {0x12, sign + round},
          {0x12, 0x11},
          {0x14, sign + round},
          {0x14, 0x21},
          {0x08, swapped, sign + round},
          {0x08, 0x9999, swapped ^ sign},
          {0x08, 0xabc, swapped},
      };
      memory.Store64(0, wide ? 0 : 0xcafebabe00000000ull);
      memory.Store(16, 0);
      std::vector<uint64_t> values;
      uint64_t expected = 0;
      Pm4 streams[2];
      // CP_SYNC retires initialization before the first atomic. The other
      // queue remains behind the timeline dependency until ownership passes.
      streams[0].DmaCopy(memory.address(), atomic.address(), 16);
      for (uint32_t i = 0; i < std::size(cases); ++i) {
        const auto& operation = cases[i];
        const uint64_t operand = operation.source & mask;
        switch (operation.op) {
          case 0x07:
            expected = operand;
            break;
          case 0x08:
            if (expected == (operation.compare & mask)) expected = operand;
            break;
          case 0x0f:
            expected += operand;
            break;
          case 0x10:
            expected -= operand;
            break;
          case 0x11:
            if ((operand ^ sign) < (expected ^ sign)) expected = operand;
            break;
          case 0x12:
            expected = std::min(expected, operand);
            break;
          case 0x13:
            if ((operand ^ sign) > (expected ^ sign)) expected = operand;
            break;
          case 0x14:
            expected = std::max(expected, operand);
            break;
          case 0x15:
            expected &= operand;
            break;
          case 0x16:
            expected |= operand;
            break;
          case 0x17:
            expected ^= operand;
            break;
        }
        expected &= mask;
        values.push_back(expected | (wide ? 0 : 0xcafebabe00000000ull));
        auto& commands = streams[i & 1];
        commands.Wait(memory.address(64), i);
        commands.Atomic(operation.op, atomic.address(), operand, wide,
                        operation.compare & mask);
        commands.Barrier();
        commands.Copy(atomic.address(), memory.address(128 + i * 8));
        commands.Copy(atomic.address(4), memory.address(132 + i * 8));
        if (i + 1 == std::size(cases))
          commands.DmaCopy(atomic.address(), memory.address(), 16);
        commands.Finish(memory.address(64), i + 1);
      }
      // FIFO edges preserve 0,2,... / 1,3,... ordering despite reverse
      // publication.
      queues[1]->Submit(streams[1].words);
      queues[0]->Submit(streams[0].words);
      memory.Wait(16, values.size(), 10000, queues[1]);
      for (uint32_t i = 0; i < values.size(); ++i)
        if (memory.Load64(128 + i * 8) != values[i])
          Fail(
              "atomic round=%u width=%u step=%u op=%x expected=%llx "
              "observed=%llx",
              round, wide ? 64 : 32, i, cases[i].op,
              (unsigned long long)values[i],
              (unsigned long long)memory.Load64(128 + i * 8));
      Check(memory.Load64(0) == values.back(), "atomic final value mismatch");
      Check(
          memory.Load64(8) == 0 && memory.Load64(128 + values.size() * 8) == 0,
          "atomic guard corrupted");
      first.Drain();
      second.Drain();
      operations += values.size();
    }
  }
  Pass("pm4_atomic_operations", operations);
}
