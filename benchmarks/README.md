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
It applies the suite's thread policy, removes the simulation tick limit, and
adds the selected plugin and report paths. With `thread_policy = "default"`,
the runner preserves the native allocation policy and records the allocation
reported by `--thread-budget-table`. Base configs must not enable plugins or sinks.
With `thread_policy = "single"`, the runner sets the CPU budget to one and overrides
engine, dispatch, and helper counts to 1/1/0. It verifies that the native CLI
resolves exactly one total worker. Setting the integer `num_threads = 1` alone
only limits simulator engines; dispatch and helper workers can still run in parallel.
Each manifest must specify exactly one of `thread_policy` or integer `num_threads`.
The keys cannot be combined; string-valued `num_threads` is not supported.
Execution requires `thread_policy = "default"` or `"single"`. Numeric-thread
manifests can still be loaded and listed, but cannot produce new raw runs.
With either named thread policy, the native worker allocation is recorded in
`thread-policy/<target>/allocation.json` under the output directory.
`run.json` records the named policy in `execution_summary.threading_mode`.

The runner checks the Release configuration, disabled LTO/sanitizers,
source root, SDK, and selected plugin binaries. The wrapper must select the
binary from that build; arbitrary wrapper commands cannot be checked against
CMake metadata. Rebuild rocjitsu after source changes.

The default `benchmarks/suites/nightly.toml` contains 20 case definitions and
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
Nightly uses zero warmups and one sample after compile-only preparation, with
Rocjitsu's default CPU thread budget and the caller's CPU affinity.

`benchmarks/suites/nightly-single.toml` uses the same sampling settings and a
single CPU worker. It selects five cases per target (10 target/case combinations):
full causal attention, persistent matmul, grouped GEMM, the smaller DeepSeek W1
projection, and BF16 TensileLite. All shapes and kernel settings match their
default-threaded counterparts. This keeps all four libraries while excluding
the large issue 12611 cases, windowed attention, W2 projections, MX variants,
softmax, layer normalization, and activation/weight conversions.
The issue's later measurements put the large W1/W2 cases near 14 minutes per
single-threaded launch; those cases remain in the default suite only.
End-to-end runtime includes setup, compilation, output reset, and CPU validation;
it is longer than the sum of measured kernel durations.

Run both manifests separately with different output directories. Keep their
dashboard run IDs and environment IDs distinct so both histories are retained.

Use `--manifest benchmarks/suites/smoke.toml` for a short suite, repeated
`--case` and `--target` flags for subsets, and `--warmups`/`--samples` for
experiments. Sample counts must be positive and odd. `--list` shows the matrix
without building or requiring GPU dependencies. Output directories must be new.
All cells run sequentially. Failures and timeouts leave finalized partial results;
the runner returns failure if any selected cell fails.
Invalid base configurations are rejected before creating the output directory.
If a native policy probe or setup fails before the initial `run.json` checkpoint,
the runner removes its new output directory so the same path can be retried.
After that checkpoint, failures preserve partial results as usual.

## Measurement and dependencies

