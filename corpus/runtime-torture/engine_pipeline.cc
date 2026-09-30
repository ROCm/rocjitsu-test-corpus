// Purpose: Test a pipeline of SDMA upload, PM4 atomics in private VRAM and SDMA download.
// Submit consumers first and connect each stage with per-slot GPU fences.
// Check every downloaded value and guards for broken dependencies or stale data.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds.
//     Default 64; range 1..100000.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/KhronosGroup/OpenCL-CTS/blob/9feccbb8fcb8eefeebf86a48036173a8155f9d21/test_conformance/extensions/cl_khr_command_buffer/command_buffer_pipelined_enqueue.cpp
// https://github.com/KhronosGroup/VK-GL-CTS/blob/3905c821f43ded89284713187ffb3c7a1072afdb/external/vulkancts/modules/vulkan/synchronization/vktSynchronizationOperationMultiQueueTests.cpp
#include "support/pm4.h"
#include "support/sdma.h"
using namespace torture;

int main(int argc, char** argv) {
  Start(argc, argv, "engine_pipeline");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device(TEST_GFX);
  constexpr uint32_t kSlots = 4, kWords = 64;
  Buffer input(device, kSlots * 4096), output(device, kSlots * 4096), fences(device, 4096);
  Buffer local(device, kSlots * 4096, false, true);
  SdmaQueue upload(device), download(device);
  Queue compute(device);
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t slot = 0; slot < kSlots; ++slot) {
      for (uint32_t word = 0; word < kWords; ++word) {
        input.Store(slot * 1024 + word, round * 65536 + slot * 256 + word);
        output.Store(slot * 1024 + word, 0);
      }
      // Download waits on compute; compute waits on upload. Publish in reverse
      // order, with several slots in flight and no host synchronization between stages.
      Sdma receive(device.gfx);
      receive.Wait(fences.address(slot * 64 + 4), round);
      receive.Acquire();
      receive.Copy(local.address(slot * 4096), output.address(slot * 4096), kWords * 4);
      receive.Finish(fences.address(slot * 64 + 8), round);
      download.Submit(receive.words);
      Pm4 transform;
      transform.Wait(fences.address(slot * 64), round);
      transform.Barrier();
      for (uint32_t word = 0; word < kWords; ++word)
        transform.Add(local.address(slot * 4096 + word * 4), 17, false);
      transform.Finish(fences.address(slot * 64 + 4), round);
      compute.Submit(transform.words);
      Sdma send(device.gfx);
      send.Acquire();
      send.Copy(input.address(slot * 4096), local.address(slot * 4096), kWords * 4);
      send.Finish(fences.address(slot * 64), round);
      upload.Submit(send.words);
    }
    for (uint32_t slot = 0; slot < kSlots; ++slot) {
      fences.Wait(slot * 16 + 2, round);
      for (uint32_t word = 0; word < kWords; ++word)
        Check(output.Load(slot * 1024 + word) == round * 65536 + slot * 256 + word + 17,
              "SDMA/compute pipeline consumed stale data");
      Check(output.Load(slot * 1024 + kWords) == 0, "pipeline output guard corrupted");
    }
  }
  upload.Drain();
  compute.Drain();
  download.Drain();
  Pass("engine_pipeline", rounds * kSlots * 3);
}
