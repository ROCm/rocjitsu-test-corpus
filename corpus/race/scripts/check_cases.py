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
* every ``asm/<target>/*.s`` belongs to a case that builds for that target.
"""

import argparse
import sys
from pathlib import Path

import inventory

CORPUS_ROOT = Path(__file__).resolve().parent.parent
ASM_DIR = CORPUS_ROOT / "asm"
KERNELS_DIR = CORPUS_ROOT / "kernels"
CASES_PATH = CORPUS_ROOT / "cases.toml"


def asm_targets() -> list[str]:
    if not ASM_DIR.is_dir():
        return []
    return sorted(path.name for path in ASM_DIR.iterdir() if path.is_dir())


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
        for asm in sorted((ASM_DIR / target).glob("*.s")):
            if (target, asm.name) not in owned:
                errors.append(f"asm/{target}/{asm.name}: no case builds {asm.stem} for {target}")
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
