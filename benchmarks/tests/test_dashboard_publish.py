# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

from __future__ import annotations

import contextlib
import io
import json
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from benchmarks import dashboard_publish as publisher


class DashboardPublishTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.data = self.root / "public" / "data"

    @staticmethod
    def _test(
        logical_id: str = "triton.copy_fp32_32m",
        *,
        target: str = "gfx950",
        problem: dict[str, object] | None = None,
        status: str = "completed",
    ) -> dict[str, object]:
        timed_out = status == "timeout"
        return {
            "testId": f"{target}:{logical_id}",
            "logicalTestId": logical_id,
            "suite": "Triton",
            "name": "32 MiB contiguous FP32 copy",
            "target": target,
            "operation": "Copy",
            "dataType": "fp32",
            "problem": {"elements": 8_388_608} if problem is None else problem,
            "execMode": "functional",
            "numThreads": 1,
            "durationSeconds": 0.00125 if status == "completed" else None,
            "timing": {
                "unit": "ns",
                "samples": [1_200_000, 1_250_000, 1_300_000],
                "minimum": 1_200_000,
                "median": 1_250_000,
                "maximum": 1_300_000,
            },
            "status": status,
            "exitCode": 0 if status == "completed" else None,
            "timedOut": timed_out,
            "error": None if status == "completed" else f"{status} fixture",
            "artifacts": {},
        }

    def _raw(self, tests: list[dict[str, object]] | None = None) -> dict[str, object]:
        return {
            "schemaVersion": 1,
            "timestamp": "2026-09-01T20:00:00Z",
            "finishedAt": "2026-09-01T20:01:00+00:00",
            "status": "completed",
            "wallTimeSeconds": 60.0,
            "benchmarkSuite": "nightly",
            "targets": sorted({t["target"] for t in (tests or [self._test()])}),
            "measurement": {"warmups": 3, "samples": 3, "timeoutSeconds": 300},
            "configuration": {
                "id": "plugins-none-v1",
                "pluginProfile": "none",
                "plugins": [],
                "targetConfigSha256": {"gfx950": "b" * 64},
            },
            "provenance": {
                "rocjitsuCommitSha": "a" * 40,
                "rocjitsuCommitTimestamp": "2026-09-01T19:42:10-07:00",
                "dirty": False,
                "corpusCommitSha": "e" * 40,
                "corpusCommitTimestamp": "2026-09-01T00:00:00Z",
                "corpusDirty": False,
                "buildType": "Release",
                "rocmSdkPath": "/opt/rocm",
                "rocmSdkVersion": "7.2.0",
                "pythonVersion": "3.12.0",
                "torchVersion": "2.10.0",
                "tritonVersion": "3.6.0",
                "tritonCommitSha": None,
                "tensileLiteCommitSha": "c" * 12,
                "packages": {},
            },
            "environment": {"hostname": "benchmark-host"},
            "tests": tests or [self._test()],
        }

    def _publish(self, raw: dict[str, object] | None = None, **overrides):
        options = {
            "data_dir": self.data,
            "run_id": "github-123-attempt-1",
            "repository": "https://github.com/ROCm/rocm-systems",
            "environment_id": "rocm-7.2-sjc-01",
            "trigger": "auto",
            "branch": "develop",
            "machine_id": "sjc-rocjitsu-perf-01",
            "commit_message": "Improve dispatch",
            "generated_at": "2026-09-01T20:02:00Z",
        }
        options.update(overrides)
        return publisher.publish(raw or self._raw(), **options)

    def test_contract_and_idempotent_publication(self):
        result = self._publish()
        metadata = publisher.load_json_document(result["metadata"])
        self.assertEqual(
            metadata,
            {
                "schemaVersion": 1,
                "repository": "https://github.com/ROCm/rocm-systems",
                "isBeta": False,
            },
        )
        index = publisher.load_json_document(result["index"])
        self.assertEqual(set(index), {"generatedAt", "runFiles"})
        self.assertEqual(index["runFiles"], ["runs/github-123-attempt-1.json"])
        run = publisher.load_json_document(result["run"])
        self.assertEqual(
            set(run),
            {
                "id",
                "comparisonId",
                "testCatalog",
                "plugin",
                "source",
                "execution",
                "environment",
                "targets",
            },
        )
        self.assertEqual(run["plugin"], {"id": "vanilla", "name": "Vanilla"})
        self.assertEqual(run["source"]["committedAt"], "2026-09-02T02:42:10Z")
        self.assertEqual(run["execution"]["machine"], "sjc-rocjitsu-perf-01")
        catalog = publisher.load_json_document(result["catalog"])
        self.assertEqual(catalog["targets"], {"gfx950": ["triton.copy_fp32_32m"]})
        self.assertEqual(
            catalog["tests"][0]["problem"],
            {"operation": "Copy", "dataType": "fp32", "elements": 8388608},
        )
        self.assertEqual(
            run["targets"][0]["results"][0]["testId"], "triton.copy_fp32_32m"
        )
        snapshot = {p: p.read_bytes() for p in self.data.rglob("*.json")}
        self.assertFalse(self._publish()["changed"])
        self.assertEqual(
            snapshot, {p: p.read_bytes() for p in self.data.rglob("*.json")}
        )

    def test_subset_catalogs_are_snapshots_and_preserve_history(self):
        first = self._publish()
        original = Path(first["catalog"]).read_bytes()
        tests = [self._test(), self._test("other", target="gfx1250")]
        second = self._publish(self._raw(tests), run_id="second")
        self.assertNotEqual(first["catalog"], second["catalog"])
        self.assertEqual(Path(first["catalog"]).read_bytes(), original)
        catalog = publisher.load_json_document(second["catalog"])
        self.assertEqual(
            catalog["targets"],
            {"gfx950": ["triton.copy_fp32_32m"], "gfx1250": ["other"]},
        )
        reordered = self._publish(self._raw(list(reversed(tests))), run_id="third")
        self.assertEqual(second["catalog"], reordered["catalog"])

    def test_first_failure_timeout_and_recovery(self):
        raw = self._raw(
            [
                self._test(status="failed"),
                self._test(target="gfx1250", status="timeout"),
            ]
        )
        raw["status"] = "failed"
        first = self._publish(raw)
        run = publisher.load_json_document(first["run"])
        self.assertEqual(
            [g["results"][0]["status"] for g in run["targets"]], ["timeout", "failed"]
        )
        recovered = self._publish(
            self._raw([self._test(), self._test(target="gfx1250")]), run_id="recovered"
        )
        self.assertEqual(first["catalog"], recovered["catalog"])

    def test_definition_conflicts_fail_before_writes(self):
        self._publish()
        before = (self.data / "index.json").read_bytes()
        for field, value in (
            ("name", "renamed"),
            ("suite", "another"),
            ("problem", {"elements": 17}),
        ):
            test = self._test()
            test[field] = value
            with (
                self.subTest(field=field),
                self.assertRaisesRegex(publisher.PublishError, "definition conflicts"),
            ):
                self._publish(self._raw([test]), run_id="conflict")
        self.assertEqual((self.data / "index.json").read_bytes(), before)
        self.assertFalse((self.data / "runs/conflict.json").exists())

    def test_source_and_corpus_provenance(self):
        result = self._publish(expected_sha="A" * 40, expected_corpus_sha="E" * 40)
        run = publisher.load_json_document(result["run"])
        details = {item["key"]: item["value"] for item in run["environment"]}
        self.assertEqual(details["corpusCommitSha"], "e" * 40)
        self.assertEqual(details["target.gfx950.numThreads"], 1)
        for field, value in (
            ("dirty", True),
            ("corpusDirty", True),
            ("rocjitsuCommitSha", "bad"),
            ("corpusCommitSha", "bad"),
        ):
            raw = self._raw()
            raw["provenance"][field] = value
            with self.subTest(field=field), self.assertRaises(publisher.PublishError):
                self._publish(raw, run_id="bad")
        for option in ("expected_sha", "expected_corpus_sha"):
            with self.assertRaisesRegex(publisher.PublishError, "expected SHA"):
                self._publish(**{option: "f" * 40})

    def test_same_source_requires_consistent_commit_timestamp(self):
        self._publish()
        before = (self.data / "index.json").read_bytes()
        raw = self._raw()
        raw["provenance"]["rocjitsuCommitTimestamp"] = "2026-09-03T00:00:00Z"
        with self.assertRaisesRegex(publisher.PublishError, "commit timestamp"):
            self._publish(raw, run_id="different-timestamp")
        self.assertEqual((self.data / "index.json").read_bytes(), before)

    def test_compatible_plugins_share_comparison(self):
        self._publish(comparison_id="experiment")
        for profile in ("logging", "race", "throughput"):
            raw = self._raw()
            raw["configuration"].update(
                id=f"plugins-{profile}-v1", pluginProfile=profile, plugins=[profile]
            )
            result = self._publish(raw, run_id=profile, comparison_id="experiment")
            run = publisher.load_json_document(result["run"])
            self.assertEqual(run["plugin"]["id"], profile)
            self.assertNotIn("pluginProfile", {e["key"] for e in run["environment"]})
        with self.assertRaisesRegex(publisher.PublishError, "repeats a plugin"):
            self._publish(run_id="duplicate-vanilla", comparison_id="experiment")

    def test_incompatible_comparisons_rejected(self):
        self._publish(comparison_id="experiment")
        for option, value in (
            ("machine_id", "other"),
            ("environment_id", "other"),
            ("trigger", "manual"),
            ("commit_message", "other"),
        ):
            raw = self._raw()
            raw["configuration"]["pluginProfile"] = "logging"
            with (
                self.subTest(option=option),
                self.assertRaisesRegex(
                    publisher.PublishError, "incompatible comparison"
                ),
            ):
                self._publish(
                    raw, run_id="logging", comparison_id="experiment", **{option: value}
                )
        for change in ("source", "catalog", "environment"):
            raw = self._raw()
            raw["configuration"]["pluginProfile"] = "logging"
            if change == "source":
                raw["provenance"]["rocjitsuCommitSha"] = "b" * 40
            elif change == "catalog":
                raw["tests"][0]["logicalTestId"] = "new"
                raw["tests"][0]["testId"] = "gfx950:new"
            else:
                raw["measurement"]["samples"] = 21
            with (
                self.subTest(change=change),
                self.assertRaisesRegex(
                    publisher.PublishError, "incompatible comparison"
                ),
            ):
                self._publish(raw, run_id="logging", comparison_id="experiment")

    def test_malformed_results_and_problems_rejected(self):
        for field, value in (
            ("durationSeconds", 0),
            ("durationSeconds", float("inf")),
            ("durationSeconds", True),
            ("exitCode", {}),
            ("error", {}),
            ("problem", None),
            ("problem", {"nested": {"x": 1}}),
            ("problem", {"list": [1]}),
            ("timedOut", True),
            ("status", "unknown"),
        ):
            test = self._test()
            test[field] = value
            with (
                self.subTest(field=field, value=value),
                self.assertRaises(publisher.PublishError),
            ):
                self._publish(self._raw([test]))
        self.assertFalse(self.data.exists())

    def test_duplicate_results_and_target_mismatches_rejected(self):
        raw = self._raw([self._test(), self._test()])
        with self.assertRaisesRegex(publisher.PublishError, "duplicate result"):
            self._publish(raw)
        raw = self._raw()
        raw["targets"].append("gfx1250")
        with self.assertRaisesRegex(publisher.PublishError, "targets do not match"):
            self._publish(raw)

    def test_running_run_and_unsafe_ids_rejected(self):
        raw = self._raw()
        raw["status"] = "running"
        with self.assertRaisesRegex(publisher.PublishError, "finalized"):
            self._publish(raw)
        for name in ("../escape", "", "/absolute"):
            with self.assertRaises(publisher.PublishError):
                self._publish(run_id=name)

    def test_conflicting_run_id_rejected(self):
        self._publish()
        raw = self._raw()
        raw["tests"][0]["durationSeconds"] = 42
        with self.assertRaisesRegex(publisher.PublishError, "immutable"):
            self._publish(raw)

    def test_legacy_dataset_rejected_without_changes(self):
        self.data.mkdir(parents=True)
        old = '{"schemaVersion": 1, "runs": [], "catalog": "old.json"}'
        (self.data / "index.json").write_text(old)
        with self.assertRaisesRegex(publisher.PublishError, "fresh data directory"):
            self._publish()
        self.assertEqual((self.data / "index.json").read_text(), old)

    def test_missing_or_corrupt_indexed_resources_rejected(self):
        result = self._publish()
        run_path = Path(result["run"])
        original = run_path.read_bytes()
        run_path.unlink()
        with self.assertRaises(publisher.PublishError):
            self._publish(run_id="next")
        run_path.write_bytes(original)
        run = json.loads(original)
        run["targets"][0]["results"] = []
        run_path.write_text(json.dumps(run))
        with self.assertRaisesRegex(publisher.PublishError, "catalog"):
            self._publish(run_id="next")
        run_path.write_bytes(original)
        catalog = publisher.load_json_document(result["catalog"])
        catalog["tests"][0]["name"] = "changed"
        Path(result["catalog"]).write_text(json.dumps(catalog))
        with self.assertRaisesRegex(publisher.PublishError, "hash"):
            self._publish(run_id="next")
        self.assertFalse((self.data / "runs/next.json").exists())

    def test_metadata_conflict(self):
        self._publish()
        for options in (
            {"is_beta": True},
            {"repository": "https://github.com/example/fork"},
        ):
            with self.assertRaisesRegex(publisher.PublishError, "metadata conflicts"):
                self._publish(**options)

    def test_index_written_after_catalog_and_run(self):
        writes = []
        write = publisher._write_atomic

        def record(path, content):
            writes.append(path)
            write(path, content)

        with mock.patch.object(publisher, "_write_atomic", side_effect=record):
            result = self._publish()
        self.assertLess(
            writes.index(Path(result["catalog"])), writes.index(Path(result["run"]))
        )
        self.assertEqual(writes[-1], self.data / "index.json")

    def test_strict_json(self):
        for value in ("{} {}", '{"x":1,"x":2}', '{"x":NaN}', '{"x":1e999}'):
            path = self.root / "bad.json"
            path.write_text(value)
            with self.assertRaises(publisher.PublishError):
                publisher.load_json_document(path)

    def test_cli(self):
        raw_path = self.root / "raw.json"
        raw_path.write_text(json.dumps(self._raw()))
        with contextlib.redirect_stdout(io.StringIO()):
            self.assertEqual(
                publisher.main(
                    [
                        "--raw-run",
                        str(raw_path),
                        "--data-dir",
                        str(self.data),
                        "--run-id",
                        "cli",
                        "--repository",
                        "https://github.com/ROCm/rocm-systems",
                        "--environment-id",
                        "local",
                        "--trigger",
                        "manual",
                        "--branch",
                        "develop",
                        "--expected-sha",
                        "a" * 40,
                        "--expected-corpus-sha",
                        "e" * 40,
                        "--is-beta",
                        "--comparison-id",
                        "experiment",
                    ]
                ),
                0,
            )
        run = publisher.load_json_document(self.data / "runs/cli.json")
        self.assertEqual(run["execution"]["machine"], "benchmark-host")
        self.assertEqual(run["comparisonId"], "experiment")
        self.assertTrue(
            publisher.load_json_document(self.data / "metadata.json")["isBeta"]
        )


if __name__ == "__main__":
    unittest.main()
