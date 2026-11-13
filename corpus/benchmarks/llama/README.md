# Bounded llama / GGML operator benchmarks

`workloads.py` is a stdlib-only runner adapter. It accepts
`--workload --params --case --target --warmups --samples --output` and emits
exactly schema/case/target/provider/parameters/timings_ns with schema
`rocjitsu.benchmark.workload.v1` and provider `llama`. Supply the prepared binary
through `ROCJITSU_LLAMA_BINARY` or `--binary`; it must have a matching adjacent
`benchmark-build.json` receipt (source pin/backend/target checked), and the
binary path must exist as a file. Executable and GGML library hashes are not
validated.
There is no stock perf loop, adaptive repetition, model download or CPU fallback.

| Workload | Selected parameters | Graph / selected policies |
|---|---|---|
| `llama_rope` | `{"k":128,"heads":4096,"tokens":32,"dtype":"fp32"}` | normal FP32 RoPE `[128,4096,32,1]`, default only |
| `llama_matvec` | `{"k":4096,"rows":32768,"tokens":1,"dtype":"fp32"}` | Q4_0 weights `[4096,32768]`, one FP32 RHS, default and single |
| `llama_gather` | `{"k":4096,"rows":1024,"tokens":4096,"dtype":"fp32"}` | Q8_0 table `[4096,1024]`, 4096 gathered rows, default only |

Targets are gfx1100 and gfx1201. The recipe/runner owns thread policies.
Dimensions are bounded positive integers, K even for RoPE and divisible by 32
for quantization. Matvec always has one RHS. Each source/output footprint is
bounded by 134217728 elements. Small shapes are supported for host tests.
Manifest parameters explicitly specify `"dtype":"fp32"`, the only supported
dtype; standalone callers may omit it (defaults to `fp32`). Emitted parameters
always record dtype and the exact llama commit as `source_pin`, preserving the
requested dimensions. The outer `run.json` corpus revision supplies adapter
provenance; the workload does not duplicate that Git metadata.
Dtype describes FP32 activations/output, not the quantized
weight storage. Dtype is wrapper metadata: it is neither forwarded as a native
dimension flag nor required in the native dimension-only JSON. All native
correctness, provenance, dimension and sampling checks remain enforced.

## Exact source and out-of-source preparation

This harness needs a **separate** caller-owned pristine llama.cpp checkout at
`26d52b0f9543f441fc2bfa383557c992a4fbf4b9`. Do not repoint or upgrade existing
`corpus/llama` sources. No upstream source is vendored here; license and attribution
are retained separately in LICENSE/NOTICE.md.

```sh
git clone https://github.com/ggml-org/llama.cpp.git "$LLAMA_SOURCE"
git -C "$LLAMA_SOURCE" checkout --detach 26d52b0f9543f441fc2bfa383557c992a4fbf4b9
python corpus/benchmarks/llama/prepare.py --source "$LLAMA_SOURCE" \
  --build "$ATTEMPT/llama-hip" --backend hip --rocm-path "$ROCM_PATH"
export ROCJITSU_LLAMA_BINARY="$ATTEMPT/llama-hip/bounded-ops"
```

The CLI verifies the exact HEAD, checkout root, expected files and pristine state
(including ignored/untracked files) before configuration and after build. Build
must be a **fresh** directory outside both source trees, with no source ancestor
used as build root. Preparation never clones, checks out, patches or writes into
the source. It uses CMake >=3.28, Ninja, C/C++17 compilers, Git and Python stdlib.
HIP additionally needs a coherent ROCm SDK (HIP >=6.1 per upstream), HIP compiler,
hipBLAS and rocBLAS development packages. The actual SDK should be the same as
used by the corpus/runner, not an implicitly discovered system installation.

All builds use `cmake --build ... -j16`. ccache is disabled in CMake and the child
environment, compiler launchers are cleared, and child TMPDIR/XDG_CACHE_HOME/
CCACHE_DIR are owned by the new build. Explicit architectures are
`gfx1100;gfx1201`; the HIP toolchain and ROCm root are explicit. Any inherited
HCC_AMDGPU_TARGET is removed and replaced only in this child with the two build
targets, suppressing implicit compiler device discovery. SDK loader directories
are prepended without dropping inherited LD_LIBRARY_PATH. FlashAttention and
HIP graphs are disabled, VMM disabled, native CPU tuning disabled, runtime
backend loading disabled. GGML's HIP implementation is otherwise unchanged.
The receipt records the llama source commit, license/adapter/CMake hashes and
exact CMake commands. Those hashes are diagnostic build evidence, not execution
attestation. Older receipts may include an unused `binary_sha256`; new receipts
do not generate it. Configure/build logs and linked libraries stay in the build tree;
keep the entire tree with the binary (build-tree RPATHs are intentional).

