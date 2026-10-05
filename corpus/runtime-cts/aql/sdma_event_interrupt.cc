// Purpose: Exercise GPU interrupt delivery, KFD event reuse and auto-reset.
// Uses SDMA FENCE+TRAP, never host SET_EVENT.
// Submit independent payloads on several queues, wait for all events via ioctl,
// verify every payload, then confirm events were consumed. Repeat twice per
// event generation and recreate events each round. This tests notifications
// as well as memory completion; no polling fallback or retry masks failure.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues N: event-producing queues; default 2; range 1..4.
//   --seed: accepted by common parser but unused.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDQMTest.cpp
#include <linux/kfd_ioctl.h>

#include <cstdio>
#include <memory>

#include "support/sdma.h"
using namespace cts;
int main(int argc, char** argv) {
  const char* name = "sdma_event_interrupt";
  Start(argc, argv, name);
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  const uint32_t count = Option(argc, argv, "--queues", 2, 4);
  Device device;
  // KFD retains its signal-page BO until process teardown and rejects FREE
  // even after all events are destroyed. Keep this one bounded allocation
  // alive until exit; the kernel releases it with the process VM.
  Buffer& page = *new Buffer(device, KFD_SIGNAL_EVENT_LIMIT * 8);
  Buffer source(device, count * 4096);
  Buffer result(device, count * 4096);
  std::vector<std::unique_ptr<SdmaQueue>> sdma;
  for (uint32_t q = 0; q < count; ++q) {
    sdma.emplace_back(new SdmaQueue(device));
  }
  for (uint32_t round = 1; round <= rounds; ++round) {
    std::vector<kfd_ioctl_create_event_args> events(count);
    std::vector<kfd_event_data> waits(count);
    for (uint32_t q = 0; q < count; ++q) {
      auto& event = events[q];
      if (round == 1 && q == 0) event.event_page_offset = page.handle;
      event.event_type = KFD_IOC_EVENT_SIGNAL;
      event.auto_reset = 1;
      device.Ioctl(AMDKFD_IOC_CREATE_EVENT, &event, "CREATE_EVENT");
      Check(event.event_slot_index < KFD_SIGNAL_EVENT_LIMIT, "event slot outside signal page");
      waits[q].event_id = event.event_id;
    }
    kfd_ioctl_wait_events_args wait{};
    wait.events_ptr = reinterpret_cast<uintptr_t>(waits.data());
    wait.num_events = count;
    wait.wait_for_all = 1;
    // An event must start unsignaled, and auto-reset after each successful wait.
    for (uint32_t phase = 0; phase < 2; ++phase) {
      wait.timeout = 0;
      wait.wait_for_all = 0;
      device.Ioctl(AMDKFD_IOC_WAIT_EVENTS, &wait, "WAIT_EVENTS initially unsignaled");
      Check(wait.wait_result == KFD_IOC_WAIT_RESULT_TIMEOUT, "new or consumed event is signaled");
      for (uint32_t q = 0; q < count; ++q) {
        const uint32_t token = round * 65536 + phase * 4096 + q * 256;
        for (uint32_t word = 0; word < 63; ++word) {
          source.Store(q * 1024 + word, token + word);
          result.Store(q * 1024 + word, 0);
        }
        const uint64_t address = page.address(events[q].event_slot_index * 8);
        const uint32_t id = events[q].event_trigger_data;
        Sdma commands(device.gfx);
        commands.Acquire();
        commands.Copy(source.address(q * 4096), result.address(q * 4096), 63 * 4);
        commands.Finish(address, id);
        commands.words.insert(commands.words.end(), {6, id & 0x0fffffffu});
        commands.words.resize((commands.words.size() + 31) & ~size_t{31}, 0);
        sdma[q]->Submit(commands.words);
      }
      wait.timeout = 10000;
      wait.wait_for_all = 1;
      device.Ioctl(AMDKFD_IOC_WAIT_EVENTS, &wait, "WAIT_EVENTS GPU interrupt");
      if (wait.wait_result != KFD_IOC_WAIT_RESULT_COMPLETE) {
        for (uint32_t q = 0; q < count; ++q) {
          std::fprintf(stderr, "round=%u phase=%u event=%u trigger=%u slot=%u value=%llu data=%u\n",
                       round, phase, events[q].event_id, events[q].event_trigger_data,
                       events[q].event_slot_index,
                       (unsigned long long)page.Load64(events[q].event_slot_index * 8),
                       result.Load(q * 1024));
        }
        Fail("GPU event interrupt timeout");
      }
      for (uint32_t q = 0; q < count; ++q) {
        for (uint32_t word = 0; word < 63; ++word)
          Check(result.Load(q * 1024 + word) == round * 65536 + phase * 4096 + q * 256 + word,
                "event signaled before payload became visible");
        Check(result.Load(q * 1024 + 63) == 0, "interrupt payload guard corrupted");
        sdma[q]->Drain();
      }
    }
    wait.timeout = 0;
    wait.wait_for_all = 0;
    device.Ioctl(AMDKFD_IOC_WAIT_EVENTS, &wait, "WAIT_EVENTS auto-reset");
    Check(wait.wait_result == KFD_IOC_WAIT_RESULT_TIMEOUT, "auto-reset left an event signaled");
    for (auto& event : events) {
      kfd_ioctl_destroy_event_args destroy{};
      destroy.event_id = event.event_id;
      device.Ioctl(AMDKFD_IOC_DESTROY_EVENT, &destroy, "DESTROY_EVENT");
    }
  }
  Pass(name, uint64_t(rounds) * count * 2);
}
