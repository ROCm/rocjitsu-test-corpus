# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Real CPU arithmetic checks; no ROCm device or Triton kernels are required."""

import importlib.util
import struct
from pathlib import Path
import sys
from types import SimpleNamespace

import pytest

# Lightweight harness environments can omit Torch; native acceptance installs it.
torch = pytest.importorskip("torch")
from corpus.benchmarks.triton.candidate_reference import (
    assert_candidate_output, candidate_expected, candidate_inputs,
)


def _block_products(a, b, a_scale, b_scale):
    """Independent oracle using actual stored FP8 values and scale indexing."""
    a, b = a.float(), b.float()
    columns = torch.arange(b.shape[0]) // 128
    return [
        (a[:, start:start + 128] @ b[:, start:start + 128].T)
        * a_scale[:, block, None] * b_scale[columns, block][None, :]
        for block, start in enumerate(range(0, a.shape[1], 128))
    ]


@pytest.mark.parametrize("shape", [(1, 1, 1), (9, 11, 129), (7, 5, 4096)])
@pytest.mark.parametrize("group", range(4))
def test_fp16_reference_matches_actual_operands(shape, group):
    a, b = candidate_inputs(*shape, torch.float16, group=group)
    actual = (a.float() @ b.float()).half()
    expected = candidate_expected(*shape, torch.float16, group=group)
    assert_candidate_output(actual, expected)
    assert torch.all(expected > 0)


@pytest.mark.parametrize("k", [65535, 65536, 65537, 131072, 262144])
def test_large_fp16_reduction_stays_finite_and_matches_operands(k):
    # Seven rows/five columns exercise every magnitude in the input pattern.
    a, b = candidate_inputs(7, 5, k, torch.float16)
    actual = (a.float() @ b.float()).half()
    expected = candidate_expected(7, 5, k, torch.float16)
    assert torch.isfinite(actual).all()
    assert torch.isfinite(expected).all()
    assert torch.all(expected > 0)
    assert_candidate_output(actual, expected)
    with pytest.raises(AssertionError, match="output must be finite"):
        assert_candidate_output(torch.full_like(expected, float("inf")), expected)


@pytest.mark.parametrize("value", [float("inf"), float("-inf"), float("nan")])
def test_nonfinite_candidate_reference_is_rejected(value):
    expected = torch.full((1, 1), value, dtype=torch.float16)
    with pytest.raises(AssertionError, match="reference must be finite"):
        assert_candidate_output(expected.clone(), expected)


@pytest.mark.parametrize("value", [float("inf"), float("-inf"), float("nan")])
def test_nonfinite_candidate_output_is_rejected(value):
    expected = torch.ones((1, 1), dtype=torch.float16)
    with pytest.raises(AssertionError, match="output must be finite"):
        assert_candidate_output(torch.full_like(expected, value), expected)


def test_large_fp16_factors_preserve_exact_sequential_accumulation():
    # A wide CPU matmul may use a different reduction tree than the kernel.
    # Exercise sequential FP32 accumulation as well as the GEMM oracle above.
    k = 262144
    a, b = candidate_inputs(7, 5, k, torch.float16)
    products = (a[5].float() * b[:, 3].float()).tolist()
    total = 0.0
    for product in products:
        total = struct.unpack("f", struct.pack("f", total + product))[0]
    expected = candidate_expected(7, 5, k, torch.float16)[5, 3]
    assert_candidate_output(torch.tensor(total, dtype=torch.float16), expected)


@pytest.mark.parametrize("bases", [(0.5, 0.25), (1.0, 1.0)])
@pytest.mark.parametrize("shape", [(1, 1, 1), (7, 257, 513), (7, 5, 18432)])
def test_fp8_reference_matches_actual_operands(shape, bases):
    inputs = candidate_inputs(*shape, torch.float8_e4m3fn, scale_bases=bases)
    actual = sum(_block_products(*inputs)).bfloat16()
    expected = candidate_expected(*shape, torch.bfloat16, scale_bases=bases)
    assert_candidate_output(actual, expected)
    assert torch.all(expected > 0)


@pytest.mark.parametrize("bases", [(0.5, 0.25), (1.0, 1.0)])
def test_every_omitted_w2_reduction_block_is_detected(bases):
    shape = (7, 5, 18432)
    products = _block_products(*candidate_inputs(
        *shape, torch.float8_e4m3fn, scale_bases=bases,
    ))
    full = sum(products)
    expected = candidate_expected(*shape, torch.bfloat16, scale_bases=bases)
    assert_candidate_output(full.bfloat16(), expected)
    assert len(products) == 144
    for block, product in enumerate(products):
        omitted = (full - product).bfloat16()
        assert torch.any(omitted != expected), f"block {block} is undetectable"
        with pytest.raises(AssertionError):
            assert_candidate_output(omitted, expected)


