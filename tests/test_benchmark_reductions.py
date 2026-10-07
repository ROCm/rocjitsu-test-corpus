# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""CPU reference and mutation coverage for the row reduction benchmarks."""

import pytest

torch = pytest.importorskip("torch")
pytest.importorskip("triton")

from corpus.benchmarks.triton.reductions import (
    check_reduction_output,
    reduction_affine,
    reduction_input,
    reduction_reference,
    validate_reduction_parameters,
)


@pytest.mark.parametrize("workload", ["triton_softmax", "triton_layernorm"])
def test_reference_matches_independent_torch_operator(workload):
    x = reduction_input(0, 11, 63)
    if workload == "triton_softmax":
        expected = torch.softmax(x, dim=1)
    else:
        w, b = reduction_affine(63)
        expected = torch.nn.functional.layer_norm(x, (63,), w, b, 1e-5)
    outputs = reduction_reference(workload, 0, 11, 63)
    torch.testing.assert_close(outputs[0], expected, rtol=2e-5, atol=2e-6)
    check_reduction_output(workload, outputs)


@pytest.mark.parametrize("workload", ["triton_softmax", "triton_layernorm"])
def test_reference_chunk_offsets_and_complete_output_check(workload):
    outputs = reduction_reference(workload, 0, 519, 65)
    check_reduction_output(workload, outputs)
    for start, stop in ((0, 256), (256, 512), (512, 519)):
        chunk = reduction_reference(workload, start, stop, 65)
        for actual, expected in zip(outputs, chunk, strict=True):
            assert torch.equal(actual[start:stop], expected)
    # Last row in the final partial chunk must be checked too.
    outputs[0][-1, -1] = float("nan")
    with pytest.raises(AssertionError, match="nonfinite"):
        check_reduction_output(workload, outputs)


@pytest.mark.parametrize("workload", ["triton_softmax", "triton_layernorm"])
@pytest.mark.parametrize("mutation", ["zero", "constant", "row_permutation", "column_permutation", "incomplete", "inf"])
def test_rejects_incorrect_output(workload, mutation):
    outputs = list(reduction_reference(workload, 0, 19, 257))
    y = outputs[0]
    if mutation == "zero":
        y.zero_()
    elif mutation == "constant":
        y.fill_(1 / y.shape[1])
    elif mutation == "row_permutation":
        outputs[0] = y.roll(1, dims=0)
    elif mutation == "column_permutation":
        outputs[0] = y.roll(1, dims=1)
    elif mutation == "incomplete":
        y[-1, -1] = float("nan")
    else:
        y[-1, -1] = float("inf")
    with pytest.raises(AssertionError):
        check_reduction_output(workload, outputs)


def test_rejects_ignored_layernorm_affine_and_statistics():
    outputs = list(reduction_reference("triton_layernorm", 0, 19, 257))
    x = reduction_input(0, 19, 257)
    outputs[0] = torch.nn.functional.layer_norm(x, (257,))
    with pytest.raises(AssertionError):
        check_reduction_output("triton_layernorm", outputs)
    for index in (1, 2):
        outputs = list(reduction_reference("triton_layernorm", 0, 19, 257))
        outputs[index][-1] = float("nan")
        with pytest.raises(AssertionError):
            check_reduction_output("triton_layernorm", outputs)


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
