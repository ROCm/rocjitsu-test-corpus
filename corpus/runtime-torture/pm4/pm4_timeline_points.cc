// Purpose: Test unsigned 64-bit timeline waits across a low-word carry and signal overshoot.
// Require an unsatisfied wait to block, a later signal value to release it, and
// an already-satisfied smaller target to complete; check dependent payload visibility.
//
// Parameters (decimal integers; ranges are inclusive):
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
using namespace torture;

int main(int argc, char** argv) {
  Start(argc, argv, "pm4_timeline_points");
  const uint32_t rounds = Option(argc, argv, "--iterations", 32, 100000);
  Device device;
  Buffer result(device, 4096);
  Queue waiter(device), producer(device);
  for (uint32_t round = 1; round <= rounds; ++round) {
    // Low word carry and large initial values: no 32-bit truncation is valid.
    uint64_t target = (uint64_t(round) << 32) + 5;
    result.Store64(0, target - 10);
    Pm4 commands;
    commands.Write(result.address(64), round);
    commands.Wait64(result.address(), target);
    commands.Barrier();
    commands.Copy(result.address(128), result.address(192));
    commands.Finish(result.address(256), round);
    waiter.Submit(commands.words);
    result.Wait(16, round, 10000, &waiter);
    const uint64_t deadline = NowNs() + 1000000;
    while (NowNs() < deadline) {
      Check(result.Load(64) == round - 1, "timeline wait passed before its target");
      std::this_thread::yield();
    }
    Pm4 signal;
    signal.Write(result.address(128), round * 31337);
    signal.Barrier();
    // Signal a later point: equality-based waits would hang here.
    signal.Exchange64(result.address(), target + 7);
    signal.Finish(result.address(320), round);
    producer.Submit(signal.words);
    result.Wait(64, round, 10000, &waiter);
    result.Wait(80, round, 10000, &producer);
    Check(result.Load(48) == round * 31337 && result.Load64(0) == target + 7,
          "timeline signal or payload mismatch");
    // A wait for an already satisfied, smaller value must also complete.
    Pm4 past;
    past.Wait64(result.address(), target - 1);
    past.Finish(result.address(384), round);
    waiter.Submit(past.words);
    result.Wait(96, round, 10000, &waiter);
    waiter.Drain();
    producer.Drain();
  }
  Pass("pm4_timeline_points", rounds * 2);
}
