#!/usr/bin/env python3
"""Extract packaged gfx1250 code objects from an active TheRock/PyTorch venv.

The output is a content-addressed corpus for downstream offline consumers.
Extraction itself is file based except for CCOB containers, which HIP must
materialize on a visible gfx1250 GPU when ``--materialize-ccob`` is requested.
"""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
import lzma
import mmap
import os
import re
import struct
import subprocess
import sys
import sysconfig
import tempfile
import zipfile
from dataclasses import dataclass
from importlib import metadata
from pathlib import Path

ELF_MAGIC = b"\x7fELF"
ELFCLASS64 = 2
ELFDATA2LSB = 1
ET_DYN = 3
EM_AMDGPU = 224
EF_AMDGPU_MACH = 0x0FF
PT_NOTE = 4
SHT_NOTE = 7
SHT_NOBITS = 8
NT_AMDGPU_METADATA = 32
KPACK_ERROR_KERNEL_NOT_FOUND = 5
CLANG_OFFLOAD_BUNDLE_MAGIC = b"__CLANG_OFFLOAD_BUNDLE__"
AMDGPU_MACH_BY_TARGET = {"gfx1250": 0x49}

AKS2_HEADER = struct.Struct("<4sIII")
AKS2_METADATA = struct.Struct("<IIIII")
AMDHSA_TARGET_BYTES_PATTERN = re.compile(
    rb"amdgcn-amd-amdhsa--(gfx[0-9a-z]+)(?=[^0-9a-z]|$)"
)


def is_loadable_amdgpu_elf(data: bytes) -> bool:
    """Return whether data is a little-endian ELF64 AMDGPU shared object."""
    return (
        len(data) >= 64
        and data.startswith(ELF_MAGIC)
        and data[4] == ELFCLASS64
        and data[5] == ELFDATA2LSB
        and struct.unpack_from("<H", data, 16)[0] == ET_DYN
        and struct.unpack_from("<H", data, 18)[0] == EM_AMDGPU
    )


def path_mentions_target(path: Path, target: str) -> bool:
    return (
        re.search(rf"(?<![A-Za-z0-9]){re.escape(target)}(?![A-Za-z0-9])", str(path))
        is not None
    )


def target_note(target: str) -> bytes:
    return f"amdgcn-amd-amdhsa--{target}".encode()


def elf_notes(data):
    """Yield bounded ELF note owner, type, and description tuples."""
    if not is_loadable_amdgpu_elf(data):
        return

    ranges: list[tuple[int, int]] = []
    program_offset = struct.unpack_from("<Q", data, 32)[0]
    program_entry_size, program_count = struct.unpack_from("<HH", data, 54)
    if program_entry_size >= 56:
        for index in range(program_count):
            position = program_offset + index * program_entry_size
            if position + 56 > len(data):
                break
            if struct.unpack_from("<I", data, position)[0] != PT_NOTE:
                continue
            offset = struct.unpack_from("<Q", data, position + 8)[0]
            size = struct.unpack_from("<Q", data, position + 32)[0]
            if offset <= len(data) and size <= len(data) - offset:
                ranges.append((offset, size))

    section_offset = struct.unpack_from("<Q", data, 40)[0]
    section_entry_size, section_count = struct.unpack_from("<HH", data, 58)
    if section_entry_size >= 64:
        for index in range(section_count):
            position = section_offset + index * section_entry_size
            if position + 64 > len(data):
                break
            if struct.unpack_from("<I", data, position + 4)[0] != SHT_NOTE:
                continue
            offset, size = struct.unpack_from("<QQ", data, position + 24)
            if offset <= len(data) and size <= len(data) - offset:
                ranges.append((offset, size))

    for offset, size in dict.fromkeys(ranges):
        cursor = offset
        end = offset + size
        while cursor + 12 <= end:
            name_size, description_size, note_type = struct.unpack_from(
                "<III", data, cursor
            )
            cursor += 12
            name_end = cursor + name_size
            description_offset = (name_end + 3) & ~3
            description_end = description_offset + description_size
            next_note = (description_end + 3) & ~3
            if name_end > end or description_end > end or next_note > end:
                break
            owner = bytes(data[cursor:name_end]).rstrip(b"\0")
            description = bytes(data[description_offset:description_end])
            yield owner, note_type, description
            cursor = next_note


def amdhsa_targets(data) -> set[str]:
    targets = set()
    for owner, note_type, description in elf_notes(data):
        if owner != b"AMDGPU" or note_type != NT_AMDGPU_METADATA:
            continue
        targets.update(
            match.group(1).decode("ascii")
            for match in AMDHSA_TARGET_BYTES_PATTERN.finditer(description)
        )
    return targets


def elf_machine_matches_target(data, target: str) -> bool | None:
    expected = AMDGPU_MACH_BY_TARGET.get(target)
    selected = struct.unpack_from("<I", data, 48)[0] & EF_AMDGPU_MACH
    if expected is None or selected == 0:
        return None
    return selected == expected


def elf_target_evidence(data, target: str) -> str | None:
    """Return consistent in-object target evidence, rejecting contradictions."""
    targets = amdhsa_targets(data)
    if targets and targets != {target}:
        raise ValueError(
            f"AMDHSA metadata declares {sorted(targets)}, expected only {target}"
        )

    machine_matches = elf_machine_matches_target(data, target)
    if machine_matches is False:
        raise ValueError(f"ELF processor flags do not match {target}")
    if targets:
        return (
            "amdhsa-target+elf-flags"
            if machine_matches is True
            else "amdhsa-target"
        )
    if machine_matches is True:
        return "elf-flags"
    return None


def source_path(path: Path, environment: Path) -> str:
    try:
        return str(path.relative_to(environment))
    except ValueError:
        return str(path)


def write_json(path: Path, payload: object) -> None:
    path.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )


