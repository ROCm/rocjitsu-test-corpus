# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
from __future__ import annotations

import contextlib
import importlib.util
import json
import sys
import tomllib
import types
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import ANY, MagicMock, patch

import pytest

ROOT = Path(__file__).resolve().parents[1]
GPT_PARAMS = dict(
    dtype="bf16",
    batch=1,
    query_heads=64,
    key_value_heads=8,
    sequence=128,
    window=128,
    head_dimension=64,
)
WORKLOAD = ROOT / "corpus/benchmarks/triton/workloads.py"


@pytest.fixture
def workloads_context(monkeypatch):
    # Fake GPU dependencies keep harness tests runnable without ROCm or Triton.
    ctx = SimpleNamespace(
        torch=MagicMock(), descriptor=MagicMock(), attention=MagicMock()
    )
    triton = types.ModuleType("triton")
    triton.jit = lambda function: function
    triton.cdiv = lambda a, b: (a + b - 1) // b
    triton.next_power_of_2 = lambda x: 1 << (x - 1).bit_length()
    triton.language = types.ModuleType("triton.language")
    dependencies = {
        "torch": ctx.torch,
        "triton": triton,
        "triton.language": triton.language,
        "triton.tools.tensor_descriptor": SimpleNamespace(
            TensorDescriptor=ctx.descriptor
        ),
        "corpus.benchmarks.third_party.gpt_oss.attention": SimpleNamespace(
            _attn_fwd=ctx.attention, attention_ref=MagicMock()
        ),
    }
    for name, module in dependencies.items():
        monkeypatch.setitem(sys.modules, name, module)
    ctx.measurement = load_module(
        "measurement_under_test", ROOT / "benchmarks/measurement.py"
    )
    monkeypatch.setitem(sys.modules, "benchmarks.measurement", ctx.measurement)
    ctx.workload = load_module("upstream_under_test", WORKLOAD)
    return ctx


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_nightly_parameters_are_valid(workloads_context):
    suite = tomllib.loads((ROOT / "benchmarks/suites/nightly.toml").read_text())
    for case in suite["cases"]:
        workloads_context.workload.validate_parameters(case["workload"], case["params"])


def test_reference_copies_use_registered_host_memory(workloads_context):
    tensor = MagicMock()
    host = workloads_context.workload.to_cpu(tensor)
    workloads_context.torch.empty.assert_called_once_with(
        tensor.shape, dtype=tensor.dtype, device="cpu", pin_memory=True
    )
    host.copy_.assert_called_once_with(tensor)
    tensor.cpu.assert_not_called()


def test_attention_prepares_buffers_and_descriptors_only_once(workloads_context):
    parameters, launch, check = workloads_context.workload.prepare(
        "gpt_oss_attention", GPT_PARAMS
    )
    workloads_context.attention.__getitem__.assert_not_called()
    assert workloads_context.descriptor.from_tensor.call_count == 4
    assert workloads_context.torch.full.call_count == 4
    allocations = list(workloads_context.torch.mock_calls)
    descriptors = list(workloads_context.descriptor.mock_calls)
    launch()
    launch()
    assert workloads_context.torch.mock_calls == allocations
    assert workloads_context.descriptor.mock_calls == descriptors
    assert workloads_context.attention.__getitem__.return_value.call_count == 2
    assert parameters["measurement_scope"] == "kernel_launch_and_synchronize"
    assert callable(check)


def test_invalid_parameters_fail_before_allocation(workloads_context):
    for change in (
        {"dtype": "fp32"},
        {"batch": 0},
        {"sequence": 65},
        {"head_dimension": 32},
        {"query_heads": 7},
        {"window": 1},
        {"window": -64},
        {"batch": True},
        {"unknown": 1},
    ):
        with pytest.raises(ValueError):
            workloads_context.workload.prepare("gpt_oss_attention", GPT_PARAMS | change)
    workloads_context.torch.full.assert_not_called()
    workloads_context.torch.empty.assert_not_called()


