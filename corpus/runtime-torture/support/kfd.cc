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
#include <signal.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <unistd.h>

#include <cerrno>
#include <cstdarg>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <fstream>
#include <thread>

namespace torture {
namespace {
constexpr uint64_t kTimeoutNs = 10000000000ull;
constexpr size_t kDoorbellBytes = 8192;
size_t PageAlign(size_t size) { return (size + 4095) & ~size_t{4095}; }
void Watchdog(int) {
  constexpr char message[] = "FAIL process watchdog expired\n";
  (void)!write(STDERR_FILENO, message, sizeof(message) - 1);
  _exit(124);
}
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

[[noreturn]] void Fail(const char* format, ...) {
  std::fputs("FAIL ", stderr);
  va_list args;
  va_start(args, format);
  std::vfprintf(stderr, format, args);
  va_end(args);
  std::fputc('\n', stderr);
  std::fflush(nullptr);
  // On failure, let KFD process teardown retire queues before freeing BOs.
  // Unwinding individual buffers after a timeout could free live GPU storage.
  std::_Exit(1);
}
void Check(bool condition, const char* message) {
  if (!condition) Fail("%s", message);
}
uint64_t NowNs() {
  timespec t{};
  Check(clock_gettime(CLOCK_MONOTONIC, &t) == 0, "clock_gettime");
  return uint64_t(t.tv_sec) * 1000000000 + t.tv_nsec;
}
uint32_t Option(int argc, char** argv, const char* name, uint32_t fallback, uint32_t maximum) {
  for (int i = 1; i < argc; ++i) {
    if (std::strcmp(argv[i], name)) continue;
    Check(i + 1 < argc, "missing option value");
    char* end = nullptr;
    errno = 0;
    unsigned long value = std::strtoul(argv[i + 1], &end, 10);
    if (errno || !*argv[i + 1] || *end || !value || value > maximum)
      Fail("invalid %s value: %s (1..%u)", name, argv[i + 1], maximum);
    return static_cast<uint32_t>(value);
  }
  return fallback;
}
void Start(int argc, char** argv, const char* test) {
  for (int i = 1; i < argc; i += 2) {
    const bool known = !std::strcmp(argv[i], "--iterations") || !std::strcmp(argv[i], "--queues") ||
                       !std::strcmp(argv[i], "--timeout") || !std::strcmp(argv[i], "--seed");
    if (!known || i + 1 == argc)
      Fail("usage: %s [--iterations N] [--queues N] [--timeout seconds] [--seed N]", argv[0]);
  }
  signal(SIGALRM, Watchdog);
  alarm(Option(argc, argv, "--timeout", 45, 3600));
  std::printf("RUN %s pid=%d\n", test, getpid());
  std::fflush(stdout);
}
void Pass(const char* test, uint64_t operations) {
  std::printf("PASS %s operations=%llu\n", test, (unsigned long long)operations);
}

Device::Device(uint32_t target) {
  Check(sizeof(void*) == 8 && sysconf(_SC_PAGESIZE) == 4096,
        "requires 64-bit Linux and 4 KiB pages");
  const uint32_t wanted = target == 1201 ? 120001 : target == 1250 ? 120500 : 0;
  Check(wanted != 0, "unsupported target");
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

Buffer::Buffer(Device& d, size_t bytes, bool executable, bool local)
    : device(d), size(PageAlign(bytes)) {
  Check(size != 0, "empty allocation");
  data = mmap(nullptr, size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
  if (data == MAP_FAILED) Fail("reserve VA: %s", std::strerror(errno));
  kfd_ioctl_alloc_memory_of_gpu_args alloc{};
  alloc.va_addr = address();
  alloc.size = size;
  alloc.gpu_id = device.gpu_id;
  alloc.flags = KFD_IOC_ALLOC_MEM_FLAGS_GTT | KFD_IOC_ALLOC_MEM_FLAGS_WRITABLE |
                KFD_IOC_ALLOC_MEM_FLAGS_PUBLIC | KFD_IOC_ALLOC_MEM_FLAGS_COHERENT |
                KFD_IOC_ALLOC_MEM_FLAGS_UNCACHED | KFD_IOC_ALLOC_MEM_FLAGS_NO_SUBSTITUTE;
  if (executable) alloc.flags |= KFD_IOC_ALLOC_MEM_FLAGS_EXECUTABLE;
  if (local)
    alloc.flags = KFD_IOC_ALLOC_MEM_FLAGS_VRAM | KFD_IOC_ALLOC_MEM_FLAGS_WRITABLE |
                  KFD_IOC_ALLOC_MEM_FLAGS_EXECUTABLE | KFD_IOC_ALLOC_MEM_FLAGS_NO_SUBSTITUTE;
  device.Ioctl(AMDKFD_IOC_ALLOC_MEMORY_OF_GPU, &alloc, "ALLOC_MEMORY_OF_GPU");
  handle = alloc.handle;
  if (!local) {
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

Queue::Queue(Device& device, uint32_t ring_bytes, uint32_t priority, bool aql)
    : device_(device),
      ring_(device, ring_bytes, true),
      pointers_(device, 4096),
      eop_(device, 4096, true, true),
      context_(device, ContextBytes(device), true),
      aql_(aql),
      priority_(priority) {
  Check(ring_bytes >= 4096 && !(ring_bytes & (ring_bytes - 1)) && priority <= 15,
        "invalid queue configuration");
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
    control[0] = 1;  // Single producer.
    control[1] = 1;  // Kernel dispatch feature.
    const uint64_t ring_address = ring_.address();
    std::memcpy(control + 2, &ring_address, 8);
    control[6] = ring_bytes / 64;
    control[18] = device.Property("simd_count") / device.Property("simd_per_cu") - 1;
    control[19] = device.Property("max_waves_per_simd") * device.Property("simd_per_cu") - 1;
    control[34] = 128;  // read_dispatch_id_field_base_byte_offset.
    control[45] = 2;    // IS_PTR64; scratch stays disabled.
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
  Check(aql_, "AQL submission to PM4 ring");
  const uint64_t capacity = ring_.size / 64;
  const uint64_t deadline = NowNs() + kTimeoutNs;
  while (producer_ - consumed() >= capacity) {
    if (NowNs() >= deadline) Fail("AQL ring full queue=%u", id_);
    std::this_thread::yield();
  }
  auto* slot = static_cast<char*>(ring_.data) + (producer_ % capacity) * 64;
  // Commit header last; firmware must never see a partially populated packet.
  std::memcpy(slot + 4, static_cast<const char*>(packet) + 4, 60);
  __atomic_thread_fence(__ATOMIC_RELEASE);
  __asm__ __volatile__("sfence" ::: "memory");
  uint32_t header;
  std::memcpy(&header, packet, 4);
  __atomic_store_n(reinterpret_cast<uint32_t*>(slot), header, __ATOMIC_RELEASE);
  ++producer_;
  __atomic_store_n(static_cast<uint64_t*>(pointers_.data) + 7, producer_, __ATOMIC_RELEASE);
  __asm__ __volatile__("sfence" ::: "memory");
  __atomic_store_n(doorbell_, producer_ - 1, __ATOMIC_RELEASE);
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
