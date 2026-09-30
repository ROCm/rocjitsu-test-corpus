# TensileLite benchmark candidates

These candidates use fixed solutions from
[ROCm/rocm-libraries at dd77374194a3ea1a7258cd54f87af6747b6362a5](https://github.com/ROCm/rocm-libraries/tree/dd77374194a3ea1a7258cd54f87af6747b6362a5).
The files in `upstream/` are unmodified copies of the corresponding upstream
`projects/hipblaslt/tensilelite/Tensile/Tests/common/` configurations.
`prepare.py` selects one problem group and the first listed value of each tuning
parameter, then replaces the problem sizes. It does not autotune.

| Variant | Target | Input/output | Initial M × N × K | Upstream configuration |
|---|---|---|---|---|
| `bf16_streamk` | gfx950 | BF16/BF16 | 4096 × 4096 × 4096 | `streamk/gfx950/sk_bgemm_pap.yaml` |
| `bf16_subtile` | gfx1250 | BF16/BF16 | 4096 × 4096 × 4096 | `gemm/gfx12/subtile_bf16_gfx1250_bench.yaml` |
| `mxfp8_subtile` | gfx950 | MXFP8/BF16 | 4096 × 4096 × 4096 | `gemm/gfx950/subtile_mxfp8.yaml`, group 4 (zero-based) |
| `mxfp4_streamk` | gfx1250 | MXFP4/FP32 | 4096 × 4096 × 4096 | `streamk/gfx1250/core/sk_mxf4gemm_tdm_pap.yaml` |

All cases use batch 1 and FP32 accumulation. These are investigation candidates;
being listed here does not establish correctness or a qualified runtime. Keep
measurements and failures in the campaign report.

## Build and generate

Use a ROCm SDK and an isolated Python environment with the pinned source's Python
requirements and `rocisa` installed. Set `TENSILE_SOURCE` to the full pinned
rocm-libraries Git checkout, `ROCM_PATH` to the SDK, and `PYTHON` to that environment's
interpreter. Generation and CMake configuration verify the checkout revision and
reject tracked changes and untracked files. Extracted source archives are not
supported. Keep build outputs outside the source checkout. PyYAML is required
for generation. The Python workload adapter for prebuilt artifacts uses only the
standard library.

From the corpus root, build the host adapter:

```sh
cmake -S corpus/benchmarks/tensile_candidates -B .benchmark-artifacts/tensile-native \
  -DCMAKE_BUILD_TYPE=Release \
  -DTENSILE_SOURCE="$TENSILE_SOURCE" \
  -DROCM_PATH="$ROCM_PATH" -DCMAKE_PREFIX_PATH="$ROCM_PATH" \
  -DCMAKE_CXX_COMPILER="$ROCM_PATH/bin/amdclang++" \
  -DPython_EXECUTABLE="$PYTHON" -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build .benchmark-artifacts/tensile-native --target tensile_candidate -j8
```

CMake uses upstream's pinned nanobind dependency. An existing checkout can be
supplied with `-DFETCHCONTENT_SOURCE_DIR_NANOBIND=...` for an offline build.
Generate and package the code objects outside the timed runs:

```sh
"$PYTHON" corpus/benchmarks/tensile_candidates/generate.py \
  --source-root "$TENSILE_SOURCE" \
  --output .benchmark-artifacts/tensile-candidates
```

Generation requires `amdclang++` and other SDK tools on `PATH`. Use
`--variant bf16_subtile --shape 4096 4096 4096` to generate a single shape.
Use a fresh output directory when changing the selected solution. Generation
logs, commands, the fixed configuration, and content hashes are retained per
variant. `CpuThreads` in the generated YAML limits generator parallelism; it does
not set Rocjitsu's runtime thread budget.

## Run

Set the artifact directory and native executable paths before using the benchmark
runner:

```sh
export TENSILE_CANDIDATE_ARTIFACTS="$PWD/.benchmark-artifacts/tensile-candidates"
export TENSILE_CANDIDATE_RUNNER="$PWD/.benchmark-artifacts/tensile-native/tensile_candidate"
```

The runner invokes `workload.py` with `--workload tensile_candidate`. Parameters
are `variant`, `dtype`, `m`, `n`, and `k`; `dtype` is `bf16`, `mxfp8`, or `mxfp4`.
The requested target and shape must match the artifact metadata. The wrapper
verifies artifact hashes before launching and emits the standard workload JSON,
including source and solution provenance.

The native adapter requires exactly one solution and exactly one kernel invocation
from `solve()`. It initializes and validates once, performs the requested warmups,
then times individual launches with device synchronization. Allocations, copies,
workspace and synchronization-flag resets, output poisoning, and full-output
reference checks are outside timing. Every measured launch is validated.

BF16 inputs vary in both matrix axes with separable periodic patterns. MX inputs
use unit values and unit E8 scales constructed by upstream conversion types;
constant data is unchanged by the upstream swizzles. This MX check covers
accumulation and complete output writes, but does not establish correctness for
arbitrary packed input layouts or varying scales. Do not use it as a replacement
for the upstream numeric test suite.

Runtime environment changes, including any SDMA compatibility setting needed by
the selected Rocjitsu/SDK pair, belong in the campaign provenance. Keep the
Rocjitsu thread budget at its default for candidate qualification.
