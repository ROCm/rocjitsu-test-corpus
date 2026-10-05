// Purpose: Disable, submit to, resume and recreate an SDMA queue.
// A surviving PM4 queue must progress while SDMA is disabled. Check that copies
// and completion remain blocked, then validate all data and guards after resume.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDQMTest.cpp
#include <thread>

#include "pm4.h"
#include "support/sdma.h"
using namespace cts;
int main(int argc, char** argv) {
  Start(argc, argv, "sdma_queue_lifecycle");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device;
  Buffer source(device, 4096), target(device, 4096), fences(device, 4096);
  Queue survivor(device);
  for (uint32_t round = 1; round <= rounds; ++round) {
    SdmaQueue queue(device);
    for (uint32_t word = 0; word < 64; ++word) {
      source.Store(word, round * 65536 + word);
      target.Store(word, 0);
    }
    queue.SetEnabled(false);
    Sdma copy(device.gfx);
    copy.Acquire();
    copy.Copy(source.address(), target.address(), 63 * 4);
    copy.Finish(fences.address(), round);
    queue.Submit(copy.words);
    Pm4 ping;
    ping.Finish(fences.address(64), round);
    survivor.Submit(ping.words);
    fences.Wait(16, round, 10000, &survivor);
    const uint64_t deadline = NowNs() + 1000000;
    do {
      Check(fences.Load(0) == round - 1, "disabled SDMA completed");
      for (uint32_t word = 0; word < 64; ++word)
        Check(target.Load(word) == 0, "disabled SDMA wrote output");
      std::this_thread::yield();
    } while (NowNs() < deadline);
    queue.SetEnabled(true);
    fences.Wait(0, round);
    queue.Drain();
    for (uint32_t word = 0; word < 63; ++word)
      Check(target.Load(word) == round * 65536 + word, "resumed SDMA copy mismatch");
    Check(target.Load(63) == 0, "SDMA copy guard corrupted");
    survivor.Drain();
  }
  Pass("sdma_queue_lifecycle", rounds);
}