def extraction_completion(
    *,
    ccob_containers: int,
    materialize_ccob: bool,
    failures: list[dict[str, object]],
) -> tuple[str, bool]:
    if not ccob_containers:
        ccob_status = "not-present"
    elif not materialize_ccob:
        ccob_status = "skipped"
    elif any(failure.get("category") == "ccob" for failure in failures):
        ccob_status = "failed"
    else:
        ccob_status = "materialized"
    complete = not failures and ccob_status not in ("skipped", "failed")
    return ccob_status, complete


class Corpus:
    """Content-addressed object store with per-source provenance records."""

    def __init__(self, destination: Path, target: str):
        self.destination = destination
        self.target = target
        self.objects = destination / "objects"
        self.manifests = destination / "manifests"
        self.objects.mkdir(parents=True)
        self.manifests.mkdir()
        self.records: list[dict[str, object]] = []
        self.unique: set[str] = set()
        self.by_category: dict[str, set[str]] = {}

    def add(
        self,
        data: bytes,
        category: str,
        source: dict[str, object],
    ) -> str:
        if not is_loadable_amdgpu_elf(data):
            raise ValueError(f"not a loadable AMDGPU ELF: {source}")
        elf_target_evidence(data, self.target)

        digest = hashlib.sha256(data).hexdigest()
        object_path = self.objects / f"{digest}.hsaco"
        if not object_path.exists():
            object_path.write_bytes(data)

        self.unique.add(digest)
        self.by_category.setdefault(category, set()).add(digest)
        self.records.append(
            {
                "category": category,
                "sha256": digest,
                "size": len(data),
                **source,
            }
        )
        return digest

    def finish(self, summary_fields: dict[str, object]) -> dict[str, object]:
        records = sorted(
            self.records,
            key=lambda record: (
                str(record["category"]),
                str(record.get("path", "")),
                str(record.get("archive", "")),
                str(record.get("member", "")),
                str(record.get("aks2_entry", "")),
                int(record.get("kernel_index", 0)),
                int(record.get("offset", 0)),
                str(record.get("runtime_dump", "")),
                str(record.get("architecture", "")),
                str(record["sha256"]),
            ),
        )
        with (self.manifests / "provenance.jsonl").open(
            "w", encoding="utf-8"
        ) as output:
            for record in records:
                output.write(json.dumps(record, sort_keys=True) + "\n")

        with (self.manifests / "SHA256SUMS").open("w", encoding="ascii") as output:
            for digest in sorted(self.unique):
                output.write(f"{digest}  objects/{digest}.hsaco\n")

        non_ccob = set().union(
            *(
                digests
                for category, digests in self.by_category.items()
                if category != "ccob"
            )
        )
        with (self.manifests / "NON_CCOB_SHA256SUMS").open(
            "w", encoding="ascii"
        ) as output:
            for digest in sorted(non_ccob):
                output.write(f"{digest}  objects/{digest}.hsaco\n")

        source_counts: dict[str, int] = {}
        for record in records:
            category = str(record["category"])
            source_counts[category] = source_counts.get(category, 0) + 1

        summary = {
            "source_records": len(records),
            "unique_code_objects": len(self.unique),
            "category_source_records": dict(sorted(source_counts.items())),
            "category_unique_code_objects": {
                category: len(digests)
                for category, digests in sorted(self.by_category.items())
            },
            **summary_fields,
        }
        write_json(self.destination / "summary.json", summary)
        return summary


class Kpack:
    """Small ctypes wrapper around the KPACK discovery API."""

    def __init__(self, library: Path, target: str):
        self.target = target
        self.lib = ctypes.CDLL(str(library))
        void_pointer = ctypes.c_void_p
        size = ctypes.c_size_t
        char_pointer = ctypes.c_char_p

        self.lib.kpack_open.argtypes = [
            char_pointer,
            ctypes.POINTER(void_pointer),
        ]
        self.lib.kpack_open.restype = ctypes.c_int
        self.lib.kpack_close.argtypes = [void_pointer]
        self.lib.kpack_close.restype = None
        self.lib.kpack_get_architecture_count.argtypes = [
            void_pointer,
            ctypes.POINTER(size),
        ]
        self.lib.kpack_get_architecture_count.restype = ctypes.c_int
        self.lib.kpack_get_architecture.argtypes = [
            void_pointer,
            size,
            ctypes.POINTER(char_pointer),
        ]
        self.lib.kpack_get_architecture.restype = ctypes.c_int
        self.lib.kpack_get_binary_count.argtypes = [
            void_pointer,
            ctypes.POINTER(size),
        ]
        self.lib.kpack_get_binary_count.restype = ctypes.c_int
        self.lib.kpack_get_binary.argtypes = [
            void_pointer,
            size,
            ctypes.POINTER(char_pointer),
        ]
        self.lib.kpack_get_binary.restype = ctypes.c_int
        self.lib.kpack_get_kernel.argtypes = [
            void_pointer,
            char_pointer,
            char_pointer,
            ctypes.POINTER(void_pointer),
            ctypes.POINTER(size),
        ]
        self.lib.kpack_get_kernel.restype = ctypes.c_int
        self.lib.kpack_free_kernel.argtypes = [void_pointer]
        self.lib.kpack_free_kernel.restype = None

    @staticmethod
    def _query_strings(handle, get_count, get_value) -> list[str]:
        count = ctypes.c_size_t()
        result = get_count(handle, ctypes.byref(count))
        if result:
            raise RuntimeError(f"KPACK count query failed: {result}")

        values = []
        for index in range(count.value):
            value = ctypes.c_char_p()
            result = get_value(handle, index, ctypes.byref(value))
            if result:
                raise RuntimeError(f"KPACK indexed query {index} failed: {result}")
            if value.value is None:
                raise RuntimeError(f"KPACK indexed query {index} returned null")
            values.append(value.value.decode())
        return values

    def extract(
        self,
        archive_path: Path,
        corpus: Corpus,
        environment: Path,
    ) -> int:
        handle = ctypes.c_void_p()
        result = self.lib.kpack_open(os.fsencode(archive_path), ctypes.byref(handle))
        if result:
            raise RuntimeError(f"kpack_open failed ({result}): {archive_path}")

        try:
            architectures = sorted(
                self._query_strings(
                    handle,
                    self.lib.kpack_get_architecture_count,
                    self.lib.kpack_get_architecture,
                )
            )
            binaries = sorted(
                self._query_strings(
                    handle,
                    self.lib.kpack_get_binary_count,
                    self.lib.kpack_get_binary,
                )
            )
            count = 0
            for architecture in architectures:
                if architecture.partition(":")[0] != self.target:
                    continue
                for binary in binaries:
                    data_pointer = ctypes.c_void_p()
                    size = ctypes.c_size_t()
                    result = self.lib.kpack_get_kernel(
                        handle,
                        binary.encode(),
                        architecture.encode(),
                        ctypes.byref(data_pointer),
                        ctypes.byref(size),
                    )
                    if result == KPACK_ERROR_KERNEL_NOT_FOUND:
                        continue
                    if result:
                        raise RuntimeError(
                            "kpack_get_kernel failed "
                            f"({result}): {archive_path}:{binary}:{architecture}"
                        )
                    try:
                        data = ctypes.string_at(data_pointer, size.value)
                    finally:
                        self.lib.kpack_free_kernel(data_pointer)
                    corpus.add(
                        data,
                        "kpack",
                        {
                            "archive": source_path(archive_path, environment),
                            "member": binary,
                            "architecture": architecture,
                            "target_evidence": "kpack-architecture",
                        },
                    )
                    count += 1
            return count
        finally:
            self.lib.kpack_close(handle)


