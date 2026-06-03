# Tensile gfx1250 Corpus

This directory packages the gfx1250 TensileLite configs selected by:

```bash
python -m pytest Tensile/Tests/common -m "gfx1250" -v
```

The configs come from ROCm rocm-libraries commit
`a8f0845f87ab50adc3dc8d0edd86693cb31065b1`, under
`projects/hipblaslt/tensilelite/Tensile/Tests/common`.

## Contents

- `selected-configs.txt`: all 53 pytest-selected gfx1250 configs.
- `manifest.csv`: the 48 configs that actually ran after pytest skip markers,
  with generated artifact counts.
- `numeric-smoke-configs.txt`: a small default numeric validation subset.
- `configs/`: copied source YAML configs.
- `artifacts/`: generated `gfx1250` library artifacts for each runnable config.
  Each leaf contains:
  - `Kernels.so-000-gfx1250.hsaco`
  - `TensileLibrary_gfx1250.co`
  - `TensileLibrary.yaml`
- `logs/`: build-only timing and summary from the artifact-generation run.

The artifact-generation run was done under kmd.so, with `rocm_agent_enumerator`
reporting `gfx1250`, using:

```bash
python -m pytest Tensile/Tests/common -m "gfx1250" -v -s \
  --tensile-options="--build-only,--gpu-targets,gfx1250"
```

Summary:

```text
48 passed, 5 skipped, 249 deselected, 1 warning in 238.18s
```

All generated HSACOs inspected with `/home/jakub/llvm/main/build/bin/llvm-readelf`
were flagged `gfx1250`.

## Rebuild And Validate

First install the Python requirements and build the TensileLite client from a
ROCm rocm-libraries checkout:

```bash
python -m pip install -r requirements.txt
./scripts/build_tensilelite_repro.sh \
  --env-file env/kmd-so.example.sh \
  --tensilelite-root /path/to/rocm-libraries/projects/hipblaslt/tensilelite
```

Then use the corpus runner from the repository root:

```bash
./scripts/run_tensile_gfx1250_repro.sh env/kmd-so.example.sh
```

That rebuilds all runnable configs in build-only mode. For a numeric smoke test,
omit `--build-only` by using `--numeric`:

```bash
./scripts/run_tensile_gfx1250_repro.sh --numeric env/kmd-so.example.sh
```

Numeric mode runs Tensile's benchmark/validation path and defaults to the three
configs in `numeric-smoke-configs.txt`. Use `--numeric --all` for every runnable
config, or `--numeric --case sk_sgemm_quick` for one config.

The runner needs a ROCm rocm-libraries checkout with TensileLite available. Set
`TENSILELITE_ROOT` or pass `--tensilelite-root` if it cannot find a sibling
checkout automatically. Numeric mode also needs `tensilelite-client`; by default
the runner looks for `build_tmp/tensilelite/client/tensilelite-client` under the
TensileLite checkout, or accepts `--prebuilt-client`.

Current kmd.so numeric status: the numeric runner reaches
`tensilelite-client` and loads the generated gfx1250 code object, but the
current simulator aborts before validation with:

```text
AMDHSA kernarg preload exceeds kernarg segment size
```

This was reproduced on `sk_sgemm_quick.yaml` and `spmm_b8f8.yaml`. The numeric
runner is kept in the corpus so the same configs become validation checks once
that simulator issue is fixed or when running against real gfx1250 hardware.
