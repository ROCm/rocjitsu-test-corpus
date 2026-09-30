# DeepSeek-V3 FP8 GEMM

`kernel.py` is an unmodified copy of:
https://github.com/deepseek-ai/DeepSeek-V3/blob/9b4e9788e4a3a731f7567338ed15d3ec549ce03b/inference/kernel.py

The adapter invokes `fp8_gemm_kernel.fn` with a fixed configuration, bypassing
the upstream autotuner. See LICENSE for the upstream MIT license.
