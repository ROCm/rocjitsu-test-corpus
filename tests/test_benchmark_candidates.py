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
    for name in ("torch", "triton"):
        monkeypatch.setitem(sys.modules, name, MagicMock())
    measurement_path = Path(__file__).resolve().parents[1] / "benchmarks/measurement.py"
    measurement_spec = importlib.util.spec_from_file_location("candidate_measurement", measurement_path)
    measurement = importlib.util.module_from_spec(measurement_spec)
    measurement_spec.loader.exec_module(measurement)
    measurement.deterministic_tensor = MagicMock()
    monkeypatch.setitem(sys.modules, "benchmarks.measurement", measurement)
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


@pytest.mark.parametrize("workload", ["deepseek_fp8", "triton_grouped", "triton_persistent"])
def test_issue_configuration_is_explicit_and_validated(candidates, workload):
    p = dict(dtype="fp8" if workload == "deepseek_fp8" else "fp16",
             rows=3072, columns=7168, reduction=18432)
    if workload == "triton_grouped":
        p["groups"] = 4
    assert candidates.validate_candidate_parameters(workload, p) == p
    configured = {**p, "configuration": "issue12611"}
    assert candidates.validate_candidate_parameters(workload, configured) == configured
    for invalid in (None, True, 12611, "unknown", {}, []):
        with pytest.raises(ValueError, match="configuration"):
            candidates.validate_candidate_parameters(workload, {**p, "configuration": invalid})


def test_issue_grouped_requires_selected_full_tiles(candidates):
    p = dict(dtype="fp16", rows=128, columns=128, reduction=64, groups=4,
             configuration="issue12611")
    assert candidates.validate_candidate_parameters("triton_grouped", p) == p
    for key, value in (("rows", 64), ("columns", 64), ("reduction", 32)):
        with pytest.raises(ValueError, match="full 128-element tiles"):
            candidates.validate_candidate_parameters("triton_grouped", {**p, key: value})
    default = dict(dtype="fp16", rows=64, columns=64, reduction=64, groups=4)
    assert candidates.validate_candidate_parameters("triton_grouped", default) == default


@pytest.mark.parametrize("configuration,tile,stages", [(None, 64, 1), ("issue12611", 128, 2)])
@pytest.mark.parametrize("workload,module_name,kernel_name", [
    ("triton_persistent", "persistent", "matmul_kernel_persistent"),
    ("triton_grouped", "grouped", "grouped_matmul_kernel"),
])
def test_triton_configuration_reaches_launch(candidates, monkeypatch, configuration, tile,
                                            stages, workload, module_name, kernel_name):
    module = MagicMock()
    monkeypatch.setitem(sys.modules, f"corpus.benchmarks.third_party.triton_candidates.{module_name}", module)
    kernel = getattr(module, kernel_name)
    candidates.triton.cdiv.side_effect = lambda value, block: (value + block - 1) // block
    candidates.torch.cuda.get_device_properties.return_value.multi_processor_count = 100
    candidates.deterministic_tensor.return_value.stride.return_value = (256, 1)
    candidates.torch.empty.return_value.stride.return_value = (256, 1)
    p = dict(dtype="fp16", rows=256, columns=256, reduction=64)
    if workload == "triton_grouped":
        p["groups"] = 4
    if configuration:
        p["configuration"] = configuration
    metadata, launch, _ = candidates.PREPARE_CANDIDATES[workload](p)
    launch.compile()
    kernel.__getitem__.assert_not_called()
    launch()
    expected_grid = (min(100, (256 // tile) ** 2),) if workload == "triton_persistent" else (100,)
    kernel.__getitem__.assert_called_once_with(expected_grid)
    knobs = kernel.__getitem__.return_value.call_args.kwargs
    assert knobs["BLOCK_SIZE_M"] == knobs["BLOCK_SIZE_N"] == tile
    assert knobs["BLOCK_SIZE_K"] == 64
    assert knobs["num_warps"] == 4
    assert knobs["num_stages"] == stages
    assert metadata["launch"]["grid"] == list(expected_grid)
    if workload == "triton_persistent":
        assert knobs["GROUP_SIZE_M"] == 8


@pytest.mark.parametrize("configuration,tile_m,scales", [
    (None, 32, (0.5, 0.25)), ("issue12611", 64, (1.0, 1.0)),
])
def test_deepseek_configuration_reaches_launch_and_validation(candidates, monkeypatch,
                                                             configuration, tile_m, scales):
    module = MagicMock()
    monkeypatch.setitem(sys.modules, "corpus.benchmarks.third_party.deepseek.kernel", module)
    candidates.triton.cdiv.side_effect = lambda value, block: (value + block - 1) // block
    check = MagicMock()
    monkeypatch.setattr(candidates, "_constant_check", check)
    p = dict(dtype="fp8", rows=256, columns=256, reduction=128)
    if configuration:
        p["configuration"] = configuration
    metadata, launch, _ = candidates.prepare_deepseek_fp8(p)
    kernel = module.fp8_gemm_kernel.fn
    launch.compile()
    kernel.__getitem__.assert_not_called()
    launch()
    kernel.__getitem__.assert_called_once_with((256 // tile_m, 4))
    knobs = kernel.__getitem__.return_value.call_args.kwargs
    assert knobs == dict(BLOCK_SIZE_M=tile_m, BLOCK_SIZE_N=64, BLOCK_SIZE_K=128,
                         num_warps=8, num_stages=3)
    assert [call.args[1] for call in candidates.torch.full.call_args_list] == list(scales)
    assert metadata["scale_values"] == list(scales)
    assert check.call_args.kwargs["scales"] == scales[0] * scales[1]
