# Guitar Hero

The goal is very high simulator execution coverage, targeting 90–95%, from one
standalone assembly kernel per variant and a small HIP launch harness. Every
workgroup has 64 work-items and owns its memory; workgroups never depend on
another workgroup or CU. The code has no simulator dependency and also runs on
matching hardware.

This version provides execution and performance smokes. It ships no saved
expected outputs and does not establish ISA correctness. The harness checks HIP
errors and compares every workgroup's checkpoint words with group zero in the
same launch. With one workgroup, success means the launch and output copy
completed. Identical incorrect results across all groups are not detected.

## Variants

| Case / executable | Target | Wave size | Checkpoints |
| --- | --- | ---: | ---: |
| [guitar_hero](guitar_hero_rdna4/guitar_hero_wave32/) | gfx1201 | 32 | 650 |
| [guitar_hero_wave64](guitar_hero_rdna4/guitar_hero_wave64/) | gfx1201 | 64 | 650 |
| [guitar_hero_rdna3](guitar_hero_rdna3/) | gfx1100 | 32 | 642 |

Each case contains a manifest, checkpoint names and a small runner configuration.
All runners use [runner.hpp](runner.hpp). The RDNA4 entries share
[guitar_hero_rdna4.s](guitar_hero_rdna4/guitar_hero_rdna4.s) and one code object,
assembled separately in each strict wave mode to retain operand validation.
Other targets maintain independent assembly. Building requires no source
generator. [ISA-NOTES.md](ISA-NOTES.md) describes target differences and limits.

## Build and run

From the repository root, use a TheRock SDK environment and select a case and
matching target from the table:

```sh
gh_target=gfx1201
gh_case=guitar_hero
cmake -S corpus/kernels -B build/guitar-hero -G Ninja \
  -DCMAKE_C_COMPILER="$ROCM_PATH/lib/llvm/bin/amdclang" \
  -DCMAKE_CXX_COMPILER="$ROCM_PATH/lib/llvm/bin/amdclang++" \
  -DROCM_PATH="$ROCM_PATH" -DCMAKE_HIP_ARCHITECTURES="$gh_target" \
  -DKERNEL_CORPUS_ENABLE_ALL=OFF -DKERNEL_CORPUS_ENABLE_GUITAR_HERO=ON
cmake --build build/guitar-hero --target "$gh_case"
gh_exe="$PWD/build/guitar-hero/cases/guitar-hero/$gh_case"
"$gh_exe" --groups 7
```

Keep the executable and code object together. RDNA4 uses
`guitar_hero_rdna4.hsaco`; other code objects use the case name.
`--code-object PATH` overrides the location. `--help` lists the launch controls.
The harness selects a visible device of the requested architecture; external
tooling selects hardware or simulation.

The normal corpus adapter registers one-group and seven-group smokes. Both run
in the same pytest session, sharing the executable while preserving their own
launch arguments, inputs and log directories:

```sh
python -m pytest tests/test_corpus.py --target "$gh_target" --suite kernels --case "$gh_case"
```

Host-only checks of checkpoint layout, output stride, manifest discovery and
cached runtime dispatch run separately, without a GPU or compiled kernel:

```sh
python -m pytest tests/test_guitar_hero_contracts.py tests/test_kernels_discovery.py tests/test_kernels_suite.py -q
```

## Checkpoints and diagnosis

Each checkpoint folds sixteen result words per work-item into two rolling
32-bit lane hashes. `checkpoints.inc` is the ordered name/count table compiled
into the harness: it determines output allocation, labels and checkpoint indices.
It contains no expected results. Host contracts check that its count and the
assembly's checkpoint IDs and per-group output stride agree.

The group comparison uses the lane hash words directly. A mismatch reports the
seed, workgroup and first checkpoint differing from group zero. Later hashes
retain earlier history. All three fixed seeds run by default. For external
comparison, `--dump-digests` folds group zero's 64 lanes in order into two 64-bit
words and prints one row per seed/checkpoint. These are diagnostic values;
hash collisions are possible and no captured file is treated as an oracle.

```sh
"$gh_exe" --dump-digests > run.digests
"$gh_exe" --seed-index 0 --dump-checkpoint 11
"$gh_exe" --stop-after-checkpoint 11
```

Raw dumps contain v16–v31 for each work-item and require one workgroup. A dump
may be combined with a stop at or after its checkpoint. Stopping exercises only
a prefix. A one-group rerun may not reproduce a scheduling-dependent failure.
Hardware and simulator digests can differ; resolving those differences is
separate from this smoke workload.

## Execution scope

Sweeps cover target-supported integer, floating and packed arithmetic;
modifiers and rounding/denormal policies; compact and extended encodings;
DPP8/DPP16, lane access and reductions; memory and atomics; and matrix operations.
Boundary checkpoints select negative conversion inputs, signed overflow and carry,
NaNs, signed zeros, packed subnormals, nonzero scalar-relative offsets and FFT/rotate
cross-lane controls. Full and alternating EXEC masks preserve inactive sentinels.
These inputs exercise paths that mnemonic presence alone does not establish.

Distinct encodings exercise the decoder; byte-identical aliases add no decoder
behavior. Rejected encodings are not inserted as raw instruction words.

Ordinary arithmetic regions retain EXEC through input setup, operations and
result folding. Their 5–8 iterations hash seed, region and iteration into mixed,
sparse, singleton, dense, empty and all-but-one masks, with no adjacent repeats.
Wave64 independently mixes its two mask halves. A full first iteration initializes
lanes. Other divergent loops have dynamic bounds capped at sixteen. Scalar
counters advance with empty EXEC; collective and memory boundaries reconverge.

Active results fold before reconvergence. Ordinary ALU inputs repeat, so an
incorrect inactive write repeating an earlier result can remain invisible.
Sentinel, half-register, DPP, control and memory probes feed checkpoints, but
measured EXEC exposure is not exhaustive correctness checking. Every group owns
4 KiB of workspace and LDS; scratch requirements are in the ISA notes.

Graphics/image paths, cross-workgroup protocols, traps, timing-dependent results,
and every operand combination are outside this compute smoke. Assembler
acceptance and simulator agreement do not establish physical scheduling correctness.

## Performance smoke

```sh
"$gh_exe" --groups 256 --iterations 20
```

HIP events report mean launch time per seed, including checkpoint work and launch
gaps. Allocation and host comparisons are outside the interval. Only the final
iteration's output is compared; there is no performance pass threshold. Compare
the same binary, seeds, grid, repetitions and environment across repeated samples,
accounting for warmup. This is not peak arithmetic throughput.
