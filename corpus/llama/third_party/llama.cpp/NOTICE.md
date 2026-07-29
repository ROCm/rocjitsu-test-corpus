# llama.cpp Extracted Sources

This directory contains the sources extracted from `llama.cpp` to build the
`test-backend-ops` backend operator harness used by the `llama` suite.

- Upstream repository: https://github.com/ggml-org/llama.cpp
- Source commit: `c588c4f47683e73ad2d69f50480bec6cc85fd0f7`
- Extracted subtrees: `ggml/` and `tests/test-backend-ops.cpp`
- License: MIT, see `LICENSE`

`ggml/src` keeps only the backends `test-backend-ops` needs on ROCm targets:
the shared GGML core, `ggml-cpu` for the reference implementation, and
`ggml-cuda`/`ggml-hip` for the device implementation under test. The remaining
upstream backends are omitted because the suite never enables them.

The extracted sources retain their upstream file contents and copyright
notices. The MIT license allows use, copy, modification, merge, publication,
distribution, sublicensing, and sale of copies, provided the copyright notice
and permission notice are included in all copies or substantial portions of the
software.
