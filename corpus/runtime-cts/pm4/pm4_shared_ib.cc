// Purpose: Stress concurrent replay of one immutable PM4 indirect buffer by
// multiple queues. Patch it only after all prior work retires, then replay with
// a different addend. Check exact atomic totals and guards for lost, duplicated
// or stale IB execution.
//
// Queue count defaults to the native CP capacity minus companion queues.
// Explicit --queues above that budget fails before queue creation.
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --iterations N: rounds.
//     Default 64; range 1..100000.
//   --queues N: PM4 queues.
//     Default/maximum: native capacity minus companion queues.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_test_hcq.py
// https://github.com/KhronosGroup/OpenCL-CTS/blob/9feccbb8fcb8eefeebf86a48036173a8155f9d21/test_conformance/extensions/cl_khr_command_buffer/command_buffer_pipelined_enqueue.cpp
#include <cstring>
#include <memory>

#include "pm4.h"
using namespace cts;

int main(int argc, char** argv) {
  Start(argc, argv, "pm4_shared_ib");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  const uint32_t count = QueueCount(argc, argv, 0);
  Device device;
  Buffer result(device, 4096), indirect(device, 4096, true);
  std::vector<std::unique_ptr<Queue>> queues;
  for (uint32_t q = 0; q < count; ++q) queues.emplace_back(new Queue(device));
  for (uint32_t round = 1; round <= rounds; ++round) {
    Pm4 body;
    // Patch a retired IB at the same GPU VA between rounds, then share it
    // immutably across all queues and many references in each ring.
    const uint32_t addend = 1 + round % 7;
    body.Add(result.address(), addend, false);
    body.Add(result.address(8), 1, false);
    body.Pad();
    std::memcpy(indirect.data, body.words.data(), body.words.size() * 4);
    const uint32_t before = result.Load(0);
    for (uint32_t q = 0; q < count; ++q) {
      Pm4 commands;
      commands.Barrier();
      for (uint32_t replay = 0; replay < 32; ++replay)
        commands.Indirect(indirect.address(), body.words.size());
      commands.Finish(result.address(64 + q * 4), round);
      queues[q]->Submit(commands.words);
    }
    for (uint32_t q = 0; q < count; ++q) {
      result.Wait(16 + q, round, 10000, queues[q].get());
      queues[q]->Drain();
    }
    Check(result.Load(0) == before + addend * count * 32,
          "IB patch/replay used stale commands");
    Check(result.Load(2) == round * count * 32,
          "IB replay lost or duplicated execution");
    Check(result.Load(1) == 0 && result.Load(3) == 0,
          "IB replay guard corrupted");
  }
  Pass("pm4_shared_ib", uint64_t(rounds) * count * 32);
}
