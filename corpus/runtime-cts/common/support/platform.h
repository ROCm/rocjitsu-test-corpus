// Compile target only; Device still selects an exact matching KFD node.
#pragma once
#include <cstdint>
namespace cts {
inline constexpr uint32_t kGfxVersion = CTS_GFX_VERSION;
inline constexpr uint32_t kGfxMajor = kGfxVersion / 10000;
inline constexpr bool kGfx125 = kGfxVersion == 120500;
inline constexpr uint32_t kWaveSize = kGfxMajor == 9 ? 64 : 32;
}  // namespace cts
