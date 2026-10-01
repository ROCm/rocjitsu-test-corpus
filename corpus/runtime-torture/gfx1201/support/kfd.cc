// Native KFD allocation, queue and doorbell helpers; no runtime library dependency.
// Requires Linux x86-64, 4 KiB pages, wave32, one XCC and KFD context-save sizes.
// GTT is coherent/uncached; EOP backing is private VRAM. Retire GPU references
// before freeing backing; failures leave live-resource cleanup to KFD process teardown.
// Public implementation and ABI references:
// https://github.com/torvalds/linux/blob/master/include/uapi/linux/kfd_ioctl.h
// https://github.com/tinygrad/tinygrad/blob/194aa6bad34604144bb98e80ae5837925d9f0839/tinygrad/runtime/ops_amd.py
// https://github.com/ROCm/rocm-systems/blob/96f1528fa5c5a0e12d706dbf4507c441c456f6eb/projects/rocr-runtime/runtime/hsa-runtime/inc/amd_hsa_queue.h
// https://github.com/ROCm/rocm-systems/blob/96f1528fa5c5a0e12d706dbf4507c441c456f6eb/projects/rocr-runtime/runtime/hsa-runtime/inc/amd_hsa_signal.h
// https://github.com/ROCm/rocm-systems/blob/96f1528fa5c5a0e12d706dbf4507c441c456f6eb/projects/rocr-runtime/libhsakmt/include/hsakmt/hsakmttypes.h
#include "support/kfd.h"

#include <dirent.h>
#include <fcntl.h>
#include <linux/kfd_ioctl.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <unistd.h>

#include <cerrno>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <thread>

