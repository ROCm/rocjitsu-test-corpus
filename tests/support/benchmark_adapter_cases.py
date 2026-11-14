# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Workload/preset pairs exercised by the CPU launch/reset tests (no Torch imports)."""

CASES = [
    ("gpt_oss_attention", None),
    ("triton_softmax", None), ("triton_layernorm", None),
    ("deepseek_act_quant", None), ("deepseek_weight_dequant", None),
    *[(name, preset) for name in ("triton_persistent", "triton_grouped", "deepseek_fp8")
      for preset in (None, "large_tile")],
]
