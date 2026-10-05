// Purpose: Exercise SDMA upload -> compute -> SDMA download through private
// VRAM. Submit consumers first, with GPU dependencies between stages and no
// host wait between them. AQL transforms data in a shader and signals
// firmware dispatch completion to SDMA. Verify payloads and untouched guards.
//
// Parameters (decimal integers; ranges inclusive):
//   Queue protocol: AQL only.
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
#include "support/sdma.h"
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
  Start(argc, argv, "engine_pipeline");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  constexpr uint32_t kSlots = 4, kWords = 256, kStride = 8192, kGuard = 0xdeadbeef;
  Device device;
  Buffer code(device, sizeof(kKernelImage), true), args(device, kSlots * 512);
  Buffer source(device, kSlots * kStride), result(device, kSlots * kStride);
  Buffer local(device, kSlots * kStride, false, true), signals(device, 4096);
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  Check(kKernargBytes <= 512, "kernel arguments too large");
  SdmaQueue upload(device), download(device);
  Queue compute(device, 4096, 7, true);
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t slot = 0; slot < kSlots; ++slot) {
      const uint32_t base = slot * kStride;
      for (uint32_t word = 0; word < kStride / 4; ++word) {
        source.Store(base / 4 + word, word < kWords ? round * 65536 + slot * 256 + word : kGuard);
        result.Store(base / 4 + word, 0);
      }
      ResetSignal(signals, slot * 192);
      ResetSignal(signals, slot * 192 + 64);
      Sdma receive(device.gfx);
      receive.Wait(signals.address(slot * 192 + 64 + 8), 0);
      receive.Acquire();
      receive.Copy(local.address(base), result.address(base), kStride);
      receive.Finish(signals.address(slot * 192 + 128), round);
      download.Submit(receive.words);
      BarrierPacket wait{};
      wait.header = 3u | (1u << 8) | (2u << 9) | (2u << 11);
      wait.dependencies[0] = signals.address(slot * 192);
      compute.SubmitAql(&wait);
      PipelineArguments arguments{local.address(base), local.address(base + 4096), round ^ slot,
                                  kWords, round};
      std::memcpy(static_cast<char*>(args.data) + slot * 512, &arguments, sizeof(arguments));
      Dispatch packet = OneGroup(code.address(kDescriptorOffset), args.address(slot * 512),
                                 signals.address(slot * 192 + 64), true);
      packet.workgroup_x = 64;
      packet.grid_x = kWords;
      compute.SubmitAql(&packet);
      Sdma send(device.gfx);
      send.Acquire();
      send.Copy(source.address(base), local.address(base), kStride);
      send.Finish(signals.address(slot * 192 + 8), 0);
      upload.Submit(send.words);
    }
    for (uint32_t slot = 0; slot < kSlots; ++slot) {
      signals.Wait((slot * 192 + 128) / 4, round);
      WaitSignal(signals, slot * 192 + 64, compute);
      for (uint32_t word = 0; word < kStride / 4; ++word) {
        uint32_t expected = kGuard;
        if (word < kWords) expected = round * 65536 + slot * 256 + word;
        if (word >= 1024 && word < 1024 + kWords)
          expected = Advance((round * 65536 + slot * 256 + word - 1024) ^ (round ^ slot), 3);
        Check(result.Load(slot * kStride / 4 + word) == expected,
              "shader/SDMA pipeline data or guard mismatch");
      }
    }
    upload.Drain();
    compute.Drain();
    download.Drain();
  }
  Pass("engine_pipeline", uint64_t(rounds) * kSlots * kWords);
  return 0;
}
