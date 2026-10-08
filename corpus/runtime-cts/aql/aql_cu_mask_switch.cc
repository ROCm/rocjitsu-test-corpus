// Purpose: Change a live AQL queue between disjoint masks, one WGP per XCC.
// Retire each dispatch before updating the mask. Every workgroup reports its
// hardware WGP identity; require exactly num_xcc identities, disjoint sets for
// different masks, and identical sets on later visits. gfx1250 uses one mask
// bit per WGP, interleaved across XCCs. Keep every XCC enabled for AQL
// dispatch; an all-zero mask on another XCC does not provide a single-XCC
// dispatch mode. The reported identity includes SE/AID information. A second
// queue keeps a fixed mask while the first changes, detecting mask leakage.
// Restore the first queue to the full mask each round; check valid results
// without requiring every eligible WGP to execute work. WGP identity provides
// the placement oracle without relying on timing.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 2; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues N: disjoint masks on ONE queue; default all WGPs per XCC.
//     Range 2..the detected WGP count per XCC.
//   --seed: accepted by common parser but unused.
//   --aql-metadata off|on: gfx1250 only; default off.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDQMTest.cpp
// gfx1250 mask ABI (extendedCuMaskingXcc):
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDQMTest.cpp
#include <algorithm>
#include <cstring>
#include <set>

#include "placement_kernel.inc"
#include "support/aql.h"
using namespace cts;
int main(int argc, char** argv) {
  Start(argc, argv, "aql_cu_mask_switch");
  const uint32_t rounds = Option(argc, argv, "--iterations", 2, 100000);
  Device device;
  const uint32_t mask_bits =
      device.Property("simd_count") / device.Property("simd_per_cu");
  const uint32_t wgps = mask_bits / kCuMaskBitsPerWgp;
  const uint32_t xccs = device.Property("num_xcc");
  Check(xccs && xccs <= 64 && !(wgps % xccs), "unsupported WGP/XCC topology");
  const uint32_t count =
      Option(argc, argv, "--queues", wgps / xccs, wgps / xccs);
  Check(count >= 2 && count <= wgps / xccs,
        "requires 2..available WGP masks per XCC");
  Buffer code(device, sizeof(kKernelImage), true), args(device, 4096);
  Buffer output(device, 4096), signals(device, 4096);
  Check(kKernargBytes <= 512, "kernel arguments too large");
  std::memcpy(code.data, kKernelImage, sizeof(kKernelImage));
  Queue queue(device, 4096, 7, true), peer(device, 4096, 7, true);
  Buffer peer_args(device, 4096), peer_output(device, 4096),
      peer_signals(device, 4096);
  std::vector<std::set<uint64_t>> identities(count);
  std::vector<uint32_t> mask((mask_bits + 31) / 32);
  auto dispatch = [&](Queue& target, Buffer& arguments, Buffer& output,
                      Buffer& signals, uint32_t token) {
    ResetSignal(signals, 0);
    for (uint32_t word = 0; word < 128; ++word) output.Store(word, 0xffffffffu);
    Arguments a{output.address(), output.address(1024), 0, 0, token};
    std::memcpy(arguments.data, &a, sizeof(a));
    Dispatch packet = OneGroup(code.address(kDescriptorOffset),
                               arguments.address(), signals.address(), true);
    packet.grid_x = 64;
    target.SubmitAql(&packet);
    WaitSignal(signals, 0, target);
    std::set<uint64_t> observed;
    for (uint32_t group = 0; group < 64; ++group) {
      const uint64_t identity = output.Load64(group * 8);
      Check(identity != ~uint64_t{0}, "placement shader did not write");
      observed.insert(identity);
      Check(output.Load(256 + group) == token, "placement marker missing");
    }
    Check(output.Load(128) == 0 && output.Load(320) == 0,
          "placement guard corrupted");
    target.Drain();
    return observed;
  };
  auto select = [&](uint32_t selected) {
    std::fill(mask.begin(), mask.end(), 0);
    for (uint32_t xcc = 0; xcc < xccs; ++xcc) {
      const uint32_t bit = (selected * xccs + xcc) * kCuMaskBitsPerWgp;
      mask[bit / 32] |= ((1u << kCuMaskBitsPerWgp) - 1) << (bit % 32);
    }
  };
  select(count - 1);
  peer.SetCuMask(mask);
  const auto peer_identities =
      dispatch(peer, peer_args, peer_output, peer_signals, 1);
  Check(peer_identities.size() == xccs, "peer mask selected wrong WGP count");
  for (uint32_t round = 1; round <= rounds; ++round) {
    for (uint32_t step = 0; step < count; ++step) {
      const uint32_t selected = round & 1 ? step : count - 1 - step;
      select(selected);
      queue.SetCuMask(mask);
      const auto observed = dispatch(queue, args, output, signals, round);
      if (observed.size() != xccs)
        Fail("mask=%u round=%u expected %u WGP identities, observed %zu",
             selected, round, xccs, observed.size());
      if (round == 1) {
        for (const auto& previous : identities)
          for (uint64_t identity : observed)
            Check(!previous.count(identity),
                  "disjoint masks selected the same WGP");
        identities[selected] = observed;
      } else
        Check(identities[selected] == observed,
              "CU mask update selected stale WGP set");
      Check(dispatch(peer, peer_args, peer_output, peer_signals, round + 1) ==
                peer_identities,
            "CU mask update leaked into peer queue");
    }
    std::fill(mask.begin(), mask.end(), ~uint32_t{0});
    if (mask_bits % 32) mask.back() = (1u << (mask_bits % 32)) - 1;
    queue.SetCuMask(mask);
    (void)dispatch(queue, args, output, signals, round);
    Check(dispatch(peer, peer_args, peer_output, peer_signals, round + 1) ==
              peer_identities,
          "full-mask restore leaked into peer queue");
  }
  Pass("aql_cu_mask_switch", uint64_t(rounds) * (2 * count + 2) + 1);
}
