// Direct-KFD buffer and queue interfaces; scenarios own GPU lifetimes.
// ABI reference: https://github.com/torvalds/linux/blob/master/include/uapi/linux/kfd_ioctl.h
// Queue layout reference:
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/runtime/hsa-runtime/inc/amd_hsa_queue.h
#ifndef CTS_TESTS_SUPPORT_KFD_H_
#define CTS_TESTS_SUPPORT_KFD_H_

#include <cstddef>
#include <cstdint>
#include <map>
#include <string>
#include <vector>

#include "common/test.h"
#include "support/platform.h"

namespace cts {
// Public KFDQMTest extendedCuMaskingXcc: gfx12.5 uses one bit per WGP.
inline constexpr uint32_t kCuMaskBitsPerWgp = kGfx125 ? 1 : 2;
class Queue;

// One native VM per process. Tests fork/exec before constructing a Device.
struct Device {
  Device();
  ~Device();
  Device(const Device&) = delete;
  Device& operator=(const Device&) = delete;
  void Ioctl(unsigned long request, void* argument, const char* operation);
  uint64_t Property(const char* name) const;
  uint64_t* Doorbell(uint64_t offset);
  void MapDoorbellsForGpu();
  int kfd = -1;
  int drm = -1;
  uint32_t gpu_id = 0;
  uint32_t gfx = 0;
  uint32_t kfd_minor = 0;
  std::map<std::string, uint64_t> properties;

 private:
  void* doorbells_ = nullptr;
  uint64_t doorbell_offset_ = 0;
  uint64_t doorbell_handle_ = 0;
};

// Coherent, uncached GTT (or registered anonymous USERPTR) with identical
// CPU and GPU virtual addresses. Private VRAM is GPU-only.
// Backing must outlive every command referring to it.
struct Buffer {
  Buffer(Device& device, size_t bytes, bool executable = false, bool local = false,
         bool userptr = false);
  ~Buffer();
  Buffer(const Buffer&) = delete;
  Buffer& operator=(const Buffer&) = delete;
  uint64_t address(size_t offset = 0) const;
  uint32_t Load(size_t word) const;
  void Store(size_t word, uint32_t value);
  uint64_t Load64(size_t byte_offset) const;
  void Store64(size_t byte_offset, uint64_t value);
  void Wait(size_t word, uint32_t value, uint32_t timeout_ms = 10000, Queue* queue = nullptr) const;
  Device& device;
  void* data = nullptr;
  size_t size = 0;
  uint64_t handle = 0;
};

// Single reservation thread per queue. Shared PM4 producers serialize Submit.
// AQL multi-producer queues may publish disjoint reserved slots concurrently.
// The wrapped hardware RPTR cannot disambiguate a completely full ring, so
// reserve one dword. Consumption is separate from application completion.
class Queue {
 public:
  explicit Queue(Device& device, uint32_t ring_bytes = 4096, uint32_t priority = 7,
                 bool aql = false, bool multi_producer = false, bool metadata = true);
  ~Queue();
  Queue(const Queue&) = delete;
  Queue& operator=(const Queue&) = delete;
  void Submit(const std::vector<uint32_t>& words);
  void SubmitAql(const void* packet);
  // Reserve on one host thread; publish disjoint reserved slots concurrently.
  // Notify only after publishers have joined. No slot may be published twice.
  uint64_t ReserveAql(uint32_t count);
  void PublishAql(uint64_t index, const void* packet);
  void NotifyAql();
  // Explicitly publish companion metadata for GPU-produced AQL packets.
  // Normal PublishAql calls this before making the AQL header valid.
  void PublishMetadata(uint64_t index, const void* packet);
  uint64_t AqlMetadataSlotAddress(uint64_t index) const;
  bool has_metadata() const { return metadata_; }
  uint64_t AqlSlotAddress(uint64_t index) const;
  uint64_t AqlWriteIndexAddress() const;
  uint64_t GpuDoorbellAddress();
  void SeedEmptyPm4(uint64_t index);
  void Drain();
  void SetPriority(uint32_t priority);
  void SetCuMask(const std::vector<uint32_t>& mask);
  // Queue must be retired. Backing includes a final 4 KiB guard page.
  void SetScratch(Buffer& backing, uint32_t bytes_per_lane);
  void SetEnabled(bool enabled);
  uint64_t producer() const { return producer_; }
  uint64_t consumed();
  void Dump();

 private:
  Device& device_;
  Buffer ring_;
  Buffer pointers_;
  Buffer eop_;
  Buffer context_;
  uint32_t ring_bytes_ = 0;
  uint32_t id_ = 0;
  uint64_t* doorbell_ = nullptr;
  uint64_t producer_ = 0;
  uint64_t consumed_ = 0;
  uint64_t drained_aql_ = 0;
  bool aql_ = false;
  bool metadata_ = false;
  uint32_t priority_ = 7;
  bool enabled_ = true;
};
}  // namespace cts
#endif
