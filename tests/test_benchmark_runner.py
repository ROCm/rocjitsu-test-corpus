# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
from __future__ import annotations

import contextlib
import hashlib
import importlib.util
import io
import json
import os
import re
import shlex
import signal
import subprocess
import sys
import time
import types
from functools import partial
from pathlib import Path
from types import SimpleNamespace
from unittest import mock

import pytest

from benchmarks import dashboard_publish, runner


@pytest.fixture
def runner_context(tmp_path, monkeypatch):
    ctx = SimpleNamespace(
        root=tmp_path,
        build=tmp_path / "build",
        rocm=tmp_path / "rocm",
        source=tmp_path / "rocjitsu",
    )
    ctx.rocm.mkdir()
    (ctx.source / "configs").mkdir(parents=True)
    ctx.configs = {}
    for target in ("gfx950", "gfx1250"):
        path = ctx.source / "configs" / f"{target}.json"
        path.write_text(json.dumps({"exec_mode": "functional", "num_threads": 1}))
        ctx.configs[target] = path
    ctx.build.mkdir()
    _write_cache(ctx)
    executable = ctx.build / "custom launcher"
    executable.write_text("#!/bin/sh\n", encoding="utf-8")
    executable.chmod(0o755)
    ctx.wrapper = f'"{executable}" --config {{config}} --'
    for plugin in ("logging", "race", "throughput"):
        (ctx.build / f"librocjitsu_plugin_{plugin}.so").touch()
    monkeypatch.setattr(runner, "_installed_rocm_path", lambda: ctx.rocm)
    ctx.suite = runner.load_manifest()
    return ctx


def _write_cache(runner_context, **overrides: str) -> None:
    values = {
        "CMAKE_BUILD_TYPE": "Release",
        "CMAKE_HOME_DIRECTORY": str(runner_context.source),
        "LTO": "OFF",
        "RJ_ENABLE_ASAN": "OFF",
        "RJ_ENABLE_MSAN": "OFF",
        "RJ_ENABLE_TSAN": "OFF",
        "RJ_ENABLE_UBSAN": "OFF",
        "ROCM_PATH": str(runner_context.rocm),
    }
    values.update(overrides)
    (runner_context.build / "CMakeCache.txt").write_text(
        "".join((f"{key}:STRING={value}\n" for key, value in values.items())),
        encoding="utf-8",
    )


def _matrix(runner_context, *cases: str, targets: tuple[str, ...] = ("gfx950",)):
    return runner.select_matrix(runner_context.suite, cases=cases, targets=targets)


def _cell(runner_context, case_id: str, target: str) -> runner.Cell:
    definition = next(case for case in runner_context.suite.cases if case.id == case_id)
    return runner.Cell(definition, target)


def _payload(cell: runner.Cell, timings: list[int]) -> dict[str, object]:
    return {
        "schema": "rocjitsu.benchmark.workload.v1",
        "case": cell.case,
        "target": cell.target,
        "provider": "triton",
        "parameters": {"fixture": True},
        "timings_ns": timings,
    }


def _successful_process(runner_context, argv, **_kwargs):
    case = argv[argv.index("--case") + 1]
    target = argv[argv.index("--target") + 1]
    samples = int(argv[argv.index("--samples") + 1])
    output = Path(argv[argv.index("--output") + 1])
    output.write_text(
        json.dumps(
            _payload(_cell(runner_context, case, target), list(range(1, samples + 1)))
        ),
        encoding="utf-8",
    )
    config = json.loads(
        Path(argv[argv.index("--config") + 1]).read_text(encoding="utf-8")
    )
    for plugin in config.get("plugins", {}):
        report = Path(config["sinks"]["dir"]) / f"{plugin}.log"
        report.write_text(f"{plugin} report\n", encoding="utf-8")
    return subprocess.CompletedProcess(argv, 0, "out", "")


def _run(
    runner_context,
    matrix,
    name: str,
    process=None,
    samples=None,
    plugin_profile: str = "none",
    progress=None,
):
    output = runner_context.root / name
    packages = {"rocm-sdk-devel": "7.2.0", "torch": "2.10.0", "triton": "3.6.0"}
    with mock.patch.object(
        runner,
        "_source_info",
        return_value={
            "commit_sha": "a" * 40,
            "commit_timestamp": "2026-09-01T21:42:10Z",
            "dirty": False,
        },
    ), mock.patch.object(
        runner,
        "_environment_info",
        return_value={
            "hostname": "benchmark-host",
            "platform": "Linux-test",
            "kernel": "6.14.0",
            "cpu": "test-cpu",
            "python": "3.12.0",
            "packages": packages,
        },
    ), mock.patch.object(
        runner,
        "_run_command",
        side_effect=process or partial(_successful_process, runner_context),
    ):
        result = runner.run_suite(
            runner_context.suite,
            matrix,
            build_dir=runner_context.build,
            output=output,
            samples=samples,
            plugin_profile=plugin_profile,
            progress=progress,
            rocjitsu_source_dir=runner_context.source,
            run_wrapper=runner_context.wrapper,
            target_configs=runner_context.configs,
        )
    return (output, result)


def test_default_manifest_has_full_ordered_matrix(runner_context) -> None:
    matrix = runner.select_matrix(runner_context.suite)
    assert len(matrix) == 56
    assert sum(c.workload == "gemm" for c in runner_context.suite.cases) == 16
    assert matrix[:4] == (
        _cell(runner_context, "triton.copy_fp32_32m.threads8", "gfx950"),
        _cell(runner_context, "triton.copy_fp32_32m.threads8", "gfx1250"),
        _cell(runner_context, "triton.vector_add_fp32_boundary.threads8", "gfx950"),
        _cell(runner_context, "triton.vector_add_fp32_boundary.threads8", "gfx1250"),
    )
    assert runner_context.suite.warmups == 3
    assert runner_context.suite.samples == 21
    assert runner_context.suite.num_threads == 8
    assert runner_context.suite.timeout_seconds == 300


def test_smoke_manifest_has_single_triton_case(runner_context) -> None:
    smoke = runner.load_manifest(runner.BENCHMARK_ROOT / "suites" / "smoke.toml")
    assert smoke.name == "smoke"
    assert smoke.targets == ("gfx950",)
    assert tuple(case.id for case in smoke.cases) == ("triton.rmsnorm_bf16.threads8",)
    assert smoke.warmups == 1
    assert smoke.samples == 3
    assert smoke.num_threads == 8
    assert smoke.timeout_seconds == 60


def test_manifest_rejects_extra_fields(runner_context) -> None:
    manifest = runner_context.root / "suite.toml"
    text = runner.DEFAULT_MANIFEST.read_text(encoding="utf-8")
    manifest.write_text("description = 'extra'\n" + text, encoding="utf-8")
    with pytest.raises(runner.RunnerError, match="extra=.*description"):
        runner.load_manifest(manifest)