def test_copy_parameters_control_allocations_and_bytes(workloads_context):
    for dtype, size in (("fp16", 17), ("bf16", 1031), ("fp32", 7)):
        parameters, _, _ = workloads_context.workload.prepare(
            "copy", dict(dtype=dtype, elements=size)
        )
        workloads_context.torch.full.assert_called_with(
            (size,), ANY, device="cuda", dtype=workloads_context.workload.DTYPES[dtype]
        )
        assert parameters["bytes"] == size * (4 if dtype == "fp32" else 2)


def test_gather_wraps_arbitrary_source_size(workloads_context):
    workloads_context.workload.prepare(
        "gather",
        dict(
            dtype="bf16",
            source_elements=37,
            output_elements=51,
            index_stride=7,
            index_offset=3,
        ),
    )
    workloads_context.torch.arange.return_value.remainder_.assert_called_once_with(37)
    workloads_context.torch.arange.return_value.bitwise_and_.assert_not_called()


def test_gemm_both_dtypes_and_ragged_dimensions(workloads_context):
    for dtype in ("fp16", "bf16"):
        p, _, _ = workloads_context.workload.prepare(
            "gemm", dict(dtype=dtype, m=17, n=33, k=65)
        )
        workloads_context.torch.empty.assert_called_with(
            (17, 33), device="cuda", dtype=workloads_context.workload.DTYPES[dtype]
        )
        assert p["input_dtype"] == dtype
        assert p["output_dtype"] == dtype
        assert p["launch"]["grid"] == [1]


def test_transpose_ragged_dimensions(workloads_context):
    p, _, _ = workloads_context.workload.prepare(
        "transpose", dict(dtype="fp32", rows=33, columns=65)
    )
    workloads_context.torch.empty.assert_called_with(
        (65, 33), device="cuda", dtype=workloads_context.torch.float32
    )
    assert p["launch"]["grid"] == [2, 3]


def test_attention_parameters_control_launch(workloads_context):
    p, launch, _ = workloads_context.workload.prepare(
        "gpt_oss_attention",
        GPT_PARAMS
        | dict(batch=2, sequence=256, query_heads=16, key_value_heads=4, window=0),
    )
    launch()
    workloads_context.attention.__getitem__.assert_called_once_with((4, 32, 1))
    assert (
        workloads_context.attention.__getitem__.return_value.call_args.kwargs[
            "BANDWIDTH"
        ]
        == 0
    )
    assert "model" not in p


@contextlib.contextmanager
def run_main(workloads_context, check):
    events = []
    launch = MagicMock()

    def prepare(workload, params):
        assert workload == "gpt_oss_attention"
        assert params == GPT_PARAMS
        events.append("prepare")
        return ({"fixture": True}, launch, check(events))

    def measure(callback, warmups, samples):
        assert callback is launch
        events.append("measure")
        return [12, 13, 14]

    workloads_context.torch.inference_mode.return_value = contextlib.nullcontext()
    with patch.object(
        sys,
        "argv",
        [
            "workloads",
            "--case",
            "triton.gpt_oss_attention_bf16",
            "--workload",
            "gpt_oss_attention",
            "--params",
            json.dumps(GPT_PARAMS),
            "--target",
            "gfx950",
        ],
    ), patch.object(
        workloads_context.workload, "prepare", side_effect=prepare
    ), patch.object(
        workloads_context.workload, "_reported_target", return_value="gfx950"
    ), patch.object(
        workloads_context.workload, "_measure", side_effect=measure
    ), patch.object(
        workloads_context.workload, "_write_result"
    ) as write_result:
        yield (events, write_result, workloads_context.workload.main)


def test_reference_check_runs_after_measurement_before_emission(workloads_context):

    def check(events):
        return lambda: events.append("check")

    with run_main(workloads_context, check) as (events, write_result, main):
        assert main() == 0
        assert events == ["prepare", "measure", "check"]
        assert write_result.call_args.args[1]["timings_ns"] == [12, 13, 14]


def test_reference_failure_does_not_emit_successful_samples(workloads_context):

    def check(events):

        def fail():
            events.append("check")
            raise AssertionError("reference mismatch")

        return fail

    with run_main(workloads_context, check) as (events, write_result, main):
        with pytest.raises(AssertionError, match="reference mismatch"):
            main()
        assert events == ["prepare", "measure", "check"]
        write_result.assert_not_called()
