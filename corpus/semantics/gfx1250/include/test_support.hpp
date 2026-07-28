#pragma once

#include <hip/hip_runtime.h>

#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <limits>
#include <span>
#include <string_view>
#include <type_traits>
#include <vector>

#define HIP_CHECK(call)                                                                           \
  do {                                                                                            \
    hipError_t error_ = (call);                                                                   \
    if (error_ != hipSuccess) {                                                                   \
      std::fprintf(stderr, "%s:%d: %s failed: %s\n", __FILE__, __LINE__, #call,                  \
                   hipGetErrorString(error_));                                                     \
      std::exit(2);                                                                                \
    }                                                                                             \
  } while (false)

namespace corpus {

inline uint64_t fnv1a64(std::span<const std::byte> bytes) {
  uint64_t digest = UINT64_C(14695981039346656037);
  for (std::byte byte : bytes) {
    digest ^= static_cast<uint8_t>(byte);
    digest *= UINT64_C(1099511628211);
  }
  return digest;
}

inline const char *test_id() {
  const char *path = __BASE_FILE__;
  const char *base = path;
  for (const char *cursor = path; *cursor; ++cursor) {
    if (*cursor == '/' || *cursor == '\\')
      base = cursor + 1;
  }
  return base;
}

inline size_t next_result_index() {
  static size_t index = 0;
  return index++;
}

inline bool record_only_mode() {
  const char *value = std::getenv("CORPUS_RECORD_ONLY");
  return value != nullptr && value[0] == '1' && value[1] == '\0';
}

template <class T>
void emit_result_record(const char *name, size_t variant, const char *comparison,
                        const std::vector<T> &values) {
  static_assert(std::is_trivially_copyable_v<T>);
  const std::string_view name_view(name);
  if (name_view.find_first_of("\"\\\n\r") != std::string_view::npos) {
    std::fprintf(stderr, "invalid result case name: %s\n", name);
    std::exit(2);
  }
  const auto bytes = std::as_bytes(std::span(values));
  const uint64_t digest = fnv1a64(bytes);
  std::printf(
      "CORPUS_RESULT {\"test\":\"%s\",\"case\":\"%s\",\"variant\":%zu,"
      "\"index\":%zu,\"count\":%zu,\"element_bytes\":%zu,"
      "\"comparison\":\"%s\","
      "\"fnv1a64\":\"%016llx\",\"data_hex\":\"",
      test_id(), name, variant, next_result_index(), values.size(), sizeof(T),
      comparison,
      static_cast<unsigned long long>(digest));
  for (std::byte byte : bytes)
    std::printf("%02x", static_cast<unsigned>(byte));
  std::printf("\"}\n");
}

inline float decode_ue5m3(unsigned byte) {
  if (byte == 0xff)
    return std::numeric_limits<float>::quiet_NaN();
  const unsigned exponent = byte >> 3;
  const unsigned mantissa = byte & 7;
  if (exponent == 0)
    return std::ldexp(static_cast<float>(mantissa) / 8.0f, -14);
  return std::ldexp(1.0f + static_cast<float>(mantissa) / 8.0f,
                    static_cast<int>(exponent) - 15);
}

template <class T> class DeviceBuffer {
public:
  explicit DeviceBuffer(size_t count) : host(count), count_(count) {
    HIP_CHECK(hipMalloc(&device, bytes()));
  }
  DeviceBuffer(const DeviceBuffer &) = delete;
  DeviceBuffer &operator=(const DeviceBuffer &) = delete;
  ~DeviceBuffer() { (void)hipFree(device); }

  size_t bytes() const { return count_ * sizeof(T); }
  size_t size() const { return count_; }
  void upload() {
    HIP_CHECK(hipMemcpy(device, host.data(), count_ * sizeof(T), hipMemcpyHostToDevice));
  }
  void clear() { HIP_CHECK(hipMemset(device, 0, count_ * sizeof(T))); }
  void download() {
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());
    HIP_CHECK(hipMemcpy(host.data(), device, count_ * sizeof(T), hipMemcpyDeviceToHost));
  }

  std::vector<T> host;
  T *device = nullptr;

private:
  size_t count_;
};

template <class T>
bool expect_equal(const char *name, const std::vector<T> &actual,
                  const std::vector<T> &expected, size_t variant = 0) {
  static_assert(std::is_arithmetic_v<T>);
  emit_result_record(name, variant, "exact", actual);
  if (record_only_mode())
    return true;
  if (actual.size() != expected.size())
    return false;
  for (size_t i = 0; i < actual.size(); ++i) {
    if (actual[i] != expected[i]) {
      std::fprintf(stderr, "%s: mismatch at %zu: got %lld, expected %lld\n", name, i,
                   static_cast<long long>(actual[i]), static_cast<long long>(expected[i]));
      return false;
    }
  }
  std::printf("PASS: %s (%zu values)\n", name, actual.size());
  return true;
}

template <class T>
bool expect_near(const char *name, const std::vector<T> &actual,
                 const std::vector<T> &expected, double tolerance = 0.0,
                 size_t variant = 0) {
  std::vector<T> normalized = actual;
  if constexpr (std::is_floating_point_v<T>) {
    for (T &value : normalized) {
      if (std::isnan(value))
        value = std::numeric_limits<T>::quiet_NaN();
    }
  }
  emit_result_record(name, variant, "near", normalized);
  if (record_only_mode())
    return true;
  if (actual.size() != expected.size())
    return false;
  for (size_t i = 0; i < actual.size(); ++i) {
    const double actual_value = static_cast<double>(actual[i]);
    const double expected_value = static_cast<double>(expected[i]);
    const bool both_nan = std::isnan(actual_value) && std::isnan(expected_value);
    const double error = std::fabs(actual_value - expected_value);
    if (!both_nan && !(error <= tolerance)) {
      std::fprintf(stderr, "%s: mismatch at %zu: got %.9g, expected %.9g\n", name, i,
                   static_cast<double>(actual[i]), static_cast<double>(expected[i]));
      return false;
    }
  }
  std::printf("PASS: %s (%zu values)\n", name, actual.size());
  return true;
}

template <class T>
bool expect_nonconstant_observation(const char *name,
                                    const std::vector<T> &actual,
                                    size_t variant = 0) {
  static_assert(std::is_arithmetic_v<T>);
  emit_result_record(name, variant, "exact", actual);
  if (record_only_mode())
    return true;
  if (actual.empty()) {
    std::fprintf(stderr, "%s: observation is empty\n", name);
    return false;
  }
  bool differs = false;
  for (size_t i = 0; i < actual.size(); ++i) {
    if constexpr (std::is_floating_point_v<T>) {
      if (!std::isfinite(actual[i])) {
        std::fprintf(stderr, "%s: non-finite value at %zu\n", name, i);
        return false;
      }
    }
    differs |= actual[i] != actual[0];
  }
  if (!differs) {
    std::fprintf(stderr, "%s: observation is permutation-invariant\n", name);
    return false;
  }
  std::printf("PASS: %s (%zu nonconstant values)\n", name, actual.size());
  return true;
}

} // namespace corpus
