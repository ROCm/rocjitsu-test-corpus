# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Bounded CPU references for row reductions; no launch dependencies."""

import torch

REFERENCE_ROWS = 256


def reduction_input(start, stop, columns):
    """Dyadic values whose distribution changes with both row and column."""
    row = torch.arange(start, stop, dtype=torch.int64)[:, None]
    col = torch.arange(columns, dtype=torch.int64)[None, :]
    return (((row * 17 + col * 13 + (row * col) % 127) % 257 - 128).float() / 32)


def reduction_affine(columns):
    col = torch.arange(columns, dtype=torch.int64)
    return 0.5 + (col % 13).float() / 16, ((col % 17) - 8).float() / 32


def reduction_reference(workload, start, stop, columns, epsilon=1e-5):
    x = reduction_input(start, stop, columns).double()
    if workload == "triton_softmax":
        return (torch.softmax(x, dim=1).float(),)
    mean = x.mean(dim=1)
    rstd = torch.rsqrt(((x - mean[:, None]) ** 2).mean(dim=1) + epsilon)
    weight, bias = reduction_affine(columns)
    output = (x - mean[:, None]) * rstd[:, None] * weight.double() + bias.double()
    return output.float(), mean.float(), rstd.float()


def check_reduction_output(workload, outputs, epsilon=1e-5, copy_to_cpu=lambda x: x):
    """Check every output, including LayerNorm statistics, in bounded chunks."""
    rows, columns = outputs[0].shape
    for start in range(0, rows, REFERENCE_ROWS):
        stop = min(start + REFERENCE_ROWS, rows)
        expected = reduction_reference(workload, start, stop, columns, epsilon)
        for actual, reference in zip(outputs, expected, strict=True):
            actual = copy_to_cpu(actual[start:stop])
            if not torch.isfinite(actual).all():
                raise AssertionError("reduction output contains nonfinite or unwritten values")
            # Exp/rsqrt and reduction order differ between CPU and Triton. These
            # FP32 bounds are tight enough to reject a dropped element or row.
            torch.testing.assert_close(
                actual, reference, rtol=2e-5,
                atol=1e-8 if workload == "triton_softmax" else 2e-6,
            )
