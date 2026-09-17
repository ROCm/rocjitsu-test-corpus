# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Integration between native benchmark selection and normal corpus cases."""

import copy
import dataclasses
import json
from unittest import mock

import pytest

from benchmarks import native, runner
from support.define_contracts import BuildResult, RunContext, TargetSpec


@pytest.fixture
def native_cells():
    return tuple(
        cell
        for cell in runner.select_matrix(runner.load_manifest())
        if cell.definition.corpus_cases
    )


def test_native_matrix_and_target_selection(native_cells):
    assert [cell.target for cell in native_cells] == ["gfx950", "gfx1250"]
    assert len({cell.case for cell in native_cells}) == 2
    suite = runner.load_manifest()
    with pytest.raises(runner.RunnerError, match="do not support"):
        runner.select_matrix(suite, cases=[native_cells[0].case], targets=["gfx1250"])
    assert runner.select_matrix(suite, cases=[native_cells[0].case]) == (
        native_cells[0],
    )


def test_parameters_drive_both_modes(native_cells, tmp_path):
    cell = native_cells[0]
    original = copy.deepcopy(
        cell.definition.corpus_cases[0].metadata["kernel_case"].case
    )
    variant = original["tests"]["m256_n256_k256"]
    variant["parameters"]["k"] = 512
    path = tmp_path / "case.json"
    path.write_text(json.dumps(original))
    loaded = native.kernels_impl.load_case(path)
    case = native.kernels_impl.KernelCase(path, loaded, "m256_n256_k256", variant)
    assert native.kernels_impl.effective_case(case)["run"]["args"] == [
        "--m",
        "256",
        "--n",
        "256",
        "--k",
        "512",
    ]
    for change in ({"k": True}, {"m": 2**32}, {"n": 0}, {"extra": 1}):
        invalid = copy.deepcopy(original)
        invalid["tests"]["m256_n256_k256"]["parameters"].update(change)
        path.write_text(json.dumps(invalid))
        with pytest.raises(ValueError):
            native.kernels_impl.load_case(path)
    variant["test_args"] = []
    path.write_text(json.dumps(original))
    with pytest.raises(ValueError, match="exactly one"):
        native.kernels_impl.load_case(path)


def test_build_reuse_keeps_selected_correctness_variant(native_cells, tmp_path):
    first = native_cells[0].definition.corpus_cases[0]
    context = RunContext(runner.CORPUS_ROOT, tmp_path, False)
    manager = native.BuildManager(context)
    with mock.patch.object(native.kernels, "build") as build:
        native.build(first, manager, tmp_path / "sdk")
        native.build(first, manager, tmp_path / "sdk")
    build.assert_called_once()
    config = build.call_args.args[0].metadata["target_config"]["cmake"][
        "cache_variables"
    ]
    assert config["CMAKE_BUILD_TYPE"] == "Release"
    assert config["ROCM_PATH"] == str(tmp_path / "sdk")
    assert config["KERNEL_CORPUS_ENABLE_ROCBLAS"] == "OFF"

    metadata = copy.deepcopy(first.metadata)
    kernel_case = dataclasses.replace(
        metadata["kernel_case"], test_name="m256_n256_k512"
    )
    kernel_case.test["parameters"]["k"] = 512
    metadata["kernel_case"] = kernel_case
    metadata["effective_case"] = native.kernels_impl.effective_case(kernel_case)
    second = dataclasses.replace(
        first,
        metadata=metadata,
        run={"kind": "kernel_case", "variant": kernel_case.test_name},
    )
    built = BuildResult(tmp_path, tmp_path / "kernel", first.metadata)
    with mock.patch.object(native.kernels_impl, "run_executable") as execute:
        native.kernels.run(second, built, context)
    assert execute.call_args.args[0]["run"]["args"][-1] == "512"


def test_existing_test_arguments_remain_unchanged():
    configs = native.kernels.load_target_configs(native.kernels.default_config_files())
    for target in ("gfx950", "gfx1250"):
        for case in native.kernels.discover(TargetSpec(target), configs):
            test = case.metadata["kernel_case"].test
            if "test_args" in test:
                assert (
                    case.metadata["effective_case"]["run"]["args"] == test["test_args"]
                )


def test_unavailable_capability_rejected(native_cells):
    original = native_cells[0].definition.corpus_cases[0]
    entry = {
        "suite": "kernels",
        "case": original.metadata["name"],
        "variant": original.run["variant"],
    }
    with mock.patch.object(
        native.kernels,
        "discover",
        return_value=[dataclasses.replace(original, expected_run_failure=True)],
    ):
        with pytest.raises(ValueError, match="not runnable"):
            native.resolve(entry, ["gfx950"])
    metadata = copy.deepcopy(original.metadata)
    metadata["effective_case"].pop("benchmark")
    with mock.patch.object(
        native.kernels,
        "discover",
        return_value=[dataclasses.replace(original, metadata=metadata)],
    ):
        with pytest.raises(ValueError, match="no structured benchmark"):
            native.resolve(entry, ["gfx950"])
