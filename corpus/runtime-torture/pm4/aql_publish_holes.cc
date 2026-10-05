// Purpose: Publish AQL packets out of order around an INVALID head slot.
// Independent host threads publish disjoint slots; reservation stays single-threaded.
// Notify with the hole present, prove later packets remain blocked, then publish
// the head and repeat the SAME doorbell value. Sweep holes across ring wrap.
// This extends ROCr index-atomicity patterns to actual firmware consumption.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues N: reserved slots/publishers on ONE queue; default 7; range 1..32.
//   --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/rocrtst/suites/stress/queue_write_index_concurrent_tests.cc
#include <cstring>
#include <thread>

#include "support/aql.h"
#include "pm4.h"
#include "work_kernel.inc"
using namespace torture;
int main(int argc, char** argv) {
  Start(argc, argv, "aql_publish_holes");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  const uint32_t count = Option(argc, argv, "--queues", 7, 32);
  Device device;
  Buffer code(device, sizeof(kKernelImage), true), args(device, count * 512);
  Buffer result(device, count * 64), signals(device, count * 64), heartbeat(device, 4096);
  Check(kKernargBytes <= 512, "kernel arguments too large");
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  Queue queue(device, 4096, 7, true, true), independent(device);
  for (uint32_t round = 1; round <= rounds; ++round) {
    std::vector<Dispatch> packets(count);
    for (uint32_t slot = 0; slot < count; ++slot) {
      ResetSignal(signals, slot * 64);
      result.Store(slot * 16, 0xdeadbeef);
      result.Store(slot * 16 + 1, 0);
      Arguments arguments{result.address(slot * 64), result.address(slot * 64 + 4), round ^ slot,
                          17, round};
      std::memcpy(static_cast<char*>(args.data) + slot * 512, &arguments, sizeof(arguments));
      packets[slot] = OneGroup(code.address(kDescriptorOffset), args.address(slot * 512),
                               signals.address(slot * 64), false);
    }
    const uint64_t first = queue.ReserveAql(count);
    std::vector<std::thread> publishers;
    for (uint32_t slot = 1; slot < count; ++slot)
      publishers.emplace_back([&, slot] { queue.PublishAql(first + slot, &packets[slot]); });
    for (auto& publisher : publishers) publisher.join();
    queue.NotifyAql();
    Pm4 ping;
    ping.Finish(heartbeat.address(), round);
    independent.Submit(ping.words);
    heartbeat.Wait(0, round, 10000, &independent);
    const uint64_t deadline = NowNs() + 1000000;
    do {
      for (uint32_t slot = 0; slot < count; ++slot) {
        Check(signals.Load64(slot * 64 + 8) == 1, "packet completed beyond unpublished head");
        Check(result.Load(slot * 16) == 0xdeadbeef && result.Load(slot * 16 + 1) == 0,
              "packet executed beyond unpublished head");
      }
      std::this_thread::yield();
    } while (NowNs() < deadline);
    queue.PublishAql(first, &packets[0]);
    queue.NotifyAql();
    for (uint32_t slot = 0; slot < count; ++slot) {
      WaitSignal(signals, slot * 64, queue);
      Check(result.Load(slot * 16) == Advance(round ^ slot, 17),
            "published dispatch result mismatch");
      Check(result.Load(slot * 16 + 1) == round, "published dispatch marker missing");
      Check(result.Load(slot * 16 + 2) == 0, "dispatch guard corrupted");
    }
    queue.Drain();
    independent.Drain();
  }
  Pass("aql_publish_holes", uint64_t(rounds) * count);
}
