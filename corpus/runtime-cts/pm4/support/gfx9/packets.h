// gfx9 GCN/CDNA: legacy CP_COHER_CNTL, shared by gfx9.0/9.4/9.5.
#pragma once
#include <cstdint>
namespace cts::pm4_encoding {
inline constexpr uint32_t kWriteScope = 0;
inline constexpr uint32_t kWaitOffload = 0;
inline constexpr uint32_t kReleaseControl =
    0x14u | (5u << 8) | (1u << 15) | (1u << 17);
inline constexpr uint32_t kAcquire[] = {
    (1u << 29) | (1u << 27) | (1u << 23) | (1u << 22) | (1u << 18),
    0xffffffffu,
    0xffffffu,
    0,
    0,
    10};
}  // namespace cts::pm4_encoding
