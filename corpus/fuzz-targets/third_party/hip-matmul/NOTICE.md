# nod-ai hip-matmul Extracted Source

This directory contains sources extracted from `nod-ai/hip-matmul`:

- Upstream repository: https://github.com/nod-ai/hip-matmul
- Extracted revision: `f932f783976342b397b255361f158bbc7c7a7ea3`
- License: Apache License 2.0; source files carry
  `Apache-2.0 WITH LLVM-exception` SPDX identifiers.

The extracted HIP sources provide self-contained executable runners. The
`matmul.hip` and `matvec.hip` programs allocate inputs, launch the upstream
`__global__` kernels, validate results, and benchmark the kernels.