def test_manifest_rejects_duplicate_case_ids(runner_context) -> None:
    manifest = runner_context.root / "suite.toml"
    text = runner.DEFAULT_MANIFEST.read_text(encoding="utf-8")
    text += "\n[[cases]]" + text.split("[[cases]]")[1]
    manifest.write_text(text, encoding="utf-8")
    with pytest.raises(runner.RunnerError, match="duplicate"):
        runner.load_manifest(manifest)


def test_manifest_rejects_unknown_workload(runner_context) -> None:
    manifest = runner_context.root / "suite.toml"
    text = runner.DEFAULT_MANIFEST.read_text(encoding="utf-8")
    manifest.write_text(
        text.replace('workload = "copy"', 'workload = "missing"', 1), encoding="utf-8"
    )
    with pytest.raises(runner.RunnerError, match="workload"):
        runner.load_manifest(manifest)


def test_manifest_only_variant_forwards_parameters_and_metadata(runner_context) -> None:
    manifest = runner_context.root / "variant.toml"
    manifest.write_text(
        'name = "custom"\ntargets = ["gfx950"]\nwarmups = 1\nsamples = 3\nnum_threads = 1\ntimeout_seconds = 60\n\n[[cases]]\nid = "copy.small_bf16"\nworkload = "copy"\nsuite = "Custom suite"\nname = "Small BF16 copy"\noperation = "Copy"\nparams = { dtype = "bf16", elements = 12345 }\n',
        encoding="utf-8",
    )
    runner_context.suite = runner.load_manifest(manifest)
    matrix = runner.select_matrix(runner_context.suite)
    assert len(matrix) == 1
    assert matrix[0].case == "copy.small_bf16"
    observed = {}

    def execute(argv, **kwargs):
        observed["workload"] = argv[argv.index("--workload") + 1]
        observed["params"] = json.loads(argv[argv.index("--params") + 1])
        return _successful_process(runner_context, argv, **kwargs)

    _, result = _run(runner_context, matrix, "variant", process=execute)
    assert observed == {
        "workload": "copy",
        "params": {"dtype": "bf16", "elements": 12345},
    }
    assert result["status"] == "completed"
    case = result["tests"][0]
    assert case["logicalTestId"] == "copy.small_bf16"
    assert case["suite"] == "Custom suite"
    assert case["name"] == "Small BF16 copy"
    assert case["operation"] == "Copy"
    assert case["dataType"] == "bf16"


def test_manifest_rejects_invalid_thread_count(runner_context) -> None:
    manifest = runner_context.root / "suite.toml"
    text = runner.DEFAULT_MANIFEST.read_text(encoding="utf-8")
    for value in ("0", "-1", "true"):
        manifest.write_text(
            text.replace("num_threads = 8", f"num_threads = {value}"), encoding="utf-8"
        )
        with pytest.raises(
            runner.RunnerError, match="num_threads must be a positive integer"
        ):
            runner.load_manifest(manifest)


def test_manifest_rejects_case_path_traversal(runner_context) -> None:
    manifest = runner_context.root / "suite.toml"
    text = runner.DEFAULT_MANIFEST.read_text(encoding="utf-8").replace(
        '"triton.softmax_fp16_aligned.threads8"', '"triton./../../../escaped"'
    )
    manifest.write_text(text, encoding="utf-8")
    with pytest.raises(runner.RunnerError, match="invalid benchmark case ID"):
        runner.load_manifest(manifest)


def test_manifest_rejects_non_utf8_input(runner_context) -> None:
    manifest = runner_context.root / "suite.toml"
    manifest.write_bytes(b"name = \xff\n")
    with pytest.raises(runner.RunnerError, match="cannot read manifest"):
        runner.load_manifest(manifest)


def test_even_sample_count_is_rejected(runner_context) -> None:
    with pytest.raises(runner.RunnerError, match="must be odd"):
        runner.run_suite(
            runner_context.suite,
            _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
            build_dir=runner_context.build,
            output=runner_context.root / "even-samples",
            samples=2,
            rocjitsu_source_dir=runner_context.source,
            run_wrapper=runner_context.wrapper,
            target_configs=runner_context.configs,
        )
    assert not (runner_context.root / "even-samples").exists()


def test_subsets_keep_manifest_order_and_reject_unknowns(runner_context) -> None:
    matrix = runner.select_matrix(
        runner_context.suite,
        cases=("triton.gemm_bf16_aligned.threads8", "triton.rmsnorm_bf16.threads8"),
        targets=("gfx1250",),
    )
    assert matrix == (
        _cell(runner_context, "triton.rmsnorm_bf16.threads8", "gfx1250"),
        _cell(runner_context, "triton.gemm_bf16_aligned.threads8", "gfx1250"),
    )
    with pytest.raises(runner.RunnerError, match="not in the suite"):
        runner.select_matrix(runner_context.suite, cases=("triton.unknown",))
    with pytest.raises(runner.RunnerError, match="not in the suite"):
        runner.select_matrix(runner_context.suite, targets=("gfx9999",))


def test_measurement_excludes_slow_compilation_and_warmups(runner_context) -> None:
    elapsed = 0
    launches = 0

    def launch():
        nonlocal elapsed, launches
        launches += 1
        elapsed += 10000 if launches == 1 else 1000 if launches <= 3 else 5

    def synchronize():
        nonlocal elapsed
        elapsed += 2

    torch = types.SimpleNamespace(cuda=types.SimpleNamespace(synchronize=synchronize))
    spec = importlib.util.spec_from_file_location(
        "measurement_test", runner.BENCHMARK_ROOT / "measurement.py"
    )
    measurement = importlib.util.module_from_spec(spec)
    with mock.patch.dict(sys.modules, {"torch": torch}):
        spec.loader.exec_module(measurement)
    with mock.patch.object(
        measurement.time, "perf_counter_ns", side_effect=lambda: elapsed
    ):
        assert measurement.measure(launch, warmups=2, samples=3) == [7, 7, 7]
    assert launches == 6


def test_python_adapter_dispatch_is_independent_of_rocjitsu_source(
    runner_context,
) -> None:
    case = "triton.gpt_oss_attention_bf16.threads8"
    command = runner.prepare_command(
        runner_context.root / case,
        _cell(runner_context, case, "gfx950"),
        warmups=1,
        samples=3,
        run_wrapper=runner.parse_run_wrapper(runner_context.wrapper),
        target=runner._target_metadata(runner_context.configs["gfx950"], 8),
    )
    script = runner.WORKLOAD_ROOT / "triton" / "workloads.py"
    assert str(script) in command.argv
    assert command.cwd == runner.CORPUS_ROOT
    assert command.environment["PYTHONPATH"].split(os.pathsep)[0] == str(
        runner.CORPUS_ROOT
    )


