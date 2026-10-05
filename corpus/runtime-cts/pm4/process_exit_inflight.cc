// Purpose: Kill a child with a published, blocked PM4 or AQL queue.
// A parent queue must progress before and after SIGKILL, and a fresh queue
// must work after process teardown. Child exec occurs before its KFD setup;
// parent-death signaling prevents abandoned workers. No bad packets or GPU
// reset are used. This covers blocked queue teardown, not live-wave CWSR.
//
// Parameters (decimal integers; ranges are inclusive):
//   --aql-metadata off|on: gfx1250 only; default off for AQL queues.
//   --mode pm4|aql: blocked queue and survivor protocol; default pm4.
//   --iterations N: rounds; default 16; range 1..100000.
//   --timeout N: process watchdog seconds; default 45; range 1..3600.
//   --queues and --seed: accepted by common parser but unused.
//   --worker mode seconds: internal exec mode; readiness on inherited FD 3.
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
#include "pm4.h"
using namespace cts;
extern char** environ;
static int Worker(int argc, char** argv) {
  const bool aql = AqlMode(argc, argv);
  Check(prctl(PR_SET_PDEATHSIG, SIGKILL) == 0 && getppid() != 1, "worker parent disappeared");
  Start(argc, argv, "process_exit_worker", true);
  Device device;
  Buffer memory(device, 4096);
  Queue queue(device, 4096, 7, aql);
  AqlPayload work(device, 2);
  Buffer gate(device, 4096);
  if (aql) {
    ResetSignal(gate, 0);
    work.Prepare(0, memory.address(), 1);
    work.Prepare(1, memory.address(128), 1);
    work.Submit(queue, 0);
    work.Wait(queue, 0);
    AqlWait(queue, gate.address());
    work.Submit(queue, 1);
  } else {
    Pm4 commands;
    commands.Write(memory.address(), 1);
    commands.Wait(memory.address(64), 1);
    commands.Finish(memory.address(128), 1);
    queue.Submit(commands.words);
  }
  memory.Wait(0, 1, 10000, &queue);
  Check(memory.Load(32) == 0, "worker did not block");
  const char ready = 'R';
  Check(write(3, &ready, 1) == 1, "worker readiness pipe");
  close(3);
  for (;;) pause();
}
int main(int argc, char** argv) {
  if (argc >= 4 && !std::strcmp(argv[1], "--worker")) {
    char mode_option[] = "--mode", timeout_option[] = "--timeout";
    std::vector<char*> worker_argv = {argv[0], mode_option, argv[2], timeout_option, argv[3]};
    worker_argv.insert(worker_argv.end(), argv + 4, argv + argc);
    return Worker(worker_argv.size(), worker_argv.data());
  }
  Start(argc, argv, "process_exit_inflight", true);
  const bool aql = AqlMode(argc, argv);
  const uint32_t rounds = Option(argc, argv, "--iterations", 16, 100000);
  Device device;
  Buffer memory(device, 4096);
  Queue survivor(device, 4096, 7, aql);
  AqlPayload work(device, 2);
  for (uint32_t round = 1; round <= rounds; ++round) {
    int pipefd[2];
    Check(pipe2(pipefd, O_CLOEXEC) == 0, "create readiness pipe");
    posix_spawn_file_actions_t actions;
    Check(posix_spawn_file_actions_init(&actions) == 0, "spawn actions init");
    Check(posix_spawn_file_actions_adddup2(&actions, pipefd[1], 3) == 0, "spawn ready descriptor");
    if (pipefd[0] != 3)
      Check(posix_spawn_file_actions_addclose(&actions, pipefd[0]) == 0, "spawn close reader");
    if (pipefd[1] != 3)
      Check(posix_spawn_file_actions_addclose(&actions, pipefd[1]) == 0, "spawn close writer");
    char path[] = "/proc/self/exe", worker[] = "--worker";
    char pm4_mode[] = "pm4", aql_mode[] = "aql", timeout[32];
    std::snprintf(timeout, sizeof(timeout), "%u", Option(argc, argv, "--timeout", 45, 3600));
    char metadata_option[] = "--aql-metadata";
    char* child_argv[] = {path, worker, aql ? aql_mode : pm4_mode, timeout,
                         AqlMetadataMode() ? metadata_option : nullptr,
                         const_cast<char*>(AqlMetadataMode()), nullptr};
    pid_t child;
    Check(posix_spawn(&child, path, &actions, nullptr, child_argv, environ) == 0, "spawn worker");
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
    if (aql) {
      work.Prepare(0, memory.address(), round * 2);
      work.Submit(survivor, 0);
      work.Wait(survivor, 0);
      survivor.Drain();
    } else {
      Pm4 ping;
      ping.Finish(memory.address(), round * 2);
      survivor.Submit(ping.words);
      memory.Wait(0, round * 2, 10000, &survivor);
    }
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
    Check(WIFSIGNALED(status) && WTERMSIG(status) == SIGKILL, "worker exited before intended kill");
    Queue replacement(device, 4096, 7, aql);
    if (aql) {
      work.Prepare(0, memory.address(), round * 2 + 1);
      work.Prepare(1, memory.address(64), round);
      work.Submit(survivor, 0);
      work.Submit(replacement, 1);
      work.Wait(survivor, 0);
      work.Wait(replacement, 1);
      Check(memory.Load(0) == round * 2 + 1 && memory.Load(16) == round,
            "AQL post-exit data mismatch");
    } else {
      Pm4 after;
      after.Finish(memory.address(), round * 2 + 1);
      survivor.Submit(after.words);
      memory.Wait(0, round * 2 + 1, 10000, &survivor);

      Pm4 fresh;
      fresh.Finish(memory.address(64), round);
      replacement.Submit(fresh.words);
      memory.Wait(16, round, 10000, &replacement);
    }
    survivor.Drain();
  }
  Pass("process_exit_inflight", rounds);
}
