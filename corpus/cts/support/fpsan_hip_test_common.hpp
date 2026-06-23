// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#ifndef FPSAN_HIP_TEST_COMMON_HPP
#define FPSAN_HIP_TEST_COMMON_HPP

#include <hip/hip_runtime.h>

#include <cstddef>
#include <vector>

#define FPSAN_HIP_ASSERT(call)        \
    do                                \
    {                                 \
        if((call) != hipSuccess)      \
            return 1;                 \
    } while(0)

inline bool have_device()
{
    int n = 0;
    return hipGetDeviceCount(&n) == hipSuccess && n > 0;
}

template <class T>
int to_dev(const std::vector<T>& h, T** d)
{
    *d = nullptr;
    if(hipMalloc(d, h.size() * sizeof(T)) != hipSuccess)
        return 1;
    if(hipMemcpy(*d, h.data(), h.size() * sizeof(T), hipMemcpyHostToDevice) != hipSuccess)
        return 1;
    return 0;
}

template <class T>
int from_dev(const T* d, std::size_t n, std::vector<T>& h)
{
    h.resize(n);
    if(hipMemcpy(h.data(), d, n * sizeof(T), hipMemcpyDeviceToHost) != hipSuccess)
        return 1;
    return 0;
}

#endif // FPSAN_HIP_TEST_COMMON_HPP