def test_missing_selected_python_adapter_is_actionable(runner_context) -> None:
    with mock.patch.object(runner, "WORKLOAD_ROOT", runner_context.root / "missing"):
        with pytest.raises(runner.RunnerError, match="missing Triton workload"):
            runner.validate_build(
                runner_context.build, rocjitsu_source_dir=runner_context.source
            )


def test_commands_forward_measurement_and_parameters(runner_context) -> None:
    output = runner_context.root / "out"
    expected_programs = {
        "triton.rmsnorm_bf16.threads8": "workloads.py",
        "triton.gemm_bf16_aligned.threads8": "workloads.py",
    }
    for case, marker in expected_programs.items():
        cell = _cell(runner_context, case, "gfx950")
        command = runner.prepare_command(
            output,
            cell,
            warmups=2,
            samples=5,
            run_wrapper=runner.parse_run_wrapper(runner_context.wrapper),
            target=runner._target_metadata(runner_context.configs["gfx950"], 8),
        )
        assert any(
            item == marker or item.endswith("/" + marker) for item in command.argv
        )
        assert command.argv[command.argv.index("--target") :] == (
            "--target",
            "gfx950",
            "--warmups",
            "2",
            "--samples",
            "5",
            "--output",
            str(command.workload_path),
        )
        assert command.environment["PYTHONHASHSEED"] == "0"
        assert command.environment["TRITON_CACHE_DIR"].endswith("triton/gfx950")
        effective_config = command.config_path.read_bytes()
        assert json.loads(effective_config)["num_threads"] == 8
        assert (
            hashlib.sha256(effective_config).hexdigest()
            == runner._target_metadata(
                runner_context.configs["gfx950"], 8
            ).config_sha256
        )


def test_plugin_config_is_derived_without_modifying_base(runner_context) -> None:
    cell = _cell(runner_context, "triton.rmsnorm_bf16.threads8", "gfx950")
    base = runner_context.configs[cell.target]
    original = base.read_bytes()
    command = runner.prepare_command(
        runner_context.root / "plugin-config",
        cell,
        warmups=1,
        samples=3,
        plugin_profile="race",
        run_wrapper=runner.parse_run_wrapper(runner_context.wrapper),
        target=runner._target_metadata(runner_context.configs["gfx950"], 8),
    )
    generated = json.loads(command.config_path.read_text(encoding="utf-8"))
    assert generated["plugins"] == {"race": {}}
    assert generated["sinks"]["types"] == ["file"]
    assert command.plugin_reports == {
        "race": command.config_path.parent / "plugins" / "race.log"
    }
    assert base.read_bytes() == original


def test_validate_and_aggregate_workload(runner_context) -> None:
    path = runner_context.root / "workload.json"
    cell = _cell(runner_context, "triton.rmsnorm_bf16.threads8", "gfx950")
    payload = _payload(cell, [30, 10, 20])
    payload["parameters"] = {
        "threads_per_block": 64,
        "nested_values": [{"input_dtype": "fp16"}],
    }
    path.write_text(json.dumps(payload), encoding="utf-8")
    result = runner.validate_workload(path, cell, 3)
    assert "problem" not in result
    assert json.loads(path.read_text()) == payload
    assert result["durationSeconds"] == 20 / 1000000000
    assert result["timing"] == {
        "unit": "ns",
        "samples": [30, 10, 20],
        "minimum": 10,
        "median": 20,
        "maximum": 30,
    }


def test_dashboard_parameter_conversion_rejects_collisions(runner_context) -> None:
    assert runner._dashboard_value(
        {
            "input_dtype": "bf16",
            "alreadyCamel": True,
            "nested_list": [{"threads_per_block": 256}],
        }
    ) == {
        "inputDtype": "bf16",
        "alreadyCamel": True,
        "nestedList": [{"threadsPerBlock": 256}],
    }
    for parameters in (
        {"foo_bar": 1, "fooBar": 2},
        {"nested": {"foo__bar": 1, "foo_bar": 2}},
    ):
        with pytest.raises(runner.RunnerError, match="collide as 'fooBar'"):
            runner._dashboard_value(parameters)


def test_success_writes_compact_artifacts(runner_context) -> None:
    matrix = _matrix(runner_context, "triton.rmsnorm_bf16.threads8")
    output, result = _run(runner_context, matrix, "success", samples=3)
    assert set(result) == {
        "schemaVersion",
        "timestamp",
        "finishedAt",
        "status",
        "wallTimeSeconds",
        "benchmarkSuite",
        "targets",
        "measurement",
        "configuration",
        "provenance",
        "environment",
        "tests",
    }
    assert result["schemaVersion"] == 1
    assert result["status"] == "completed"
    assert result["benchmarkSuite"] == "nightly"
    assert result["targets"] == ["gfx950"]
    assert result["measurement"] == {
        "warmups": 3,
        "samples": 3,
        "timeoutSeconds": 300.0,
    }
    assert result["configuration"] == {
        "id": "plugins-none-v1",
        "pluginProfile": "none",
        "plugins": [],
        "targetConfigSha256": {
            "gfx950": runner._target_metadata(
                runner_context.configs["gfx950"], runner_context.suite.num_threads
            ).config_sha256
        },
    }
    assert result["provenance"] == {
        "rocjitsuCommitSha": "a" * 40,
        "rocjitsuCommitTimestamp": "2026-09-01T21:42:10Z",
        "corpusCommitSha": "a" * 40,
        "corpusCommitTimestamp": "2026-09-01T21:42:10Z",
        "corpusDirty": False,
        "dirty": False,
        "buildType": "Release",
        "rocmSdkPath": str(runner_context.rocm),
        "rocmSdkVersion": "7.2.0",
        "pythonVersion": "3.12.0",
        "torchVersion": "2.10.0",
        "tritonVersion": "3.6.0",
        "tritonCommitSha": None,
        "tensileLiteCommitSha": None,
        "packages": {"rocm-sdk-devel": "7.2.0", "torch": "2.10.0", "triton": "3.6.0"},
    }
    assert result["environment"] == {
        "hostname": "benchmark-host",
        "platform": "Linux-test",
        "kernel": "6.14.0",
        "cpu": "test-cpu",
    }
    test = result["tests"][0]
    assert set(test) == {
        "testId",
        "logicalTestId",
        "suite",
        "name",
        "target",
        "operation",
        "dataType",
        "problem",
        "execMode",
        "numThreads",
        "durationSeconds",
        "timing",
        "status",
        "exitCode",
        "timedOut",
        "error",
        "artifacts",
    }
    assert test["testId"] == "gfx950:triton.rmsnorm_bf16.threads8"
    assert test["logicalTestId"] == "triton.rmsnorm_bf16.threads8"
    assert test["suite"] == "Triton"
    assert test["name"] == "BF16 RMSNorm"
    assert test["operation"] == "RMSNorm"
    assert test["dataType"] == "bf16"
    assert test["problem"] == {
        "dtype": "bf16",
        "rows": 128,
        "columns": 4096,
        "epsilon": 1e-05,
    }
    assert test["execMode"] == "functional"
    assert test["numThreads"] == 8
    assert test["durationSeconds"] == 2 / 1000000000
    assert test["timing"] == {
        "unit": "ns",
        "samples": [1, 2, 3],
        "minimum": 1,
        "median": 2,
        "maximum": 3,
    }
    assert test["status"] == "completed"
    assert test["exitCode"] == 0
    assert not test["timedOut"]
    assert test["error"] is None
    assert test["artifacts"] == {
        "workload": "cases/triton.rmsnorm_bf16.threads8/gfx950/workload.json",
        "stdout": "cases/triton.rmsnorm_bf16.threads8/gfx950/stdout.txt",
        "stderr": "cases/triton.rmsnorm_bf16.threads8/gfx950/stderr.txt",
        "config": "cases/triton.rmsnorm_bf16.threads8/gfx950/config.json",
        "pluginReports": {},
    }
    assert "canonical" not in result["provenance"]
    assert (output / "run.json").is_file()
    assert json.loads((output / "run.json").read_text(encoding="utf-8")) == result
    assert (
        output / "cases/triton.rmsnorm_bf16.threads8/gfx950/stdout.txt"
    ).read_text() == "out"


