#!/usr/bin/env python3
"""Build and smoke-check the llama.cpp backend-ops corpus executable."""

from __future__ import annotations

import argparse
import os
import subprocess
from pathlib import Path
from typing import Sequence


DEFAULT_TARGETS = ("gfx1201",)
DEFAULT_JOBS = max(1, ((os.cpu_count() or 1) + 1) // 2)


def _positive_int(value: str) -> int:
    parsed = int(value)
    if parsed < 1:
        raise argparse.ArgumentTypeError("value must be at least 1")
    return parsed


def _parse_args(argv: Sequence[str] | None = None) -> argparse.Namespace:
    source_dir = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--targets",
        nargs="+",
        default=list(DEFAULT_TARGETS),
        metavar="GFX_TARGET",
        help="HIP targets to compile",
    )
    parser.add_argument(
        "--build-dir",
        type=Path,
        default=source_dir / "build",
        help="CMake build directory",
    )
    parser.add_argument(
        "--jobs",
        type=_positive_int,
        default=DEFAULT_JOBS,
        help="parallel CMake build jobs",
    )
    return parser.parse_args(argv)


def _run(command: Sequence[str]) -> None:
    subprocess.run(command, check=True)


def _check_selected_tests(source_dir: Path, executable: Path) -> None:
    selected_tests_path = source_dir / "selected_llama_backend_ops_tests.txt"
    selected_tests = selected_tests_path.read_text(encoding="utf-8").strip()
    if not selected_tests:
        raise RuntimeError(f"selected test list is empty: {selected_tests_path}")

    _run(
        [
            str(executable),
            "support",
            "-o",
            selected_tests,
            "-b",
            "ROCm0",
            "--output",
            "csv",
        ]
    )


def main(argv: Sequence[str] | None = None) -> int:
    args = _parse_args(argv)
    source_dir = Path(__file__).resolve().parent
    build_dir = args.build_dir.resolve()
    llama_source_dir = source_dir / "third_party" / "llama.cpp"
    targets = ";".join(args.targets)

    _run(
        [
            "cmake",
            "-S",
            str(source_dir),
            "-B",
            str(build_dir),
            f"-DCMAKE_HIP_ARCHITECTURES={targets}",
            f"-DLLAMA_CORPUS_SOURCE_DIR={llama_source_dir}",
        ]
    )
    _run(
        [
            "cmake",
            "--build",
            str(build_dir),
            "--target",
            "test-backend-ops",
            "-j",
            str(args.jobs),
        ]
    )
    _check_selected_tests(source_dir, build_dir / "test-backend-ops")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
