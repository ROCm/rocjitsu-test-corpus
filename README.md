# RocJITsu Test Corpus

This repository vendors third-party resources and adapts them into test cases
for RocJITsu regression coverage. The main pytest entrypoint is `tests/test_corpus.py`.

## Repository Layout

```text
corpus/
  iree/       IREE run-module cases and target configs.
  kernels/    HIP kernel reproducers, CMake runners, and vendored sources.
  dbt/        Offline DBT translation profiles.
  semantics/  Standalone target-specific HIP semantic programs.
  tensile/    gfx1250 TensileLite configs and generated artifacts.

tests/
  test_corpus.py       Unified pytest entrypoint.
  test_suites/         Suite adapters used by test_corpus.py.
  support/             Shared discovery, target, build, and run helpers.

scripts/
  run_gfx1250_regression.sh
  extract_gfx1250_hsacos.py
  ... additional corpus helper scripts

requirements.txt       Python packages for pytest and corpus helpers.
```

## Corpus Contents

- `corpus/iree/`: IREE HIP e2e and matmul cases described by JSON files. The
  suite compiles with `iree-compile` and runs with `iree-run-module`.
- `corpus/kernels/`: standalone HIP kernel reproducers. Current backends include
  `hip-stream-k`, `hip-matmul`, `hipkittens`, and `llama.cpp`.
- `corpus/cts/`: HIP semantic tests organized by target family, including
  FPSan-derived floating-point cases and standalone integer ISA cases.
- `corpus/semantics/`: standalone HIP programs with deterministic inputs,
  source-ISA coverage, and typed results that can be captured under any
  externally selected launch configuration.
- `corpus/tensile/`: gfx1250 TensileLite YAML configs, manifests, numeric smoke
  lists, and generated HSACO/code-object artifacts. This corpus is run by the
  Tensile scripts, not by `tests/test_corpus.py`.

`tests/test_corpus.py` discovers and runs the `iree`, `kernels`, `cts`, `dbt`,
and `semantics` suites. By default it uses target `gfx1201` and selects the
first three; `dbt` and `semantics` are opt-in.

## Prerequisites

```bash
# Install Python packages in your virtual environment.
python -m pip install -r requirements.txt

# Check that the IREE tools are available.
command -v iree-compile iree-run-module

# Check ROCm SDK discovery, or set ROCM_PATH explicitly.
rocm-sdk path --root
```

## Run `tests/test_corpus.py`
Preview the selected pytest cases without running them:

```bash
pytest --collect-only tests/test_corpus.py
```

Run through RocJITsu with all valid test suites for that target:

```bash
rocjitsu --config /path/to/gfx1201.json -- \
  pytest tests/test_corpus.py \
  --target gfx1201 \
  --timeout 15
```

Run the RocJITsu corpus matrix for all configured gfx targets:

```bash
ROCM_VENV=path/to/.venv \
ROCJITSU_WORKSPACE=path/to/rocjitsu-workspace \ # contains configs and rocjitsu binary
ROCJITSU_EXE=path/to/rocjitsu-binary \
./scripts/run_rocjitsu_corpus_matrix.sh
```

Run selected suites:

```bash
rocjitsu --config /path/to/gfx1201.json -- \
  pytest tests/test_corpus.py \
  --target gfx1201 \
  --suite kernels,cts \
  --timeout 15
```

Run selected cases:

```bash
rocjitsu --config /path/to/gfx1201.json -- \
  pytest tests/test_corpus.py \
  --target gfx1201 \
  --suite cts \
  --case fpsan_wmma \
  --timeout 15
```

Run suite runtime commands through a wrapper:

```bash
pytest tests/test_corpus.py \
  --target gfx1201 \
  --run-wrapper "rocjitsu --config ${CONFIG} --"
```

Run with a list of tests to skip:

```bash
rocjitsu --config /path/to/gfx1201.json -- \
  pytest tests/test_corpus.py \
  --target gfx1201 \
  --skip-tests-config tests/gfx1201_skip_tests.example.json
```

Useful selectors:

- `--target <gfx target>`: target to run, for example `gfx942`, `gfx950`,
  `gfx1201`, or `gfx1250`.
- `--suite <iree|kernels|cts|dbt|semantics>`: include a suite. Repeat or pass
  comma-separated values.
- `--exclude-suite <suite>`: exclude a suite.
- `--backend <backend>`: include a kernel backend such as `hipkittens`.
- `--exclude-backend <backend>`: exclude a kernel backend.
- `--case <selector>`: include a case by case id or selector name.
- `--exclude-case <selector>`: exclude a case.
- `--artifact-directory <path>`: write build artifacts, logs, and generated
  outputs somewhere other than `.pytest-artifacts`.
