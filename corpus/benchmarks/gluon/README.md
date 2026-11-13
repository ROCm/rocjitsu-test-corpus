# Gluon bounded copy benchmarks

The runner-facing command is `python corpus/benchmarks/gluon/workloads.py` (or
`python -m corpus.benchmarks.gluon.workloads`). It accepts the common
`--workload --params --case --target --warmups --samples --output` protocol and
emits only schema/case/target/provider/parameters/timings_ns, with schema
`rocjitsu.benchmark.workload.v1` and provider `gluon`.

| Workload | Exact selected parameters | Selected thread policies |
|---|---|---|
| `gluon_copy` | `{"elements":100663296,"dtype":"fp32"}` | single only |
| `gluon_copy_2d` | `{"rows":16384,"columns":8192,"dtype":"fp32"}` | default only |

Both target gfx1100 and gfx1201. Policy selection belongs to the recipe/runner,
not this adapter. Smaller positive sizes (up to 134217728 total elements) are
accepted for qualification and mask-boundary checks. Dtype is fixed FP32;
manifest parameters explicitly specify `"dtype":"fp32"`; standalone callers may
omit it (defaults to `fp32`). Other dtype values are rejected, and emitted
parameters always record `dtype`. Dtype is metadata, not a kernel dimension.
2D input is contiguous, output is the transposed view of a columns-by-rows
allocation, with logical shape rows-by-columns and strides `(1, rows)`.

## Dependencies and preparation

Use the corpus-pinned ROCm Torch/Triton environment and coherent RDNA device
packages for the selected target; Gluon ships within Triton, not a separate pip
package. No install, benchmark, device enumeration or model download is performed
by preparation. Python stdlib alone can verify extraction/provenance:

```sh
python corpus/benchmarks/gluon/prepare.py --upstream --output "$ATTEMPT/gluon-source.json"
```

This fetches the exact pinned tutorial and license into memory, checks their
SHA-256 values, then compares all three complete function bodies and decorators
with the shipped extraction. Offline preparation may omit `--upstream` and
checks shipped hashes only; its receipt explicitly records that distinction.
Receipts are exclusively created outside the source directory. Runtime also
checks the shipped extraction/license hashes before importing device code.

## Launch and timing

Parent-only simulator example (do not execute natively on a host GPU):

```sh
python corpus/benchmarks/gluon/workloads.py --workload gluon_copy_2d \
  --params '{"rows":16384,"columns":8192,"dtype":"fp32"}' --case gluon-strided-copy \
  --target gfx1100 --warmups 0 --samples 1 --output "$RESULT"
```

The unchanged upstream functions use the qualified blocked layouts: 1D XBLOCK
1024 / four warps; 2D tile 128x128 / four warps, input layout
`([1,4],[4,8],[4,1],[1,0])`, output `([4,1],[8,4],[1,4],[0,1])`.
`TritonLaunch.compile()` only compiles/initializes; `benchmarks.measurement.measure`
times one launch plus synchronization per sample. Warmups are nonnegative and
samples positive caller-provided integers, with no arbitrary upper cap or adaptive
loops. The benchmark runner additionally requires odd sample counts; standalone
adapters accept even counts. Preparation, CPU input construction, poisoning,
progress and validation remain outside timing. Poisoning uses stride-aware
`fill_(NaN)`, not `view(uint8)`, which cannot handle this output view. Every
logical output element is compared exactly on CPU with independent nonuniform,
exact-dyadic input generation; no GPU reference kernel or validation rerun.

Host tests: `python -m pytest tests/test_benchmark_gluon.py -q`. The actual
strided-output positive/NaN/index-corruption test needs Torch, but uses CPU
allocations only and no device query; it is explicitly skipped without Torch.
The remaining argument/schema/provenance tests use stdlib only. CPU passes are
not simulator or GPU correctness evidence.
