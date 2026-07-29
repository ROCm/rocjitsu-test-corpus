# gfx1250 Semantic Corpus

This package provides standalone HIP programs for gfx1250 instruction
semantics. It deliberately does not select a simulator, physical device,
runtime hook, binary transformation, or launch environment.

Each program:

- contains one or more source instruction shapes named by `cases.toml`;
- uses deterministic inputs and an independent result oracle;
- exits nonzero when its oracle fails; and
- emits typed `CORPUS_RESULT` records for cross-run comparison.

External workflows decide how to invoke the binaries. The same build can be
run directly, through an arbitrary launcher, or replaced with externally
prepared binaries that retain the test executable names.

## Build

```sh
cmake -S corpus/semantics/gfx1250 \
  -B build/gfx1250-semantics \
  -G Ninja \
  -DHIPCC=/path/to/hipcc
cmake --build build/gfx1250-semantics
cmake --build build/gfx1250-semantics --target check-source-coverage
cmake --build build/gfx1250-semantics \
  --target check-semantic-ds_addtid_test
```

The build produces:

- `bin/`: independently runnable HIP programs;
- `assembly/`: compiler output used to verify the declared source forms.

## Capture a run

`capture_run.py` accepts an arbitrary command prefix and otherwise treats the
launch as opaque:

```sh
python corpus/semantics/gfx1250/scripts/capture_run.py \
  --manifest corpus/semantics/gfx1250/cases.toml \
  --binary-dir build/gfx1250-semantics/bin \
  --label simulator-source \
  --run-wrapper "/path/to/launcher --config /path/to/config.json --" \
  --output runs/simulator-source.json
```

Omit `--run-wrapper` to execute the binaries directly. Use `--test` to select
either a test executable or a stable semantic case ID. Set environment
variables around the command when a launch needs them.

Capture mode records every observable as typed hexadecimal bytes without
rejecting results that differ from the program's built-in oracle. Normal
direct execution and the pytest suite retain the self-checking behavior. Set
`CORPUS_RECORD_ONLY=1` explicitly for a pytest launch whose observations will
be compared separately. This permits an unmodified physical-hardware run to
become a golden even when it exposes a known semantic difference.

An optional `--metadata` JSON object can record the external configuration,
such as compiler revisions, simulator settings, physical-device identity, or
how the binaries were prepared. Metadata is preserved but does not affect
semantic comparison.

## Compare two runs

```sh
python corpus/semantics/gfx1250/scripts/compare_runs.py \
  runs/reference.json runs/candidate.json
```

The reports must use the same target, manifest revision, selected tests, and
typed result records. Labels, metadata, and executable hashes may differ.
Comparison is deliberately exact after record normalization; no numeric
tolerance is applied. Floating-point bytes compare exactly except that `near`
records canonicalize all NaNs before serialization. The `comparison` field
describes the program's built-in oracle and does not otherwise relax cross-run
equality. These fixtures use deterministic inputs so any differing observation
remains visible.
This permits comparisons between:

- two simulator configurations;
- simulator and physical hardware;
- original and externally transformed binaries; or
- a new hardware run and a checked-in golden report.

Tool-specific coverage maps, strict-mode policy, transformation provenance,
post-transformation ISA checks, device selection, and CI launch matrices
belong to the external workflow that invokes this corpus.

## Repository entrypoint

The standard corpus runner builds and executes each program through the
repository-wide `--run-wrapper` option:

```sh
pytest tests/test_corpus.py \
  --target gfx1250 \
  --suite semantics \
  --run-wrapper "/path/to/launcher --config /path/to/config.json --"
```

To compare two launch configurations in one pytest run, add a comparison
wrapper. The reference leg retains its built-in oracle, the comparison leg
runs in record-only mode, and each pytest case compares their validated typed
records exactly:

```sh
pytest tests/test_corpus.py \
  --target gfx1250 \
  --suite semantics \
  --run-wrapper "/path/to/reference-launcher --" \
  --comparison-run-wrapper "/path/to/candidate-launcher --" \
  --comparison-required-stderr "candidate activation record"
```

`--comparison-required-stderr` is optional and repeatable. It lets an external
workflow verify that its candidate launch mechanism was active without making
the corpus aware of that mechanism.
