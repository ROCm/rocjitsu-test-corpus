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

A mutant is identified by ``(target, id)``. ``id`` is ``<kernel>.<kind><NNN>``
and is target-local: its ordinal counts sites in that target's assembly, so the
same id names a different instruction on each target. Selectors and coverage
consumers must key mutants by the pair, as a per-target ``RunReport`` does.
generate() rejects a manifest in which the pair is not unique.

The tags it derives are a best guess and are meant to be reviewed; see
``derive_resource`` for why the wait counter alone does not determine them.

Run this from the repository root after ``regenerate_asm.py`` changes the
assembly, or after editing ``cases.toml``::

    python corpus/race/scripts/generate.py                    # every target
    python corpus/race/scripts/generate.py --target gfx950    # gfx950 only
    python corpus/race/scripts/generate.py --check            # exit 1 if stale
"""

import argparse
import enum
import sys
import tomllib
from dataclasses import dataclass

import inventory
import mutate
from detector_protocol import validate_tags

ASM_DIR = inventory.ASM_DIR
CASES_PATH = inventory.CASES_PATH
MANIFEST_PATH = inventory.CORPUS_ROOT / "mutants.toml"
MANIFEST_SCHEMA = 1


class ExitCode(enum.IntEnum):
    """How a run ended."""

    SUCCESS = 0
    OUT_OF_DATE = 1
    FAILED = 2


class GenerationError(RuntimeError):
    """The manifest cannot be generated; nothing is written."""


@dataclass(frozen=True)
class MutantRow:
    """
    One mutant of the manifest.

    Attributes:
        id: ``<kernel>.<kind><NNN>``; unique with ``target``.
        case: The case's id.
        kernel: The kernel's basename.
        target: The gfx target whose assembly the ordinal counts sites in.
        kind: The mutation kind.
        ordinal: Which site of that kind; see mutate.find_sites.
        resource: The resource tag.
        hazard: The hazard kind tag.
        site: The signature of the instruction at the site.
        exempt_reason: Why the mutant is exempt from scoring, or None.
    """

    id: str
    case: str
    kernel: str
    target: str
    kind: str
    ordinal: int
    resource: str
    hazard: str
    site: str
    exempt_reason: str | None = None

    @classmethod
    def from_table(cls, table: dict[str, object]) -> "MutantRow":
        """The row a [[mutant]] table of a written manifest describes."""
        return cls(
            id=table["id"],
            case=table["case"],
            kernel=table["kernel"],
            target=table["target"],
            kind=table["kind"],
            ordinal=table["ordinal"],
            resource=table["resource"],
            hazard=table["hazard"],
            site=table["site"],
            exempt_reason=table.get("exempt_reason"),
        )


# --- Tagging -----------------------------------------------------------------


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

# The memory a load rewritten as a store races, from the load's address space.
# flat_ is deliberately absent: a flat address can resolve to global memory,
# LDS or scratch, so a case with a flat memory site must say which with
# `resource = "..."`.
_MEMORY_SITE_RESOURCE = (
    ("global_", "global"),
    ("buffer_", "global"),
    ("scratch_", "scratch"),
    ("ds_", "lds"),
)


def _counter_family(site: "mutate.WaitSite") -> str:
    """Which counter the wait drains, from the mnemonic or the legacy operand."""
    if split := _SPLIT_COUNTER.get(site.mnemonic):
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


def _nearest_inflight(
    lines: list[str], line_number: int, families: tuple[str, ...]
) -> str | None:
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


def derive_resource(
    case: inventory.Case,
    site: mutate.WaitSite | mutate.MemorySite,
    lines: list[str],
) -> str:
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

    A load rewritten as a store races the memory itself rather than a
    register, so a ``memory`` site takes the address space of the load.

    A case may still pin its resource with ``resource = "..."`` in cases.toml.
    Tags are committed and reviewable precisely so a wrong guess is corrected
    once and stays corrected. Where a site cannot be attributed at all,
    generation fails rather than guessing.
    """
    if case.rules.resource is not None:
        return case.rules.resource
    if isinstance(site, mutate.MemorySite):
        for prefix, resource in _MEMORY_SITE_RESOURCE:
            if site.load_mnemonic.startswith(prefix):
                return resource
        raise GenerationError(
            f"{case.id}: memory site {site.ordinal} ({site.load_mnemonic}) does not say "
            f'which memory it touches; pin it with resource = "..." in cases.toml'
        )

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
        raise GenerationError(
            f"{case.id}: cannot tell what wait {site.ordinal} ({site.signature}) "
            f"guards: no scalar, DS or vector memory operation within the "
            f'{_INFLIGHT_SCAN_LINES} lines before it. Pin it with resource = "..." '
            f"in cases.toml."
        )
    return "vgpr"


