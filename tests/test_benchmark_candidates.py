# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Validate candidate constraints without requiring a ROCm installation."""
import importlib.util
import sys
from pathlib import Path
from unittest.mock import MagicMock

import pytest


@pytest.fixture
def candidates(monkeypatch):
    for name in ("torch", "triton", "benchmarks.measurement"):
        monkeypatch.setitem(sys.modules, name, MagicMock())
    path = Path(__file__).resolve().parents[1] / "corpus/benchmarks/triton/candidates.py"
    spec = importlib.util.spec_from_file_location("candidates_under_test", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_grouped_requires_full_tiles(candidates):
    p = dict(dtype="fp16", rows=2048, columns=2048, reduction=2048, groups=4)
    assert candidates.validate_candidate_parameters("triton_grouped", p) == p
    for key in ("rows", "columns", "reduction"):
        with pytest.raises(ValueError, match="full 64-element tiles"):
            candidates.validate_candidate_parameters("triton_grouped", {**p, key: 65})


def test_candidate_rejects_invalid_launch_inputs(candidates):
    p = dict(dtype="fp8", rows=512, columns=18432, reduction=7168)
    assert candidates.validate_candidate_parameters("deepseek_fp8", p) == p
    for invalid in ({**p, "dtype": "fp16"}, {**p, "rows": True}, {**p, "reduction": 0}, {**p, "num_warps": 4}):
        with pytest.raises(ValueError):
            candidates.validate_candidate_parameters("deepseek_fp8", invalid)
