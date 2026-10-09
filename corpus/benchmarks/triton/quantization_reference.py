# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Bounded CPU inputs and references for pinned DeepSeek conversion kernels."""

import torch

BLOCK = 128
CHUNK_ROWS = 128


def activation_input(start, stop, columns):
    row = torch.arange(start, stop, dtype=torch.int64)[:, None]
    col = torch.arange(columns, dtype=torch.int64)[None, :]
    # Each nonzero block has max(abs(x)) == 7 * 2**exponent. Its scale is
    # exactly representable, and division yields exact FP32 values including
    # FP8 rounding ties. Row/block variation catches misplaced scale stores.
    exponent = (row * 3 + col // BLOCK * 5) % 7 - 3
    values = ((col % BLOCK + row * 17) % 113 - 56).float() / 8
    values = values * torch.pow(2.0, exponent)
    values[(row == 0) & (col < BLOCK)] = 0
    return values.to(torch.bfloat16)


def activation_expected(value):
    blocks = value.float().reshape(value.shape[0], -1, BLOCK)
    scales = blocks.abs().amax(dim=-1).clamp_min(1e-4) / 448.0
    output = (blocks / scales[..., None]).reshape(value.shape).to(torch.float8_e4m3fn)
    return output, scales


def assert_activation_output(actual, actual_scales, value):
    expected, scales = activation_expected(value)
    if not torch.isfinite(actual.float()).all() or not torch.isfinite(actual_scales).all():
        raise AssertionError("activation quantization produced nonfinite values")
    torch.testing.assert_close(actual_scales, scales, rtol=2e-7, atol=0)
    # The chosen inputs have exactly representable nonzero scales and division
    # results. This checks FP8 round-to-nearest-even, not a loose error envelope.
    torch.testing.assert_close(actual.float(), expected.float(), rtol=0, atol=0)


def weight_input(start, stop, columns):
    row = torch.arange(start, stop, dtype=torch.int64)[:, None]
    col = torch.arange(columns, dtype=torch.int64)[None, :]
    values = ((row * 13 + col * 7 + row // BLOCK * 3 + col // BLOCK) % 57 - 28).float() / 4
    return values.to(torch.float8_e4m3fn)


def weight_scales(rows, columns):
    row = torch.arange((rows + BLOCK - 1) // BLOCK)[:, None]
    col = torch.arange((columns + BLOCK - 1) // BLOCK)[None, :]
    return torch.pow(2.0, (row * 3 + col * 5) % 11 - 5).float()


def assert_weight_output(actual, value, scales, start):
    row = torch.arange(start, start + value.shape[0]) // BLOCK
    col = torch.arange(value.shape[1]) // BLOCK
    expected = value.float() * scales[row[:, None], col[None, :]]
    if not torch.isfinite(actual).all():
        raise AssertionError("weight dequantization produced nonfinite values")
    torch.testing.assert_close(actual, expected, rtol=0, atol=0)
