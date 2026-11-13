# Full Tensile FP32 RDNA provider

This provider is **full Tensile**, not the separately pinned TensileLite
`../tensile_candidates` adapter. Workload and provider names are `full_tensile`.
The source is `ROCm/rocm-libraries/shared/tensile` at
`1c63e26254a357007ce2d963266085a30b39515b`. No experiment directory is imported
or required at runtime. FP16/WMMA is deliberately excluded.

## Fixed scope and parameters

`prepare.py:CASES` owns the accepted parameter dictionaries. No tuning or shape
fallback is permitted. Both gfx1100 and gfx1201 are supported; manifest policy
eligibility is owned by the caller (qualified selection is **default only**).

| variant | Parameters beyond `variant`, `dtype="fp32"` | Mechanism |
| --- | --- | --- |
| `valu` | m=3072,n=2048,k=1024,beta=0 | NN VALU GEMM |
| `tensor` | i=2048,j=2048,k=16,l=64,beta=1 | A[k,i,l], B[k,j,l]; two independent summations |
| `splitk` | m=3072,n=2048,k=1536,gsu=3,beta=1 | SingleBuffer beta helper + atomic main |
| `pointer` | m=1024,n=1024,k=1024,batch=8,beta=1 | GPU pointer arrays, uniform matrix batches |

## Offline preparation

Use a **separate exact-pin clean monorepo checkout**, containing `shared/tensile`.
Do not substitute the TensileLite pin. Python generator dependencies are the pin's
`shared/tensile/requirements.txt`: PyYAML, msgpack, joblib and rich. Import is from
the explicitly verified source root, without installing an editable checkout.

```sh
PYTHONDONTWRITEBYTECODE=1 python corpus/benchmarks/full_tensile/prepare.py \
  --source-root "$FULL_TENSILE_SOURCE" --sdk-root "$ROCM_PATH" \
  --output "$FULL_TENSILE_ARTIFACTS" --target gfx1100 --variant valu
```

Repeat in separate processes for the selected target/variant cells. Existing
cells are rejected instead of overwritten. This calls `writeBenchmarkFiles`,
**never** the upstream benchmark/tuning driver or HIP client. It uses one CPU
worker, explicit ISA/V5, a disabled device enumerator and real assembler
capability probes in an owned writable directory. `HCC_AMDGPU_TARGET` is set
from the validated target within the generator process, preventing hipcc's
implicit target discovery. The generator retains its generated source under
`OUTPUT/TARGET/VARIANT/build/`; the runtime needs only the flat cell files:

- `TensileLibrary.dat`, all `.co` and `.hsaco` objects (split-K needs both);
- `selection.yaml`, recording fixed choices, exact sizes and generator options;
- `artifacts.json`: exact pin, target, parameters, seed/generator hashes, and
  hashes of **every** runtime artifact and selection YAML.

Every runtime invocation checks the inventory and all hashes before starting
the native adapter. Do not discard helper objects or parse repeated upstream
`code-object` INI keys into a dictionary; this adapter does not use the INI.

## Native build

Requirements: CMake >=3.25, C++17, the coherent ROCm SDK compiler/HIP runtime,
and a C++ MessagePack CMake package with its Boost header dependencies.
On Ubuntu, use the distro's `libmsgpack-dev`/`libmsgpack-cxx-dev` packages as
applicable. No Boost program_options/filesystem libraries, AMD SMI, nanobind,
ROCISA Python extension, upstream client, or OpenMP client library is needed.

```sh
cmake -S corpus/benchmarks/full_tensile -B "$FULL_TENSILE_BUILD" \
  -DCMAKE_BUILD_TYPE=Release -DTENSILE_SOURCE="$FULL_TENSILE_SOURCE" \
  -DCMAKE_PREFIX_PATH="$ROCM_PATH" \
  -DCMAKE_CXX_COMPILER="$ROCM_PATH/bin/amdclang++"
cmake --build "$FULL_TENSILE_BUILD" --parallel 4
export FULL_TENSILE_RUNNER="$FULL_TENSILE_BUILD/full_tensile_runner"
```

