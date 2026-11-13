// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT
// Bounded graph adapter. Upstream GGML remains unmodified; see NOTICE.md.
#include "ggml-alloc.h"
#include "ggml-backend.h"
#include "ggml-cpu.h"
#include "ggml.h"
#ifdef EXPERIMENT_HIP
#include "ggml-cuda.h"
#include <hip/hip_runtime_api.h>
#endif
#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstring>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <string>
#include <vector>

static int number(const char *s, int low, int high) {
  if (!s || !*s || std::strspn(s, "0123456789") != std::strlen(s))
    throw std::runtime_error("expected decimal integer");
  size_t n = 0;
  int v = std::stoi(s, &n);
  if (s[n] || v < low || v > high)
    throw std::runtime_error("integer out of bounds");
  return v;
}
// Follow upstream test-backend-ops MODE_TEST: use the CPU reference kernels,
// not the default optimized CPU backend. The upstream clone preserves tensor
// layout, op parameters and serialized inputs in a separate backend buffer.
static std::vector<float> cpu_reference(ggml_cgraph *graph) {
  std::vector<float> result(ggml_nelements(ggml_graph_node(graph, -1)));
  auto backend = ggml_backend_cpu_init();
  if (!backend)
    throw std::runtime_error("CPU reference backend unavailable");
  ggml_backend_cpu_set_n_threads(backend, 1);
  ggml_backend_cpu_set_use_ref(backend, true);
  auto copy = ggml_backend_graph_copy(backend, graph);
  if (!copy.buffer) {
    ggml_backend_free(backend);
    throw std::runtime_error("CPU reference graph allocation failed");
  }
  auto status = ggml_backend_graph_compute(backend, copy.graph);
  ggml_backend_synchronize(backend);
  auto *out = ggml_graph_node(copy.graph, -1);
  if (status == GGML_STATUS_SUCCESS)
    ggml_backend_tensor_get(out, result.data(), 0, ggml_nbytes(out));
  ggml_backend_graph_copy_free(copy);
  ggml_backend_free(backend);
  if (status != GGML_STATUS_SUCCESS)
    throw std::runtime_error("CPU reference graph compute failed");
  return result;
}
int main(int argc, char **argv) {
  try {
    if (argc < 2)
      throw std::runtime_error(
          "usage: bounded-ops rope|matvec-q4|gather-q8 "
          "[--cpu] [--k N] [--rows N] [--tokens N] [--heads N] [--neox]");
    std::string op = argv[1];
    bool cpu = false, neox = false;
    int k = 128, rows = 32, tokens = 4, heads = 4, warmups = 0, samples = 1;
    std::string target = "gfx1100";
    for (int i = 2; i < argc; ++i) {
      std::string a = argv[i];
      if (a == "--cpu")
        cpu = true;
      else if (a == "--neox")
        neox = true;
      else {
        if (i + 1 == argc)
          throw std::runtime_error("missing option value");
        const char *value = argv[++i];
        if (a == "--target") {
          target = value;
          continue;
        }
        int v = number(value, (a == "--warmups" ? 0 : 1),
                       (a == "--warmups" || a == "--samples"
                            ? std::numeric_limits<int>::max()
                            : 32768));
        if (a == "--warmups")
          warmups = v;
        else if (a == "--samples")
          samples = v;
        else if (a == "--k")
          k = v;
        else if (a == "--rows")
          rows = v;
        else if (a == "--tokens")
          tokens = v;
        else if (a == "--heads")
          heads = v;
        else
          throw std::runtime_error("unknown option");
      }
    }
    if (target != "gfx1100" && target != "gfx1201")
      throw std::runtime_error("unsupported target");
    bool rope = op == "rope", mat = op == "matvec-q4",
         gather = op == "gather-q8", q8 = gather;
    if (!rope && !mat && !gather)
      throw std::runtime_error("unknown op");
    if ((rope && k % 2) || (!rope && k % 32) ||
        (rope ? int64_t(k) * heads * tokens : int64_t(k) * rows) > 134217728 ||
        int64_t(k) * tokens > 134217728)
      throw std::runtime_error("invalid alignment or footprint bound");
    if (mat && tokens != 1)
      throw std::runtime_error("matvec requires explicit --tokens 1");
    ggml_backend_t backend = nullptr;
    if (cpu) {
      backend = ggml_backend_cpu_init();
      ggml_backend_cpu_set_n_threads(backend, 1);
    }
#ifdef EXPERIMENT_HIP
    else {
      hipDeviceProp_t properties;
      if (hipGetDeviceProperties(&properties, 0) != hipSuccess)
        throw std::runtime_error("device target query failed");
      std::string reported = properties.gcnArchName;
      if (reported != target && reported.rfind(target + ":", 0) != 0)
        throw std::runtime_error("device target mismatch");
      backend = ggml_backend_cuda_init(0);
    }
#endif
    if (!backend)
      throw std::runtime_error(
          "backend unavailable (CPU build requires --cpu)");
    auto *ctx = ggml_init({16 * 1024 * 1024, nullptr, true});
    ggml_tensor *a = nullptr, *b = nullptr, *out = nullptr;
    auto type = q8 ? GGML_TYPE_Q8_0 : GGML_TYPE_Q4_0;
    if (rope) {
      a = ggml_new_tensor_3d(ctx, GGML_TYPE_F32, k, heads, tokens);
      b = ggml_new_tensor_1d(ctx, GGML_TYPE_I32, tokens);
      out = ggml_rope(ctx, a, b, k, neox ? GGML_ROPE_TYPE_NEOX : 0);
    } else {
      a = ggml_new_tensor_2d(ctx, type, k, rows);
      if (mat) {
        b = ggml_new_tensor_2d(ctx, GGML_TYPE_F32, k, 1);
        out = ggml_mul_mat(ctx, a, b);
      } else {
        b = ggml_new_tensor_1d(ctx, GGML_TYPE_I32, tokens);
        out = ggml_get_rows(ctx, a, b);
      }
    }
    if (!ggml_backend_supports_op(backend, out))
      throw std::runtime_error("backend reports unsupported op");
    auto *graph = ggml_new_graph_custom(ctx, 16, false);
    ggml_build_forward_expand(graph, out);
    auto buf = ggml_backend_alloc_ctx_tensors(ctx, backend);
    if (!buf)
      throw std::runtime_error("buffer allocation failed");
    std::vector<float> src(ggml_nelements(a));
    for (size_t i = 0; i < src.size(); ++i)
      src[i] = float(int((i * 17 + 13) % 101) - 50) / 51.f;
    std::vector<unsigned char> packed;
    if (rope)
      ggml_backend_tensor_set(a, src.data(), 0, ggml_nbytes(a));
    else {
      packed.resize(ggml_nbytes(a));
      auto n = ggml_quantize_chunk(type, src.data(), packed.data(), 0, rows, k,
                                   nullptr);
      if (n != packed.size())
        throw std::runtime_error("quantized size mismatch");
      ggml_backend_tensor_set(a, packed.data(), 0, packed.size());
    }
    std::vector<int32_t> ix(tokens);
    for (int i = 0; i < tokens; ++i)
      ix[i] = rope ? i + 7 : (i % 3 == 0 ? 0 : (i * 7 + 3) % rows);
    std::vector<float> rhs(k);
    for (int i = 0; i < k; ++i)
      rhs[i] = float(int((i * 3) % 15) - 7) / 7.f;
    if (mat)
      ggml_backend_tensor_set(b, rhs.data(), 0, ggml_nbytes(b));
    else
      ggml_backend_tensor_set(b, ix.data(), 0, ggml_nbytes(b));
    // Poison before cloning too: graph_copy copies all allocated tensors, so
    // never ask it to read uninitialized output storage. The clone executes
    // once outside timing and cannot write the measured output or bypass
    // mutations.
    std::vector<float> got(ggml_nelements(out),
                           std::numeric_limits<float>::quiet_NaN());
    ggml_backend_tensor_set(out, got.data(), 0, ggml_nbytes(out));
    ggml_backend_synchronize(backend);
    if (ggml_graph_n_nodes(graph) != 1)
      throw std::runtime_error("expected one operation per graph");
    std::vector<float> ref = cpu_reference(graph);
    std::vector<int64_t> timings;
    for (int64_t iteration = 0; iteration < int64_t(warmups) + samples;
         ++iteration) {
      std::fill(got.begin(), got.end(),
                std::numeric_limits<float>::quiet_NaN());
      ggml_backend_tensor_set(out, got.data(), 0, ggml_nbytes(out));
      ggml_backend_synchronize(backend);
      auto start = std::chrono::steady_clock::now();
#ifdef BENCHMARK_CPU_NOOP
      auto status = GGML_STATUS_SUCCESS;
#else
      auto status = ggml_backend_graph_compute(backend, graph);
#endif
      ggml_backend_synchronize(backend);
      auto ns = std::chrono::duration_cast<std::chrono::nanoseconds>(
                    std::chrono::steady_clock::now() - start)
                    .count();
      if (status != GGML_STATUS_SUCCESS || ns <= 0)
        throw std::runtime_error("graph compute or timing failed");
      if (iteration >= warmups)
        timings.push_back(ns);
    }
    ggml_backend_tensor_get(out, got.data(), 0, ggml_nbytes(out));
#ifdef BENCHMARK_CPU_CORRUPT
    got.back() += 1.0f;
#endif
    double maxerr = 0, maxratio = 0;
    size_t bad = 0;
    double atol = mat ? .03 : 2e-5, rtol = mat ? .02 : 2e-5;
    for (size_t i = 0; i < got.size(); ++i) {
      double e = std::abs(double(got[i]) - ref[i]),
             ratio = e / (atol + rtol * std::abs(ref[i]));
      if (!std::isfinite(got[i]) || !std::isfinite(ref[i]) || ratio > 1)
        ++bad;
      if (std::isfinite(e))
        maxerr = std::max(maxerr, e);
      if (std::isfinite(ratio))
        maxratio = std::max(maxratio, ratio);
    }
    std::cout << "{\"source_pin\":\"26d52b0f9543f441fc2bfa383557c992a4fbf4b9\","
                 "\"op\":\""
              << op << "\",\"backend\":\"" << ggml_backend_name(backend)
              << "\",\"k\":" << k << ",\"rows\":" << rows
              << ",\"tokens\":" << tokens << ",\"heads\":" << heads
              << ",\"reference_backend\":\"CPU\",\"reference_use_ref\":true"
              << ",\"reference_graph_invocations\":1"
              << ",\"graph_invocations\":" << int64_t(warmups) + samples
              << ",\"warmups\":" << warmups << ",\"checked\":" << got.size()
              << ",\"bad\":" << bad << ",\"max_abs_error\":" << maxerr
              << ",\"max_tolerance_ratio\":" << maxratio << ",\"atol\":" << atol
              << ",\"rtol\":" << rtol
              << ",\"pass\":" << (bad ? "false" : "true")
              << ",\"timings_ns\":[";
    for (size_t i = 0; i < timings.size(); ++i)
      std::cout << (i ? "," : "") << timings[i];
    std::cout << "]}\n";
    ggml_backend_buffer_free(buf);
    ggml_free(ctx);
    ggml_backend_free(backend);
    return bad ? 2 : 0;
  } catch (const std::exception &e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
