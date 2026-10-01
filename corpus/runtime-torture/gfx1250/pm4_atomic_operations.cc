// Purpose: Check 32/64-bit PM4 swap, add, subtract, AND, OR and XOR.
// Alternate two queues through GPU dependencies; snapshot each intermediate
// result before the next owner changes it. Include overflow, borrow and high
// bits, and verify narrow operations do not modify the adjacent guard word.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/queue/queue_atomic_test.cc
#include <array>

#include "support/pm4.h"
using namespace torture;
int main(int argc, char** argv) {
  Start(argc, argv, "pm4_atomic_operations");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device(1250);
  Buffer memory(device, 4096);
  Queue first(device), second(device);
  Queue* queues[] = {&first, &second};
  constexpr std::array<uint32_t, 6> ops = {0x07, 0x0f, 0x10, 0x15, 0x16, 0x17};
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t wide = 0; wide < 2; ++wide) {
      const uint64_t mask = wide ? ~uint64_t{0} : 0xffffffffu;
      const uint64_t operands[] = {~uint64_t{0} - round,  uint64_t(round) + 2,
                                   0x100000003ull,        0xaaaaaaaaff00ff00ull,
                                   0x1234567800ff00ffull, 0xfedcba9876543210ull};
      memory.Store64(0, wide ? 0 : 0xcafebabe00000000ull);
      memory.Store(16, 0);
      uint64_t expected = 0;
      std::array<uint64_t, 6> values{};
      for (uint32_t i = 0; i < ops.size(); ++i) {
        const uint64_t operand = operands[i] & mask;
        switch (i) {
          case 0:
            expected = operand;
            break;
          case 1:
            expected += operand;
            break;
          case 2:
            expected -= operand;
            break;
          case 3:
            expected &= operand;
            break;
          case 4:
            expected |= operand;
            break;
          case 5:
            expected ^= operand;
            break;
        }
        expected &= mask;
        values[i] = expected | (wide ? 0 : 0xcafebabe00000000ull);
      }
      // Reverse submission makes each consumer initially wait for its producer.
      // One stream per queue preserves acyclic dependencies (0,2,4 / 1,3,5).
      Pm4 streams[2];
      for (uint32_t i = 0; i < ops.size(); ++i) {
        auto& commands = streams[i & 1];
        commands.Wait(memory.address(64), i);
        const uint64_t operand = operands[i] & mask;
        commands.Packet(0x1e, {ops[i] + (wide ? 0x20u : 0u), uint32_t(memory.address()),
                               uint32_t(memory.address() >> 32), uint32_t(operand),
                               uint32_t(operand >> 32), 0, 0, 0});
        commands.Barrier();
        commands.Copy(memory.address(), memory.address(128 + i * 8));
        commands.Copy(memory.address(4), memory.address(132 + i * 8));
        commands.Finish(memory.address(64), i + 1);
      }
      queues[1]->Submit(streams[1].words);
      queues[0]->Submit(streams[0].words);
      memory.Wait(16, ops.size(), 10000, queues[1]);
      for (uint32_t i = 0; i < ops.size(); ++i)
        Check(memory.Load64(128 + i * 8) == values[i], "atomic intermediate result mismatch");
      Check(memory.Load64(0) == values.back(), "atomic final value mismatch");
      Check(memory.Load64(8) == 0 && memory.Load64(176) == 0, "atomic guard corrupted");
      first.Drain();
      second.Drain();
    }
  }
  Pass("pm4_atomic_operations", uint64_t(rounds) * 12);
}
