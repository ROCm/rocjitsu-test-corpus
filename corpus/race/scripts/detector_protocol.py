# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""
The contract a race detector implements to be scored against this corpus.

Detectors differ in two ways that both have to be absorbed here, because a
corpus that assumes either one ends up serving exactly one tool:

**When they consume.** A static analyzer reads a code object and never runs it.
A dynamic one needs a linked executable and a launcher. So an adapter is handed
every artifact level and decides for itself what to do with them, rather than
being called back inside a run the corpus orchestrates.

**What they detect.** Detectors cover different resources and different hazard
kinds, and the two do not factor into independent sets. rocjitsu's
``race_detector`` finds WAW on registers but not on LDS, so a detector's
capability is a set of ``(resource, kind)`` *pairs*; treating it as
resources x kinds would claim LDS WAW support it does not have. Every mutant
carries the pair it injects, every detector declares the pairs it supports, and
cases outside the intersection are skipped and dropped from the denominator --
never recorded as misses.

Resource and hazard names here are the corpus's own, not any one detector's
internal spelling. Adapters map them onto their tool's vocabulary.
"""

from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path
from typing import Any, Mapping, Protocol, runtime_checkable

REPORT_SCHEMA = 1

# --- Corpus vocabulary -------------------------------------------------------

# Where a hazard lands. Memory first, then registers.
RESOURCES = frozenset(
    {
        "global",  # device-visible memory
        "lds",     # workgroup-shared local data share
        "scratch", # per-thread private memory
        "vgpr",    # vector register
        "agpr",    # accumulation vector register
        "sgpr",    # scalar register
    }
)

# What kind of hazard it is.
HAZARD_KINDS = frozenset(
    {
        "RAW",
        "WAR",
        "WAW",
        "LocalMemoryRace",   # cross-wave race on LDS
        "GlobalMemoryRace",  # cross-workgroup race on global memory
    }
)


def capability(
    resources: set[str] | frozenset[str],
    kinds: set[str] | frozenset[str],
    *,
    without: set[tuple[str, str]] | frozenset[tuple[str, str]] = frozenset(),
) -> frozenset[tuple[str, str]]:
    """
    Build a capability set from a cross-product minus the pairs a tool lacks.

    Most detectors cover a rectangle of the matrix with a few holes punched in
    it, so declaring the rectangle and naming the holes reads better than
    enumerating every pair -- and the holes are exactly where a comment
    explaining the gap belongs.
    """
    for resource, kind in without:
        validate_tags(resource, kind, "capability(without=...)")
    return frozenset(
        (resource, kind)
        for resource in resources
        for kind in kinds
        if (resource, kind) not in without
    )


class DetectorUnavailable(RuntimeError):
    """
    The detector's tool is not present, so it cannot be asked anything.

    Distinct from "found nothing": a missing binary or an unreadable report must
    never be scored as a clean run, because that is indistinguishable from a
    detector that works perfectly and reports no hazard. The suite turns this
    into a skip that names what was missing.
    """


class DetectorError(RuntimeError):
    """
    The detector ran but could not complete its analysis.

    Also never scored as zero hazards, for the same reason: a misconfigured
    run that analyzes nothing looks exactly like a clean one.
    """


class Verdict(str, Enum):
    """Outcome of scoring one case against one detector."""

    DETECTED = "detected"  # in scope, and the detector reported a hazard
    MISSED = "missed"  # in scope, and it did not
    SKIPPED = "skipped"  # out of this detector's scope; not scored
    BASELINE_DIRTY = "baseline-dirty"  # the unmutated kernel already reports
    # The mutation provably introduces no race, so reporting nothing is the
    # right answer. Distinct from SKIPPED: that is about what a detector
    # covers, this is about the mutant itself being a no-op, and it applies
    # to every detector equally.
    EXEMPT = "exempt"


# --- What a detector is given and what it returns ----------------------------


@dataclass(frozen=True)
class MutantArtifacts:
    """
    Every level of a built mutant, so a detector can take what it needs.

    A static detector stops at ``code_object``. A dynamic one needs
    ``executable``, which is ``None`` when the suite ran under
    ``--skip-all-runs``; a detector with ``needs_execution`` set will not be
    asked to run in that case.
    """

    asm: Path
    code_object: Path
    executable: Path | None
    workdir: Path  # scratch space for reports, logs and configs
    target: str  # the gfx target these artifacts were built for


@dataclass(frozen=True)
class Detection:
    """What a detector found. ``count`` is the oracle; the rest is context."""

    count: int
    resources: frozenset[str] = frozenset()  # resources named, if the tool says
    raw: str = ""  # native report text, kept for failure messages
    command: str = ""  # what was actually invoked, for reproduction


@runtime_checkable
class Detector(Protocol):
    """
    One race detector, adapted to the corpus.

    The adapter owns its whole workflow -- deciding whether to analyze or
    execute, invoking its tool, and parsing whatever that tool emits. The corpus
    never parses a native format.
    """

    name: str
    supports: frozenset[tuple[str, str]]  # (resource, hazard_kind) pairs
    needs_execution: bool

    def detect(self, artifacts: MutantArtifacts, run_wrapper: str | None) -> Detection: ...


# --- Capability scoping ------------------------------------------------------


def out_of_scope_reason(
    detector: Detector,
    resource: str,
    hazard_kind: str,
) -> str | None:
    """
    Why *detector* cannot be expected to find this hazard, or None if it can.

    The pair is checked as a unit. A detector may cover the resource in general
    and the kind in general while lacking that specific combination -- which is
    exactly rocjitsu's ``race_detector`` on LDS WAW -- so scoring it as a miss
    there would be wrong.
    """
    if (resource, hazard_kind) in detector.supports:
        return None

    resources = {pair[0] for pair in detector.supports}
    kinds_here = sorted(pair[1] for pair in detector.supports if pair[0] == resource)
    if resource not in resources:
        return (
            f"{detector.name} does not detect hazards on {resource} "
            f"(covers: {', '.join(sorted(resources))})"
        )
    return (
        f"{detector.name} does not implement {hazard_kind} on {resource} "
        f"(on {resource} it implements: {', '.join(kinds_here)})"
    )


def score(baseline: Detection, mutant: Detection) -> Verdict:
    """
    Score one in-scope mutant.

    The baseline must be clean: a corpus kernel that already reports a hazard
    before anything is injected says nothing about the mutant, and is a defect
    in the corpus or a false positive in the detector. Either way it is reported
    rather than folded into the score.
    """
    if baseline.count != 0:
        return Verdict.BASELINE_DIRTY
    return Verdict.DETECTED if mutant.count > 0 else Verdict.MISSED


def validate_tags(resource: str, hazard_kind: str, where: str) -> None:
    """Reject a manifest tag outside the corpus vocabulary, naming its source."""
    if resource not in RESOURCES:
        raise ValueError(
            f"{where}: unknown resource {resource!r}; known: {', '.join(sorted(RESOURCES))}"
        )
    if hazard_kind not in HAZARD_KINDS:
        raise ValueError(
            f"{where}: unknown hazard kind {hazard_kind!r}; "
            f"known: {', '.join(sorted(HAZARD_KINDS))}"
        )


# --- Run report --------------------------------------------------------------


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


@dataclass
class RunReport:
    """
    Machine-readable result of one detector's pass over the corpus.

    Stamped with the manifest digest so a report can always be tied back to the
    exact corpus revision that produced it, the way the semantics suite's run
    reports are.
    """

    detector: str
    target: str
    manifest_sha256: str
    cases: list[dict[str, Any]] = field(default_factory=list)
    metadata: dict[str, Any] = field(default_factory=dict)

    def add(
        self,
        *,
        case_id: str,
        verdict: Verdict,
        resource: str,
        hazard_kind: str,
        baseline_count: int | None = None,
        mutant_count: int | None = None,
        detail: str = "",
    ) -> None:
        self.cases.append(
            {
                "case": case_id,
                "verdict": verdict.value,
                "resource": resource,
                "hazard_kind": hazard_kind,
                "baseline_count": baseline_count,
                "mutant_count": mutant_count,
                "detail": detail,
            }
        )

    def summary(self) -> dict[str, int]:
        """Counts per verdict, plus the in-scope denominator the score uses."""
        counts = {v.value: 0 for v in Verdict}
        for row in self.cases:
            counts[row["verdict"]] += 1
        counts["in_scope"] = (
            counts[Verdict.DETECTED.value] + counts[Verdict.MISSED.value]
        )
        return counts

    def write(self, path: Path) -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(
            json.dumps(
                {
                    "schema": REPORT_SCHEMA,
                    "detector": self.detector,
                    "corpus": {
                        "target": self.target,
                        "manifest_sha256": self.manifest_sha256,
                    },
                    "metadata": self.metadata,
                    "summary": self.summary(),
                    "cases": self.cases,
                },
                indent=2,
                sort_keys=True,
            )
            + "\n"
        )



def load_report(path: Path) -> Mapping[str, Any]:
    """Read a run report, rejecting one that does not meet the schema."""
    try:
        report = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as error:
        raise ValueError(f"cannot read run report {path}: {error}") from error
    if not isinstance(report, dict) or report.get("schema") != REPORT_SCHEMA:
        raise ValueError(f"{path}: unsupported run-report schema")
    corpus = report.get("corpus")
    if not isinstance(corpus, dict) or not isinstance(corpus.get("target"), str):
        raise ValueError(f"{path}: run report contains invalid corpus identity")
    if len(str(corpus.get("manifest_sha256", ""))) != 64:
        raise ValueError(f"{path}: run report has no valid manifest digest")
    if not isinstance(report.get("cases"), list):
        raise ValueError(f"{path}: run report contains no cases")
    return report
