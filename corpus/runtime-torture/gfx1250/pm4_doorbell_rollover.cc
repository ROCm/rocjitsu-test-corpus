// Purpose: Cross a 32-bit PM4 producer/doorbell counter boundary.
// Seed an unused queue by whole rings near 2^33, preserving the physical RPTR
// offset, then submit enough real packets to cross the boundary each run.
// Verify all batch values and guards. This is not a timeline-value carry test.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_test_amd.py
#include "support/pm4.h"
using namespace torture;
int main(int argc, char** argv) {
  Start(argc, argv, "pm4_doorbell_rollover");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device(1250);
  Buffer result(device, 4096);
  Queue queue(device);
  queue.SeedEmptyPm4((2ull << 32) - 1024);
  for (uint32_t round = 0; round < rounds; ++round) {
    for (uint32_t batch = 0; batch < 8; ++batch) {
      const uint32_t token = round * 8 + batch + 1;
      Pm4 commands;
      for (uint32_t word = 0; word < 63; ++word)
        commands.Write(result.address(word * 4), token * 256 + word);
      commands.Finish(result.address(512), token);
      queue.Submit(commands.words);
      result.Wait(128, token, 10000, &queue);
      for (uint32_t word = 0; word < 63; ++word)
        Check(result.Load(word) == token * 256 + word, "counter rollover lost packet data");
      Check(result.Load(63) == 0, "rollover output guard corrupted");
    }
  }
  queue.Drain();
  Check(queue.producer() >= (2ull << 32), "test did not cross counter boundary");
  Pass("pm4_doorbell_rollover", uint64_t(rounds) * 8 * 63);
}