This is commit provenance under a controlled preparation/execution workflow,
not proof of the executable bytes or the GGML libraries actually loaded.
Use the prepared executable and intact build tree from that workflow; source
pins and receipt metadata do not detect arbitrary executable/library replacement
or loader overrides. The wrapper still checks the native result's source pin
and CPU-versus-HIP backend identity; native HIP mode checks the actual target.

Preparation performs no GPU/simulator execution. Actual benchmark invocation
belongs inside the parent runner's serialized simulator launcher:

```sh
python corpus/benchmarks/llama/workloads.py --workload llama_matvec \
  --params '{"k":4096,"rows":32768,"tokens":1,"dtype":"fp32"}' --case llama-q4-matvec \
  --target gfx1100 --warmups 0 --samples 1 --output "$RESULT"
```

Native HIP mode validates the actual reported architecture before graph setup.
It requires direct HIP support for the operation; there is no scheduler fallback.

## Timing and upstream CPU reference validation

A graph contains exactly one operation. Each warmup/sample invokes graph compute
once, followed by synchronization; `steady_clock` measures that host-wall
interval as integer nanoseconds. Uploads, full NaN output poisoning and a drain
synchronize precede **every** invocation outside timing. Input generation,
allocation, CPU reference graph copying/execution, output readback
and full comparison are outside timing. Only samples enter timings_ns. The
final measured output is validated without rerunning computation. Warmups
are nonnegative and samples positive fixed caller-provided integers, bounded
only by the native `int` representation (2147483647 on supported builds), not an
arbitrary sampling cap. Invocation totals use widened arithmetic. Standalone
adapters accept even samples; the benchmark runner requires odd samples. Shape
and tensor-footprint bounds are unchanged. First invocation
may include lazy GGML dispatch/workspace preparation and activation packing;
this is whole-graph host timing, not an isolated device-event measurement.

Inputs retain deterministic nonuniform values, duplicate/dispersed gather
indices and RoPE positions 7..tokens+6. Gather inputs encode the row index in
15 +/-1 sign markers in the first Q8_0 block, preserving distinct rows after
upstream quantization instead of repeating every 101 rows. Matvec weights retain
that historical nonuniform K pattern, positively offset and scaled:
`M * (64 + ((row*K + lane)*17 + 13)%101) / 256`, where
`M = 1 + floor(row/32)`. The first 15 lanes instead encode row-index signs
`+/-M`. The independent FP32 RHS is `(8 + (lane*3)%15)/1024` (period 5).
Both operands vary within a 32-value quantization block; the row repair must not
flatten either reduction operand. Positive bulk avoids cancellation, and row
magnitude separates modulo-101 substitutions after accumulation. Sign markers
preserve serialized row identity, not detection of every possible wrong row.

First-block Q4 scales `+/-M/8` are exactly FP16-representable for M=1..1024.
Bulk scales are not all exact: the selected-size upstream quantizer/dequantizer
probe found maximum relative FP16 scale rounding 0.000486618, maximum bulk
scale 82, and decoded bulk weights between 0.222551*M and 0.640931*M.
No bulk block became constant after quantization. The `/256` normalization
preserves headroom: bounding every nonmarker decoded weight by 0.75*M gives
absolute dot sum <=61515 at K4096/M1024 with the original dyadic RHS, below
FP16 maximum 65504 even before using FP32 accumulation. This is a conservative
input-range bound, not a claim about unqualified HIP intermediate arithmetic.
A full selected-size CPU run (K4096/32768 rows) passed against the separate
upstream reference. The actual-serialized-row modulo-101 mutation rejected all
32667 changed outputs; all 32768 quantized rows were distinct and the minimum
changed-output tolerance ratio was 21.228. Maximum reference output was 25539.2.
The bounded K4096/202-row regression retains all 101 required substitutions.
All these CPU results retain the unchanged .03/.02 policy; HIP qualification
remains separate.
Upstream `init_tensor_uniform` uses `random_device`-seeded uniform samples: it
was inspected but does not guarantee reproducible separation of these selected
dot outputs at the existing tolerance. This small deterministic input repair
retains upstream quantization and reference execution, not a new numerical oracle.
Validation follows
upstream `tests/test-backend-ops.cpp` MODE_TEST: a separate CPU backend explicitly enables
`ggml_backend_cpu_set_use_ref(backend, true)`. This is GGML's reference mode, not
its default optimized CPU mode. The setter is linked directly from the pinned
public CPU API; missing support fails the build rather than silently using a
different mode. `ggml_backend_graph_copy` copies the allocated graph's actual
serialized inputs (including quantized weights), layout and operation parameters
into a distinct CPU buffer. The cloned one-operation graph executes exactly once
before any warmup/sample. Its result is read back, then its graph, buffer and
backend are freed before timing. It cannot overwrite the tested graph's output.
No corpus-written unpacking, dot-product, gather or trigonometric oracle remains.
This reuses upstream reference execution, not the upstream test suite or its
comparison policy; shared upstream defects are not independently detected.

