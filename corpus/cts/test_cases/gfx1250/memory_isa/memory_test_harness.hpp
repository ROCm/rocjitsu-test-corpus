// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#pragma once

#include "../../../support/hip_test_utils.hpp"

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include <array>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <vector>

namespace memory_isa_test {

constexpr int kWaveLanes = 32;
constexpr std::uint32_t kWordCanary = 0xa5c39e71u;
constexpr std::uint8_t kByteCanary = 0xd7u;

using u32x2 = std::uint32_t __attribute__((ext_vector_type(2)));
using u32x3 = std::uint32_t __attribute__((ext_vector_type(3)));
using u32x4 = std::uint32_t __attribute__((ext_vector_type(4)));
using u32x8 = std::uint32_t __attribute__((ext_vector_type(8)));
using u32x16 = std::uint32_t __attribute__((ext_vector_type(16)));
using u32x32 = std::uint32_t __attribute__((ext_vector_type(32)));

constexpr std::uint32_t lane_word(unsigned lane, unsigned slot) {
  return 0x41000000u ^ (lane * 0x00010101u) ^ (slot * 0x0103070bu);
}

constexpr std::uint8_t coordinate_byte(unsigned x, unsigned y, unsigned z = 0, unsigned w = 0,
                                       unsigned q = 0) {
  return static_cast<std::uint8_t>(1u + 17u * x + 29u * y + 43u * z + 59u * w + 71u * q);
}

template <class To, class From> To bit_copy(const From &from) {
  static_assert(sizeof(To) == sizeof(From));
  To to{};
  std::memcpy(&to, &from, sizeof(to));
  return to;
}

template <class T> class DeviceBuffer {
public:
  DeviceBuffer() = default;
  DeviceBuffer(const DeviceBuffer &) = delete;
  DeviceBuffer &operator=(const DeviceBuffer &) = delete;
  DeviceBuffer(DeviceBuffer &&other) noexcept : pointer_(other.pointer_), count_(other.count_) {
    other.pointer_ = nullptr;
    other.count_ = 0;
  }
  DeviceBuffer &operator=(DeviceBuffer &&other) noexcept {
    if (this != &other) {
      reset();
      pointer_ = other.pointer_;
      count_ = other.count_;
      other.pointer_ = nullptr;
      other.count_ = 0;
    }
    return *this;
  }
  ~DeviceBuffer() { reset(); }

  static DeviceBuffer allocate(std::size_t count) {
    DeviceBuffer buffer;
    buffer.count_ = count;
    const hipError_t status = hipMalloc(&buffer.pointer_, count * sizeof(T));
    if (status != hipSuccess) {
      ADD_FAILURE() << "device allocation failed: " << hipGetErrorString(status);
      buffer.pointer_ = nullptr;
      buffer.count_ = 0;
    }
    return buffer;
  }

  static DeviceBuffer from_host(const std::vector<T> &values) {
    DeviceBuffer buffer = allocate(values.size());
    if (!buffer)
      return buffer;
    const hipError_t status =
        hipMemcpy(buffer.pointer_, values.data(), values.size() * sizeof(T), hipMemcpyHostToDevice);
    if (status != hipSuccess) {
      ADD_FAILURE() << "host-to-device copy failed: " << hipGetErrorString(status);
      buffer.reset();
    }
    return buffer;
  }

  explicit operator bool() const { return pointer_ != nullptr; }
  T *get() const { return pointer_; }
  std::size_t size() const { return count_; }

  std::vector<T> to_host() const {
    std::vector<T> values(count_);
    if (pointer_ != nullptr) {
      const hipError_t status =
          hipMemcpy(values.data(), pointer_, count_ * sizeof(T), hipMemcpyDeviceToHost);
      if (status != hipSuccess)
        ADD_FAILURE() << "device-to-host copy failed: " << hipGetErrorString(status);
    }
    return values;
  }

private:
  void reset() {
    if (pointer_ != nullptr)
      (void)hipFree(pointer_);
    pointer_ = nullptr;
    count_ = 0;
  }

  T *pointer_ = nullptr;
  std::size_t count_ = 0;
};

struct BufferResourceWords {
  std::array<std::uint32_t, 4> words{};

  constexpr u32x4 vector() const { return {words[0], words[1], words[2], words[3]}; }
};

constexpr BufferResourceWords make_buffer_resource(std::uint64_t base, std::uint64_t num_records,
                                                   std::uint32_t stride = 0,
                                                   std::uint32_t stride_scale = 0,
                                                   bool swizzle = false, bool oob_select = false) {
  const unsigned __int128 bits =
      (static_cast<unsigned __int128>(base) & ((static_cast<unsigned __int128>(1) << 57) - 1)) |
      ((static_cast<unsigned __int128>(num_records) &
        ((static_cast<unsigned __int128>(1) << 45) - 1))
       << 57) |
      ((static_cast<unsigned __int128>(stride) & 0x3fffu) << 108) |
      ((static_cast<unsigned __int128>(stride_scale) & 0x3u) << 122) |
      (static_cast<unsigned __int128>(swizzle) << 124) |
      (static_cast<unsigned __int128>(oob_select) << 125);
  return {{static_cast<std::uint32_t>(bits), static_cast<std::uint32_t>(bits >> 32),
           static_cast<std::uint32_t>(bits >> 64), static_cast<std::uint32_t>(bits >> 96)}};
}

inline void expect_bytes_equal(const std::vector<std::uint8_t> &actual,
                               const std::vector<std::uint8_t> &expected, const char *context) {
  ASSERT_EQ(actual.size(), expected.size());
  for (std::size_t i = 0; i < expected.size(); ++i)
    EXPECT_EQ(actual[i], expected[i]) << context << " byte " << i;
}

} // namespace memory_isa_test

#define REQUIRE_GFX1250_DEVICE()                                                                   \
  do {                                                                                             \
    if (!::have_device())                                                                          \
      GTEST_SKIP() << "no HIP device available";                                                   \
    if (!::device_is_gfx1250())                                                                    \
      GTEST_SKIP() << "test requires gfx1250";                                                     \
  } while (false)
