# HipKittens Extracted Source

This directory contains sources extracted from `HazyResearch/HipKittens`:

- Upstream repository: https://github.com/HazyResearch/HipKittens
- Main-branch extracted revision: `cd090ae98ee4e7b8d3d5291fc62cfd716aecb946`
- CDNA3-branch extracted revision: `fbec871cc606f1b5a167f93d17eb7189fa9de0ff`
- License: MIT. See `LICENSE`.

The extracted sources include the HipKittens `include/` tree and selected GEMM
sources:

- `kernels/gemm/mxfp8/MXFP8_4wave/4_wave.cu`
- `kernels/gemm/fp8fp32/FP8_4wave/4_wave.cu`
- `kernels/gemm/bf16fp32/256_256_64_32_with16x32.cpp`
- `kernels/gemm/bf16fp32/mi325x/8192_256_256_64_16/256_256_64_16.cpp`
- `cdna3/include/`

The MXFP8 and FP8 main-branch sources define launchable HIP kernels, prepare
input data, compute CPU references, launch the GEMM kernels, validate GPU
output, and then run benchmarks. The BF16 sources define launchable HIP kernels
and dispatch helpers; the ROCfuzz cases supply standalone host runners and CPU
references. The CDNA3 BF16 source is paired with the CDNA3 branch include tree.

The corpus applies small local compatibility edits to make `SIZE`, warmup
iterations, and timing iterations overridable by the MXFP8/FP8 case wrappers,
to make the CDNA3 BF16 dimensions overridable without preprocessor pollution,
and to let the BF16 sources compile without their upstream pybind/PyTorch
modules when used by standalone ROCfuzz runners.
