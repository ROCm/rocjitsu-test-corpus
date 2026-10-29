# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
from dataclasses import dataclass
from pathlib import Path

import pytest

from support.race_corpus import import_module

protocol = import_module("detector_protocol")

CLEAN = protocol.Detection(count=0)
DIRTY = protocol.Detection(count=2)
FOUND = protocol.Detection(count=1)


@dataclass(frozen=True)
class FakeDetector:
    """A detector that only declares what it covers."""

    name: str
    supports: frozenset[tuple[str, str]]
    needs_execution: bool = False

    def detect(
        self, artifacts: "protocol.MutantArtifacts", run_wrapper: str | None
    ) -> "protocol.Detection":
        raise AssertionError("scoping never runs the detector")


# --- Scoring one mutant ----------------------------------------------------------


@pytest.mark.parametrize(
    "baseline, mutant, verdict",
    [
        (CLEAN, FOUND, protocol.Verdict.DETECTED),
        (CLEAN, CLEAN, protocol.Verdict.MISSED),
        # A dirty baseline says nothing about the mutant, whatever it reports.
        (DIRTY, FOUND, protocol.Verdict.BASELINE_DIRTY),
        (DIRTY, CLEAN, protocol.Verdict.BASELINE_DIRTY),
    ],
    ids=["clean, found", "clean, missed", "dirty, found", "dirty, missed"],
)
def test_score(
    baseline: "protocol.Detection",
    mutant: "protocol.Detection",
    verdict: "protocol.Verdict",
) -> None:
    assert protocol.score(baseline, mutant) == verdict


# --- The run report --------------------------------------------------------------


def report_with(*verdicts: "protocol.Verdict") -> "protocol.RunReport":
    report = protocol.RunReport(detector="d", target="gfx950", manifest_sha256="0" * 64)
    for number, verdict in enumerate(verdicts):
        report.add(
            case_id=f"k.wait{number:03d}",
            verdict=verdict,
            resource="vgpr",
            hazard_kind="RAW",
        )
    return report


def test_summary_denominator_counts_only_scored_mutants() -> None:
    v = protocol.Verdict
    report = report_with(
        v.DETECTED,
        v.DETECTED,
        v.MISSED,
        v.SKIPPED,
        v.EXEMPT,
        v.BASELINE_DIRTY,
    )
    summary = report.summary()
    assert summary["in_scope"] == 3
    assert {verdict.value: summary[verdict.value] for verdict in v} == {
        "detected": 2,
        "missed": 1,
        "skipped": 1,
        "exempt": 1,
        "baseline-dirty": 1,
    }


def test_summary_of_an_empty_report_has_every_verdict() -> None:
    summary = report_with().summary()
    assert summary == {verdict.value: 0 for verdict in protocol.Verdict} | {
        "in_scope": 0
    }


def test_report_round_trips(tmp_path: Path) -> None:
    report = report_with(protocol.Verdict.DETECTED)
    path = tmp_path / "report.json"
    report.write(path)
    loaded = protocol.load_report(path)
    assert loaded["corpus"] == {"target": "gfx950", "manifest_sha256": "0" * 64}
    assert loaded["summary"] == report.summary()
    assert loaded["cases"] == report.cases


@pytest.mark.parametrize(
    "text, problem",
    [
        ("{", "cannot read run report"),
        ('{"schema": 0}', "unsupported run-report schema"),
        ('{"schema": 1, "corpus": {}}', "invalid corpus identity"),
        (
            '{"schema": 1, "corpus": {"target": "gfx950", "manifest_sha256": "x"}}',
            "no valid manifest digest",
        ),
    ],
)
def test_invalid_report_is_rejected(tmp_path: Path, text: str, problem: str) -> None:
    path = tmp_path / "report.json"
    path.write_text(text)
    with pytest.raises(ValueError, match=problem):
        protocol.load_report(path)


# --- Capability scoping ----------------------------------------------------------


def test_capability_is_a_rectangle_minus_its_holes() -> None:
    supported = protocol.capability(
        {"vgpr", "lds"}, {"RAW", "WAW"}, without={("lds", "WAW")}
    )
    assert supported == {("vgpr", "RAW"), ("vgpr", "WAW"), ("lds", "RAW")}


def test_capability_hole_must_use_the_vocabulary() -> None:
    with pytest.raises(ValueError, match="unknown resource 'lds2'"):
        protocol.capability({"lds"}, {"RAW"}, without={("lds2", "RAW")})


def test_scope_is_decided_by_the_pair() -> None:
    detector = FakeDetector(
        name="d",
        supports=protocol.capability(
            {"vgpr", "lds"}, {"RAW", "WAW"}, without={("lds", "WAW")}
        ),
    )
    assert protocol.out_of_scope_reason(detector, "vgpr", "RAW") is None
    assert protocol.out_of_scope_reason(detector, "lds", "WAW") == (
        "d does not implement WAW on lds (on lds it implements: RAW)"
    )
    assert protocol.out_of_scope_reason(detector, "sgpr", "RAW") == (
        "d does not detect hazards on sgpr (covers: lds, vgpr)"
    )


@pytest.mark.parametrize(
    "resource, hazard, problem",
    [
        ("register", "RAW", "unknown resource 'register'"),
        ("vgpr", "race", "unknown hazard kind 'race'"),
    ],
)
def test_tag_outside_the_vocabulary_is_rejected(
    resource: str, hazard: str, problem: str
) -> None:
    with pytest.raises(ValueError, match=f"where: {problem}"):
        protocol.validate_tags(resource, hazard, "where")