namespace torture {
namespace {
constexpr uint64_t kTimeoutNs = 10000000000ull;
constexpr size_t kDoorbellBytes = 8192;
size_t PageAlign(size_t size) { return (size + 4095) & ~size_t{4095}; }
size_t ContextBytes(Device& device) {
  Check(device.Property("num_xcc") == 1, "only single-XCC targets are implemented");
  const uint64_t bytes = device.Property("cwsr_size");
  const uint64_t stack = device.Property("ctl_stack_size");
  Check(bytes && bytes < (1ull << 30) && !(bytes & 4095) && stack >= 4096 && stack < bytes &&
            !(stack & 4095),
        "invalid KFD context-save sizes");
  return PageAlign(bytes +
                   device.Property("simd_count") / device.Property("simd_per_cu") * 32 * 32);
}
}  // namespace

Device::Device(uint32_t target) {
  Check(sizeof(void*) == 8 && sysconf(_SC_PAGESIZE) == 4096,
        "requires 64-bit Linux and 4 KiB pages");
  const uint32_t wanted = 120001;
  Check(target == 1201, "wrong target for gfx1201 support");
  const char* root = "/sys/class/kfd/kfd/topology/nodes";
  DIR* nodes = opendir(root);
  if (!nodes) Fail("open KFD topology: %s", std::strerror(errno));
  while (dirent* entry = readdir(nodes)) {
    if (entry->d_name[0] == '.') continue;
    std::string path = std::string(root) + "/" + entry->d_name;
    uint32_t id = 0;
    std::ifstream(path + "/gpu_id") >> id;
    if (!id) continue;
    std::ifstream input(path + "/properties");
    std::map<std::string, uint64_t> props;
    std::string key;
    uint64_t value;
    while (input >> key >> value) props[key] = value;
    if (props["gfx_target_version"] != wanted) continue;
    gpu_id = id;
    properties = std::move(props);
    break;
  }
  closedir(nodes);
  if (!gpu_id) {
    std::printf("SKIP no gfx%u GPU\n", target);
    std::exit(77);
  }
  gfx = wanted;
  Check(Property("wave_front_size") == 32, "requires wave32 target");
  kfd = open("/dev/kfd", O_RDWR | O_CLOEXEC);
  if (kfd < 0) Fail("open /dev/kfd: %s", std::strerror(errno));
  const std::string path = "/dev/dri/renderD" + std::to_string(Property("drm_render_minor"));
  drm = open(path.c_str(), O_RDWR | O_CLOEXEC);
  if (drm < 0) Fail("open %s: %s", path.c_str(), std::strerror(errno));
  kfd_ioctl_get_version_args version{};
  Ioctl(AMDKFD_IOC_GET_VERSION, &version, "GET_VERSION");
  Check(version.major_version == 1, "unsupported KFD ABI major");
  kfd_ioctl_acquire_vm_args vm{};
  vm.drm_fd = drm;
  vm.gpu_id = gpu_id;
  Ioctl(AMDKFD_IOC_ACQUIRE_VM, &vm, "ACQUIRE_VM");
  Check(version.minor_version >= 14, "requires KFD runtime-enable ABI");
  kfd_ioctl_runtime_enable_args runtime{};
  runtime.mode_mask = KFD_RUNTIME_ENABLE_MODE_ENABLE_MASK;
  Ioctl(AMDKFD_IOC_RUNTIME_ENABLE, &runtime, "RUNTIME_ENABLE");
  std::printf("GPU gfx%u gpu_id=%u KFD=%u.%u fw=%llu cp_queues=%llu\n", target, gpu_id,
              version.major_version, version.minor_version,
              (unsigned long long)Property("fw_version"),
              (unsigned long long)Property("num_cp_queues"));
  std::fflush(stdout);
}
Device::~Device() {
  if (doorbell_handle_) {
    kfd_ioctl_unmap_memory_from_gpu_args unmap{};
    unmap.handle = doorbell_handle_;
    unmap.device_ids_array_ptr = reinterpret_cast<uintptr_t>(&gpu_id);
    unmap.n_devices = 1;
    Ioctl(AMDKFD_IOC_UNMAP_MEMORY_FROM_GPU, &unmap, "UNMAP doorbell GPU aperture");
    Check(unmap.n_success == 1, "partial doorbell unmapping");
    kfd_ioctl_free_memory_of_gpu_args free{};
    free.handle = doorbell_handle_;
    Ioctl(AMDKFD_IOC_FREE_MEMORY_OF_GPU, &free, "FREE doorbell GPU aperture");
  }
  if (doorbells_) Check(munmap(doorbells_, kDoorbellBytes) == 0, "unmap doorbells");
  if (drm >= 0) close(drm);
  if (kfd >= 0) close(kfd);
}
uint64_t Device::Property(const char* name) const {
  auto it = properties.find(name);
  if (it == properties.end()) Fail("missing KFD property %s", name);
  return it->second;
}
void Device::Ioctl(unsigned long request, void* argument, const char* operation) {
  int result;
  do {
    result = ioctl(kfd, request, argument);
  } while (result < 0 && errno == EINTR);
  if (result < 0) Fail("KFD %s: errno=%d (%s)", operation, errno, std::strerror(errno));
}
uint64_t* Device::Doorbell(uint64_t offset) {
  const uint64_t base = offset & ~(kDoorbellBytes - 1);
  if (!doorbells_) {
    doorbells_ = mmap(nullptr, kDoorbellBytes, PROT_READ | PROT_WRITE, MAP_SHARED, kfd, base);
    if (doorbells_ == MAP_FAILED) Fail("map doorbells: %s", std::strerror(errno));
    doorbell_offset_ = base;
  }
  Check(base == doorbell_offset_ && !(offset & 7), "unexpected doorbell aperture");
  return reinterpret_cast<uint64_t*>(static_cast<char*>(doorbells_) + offset - base);
}

// GPUVM doorbell mapping follows public libhsakmt fmm.c/queues.c.
// CPU mmap alone does not make the aperture accessible to GPU producers.
void Device::MapDoorbellsForGpu() {
  Check(doorbells_ != nullptr, "create a queue before mapping GPU doorbells");
  if (doorbell_handle_) return;
  kfd_ioctl_alloc_memory_of_gpu_args alloc{};
  alloc.va_addr = reinterpret_cast<uintptr_t>(doorbells_);
  alloc.size = kDoorbellBytes;
  alloc.gpu_id = gpu_id;
  alloc.flags = KFD_IOC_ALLOC_MEM_FLAGS_DOORBELL | KFD_IOC_ALLOC_MEM_FLAGS_WRITABLE |
                KFD_IOC_ALLOC_MEM_FLAGS_COHERENT;
  Ioctl(AMDKFD_IOC_ALLOC_MEMORY_OF_GPU, &alloc, "ALLOC doorbell GPU aperture");
  doorbell_handle_ = alloc.handle;
  kfd_ioctl_map_memory_to_gpu_args map{};
  map.handle = alloc.handle;
  map.device_ids_array_ptr = reinterpret_cast<uintptr_t>(&gpu_id);
  map.n_devices = 1;
  Ioctl(AMDKFD_IOC_MAP_MEMORY_TO_GPU, &map, "MAP doorbell GPU aperture");
  Check(map.n_success == 1, "partial doorbell mapping");
}

Buffer::Buffer(Device& d, size_t bytes, bool executable, bool local, bool userptr)
    : device(d), size(PageAlign(bytes)) {
  Check(size != 0, "empty allocation");
  Check(!(local && userptr), "USERPTR cannot be private VRAM");
  data = mmap(nullptr, size, userptr ? PROT_READ | PROT_WRITE : PROT_NONE,
              MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
  if (data == MAP_FAILED) Fail("reserve VA: %s", std::strerror(errno));
  kfd_ioctl_alloc_memory_of_gpu_args alloc{};
  alloc.va_addr = address();
  alloc.size = size;
  alloc.gpu_id = device.gpu_id;
  alloc.flags = (userptr ? KFD_IOC_ALLOC_MEM_FLAGS_USERPTR : KFD_IOC_ALLOC_MEM_FLAGS_GTT) |
                KFD_IOC_ALLOC_MEM_FLAGS_WRITABLE | KFD_IOC_ALLOC_MEM_FLAGS_PUBLIC |
                KFD_IOC_ALLOC_MEM_FLAGS_COHERENT | KFD_IOC_ALLOC_MEM_FLAGS_UNCACHED |
                KFD_IOC_ALLOC_MEM_FLAGS_NO_SUBSTITUTE;
  if (userptr) {
    // Fault in CPU pages before registration. Their lifetime includes every
    // GPU reference; this test helper does not model concurrent invalidation.
    std::memset(data, 0, size);
    alloc.mmap_offset = address();
  }
  if (executable) alloc.flags |= KFD_IOC_ALLOC_MEM_FLAGS_EXECUTABLE;
  if (local)
    alloc.flags = KFD_IOC_ALLOC_MEM_FLAGS_VRAM | KFD_IOC_ALLOC_MEM_FLAGS_WRITABLE |
                  KFD_IOC_ALLOC_MEM_FLAGS_EXECUTABLE | KFD_IOC_ALLOC_MEM_FLAGS_NO_SUBSTITUTE;
  device.Ioctl(AMDKFD_IOC_ALLOC_MEMORY_OF_GPU, &alloc, "ALLOC_MEMORY_OF_GPU");
  handle = alloc.handle;
  if (!local && !userptr) {
    void* mapped = mmap(data, size, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED, device.drm,
                        alloc.mmap_offset);
    if (mapped == MAP_FAILED) Fail("map GTT: %s", std::strerror(errno));
  }
  kfd_ioctl_map_memory_to_gpu_args map{};
  map.handle = handle;
  map.device_ids_array_ptr = reinterpret_cast<uintptr_t>(&device.gpu_id);
  map.n_devices = 1;
  device.Ioctl(AMDKFD_IOC_MAP_MEMORY_TO_GPU, &map, "MAP_MEMORY_TO_GPU");
  Check(map.n_success == 1, "partial GPU mapping");
  if (!local) std::memset(data, 0, size);
}
Buffer::~Buffer() {
  kfd_ioctl_unmap_memory_from_gpu_args unmap{};
  unmap.handle = handle;
  unmap.device_ids_array_ptr = reinterpret_cast<uintptr_t>(&device.gpu_id);
  unmap.n_devices = 1;
  device.Ioctl(AMDKFD_IOC_UNMAP_MEMORY_FROM_GPU, &unmap, "UNMAP_MEMORY_FROM_GPU");
  Check(unmap.n_success == 1, "partial GPU unmapping");
  kfd_ioctl_free_memory_of_gpu_args free{};
  free.handle = handle;
  device.Ioctl(AMDKFD_IOC_FREE_MEMORY_OF_GPU, &free, "FREE_MEMORY_OF_GPU");
  Check(munmap(data, size) == 0, "unmap GTT");
}
uint64_t Buffer::address(size_t offset) const {
  Check(offset < size, "buffer offset out of bounds");
  return reinterpret_cast<uintptr_t>(data) + offset;
}
uint32_t Buffer::Load(size_t word) const {
  Check(word < size / 4, "load out of bounds");
  return __atomic_load_n(static_cast<uint32_t*>(data) + word, __ATOMIC_ACQUIRE);
}
void Buffer::Store(size_t word, uint32_t value) {
  Check(word < size / 4, "store out of bounds");
  __atomic_store_n(static_cast<uint32_t*>(data) + word, value, __ATOMIC_RELEASE);
}
uint64_t Buffer::Load64(size_t offset) const {
  Check(!(offset & 7) && offset <= size - 8, "64-bit load out of bounds or unaligned");
  return __atomic_load_n(reinterpret_cast<uint64_t*>(static_cast<char*>(data) + offset),
                         __ATOMIC_ACQUIRE);
}
void Buffer::Store64(size_t offset, uint64_t value) {
  Check(!(offset & 7) && offset <= size - 8, "64-bit store out of bounds or unaligned");
  __atomic_store_n(reinterpret_cast<uint64_t*>(static_cast<char*>(data) + offset), value,
                   __ATOMIC_RELEASE);
}
void Buffer::Wait(size_t word, uint32_t value, uint32_t timeout_ms, Queue* queue) const {
  const uint64_t deadline = NowNs() + uint64_t(timeout_ms) * 1000000;
  while (Load(word) != value) {
    if (NowNs() >= deadline) {
      if (queue) queue->Dump();
      Fail("completion timeout word=%zu expected=%u observed=%u", word, value, Load(word));
    }
    std::this_thread::yield();
  }
}

Queue::Queue(Device& device, uint32_t ring_bytes, uint32_t priority, bool aql, bool multi_producer)
    : device_(device),
      ring_(device, ring_bytes, true),
      pointers_(device, 4096),
      eop_(device, 4096, true, true),
      context_(device, ContextBytes(device), true),
      aql_(aql),
      priority_(priority) {
  Check(ring_bytes >= 4096 && !(ring_bytes & (ring_bytes - 1)) && priority <= 15,
        "invalid queue configuration");
  Check(!multi_producer || aql_, "multi-producer publication requires AQL");
  // KFD HsaUserContextSaveAreaHeader: DebugOffset, DebugSize, ErrorReason.
  // Context/stack sizes come from this GPU's sysfs, not another architecture.
  auto* header = static_cast<uint32_t*>(context_.data);
  header[4] = device.Property("cwsr_size");
  header[5] = device.Property("simd_count") / device.Property("simd_per_cu") * 32 * 32;
  const uint64_t error_address = pointers_.address(512);
  std::memcpy(header + 6, &error_address, sizeof(error_address));
  if (aql_) {
    // Firmware-facing AMD queue descriptor, not a ROCr object. Offsets follow
    // amd_hsa_queue.h (linked above). No dynamic scratch or runtime callbacks.
    auto* control = static_cast<uint32_t*>(pointers_.data);
    control[0] = multi_producer ? 0 : 1;  // HSA_QUEUE_TYPE_MULTI / SINGLE.
    control[1] = 1;                       // Kernel dispatch feature.
    const uint64_t ring_address = ring_.address();
    std::memcpy(control + 2, &ring_address, 8);
    control[6] = ring_bytes / 64;
    control[18] = device.Property("simd_count") / device.Property("simd_per_cu") - 1;
    control[19] = device.Property("max_waves_per_simd") * device.Property("simd_per_cu") - 1;
    control[34] = 128;  // read_dispatch_id_field_base_byte_offset.
    control[45] = 2;    // IS_PTR64; scratch starts disabled (SetScratch opts in).
    kfd_ioctl_get_process_apertures_new_args query{};
    device.Ioctl(AMDKFD_IOC_GET_PROCESS_APERTURES_NEW, &query, "GET_PROCESS_APERTURES count");
    std::vector<kfd_process_device_apertures> apertures(query.num_of_nodes);
    query.kfd_process_device_apertures_ptr = reinterpret_cast<uintptr_t>(apertures.data());
    device.Ioctl(AMDKFD_IOC_GET_PROCESS_APERTURES_NEW, &query, "GET_PROCESS_APERTURES");
    bool found = false;
    for (const auto& aperture : apertures)
      if (aperture.gpu_id == device.gpu_id) {
        control[16] = aperture.lds_base >> 32;
        control[17] = aperture.scratch_base >> 32;
        found = true;
      }
    Check(found, "GPU apertures missing");
    for (uint32_t i = 0; i < ring_bytes / 64; ++i)
      static_cast<uint32_t*>(ring_.data)[i * 16] = 1;  // INVALID AQL packet.
  }
  kfd_ioctl_create_queue_args create{};
  create.ring_base_address = ring_.address();
  create.ring_size = ring_bytes;
  create.gpu_id = device.gpu_id;
  create.queue_type = aql_ ? KFD_IOC_QUEUE_TYPE_COMPUTE_AQL : KFD_IOC_QUEUE_TYPE_COMPUTE;
  create.queue_percentage = 100;
  create.queue_priority = priority;
  create.read_pointer_address = pointers_.address(aql_ ? 128 : 0);
  create.write_pointer_address = pointers_.address(aql_ ? 56 : 64);
  create.eop_buffer_address = eop_.address();
  create.eop_buffer_size = eop_.size;
  create.ctx_save_restore_address = context_.address();
  create.ctx_save_restore_size = device.Property("cwsr_size");
  create.ctl_stack_size = device.Property("ctl_stack_size");
  // All backing and INVALID AQL headers must be visible before queue activation.
  __atomic_thread_fence(__ATOMIC_RELEASE);
  __asm__ __volatile__("sfence" ::: "memory");
  device.Ioctl(AMDKFD_IOC_CREATE_QUEUE, &create, "CREATE_QUEUE");
  id_ = create.queue_id;
  doorbell_ = device.Doorbell(create.doorbell_offset);
}
Queue::~Queue() {
  Drain();
  kfd_ioctl_destroy_queue_args destroy{};
  destroy.queue_id = id_;
  device_.Ioctl(AMDKFD_IOC_DESTROY_QUEUE, &destroy, "DESTROY_QUEUE");
}
uint64_t Queue::consumed() {
  const uint64_t mask = ring_.size / 4 - 1;
  const uint64_t raw =
      __atomic_load_n(static_cast<uint64_t*>(pointers_.data) + (aql_ ? 16 : 0), __ATOMIC_ACQUIRE);
  if (aql_)
    consumed_ = raw;
  else
    consumed_ += (raw - consumed_) & mask;
  Check(consumed_ <= producer_, "read pointer passed producer");
  if (pointers_.Load(128) || pointers_.Load(129))
    Fail("queue %u error=%08x:%08x", id_, pointers_.Load(129), pointers_.Load(128));
  return consumed_;
}
void Queue::Dump() {
  std::fprintf(
      stderr,
      "queue=%u aql=%d producer=%llu raw_read=%llu error=%08x:%08x context=%08x,%08x,%08x,%08x\n",
      id_, aql_, (unsigned long long)producer_,
      (unsigned long long)__atomic_load_n(static_cast<uint64_t*>(pointers_.data) + (aql_ ? 16 : 0),
                                          __ATOMIC_ACQUIRE),
      pointers_.Load(129), pointers_.Load(128), context_.Load(0), context_.Load(1),
      context_.Load(2), context_.Load(3));
}
void Queue::Submit(const std::vector<uint32_t>& words) {
  Check(!aql_, "PM4 submission to AQL ring");
  const uint64_t capacity = ring_.size / 4;
  Check(!words.empty() && words.size() < capacity, "submission exceeds ring capacity");
  const uint64_t deadline = NowNs() + kTimeoutNs;
  while (producer_ - consumed() + words.size() >= capacity) {
    if (NowNs() >= deadline)
      Fail("ring full queue=%u producer=%llu consumed=%llu", id_, (unsigned long long)producer_,
           (unsigned long long)consumed_);
    std::this_thread::yield();
  }
  auto* ring = static_cast<uint32_t*>(ring_.data);
  for (size_t i = 0; i < words.size(); ++i) ring[(producer_ + i) & (capacity - 1)] = words[i];
  producer_ += words.size();
  __atomic_store_n(static_cast<uint64_t*>(pointers_.data) + 8, producer_, __ATOMIC_RELEASE);
  // Order WC/UC writes to the ring and write pointer before MMIO notification.
  __asm__ __volatile__("sfence" ::: "memory");
  __atomic_store_n(doorbell_, producer_, __ATOMIC_RELEASE);
}
void Queue::SubmitAql(const void* packet) {
  const uint64_t index = ReserveAql(1);
  PublishAql(index, packet);
  NotifyAql();
}
uint64_t Queue::ReserveAql(uint32_t count) {
  Check(aql_, "AQL reservation on PM4 ring");
  const uint64_t capacity = ring_.size / 64;
  Check(count && count <= capacity, "invalid AQL reservation size");
  const uint64_t deadline = NowNs() + kTimeoutNs;
  while (producer_ - consumed() + count > capacity) {
    if (NowNs() >= deadline) Fail("AQL ring full queue=%u", id_);
    std::this_thread::yield();
  }
  const uint64_t first = producer_;
  producer_ += count;
  pointers_.Store64(56, producer_);
  return first;
}
void Queue::PublishAql(uint64_t index, const void* packet) {
  Check(aql_ && index < producer_ && producer_ - index <= ring_.size / 64,
        "AQL publication outside reserved window");
  auto* slot = static_cast<char*>(ring_.data) + (index % (ring_.size / 64)) * 64;
  // Commit header last; firmware must never see a partially populated packet.
  std::memcpy(slot + 4, static_cast<const char*>(packet) + 4, 60);
  __atomic_thread_fence(__ATOMIC_RELEASE);
  __asm__ __volatile__("sfence" ::: "memory");
  uint32_t header;
  std::memcpy(&header, packet, 4);
  __atomic_store_n(reinterpret_cast<uint32_t*>(slot), header, __ATOMIC_RELEASE);
}
void Queue::NotifyAql() {
  Check(aql_ && producer_, "AQL notification without reservation");
  __asm__ __volatile__("sfence" ::: "memory");
  __atomic_store_n(doorbell_, producer_ - 1, __ATOMIC_RELEASE);
}
uint64_t Queue::AqlSlotAddress(uint64_t index) const {
  Check(aql_ && index < producer_ && producer_ - index <= ring_.size / 64,
        "AQL slot outside reserved window");
  return ring_.address((index % (ring_.size / 64)) * 64);
}
uint64_t Queue::AqlWriteIndexAddress() const {
  Check(aql_, "AQL write index requested for PM4 queue");
  return pointers_.address(56);
}
uint64_t Queue::GpuDoorbellAddress() {
  device_.MapDoorbellsForGpu();
  return reinterpret_cast<uintptr_t>(doorbell_);
}
void Queue::SeedEmptyPm4(uint64_t index) {
  Check(!aql_ && producer_ == 0 && consumed() == 0 && !(index % (ring_.size / 4)),
        "counter seed requires unused PM4 queue and ring-aligned index");
  // Hardware PM4 RPTR is ring-relative. Lift the software counters by whole
  // rings, as in tinygrad's 64-bit doorbell regression; no packets are skipped.
  producer_ = consumed_ = index;
  pointers_.Store64(64, index);
}
void Queue::Drain() {
  const uint64_t deadline = NowNs() + kTimeoutNs;
  while (consumed() != producer_) {
    if (NowNs() >= deadline)
      Fail("drain timeout queue=%u producer=%llu consumed=%llu", id_, (unsigned long long)producer_,
           (unsigned long long)consumed_);
    std::this_thread::yield();
  }
}
// Static wave32 scratch setup from public ROCr InitScratchSRD and registers.h:
// https://github.com/ROCm/rocm-systems/blob/96f1528fa5c5a0e12d706dbf4507c441c456f6eb/projects/rocr-runtime/runtime/hsa-runtime/core/runtime/amd_aql_queue.cpp
void Queue::SetScratch(Buffer& backing, uint32_t bytes_per_lane) {
  Check(aql_ && consumed() == producer_, "scratch update requires retired AQL queue");
  Check(bytes_per_lane && bytes_per_lane <= 65536 && backing.size > 4096,
        "invalid static scratch allocation");
  const uint32_t wave_units = (bytes_per_lane * 32 + 255) / 256;
  const uint32_t arrays_per_engine = device_.Property("simd_arrays_per_engine");
  Check(arrays_per_engine != 0 && !(bytes_per_lane & 15), "invalid scratch alignment/topology");
  const uint32_t engines = device_.Property("array_count") / arrays_per_engine;
  Check(engines != 0, "missing scratch shader engines");
  const uint64_t bytes = backing.size - 4096;
  const uint32_t waves = bytes / (wave_units * 256) / engines;
  Check(engines && waves && waves < 4096 && bytes <= 0xffffffffu,
        "scratch wave count or size out of range");
  pointers_.Store(35, waves | (wave_units << 12));  // COMPUTE_TMPRING_SIZE_GFX12.
  pointers_.Store(36, uint32_t(backing.address()));
  pointers_.Store(37, uint32_t(backing.address() >> 32) | (1u << 30));
  pointers_.Store(38, bytes);
  // X/Y/Z/W selectors; 32_UINT format; ADD_TID; OOB disabled for swizzled scratch.
  pointers_.Store(39,
                  4u | (5u << 3) | (6u << 6) | (7u << 9) | (0x14u << 12) | (1u << 23) | (2u << 28));
  pointers_.Store64(160, backing.address());
  pointers_.Store64(168, bytes);
  pointers_.Store(44, bytes_per_lane / 2);  // Legacy wave64 per-lane representation.
  __asm__ __volatile__("sfence" ::: "memory");
}
void Queue::SetCuMask(const std::vector<uint32_t>& mask) {
  Check(!mask.empty(), "empty CU mask");
  kfd_ioctl_set_cu_mask_args args{};
  args.queue_id = id_;
  args.num_cu_mask = mask.size() * 32;
  args.cu_mask_ptr = reinterpret_cast<uintptr_t>(mask.data());
  device_.Ioctl(AMDKFD_IOC_SET_CU_MASK, &args, "SET_CU_MASK");
}
void Queue::SetPriority(uint32_t priority) {
  Check(priority <= 15, "invalid priority");
  kfd_ioctl_update_queue_args update{};
  update.queue_id = id_;
  update.ring_base_address = ring_.address();
  update.ring_size = ring_.size;
  update.queue_percentage = enabled_ ? 100 : 0;
  update.queue_priority = priority;
  device_.Ioctl(AMDKFD_IOC_UPDATE_QUEUE, &update, "UPDATE_QUEUE");
  priority_ = priority;
}
void Queue::SetEnabled(bool enabled) {
  enabled_ = enabled;
  SetPriority(priority_);
}
}  // namespace torture
