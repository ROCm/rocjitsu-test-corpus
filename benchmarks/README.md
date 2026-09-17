# Rocjitsu benchmarks

Triton workload sources live under `corpus/benchmarks/triton/`, with an
independent sequential runner. Suite TOML files contain Triton case metadata and
parameters, or references to existing native corpus cases. Benchmark runs are separate from normal pytest collection.

## Setup and run

Use Python 3.12 and install the pinned GPU dependencies with
`python -m pip install -r benchmarks/requirements.txt`. For the concrete
rocjitsu build and launch recipe, see the
[rocm-systems benchmark guide](https://github.com/ROCm/rocm-systems/blob/develop/emulation/rocjitsu/docs/benchmark-suite.md).

The consumer supplies the launch command and one base config per selected target:

```bash
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
It sets the suite's thread count and removes the simulation tick limit, and
adds the selected plugin and report paths. Base configs must not enable plugins
or sinks.

The runner still checks the Release configuration, disabled LTO/sanitizers,
source root, SDK, and selected plugin binaries. The wrapper must select the
binary from that build; arbitrary wrapper commands cannot be checked against
CMake metadata. Rebuild rocjitsu after source changes.

The default `benchmarks/suites/nightly.toml` runs 28 Triton cases on both `gfx950` and
`gfx1250`, plus one native BF16 HipKittens GEMM per target (58 cells). Sixteen cases cover FP16 and BF16 GEMMs at
128x128x128, 256x256x512, 512x512x512, 1024x1024x1024, 1024x128x512,
128x1024x512, 128x128x2048, and 250x250x510 (M x N x K).
Use `--manifest benchmarks/suites/smoke.toml` for a short suite, repeated
`--case` and `--target` flags for subsets, and `--warmups`/`--samples` for
experiments. Sample counts must be positive and odd. `--list` shows the matrix
without building or requiring GPU dependencies. Output directories must be new.

All cells run sequentially, with eight simulator threads per cell. Progress appears when
cells start and finish. Failures and timeouts leave finalized partial results;
the runner returns failure if any selected cell fails.

## Measurement and source reuse

Each sample measures host elapsed time around launch and device synchronization.
Input allocation, compilation, descriptors, warmups, and
result serialization stay outside samples. The GPT-OSS attention adapter copies
outputs to the CPU and checks an upstream CPU reference after all samples,
before emitting results. A failed reference check fails the case. Each sample
launches one Triton kernel.

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
distinct IDs. Thread count is recorded in the published environment; the default IDs end in
`.threads8` to distinguish them from the former single-thread runs.
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

Gather accepts a nonnegative index offset and wraps indices by source size.
RMSNorm epsilon must be finite and positive. GEMM uses non-transposed inputs,
matching input/output dtypes, and FP32 accumulation. GPT-OSS requires head
dimension 64, sequence lengths divisible by 64, query heads divisible by KV
heads, and a window of zero (full causal attention) or a positive multiple of 64.
Unsupported parameters fail the case before GPU allocation.

## Benchmarking existing corpus cases

Native suite entries select an existing correctness variant:

```toml
[[cases]]
suite = "kernels"
case = "hipkittens_gemm_bf16fp32_16x32"
variant = "m256_n256_k256"
```

The nightly suite includes that gfx950 case and
`hipkittens_gemm_bf16fp32_gfx1250_naive` on gfx1250. Each uses its existing
256x256x256 variant, BF16 inputs and output, FP32 accumulation, and A x B-transpose
layout. These are distinct kernels with distinct dashboard IDs.

The existing corpus `case.json` owns the parameters, supported targets, build
settings, and benchmark capability. Structured `parameters` containing `m`, `n`,
and `k` in its JSON variant produce the arguments for both normal tests and
benchmarks; other
cases continue to use `test_args`. Benchmark TOML does not duplicate this metadata.
Only supported target/case combinations are selected. Unknown references,
cases without benchmark support, and explicitly incompatible selections fail
before execution.

The runner reuses the corpus build adapter with an isolated Release build under
`OUTPUT/native/`, using the active ROCm SDK and building only selected executables.
CMake, a host C++ compiler with OpenMP support, and the SDK HIP compiler are
required. Configure/build logs are retained there on failure. Native compilation
is outside timing samples but inside the CI benchmark step's 30-minute limit.

The two executables accept `--benchmark --case ID --target TARGET --warmups N
--samples N --output PATH` alongside their shape arguments. A shared helper
initializes the launch path, warms up, and measures one launch plus synchronization
per sample using a monotonic host clock. Allocation and reference checks stay
outside samples. Benchmark mode skips numerical validation; normal corpus tests
retain it and should be run when changing the kernels or their inputs.

The gfx950 kernel requires M/N multiples of 256 and K a multiple of 128;
the gfx1250 kernel requires M/N multiples of 64 and K a multiple of 32.
Dimensions and matrix element counts must fit signed 32-bit indexing.
These checks run before allocation. Neither kernel supports ragged shapes.

## Results and plugins

`run.json` uses schema version 1 and records raw samples, summaries, cell status,
configuration, package versions, and both rocjitsu and corpus revisions,
commit timestamps, and dirty state. Each cell retains `workload.json`,
`stdout.txt`, `stderr.txt`, and its generated `config.json` under `cases/`.
Dashboard problem definitions come from the resolved suite definitions (Triton
TOML parameters or native corpus metadata) for both successful and failed cases,
so a new case can publish its first failure without an existing catalog entry. Derived launch and source metadata remain in `workload.json`.
A workload that fails early may have no `workload.json`.

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

Published files follow the [dashboard contract](https://github.com/ROCm/rocm-systems/blob/64c135a1314a94d7156ccb352c9ae48b65ec59a5/emulation/rocjitsu/website/docs/website-data-contract.md):
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
comparison. `--machine-id` defaults to the recorded hostname; CI passes the
benchmark runner's name. `--is-beta` controls the site's Beta label.

CI publishes only the uninstrumented nightly suite. The benchmark step has a
30-minute timeout, excluding installation, the rocjitsu build, and publication.
Native case builds count toward that limit. The full 58-cell suite passed locally
in 18m11s, including fresh native builds, with eight threads, three warmups, and
21 samples; hosted runner speed may differ. A fresh dataset requires a completed
Vanilla run before the dashboard can display it, although failed runs can be
published.

Run the benchmark harness tests through the repository's pytest configuration,
without ROCm dependencies. pytest-xdist supplies the plugin used by the root
configuration; install these test tools separately from the AMD package index:

```bash
python3 -m pip install --index-url https://pypi.org/simple \
  'pytest>=5.4.1' 'pytest-xdist>=1.32.0'
python3 -m pytest -q tests/test_benchmark_*.py
```