def test_progress_reports_suite_and_cell_status(runner_context) -> None:
    progress = io.StringIO()
    _run(
        runner_context,
        _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
        "progress",
        samples=1,
        progress=progress,
    )
    messages = progress.getvalue().splitlines()
    assert (
        messages[0]
        == "[rocjitsu-benchmark] START suite=nightly cells=1 warmups=3 samples=1 threads=8 plugin=none"
    )
    assert (
        messages[1]
        == "[rocjitsu-benchmark] START [1/1] case=triton.rmsnorm_bf16.threads8 target=gfx950 provider=triton timeout_seconds=300"
    )
    assert re.search(
        "^\\[rocjitsu-benchmark\\] DONE  \\[1/1\\] case=triton\\.rmsnorm_bf16\\.threads8 target=gfx950 status=completed elapsed_seconds=\\d+\\.\\d median_ns=1$",
        messages[2],
    )
    assert re.search(
        "^\\[rocjitsu-benchmark\\] DONE suite=nightly status=completed completed=1 failed=0 timeout=0 elapsed_seconds=\\d+\\.\\d$",
        messages[3],
    )


def test_initial_checkpoint_is_a_running_v1_run(runner_context) -> None:
    observed = None

    def inspect_checkpoint(argv, **kwargs):
        nonlocal observed
        workload = Path(argv[argv.index("--output") + 1])
        observed = json.loads((workload.parents[3] / "run.json").read_text())
        return _successful_process(runner_context, argv, **kwargs)

    _run(
        runner_context,
        _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
        "running-checkpoint",
        process=inspect_checkpoint,
        samples=1,
    )
    assert observed is not None
    assert observed["schemaVersion"] == 1
    assert observed["status"] == "running"
    assert observed["finishedAt"] is None
    assert len(observed["tests"]) == 1
    assert observed["tests"][0]["status"] == "failed"


def test_first_partial_run_publishes_and_failed_case_can_later_succeed(
    runner_context,
) -> None:
    failed_id = "triton.gpt_oss_attention_bf16.threads8"
    matrix = _matrix(
        runner_context,
        "triton.rmsnorm_bf16.threads8",
        failed_id,
        targets=("gfx950", "gfx1250"),
    )

    def fail_attention(argv, **kwargs):
        if argv[argv.index("--case") + 1] == failed_id:
            return subprocess.CompletedProcess(argv, 1, "", "launch failed")
        return _successful_process(runner_context, argv, **kwargs)

    _, partial = _run(
        runner_context, matrix, "partial", process=fail_attention, samples=1
    )
    assert partial["status"] == "failed"
    assert [test["status"] for test in partial["tests"]] == [
        "completed",
        "completed",
        "failed",
        "failed",
    ]
    options = dict(
        data_dir=runner_context.root / "dashboard",
        repository="https://github.com/ROCm/rocm-systems",
        environment_id="test",
        trigger="manual",
        branch="develop",
        expected_sha="a" * 40,
        expected_corpus_sha="a" * 40,
    )
    published = dashboard_publish.publish(partial, run_id="partial", **options)
    normalized = json.loads(Path(published["run"]).read_text())
    results = [r for group in normalized["targets"] for r in group["results"]]
    assert len(results) == 4
    assert sum(r["status"] == "failed" for r in results) == 2
    catalog = json.loads(Path(published["catalog"]).read_text())
    assert len(catalog["tests"]) == 2
    _, recovered = _run(runner_context, matrix, "recovered", samples=1)
    assert recovered["status"] == "completed"
    dashboard_publish.publish(recovered, run_id="recovered", **options)
    assert not dashboard_publish.publish(recovered, run_id="recovered", **options)[
        "changed"
    ]


def test_nonzero_exit_preserves_logs(runner_context) -> None:

    def fail(argv, **_kwargs):
        return subprocess.CompletedProcess(argv, 7, "partial out", "failure text")

    output, result = _run(
        runner_context,
        _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
        "nonzero",
        process=fail,
    )
    assert result["status"] == "failed"
    test = result["tests"][0]
    assert test["status"] == "failed"
    assert test["exitCode"] == 7
    assert not test["timedOut"]
    assert "status 7" in test["error"]
    assert test["problem"] == {
        "dtype": "bf16",
        "rows": 128,
        "columns": 4096,
        "epsilon": 1e-05,
    }
    assert test["durationSeconds"] is None
    assert test["timing"] == {
        "unit": "ns",
        "samples": [],
        "minimum": None,
        "median": None,
        "maximum": None,
    }
    assert test["artifacts"]["workload"] is None
    assert (
        output / "cases/triton.rmsnorm_bf16.threads8/gfx950/stderr.txt"
    ).read_text() == "failure text"


def test_rejects_build_from_another_worktree(runner_context) -> None:
    _write_cache(runner_context, CMAKE_HOME_DIRECTORY="/tmp/other-rocjitsu")
    with pytest.raises(runner.RunnerError, match="belongs to"):
        runner.validate_build(
            runner_context.build, rocjitsu_source_dir=runner_context.source
        )


def test_build_validation_requires_pinned_sdk_and_no_instrumentation(
    runner_context,
) -> None:
    metadata = runner.validate_build(
        runner_context.build, rocjitsu_source_dir=runner_context.source
    )
    assert metadata == runner.BuildMetadata("Release", runner_context.rocm)
    _write_cache(runner_context, ROCM_PATH=str(runner_context.root / "another-sdk"))
    with pytest.raises(runner.RunnerError, match="this Python environment"):
        runner.validate_build(
            runner_context.build, rocjitsu_source_dir=runner_context.source
        )
    for option in (
        "LTO",
        "RJ_ENABLE_ASAN",
        "RJ_ENABLE_MSAN",
        "RJ_ENABLE_TSAN",
        "RJ_ENABLE_UBSAN",
    ):
        _write_cache(runner_context, **{option: "ON"})
        with pytest.raises(runner.RunnerError, match="LTO=OFF|disable sanitizers"):
            runner.validate_build(
                runner_context.build, rocjitsu_source_dir=runner_context.source
            )
    _write_cache(runner_context)