def site_tag(
    case: inventory.Case,
    kind: str,
    site: mutate.WaitSite | mutate.MemorySite,
    lines: list[str],
    target: str,
) -> tuple[str, str]:
    """
    The (resource, hazard) of a mutation of *site*: the resource derived from
    the site, and the hazard the kernel is written around.
    """
    del kind, target
    return derive_resource(case, site, lines), case.rules.hazard


# --- Generation --------------------------------------------------------------


def load_corpus() -> inventory.Inventory:
    """The validated inventory. Raises GenerationError if it is invalid."""
    try:
        return inventory.load(CASES_PATH)
    except inventory.InventoryError as error:
        raise GenerationError(
            f"{CASES_PATH.name} is invalid:\n  " + "\n  ".join(error.problems)
        ) from error


def generate(corpus: inventory.Inventory, targets: list[str]) -> list[MutantRow]:
    """Every mutant of the cases that build for *targets*, target by target."""
    rows: list[MutantRow] = []
    for target in targets:
        for case in corpus.cases:
            if not (case.builds_for(target) and case.rules.mutate):
                continue
            if not (ASM_DIR / target / f"{case.kernel}.s").is_file():
                print(
                    f"  FAIL: {case.id} ({target}): asm/{target}/{case.kernel}.s is "
                    f"missing; run python corpus/race/scripts/regenerate_asm.py",
                    file=sys.stderr,
                )
                continue
            rows += case_rows(case, target)
    check_unique_keys(rows)
    return rows


def case_rows(case: inventory.Case, target: str) -> list[MutantRow]:
    """The mutants of *case* on *target*, one per site of each kind it opts into."""
    asm = ASM_DIR / target / f"{case.kernel}.s"
    lines = asm.read_text(encoding="utf-8").splitlines()
    check_pins(case, target)
    rows = []
    for kind in case.rules.mutate:
        for site in mutate.find_sites(asm, kind):
            resource, hazard = site_tag(case, kind, site, lines, target)
            try:
                validate_tags(resource, hazard, f"{case.id}/{kind}/{site.ordinal}")
            except ValueError as error:
                raise GenerationError(str(error)) from error
            exemption = case.rules.exemption_for(kind, site.ordinal, target)
            rows.append(
                MutantRow(
                    id=f"{case.kernel}.{kind}{site.ordinal:03d}",
                    case=case.id,
                    kernel=case.kernel,
                    target=target,
                    kind=kind,
                    ordinal=site.ordinal,
                    resource=resource,
                    hazard=hazard,
                    site=site.signature,
                    exempt_reason=exemption.reason if exemption else None,
                )
            )
    return rows


def check_pins(case: inventory.Case, target: str) -> None:
    """
    Raise GenerationError if one of *case*'s exemptions or tag overrides for
    *target* names a site whose instruction is not the one it pins. A stale pin
    would silently excuse, or retag, a site nobody has reasoned about.
    """
    asm = ASM_DIR / target / f"{case.kernel}.s"
    listing = f"asm/{target}/{case.kernel}.s"
    for pin in case.rules.pins():
        if pin.target not in (None, target):
            continue
        sites = mutate.find_sites(asm, pin.kind)
        if mismatch := mutate.pin_mismatch(sites, pin.ordinal, pin.site, listing):
            raise GenerationError(
                f"{case.id}: a pinned {pin.kind} {mismatch}. Re-verify the site and "
                f"update its pin in cases.toml, or remove it."
            )


def check_unique_keys(rows: list[MutantRow]) -> None:
    """
    Raise GenerationError naming every (target, id) that more than one row has.
    The pair is the manifest's key; see the module docstring.
    """
    counts: dict[tuple[str, str], int] = {}
    for row in rows:
        key = (row.target, row.id)
        counts[key] = counts.get(key, 0) + 1
    if duplicates := sorted(key for key, count in counts.items() if count > 1):
        named = ", ".join(f"{target}/{mutant_id}" for target, mutant_id in duplicates)
        raise GenerationError(
            f"mutants.toml: (target, id) must be unique, but these repeat: {named}. "
            f"Two cases may share a kernel in cases.toml."
        )


