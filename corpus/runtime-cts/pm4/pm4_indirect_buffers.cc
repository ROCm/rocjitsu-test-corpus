// Purpose: Stress execution of many distinct PM4 indirect buffers and return to the ring.
// Keep each IB immutable until completion and check every IB's distinct output
// to detect skipped, stale or corrupted command streams.
//
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --iterations N: batches of 64 indirect buffers.
//     Default 128; range 1..100000.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/torvalds/linux/blob/551c722f40809618230001baccf219193e22fc5a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
// https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/blob/26513be3e0f711ed835ec50d5cdcb723ef224105/tests/amdgpu/amd_cs_nop.c
#include <cstring>

#include "pm4.h"

using namespace cts;

int main(int argc, char** argv) {
  Start(argc, argv, "pm4_indirect_buffers");
  const uint32_t iterations = Option(argc, argv, "--iterations", 128, 100000);
  Device device;
  Buffer result(device, 4096);
  Buffer indirect(device, 64 * 4096, true);
  Queue queue(device);
  for (uint32_t round = 1; round <= iterations; ++round) {
    Pm4 ring;
    for (uint32_t ib = 0; ib < 64; ++ib) {
      Pm4 commands;
      // Distinct IBs remain immutable until the final GPU completion.
      commands.Write(result.address(ib * 4), round * 64 + ib);
      commands.Pad();
      std::memcpy(static_cast<char*>(indirect.data) + ib * 4096, commands.words.data(),
                  commands.words.size() * 4);
      ring.Indirect(indirect.address(ib * 4096), commands.words.size());
    }
    ring.Finish(result.address(2048), round);
    queue.Submit(ring.words);
    result.Wait(512, round);
    for (uint32_t ib = 0; ib < 64; ++ib)
      Check(result.Load(ib) == round * 64 + ib, "indirect buffer skipped or corrupted");
  }
  queue.Drain();
  Pass("pm4_indirect_buffers", uint64_t(iterations) * 64);
}