def test_build_validation_requires_selected_plugin_binary(runner_context) -> None:
    plugin = runner_context.build / "librocjitsu_plugin_race.so"
    plugin.unlink()
    with pytest.raises(runner.RunnerError, match="missing race plugin"):
        runner.validate_build(
            runner_context.build,
            plugin_profile="race",
            rocjitsu_source_dir=runner_context.source,
        )


def test_target_metadata_is_read_from_selected_configuration(runner_context) -> None:
    configuration = runner_context.root / "target.json"
    configuration.write_text(
        json.dumps({"exec_mode": "parallel", "num_threads": 8, "max_ticks": 100000}),
        encoding="utf-8",
    )
    with mock.patch.dict(runner_context.configs, {"gfx950": configuration}, clear=True):
        config, _ = runner._load_target_configuration(runner_context.configs["gfx950"])
        assert config["max_ticks"] == 0
        metadata = runner._target_metadata(runner_context.configs["gfx950"])
        effective_metadata = runner._target_metadata(
            runner_context.configs["gfx950"], runner_context.suite.num_threads
        )
        _, result = _run(
            runner_context,
            _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
            "target-metadata",
            samples=1,
        )
    assert metadata.exec_mode == "parallel"
    assert metadata.num_threads == 8
    assert (
        metadata.config_sha256
        == hashlib.sha256(
            (json.dumps(config, indent=2, sort_keys=True) + "\n").encode()
        ).hexdigest()
    )
    assert result["tests"][0]["execMode"] == "parallel"
    assert result["tests"][0]["numThreads"] == runner_context.suite.num_threads
    assert (
        result["configuration"]["targetConfigSha256"]["gfx950"]
        == effective_metadata.config_sha256
    )


def test_plugin_profile_is_recorded_and_report_is_retained(runner_context) -> None:
    output, result = _run(
        runner_context,
        _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
        "race-profile",
        samples=1,
        plugin_profile="race",
    )
    assert result["configuration"] == {
        "id": "plugins-race-v1",
        "pluginProfile": "race",
        "plugins": ["race"],
        "targetConfigSha256": {
            "gfx950": runner._target_metadata(
                runner_context.configs["gfx950"], runner_context.suite.num_threads
            ).config_sha256
        },
    }
    report = "cases/triton.rmsnorm_bf16.threads8/gfx950/plugins/race.log"
    assert result["tests"][0]["artifacts"]["pluginReports"] == {"race": report}
    assert (output / report).read_text(encoding="utf-8") == "race report\n"


def test_missing_plugin_report_fails_the_cell(runner_context) -> None:

    def no_report(argv, **_kwargs):
        case = argv[argv.index("--case") + 1]
        target = argv[argv.index("--target") + 1]
        output = Path(argv[argv.index("--output") + 1])
        output.write_text(
            json.dumps(_payload(_cell(runner_context, case, target), [1])),
            encoding="utf-8",
        )
        return subprocess.CompletedProcess(argv, 0, "", "")

    _, result = _run(
        runner_context,
        _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
        "missing-plugin-report",
        process=no_report,
        samples=1,
        plugin_profile="logging",
    )
    assert result["status"] == "failed"
    assert "logging" in result["tests"][0]["error"]


def test_target_metadata_rejects_invalid_fields(runner_context) -> None:
    configuration = runner_context.root / "target.json"
    invalid_values = (
        [],
        {"exec_mode": "", "num_threads": 1},
        {"exec_mode": "functional", "num_threads": True},
        {"exec_mode": "functional", "num_threads": 0},
    )
    for value in invalid_values:
        configuration.write_text(json.dumps(value), encoding="utf-8")
        with mock.patch.dict(
            runner_context.configs, {"gfx950": configuration}, clear=True
        ), pytest.raises(runner.RunnerError):
            runner._target_metadata(runner_context.configs["gfx950"])
    configuration.write_text("{", encoding="utf-8")
    with mock.patch.dict(
        runner_context.configs, {"gfx950": configuration}, clear=True
    ), pytest.raises(runner.RunnerError, match="cannot read"):
        runner._target_metadata(runner_context.configs["gfx950"])


def test_commit_timestamp_is_normalized_to_utc(runner_context) -> None:
    assert (
        runner._normalize_timestamp("2026-09-02T09:30:00-07:00")
        == "2026-09-02T16:30:00Z"
    )
    assert (
        runner._normalize_timestamp("2026-09-02T16:30:00+00:00")
        == "2026-09-02T16:30:00Z"
    )
    for value in ("", "not-a-timestamp", "2026-09-02T16:30:00"):
        assert runner._normalize_timestamp(value) is None


def test_source_info_preserves_sha_when_timestamp_is_invalid(runner_context) -> None:
    with mock.patch.object(
        runner.subprocess,
        "check_output",
        side_effect=["abc123\n", "invalid\n", " M local-file\n"],
    ) as check_output:
        result = runner._source_info(runner_context.source)
    assert result == {"commit_sha": "abc123", "commit_timestamp": None, "dirty": True}
    assert check_output.call_args_list[1].args[0] == [
        "git",
        "show",
        "-s",
        "--format=%cI",
        "abc123",
    ]
    for call in check_output.call_args_list:
        assert call.kwargs["cwd"] == runner_context.source
        assert call.kwargs["stderr"] is subprocess.DEVNULL


def test_source_info_ties_timestamp_to_resolved_sha(runner_context) -> None:
    with mock.patch.object(
        runner.subprocess,
        "check_output",
        side_effect=["abc123\n", "2026-09-02T09:30:00-07:00\n", ""],
    ) as check_output:
        result = runner._source_info(runner_context.source)
    assert result["commit_sha"] == "abc123"
    assert result["commit_timestamp"] == "2026-09-02T16:30:00Z"
    assert check_output.call_args_list[1].args[0] == [
        "git",
        "show",
        "-s",
        "--format=%cI",
        "abc123",
    ]


def test_source_info_falls_back_when_git_is_unavailable(runner_context) -> None:
    unavailable = subprocess.CalledProcessError(128, ["git"])
    with mock.patch.object(
        runner.subprocess, "check_output", side_effect=[unavailable, unavailable]
    ) as check_output:
        result = runner._source_info(runner_context.source)
    assert result == {"commit_sha": None, "commit_timestamp": None, "dirty": None}
    assert check_output.call_count == 2