@dataclass
class Inventory:
    files: list[Path]
    kpack: list[Path]
    ccob: list[Path]
    loose_amdgpu: list[Path]
    host_elf: list[Path]


def walk_files(roots: list[Path]):
    for root in roots:
        def raise_walk_error(error: OSError) -> None:
            raise error

        for directory, directory_names, file_names in os.walk(
            root, onerror=raise_walk_error
        ):
            directory_names.sort()
            file_names.sort()
            for name in file_names:
                path = Path(directory) / name
                path.stat()
                yield path


def inventory_files(roots: list[Path]) -> Inventory:
    files = list(walk_files(roots))
    kpack = []
    ccob = []
    loose_amdgpu = []
    host_elf = []

    for path in files:
        with path.open("rb") as source:
            header = source.read(64)
        if header.startswith(b"KPAK"):
            kpack.append(path)
            continue
        if header.startswith(b"CCOB"):
            ccob.append(path)
            continue
        if not header.startswith(ELF_MAGIC) or len(header) < 20:
            continue
        if struct.unpack_from("<H", header, 18)[0] == EM_AMDGPU:
            loose_amdgpu.append(path)
        else:
            host_elf.append(path)

    return Inventory(files, kpack, ccob, loose_amdgpu, host_elf)


def extract_loose(
    paths: list[Path],
    corpus: Corpus,
    environment: Path,
    target: str,
) -> int:
    count = 0
    for path in paths:
        data = path.read_bytes()
        if not is_loadable_amdgpu_elf(data):
            continue
        try:
            evidence = elf_target_evidence(data, target)
        except ValueError:
            continue
        if evidence is None and path_mentions_target(path, target):
            evidence = "path"
        if evidence is None:
            continue
        corpus.add(
            data,
            "loose",
            {
                "path": source_path(path, environment),
                "target_evidence": evidence,
            },
        )
        count += 1
    return count


def has_elf_section(path: Path, expected_name: bytes) -> bool:
    try:
        with path.open("rb") as source:
            if os.fstat(source.fileno()).st_size < 64:
                return False
            with mmap.mmap(source.fileno(), 0, access=mmap.ACCESS_READ) as data:
                if data[:6] != ELF_MAGIC + bytes((ELFCLASS64, ELFDATA2LSB)):
                    return False
                section_offset = struct.unpack_from("<Q", data, 40)[0]
                section_entry_size, section_count, name_table_index = (
                    struct.unpack_from("<HHH", data, 58)
                )
                if section_entry_size < 64 or section_offset + 64 > len(data):
                    return False
                if section_count == 0:
                    section_count = struct.unpack_from("<Q", data, section_offset + 32)[
                        0
                    ]
                if name_table_index == 0xFFFF:
                    name_table_index = struct.unpack_from(
                        "<I", data, section_offset + 40
                    )[0]
                table_end = section_offset + section_entry_size * section_count
                if (
                    not section_count
                    or table_end > len(data)
                    or name_table_index >= section_count
                ):
                    return False

                name_header = section_offset + name_table_index * section_entry_size
                names_offset, names_size = struct.unpack_from(
                    "<QQ", data, name_header + 24
                )
                names_end = names_offset + names_size
                if names_end > len(data):
                    return False
                for index in range(section_count):
                    header = section_offset + index * section_entry_size
                    name_offset = struct.unpack_from("<I", data, header)[0]
                    name_start = names_offset + name_offset
                    if name_start >= names_end:
                        continue
                    name_end = data.find(b"\0", name_start, names_end)
                    if name_end >= 0 and data[name_start:name_end] == expected_name:
                        section_type = struct.unpack_from("<I", data, header + 4)[0]
                        file_offset, file_size = struct.unpack_from(
                            "<QQ", data, header + 24
                        )
                        return (
                            section_type != SHT_NOBITS
                            and file_size > 0
                            and file_offset + file_size <= len(data)
                        )
    except (OSError, struct.error, ValueError):
        return False
    return False


def bundle_target_matches(value: str, target: str) -> bool:
    match = re.search(r"--(gfx[0-9a-z]+)(?::[^\s]+)?$", value)
    return match is not None and match.group(1) == target


