# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
import importlib.util
import json
import sys
from pathlib import Path
from unittest.mock import MagicMock

import pytest


@pytest.fixture
def measurement(monkeypatch):
    monkeypatch.setitem(sys.modules, "torch", MagicMock())
    path = Path(__file__).resolve().parents[1] / "benchmarks/measurement.py"
    spec = importlib.util.spec_from_file_location("measurement_progress_test", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_progress_boundaries_and_callback_cost(measurement, monkeypatch):
    clock = [0]
    events = []
    monkeypatch.setattr(measurement.time, "perf_counter_ns", lambda: clock[0])
    monkeypatch.setattr(measurement.time, "monotonic_ns", lambda: clock[0])

    def launch():
        clock[0] += 10

    def progress(event):
        events.append(event)
        clock[0] += 1000  # File I/O must never enter measured sample durations.

    assert measurement.measure(launch, 1, 2, progress=progress) == [10, 10]
    assert [(event["stage"], event["index"]) for event in events] == [
        ("warmup", 1), ("warmup", 1),
        ("sample", 1), ("sample", 1), ("sample", 2), ("sample", 2),
    ]
    assert all(event["monotonic_end_ns"] is None for event in events[::2])
    assert all(event["duration_ns"] == 10 for event in events[1::2])
    assert events[-1]["timings_ns"] == [10, 10]
    assert events[-2]["timings_ns"] == [10]


def test_progress_retains_running_stage_on_failure(measurement):
    events = []

    def fail():
        raise RuntimeError("dispatch failed")

    with pytest.raises(RuntimeError, match="dispatch failed"):
        measurement.measure(fail, 1, 1, progress=events.append)
    assert len(events) == 1
    assert events[0]["stage"] == "warmup"
    assert events[0]["monotonic_end_ns"] is None


def test_progress_sidecar_replaces_atomically(measurement, tmp_path):
    writer = measurement.progress_writer(str(tmp_path / "workload.json"), "example")
    writer({"stage": "warmup", "index": 1})
    writer({"stage": "sample", "index": 2})
    assert json.loads((tmp_path / "workload.progress.json").read_text()) == {
        "case": "example", "stage": "sample", "index": 2,
    }
    assert not list(tmp_path.glob("*.tmp"))
    assert measurement.progress_writer("-", "example") is None


def test_reference_copies_use_registered_host_memory(measurement):
    tensor = MagicMock()
    host = measurement.to_cpu(tensor)
    measurement.torch.empty.assert_called_once_with(
        tensor.shape, dtype=tensor.dtype, device="cpu", pin_memory=True
    )
    host.copy_.assert_called_once_with(tensor)
    tensor.cpu.assert_not_called()


def test_precompiled_single_sample_does_not_launch_during_compile(measurement, monkeypatch):
    from unittest.mock import PropertyMock
    clock = [0]
    kernel = MagicMock()
    handles = PropertyMock(side_effect=lambda: clock.__setitem__(0, clock[0] + 10000))
    compiled = MagicMock()
    type(compiled).run = handles
    kernel.warmup.return_value = compiled
    launch = measurement.TritonLaunch(kernel, (4,), "tensor", BLOCK=128)
    monkeypatch.setattr(measurement.time, "perf_counter_ns", lambda: clock[0])
    kernel.__getitem__.return_value.side_effect = lambda *a, **k: clock.__setitem__(0, clock[0] + 10)
    launch.compile()
    kernel.warmup.assert_called_once_with("tensor", grid=(4,), BLOCK=128)
    handles.assert_called_once()
    kernel.__getitem__.assert_not_called()
    assert measurement.measure(launch, 0, 1) == [10]
    kernel.__getitem__.return_value.assert_called_once_with("tensor", BLOCK=128)
