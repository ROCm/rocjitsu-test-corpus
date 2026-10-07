# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Bound the CPU attention reference's temporary matrices by query chunks."""

import torch


def check_attention_reference(
    query, key, value, sinks, actual, *, sm_scale=0.125, sliding_window=0,
    query_chunk_size=128,
):
    """Compare CPU outputs in [batch, query, heads * dimension] layout.

    Keep all keys for the upstream reference's causal/window masking, but only
    one batch, one KV head, and a bounded number of queries live at a time.
    """
    from corpus.benchmarks.third_party.gpt_oss.attention import attention_ref

    if query_chunk_size <= 0:
        raise ValueError("query_chunk_size must be positive")
    batches, queries, kv_heads, groups, dimension = query.shape
    for batch in range(batches):
        for head in range(kv_heads):
            first_head = head * groups
            last_head = first_head + groups
            for start in range(0, queries, query_chunk_size):
                end = min(start + query_chunk_size, queries)
                expected = attention_ref(
                    query[batch:batch + 1, start:end, head:head + 1],
                    key[batch:batch + 1, :, head:head + 1],
                    value[batch:batch + 1, :, head:head + 1],
                    sinks[first_head:last_head],
                    sm_scale=sm_scale,
                    sliding_window=sliding_window,
                    start_q=start,
                )
                observed = actual[
                    batch:batch + 1, start:end,
                    first_head * dimension:last_head * dimension,
                ]
                torch.testing.assert_close(observed, expected)
