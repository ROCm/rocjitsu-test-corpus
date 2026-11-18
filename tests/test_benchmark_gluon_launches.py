# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Real Gluon preparation, sampling and checking with CPU transport only."""

from contextlib import ExitStack, redirect_stdout
import io
import json
from pathlib import Path
import sys
from types import SimpleNamespace
import unittest
from unittest.mock import MagicMock, patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))


class GluonLaunchTests(unittest.TestCase):
    def run_adapter(self, workload, params, grid, warmups, samples, final_write):
        try:
            import torch
        except ImportError as exc:
            self.skipTest(str(exc))
        from corpus.benchmarks.gluon import workloads
        from benchmarks import measurement

        kernel = MagicMock()

        def layout(*args):
            return tuple(args)

        language = SimpleNamespace(BlockedLayout=layout)
        gluon = SimpleNamespace(language=language)
        triton = SimpleNamespace(
            cdiv=lambda n, d: (n + d - 1) // d,
            experimental=SimpleNamespace(gluon=gluon),
        )
        modules = {
            "triton": triton,
            "triton.experimental": triton.experimental,
            "triton.experimental.gluon": gluon,
            "corpus.benchmarks.gluon.kernels": SimpleNamespace(
                memcpy_1d_kernel=kernel, memcpy_2d_inout_kernel=kernel
            ),
        }
        calls = 0
        original_to = torch.Tensor.to
        stdout = io.StringIO()

        def to(tensor, *args, **kwargs):
            if kwargs.get("device") == "cuda":
                kwargs["device"] = "cpu"
            return original_to(tensor, *args, **kwargs)

        def dispatch(x, y, *args, **kwargs):
            nonlocal calls
            calls += 1
            if final_write == "all" or calls < warmups + samples:
                y.copy_(x)
            elif final_write == "partial":
                # Index the logical tensor: reshape could copy the strided output.
                y[:-1].copy_(x[:-1])

        kernel.__getitem__.return_value.side_effect = dispatch
        with ExitStack() as stack:
            stack.enter_context(patch.dict(sys.modules, modules))
            for name in ("empty", "empty_like"):
                original = getattr(torch, name)

                def allocate(*args, _original=original, **kwargs):
                    kwargs.pop("pin_memory", None)
                    if kwargs.get("device") == "cuda":
                        kwargs["device"] = "cpu"
                    return _original(*args, **kwargs)

                stack.enter_context(patch.object(torch, name, allocate))
            stack.enter_context(patch.object(torch.Tensor, "to", to))
            stack.enter_context(patch.object(torch.cuda, "synchronize", lambda: None))
            stack.enter_context(
                patch.object(measurement, "reported_target", lambda: "gfx1100")
            )
            argv = [
                "--workload",
                workload,
                "--params",
                json.dumps(params),
                "--case",
                "gluon-reset",
                "--target",
                "gfx1100",
                "--warmups",
                str(warmups),
                "--samples",
                str(samples),
                "--output",
                "-",
            ]
            with redirect_stdout(stdout):
                if final_write == "all":
                    workloads.main(argv)
                else:
                    with self.assertRaisesRegex(
                        RuntimeError, "full exact CPU copy validation failed"
                    ):
                        workloads.main(argv)

        # Compilation and validation must not dispatch a hidden extra launch.
        self.assertEqual(calls, warmups + samples)
        self.assertEqual(kernel.warmup.call_count, 1)
        prepared = kernel.warmup.call_args
        x, y = prepared.args[:2]
        self.assertEqual(prepared.kwargs["grid"], grid)
        self.assertEqual(prepared.kwargs["num_warps"], 4)
        self.assertTrue(
            all(call.args == (grid,) for call in kernel.__getitem__.call_args_list)
        )
        rows, columns = params.get("rows", params.get("elements")), params.get(
            "columns", 1
        )
        self.assertEqual(x.shape, (rows, columns))
        if workload == "gluon_copy":
            self.assertEqual(y.stride(), (1, 1))
            self.assertEqual(prepared.args[2:], (rows,))
            self.assertEqual(prepared.kwargs["XBLOCK"], 1024)
            self.assertEqual(prepared.kwargs["layout"], ([1], [32], [4], [0]))
        else:
            self.assertFalse(y.is_contiguous())
            self.assertEqual(y.stride(), (1, rows))
            self.assertEqual(
                prepared.args[2:],
                (
                    rows,
                    columns,
                    columns,
                    1,
                    1,
                    rows,
                    ([1, 4], [4, 8], [4, 1], [1, 0]),
                    ([4, 1], [8, 4], [1, 4], [0, 1]),
                    128,
                    128,
                ),
            )
        if final_write == "all":
            self.assertEqual(len(json.loads(stdout.getvalue())["timings_ns"]), samples)
        else:
            self.assertEqual(stdout.getvalue(), "")

    def test_final_sample_cannot_reuse_earlier_good_output(self):
        cases = (
            ("gluon_copy", {"elements": 33}, (1,)),
            ("gluon_copy", {"elements": 2051}, (3,)),
            ("gluon_copy_2d", {"rows": 35, "columns": 19}, (1, 1)),
            ("gluon_copy_2d", {"rows": 129, "columns": 131}, (2, 2)),
        )
        for workload, params, grid in cases:
            for warmups, samples in ((0, 2), (1, 1)):
                for final_write in ("all", "none", "partial"):
                    with self.subTest(
                        workload=workload,
                        params=params,
                        warmups=warmups,
                        samples=samples,
                        final_write=final_write,
                    ):
                        self.run_adapter(
                            workload, params, grid, warmups, samples, final_write
                        )


if __name__ == "__main__":
    unittest.main()
