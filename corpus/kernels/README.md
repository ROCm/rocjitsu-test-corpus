# Kernel Corpus

Small runnable ROCm corpus for exercising kernels and higher-level library
entry points from upstream projects.

## At a Glance

The corpus keeps runnable cases separate from vendored or extracted upstream
source:

```text
cases/
  <project>/<case>/      runner, metadata, and optional overrides/helpers

third_party/
  <project>/             vendored or extracted upstream sources
```

Collected kernel cases:

- `hip-stream-k/`:
  - `simple_streamk`
  - `two_tile_streamk`
- `hip-matmul/`:
  - `matmul`
  - `matvec`
- `hipkittens/`:
  - `gemm_bf16fp32_cdna3_64x16`
  - `gemm_bf16fp32_gfx1250_naive`
  - `gemm_bf16fp32_16x32`
  - `gemm_fp8fp32_4wave`
  - `gemm_mxfp8_4wave`
- `rocblas/`:
  - `sgemm`
- `llama.cpp/`:
  - `mul_mat_vec_q`
  - `noncont_batched_matmul`
  - `noncont_batched_matmul_hazard`
  - `rms_norm`

| Case | Target Arch | Check |
| --- | --- | --- |
| `hip-stream-k/simple_streamk` | CDNA3 | Pass |
| `hip-stream-k/two_tile_streamk` | CDNA3 | Pass |
| `hip-matmul/matmul` | CDNA3 | Bug |
| `hip-matmul/matvec` | CDNA3/RDNA4 | Bug |
| `hipkittens/gemm_bf16fp32_cdna3_64x16` | `gfx942` | Pass |
| `hipkittens/gemm_bf16fp32_16x32` | `gfx950` | - |
| `hipkittens/gemm_bf16fp32_gfx1250_naive` | `gfx1250` | - |
| `hipkittens/gemm_fp8fp32_4wave` | `gfx950` | - |
| `hipkittens/gemm_mxfp8_4wave` | `gfx950` | - |
| `rocblas/sgemm` | `gfx950`/`gfx942` | - |
| `llama.cpp/mul_mat_vec_q` | CDNA3/RDNA4 | Pass |
| `llama.cpp/noncont_batched_matmul` | CDNA3/RDNA4 | Pass |
| `llama.cpp/noncont_batched_matmul_hazard` | CDNA3/RDNA4 | Pass/Bug |
| `llama.cpp/rms_norm` | CDNA3/RDNA4 | Pass |

## CMake Presets

`CMakePresets.json` only defines the shared hidden `base` preset. Put local GPU
architecture and the ROCm SDK root in
`CMakeUserPresets.json`, for example:

```json
{
  "version": 8,
  "configurePresets": [
    {
      "name": "local-hip",
      "inherits": "base",
      "cacheVariables": {
        "CMAKE_HIP_ARCHITECTURES": "<gfx target>",
        "ROCM_PATH": "<ROCm SDK root>"
      }
    }
  ],
  "buildPresets": [
    {
      "name": "local-hip",
      "configurePreset": "local-hip"
    }
  ]
}
```

To build only selected backends, add enable flags under `cacheVariables`:

```json
"KERNEL_CORPUS_ENABLE_ALL": "OFF",
"KERNEL_CORPUS_ENABLE_HIP_STREAMK": "ON"
```

`ROCM_PATH` must point at a ROCm SDK root with
`lib/cmake/hip/hip-config.cmake`. If `ROCM_PATH` is unset, CMake attempts to
discover it with `$ROCM_VENV/bin/rocm-sdk path --root` or `rocm-sdk path --root`.

Then configure and build with the local preset:

```sh
cmake --preset local-hip
cmake --build --preset local-hip
```

## Third-Party Sources

The llama.cpp GGML sources used by the llama cases are vendored in
`third_party/llama.cpp/ggml`. See `third_party/llama.cpp/NOTICE.md` and
`third_party/llama.cpp/LICENSE` for the upstream source revision and MIT license
terms.

