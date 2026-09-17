"""Exercise native timing and runtime failures without a GPU or ROCm install."""

import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import pytest

ROOT = Path(__file__).resolve().parents[1]


pytestmark = pytest.mark.skipif(
    not shutil.which("c++"), reason="requires a host C++ compiler"
)


def test_initialization_warmup_and_synchronization_boundaries():
    source = r"""
#include "benchmark_sampling.hpp"
#include <cassert>
struct Clock {
using time_point = std::chrono::time_point<Clock, std::chrono::nanoseconds>;
static inline int64_t elapsed = 0;
static time_point now() { return time_point(std::chrono::nanoseconds(elapsed)); }
};
int main() {
int launches = 0, synchronizations = 0;
auto timings = corpus_benchmark::measure<Clock>(2, 3, [&] {
    ++launches;
    Clock::elapsed += launches == 1 ? 10000 : launches <= 3 ? 1000 : 5;
}, [&] { ++synchronizations; Clock::elapsed += 2; });
assert((timings == std::vector<int64_t>{7, 7, 7}));
assert(launches == 6 && synchronizations == 6);
try { corpus_benchmark::measure(-1, 3, []{}, []{}); return 1; }
catch (const std::invalid_argument&) {}
try { corpus_benchmark::measure(1, 2, []{}, []{}); return 2; }
catch (const std::invalid_argument&) {}
}
"""
    with tempfile.TemporaryDirectory() as temporary:
        root = Path(temporary)
        path = root / "sampling.cpp"
        path.write_text(source)
        subprocess.run(
            [
                "c++",
                "-std=c++17",
                "-I",
                str(ROOT / "corpus/kernels/include"),
                str(path),
                "-o",
                str(root / "sampling"),
            ],
            check=True,
            capture_output=True,
        )
        subprocess.run([str(root / "sampling")], check=True, capture_output=True)


def test_native_result_and_hip_errors():
    with tempfile.TemporaryDirectory() as temporary:
        root = Path(temporary)
        (root / "hip").mkdir()
        (root / "hip/hip_runtime.h").write_text(r"""
#pragma once
#include <cstdlib>
using hipError_t = int;
constexpr int hipSuccess = 0;
struct hipDeviceProp_t { const char* gcnArchName = "gfx950:sramecc+"; };
inline int hipGetDevice(int* device) { *device = 0; return 0; }
inline int hipGetDeviceProperties(hipDeviceProp_t*, int) { return 0; }
inline const char* hipGetErrorString(int) { return "injected HIP failure"; }
inline int hipGetLastError() { return std::getenv("FAIL_LAUNCH") ? 1 : 0; }
inline int hipDeviceSynchronize() { return std::getenv("FAIL_SYNC") ? 1 : 0; }
""")
        path = root / "native.cpp"
        path.write_text(r"""
#include "benchmark.hpp"
#include <array>
#include <cassert>
int main(int argc, char** argv) try {
auto options = corpus_benchmark::parse(argc, argv);
corpus_benchmark::check_target(options);
corpus_benchmark::check_shape(256,256,256,256,256,128,128);
corpus_benchmark::check_shape(64,64,32,64,64,32,32);
for (auto shape : {std::array<int,3>{250,256,256}, {256,250,256},
                   {256,256,129}, {256,256,64}, {0,256,256},
                   {65536,65536,256}, {65536,256,65536},
                   {256,65536,65536}}) {
    bool rejected = false;
    try { corpus_benchmark::check_shape(shape[0],shape[1],shape[2],256,256,128,128); }
    catch (const std::invalid_argument&) { rejected = true; }
    assert(rejected);
}
// No numerical result, reference, or correctness callback is required.
corpus_benchmark::run(options, 256,256,256, []{});
return 0;
} catch(const std::exception& error) { std::cerr << error.what(); return 1; }
""")
        executable = root / "native"
        subprocess.run(
            [
                "c++",
                "-std=c++17",
                "-I",
                str(root),
                "-I",
                str(ROOT / "corpus/kernels/include"),
                str(path),
                "-o",
                str(executable),
            ],
            check=True,
            capture_output=True,
        )
        output = root / "result.json"
        argv = [
            str(executable),
            "--benchmark",
            "--case",
            "native.test",
            "--target",
            "gfx950",
            "--samples",
            "3",
            "--warmups",
            "0",
            "--output",
            str(output),
        ]
        subprocess.run(argv, check=True, capture_output=True)
        result = json.loads(output.read_text())
        assert len(result["timings_ns"]) == 3
        assert result["parameters"]["m"] == 256
        for failure in ("FAIL_LAUNCH", "FAIL_SYNC"):
            output.unlink(missing_ok=True)
            process = subprocess.run(
                argv, env={failure: "1"}, capture_output=True, text=True
            )
            assert process.returncode == 1
            assert "injected HIP failure" in process.stderr
            assert not output.exists()
        argv[argv.index("gfx950")] = "gfx1250"
        process = subprocess.run(argv, capture_output=True, text=True)
        assert process.returncode == 1
        assert "does not match" in process.stderr
