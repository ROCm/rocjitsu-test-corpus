// Purpose: Exercise native 64-bit SDMA memory polls and fences.
// Hold a consumer on a signal whose low word already matches but high word
// does not. Prove independent progress and blocked completion, then have the
// producer copy payload and signal with FENCE_64B. Check payload visibility,
// full-width completion and guards across low-word carry and ring reuse.
//
// Parameters (decimal integers; ranges inclusive):
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted but unused. Progress waits have a 10s deadline.
// Inspiration/encoding: public ROCr BuildPoll64bCommand / BuildFence64bCommand.
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/runtime/hsa-runtime/core/runtime/amd_blit_sdma.cpp
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/runtime/hsa-runtime/core/inc/sdma_registers.h
#include <thread>

#include "support/sdma.h"
using namespace torture;
int main(int argc, char** argv) {
  Start(argc, argv, "sdma_signal64");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device;
  Buffer source(device, 4096), shared(device, 4096), output(device, 4096), signals(device, 4096);
  SdmaQueue producer(device), consumer(device);
  for (uint32_t round = 1; round <= rounds; ++round) {
    const uint64_t token = 0xfffffff0ull + round;
    signals.Store64(0, token ^ (1ull << 32));
    signals.Store64(64, ~token);
    for (uint32_t word = 0; word < 63; ++word) {
      source.Store(word, round * 256 + word);
      output.Store(word, 0);
    }
    Sdma receive(device.gfx);
    receive.Wait64(signals.address(), token);
    receive.Acquire();
    receive.Copy(shared.address(), output.address(), 63 * 4);
    receive.Fence64(signals.address(64), token);
    receive.Finish(signals.address(128), round);
    consumer.Submit(receive.words);
    Sdma ping(device.gfx);
    ping.Fence64(signals.address(192), token);
    ping.Finish(signals.address(256), round);
    producer.Submit(ping.words);
    signals.Wait(64, round);
    Check(signals.Load64(192) == token, "independent SDMA fence truncated");
    const uint64_t deadline = NowNs() + 1000000;
    do {
      Check(signals.Load64(64) == ~token && signals.Load(32) == round - 1,
            "SDMA 64-bit wait ignored the high word");
      std::this_thread::yield();
    } while (NowNs() < deadline);
    Sdma send(device.gfx);
    send.Acquire();
    send.Copy(source.address(), shared.address(), 63 * 4);
    send.Fence64(signals.address(), token);
    send.Finish(signals.address(320), round);
    producer.Submit(send.words);
    signals.Wait(32, round);
    signals.Wait(80, round);
    Check(signals.Load64(0) == token && signals.Load64(64) == token,
          "SDMA full-width fence mismatch");
    for (uint32_t word = 0; word < 63; ++word)
      Check(output.Load(word) == round * 256 + word, "SDMA 64-bit handoff stale payload");
    Check(output.Load(63) == 0 && shared.Load(63) == 0, "SDMA handoff guard corrupted");
    producer.Drain();
    consumer.Drain();
  }
  Pass("sdma_signal64", rounds);
}
