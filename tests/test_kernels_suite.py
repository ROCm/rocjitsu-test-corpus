# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Runtime variants share compiled kernels while keeping their own run state."""

import struct
from collections import defaultdict
from pathlib import Path

import pytest

from support.define_contracts import RunContext, TargetSpec
from support.manage_builds import BuildManager
from test_suites import kernels


@pytest.fixture
def kernel_session(tmp_path, monkeypatch):
    commands = []

    def command(argv, *, cwd, log_path, phase, env, expected_returncode=0):
        log_path.parent.mkdir(parents=True, exist_ok=True)
        log_path.write_text(" ".join(argv))
        commands.append((argv, log_path, phase, env, expected_returncode))

    # Keep discovery, build caching, input generation and launch construction real.
    monkeypatch.setattr(kernels.legacy_kernels, "_run_command", command)
    context = RunContext(
        repo_root=kernels.legacy_kernels.REPO_ROOT,
        artifact_directory=tmp_path,
        skip_all_runs=False,
    )
    return context, BuildManager(context), commands


def guitar_hero_cases(target):
    configs = kernels.load_target_configs(
        [kernels.legacy_kernels.KERNEL_CORPUS_ROOT / "configs" / f"{target}.json"]
    )
    return [
        case
        for case in kernels.discover(TargetSpec(target), configs)
        if case.backend == "guitar-hero"
    ]


@pytest.mark.parametrize("target", ["gfx1100", "gfx1201", "gfx950", "gfx1250"])
@pytest.mark.parametrize("reverse", [False, True])
def test_cached_build_preserves_runtime_arguments_and_logs(
    kernel_session, target, reverse
):
    context, manager, commands = kernel_session
    cases = guitar_hero_cases(target)
    assert len(cases) == (4 if target == "gfx1201" else 2)
    if reverse:
        cases.reverse()
    builds = defaultdict(list)
    for case in cases:
        result = manager.ensure_built(case, kernels)
        builds[case.path].append(result)
        kernels.run(case, result, context)

    assert all(
        len(results) == 2 and results[0] is results[1]
        for results in builds.values()
    )
    assert sum(phase == "build" for _, _, phase, _, _ in commands) == len(builds)
    runs = [entry for entry in commands if entry[2] == "run"]
    assert len(runs) == len(cases)
    assert len({log_path for _, log_path, _, _, _ in runs}) == len(cases)
    for case, (argv, log_path, _, _, _) in zip(cases, runs):
        variant = case.run["variant"]
        groups = "1" if variant == "one_group" else "7"
        assert argv[-2:] == ["--groups", groups]
        assert log_path.parent.name == variant
        assert log_path.parent.parent.name == case.path.parent.name
        assert log_path.read_text().endswith(f"--groups {groups}")


def test_cached_build_preserves_runtime_inputs_environment_and_validation(
    kernel_session,
):
    context, manager, commands = kernel_session
    cases = [
        case for case in guitar_hero_cases("gfx1201")
        if case.metadata["name"] == "guitar_hero"
    ]
    assert len(cases) == 2
    for case, value in zip(cases, [1, 7]):
        effective = case.metadata["effective_case"]
        effective["run"]["env"] = {"KERNEL_VARIANT": str(value)}
        effective["validation"] = {"kind": "exit_code", "pass_exit_code": value}
        effective["inputs"] = [
            {
                "name": "data",
                "format": "raw",
                "dtype": "f32",
                "shape": [2],
                "generator": {
                    "kind": "repeat_affine", "period": 2,
                    "scale": 1, "offset": value,
                },
            }
        ]
        result = manager.ensure_built(case, kernels)
        kernels.run(case, result, context)

    assert sum(phase == "build" for _, _, phase, _, _ in commands) == 1
    runs = [entry for entry in commands if entry[2] == "run"]
    assert len(runs) == 2
    inputs = []
    for value, (argv, log_path, _, env, expected_returncode) in zip([1, 7], runs):
        path = Path(argv[argv.index("--input") + 1].split("=", 1)[1])
        inputs.append(path)
        assert path.parent.parent == log_path.parent
        assert struct.unpack("<2f", path.read_bytes()) == (value, value + 1)
        assert env["KERNEL_VARIANT"] == str(value)
        assert expected_returncode == value
    assert inputs[0] != inputs[1]
