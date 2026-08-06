# llama.cpp Backend Operator Corpus

Selected `test-backend-ops` cases from `llama.cpp`, used to exercise the GGML
HIP backend against its CPU reference on ROCm targets.

## At a Glance

```text
build_llama_tests.sh  Standalone build entrypoint.
CMakeLists.txt        Defines test-backend-ops from the vendored sources.
selected_llama_backend_ops_tests.json
                      Checked-in backend-op case inventory.
selected_llama_backend_ops_tests.txt
                      One-line filter for direct harness runs.
third_party/          Vendored upstream sources.
```

`selected_llama_backend_ops_tests.json` holds 535 exact `OP(params)` strings
covering 117 GGML operators. The list was selected from the ROCm-supported
`test-backend-ops` set to reach the kernels and parameter shapes implicated by
merged `llama.cpp` bug-fix pull requests, then pruned so that near-duplicate
producers of the same trigger do not repeat while operator and parameter
variety stays broad. Every selected case passes on native `gfx1201`, so a
non-pass result is a property of the environment under test rather than of the
case.

The final half-size tier retains every observed failure, segfault, and timeout,
plus all class and boundary anchors. Passing cases are selected to preserve all
117 operations and every observed dtype, control, and size coverage token, then
to maximize kernel-symbol coverage with smaller producers preferred. This keeps
566 of 880 profiled non-runtime kernel symbols.

Cases that initially time out are removed only after a 60-second, `-n 16`
recheck passes on every probed gfx target. Any failure, segfault, or remaining
timeout is retained.

`selected_llama_backend_ops_tests.txt` contains the same exact names joined by
commas for `test-backend-ops -o`.

The inventory supports `gfx942`, `gfx950`, `gfx1100`, `gfx1201`, and `gfx1250`.
Pytest creates one parameter for every exact case string when one of those
targets is requested.

The suite runs one `test-backend-ops` process per case. Operators such as
`MUL_MAT` and `FLASH_ATTN_EXT` can crash or hang a simulated device, and one
process per case keeps that from hiding the result of every other case in the
same batch.

## Third-Party Sources

`third_party/llama.cpp` holds the pinned `ggml/` subtree and
`tests/test-backend-ops.cpp` that the inventory was selected from. See
`third_party/llama.cpp/NOTICE.md` for the upstream commit and
`third_party/llama.cpp/LICENSE` for the MIT license terms. Only the GGML core
plus the `ggml-cpu`, `ggml-cuda`, and `ggml-hip` backends are vendored, because
those are the backends the suite enables.

Refreshing the pin means re-measuring: case names embed operator parameters, so
an upstream change to a test definition renames the case, and outcomes can move
with kernel changes. Update the vendored subtree and inventory in one change.

## Run

Build the harness once, then use the unified corpus pytest entrypoint. Pytest
checks that executable and creates one parameter for each selected backend-op
case:

```bash
export ROCM_PATH="$(rocm-sdk path --root)"
./corpus/llama/build_llama_tests.sh --targets gfx1201
python -m pytest tests/test_corpus.py \
  --suite llama \
  --target gfx1201 \
  --timeout 15
```

Run all selected cases in one harness process:

```bash
corpus/llama/build/test-backend-ops test \
  -o "$(< corpus/llama/selected_llama_backend_ops_tests.txt)" \
  -b ROCm0 --output csv
```

## Build

Run `build_llama_tests.sh` before pytest to build `test-backend-ops` in
`corpus/llama/build`. Pytest does not compile it.

The build needs a ROCm SDK root that provides
`lib/cmake/hip/hip-config.cmake`, hipBLAS, and rocBLAS; the CMake project takes
it from `-DROCM_PATH`, `$ROCM_PATH`, or the `rocm-sdk path --root` command. By
default the script builds `third_party/llama.cpp`.

With no arguments, `build_llama_tests.sh` builds `gfx1201`. Use `--targets` to
build one or more other targets and `--build-dir` to override the default
`corpus/llama/build` directory. Use `--jobs` to control build parallelism; it
defaults to half the available CPUs.

Pass multiple space-separated targets to build several gfx architectures at
once:

```bash
./corpus/llama/build_llama_tests.sh --targets gfx1201 gfx942
```

To build the harness by hand, for example to reproduce a single case outside
pytest:

```bash
export ROCM_PATH="$(rocm-sdk path --root)"
./corpus/llama/build_llama_tests.sh \
  --targets gfx1201 \
  --build-dir /tmp/llama-corpus-gfx1201
/tmp/llama-corpus-gfx1201/test-backend-ops test \
  -o 'ABS(type=f16,ne_a=[128,2,2,2],v=0)' \
  -b ROCm0 -j 1 --output csv
```

Each selected case reports its actual result directly to pytest. A test
failure, signal, unsupported result, or malformed output fails the corresponding
pytest case. Runtime limits come exclusively from pytest, such as
`pytest-timeout`'s `--timeout` option.