TensileLite cases require `TENSILE_CANDIDATE_ARTIFACTS` to point to generated
artifacts and `TENSILE_CANDIDATE_RUNNER` to point to the native executable. Follow
[the build and generation instructions](../corpus/benchmarks/tensile_candidates/README.md)
before running nightly. The persistent and grouped Triton kernels and DeepSeek
kernel are vendored in the corpus.

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
nightly shape; full input and output storage still scales with the problem.

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
id = "triton.copy_fp32_32m.default"
workload = "copy"
suite = "Triton"
name = "32 MiB contiguous FP32 copy"
operation = "Copy"
params = { dtype = "fp32", elements = 8388608 }
```

`workload` selects the preparation function; `id` identifies the case in
`--case` selection and dashboard history. Give different parameter variants
distinct IDs. The bundled suites use case IDs ending in `.default` for native
allocation or `.single` for one total CPU worker. Smoke and plugin-overhead use
the default policy too. Give cases with different thread policies distinct IDs
to keep their dashboard histories separate.
Repeat the complete definition in each suite that uses it.
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
validate their outputs. The nightly `triton_softmax` and `triton_layernorm`
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
The schema records cell status, problem parameters, configuration hashes,
package versions, and both rocjitsu and corpus revisions and commit timestamps.
Each cell retains `workload.json`,
`stdout.txt`, `stderr.txt`, and its generated `config.json` under `cases/`.
Problem definitions come from TOML parameters for both successful and failed
cases. Derived launch and source metadata remain in `workload.json`.
A workload that fails early may have no `workload.json`.

On SIGINT or SIGTERM, the runner terminates the active workload, saves captured
stdout and stderr, retains existing workload and plugin artifacts, and
finalizes `run.json` with a finish time and failed status for unfinished cells.
Completed cells retain their results; cells that have not started have no artifacts.

Use `--manifest benchmarks/suites/plugin-overhead.toml` and
`--plugin-profile none|logging|race|throughput`, running each profile into a
separate output directory. Each enabled profile must produce its report.
Reports cover the entire process, including setup and warmups; timing samples
retain the same boundary across profiles.

### Existing dashboard publication

The existing publisher does not yet accept the new raw schema. Updating the
publisher and dashboard contract is separate work. The workflow below describes
publication of legacy raw files; do not use it with newly generated runs.

The CI workflow remains in rocm-systems. It pins this corpus and uses the same
revision for execution and `python -m benchmarks.dashboard_publish`. The
publisher writes dashboard resources into a local `--data-dir`; CI passes
`--expected-sha` and `--expected-corpus-sha` to require matching, clean source
checkouts. Both source checkouts must be clean and include revision metadata.

Published files follow the [dashboard contract](https://github.com/ROCm/rocm-systems/blob/c53572277a6f160e92f360e23f5af7ce2de904a7/emulation/rocjitsu/website/docs/website-data-contract.md):
`metadata.json`, `index.json`, `test-catalogs/catalog-<hash>.json`, and
`runs/<run-id>.json` under the supplied data directory. Catalogs describe the
selected matrix exactly, including failed or interrupted cells. Catalogs and
runs are immutable; the index is updated last. The publisher keeps the existing
JSON contract and validates existing runs and their catalogs when updating a dataset.
Child `workload.json` files keep their existing format and nanosecond timings.

Existing published results retain the per-target engine-thread count and
configuration hash; the nightly case IDs use `.default` and `.single` suffixes
to distinguish the suites.

The baseline profile is published as `vanilla`. For local plugin comparisons,
run the same suite and sampling settings on the same machine, then publish each
profile with a distinct `--run-id` and the same `--comparison-id`. The latter
defaults to the run ID, so unrelated executions are never grouped implicitly.
Catalog, source metadata, machine, environment, trigger, and targets must match
within a plugin comparison. The published environment includes per-target
engine-thread counts and configuration hashes, so those values must match too.
Raw threading modes and dispatch/helper/total worker counts are not published
and do not participate in these checks.
Historical comparisons span revisions and do not require equal engine-thread
counts or configuration hashes; the dashboard displays those values as context.
Recorded package versions are published as `package.<name>` environment entries
and participate in plugin comparison compatibility checks. Packages recorded as
unavailable are omitted. Existing published runs remain immutable; runs with
package entries cannot join comparisons that lack those entries.
`--machine-id` defaults to the recorded hostname; CI passes the
benchmark runner's name. `--is-beta` controls the site's Beta label.

Consumer CI must provide the nightly dependencies and allow the manifest sampling
defaults to take effect. A fresh dataset requires a valid Vanilla run, which can
contain failed or timed-out results. Publish each comparison's Vanilla baseline
before its instrumented runs. All supported runs in a dataset must use the same machine.

Run the benchmark harness tests through the repository's pytest configuration,
without ROCm dependencies. pytest-xdist supplies the plugin used by the root
configuration; install these test tools separately from the AMD package index:

```bash
python3 -m pip install --index-url https://pypi.org/simple \
  'pytest>=5.4.1' 'pytest-xdist>=1.32.0'
python3 -m pytest -q tests/test_benchmark_*.py tests/test_measurement_progress.py
```
