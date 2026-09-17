// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT
#pragma once

#include "benchmark_sampling.hpp"
#include <hip/hip_runtime.h>
#include <climits>
#include <cerrno>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

namespace corpus_benchmark {
struct Options {
    bool enabled = false;
    int warmups = 3;
    int samples = 21;
    std::string case_id, target, output;
    std::vector<char*> remaining;
};

inline int integer(const char* value, int minimum) {
    char* end = nullptr;
    errno = 0;
    long parsed = std::strtol(value, &end, 10);
    if (errno || end == value || *end || parsed < minimum || parsed > INT_MAX)
        throw std::invalid_argument("invalid integer argument");
    return static_cast<int>(parsed);
}

inline Options parse(int argc, char** argv) {
    Options options;
    options.remaining.push_back(argv[0]);
    bool supplied = false;
    for (int i = 1; i < argc; ++i) {
        std::string arg(argv[i]);
        if (arg == "--benchmark") { options.enabled = true; continue; }
        if (arg == "--warmups" || arg == "--samples" || arg == "--case" || arg == "--target" || arg == "--output") {
            supplied = true;
            if (++i >= argc) throw std::invalid_argument("missing value for " + arg);
            if (arg == "--warmups") options.warmups = integer(argv[i], 0);
            else if (arg == "--samples") options.samples = integer(argv[i], 1);
            else if (arg == "--case") options.case_id = argv[i];
            else if (arg == "--target") options.target = argv[i];
            else options.output = argv[i];
        } else options.remaining.push_back(argv[i]);
    }
    if (supplied && !options.enabled) throw std::invalid_argument("sampling arguments require --benchmark");
    if (options.enabled && (options.case_id.empty() || options.target.empty() || options.output.empty() || options.samples % 2 == 0))
        throw std::invalid_argument("benchmark requires case, target, output, and an odd sample count");
    return options;
}

inline void check(hipError_t error) {
    if (error != hipSuccess) throw std::runtime_error(hipGetErrorString(error));
}

inline void check_target(const Options& options) {
    int device;
    check(hipGetDevice(&device));
    hipDeviceProp_t properties{};
    check(hipGetDeviceProperties(&properties, device));
    const std::string actual(properties.gcnArchName);
    if (actual != options.target && actual.rfind(options.target + ":", 0) != 0)
        throw std::runtime_error("HIP target " + actual + " does not match " + options.target);
}

inline void check_shape(int m, int n, int k, int tile_m, int tile_n, int tile_k, int minimum_k) {
    if (m <= 0 || n <= 0 || k < minimum_k || m % tile_m || n % tile_n || k % tile_k ||
        int64_t(m)*n > INT_MAX || int64_t(m)*k > INT_MAX || int64_t(n)*k > INT_MAX)
        throw std::invalid_argument("dimensions exceed kernel indexing or violate tile/pipeline constraints");
}

inline std::string quote(const std::string& value) {
    std::string result = "\"";
    for (unsigned char c : value) {
        if (c == '\\' || c == '"') result += '\\';
        if (c < 32) throw std::invalid_argument("control character in result metadata");
        result += char(c);
    }
    return result + '"';
}

template <class Launch>
void run(const Options& options, int m, int n, int k, Launch launch) {
    const auto timings = measure(options.warmups, options.samples, [&] {
        launch();
        check(hipGetLastError());
    }, [] { check(hipDeviceSynchronize()); });
    std::ofstream stream(options.output);
    if (!stream) throw std::runtime_error("cannot open benchmark output");
    stream << "{\"schema\":\"rocjitsu.benchmark.workload.v1\",\"provider\":\"hipkittens\",\"case\":"
           << quote(options.case_id) << ",\"target\":" << quote(options.target)
           << ",\"parameters\":{\"m\":" << m << ",\"n\":" << n << ",\"k\":" << k
           << ",\"dtype\":\"bf16\",\"output_dtype\":\"bf16\",\"accumulation_dtype\":\"fp32\",\"layout\":\"ABt\"},\"timings_ns\":[";
    for (size_t i = 0; i < timings.size(); ++i) {
        if (i) stream << ',';
        stream << timings[i];
    }
    stream << "]}\n";
    stream.close();
    if (!stream) throw std::runtime_error("cannot write benchmark output");
}
} // namespace corpus_benchmark
