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
            "with Path(os.environ['HEADER_CHECK_COMMAND']).open('a') as log:\n"
            "    log.write(json.dumps(sys.argv[1:]) + '\\n')\n",
        )
        self.compiler.chmod(0o755)
        self.log = self.root / "command.json"

    def write(self, name, content):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)
        return path

    def check(self, header, *arguments):
        self.log.unlink(missing_ok=True)
        return subprocess.run(
            [
                sys.executable,
                str(self.root / "scripts/check_helper_headers.py"),
                "--header",
                header,
                "--jobs",
                "1",
                "--host-cxx",
                str(self.compiler),
                *map(str, arguments),
            ],
            env={**os.environ, "HEADER_CHECK_COMMAND": str(self.log)},
            capture_output=True,
            text=True,
        )

    def command(self):
        return self.commands()[0]

    def commands(self):
        return [json.loads(line) for line in self.log.read_text().splitlines()]

    def test_semantics_ignores_unrelated_inputs_and_host_compiler(self):
        header = "corpus/semantics/gfx1250/include/test_support.hpp"
        self.write(header, "#include <hip/hip_runtime.h>\n")
        result = self.check(
            header,
            "--rocm-path",
            self.root / "sdk",
            "--gtest-include",
            self.root / "missing-gtest",
            "--runtime-kernel-dir",
            self.root / "missing-payload",
            "--host-cxx",
            "missing-host-compiler",
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
        hip, host = self.commands()
        self.assertIn("-std=gnu++17", hip)
        self.assertIn("-std=c++17", host)
        for command in (hip, host):
            self.assertIn("-Icorpus/cts/support", command)
            self.assertIn("-Icorpus/cts/third_party/hip-fpsan/include", command)
            self.assertNotIn("-Icorpus/semantics/gfx1250/include", command)

    def test_transitive_gtest_dependency_is_required(self):
        header = "corpus/cts/test_cases/general/helper.hpp"
        self.write(header, '#include "hip_test_utils.hpp"\n')
        self.write(
            "corpus/cts/support/hip_test_utils.hpp", "#include <gtest/gtest.h>\n"
        )
        result = self.check(header, "--rocm-path", self.root / "sdk")
        self.assertEqual(result.returncode, 2)
        self.assertIn("--gtest-include is required", result.stderr)
        self.assertFalse(self.log.exists())
        gtest = self.write("gtest/gtest/gtest.h", "").parents[1]
        result = self.check(
            header, "--rocm-path", self.root / "sdk", "--gtest-include", gtest
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(f"-I{gtest}", self.command())

    def test_runtime_header_needs_no_hip_toolchain_or_payload(self):
        header = "corpus/runtime-cts/common/test.h"
        self.write(header, "#include <cstdint>\n")
        result = self.check(
            header, "--host-cxx", self.compiler, "--hip-cxx", "missing-hip"
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("-std=c++17", self.command())
        self.assertNotIn("hip", self.command())

    def test_transitive_payload_dependency_is_required_and_validated(self):
        header = "corpus/runtime-cts/common/support/wrapper.h"
        self.write(header, '#include "support/aql_payload.h"\n')
        self.write(
            "corpus/runtime-cts/common/support/aql_payload.h",
            '#include "payload_kernel.inc"\n',
        )
        result = self.check(header, "--host-cxx", self.compiler)
        self.assertEqual(result.returncode, 2)
        self.assertIn("--runtime-kernel-dir is required", result.stderr)
        payload_dir = self.root / "payload"
        result = self.check(
            header, "--host-cxx", self.compiler, "--runtime-kernel-dir", payload_dir
        )
        self.assertEqual(result.returncode, 2)
        self.assertIn("required input does not exist", result.stderr)
        self.write("payload/payload_kernel.inc", "")
        result = self.check(
            header, "--host-cxx", self.compiler, "--runtime-kernel-dir", payload_dir
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(f"-I{payload_dir}", self.command())

    def test_race_uses_only_its_own_root(self):
        header = "corpus/race/integration/race_log_expectation.hpp"
        self.write(header, "#include <string>\n")
        result = self.check(header, "--rocm-path", self.root / "sdk")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("-std=gnu++20", self.command())
        self.assertIn("-Icorpus/race/integration", self.command())
        self.assertNotIn("-Icorpus/cts/support", self.command())

    def test_host_helpers_compile_without_hip_runtime_or_flags(self):
        for header, standard in (
            ("corpus/cts/support/fpsan_generic.hpp", "c++17"),
            ("corpus/cts/support/fpsan_semantics.hpp", "c++17"),
            ("corpus/cts/support/parity_ops.hpp", "c++17"),
            ("corpus/cts/support/test_random.hpp", "c++17"),
            ("corpus/cts/support/test_utils.hpp", "c++17"),
            ("corpus/race/integration/race_log_expectation.hpp", "c++20"),
        ):
            with self.subTest(header=header):
                self.write(header, "")
                result = self.check(
                    header,
                    "--rocm-path",
                    self.root / "sdk",
                    "--hip-include",
                    self.root / "hip-only-includes",
                )
                self.assertEqual(result.returncode, 0, result.stderr)
                hip, host = self.commands()
                self.assertIn("hip", hip)
                self.assertIn("c++", host)
                self.assertIn(f"-std={standard}", host)
                self.assertFalse(
                    any(
                        flag.startswith(
                            ("--rocm-path=", "--hip-path=", "--offload-arch=")
                        )
                        for flag in host
                    )
                )
                self.assertNotIn("hip", host)
                self.assertNotIn(str(self.root / "hip-only-includes"), host)
                self.assertNotIn("-idirafter", host)
                self.assertIn(f"{header} [c++ {standard}]", result.stdout)
                self.assertIn(
                    "1 helper headers: 2/2 configurations passed", result.stdout
                )

    def test_host_helper_requires_executable_host_compiler(self):
        header = "corpus/race/integration/race_log_expectation.hpp"
        self.write(header, "")
        result = self.check(
            header,
            "--rocm-path",
            self.root / "sdk",
            "--host-cxx",
            "missing-host-compiler",
        )
        self.assertEqual(result.returncode, 2)
        self.assertIn("host compiler must be executable", result.stderr)
        self.assertFalse(self.log.exists())

    def test_host_failure_fails_even_when_hip_passes(self):
        header = "corpus/race/integration/race_log_expectation.hpp"
        self.write(header, "")
        self.compiler.write_text(
            "#!/usr/bin/env python3\n"
            "import sys\n"
            "if 'c++' in sys.argv:\n"
            "    print('missing host declaration', file=sys.stderr)\n"
            "    sys.exit(1)\n"
        )
        result = self.check(header, "--rocm-path", self.root / "sdk")
        self.assertEqual(result.returncode, 1)
        self.assertIn(f"PASS {header} [hip gnu++20 gfx950]", result.stdout)
        self.assertIn(f"FAIL {header} [c++ c++20]", result.stdout)
        self.assertIn("missing host declaration", result.stdout)
        self.assertIn("1 helper headers: 1/2 configurations passed", result.stdout)

    def test_shared_wave64_helpers_check_both_variants(self):
        for header, target, definitions in (
            (
                "corpus/cts/test_cases/rdna3/fpsan/wmma_gfx11_parts.hpp",
                "gfx1151",
                ("FPSAN_TEST_GFX11_WAVE64=1",),
            ),
            (
                "corpus/cts/test_cases/rdna4/fpsan/wmma_gfx12_parts.hpp",
                "gfx1201",
                ("FPSAN_TEST_GFX12_WAVE64=1", "FPSAN_TEST_FORCE_WAVE_SIZE=64"),
            ),
            (
                "corpus/cts/test_cases/general/int_isa/matrix_test_parts.hpp",
                "gfx1201",
                ("INT_ISA_TEST_WAVE64=1",),
            ),
            (
                "corpus/cts/support/wave_test_harness.hpp",
                "gfx1201",
                ("INT_ISA_TEST_WAVE64=1",),
            ),
        ):
            with self.subTest(header=header):
                self.write(header, "")
                result = self.check(header, "--rocm-path", self.root / "sdk")
                self.assertEqual(result.returncode, 0, result.stderr)
                default, wave64 = self.commands()
                self.assertNotIn("-mwavefrontsize64", default)
                self.assertIn("-mwavefrontsize64", wave64)
                self.assertIn(f"--offload-arch={target}", wave64)
                self.assertIn("-std=gnu++17", wave64)
                for definition in definitions:
                    self.assertNotIn(f"-D{definition}", default)
                    self.assertIn(f"-D{definition}", wave64)
                self.assertIn(f"hip gnu++17 {target} wave64", result.stdout)

    def test_wave64_failure_fails_even_when_default_passes(self):
        header = "corpus/cts/support/wave_test_harness.hpp"
        self.write(header, "")
        self.compiler.write_text(
            "#!/usr/bin/env python3\n"
            "import sys\n"
            "if '-DINT_ISA_TEST_WAVE64=1' in sys.argv:\n"
            "    print('wave64 branch error', file=sys.stderr)\n"
            "    sys.exit(1)\n"
        )
        result = self.check(header, "--rocm-path", self.root / "sdk")
        self.assertEqual(result.returncode, 1)
        self.assertIn(f"PASS {header} [hip gnu++17 gfx950]", result.stdout)
        self.assertIn(f"FAIL {header} [hip gnu++17 gfx1201 wave64]", result.stdout)
        self.assertIn("wave64 branch error", result.stdout)
        self.assertIn("1 helper headers: 1/2 configurations passed", result.stdout)

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

    def test_compile_failure_reports_command_and_source(self):
        header = "corpus/cts/support/hip_test_utils.hpp"
        self.write(header, "")
        self.compiler.write_text(
            "#!/usr/bin/env python3\n"
            "import sys\n"
            "print('synthetic compile failure', file=sys.stderr)\n"
            "sys.exit(1)\n"
        )
        result = self.check(header, "--rocm-path", self.root / "sdk")
        self.assertEqual(result.returncode, 1)
        self.assertIn(f"FAIL {header}", result.stdout)
        self.assertIn("-std=gnu++17", result.stdout)
        self.assertIn(f'#include "{header}"', result.stdout)
        self.assertIn("synthetic compile failure", result.stdout)
        self.assertIn("1 helper headers: 0/1 configurations passed", result.stdout)


if __name__ == "__main__":
    unittest.main()