- `--run-wrapper <command>`: prepend a shell-style command prefix to supported
  suite runtime commands.
- `--comparison-run-wrapper <command>`: run each selected semantic program
  through a second wrapper and compare its typed results exactly with the
  self-checking `--run-wrapper` results. This option requires selecting only
  the `semantics` suite.
- `--comparison-required-stderr <text>`: require text in each comparison
  run's stderr; repeat for multiple external activation checks.
- `--timeout <seconds>`: fail an individual pytest case if it exceeds this
  runtime. This is provided by `pytest-timeout` and is not a timeout for the
  entire script; use `--session-timeout <seconds>` for a whole-session limit.
- `--skip-all-runs`: build or compile only where supported.
- `--dbt-corpus <path>`: packaged-HSACO extraction root for the opt-in `dbt`
  suite; defaults to `ROCJITSU_HSACO_CORPUS`.
- `--dbt-translator <path>`: `rj_dbt_translate` executable; it can also be
  resolved from `RJ_DBT_TRANSLATE`, `ROCJITSU_BUILD_DIR`, `ROCJITSU_BUILD`, or
  `PATH`.
- `--dbt-llvm-objdump <path>`: gfx1250-capable TheRock `llvm-objdump` used to
  disassemble each successful translated object; it can also be resolved from
  `ROCJITSU_DBT_LLVM_OBJDUMP`, beside the translator, or `PATH`.
- `--dbt-package-lock <path>`: consumer-owned producer-package versions,
  file-only manifest digest, and extraction-size rules.
- `--dbt-expected-failures <path>`: consumer-owned strict expected-failure
  manifest.
- `--dbt-expected-rewrites <path>`: consumer-owned manifest recording how
  many source instructions require rewriting in selected inputs.
- `--dbt-timeout <seconds>`: override the profile's per-object translation
  timeout.
- `--dbt-memory-limit-mib <MiB>`: override the profile's per-object translator
  resident-memory limit.
- `--dbt-allow-incomplete-corpus`: explicitly consume an extraction that
  records `"complete": false` solely because CCOB materialization was skipped.

## gfx1250 semantic run capture

The opt-in `semantics` suite builds standalone gfx1250 HIP programs, verifies
their declared source instructions, and runs them directly or through the
repository-wide wrapper:

```bash
ROCM_PATH=/path/to/rocm-sdk \
pytest tests/test_corpus.py \
  --target gfx1250 \
  --suite semantics \
  --run-wrapper "/path/to/launcher --config /path/to/config.json --"
```

The package also provides generic capture and comparison utilities. External
workflows choose simulator or physical hardware, original or prepared
binaries, environment variables, and provenance checks. See
[`corpus/semantics/gfx1250/README.md`](corpus/semantics/gfx1250/README.md) for
the build, capture, comparison, and hardware-golden flow.

## Packaged gfx1250 HSACO extraction

The packaged-HSACO workflow inventories the gfx1250 code objects shipped in an
active TheRock/PyTorch venv. It deliberately stops at extraction so the same
content-addressed corpus can feed separate offline translation and analysis
workflows. The large generated corpus stays in ignored `results-*` directories
rather than being committed.

Install the explicit gfx1250 PyTorch device package into the same venv as
TheRock. Installing plain `torch` can select a build without the gfx1250
payload. The consumer supplies the requirements file so package updates and
their corresponding DBT expectations stay in one change:

```bash
export ROCM_VENV=/path/to/venv
export DBT_REQUIREMENTS=/path/to/requirements-gfx1250-dbt.txt

uv pip install \
  --python "$ROCM_VENV/bin/python" \
  -r "$DBT_REQUIREMENTS"

"$ROCM_VENV/bin/rocm-sdk" init
"$ROCM_VENV/bin/python" -c \
  'import torch; print(torch.__version__, torch.version.hip, torch.cuda.get_arch_list())'
```

Extract the packaged code objects:

```bash
"$ROCM_VENV/bin/python" scripts/extract_gfx1250_hsacos.py \
  --environment "$ROCM_VENV" \
  --destination results-gfx1250-packaged \
  --materialize-ccob
```

The extractor covers:

- TheRock and PyTorch KPACK archives;
- loose loadable AMDGPU ELF code objects;
- gfx1250 entries in HIP offload bundles;
- directly embedded gfx1250 AMDGPU ELFs;
- AOTriton ZIP/AKS2 image stores;
- CCOB containers materialized through HIP.

