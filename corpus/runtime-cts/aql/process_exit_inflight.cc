// Purpose: Kill a child with a published, blocked AQL queue.
// A parent queue must progress before and after SIGKILL, and a fresh queue
// must work after process teardown. Child exec occurs before its KFD setup;
// parent-death signaling prevents abandoned workers. No bad packets or GPU
// reset are used. This covers blocked queue teardown, not live-wave CWSR.
//
// Parameters (decimal integers; ranges are inclusive):
//   Queue protocol: AQL only.
//   --iterations N: rounds; default 2; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
//   --worker seconds: internal exec mode; readiness on inherited FD 3.
//   --aql-metadata off|on: gfx1250 only; default off.
// Progress waits have a separate 10-second deadline.
// Inspiration: independent direct-KFD adaptation of public workload patterns.
// https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/blob/26513be3e0f711ed835ec50d5cdcb723ef224105/tests/amdgpu/amd_close_race.c
#include <fcntl.h>
#include <poll.h>
#include <signal.h>
#include <spawn.h>
#include <sys/prctl.h>
#include <sys/wait.h>
#include <unistd.h>

#include <cerrno>
#include <cstring>
#include <thread>

#include "support/aql_payload.h"
using namespace cts;
extern char** environ;
static int Worker(int argc, char** argv) {
  Check(prctl(PR_SET_PDEATHSIG, SIGKILL) == 0 && getppid() != 1,
        "worker parent disappeared");
  Start(argc, argv, "process_exit_worker");
  Device device;
  Buffer memory(device, 4096);
  Queue queue(device, 4096, 7, true);
  AqlPayload work(device, 2);
  Buffer gate(device, 4096);
  ResetSignal(gate, 0);
  work.Prepare(0, memory.address(), 1);
  work.Prepare(1, memory.address(128), 1);
  work.Submit(queue, 0);
  work.Wait(queue, 0);
  AqlWait(queue, gate.address());
  work.Submit(queue, 1);
  memory.Wait(0, 1, 10000, &queue);
  Check(memory.Load(32) == 0, "worker did not block");
  const char ready = 'R';
  Check(write(3, &ready, 1) == 1, "worker readiness pipe");
  close(3);
  for (;;) pause();
}
int main(int argc, char** argv) {
  if (argc >= 3 && !std::strcmp(argv[1], "--worker")) {
    char timeout_option[] = "--timeout";
    argv[1] = timeout_option;
    return Worker(argc, argv);
  }
  Start(argc, argv, "process_exit_inflight");
  const uint32_t rounds = Option(argc, argv, "--iterations", 2, 100000);
  Device device;
  Buffer memory(device, 4096);
  Queue survivor(device, 4096, 7, true);
  AqlPayload work(device, 2);
  for (uint32_t round = 1; round <= rounds; ++round) {
    int pipefd[2];
    Check(pipe2(pipefd, O_CLOEXEC) == 0, "create readiness pipe");
    posix_spawn_file_actions_t actions;
    Check(posix_spawn_file_actions_init(&actions) == 0, "spawn actions init");
    Check(posix_spawn_file_actions_adddup2(&actions, pipefd[1], 3) == 0,
          "spawn ready descriptor");
    if (pipefd[0] != 3)
      Check(posix_spawn_file_actions_addclose(&actions, pipefd[0]) == 0,
            "spawn close reader");
    if (pipefd[1] != 3)
      Check(posix_spawn_file_actions_addclose(&actions, pipefd[1]) == 0,
            "spawn close writer");
    char path[] = "/proc/self/exe", worker[] = "--worker";
    char timeout[32];
    std::snprintf(timeout, sizeof(timeout), "%u",
                  Option(argc, argv, "--timeout", 45, 3600));
    char metadata_option[] = "--aql-metadata";
    char* child_argv[] = {path,
                          worker,
                          timeout,
                          AqlMetadataMode() ? metadata_option : nullptr,
                          const_cast<char*>(AqlMetadataMode()),
                          nullptr};
    pid_t child;
    Check(
        posix_spawn(&child, path, &actions, nullptr, child_argv, environ) == 0,
        "spawn worker");
    posix_spawn_file_actions_destroy(&actions);
    close(pipefd[1]);
    pollfd ready{pipefd[0], POLLIN, 0};
    int polled;
    do {
      polled = poll(&ready, 1, 10000);
    } while (polled < 0 && errno == EINTR);
    char value = 0;
    Check(polled == 1 && read(pipefd[0], &value, 1) == 1 && value == 'R',
          "worker did not publish blocked queue");
    close(pipefd[0]);
    work.Prepare(0, memory.address(), round * 2);
    work.Submit(survivor, 0);
    work.Wait(survivor, 0);
    survivor.Drain();
    Check(kill(child, SIGKILL) == 0, "kill blocked worker");
    const uint64_t deadline = NowNs() + 10000000000ull;
    int status = 0;
    for (;;) {
      const pid_t reaped = waitpid(child, &status, WNOHANG);
      if (reaped == child) break;
      Check(reaped == 0 || (reaped < 0 && errno == EINTR), "waitpid worker");
      Check(NowNs() < deadline, "blocked queue process teardown timeout");
      std::this_thread::yield();
    }
    Check(WIFSIGNALED(status) && WTERMSIG(status) == SIGKILL,
          "worker exited before intended kill");
    Queue replacement(device, 4096, 7, true);
    work.Prepare(0, memory.address(), round * 2 + 1);
    work.Prepare(1, memory.address(64), round);
    work.Submit(survivor, 0);
    work.Submit(replacement, 1);
    work.Wait(survivor, 0);
    work.Wait(replacement, 1);
    Check(memory.Load(0) == round * 2 + 1 && memory.Load(16) == round,
          "AQL post-exit data mismatch");
    survivor.Drain();
  }
  Pass("process_exit_inflight", rounds);
}
