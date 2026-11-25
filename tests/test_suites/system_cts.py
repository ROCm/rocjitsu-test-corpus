"""Qualify a selected VFIO-enabled rocjitsu build through its corpus-owned CTest registrations."""

import json
from pathlib import Path
import re
import subprocess

import pytest

from support.define_contracts import BuildResult, CorpusCase


def discover(target, binary_dir):
    if target.target != "gfx1250" or not binary_dir:
        raise ValueError(
            "system-cts requires --target gfx1250 and --binary-dir BUILD/tests/system-cts"
        )
    directory = Path(binary_dir).expanduser().resolve(strict=True)
    result = subprocess.run(
        ["ctest", "--test-dir", directory, "--show-only=json-v1"],
        check=True,
        text=True,
        capture_output=True,
    )
    cases = []
    for test in json.loads(result.stdout)["tests"]:
        name = test["name"]
        if name.startswith("SystemCTS."):
            labels = next(
                (p["value"] for p in test["properties"] if p["name"] == "LABELS"), []
            )
            cases.append(
                CorpusCase(
                    id=f"system-cts.{target.target}.{name}",
                    suite="system-cts",
                    target=target.target,
                    collection=None,
                    backend=None,
                    path=directory,
                    build={},
                    run={"name": name},
                    selector_names=(name, name.removeprefix("SystemCTS."), *labels),
                )
            )
    if not cases:
        raise ValueError(f"No SystemCTS tests registered in {directory}")
    return cases


def build(case, _context, _state):
    return BuildResult(build_dir=case.path, executable_path=None)


def run(case, build_result, context):
    if context.skip_all_runs:
        pytest.skip("Runtime execution disabled")
    name = case.run["name"]
    directory = context.artifact_directory / "system-cts" / case.target
    directory.mkdir(parents=True, exist_ok=True)
    log = directory / f"{name}.log"
    with log.open("w") as output:
        result = subprocess.run(
            [
                "ctest",
                "--test-dir",
                build_result.build_dir,
                "--no-tests=error",
                "-V",
                "-R",
                f"^{re.escape(name)}$",
            ],
            stdout=output,
            stderr=subprocess.STDOUT,
        )
    assert result.returncode == 0, f"{name} failed. See {log}"
