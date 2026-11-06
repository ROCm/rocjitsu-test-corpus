# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""
The race corpus's kernel inventory, ``cases.toml``, read and validated in one place.

``regenerate_asm.py`` and ``check_cases.py`` both read the inventory through
:func:`load`, so they accept the same manifests, see the same cases, and apply
the same rule for which targets a case builds for. A change to the schema is a
change here, not in each script.

This module checks the manifest on its own terms: fields, types, uniqueness, and
that every case's targets are corpus targets. Whether the files it names exist,
and whether a case's mutation rules agree with its assembly, is
``check_cases.py``'s job.
"""

import tomllib
from collections.abc import Iterable
from dataclasses import dataclass, field, fields
from pathlib import Path

from detector_protocol import HAZARD_KINDS, RESOURCES

SCHEMA = 1

# The keys cases.toml may have at its top level, and in its [corpus] table. Any
# other is rejected: a misspelled [[case]] table would otherwise leave no cases.
MANIFEST_KEYS = frozenset({"corpus", "case"})
CORPUS_KEYS = frozenset({"schema", "targets"})

# The corpus layout. This module lives in scripts/, beside cases.toml, kernels/
# and asm/; both scripts take their paths from here.
CORPUS_ROOT = Path(__file__).resolve().parent.parent
CASES_PATH = CORPUS_ROOT / "cases.toml"
KERNELS_DIR = CORPUS_ROOT / "kernels"
ASM_DIR = CORPUS_ROOT / "asm"


class InventoryError(ValueError):
    """The manifest is invalid. ``problems`` lists every problem found."""

    def __init__(self, problems: list[str]) -> None:
        super().__init__("\n".join(problems))
        self.problems = problems


# The mutation kinds a case may opt into with ``mutate``.
MUTATION_KINDS = frozenset({"wait", "memory"})

# The keys of a [[case.exempt]] and a [[case.tag]] table. All but ``target``
# are required.
_PIN_KEYS = frozenset({"kind", "ordinal", "site", "target"})
EXEMPTION_KEYS = _PIN_KEYS | {"reason"}
TAG_KEYS = _PIN_KEYS | {"resource", "hazard", "reason"}


@dataclass(frozen=True, kw_only=True)
class SitePin:
    """
    One mutation site of a case, pinned to the instruction found there.

    Attributes:
        kind: The mutation kind, such as ``"wait"``.
        ordinal: Which site of that kind, 0-based, counted as
            ``mutate.find_sites`` counts them.
        site: The instruction's signature, such as ``"s_wait_dscnt 0x0"``;
            see ``mutate.signature``. A site whose ordinal now names a
            different instruction, even one with the same mnemonic, no longer
            matches, so the pin cannot drift onto it.
        target: The one target the pin applies to, or None for every target
            the case builds for. The instruction at an ordinal differs between
            targets, so a portable case's pin usually names one.
    """

    kind: str
    ordinal: int
    site: str
    target: str | None = None

    def names(self, kind: str, ordinal: int, target: str) -> bool:
        """Whether this pin is for site *ordinal* of *kind* on *target*."""
        return (
            self.kind == kind
            and self.ordinal == ordinal
            and self.target in (None, target)
        )


@dataclass(frozen=True, kw_only=True)
class Exemption(SitePin):
    """
    A mutation that provably introduces no race, so its mutant is exempt from
    scoring.

    Attributes:
        reason: Why the mutation introduces no race.
    """

    reason: str


@dataclass(frozen=True, kw_only=True)
class TagOverride(SitePin):
    """
    The scoring tag of a site whose derived tag is wrong, or that has none.

    Attributes:
        resource: The resource tag; see detector_protocol.RESOURCES.
        hazard: The hazard kind; see detector_protocol.HAZARD_KINDS.
        reason: Why the derived tag does not apply.
    """

    resource: str
    hazard: str
    reason: str


@dataclass(frozen=True)
class MutationRules:
    """
    How the mutant generator treats a case. A case with none of these fields
    takes no part in mutation, and has no default rules.

    Attributes:
        mutate: The mutation kinds the case opts into; see MUTATION_KINDS.
        hazard: The hazard pattern the kernel is written around. It describes
            the kernel; each mutant's tag is derived from its own site.
        description: What the kernel exercises, in a sentence.
        waits: Per target, the counters the case's assembly waits on, or None
            if the manifest gives no ``waits`` table.
        exempt: The mutations exempt from scoring.
        tags: The sites whose scoring tag is given rather than derived.
    """

    mutate: tuple[str, ...] = ()
    hazard: str | None = None
    description: str | None = None
    waits: dict[str, tuple[str, ...]] | None = None
    exempt: tuple[Exemption, ...] = ()
    tags: tuple[TagOverride, ...] = ()

    def declared(self) -> bool:
        """Whether the manifest gives the case any mutation rule."""
        return self != MutationRules()

    def exemption_for(self, kind: str, ordinal: int, target: str) -> Exemption | None:
        """The exemption of site *ordinal* of *kind* on *target*, if any."""
        return next((e for e in self.exempt if e.names(kind, ordinal, target)), None)

    def tag_for(self, kind: str, ordinal: int, target: str) -> TagOverride | None:
        """The tag override of site *ordinal* of *kind* on *target*, if any."""
        return next((t for t in self.tags if t.names(kind, ordinal, target)), None)

    def pins(self) -> tuple[SitePin, ...]:
        """Every site this case pins, by exemption or tag override."""
        return self.exempt + self.tags


@dataclass(frozen=True)
class Case:
    """
    One independently buildable kernel.

    Attributes:
        id: Stable selector for the case.
        kernel: Basename under ``kernels/``, without ``.hip``.
        targets: The corpus targets the kernel builds for, as listed in the
            manifest. Empty means every corpus target; see
            :meth:`Inventory.targets_of`.
        headers: Headers outside ROCm's defaults that the kernel includes.
        rules: The case's mutation rules, from its other fields.
    """

    id: str
    kernel: str
    targets: tuple[str, ...]
    headers: tuple[str, ...]
    rules: MutationRules = field(default_factory=MutationRules)

    def builds_for(self, target: str) -> bool:
        """Whether the case builds for *target*, a corpus target."""
        return not self.targets or target in self.targets


# The fields a [[case]] table may have: those of Case, with MutationRules'
# fields in place of ``rules``. MutationRules.tags is the [[case.tag]] array.
CASE_FIELDS = frozenset(
    {item.name for item in fields(Case)} - {"rules"}
    | {item.name for item in fields(MutationRules)} - {"tags"}
    | {"tag"}
)


@dataclass(frozen=True)
class Inventory:
    """
    A validated ``cases.toml``.

    Attributes:
        targets: ``[corpus] targets``, the gfx targets the corpus is built for.
        cases: The cases, in manifest order.
    """

    targets: tuple[str, ...]
    cases: tuple[Case, ...]

    def targets_of(self, case: Case) -> tuple[str, ...]:
        """The corpus targets *case* builds for, in corpus order."""
        return tuple(target for target in self.targets if case.builds_for(target))

    def outputs(self, targets: Iterable[str] | None = None) -> set[tuple[str, str]]:
        """
        The (target, assembly file) pairs the cases produce, for *targets* or
        every corpus target.
        """
        selected = self.targets if targets is None else tuple(targets)
        return {
            (target, f"{case.kernel}.s")
            for target in selected
            for case in self.cases
            if case.builds_for(target)
        }


def load(path: Path) -> Inventory:
    """
    Read and validate the manifest at *path*.

    Raises InventoryError naming every problem, not just the first, so one run
    of the checker reports them all. A file that cannot be read, or is not valid
    TOML, is an InventoryError too, with the underlying error as its cause.
    """
    manifest = _read(path)
    corpus = manifest.get("corpus", {})
    if not isinstance(corpus, dict):
        raise InventoryError([f"{path.name}: [corpus] must be a table"])
    if corpus.get("schema") != SCHEMA:
        raise InventoryError([f"{path.name}: unsupported corpus schema"])

    problems = _unknown_keys(path, manifest=manifest, corpus=corpus)
    targets = _corpus_targets(path, corpus.get("targets"), problems)
    entries = manifest.get("case", [])
    if not isinstance(entries, list) or not all(isinstance(e, dict) for e in entries):
        problems.append(f"{path.name}: case must be a list of [[case]] tables")
        entries = []
    elif not entries:
        problems.append(f"{path.name}: no [[case]] tables")
    cases = tuple(
        _cases(path=path, entries=entries, corpus_targets=targets, problems=problems)
    )
    if problems:
        raise InventoryError(problems)
    return Inventory(targets=targets, cases=cases)


def _unknown_keys(
    path: Path, manifest: dict[str, object], corpus: dict[str, object]
) -> list[str]:
    """A problem for each key of *manifest* or its [corpus] table that is not known."""
    return [
        f"{path.name}: unknown top-level key {key!r}"
        for key in sorted(set(manifest) - MANIFEST_KEYS)
    ] + [
        f"{path.name}: unknown [corpus] key {key!r}"
        for key in sorted(set(corpus) - CORPUS_KEYS)
    ]


def _read(path: Path) -> dict[str, object]:
    """
    The TOML at *path*, as a table. Raises InventoryError, with the underlying
    error as its cause, if it cannot be read, is not valid UTF-8 or is not valid
    TOML.
    """
    try:
        text = path.read_text(encoding="utf-8")
    except OSError as error:
        raise InventoryError([f"{path}: cannot be read ({error.strerror})"]) from error
    except UnicodeDecodeError as error:
        raise InventoryError([f"{path.name}: not valid UTF-8 ({error})"]) from error
    try:
        return tomllib.loads(text)
    except tomllib.TOMLDecodeError as error:
        raise InventoryError([f"{path.name}: not valid TOML ({error})"]) from error


def _corpus_targets(path: Path, value: object, problems: list[str]) -> tuple[str, ...]:
    if (
        not isinstance(value, list)
        or not value
        or not all(isinstance(target, str) and target for target in value)
        or len(set(value)) != len(value)
    ):
        problems.append(
            f"{path.name}: [corpus] targets must list the gfx targets the corpus is "
            f"built for, each once"
        )
        return ()
    return tuple(value)


def _cases(
    path: Path,
    entries: list[dict[str, object]],
    corpus_targets: tuple[str, ...],
    problems: list[str],
) -> Iterable[Case]:
    seen_ids: set[str] = set()
    seen_kernels: set[str] = set()
    for entry in entries:
        where = f"{path.name} [{entry.get('id', '?')}]"
        problems.extend(_field_problems(where, entry))
        case_id, kernel = entry.get("id"), entry.get("kernel")
        targets, headers = (
            _string_list(
                where=where, name=name, value=entry.get(name, []), problems=problems
            )
            for name in ("targets", "headers")
        )
        for target in targets:
            if target not in corpus_targets:
                problems.append(
                    f"{where}: lists target {target}, which is not in [corpus] targets"
                )

        _check_unique(
            case_id, seen=seen_ids, problem=f"{where}: duplicate id", problems=problems
        )
        _check_unique(
            kernel,
            seen=seen_kernels,
            problem=f"{where}: kernel {kernel} is already used by another case",
            problems=problems,
        )
        rules = _mutation_rules(where=where, entry=entry, problems=problems)
        yield Case(
            id=case_id, kernel=kernel, targets=targets, headers=headers, rules=rules
        )


def _mutation_rules(
    where: str, entry: dict[str, object], problems: list[str]
) -> MutationRules:
    """The mutation rules in a case *entry*, with a problem for each invalid one."""
    mutate = _string_list(
        where=where, name="mutate", value=entry.get("mutate", []), problems=problems
    )
    for kind in mutate:
        if kind not in MUTATION_KINDS:
            problems.append(
                f"{where}: mutate lists {kind!r}; known kinds are "
                f"{', '.join(sorted(MUTATION_KINDS))}"
            )
    hazard, description = (
        _optional_string(
            where=where, name=name, value=entry.get(name), problems=problems
        )
        for name in ("hazard", "description")
    )
    exempt = _site_pins(where, entry.get("exempt", []), "exempt", problems)
    tags = _site_pins(where, entry.get("tag", []), "tag", problems)
    return MutationRules(
        mutate=mutate,
        hazard=hazard,
        description=description,
        waits=_waits(where=where, value=entry.get("waits"), problems=problems),
        exempt=tuple(Exemption(**table) for table in exempt),
        tags=tuple(TagOverride(**table) for table in tags),
    )


def _optional_string(
    where: str, name: str, value: object, problems: list[str]
) -> str | None:
    if value is not None and not _is_name(value):
        problems.append(f"{where}: {name} must be a non-empty string")
        return None
    return value


def _waits(
    where: str, value: object, problems: list[str]
) -> dict[str, tuple[str, ...]] | None:
    """A ``waits`` table: each target to the counters its assembly waits on."""
    if value is None:
        return None
    if not isinstance(value, dict):
        problems.append(f"{where}: waits must be a table keyed by target")
        return None
    return {
        target: _string_list(
            where=where, name=f"waits.{target}", value=counters, problems=problems
        )
        for target, counters in value.items()
    }


def _site_pins(
    where: str, value: object, name: str, problems: list[str]
) -> list[dict[str, object]]:
    """
    The valid [[case.<name>]] tables in *value*, *name* being ``exempt`` or
    ``tag``, with a problem for each invalid one.
    """
    if not isinstance(value, list) or not all(isinstance(t, dict) for t in value):
        problems.append(f"{where}: {name} must be a list of [[case.{name}]] tables")
        return []
    valid = []
    for table in value:
        if table_problems := _site_pin_problems(where, table, name):
            problems.extend(table_problems)
        else:
            valid.append(table)
    return valid


def _site_pin_problems(where: str, table: dict[str, object], name: str) -> list[str]:
    """What is wrong with one [[case.<name>]] table."""
    keys = EXEMPTION_KEYS if name == "exempt" else TAG_KEYS
    problems = [
        f"{where}: unknown [[case.{name}]] key {key!r}"
        for key in sorted(set(table) - keys)
    ]
    for key in sorted(keys - {"ordinal", "target"}):
        if not _is_name(table.get(key)):
            problems.append(f"{where}: {name} {key} must be a non-empty string")
    ordinal = table.get("ordinal")
    if not isinstance(ordinal, int) or isinstance(ordinal, bool) or ordinal < 0:
        problems.append(f"{where}: {name} ordinal must be a non-negative integer")
    if table.get("target") is not None and not _is_name(table.get("target")):
        problems.append(f"{where}: {name} target must be a non-empty string")
    for key, known in (
        ("kind", MUTATION_KINDS),
        ("resource", RESOURCES),
        ("hazard", HAZARD_KINDS),
    ):
        if key in keys and _is_name(table.get(key)) and table[key] not in known:
            problems.append(
                f"{where}: {name} {key} {table[key]!r} is not one of "
                f"{', '.join(sorted(known))}"
            )
    return problems


def _field_problems(where: str, entry: dict[str, object]) -> list[str]:
    """Unknown fields in a case *entry*, and an id or kernel that is not a non-empty string."""
    problems = []
    for field in sorted(set(entry) - CASE_FIELDS):
        if field == "requires":
            problems.append(f"{where}: 'requires' is now 'targets'")
        else:
            problems.append(f"{where}: unknown field {field!r}")
    for name in ("id", "kernel"):
        if not _is_name(entry.get(name)):
            problems.append(f"{where}: {name} must be a non-empty string")
    return problems


def _check_unique(
    value: object, seen: set[str], problem: str, problems: list[str]
) -> None:
    """
    Add *problem* if *value* is in *seen*, then add *value* to *seen*. Only a
    valid id or kernel is checked: an invalid one is already reported, and may
    not be hashable.
    """
    if not _is_name(value):
        return
    if value in seen:
        problems.append(problem)
    seen.add(value)


def _is_name(value: object) -> bool:
    """Whether *value* is a valid id or kernel: a non-empty string."""
    return isinstance(value, str) and bool(value)


def _string_list(
    where: str, name: str, value: object, problems: list[str]
) -> tuple[str, ...]:
    if not isinstance(value, list) or not all(isinstance(item, str) for item in value):
        problems.append(f"{where}: {name} must be a list of strings")
        return ()
    return tuple(value)
