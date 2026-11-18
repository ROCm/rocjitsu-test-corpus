# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""CPU-only Gluon contract and full-output corruption checks."""

import importlib.util
import pathlib
import sys
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))


class GluonContractTests(unittest.TestCase):
    def load(self):
        from corpus.benchmarks.gluon import workloads

        return workloads

    def test_parameters_and_result_schema(self):
        w = self.load()
        p = {"elements": 100663296}
        normalized = w.validate_parameters("gluon_copy", p)
        self.assertEqual(normalized, {**p, "dtype": "fp32"})
        self.assertNotIn("dtype", p)
        result = w.result("copy", "gfx1100", normalized, [13, 17])
        self.assertEqual(result["parameters"], {**p, "dtype": "fp32"})
        self.assertEqual(
            set(result),
            {"schema", "case", "target", "provider", "parameters", "timings_ns"},
        )
        self.assertEqual(result["schema"], "rocjitsu.benchmark.workload.v1")
        self.assertEqual(result["provider"], "gluon")
        for p in (
            {"elements": True},
            {"elements": 0},
            {"elements": 134217729},
            {"elements": 1, "x": 2},
        ):
            with self.assertRaises(ValueError):
                w.validate_parameters("gluon_copy", p)
        with self.assertRaises(ValueError):
            w.validate_parameters("gluon_copy_2d", {"rows": 16384, "columns": 8193})

    def test_manifest_fp32_parameters(self):
        w = self.load()
        for workload, params in (
            ("gluon_copy", {"elements": 100663296, "dtype": "fp32"}),
            ("gluon_copy_2d", {"rows": 16384, "columns": 8192, "dtype": "fp32"}),
        ):
            with self.subTest(workload=workload):
                self.assertEqual(w.validate_parameters(workload, params), params)
                for dtype in ("fp16", "FP32", "", None, 32, True):
                    with self.subTest(dtype=dtype), self.assertRaises(ValueError):
                        w.validate_parameters(workload, {**params, "dtype": dtype})

    def test_pinned_extracted_kernels_and_license(self):
        from corpus.benchmarks.gluon import prepare

        metadata = prepare.verify_local()
        self.assertEqual(
            metadata["source_pin"], "675c59878aa2280b31f722aaf42b825fcee21de8"
        )
        self.assertEqual(
            metadata["functions"],
            ["memcpy_1d_kernel", "get_mask_and_offsets", "memcpy_2d_inout_kernel"],
        )

    def test_cpu_strided_poison_and_corruption(self):
        try:
            import torch
        except ImportError as exc:
            self.skipTest(str(exc))
        w = self.load()
        expected = w.host_input(35, 19, pinned=False)
        output = torch.empty((19, 35), dtype=torch.float32).T
        self.assertFalse(output.is_contiguous())
        w.poison_output(output)
        self.assertTrue(torch.isnan(output).all().item())
        with self.assertRaises(RuntimeError):
            w.check_output(output, expected)
        output.copy_(expected)
        w.check_output(output, expected)
        output[34, 18] += 1
        with self.assertRaises(RuntimeError):
            w.check_output(output, expected)
        output.copy_(expected.flip(0))
        with self.assertRaises(RuntimeError):
            w.check_output(output, expected)

    def test_selected_width_rejects_transposed_layout_tiles(self):
        try:
            import torch
        except ImportError as exc:
            self.skipTest(str(exc))
        w = self.load()
        # One tile-row at the selected width: 64 tiles, not the full 512 MiB case.
        expected = w.host_input(128, 8192, pinned=False)
        output = torch.empty((8192, 128), dtype=torch.float32).T
        self.assertFalse(output.is_contiguous())
        output.copy_(expected)
        w.check_output(output, expected)
        for column in range(0, 8192, 128):
            output[:, column : column + 128].copy_(expected[:, column : column + 128].T)
        with self.assertRaisesRegex(RuntimeError, "full exact CPU copy validation"):
            w.check_output(output, expected)
        # The generated dyadic values survive an FP64 round trip exactly.
        self.assertTrue(torch.equal(expected.double().float(), expected))
        self.assertTrue(torch.equal(expected * 16, (expected * 16).round()))

    def test_cli_rejects_arguments_without_device_imports(self):
        import subprocess

        for extra in (["--warmups", "-1"], ["--samples", "0"], ["--target", "gfx950"]):
            p = subprocess.run(
                [
                    sys.executable,
                    str(ROOT / "corpus/benchmarks/gluon/workloads.py"),
                    "--workload",
                    "gluon_copy",
                    "--params",
                    '{"elements":33}',
                    "--case",
                    "test",
                    "--target",
                    "gfx1100",
                    "--output",
                    "-",
                    *extra,
                ],
                capture_output=True,
                text=True,
            )
            self.assertNotEqual(p.returncode, 0)
            self.assertNotIn("ModuleNotFoundError", p.stderr)


if __name__ == "__main__":
    unittest.main()
