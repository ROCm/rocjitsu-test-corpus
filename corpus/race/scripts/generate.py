#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""
Enumerate every mutation site in the committed assembly and write
``mutants.toml``.

Reads ``asm/<target>/<kernel>.s`` and never invokes a compiler, so this needs no
ROCm install. The assembly is frozen in the repository precisely so the set of
mutation sites is fixed: the compiler decides how many ``s_wait_*`` a kernel
contains and one mutant is derived per wait, so compiling here would let a
toolchain bump silently reshape the corpus.

Why a committed manifest rather than discovery at run time: pytest collection
happens before any build, so per-mutant case IDs have to be readable with no
toolchain present. The manifest holds *recipes* -- ``(kernel, kind, ordinal)``
plus the tags scoring needs -- which are applied to the committed assembly when
a case is built.

Run this after ``regenerate_asm.py`` changes the assembly, or after editing tags
in ``cases.toml``::

    python scripts/generate.py --target gfx950
    python scripts/generate.py --target gfx950 --target gfx1250   # both

The tags it derives are a best guess and are meant to be reviewed; see
``derive_resource`` for why the wait counter alone does not determine them.
"""

from __future__ import annotations

import argparse
import sys
import tomllib
from dataclasses import dataclass
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import mutate  # noqa: E402
from detector_protocol import validate_tags  # noqa: E402

CORPUS_ROOT = Path(__file__).resolve().parent.parent
ASM_DIR = CORPUS_ROOT / "asm"
MANIFEST_PATH = CORPUS_ROOT / "mutants.toml"
MANIFEST_SCHEMA = 1


# --- Tagging -----------------------------------------------------------------


@dataclass(frozen=True)
class Exemption:
    """
    A mutation that provably does not introduce a race.

    Some edits are no-ops: a wait already satisfied by an earlier one on the
    path the kernel takes can be removed with no effect. A detector reporting
    nothing there is *correct*, so scoring it as a miss would penalise the
    right answer. ``site`` pins the exemption to a specific instruction so it
    cannot drift onto a different one when codegen changes.
    """

    kind: str
    ordinal: int
    site: str
    reason: str


@dataclass(frozen=True)
class Case:
    id: str
    kernel: str
    requires: list[str]
    mutate: list[str]
    access: str
    hazard: str
    resource: str | None  # optional override; see derive_resource
    exempt: tuple[Exemption, ...] = ()

    def exemption_for(self, kind: str, ordinal: int) -> Exemption | None:
        for entry in self.exempt:
            if entry.kind == kind and entry.ordinal == ordinal:
                return entry
        return None


# Which counter family a wait drains. Two eras have to be handled: gfx12-era
# targets use split mnemonics, while CDNA and earlier put everything on the
# combined `s_waitcnt` and name the counters in the operand. gfx950 emits only
# the latter, so keying on the mnemonic alone tags the entire corpus `vgpr`.
_SPLIT_COUNTER = {
    "s_wait_loadcnt": "vm",
    "s_wait_storecnt": "vm",
    "s_wait_samplecnt": "vm",
    "s_wait_bvhcnt": "vm",
    "s_wait_expcnt": "vm",
    "s_wait_kmcnt": "smem",
    "s_wait_dscnt": "lds",
    "s_wait_tensorcnt": "tensor",
    "s_wait_asynccnt": "tensor",
}

# What each kind of in-flight operation leaves unguarded when its wait is gone.
_INFLIGHT_RESOURCE = (
    ("ds_", "lds"),  # LDS read/write: the slot and its ordering
    ("s_load", "sgpr"),  # scalar memory: destination SGPR
    ("s_buffer_load", "sgpr"),
    ("tensor_load", "lds"),  # tensor DMA lands in LDS
    ("tensor_store", "lds"),
    ("scratch_", "vgpr"),  # scratch load: destination VGPR
    ("buffer_load", "vgpr"),
    ("global_load", "vgpr"),
    ("flat_load", "vgpr"),
    ("global_store", "vgpr"),  # store: the source VGPR may be overwritten
    ("flat_store", "vgpr"),
    ("buffer_store", "vgpr"),
)

_INFLIGHT_SCAN_LINES = 40


def _counter_family(site: "mutate.WaitSite") -> str:
    """Which counter the wait drains, from the mnemonic or the legacy operand."""
    if (split := _SPLIT_COUNTER.get(site.mnemonic)):
        return split
    operand = site.full_line
    has_lgkm = "lgkmcnt" in operand
    has_vm = "vmcnt" in operand or "vscnt" in operand
    if has_lgkm and not has_vm:
        return "lgkm"
    if has_vm and not has_lgkm:
        return "vm"
    if has_lgkm and has_vm:
        return "both"
    return "unknown"


def _nearest_inflight(lines: list[str], line_number: int, families: tuple[str, ...]) -> str | None:
    """
    Resource of the nearest preceding operation this wait could be draining.

    Scanning backwards is what disambiguates the legacy combined counter:
    `lgkmcnt` retires scalar memory and LDS as one sequence, so the mnemonic
    says nothing, but the instruction actually in flight does.
    """
    start = max(0, line_number - _INFLIGHT_SCAN_LINES)
    for idx in range(line_number - 1, start - 1, -1):
        stripped = lines[idx].strip()
        if not stripped or stripped.startswith((";", ".")):
            continue
        for prefix, resource in _INFLIGHT_RESOURCE:
            if stripped.startswith(prefix) and resource in families:
                return resource
    return None


def derive_resource(case: Case, site, lines: list[str]) -> str:
    """
    Best guess at the resource a mutation races, with the case free to override.

    The wait counter is not the resource. Removing a ``vmcnt`` wait on a global
    load leaves an unguarded *register* -- the load's destination VGPR -- even
    though the data came from global memory, which is why a global-memory-only
    detector correctly sees nothing there.

    And on CDNA the counter is not even a family: ``lgkmcnt`` retires scalar
    memory and LDS as a single sequence, so the same mnemonic guards a kernarg
    ``s_load`` in one place and a ``ds_write`` a few lines later. The nearest
    preceding memory operation is what actually says which, so that is what is
    consulted.

    A case may still pin its resource with ``resource = "..."`` in cases.toml.
    Tags are committed and reviewable precisely so a wrong guess is corrected
    once and stays corrected.
    """
    if case.resource is not None:
        return case.resource
    if isinstance(site, mutate.MemorySite):
        # A load rewritten as a store races the memory itself, not a register.
        return case.access

    family = _counter_family(site)
    if family == "tensor":
        return "lds"
    if family == "lds":
        return _nearest_inflight(lines, site.line_number, ("lds", "vgpr")) or "lds"
    if family == "smem":
        return "sgpr"
    if family == "vm":
        return _nearest_inflight(lines, site.line_number, ("vgpr",)) or "vgpr"
    if family in ("lgkm", "both"):
        # The ambiguous case: scalar memory and LDS share this counter.
        found = _nearest_inflight(lines, site.line_number, ("lds", "sgpr", "vgpr"))
        if found is not None:
            return found
        return "lds" if case.access == "lds" else "sgpr"
    return "vgpr"


def derive_hazard_kind(case: Case, site) -> str:
    """
    The hazard kind a mutation induces.

    Taken from the kernel's declared intent: a kernel is written to exercise one
    pattern, and the mutation exposes that pattern rather than inventing a
    different one.
    """
    del site
    return case.hazard


# --- Manifest ----------------------------------------------------------------


def load_cases() -> list[Case]:
    manifest = tomllib.loads((CORPUS_ROOT / "cases.toml").read_text())
    if manifest.get("corpus", {}).get("schema") != 1:
        raise SystemExit("cases.toml: unsupported corpus schema")
    return [
        Case(
            id=entry["id"],
            kernel=entry["kernel"],
            requires=entry.get("requires", []),
            mutate=entry.get("mutate", ["wait"]),
            access=entry["access"],
            hazard=entry["hazard"],
            resource=entry.get("resource"),
            exempt=tuple(
                Exemption(
                    kind=e["kind"],
                    ordinal=e["ordinal"],
                    site=e["site"],
                    reason=e["reason"],
                )
                for e in entry.get("exempt", [])
            ),
        )
        for entry in manifest["case"]
    ]


def _toml_escape(text: str) -> str:
    return text.replace("\\", "\\\\").replace('"', '\\"')


def render_manifest(rows: list[dict], targets: list[str]) -> str:
    """Emit mutants.toml. Written by hand so the output stays diff-friendly."""
    lines = [
        "# GENERATED by scripts/generate.py -- do not hand-edit mechanically,",
        "# but DO correct a wrong `resource` or `hazard` tag: the derivation is a",
        "# best guess (see derive_resource) and a mis-tag silently moves a case in",
        "# or out of a detector's scope. Pin a correction in cases.toml so it",
        "# survives the next regeneration.",
        "#",
        "# Each entry is a recipe, not assembly: `ordinal` names the Nth mutation",
        "# site of its kind in asm/<target>/<kernel>.s, counted in emission order.",
        "# That assembly is committed and frozen, so this manifest only changes",
        "# when regenerate_asm.py is run or cases.toml is edited.",
        "",
        "[manifest]",
        f"schema = {MANIFEST_SCHEMA}",
        "targets = [" + ", ".join(f'"{t}"' for t in targets) + "]",
        "",
    ]
    for row in rows:
        lines += [
            "[[mutant]]",
            f'id = "{row["id"]}"',
            f'case = "{row["case"]}"',
            f'kernel = "{row["kernel"]}"',
            f'target = "{row["target"]}"',
            f'kind = "{row["kind"]}"',
            f'ordinal = {row["ordinal"]}',
            f'resource = "{row["resource"]}"',
            f'hazard = "{row["hazard"]}"',
            f'site = "{_toml_escape(row["site"])}"',
        ]
        if row.get("exempt"):
            lines += [
                "exempt = true",
                f'exempt_reason = "{_toml_escape(row["exempt_reason"])}"',
            ]
        lines.append("")
    return "\n".join(lines)


def _targets_in_asm() -> list[str]:
    """
    Every target the committed assembly covers.

    Derived from the tree rather than defaulted to one target, so that adding a
    target means adding its assembly and nothing else.
    """
    if not ASM_DIR.is_dir():
        raise SystemExit(f"{ASM_DIR} is missing; run scripts/regenerate_asm.py first")
    targets = sorted(path.name for path in ASM_DIR.iterdir() if path.is_dir())
    if not targets:
        raise SystemExit(f"{ASM_DIR} holds no target directories")
    return targets


def generate(targets: list[str]) -> list[dict]:
    cases = load_cases()
    rows: list[dict] = []
    skipped: list[str] = []
    failed: list[str] = []

    for target in targets:
        for case in cases:
            if case.requires and target not in case.requires:
                skipped.append(f"{case.id} ({target}): requires {', '.join(case.requires)}")
                continue

            asm = ASM_DIR / target / f"{case.kernel}.s"
            if not asm.is_file():
                failed.append(
                    f"{case.id} ({target}): {asm.relative_to(CORPUS_ROOT)} is missing; "
                    "run scripts/regenerate_asm.py"
                )
                continue

            lines = asm.read_text().splitlines()
            for kind in case.mutate:
                for site in mutate.find_sites(asm, kind):
                    resource = derive_resource(case, site, lines)
                    hazard = derive_hazard_kind(case, site)
                    validate_tags(resource, hazard, f"{case.id}/{kind}/{site.ordinal}")
                    label = (
                        site.mnemonic
                        if isinstance(site, mutate.WaitSite)
                        else site.load_mnemonic
                    )
                    row = {
                        "id": f"{case.kernel}.{kind}{site.ordinal:03d}",
                        "case": case.id,
                        "kernel": case.kernel,
                        "target": target,
                        "kind": kind,
                        "ordinal": site.ordinal,
                        "resource": resource,
                        "hazard": hazard,
                        "site": label,
                    }
                    if (exemption := case.exemption_for(kind, site.ordinal)) is not None:
                        # Verified now rather than at run time: if codegen moved
                        # this ordinal onto a different instruction, the
                        # exemption is stale and would silently excuse a site
                        # nobody has reasoned about.
                        if label != exemption.site:
                            raise SystemExit(
                                f"{case.id}: exemption for {kind} ordinal "
                                f"{exemption.ordinal} expects {exemption.site!r}, but "
                                f"{target} codegen puts {label!r} there. Re-verify why "
                                f"the mutation is harmless and update the exemption in "
                                f"cases.toml, or remove it."
                            )
                        row["exempt"] = True
                        row["exempt_reason"] = exemption.reason
                    rows.append(row)

    for note in skipped:
        print(f"  skip: {note}")
    for note in failed:
        print(f"  FAIL: {note}", file=sys.stderr)
    return rows


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--target",
        action="append",
        default=[],
        help=(
            "gfx target to enumerate for; repeat for several. "
            "Default: every target present under asm/."
        ),
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="Do not write; exit non-zero if the manifest would change.",
    )
    args = parser.parse_args()

    targets = args.target or _targets_in_asm()
    print(f"enumerating {', '.join(targets)} from {ASM_DIR.relative_to(CORPUS_ROOT.parent.parent)}")

    rows = generate(targets)
    if not rows:
        print("no mutation sites found; refusing to write an empty manifest", file=sys.stderr)
        return 2

    rendered = render_manifest(rows, targets)
    if args.check:
        current = MANIFEST_PATH.read_text() if MANIFEST_PATH.is_file() else ""
        if current != rendered:
            print("mutants.toml is out of date; re-run without --check", file=sys.stderr)
            return 1
        print("mutants.toml is up to date")
        return 0

    MANIFEST_PATH.write_text(rendered)
    kinds = {}
    for row in rows:
        kinds[row["resource"]] = kinds.get(row["resource"], 0) + 1
    print(f"\nwrote {MANIFEST_PATH.relative_to(CORPUS_ROOT.parent.parent)}: {len(rows)} mutants")
    print(f"  by resource: {kinds}")
    print("\nReview the resource/hazard tags before committing: they are derived,")
    print("and a wrong tag silently moves a case in or out of a detector's scope.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
