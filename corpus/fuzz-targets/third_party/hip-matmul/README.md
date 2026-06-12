# Toying with matmuls in HIP

Trying to put together a self-contained testbed for data-tiled matmul kernels
using MFMA intrinsics.

To build and test, just run this script,

```
./build_and_test.sh
```

but it's really just a single `hipcc` command line to build, and then runs the
resulting executable.

## ROCfuzz Local Changes

This directory is based on the extracted upstream `hip-matmul` testbed. ROCfuzz
keeps the upstream sources mostly intact, with the following local changes to
make corpus cases configurable from case metadata:

- `common.hip` adds shared command-line parsing for `-m`/`--m`,
  `-n`/`--n`, and `-k`/`--k`. Parsed values are written to the existing `M`,
  `N`, and `K` environment variables and marked with
  `ROCFUZZ_HIP_MATMUL_HAS_MNK_ARGS`.
- `matvec.hip` uses those parsed dimensions when explicit M/N/K arguments are
  provided. Without explicit arguments, it still runs the original upstream
  benchmark shape list.
