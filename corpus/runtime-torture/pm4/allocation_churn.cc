// Purpose: Exercise repeated allocation, GPU mapping and retirement with one persistent queue.
// Check writes at both ends of each buffer and untouched interior guards before
// unmapping/freeing completed allocations; this does not test eviction.
//
// Parameters (decimal integers; ranges are inclusive):
//   --mode pm4|aql: queue protocol; default pm4.
//   AQL uses ordinary dispatches and completion-signal barriers.
//   --iterations N: rounds.
//     Default 32; range 1..100000.
//   --queues N: buffers per round.
//     Default 16; range 1..64.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/blob/26513be3e0f711ed835ec50d5cdcb723ef224105/tests/amdgpu/amd_basic.c
#include <atomic>
#include <memory>
#include <thread>

#include "support/aql_payload.h"
#include "pm4.h"
using namespace torture;

static int RunPm4(int argc, char** argv) {
  Start(argc, argv, "allocation_churn", true);
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  const uint32_t width = Option(argc, argv, "--queues", 16, 64);
  Device device;
  Buffer completion(device, 4096);
  Queue queue(device);
  for (uint32_t round = 1; round <= rounds; ++round) {
    std::vector<std::unique_ptr<Buffer>> buffers;
    Pm4 commands;
    for (uint32_t i = 0; i < width; ++i) {
      buffers.emplace_back(new Buffer(device, 4096 * (1 + (round + i) % 4)));
      commands.Write(buffers.back()->address(), round * 256 + i);
      commands.Write(buffers.back()->address(buffers.back()->size - 4), ~(round * 256 + i));
    }
    commands.Finish(completion.address(), round);
    queue.Submit(commands.words);
    completion.Wait(0, round, 10000, &queue);
    queue.Drain();
    // Unmap/free only retired allocations, with a live queue retained across
    // rounds. Fresh mappings must not expose stale payloads or stale translations.
    for (uint32_t i = width; i-- > 0;) {
      Check(buffers[i]->Load(0) == round * 256 + i, "new allocation payload mismatch");
      Check(buffers[i]->Load(buffers[i]->size / 4 - 1) == ~(round * 256 + i),
            "allocation tail mismatch");
      for (size_t word = 1; word + 1 < buffers[i]->size / 4; ++word)
        Check(buffers[i]->Load(word) == 0, "allocation guard corrupted");
      buffers[i].reset();
    }
  }
  Pass("allocation_churn", uint64_t(rounds) * width);
  return 0;
}



int main(int argc, char** argv) {
  Check(!AqlMode(argc, argv), "use the AQL suite for this scenario in AQL mode");
  return RunPm4(argc, argv);
}
