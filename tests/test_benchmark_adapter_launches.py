# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Exercise real preparation/reset/check wiring with CPU tensors and fake kernels."""

import importlib.util
from pathlib import Path
import sys
from types import SimpleNamespace
from unittest.mock import MagicMock

import pytest

torch = pytest.importorskip("torch")


@pytest.fixture
def adapters(monkeypatch):
    # Replace device transport only. Keep actual inputs, outputs, preparation,
    # reset hooks, measurement, and checkers so missing adapter wiring fails.
    for name in ("empty", "tensor"):
        original = getattr(torch, name)

        def allocate(*args, _original=original, **kwargs):
            kwargs.pop("pin_memory", None)
            if kwargs.get("device") == "cuda":
                kwargs["device"] = "cpu"
            return _original(*args, **kwargs)

        monkeypatch.setattr(torch, name, allocate)
    original_to = torch.Tensor.to

    def to(tensor, *args, **kwargs):
        if args and args[0] == "cuda":
            args = ("cpu", *args[1:])
        return original_to(tensor, *args, **kwargs)

    monkeypatch.setattr(torch.Tensor, "to", to)
    monkeypatch.setattr(torch.Tensor, "pin_memory", lambda tensor: tensor)
    monkeypatch.setattr(torch.cuda, "synchronize", lambda: None)
    monkeypatch.setattr(torch.cuda, "get_device_properties", lambda *_: SimpleNamespace(multi_processor_count=8))
    monkeypatch.setitem(sys.modules, "triton", SimpleNamespace(
        cdiv=lambda n, d: (n + d - 1) // d,
        next_power_of_2=lambda n: 1 << (n - 1).bit_length(),
    ))
    root = Path(__file__).resolve().parents[1]

    def load(name, relative):
        spec = importlib.util.spec_from_file_location(name, root / relative)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        return module

    measurement = load("adapter_measurement", "benchmarks/measurement.py")
    monkeypatch.setitem(sys.modules, "benchmarks.measurement", measurement)
    modules = {}
    for name in ("reductions", "quantization", "candidates"):
        modules[name] = load(f"adapter_{name}", f"corpus/benchmarks/triton/{name}.py")
        monkeypatch.setattr(modules[name], "to_cpu", lambda tensor: tensor)
    return measurement, modules


CASES = [
    ("triton_softmax", None), ("triton_layernorm", None),
    ("deepseek_act_quant", None), ("deepseek_weight_dequant", None),
    *[(name, preset) for name in ("triton_persistent", "triton_grouped", "deepseek_fp8")
      for preset in (None, "large_tile")],
]


