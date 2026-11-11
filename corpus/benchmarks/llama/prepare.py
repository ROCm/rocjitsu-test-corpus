#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Verify a caller-owned exact llama checkout, then build out-of-source (-j16).

Acquire separately: git clone https://github.com/ggml-org/llama.cpp.git SOURCE;
git -C SOURCE checkout --detach 26d52b0f9543f441fc2bfa383557c992a4fbf4b9.
This command never checks out, fetches, patches or writes inside that source.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess

PIN = "26d52b0f9543f441fc2bfa383557c992a4fbf4b9"
HERE = Path(__file__).resolve().parent


def git(source, *args):
    return subprocess.check_output(["git", "-C", str(source), *args], text=True).strip()


def verify_source(source):
    source = Path(source).resolve()
    if git(source, "rev-parse", "--show-toplevel") != str(source):
        raise ValueError("source must be the checkout root")
    if git(source, "rev-parse", "HEAD") != PIN:
        raise ValueError("llama source revision must be " + PIN)
    if git(source, "status", "--porcelain", "--untracked-files=all", "--ignored"):
        raise ValueError(
            "llama source must be pristine, including untracked/ignored files"
        )
    for required in ("LICENSE", "ggml/CMakeLists.txt", "ggml/include/ggml.h"):
        if not (source / required).is_file():
            raise ValueError("incomplete llama source: " + required)
    return source


def check_build_path(source, build):
    source, build = Path(source).resolve(), Path(build).resolve()
    if (
        build == source
        or source in build.parents
        or build == HERE
        or HERE in build.parents
    ):
        raise ValueError(
            "build must remain outside upstream and adapter source directories"
        )
    if build in source.parents or build in HERE.parents:
        raise ValueError("build must not contain source directories")
    return build


def sha256(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument(
        "--build", type=Path, required=True, help="fresh owned out-of-source directory"
    )
    parser.add_argument("--backend", choices=("cpu", "hip"), required=True)
    parser.add_argument("--rocm-path", type=Path)
    parser.add_argument(
        "--mutation", action="store_true", help="CPU-only negative-control binary"
    )
    args = parser.parse_args(argv)
    try:
        source = verify_source(args.source)
        build = check_build_path(source, args.build)
        if build.exists():
            raise ValueError(
                "build directory already exists; choose a fresh owned directory"
            )
        if args.mutation and args.backend != "cpu":
            raise ValueError("mutation is CPU-only")
        if args.backend == "hip" and not args.rocm_path:
            raise ValueError(
                "--rocm-path is required for explicit HIP toolchain selection"
            )
        build.mkdir(parents=True)
        env = dict(
            os.environ,
            CCACHE_DISABLE="1",
            CCACHE_DIR=str(build / "cache/ccache"),
            XDG_CACHE_HOME=str(build / "cache"),
            TMPDIR=str(build / "tmp"),
        )
        (build / "tmp").mkdir()
        (build / "cache").mkdir()
        for key in (
            "HCC_AMDGPU_TARGET",
            "AMDGPU_TARGETS",
            "GPU_TARGETS",
            "CMAKE_HIP_ARCHITECTURES",
        ):
            env.pop(key, None)
        command = [
            "cmake",
            "-S",
            str(HERE),
            "-B",
            str(build),
            "-G",
            "Ninja",
            "-DLLAMA_SOURCE_DIR=" + str(source),
            "-DCMAKE_BUILD_TYPE=Release",
            "-DGGML_HIP=" + ("ON" if args.backend == "hip" else "OFF"),
            "-DGGML_CCACHE=OFF",
            "-DCMAKE_C_COMPILER_LAUNCHER=",
            "-DCMAKE_CXX_COMPILER_LAUNCHER=",
            "-DBENCHMARK_BUILD_CPU_MUTATION=" + ("ON" if args.mutation else "OFF"),
        ]
        if args.backend == "hip":
            sdk = args.rocm_path.resolve()
            env.update(
                ROCM_PATH=str(sdk),
                HIP_PATH=str(sdk),
                HCC_AMDGPU_TARGET="gfx1100,gfx1201",
            )
            libraries = [
                sdk / "lib",
                sdk / "lib/rocm_sysdeps/lib",
                sdk / "lib/llvm/lib",
                sdk / "lib/host-math/lib",
            ]
            env["LD_LIBRARY_PATH"] = ":".join(map(str, libraries)) + (
                ":" + env["LD_LIBRARY_PATH"] if env.get("LD_LIBRARY_PATH") else ""
            )
            command += [
                "-DCMAKE_HIP_ARCHITECTURES=gfx1100;gfx1201",
                "-DCMAKE_HIP_COMPILER=" + str(sdk / "lib/llvm/bin/clang++"),
                "-DCMAKE_HIP_COMPILER_ROCM_ROOT=" + str(sdk),
                "-DCMAKE_PREFIX_PATH=" + str(sdk),
            ]
        with (build / "configure.log").open("w") as log:
            subprocess.run(
                command,
                env=env,
                cwd=build,
                stdout=log,
                stderr=subprocess.STDOUT,
                check=True,
            )
        with (build / "build.log").open("w") as log:
            subprocess.run(
                ["cmake", "--build", str(build), "-j16"],
                env=env,
                cwd=build,
                stdout=log,
                stderr=subprocess.STDOUT,
                check=True,
            )
        verify_source(source)
        receipt = dict(
            schema="rocjitsu.benchmark.llama-build.v1",
            source_url="https://github.com/ggml-org/llama.cpp",
            source_pin=PIN,
            source=str(source),
            backend=args.backend,
            targets=["gfx1100", "gfx1201"] if args.backend == "hip" else [],
            build_command=["cmake", "--build", str(build), "-j16"],
            configure_command=command,
            source_license_sha256=sha256(source / "LICENSE"),
            adapter_sha256=sha256(HERE / "bounded-ops.cpp"),
            cmake_sha256=sha256(HERE / "CMakeLists.txt"),
            binary_sha256=sha256(build / "bounded-ops"),
            cmake_version=subprocess.check_output(
                ["cmake", "--version"], text=True
            ).splitlines()[0],
        )
        (build / "benchmark-build.json").write_text(
            json.dumps(receipt, indent=2) + "\n"
        )
        print(build / "bounded-ops")
    except (ValueError, OSError, subprocess.CalledProcessError) as exc:
        parser.exit(1, str(exc) + "\n")


if __name__ == "__main__":
    main()
