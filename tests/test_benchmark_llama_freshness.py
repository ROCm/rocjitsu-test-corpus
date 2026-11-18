# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Source freshness is checked before launching a caller-selected executable."""

import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from corpus.benchmarks.llama import workloads

ROOT = Path(__file__).resolve().parents[1]
ADAPTER = ROOT / "corpus/benchmarks/llama/runner.cpp"


class LlamaFreshnessTests(unittest.TestCase):
    def run_fixture(self, adapter_hash):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)
            marker = path / "launched"
            binary = path / "llama_bounded_ops"
            native = dict(
                source_pin=workloads.PIN,
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
            binary.write_text(
                f"#!{sys.executable}\nfrom pathlib import Path\n"
                f"Path({str(marker)!r}).write_text('launched')\n"
                f"print({json.dumps(native)!r})\n"
            )
            binary.chmod(0o755)
            receipt = dict(source_pin=workloads.PIN, backend="cpu", targets=[])
            if adapter_hash is not None:
                receipt["adapter_sha256"] = adapter_hash
            (path / "benchmark-build.json").write_text(json.dumps(receipt))
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
                    "freshness",
                    "--target",
                    "gfx1100",
                    "--cpu",
                    "--binary",
                    str(binary),
                ],
                cwd=ROOT,
                capture_output=True,
                text=True,
                timeout=15,
            )
            return result, marker.exists()

    def test_stale_adapter_rejected_before_child_execution(self):
        # Positive control: this exact child can execute and return valid output.
        good, launched = self.run_fixture(
            hashlib.sha256(ADAPTER.read_bytes()).hexdigest()
        )
        self.assertEqual(good.returncode, 0, good.stderr)
        self.assertTrue(launched)
        stale, launched = self.run_fixture("0" * 64)
        self.assertNotEqual(stale.returncode, 0)
        self.assertFalse(launched)
        self.assertEqual(stale.stdout, "")
        self.assertIn("adapter", stale.stderr)
        self.assertIn("rebuild", stale.stderr.lower())
        self.assertIn("prepare.py", stale.stderr)

    def test_missing_adapter_hash_requires_rebuild_before_launch(self):
        result, launched = self.run_fixture(None)
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(launched)
        self.assertEqual(result.stdout, "")
        self.assertIn("missing", result.stderr)
        self.assertIn("prepare.py", result.stderr)
        self.assertIn("do not regenerate the receipt without rebuilding", result.stderr)

    def test_comment_only_source_change_is_stale(self):
        old_source = ADAPTER.read_bytes() + b"\n// different adapter comment\n"
        result, launched = self.run_fixture(hashlib.sha256(old_source).hexdigest())
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(launched)
        self.assertIn("hash mismatch", result.stderr)


if __name__ == "__main__":
    unittest.main()
