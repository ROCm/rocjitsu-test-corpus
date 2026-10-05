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
adds the selected plugin and report paths. With `num_threads = "default"`,
the runner preserves the native allocation policy and records the allocation
reported by `--thread-budget-table`. Base configs must not enable plugins or sinks.
With the default thread policy, resolved engine, dispatch, helper, and total
worker counts are included in `run.json` and the published environment.
Comparisons reject different allocations or a mix of results with and without
allocation metadata.

The runner checks the Release configuration, disabled LTO/sanitizers,
source root, SDK, and selected plugin binaries. The wrapper must select the
binary from that build; arbitrary wrapper commands cannot be checked against
CMake metadata. Rebuild rocjitsu after source changes.

The default `benchmarks/suites/nightly.toml` contains 16 case definitions and
20 target/case combinations across `gfx950` and `gfx1250`:

- GPT-OSS windowed and full causal attention on both targets.
- Triton persistent and grouped GEMM on both targets.
- DeepSeek FP8 MLP projections with target-specific token counts.
- TensileLite BF16 Stream-K and MXFP8 on gfx950, and BF16 subtile and MXFP4
  Stream-K on gfx1250.

Four larger gfx1250 cases come from
[rocm-systems issue 12611](https://github.com/ROCm/rocm-systems/issues/12611):
DeepSeek W1 and W2 with 3072 tokens, four grouped 3584³ GEMMs, and persistent
8192 × 8192 × 4096 matmul. Their `configuration = "issue12611"` selects the issue's
fixed launch settings: Triton tiles 128 × 128 × 64 with four warps and two stages;
DeepSeek tiles 64 × 64 × 128 with eight warps, three stages, and unit scales.
Nightly uses one warmup and three samples after compile-only preparation, with
Rocjitsu's default CPU thread budget and the caller's CPU affinity.

Use `--manifest benchmarks/suites/smoke.toml` for a short suite, repeated
`--case` and `--target` flags for subsets, and `--warmups`/`--samples` for
experiments. Sample counts must be positive and odd. `--list` shows the matrix
without building or requiring GPU dependencies. Output directories must be new.
All cells run sequentially. Failures and timeouts leave finalized partial results;
the runner returns failure if any selected cell fails.

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

Each Triton sample launches one kernel. The DeepSeek, grouped GEMM, persistent
GEMM, and GPT-OSS adapters copy outputs to the CPU and check references after all
samples, before emitting results. A failed reference check fails the case. The
Tensile adapter validates every measured launch; see its [README](../corpus/benchmarks/tensile_candidates/README.md) for input patterns
and validation limits.

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
id = "triton.copy_fp32_32m.threads8"
workload = "copy"
suite = "Triton"
name = "32 MiB contiguous FP32 copy"
operation = "Copy"
params = { dtype = "fp32", elements = 8388608 }
```

`workload` selects the preparation function; `id` identifies the case in
`--case` selection and dashboard history. Give different parameter variants
distinct IDs. Thread count is recorded in the published environment; nightly IDs end in
`.default` for native allocation, while fixed-thread suites retain `.threads8` IDs.
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
| `triton_persistent` | `rows`, `columns`, `reduction`; optional `configuration = "issue12611"` | fp16 |
| `triton_grouped` | `rows`, `columns`, `reduction`, `groups`; optional `configuration = "issue12611"` | fp16 |
| `deepseek_fp8` | `rows`, `columns`, `reduction`; optional `configuration = "issue12611"` | fp8 |

Gather accepts a nonnegative index offset and wraps indices by source size.
RMSNorm epsilon must be finite and positive. GEMM uses non-transposed inputs,
matching input/output dtypes, and FP32 accumulation. GPT-OSS requires head
dimension 64, sequence lengths divisible by 64, query heads divisible by KV
heads, and a window of zero (full causal attention) or a positive multiple of 64.
Unsupported parameters fail the case before GPU allocation.
Grouped GEMM requires full tiles: rows and columns divisible by 64 by default,
or 128 with `configuration = "issue12611"`, and reduction divisible by 64.

## Results and plugins

`run.json` uses schema version 1 and records raw samples, summaries, cell status,
configuration, package versions, and both rocjitsu and corpus revisions,
commit timestamps, and dirty state. Each cell retains `workload.json`,
`stdout.txt`, `stderr.txt`, and its generated `config.json` under `cases/`.
Dashboard problem definitions come from TOML parameters for both successful and
failed cases, so a new case can publish its first failure without an existing
catalog entry. Derived launch and source metadata remain in `workload.json`.
A workload that fails early may have no `workload.json`.

On SIGINT or SIGTERM, the runner terminates the active workload, saves captured
stdout and stderr, retains existing workload and plugin artifacts, and
finalizes `run.json` as failed. Completed cells retain their results; cells that
have not started retain null artifact links.

Use `--manifest benchmarks/suites/plugin-overhead.toml` and
`--plugin-profile none|logging|race|throughput`, running each profile into a
separate output directory. Each enabled profile must produce its report.
Reports cover the entire process, including setup and warmups; timing samples
retain the same boundary across profiles.

The CI workflow remains in rocm-systems. It pins this corpus and uses the same
revision for execution and `python -m benchmarks.dashboard_publish`. The
publisher writes dashboard resources into a local `--data-dir`; CI passes
`--expected-sha` and `--expected-corpus-sha` to require matching, clean source
checkouts. Both source checkouts must be clean and include revision metadata.

Published files follow the [dashboard contract](https://github.com/ROCm/rocm-systems/blob/c53572277a6f160e92f360e23f5af7ce2de904a7/emulation/rocjitsu/website/docs/website-data-contract.md):
`metadata.json`, `index.json`, `test-catalogs/catalog-<hash>.json`, and
`runs/<run-id>.json` under the supplied data directory. Catalogs describe the
selected matrix exactly, including failed or interrupted cells. Catalogs and
runs are immutable; the index is updated last. Existing legacy datasets are
rejected: use a fresh directory rather than mixing the two formats.

The baseline profile is published as `vanilla`. For local plugin comparisons,
run the same suite and sampling settings on the same machine, then publish each
profile with a distinct `--run-id` and the same `--comparison-id`. The latter
defaults to the run ID, so unrelated executions are never grouped implicitly.
Catalog, source, machine, environment, trigger, and targets must match within a
comparison. Recorded package versions are published as `package.<name>` environment
entries and participate in these compatibility checks. Packages recorded as
unavailable are omitted. Existing published runs remain immutable; runs with
package entries cannot join comparisons that lack those entries.
`--machine-id` defaults to the recorded hostname; CI passes the
benchmark runner's name. `--is-beta` controls the site's Beta label.

Consumer CI must provide the nightly dependencies and allow the manifest sampling
defaults to take effect. A fresh dataset requires a valid Vanilla run, which can
contain failed or timed-out results. Publish each comparison's Vanilla baseline
before its instrumented runs. All runs in a dataset must use the same machine.

Run the benchmark harness tests through the repository's pytest configuration,
without ROCm dependencies. pytest-xdist supplies the plugin used by the root
configuration; install these test tools separately from the AMD package index:

```bash
python3 -m pip install --index-url https://pypi.org/simple \
  'pytest>=5.4.1' 'pytest-xdist>=1.32.0'
python3 -m pytest -q tests/test_benchmark_*.py tests/test_measurement_progress.py
```
