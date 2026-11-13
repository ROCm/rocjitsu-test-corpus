# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Bounded host-only subprocess and preparation interface regressions."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class LlamaDiagnosticsTests(unittest.TestCase):
    def test_native_failure_preserves_both_streams_without_success_output(self):
        from corpus.benchmarks.llama.workloads import PIN

        diagnostics = '{"bad":7,"max_abs_error":0.5,"max_tolerance_ratio":4,"atol":0.01,"rtol":0.02}'
        for stdout in (diagnostics, "malformed native output", ""):
            with self.subTest(
                stdout=stdout
            ), tempfile.TemporaryDirectory() as directory:
                path = Path(directory)
                binary = path / "llama_bounded_ops"
                binary.write_text(
                    f"#!{sys.executable}\nimport sys\n"
                    f"sys.stdout.write({stdout!r})\n"
                    "sys.stderr.write('native stderr marker\\n')\n"
                    "sys.exit(2)\n"
                )
                binary.chmod(0o755)
                (path / "benchmark-build.json").write_text(
                    json.dumps(
                        dict(
                            source_pin=PIN,
                            backend="cpu",
                            targets=[],
                            adapter_sha256=hashlib.sha256(
                                (
                                    ROOT / "corpus/benchmarks/llama/runner.cpp"
                                ).read_bytes()
                            ).hexdigest(),
                        )
                    )
                )
                for output in ("-", str(path / "result.json")):
                    result = subprocess.run(
                        [
                            sys.executable,
                            "-m",
                            "corpus.benchmarks.llama.workloads",
                            "--workload",
                            "llama_rope",
                            "--params",
                            '{"k":128,"heads":1,"tokens":32}',
                            "--case",
                            "fixture",
                            "--target",
                            "gfx1100",
                            "--cpu",
                            "--binary",
                            str(binary),
                            "--output",
                            output,
                        ],
                        cwd=ROOT,
                        capture_output=True,
                        text=True,
                        timeout=15,
                    )
                    self.assertNotEqual(result.returncode, 0)
                    self.assertEqual(result.stdout, "")
                    self.assertIn("native stderr marker", result.stderr)
                    self.assertIn("exit status 2", result.stderr)
                    if stdout:
                        self.assertIn(stdout, result.stderr)
                    self.assertFalse((path / "result.json").exists())

    def test_zero_exit_requires_valid_native_result_and_preserves_success_schema(self):
        from corpus.benchmarks.llama.workloads import PIN

        native = dict(
            source_pin=PIN,
            backend="CPU",
            op="rope",
            k=128,
            heads=1,
            tokens=32,
            checked=4096,
            bad=0,
            warmups=0,
            graph_invocations=1,
            timings_ns=[17],
            **{"pass": True},
        )
        for stdout in (json.dumps(native), "malformed native output", ""):
            with self.subTest(
                stdout=stdout
            ), tempfile.TemporaryDirectory() as directory:
                path = Path(directory)
                binary = path / "llama_bounded_ops"
                binary.write_text(f"#!{sys.executable}\nprint({stdout!r})\n")
                binary.chmod(0o755)
                (path / "benchmark-build.json").write_text(
                    json.dumps(
                        dict(
                            source_pin=PIN,
                            backend="cpu",
                            targets=[],
                            adapter_sha256=hashlib.sha256(
                                (
                                    ROOT / "corpus/benchmarks/llama/runner.cpp"
                                ).read_bytes()
                            ).hexdigest(),
                        )
                    )
                )
                for output in ("-", str(path / "result.json")):
                    result = subprocess.run(
                        [
                            sys.executable,
                            "-m",
                            "corpus.benchmarks.llama.workloads",
                            "--workload",
                            "llama_rope",
                            "--params",
                            '{"k":128,"heads":1,"tokens":32}',
                            "--case",
                            "fixture",
                            "--target",
                            "gfx1100",
                            "--cpu",
                            "--binary",
                            str(binary),
                            "--output",
                            output,
                        ],
                        cwd=ROOT,
                        capture_output=True,
                        text=True,
                        timeout=15,
                    )
                    if stdout != json.dumps(native):
                        self.assertNotEqual(result.returncode, 0)
                        self.assertEqual(result.stdout, "")
                        self.assertFalse((path / "result.json").exists())
                        continue
                    self.assertEqual(result.returncode, 0, result.stderr)
                    self.assertEqual(result.stderr, "")
                    data = json.loads(
                        result.stdout
                        if output == "-"
                        else (path / "result.json").read_text()
                    )
                    self.assertEqual(
                        data,
                        dict(
                            schema="rocjitsu.benchmark.workload.v1",
                            case="fixture",
                            target="gfx1100",
                            provider="llama",
                            timings_ns=[17],
                            parameters=dict(
                                k=128, heads=1, tokens=32, dtype="fp32", source_pin=PIN
                            ),
                        ),
                    )
                    if output != "-":
                        self.assertEqual(result.stdout, "")


