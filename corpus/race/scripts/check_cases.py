#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""
Check that ``cases.toml`` agrees with ``kernels/`` and the committed ``asm/``.

This needs no compiler: it checks the kernel inventory against the files on
disk::

    python corpus/race/scripts/check_cases.py            # exit 1 on any problem
    python corpus/race/scripts/check_cases.py --suggest  # print derived waits tables

Its guarantee is about the inventory only: every case has its source and its
assembly, and every assembly file belongs to a case. It does not check that
the assembly is up to date with its source. A kernel whose signature or body
changed without regenerating its ``.s`` still passes. That needs the manual
``regenerate_asm.py --check``, which compiles every case and compares the
result with the committed assembly.

The corpus's target set is ``[corpus] targets`` in ``cases.toml``, not whatever
happens to be under ``asm/``, so a target whose assembly is missing entirely is
caught. It checks that:

* ``[corpus] targets`` names at least one target, and ``asm/`` has a directory
  for each and for nothing else;
* the manifest is valid, as ``inventory.load`` checks it: only known tables,
  keys and fields, at least one case, unique ids and kernels, and every target
  in a case's ``targets`` a corpus target;
* every case has ``kernels/<kernel>.hip`` and, for each target it builds for,
  ``asm/<target>/<kernel>.s``;
