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
from dataclasses import dataclass
from pathlib import Path

SCHEMA = 1
CASE_FIELDS = frozenset({"id", "kernel", "targets", "headers"})


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
    of the checker reports them all.
    """
    manifest = tomllib.loads(path.read_text())
    corpus = manifest.get("corpus", {})
    if corpus.get("schema") != SCHEMA:
        raise InventoryError([f"{path.name}: unsupported corpus schema"])

    problems: list[str] = []
    targets = _corpus_targets(path, corpus.get("targets"), problems)
    cases = tuple(_cases(path, manifest.get("case", []), targets, problems))
    if problems:
        raise InventoryError(problems)
    return Inventory(targets=targets, cases=cases)


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
    path: Path, entries: list[dict], corpus_targets: tuple[str, ...], problems: list[str]
) -> Iterable[Case]:
    seen_ids: set[str] = set()
    seen_kernels: set[str] = set()
    for entry in entries:
        where = f"{path.name} [{entry.get('id', '?')}]"
        for field in sorted(set(entry) - CASE_FIELDS):
            if field == "requires":
                problems.append(f"{where}: 'requires' is now 'targets'")
            else:
                problems.append(f"{where}: unknown field {field!r}")

        case_id, kernel = entry.get("id"), entry.get("kernel")
        for name, value in (("id", case_id), ("kernel", kernel)):
            if not isinstance(value, str) or not value:
                problems.append(f"{where}: {name} must be a non-empty string")
        targets = _string_list(where, "targets", entry.get("targets", []), problems)
        headers = _string_list(where, "headers", entry.get("headers", []), problems)
        for target in targets:
            if target not in corpus_targets:
                problems.append(f"{where}: lists target {target}, which is not in [corpus] targets")

        if case_id in seen_ids:
            problems.append(f"{where}: duplicate id")
        if kernel in seen_kernels:
            problems.append(f"{where}: kernel {kernel} is already used by another case")
        seen_ids.add(case_id)
        seen_kernels.add(kernel)
        yield Case(id=case_id, kernel=kernel, targets=targets, headers=headers)


def _string_list(where: str, name: str, value: object, problems: list[str]) -> tuple[str, ...]:
    if not isinstance(value, list) or not all(isinstance(item, str) for item in value):
        problems.append(f"{where}: {name} must be a list of strings")
        return ()
    return tuple(value)
