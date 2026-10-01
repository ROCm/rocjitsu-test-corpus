// Purpose: Exercise masked 64-bit WAIT_REG_MEM64 comparisons.
// Check LT/LE/EQ/NE/GE/GT both blocked and satisfied, with decisive bits in
// the HIGH word and deliberately different ignored bits. A separate queue
// must progress before the host releases each wait with a 64-bit store.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/queue/queue_atomic_test.cc
#include <thread>

#include "support/pm4.h"
using namespace torture;
int main(int argc, char** argv) {
  Start(argc, argv, "pm4_wait64_comparisons");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device(1201);
  Buffer memory(device, 4096);
  Queue waiter(device), independent(device);
  const uint64_t mask = 0xffff00000000ffffull;
  const uint64_t ref = 0x8000000000000010ull, step = 1ull << 48;
  const uint64_t blocked[] = {ref + step, ref + step, ref + step, ref, ref - step, ref};
  const uint64_t ready[] = {ref - step, ref, ref, ref + step, ref, ref + step};
  uint32_t token = 0;
  for (uint32_t round = 0; round < rounds; ++round) {
    for (uint32_t function = 1; function <= 6; ++function) {
      ++token;
      memory.Store64(0, blocked[function - 1] | 0x0000123456780000ull);
      Pm4 wait;
      const uint64_t address = memory.address();
      wait.Packet(0x93,
                  {function | (1u << 4), uint32_t(address), uint32_t(address >> 32), uint32_t(ref),
                   uint32_t(ref >> 32), uint32_t(mask), uint32_t(mask >> 32), 4});
      wait.Finish(memory.address(64), token);
      waiter.Submit(wait.words);
      Pm4 ping;
      ping.Finish(memory.address(128), token);
      independent.Submit(ping.words);
      memory.Wait(32, token, 10000, &independent);
      const uint64_t deadline = NowNs() + 1000000;
      do {
        Check(memory.Load(16) == token - 1, "64-bit comparison passed while false");
        std::this_thread::yield();
      } while (NowNs() < deadline);
      memory.Store64(0, ready[function - 1] | 0x0000fedcba980000ull);
      memory.Wait(16, token, 10000, &waiter);
      Check(memory.Load64(8) == 0, "wait operand guard corrupted");
      waiter.Drain();
      independent.Drain();
    }
  }
  Pass("pm4_wait64_comparisons", token);
}
