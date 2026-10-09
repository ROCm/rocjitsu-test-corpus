# DeepSeek-V3 FP8 kernels

`kernel.py` is an unmodified copy of:
https://github.com/deepseek-ai/DeepSeek-V3/blob/9b4e9788e4a3a731f7567338ed15d3ec549ce03b/inference/kernel.py

The benchmark adapters invoke these entrypoints directly:

- `fp8_gemm_kernel.fn`: fixed GEMM configurations, bypassing the upstream
  autotuner. The default tile is 32 × 64 × 128; `large_tile` uses 64 × 64 × 128.
  Both use eight warps and three stages.
- `act_quant_kernel`: BF16-to-FP8 activation quantization with 128-element blocks,
  four warps, and `scale_fmt=None`.
- `weight_dequant_kernel`: FP8-to-FP32 weight dequantization with 128 × 128 tiles
  and four warps.

The conversion adapters use the pinned Triton version's default stage count.
See LICENSE for the upstream MIT license.
