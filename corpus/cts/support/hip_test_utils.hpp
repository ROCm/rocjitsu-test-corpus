// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#ifndef FPSAN_SUPPORT_HIP_TEST_UTILS_HPP
#define FPSAN_SUPPORT_HIP_TEST_UTILS_HPP

#include "test_utils.hpp"

#include <hip/hip_runtime.h>

#include <cstddef>
#include <string>
#include <vector>

#define HIP_CHECK(e) ASSERT_EQ((e), hipSuccess)

inline bool have_device()
{
    int n = 0;
    return hipGetDeviceCount(&n) == hipSuccess && n > 0;
}

inline bool device_is_gfx1250()
{
    int dev = 0;
    if(hipGetDevice(&dev) != hipSuccess)
        return false;
    hipDeviceProp_t prop{};
    if(hipGetDeviceProperties(&prop, dev) != hipSuccess)
        return false;
    return std::string(prop.gcnArchName).compare(0, 7, "gfx1250") == 0;
}

inline bool device_is_gfx12()
{
    int dev = 0;
    if(hipGetDevice(&dev) != hipSuccess)
        return false;
    hipDeviceProp_t prop{};
    if(hipGetDeviceProperties(&prop, dev) != hipSuccess)
        return false;
    return std::string(prop.gcnArchName).compare(0, 5, "gfx12") == 0;
}

inline bool device_is_gfx950()
{
    int dev = 0;
    if(hipGetDevice(&dev) != hipSuccess)
        return false;
    hipDeviceProp_t prop{};
    if(hipGetDeviceProperties(&prop, dev) != hipSuccess)
        return false;
    return std::string(prop.gcnArchName).compare(0, 6, "gfx950") == 0;
}

template <class T>
T* to_dev(const std::vector<T>& h)
{
    T* d = nullptr;
    (void)hipMalloc(&d, h.size() * sizeof(T));
    (void)hipMemcpy(d, h.data(), h.size() * sizeof(T), hipMemcpyHostToDevice);
    return d;
}

template <class T>
std::vector<T> from_dev(const T* d, std::size_t n)
{
    std::vector<T> h(n);
    (void)hipMemcpy(h.data(), d, n * sizeof(T), hipMemcpyDeviceToHost);
    return h;
}

#endif // FPSAN_SUPPORT_HIP_TEST_UTILS_HPP
