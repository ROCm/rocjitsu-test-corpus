// Purpose: Test masked PM4 memory waits for LT, LE, EQ, NE, GE and GT comparisons.
// Require each false condition to block while an independent queue progresses,
// then change the host value and check completion; masked-off bits deliberately differ.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds of all six comparison functions.
//     Default 8; range 1..100000.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/hrx-system/blob/10b32fbacefe73b1a8a246a779bec17a411ca8cc/runtime/src/iree/hal/cts/queue/queue_atomic_test.cc
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/hip-tests/catch/unit/stream/hipStreamValue.cc
#include <thread>

#include "support/pm4.h"
using namespace torture;

int main(int argc, char** argv) {
  Start(argc, argv, "wait_comparisons");
  const uint32_t rounds = Option(argc, argv, "--iterations", 8, 100000);
  Device device(TEST_GFX);
  Buffer result(device, 4096);
  Queue waiter(device), control(device);
  // Unsigned LT, LE, EQ, NE, GE, GT. The upper bits deliberately disagree.
  const uint32_t blocked[] = {0, 6, 6, 4, 5, 4, 4};
  const uint32_t released[] = {0, 4, 5, 5, 4, 5, 6};
  uint32_t token = 0;
  for (uint32_t round = 0; round < rounds; ++round) {
    for (uint32_t comparison = 1; comparison <= 6; ++comparison) {
      result.Store(0, 0xa5a50000u | blocked[comparison]);
      Pm4 commands;
      commands.Write(result.address(64), ++token);  // Reached the wait.
      commands.WaitCompare(result.address(), 5, comparison, 0xffff);
      commands.Finish(result.address(128), token);
      waiter.Submit(commands.words);
      result.Wait(16, token, 10000, &waiter);
      Pm4 progress;
      progress.Finish(result.address(192), token);
      control.Submit(progress.words);
      result.Wait(48, token, 10000, &control);
      const uint64_t deadline = NowNs() + 1000000;
      while (NowNs() < deadline) {
        Check(result.Load(32) == token - 1, "false wait comparison passed");
        std::this_thread::yield();
      }
      result.Store(0, 0x5a5a0000u | released[comparison]);
      result.Wait(32, token, 10000, &waiter);
      waiter.Drain();
    }
  }
  control.Drain();
  Pass("wait_comparisons", token);
}
