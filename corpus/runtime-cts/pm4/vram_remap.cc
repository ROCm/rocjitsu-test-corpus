// Purpose: Preserve private VRAM contents across GPU unmap/remap.
// Retire upload references, unmap the BO without freeing it, prove another
// queue still progresses, remap and read all bytes through SDMA. This tests
// mapping restoration separately from allocation churn and ordinary copies.
//
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; default off for AQL queues.
//   --mode pm4|aql: observer queue; default pm4. SDMA transport is retained.
//   The observer copies data through the tested mapping before host verification.
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDLocalMemoryTest.cpp
#include <linux/kfd_ioctl.h>

#include "support/aql_payload.h"
#include "pm4.h"
#include "support/sdma.h"
using namespace cts;
int main(int argc, char** argv) {
  Start(argc, argv, "vram_remap", true);
  const bool aql = AqlMode(argc, argv);
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  constexpr uint32_t kBytes = 65536;
  Device device;
  Buffer source(device, kBytes), output(device, kBytes), local(device, kBytes, false, true);
  Buffer fences(device, 4096);
  SdmaQueue transfer(device);
  Queue survivor(device);
  AqlPayload observe(device, 1);
  Buffer snapshot(device, kBytes), observed(device, 4096);
  Queue observer(device, 4096, 7, aql);
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t word = 0; word < kBytes / 4; ++word) {
      source.Store(word, round * 65536 + word);
      output.Store(word, 0);
    }
    Sdma upload(device.gfx);
    upload.Acquire();
    upload.Copy(source.address(), local.address(), kBytes);
    upload.Finish(fences.address(), round);
    transfer.Submit(upload.words);
    fences.Wait(0, round);
    transfer.Drain();
    kfd_ioctl_unmap_memory_from_gpu_args unmap{};
    unmap.handle = local.handle;
    unmap.device_ids_array_ptr = reinterpret_cast<uintptr_t>(&device.gpu_id);
    unmap.n_devices = 1;
    device.Ioctl(AMDKFD_IOC_UNMAP_MEMORY_FROM_GPU, &unmap, "UNMAP retained VRAM");
    Check(unmap.n_success == 1, "partial retained VRAM unmap");
    Pm4 ping;
    ping.Finish(fences.address(64), round);
    survivor.Submit(ping.words);
    fences.Wait(16, round, 10000, &survivor);
    kfd_ioctl_map_memory_to_gpu_args map{};
    map.handle = local.handle;
    map.device_ids_array_ptr = reinterpret_cast<uintptr_t>(&device.gpu_id);
    map.n_devices = 1;
    device.Ioctl(AMDKFD_IOC_MAP_MEMORY_TO_GPU, &map, "REMAP retained VRAM");
    Check(map.n_success == 1, "partial retained VRAM remap");
    Sdma download(device.gfx);
    download.Acquire();
    download.Copy(local.address(), output.address(), kBytes);
    download.Finish(fences.address(128), round);
    transfer.Submit(download.words);
    fences.Wait(32, round);
    if (aql) {
      observe.Prepare(0, snapshot.address(), 0, kBytes / 4, local.address());
      observe.Submit(observer, 0);
      observe.Wait(observer, 0);
    } else {
      Pm4 read;
      read.Barrier();
      read.DmaCopy(local.address(), snapshot.address(), kBytes);
      read.Finish(observed.address(), round);
      observer.Submit(read.words);
      observed.Wait(0, round, 10000, &observer);
    }
    observer.Drain();
    for (uint32_t word = 0; word < kBytes / 4; ++word)
      Check(
          output.Load(word) == round * 65536 + word && snapshot.Load(word) == round * 65536 + word,
          "VRAM contents changed across remapping");
    transfer.Drain();
    survivor.Drain();
  }
  Pass("vram_remap", rounds);
}
