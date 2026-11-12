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

Each mutant's tag is derived from its own site; see ``site_tag``. A site the
derivation cannot tag, and one it tags wrongly, is settled in ``cases.toml``,
and generation fails until it is.

Run this from the repository root after ``regenerate_asm.py`` changes the
assembly, or after editing ``cases.toml``::

    python corpus/race/scripts/generate.py                    # every target
    python corpus/race/scripts/generate.py --target gfx950    # gfx950 only
    python corpus/race/scripts/generate.py --check            # exit 1 if stale

The manifest holds every corpus target. ``--target`` regenerates the rows of
the named targets and keeps the others as committed, and ``--check`` compares
what would be written. Nothing is written unless every selected case's
assembly is present, so an incomplete corpus never truncates the manifest.
"""

import argparse
import enum
import sys
import tomllib
from dataclasses import dataclass

import exposure
import inventory
import mutate
from detector_protocol import validate_tags

ASM_DIR = inventory.ASM_DIR
CASES_PATH = inventory.CASES_PATH
MANIFEST_PATH = inventory.CORPUS_ROOT / "mutants.toml"
MANIFEST_SCHEMA = 1

# The race a load rewritten as a store opens with other threads' reads of the
# same memory, from the load's address space. flat_ is absent: a flat address
# may be global memory, LDS or scratch, so such a site needs a [[case.tag]].
_MEMORY_SITE_TAGS = (
    ("global_", "global", "GlobalMemoryRace"),
    ("buffer_", "global", "GlobalMemoryRace"),
    ("ds_", "lds", "LocalMemoryRace"),
)


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


def site_tag(
    case: inventory.Case,
    kind: str,
    site: mutate.WaitSite | mutate.MemorySite,
    lines: list[str],
    target: str,
) -> tuple[str, str]:
    """
    The (resource, hazard) a mutation of *site* exposes.

    A ``[[case.tag]]`` for the site gives it. Otherwise a load rewritten as a
    store races other threads' reads of its address space, and a removed wait
    exposes the first dependency on what it retired; see exposure.py. Raises
    GenerationError where neither applies.
    """
    where = f"{case.id} ({target}): {kind} ordinal {site.ordinal} ({site.signature})"
    if (override := case.rules.tag_for(kind, site.ordinal, target)) is not None:
        return override.resource, override.hazard
    if isinstance(site, mutate.MemorySite):
        return _memory_site_tag(where, site)
    try:
        tag = exposure.expose(lines, site.line_number, target)
    except exposure.AttributionError as error:
        raise GenerationError(f"{where}: {error}") from error
    if tag is None:
        raise GenerationError(
            f"{where}: removing the wait exposes nothing a later instruction depends "
            f"on. Exempt it with [[case.exempt]] if that is right, and give its tag "
            f"with [[case.tag]]."
        )
    return tag.resource, tag.hazard


def _memory_site_tag(where: str, site: mutate.MemorySite) -> tuple[str, str]:
    for prefix, resource, hazard in _MEMORY_SITE_TAGS:
        if site.load_mnemonic.startswith(prefix):
            return resource, hazard
    raise GenerationError(
        f"{where}: {site.load_mnemonic} does not say which memory it touches; give "
        f"the site's tag with [[case.tag]] in cases.toml"
    )


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
    """
    Every mutant of the cases that build for *targets*, target by target.

    Raises GenerationError, before generating anything, if a case's assembly
    is missing, since the manifest would silently lose its mutants.
    """
    selected = [
        (target, case)
        for target in targets
        for case in corpus.cases
        if case.builds_for(target) and case.rules.mutate
    ]
    if missing := [
        f"asm/{target}/{case.kernel}.s"
        for target, case in selected
        if not (ASM_DIR / target / f"{case.kernel}.s").is_file()
    ]:
        raise GenerationError(
            f"missing assembly, so the manifest would lose its mutants: "
            f"{', '.join(missing)}. Run python corpus/race/scripts/regenerate_asm.py."
        )
    rows = [row for target, case in selected for row in case_rows(case, target)]
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


def committed_rows() -> tuple[tuple[str, ...], list[MutantRow]]:
    """The targets and rows of the committed manifest; none if there is none."""
    if not MANIFEST_PATH.is_file():
        return (), []
    manifest = tomllib.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    return (
        tuple(manifest.get("manifest", {}).get("targets", [])),
        [MutantRow.from_table(table) for table in manifest.get("mutant", [])],
    )


def manifest_rows(
    corpus: inventory.Inventory, selected: list[str]
) -> tuple[list[str], list[MutantRow]]:
    """
    The targets and rows of the manifest to write: every corpus target, with
    the rows of *selected* regenerated and the others kept as committed.

    Raises GenerationError if an unselected target has no committed rows to
    keep, since writing would drop them.
    """
    targets = sorted(corpus.targets)
    fresh = generate(corpus, selected)
    kept_targets, kept = committed_rows()
    if unkept := [t for t in targets if t not in selected and t not in kept_targets]:
        raise GenerationError(
            f"mutants.toml has no rows for {', '.join(unkept)} to keep; regenerate "
            f"them too, or run without --target"
        )
    rows = [
        row
        for target in targets
        for row in (fresh if target in selected else kept)
        if row.target == target
    ]
    return targets, rows


def _toml_escape(text: str) -> str:
    return text.replace("\\", "\\\\").replace('"', '\\"')


def render_manifest(rows: list[MutantRow], targets: list[str]) -> str:
    """Emit mutants.toml. Written by hand so the output stays diff-friendly."""
    lines = [
        "# GENERATED by corpus/race/scripts/generate.py -- do not edit by hand.",
        "# Each mutant's `resource` and `hazard` tag is derived from its site,",
        "# and a mis-tag silently moves it in or out of a detector's scope, so",
        "# correct one with a [[case.tag]] in cases.toml and regenerate.",
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
        help=(
            "Corpus target to regenerate; repeat for several. The other targets' "
            "rows are kept as committed. Default: every corpus target."
        ),
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
        if unknown := sorted(set(args.target) - set(corpus.targets)):
            parser.error(f"--target {', '.join(unknown)}: not a corpus target")
        selected = args.target or sorted(corpus.targets)
        targets, rows = manifest_rows(corpus, selected)
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
