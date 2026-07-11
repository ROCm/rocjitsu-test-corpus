# RocJITsu Test Corpus

This repository vendors third-party resources and adapts them into test cases
for RocJITsu regression coverage. The main pytest entrypoint is `tests/test_corpus.py`.

## Repository Layout

```text
corpus/
  iree/       IREE run-module cases and target configs.
  kernels/    HIP kernel reproducers, CMake runners, and vendored sources.
  cts/        Deterministic HIP FPSAN CTS tests run through CTest.
  tensile/    gfx1250 TensileLite configs and generated artifacts.

tests/
  test_corpus.py       Unified pytest entrypoint for iree, kernels, and cts.
  test_suites/         Suite adapters used by test_corpus.py.
  support/             Shared discovery, target, build, and run helpers.

scripts/
  run_gfx1250_regression.sh
  ... additional corpus helper scripts

requirements.txt       Python packages for pytest and corpus helpers.
```

## Corpus Contents

- `corpus/iree/`: IREE HIP e2e and matmul cases described by JSON files. The
  suite compiles with `iree-compile` and runs with `iree-run-module`.
- `corpus/kernels/`: standalone HIP kernel reproducers. Current backends include
  `hip-stream-k`, `hip-matmul`, `hipkittens`, and `llama.cpp`.
- `corpus/cts/`: HIP FPSAN tests organized by target family, including gfx942,
  gfx950, gfx1100, gfx1201, and gfx1250 configs.
- `corpus/tensile/`: gfx1250 TensileLite YAML configs, manifests, numeric smoke
  lists, and generated HSACO/code-object artifacts. This corpus is run by the
  Tensile scripts, not by `tests/test_corpus.py`.

`tests/test_corpus.py` discovers and runs the `iree`, `kernels`, and `cts`
suites. By default it uses target `gfx1201` and selects all three suites.

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
  --timeout 1200 \
  --ctest-jobs 16 \
  --ctest-timeout 200
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
  --timeout 1200 \
  --ctest-jobs 16 \
  --ctest-timeout 200
```

Run selected cases:

```bash
rocjitsu --config /path/to/gfx1201.json -- \
  pytest tests/test_corpus.py \
  --target gfx1201 \
  --suite cts \
  --case fpsan_wmma \
  --timeout 1200 \
  --ctest-jobs 16 \
  --ctest-timeout 200
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
- `--suite <iree|kernels|cts>`: include a suite. Repeat or pass comma-separated
  values.
- `--exclude-suite <suite>`: exclude a suite.
- `--backend <backend>`: include a kernel backend such as `hipkittens`.
- `--exclude-backend <backend>`: exclude a kernel backend.
- `--case <selector>`: include a case by case id or selector name.
- `--exclude-case <selector>`: exclude a case.
- `--artifact-directory <path>`: write build artifacts, logs, and generated
  outputs somewhere other than `.pytest-artifacts`.
- `--timeout <seconds>`: fail an individual pytest case if it exceeds this
  runtime. This is provided by `pytest-timeout` and is not a timeout for the
  entire script; use `--session-timeout <seconds>` for a whole-session limit.
- `--ctest-jobs <jobs>`: number of parallel CTest jobs to use inside CTS cases.
  The matrix helper defaults to `16`.
- `--ctest-timeout <seconds>`: CTest per-test timeout for CTS cases. The default
  is `200`.
- `--skip-all-runs`: build or compile only where supported.