* every ``kernels/*.hip`` belongs to a case;
* every ``asm/<target>/*.s`` belongs to a case that builds for that target, and
  ``asm/<target>/`` holds nothing but those listings and its recipe.toml, since
  regeneration would remove anything else;
* every ``asm/<target>/*.s`` declares ``.amdgcn_target`` for that target, which
  catches an empty file or a listing copied into the wrong directory. This is a
  sanity check on the files, not proof that they match their source;
* every ``asm/<target>/`` has the ``recipe.toml`` that ``regenerate_asm.py``
  writes beside the assembly, with all of its fields, so a regeneration commit
  that leaves it out is caught.

For a case with mutation rules (any of ``mutate``, ``hazard``, ``waits`` and
the other fields ``generate.py`` reads), it also checks that:

* ``waits`` has exactly one entry per target the case builds for, and that
  entry lists exactly the counters the target's assembly waits on (see
  ``wait_counters``);
* each ``[[case.exempt]]`` names, at its ordinal, the instruction its
  ``site`` signature says it does. Sites are counted, and pins
  matched, by ``mutate``, as ``generate.py`` counts and matches them.
"""

import argparse
import enum
import re
import sys
from pathlib import Path

import inventory
import mutate
import recipe


class ExitCode(enum.IntEnum):
    """How a check ended."""

    SUCCESS = 0
    PROBLEMS_FOUND = 1


# The corpus layout, from inventory. Bound here so that a test can point a run
# at a scratch corpus.
CORPUS_ROOT = inventory.CORPUS_ROOT
CASES_PATH = inventory.CASES_PATH
KERNELS_DIR = inventory.KERNELS_DIR
ASM_DIR = inventory.ASM_DIR

# The directive hipcc writes at the top of each listing, naming the target
# triple and processor, e.g. "amdgcn-amd-amdhsa-unknown-gfx950:xnack-". Group 1
# is the processor, without target features.
_AMDGCN_TARGET_RE = re.compile(
    r'^\s*\.amdgcn_target\s+"[^"]*-([^-":]+)(?::[^"]*)?"', re.MULTILINE
)


def wait_counters(asm: Path) -> set[str]:
    """
    Every counter some wait site in *asm* drains, with sites counted as
    mutate.find_wait_sites counts them, so excluding what it excludes.
    """
    return {
        counter for site in mutate.find_wait_sites(asm) for counter in site.counters
    }


def asm_targets() -> list[str]:
    if not ASM_DIR.is_dir():
        return []
    return sorted(path.name for path in ASM_DIR.iterdir() if path.is_dir())


def target_mismatch(asm: Path, target: str) -> str | None:
    """Why *asm* is not a listing for *target*, or None if it is."""
    declared = _AMDGCN_TARGET_RE.findall(asm.read_text(errors="replace"))
    if not declared:
        return f"asm/{target}/{asm.name}: no .amdgcn_target directive"
    for processor in declared:
        if processor != target:
            return (
                f"asm/{target}/{asm.name}: .amdgcn_target is {processor}, not {target}"
            )
    return None


def recipe_problems(target: str) -> list[str]:
    """What is wrong with *target*'s recipe.toml, as recipe.load reports it."""
    where = f"asm/{target}/{recipe.FILE_NAME}"
    try:
        loaded = recipe.load(ASM_DIR / target / recipe.FILE_NAME)
    except recipe.RecipeError as error:
        return [f"{where}: {problem}" for problem in error.problems]
    if loaded is None:
        return [f"{where} is missing; regenerate {target} to write it"]
    return []


def stray_entries(target: str) -> list[str]:
    """
    Each entry of ``asm/<target>/`` that is neither a ``.s`` listing nor
    recipe.toml. Regeneration replaces the directory with exactly those, so it
    would remove anything else.
    """
    return [
        f"asm/{target}/{entry.name}{'/' if entry.is_dir() else ''}: not a listing or "
        f"{recipe.FILE_NAME}; regenerating {target} would remove it"
        for entry in sorted((ASM_DIR / target).iterdir())
        if entry.is_dir() or (entry.suffix != ".s" and entry.name != recipe.FILE_NAME)
    ]


def case_file_problems(corpus: inventory.Inventory) -> list[str]:
    """
    Each case's missing source or listing, and each kernel source that no case
    uses, such as one left behind by a removed or misspelled case.
    """
    problems: list[str] = []
    for case in corpus.cases:
        where = f"{CASES_PATH.name} [{case.id}]"
        if not (KERNELS_DIR / f"{case.kernel}.hip").is_file():
            problems.append(f"{where}: kernels/{case.kernel}.hip is missing")
        for target in corpus.targets_of(case):
            if not (ASM_DIR / target / f"{case.kernel}.s").is_file():
                problems.append(f"{where}: asm/{target}/{case.kernel}.s is missing")
    used = {f"{case.kernel}.hip" for case in corpus.cases}
    for source in sorted(KERNELS_DIR.glob("*.hip")):
        if source.name not in used:
            problems.append(f"kernels/{source.name}: no case uses it")
    return problems


def mutation_problems(corpus: inventory.Inventory) -> list[str]:
    """
    Where a case's mutation rules disagree with its committed assembly: its
    ``waits`` table, and its exemption ordinals. A case without mutation rules
    is not checked, and a missing listing is left to case_file_problems.
    """
    problems: list[str] = []
    for case in corpus.cases:
        if case.rules.declared():
            problems.extend(
                _case_mutation_problems(case=case, targets=corpus.targets_of(case))
            )
    return problems


def _case_mutation_problems(
    case: inventory.Case, targets: tuple[str, ...]
) -> list[str]:
    where = f"{CASES_PATH.name} [{case.id}]"
    waits = case.rules.waits
    if waits is None:
        example = targets[0] if targets else "<target>"
        return [
            f"{where}: waits must be a table keyed by target, e.g. "
            f"waits = {{ {example} = [...] }}"
        ]
    problems = [
        f"{where}: waits names {target}, which the case does not build for"
        for target in sorted(set(waits) - set(targets))
    ]
    for target in targets:
        asm = ASM_DIR / target / f"{case.kernel}.s"
        if asm.is_file():
            problems.extend(
                _wait_problems(
                    where, target=target, declared=waits.get(target), asm=asm
                )
            )
            problems.extend(_pin_problems(where, case=case, target=target, asm=asm))
    return problems


def _wait_problems(
    where: str, target: str, declared: tuple[str, ...] | None, asm: Path
) -> list[str]:
    """Whether *declared*, a case's waits for *target*, is what *asm* waits on."""
    actual = wait_counters(asm)
    if declared is None:
        return [
            f"{where}: waits has no {target} entry; the asm waits on {sorted(actual)}"
        ]
    if set(declared) == actual and len(declared) == len(set(declared)):
        return []
    detail = []
    if missing := sorted(actual - set(declared)):
        detail.append(f"asm also waits on {missing}")
    if extra := sorted(set(declared) - actual):
        detail.append(f"asm never waits on {extra}")
    if len(declared) != len(set(declared)):
        detail.append("duplicate entries")
    return [f"{where}: waits.{target} {list(declared)}: {'; '.join(detail)}"]


def _pin_problems(
    where: str, case: inventory.Case, target: str, asm: Path
) -> list[str]:
    """Whether each of *case*'s pins for *target* names the instruction it says."""
    problems: list[str] = []
    listing = f"asm/{target}/{case.kernel}.s"
    for pin in case.rules.pins():
        if pin.target not in (None, target):
            continue
        sites = mutate.find_sites(asm, pin.kind)
        if mismatch := mutate.pin_mismatch(sites, pin.ordinal, pin.site, listing):
            problems.append(f"{where}: exempt {pin.kind} {mismatch}")
    return problems


def suggest(corpus: inventory.Inventory) -> None:
    """Print the waits table each case's committed assembly implies."""
    for case in corpus.cases:
        entries = []
        for target in corpus.targets_of(case):
            asm = ASM_DIR / target / f"{case.kernel}.s"
            counters = sorted(wait_counters(asm)) if asm.is_file() else []
            quoted = ", ".join(f'"{counter}"' for counter in counters)
            entries.append(f"{target} = [{quoted}]")
        print(f"{case.id:24} waits = {{ {', '.join(entries)} }}")


def check(corpus: inventory.Inventory) -> list[str]:
    """
    Every mismatch between a validated inventory and the files on disk.

    The manifest itself (fields, targets, uniqueness) has already been checked
    by inventory.load; this compares it with kernels/ and asm/.
    """
    errors: list[str] = []
    present = asm_targets()
    for target in corpus.targets:
        if target not in present:
            errors.append(f"asm/{target}/ is missing")
    for target in present:
        if target not in corpus.targets:
            errors.append(
                f"asm/{target}/ is not a corpus target; add it to [corpus] targets"
            )

    errors.extend(case_file_problems(corpus))
    errors.extend(mutation_problems(corpus))

    owned = corpus.outputs()
    for target in sorted(set(corpus.targets) & set(present)):
        errors.extend(recipe_problems(target))
        errors.extend(stray_entries(target))
        for asm in sorted((ASM_DIR / target).glob("*.s")):
            if (target, asm.name) not in owned:
                errors.append(
                    f"asm/{target}/{asm.name}: no case builds {asm.stem} for {target}"
                )
            if (mismatch := target_mismatch(asm, target)) is not None:
                errors.append(mismatch)
    return errors


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Check cases.toml against kernels/ and the committed asm/, without a compiler."
    )
    parser.add_argument(
        "--suggest",
        action=argparse.BooleanOptionalAction,
        default=False,
        help="Print the waits table each case's committed assembly implies, and exit.",
    )
    return parser


def main(argv: list[str]) -> ExitCode:
    args = _build_parser().parse_args(argv)
    try:
        corpus = inventory.load(CASES_PATH)
    except inventory.InventoryError as error:
        _print_problems(
            error.problems, summary=f"{CASES_PATH.name} is invalid: {{}} problem(s)"
        )
        return ExitCode.PROBLEMS_FOUND
    if args.suggest:
        suggest(corpus)
        return ExitCode.SUCCESS
    if mismatches := check(corpus):
        _print_problems(
            mismatches,
            summary=f"{{}} mismatch(es) between {CASES_PATH.name} and the corpus",
        )
        return ExitCode.PROBLEMS_FOUND
    print(
        f"cases.toml agrees with kernels/ and asm/ "
        f"({len(corpus.cases)} cases, targets: {', '.join(corpus.targets)})"
    )
    return ExitCode.SUCCESS


def _print_problems(problems: list[str], summary: str) -> None:
    """Each problem, then *summary* with their count in place of ``{}``."""
    for problem in problems:
        print(f"error: {problem}", file=sys.stderr)
    print("\n" + summary.format(len(problems)), file=sys.stderr)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
