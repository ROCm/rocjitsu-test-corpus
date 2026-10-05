// Purpose: Test AQL barrier dependencies and completion signals using five real signal handles.
// The AND binary must wait for all five; the OR binary must finish after any one.
// After the barrier, dispatch a shader that copies all AND payloads or only
// the known OR winner. Check data visibility, blocked completion, remaining
// signals, completion underflow and untouched output guards.
//
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; default off for AQL queues.
//   --iterations N: rounds.
//     Default 32; range 1..100000.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/rocrtst/suites/functional/signal_wait_multi.cc
// https://github.com/KhronosGroup/VK-GL-CTS/blob/3905c821f43ded89284713187ffb3c7a1072afdb/external/vulkancts/modules/vulkan/synchronization/vktSynchronizationTimelineSemaphoreTests.cpp
#include <thread>

#include "pm4.h"
#include "support/aql_payload.h"
using namespace cts;

// AMD AQL barrier packets use five handles to firmware-visible 64-byte signals.
// All five handles are populated so OR does not accidentally pass on a null slot.
struct BarrierPacket {
  uint16_t header;
  uint16_t reserved0;
  uint32_t reserved1;
  uint64_t dependencies[5];
  uint64_t reserved2;
  uint64_t completion;
};
static_assert(sizeof(BarrierPacket) == 64);
static_assert(offsetof(BarrierPacket, completion) == 56);

int main(int argc, char** argv) {
  constexpr bool kAny = AQL_WAIT_ANY;
  const char* name = kAny ? "aql_barrier_or" : "aql_barrier_and";
  Start(argc, argv, name);
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  Device device;
  Buffer signals(device, 4096), result(device, 4096), payload(device, 4096);
  AqlPayload consumer(device, 1);
  Queue waiter(device, 4096, 7, true), producer(device);
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t s = 0; s < 6; ++s) {
      signals.Store64(s * 64, 1);  // AMD_SIGNAL_KIND_USER.
      signals.Store64(s * 64 + 8, 1);
    }
    const uint32_t decisive = round % 5;
    for (uint32_t s = 0; s < 5; ++s) {
      payload.Store(s, 0);
      result.Store(128 + s, 0);
    }
    consumer.Prepare(0, result.address(512), 0, kAny ? 1 : 5,
                     payload.address(kAny ? decisive * 4 : 0));
    BarrierPacket packet{};
    packet.header = (kAny ? 5u : 3u) | (1u << 8) | (2u << 9) | (2u << 11);
    for (uint32_t s = 0; s < 5; ++s) packet.dependencies[s] = signals.address(s * 64);
    packet.completion = signals.address(5 * 64);
    waiter.SubmitAql(&packet);
    consumer.Submit(waiter, 0);
    // Alternate which signal is decisive; mix host and GPU signaling. AND
    // must remain blocked even with four satisfied dependencies. OR must
    // finish with the other four still unsatisfied.
    Pm4 partial;
    if (!kAny) {
      for (uint32_t s = 0; s < 5; ++s)
        if (s != decisive) {
          partial.Write(payload.address(s * 4), round * 31337 + s);
          partial.Barrier();
          partial.Exchange64(signals.address(s * 64 + 8), 0);
        }
    }
    partial.Finish(result.address(), round);
    producer.Submit(partial.words);
    result.Wait(0, round, 10000, &producer);
    const uint64_t deadline = NowNs() + 1000000;
    while (NowNs() < deadline) {
      Check(signals.Load64(5 * 64 + 8) == 1, "AQL barrier completed with unsatisfied dependencies");
      std::this_thread::yield();
    }
    if (round & 1) {
      payload.Store(decisive, round * 31337 + decisive);
      __asm__ __volatile__("sfence" ::: "memory");
      signals.Store64(decisive * 64 + 8, 0);
    } else {
      Pm4 release;
      release.Write(payload.address(decisive * 4), round * 31337 + decisive);
      release.Barrier();
      release.Exchange64(signals.address(decisive * 64 + 8), 0);
      release.Finish(result.address(64), round);
      producer.Submit(release.words);
      result.Wait(16, round, 10000, &producer);
    }
    signals.Wait((5 * 64 + 8) / 4, 0, 10000, &waiter);
    Check(signals.Load64(5 * 64 + 8) == 0, "AQL completion signal underflow");
    for (uint32_t s = 0; s < 5; ++s)
      Check(signals.Load64(s * 64 + 8) == uint64_t(kAny && s != decisive),
            "dependency signal corrupted");
    consumer.Wait(waiter, 0);
    for (uint32_t s = 0; s < (kAny ? 1u : 5u); ++s)
      Check(result.Load(128 + s) == round * 31337 + (kAny ? decisive : s),
            "barrier consumer saw stale producer payload");
    for (uint32_t s = kAny ? 1 : 5; s < 16; ++s)
      Check(result.Load(128 + s) == 0, "barrier consumer guard corrupted");
    waiter.Drain();
    producer.Drain();
  }
  Pass(name, rounds);
}