def test_timeout_preserves_captured_output(runner_context) -> None:

    def timeout(argv, **_kwargs):
        raise subprocess.TimeoutExpired(
            argv, 180, output=b"partial out", stderr=b"partial error"
        )

    output, result = _run(
        runner_context,
        _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
        "timeout",
        process=timeout,
    )
    test = result["tests"][0]
    assert result["status"] == "failed"
    assert test["status"] == "timeout"
    assert test["exitCode"] is None
    assert test["timedOut"]
    assert "timed out" in test["error"]
    assert test["problem"] == {
        "dtype": "bf16",
        "rows": 128,
        "columns": 4096,
        "epsilon": 1e-05,
    }
    assert test["durationSeconds"] is None
    assert (
        output / "cases/triton.rmsnorm_bf16.threads8/gfx950/stdout.txt"
    ).read_text() == "partial out"


def test_zero_exit_without_workload_is_a_failed_test(runner_context) -> None:

    def missing(argv, **_kwargs):
        return subprocess.CompletedProcess(argv, 0, "", "")

    _, result = _run(
        runner_context,
        _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
        "missing-workload",
        process=missing,
    )
    test = result["tests"][0]
    assert test["status"] == "failed"
    assert test["exitCode"] == 0
    assert test["artifacts"]["workload"] is None
    assert "cannot read workload result" in test["error"]


def test_malformed_samples_fail_validation(runner_context) -> None:

    def malformed(argv, **_kwargs):
        case = argv[argv.index("--case") + 1]
        target = argv[argv.index("--target") + 1]
        output = Path(argv[argv.index("--output") + 1])
        output.write_text(
            json.dumps(_payload(_cell(runner_context, case, target), [1, 0, 3])),
            encoding="utf-8",
        )
        return subprocess.CompletedProcess(argv, 0, "", "")

    _, result = _run(
        runner_context,
        _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
        "malformed",
        process=malformed,
        samples=3,
    )
    assert result["status"] == "failed"
    assert result["tests"][0]["exitCode"] == 0
    assert not result["tests"][0]["timedOut"]
    assert "positive integers" in result["tests"][0]["error"]


def test_nonfinite_parameters_fail_without_aborting_suite(runner_context) -> None:

    def nonfinite(argv, **_kwargs):
        case = argv[argv.index("--case") + 1]
        target = argv[argv.index("--target") + 1]
        output = Path(argv[argv.index("--output") + 1])
        payload = _payload(_cell(runner_context, case, target), [1])
        payload["parameters"] = {"invalid": float("nan")}
        output.write_text(json.dumps(payload), encoding="utf-8")
        return subprocess.CompletedProcess(argv, 0, "", "")

    output, result = _run(
        runner_context,
        _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
        "nonfinite",
        process=nonfinite,
        samples=1,
    )
    assert result["status"] == "failed"
    assert "non-finite JSON value" in result["tests"][0]["error"]
    persisted = json.loads((output / "run.json").read_text(encoding="utf-8"))
    assert persisted["status"] == "failed"


@pytest.mark.skipif(not os.name == "posix", reason="process groups require POSIX")
def test_success_does_not_signal_a_reaped_process_group(runner_context) -> None:
    process = mock.Mock(pid=1234, returncode=0)
    process.communicate.return_value = ("out", "error")
    with mock.patch.object(
        runner.subprocess, "Popen", return_value=process
    ), mock.patch.object(runner.os, "killpg") as kill_group:
        completed = runner._run_command(
            ("workload",), cwd=runner_context.root, env={}, timeout=1
        )
    kill_group.assert_not_called()
    assert completed.stdout == "out"
    assert completed.stderr == "error"


@pytest.mark.skipif(not os.name == "posix", reason="process groups require POSIX")
def test_timeout_kills_workload_process_group(runner_context) -> None:
    process = mock.Mock(pid=1234, returncode=-signal.SIGKILL)
    process.communicate.side_effect = [
        subprocess.TimeoutExpired(("workload",), 1),
        ("partial out", "partial error"),
    ]
    with mock.patch.object(
        runner.subprocess, "Popen", return_value=process
    ) as popen, mock.patch.object(runner.os, "killpg") as kill_group, pytest.raises(
        subprocess.TimeoutExpired
    ) as raised:
        runner._run_command(("workload",), cwd=runner_context.root, env={}, timeout=1)
    assert popen.call_args.kwargs["start_new_session"]
    assert popen.call_args.kwargs["encoding"] == "utf-8"
    assert popen.call_args.kwargs["errors"] == "replace"
    kill_group.assert_called_once_with(1234, signal.SIGKILL)
    assert raised.value.stdout == "partial out"
    assert raised.value.stderr == "partial error"


@pytest.mark.skipif(not os.name == "posix", reason="process groups require POSIX")
def test_interrupt_kills_workload_process_group(runner_context) -> None:
    process = mock.Mock(pid=1234)
    process.communicate.side_effect = [
        KeyboardInterrupt("SIGTERM"),
        ("partial out", "partial error"),
    ]
    with mock.patch.object(
        runner.subprocess, "Popen", return_value=process
    ), mock.patch.object(runner.os, "killpg") as kill_group, pytest.raises(
        KeyboardInterrupt
    ) as raised:
        runner._run_command(("workload",), cwd=runner_context.root, env={}, timeout=1)
    kill_group.assert_called_once_with(1234, signal.SIGKILL)
    assert process.communicate.call_count == 2
    assert str(raised.value) == "SIGTERM"
    assert raised.value.stdout == "partial out"
    assert raised.value.stderr == "partial error"


@pytest.mark.skipif(not os.name == "posix", reason="process groups require POSIX")
def test_interrupt_survives_failure_to_drain_output(runner_context) -> None:
    interruption = KeyboardInterrupt("SIGTERM")
    process = mock.Mock(pid=1234)
    process.communicate.side_effect = [interruption, OSError("cannot drain")]
    with mock.patch.object(
        runner.subprocess, "Popen", return_value=process
    ), mock.patch.object(runner.os, "killpg"), pytest.raises(KeyboardInterrupt) as raised:
        runner._run_command(("workload",), cwd=runner_context.root, env={}, timeout=1)
    assert raised.value is interruption


