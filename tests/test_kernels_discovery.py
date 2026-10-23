# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Kernel manifests can share architecture directories without losing tests."""

import json

from test_suites import kernels_impl


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