All output elements are checked; nonfinite values fail. Existing comparison
policy is unchanged: RoPE/gather atol=rtol=2e-5; matvec atol=.03, rtol=.02 allows
activation-packing differences. Native JSON reports checked/bad/error/tolerances,
source pin/backend/parameters/measured invocation count, plus
`reference_backend="CPU"`, `reference_use_ref=true` and
`reference_graph_invocations=1`. The reference invocation is not included in
`graph_invocations` or `timings_ns`. The wrapper accepts the additive native
metadata without adding fields to its top-level workload schema.

Reference validation adds an untimed CPU execution and a temporary host copy of
the graph's inputs/output, in addition to the tested backend allocation and host
input/comparison vectors. CPU reference time and peak host memory are preparation/
validation costs, not reported sample timings. Even a HIP build requires this CPU
reference backend; it is never a fallback for the measured operation.

## CPU-only tests

```sh
python corpus/benchmarks/llama/prepare.py --source "$LLAMA_SOURCE" \
  --build "$ATTEMPT/llama-cpu" --backend cpu --mutation
LLAMA_BENCHMARK_CPU_BINARY="$ATTEMPT/llama-cpu/bounded-ops" \
  python -m pytest tests/test_benchmark_llama.py -q
```

`--cpu` is an explicit host-test-only adapter/native switch; the wrapper refuses
a CPU artifact without it, and refuses a HIP artifact with it. Never publish
host-test results as simulator measurements. Tests exercise all three real CPU
graphs against a separate reference, long-position normal/NeoX RoPE, 0/1 and 1/2
sampling, reference metadata, exact child schema, invalid arguments, wrong source
pin/build containment, receipt source/backend/target mismatches, missing binary
paths, hash-free receipts and partial-check rejection. Set
`LLAMA_BENCHMARK_SOURCE` to the exact pristine checkout to also exercise a fresh
CPU preparation and its receipt format.
`--mutation` creates CPU-only final-no-op, final-partial-write,
finite-last-element-corruption and wrong-row binaries. The no-op and partial-write
controls first compute the warmup and earlier measured sample, inspect that real
prior output against the same reference/tolerances, then omit the final compute
or copy only its first half from that prior output. They must reject all or half
of the final poisoned output, respectively, for normal/NeoX RoPE, matvec and
gather. Test-only native diagnostics confirm the earlier output passed and two
real graph invocations completed. Disabling the loop's output poison must break
this regression; startup-only poisoning cannot catch stale final samples.
Finite corruption must fail the last element for all three families.
The selected-size gather test uses `bounded-ops-wrong-row` from that same prepared
build: it checks all 1024 serialized Q8_0 rows are distinct, remaps indices modulo
101 only after reference execution, and requires rejection of the 2461 changed
requests. The bounded K4096/202-row matvec test uses the same variant to substitute
complete serialized Q4 weight rows r%101 after reference execution; all 202 rows
must be distinct and all 101 substituted outputs must fail the unchanged checker.
For matvec only, that CPU-only binary also accepts test environment variable
`LLAMA_TEST_REVERSE_K=a|b`: after the reference ran, it reverses the selected
operand's lanes within each bulk 32-value block, leaving the first row-marker
block untouched. A reversal in A is quantized again by upstream before execution;
B remains FP32. The K64/4096-row test requires rejection for either operand at
unchanged tolerances, and failed for both with the flattened inputs. Short K
avoids averaging lane-order effects away; enough row magnitudes clear the
absolute-error floor. This bounded sensitivity test does not claim detection of
every K permutation or full-K reversal after long-reduction averaging.
Mutations cannot be built
in HIP mode; these controls fail native correctness checks, not receipt hash
validation.
The receipt does not distinguish mutation executables from the production one.
Without the CPU binary environment
variable, native tests are explicitly skipped, not falsely reported as passed.
CPU builds/tests do not qualify HIP compilation, runtime kernels or numerical
GPU correctness; those remain parent-owned acceptance.
