// Shared CLI, target checks, deadlines and result checks.
// Process watchdog and monotonic deadline API references:
// https://pubs.opengroup.org/onlinepubs/9799919799/functions/alarm.html
// https://pubs.opengroup.org/onlinepubs/9799919799/functions/clock_gettime.html
#ifndef CTS_COMMON_TEST_H_
#define CTS_COMMON_TEST_H_
#include <cstdint>

namespace cts {
[[noreturn]] void Fail(const char* format, ...);
void Check(bool condition, const char* message);
uint64_t NowNs();
uint32_t Option(int argc, char** argv, const char* name, uint32_t fallback, uint32_t maximum);
void Start(int argc, char** argv, const char* test, bool modes = false);
// Null means no explicit override; AQL metadata defaults to off.
const char* AqlMetadataMode();
bool AqlMetadataEnabled();
bool AqlMode(int argc, char** argv);
void Pass(const char* test, uint64_t operations);

}  // namespace cts
#endif
