#pragma once

#include <hip/hip_runtime_api.h>

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <exception>
#include <filesystem>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <stdexcept>
#include <string>
#include <vector>

namespace guitar_hero {
struct Configuration {
  const char *kernel;
  const char *target;
  const char *code_object;
  const char *const *checkpoints;
  size_t checkpoint_count;
};

constexpr size_t threads = 64;
constexpr size_t checkpoint_words = threads * 2;
constexpr std::array<uint32_t, 3> seeds = {1, 0x12345678, 0xffffffff};
using Digest = std::array<uint64_t, 2>;

inline void check(hipError_t result) {
  if (result != hipSuccess)
    throw std::runtime_error(hipGetErrorString(result));
}

// Preserve wave, lane and hash-word order in diagnostic digests.
inline Digest digest(const uint32_t *words) {
  Digest result = {0xcbf29ce484222325ULL, 0x6a09e667f3bcc909ULL};
  for (size_t i = 0; i < checkpoint_words; ++i) {
    result[0] = (result[0] ^ words[i]) * 0x100000001b3ULL;
    result[1] ^= uint64_t(words[i]) + 0x9e3779b97f4a7c15ULL + (result[1] << 6) +
                 (result[1] >> 2);
  }
  return result;
}

inline uint32_t number(const char *value, uint32_t low, uint32_t high) {
  size_t used = 0;
  const std::string text(value);
  auto n = std::stoull(text, &used, 0);
  if (used != text.size() || n < low || n > high)
    throw std::runtime_error("Numeric option out of range: " + text);
  return static_cast<uint32_t>(n);
}

struct DeviceBuffer {
  uint32_t *ptr = nullptr;
  explicit DeviceBuffer(size_t words) {
    check(hipMalloc(reinterpret_cast<void **>(&ptr), words * sizeof(uint32_t)));
  }
  ~DeviceBuffer() {
    if (ptr)
      (void)hipFree(ptr);
  }
  DeviceBuffer(const DeviceBuffer &) = delete;
  DeviceBuffer &operator=(const DeviceBuffer &) = delete;
};

inline int run(int argc, char **argv, const Configuration &config) {
  try {
    const auto directory =
        std::filesystem::canonical("/proc/self/exe").parent_path();
    auto code_object = directory / config.code_object;
    const size_t checkpoint_count = config.checkpoint_count;
    const size_t group_words = checkpoint_count * checkpoint_words;
    uint32_t groups = 1, iterations = 1, trace_id = 0, stop = 0;
    int selected_seed = -1;
    bool dump_digests = false;
    for (int i = 1; i < argc; ++i) {
      const std::string arg(argv[i]);
      auto value = [&]() {
        if (++i == argc)
          throw std::runtime_error("Missing value for " + arg);
        return argv[i];
      };
      if (arg == "--groups")
        groups = number(value(), 1, 4096);
      else if (arg == "--iterations")
        iterations = number(value(), 1, 100000);
      else if (arg == "--seed-index")
        selected_seed = number(value(), 0, seeds.size() - 1);
      else if (arg == "--stop-after-checkpoint")
        stop = number(value(), 0, checkpoint_count - 1) + 1;
      else if (arg == "--dump-checkpoint")
        trace_id = number(value(), 0, checkpoint_count - 1) + 1;
      else if (arg == "--code-object")
        code_object = value();
      else if (arg == "--dump-digests")
        dump_digests = true;
      else if (arg == "--help") {
        std::cout << config.kernel
                  << " [--groups 1..4096] [--iterations 1..100000] "
                     "[--seed-index 0..2] [--dump-checkpoint 0.."
                  << checkpoint_count - 1
                  << "] [--stop-after-checkpoint N] [--dump-digests] "
                     "[--code-object PATH]\n";
        return 0;
      } else
        throw std::runtime_error("Unknown option: " + arg);
    }
    if (trace_id && groups != 1)
      throw std::runtime_error("--dump-checkpoint requires --groups 1");
    if (trace_id && stop && trace_id > stop)
      throw std::runtime_error(
          "Requested dump is after the stopping checkpoint");

    int devices = 0, device = -1;
    check(hipGetDeviceCount(&devices));
    hipDeviceProp_t properties{};
    for (int i = 0; i < devices; ++i) {
      check(hipGetDeviceProperties(&properties, i));
      const std::string arch(properties.gcnArchName);
      if (arch == config.target ||
          arch.rfind(std::string(config.target) + ":", 0) == 0) {
        device = i;
        break;
      }
    }
    if (device < 0)
      throw std::runtime_error(std::string("No ") + config.target +
                               " device is visible");
    check(hipSetDevice(device));
    const size_t completed = stop ? stop : checkpoint_count;
    std::cerr << "device=" << properties.name
              << " target=" << properties.gcnArchName << " groups=" << groups
              << " iterations=" << iterations << " checkpoints=" << completed
              << "/" << checkpoint_count << '\n';
    hipModule_t module;
    hipFunction_t kernel;
    check(hipModuleLoad(&module, code_object.c_str()));
    check(hipModuleGetFunction(&kernel, module, config.kernel));
    DeviceBuffer output(size_t(groups) * group_words), trace(threads * 16),
        workspace(size_t(groups) * 1024);
    std::vector<uint32_t> results(size_t(groups) * group_words);
    hipEvent_t start, end;
    check(hipEventCreate(&start));
    check(hipEventCreate(&end));
    bool passed = true;
    if (dump_digests)
      std::cout << "guitar_hero_digests_v1 " << config.kernel << ' '
                << config.target << ' ' << completed << ' ' << threads << '\n';

    for (size_t seed_index = 0; seed_index < seeds.size(); ++seed_index) {
      if (selected_seed >= 0 && seed_index != size_t(selected_seed))
        continue;
      uint32_t seed = seeds[seed_index];
      void *args[] = {&output.ptr, &trace.ptr, &seed,
                      &trace_id,   &stop,      &workspace.ptr};
      check(hipMemset(output.ptr, 0xa5, results.size() * sizeof(uint32_t)));
      check(hipMemset(trace.ptr, 0xa5, threads * 16 * sizeof(uint32_t)));
      check(hipEventRecord(start));
      for (uint32_t it = 0; it < iterations; ++it)
        check(hipModuleLaunchKernel(kernel, groups, 1, 1, threads, 1, 1, 0,
                                    nullptr, args, nullptr));
      check(hipEventRecord(end));
      check(hipEventSynchronize(end));
      float milliseconds = 0;
      check(hipEventElapsedTime(&milliseconds, start, end));
      check(hipMemcpy(results.data(), output.ptr,
                      results.size() * sizeof(uint32_t),
                      hipMemcpyDeviceToHost));
      for (size_t group = 1; group < groups; ++group) {
        for (size_t cp = 0; cp < completed; ++cp) {
          const auto *reference = results.data() + cp * checkpoint_words;
          const auto *actual = reference + group * group_words;
          if (!std::equal(reference, reference + checkpoint_words, actual)) {
            std::cerr << "FAIL seed-index=" << seed_index << " group=" << group
                      << " first-checkpoint=" << cp << " ("
                      << config.checkpoints[cp] << ") differs from group 0\n";
            passed = false;
            break;
          }
        }
      }
      if (dump_digests) {
        for (size_t cp = 0; cp < completed; ++cp) {
          auto value = digest(results.data() + cp * checkpoint_words);
          std::cout << std::hex << seed << ' ' << config.checkpoints[cp] << ' '
                    << value[0] << ' ' << value[1] << std::dec << '\n';
        }
      }
      std::cerr << "seed-index=" << seed_index
                << " mean-launch-us=" << milliseconds * 1000 / iterations
                << '\n';
      if (trace_id) {
        std::array<uint32_t, threads * 16> raw{};
        check(hipMemcpy(raw.data(), trace.ptr, sizeof(raw),
                        hipMemcpyDeviceToHost));
        std::cerr << "checkpoint=" << trace_id - 1 << " ("
                  << config.checkpoints[trace_id - 1] << ") raw v16..v31\n";
        for (size_t lane = 0; lane < threads; ++lane) {
          std::cerr << std::dec << lane;
          for (size_t reg = 0; reg < 16; ++reg)
            std::cerr << ' ' << std::hex << std::setw(8) << std::setfill('0')
                      << raw[lane * 16 + reg];
          std::cerr << std::dec << '\n';
        }
      }
    }
    check(hipEventDestroy(start));
    check(hipEventDestroy(end));
    check(hipModuleUnload(module));
    std::cerr << (passed ? "PASS" : "FAIL") << ' ' << config.kernel
              << " smoke checkpoints=" << completed << "/" << checkpoint_count
              << " groups=" << groups << '\n';
    return passed ? 0 : 1;
  } catch (const std::exception &error) {
    std::cerr << config.kernel << ": " << error.what() << '\n';
    return 1;
  }
}
} // namespace guitar_hero
