# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Host-only native adapter tests. Set LLAMA_BENCHMARK_CPU_BINARY after preparation."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))


class LlamaContractTests(unittest.TestCase):
    def test_preparation_rejects_wrong_pin_and_in_source_build(self):
        import tempfile
        from corpus.benchmarks.llama import prepare

        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)
            subprocess.run(["git", "init", "-q", str(path)], check=True)
            (path / "tracked").write_text("fixture")
            subprocess.run(["git", "-C", str(path), "add", "tracked"], check=True)
            subprocess.run(
                [
                    "git",
                    "-C",
                    str(path),
                    "-c",
                    "user.name=test",
                    "-c",
                    "user.email=test@example.com",
                    "commit",
                    "--no-gpg-sign",
                    "-qm",
                    "fixture",
                ],
                check=True,
            )
            with self.assertRaises(ValueError):
                prepare.verify_source(path)
            with self.assertRaises(ValueError):
                prepare.check_build_path(path, path / "build")

    def test_binary_receipt_needs_source_backend_target_not_binary_hash(self):
        import tempfile
        from corpus.benchmarks.llama import workloads as w

        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)
            binary = path / "llama_bounded_ops"
            binary.write_bytes(b"explicit unit-test binary fixture, not executable")
            receipt = dict(
                source_pin=w.PIN,
                backend="cpu",
                targets=[],
                adapter_sha256=hashlib.sha256(
                    (ROOT / "corpus/benchmarks/llama/runner.cpp").read_bytes()
                ).hexdigest(),
            )
            receipt_path = path / "benchmark-build.json"
            receipt_path.write_text(json.dumps(receipt))
            self.assertEqual(
                w.verify_binary(binary, cpu=True, target="gfx1100"), binary
            )
            # Receipts describe source provenance, not executable-byte identity.
            binary.write_bytes(b"changed fixture")
            self.assertEqual(
                w.verify_binary(binary, cpu=True, target="gfx1100"), binary
            )
            for cpu, target, metadata in (
                (True, "gfx1100", {**receipt, "source_pin": "wrong"}),
                (False, "gfx1100", receipt),
                (True, "gfx1100", {**receipt, "backend": "hip"}),
                (
                    False,
                    "gfx1201",
                    {**receipt, "backend": "hip", "targets": ["gfx1100"]},
                ),
            ):
                with self.subTest(cpu=cpu, target=target, metadata=metadata):
                    receipt_path.write_text(json.dumps(metadata))
                    with self.assertRaises(ValueError):
                        w.verify_binary(binary, cpu=cpu, target=target)
            receipt_path.write_text(
                json.dumps({**receipt, "backend": "hip", "targets": ["gfx1100"]})
            )
            self.assertEqual(
                w.verify_binary(binary, cpu=False, target="gfx1100"), binary
            )
            binary.unlink()
            with self.assertRaises((ValueError, OSError)):
                w.verify_binary(binary, cpu=False, target="gfx1100")
            binary.mkdir()
            with self.assertRaises((ValueError, OSError)):
                w.verify_binary(binary, cpu=False, target="gfx1100")

    @unittest.skipUnless(
        os.environ.get("LLAMA_BENCHMARK_SOURCE"), "exact llama source required"
    )
    def test_fresh_preparation_records_source_without_binary_hash(self):
        import tempfile
        from corpus.benchmarks.llama import prepare, workloads

        with tempfile.TemporaryDirectory() as directory:
            build = Path(directory) / "cpu"
            prepare.main(
                [
                    "--source",
                    os.environ["LLAMA_BENCHMARK_SOURCE"],
                    "--build",
                    str(build),
                    "--backend",
                    "cpu",
                ]
            )
            receipt = json.loads((build / "benchmark-build.json").read_text())
            self.assertEqual(receipt["source_pin"], workloads.PIN)
            self.assertEqual(receipt["backend"], "cpu")
            self.assertEqual(receipt["targets"], [])
            self.assertEqual(
                receipt["adapter_sha256"],
                prepare.sha256(ROOT / "corpus/benchmarks/llama/runner.cpp"),
            )
            self.assertNotIn("binary_sha256", receipt)
            self.assertEqual(
                workloads.verify_binary(
                    build / "llama_bounded_ops", cpu=True, target="gfx1100"
                ),
                build / "llama_bounded_ops",
            )

    def test_result_parameters_include_exact_source_pin(self):
        from corpus.benchmarks.llama import workloads as w

        params = {"k": 32, "rows": 4, "tokens": 1, "dtype": "fp32"}
        data = {
            "source_pin": w.PIN,
            "backend": "CPU",
            "op": "matvec-q4",
            "pass": True,
            "bad": 0,
            "checked": 4,
            "warmups": 0,
            "graph_invocations": 1,
            "timings_ns": [123],
            "k": 32,
            "rows": 4,
            "tokens": 1,
        }
        for cpu, backend in ((True, "CPU"), (False, "HIP0")):
            with self.subTest(cpu=cpu):
                native = {**data, "backend": backend}
                result = w.checked_result(
                    native, "case", "gfx1100", params, 1, cpu=cpu, op="matvec-q4"
                )
                self.assertEqual(result["parameters"], {**params, "source_pin": w.PIN})
                for key, value in (
                    ("source_pin", "wrong"),
                    ("backend", "HIP0" if cpu else "CPU"),
                ):
                    with self.subTest(key=key), self.assertRaises(ValueError):
                        w.checked_result(
                            {**native, key: value},
                            "case",
                            "gfx1100",
                            params,
                            1,
                            cpu=cpu,
                            op="matvec-q4",
                        )
        self.assertNotIn("source_pin", params)

    def test_contract(self):
        from corpus.benchmarks.llama import workloads as w

        p = {"k": 128, "heads": 4096, "tokens": 32}
        self.assertEqual(w.validate_parameters("llama_rope", p), {**p, "dtype": "fp32"})
        self.assertNotIn("dtype", p)
        for workload, params in [
            ("llama_rope", {"k": 3, "heads": 1, "tokens": 1}),
            ("llama_matvec", {"k": 128, "rows": 32, "tokens": 2}),
            ("llama_gather", {"k": 31, "rows": 32, "tokens": 4}),
            ("llama_rope", {"k": True, "heads": 1, "tokens": 1}),
        ]:
            with self.assertRaises(ValueError):
                w.validate_parameters(workload, params)
        with self.assertRaises(ValueError):
            w.checked_result({"pass": False}, "case", "gfx1100", p, 1)

    def test_manifest_fp32_parameters(self):
        from corpus.benchmarks.llama import workloads as w

        for workload, params in (
            ("llama_rope", {"k": 128, "heads": 4096, "tokens": 32, "dtype": "fp32"}),
            ("llama_matvec", {"k": 4096, "rows": 32768, "tokens": 1, "dtype": "fp32"}),
            (
                "llama_gather",
                {"k": 4096, "rows": 1024, "tokens": 4096, "dtype": "fp32"},
            ),
        ):
            with self.subTest(workload=workload):
                self.assertEqual(w.validate_parameters(workload, params), params)
                for dtype in ("fp16", "FP32", "", None, 32, True):
                    with self.subTest(dtype=dtype), self.assertRaises(ValueError):
                        w.validate_parameters(workload, {**params, "dtype": dtype})

    @unittest.skipUnless(
        os.environ.get("LLAMA_BENCHMARK_CPU_BINARY"), "prepare CPU binary first"
    )
    def test_native_usage_lists_only_supported_operations(self):
        result = subprocess.run(
            [os.environ["LLAMA_BENCHMARK_CPU_BINARY"]],
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 1)
        self.assertFalse(result.stdout)
        self.assertTrue(result.stderr.startswith("usage: llama_bounded_ops "))
        self.assertEqual(
            result.stderr.split()[2].split("|"),
            ["rope", "matvec-q4", "gather-q8"],
        )

    @unittest.skipUnless(
        os.environ.get("LLAMA_BENCHMARK_CPU_BINARY"), "prepare CPU binary first"
    )
    def test_native_valid_footprints_reach_backend_selection(self):
        from corpus.benchmarks.llama import workloads

        binary = os.environ["LLAMA_BENCHMARK_CPU_BINARY"]
        workloads.verify_binary(binary, cpu=True, target="gfx1100")
        cases = (
            ("llama_gather", {"k": 4096, "rows": 1024, "tokens": 16384}, []),
            ("llama_gather", {"k": 4096, "rows": 1024, "tokens": 32768}, []),
            ("llama_matvec", {"k": 4096, "rows": 32768, "tokens": 1}, []),
            ("llama_rope", {"k": 128, "heads": 32768, "tokens": 32}, []),
            ("llama_rope", {"k": 32768, "heads": 1, "tokens": 1}, ["--rows", "32768"]),
            (
                "llama_gather",
                {"k": 4096, "rows": 32, "tokens": 32},
                ["--heads", "32768"],
            ),
        )
        for workload, params, extra in cases:
            with self.subTest(workload=workload, params=params, extra=extra):
                workloads.validate_parameters(workload, params)
                command = [binary, workloads.WORKLOADS[workload], *extra]
                for key, value in params.items():
                    command.extend(["--" + key, str(value)])
                # A verified CPU-only build without --cpu stops before graph allocation.
                result = subprocess.run(command, capture_output=True, text=True)
                self.assertEqual(result.returncode, 1, result.stderr)
                self.assertFalse(result.stdout)
                self.assertEqual(
                    result.stderr.strip(),
                    "backend unavailable (CPU build requires --cpu)",
                )

    @unittest.skipUnless(
        os.environ.get("LLAMA_BENCHMARK_CPU_BINARY"), "prepare CPU binary first"
    )
    def test_cpu_long_rope_matches_reference(self):
        """Long positions expose drift in a corpus-written double-trig oracle."""
        from corpus.benchmarks.llama import workloads as w

        binary = os.environ["LLAMA_BENCHMARK_CPU_BINARY"]
        w.verify_binary(binary, cpu=True, target="gfx1100")
        for mode in ([], ["--neox"]):
            with self.subTest(mode=mode):
                process = subprocess.run(
                    [
                        binary,
                        "rope",
                        "--cpu",
                        "--k",
                        "128",
                        "--heads",
                        "1",
                        "--tokens",
                        "1024",
                        *mode,
                    ],
                    capture_output=True,
                    text=True,
                )
                self.assertEqual(process.returncode, 0, process.stdout + process.stderr)
                data = json.loads(process.stdout)
                self.assertTrue(data["pass"])
                self.assertEqual(data["checked"], 128 * 1024)

    @unittest.skipUnless(
        os.environ.get("LLAMA_BENCHMARK_CPU_BINARY"), "prepare CPU binary first"
    )
    def test_cpu_positive_and_schema(self):
        binary = os.environ["LLAMA_BENCHMARK_CPU_BINARY"]
        cases = [
            ("llama_rope", {"k": 128, "heads": 4, "tokens": 4}),
            ("llama_matvec", {"k": 128, "rows": 32, "tokens": 1}),
            ("llama_gather", {"k": 128, "rows": 32, "tokens": 7}),
        ]
        for workload, params in cases + [
            (workload, {**params, "dtype": "fp32"}) for workload, params in cases
        ]:
            p = subprocess.run(
                [
                    sys.executable,
                    str(ROOT / "corpus/benchmarks/llama/workloads.py"),
                    "--binary",
                    binary,
                    "--cpu",
                    "--workload",
                    workload,
                    "--params",
                    json.dumps(params),
                    "--case",
                    "host-check",
                    "--target",
                    "gfx1100",
                    "--warmups",
                    "1",
                    "--samples",
                    "2",
                    "--output",
                    "-",
                ],
                capture_output=True,
                text=True,
            )
            self.assertEqual(p.returncode, 0, p.stderr)
            data = json.loads(p.stdout)
            self.assertEqual(
                set(data),
                {"schema", "case", "target", "provider", "parameters", "timings_ns"},
            )
            self.assertEqual(data["schema"], "rocjitsu.benchmark.workload.v1")
            self.assertEqual(data["provider"], "llama")
            self.assertEqual(
                data["parameters"],
                {
                    **params,
                    "dtype": "fp32",
                    "source_pin": "26d52b0f9543f441fc2bfa383557c992a4fbf4b9",
                },
            )
            self.assertEqual(len(data["timings_ns"]), 2)
            self.assertTrue(all(type(t) is int and t > 0 for t in data["timings_ns"]))

    @unittest.skipUnless(
        os.environ.get("LLAMA_BENCHMARK_CPU_BINARY"), "prepare CPU binary first"
    )
    def test_native_separate_cpu_reference_and_counts(self):
        from corpus.benchmarks.llama import workloads as w

        binary = os.environ["LLAMA_BENCHMARK_CPU_BINARY"]
        w.verify_binary(binary, cpu=True, target="gfx1100")
        for op, params, extent in (
            ("rope", {"k": 128, "heads": 4, "tokens": 4}, 2048),
            ("matvec-q4", {"k": 128, "rows": 32, "tokens": 1}, 32),
            ("gather-q8", {"k": 128, "rows": 32, "tokens": 7}, 896),
        ):
            for warmups, samples in ((0, 1), (1, 2)):
                with self.subTest(op=op, warmups=warmups, samples=samples):
                    command = [
                        binary,
                        op,
                        "--cpu",
                        "--warmups",
                        str(warmups),
                        "--samples",
                        str(samples),
                    ]
                    for key, value in params.items():
                        command.extend(["--" + key, str(value)])
                    process = subprocess.run(command, capture_output=True, text=True)
                    self.assertEqual(
                        process.returncode, 0, process.stdout + process.stderr
                    )
                    data = json.loads(process.stdout)
                    self.assertEqual(data["reference_backend"], "CPU")
                    self.assertIs(data["reference_use_ref"], True)
                    self.assertEqual(data["reference_graph_invocations"], 1)
                    self.assertEqual(data["graph_invocations"], warmups + samples)
                    self.assertEqual(data["checked"], extent)
                    self.assertEqual(data["bad"], 0)
                    self.assertEqual(data["atol"], 0.03 if op == "matvec-q4" else 2e-5)
                    self.assertEqual(data["rtol"], 0.02 if op == "matvec-q4" else 2e-5)
                    result = w.checked_result(
                        data,
                        "reference-check",
                        "gfx1100",
                        params,
                        samples,
                        warmups=warmups,
                        cpu=True,
                        op=op,
                    )
                    self.assertEqual(len(result["timings_ns"]), samples)
                    self.assertEqual(
                        set(result),
                        {
                            "schema",
                            "case",
                            "target",
                            "provider",
                            "parameters",
                            "timings_ns",
                        },
                    )

    @unittest.skipUnless(
        os.environ.get("LLAMA_BENCHMARK_CPU_BINARY"), "prepare CPU binary first"
    )
    def test_native_sampling_count_and_checked_extent(self):
        from corpus.benchmarks.llama import workloads as w

        p = subprocess.run(
            [os.environ["LLAMA_BENCHMARK_CPU_BINARY"], "gather-q8", "--cpu"],
            capture_output=True,
            text=True,
            check=True,
        )
        data = json.loads(p.stdout)
        params = {"k": 128, "rows": 32, "tokens": 4, "dtype": "fp32"}
        self.assertNotIn("dtype", data)
        result = w.checked_result(
            data, "case", "gfx1100", params, 1, cpu=True, op="gather-q8"
        )
        self.assertEqual(result["parameters"], {**params, "source_pin": w.PIN})
        for key, value in (
            ("source_pin", "wrong"),
            ("pass", False),
            ("bad", 1),
            ("warmups", 1),
            ("graph_invocations", 2),
            ("backend", "HIP"),
            ("op", "rope"),
            ("k", 256),
            ("timings_ns", [0]),
        ):
            with self.subTest(key=key), self.assertRaises(ValueError):
                w.checked_result(
                    {**data, key: value},
                    "case",
                    "gfx1100",
                    params,
                    1,
                    cpu=True,
                    op="gather-q8",
                )
        self.assertEqual(data["graph_invocations"], 1)
        data["checked"] -= 1
        with self.assertRaises(ValueError):
            w.checked_result(
                data, "case", "gfx1100", params, 1, cpu=True, op="gather-q8"
            )

    @unittest.skipUnless(
        os.environ.get("LLAMA_BENCHMARK_CPU_BINARY"), "prepare CPU binary first"
    )
    def test_matvec_quantized_rows_reject_wrong_row(self):
        binary = Path(os.environ["LLAMA_BENCHMARK_CPU_BINARY"])
        # Same K as the selected case, two periods of the former alias pattern.
        arguments = [
            "matvec-q4",
            "--cpu",
            "--k",
            "4096",
            "--rows",
            "202",
            "--tokens",
            "1",
            "--warmups",
            "1",
            "--samples",
            "2",
        ]
        control = subprocess.run(
            [str(binary), *arguments], capture_output=True, text=True, timeout=120
        )
        self.assertEqual(control.returncode, 0, control.stdout + control.stderr)
        positive = json.loads(control.stdout)
        self.assertEqual(positive["checked"], 202)
        mutation = subprocess.run(
            [str(binary.with_name("llama_bounded_ops-wrong-row")), *arguments],
            capture_output=True,
            text=True,
            timeout=120,
        )
        data = json.loads(mutation.stdout)
        self.assertEqual(data["wrong_row_requests"], 101)
        self.assertEqual(mutation.returncode, 2, mutation.stdout + mutation.stderr)
        self.assertEqual(data["quantized_unique_rows"], 202)
        self.assertEqual(data["bad"], data["wrong_row_requests"])
        self.assertGreater(data["min_wrong_row_tolerance_ratio"], 1)
        self.assertGreater(data["max_tolerance_ratio"], 1)
        self.assertEqual(data["checked"], positive["checked"])
        self.assertEqual(data["graph_invocations"], 3)
        self.assertEqual(data["reference_graph_invocations"], 1)
        self.assertEqual((data["atol"], data["rtol"]), (0.03, 0.02))

    @unittest.skipUnless(
        os.environ.get("LLAMA_BENCHMARK_CPU_BINARY"), "prepare CPU binary first"
    )
    def test_matvec_bulk_k_reversal_is_observable_for_either_operand(self):
        binary = Path(os.environ["LLAMA_BENCHMARK_CPU_BINARY"])
        arguments = [
            # Short K avoids averaging lane-order errors away; enough rows
            # exercise magnitudes above the unchanged absolute-error floor.
            "matvec-q4",
            "--cpu",
            "--k",
            "64",
            "--rows",
            "4096",
            "--tokens",
            "1",
        ]
        control = subprocess.run(
            [str(binary), *arguments], capture_output=True, text=True, timeout=120
        )
        self.assertEqual(control.returncode, 0, control.stdout + control.stderr)
        for operand in ("a", "b"):
            with self.subTest(operand=operand):
                mutation = subprocess.run(
                    [str(binary.with_name("llama_bounded_ops-wrong-row")), *arguments],
                    env={**os.environ, "LLAMA_TEST_REVERSE_K": operand},
                    capture_output=True,
                    text=True,
                    timeout=120,
                )
                data = json.loads(mutation.stdout)
                self.assertEqual(data["wrong_row_requests"], 0)
                self.assertEqual(
                    mutation.returncode, 2, mutation.stdout + mutation.stderr
                )
                self.assertGreater(data["bad"], 0)
                self.assertEqual((data["atol"], data["rtol"]), (0.03, 0.02))

    @unittest.skipUnless(
        os.environ.get("LLAMA_BENCHMARK_CPU_BINARY"), "prepare CPU binary first"
    )
    def test_selected_gather_quantized_rows_reject_wrong_row(self):
        binary = Path(os.environ["LLAMA_BENCHMARK_CPU_BINARY"])
        arguments = [
            "gather-q8",
            "--cpu",
            "--k",
            "4096",
            "--rows",
            "1024",
            "--tokens",
            "4096",
        ]
        control = subprocess.run(
            [str(binary), *arguments], capture_output=True, text=True, timeout=120
        )
        self.assertEqual(control.returncode, 0, control.stdout + control.stderr)
        positive = json.loads(control.stdout)
        self.assertTrue(positive["pass"])
        self.assertEqual(positive["checked"], 4096 * 4096)
        wrong_row = binary.with_name("llama_bounded_ops-wrong-row")
        self.assertTrue(wrong_row.is_file(), "prepare CPU binary with --mutation")
        mutation = subprocess.run(
            [str(wrong_row), *arguments],
            capture_output=True,
            text=True,
            timeout=120,
        )
        data = json.loads(mutation.stdout)
        # This variant inspects the actual upstream-quantized source bytes,
        # then rewrites indices only AFTER the unchanged CPU reference ran.
        self.assertEqual(data["quantized_unique_rows"], 1024)
        self.assertEqual(data["wrong_row_requests"], 2461)
        self.assertEqual(mutation.returncode, 2, mutation.stdout + mutation.stderr)
        self.assertFalse(data["pass"])
        self.assertGreater(data["bad"], 0)
        self.assertGreater(data["max_tolerance_ratio"], 1)
        self.assertEqual(data["reference_graph_invocations"], 1)
        self.assertEqual(data["checked"], positive["checked"])

    @unittest.skipUnless(
        os.environ.get("LLAMA_BENCHMARK_CPU_BINARY"), "prepare CPU binary first"
    )
    def test_native_final_missing_writes_reject_prior_good_sample(self):
        binary = Path(os.environ["LLAMA_BENCHMARK_CPU_BINARY"])
        for op, extra in (
            ("rope", []),
            ("rope", ["--neox"]),
            ("matvec-q4", []),
            ("gather-q8", []),
        ):
            for variant in ("noop", "partial"):
                with self.subTest(op=op, extra=extra, variant=variant):
                    process = subprocess.run(
                        [
                            str(binary.with_name("llama_bounded_ops-" + variant)),
                            op,
                            "--cpu",
                            "--tokens",
                            "1",
                            "--warmups",
                            "1",
                            "--samples",
                            "2",
                            *extra,
                        ],
                        capture_output=True,
                        text=True,
                        timeout=120,
                    )
                    data = json.loads(process.stdout)
                    # The mutation really computed and inspected an earlier
                    # valid sample, not just an output poisoned from startup.
                    self.assertIs(data.get("prior_sample_pass"), True)
                    self.assertEqual(data["completed_graph_invocations"], 2)
                    self.assertEqual(
                        process.returncode, 2, process.stdout + process.stderr
                    )
                    self.assertFalse(data["pass"])
                    written = data["checked"] // 2 if variant == "partial" else 0
                    self.assertEqual(data["bad"], data["checked"] - written)
                    self.assertEqual(data["graph_invocations"], 3)
                    self.assertEqual(data["reference_graph_invocations"], 1)
                    self.assertEqual(len(data["timings_ns"]), 2)

    @unittest.skipUnless(
        os.environ.get("LLAMA_BENCHMARK_CPU_BINARY"), "prepare CPU binary first"
    )
    def test_native_invalid_and_no_op_corruption(self):
        binary = os.environ["LLAMA_BENCHMARK_CPU_BINARY"]
        for args in (
            ["invalid"],
            ["rope", "--k", "3"],
            ["rope", "--k", "32769"],
            ["gather-q8", "--tokens", "32768", "--k", "32768"],
            ["matvec-q4", "--tokens", "2"],
            ["rope", "--samples", "0"],
            ["rope", "--warmups", "-1"],
            ["rope", "--samples", "2147483648"],
            ["rope", "--target", "gfx950"],
        ):
            p = subprocess.run([binary, *args, "--cpu"], capture_output=True, text=True)
            self.assertNotEqual(p.returncode, 0, args)
            self.assertFalse(p.stdout, args)
        # CPU-only controls fail correctness, not executable hash validation.
        mutation = str(Path(binary).with_name("llama_bounded_ops-noop"))
        modes = (
            ("rope", []),
            ("rope", ["--neox"]),
            ("matvec-q4", []),
            ("gather-q8", []),
        )
        for op, extra in modes:
            p = subprocess.run(
                [
                    mutation,
                    op,
                    "--cpu",
                    "--tokens",
                    "1",
                    "--warmups",
                    "1",
                    "--samples",
                    "2",
                    *extra,
                ],
                capture_output=True,
                text=True,
            )
            data = json.loads(p.stdout)
            self.assertEqual(p.returncode, 2)
            self.assertFalse(data["pass"])
            self.assertEqual(data["bad"], data["checked"])
            self.assertEqual(data["graph_invocations"], 3)
            self.assertEqual(data["reference_graph_invocations"], 1)
        corruption = str(Path(binary).with_name("llama_bounded_ops-corrupt"))
        for op, extra in modes:
            p = subprocess.run(
                [
                    corruption,
                    op,
                    "--cpu",
                    "--tokens",
                    "1",
                    "--warmups",
                    "1",
                    "--samples",
                    "2",
                    *extra,
                ],
                capture_output=True,
                text=True,
            )
            data = json.loads(p.stdout)
            self.assertEqual(p.returncode, 2)
            self.assertFalse(data["pass"])
            self.assertEqual(data["bad"], 1)
            self.assertEqual(data["graph_invocations"], 3)
            self.assertEqual(data["reference_graph_invocations"], 1)

    @unittest.skipUnless(
        os.environ.get("LLAMA_BENCHMARK_CPU_BINARY"), "prepare CPU binary first"
    )
    def test_selected_matvec_finite_packed_input_controls(self):
        binary = Path(os.environ["LLAMA_BENCHMARK_CPU_BINARY"])
        arguments = [
            "matvec-q4",
            "--cpu",
            "--k",
            "4096",
            "--rows",
            "32768",
            "--tokens",
            "1",
            "--warmups",
            "0",
            "--samples",
            "1",
        ]
        positive = subprocess.run(
            [str(binary), *arguments], capture_output=True, text=True, timeout=120
        )
        self.assertEqual(positive.returncode, 0, positive.stdout + positive.stderr)
        for mode in ("drop-last-block", "swap-nibbles", "unsigned-activation"):
            with self.subTest(mode=mode):
                process = subprocess.run(
                    [str(binary.with_name("llama_bounded_ops-wrong-row")), *arguments],
                    env={**os.environ, "LLAMA_TEST_MATVEC_MUTATION": mode},
                    capture_output=True,
                    text=True,
                    timeout=120,
                )
                data = json.loads(process.stdout)
                self.assertEqual(data["matvec_mutation"], mode)
                self.assertGreater(data["q8_1_negative_values"], 0)
                self.assertGreater(data["q8_1_positive_values"], 0)
                self.assertEqual(data["q8_1_reconstruction_max_error"], 0)
                self.assertEqual(data["nonfinite_outputs"], 0)
                self.assertEqual(process.returncode, 2, process.stdout + process.stderr)
                self.assertFalse(data["pass"])
                self.assertGreater(data["bad"], 0)
                self.assertGreater(data["max_tolerance_ratio"], 1)
                self.assertEqual(data["reference_graph_invocations"], 1)
                self.assertEqual(data["graph_invocations"], 1)
                self.assertEqual(data["checked"], 32768)
                self.assertEqual((data["atol"], data["rtol"]), (0.03, 0.02))


if __name__ == "__main__":
    unittest.main()
