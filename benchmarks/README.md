# Rocjitsu benchmarks

Triton workload sources live under `corpus/benchmarks/triton/`, with an
independent sequential runner. Suite TOML files contain case metadata and
parameters. Benchmark runs are separate from normal pytest collection.

## Setup and run

Use Python 3.12. From this repository, install the pinned ROCm environment:

```bash
python3.12 -m venv /path/to/benchmark-env
python=/path/to/benchmark-env/bin/python
"$python" -m pip install -r benchmarks/requirements.txt

src=/path/to/rocm-systems/emulation/rocjitsu
build=/path/to/rocjitsu-build-release
rocm=$("$(dirname "$python")/rocm-sdk" path --root)
export LD_LIBRARY_PATH="$rocm/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
cmake -S "$src" -B "$build" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=ON -DLTO=OFF \
  -DRJ_ENABLE_ASAN=OFF -DRJ_ENABLE_MSAN=OFF \
  -DRJ_ENABLE_TSAN=OFF -DRJ_ENABLE_UBSAN=OFF \
  -DROCM_PATH="$rocm" -DPython3_EXECUTABLE="$python"
cmake --build "$build"

"$python" -m benchmarks.runner \
  --rocjitsu-source-dir "$src" --build-dir "$build" \
  --output .benchmark-artifacts/run-001
```

The runner checks the Release configuration, disabled LTO/sanitizers, source
root, and SDK against the active Python environment. Rebuild rocjitsu after
source changes.

The default `benchmarks/suites/nightly.toml` runs 28 cases on both `gfx950` and
`gfx1250` (56 cells). Sixteen cases cover FP16 and BF16 GEMMs at
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

GPT-OSS attention lives alongside the other Triton workloads in
`corpus/benchmarks/triton/gpt_oss_attention.py`. Its top comment records the
upstream repository, commit, and original path. The adapter calls `_attn_fwd`
directly with fixed launch settings; it does not download a model or autotune.

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

## Results and plugins

`run.json` uses schema version 1 and records raw samples, summaries, cell status,
configuration, package versions, and both rocjitsu and corpus revisions,
commit timestamps, and dirty state. Each cell retains `workload.json`,
`stdout.txt`, `stderr.txt`, and its generated `config.json` under `cases/`.
Dashboard problem definitions come from TOML parameters for both successful and
failed cases, so a new case can publish its first failure without an existing
catalog entry. Derived launch and source metadata remain in `workload.json`.
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
30-minute timeout, excluding installation, building, and publication. The
expanded suite passed all 56 cells locally in 17m43s with eight threads, three
warmups, and 21 samples; hosted runner speed may differ. A fresh dataset requires a completed Vanilla run
before the dashboard can display it, although failed runs can be published.

Run the runner and publisher unit tests without ROCm dependencies:

```bash
python3 -m unittest discover -s benchmarks/tests
```