def parse_clang_offload_bundles(data: bytes):
    """Yield every entry from concatenated Clang offload bundles."""
    search_offset = 0
    bundle_index = 0
    while True:
        bundle_offset = data.find(CLANG_OFFLOAD_BUNDLE_MAGIC, search_offset)
        if bundle_offset < 0:
            return
        cursor = bundle_offset + len(CLANG_OFFLOAD_BUNDLE_MAGIC)
        if cursor + 8 > len(data):
            raise ValueError(f"bundle {bundle_index} has a truncated header")
        entry_count = struct.unpack_from("<Q", data, cursor)[0]
        cursor += 8
        if entry_count > (len(data) - cursor) // 24:
            raise ValueError(f"bundle {bundle_index} has an invalid entry count")

        entries = []
        bundle_end = cursor
        for entry_index in range(entry_count):
            offset, size, target_size = struct.unpack_from("<QQQ", data, cursor)
            cursor += 24
            target_end = cursor + target_size
            if target_end > len(data):
                raise ValueError(
                    f"bundle {bundle_index} entry {entry_index} has a truncated target"
                )
            try:
                bundle_target = data[cursor:target_end].decode("utf-8")
            except UnicodeDecodeError as exc:
                raise ValueError(
                    f"bundle {bundle_index} entry {entry_index} has an invalid target"
                ) from exc
            cursor = target_end
            payload_offset = bundle_offset + offset
            payload_end = payload_offset + size
            if (
                payload_offset < bundle_offset
                or payload_offset > len(data)
                or payload_end > len(data)
            ):
                raise ValueError(
                    f"bundle {bundle_index} entry {entry_index} has an "
                    "out-of-bounds payload"
                )
            entries.append(
                (
                    bundle_index,
                    entry_index,
                    bundle_target,
                    data[payload_offset:payload_end],
                )
            )
            bundle_end = max(bundle_end, payload_end)

        yield from entries
        search_offset = max(cursor, bundle_end)
        bundle_index += 1


def extract_bundles(
    paths: list[Path],
    corpus: Corpus,
    environment: Path,
    target: str,
    llvm_objcopy: Path,
    bundler: Path,
) -> tuple[int, list[dict[str, object]]]:
    count = 0
    failures: list[dict[str, object]] = []
    candidates = [path for path in paths if has_elf_section(path, b".hip_fatbin")]

    with tempfile.TemporaryDirectory(prefix=f"{target}-bundles-") as temp_name:
        temporary = Path(temp_name)
        for index, path in enumerate(candidates):
            fatbin = temporary / f"{index}.fatbin"
            dump = subprocess.run(
                [
                    str(llvm_objcopy),
                    "--dump-section",
                    f".hip_fatbin={fatbin}",
                    str(path),
                ],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.PIPE,
                text=True,
            )
            if dump.returncode or not fatbin.exists() or fatbin.stat().st_size == 0:
                failures.append(
                    {
                        "category": "hip-bundle",
                        "path": source_path(path, environment),
                        "operation": "dump-section",
                        "returncode": dump.returncode,
                        "stderr": dump.stderr,
                    }
                )
                continue

            try:
                fatbin_data = fatbin.read_bytes()
                if CLANG_OFFLOAD_BUNDLE_MAGIC in fatbin_data:
                    bundle_entries = list(parse_clang_offload_bundles(fatbin_data))
                else:
                    listed = subprocess.run(
                        [
                            str(bundler),
                            "--list",
                            "--type=o",
                            f"--input={fatbin}",
                        ],
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE,
                        text=True,
                    )
                    if listed.returncode:
                        raise ValueError(
                            f"clang-offload-bundler --list failed: {listed.stderr}"
                        )
                    matching_targets = [
                        (entry_index, value.strip())
                        for entry_index, value in enumerate(listed.stdout.splitlines())
                        if bundle_target_matches(value.strip(), target)
                    ]
                    if len(matching_targets) > 1:
                        raise ValueError(
                            "non-Clang bundle contains repeated matching "
                            f"target entries: {matching_targets}"
                        )
                    bundle_entries = []
                    if matching_targets:
                        entry_index, bundle_target = matching_targets[0]
                        output = temporary / f"{index}.hsaco"
                        unbundled = subprocess.run(
                            [
                                str(bundler),
                                "--unbundle",
                                "--type=o",
                                f"--targets={bundle_target}",
                                f"--input={fatbin}",
                                f"--output={output}",
                            ],
                            stdout=subprocess.DEVNULL,
                            stderr=subprocess.PIPE,
                            text=True,
                        )
                        if unbundled.returncode or not output.exists():
                            raise ValueError(
                                "clang-offload-bundler --unbundle failed: "
                                f"{unbundled.stderr}"
                            )
                        bundle_entries.append(
                            (
                                0,
                                entry_index,
                                bundle_target,
                                output.read_bytes(),
                            )
                        )
            except (OSError, ValueError) as error:
                failures.append(
                    {
                        "category": "hip-bundle",
                        "path": source_path(path, environment),
                        "operation": "parse",
                        "error": str(error),
                    }
                )
                continue

            for (
                bundle_index,
                entry_index,
                bundle_target,
                payload,
            ) in bundle_entries:
                if not bundle_target_matches(bundle_target, target):
                    continue
                try:
                    corpus.add(
                        payload,
                        "hip-bundle",
                        {
                            "path": source_path(path, environment),
                            "bundle_index": bundle_index,
                            "bundle_entry_index": entry_index,
                            "bundle_target": bundle_target,
                            "target_evidence": "offload-bundle-target",
                        },
                    )
                except ValueError as error:
                    failures.append(
                        {
                            "category": "hip-bundle",
                            "path": source_path(path, environment),
                            "operation": "validate",
                            "bundle_index": bundle_index,
                            "bundle_entry_index": entry_index,
                            "error": str(error),
                        }
                    )
                    continue
                count += 1
    return count, failures


