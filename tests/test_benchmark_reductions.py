# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Parameter validation for the row reduction adapters."""

import pytest

pytest.importorskip("torch")
pytest.importorskip("triton")

from corpus.benchmarks.triton.reductions import validate_reduction_parameters


@pytest.mark.parametrize("workload", ["triton_softmax", "triton_layernorm"])
def test_validate_parameters(workload):
    parameters = {"rows": 131072, "columns": 2048, "dtype": "fp32"}
    if workload == "triton_layernorm":
        parameters["epsilon"] = 1e-5
    assert validate_reduction_parameters(workload, parameters) == parameters
    assert validate_reduction_parameters(workload, parameters) is not parameters
    for key, value in (("rows", True), ("rows", 0), ("columns", 1.5),
                       ("columns", 16385), ("dtype", "fp16"), ("extra", 1)):
        with pytest.raises(ValueError):
            validate_reduction_parameters(workload, {**parameters, key: value})
    with pytest.raises(ValueError):
        validate_reduction_parameters(workload, [])


@pytest.mark.parametrize("epsilon", [0, -1, float("nan"), float("inf"), True, "1e-5"])
def test_rejects_invalid_epsilon(epsilon):
    with pytest.raises(ValueError, match="epsilon"):
        validate_reduction_parameters("triton_layernorm", {
            "rows": 16, "columns": 64, "dtype": "fp32", "epsilon": epsilon,
        })
