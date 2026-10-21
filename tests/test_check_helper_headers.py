# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
from __future__ import annotations

import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]


class HelperHeaderCheckTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.write("scripts/check_helper_headers.py", "")
        shutil.copyfile(
            ROOT / "scripts/check_helper_headers.py",
            self.root / "scripts/check_helper_headers.py",
        )
        self.write("sdk/include/hip/hip_runtime.h", "")
        self.compiler = self.write(
            "sdk/bin/amdclang++",
            "#!/usr/bin/env python3\n"
            "import json, os, sys\n"
            "from pathlib import Path\n"
            "Path(os.environ['HEADER_CHECK_COMMAND']).write_text(\n"
            "    json.dumps(sys.argv[1:]))\n",
        )
        self.compiler.chmod(0o755)
        self.log = self.root / "command.json"

    def write(self, name, content):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)
        return path

    def check(self, header, *arguments):
        return subprocess.run(
            [
                sys.executable,
                str(self.root / "scripts/check_helper_headers.py"),
                "--header",
                header,
                *map(str, arguments),
            ],
            env={**os.environ, "HEADER_CHECK_COMMAND": str(self.log)},
            capture_output=True,
            text=True,
        )

    def command(self):
        return json.loads(self.log.read_text())

    def test_semantics_ignores_unrelated_inputs_and_host_compiler(self):
        header = "corpus/semantics/gfx1250/include/test_support.hpp"
        self.write(header, "#include <hip/hip_runtime.h>\n")
        result = self.check(
            header,
            "--rocm-path", self.root / "sdk",
            "--gtest-include", self.root / "missing-gtest",
            "--runtime-kernel-dir", self.root / "missing-payload",
            "--host-cxx", "missing-host-compiler",
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        command = self.command()
        self.assertIn("-std=c++20", command)
        self.assertIn("--offload-arch=gfx1250", command)
        self.assertIn("-Icorpus/semantics/gfx1250/include", command)
        self.assertFalse(any("gtest" in flag or "payload" in flag for flag in command))
        self.assertNotIn("-Icorpus/cts/support", command)

    def test_cts_uses_gnu_cpp17_and_its_own_roots(self):
        header = "corpus/cts/support/test_utils.hpp"
        self.write(header, "#include <cstdint>\n")
        result = self.check(header, "--rocm-path", self.root / "sdk")
        self.assertEqual(result.returncode, 0, result.stderr)
        command = self.command()
        self.assertIn("-std=gnu++17", command)
        self.assertIn("-Icorpus/cts/support", command)
        self.assertIn("-Icorpus/cts/third_party/hip-fpsan/include", command)
        self.assertNotIn("-Icorpus/semantics/gfx1250/include", command)

    def test_transitive_gtest_dependency_is_required(self):
        header = "corpus/cts/test_cases/general/helper.hpp"
        self.write(header, '#include "hip_test_utils.hpp"\n')
        self.write("corpus/cts/support/hip_test_utils.hpp", "#include <gtest/gtest.h>\n")
        result = self.check(header, "--rocm-path", self.root / "sdk")
        self.assertEqual(result.returncode, 2)
        self.assertIn("--gtest-include is required", result.stderr)
        self.assertFalse(self.log.exists())
        gtest = self.write("gtest/gtest/gtest.h", "").parents[1]
        result = self.check(header, "--rocm-path", self.root / "sdk", "--gtest-include", gtest)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(f"-I{gtest}", self.command())

    def test_runtime_header_needs_no_hip_toolchain_or_payload(self):
        header = "corpus/runtime-cts/common/test.h"
        self.write(header, "#include <cstdint>\n")
        result = self.check(header, "--host-cxx", self.compiler, "--hip-cxx", "missing-hip")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("-std=c++17", self.command())
        self.assertNotIn("hip", self.command())

    def test_transitive_payload_dependency_is_required_and_validated(self):
        header = "corpus/runtime-cts/common/support/wrapper.h"
        self.write(header, '#include "support/aql_payload.h"\n')
        self.write("corpus/runtime-cts/common/support/aql_payload.h", '#include "payload_kernel.inc"\n')
        result = self.check(header, "--host-cxx", self.compiler)
        self.assertEqual(result.returncode, 2)
        self.assertIn("--runtime-kernel-dir is required", result.stderr)
        payload_dir = self.root / "payload"
        result = self.check(header, "--host-cxx", self.compiler, "--runtime-kernel-dir", payload_dir)
        self.assertEqual(result.returncode, 2)
        self.assertIn("required input does not exist", result.stderr)
        self.write("payload/payload_kernel.inc", "")
        result = self.check(header, "--host-cxx", self.compiler, "--runtime-kernel-dir", payload_dir)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(f"-I{payload_dir}", self.command())

    def test_race_uses_only_its_own_root(self):
        header = "corpus/race/integration/race_log_expectation.hpp"
        self.write(header, "#include <string>\n")
        result = self.check(header, "--rocm-path", self.root / "sdk")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("-std=c++20", self.command())
        self.assertIn("-Icorpus/race/integration", self.command())
        self.assertNotIn("-Icorpus/cts/support", self.command())

    def test_cts_wave64_target_is_preserved(self):
        header = "corpus/cts/test_cases/rdna4/fpsan/swmmac_gfx12_w64_parts.hpp"
        self.write(header, "")
        result = self.check(header, "--rocm-path", self.root / "sdk")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("--offload-arch=gfx1201", self.command())
        self.assertIn("-mwavefrontsize64", self.command())

    def test_unknown_header_is_reported_before_missing_dependencies(self):
        result = self.check("corpus/cts/missing.hpp")
        self.assertEqual(result.returncode, 2)
        self.assertIn("unknown helper headers", result.stderr)
        self.assertFalse(self.log.exists())


if __name__ == "__main__":
    unittest.main()
