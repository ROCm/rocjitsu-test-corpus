# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Check the assembly/host checkpoint layout agreement without requiring a GPU."""

import json
import re
from pathlib import Path

import pytest


CASES = Path(__file__).resolve().parents[1] / "corpus/kernels/cases/guitar-hero"
MANIFESTS = sorted(CASES.rglob("case.json"))


@pytest.mark.parametrize("manifest", MANIFESTS, ids=lambda path: path.parent.name)
def test_checkpoint_layout(manifest):
    case = manifest.parent
    metadata = json.loads(manifest.read_text())
    name = metadata["name"]
    source = (
        case.parent / "guitar_hero_rdna4.s"
        if metadata["supported_targets"] == ["gfx1201"]
        else case / f"{name}.s"
    )
    assembly = source.read_text()
    checkpoints = re.findall(r'"([^"]+)"', (case / "checkpoints.inc").read_text())
    ids = [int(n) for n in re.findall(r"^checkpoint (\d+)$", assembly, re.MULTILINE)]
    assert ids == list(range(len(checkpoints)))
    assert len(set(checkpoints)) == len(checkpoints)

    # Group zero cannot expose a wrong stride; check it even on hosts without HIP.
    strides = re.findall(
        r"^s_mul_i32 s12, (?:ttmp9|s48|s68), (\d+)$", assembly, re.MULTILINE
    )
    assert len(strides) == 1
    assert int(strides[0]) == len(checkpoints) * 64 * 2 * 4

    if name == "guitar_hero_cdna4":
        assert ".wavefront_size: 64" in assembly
        assert ".private_segment_fixed_size: 0" in assembly


def test_registered_cases():
    from test_suites import kernels_impl

    discovered = [
        case
        for case in kernels_impl.discover_cases()
        if case.case["project"] == "guitar-hero"
    ]
    assert {case.path for case in discovered} == set(MANIFESTS)
    for manifest in MANIFESTS:
        variants = [case for case in discovered if case.path == manifest]
        assert {case.test_name for case in variants} == {"one_group", "independent_groups"}
        assert len(variants) == 2
