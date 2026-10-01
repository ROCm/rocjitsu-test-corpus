// Purpose: Have a PM4 queue publish and launch AQL dispatches.
// CPU reserves slots but never writes their headers or rings the AQL doorbell.
// CP DMA uploads payload, WRITE_DATA commits header last, then 64-bit
// RELEASE_MEM writes the index and GPU-mapped doorbell. Check shader output,
// completion and ring reuse; prepared packets live until both queues retire.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDQMTest.cpp
#include <cstring>

#include "support/aql.h"
#include "support/pm4.h"
#include "work_kernel.inc"
using namespace torture;
// Public PM4Packet.cpp InitPacketNV / InitPacketGfx125x: data-after-confirm
// without an interrupt, using one 64-bit write for the doorbell.
static void Release64(Pm4& commands, uint64_t address, uint64_t value) {
  const uint32_t gcr = ((1u << 10) | (1u << 9) | (1u << 8) | 12u);
  const size_t first = commands.words.size();
  commands.Packet(0x49,
                  {0x14u | (5u << 8) | (gcr << 12), (3u << 24) | (2u << 29), uint32_t(address),
                   uint32_t(address >> 32), uint32_t(value), uint32_t(value >> 32), 0});
  commands.words[first] |= 2;
}
int main(int argc, char** argv) {
  Start(argc, argv, "aql_gpu_queue_producer");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device(1201);
  Buffer code(device, sizeof(kKernelImage), true), args(device, 4096);
  Buffer packets(device, 4096), result(device, 4096), signals(device, 4096);
  Check(kKernargBytes <= 512, "kernel arguments too large");
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  Queue target(device, 4096, 7, true), producer(device);
  const uint64_t doorbell = target.GpuDoorbellAddress();
  for (uint32_t round = 1; round <= rounds; ++round) {
    ResetSignal(signals, 0);
    Arguments arguments{result.address(), result.address(256), round * 17, 31, round};
    std::memcpy(args.data, &arguments, sizeof(arguments));
    Dispatch packet =
        OneGroup(code.address(kDescriptorOffset), args.address(), signals.address(), false);
    packet.grid_x = 63;
    std::memcpy(packets.data, &packet, sizeof(packet));
    const uint64_t index = target.ReserveAql(1);
    const uint64_t slot = target.AqlSlotAddress(index);
    Pm4 commands;
    commands.DmaCopy(packets.address(4), slot + 4, 60);
    commands.Barrier();
    commands.Write(slot, packet.header_setup);
    commands.Barrier();
    Release64(commands, target.AqlWriteIndexAddress(), index + 1);
    Release64(commands, doorbell, index);
    commands.Finish(result.address(512), round);
    producer.Submit(commands.words);
    WaitSignal(signals, 0, target);
    result.Wait(128, round, 10000, &producer);
    for (uint32_t group = 0; group < 63; ++group) {
      Check(result.Load(group) == Advance((round * 17) ^ group, 31),
            "GPU-produced dispatch mismatch");
      Check(result.Load(64 + group) == round, "GPU-produced shader marker missing");
    }
    Check(result.Load(63) == 0 && result.Load(127) == 0, "GPU-produced dispatch guard corrupted");
    target.Drain();
    producer.Drain();
  }
  Pass("aql_gpu_queue_producer", rounds);
}
