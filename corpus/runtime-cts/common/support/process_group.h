// Multiprocess queue lifetime coordination. Workers exec before opening KFD.
// Ready/start and done/release handshakes retain every VM until all work is
// checked. A completed worker must not change the runlist while another worker
// is still active.
// https://github.com/ROCm/rocm-systems/blob/fa643819f9139a3af5223e57686d07df1c560b64/projects/rocr-runtime/libhsakmt/tests/kfdtest/src/KFDHWSTest.cpp
#ifndef CTS_PROCESS_GROUP_H_
#define CTS_PROCESS_GROUP_H_
#include <poll.h>
#include <signal.h>
#include <sys/prctl.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <unistd.h>

#include <cerrno>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <vector>

#include "common/test.h"
namespace cts {
// Private exec channel. Standalone queue_flood has no rendezvous.
inline void WorkerPhase(char phase) {
  const char* channel = std::getenv("CTS_WORKER_CHANNEL");
  if (!channel) return;
  char* end = nullptr;
  const long fd = std::strtol(channel, &end, 10);
  Check(*channel && !*end && fd >= 0 && fd <= 0x7fffffff,
        "invalid worker channel");
  Check(send(int(fd), &phase, 1, MSG_NOSIGNAL) == 1, "notify worker phase");
  char release = 0;
  ssize_t n;
  do {
    n = read(int(fd), &release, 1);
  } while (n < 0 && errno == EINTR);
  Check(n == 1 && release == phase, "parent did not release worker phase");
}
inline int RunProcessGroup(int argc, char** argv, const char* sibling) {
  const uint32_t count = Option(argc, argv, "--queues", 4, 32);
  const std::string rounds =
      std::to_string(Option(argc, argv, "--iterations", 64, 100000));
  const uint32_t seconds = Option(argc, argv, "--timeout", 45, 3600);
  const std::string timeout = std::to_string(seconds);
  char executable[4096];
  const ssize_t length =
      readlink("/proc/self/exe", executable, sizeof(executable) - 1);
  Check(length > 0 && size_t(length) < sizeof(executable) - 1,
        "resolve executable path");
  executable[length] = 0;
  std::string path(executable);
  path = path.substr(0, path.find_last_of('/') + 1) + sibling;
  struct Child {
    pid_t pid;
    int fd;
    int status = 0;
    bool reaped = false;
    char phase = 0;
  };
  std::vector<Child> children;
  const pid_t parent = getpid();
  // The supervisor owns cleanup. Its deadline replaces the exit-only process
  // watchdog.
  alarm(0);
  const uint64_t deadline = NowNs() + uint64_t(seconds) * 1000000000;
  bool failed = false;
  for (uint32_t i = 0; i < count; ++i) {
    int channel[2];
    if (socketpair(AF_UNIX, SOCK_STREAM, 0, channel) != 0) {
      failed = true;
      break;
    }
    const pid_t pid = fork();
    if (pid < 0) {
      close(channel[0]);
      close(channel[1]);
      failed = true;
      break;
    }
    if (!pid) {
      close(channel[0]);
      for (const auto& child : children) close(child.fd);
      if (prctl(PR_SET_PDEATHSIG, SIGKILL) != 0 || getppid() != parent)
        _exit(126);
      const std::string fd = std::to_string(channel[1]);
      if (setenv("CTS_WORKER_CHANNEL", fd.c_str(), 1) != 0) _exit(126);
      execl(path.c_str(), path.c_str(), "--queues", "4", "--iterations",
            rounds.c_str(), "--timeout", timeout.c_str(),
            AqlMetadataMode() ? "--aql-metadata" : nullptr, AqlMetadataMode(),
            nullptr);
      _exit(126);
    }
    close(channel[1]);
    children.push_back({pid, channel[0]});
  }
  uint32_t skipped = 0;
  for (char phase : {'R', 'D'}) {
    if (failed) break;
    for (auto& child : children) {
      while (NowNs() < deadline) {
        pollfd event{child.fd, POLLIN, 0};
        const int ready = poll(&event, 1, 20);
        if (ready < 0 && errno == EINTR) continue;
        if (ready < 0) {
          failed = true;
          break;
        }
        if (!ready) continue;
        char received = 0;
        const ssize_t n = read(child.fd, &received, 1);
        if (n == 1 && received == phase) {
          child.phase = phase;
          break;
        }
        // EOF can be an unsupported-device skip before ready; preserve that
        // result.
        if (n == 0 && phase == 'R') {
          pid_t reaped;
          do {
            reaped = waitpid(child.pid, &child.status, WNOHANG);
          } while (reaped < 0 && errno == EINTR);
          if (reaped == 0) continue;
          child.reaped = reaped == child.pid;
          if (child.reaped && WIFEXITED(child.status) &&
              WEXITSTATUS(child.status) == 77) {
            ++skipped;
            break;
          }
        }
        failed = true;
        break;
      }
      if (!child.reaped && child.phase != phase) failed = true;
      if (failed) break;
    }
    if (skipped) {
      failed = skipped != count;
      break;
    }
    if (failed) break;
    for (auto& child : children)
      if (send(child.fd, &phase, 1, MSG_NOSIGNAL) != 1) failed = true;
  }
  if (failed)
    for (const auto& child : children)
      std::fprintf(stderr, "worker pid=%d last_phase=%c reaped=%d\n", child.pid,
                   child.phase ? child.phase : '-', child.reaped);
  for (auto& child : children) {
    if (failed && !child.reaped) kill(child.pid, SIGKILL);
    close(child.fd);
  }
  auto reap_until = [&](uint64_t limit) {
    for (auto& child : children) {
      while (!child.reaped && NowNs() < limit) {
        const pid_t n = waitpid(child.pid, &child.status, WNOHANG);
        if (n == child.pid) {
          child.reaped = true;
          break;
        }
        if (n < 0 && errno != EINTR) break;
        poll(nullptr, 0, 1);
      }
    }
  };
  reap_until(failed ? NowNs() + 2000000000ull : deadline);
  bool unreaped = false;
  for (const auto& child : children) {
    if (!child.reaped) {
      std::fprintf(stderr,
                   "worker pid=%d last_phase=%c exit deadline expired\n",
                   child.pid, child.phase ? child.phase : '-');
      kill(child.pid, SIGKILL);
      failed = unreaped = true;
    }
  }
  if (unreaped) reap_until(NowNs() + 2000000000ull);
  for (const auto& child : children) {
    const bool skipped_before_ready = child.phase == 0 &&
                                      WIFEXITED(child.status) &&
                                      WEXITSTATUS(child.status) == 77;
    if (!child.reaped || !WIFEXITED(child.status) ||
        (WEXITSTATUS(child.status) != 0 && !skipped_before_ready)) {
      std::fprintf(stderr,
                   "worker pid=%d last_phase=%c reaped=%d wait_status=%x\n",
                   child.pid, child.phase ? child.phase : '-', child.reaped,
                   child.status);
      failed = true;
    }
  }
  Check(!failed, "multiprocess worker or rendezvous failed");
  if (skipped == count) return 77;
  Pass("multiprocess", count);
  return 0;
}
}  // namespace cts
#endif
