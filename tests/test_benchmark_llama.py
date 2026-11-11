"""Host-only native adapter tests. Set LLAMA_BENCHMARK_CPU_BINARY after preparation."""

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
                    "-qm",
                    "fixture",
                ],
                check=True,
            )
            with self.assertRaises(ValueError):
                prepare.verify_source(path)
            with self.assertRaises(ValueError):
                prepare.check_build_path(path, path / "build")

    def test_binary_receipt_rejects_tampering(self):
        import hashlib
        import tempfile
        from corpus.benchmarks.llama import workloads as w

        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)
            binary = path / "bounded-ops"
            binary.write_bytes(b"explicit unit-test binary fixture, not executable")
            receipt = dict(
                source_pin=w.PIN,
                backend="cpu",
                targets=[],
                binary_sha256=hashlib.sha256(binary.read_bytes()).hexdigest(),
            )
            (path / "benchmark-build.json").write_text(json.dumps(receipt))
            w.verify_binary(binary, cpu=True, target="gfx1100")
            with self.assertRaises(ValueError):
                w.verify_binary(binary, cpu=False, target="gfx1100")
            binary.write_bytes(b"corrupted fixture")
            with self.assertRaises(ValueError):
                w.verify_binary(binary, cpu=True, target="gfx1100")

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
        self.assertTrue(result.stderr.startswith("usage: bounded-ops "))
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
            self.assertEqual(data["parameters"], {**params, "dtype": "fp32"})
            self.assertEqual(len(data["timings_ns"]), 2)
            self.assertTrue(all(type(t) is int and t > 0 for t in data["timings_ns"]))

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
        self.assertEqual(result["parameters"], params)
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
    def test_native_invalid_and_no_op_corruption(self):
        binary = os.environ["LLAMA_BENCHMARK_CPU_BINARY"]
        for args in (
            ["invalid"],
            ["rope", "--k", "3"],
            ["gather-q8", "--tokens", "32768", "--k", "32768"],
            ["matvec-q4", "--tokens", "2"],
            ["rope", "--samples", "0"],
            ["rope", "--warmups", "-1"],
            ["rope", "--samples", "101"],
            ["rope", "--target", "gfx950"],
        ):
            p = subprocess.run([binary, *args, "--cpu"], capture_output=True, text=True)
            self.assertNotEqual(p.returncode, 0, args)
            self.assertFalse(p.stdout, args)
        # Dedicated CPU-only mutation compiled by prepare --mutation; never accepted by the wrapper.
        mutation = str(Path(binary).with_name("bounded-ops-noop"))
        for op in ("rope", "matvec-q4", "gather-q8"):
            p = subprocess.run(
                [mutation, op, "--cpu", "--tokens", "1"], capture_output=True, text=True
            )
            data = json.loads(p.stdout)
            self.assertEqual(p.returncode, 2)
            self.assertFalse(data["pass"])
            self.assertEqual(data["bad"], data["checked"])
        corruption = str(Path(binary).with_name("bounded-ops-corrupt"))
        for op in ("rope", "matvec-q4", "gather-q8"):
            p = subprocess.run(
                [corruption, op, "--cpu", "--tokens", "1"],
                capture_output=True,
                text=True,
            )
            data = json.loads(p.stdout)
            self.assertEqual(p.returncode, 2)
            self.assertFalse(data["pass"])
            self.assertEqual(data["bad"], 1)


if __name__ == "__main__":
    unittest.main()
