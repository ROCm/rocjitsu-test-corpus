#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Compile first-party CTS, runtime CTS, race and semantic headers in isolation."""

from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import re
import shlex
import shutil
import subprocess


ROOT = Path(__file__).resolve().parents[1]
HEADER_DIRS = ("corpus/cts", "corpus/runtime-cts", "corpus/race", "corpus/semantics")
HIP_TARGETS = {
    "gfx1250": "gfx1250",
    "cdna3": "gfx942",
    "cdna4": "gfx950",
    "rdna3": "gfx1151",
    "rdna4": "gfx1201",
}


def include_roots(header: Path) -> list[Path]:
    if "runtime-cts" in header.parts:
        return [
            Path("corpus/runtime-cts"),
            Path("corpus/runtime-cts/common"),
            Path("corpus/runtime-cts/pm4/support/gfx125"),
        ]
    if "cts" in header.parts:
        return [
            Path("corpus/cts/support"),
            Path("corpus/cts/third_party/hip-fpsan/include"),
        ]
    return [header.parent]


def required_inputs(header: Path) -> set[str]:
    """Find external inputs named by the header and its local includes."""
    pending = [ROOT / header]
    visited = set()
    required = set()
    roots = [ROOT / directory for directory in include_roots(header)]
    while pending:
        path = pending.pop().resolve()
        if path in visited:
            continue
        visited.add(path)
        for delimiter, name in re.findall(
            r'^\s*#\s*include\s*(["<])([^">]+)[">]',
            path.read_text(),
            flags=re.MULTILINE,
        ):
            if name.startswith("gtest/"):
                required.add("gtest_include")
            elif name == "payload_kernel.inc":
                required.add("runtime_kernel_dir")
            elif delimiter == '"':
                for directory in [path.parent, *roots]:
                    included = directory / name
                    if included.is_file():
                        pending.append(included)
                        break
    return required


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rocm-path", type=Path, help="ROCm SDK root for HIP headers")
    parser.add_argument(
        "--gtest-include",
        type=Path,
        help="directory containing gtest/gtest.h, when selected headers use it",
    )
    parser.add_argument(
        "--runtime-kernel-dir",
        type=Path,
        help="runtime CTS build's kernels/gfx1250 directory, for payload headers",
    )
    parser.add_argument("--host-cxx", default="clang++", help="host C++ compiler")
    parser.add_argument(
        "--hip-cxx", help="HIP compiler (default: amdclang++ in the SDK)"
    )
    parser.add_argument(
        "--hip-include",
        type=Path,
        action="append",
        default=[],
        help="additional HIP system include directory; may be repeated",
    )
    parser.add_argument(
        "--header",
        action="append",
        help="repository-relative header to check; may be repeated",
    )
    parser.add_argument(
        "--jobs", type=int, default=4, help="parallel compiler processes"
    )
    args = parser.parse_args()
    if args.jobs < 1:
        parser.error("--jobs must be positive")
    headers = sorted(
        path.relative_to(ROOT)
        for directory in HEADER_DIRS
        for path in (ROOT / directory).rglob("*")
        if path.suffix in {".h", ".hpp"} and "third_party" not in path.parts
    )
    if args.header:
        selected = {Path(header) for header in args.header}
        unknown = selected - set(headers)
        if unknown:
            parser.error(
                "unknown helper headers: " + ", ".join(map(str, sorted(unknown)))
            )
        headers = [header for header in headers if header in selected]
    if not headers:
        parser.error("no helper headers found")

    dependencies = {header: required_inputs(header) for header in headers}
    needs_host = any("runtime-cts" in header.parts for header in headers)
    needs_hip = any("runtime-cts" not in header.parts for header in headers)
    required = set().union(*dependencies.values())
    if needs_hip:
        required.add("rocm_path")
    input_files = {
        "rocm_path": "include/hip/hip_runtime.h",
        "gtest_include": "gtest/gtest.h",
        "runtime_kernel_dir": "payload_kernel.inc",
    }
    for name in sorted(required):
        directory = getattr(args, name)
        if directory is None:
            parser.error(f"--{name.replace('_', '-')} is required for selected headers")
        directory = directory.resolve()
        setattr(args, name, directory)
        path = directory / input_files[name]
        if not path.is_file():
            parser.error(f"required input does not exist: {path}")

    host_cxx = shutil.which(args.host_cxx) if needs_host else None
    if needs_host and not host_cxx:
        parser.error("host compiler must be executable")
    hip_cxx = args.hip_cxx
    if needs_hip:
        if not hip_cxx:
            hip_cxx = next(
                (
                    str(args.rocm_path / directory / "amdclang++")
                    for directory in ("lib/llvm/bin", "bin", "llvm/bin")
                    if (args.rocm_path / directory / "amdclang++").is_file()
                ),
                None,
            )
        hip_cxx = shutil.which(hip_cxx) if hip_cxx else None
        if not hip_cxx:
            parser.error("HIP compiler must be executable")

    def check(header: Path) -> tuple[Path, int, str]:
        if "runtime-cts" in header.parts:
            command = [
                host_cxx,
                "-x",
                "c++",
                "-std=c++17",
                "-DCTS_GFX_VERSION=120500",
                '-DCTS_TARGET_NAME="gfx1250"',
            ]
        else:
            target = next(
                (
                    target
                    for directory, target in HIP_TARGETS.items()
                    if directory in header.parts
                ),
                "gfx950",
            )
            command = [
                hip_cxx,
                "-x",
                "hip",
                "-std=gnu++17" if "cts" in header.parts else "-std=c++20",
                f"--offload-arch={target}",
                f"--rocm-path={args.rocm_path}",
                f"--hip-path={args.rocm_path}",
            ]
            for directory in args.hip_include:
                command.extend(["-idirafter", str(directory.resolve())])
            if "_w64_" in header.name:
                command.append("-mwavefrontsize64")
        command.extend(f"-I{directory}" for directory in include_roots(header))
        for name in sorted(dependencies[header]):
            command.append(f"-I{getattr(args, name)}")
        command.extend(["-fsyntax-only", "-"])
        source = f'#include "{header.as_posix()}"\n'
        result = subprocess.run(
            command, input=source, cwd=ROOT, capture_output=True, text=True
        )
        detail = f"{shlex.join(command)}\n{source}{result.stdout}{result.stderr}"
        return header, result.returncode, detail

    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        results = list(pool.map(check, headers))
    for header, status, detail in results:
        print(f"{'FAIL' if status else 'PASS'} {header}")
        if status:
            print(detail)
    failed = sum(status != 0 for _, status, _ in results)
    print(f"{len(results) - failed}/{len(results)} helper headers passed")
    return int(failed != 0)


if __name__ == "__main__":
    raise SystemExit(main())
