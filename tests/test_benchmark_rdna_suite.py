# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""RDNA recipe preserves existing benchmark definitions and eligibility."""

from pathlib import Path
import json
import tomllib

import pytest

from benchmarks import runner

ROOT = Path(__file__).resolve().parents[1]


def test_performance_v2_preserves_original_cdna_definitions():
    original = tomllib.loads(
        (ROOT / "benchmarks/suites/performance-v1.toml").read_text()
    )
    expanded = tomllib.loads(
        (ROOT / "benchmarks/suites/performance-v2.toml").read_text()
    )
    assert expanded["name"] == "performance-v2"
    for setting in ("warmups", "samples", "timeout_seconds"):
        assert expanded[setting] == original[setting]
    by_id = {case["id"]: case for case in expanded["cases"]}
    assert len(by_id) == len(expanded["cases"])
    for case in original["cases"]:
        preserved = dict(by_id[case["id"]])
        overrides = preserved.pop("thread_policy_overrides", {})
        assert not set(overrides).intersection(case["targets"])
        preserved["targets"] = [
            target for target in preserved["targets"] if target in case["targets"]
        ]
        assert preserved == case


def test_rdna_dependency_pins_match_existing_stack():
    pins = {}
    for line in (ROOT / "benchmarks/requirements.txt").read_text().splitlines():
        if "==" in line and not line.startswith(("#", "--")):
            package, version = line.split("==", 1)
            pins[package] = version
    for target in ("gfx1100", "gfx1201"):
        assert pins[f"rocm-sdk-device-{target}"] == pins["rocm-sdk-device-gfx950"]
        assert pins[f"amd-torch-device-{target}"] == pins["torch"]


def test_runner_records_rdna_device_package_provenance():
    assert {
        "rocm-sdk-device-gfx1100",
        "rocm-sdk-device-gfx1201",
        "amd-torch-device-gfx1100",
        "amd-torch-device-gfx1201",
    } <= set(runner.PACKAGE_NAMES)


@pytest.mark.parametrize(
    "workload,provider,script",
    [
        ("full_tensile", "full_tensile", "full_tensile/workload.py"),
        ("gluon_copy", "gluon", "gluon/workloads.py"),
        ("gluon_copy_2d", "gluon", "gluon/workloads.py"),
        ("llama_rope", "llama", "llama/workloads.py"),
        ("llama_matvec", "llama", "llama/workloads.py"),
        ("llama_gather", "llama", "llama/workloads.py"),
    ],
)
def test_rdna_provider_registration_and_workload_protocol(
    tmp_path, runner_context, workload, provider, script
):
    manifest = tmp_path / "provider.toml"
    manifest.write_text(
        'name = "provider-probe"\nwarmups = 0\nsamples = 1\ntimeout_seconds = 60\n'
        f'[[cases]]\nid = "example.provider"\nworkload = "{workload}"\n'
        'suite = "Example"\nname = "Provider"\noperation = "Example"\n'
        'targets = ["gfx1100"]\nthread_policies = ["default"]\n'
        'params = { dtype = "fp32" }\n'
    )
    suite = runner.load_manifest(manifest)
    cell = runner.select_matrix(suite)[0]
    command = runner.prepare_command(
        tmp_path / "output",
        cell,
        run_wrapper=runner.parse_run_wrapper(runner_context.wrapper),
        target=runner.TargetMetadata({}),
        warmups=0,
        samples=1,
    )
    assert str(runner.WORKLOAD_ROOT / script) in command.argv
    assert (runner.WORKLOAD_ROOT / script).is_file()
    command.workload_path.write_text(
        json.dumps(
            {
                "schema": "rocjitsu.benchmark.workload.v1",
                "case": cell.case,
                "target": cell.target,
                "provider": provider,
                "parameters": {"dtype": "fp32"},
                "timings_ns": [3000000000],
            }
        )
    )
    assert runner.validate_workload(command.workload_path, cell, 1) == [3.0]


def test_performance_v2_has_exact_planned_target_policy_matrix():
    suite = runner.load_manifest(ROOT / "benchmarks/suites/performance-v2.toml")
    matrix = runner.select_matrix(suite)
    assert len(matrix) == 66
    assert len({(c.case, c.target, c.thread_policy) for c in matrix}) == 66
    expected = {
        "triton.persistent_1024x4096x4096": ("default",),
        "triton.grouped_4x2048": ("default",),
        "triton.softmax_65536x2048": ("default",),
        "triton.layernorm_65536x2048": ("default",),
        "gluon.copy_fp32_100663296": ("single",),
        "gluon.copy_2d_fp32_16384x8192": ("default",),
        "full_tensile.valu_3072x2048x1024": ("default",),
        "full_tensile.tensor_2048x2048x16x64": ("default",),
        "full_tensile.splitk_3072x2048x1536_gsu3": ("default",),
        "full_tensile.pointer_8x1024x1024x1024": ("default",),
        "llama.rope_128x4096x32": ("default",),
        "llama.matvec_q4_4096x32768": ("default", "single"),
        "llama.gather_q8_4096x1024x4096": ("default",),
    }
    rdna = {
        (c.case, c.target, c.thread_policy)
        for c in matrix
        if c.target in ("gfx1100", "gfx1201")
    }
    assert rdna == {
        (case, target, policy)
        for case, policies in expected.items()
        for target in ("gfx1100", "gfx1201")
        for policy in policies
    }
    original = runner.load_manifest(ROOT / "benchmarks/suites/performance-v1.toml")
    assert [
        (c.case, c.target, c.thread_policy)
        for c in runner.select_matrix(suite, targets=("gfx950", "gfx1250"))
    ] == [(c.case, c.target, c.thread_policy) for c in runner.select_matrix(original)]
