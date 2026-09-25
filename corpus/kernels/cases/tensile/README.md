# Packaged Tensile SGEMM cases

These two gfx1250 cases execute fixed MT16×32 and MT32×16 solutions from
`sk_sgemm_quick` group 00. Each case has 127³, 128³, and 129³ variants.
The operation is FP32 `D = A × Bᵀ + C`, with batch count 1, alpha 1, and beta 1.
A and B use column-major storage. C and D have separate allocations, so repeated
launches compute the same result.

[artifacts.json](artifacts.json) records the source revision, solution indices,
kernel names, and SHA-256 hashes of the packaged YAML and code objects. CMake
checks those hashes during configuration; each executable checks them again
before loading. Build provenance is copied to `cases/tensile/provenance.json`
under the build directory and printed in workload logs.

## Build the native adapter

Use the benchmark environment's ROCm SDK, CMake 3.28 or later, and Ninja.
The SDK must provide its AMD Clang compiler, HIP headers/runtime, LLVM CMake
package and static libraries (including `LLVMObjectYAML`), and ROCm CMake build
tools. LLVM also needs the system zlib and zstd development packages.

From the corpus repository root:

```sh
TENSILE_SDK_ROOT=$(rocm-sdk path --root)
cmake -S corpus/kernels -B build/tensile -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DROCM_PATH="$TENSILE_SDK_ROOT" \
  -DCMAKE_C_COMPILER="$TENSILE_SDK_ROOT/lib/llvm/bin/amdclang" \
  -DCMAKE_CXX_COMPILER="$TENSILE_SDK_ROOT/lib/llvm/bin/amdclang++" \
  -DCMAKE_HIP_ARCHITECTURES=gfx1250 \
  -DKERNEL_CORPUS_ENABLE_ALL=OFF \
  -DKERNEL_CORPUS_ENABLE_TENSILE=ON
cmake --build build/tensile --parallel 8
```

CMake downloads the pinned rocm-libraries source archive and builds TensileLite's
host library and origami. It doesn't generate device code or build the upstream
client, tests, or Python bindings. For an existing checkout of the pinned source,
add `-DFETCHCONTENT_SOURCE_DIR_TENSILE_ROCM_LIBRARIES=SOURCE_DIRECTORY` to the
configuration command, replacing `SOURCE_DIRECTORY` with its absolute path.
The standard FetchContent override bypasses archive hash verification; use the
revision recorded in `artifacts.json`.

## Validate and measure

Run normal numerical validation through rocjitsu:

```sh
rocjitsu --config GFX1250_CONFIG -- \
  build/tensile/cases/tensile/tensile_sgemm_gfx1250_mt16x32 \
  --m 128 --n 128 --k 128
```

Replace `GFX1250_CONFIG` with the gfx1250 simulator configuration. Use the
benchmark configuration with eight simulator threads for comparable timings.
Normal execution validates every output against a CPU reference on three
consecutive launches, rejecting nonfinite values and errors greater than
`1e-4 + 1e-4 * abs(reference)`. Both solutions and all three shapes are registered
for the normal gfx1250 kernel corpus tests.

The [benchmark runner](../../../../benchmarks/README.md) builds and invokes these
executables with `--benchmark`, `--case`, `--target`, `--output`, `--warmups`, and
`--samples`. Benchmark mode omits the CPU reference and output comparison.
One unmeasured initialization launch precedes warmups and samples. Each host
monotonic-clock sample includes required workspace/flag resets, every prepared
kernel invocation, and device synchronization. Allocation, artifact checks,
module loading, argument preparation, and JSON output remain outside samples.

The solution index is fixed; TensileLite still computes its StreamK launch grid
from the shape and device. These small shapes can use the data-parallel path,
so these cases don't guarantee coverage of split-work reduction.
