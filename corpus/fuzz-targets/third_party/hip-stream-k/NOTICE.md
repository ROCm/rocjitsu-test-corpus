# hip-stream-k Extract

Source files in this directory were extracted from the local
`ROCm/hip-stream-k` checkout at `/home/amily/hip-stream-k/main`.

Included files:

- `include/streamk/**`
- `benchmarks/timing.hpp`

The Stream-K case runners under `../../cases/hip-stream-k/` were copied from
the upstream `examples/simple_streamk.cpp` and `examples/two_tile_streamk.cpp`
files.

The extracted `include/streamk/utils/parameters.hpp` was adapted to remove the
repository's external `cxxopts` fetch dependency while preserving the example
command-line flags.

The extracted Stream-K kernels were adapted to remove the upstream cooperative
rocWMMA dependency. `include/streamk/utils/mfma.hpp` provides the small fragment
and layout surface these runners need and calls clang's AMDGCN MFMA builtins
directly.
