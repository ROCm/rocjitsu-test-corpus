# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""
The race corpus's kernel inventory, ``cases.toml``, read and validated in one place.

``regenerate_asm.py`` and ``check_cases.py`` both read the inventory through
:func:`load`, so they accept the same manifests, see the same cases, and apply
the same rule for which targets a case builds for. A change to the schema is a
change here, not in each script.

This module checks the manifest on its own terms: fields, types, uniqueness, and
that every case's targets are corpus targets. Whether the files it names exist
is ``check_cases.py``'s job.
"""

import tomllib
from collections.abc import Iterable
from dataclasses import dataclass, fields
from pathlib import Path

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
    """

    id: str
    kernel: str
    targets: tuple[str, ...]
    headers: tuple[str, ...]

    def builds_for(self, target: str) -> bool:
        """Whether the case builds for *target*, a corpus target."""
        return not self.targets or target in self.targets


# The fields a [[case]] table may have: those of Case.
CASE_FIELDS = frozenset(field.name for field in fields(Case))


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
    """The TOML at *path*, as a table. Raises InventoryError if it cannot be read."""
    try:
        text = path.read_text(encoding="utf-8")
    except OSError as error:
        raise InventoryError([f"{path}: cannot be read ({error.strerror})"]) from error
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
        yield Case(id=case_id, kernel=kernel, targets=targets, headers=headers)


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