def dump_ccob_child(hip_library: Path, ccob: Path, device_ordinal: int) -> int:
    hip = ctypes.CDLL(str(hip_library))
    hip.hipSetDevice.argtypes = [ctypes.c_int]
    hip.hipSetDevice.restype = ctypes.c_int
    hip.hipModuleLoad.argtypes = [
        ctypes.POINTER(ctypes.c_void_p),
        ctypes.c_char_p,
    ]
    hip.hipModuleLoad.restype = ctypes.c_int
    hip.hipModuleUnload.argtypes = [ctypes.c_void_p]
    hip.hipModuleUnload.restype = ctypes.c_int

    result = hip.hipSetDevice(device_ordinal)
    if result:
        print(
            f"hipSetDevice({device_ordinal}) failed: {result}",
            file=sys.stderr,
        )
        return result
    module = ctypes.c_void_p()
    result = hip.hipModuleLoad(ctypes.byref(module), os.fsencode(ccob))
    if result:
        print(f"hipModuleLoad({ccob}) failed: {result}", file=sys.stderr)
        return result
    result = hip.hipModuleUnload(module)
    if result:
        print(f"hipModuleUnload({ccob}) failed: {result}", file=sys.stderr)
    return result


def clean_runtime_environment() -> dict[str, str]:
    child_environment = os.environ.copy()
    for name in (
        "LD_PRELOAD",
        "GPU_DUMP_CODE_OBJECT",
        "HSA_MODEL_LIB",
        "HSA_MODEL_TOPOLOGY",
        "HSA_OVERRIDE_GFX_VERSION",
        "RJ_CONFIG",
    ):
        child_environment.pop(name, None)
    return child_environment


def clean_materialization_environment() -> dict[str, str]:
    child_environment = clean_runtime_environment()
    child_environment["GPU_DUMP_CODE_OBJECT"] = "1"
    return child_environment


def visible_gpu_devices() -> list[tuple[int, str]]:
    try:
        import torch
    except ImportError as error:
        raise RuntimeError(
            "PyTorch is required to select the target HIP device for CCOB "
            "materialization"
        ) from error
    if not torch.cuda.is_available():
        return []
    return [
        (
            index,
            str(torch.cuda.get_device_properties(index).gcnArchName).partition(":")[0],
        )
        for index in range(torch.cuda.device_count())
    ]


def extract_ccob(
    paths: list[Path],
    corpus: Corpus,
    environment: Path,
    hip_library: Path,
    target: str,
    device_ordinal: int,
    progress_every: int,
) -> tuple[int, int, list[dict[str, object]]]:
    source_records = 0
    materialized_containers = 0
    failures: list[dict[str, object]] = []

    for index, path in enumerate(paths, 1):
        with tempfile.TemporaryDirectory(prefix="gfx1250-ccob-") as temp_name:
            child = subprocess.run(
                [
                    sys.executable,
                    str(Path(__file__).resolve()),
                    "--dump-ccob",
                    str(hip_library),
                    str(path),
                    str(device_ordinal),
                ],
                cwd=temp_name,
                env=clean_materialization_environment(),
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
            )
            outputs = sorted(Path(temp_name).glob("_code_object*.o"))
            if child.returncode or not outputs:
                failures.append(
                    {
                        "category": "ccob",
                        "path": source_path(path, environment),
                        "returncode": child.returncode,
                        "stdout": child.stdout,
                        "stderr": child.stderr,
                    }
                )
                continue

            container_failed = False
            for output in outputs:
                try:
                    data = output.read_bytes()
                    declared_targets = amdhsa_targets(data)
                    if declared_targets and target not in declared_targets:
                        raise ValueError(
                            "materialized code object declares "
                            f"{sorted(declared_targets)}, expected {target}"
                        )
                    corpus.add(
                        data,
                        "ccob",
                        {
                            "path": source_path(path, environment),
                            "runtime_dump": output.name,
                            "target_evidence": "hip-materialization",
                        },
                    )
                except (OSError, ValueError) as error:
                    failures.append(
                        {
                            "category": "ccob",
                            "path": source_path(path, environment),
                            "runtime_dump": output.name,
                            "error": str(error),
                        }
                    )
                    container_failed = True
                    continue
                source_records += 1
            if not container_failed:
                materialized_containers += 1

        if progress_every > 0 and index % progress_every == 0:
            print(
                f"CCOB: processed {index}/{len(paths)} containers",
                flush=True,
            )
    return source_records, materialized_containers, failures


def parse_aks2(blob: bytes):
    """Yield the loadable images described by one AOTriton AKS2 record."""
    if len(blob) < AKS2_HEADER.size:
        raise ValueError("truncated AKS2 header")
    magic, uncompressed_size, kernel_count, directory_size = AKS2_HEADER.unpack_from(
        blob
    )
    if magic != b"AKS2":
        raise ValueError(f"bad AKS2 magic: {magic!r}")
    content = lzma.decompress(blob[AKS2_HEADER.size :])
    if len(content) != uncompressed_size:
        raise ValueError(
            f"AKS2 size mismatch: expected {uncompressed_size}, got {len(content)}"
        )

    cursor = 0
    records = []
    for _ in range(kernel_count):
        if cursor + AKS2_METADATA.size > len(content):
            raise ValueError("truncated AKS2 directory")
        shared_memory, threads, offset, image_size, filename_length = (
            AKS2_METADATA.unpack_from(content, cursor)
        )
        cursor += AKS2_METADATA.size
        end = cursor + filename_length
        if filename_length == 0 or end > len(content):
            raise ValueError("invalid AKS2 filename length")
        raw_name = content[cursor:end]
        cursor = end
        if not raw_name.endswith(b"\0"):
            raise ValueError("AKS2 filename is not NUL terminated")
        records.append(
            (
                raw_name[:-1].decode("utf-8", errors="surrogateescape"),
                shared_memory,
                threads,
                offset,
                image_size,
            )
        )
    if cursor != directory_size:
        raise ValueError(
            f"AKS2 directory mismatch: expected {directory_size}, parsed {cursor}"
        )

    image_base = cursor
    for name, shared_memory, threads, offset, image_size in records:
        begin = image_base + offset
        end = begin + image_size
        if end > len(content):
            raise ValueError(f"AKS2 image {name!r} extends beyond its content")
        yield name, shared_memory, threads, content[begin:end]


