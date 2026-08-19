# Vendored TensileLite corpus harness

This directory contains the TensileLite components needed to generate portable
AMDGPU kernel-candidate bundles from a tuning YAML and validate those candidates
against the TensileLite CPU reference. Validation executes no performance
benchmark iterations.

The sources were copied from `rocm-libraries` commit
`75978ca0061ac014dc2496bd3a9ff53d71c3ac56`.

## Harness scripts

- `setup.sh` checks the Python and ROCm SDK environment.
- `generate-kernels.sh` generates kernels and extracts a candidate bundle.
- `build-client.sh` builds the correctness-validation client.
- `validate-kernels.sh` validates every case in an extracted bundle.

All scripts are executable Bash entry points.

## Requirements

- Linux and Python 3.12+. The ROCm SDK's `_rocisa.abi3.so` requires Python 3.12+.
- `PyYAML`, `joblib>=1.4.0`, and `packaging` from `requirements.txt`.
- The `rocm-sdk-devel` toolchain, including `amdclang++`,
  `clang-offload-bundler`, HIP headers, and compiled `rocisa`.
- CMake, Ninja, OpenMP, and zlib development files to build the client.

Activate a compatible environment and check it from this directory:

```bash
./setup.sh
```

`setup.sh` does not install packages or copy native libraries.

## Generate a candidate bundle

Pass a tuning YAML, a new output directory, and any Tensile options:

```bash
./generate-kernels.sh \
  examples/small-gemm.yaml \
  candidates/small-gemm \
  --gpu-targets gfx1250
```

The output directory must not already exist. Generation runs TensileLite in
build-only mode with temporary assembly retention enabled, then generates the
client configurations through its CPU-only path. Caller-provided
`--global-parameters` are preserved, except that the harness-required retention
and correctness controls take precedence. It does not launch a GPU client or
run benchmarks.

The extracted bundle is organized by GEMM, benchmark step, and Tensile cache:

```text
candidates/small-gemm/
├── input.yaml
├── manifest.tsv
└── gemms/
    └── <gemm>/<step>/<cache>/
        ├── ClientParameters.ini
        ├── cache.yaml
        ├── solutions.yaml
        ├── assembly/
        │   ├── <kernel>.s
        │   └── <kernel>.o
        └── library/<architecture>/
            ├── TensileLibrary.yaml
            ├── TensileLibrary_<architecture>.co
            └── *.hsaco
```

`ClientParameters.ini` contains only bundle-relative paths, so the candidate
directory can be moved before validation. Each client case points to its own
library and code object.

The YAML input uses Tensile's normal `GlobalParameters` and `BenchmarkProblems`
sections. Each `BenchmarkProblems` entry describes a problem type, candidate
solution parameters, and problem sizes.

`examples/gfx1250-workloads.yaml` is a shape-first BF16 correctness suite
designed independently of the upstream Tensile test YAMLs. It contains 183
distinct exact shapes and applies them to all four transpose combinations,
for 732 layout-by-shape workloads. Every M, N, and K is below 2048, and each
workload is capped at 8,388,608 multiply-accumulates including batch so that
RocJitsu CPU simulation remains bounded. Its single baseline solution per
layout intentionally keeps workload coverage separate from candidate-space
coverage.

## Validate an extracted bundle

Build the client once:

```bash
./build-client.sh
```

To check that every extracted case is complete and configured for full
CPU-reference comparison without launching a GPU client:

```bash
./validate-kernels.sh --cpu-only candidates/small-gemm
```

This CPU-only mode is a readiness check; it does not claim numerical kernel
correctness without executing the candidate on a GPU.

On a machine with a compatible GPU, run the numerical validation:

```bash
./validate-kernels.sh candidates/small-gemm
```

The validator recursively discovers every `ClientParameters.ini`, executes the
corresponding candidate once, and compares every output element with the CPU
reference. The generated configuration uses zero warmups and zero benchmark
timing syncs; the reference validator itself requests the single kernel run
needed for correctness. A mismatch causes a nonzero exit.

## Vendored scope

- `Tensile/` contains the Python generator and static kernel headers.
- `rocisa/__init__.py` loads the compiled ROCm SDK `rocisa` extension.
- `include/`, `src/`, and `client/` provide the validation client.
- `third_party/` contains the matching origami and MX data-generation sources.

The upstream `Tensile/Tests`, `Tensile/CustomKernels`, and `Tensile/ductile`
directories are intentionally omitted. Custom-kernel YAMLs and the Ductile
optimization backend are not supported by this minimal copy.
