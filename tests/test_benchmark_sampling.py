# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Sampling boundaries without running large workloads or importing GPU runtimes."""

import json
import os
from pathlib import Path
import subprocess
import sys

import pytest

ROOT = Path(__file__).resolve().parents[1]


@pytest.mark.parametrize(
    "provider", ["gluon", "llama", "full_tensile", "tensile_candidates"]
)
@pytest.mark.parametrize(
    "warmups,samples", [(101, 102), (65537, 65538), (-1, 1), (0, 0)]
)
def test_adapter_sampling_validation_before_preparation(
    monkeypatch, tmp_path, provider, warmups, samples
):
    """Stop at the real preparation boundary; never allocate or launch a workload."""
    if provider == "gluon":
        from corpus.benchmarks.gluon import workloads as adapter
        from corpus.benchmarks.gluon import prepare

        workload, params = "gluon_copy", {"elements": 33}
        boundary = (prepare, "verify_local")
    elif provider == "llama":
        from corpus.benchmarks.llama import workloads as adapter

        workload, params = "llama_rope", {"k": 2, "heads": 1, "tokens": 1}
        boundary = (adapter, "verify_binary")
    elif provider == "full_tensile":
        from corpus.benchmarks.full_tensile import prepare

        monkeypatch.setitem(sys.modules, "prepare", prepare)
        from corpus.benchmarks.full_tensile import workload as adapter

        workload, params = "full_tensile", prepare.CASES["valu"]
        boundary = (adapter, "validate_artifacts")
        monkeypatch.setenv("FULL_TENSILE_ARTIFACTS", str(tmp_path))
    else:
        from corpus.benchmarks.tensile_candidates import prepare

        monkeypatch.setitem(sys.modules, "prepare", prepare)
        from corpus.benchmarks.tensile_candidates import workload as adapter

        workload = "tensile_candidate"
        params = {"variant": "bf16_subtile", "dtype": "bf16"}
        # Candidate shapes are fixed by their preparation owner.
        params.update(zip(("m", "n", "k"), prepare.CANDIDATES["bf16_subtile"][3]))
        monkeypatch.setenv("TENSILE_CANDIDATE_ARTIFACTS", str(tmp_path))
        # Missing provenance is a deterministic stop before subprocess execution.
        boundary = None

    class ReachedPreparation(Exception):
        pass

    def stop(*args, **kwargs):
        raise ReachedPreparation

    if boundary:
        monkeypatch.setattr(*boundary, stop)
    argv = [
        "workload",
        "--workload",
        workload,
        "--params",
        json.dumps(params),
        "--case",
        "sampling",
        "--target",
        "gfx1250" if provider == "tensile_candidates" else "gfx1100",
        "--warmups",
        str(warmups),
        "--samples",
        str(samples),
        "--output",
        str(tmp_path / "result"),
    ]
    if provider == "llama":
        argv += ["--binary", str(tmp_path / "binary")]
    monkeypatch.setattr(sys, "argv", argv)
    if warmups < 0 or samples <= 0:
        with pytest.raises((SystemExit, ValueError)):
            adapter.main()
    else:
        with pytest.raises(ReachedPreparation if boundary else FileNotFoundError):
            adapter.main()


