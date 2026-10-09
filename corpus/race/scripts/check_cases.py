#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""
Check that ``cases.toml`` agrees with ``kernels/`` and the committed ``asm/``.

``regenerate_asm.py --check`` compares assembly text and needs a compiler. This
needs neither: it checks the kernel inventory against the files on disk, so a
case and its pinned assembly cannot drift apart unnoticed::

    python corpus/race/scripts/check_cases.py   # exit 1 on any mismatch

It checks that:

* every case uses only known fields, and no two cases share an id or a kernel;
* every target a case names has a directory under ``asm/``;
* every case has ``kernels/<kernel>.hip`` and, for each target it builds for,
  ``asm/<target>/<kernel>.s``;
* every ``asm/<target>/*.s`` belongs to a case that builds for that target.
"""

from __future__ import annotations

import sys
import tomllib
from pathlib import Path

CORPUS_ROOT = Path(__file__).resolve().parent.parent
ASM_DIR = CORPUS_ROOT / "asm"
KERNELS_DIR = CORPUS_ROOT / "kernels"
CASES_PATH = CORPUS_ROOT / "cases.toml"

KNOWN_FIELDS = frozenset({"id", "kernel", "requires", "headers"})


def asm_targets() -> list[str]:
    return sorted(path.name for path in ASM_DIR.iterdir() if path.is_dir())


def case_targets(case: dict, all_targets: list[str]) -> list[str]:
    """The targets a case builds for: its ``requires``, or every target."""
    return sorted(case.get("requires") or all_targets)


def check(cases: list[dict], all_targets: list[str]) -> list[str]:
    errors: list[str] = []
    seen_ids: set[str] = set()
    seen_kernels: set[str] = set()
    owned: set[tuple[str, str]] = set()

    for case in cases:
        where = f"cases.toml [{case.get('id', '?')}]"
        for field in sorted(set(case) - KNOWN_FIELDS):
            errors.append(f"{where}: unknown field {field!r}")
        if case["id"] in seen_ids:
            errors.append(f"{where}: duplicate id")
        if case["kernel"] in seen_kernels:
            errors.append(f"{where}: kernel {case['kernel']} is already used by another case")
        seen_ids.add(case["id"])
        seen_kernels.add(case["kernel"])

        if not (KERNELS_DIR / f"{case['kernel']}.hip").is_file():
            errors.append(f"{where}: kernels/{case['kernel']}.hip is missing")
        for target in case.get("requires", []):
            if target not in all_targets:
                errors.append(f"{where}: requires {target}, which has no asm/{target}/ directory")

        for target in case_targets(case, all_targets):
            owned.add((target, f"{case['kernel']}.s"))
            if not (ASM_DIR / target / f"{case['kernel']}.s").is_file():
                errors.append(f"{where}: asm/{target}/{case['kernel']}.s is missing")

    for target in all_targets:
        for asm in sorted((ASM_DIR / target).glob("*.s")):
            if (target, asm.name) not in owned:
                errors.append(f"asm/{target}/{asm.name}: no case builds {asm.stem} for {target}")
    return errors


def main() -> int:
    manifest = tomllib.loads(CASES_PATH.read_text())
    if manifest.get("corpus", {}).get("schema") != 1:
        print("cases.toml: unsupported corpus schema", file=sys.stderr)
        return 2
    cases = manifest["case"]
    targets = asm_targets()

    errors = check(cases, targets)
    for error in errors:
        print(f"error: {error}", file=sys.stderr)
    if errors:
        print(f"\n{len(errors)} mismatch(es) between cases.toml and the corpus", file=sys.stderr)
        return 1
    print(f"cases.toml agrees with kernels/ and asm/ ({len(cases)} cases, targets: {', '.join(targets)})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