def extract_aotriton(
    image_root: Path,
    corpus: Corpus,
    environment: Path,
    target: str,
) -> tuple[int, int]:
    entry_count = 0
    image_count = 0

    for archive in sorted(image_root.rglob("*.zip")):
        with zipfile.ZipFile(archive) as archive_file:
            for aks2_entry in sorted(archive_file.namelist()):
                if aks2_entry.endswith("/"):
                    continue
                entry_count += 1
                for index, (
                    kernel_name,
                    shared_memory,
                    threads,
                    image,
                ) in enumerate(parse_aks2(archive_file.read(aks2_entry))):
                    if target not in amdhsa_targets(image):
                        raise ValueError(
                            "AOTriton image has the wrong target: "
                            f"{archive}:{aks2_entry}:{index}"
                        )
                    corpus.add(
                        image,
                        "aotriton-aks2",
                        {
                            "archive": source_path(archive, environment),
                            "aks2_entry": aks2_entry,
                            "kernel_index": index,
                            "kernel_name": kernel_name,
                            "shared_memory": shared_memory,
                            "threads": threads,
                            "target_evidence": "amdhsa-target",
                        },
                    )
                    image_count += 1
    return entry_count, image_count


def embedded_elf_size(data, base: int) -> int | None:
    """Return the complete size of an embedded little-endian AMDGPU ELF64."""
    if base + 64 > len(data):
        return None
    if data[base : base + 6] != ELF_MAGIC + bytes((ELFCLASS64, ELFDATA2LSB)):
        return None
    if struct.unpack_from("<H", data, base + 16)[0] != ET_DYN:
        return None
    if struct.unpack_from("<H", data, base + 18)[0] != EM_AMDGPU:
        return None

    program_offset = struct.unpack_from("<Q", data, base + 32)[0]
    section_offset = struct.unpack_from("<Q", data, base + 40)[0]
    (
        header_size,
        program_entry_size,
        program_count,
        section_entry_size,
        section_count,
    ) = struct.unpack_from("<HHHHH", data, base + 52)
    relative_limit = len(data) - base
    if program_count and program_entry_size < 56:
        return None
    if section_count and section_entry_size < 64:
        return None
    if program_offset + program_entry_size * program_count > relative_limit:
        return None
    if section_offset + section_entry_size * section_count > relative_limit:
        return None

    end = max(
        header_size,
        program_offset + program_entry_size * program_count,
        section_offset + section_entry_size * section_count,
    )
    for index in range(program_count):
        position = base + program_offset + index * program_entry_size
        file_offset = struct.unpack_from("<Q", data, position + 8)[0]
        file_size = struct.unpack_from("<Q", data, position + 32)[0]
        end = max(end, file_offset + file_size)
    for index in range(section_count):
        position = base + section_offset + index * section_entry_size
        section_type = struct.unpack_from("<I", data, position + 4)[0]
        file_offset = struct.unpack_from("<Q", data, position + 24)[0]
        file_size = struct.unpack_from("<Q", data, position + 32)[0]
        if section_type != SHT_NOBITS:
            end = max(end, file_offset + file_size)
    return end if end <= relative_limit else None


def extract_raw_embedded(
    paths: list[Path],
    corpus: Corpus,
    environment: Path,
    target: str,
) -> tuple[int, list[dict[str, object]]]:
    count = 0
    failures: list[dict[str, object]] = []
    expected_note = target_note(target)

    for path in paths:
        try:
            with path.open("rb") as source:
                if os.fstat(source.fileno()).st_size == 0:
                    continue
                with mmap.mmap(source.fileno(), 0, access=mmap.ACCESS_READ) as data:
                    if data.find(expected_note) < 0:
                        continue
                    cursor = 1  # A loose object at offset zero is handled above.
                    while True:
                        cursor = data.find(ELF_MAGIC, cursor)
                        if cursor < 0:
                            break
                        size = embedded_elf_size(data, cursor)
                        if size is not None:
                            image = data[cursor : cursor + size]
                            if target in amdhsa_targets(image):
                                try:
                                    corpus.add(
                                        image,
                                        "raw-embedded",
                                        {
                                            "path": source_path(path, environment),
                                            "offset": cursor,
                                            "target_evidence": "amdhsa-target",
                                        },
                                    )
                                except ValueError as error:
                                    failures.append(
                                        {
                                            "category": "raw-embedded",
                                            "path": source_path(path, environment),
                                            "offset": cursor,
                                            "error": str(error),
                                        }
                                    )
                                else:
                                    count += 1
                        cursor += len(ELF_MAGIC)
        except OSError as error:
            failures.append(
                {
                    "category": "raw-embedded",
                    "path": source_path(path, environment),
                    "error": str(error),
                }
            )
    return count, failures


def locate_file(candidates: list[Path], description: str) -> Path:
    for candidate in candidates:
        if candidate.is_file():
            return candidate
    joined = "\n  ".join(str(candidate) for candidate in candidates)
    raise RuntimeError(f"could not locate {description}; checked:\n  {joined}")


def package_snapshot() -> list[dict[str, str]]:
    packages = []
    for distribution in metadata.distributions():
        name = distribution.metadata.get("Name", distribution.name)
        packages.append({"name": name, "version": distribution.version})
    return sorted(
        packages,
        key=lambda package: (
            package["name"].lower(),
            package["version"],
        ),
    )


def selected_roots(
    site_packages: Path, sources: set[str]
) -> tuple[list[Path], Path | None]:
    roots = []
    if "rocm" in sources:
        rocm_roots = [
            site_packages / "_rocm_sdk_core",
            site_packages / "_rocm_sdk_libraries",
            site_packages / "_rocm_sdk_devel",
        ]
        rocm_roots = [root for root in rocm_roots if root.is_dir()]
        if not rocm_roots:
            raise RuntimeError(
                f"TheRock package roots were not found below {site_packages}"
            )
        roots.extend(rocm_roots)

    torch_root = None
    if "torch" in sources:
        torch_root = site_packages / "torch"
        if not torch_root.is_dir():
            raise RuntimeError(
                "PyTorch is not installed in the active venv. Install "
                "amd-torch-device-gfx1250 from the ROCm multi-arch index."
            )
        roots.append(torch_root)
        triton_root = site_packages / "triton"
        if triton_root.is_dir():
            roots.append(triton_root)
    return roots, torch_root


