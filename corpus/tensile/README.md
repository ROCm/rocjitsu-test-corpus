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
  with generated artifact counts, plus the reduced SGEMM runtime smoke entry.
- `numeric-smoke-configs.txt`: a small default numeric validation subset. It
  uses `sk_sgemm_runtime_smoke.yaml`, a reduced runtime-only copy of the first
  `sk_sgemm_quick.yaml` benchmark group, because the upstream quick config also
  contains a 648-solution tuning sweep that is too large for the default
  simulator smoke.
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
config. The full upstream `sk_sgemm_quick.yaml` config remains packaged, but it
includes a 648-solution tuning sweep and should be treated as a long-form run
rather than the default kmd.so smoke.

The runner needs a ROCm rocm-libraries checkout with TensileLite available. Set
`TENSILELITE_ROOT` or pass `--tensilelite-root` if it cannot find a sibling
checkout automatically. Numeric mode also needs `tensilelite-client`; by default
the runner looks for `build_tmp/tensilelite/client/tensilelite-client` under the
TensileLite checkout, or accepts `--prebuilt-client`.

Current kmd.so numeric status on RocJITsu gfx1250 DBT commit
`15e78baad4`: the default numeric smoke passes `spmm_b8f8.yaml`,
`hhs_dgelu_gfx1250.yaml`, and the reduced SGEMM runtime smoke under kmd.so.