All methods except CCOB are file-only. `--materialize-ccob` needs a visible
gfx1250 GPU and a working `/dev/kfd`; omit it for a fully offline extraction
subset. The resulting `summary.json` then has `"complete": false`, making the
omission explicit.

Deduplication is by the SHA-256 of the complete HSACO bytes. Each unique object
is written once as `objects/<sha256>.hsaco`; duplicate KPACK members, loose
files, embedded images, and AOTriton records retain separate entries in
`manifests/provenance.jsonl`. `summary.json` reports both `source_records` and
`unique_code_objects`, while `manifests/SHA256SUMS`,
`manifests/NON_CCOB_SHA256SUMS`, and `manifests/packages.json` preserve
integrity, the pinned file-only baseline, and environment details.

The extractor is deterministic for an unchanged environment: filesystem,
archive, record, and checksum orderings are canonical; JSON keys are sorted;
and generated manifests contain no timestamps or destination-dependent paths.
Two runs against the same venv should have identical `objects/` contents and
byte-identical files under `manifests/` plus an identical `summary.json`.

Verify every extracted object against its content-addressed filename:

```bash
(
  cd results-gfx1250-packaged
  sha256sum --quiet -c manifests/SHA256SUMS
)
```

Consumers should use `manifests/SHA256SUMS` or the flat `objects/*.hsaco`
directory as their input list. Translation results and policy belong in their
own result directory and should not be mixed back into the extraction corpus.

## Offline gfx1250 B0-to-A0 translation

Translation is a separate, read-only consumer of a completed extraction. The
`dbt` suite sends each unique object to `rj_dbt_translate` with input revision
`b0` and output revision `a0`. It verifies each input hash and checks
code-object output has bounded ELF tables, executable loadable content, and a
non-empty AMDGPU metadata note. Hash-pinned objects selected by the consumer additionally
run in diff mode and must reproduce the expected number of source instructions
requiring rewrite. The output instruction sequence remains free to change. The
pinned profile gives each translator process a 30-second timeout and 4 GiB
resident-memory limit, while stdout and stderr are spooled to temporary files
so large outputs do not accumulate in pytest worker memory. Every successful
output must also disassemble with the selected TheRock `llvm-objdump`,
independently exercising LLVM's ELF and gfx1250 ISA readers.

The consumer-owned package lock ties the extraction to its producer packages.
It records the relevant TheRock, PyTorch, and Triton versions, the file-only
manifest digest, and object-count rules. Collection fails before any xfail or
rewrite expectation is applied if the extraction does not match that lock.
Expected failures and rewrites are consumer-owned as well, so package and
translator updates can adjust all coupled inputs in one change.

Keep extraction and translation as separate commands, but sequence them so
pytest only runs after extraction succeeds:

```bash
export ROCM_VENV=/path/to/venv
export ROCJITSU_HSACO_CORPUS="$PWD/results-gfx1250-packaged"

"$ROCM_VENV/bin/python" scripts/extract_gfx1250_hsacos.py \
  --environment "$ROCM_VENV" \
  --destination "$ROCJITSU_HSACO_CORPUS" \
  --materialize-ccob &&
"$ROCM_VENV/bin/python" -m pytest tests/test_corpus.py \
  --target gfx1250 \
  --suite dbt \
  --dbt-translator /path/to/build/tools/rj_dbt_translate \
  --dbt-llvm-objdump /path/to/therock/lib/llvm/bin/llvm-objdump \
  --dbt-package-lock /path/to/package_lock.json \
  --dbt-expected-failures /path/to/expected_failures.json \
  --dbt-expected-rewrites /path/to/expected_rewrites.json \
  -n 8
```

An offline extraction that intentionally omitted GPU-only CCOB materialization
has `"complete": false`. Opt in explicitly when testing that subset:

```bash
pytest tests/test_corpus.py \
  --target gfx1250 \
  --suite dbt \
  --dbt-translator /path/to/build/tools/rj_dbt_translate \
  --dbt-llvm-objdump /path/to/therock/lib/llvm/bin/llvm-objdump \
  --dbt-package-lock /path/to/package_lock.json \
  --dbt-expected-failures /path/to/expected_failures.json \
  --dbt-expected-rewrites /path/to/expected_rewrites.json \
  --dbt-allow-incomplete-corpus \
  -n 8
```

Expected failures are keyed by the full input SHA-256 and additionally constrain
the failure class, process return code, and diagnostic. An unlisted failure,
changed diagnostic, timeout of the wrong object, or successful translation of
an xfailed object fails the suite. Only expected and unexpected failures write
diagnostic logs. Successful output stays file-backed during validation and is
deleted afterward.
