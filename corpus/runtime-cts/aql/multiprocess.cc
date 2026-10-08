// Purpose: Stress independent KFD processes/VMs with multiple active queues in
// each process. Run queue_flood workers concurrently so each validates its own
// payloads and completion. Workers rendezvous after queue creation and retain
// their queues/VMs until every worker reports checked completion. A parent
// deadline records phases, terminates failed groups and propagates child
// failures or device skips.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: queue_flood rounds in each worker process.
//     Default 2; range 1..100000.
//   Queue protocol: AQL only.
//   --queues N: worker processes; default min(4, native CP capacity).
//     Range 2..native CP capacity. Workers split the full machine queue
//     capacity, distributing any remainder; their combined count never exceeds
//     it.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
//   --aql-metadata off|on: gfx1250 only; default off.
// Progress waits retain their separate 10-second deadline.
// Keep aql_queue_flood_<target> beside this binary; --timeout also applies to
// each worker.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDHWSTest.cpp
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_fuzz_hcq_mp.py
#include "support/process_group.h"
using namespace cts;
int main(int argc, char** argv) {
  Start(argc, argv, "multiprocess");
  return RunProcessGroup(argc, argv, "aql_queue_flood_" CTS_TARGET_NAME);
}
