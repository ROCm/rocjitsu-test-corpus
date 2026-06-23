// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#ifndef FPSAN_TEST_COMMON_HPP
#define FPSAN_TEST_COMMON_HPP

#include <cstdint>
#include <cstring>
#include <random>

#define FPSAN_ASSERT_TRUE(cond) \
    do                          \
    {                           \
        if(!(cond))             \
            return 1;           \
    } while(0)

#define FPSAN_ASSERT_EQ(actual, expected) \
    do                                    \
    {                                     \
        if((actual) != (expected))        \
            return 1;                     \
    } while(0)

template <class T>
std::uint64_t bits_of(T v)
{
    std::uint64_t u = 0;
    std::memcpy(&u, &v, sizeof v);
    return u;
}

namespace fpsan_test
{
    inline std::mt19937 make_rng()
    {
        return std::mt19937{};
    }

    inline int pick_int(std::mt19937& rng, int lo, int hi)
    {
        const std::uint32_t span = static_cast<std::uint32_t>(hi - lo + 1);
        return lo + static_cast<int>(static_cast<std::uint32_t>(rng()) % span);
    }

    template <class T>
    T pick_int_valued(std::mt19937& rng, int lo, int hi)
    {
        return static_cast<T>(static_cast<float>(pick_int(rng, lo, hi)));
    }

    template <class T>
    T pick_quarter(std::mt19937& rng, int lo4, int hi4)
    {
        return static_cast<T>(pick_int(rng, lo4, hi4)) / static_cast<T>(4);
    }
} // namespace fpsan_test

#endif // FPSAN_TEST_COMMON_HPP
