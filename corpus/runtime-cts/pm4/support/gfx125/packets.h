// gfx12.5: explicit memory scope, revised GCR fields, dependency-wait offload.
#pragma once
#include <cstdint>
namespace cts::pm4_encoding {
inline constexpr uint32_t kWriteScope = (3u << 12);
inline constexpr uint32_t kWaitOffload = (1u << 31);
inline constexpr uint32_t kReleaseControl =
    0x14u | (5u << 8) | (((1u << 12) | (1u << 10) | (1u << 9) | 1u) << 12);
inline constexpr uint32_t kAcquire[] = {
    0, 0xffffffffu, 0, 0, 0, 4, (1u << 15) | (1u << 14) | (1u << 8) | (1u << 7) | (1u << 4) | 1u};
}  // namespace cts::pm4_encoding
