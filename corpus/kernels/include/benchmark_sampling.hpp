// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT
#pragma once

#include <chrono>
#include <cstdint>
#include <stdexcept>
#include <vector>

namespace corpus_benchmark {
// Launch and synchronize once to initialize the runtime, then warm up and sample.
// Callers own all allocation, launch configuration, and result serialization.
template <class Clock = std::chrono::steady_clock, class Launch, class Synchronize>
std::vector<int64_t> measure(int warmups, int samples, Launch launch, Synchronize synchronize) {
    if (warmups < 0 || samples <= 0 || samples % 2 == 0)
        throw std::invalid_argument("warmups must be nonnegative and samples positive and odd");
    launch();
    synchronize();
    for (int i = 0; i < warmups; ++i) {
        launch();
        synchronize();
    }
    std::vector<int64_t> timings;
    timings.reserve(samples);
    for (int i = 0; i < samples; ++i) {
        const auto start = Clock::now();
        launch();
        synchronize();
        const auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(Clock::now() - start).count();
        if (duration <= 0) throw std::runtime_error("non-positive sample duration");
        timings.push_back(duration);
    }
    return timings;
}
} // namespace corpus_benchmark
