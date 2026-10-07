# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Exercise the real CPU attention reference without allocating full nightly logits."""

import importlib

import pytest

torch = pytest.importorskip("torch")
pytest.importorskip("triton")


@pytest.fixture
def references():
    # Other harness tests deliberately load adapters with mocked Torch imports.
    # Reload this small helper so this suite always exercises real arithmetic.
    helper = importlib.import_module("corpus.benchmarks.triton.attention_reference")
    helper = importlib.reload(helper)
    upstream = importlib.import_module("corpus.benchmarks.third_party.gpt_oss.attention")
    previous_threads = torch.get_num_threads()
    torch.set_num_threads(1)
    yield helper, upstream
    torch.set_num_threads(previous_threads)


def inputs(sequence, *, batches=2, kv_heads=2, groups=3):
    generator = torch.Generator().manual_seed(54)
    shapes = (
        (batches, sequence, kv_heads, groups, 8),
        (batches, sequence, kv_heads, 8),
        (batches, sequence, kv_heads, 8),
        (kv_heads * groups,),
    )
    return tuple(torch.randn(shape, generator=generator).bfloat16() for shape in shapes)


@pytest.mark.parametrize("window", [0, 1, 7, 128])
@pytest.mark.parametrize("sequence,chunk", [(17, 1), (33, 8), (145, 128)])
def test_chunked_matches_full_reference(references, window, sequence, chunk):
    helper, upstream = references
    q, k, v, sinks = inputs(sequence)
    expected = upstream.attention_ref(q, k, v, sinks, sliding_window=window)
    helper.check_attention_reference(
        q, k, v, sinks, expected, sliding_window=window, query_chunk_size=chunk,
    )


def test_checks_every_batch_head_and_final_partial_chunk(references):
    helper, upstream = references
    q, k, v, sinks = inputs(19)
    expected = upstream.attention_ref(q, k, v, sinks, sliding_window=7)
    expected[-1, -1, -1] += 1
    with pytest.raises(AssertionError):
        helper.check_attention_reference(
            q, k, v, sinks, expected, sliding_window=7, query_chunk_size=8,
        )


def test_reference_calls_bound_scratch_and_preserve_absolute_query_offsets(references, monkeypatch):
    helper, upstream = references
    q, k, v, sinks = inputs(145)
    original = upstream.attention_ref
    expected = original(q, k, v, sinks, sliding_window=128)
    calls = []

    def observed(query, key, value, selected_sinks, **kwargs):
        calls.append((query.shape, key.shape, selected_sinks.shape, kwargs["start_q"]))
        return original(query, key, value, selected_sinks, **kwargs)

    monkeypatch.setattr(upstream, "attention_ref", observed)
    helper.check_attention_reference(q, k, v, sinks, expected, sliding_window=128)
    assert len(calls) == 2 * 2 * 2
    assert [call[3] for call in calls] == [0, 128] * 4
    assert all(shape[0] == shape[2] == 1 and shape[1] <= 128 for shape, *_ in calls)
    assert all(shape == (1, 145, 1, 8) for _, shape, _, _ in calls)
    assert all(shape == (3,) for _, _, shape, _ in calls)


def test_nonpositive_chunk_rejected(references):
    helper, _ = references
    q, k, v, sinks = inputs(1)
    with pytest.raises(ValueError, match="positive"):
        helper.check_attention_reference(q, k, v, sinks, None, query_chunk_size=0)
