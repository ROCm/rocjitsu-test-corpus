#!/usr/bin/env python3
"""Validate gfx1250 integer CTS inventory and linked-image opcode coverage."""

from __future__ import annotations

import argparse
from collections import Counter
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

COVERAGE_TEST_NAME = "int_isa_gfx1250_source_coverage_test"
ENCODING_SUFFIX = re.compile(r"_(?:e32|e64)$")
OPCODE = re.compile(
    r"^[ \t]+([a-z][a-z0-9]*_[a-z0-9_]+)\b", re.IGNORECASE | re.MULTILINE
)


def _load_json(path: Path) -> tuple[object | None, list[str]]:
    try:
        with path.open(encoding="utf-8") as stream:
            return json.load(stream), []
    except (OSError, json.JSONDecodeError) as error:
        return None, [f"cannot read {path}: {error}"]


def _normalized_opcodes(disassembly: str) -> set[str]:
    return {
        ENCODING_SUFFIX.sub("", match.group(1).lower())
        for match in OPCODE.finditer(disassembly)
    }


def _string_list(value: object, *, nonempty: bool = False) -> bool:
    return (
        isinstance(value, list)
        and (bool(value) or not nonempty)
        and all(isinstance(item, str) and bool(item) for item in value)
    )


def _string_groups(value: object) -> bool:
    return isinstance(value, list) and all(
        _string_list(group, nonempty=True) for group in value
    )


def validate_documents(
    coverage: object,
    inventory: object,
    disassembly_by_name: dict[str, str],
    source_root: Path,
) -> list[str]:
    errors: list[str] = []
    if not isinstance(coverage, dict):
        return ["coverage document must be an object"]
    if coverage.get("schema_version") != 2:
        errors.append("coverage schema_version must be 2")
    if coverage.get("target") != "gfx1250":
        errors.append("coverage target must be gfx1250")

    tests = coverage.get("tests")
    if not isinstance(tests, list) or not tests:
        return errors + ["coverage tests must be a non-empty list"]

    names: list[str] = []
    for entry in tests:
        if isinstance(entry, dict) and isinstance(entry.get("name"), str):
            names.append(entry["name"])
    duplicates = sorted(name for name, count in Counter(names).items() if count > 1)
    if duplicates:
        errors.append(f"duplicate coverage test names: {', '.join(duplicates)}")

    inventory_names: set[str] = set()
    coverage_test_inventory_count = 0
    if not isinstance(inventory, dict) or not isinstance(inventory.get("cases"), list):
        errors.append("case inventory must contain a cases list")
    else:
        for index, case in enumerate(inventory["cases"]):
            if not isinstance(case, dict):
                errors.append(f"case inventory entry {index} must be an object")
                continue
            name = case.get("name")
            targets = case.get("supported_targets")
            if not isinstance(name, str) or not name:
                errors.append(f"case inventory entry {index} has an invalid name")
                continue
            if not _string_list(targets, nonempty=True):
                errors.append(
                    f"{name}: supported_targets must be a non-empty string list"
                )
                continue
            if "gfx1250" in targets:
                if name == COVERAGE_TEST_NAME:
                    coverage_test_inventory_count += 1
                elif name.startswith("int_isa_gfx1250_"):
                    inventory_names.add(name)

    if coverage_test_inventory_count != 1:
        errors.append(
            f"{COVERAGE_TEST_NAME}: case inventory must contain exactly one "
            f"gfx1250 entry (found {coverage_test_inventory_count})"
        )

    coverage_names = set(names)
    if missing := sorted(inventory_names - coverage_names):
        errors.append(
            f"gfx1250 integer cases missing coverage entries: {', '.join(missing)}"
        )
    if extra := sorted(coverage_names - inventory_names):
        errors.append(
            f"coverage entries missing from case inventory: {', '.join(extra)}"
        )
    if missing_images := sorted(coverage_names - disassembly_by_name.keys()):
        errors.append(
            f"coverage entries missing linked images: {', '.join(missing_images)}"
        )
    if extra_images := sorted(disassembly_by_name.keys() - coverage_names):
        errors.append(
            f"linked images missing coverage entries: {', '.join(extra_images)}"
        )

    for index, entry in enumerate(tests):
        if not isinstance(entry, dict):
            errors.append(f"coverage test entry {index} must be an object")
            continue
        name = entry.get("name")
        source = entry.get("source")
        expected = entry.get("expected_opcodes", [])
        alternatives = entry.get("expected_opcode_alternatives", [])
        semantic_only = entry.get("semantic_only", False)
        if not isinstance(name, str) or not name:
            errors.append(f"coverage test entry {index} has an invalid name")
            continue
        if not isinstance(source, str) or not source:
            errors.append(f"{name}: source must be a non-empty string")
        elif not (source_root / source).is_file():
            errors.append(f"{name}: source does not exist: {source}")
        if not _string_list(expected):
            errors.append(f"{name}: expected_opcodes must be a string list")
            continue
        if not _string_groups(alternatives):
            errors.append(
                f"{name}: expected_opcode_alternatives must be a list of "
                "non-empty string lists"
            )
            continue
        if not isinstance(semantic_only, bool):
            errors.append(f"{name}: semantic_only must be a boolean")
            continue
        if not expected and not alternatives and not semantic_only:
            errors.append(
                f"{name}: requires expected_opcodes, "
                "expected_opcode_alternatives, or semantic_only"
            )
        reason = entry.get("reason")
        if semantic_only and (not isinstance(reason, str) or not reason.strip()):
            errors.append(f"{name}: semantic_only entries require a non-empty reason")

        normalized_expected = {
            ENCODING_SUFFIX.sub("", opcode.lower()) for opcode in expected
        }
        emitted = _normalized_opcodes(disassembly_by_name.get(name, ""))
        if missing_opcodes := sorted(normalized_expected - emitted):
            errors.append(
                f"{name}: linked image is missing opcodes: {', '.join(missing_opcodes)}"
            )
        for group in alternatives:
            normalized_group = {
                ENCODING_SUFFIX.sub("", opcode.lower()) for opcode in group
            }
            if normalized_group.isdisjoint(emitted):
                errors.append(
                    f"{name}: linked image is missing opcode alternatives: "
                    f"{' | '.join(sorted(normalized_group))}"
                )

    return errors


