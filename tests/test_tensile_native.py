# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Checks for immutable native inputs and host sampling, without a GPU or SDK."""
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess

import pytest

ROOT = Path(__file__).resolve().parents[1]


def test_packaged_tensile_identity():
    metadata = json.loads((ROOT / "corpus/kernels/cases/tensile/artifacts.json").read_text())
    artifacts = ROOT / metadata["artifact_directory"]
    for filename, digest in metadata["files"].items():
        assert hashlib.sha256((artifacts / filename).read_bytes()).hexdigest() == digest
    library = (artifacts / "TensileLibrary.yaml").read_text()
    kernels = re.findall(r"^  kernelName: (.*)$", library, re.MULTILINE)
    indices = re.findall(r"^  index: (\d+)$", library, re.MULTILINE)
    assert [entry["kernel_name"] for entry in metadata["solutions"]] == kernels
    assert [str(entry["index"]) for entry in metadata["solutions"]] == indices == ["0", "1"]


def test_sampling_boundaries_and_invalid_counts(tmp_path):
    compiler = shutil.which("c++")
    if compiler is None:
        pytest.skip("host C++ compiler unavailable")
    source = tmp_path / "sampling.cpp"
    source.write_text(r'''
#include "benchmark_sampling.hpp"
#include <cassert>
struct Clock {
    using duration = std::chrono::nanoseconds;
    using time_point = std::chrono::time_point<Clock>;
    static constexpr bool is_steady = true;
    inline static int64_t ticks = 0;
    static time_point now() { return time_point(duration(ticks)); }
};
int main() {
    int launches = 0, syncs = 0;
    auto launch = [&] { ++launches; Clock::ticks += 7; };
    auto sync = [&] { ++syncs; Clock::ticks += 11; };
    auto values = corpus_benchmark::measure<Clock>(3,21,launch,sync);
    assert(launches == 25 && syncs == 25);
    assert(values.size() == 21);
    for (auto value : values) assert(value == 18);
    for (auto counts : {std::pair{-1,3},std::pair{0,0},std::pair{0,2}}) {
        bool rejected = false;
        try { corpus_benchmark::measure<Clock>(counts.first,counts.second,launch,sync); }
        catch (const std::invalid_argument&) { rejected = true; }
        assert(rejected && launches == 25 && syncs == 25);
    }
}
''')
    executable = tmp_path / "sampling"
    subprocess.run([compiler,"-std=c++17","-I",str(ROOT / "corpus/kernels/include"),
                    str(source),"-o",str(executable)],check=True,capture_output=True,text=True)
    subprocess.run([str(executable)],check=True)
