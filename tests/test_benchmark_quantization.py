# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Adapter parameter validation and shared output reset coverage."""

import pytest

torch = pytest.importorskip("torch")
pytest.importorskip("triton")

from corpus.benchmarks.triton.quantization import validate_quantization_parameters


@pytest.mark.parametrize("workload,dtype", [("deepseek_act_quant", "bf16"), ("deepseek_weight_dequant", "fp8")])
def test_quantization_parameters(workload, dtype):
    params = {"rows": 32768, "columns": 8192, "dtype": dtype}
    assert validate_quantization_parameters(workload, params) == params
    for key, bad in [("rows", True), ("rows", 0), ("columns", -128), ("dtype", "fp32"), ("extra", 1)]:
        with pytest.raises(ValueError):
            validate_quantization_parameters(workload, {**params, key: bad})
    with pytest.raises(ValueError):
        validate_quantization_parameters(workload, {"rows": 128, "dtype": dtype})
    with pytest.raises(ValueError):
        validate_quantization_parameters(workload, None)


def test_activation_rejects_unmasked_partial_block():
    with pytest.raises(ValueError, match="divisible by 128"):
        validate_quantization_parameters("deepseek_act_quant", {"rows": 3, "columns": 127, "dtype": "bf16"})
    assert validate_quantization_parameters("deepseek_weight_dequant", {"rows": 3, "columns": 127, "dtype": "fp8"})


@pytest.mark.parametrize("dtype", [torch.float8_e4m3fn, torch.float16, torch.bfloat16, torch.float32])
def test_shared_output_reset_poison_supports_all_benchmark_dtypes(dtype):
    from benchmarks.measurement import poison_outputs

    output = torch.ones((7, 13), dtype=dtype)
    poison_outputs([output])
    assert torch.isnan(output.float()).all()
    output[1:].copy_(torch.ones((6, 13), dtype=dtype))
    assert torch.isnan(output.float()[0]).all()
    assert torch.isfinite(output.float()[1:]).all()