@pytest.mark.parametrize("workload,preset", CASES)
@pytest.mark.parametrize("warmups,samples", [(0, 1), (0, 2), (1, 2)])
@pytest.mark.parametrize("final_write", ["all", "none", "partial"])
def test_prepared_launch_metadata_and_final_sample_reset(
    adapters, monkeypatch, workload, preset, warmups, samples, final_write,
):
    measurement, modules = adapters
    kernel = MagicMock()
    if workload.startswith("triton_") and workload in ("triton_softmax", "triton_layernorm"):
        name = "softmax" if workload == "triton_softmax" else "layernorm"
        symbol = "softmax_kernel" if name == "softmax" else "_layer_norm_fwd_fused"
        monkeypatch.setitem(sys.modules, f"corpus.benchmarks.third_party.triton_candidates.{name}", SimpleNamespace(**{symbol: kernel}))
        params = dict(rows=3, columns=257, dtype="fp32")
        if name == "layernorm":
            params["epsilon"] = 1e-5
        metadata, launch, check = modules["reductions"].PREPARE_REDUCTIONS[workload](params)
        outputs = [launch.args[0]] if name == "softmax" else [launch.args[i] for i in (1, 4, 5)]
        from corpus.benchmarks.triton.reduction_reference import reduction_reference
        expected = reduction_reference(workload, 0, 3, 257)
        expected_grid = (3,)
        expected_knobs = dict(BLOCK_SIZE=512, num_warps=8, num_stages=2 if name == "softmax" else 1)
    elif workload in ("deepseek_act_quant", "deepseek_weight_dequant"):
        symbol = "act_quant_kernel" if workload == "deepseek_act_quant" else "weight_dequant_kernel"
        monkeypatch.setitem(sys.modules, "corpus.benchmarks.third_party.deepseek.kernel", SimpleNamespace(**{symbol: kernel}))
        from corpus.benchmarks.triton.quantization_reference import activation_expected
        if workload == "deepseek_act_quant":
            params = dict(rows=3, columns=256, dtype="bf16")
            metadata, launch, check = modules["quantization"].prepare_deepseek_act_quant(params)
            outputs = [launch.args[1], launch.args[2]]
            expected = activation_expected(launch.args[0])
            expected_grid = (6,)
            expected_knobs = dict(BLOCK_SIZE=128, scale_fmt=None, num_warps=4)
        else:
            params = dict(rows=129, columns=131, dtype="fp8")
            metadata, launch, check = modules["quantization"].prepare_deepseek_weight_dequant(params)
            x, scales, y = launch.args[:3]
            outputs = [y]
            expected = [x.float() * scales.repeat_interleave(128, 0).repeat_interleave(128, 1)[:129, :131]]
            expected_grid = (2, 2)
            expected_knobs = dict(BLOCK_SIZE=128, num_warps=4)
    else:
        from corpus.benchmarks.triton.candidate_reference import candidate_expected
        params = dict(rows=128, columns=128, reduction=256, dtype="fp16")
        if preset:
            params["configuration"] = preset
        if workload == "deepseek_fp8":
            params["dtype"] = "fp8"
            monkeypatch.setitem(sys.modules, "corpus.benchmarks.third_party.deepseek.kernel", SimpleNamespace(fp8_gemm_kernel=SimpleNamespace(fn=kernel)))
        else:
            name, symbol = ("persistent", "matmul_kernel_persistent") if workload == "triton_persistent" else ("grouped", "grouped_matmul_kernel")
            monkeypatch.setitem(sys.modules, f"corpus.benchmarks.third_party.triton_candidates.{name}", SimpleNamespace(**{symbol: kernel}))
        if workload == "triton_grouped":
            params["groups"] = 2
        metadata, launch, check = modules["candidates"].PREPARE_CANDIDATES[workload](params)
        outputs = launch.keepalive[2] if workload == "triton_grouped" else [launch.args[2]]
        bases = ((1., 1.) if preset else (.5, .25)) if workload == "deepseek_fp8" else None
        expected = [candidate_expected(128, 128, 256, out.dtype, group=g, scale_bases=bases) for g, out in enumerate(outputs)]
        tile = 128 if preset else 64
        if workload == "deepseek_fp8":
            expected_grid = (2 if preset else 4, 2)
            expected_knobs = dict(BLOCK_SIZE_M=64 if preset else 32, BLOCK_SIZE_N=64, BLOCK_SIZE_K=128, num_warps=8, num_stages=3)
        else:
            expected_grid = (8,) if workload == "triton_grouped" else ((128 // tile) ** 2,)
            expected_knobs = dict(BLOCK_SIZE_M=tile, BLOCK_SIZE_N=tile, BLOCK_SIZE_K=64, num_warps=4, num_stages=2 if preset else 1)
            if workload == "triton_grouped":
                expected_knobs["NUM_SM"] = 8
            else:
                expected_knobs.update(NUM_SMS=8, GROUP_SIZE_M=8)

    assert metadata["launch"] == {"grid": list(expected_grid), **expected_knobs}
    # Seed a previous good result. Removing the installed hook must fail even
    # for a sole no-op sample, not just when allocation happened to contain NaN.
    for output, value in zip(outputs, expected, strict=True):
        output.copy_(value)
    launch.compile()
    kernel.__getitem__.assert_not_called()
    assert kernel.warmup.call_args.kwargs == {"grid": expected_grid, **expected_knobs}
    for output, value in zip(outputs, expected, strict=True):
        assert torch.equal(output.float(), value.float())
    calls = 0

    def dispatch(*args, **kwargs):
        nonlocal calls
        calls += 1
        assert kwargs == expected_knobs
        for output in outputs:
            assert torch.isnan(output.float()).all()
        for output, value in zip(outputs, expected, strict=True):
            if final_write == "all" or calls < warmups + samples:
                output.copy_(value)
            elif final_write == "partial":
                output[1:].copy_(value[1:])

    kernel.__getitem__.return_value.side_effect = dispatch
    durations = measurement.measure(launch, warmups, samples)
    assert len(durations) == samples
    assert calls == warmups + samples
    assert all(call.args == (expected_grid,) for call in kernel.__getitem__.call_args_list)
    if final_write == "all":
        check()
    else:
        with pytest.raises(AssertionError):
            check()
    assert calls == warmups + samples  # Checking must not launch again.