@pytest.mark.parametrize("dtype,bases", [(torch.float16, None), (torch.bfloat16, (0.5, 0.25)), (torch.bfloat16, (1.0, 1.0))])
def test_zero_scalar_output_is_rejected(dtype, bases):
    expected = candidate_expected(1, 1, 1, dtype, scale_bases=bases)
    with pytest.raises(AssertionError):
        assert_candidate_output(torch.zeros_like(expected), expected)


@pytest.mark.parametrize("axis,shift", [(0, 1), (0, 64), (0, 128), (1, 1), (1, 64), (1, 128)])
def test_row_and_column_permutations_are_rejected(axis, shift):
    expected = candidate_expected(137, 257, 512, torch.float16)
    with pytest.raises(AssertionError):
        assert_candidate_output(expected.roll(shift, axis), expected)


def test_group_swap_is_rejected():
    expected = candidate_expected(7, 5, 512, torch.float16, group=0)
    a, b = candidate_inputs(7, 5, 512, torch.float16, group=1)
    with pytest.raises(AssertionError):
        assert_candidate_output((a.float() @ b.float()).half(), expected)


@pytest.mark.parametrize("bases", [(0.5, 0.25), (1.0, 1.0)])
@pytest.mark.parametrize("mutation", ["a_row", "b_column_block", "a_k_block", "b_k_block"])
@pytest.mark.parametrize("shift", [-1, 1])
def test_scale_indexing_mutations_are_rejected(bases, mutation, shift):
    shape = (7, 257, 512)
    a, b, a_scale, b_scale = candidate_inputs(
        *shape, torch.float8_e4m3fn, scale_bases=bases,
    )
    if mutation == "a_row":
        a_scale = a_scale.roll(shift, 0)
    elif mutation == "b_column_block":
        b_scale = b_scale.roll(shift, 0)
    elif mutation == "a_k_block":
        a_scale = a_scale.roll(shift, 1)
    else:
        b_scale = b_scale.roll(shift, 1)
    actual = sum(_block_products(a, b, a_scale, b_scale)).bfloat16()
    expected = candidate_expected(*shape, torch.bfloat16, scale_bases=bases)
    with pytest.raises(AssertionError):
        assert_candidate_output(actual, expected)


@pytest.mark.parametrize("bases", [(0.5, 0.25), (1.0, 1.0)])
@pytest.mark.parametrize("ignored", ["a", "b", "both"])
def test_ignored_scales_are_rejected(bases, ignored):
    shape = (7, 257, 512)
    a, b, a_scale, b_scale = candidate_inputs(
        *shape, torch.float8_e4m3fn, scale_bases=bases,
    )
    if ignored in ("a", "both"):
        a_scale.fill_(1)
    if ignored in ("b", "both"):
        b_scale.fill_(1)
    actual = sum(_block_products(a, b, a_scale, b_scale)).bfloat16()
    expected = candidate_expected(*shape, torch.bfloat16, scale_bases=bases)
    with pytest.raises(AssertionError):
        assert_candidate_output(actual, expected)


def test_checked_launch_poisoning_rejects_stale_and_partial_outputs(monkeypatch):
    # Only CUDA transport is replaced; poisoning and validation use real tensors.
    monkeypatch.setitem(sys.modules, "triton", SimpleNamespace())
    path = Path(__file__).resolve().parents[1] / "corpus/benchmarks/triton/candidates.py"
    spec = importlib.util.spec_from_file_location("real_candidate_checks", path)
    candidates = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(candidates)
    monkeypatch.setattr(candidates, "to_cpu", lambda tensor: tensor)
    events = []
    monkeypatch.setattr(torch.cuda, "synchronize", lambda: events.append("synchronize"))
    expected = candidate_expected(7, 5, 512, torch.float16)
    output = expected.clone()
    write = "all"

    def launch():
        assert torch.isnan(output).all()
        events.append("launch")
        if write == "all":
            output.copy_(expected)
        elif write == "partial":
            output[1:].copy_(expected[1:])

    check = candidates._candidate_check([output], launch, 512)
    check()
    assert events == ["launch", "synchronize"]
    for write in ("none", "partial"):
        output.copy_(expected)  # Simulate a successful earlier warmup/sample.
        with pytest.raises(AssertionError):
            check()