CMake verifies the pin and clean source. It builds only upstream `TensileHost`
and the small first-party adapter. Compilation is host-only. Both `GPU_TARGETS`
and SDK `GPU_BUILD_TARGETS` are set **before** HIP discovery; without this,
HIP CMake can invoke `amdgpu-arch` even for a host-only executable. Preserve SDK
`lib`/`lib/llvm/lib` paths alongside existing `LD_LIBRARY_PATH` when needed.

## Runner protocol and timing contract

The caller launches `workload.py` with standard `--workload full_tensile`,
`--params JSON`, `--case ID`, `--target`, `--warmups`, `--samples`, `--output`.
Set `FULL_TENSILE_ARTIFACTS` to the preparation root and `FULL_TENSILE_RUNNER`
to the native executable. JSON has exactly `schema`, `case`, `target`,
`provider`, `parameters`, `timings_ns`, schema `rocjitsu.benchmark.workload.v1`,
provider `full_tensile`, and positive integer nanosecond samples. Parameters
retain hashes, pin, kernel, solution index, invocation count and timing contract.

Warmups are nonnegative and samples positive caller-provided integers without
an arbitrary upper cap; each must fit a native `int` (2147483647 on supported
builds). Warmup and sample loops are separate to avoid total-count overflow.
Standalone adapters accept even samples; the benchmark runner requires odd
samples. Native dimension bounds remain 1..65536 and fixed recipe shapes remain
unchanged. Large counts remain subject to time and timing-output memory limits.

Before any sample: independently construct host inputs/reference, allocate and
copy A/B/C and device pointer arrays, verify actual target and fixed solution
predicates, load **all** code objects, solve once, and initialize every kernel.
The four selections require zero workspace. Warmups execute the same reset,
whole-solution launch/sync and validation path without collecting a time.

Each measured sample is:

1. Poison D with NaNs and synchronize, **outside** timing. C and D are distinct.
2. Start host steady-clock; enqueue `solution->solve`'s **entire cached invocation
   vector**, then device-synchronize; stop clock.
3. Copy and independently check **every** measured output, outside timing.

Split-K requires exactly two invocations: `Cij_S` beta initialization followed
by GSU3 atomic main, not just a timed main kernel. Others require one invocation.
There is no validation-only device rerun, hidden validation warmup, minimum-flop
loop or adaptive repetition. With 0 warmups/1 sample, the first solution launch
is the single measured solution. Compilation, loading, reset, copy-back and
CPU checking are excluded; host enqueue + synchronization of the whole
solution is included. A failed measured output never produces workload JSON.

## Independent numerical check

`host.hpp` uses mixed-sign integer FP32 inputs with independent i/j/q/l/batch
variation and nonconstant C. A depends periodically on i (period11), B on j
(period13); this permits caching 11x13 dot products **from actual input storage**
per batch, then checking all MxNxBatch outputs including independently varying
beta*C. It is not an all-ones or single-output check, nor another GPU GEMM.

Values satisfy |A|<=5, |B|<=6, |C|<=3. The conservative bound
`K*L*30+3 < 2^24` proves every product and partial sum is an exactly
representable FP32 integer, including any split-K atomic order. Require exact
finite equality; never widen a tolerance to accept a discrepancy. NaN poison
catches missing writes, nonzero C catches missing beta initialization, and
batch/l/reduction variation distinguishes missing or incorrectly indexed work.
This mathematical reference is independent of upstream client validation.

## Host-only verification

```sh
python -m pytest tests/test_benchmark_full_tensile.py -q
# Optional real compile/link test, without executing any HIP binary:
FULL_TENSILE_TEST_SOURCE="$FULL_TENSILE_SOURCE" \
FULL_TENSILE_TEST_SDK="$ROCM_PATH" \
python -m pytest tests/test_benchmark_full_tensile.py -q
```

Normal collection uses repository conftest/xdist. Tests compile and run a
standard-C++ independent brute-force small-storage oracle, exercise full-output
corruption/NaN/missing-beta rejection and reset/timer/launch/validation ordering,
and check workload schema/invalid timing/whole-chain rejection through an
explicitly synthetic protocol subprocess fixture. Fixture timings are **not**
benchmark evidence. The optional test performs a real native compile/link, never
a device probe or workload. Production runtime correctness, actual launch trace
and budgets still require the caller's authorized serial simulator validation.

See [upstream/NOTICE.md](upstream/NOTICE.md) for unchanged vendor files and the
precise derivation of each fixed selection. First-party adapters are MIT.
