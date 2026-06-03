# RocJITsu gfx1250 Corpus

This repository packages gfx1250 VMFB and TensileLite kernel corpora for quick
FFM and kmd.so regression checks.

The runner is intentionally simple: it sources one environment file, then runs a
fixed list of commands over the packaged VMFBs and records pass/fail plus
wall-clock time.

## Requirements

The IREE tools must be available in `PATH`:

- `iree-check-module`
- `iree-e2e-matmul-test`

The Tensile runner additionally needs a ROCm rocm-libraries checkout with
`projects/hipblaslt/tensilelite`; pass `--tensilelite-root` or set
`TENSILELITE_ROOT` if it is not in a sibling checkout.

To prepare a fresh machine or venv for the Tensile corpus:

```bash
python -m pip install -r requirements.txt
./scripts/build_tensilelite_repro.sh \
  --env-file env/kmd-so.example.sh \
  --tensilelite-root /path/to/rocm-libraries/projects/hipblaslt/tensilelite
```

The build script uses the env file for ROCm/TheRock paths but unsets runtime
preload variables before configuring and building.

The env file is responsible for selecting the runtime mode. For FFM, pass a
local env file for the shell/runtime setup you want to test. For kmd.so it
should set `LD_PRELOAD`, `RJ_CONFIG`, and any ROCm runtime variables required by
that setup.

## Run

```bash
./scripts/run_gfx1250_regression.sh --out-dir results-ffm path/to/ffm-env.sh
./scripts/run_gfx1250_regression.sh --out-dir results-kmd env/kmd-so.example.sh
```

Tensile rebuild and numeric smoke checks:

```bash
./scripts/run_tensile_gfx1250_repro.sh env/kmd-so.example.sh
./scripts/run_tensile_gfx1250_repro.sh --numeric env/kmd-so.example.sh
```

Useful subsets:

```bash
./scripts/run_gfx1250_regression.sh --only e2e path/to/ffm-env.sh
./scripts/run_gfx1250_regression.sh --only matmul path/to/ffm-env.sh
./scripts/run_gfx1250_regression.sh --list path/to/ffm-env.sh
```

Each run writes:

```text
<out-dir>/results.csv
<out-dir>/logs/*.log
```

The CSV columns are:

```csv
kind,name,status,elapsed_s,returncode,log
```

## Corpus

- `corpus/e2e/*.vmfb`: IREE HIP e2e VMFBs compiled for gfx1250.
- `corpus/matmul/<case>/*_{matmul,calls}.vmfb`: specialized IREE matmul e2e
  VMFB pairs compiled for gfx1250.
- `corpus/tensile/`: gfx1250 TensileLite YAML configs plus generated HSACO and
  code-object artifacts.
