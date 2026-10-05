// gfx1250 AQL metadata prefetch ABI, version 0.0. Each 64-byte AQL slot
// has one 256-byte companion containing four matching headers. Descriptor
// and kernarg data must stay valid until both the packet and its users retire.
// Public reference: hsa_amd_metadata_kernel_dispatch_packet_t / barrier_packet_t.
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/runtime/hsa-runtime/inc/hsa_ext_amd.h
#ifndef CTS_GFX1250_METADATA_H_
#define CTS_GFX1250_METADATA_H_
#include <cstring>

#include "support/aql.h"
namespace cts {
struct AqlMetadata {
  uint32_t words[64]{};
};
static_assert(sizeof(AqlMetadata) == 256);
inline AqlMetadata MakeMetadata(const void* packet) {
  const auto* bytes = static_cast<const char*>(packet);
  uint32_t header;
  std::memcpy(&header, bytes, sizeof(header));
  const uint32_t type = header & 0xff;
  Check(type == 2 || type == 3 || type == 5,
        "metadata supports standard dispatch and barrier packets only");
  AqlMetadata out;
  for (uint32_t i = 0; i < 4; ++i) out.words[i * 16] = type;  // version 0.0.
  uint64_t completion;
  std::memcpy(&completion, bytes + 56, sizeof(completion));
  if (completion) std::memcpy(&out.words[1], reinterpret_cast<void*>(completion + 24), 4);
  if (type == 2) {
    Dispatch dispatch;
    std::memcpy(&dispatch, packet, sizeof(dispatch));
    Check(dispatch.kernel && !(dispatch.kernel & 63), "invalid metadata kernel descriptor");
    // Kernel descriptor bytes 16..63 are exactly the 48-byte metadata descriptor.
    const auto* descriptor = reinterpret_cast<const char*>(dispatch.kernel);
    std::memcpy(&out.words[2], descriptor + 16, 48);
    uint16_t preload;
    std::memcpy(&preload, descriptor + 58, sizeof(preload));
    const uint32_t count = preload & 127, offset = preload >> 7;
    Check(count <= 32 && (!count || dispatch.arguments), "unsupported kernarg preload");
    for (uint32_t i = 0; i < count; ++i) {
      // Each 64-byte block starts with a repeated header: skip those dwords.
      const uint32_t word = i < 15 ? 17 + i : (i < 30 ? 33 + i - 15 : 49 + i - 30);
      std::memcpy(&out.words[word], reinterpret_cast<void*>(dispatch.arguments + (offset + i) * 4),
                  4);
    }
  }
  return out;
}
}  // namespace cts
#endif