@pytest.mark.parametrize("artifacts_written", [False, True])
def test_interruption_retains_completed_and_unrun_matrix_cells(
    runner_context, artifacts_written
) -> None:
    matrix = _matrix(
        runner_context,
        "triton.rmsnorm_bf16.threads8",
        "triton.gemm_bf16_aligned.threads8",
        "triton.gpt_oss_attention_bf16.threads8",
    )
    calls = 0

    def interrupt_after_first(argv, **kwargs):
        nonlocal calls
        calls += 1
        if calls == 2:
            if artifacts_written:
                _successful_process(runner_context, argv, **kwargs)
            raise runner._CommandInterrupted("SIGTERM", "partial out", "partial error")
        return _successful_process(runner_context, argv, **kwargs)

    with pytest.raises(KeyboardInterrupt):
        _run(
            runner_context,
            matrix,
            "interrupted-partial",
            process=interrupt_after_first,
            samples=1,
            plugin_profile="logging",
        )
    output = runner_context.root / "interrupted-partial"
    raw = json.loads((output / "run.json").read_text())
    assert calls == 2
    assert [test["status"] for test in raw["tests"]] == ["completed", "failed", "failed"]
    assert raw["status"] == "failed"
    assert raw["finishedAt"] is not None
    assert raw["tests"][0]["durationSeconds"] is not None
    assert (output / raw["tests"][0]["artifacts"]["stdout"]).read_text() == "out"
    active = raw["tests"][1]
    assert active["durationSeconds"] is None
    assert active["timing"]["samples"] == []
    assert active["error"] == "workload interrupted: SIGTERM"
    assert not active["timedOut"]
    assert (output / active["artifacts"]["stdout"]).read_text() == "partial out"
    assert (output / active["artifacts"]["stderr"]).read_text() == "partial error"
    assert (output / active["artifacts"]["config"]).is_file()
    if artifacts_written:
        assert (output / active["artifacts"]["workload"]).is_file()
        report = output / active["artifacts"]["pluginReports"]["logging"]
        assert report.read_text() == "logging report\n"
    else:
        assert active["artifacts"]["workload"] is None
        assert active["artifacts"]["pluginReports"] == {}
    assert all(
        (
            value is None
            for key, value in raw["tests"][2]["artifacts"].items()
            if key != "pluginReports"
        )
    )
    assert raw["tests"][2]["artifacts"]["pluginReports"] == {}
    run, catalog = dashboard_publish.normalize_run(
        raw,
        run_id="interrupted",
        trigger="manual",
        branch="develop",
        environment_id="test",
    )
    assert len(catalog["tests"]) == 3
    assert len(run["targets"][0]["results"]) == 3


def test_interruption_finalizes_the_run_artifact(runner_context) -> None:

    def interrupt(_argv, **_kwargs):
        raise KeyboardInterrupt()

    output = runner_context.root / "interrupted"
    with pytest.raises(KeyboardInterrupt):
        _run(
            runner_context,
            _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
            "interrupted",
            process=interrupt,
            samples=1,
        )
    persisted = json.loads((output / "run.json").read_text(encoding="utf-8"))
    assert persisted["status"] == "failed"
    assert persisted["finishedAt"] is not None
    assert len(persisted["tests"]) == 1
    assert persisted["tests"][0]["status"] == "failed"
    assert "interrupted" in persisted["tests"][0]["error"]


@pytest.mark.skipif(os.name != "posix", reason="signals require POSIX")
@pytest.mark.parametrize("signum", [signal.SIGINT, signal.SIGTERM])
def test_signal_preserves_flushed_workload_output(runner_context, signum) -> None:
    ready = runner_context.root / "ready"
    child = runner_context.root / "waiting_workload.py"
    child.write_text(
        "import os, signal, sys\n"
        "from pathlib import Path\n"
        "print('flushed stdout', flush=True)\n"
        "print('flushed stderr', file=sys.stderr, flush=True)\n"
        "ready = Path(sys.argv[1])\n"
        "temporary = ready.with_suffix('.tmp')\n"
        "temporary.write_text(str(os.getpid()))\n"
        "temporary.replace(ready)\n"
        "while True:\n"
        "    signal.pause()\n"
    )
    driver = (
        "import sys\n"
        "from pathlib import Path\n"
        "from unittest.mock import patch\n"
        "from benchmarks import runner\n"
        "with patch.object(runner, '_installed_rocm_path', return_value=Path(sys.argv[1])):\n"
        "    raise SystemExit(runner.main(sys.argv[2:]))\n"
    )
    output = runner_context.root / "signaled"
    process = subprocess.Popen(
        [
            sys.executable,
            "-c",
            driver,
            str(runner_context.rocm),
            "--rocjitsu-source-dir",
            str(runner_context.source),
            "--build-dir",
            str(runner_context.build),
            "--target-config",
            f"gfx950={runner_context.configs['gfx950']}",
            "--target",
            "gfx950",
            "--case",
            "triton.rmsnorm_bf16.threads8",
            "--run-wrapper",
            shlex.join(
                [sys.executable, str(child), str(ready), "--config", "{config}", "--"]
            ),
            "--output",
            str(output),
        ],
        cwd=runner.CORPUS_ROOT,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        start_new_session=True,
    )
    child_reaped = False
    try:
        deadline = time.monotonic() + 10
        while not ready.exists():
            if process.poll() is not None:
                pytest.fail(f"runner exited before readiness: {process.communicate()}")
            if time.monotonic() >= deadline:
                pytest.fail("workload did not signal readiness within 10 seconds")
            time.sleep(0.01)
        child_pid = int(ready.read_text())
        process.send_signal(signum)
        _, stderr = process.communicate(timeout=10)
        assert process.returncode == 130, stderr
        assert "benchmark run interrupted" in stderr
        with pytest.raises(ProcessLookupError):
            os.kill(child_pid, 0)
        child_reaped = True
    finally:
        if not child_reaped and ready.exists():
            with contextlib.suppress(ProcessLookupError):
                os.killpg(int(ready.read_text()), signal.SIGKILL)
        if process.poll() is None:
            process.kill()
        process.communicate(timeout=10)
    raw = json.loads((output / "run.json").read_text())
    assert raw["status"] == "failed"
    assert raw["finishedAt"] is not None
    active = raw["tests"][0]
    assert active["status"] == "failed"
    assert active["durationSeconds"] is None
    assert "interrupted" in active["error"]
    assert (output / active["artifacts"]["stdout"]).read_text() == "flushed stdout\n"
    assert (output / active["artifacts"]["stderr"]).read_text() == "flushed stderr\n"
    assert (output / active["artifacts"]["config"]).is_file()
    assert active["artifacts"]["workload"] is None


def test_existing_output_is_never_overwritten(runner_context) -> None:
    output = runner_context.root / "existing"
    output.mkdir()
    marker = output / "keep"
    marker.write_text("unchanged", encoding="utf-8")
    with mock.patch.object(runner, "_run_command") as process:
        with pytest.raises(runner.RunnerError, match="already exists"):
            runner.run_suite(
                runner_context.suite,
                _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
                build_dir=runner_context.build,
                output=output,
                rocjitsu_source_dir=runner_context.source,
                run_wrapper=runner_context.wrapper,
                target_configs=runner_context.configs,
            )
    process.assert_not_called()
    assert marker.read_text(encoding="utf-8") == "unchanged"