def resolve_additional_roots(
    values: list[Path],
    environment: Path | None = None,
    selected: list[Path] | None = None,
) -> list[Path]:
    """Resolve and validate caller-supplied distribution roots."""
    roots: list[Path] = []
    for value in values:
        root = value.resolve()
        if not root.is_dir():
            raise RuntimeError(
                f"additional extraction root is not a directory: {root}"
            )
        if root in roots:
            raise RuntimeError(f"additional extraction root is repeated: {root}")
        if environment is not None:
            try:
                root.relative_to(environment)
            except ValueError as error:
                raise RuntimeError(
                    "additional extraction root must be below the selected "
                    f"environment: {root}"
                ) from error
        overlaps = any(
            root.is_relative_to(other) or other.is_relative_to(root)
            for other in [*(selected or []), *roots]
        )
        if overlaps:
            raise RuntimeError(f"additional extraction roots overlap: {root}")
        roots.append(root)
    return roots


def additional_root_stats(
    roots: list[Path],
    files: list[Path],
    records: list[dict[str, object]],
    environment: Path,
) -> list[dict[str, object]]:
    """Report inventory and provenance contributions for requested roots."""
    stats = []
    for root in roots:
        relative_root = source_path(root, environment)
        prefix = f"{relative_root}/"
        source_records = sum(
            1
            for record in records
            if any(
                str(record.get(field, "")).startswith(prefix)
                for field in ("path", "archive")
            )
        )
        stats.append(
            {
                "root": relative_root,
                "files_scanned": sum(path.is_relative_to(root) for path in files),
                "source_records": source_records,
            }
        )
    return stats


def aotriton_image_roots(roots: list[Path], target: str) -> list[Path]:
    """Find AOTriton image stores below every selected scan root."""
    candidates = [
        root / "lib" / "aotriton.images" / f"amd-{target}" for root in roots
    ]
    return [candidate for candidate in candidates if candidate.is_dir()]


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--destination",
        type=Path,
        help="new or empty output directory",
    )
    parser.add_argument(
        "--environment",
        type=Path,
        help="active venv root; defaults to sys.prefix",
    )
    parser.add_argument(
        "--target",
        default="gfx1250",
        choices=tuple(sorted(AMDGPU_MACH_BY_TARGET)),
        help="AMDGPU target to extract (default: gfx1250)",
    )
    parser.add_argument(
        "--source",
        action="append",
        choices=("rocm", "torch"),
        help="source family to scan; repeatable (default: rocm and torch)",
    )
    parser.add_argument(
        "--additional-root",
        action="append",
        type=Path,
        default=[],
        help=(
            "additional unpacked distribution root to scan; repeatable and "
            "combined with the selected venv package roots"
        ),
    )
    parser.add_argument(
        "--materialize-ccob",
        action="store_true",
        help="use HIP on a visible target GPU to materialize CCOB containers",
    )
    parser.add_argument(
        "--progress-every",
        type=int,
        default=25,
        help="CCOB progress interval (default: 25; 0 disables)",
    )
    parser.add_argument(
        "--dump-ccob",
        nargs=3,
        metavar=("HIP_LIBRARY", "CCOB", "DEVICE_ORDINAL"),
        help=argparse.SUPPRESS,
    )
    args = parser.parse_args()
    if args.dump_ccob:
        return args
    if args.destination is None:
        parser.error("--destination is required")
    if args.progress_every < 0:
        parser.error("--progress-every must be non-negative")
    return args