@pytest.mark.parametrize("provider", ["full_tensile", "tensile_candidates"])
def test_native_count_parsing_before_execution(tmp_path, provider):
    """Compile actual parser + CLI prefix, stopping before host allocation/HIP.

    This is a host parser test, not a native device execution claim. Including
    the CLI prefix ensures shapes and counts use their respective real parsers.
    """
    source = (ROOT / "corpus/benchmarks" / provider / "runner.cpp").read_text()
    if provider == "full_tensile":
        helper = source[source.index("int number(") : source.index("void upload(")]
        prefix = source[
            source.index("        if(argc!=13)") : source.index(
                "        full_tensile::Host host"
            )
        ]
        args = [
            "root",
            "valu",
            "gfx1100",
            "1",
            "1",
            "1",
            "1",
            "1",
            "0",
            "0",
            "1",
            "output",
        ]
        wi, si, shape = 9, 10, 3
    else:
        helper = source[source.index("int positive(") : source.index("} // namespace")]
        prefix = source[
            source.index("        if (argc != 10)") : source.index(
                "        hipDeviceProp_t properties"
            )
        ]
        args = ["root", "bf16_subtile", "gfx1100", "1", "1", "1", "0", "1", "output"]
        wi, si, shape = 6, 7, 3
    host = tmp_path / "parser.cpp"
    host.write_text(
        "#include <string>\n#include <stdexcept>\n#include <limits>\n#include <filesystem>\n#include <iostream>\n"
        + helper
        + "\nint main(int argc,char** argv) {try {\n"
        + prefix
        + '\nstd::cout << warmups << " " << samples; return 0;\n} catch(const std::exception& e) {std::cerr << e.what(); return 1;}}\n'
    )
    binary = tmp_path / "parser"
    subprocess.run(
        [
            "c++",
            "-std=c++17",
            "-Wall",
            "-Wextra",
            "-Wno-unused-variable",
            "-Werror",
            str(host),
            "-o",
            str(binary),
        ],
        check=True,
    )
    for warmups, samples in [(0, 1), (65537, 65538), (2147483647, 2147483647)]:
        command = args.copy()
        command[wi], command[si] = str(warmups), str(samples)
        result = subprocess.run([str(binary), *command], text=True, capture_output=True)
        assert result.returncode == 0, result.stderr
        assert result.stdout == f"{warmups} {samples}"
    for index, value in [
        (wi, "-1"),
        (si, "0"),
        (si, "-1"),
        (si, "1x"),
        (wi, "2147483648"),
        (si, "9223372036854775808"),
        (shape, "65537"),
    ]:
        command = args.copy()
        command[index] = value
        result = subprocess.run([str(binary), *command], text=True, capture_output=True)
        assert result.returncode != 0, command
        assert not result.stdout


@pytest.mark.skipif(
    not os.environ.get("LLAMA_BENCHMARK_CPU_BINARY"), reason="prepare CPU binary first"
)
def test_llama_cpu_above_old_count_cap():
    binary = os.environ["LLAMA_BENCHMARK_CPU_BINARY"]
    # Exercise native counts and wrapper validation with a tiny real CPU graph.
    for warmups, samples in [(101, 102), (0, 101)]:
        result = subprocess.run(
            [
                sys.executable,
                str(ROOT / "corpus/benchmarks/llama/workloads.py"),
                "--binary",
                binary,
                "--cpu",
                "--workload",
                "llama_rope",
                "--params",
                '{"k":2,"heads":1,"tokens":1}',
                "--case",
                "counts",
                "--target",
                "gfx1100",
                "--warmups",
                str(warmups),
                "--samples",
                str(samples),
                "--output",
                "-",
            ],
            capture_output=True,
            text=True,
            timeout=60,
        )
        assert result.returncode == 0, result.stderr
        assert len(json.loads(result.stdout)["timings_ns"]) == samples


@pytest.mark.skipif(
    not os.environ.get("LLAMA_BENCHMARK_CPU_BINARY"), reason="prepare CPU binary first"
)
def test_llama_native_count_representation_before_execution():
    binary = os.environ["LLAMA_BENCHMARK_CPU_BINARY"]
    for count in ("101", "65537", "2147483647"):
        # CPU-only build without --cpu stops before allocation, after parsing.
        result = subprocess.run(
            [binary, "rope", "--warmups", count, "--samples", count],
            capture_output=True,
            text=True,
            timeout=10,
        )
        assert result.returncode == 1
        assert result.stderr.strip() == "backend unavailable (CPU build requires --cpu)"
    for option, count in [
        ("--samples", "0"),
        ("--samples", "-1"),
        ("--warmups", "-1"),
        ("--samples", "1x"),
        ("--samples", "2147483648"),
        ("--warmups", "999999999999999999999"),
    ]:
        result = subprocess.run(
            [binary, "rope", option, count], capture_output=True, text=True, timeout=10
        )
        assert result.returncode == 1
        assert result.stderr.strip() != "backend unavailable (CPU build requires --cpu)"
        assert not result.stdout
