# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Opt-in compilation of the real adapter; no linking or device execution."""

import os
from pathlib import Path
import subprocess

import pytest


@pytest.mark.parametrize("standard", [None, "c++17"], ids=["default", "cxx17"])
@pytest.mark.parametrize("hip", [False, True], ids=["cpu", "hip"])
def test_llama_adapter_compiles_with_host_compiler(tmp_path, standard, hip):
    compiler = os.environ.get("LLAMA_COMPILE_TEST_CXX")
    ggml = os.environ.get("LLAMA_COMPILE_TEST_GGML")
    sdk = os.environ.get("LLAMA_COMPILE_TEST_SDK")
    if not compiler or not ggml or not sdk:
        pytest.skip("set LLAMA_COMPILE_TEST_CXX/GGML/SDK for real-header compilation")
    source = Path(__file__).resolve().parents[1] / "corpus/benchmarks/llama/runner.cpp"
    command = [
        compiler,
        "-c",
        str(source),
        "-o",
        str(tmp_path / "runner.o"),
        "-I" + str(Path(ggml) / "include"),
        "-DGGML_BACKEND_SHARED",
        "-DGGML_SHARED",
        "-DGGML_USE_CPU",
    ]
    if standard:
        command.append("-std=" + standard)
    if hip:
        command += [
            "-DEXPERIMENT_HIP",
            "-DGGML_USE_CUDA",
            "-DGGML_USE_HIP",
            "-DUSE_PROF_API=1",
            "-D__HIP_PLATFORM_AMD__=1",
            "-isystem",
            str(Path(sdk) / "include"),
        ]
    result = subprocess.run(command, capture_output=True, text=True, timeout=120)
    assert (
        result.returncode == 0
    ), f"Adapter compilation failed: {command!r}\n{result.stdout}\n{result.stderr}"
