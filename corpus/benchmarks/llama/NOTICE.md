# Source and licensing notice

This directory contains first-party bounded adapters and CMake/preparation code,
not a copy of llama.cpp or GGML. They are derived from the qualified disposable
operator harness, promoted with fixed-count sampling, protocol/provenance gates
and host-only corruption controls. Upstream operator/quantization/backend code
is neither copied nor patched. Numerical validation reuses the upstream CPU
reference-mode execution pattern from `tests/test-backend-ops.cpp` MODE_TEST
(`ggml_backend_cpu_set_use_ref`), with `ggml_backend_graph_copy` from
`ggml/src/ggml-backend.cpp` to preserve serialized inputs and operation parameters
in a separate buffer. Reference kernels remain in upstream `ggml/src/ggml-cpu/`;
the adapter does not implement a separate numerical oracle or adopt the upstream
test suite's numerical comparison thresholds.

Required upstream: https://github.com/ggml-org/llama.cpp
Exact revision: `26d52b0f9543f441fc2bfa383557c992a4fbf4b9`.
`LICENSE` is copied verbatim from that revision: MIT License,
Copyright (c) 2023–2026 The ggml authors.

Source-backed device entry points at that revision:

- `ggml/src/ggml-cuda/rope.cu`: normal RoPE.
- `ggml/src/ggml-cuda/mmvq.cu` (and quantization support): Q4_0 single-RHS
  matvec, including backend activation packing within graph execution.
- `ggml/src/ggml-cuda/getrows.cu`: Q8_0 gather/dequantization.
- `ggml/src/ggml-hip/CMakeLists.txt`: compiles these upstream CUDA-named
  sources as HIP. CUDA-style GGML public API names do not imply CUDA execution.

These are source-derived route expectations, not new runtime trace evidence.
Preserve the verified checkout's original LICENSE and any component notices
when retaining or redistributing linked binaries/source. The build receipt
records the exact source/license and first-party adapter hashes. The source
checkout must be supplied explicitly, remains pristine, and is distinct from
the corpus's pre-existing llama sources/pin; no upgrade is performed here.