The ROCm hip-stream-k sources used by the Stream-K runner come from the
extracted source tree in `third_party/hip-stream-k`. See
`third_party/hip-stream-k/NOTICE.md` for the upstream source reference.

The nod-ai hip-matmul sources used by the HIP matmul and matvec runners come
from the extracted source tree in `third_party/hip-matmul`. See
`third_party/hip-matmul/NOTICE.md` for the upstream source reference.

The HipKittens sources used by the MXFP8 GEMM runner come from the extracted
source tree in `third_party/hipkittens`. See
`third_party/hipkittens/NOTICE.md` for the upstream source reference.

## Corpus Layout

Runnable reproducer cases live under `cases/`. A case owns its runner, metadata,
and any local source overrides or helper CMake files:

```text
cases/
  <project>/
    <case>/
      runner.cpp|runner.hip
      case.json
      input_sets/*.json
      overrides/<relative/source/path>
      cmake/*.cmake
```

Most current llama.cpp cases link against the unmodified GGML source in
`third_party/llama.cpp/ggml`.
The non-contiguous batched matmul cases share one runner with a
`--src1-layout` selector. The fixed `noncont_batched_matmul` case embeds its
contiguous F32 src1 input directly in `case.json`, matching the other ordinary
kernel cases. The hazard backend keeps `input_sets/normal.json` and
`input_sets/trigger.json` because it intentionally exercises a known-bug kernel:
the normal input set passes and the non-contiguous triggering input set fails.
The hazard build creates a CMake-only symlink overlay from vendored GGML, copies
`ggml-cuda.cu`, and overrides it with a case-local file that restores the PR
#13155 pre-fix behavior.

The current Stream-K cases compile against extracted hip-stream-k sources in
`third_party/hip-stream-k`.

The current hip-matmul case-local wrappers compile the upstream self-contained
`matmul.hip` and `matvec.hip` programs from `third_party/hip-matmul`. Those
upstream programs include host runner code that allocates inputs and invokes the
HIP kernels.

The current HipKittens MXFP8 and FP8 cases compile upstream self-contained
4-wave GEMM programs from the HipKittens main branch. The BF16 cases wrap
upstream pybind-oriented kernel sources in standalone kernel corpus HIP runners: one
from the main branch for CDNA4 / `gfx950`, and one from the HipKittens `cdna3`
branch for CDNA3 / `gfx942`. The `gfx1250` case compiles the upstream
BF16 GEMM naive ladder rung with its standalone harness. The wrappers reduce
the default matrix and benchmark sizes for corpus runs.

Use a TheRock ROCm artifact for the ROCm/HIP stack. Point the CMake preset
below at the unpacked artifact's ROCm dist tree that you want to test.

## TheRock Artifact

Download a TheRock artifact for your GPU target, then unpack it somewhere
outside this repository:

```sh
mkdir -p ~/therock-artifacts/<gfx target>
tar -xf <therock artifact>.tar.* -C ~/therock-artifacts/<gfx target>
```

The artifact must provide a ROCm dist tree with the packages needed by this
corpus: HIP runtime, rocPRIM/rocThrust, rocBLAS, and hipBLAS.

`KERNEL_CORPUS_ENABLE_ALL=ON` makes every corpus backend default to enabled. Set it to
`OFF` when configuring a smaller build and enable individual backends with the
options below.

`KERNEL_CORPUS_ENABLE_LLAMA_HIP=ON` needs `hip`, `rocBLAS`, and `hipBLAS`.
`KERNEL_CORPUS_ENABLE_HIP_STREAMK=ON` needs `hip`, `rocThrust`/`rocPRIM`, and
`rocBLAS` for validation.
`KERNEL_CORPUS_ENABLE_HIP_MATMUL=ON` needs `hip`.
`KERNEL_CORPUS_ENABLE_HIPKITTENS=ON` needs `hip` and an OpenMP-capable host compiler
runtime.
`KERNEL_CORPUS_ENABLE_ROCBLAS=ON` needs `hip` and `rocBLAS`.

