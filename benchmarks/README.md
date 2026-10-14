# Rocjitsu benchmarks

Workload sources live under `corpus/benchmarks/`, with a sequential runner in
`benchmarks/`. Suite TOML files contain case metadata and parameters. Benchmark
runs are separate from normal pytest collection.

## Setup and run

Use Python 3.12 and install the pinned GPU dependencies with
`python -m pip install -r benchmarks/requirements.txt`. For the concrete
rocjitsu build and launch recipe, see the
[rocm-systems benchmark guide](https://github.com/ROCm/rocm-systems/blob/develop/emulation/rocjitsu/docs/benchmark-suite.md).

The consumer supplies the launch command and one base config per selected target.
Set `HSA_ENABLE_SDMA_COPY_SIZE_OVERRIDE=0` for large host/device copies with the
pinned SDK:

```bash
export HSA_ENABLE_SDMA_COPY_SIZE_OVERRIDE=0
python -m benchmarks.runner \
  --rocjitsu-source-dir "$src" --build-dir "$build" \
  --target-config "gfx950=$gfx950_config" \
  --target-config "gfx1250=$gfx1250_config" \
  --thread-policy default,single \
  --run-wrapper "\"$rocjitsu\" --config {config} --" \
  --output .benchmark-artifacts/run-001
```

`--run-wrapper` is a shell-style argument list, parsed without executing a shell.
It must contain exactly one standalone `{config}` token, which the runner
replaces with the generated per-cell config path before appending the workload
command. Quote paths containing spaces inside the wrapper string; shell
operators and variable expansion are not interpreted by the runner.

`--target-config TARGET=PATH` is repeatable. Relative paths resolve from the
invoking directory. Every selected target needs a mapping; extra mappings are
allowed for convenience when selecting a subset. The runner snapshots selected
configs before execution and derives each cell's config from that snapshot.
It removes the simulation tick limit and adds selected plugin/report paths.
Base configs must not enable plugins or sinks. Threading config values are not
overridden: the runner passes `--cpu-thread-budget 0` for `default` and
`--cpu-thread-budget 1` for `single`, to both probes and workload commands.
Independent budget flags in `--run-wrapper` are rejected. Zero means automatic
allocation, not guaranteed multithreading. Explicit engine/dispatch/helper
config settings can exceed the budget; the native `--thread-budget-table` probe
must resolve exactly 1/1/0 (one total worker) for `single` or setup fails.
Each selected target/policy is probed once; its allocation and config snapshot
are retained under `<target>/<thread-policy>/`. Policy is recorded on each raw
result, not in the execution summary.

The runner checks the Release configuration, disabled LTO/sanitizers,
source root, SDK, and selected plugin binaries. The wrapper must select the
binary from that build; arbitrary wrapper commands cannot be checked against
CMake metadata. Rebuild rocjitsu after source changes.

The default `benchmarks/suites/performance-v1.toml` contains 20 case definitions and
28 target/case combinations across `gfx950` and `gfx1250`:

- GPT-OSS windowed and full causal attention on both targets.
- Triton persistent and grouped GEMM on both targets.
- Triton FP32 softmax and layer normalization, each at 131072 × 2048.
- DeepSeek FP8 MLP projections with target-specific token counts.
- DeepSeek activation quantization (BF16 to FP8) and weight dequantization
  (FP8 to FP32), each at 32768 × 8192.
- TensileLite BF16 Stream-K and MXFP8 on gfx950, and BF16 subtile and MXFP4
  Stream-K on gfx1250.

Four larger gfx1250 cases come from
[rocm-systems issue 12611](https://github.com/ROCm/rocm-systems/issues/12611):
DeepSeek W1 and W2 with 3072 tokens, four grouped 3584³ GEMMs, and persistent
8192 × 8192 × 4096 matmul. Their `configuration = "large_tile"` selects the issue's
fixed launch settings: Triton tiles 128 × 128 × 64 with four warps and two stages;
DeepSeek tiles 64 × 64 × 128 with eight warps, three stages, and unit base scales.
The scale tensors also vary by row, column block, and reduction block for validation.
The runner defaults to zero warmups and one sample after compile-only preparation,
with Rocjitsu's default CPU thread budget and the caller's CPU affinity.

Seven of these definitions also support `single`, selecting five cases per
target (10 target/case combinations):
full causal attention, persistent matmul, grouped GEMM, the smaller DeepSeek W1
projection, and BF16 TensileLite. All shapes and kernel settings match their
default-threaded counterparts. This keeps all four libraries while excluding
the large issue 12611 cases, windowed attention, W2 projections, MX variants,
softmax, layer normalization, and activation/weight conversions.
The issue's later measurements put the large W1/W2 cases near 14 minutes per
single-threaded launch; those cases remain in the default suite only.
End-to-end runtime includes setup, compilation, output reset, and CPU validation;
it is longer than the sum of measured kernel durations.

Without filters, the runner selects all TOML-supported case/target/policy
combinations: 38 for this suite, in one invocation and one `run.json`. Explicit
`--case`, `--target`, and `--thread-policy` filters narrow that supported set;
they never add unsupported combinations. Use `--thread-policy default` for only
default-worker cases or `--thread-policy single` for only supported single-worker
cases. `--thread-policy default,single` explicitly selects both policies and is
equivalent to omitting the policy filter. Cases are not duplicated in TOML.

Use `--manifest benchmarks/suites/smoke.toml --warmups 1 --samples 3` for a short
suite, repeated `--case` and `--target` flags for subsets, and
`--warmups`/`--samples` for experiments (defaults 0/1). Each invocation accepts
one manifest; repeated `--manifest` flags are rejected, including identical paths.
Each file retains its scalar timeout: performance-v1 1200 seconds,
plugin-overhead 300 seconds, and smoke 60 seconds. Sample counts must
be positive and odd. `--list` shows case, target and policy columns
without building or requiring GPU dependencies. Output directories must be new.
Target/policy groups run sequentially, as do cases within each group. Failures
and timeouts leave finalized partial results;
the runner returns failure if any selected cell fails.
Invalid base configurations are rejected before creating the output directory.
If a native policy probe or setup fails before the initial `run.json` checkpoint,
the runner removes its new output directory so the same path can be retried.
After that checkpoint, failures preserve partial results as usual.

## Measurement and dependencies

TensileLite cases require `TENSILE_CANDIDATE_ARTIFACTS` to point to generated
artifacts and `TENSILE_CANDIDATE_RUNNER` to point to the native executable. Follow
[the build and generation instructions](../corpus/benchmarks/tensile_candidates/README.md)
before running the performance suite. The persistent and grouped Triton kernels
and DeepSeek kernel are vendored in the corpus.

Triton workloads write `workload.progress.json` beside their result, recording
preparation, compilation, warmup, sample, and validation stages. Compilation
compiles and loads kernels without executing them; progress writes stay outside
the measured interval.

Each sample measures host elapsed time around launch and device synchronization.
Input allocation, descriptors, and result serialization stay outside samples.
Kernels are compiled and launch handles initialized before sampling, without
executing an implicit initialization launch. Requested warmups run before the
samples; with zero warmups, the first execution is the first timed sample.
Remaining first-execution runtime costs can still occur in that sample.

Each Triton sample launches one benchmark kernel. The DeepSeek, grouped
GEMM, and persistent GEMM adapters poison outputs before each warmup and sample.
GPT-OSS attention, `triton_softmax`, `triton_layernorm`, and the
activation/weight conversions do this too. Reset and synchronization complete
before the sample timer starts.
Validation checks the final sampled output and never launches the benchmark
kernel again. Zero warmups and one sample therefore executes each benchmark
kernel exactly once. With multiple samples, only the final sample is checked;
the output reset prevents values from earlier launches hiding missing writes.

The candidate GEMM adapters use positive dyadic factors varying by row, column,
group, reduction block, and within each 64-element K tile. Both operands vary
independently between reduction blocks. DeepSeek scales vary across both free
and reduction axes. The scheduled shapes accumulate exactly in FP32, so the
checker compares the rounded output without a blanket tolerance. For FP16
reductions above 32,768, power-of-two free-axis factors preserve accumulation
headroom and keep outputs finite. These patterns exercise representative indexing
and scale errors, not all possible permutations. Nonfinite values and failed
references fail the case. The Tensile adapter validates every measured launch;
see its [README](../corpus/benchmarks/tensile_candidates/README.md).

GPT-OSS uses fixed-seed BF16 inputs varying across all axes, with positive value
inputs and varying queries, keys, and sinks. It checks the final sampled output
with the upstream CPU reference using explicit BF16 bounds (`rtol=0.016`,
`atol=1e-5`). Reference chunks contain one batch, one KV head, and at most 128
query positions, retaining all keys and absolute query offsets for causal/window
masking. Each temporary FP32 attention matrix is at most 12 MiB for the largest
performance-v1 shape; full input and output storage still scales with the problem.

The extracted GPT-OSS attention implementation lives in
`corpus/benchmarks/third_party/gpt_oss/attention.py`. Its `NOTICE.md`
records the upstream revision and extracted functions; `LICENSE` contains the
upstream license. The launch adapter stays in `triton/workloads.py` and calls
`_attn_fwd` directly with fixed launch settings; it does not download a model or autotune.

Package versions are pinned in `requirements.txt`; generated kernels and caches
are build artifacts.

## Defining cases

Each suite is a standalone TOML file. To benchmark another size or dtype, add a
case using an existing workload; no Python change is needed:

```toml
[[cases]]
id = "triton.copy_fp32_32m"
workload = "copy"
suite = "Triton"
name = "32 MiB contiguous FP32 copy"
operation = "Copy"
targets = ["gfx950", "gfx1250"]
thread_policies = ["default"]
params = { dtype = "fp32", elements = 8388608 }
```

`workload` selects the preparation function; `id` identifies the case in
`--case` selection and dashboard history. Give different parameter variants
distinct IDs, even when their display names match (for example,
`deepseek.mlp_w1_m64` and `deepseek.mlp_w1_m256`). The bundled suites use the same
workload ID across thread policies, without a `.default` or `.single` suffix.
Threading is execution policy, recorded separately as each result's
`thread_policy`, not a workload change. Result identity is `(id, target, thread_policy)`.
`operation` describes the overall computation, including composite operations;
it is metadata, not identity. The runner carries
the explicit manifest ID unchanged into selection, raw results, and case output
paths; it does not derive IDs from display names or strip suffixes at runtime.
Each file has only `name`, `timeout_seconds` and cases; every case explicitly
declares nonempty `targets` and `thread_policies`. There are no includes/profiles
or file-level target/threading/sampling fields.
Dimensions, dtypes, and operation parameters belong in TOML; launch settings
such as tile sizes, warps, and stages stay in code and are recorded in results.
To add a new operation, add its preparation and parameter validation, register
its name with the runner, and define a case in a suite. Prefer existing upstream kernels and small
launch adapters.

Supported parameters (all dimensions are positive integers):

| Workload | Parameters besides `dtype` | Dtypes |
|---|---|---|
| `copy`, `vector_add` | `elements` | fp16, bf16, fp32 |
| `transpose`, `softmax` | `rows`, `columns` | fp16, bf16, fp32 |
| `gather` | `source_elements`, `output_elements`, `index_stride`, `index_offset` | fp16, bf16, fp32 |
| `atomic_add` | `elements`, `buckets` | fp32 |
| `rmsnorm` | `rows`, `columns`, `epsilon` | fp16, bf16, fp32 |
| `gemm` | `m`, `n`, `k` | fp16, bf16 |
| `gpt_oss_attention` | `batch`, `query_heads`, `key_value_heads`, `sequence`, `window`, `head_dimension` | bf16 |
| `triton_persistent` | `rows`, `columns`, `reduction`; optional `configuration = "large_tile"` | fp16 |
| `triton_grouped` | `rows`, `columns`, `reduction`, `groups`; optional `configuration = "large_tile"` | fp16 |
| `triton_softmax` | `rows`, `columns` | fp32 |
| `triton_layernorm` | `rows`, `columns`, `epsilon` | fp32 |
| `deepseek_act_quant` | `rows`, `columns` | bf16 |
| `deepseek_weight_dequant` | `rows`, `columns` | fp8 |
| `tensile_candidate` | `variant`, `m`, `n`, `k`; explicit matching case `targets` | bf16, mxfp8, mxfp4 (matching variant) |
| `deepseek_fp8` | `rows`, `columns`, `reduction`; optional `configuration = "large_tile"` | fp8 |

The legacy `softmax` and `rmsnorm` workloads use local kernels and do not
validate their outputs. The performance-v1 `triton_softmax` and `triton_layernorm`
workloads use pinned upstream kernels, varied inputs, output poisoning, and
full-output CPU checks. RMSNorm and layer normalization are different operations:
RMSNorm scales by the root mean square without subtracting the mean; layer
normalization subtracts the mean and scales by the standard deviation.

For Tensile variants, target restrictions, native build instructions, and
`TENSILE_CANDIDATE_ARTIFACTS` / `TENSILE_CANDIDATE_RUNNER`, see the
[Tensile candidate guide](../corpus/benchmarks/tensile_candidates/README.md).

Gather accepts a nonnegative index offset and wraps indices by source size.
RMSNorm epsilon must be finite and positive. GEMM uses non-transposed inputs,
matching input/output dtypes, and FP32 accumulation. GPT-OSS requires head
dimension 64, sequence lengths divisible by 64, query heads divisible by KV
heads, and a window of zero (full causal attention) or a positive multiple of 64.
Unsupported parameters fail the case before GPU allocation.
Grouped GEMM requires full tiles: rows and columns divisible by 64 by default,
or 128 with `configuration = "large_tile"`, and reduction divisible by 64.
The upstream `triton_softmax` and `triton_layernorm` adapters support up to
16384 columns. Both use eight warps and one program per row; softmax uses two
stages and layer normalization uses one. Layer normalization requires a finite,
positive epsilon. Activation quantization requires columns divisible by 128 and
uses 128-element blocks. Weight dequantization uses 128 × 128 tiles, including
masked edge tiles. Both DeepSeek conversions use four warps.

These four default-thread workloads poison outputs before every launch
and check every output of the final sample in CPU chunks. Layer normalization also checks
its mean and reciprocal standard deviation; activation quantization checks its
block scales. The chosen dyadic conversion inputs allow exact output checks.
The reductions use FP64 CPU references with FP32 error bounds. Validation does
not launch these benchmark kernels again.

## Results and plugins

`run.json` follows the [raw run schema](raw-run-schema.md): `execution_summary`,
`benchmark_results`, and `provenance`. Raw timing samples are in seconds.
The schema records cell status, operation, policy, problem parameters,
package versions, and both rocjitsu and corpus revisions and commit timestamps.
Each cell retains `workload.json`,
`stdout.txt`, `stderr.txt`, and its generated `config.json` under
`<target>/<thread-policy>/cases/<case-id>/`. No target config hashes are emitted.
The group contains `config.json`, `policy.txt`, `stderr.txt` and `allocation.json`.
Problem definitions come from TOML parameters for both successful and failed
cases. Derived launch and source metadata remain in `workload.json`.
A workload that fails early may have no `workload.json`.

On SIGINT or SIGTERM, the runner terminates the active workload, saves captured
stdout and stderr, retains existing workload and plugin artifacts, and
finalizes `run.json` with a finish time and failed status for unfinished cells.
Completed cells retain their results; cells that have not started have no artifacts.

Use `--manifest benchmarks/suites/plugin-overhead.toml --warmups 3 --samples 21` and
`--plugin-profile none|logging|race|throughput`, running each profile into a
separate output directory. Each enabled profile must produce its report.
Reports cover the entire process, including setup and warmups; timing samples
retain the same boundary across profiles.

### Harness tests

Run the benchmark harness tests through the repository's pytest configuration,
without ROCm dependencies. pytest-xdist supplies the plugin used by the root
configuration; install these test tools separately from the AMD package index:

```bash
python3 -m pip install --index-url https://pypi.org/simple \
  'pytest>=5.4.1' 'pytest-xdist>=1.32.0'
python3 -m pytest -q tests/test_benchmark_*.py tests/test_measurement_progress.py
```
