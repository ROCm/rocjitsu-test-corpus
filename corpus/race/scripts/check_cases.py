#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""
Check that ``cases.toml`` agrees with ``kernels/`` and the committed ``asm/``.

This needs no compiler: it checks the kernel inventory against the files on
disk::

    python corpus/race/scripts/check_cases.py   # exit 1 on any mismatch

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
* the manifest is valid, as ``inventory.load`` checks it: known fields, unique
  ids and kernels, and every target in a case's ``targets`` a corpus target;
* every case has ``kernels/<kernel>.hip`` and, for each target it builds for,
  ``asm/<target>/<kernel>.s``;
* every ``asm/<target>/*.s`` belongs to a case that builds for that target;
* every ``asm/<target>/*.s`` declares ``.amdgcn_target`` for that target, which
  catches an empty file or a listing copied into the wrong directory. This is a
  sanity check on the files, not proof that they match their source;
* every ``asm/<target>/`` has the ``recipe.toml`` that ``regenerate_asm.py``
  writes beside the assembly, with all of its fields, so a regeneration commit
  that leaves it out is caught.
"""

import argparse
import re
import sys
from pathlib import Path

import inventory
import recipe

CORPUS_ROOT = Path(__file__).resolve().parent.parent
ASM_DIR = CORPUS_ROOT / "asm"
KERNELS_DIR = CORPUS_ROOT / "kernels"
CASES_PATH = CORPUS_ROOT / "cases.toml"

# The directive hipcc writes at the top of each listing, naming the target
# triple and processor, e.g. "amdgcn-amd-amdhsa-unknown-gfx950:xnack-". Group 1
# is the processor, without target features.
_AMDGCN_TARGET_RE = re.compile(r'^\s*\.amdgcn_target\s+"[^"]*-([^-":]+)(?::[^"]*)?"', re.MULTILINE)


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
            return f"asm/{target}/{asm.name}: .amdgcn_target is {processor}, not {target}"
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
            errors.append(f"asm/{target}/ is not a corpus target; add it to [corpus] targets")

    for case in corpus.cases:
        where = f"{CASES_PATH.name} [{case.id}]"
        if not (KERNELS_DIR / f"{case.kernel}.hip").is_file():
            errors.append(f"{where}: kernels/{case.kernel}.hip is missing")
        for target in corpus.targets_of(case):
            if not (ASM_DIR / target / f"{case.kernel}.s").is_file():
                errors.append(f"{where}: asm/{target}/{case.kernel}.s is missing")

    owned = corpus.outputs()
    for target in sorted(set(corpus.targets) & set(present)):
        errors.extend(recipe_problems(target))
        for asm in sorted((ASM_DIR / target).glob("*.s")):
            if (target, asm.name) not in owned:
                errors.append(f"asm/{target}/{asm.name}: no case builds {asm.stem} for {target}")
            if (mismatch := target_mismatch(asm, target)) is not None:
                errors.append(mismatch)
    return errors


def main(argv: list[str]) -> int:
    argparse.ArgumentParser(
        description="Check cases.toml against kernels/ and the committed asm/, without a compiler."
    ).parse_args(argv)
    try:
        corpus = inventory.load(CASES_PATH)
    except inventory.InventoryError as error:
        errors = error.problems
    else:
        errors = check(corpus)

    for problem in errors:
        print(f"error: {problem}", file=sys.stderr)
    if errors:
        print(f"\n{len(errors)} mismatch(es) between cases.toml and the corpus", file=sys.stderr)
        return 1
    print(
        f"cases.toml agrees with kernels/ and asm/ "
        f"({len(corpus.cases)} cases, targets: {', '.join(corpus.targets)})"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