The Stream-K runner is intended for CDNA / gfx9-family targets and is not expected
to work on RDNA targets. Its extracted hip-stream-k kernels use a local fragment
layer backed by clang's `__builtin_amdgcn_mfma_f32_32x32x2f32` and
`__builtin_amdgcn_mfma_f32_32x32x8f16` builtins, so the build no longer fetches
or includes rocWMMA.

## Targets

The CMake project builds the HIP Stream-K runner by default. It also builds
llama.cpp HIP harnesses when `KERNEL_CORPUS_ENABLE_LLAMA_HIP` is enabled and
`CMAKE_HIP_ARCHITECTURES` is set.

Useful run targets:

```sh
cmake --build --preset local-hip --target run_hip_streamk_simple
cmake --build --preset local-hip --target run_hip_streamk_two_tile
cmake --build --preset local-hip --target run_llama_mul_mat_vec_q
cmake --build --preset local-hip --target run_llama_rms_norm
cmake --build --preset local-hip --target run_hip_matmul_matvec
```

Useful llama.cpp build targets:

```sh
cmake --build --preset local-hip --target llama_cpp_mul_mat_vec_q
cmake --build --preset local-hip --target llama_cpp_noncont_batched_matmul
cmake --build --preset local-hip --target llama_cpp_noncont_batched_matmul_hazard
cmake --build --preset local-hip --target llama_cpp_rms_norm
```

The llama.cpp harnesses also support correctness checks that compare the GPU
result against the GGML CPU backend. Pytest configures and builds the requested
CMake targets, materializes declared inputs from `case.json` and
`input_sets/*.json`, runs each llama.cpp binary once without `--validate` to
capture GPU output, runs it again with `--validate` to capture CPU reference
output, and compares the two outputs with the case tolerance.
For manual smoke checks of cases without declared input files, build the
harnesses, then run the binaries with `--validate`:

```sh
cmake --build --preset local-hip --target llama_cpp_kernels
./build/local-hip/cases/llama.cpp/llama_cpp_mul_mat_vec_q --validate
./build/local-hip/cases/llama.cpp/llama_cpp_rms_norm --validate
```

The RMS norm validator uses a fixed absolute tolerance of `1.0e-5f`.
The non-contiguous batched matmul validator uses a fixed absolute tolerance of
`1.0e-3f`. The fixed case uses a contiguous `src1` tensor with 17 columns. The
hazard triggering input set uses a non-contiguous `src1` view with 17 columns so
latest `gfx1201` GGML dispatch does not select `ggml_cuda_mul_mat_f` and instead
reaches the overridden batched cuBLAS path.
The quantized matvec validator uses a fixed absolute tolerance of `1.0e-2f`
because the Q4_0 CPU and GPU matvec kernels use different quantized execution
paths. This is a smoke correctness check for obviously wrong GPU output, not a
proof that every value below the tolerance is correct.

The hip-matmul runners inherit the upstream environment-variable interface.
Useful variables include `M`, `N`, `K`, `FILTER`, `SKIP_CHECK`,
`BENCHMARK_MIN_MS`, and `FIXED_ITERATIONS`.

The upstream hip-matmul `matmul.hip` runner uses MFMA intrinsics and is only
built for `gfx9`-family HIP architectures. On those targets, the additional run
target is `run_hip_matmul_matmul`.

The HipKittens GEMM runners support CDNA3 / `gfx942`, CDNA4 / `gfx950`, and
`gfx1250` with different upstream sources. On `gfx942`, the additional
run target is `run_hipkittens_gemm_bf16fp32_cdna3_64x16`. On `gfx950`, the
additional run targets are `run_hipkittens_gemm_mxfp8_4wave`,
`run_hipkittens_gemm_fp8fp32_4wave`, and
`run_hipkittens_gemm_bf16fp32_16x32`. On `gfx1250`, the additional run target
is `run_hipkittens_gemm_bf16fp32_gfx1250_naive`. The runners compute CPU
references, validate GPU output, and then run short corpus-sized benchmarks
where the upstream runner includes benchmarking.