# --- The manifest ------------------------------------------------------------


def _toml_escape(text: str) -> str:
    return text.replace("\\", "\\\\").replace('"', '\\"')


def render_manifest(rows: list[MutantRow], targets: list[str]) -> str:
    """Emit mutants.toml. Written by hand so the output stays diff-friendly."""
    lines = [
        "# GENERATED by corpus/race/scripts/generate.py -- do not hand-edit,",
        "# but DO correct a wrong `resource` or `hazard` tag: the derivation is a",
        "# best guess (see derive_resource) and a mis-tag silently moves a case in",
        "# or out of a detector's scope. Pin a correction in cases.toml so it",
        "# survives the next regeneration.",
        "#",
        "# Each entry is a recipe, not assembly: `ordinal` names the Nth mutation",
        "# site of its kind in asm/<target>/<kernel>.s, counted in emission order,",
        "# and `site` is the instruction found there. That assembly is committed",
        "# and frozen, so this manifest only changes when regenerate_asm.py is run",
        "# or cases.toml is edited.",
        "#",
        "# A mutant is identified by (target, id), which is unique in this file.",
        "# `id` is target-local: the same id names a different instruction on",
        "# each target, so key mutants by the pair, never by id alone.",
        "",
        "[manifest]",
        f"schema = {MANIFEST_SCHEMA}",
        "targets = [" + ", ".join(f'"{t}"' for t in targets) + "]",
        "",
    ]
    for row in rows:
        lines += _render_row(row)
    return "\n".join(lines)


def _render_row(row: MutantRow) -> list[str]:
    lines = [
        "[[mutant]]",
        f'id = "{row.id}"',
        f'case = "{row.case}"',
        f'kernel = "{row.kernel}"',
        f'target = "{row.target}"',
        f'kind = "{row.kind}"',
        f"ordinal = {row.ordinal}",
        f'resource = "{row.resource}"',
        f'hazard = "{row.hazard}"',
        f'site = "{_toml_escape(row.site)}"',
    ]
    if row.exempt_reason is not None:
        lines += [
            "exempt = true",
            f'exempt_reason = "{_toml_escape(row.exempt_reason)}"',
        ]
    return lines + [""]


# --- Command line ------------------------------------------------------------


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Write corpus/race/mutants.toml from the committed assembly."
    )
    parser.add_argument(
        "--target",
        action="append",
        default=[],
        help="Corpus target to enumerate for; repeat for several. Default: every one.",
    )
    parser.add_argument(
        "--check",
        action=argparse.BooleanOptionalAction,
        default=False,
        help="Do not write; exit 1 if the manifest would change.",
    )
    return parser


def main(argv: list[str]) -> ExitCode:
    parser = _build_parser()
    args = parser.parse_args(argv)
    try:
        corpus = load_corpus()
        targets = args.target or sorted(corpus.targets)
        rows = generate(corpus, targets)
    except GenerationError as error:
        print(f"error: {error}", file=sys.stderr)
        return ExitCode.FAILED
    rendered = render_manifest(rows, targets)
    if args.check:
        current = (
            MANIFEST_PATH.read_text(encoding="utf-8") if MANIFEST_PATH.is_file() else ""
        )
        if current != rendered:
            print(
                "mutants.toml is out of date; re-run without --check", file=sys.stderr
            )
            return ExitCode.OUT_OF_DATE
        print("mutants.toml is up to date")
        return ExitCode.SUCCESS
    MANIFEST_PATH.write_text(rendered, encoding="utf-8")
    _print_summary(rows)
    return ExitCode.SUCCESS


def _print_summary(rows: list[MutantRow]) -> None:
    tags: dict[tuple[str, str], int] = {}
    for row in rows:
        tags[(row.resource, row.hazard)] = tags.get((row.resource, row.hazard), 0) + 1
    print(f"wrote {MANIFEST_PATH.name}: {len(rows)} mutants")
    for (resource, hazard), count in sorted(tags.items()):
        print(f"  {resource:7} {hazard:17} {count}")


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
