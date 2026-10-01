// Shared CLI, deadlines and result checks; no GPU programming policy.
// Process watchdog and monotonic deadline API references:
// https://pubs.opengroup.org/onlinepubs/9799919799/functions/alarm.html
// https://pubs.opengroup.org/onlinepubs/9799919799/functions/clock_gettime.html
#include "common/test.h"

#include <signal.h>
#include <unistd.h>

#include <cerrno>
#include <cstdarg>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>

namespace torture {
namespace {
void Watchdog(int) {
  constexpr char message[] = "FAIL process watchdog expired\n";
  (void)!write(STDERR_FILENO, message, sizeof(message) - 1);
  _exit(124);
}
}  // namespace

[[noreturn]] void Fail(const char* format, ...) {
  std::fputs("FAIL ", stderr);
  va_list args;
  va_start(args, format);
  std::vfprintf(stderr, format, args);
  va_end(args);
  std::fputc('\n', stderr);
  std::fflush(nullptr);
  // On failure, let KFD process teardown retire queues before freeing BOs.
  // Unwinding individual buffers after a timeout could free live GPU storage.
  std::_Exit(1);
}
void Check(bool condition, const char* message) {
  if (!condition) Fail("%s", message);
}
uint64_t NowNs() {
  timespec t{};
  Check(clock_gettime(CLOCK_MONOTONIC, &t) == 0, "clock_gettime");
  return uint64_t(t.tv_sec) * 1000000000 + t.tv_nsec;
}
uint32_t Option(int argc, char** argv, const char* name, uint32_t fallback, uint32_t maximum) {
  for (int i = 1; i < argc; ++i) {
    if (std::strcmp(argv[i], name)) continue;
    Check(i + 1 < argc, "missing option value");
    char* end = nullptr;
    errno = 0;
    unsigned long value = std::strtoul(argv[i + 1], &end, 10);
    if (errno || !*argv[i + 1] || *end || !value || value > maximum)
      Fail("invalid %s value: %s (1..%u)", name, argv[i + 1], maximum);
    return static_cast<uint32_t>(value);
  }
  return fallback;
}
void Start(int argc, char** argv, const char* test, bool modes) {
  for (int i = 1; i < argc; i += 2) {
    const bool known = !std::strcmp(argv[i], "--iterations") || !std::strcmp(argv[i], "--queues") ||
                       !std::strcmp(argv[i], "--timeout") || !std::strcmp(argv[i], "--seed") ||
                       (modes && !std::strcmp(argv[i], "--mode"));
    if (!known || i + 1 == argc)
      Fail("usage: %s [--iterations N] [--queues N] [--timeout seconds] [--seed N]%s", argv[0],
           modes ? " [--mode pm4|aql]" : "");
  }
  if (modes) std::printf("mode=%s\n", AqlMode(argc, argv) ? "aql" : "pm4");
  signal(SIGALRM, Watchdog);
  alarm(Option(argc, argv, "--timeout", 45, 3600));
  std::printf("RUN %s pid=%d\n", test, getpid());
  std::fflush(stdout);
}
bool AqlMode(int argc, char** argv) {
  for (int i = 1; i < argc; ++i) {
    if (std::strcmp(argv[i], "--mode")) continue;
    Check(i + 1 < argc, "missing --mode value");
    if (!std::strcmp(argv[i + 1], "aql")) return true;
    if (!std::strcmp(argv[i + 1], "pm4")) return false;
    Fail("invalid --mode: %s (expected pm4 or aql)", argv[i + 1]);
  }
  return false;
}
void Pass(const char* test, uint64_t operations) {
  std::printf("PASS %s operations=%llu\n", test, (unsigned long long)operations);
}

}  // namespace torture
