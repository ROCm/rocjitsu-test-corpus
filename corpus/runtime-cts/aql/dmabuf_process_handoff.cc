// Purpose: Exchange GPU-produced data across independent KFD process VMs.
// Export GTT as DMA-BUF, inherit only that FD across exec, import at a fresh
// child VA, and close export FDs after import. Parent writes and signals;
// child waits, transforms through its alias and signals back. Verify data
// and guards each round, then retire both processes before freeing backing.
// The imported alias is CPU-readable too: metadata publication reads the
// completion signal's event ID before submitting its GPU address.
//
// Parameters (decimal integers; ranges are inclusive):
//   Queue protocol: AQL only.
//   AQL uses two signals per round, initialized before spawning the child.
//   --iterations N: rounds; default 64; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
//   --worker N seconds: internal exec mode; imports DMA-BUF from inherited FD 3.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/runtimes/rocddi/frontends/libamdf/examples/sdma-dmabuf-copy.c
#include <fcntl.h>
#include <linux/kfd_ioctl.h>
#include <signal.h>
#include <spawn.h>
#include <sys/mman.h>
#include <sys/prctl.h>
#include <sys/wait.h>
#include <unistd.h>

#include <cerrno>
#include <cstdio>
#include <cstring>
#include <thread>

#include "support/aql_payload.h"
using namespace cts;
extern char** environ;
static size_t SharedBytes(uint32_t rounds) {
  return 4096 + ((size_t(rounds) * 128 + 4095) & ~size_t{4095});
}
static int Worker(uint32_t rounds) {
  Check(prctl(PR_SET_PDEATHSIG, SIGKILL) == 0 && getppid() != 1, "worker parent disappeared");
  Device device;
  void* va = mmap(nullptr, SharedBytes(rounds), PROT_READ | PROT_WRITE, MAP_SHARED, 3, 0);
  Check(va != MAP_FAILED, "map DMA-BUF CPU alias for metadata");
  kfd_ioctl_import_dmabuf_args imported{};
  imported.va_addr = reinterpret_cast<uintptr_t>(va);
  imported.gpu_id = device.gpu_id;
  imported.dmabuf_fd = 3;
  device.Ioctl(AMDKFD_IOC_IMPORT_DMABUF, &imported, "IMPORT_DMABUF");
  close(3);
  kfd_ioctl_map_memory_to_gpu_args map{};
  map.handle = imported.handle;
  map.device_ids_array_ptr = reinterpret_cast<uintptr_t>(&device.gpu_id);
  map.n_devices = 1;
  device.Ioctl(AMDKFD_IOC_MAP_MEMORY_TO_GPU, &map, "MAP imported DMA-BUF");
  Check(map.n_success == 1, "partial DMA-BUF mapping");
  {
    Queue queue(device, 4096, 7, true);
    AqlPayload work(device, 1);
    for (uint32_t round = 1; round <= rounds; ++round) {
      const uint64_t signals = imported.va_addr + 4096 + size_t(round - 1) * 128;
      work.Prepare(0, imported.va_addr + 256, 17, 63, imported.va_addr + 256);
      AqlWait(queue, signals);
      work.Submit(queue, 0, signals + 64);
      AqlWait(queue, 0, work.Signal(0));
      work.Wait(queue, 0);
      queue.Drain();
    }
  }
  kfd_ioctl_unmap_memory_from_gpu_args unmap{};
  unmap.handle = imported.handle;
  unmap.device_ids_array_ptr = reinterpret_cast<uintptr_t>(&device.gpu_id);
  unmap.n_devices = 1;
  device.Ioctl(AMDKFD_IOC_UNMAP_MEMORY_FROM_GPU, &unmap, "UNMAP imported DMA-BUF");
  Check(unmap.n_success == 1, "partial DMA-BUF unmapping");
  kfd_ioctl_free_memory_of_gpu_args free{};
  free.handle = imported.handle;
  device.Ioctl(AMDKFD_IOC_FREE_MEMORY_OF_GPU, &free, "FREE imported DMA-BUF");
  Check(munmap(va, SharedBytes(rounds)) == 0, "release imported VA");
  return 0;
}
int main(int argc, char** argv) {
  const bool worker = argc == 4 && !std::strcmp(argv[1], "--worker");
  if (worker) {
    char iterations_option[] = "--iterations", timeout_option[] = "--timeout";
    char* worker_argv[] = {argv[0], iterations_option, argv[2], timeout_option, argv[3]};
    Start(5, worker_argv, "dmabuf_worker");
    return Worker(Option(5, worker_argv, "--iterations", 64, 100000));
  }
  Start(argc, argv, "dmabuf_process_handoff");
  const uint32_t rounds = Option(argc, argv, "--iterations", 64, 100000);
  Device device;
  Buffer shared(device, SharedBytes(rounds));
  Queue queue(device, 4096, 7, true);
  AqlPayload work(device, 1);
  // Each round owns two signals, avoiding resets racing the other process.
  for (uint32_t r = 0; r < rounds; ++r) {
    ResetSignal(shared, 4096 + size_t(r) * 128);
    ResetSignal(shared, 4096 + size_t(r) * 128 + 64);
  }
  kfd_ioctl_export_dmabuf_args exported{};
  exported.handle = shared.handle;
  exported.flags = O_RDWR | O_CLOEXEC;
  device.Ioctl(AMDKFD_IOC_EXPORT_DMABUF, &exported, "EXPORT_DMABUF");
  posix_spawn_file_actions_t actions;
  Check(posix_spawn_file_actions_init(&actions) == 0, "spawn actions init");
  Check(posix_spawn_file_actions_adddup2(&actions, exported.dmabuf_fd, 3) == 0,
        "spawn DMA-BUF descriptor");
  if (exported.dmabuf_fd != 3)
    Check(posix_spawn_file_actions_addclose(&actions, exported.dmabuf_fd) == 0,
          "spawn close original DMA-BUF");
  char path[] = "/proc/self/exe", mode[] = "--worker", iterations[32], timeout[32];
  std::snprintf(iterations, sizeof(iterations), "%u", rounds);
  std::snprintf(timeout, sizeof(timeout), "%u", Option(argc, argv, "--timeout", 45, 3600));
  char* child_argv[] = {path, mode, iterations, timeout, nullptr};
  pid_t child;
  Check(posix_spawn(&child, path, &actions, nullptr, child_argv, environ) == 0, "spawn importer");
  posix_spawn_file_actions_destroy(&actions);
  close(exported.dmabuf_fd);
  for (uint32_t round = 1; round <= rounds; ++round) {
    const uint64_t signals = shared.address(4096 + size_t(round - 1) * 128);
    work.Prepare(0, shared.address(256), round * 65536, 63);
    work.Submit(queue, 0, signals);
    AqlWait(queue, signals + 64, work.Signal(0));
    work.Wait(queue, 0);
    for (uint32_t word = 0; word < 63; ++word)
      Check(shared.Load(64 + word) == round * 65536 + word + 17,
            "interprocess GPU handoff mismatch");
    Check(shared.Load(127) == 0 && shared.Load(63) == 0, "DMA-BUF guard corrupted");
    queue.Drain();
  }
  const uint64_t deadline = NowNs() + 10000000000ull;
  int status = 0;
  for (;;) {
    const pid_t result = waitpid(child, &status, WNOHANG);
    if (result == child) break;
    Check(result == 0 || (result < 0 && errno == EINTR), "waitpid importer");
    Check(NowNs() < deadline, "importer teardown timeout");
    std::this_thread::yield();
  }
  Check(WIFEXITED(status) && WEXITSTATUS(status) == 0, "DMA-BUF importer failed");
  Pass("dmabuf_process_handoff", rounds);
}
