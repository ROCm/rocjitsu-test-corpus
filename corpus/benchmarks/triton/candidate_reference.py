# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Positive dyadic candidate inputs and linear-time CPU references.

Factors vary by row, column, group, and 128-element reduction block. They are
exactly representable in FP16 and E4M3FN. No positive reduction range cancels.
The scheduled shapes accumulate exactly in FP32; only the output cast rounds.
"""

import torch


def _factors(m, n, k, group, *, fp16):
    rows = (8 + (torch.arange(m) + group) % 7).double() / 16
    columns = (8 + (torch.arange(n) + 2 * group) % 5).double() / 16
    if fp16 and k > 65536:
        # Larger reductions need both a finite FP16 result and more FP32
        # accumulation headroom. Power-of-two free-axis factors avoid the
        # growing odd mantissas of the small-K pattern. Scale A so that the
        # largest rounded output stays <= 49152 without changing dimensions.
        shift = (k - 1).bit_length() - 16
        rows = 2.0 ** (-1 - shift - (torch.arange(m) + group) % 7).double()
        columns = 2.0 ** (-((torch.arange(n) + 2 * group) % 5)).double()
    blocks = torch.arange((k + 127) // 128)
    reduction = torch.where((blocks % 4 == 1) | (blocks % 4 == 2), 2, 1).double()
    return rows, columns, blocks, reduction


def candidate_inputs(m, n, k, dtype, *, group=0, scale_bases=None):
    """Return contiguous CPU operands; scaled B uses DeepSeek's N-by-K layout."""
    rows, columns, blocks, reduction = _factors(m, n, k, group, fp16=scale_bases is None)
    a = (rows[:, None] * reduction.repeat_interleave(128)[:k]).to(dtype)
    if scale_bases is None:
        b = columns[None, :].expand(k, n).to(dtype).contiguous()
        return a, b
    b = columns[:, None].expand(n, k).to(dtype).contiguous()
    scale_a, scale_b = scale_bases
    a_scale = (
        scale_a * 2.0 ** (torch.arange(m) % 3)[:, None]
        * 2.0 ** (blocks % 2)[None, :]
    ).float()
    b_scale = (
        scale_b * 2.0 ** (torch.arange((n + 127) // 128) % 3)[:, None]
        * 2.0 ** ((blocks // 2) % 2)[None, :]
    ).float()
    return a, b, a_scale, b_scale


def candidate_expected(m, n, k, dtype, *, group=0, scale_bases=None):
    """Compute the separable reference, then round once to the output dtype."""
    rows, columns, blocks, reduction = _factors(m, n, k, group, fp16=scale_bases is None)
    lengths = (k - blocks * 128).clamp(max=128).double()
    if scale_bases is not None:
        scale_a, scale_b = scale_bases
        rows *= scale_a * 2.0 ** (torch.arange(m) % 3)
        columns *= scale_b * 2.0 ** ((torch.arange(n) // 128) % 3)
        reduction *= 2.0 ** (blocks % 2) * 2.0 ** ((blocks // 2) % 2)
    return (rows[:, None] * columns[None, :] * (lengths * reduction).sum()).to(dtype)


def assert_candidate_output(actual, expected):
    # Exact comparison catches small omissions hidden by a blanket 1% tolerance.
    # NaNs in an unwritten output are never accepted, even if expected is zero.
    if not torch.isfinite(expected).all():
        raise AssertionError("candidate reference must be finite")
    if not torch.isfinite(actual).all():
        raise AssertionError("candidate output must be finite")
    torch.testing.assert_close(actual, expected, rtol=0, atol=0, equal_nan=False)
