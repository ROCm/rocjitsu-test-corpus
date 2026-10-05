// Purpose: Stress independent KFD processes/VMs with multiple active queues in each process.
// Run queue_flood workers concurrently so each validates its own payloads and completion.
// Workers rendezvous after queue creation and retain their queues/VMs until
// every worker reports checked completion. A parent deadline records phases,
// terminates failed groups and propagates child failures or device skips.
//
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; no effect on PM4 or SDMA queues.
//   --iterations N: queue_flood rounds in each worker process.
//     Default 64; range 1..100000.
//   --mode pm4: default pm4; use the AQL suite for AQL coverage.
//   --queues N: worker processes; each uses four queues.
//     Default 4; range 1..32.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
// Keep pm4_queue_flood_<target> beside this binary; --timeout also applies to each worker.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDHWSTest.cpp
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_fuzz_hcq_mp.py
#include "support/process_group.h"
using namespace cts;
int main(int argc, char** argv) {
  Start(argc, argv, "multiprocess", true);
  Check(!AqlMode(argc, argv), "use the AQL suite for AQL workers");
  return RunProcessGroup(argc, argv, "pm4_queue_flood_" CTS_TARGET_NAME);
}