def test_failures_do_not_stop_later_cells(runner_context) -> None:
    calls = 0

    def one_failure(argv, **kwargs):
        nonlocal calls
        calls += 1
        if calls == 1:
            return subprocess.CompletedProcess(argv, 9, "first", "failed")
        return _successful_process(runner_context, argv, **kwargs)

    matrix = _matrix(
        runner_context,
        "triton.rmsnorm_bf16.threads8",
        "triton.gemm_bf16_aligned.threads8",
    )
    output, result = _run(
        runner_context, matrix, "partial", process=one_failure, samples=3
    )
    assert [item["status"] for item in result["tests"]] == ["failed", "completed"]
    persisted = json.loads((output / "run.json").read_text(encoding="utf-8"))
    assert len(persisted["tests"]) == 2
    assert persisted["status"] == "failed"


def test_list_needs_no_build_or_dependency_metadata(runner_context) -> None:
    stdout = io.StringIO()
    with mock.patch.object(
        runner, "_environment_info", side_effect=AssertionError
    ), mock.patch.object(
        runner, "_target_metadata", side_effect=AssertionError
    ), contextlib.redirect_stdout(
        stdout
    ):
        status = runner.main(
            ["--list", "--case", "triton.rmsnorm_bf16.threads8", "--target", "gfx950"]
        )
    assert status == 0
    assert stdout.getvalue() == "triton.rmsnorm_bf16.threads8\tgfx950\n"


@pytest.mark.parametrize(
    "wrapper",
    [
        "",
        "   ",
        "rocjitsu --",
        '"unterminated',
        "{config} --",
        "rocjitsu {config} {config}",
        "rocjitsu --config={config}",
        "rocjitsu {config} --extra={config}",
    ],
)
def test_invalid_run_wrapper(wrapper):
    with pytest.raises(runner.RunnerError):
        runner.parse_run_wrapper(wrapper)


@pytest.mark.parametrize(
    "value",
    [
        "gfx950",
        "gfx950=",
        "=config.json",
        "../gfx950=config.json",
        "gfx950/../x=config.json",
    ],
)
def test_invalid_target_mapping(value):
    with pytest.raises(runner.RunnerError, match="TARGET=PATH"):
        runner.parse_target_configs([value])


def test_target_mappings_resolve_from_invoking_directory(tmp_path, monkeypatch):
    monkeypatch.chdir(tmp_path)
    assert runner.parse_target_configs(["gfx950=config with spaces=1.json"]) == {
        "gfx950": tmp_path / "config with spaces=1.json"
    }
    with pytest.raises(runner.RunnerError, match="duplicate"):
        runner.parse_target_configs(["gfx950=a.json", "gfx950=b.json"])


@pytest.mark.parametrize(
    "target", ["../gfx950", "gfx950/../../outside", "gfx950:feature", ""]
)
def test_manifest_rejects_unsafe_targets(tmp_path, target):
    manifest = tmp_path / "suite.toml"
    manifest.write_text(
        runner.DEFAULT_MANIFEST.read_text().replace(
            'targets = ["gfx950", "gfx1250"]', f"targets = [{json.dumps(target)}]"
        )
    )
    with pytest.raises(runner.RunnerError, match="concrete gfx target|non-empty array"):
        runner.load_manifest(manifest)


def test_manifest_accepts_target_without_builtin_config(tmp_path):
    manifest = tmp_path / "suite.toml"
    manifest.write_text(
        runner.DEFAULT_MANIFEST.read_text().replace("gfx1250", "gfx942")
    )
    assert runner.load_manifest(manifest).targets == ("gfx950", "gfx942")


def test_missing_selected_config_fails_before_execution(runner_context):
    with mock.patch.object(runner, "_run_command") as process:
        with pytest.raises(
            runner.RunnerError, match="missing --target-config.*gfx1250"
        ):
            runner.run_suite(
                runner_context.suite,
                runner.select_matrix(runner_context.suite),
                build_dir=runner_context.build,
                rocjitsu_source_dir=runner_context.source,
                output=runner_context.root / "missing-config",
                run_wrapper=runner_context.wrapper,
                target_configs={"gfx950": runner_context.configs["gfx950"]},
            )
    process.assert_not_called()
    assert not (runner_context.root / "missing-config").exists()


def test_unselected_config_is_not_opened(runner_context):
    runner_context.configs["gfx1250"] = runner_context.root / "does-not-exist.json"
    _, result = _run(
        runner_context,
        _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
        "subset",
        samples=1,
    )
    assert result["status"] == "completed"


def test_config_snapshot_matches_hash_even_if_source_changes(runner_context):
    base = runner_context.configs["gfx950"]
    expected = runner._target_metadata(base, 8)

    def change_source(argv, **kwargs):
        base.write_text(json.dumps({"exec_mode": "changed", "num_threads": 99}))
        return _successful_process(runner_context, argv, **kwargs)

    output, result = _run(
        runner_context,
        _matrix(
            runner_context,
            "triton.rmsnorm_bf16.threads8",
            "triton.gemm_bf16_aligned.threads8",
        ),
        "snapshot",
        process=change_source,
        samples=1,
    )
    assert (
        result["configuration"]["targetConfigSha256"]["gfx950"]
        == expected.config_sha256
    )
    for test in result["tests"]:
        config = output / test["artifacts"]["config"]
        assert json.loads(config.read_text()) == expected.configuration
        assert hashlib.sha256(config.read_bytes()).hexdigest() == expected.config_sha256


def test_wrapper_preserves_quoted_paths_and_literal_shell_arguments(runner_context):
    script = runner_context.root / "launcher with spaces.py"
    script.write_text("import json, sys; print(json.dumps(sys.argv[1:]))\n")
    sentinel = runner_context.root / "must-not-exist"
    literal = f"$(touch {sentinel}); echo unexpected"
    wrapper = shlex.join(
        [sys.executable, str(script), literal, "--config", "{config}", "--"]
    )
    cell = _cell(runner_context, "triton.rmsnorm_bf16.threads8", "gfx950")
    command = runner.prepare_command(
        runner_context.root / "output with spaces",
        cell,
        run_wrapper=runner.parse_run_wrapper(wrapper),
        target=runner._target_metadata(runner_context.configs["gfx950"], 8),
        warmups=1,
        samples=3,
    )
    completed = runner._run_command(
        command.argv, cwd=command.cwd, env=command.environment, timeout=10
    )
    assert completed.returncode == 0
    argv = json.loads(completed.stdout)
    assert argv[:5] == [
        literal,
        "--config",
        str(command.config_path),
        "--",
        sys.executable,
    ]
    assert argv[5] == str(runner.WORKLOAD_ROOT / "triton" / "workloads.py")
    assert not sentinel.exists()


def test_missing_wrapper_executable_fails_cell(runner_context):
    runner_context.wrapper = (
        f'"{runner_context.root / "missing"}" --config {{config}} --'
    )
    _, result = _run(
        runner_context,
        _matrix(runner_context, "triton.rmsnorm_bf16.threads8"),
        "missing-launcher",
        process=runner._run_command,
        samples=1,
    )
    assert result["status"] == "failed"
    assert result["tests"][0]["exitCode"] is None
    assert "No such file" in result["tests"][0]["error"]
