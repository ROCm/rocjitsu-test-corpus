// Purpose: Test unsigned 64-bit timeline waits across a low-word carry and signal overshoot.
// Three reached waiters use distinct thresholds. An overshoot releases two
// while the largest remains blocked; a second signal releases the last. Check
// each payload snapshot and an already-satisfied smaller target.
//
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --iterations N: rounds.
//     Default 32; range 1..100000.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/blob/26513be3e0f711ed835ec50d5cdcb723ef224105/tests/syncobj_timeline.c
// https://github.com/KhronosGroup/VK-GL-CTS/blob/3905c821f43ded89284713187ffb3c7a1072afdb/external/vulkancts/modules/vulkan/synchronization/vktSynchronizationTimelineSemaphoreTests.cpp
#include <thread>

#include "pm4.h"
using namespace cts;
int main(int argc, char** argv) {
  Start(argc, argv, "pm4_timeline_points");
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  Device device;
  Buffer result(device, 4096);
  Queue first(device), second(device), third(device), producer(device);
  Queue* waiters[] = {&first, &second, &third};
  for (uint32_t round = 1; round <= rounds; ++round) {
    const uint64_t target = (uint64_t(round) << 32) + 5;
    const uint64_t thresholds[] = {target, target + 3, target + 20};
    result.Store64(0, target - 10);
    for (uint32_t q = 0; q < 3; ++q) {
      Pm4 commands;
      commands.Write(result.address(128 + q * 64), round);
      commands.Wait64(result.address(), thresholds[q]);
      commands.Barrier();
      commands.Copy(result.address(64), result.address(128 + q * 64 + 4));
      commands.Finish(result.address(128 + q * 64 + 8), round);
      waiters[q]->Submit(commands.words);
    }
    for (uint32_t q = 0; q < 3; ++q) result.Wait(32 + q * 16, round, 10000, waiters[q]);
    auto held = [&](uint32_t begin) {
      const uint64_t deadline = NowNs() + 1000000;
      do {
        for (uint32_t q = begin; q < 3; ++q)
          Check(result.Load(34 + q * 16) == round - 1, "timeline threshold released too early");
        std::this_thread::yield();
      } while (NowNs() < deadline);
    };
    held(0);
    Pm4 signal;
    signal.Write(result.address(64), round * 31337);
    signal.Barrier();
    signal.Exchange64(result.address(), target + 7);
    signal.Finish(result.address(384), round);
    producer.Submit(signal.words);
    result.Wait(96, round, 10000, &producer);
    for (uint32_t q = 0; q < 2; ++q) {
      result.Wait(34 + q * 16, round, 10000, waiters[q]);
      Check(result.Load(33 + q * 16) == round * 31337, "timeline overshoot payload mismatch");
    }
    held(2);
    Pm4 later;
    later.Write(result.address(64), round * 31337 + 1);
    later.Barrier();
    later.Exchange64(result.address(), target + 21);
    later.Finish(result.address(448), round);
    producer.Submit(later.words);
    result.Wait(66, round, 10000, &third);
    result.Wait(112, round, 10000, &producer);
    Check(result.Load(65) == round * 31337 + 1, "last timeline payload mismatch");
    Check(result.Load64(0) == target + 21, "final timeline value mismatch");
    Pm4 past;
    past.Wait64(result.address(), target - 1);
    past.Finish(result.address(512), round);
    first.Submit(past.words);
    result.Wait(128, round, 10000, &first);
    for (auto* waiter : waiters) waiter->Drain();
    producer.Drain();
    for (uint32_t q = 0; q < 3; ++q)
      Check(result.Load(35 + q * 16) == 0, "timeline snapshot guard corrupted");
  }
  Pass("pm4_timeline_points", uint64_t(rounds) * 4);
}
