#ifndef TORTURE_TESTS_SUPPORT_KFD_H_
#define TORTURE_TESTS_SUPPORT_KFD_H_

#include <cstddef>
#include <cstdint>
#include <map>
#include <string>
#include <vector>

namespace torture {
class Queue;

[[noreturn]] void Fail(const char* format, ...);
void Check(bool condition, const char* message);
uint64_t NowNs();
uint32_t Option(int argc, char** argv, const char* name, uint32_t fallback, uint32_t maximum);
void Start(int argc, char** argv, const char* test);
void Pass(const char* test, uint64_t operations);

// One native VM per process. Tests fork/exec before constructing a Device.
struct Device {
  explicit Device(uint32_t target);
  ~Device();
  Device(const Device&) = delete;
  Device& operator=(const Device&) = delete;
  void Ioctl(unsigned long request, void* argument, const char* operation);
  uint64_t Property(const char* name) const;
  uint64_t* Doorbell(uint64_t offset);
  int kfd = -1;
  int drm = -1;
  uint32_t gpu_id = 0;
  uint32_t gfx = 0;
  std::map<std::string, uint64_t> properties;

 private:
  void* doorbells_ = nullptr;
  uint64_t doorbell_offset_ = 0;
};

// Coherent, uncached GTT with identical CPU and GPU virtual addresses.
// Backing must outlive every command referring to it.
struct Buffer {
  Buffer(Device& device, size_t bytes, bool executable = false, bool local = false);
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

// Single host producer per queue. Shared-producer tests serialize Submit.
// The wrapped hardware RPTR cannot disambiguate a completely full ring, so
// reserve one dword. Consumption is separate from application completion.
class Queue {
 public:
  explicit Queue(Device& device, uint32_t ring_bytes = 4096, uint32_t priority = 7,
                 bool aql = false);
  ~Queue();
  Queue(const Queue&) = delete;
  Queue& operator=(const Queue&) = delete;
  void Submit(const std::vector<uint32_t>& words);
  void SubmitAql(const void* packet);
  void Drain();
  void SetPriority(uint32_t priority);
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
  uint32_t id_ = 0;
  uint64_t* doorbell_ = nullptr;
  uint64_t producer_ = 0;
  uint64_t consumed_ = 0;
  bool aql_ = false;
  uint32_t priority_ = 7;
  bool enabled_ = true;
};
}  // namespace torture
#endif
