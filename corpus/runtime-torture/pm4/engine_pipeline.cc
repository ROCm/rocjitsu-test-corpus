// Purpose: Exercise SDMA upload -> compute -> SDMA download through private
// VRAM. Submit consumers first, with GPU dependencies between stages and no
// host wait between them. PM4 uses atomics and per-slot GPU fences. AQL
// (formerly shader_sdma_pipeline) transforms data in a shader and signals
// firmware dispatch completion to SDMA. Verify payloads and untouched guards.
//
// Parameters (decimal integers; ranges inclusive):
//   --mode pm4|aql: default pm4.
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted but unused.
// Progress waits have a separate 10-second deadline.
//
// Inspiration: independent direct-KFD adaptations of these public patterns.
// https://github.com/KhronosGroup/OpenCL-CTS/blob/9feccbb8fcb8eefeebf86a48036173a8155f9d21/test_conformance/extensions/cl_khr_command_buffer/command_buffer_pipelined_enqueue.cpp
// https://github.com/KhronosGroup/VK-GL-CTS/blob/3905c821f43ded89284713187ffb3c7a1072afdb/external/vulkancts/modules/vulkan/synchronization/vktSynchronizationOperationMultiQueueTests.cpp
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_test_hcq.py
#include <cstring>

#include "pipeline_kernel.inc"
#include "support/aql.h"
#include "pm4.h"
#include "support/sdma.h"
using namespace torture;

static int RunPm4(int argc, char** argv) {
  Start(argc, argv, "engine_pipeline", true);
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device;
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
      for (uint32_t word = 0; word < kWords; ++word) {
        const uint32_t expected = round * 65536 + slot * 256 + word + 17;
        const uint32_t observed = output.Load(slot * 1024 + word);
        if (observed != expected)
          Fail("SDMA/compute pipeline mismatch round=%u slot=%u word=%u expected=%x observed=%x",
               round, slot, word, expected, observed);
      }
      Check(output.Load(slot * 1024 + kWords) == 0, "pipeline output guard corrupted");
    }
  }
  upload.Drain();
  compute.Drain();
  download.Drain();
  Pass("engine_pipeline", rounds * kSlots * 3);
  return 0;
}

using namespace torture;
struct PipelineArguments {
  uint64_t input, output;
  uint32_t salt, count, token;
};
struct BarrierPacket {
  uint64_t header;
  uint64_t dependencies[5];
  uint64_t reserved, completion;
};
static_assert(sizeof(BarrierPacket) == 64);


int main(int argc, char** argv) {
  Check(!AqlMode(argc, argv), "use the AQL suite for this scenario in AQL mode");
  return RunPm4(argc, argv);
}
