// gfx11 and gfx12.0: shared GCR packet layout; no separate gfx12 directory.
// References and field-level support rationale: ../../REFERENCES.md.
#pragma once
#include <cstdint>
namespace cts::pm4_encoding {
inline constexpr uint32_t kWriteScope = 0;
inline constexpr uint32_t kWaitOffload = 0;
inline constexpr uint32_t kReleaseControl =
    0x14u | (5u << 8) | (((1u << 10) | (1u << 9) | (1u << 8) | 12u) << 12);
inline constexpr uint32_t kAcquire[] = {
    0,
    0xffffffffu,
    0xffu,
    0,
    0,
    10,
    3u | (1u << 4) | (1u << 5) | (1u << 7) | (1u << 8) | (1u << 9) | (1u << 14) | (1u << 15)};
}  // namespace cts::pm4_encoding
