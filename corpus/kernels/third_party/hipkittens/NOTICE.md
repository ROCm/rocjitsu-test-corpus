# HipKittens Extracted Source

This directory contains sources extracted from `HazyResearch/HipKittens`:

- Upstream repository: https://github.com/HazyResearch/HipKittens
- Main-branch extracted revision: `840c967069139e234ad753304af8a1355e236474`
- CDNA3-branch extracted revision: `5cba0d2fb5d714aa31435de7c0e6dc4b74c237b5`
- License: MIT. See `LICENSE`.

The extracted sources include the HipKittens `include/` tree and selected GEMM
sources:

- `kernels/gemm/mxfp8/MXFP8_4wave/4_wave.cu`
- `kernels/gemm/fp8fp32/FP8_4wave/4_wave.cu`
- `kernels/gemm/bf16fp32/256_256_64_32_with16x32.cpp`
- `kernels/gemm/bf16fp32/gfx1250/`
- `kernels/gemm/bf16fp32/cdna3/8192_256_256_64_16/256_256_64_16.cpp`
- `cdna3/include/`

The MXFP8 and FP8 main-branch sources define launchable HIP kernels, prepare
input data, compute CPU references, launch the GEMM kernels, validate GPU
output, and then run benchmarks. The BF16 sources define launchable HIP kernels
and dispatch helpers; the kernel corpus cases supply standalone host runners and CPU
references. The CDNA3 BF16 source is paired with the CDNA3 branch include tree.
The gfx1250 BF16 ladder sources are paired with the main-branch gfx1250 include
tree.

The corpus applies small local compatibility edits to make `SIZE`, warmup
iterations, and timing iterations overridable by the MXFP8/FP8 case wrappers,
to make the CDNA3 BF16 dimensions overridable without preprocessor pollution,
and to let the BF16 sources compile without their upstream pybind/PyTorch
modules when used by standalone kernel corpus runners.
