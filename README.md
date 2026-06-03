# RocJITsu gfx1250 Corpus

This repository packages a small gfx1250 VMFB corpus for quick FFM and kmd.so
regression checks.

The runner is intentionally simple: it sources one environment file, then runs a
fixed list of commands over the packaged VMFBs and records pass/fail plus
wall-clock time.

## Requirements

The IREE tools must be available in `PATH`:

- `iree-check-module`
- `iree-e2e-matmul-test`

The env file is responsible for selecting the runtime mode. For FFM, pass a
local env file for the shell/runtime setup you want to test. For kmd.so it
should set `LD_PRELOAD`, `RJ_CONFIG`, and any ROCm runtime variables required by
that setup.

## Run

```bash
./scripts/run_gfx1250_regression.sh --out-dir results-ffm path/to/ffm-env.sh
./scripts/run_gfx1250_regression.sh --out-dir results-kmd env/kmd-so.example.sh
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
