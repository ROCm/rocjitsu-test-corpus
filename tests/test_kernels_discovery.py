# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Kernel manifests can share architecture directories without losing tests."""

import json

from support.define_contracts import BuildResult, CorpusCase, RunContext
from test_suites import kernels, kernels_impl


def test_flat_and_nested_case_discovery(tmp_path, monkeypatch):
    manifests = []
    for relative, name in [
        ("hip-matmul/flat", "flat"),
        ("guitar-hero/rdna4/wave32", "wave32"),
        ("guitar-hero/rdna4/wave64", "wave64"),
    ]:
        directory = tmp_path / "cases" / relative
        directory.mkdir(parents=True)
        manifest = directory / "case.json"
        manifest.write_text(
            json.dumps(
                {
                    "name": name,
                    "project": relative.split("/")[0],
                    "runner": "runner.cpp",
                    "kind": "cmake_executable",
                    "supported_targets": ["gfx1201"],
                    "build": {"system": "cmake", "target": name},
                    "executable": f"cases/{name}",
                    "tests": {
                        "one_group": {
                            "test_args": ["--groups", 1],
                            "validation": {"kind": "exit_code", "pass_exit_code": 0},
                        },
                        "independent_groups": {
                            "test_args": ["--groups", 7],
                            "validation": {"kind": "exit_code", "pass_exit_code": 0},
                        },
                    },
                }
            )
        )
        manifests.append(manifest)

    monkeypatch.setattr(kernels_impl, "KERNEL_CORPUS_ROOT", tmp_path)
    discovered = kernels_impl.discover_cases()
    assert [(case.path, case.test_name, case.test["test_args"]) for case in discovered] == [
        (manifest, test_name, ["--groups", groups])
        for manifest in sorted(manifests)
        for test_name, groups in [("one_group", 1), ("independent_groups", 7)]
    ]


def test_run_uses_current_variant_metadata_when_build_is_cached(tmp_path, monkeypatch):
    current_effective_case = {"test_args": ["--groups", 7]}
    current_target_config = {"skip_run_tests": []}
    current_kernel_case = object()
    run_dir = tmp_path / "independent_groups"
    captured = {}

    monkeypatch.setattr(kernels_impl, "_run_dir", lambda *_args: run_dir)
    monkeypatch.setattr(kernels_impl, "matches_case_selector", lambda *_args: False)
    monkeypatch.setattr(
        kernels_impl,
        "materialize_inputs",
        lambda effective_case, path: (effective_case, path),
    )

    def capture_run(
        effective_case,
        target_config,
        build_dir,
        executable_path,
        actual_run_dir,
        materialized_inputs,
        *,
        run_wrapper,
    ):
        captured.update(
            effective_case=effective_case,
            target_config=target_config,
            run_dir=actual_run_dir,
            materialized_inputs=materialized_inputs,
        )

    monkeypatch.setattr(kernels_impl, "run_executable", capture_run)
    case = CorpusCase(
        id="kernels.gfx1030.guitar-hero.guitar_hero_rdna2.independent_groups",
        suite="kernels",
        target="gfx1030",
        collection=None,
        backend="guitar-hero",
        path=tmp_path / "case.json",
        build={"system": "cmake"},
        run={"kind": "kernel_case", "variant": "independent_groups"},
        metadata={
            "effective_case": current_effective_case,
            "target_config": current_target_config,
            "kernel_case": current_kernel_case,
        },
    )
    cached_result = BuildResult(
        build_dir=tmp_path / "build",
        executable_path=tmp_path / "runner",
        metadata={
            "effective_case": {"test_args": ["--groups", 1]},
            "target_config": {"skip_run_tests": []},
            "run_dir": tmp_path / "one_group",
        },
    )

    kernels.run(
        case,
        cached_result,
        RunContext(tmp_path, tmp_path / "artifacts", False),
    )

    assert captured == {
        "effective_case": current_effective_case,
        "target_config": current_target_config,
        "run_dir": run_dir,
        "materialized_inputs": (current_effective_case, run_dir),
    }
