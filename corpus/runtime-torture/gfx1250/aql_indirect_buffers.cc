// Purpose: Exercise AMD's AQL vendor-specific PM4 indirect-buffer escape.
// Alternate vendor IB packets with ordinary AQL barriers depending on their
// completions. Check each IB's distinct data and both completion signals, then
// reuse the backing only after retirement. Repeated batches wrap the AQL ring.
// Vendor PM4 IB packets use a plain AQL queue: the public metadata ABI
// defines dispatch and barrier companions, not PM4-IB companions.
// The IB body remains gfx1250 PM4; this is not a portable PM4 encoding.
//
// Parameters (decimal integers; ranges inclusive):
//   --iterations N: batches of 64 IB/barrier pairs; default 128; range 1..100000.
//   --timeout N: watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by the common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration and public packet layout: ROCr AqlQueue::ExecutePM4.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/runtime/hsa-runtime/core/runtime/amd_aql_queue.cpp
#include <cstring>

#include "support/aql.h"
#include "support/pm4.h"
using namespace torture;
struct VendorIb {
  uint16_t header, format;
  uint32_t jump[4], remaining, reserved[8];
  uint64_t completion;
};
struct Barrier {
  uint64_t header, dependencies[5], reserved, completion;
};
static_assert(sizeof(VendorIb) == 64 && offsetof(VendorIb, completion) == 56);
static_assert(sizeof(Barrier) == 64);
int main(int argc, char** argv) {
  Start(argc, argv, "aql_indirect_buffers");
  const uint32_t rounds = Option(argc, argv, "--iterations", 128, 100000);
  Device device(1250);
  Buffer result(device, 4096), indirect(device, 64 * 4096, true), signals(device, 128 * 64);
  Queue queue(device, 4096, 7, true, false, false);
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t ib = 0; ib < 64; ++ib) {
      ResetSignal(signals, ib * 128);
      ResetSignal(signals, ib * 128 + 64);
      Pm4 body;
      body.Write(result.address(ib * 4), round * 64 + ib);
      body.Pad();
      std::memcpy(static_cast<char*>(indirect.data) + ib * 4096, body.words.data(),
                  body.words.size() * 4);
      Pm4 jump;
      jump.Indirect(indirect.address(ib * 4096), body.words.size());
      VendorIb packet{};
      packet.header = (2u << 9) | (2u << 11);  // VENDOR_SPECIFIC=0, system fences.
      packet.format = 1;                       // AMD_AQL_FORMAT_PM4_IB.
      std::memcpy(packet.jump, jump.words.data(), sizeof(packet.jump));
      packet.remaining = 0xa;
      packet.completion = signals.address(ib * 128);
      queue.SubmitAql(&packet);
      Barrier after{};
      after.header = 3u | (1u << 8) | (2u << 9) | (2u << 11);
      after.dependencies[0] = packet.completion;
      after.completion = signals.address(ib * 128 + 64);
      queue.SubmitAql(&after);
    }
    for (uint32_t ib = 0; ib < 64; ++ib) {
      WaitSignal(signals, ib * 128 + 64, queue);
      WaitSignal(signals, ib * 128, queue);
      Check(result.Load(ib) == round * 64 + ib, "AQL vendor IB lost or corrupted data");
    }
    Check(result.Load(64) == 0, "AQL vendor IB guard corrupted");
    queue.Drain();
  }
  Pass("aql_indirect_buffers", uint64_t(rounds) * 64);
}
