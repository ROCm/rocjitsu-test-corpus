# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

from __future__ import annotations

import contextlib
import importlib.util
import json
from pathlib import Path
import sys
import types
import tomllib
import unittest
from unittest.mock import ANY, MagicMock, patch


ROOT = Path(__file__).resolve().parents[2]
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


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class UpstreamWorkloadTest(unittest.TestCase):
    def setUp(self):
        # Load our adapters with fake dependencies, never importing or compiling
        # Triton kernels. Keep discovery usable in a stdlib-only environment.
        self.torch = MagicMock()
        self.descriptor = MagicMock()
        self.attention = MagicMock()
        triton = types.ModuleType("triton")
        triton.jit = lambda function: function
        triton.cdiv = lambda a, b: (a + b - 1) // b
        triton.next_power_of_2 = lambda x: 1 << (x - 1).bit_length()
        triton.language = types.ModuleType("triton.language")
        dependencies = {
            "torch": self.torch,
            "triton": triton,
            "triton.language": triton.language,
            "triton.tools.tensor_descriptor": types.SimpleNamespace(
                TensorDescriptor=self.descriptor
            ),
            "corpus.benchmarks.triton.gpt_oss_attention": types.SimpleNamespace(
                _attn_fwd=self.attention, attention_ref=MagicMock()
            ),
        }
        dependency_patch = patch.dict(sys.modules, dependencies)
        dependency_patch.start()
        self.addCleanup(dependency_patch.stop)
        self.measurement = load_module(
            "measurement_under_test", ROOT / "benchmarks/measurement.py"
        )
        with patch.dict(sys.modules, {"benchmarks.measurement": self.measurement}):
            self.workload = load_module("upstream_under_test", WORKLOAD)

    def test_nightly_parameters_are_valid(self):
        suite = tomllib.loads((ROOT / "benchmarks/suites/nightly.toml").read_text())
        for case in suite["cases"]:
            with self.subTest(case=case["id"]):
                self.workload.validate_parameters(case["workload"], case["params"])

    def test_reference_copies_use_registered_host_memory(self):
        tensor = MagicMock()
        host = self.workload.to_cpu(tensor)
        self.torch.empty.assert_called_once_with(
            tensor.shape, dtype=tensor.dtype, device="cpu", pin_memory=True
        )
        host.copy_.assert_called_once_with(tensor)
        tensor.cpu.assert_not_called()

    def test_attention_prepares_buffers_and_descriptors_only_once(self):
        parameters, launch, check = self.workload.prepare(
            "gpt_oss_attention", GPT_PARAMS
        )
        self.attention.__getitem__.assert_not_called()
        self.assertEqual(self.descriptor.from_tensor.call_count, 4)
        self.assertEqual(self.torch.full.call_count, 4)
        allocations = list(self.torch.mock_calls)
        descriptors = list(self.descriptor.mock_calls)
        launch()
        launch()
        self.assertEqual(self.torch.mock_calls, allocations)
        self.assertEqual(self.descriptor.mock_calls, descriptors)
        self.assertEqual(self.attention.__getitem__.return_value.call_count, 2)
        self.assertEqual(
            parameters["measurement_scope"], "kernel_launch_and_synchronize"
        )
        self.assertTrue(callable(check))

    def test_invalid_parameters_fail_before_allocation(self):
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
            with self.subTest(change=change), self.assertRaises(ValueError):
                self.workload.prepare("gpt_oss_attention", GPT_PARAMS | change)
        self.torch.full.assert_not_called()
        self.torch.empty.assert_not_called()

    def test_copy_parameters_control_allocations_and_bytes(self):
        for dtype, size in (("fp16", 17), ("bf16", 1031), ("fp32", 7)):
            with self.subTest(dtype=dtype):
                parameters, _, _ = self.workload.prepare(
                    "copy", dict(dtype=dtype, elements=size)
                )
                self.torch.full.assert_called_with(
                    (size,), ANY, device="cuda", dtype=self.workload.DTYPES[dtype]
                )
                self.assertEqual(
                    parameters["bytes"], size * (4 if dtype == "fp32" else 2)
                )

    def test_gather_wraps_arbitrary_source_size(self):
        self.workload.prepare(
            "gather",
            dict(
                dtype="bf16",
                source_elements=37,
                output_elements=51,
                index_stride=7,
                index_offset=3,
            ),
        )
        self.torch.arange.return_value.remainder_.assert_called_once_with(37)
        self.torch.arange.return_value.bitwise_and_.assert_not_called()

    def test_gemm_both_dtypes_and_ragged_dimensions(self):
        for dtype in ("fp16", "bf16"):
            p, _, _ = self.workload.prepare("gemm", dict(dtype=dtype, m=17, n=33, k=65))
            self.torch.empty.assert_called_with(
                (17, 33), device="cuda", dtype=self.workload.DTYPES[dtype]
            )
            self.assertEqual(p["input_dtype"], dtype)
            self.assertEqual(p["output_dtype"], dtype)
            self.assertEqual(p["launch"]["grid"], [1])

    def test_transpose_ragged_dimensions(self):
        p, _, _ = self.workload.prepare(
            "transpose", dict(dtype="fp32", rows=33, columns=65)
        )
        self.torch.empty.assert_called_with(
            (65, 33), device="cuda", dtype=self.torch.float32
        )
        self.assertEqual(p["launch"]["grid"], [2, 3])

    def test_attention_parameters_control_launch(self):
        p, launch, _ = self.workload.prepare(
            "gpt_oss_attention",
            GPT_PARAMS
            | dict(batch=2, sequence=256, query_heads=16, key_value_heads=4, window=0),
        )
        launch()
        self.attention.__getitem__.assert_called_once_with((4, 32, 1))
        self.assertEqual(
            self.attention.__getitem__.return_value.call_args.kwargs["BANDWIDTH"], 0
        )
        self.assertNotIn("model", p)

    @contextlib.contextmanager
    def run_main(self, check):
        events = []
        launch = MagicMock()

        def prepare(workload, params):
            self.assertEqual(workload, "gpt_oss_attention")
            self.assertEqual(params, GPT_PARAMS)
            events.append("prepare")
            return {"fixture": True}, launch, check(events)

        def measure(callback, warmups, samples):
            self.assertIs(callback, launch)
            events.append("measure")
            return [12, 13, 14]

        self.torch.inference_mode.return_value = contextlib.nullcontext()
        with (
            patch.object(
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
            ),
            patch.object(self.workload, "prepare", side_effect=prepare),
            patch.object(self.workload, "_reported_target", return_value="gfx950"),
            patch.object(self.workload, "_measure", side_effect=measure),
            patch.object(self.workload, "_write_result") as write_result,
        ):
            yield events, write_result, self.workload.main

    def test_reference_check_runs_after_measurement_before_emission(self):
        def check(events):
            return lambda: events.append("check")

        with self.run_main(check) as (events, write_result, main):
            self.assertEqual(main(), 0)
            self.assertEqual(events, ["prepare", "measure", "check"])
            self.assertEqual(write_result.call_args.args[1]["timings_ns"], [12, 13, 14])

    def test_reference_failure_does_not_emit_successful_samples(self):
        def check(events):
            def fail():
                events.append("check")
                raise AssertionError("reference mismatch")

            return fail

        with self.run_main(check) as (events, write_result, main):
            with self.assertRaisesRegex(AssertionError, "reference mismatch"):
                main()
            self.assertEqual(events, ["prepare", "measure", "check"])
            write_result.assert_not_called()


if __name__ == "__main__":
    unittest.main()
