// Direct-KFD SDMA ring publication, doorbells and read-pointer retirement.
// Queue ABI: https://github.com/torvalds/linux/blob/master/include/uapi/linux/kfd_ioctl.h
// Public queue programming reference:
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/libhsakmt/src/queues.c
#include "support/sdma.h"

#include <linux/kfd_ioctl.h>

#include <thread>

namespace cts {
SdmaQueue::SdmaQueue(Device& device)
    : device_(device), ring_(device, 4096, true), pointers_(device, 4096) {
  Check(device.Property("num_sdma_engines") != 0, "no SDMA engine available");
  kfd_ioctl_create_queue_args args{};
  args.gpu_id = device.gpu_id;
  args.queue_type = KFD_IOC_QUEUE_TYPE_SDMA;
  args.queue_percentage = 100;
  args.queue_priority = 7;
  args.ring_base_address = ring_.address();
  args.ring_size = ring_.size;
  args.read_pointer_address = pointers_.address();
  args.write_pointer_address = pointers_.address(64);
  __asm__ __volatile__("sfence" ::: "memory");
  device.Ioctl(AMDKFD_IOC_CREATE_QUEUE, &args, "CREATE_QUEUE SDMA");
  id_ = args.queue_id;
  doorbell_ = device.Doorbell(args.doorbell_offset);
}
SdmaQueue::~SdmaQueue() {
  Drain();
  kfd_ioctl_destroy_queue_args args{};
  args.queue_id = id_;
  device_.Ioctl(AMDKFD_IOC_DESTROY_QUEUE, &args, "DESTROY_QUEUE SDMA");
}
uint64_t SdmaQueue::Consumed() const {
  const uint64_t consumed = pointers_.Load64(0);
  Check(consumed <= producer_, "SDMA read pointer passed producer");
  return consumed;
}
void SdmaQueue::Submit(const std::vector<uint32_t>& words) {
  // ROCr requires 256-byte submissions on early gfx9 SDMA engines.
  const size_t alignment = kGfxMajor == 9 ? 256 : 128;
  const size_t bytes = (words.size() * 4 + alignment - 1) & ~(alignment - 1);
  Check(!words.empty() && !(words.size() & 31) && bytes < ring_.size, "invalid SDMA stream size");
  const uint64_t deadline = NowNs() + 10000000000ull;
  while (producer_ - Consumed() + bytes >= ring_.size) {
    if (NowNs() >= deadline) Fail("SDMA ring full queue=%u", id_);
    std::this_thread::yield();
  }
  auto* ring = static_cast<uint32_t*>(ring_.data);
  for (size_t i = 0; i < bytes / 4; ++i)
    ring[((producer_ / 4) + i) % (ring_.size / 4)] = i < words.size() ? words[i] : 0;
  producer_ += bytes;
  pointers_.Store64(64, producer_);
  __asm__ __volatile__("sfence" ::: "memory");
  __atomic_store_n(doorbell_, producer_, __ATOMIC_RELEASE);
}
void SdmaQueue::SetEnabled(bool enabled) {
  kfd_ioctl_update_queue_args args{};
  args.queue_id = id_;
  args.ring_base_address = enabled ? ring_.address() : 0;
  args.ring_size = ring_.size;
  args.queue_percentage = 100;
  args.queue_priority = 7;
  device_.Ioctl(AMDKFD_IOC_UPDATE_QUEUE, &args, "UPDATE_QUEUE SDMA");
}
void SdmaQueue::Drain() {
  const uint64_t deadline = NowNs() + 10000000000ull;
  while (Consumed() != producer_) {
    if (NowNs() >= deadline) Fail("SDMA drain timeout queue=%u", id_);
    std::this_thread::yield();
  }
}
}  // namespace cts
