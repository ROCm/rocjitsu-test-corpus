// Native KFD allocation, queue and doorbell helpers; no runtime library dependency.
// Requires Linux x86-64, 4 KiB pages, KFD runtime-enable support.
// Allocate a context header/save area for each XCC, following public libhsakmt queues.c.
// GTT is coherent/uncached; EOP backing is private VRAM. Retire GPU references
// before freeing backing; failures leave live-resource cleanup to KFD process teardown.
// AQL drains use a barrier completion: the reported read index can lag retired
// packets. Keep that raw index observable and separately track drained capacity.
// Public implementation and ABI references:
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/libhsakmt/src/queues.c
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

#include <algorithm>
#include <cerrno>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <thread>

#include "support/metadata.h"

namespace torture {
namespace {
// Public KFD 1.19 CREATE_QUEUE tail; some distro headers still stop at byte 88.
// https://github.com/ROCm/rocm-systems/blob/5668fbb3ab72cf4a88b13077804dc2db0676f974/projects/rocr-runtime/libhsakmt/include/hsakmt/linux/kfd_ioctl.h
struct CreateQueueArgs {
  uint64_t ring_base_address, write_pointer_address, read_pointer_address, doorbell_offset;
  uint32_t ring_size, gpu_id, queue_type, queue_percentage, queue_priority, queue_id;
  uint64_t eop_buffer_address, eop_buffer_size, ctx_save_restore_address;
  uint32_t ctx_save_restore_size, ctl_stack_size, sdma_engine_id, metadata_ring_size;
};
static_assert(sizeof(CreateQueueArgs) == 96 && offsetof(CreateQueueArgs, metadata_ring_size) == 92);
constexpr uint64_t kTimeoutNs = 10000000000ull;
constexpr size_t kDoorbellBytes = 8192;
size_t PageAlign(size_t size) { return (size + 4095) & ~size_t{4095}; }
size_t DebugBytes(Device& device) { return device.Property("debug_save_size"); }
size_t ContextBytes(Device& device) {
  return PageAlign(device.Property("cwsr_size") * device.Property("num_xcc") + DebugBytes(device));
}
// ROCr libhsakmt queues.c fallback for kernels without CwsrSize/CtlStackSize.
void ContextSizes(Device& device) {
  auto& props = device.properties;
  if (!props["num_xcc"]) props["num_xcc"] = 1;
  const uint64_t xcc = props["num_xcc"];
  const uint64_t simds = device.Property("simd_count");
  const uint64_t per_cu = device.Property("simd_per_cu");
  const uint64_t per_simd = device.Property("max_waves_per_simd");
  const uint64_t arrays = device.Property("simd_arrays_per_engine");
  Check(xcc <= 16 && simds && per_cu && per_simd && arrays, "invalid context-save topology");
  const uint64_t cu = simds / per_cu / xcc;
  const uint64_t waves = kGfxMajor == 9
                             ? std::min(cu * 40, device.Property("array_count") / arrays * 512)
                             : cu * per_cu * per_simd;
  const uint64_t stack = PageAlign(40 + waves * (kGfxMajor == 9 ? 8 : 12) + 8);
  const uint64_t vgpr =
      kGfxMajor == 9
          ? ((kGfxVersion >= 90008 && kGfxVersion <= 90010) || kGfxVersion > 90012 ? 0x80000
                                                                                   : 0x40000)
          : (kGfx125 ? 0x80000 : 0x60000);
  const uint64_t sgpr = kGfx125 ? 0x8000 : 0x4000;
  const uint64_t hwreg = kGfx125 ? per_simd * per_cu * 512 : 0x1000;
  const uint64_t context =
      stack + PageAlign(cu * (vgpr + sgpr + hwreg + device.Property("lds_size_in_kb") * 1024));
  if (!props["cwsr_size"]) props["cwsr_size"] = context;
  if (!props["ctl_stack_size"]) props["ctl_stack_size"] = stack;
  props["debug_save_size"] = ((waves * 32 + 63) & ~uint64_t{63}) * xcc;
  Check(props["cwsr_size"] < (1ull << 30) && !(props["cwsr_size"] & 4095) &&
            props["ctl_stack_size"] >= 4096 && props["ctl_stack_size"] < props["cwsr_size"] &&
            !(props["ctl_stack_size"] & 4095),
        "invalid KFD context-save sizes");
}
}  // namespace

Device::Device() {
  Check(sizeof(void*) == 8 && sysconf(_SC_PAGESIZE) == 4096,
        "requires 64-bit Linux and 4 KiB pages");
  const uint32_t wanted = kGfxVersion;
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
    std::printf("SKIP no %s GPU\n", TORTURE_TARGET_NAME);
    std::exit(77);
  }
  gfx = wanted;
  Check(Property("wave_front_size") == kWaveSize, "unexpected target wave size");
  ContextSizes(*this);
  kfd = open("/dev/kfd", O_RDWR | O_CLOEXEC);
  if (kfd < 0) Fail("open /dev/kfd: %s", std::strerror(errno));
  const std::string path = "/dev/dri/renderD" + std::to_string(Property("drm_render_minor"));
  drm = open(path.c_str(), O_RDWR | O_CLOEXEC);
  if (drm < 0) Fail("open %s: %s", path.c_str(), std::strerror(errno));
  kfd_ioctl_get_version_args version{};
  Ioctl(AMDKFD_IOC_GET_VERSION, &version, "GET_VERSION");
  Check(version.major_version == 1, "unsupported KFD ABI major");
  kfd_minor = version.minor_version;
  kfd_ioctl_acquire_vm_args vm{};
  vm.drm_fd = drm;
  vm.gpu_id = gpu_id;
  Ioctl(AMDKFD_IOC_ACQUIRE_VM, &vm, "ACQUIRE_VM");
  Check(version.minor_version >= 14, "requires KFD runtime-enable ABI");
  kfd_ioctl_runtime_enable_args runtime{};
  runtime.mode_mask = KFD_RUNTIME_ENABLE_MODE_ENABLE_MASK;
  Ioctl(AMDKFD_IOC_RUNTIME_ENABLE, &runtime, "RUNTIME_ENABLE");
  std::printf("GPU %s gpu_id=%u KFD=%u.%u fw=%llu cp_queues=%llu\n", TORTURE_TARGET_NAME, gpu_id,
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

Queue::Queue(Device& device, uint32_t ring_bytes, uint32_t priority, bool aql, bool multi_producer,
             bool metadata)
    : device_(device),
      ring_(device, size_t(ring_bytes) * (aql && metadata && kGfx125 ? 5 : 1), true),
      pointers_(device, 4096),
      eop_(device, 4096, true, true),
      context_(device, ContextBytes(device), true),
      ring_bytes_(ring_bytes),
      aql_(aql),
      metadata_(aql && metadata && kGfx125),
      priority_(priority) {
  Check(ring_bytes >= 4096 && !(ring_bytes & (ring_bytes - 1)) && priority <= 15,
        "invalid queue configuration");
  Check(!multi_producer || aql_, "multi-producer publication requires AQL");
#ifdef TORTURE_AQL_ONLY
  Check(aql_, "PM4 queues are forbidden in the AQL suite");
#endif
  // KFD HsaUserContextSaveAreaHeader: DebugOffset, DebugSize, ErrorReason.
  // Sizes use sysfs when available, otherwise the ROCr topology calculation.
  const uint64_t xcc = device.Property("num_xcc");
  const uint64_t save_bytes = device.Property("cwsr_size");
  const uint64_t error_address = pointers_.address(512);
  for (uint64_t i = 0; i < xcc; ++i) {
    auto* header = reinterpret_cast<uint32_t*>(static_cast<char*>(context_.data) + i * save_bytes);
    header[4] = (xcc - i) * save_bytes;
    header[5] = DebugBytes(device);
    std::memcpy(header + 6, &error_address, sizeof(error_address));
  }
  if (metadata_) Check(device.kfd_minor >= 19, "metadata queues require KFD 1.19 or newer");
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
  if (metadata_) {
    for (uint32_t i = 0; i < ring_bytes / 64; ++i)
      for (uint32_t header = 0; header < 4; ++header)
        ring_.Store((ring_bytes + i * 256 + header * 64) / 4, 1);  // INVALID.
  }
  CreateQueueArgs create{};
  create.ring_base_address = ring_.address();
  create.ring_size = ring_bytes;
  create.metadata_ring_size = metadata_ ? ring_bytes * 4 : 0;
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
  device.Ioctl(_IOWR('K', 0x02, CreateQueueArgs), &create, "CREATE_QUEUE");
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
  const uint64_t mask = ring_bytes_ / 4 - 1;
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
  if (aql_) {
    const uint64_t read = pointers_.Load64(128);
    const size_t slot = read % (ring_bytes_ / 64);
    const size_t offset = slot * 64;
    // Report addresses without dereferencing packet pointers: malformed or
    // stale pointers are exactly what a GPU page-fault investigation needs.
    std::fprintf(stderr,
                 "AQL ring=%llx descriptor=%llx slot=%zu header=%08x kernel=%llx "
                 "kernarg=%llx completion=%llx metadata=%llx\n",
                 (unsigned long long)ring_.address(), (unsigned long long)pointers_.address(), slot,
                 ring_.Load(offset / 4), (unsigned long long)ring_.Load64(offset + 32),
                 (unsigned long long)ring_.Load64(offset + 40),
                 (unsigned long long)ring_.Load64(offset + 56),
                 (unsigned long long)(metadata_ ? ring_.address(ring_bytes_ + slot * 256) : 0));
  }
}
void Queue::Submit(const std::vector<uint32_t>& words) {
  Check(!aql_, "PM4 submission to AQL ring");
  const uint64_t capacity = ring_bytes_ / 4;
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
  const uint64_t capacity = ring_bytes_ / 64;
  Check(count && count <= capacity, "invalid AQL reservation size");
  const uint64_t deadline = NowNs() + kTimeoutNs;
  while (producer_ - std::max(consumed(), drained_aql_) + count > capacity) {
    if (NowNs() >= deadline) Fail("AQL ring full queue=%u", id_);
    std::this_thread::yield();
  }
  const uint64_t first = producer_;
  producer_ += count;
  pointers_.Store64(56, producer_);
  return first;
}
void Queue::PublishAql(uint64_t index, const void* packet) {
  Check(aql_ && index < producer_ && producer_ - index <= ring_bytes_ / 64,
        "AQL publication outside reserved window");
  auto* slot = static_cast<char*>(ring_.data) + (index % (ring_bytes_ / 64)) * 64;
  if (metadata_) PublishMetadata(index, packet);
  // Commit header last; firmware must never see a partially populated packet.
  std::memcpy(slot + 4, static_cast<const char*>(packet) + 4, 60);
  __atomic_thread_fence(__ATOMIC_RELEASE);
  __asm__ __volatile__("sfence" ::: "memory");
  uint32_t header;
  std::memcpy(&header, packet, 4);
  __atomic_store_n(reinterpret_cast<uint32_t*>(slot), header, __ATOMIC_RELEASE);
}
uint64_t Queue::AqlMetadataSlotAddress(uint64_t index) const {
  Check(metadata_ && index < producer_ && producer_ - index <= ring_bytes_ / 64,
        "metadata slot outside reserved window");
  return ring_.address(ring_bytes_ + (index % (ring_bytes_ / 64)) * 256);
}
void Queue::PublishMetadata(uint64_t index, const void* packet) {
  const AqlMetadata data = MakeMetadata(packet);
  auto* slot = reinterpret_cast<uint32_t*>(AqlMetadataSlotAddress(index));
  for (uint32_t block = 0; block < 4; ++block)
    std::memcpy(slot + block * 16 + 1, data.words + block * 16 + 1, 60);
  __asm__ __volatile__("sfence" ::: "memory");
  for (uint32_t block = 4; block-- > 0;)
    __atomic_store_n(slot + block * 16, data.words[block * 16], __ATOMIC_RELEASE);
}
void Queue::NotifyAql() {
  Check(aql_ && producer_, "AQL notification without reservation");
  __asm__ __volatile__("sfence" ::: "memory");
  __atomic_store_n(doorbell_, producer_ - 1, __ATOMIC_RELEASE);
}
uint64_t Queue::AqlSlotAddress(uint64_t index) const {
  Check(aql_ && index < producer_ && producer_ - index <= ring_bytes_ / 64,
        "AQL slot outside reserved window");
  return ring_.address((index % (ring_bytes_ / 64)) * 64);
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
  Check(!aql_ && producer_ == 0 && consumed() == 0 && !(index % (ring_bytes_ / 4)),
        "counter seed requires unused PM4 queue and ring-aligned index");
  // Hardware PM4 RPTR is ring-relative. Lift the software counters by whole
  // rings, as in tinygrad's 64-bit doorbell regression; no packets are skipped.
  producer_ = consumed_ = index;
  pointers_.Store64(64, index);
}
void Queue::Drain() {
  if (aql_) {
    if (drained_aql_ == producer_) return;
    // AQL's barrier bit orders this marker after all earlier packets. Its
    // completion plus slot invalidation proves that backing can be reused,
    // even when the asynchronously reported read index still trails the tail.
    // Public HSA barrier/header/completion ABI: hsa.h, linked in support/aql.h.
    // Offset 3072 is beyond the public AMD queue-v2 fields (including the
    // 128-entry scratch-index array) and our error words at byte 512.
    constexpr size_t signal_offset = 3072;
    ResetSignal(pointers_, signal_offset);
    uint64_t barrier[8]{};
    barrier[0] = 3u | (1u << 8) | (2u << 9) | (2u << 11);
    barrier[7] = pointers_.address(signal_offset);
    const uint64_t index = ReserveAql(1);
    PublishAql(index, barrier);
    NotifyAql();
    WaitSignal(pointers_, signal_offset, *this);
    const uint64_t deadline = NowNs() + kTimeoutNs;
    while ((ring_.Load((index % (ring_bytes_ / 64)) * 16) & 0xff) != 1) {
      if (NowNs() >= deadline) {
        Dump();
        Fail("AQL drain marker not invalidated queue=%u", id_);
      }
      std::this_thread::yield();
    }
    drained_aql_ = producer_;
    return;
  }
  const uint64_t deadline = NowNs() + kTimeoutNs;
  while (consumed() != producer_) {
    if (NowNs() >= deadline) {
      Dump();
      Fail("drain timeout queue=%u producer=%llu consumed=%llu", id_, (unsigned long long)producer_,
           (unsigned long long)consumed_);
    }
    std::this_thread::yield();
  }
}
// Static wave32 scratch setup from public ROCr InitScratchSRD and registers.h:
// https://github.com/ROCm/rocm-systems/blob/96f1528fa5c5a0e12d706dbf4507c441c456f6eb/projects/rocr-runtime/runtime/hsa-runtime/core/runtime/amd_aql_queue.cpp
void Queue::SetScratch(Buffer& backing, uint32_t bytes_per_lane) {
  Check(kGfxMajor == 12, "static scratch helper requires gfx12");
  Check(aql_ && drained_aql_ == producer_, "scratch update requires drained AQL queue");
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
  // CP caches the queue's scratch descriptor on queue-connect. Updating a
  // drained queue still requires an unmap/remap to refresh that cached copy.
  // Public ROCr AqlQueue scratch-reclaim protocol (amd_aql_queue.cpp above).
  const bool resume = enabled_;
  if (resume) SetEnabled(false);
  pointers_.Store(35, waves | (wave_units << 12));  // COMPUTE_TMPRING_SIZE_GFX12.
  pointers_.Store(36, uint32_t(backing.address()));
  pointers_.Store(37, uint32_t(backing.address() >> 32) | (1u << 30));
  pointers_.Store(38, bytes / device_.Property("num_xcc"));
  // X/Y/Z/W selectors; 32_UINT format; ADD_TID; OOB disabled for swizzled scratch.
  pointers_.Store(39,
                  4u | (5u << 3) | (6u << 6) | (7u << 9) | (0x14u << 12) | (1u << 23) | (2u << 28));
  pointers_.Store64(160, backing.address());
  pointers_.Store64(168, bytes);
  pointers_.Store(44, bytes_per_lane / 2);  // Legacy wave64 per-lane representation.
  __asm__ __volatile__("sfence" ::: "memory");
  if (resume) SetEnabled(true);
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
  update.ring_size = ring_bytes_;
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