class BenchmarkParameterDocumentationTests(unittest.TestCase):
    def test_full_tensile_rejects_toml_only_shape_edits(self):
        from corpus.benchmarks.full_tensile.prepare import CASES, validate_parameters

        self.assertEqual(set(CASES), {"valu", "tensor", "splitk", "pointer"})
        for variant, params in CASES.items():
            for target in ("gfx1100", "gfx1201"):
                with self.subTest(variant=variant, target=target):
                    self.assertEqual(validate_parameters(params, target), variant)
                    with self.assertRaises(ValueError):
                        validate_parameters(
                            {**params, "k": int(params["k"]) + 32}, target
                        )

    def test_new_workload_rows_link_to_owners_and_state_bounds(self):
        text = (ROOT / "benchmarks/README.md").read_text()
        rows = {
            line.split("|")[1].strip().strip("`"): line
            for line in text.splitlines()
            if line.startswith("| `")
        }
        expected = {
            "gluon_copy": ("elements", "134217728", "gluon/README.md"),
            "gluon_copy_2d": ("rows", "columns", "134217728", "gluon/README.md"),
            "llama_rope": ("k", "heads", "tokens", "32768", "even", "llama/README.md"),
            "llama_matvec": ("k", "rows", "tokens", "32768", "32", "llama/README.md"),
            "llama_gather": ("k", "rows", "tokens", "32768", "32", "llama/README.md"),
            "full_tensile": ("four fixed", "full_tensile/README.md"),
        }
        for workload, terms in expected.items():
            with self.subTest(workload=workload):
                self.assertIn(workload, rows)
                for term in (*terms, "fp32"):
                    self.assertIn(term, rows[workload])
        self.assertIn("Input acceptance is not qualification", text)
        self.assertIn(
            "Editing a full-Tensile shape in TOML alone is not supported", text
        )
        self.assertIn("k * heads * tokens", text)
        self.assertIn("k * rows", text)
        self.assertIn("k * tokens", text)
        for provider in ("gluon", "llama", "full_tensile"):
            self.assertTrue(
                (ROOT / "corpus/benchmarks" / provider / "README.md").is_file()
            )


class LlamaCMakeTargetTests(unittest.TestCase):
    def test_ggml_sees_explicit_targets_before_hip_discovery(self):
        import shutil

        self.assertIsNotNone(
            shutil.which("cmake"), "CMake required for configure fixture"
        )
        for hip, architectures in (
            (True, "gfx1100"),
            (True, "gfx1201"),
            (True, "gfx1100;gfx1201"),
            (False, "gfx1100"),
        ):
            with self.subTest(
                hip=hip, architectures=architectures
            ), tempfile.TemporaryDirectory() as directory:
                path = Path(directory)
                source = path / "llama"
                (source / "ggml").mkdir(parents=True)
                (source / "ggml" / "CMakeLists.txt").write_text(
                    'file(WRITE "${CMAKE_BINARY_DIR}/seen-targets" "${GPU_TARGETS}")\n'
                    "add_library(ggml INTERFACE)\n"
                )
                sdk = path / "sdk"
                sdk.mkdir()
                (sdk / "hip-config.cmake").write_text(
                    "add_library(hip::host INTERFACE IMPORTED)\n"
                )
                build = path / "build"
                result = subprocess.run(
                    [
                        "cmake",
                        "-S",
                        str(ROOT / "corpus/benchmarks/llama"),
                        "-B",
                        str(build),
                        f"-DLLAMA_SOURCE_DIR={source}",
                        f"-DGGML_HIP={'ON' if hip else 'OFF'}",
                        f"-DCMAKE_HIP_ARCHITECTURES={architectures}",
                        "-DGPU_TARGETS=stale-fixture-target",
                        f"-Dhip_DIR={sdk}",
                    ],
                    capture_output=True,
                    text=True,
                    timeout=30,
                )
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assertEqual(
                    (build / "seen-targets").read_text(),
                    architectures if hip else "stale-fixture-target",
                )


class LlamaSigningFixtureTests(unittest.TestCase):
    def test_preparation_fixture_ignores_child_only_rejecting_signer(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)
            marker = path / "signer-called"
            signer = path / "reject-signing"
            signer.write_text(
                f"#!{sys.executable}\nfrom pathlib import Path\n"
                f"Path({str(marker)!r}).write_text('called')\nraise SystemExit(1)\n"
            )
            signer.chmod(0o755)
            env = {
                key: value
                for key, value in os.environ.items()
                if not key.startswith("GIT_CONFIG_")
            }
            env.update(
                GIT_CONFIG_NOSYSTEM="1",
                GIT_CONFIG_GLOBAL=os.devnull,
                GIT_CONFIG_COUNT="2",
                GIT_CONFIG_KEY_0="commit.gpgsign",
                GIT_CONFIG_VALUE_0="true",
                GIT_CONFIG_KEY_1="gpg.program",
                GIT_CONFIG_VALUE_1=str(signer),
            )
            enabled = subprocess.run(
                ["git", "config", "--get", "commit.gpgsign"],
                env=env,
                capture_output=True,
                text=True,
                check=True,
            )
            self.assertEqual(enabled.stdout.strip(), "true")
            result = subprocess.run(
                [
                    sys.executable,
                    "-m",
                    "pytest",
                    "-q",
                    "tests/test_benchmark_llama.py::LlamaContractTests::"
                    "test_preparation_rejects_wrong_pin_and_in_source_build",
                ],
                cwd=ROOT,
                env=env,
                capture_output=True,
                text=True,
                timeout=30,
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertFalse(marker.exists(), "fixture must not invoke a signer")


if __name__ == "__main__":
    unittest.main()
