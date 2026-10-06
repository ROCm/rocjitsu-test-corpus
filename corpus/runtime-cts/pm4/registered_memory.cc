// Purpose: Register anonymous CPU pages as KFD USERPTR, copy through
// private VRAM and back, then unregister after SDMA retirement. Sweep odd
// offsets and page-crossing lengths; verify every byte and all guards across
// repeated registrations. Unlike GTT allocation churn this pins CPU-owned
// memory. No live unmap, page migration or forced eviction is attempted.
//
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; default off for AQL queues.
//   --mode pm4|aql: observer queue; default pm4. SDMA transport is retained.
//   The observer copies data through the tested mapping before host
//   verification.
//   --iterations N: rounds; default 2; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/blob/26513be3e0f711ed835ec50d5cdcb723ef224105/tests/amdgpu/amd_basic.c
#include <cstring>
#include <vector>

#include "pm4.h"
#include "support/aql_payload.h"
#include "support/sdma.h"
using namespace cts;
int main(int argc, char** argv) {
  Start(argc, argv, "registered_memory", true);
  const bool aql = AqlMode(argc, argv);
  const uint32_t rounds = Option(argc, argv, "--iterations", 2, 100000);
  Device device;
  constexpr uint32_t kBytes = 32768;
  Buffer local(device, kBytes, false, true), fence(device, 4096);
  SdmaQueue queue(device);
  AqlPayload observe(device, 1);
  Buffer snapshot(device, kBytes), observed(device, 4096);
  Queue observer(device, 4096, 7, aql);
  const uint32_t lengths[] = {1, 3, 4, 63, 4097, 16387};
  for (uint32_t round = 1; round <= rounds; ++round) {
    Buffer source(device, kBytes, false, false, true);
    Buffer target(device, kBytes, false, false, true);
    for (uint32_t word = 0; word < kBytes / 4; ++word)
      source.Store(word, round * 65536 + word);
    for (uint32_t test = 0; test < 6; ++test) {
      const uint32_t src = test & 1 ? 4093 : 1;
      const uint32_t dst = test & 1 ? 8191 : 3;
      const uint32_t bytes = lengths[test];
      std::memset(target.data, 0xcd, kBytes);
      std::vector<unsigned char> expected(kBytes, 0xcd);
      std::memcpy(expected.data() + dst, static_cast<char*>(source.data) + src,
                  bytes);
      Sdma commands(device.gfx);
      commands.Acquire();
      commands.Copy(source.address(src), local.address(), bytes);
      commands.Copy(local.address(), target.address(dst), bytes);
      const uint32_t token = round * 8 + test;
      commands.Finish(fence.address(), token);
      queue.Submit(commands.words);
      fence.Wait(0, token);
      if (aql) {
        observe.Prepare(0, snapshot.address(), 0, kBytes / 4, target.address());
        observe.Submit(observer, 0);
        observe.Wait(observer, 0);
      } else {
        Pm4 read;
        read.Barrier();
        read.DmaCopy(target.address(), snapshot.address(), kBytes);
        read.Finish(observed.address(), token);
        observer.Submit(read.words);
        observed.Wait(0, token, 10000, &observer);
      }
      observer.Drain();
      Check(std::memcmp(target.data, expected.data(), kBytes) == 0 &&
                std::memcmp(snapshot.data, expected.data(), kBytes) == 0,
            "registered-memory data/guard mismatch");
      queue.Drain();
    }
  }
  Pass("registered_memory", uint64_t(rounds) * 6);
}
