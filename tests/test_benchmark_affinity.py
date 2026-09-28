#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

from pathlib import Path
import tempfile
import unittest

from benchmarks import affinity as HELPER


class AffinityTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.sysfs = self.root / "cpu"
        self.cpuinfo = self.root / "cpuinfo"
        self.cpuinfo.write_text("model name\t: Test CPU\n")
        for cpu in range(32):
            group = "0-15" if cpu < 16 else "16-31"
            base = 0 if cpu < 16 else 16
            core = cpu % 8 + base
            self.make_cpu(cpu, core, group, f"{core},{core + 8}")

    def make_cpu(self, cpu, core, group, siblings):
        root = self.sysfs / f"cpu{cpu}"
        for filename, value in {
            "topology/physical_package_id": "0",
            "topology/core_id": str(core),
            "topology/thread_siblings_list": siblings,
            "cache/index3/level": "3",
            "cache/index3/type": "Unified",
            "cache/index3/shared_cpu_list": group,
        }.items():
            path = root / filename
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(value)

    def select(self, allowed):
        return HELPER.select_cpus(HELPER.read_topology(allowed, self.sysfs))

    def test_deterministic_group_and_no_smt_siblings(self):
        self.assertEqual(self.select(reversed(range(32))), list(range(8)))

    def test_sparse_mask_and_siblings_outside_affinity(self):
        allowed = [0, 2, 4, 6, 9, 11, 13, 15]
        self.assertEqual(self.select(allowed), allowed)

    def test_skips_group_with_too_few_physical_cores(self):
        self.assertEqual(
            self.select([0, 1, 8, 9] + list(range(16, 32))), list(range(16, 24))
        )

    def test_no_cross_cache_fallback(self):
        with self.assertRaisesRegex(ValueError, "eight allowed physical cores"):
            self.select([0, 1, 2, 3, 16, 17, 18, 19])

    def test_smt_does_not_count_as_additional_core(self):
        with self.assertRaises(ValueError):
            self.select([0, 1, 2, 3, 8, 9, 10, 11])

    def test_missing_topology_fails(self):
        (self.sysfs / "cpu0/topology/core_id").unlink()
        with self.assertRaises(OSError):
            HELPER.discover(range(16), self.sysfs, self.cpuinfo)

    def test_missing_l3_fails(self):
        (self.sysfs / "cpu0/cache/index3/level").write_text("2")
        with self.assertRaisesRegex(ValueError, "shared L3"):
            self.select(range(16))

    def test_records_governor_when_available(self):
        path = self.sysfs / "cpu0/cpufreq/scaling_governor"
        path.parent.mkdir()
        path.write_text("performance\n")
        records = HELPER.read_topology([0], self.sysfs)
        self.assertEqual(records[0]["governor"], "performance")

    def test_repeated_core_ids_in_different_packages(self):
        for cpu in range(4, 8):
            topology = self.sysfs / f"cpu{cpu}/topology"
            (topology / "physical_package_id").write_text("1")
            (topology / "core_id").write_text(str(cpu - 4))
        self.assertEqual(self.select(range(8)), list(range(8)))

    def test_metadata(self):
        metadata = HELPER.discover(range(16), self.sysfs, self.cpuinfo)
        self.assertEqual(metadata["selected_cpus"], list(range(8)))
        self.assertEqual(metadata["allowed_cpus"], list(range(16)))
        self.assertEqual(metadata["cpu_models"], ["Test CPU"])
        self.assertEqual(metadata["cpu_topology"][0]["smt_siblings"], [0, 8])
        self.assertEqual(metadata["cpu_topology"][0]["governor"], "unknown")

    def test_cpu_list_ranges(self):
        self.assertEqual(HELPER.cpu_list("0-2,8,11-12\n"), [0, 1, 2, 8, 11, 12])
        with self.assertRaises(ValueError):
            HELPER.cpu_list("8-2")


if __name__ == "__main__":
    unittest.main()