def main() -> int:
    args = parse_arguments()
    if args.dump_ccob:
        return dump_ccob_child(
            Path(args.dump_ccob[0]),
            Path(args.dump_ccob[1]),
            int(args.dump_ccob[2]),
        )

    environment = (args.environment or Path(sys.prefix)).resolve()
    if environment != Path(sys.prefix).resolve():
        raise SystemExit(
            "error: run this script with the selected venv's Python: "
            f"{environment}/bin/python {Path(__file__).resolve()}"
        )
    if not (environment / "pyvenv.cfg").is_file():
        raise SystemExit(
            "error: no active venv detected; activate the TheRock/PyTorch "
            "venv or invoke its bin/python directly"
        )

    site_packages = Path(sysconfig.get_paths()["purelib"]).resolve()
    sources = set(args.source or ("rocm", "torch"))
    try:
        roots, _torch_root = selected_roots(site_packages, sources)
        additional_roots = resolve_additional_roots(
            args.additional_root, environment, roots
        )
    except RuntimeError as error:
        raise SystemExit(f"error: {error}") from error
    roots.extend(additional_roots)

    ccob_device_ordinal = None
    visible_devices: list[tuple[int, str]] = []
    if args.materialize_ccob:
        try:
            visible_devices = visible_gpu_devices()
        except RuntimeError as error:
            raise SystemExit(
                f"error: cannot validate the CCOB materialization target: {error}"
            ) from error
        ccob_device_ordinal = next(
            (
                ordinal
                for ordinal, architecture in visible_devices
                if architecture == args.target
            ),
            None,
        )
        if ccob_device_ordinal is None:
            shown_targets = (
                ", ".join(
                    f"{ordinal}:{architecture}"
                    for ordinal, architecture in visible_devices
                )
                or "none"
            )
            raise SystemExit(
                "error: --materialize-ccob requires a visible "
                f"{args.target} GPU; PyTorch reports: {shown_targets}"
            )

    destination = args.destination.resolve()
    if destination.exists() and (
        not destination.is_dir() or any(destination.iterdir())
    ):
        raise SystemExit(f"error: --destination must be absent or empty: {destination}")
    destination.mkdir(parents=True, exist_ok=True)

    print(f"environment: {environment}")
    print(f"site-packages: {site_packages}")
    print(f"sources: {', '.join(sorted(sources))}")
    for root in additional_roots:
        print(f"additional root: {root}")
    print(f"target: {args.target}")
    print(f"destination: {destination}")

    try:
        inventory = inventory_files(roots)
    except OSError as error:
        raise SystemExit(
            f"error: cannot inventory extraction roots: {error}"
        ) from error
    print(f"inventory: {len(inventory.files)} files")
    print(f"KPACK containers: {len(inventory.kpack)}")
    print(f"CCOB containers: {len(inventory.ccob)}")

    core_library = site_packages / "_rocm_sdk_core" / "lib"
    devel_library = site_packages / "_rocm_sdk_devel" / "lib"
    corpus = Corpus(destination, args.target)
    failures: list[dict[str, object]] = []

    kpack_source_records = 0
    if inventory.kpack:
        try:
            kpack_library = locate_file(
                [
                    core_library / "librocm_kpack.so.0",
                    devel_library / "librocm_kpack.so.0",
                ],
                "librocm_kpack.so.0",
            )
            kpack = Kpack(kpack_library, args.target)
            for archive in inventory.kpack:
                try:
                    kpack_source_records += kpack.extract(archive, corpus, environment)
                except (OSError, RuntimeError, ValueError) as error:
                    failures.append(
                        {
                            "category": "kpack",
                            "archive": source_path(archive, environment),
                            "error": str(error),
                        }
                    )
        except RuntimeError as error:
            failures.append({"category": "kpack", "error": str(error)})
    print(f"KPACK records: {kpack_source_records}", flush=True)

    loose_source_records = extract_loose(
        inventory.loose_amdgpu,
        corpus,
        environment,
        args.target,
    )
    print(f"loose records: {loose_source_records}", flush=True)

    bundle_source_records = 0
    try:
        llvm_bin = core_library / "llvm" / "bin"
        llvm_objcopy = locate_file(
            [
                llvm_bin / "llvm-objcopy",
                environment / "bin" / "llvm-objcopy",
            ],
            "llvm-objcopy",
        )
        bundler = locate_file(
            [
                llvm_bin / "clang-offload-bundler",
                environment / "bin" / "clang-offload-bundler",
            ],
            "clang-offload-bundler",
        )
        bundle_source_records, bundle_failures = extract_bundles(
            inventory.host_elf,
            corpus,
            environment,
            args.target,
            llvm_objcopy,
            bundler,
        )
        failures.extend(bundle_failures)
    except RuntimeError as error:
        failures.append({"category": "hip-bundle", "error": str(error)})
    print(f"HIP bundle records: {bundle_source_records}", flush=True)

    ccob_source_records = 0
    ccob_materialized_containers = 0
    if args.materialize_ccob and inventory.ccob:
        try:
            hip_library = locate_file(
                [
                    core_library / "libamdhip64.so.7",
                    devel_library / "libamdhip64.so.7",
                ],
                "libamdhip64.so.7",
            )
            (
                ccob_source_records,
                ccob_materialized_containers,
                ccob_failures,
            ) = extract_ccob(
                inventory.ccob,
                corpus,
                environment,
                hip_library,
                args.target,
                ccob_device_ordinal,
                args.progress_every,
            )
            failures.extend(ccob_failures)
        except RuntimeError as error:
            failures.append({"category": "ccob", "error": str(error)})
    ccob_status, _ = extraction_completion(
        ccob_containers=len(inventory.ccob),
        materialize_ccob=args.materialize_ccob,
        failures=failures,
    )
    print(
        "CCOB records: "
        f"{ccob_source_records} ({ccob_status}, "
        f"{ccob_materialized_containers}/{len(inventory.ccob)} containers)",
        flush=True,
    )

    raw_source_records, raw_failures = extract_raw_embedded(
        inventory.files,
        corpus,
        environment,
        args.target,
    )
    failures.extend(raw_failures)
    print(f"raw embedded records: {raw_source_records}", flush=True)

    aotriton_entries = 0
    aotriton_source_records = 0
    aotriton_archives = 0
    for aotriton_root in aotriton_image_roots(roots, args.target):
        try:
            aotriton_archives += len(list(aotriton_root.rglob("*.zip")))
            entries, records = extract_aotriton(
                aotriton_root, corpus, environment, args.target
            )
            aotriton_entries += entries
            aotriton_source_records += records
        except (OSError, ValueError, zipfile.BadZipFile) as error:
            failures.append({"category": "aotriton-aks2", "error": str(error)})
    print(
        "AOTriton records: "
        f"{aotriton_source_records} from {aotriton_entries} AKS2 entries",
        flush=True,
    )

    _ccob_status, complete = extraction_completion(
        ccob_containers=len(inventory.ccob),
        materialize_ccob=args.materialize_ccob,
        failures=failures,
    )
    assert _ccob_status == ccob_status
    failures.sort(key=lambda failure: json.dumps(failure, sort_keys=True))
    write_json(
        destination / "manifests" / "packages.json",
        package_snapshot(),
    )
    summary = corpus.finish(
        {
            "target": args.target,
            "environment": str(environment),
            "site_packages": str(site_packages),
            "sources": sorted(sources),
            "additional_roots": [
                source_path(root, environment) for root in additional_roots
            ],
            "additional_root_stats": additional_root_stats(
                additional_roots,
                inventory.files,
                corpus.records,
                environment,
            ),
            "files_scanned": len(inventory.files),
            "kpack_containers": len(inventory.kpack),
            "kpack_source_records": kpack_source_records,
            "loose_source_records": loose_source_records,
            "hip_bundle_source_records": bundle_source_records,
            "ccob_containers": len(inventory.ccob),
            "ccob_device_ordinal": ccob_device_ordinal,
            "ccob_materialized_containers": ccob_materialized_containers,
            "ccob_source_records": ccob_source_records,
            "ccob_status": ccob_status,
            "raw_embedded_source_records": raw_source_records,
            "aotriton_archives": aotriton_archives,
            "aotriton_aks2_entries": aotriton_entries,
            "aotriton_source_records": aotriton_source_records,
            "complete": complete,
            "failures": failures,
        }
    )
    print(json.dumps(summary, indent=2, sort_keys=True))
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
