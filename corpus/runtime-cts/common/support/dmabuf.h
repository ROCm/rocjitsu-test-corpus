// DMA-BUF import address selection shared by the process-handoff cases.
#ifndef CTS_DMABUF_H_
#define CTS_DMABUF_H_
#include <sys/mman.h>

#include "common/test.h"

namespace cts {
inline void* ReserveDmabufImport(size_t bytes, int fd, bool aql) {
  // Metadata publication reads completion-signal event IDs on the CPU.
  // Other modes reserve GPU-only VA without retaining a DMA-BUF file mapping
  // after the worker closes its inherited FD.
  const bool readable = aql && AqlMetadataEnabled();
  void* va = mmap(nullptr, bytes, readable ? PROT_READ | PROT_WRITE : PROT_NONE,
                  readable ? MAP_SHARED : MAP_PRIVATE | MAP_ANONYMOUS,
                  readable ? fd : -1, 0);
  Check(va != MAP_FAILED, "reserve DMA-BUF import address");
  return va;
}
}  // namespace cts
#endif