def _disassemble_image(executable: Path, llvm_objdump: Path, target: str) -> str:
    if not executable.is_file():
        raise RuntimeError(f"linked executable does not exist: {executable}")
    if not llvm_objdump.is_file():
        raise RuntimeError(f"llvm-objdump does not exist: {llvm_objdump}")
    if not os.access(llvm_objdump, os.X_OK):
        raise RuntimeError(f"llvm-objdump is not executable: {llvm_objdump}")
    with tempfile.TemporaryDirectory(prefix="int-isa-image-") as directory:
        temporary = Path(directory)
        copied = temporary / executable.name
        shutil.copy2(executable, copied)
        extracted = subprocess.run(
            [str(llvm_objdump), "--offloading", str(copied)],
            cwd=temporary,
            text=True,
            capture_output=True,
            check=False,
        )
        if extracted.returncode:
            raise RuntimeError(
                f"llvm-objdump could not extract {executable}: {extracted.stderr.strip()}"
            )
        image_name = re.compile(
            rf"^{re.escape(copied.name)}\..*\.hipv4-amdgcn-amd-amdhsa--"
            rf"{re.escape(target)}(?:$|[:+])"
        )
        candidates = sorted(
            path
            for path in temporary.iterdir()
            if image_name.match(path.name) and path.is_file() and path.stat().st_size
        )
        if len(candidates) != 1:
            shown = ", ".join(path.name for path in candidates) or "none"
            raise RuntimeError(
                f"{executable}: expected one {target} image, found {len(candidates)} ({shown})"
            )
        disassembled = subprocess.run(
            [str(llvm_objdump), "--disassemble", str(candidates[0])],
            text=True,
            capture_output=True,
            check=False,
        )
        if disassembled.returncode:
            raise RuntimeError(
                f"llvm-objdump could not disassemble {executable}: "
                f"{disassembled.stderr.strip()}"
            )
        return disassembled.stdout


def _parse_images(values: list[str]) -> tuple[dict[str, Path], list[str]]:
    images: dict[str, Path] = {}
    errors: list[str] = []
    for value in values:
        name, separator, path = value.partition("=")
        if not separator or not name or not path:
            errors.append(f"invalid --image mapping: {value}")
        elif name in images:
            errors.append(f"duplicate --image mapping: {name}")
        else:
            images[name] = Path(path).resolve()
    return images, errors


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--coverage", type=Path, required=True)
    parser.add_argument("--case-inventory", type=Path, required=True)
    parser.add_argument("--source-root", type=Path, required=True)
    parser.add_argument("--llvm-objdump", type=Path, required=True)
    parser.add_argument("--image", action="append", default=[])
    args = parser.parse_args()

    coverage, errors = _load_json(args.coverage.resolve())
    inventory, inventory_errors = _load_json(args.case_inventory.resolve())
    errors.extend(inventory_errors)
    images, image_errors = _parse_images(args.image)
    errors.extend(image_errors)

    disassembly_by_name: dict[str, str] = {}
    if not errors:
        for name, path in images.items():
            try:
                disassembly_by_name[name] = _disassemble_image(
                    path, args.llvm_objdump.resolve(), "gfx1250"
                )
            except RuntimeError as error:
                errors.append(str(error))
    if not errors:
        errors.extend(
            validate_documents(
                coverage,
                inventory,
                disassembly_by_name,
                args.source_root.resolve(),
            )
        )
    for error in errors:
        print(f"MISS {error}")
    if errors:
        return 1
    print("PASS gfx1250 integer CTS linked-image coverage")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
