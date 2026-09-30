// Purpose: Stress independent KFD processes/VMs with multiple active queues in each process.
// Run queue_flood workers concurrently so each validates its own payloads and completion.
// Check child exit status and propagate failures or skips through the parent.
//
// Parameters (decimal integers; ranges are inclusive):
//   --iterations N: queue_flood rounds in each worker process.
//     Default 64; range 1..100000.
//   --queues N: worker processes; each uses four PM4 queues.
//     Default 4; range 1..32.
//   --timeout N: process watchdog in seconds.
//     Default 45; range 1..3600.
//   --seed: accepted by the common parser but unused here.
// Progress waits retain their separate 10-second deadline.
// Keep queue_flood_gfx<arch> beside this binary; --timeout also applies to each worker.
//
// Inspiration: independent native-KFD adaptation of these public test patterns.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDHWSTest.cpp
// https://github.com/tinygrad/tinygrad/blob/c509335eaa34f60718a121a8ca1c1953777731b7/test/external/external_fuzz_hcq_mp.py
#include <signal.h>
#include <sys/prctl.h>
#include <sys/wait.h>
#include <unistd.h>

#include <cerrno>
#include <cstdio>
#include <cstdlib>
#include <string>

#include "support/kfd.h"

using namespace torture;

int main(int argc, char** argv) {
  Start(argc, argv, "multiprocess");
  const uint32_t count = Option(argc, argv, "--queues", 4, 32);
  const uint32_t iterations = Option(argc, argv, "--iterations", 64, 100000);
  // Fresh execs avoid inheriting a live KFD VM, allocations, or doorbells.
  char executable[4096];
  const ssize_t length = readlink("/proc/self/exe", executable, sizeof(executable) - 1);
  Check(length > 0 && size_t(length) < sizeof(executable) - 1, "resolve executable path");
  executable[length] = 0;
  std::string path(executable);
  path = path.substr(0, path.find_last_of('/') + 1) + "queue_flood_gfx" + std::to_string(TEST_GFX);
  const std::string rounds = std::to_string(iterations);
  const std::string timeout = std::to_string(Option(argc, argv, "--timeout", 45, 3600));
  const pid_t parent = getpid();
  std::vector<pid_t> children;
  for (uint32_t i = 0; i < count; ++i) {
    pid_t pid = fork();
    Check(pid >= 0, "fork failed");
    if (pid == 0) {
      if (prctl(PR_SET_PDEATHSIG, SIGKILL) != 0 || getppid() != parent) _exit(126);
      execl(path.c_str(), path.c_str(), "--queues", "4", "--iterations", rounds.c_str(),
            "--timeout", timeout.c_str(), nullptr);
      _exit(126);
    }
    children.push_back(pid);
  }
  bool failed = false;
  uint32_t skipped = 0;
  for (pid_t pid : children) {
    int status = 0;
    pid_t result;
    do {
      result = waitpid(pid, &status, 0);
    } while (result < 0 && errno == EINTR);
    if (result != pid || !WIFEXITED(status))
      failed = true;
    else if (WEXITSTATUS(status) == 77)
      ++skipped;
    else if (WEXITSTATUS(status) != 0)
      failed = true;
  }
  Check(!failed, "child process failed");
  if (skipped == count) return 77;
  Check(skipped == 0, "only some child processes found the GPU");
  Pass("multiprocess", count);
}
