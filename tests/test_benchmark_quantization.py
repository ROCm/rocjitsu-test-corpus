# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""CPU regression checks for full-output quantization references."""

import pytest

torch = pytest.importorskip("torch")
pytest.importorskip("triton")

from corpus.benchmarks.triton.quantization import validate_quantization_parameters
from corpus.benchmarks.triton.quantization_reference import (
    activation_expected, activation_input, assert_activation_output,
    assert_weight_output, weight_input, weight_scales,
)


def test_activation_reference_and_zero_clamp():
    value = activation_input(0, 7, 384)
    output, scales = activation_expected(value)
    assert_activation_output(output, scales, value)
    assert torch.count_nonzero(output.float()[0, :128]) == 0
    assert scales[0, 0].item() == pytest.approx(1e-4 / 448, rel=1e-7)
    assert scales.unique().numel() > 3
    assert output.float().min() < 0 < output.float().max()
    # Contiguous chunks regenerate exactly the same input as the whole tensor.
    assert torch.equal(value[3:], activation_input(3, 7, 384))
    blocks = value.float().reshape(7, 3, 128)
    assert torch.all(blocks.abs().amax(-1)[1:] > 0)


@pytest.mark.parametrize("mutation", ["zero", "nan", "wrong_scale", "scale_shift", "block_shift", "element"])
def test_activation_rejects_mutations(mutation):
    value = activation_input(0, 7, 384)
    output, scales = activation_expected(value)
    output = output.float()
    if mutation == "zero":
        output.zero_()
    elif mutation == "nan":
        output[3, 17] = float("nan")
    elif mutation == "wrong_scale":
        scales[3, 1] *= 2
    elif mutation == "scale_shift":
        scales = scales.roll(1, 1)
    elif mutation == "block_shift":
        output = output.roll(128, 1)
    else:
        output[2, 131] += 32
    with pytest.raises(AssertionError):
        assert_activation_output(output.to(torch.float8_e4m3fn), scales, value)


def test_weight_reference_partial_tiles_and_chunks():
    rows, columns = 259, 267
    value = weight_input(0, rows, columns)
    scales = weight_scales(rows, columns)
    expected = value.float() * scales.repeat_interleave(128, 0).repeat_interleave(128, 1)[:rows, :columns]
    assert_weight_output(expected, value, scales, 0)
    assert_weight_output(expected[131:], weight_input(131, rows, columns), scales, 131)
    assert scales.unique().numel() > 3
    assert value.float().min() < 0 < value.float().max()


@pytest.mark.parametrize("mutation", ["zero", "nan", "scale_shift", "tile_shift", "element"])
def test_weight_rejects_mutations(mutation):
    rows, columns = 259, 267
    value = weight_input(0, rows, columns)
    scales = weight_scales(rows, columns)
    expected = value.float() * scales.repeat_interleave(128, 0).repeat_interleave(128, 1)[:rows, :columns]
    if mutation == "zero":
        expected.zero_()
    elif mutation == "nan":
        expected[129, 130] = float("nan")
    elif mutation == "scale_shift":
        scales = scales.roll(1, 1)
    elif mutation == "tile_shift":
        expected = expected.roll(128, 1)
    else:
        expected[258, 266] += 0.25
    with pytest.raises(AssertionError):
        assert_weight_output(expected, value, scales, 0)


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
