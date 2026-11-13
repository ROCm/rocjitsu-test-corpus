# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Host-only full Tensile provider checks; no device runtime imports."""

import importlib.util
import hashlib
import json
import os
import sys
from pathlib import Path
import pytest
import subprocess


def test_host_reference_and_measurement_boundaries(tmp_path):
    assert (ROOT / "host.hpp").is_file(), "independent host reference is missing"
    source = tmp_path / "host.cpp"
    source.write_text(r"""
#include "host.hpp"
#include <cassert>
#include <functional>
#include <limits>
int main() {
  using namespace full_tensile;
  // Discriminating small tensors: independent brute-force storage oracle.
  for(bool tensor : {false, true}) for(int batches : {1, 3}) {
    Host h(15, 17, 7, tensor ? 3 : 1, batches, 1, tensor);
    std::vector<float> out(h.c.size());
    for(int b=0;b<batches;b++) for(int j=0;j<h.n;j++) for(int i=0;i<h.m;i++) {
      const size_t dindex=i+size_t(h.m)*(j+size_t(h.n)*b);
      double sum=h.c[dindex];
      for(int t=0;t<h.l;t++) for(int q=0;q<h.k;q++) {
        const size_t ai=tensor ? q+size_t(h.k)*i+size_t(h.k)*h.m*(t+size_t(h.l)*b)
                               : i+size_t(h.m)*q+size_t(h.m)*h.k*b;
        const size_t bi=q+size_t(h.k)*j+size_t(h.k)*h.n*(t+size_t(h.l)*b);
        sum+=double(h.a[ai])*h.b[bi];
      }
      out[dindex]=float(sum);
    }
    h.validate(out);
    for(auto bad : {0.f, std::numeric_limits<float>::quiet_NaN(), out.back()+1}) {
      auto copy=out; copy.back()=bad;
      bool rejected=false; try { h.validate(copy); } catch(const std::exception&) {rejected=true;}
      assert(rejected);
    }
    auto wrong=out;
    for(size_t z=0;z<wrong.size();z++) wrong[z]-=h.c[z]; // missing beta helper
    bool rejected=false; try {h.validate(wrong);} catch(const std::exception&) {rejected=true;}
    assert(rejected);
  }
  std::string events;
  long long tick=0;
  auto times=measure(1,2,[&]{events+='R';},[&]{events+='L';},[&]{events+='V';},[&]{events+='T';return ++tick;});
  assert(events=="RLVRTLTVRTLTV"); // reset and validation outside T/L/T
  assert((times==std::vector<long long>{1,1}));
}
""")
    binary = tmp_path / "host"
    subprocess.run(
        [
            "c++",
            "-std=c++17",
            "-O2",
            "-Wall",
            "-Wextra",
            "-Werror",
            "-I",
            str(ROOT),
            str(source),
            "-o",
            str(binary),
        ],
        check=True,
    )
    subprocess.run([str(binary)], check=True)


ROOT = Path(__file__).resolve().parents[1] / "corpus/benchmarks/full_tensile"


def module(name):
    spec = importlib.util.spec_from_file_location(
        "full_tensile_" + name, ROOT / (name + ".py")
    )
    value = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(value)
    return value


def test_pinned_source_and_fixed_derivation(tmp_path):
    prep = module("prepare")
    assert hasattr(prep, "selection"), "fixed solution derivation is missing"
    for variant in prep.CASES:
        selected, sizes, upstream = prep.selection(variant, "gfx1100")
        assert selected["WavefrontSize"] == 64
        assert selected["MatrixInstruction"] == []
        assert selected["DepthU"] == 8
        assert selected["VectorWidth"] == 1
        assert selected["GlobalSplitU"] == (3 if variant == "splitk" else 1)
        assert (ROOT / "upstream" / upstream).is_file()
        if variant == "tensor":
            assert sizes == [2048, 2048, 16, 64]
            assert selected["ProblemType"]["IndexAssignmentsA"] == [2, 0, 3]
        if variant == "pointer":
            assert sizes == [1024, 1024, 8, 1024]
            assert selected["ProblemType"]["StridedBatched"] is False
    with pytest.raises(ValueError, match="source"):
        prep.verify_source(tmp_path)


def test_artifact_inventory_rejects_corruption(tmp_path):
    prep = module("prepare")
    assert hasattr(prep, "validate_artifacts"), "artifact integrity gate is missing"
    cell = tmp_path / "gfx1100/valu"
    cell.mkdir(parents=True)
    for filename in ("TensileLibrary.dat", "main.co", "selection.yaml"):
        (cell / filename).write_bytes(filename.encode())
    files = {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in cell.iterdir()}
    meta = dict(
        source_revision=prep.REVISION,
        target="gfx1100",
        parameters=prep.CASES["valu"],
        files=files,
    )
    (cell / "artifacts.json").write_text(json.dumps(meta))
    assert prep.validate_artifacts(cell, prep.CASES["valu"], "gfx1100") == meta
    for name in ("main.co", "selection.yaml"):
        original = (cell / name).read_bytes()
        (cell / name).write_bytes(b"corrupted")
        with pytest.raises(ValueError, match="hash"):
            prep.validate_artifacts(cell, prep.CASES["valu"], "gfx1100")
        (cell / name).write_bytes(original)
    (cell / "extra.hsaco").write_bytes(b"extra")
    with pytest.raises(ValueError, match="inventory"):
        prep.validate_artifacts(cell, prep.CASES["valu"], "gfx1100")
    (cell / "extra.hsaco").unlink()
    meta["files"]["../escape.co"] = "bad"
    (cell / "artifacts.json").write_text(json.dumps(meta))
    with pytest.raises(ValueError):
        prep.validate_artifacts(cell, prep.CASES["valu"], "gfx1100")


def test_preparation_cli_is_offline():
    result = subprocess.run(
        [sys.executable, str(ROOT / "prepare.py"), "--help"],
        text=True,
        capture_output=True,
    )
    assert result.returncode == 0
    for option in ("--source-root", "--sdk-root", "--output", "--target", "--variant"):
        assert option in result.stdout, "offline preparation CLI is missing " + option


@pytest.mark.parametrize(
    "bad",
    [None, "unchecked", "missing_helper", "boolean_time", "zero_time", "wrong_count"],
)
def test_workload_protocol_and_native_rejection(tmp_path, bad):
    assert (ROOT / "workload.py").is_file(), "full Tensile workload protocol is missing"
    prep = module("prepare")
    params = prep.CASES["splitk"]
    cell = tmp_path / "artifacts/gfx1100/splitk"
    cell.mkdir(parents=True)
    for name in ("TensileLibrary.dat", "main.co", "helper.hsaco", "selection.yaml"):
        (cell / name).write_bytes(name.encode())
    meta = dict(
        source_revision=prep.REVISION,
        target="gfx1100",
        parameters=params,
        files={
            p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in cell.iterdir()
        },
        upstream_file=prep.UPSTREAM["splitk"],
        upstream_sha256="fixture",
    )
    (cell / "artifacts.json").write_text(json.dumps(meta))
    native = dict(
        correctness="passed",
        invocations=2,
        kernel_name="fixture",
        solution_index=0,
        input_pattern="signed_integer_periodic_v1",
        timings_ns=[101, 103],
    )
    if bad == "unchecked":
        native["correctness"] = "not_checked"
    if bad == "missing_helper":
        native["invocations"] = 1
    if bad == "boolean_time":
        native["timings_ns"][0] = True
    if bad == "zero_time":
        native["timings_ns"][0] = 0
    if bad == "wrong_count":
        native["timings_ns"] = [101]
    # This executable is a protocol fixture, not simulated device evidence.
    fixture = tmp_path / "native-fixture"
    fixture.write_text(
        "#!"
        + sys.executable
        + "\nimport json,sys\nfrom pathlib import Path\n"
        + "assert sys.argv[2:4]==['splitk','gfx1100']\n"
        + "assert sys.argv[4:12]==['3072','2048','1536','1','1','1','0','2']\n"
        + "Path(sys.argv[-1]).write_text("
        + repr(json.dumps(native))
        + ")\n"
    )
    fixture.chmod(0o755)
    output = tmp_path / "result.json"
    env = dict(
        os.environ,
        FULL_TENSILE_ARTIFACTS=str(tmp_path / "artifacts"),
        FULL_TENSILE_RUNNER=str(fixture),
    )
    result = subprocess.run(
        [
            sys.executable,
            str(ROOT / "workload.py"),
            "--workload",
            "full_tensile",
            "--params",
            json.dumps(params),
            "--case",
            "test.splitk",
            "--target",
            "gfx1100",
            "--warmups",
            "0",
            "--samples",
            "2",
            "--output",
            str(output),
        ],
        env=env,
        text=True,
        capture_output=True,
    )
    if bad:
        assert result.returncode != 0
        assert not output.exists()
    else:
        assert result.returncode == 0, result.stderr
        payload = json.loads(output.read_text())
        assert set(payload) == {
            "schema",
            "case",
            "target",
            "provider",
            "parameters",
            "timings_ns",
        }
        assert payload["schema"] == "rocjitsu.benchmark.workload.v1"
        assert payload["provider"] == "full_tensile"
        assert payload["case"] == "test.splitk"
        assert payload["timings_ns"] == [101, 103]
        assert payload["parameters"]["invocation_count"] == 2
        assert payload["parameters"]["source_revision"] == prep.REVISION


def test_native_measurement_rejects_bad_final_output(tmp_path):
    # Compile the installed callback block and its actual measure() call. Only
    # the HIP transport and device launch are replaced, so disconnecting native
    # validation/reset is observable without a GPU, SDK or second oracle.
    native = (ROOT / "runner.cpp").read_text()
    start = "        std::vector<float> output(host.c.size());"
    end = "        std::ofstream out(argv[12]);"
    assert native.count(start) == native.count(end) == 1
    callbacks = native.split(start, 1)[1].split(end, 1)[0]
    source = tmp_path / "native_measurement.cpp"
    source.write_text(
        r"""
#include "host.hpp"
#include <cassert>
#include <chrono>
#include <cstring>
#include <iostream>

constexpr int hipMemcpyDeviceToHost = 0;
int hipMemsetAsync(void* data, int value, size_t bytes, void*) {
    std::memset(data, value, bytes);
    return 0;
}
int hipDeviceSynchronize() { return 0; }
int hipMemcpy(void* destination, const void* source, size_t bytes, int) {
    std::memcpy(destination, source, bytes);
    return 0;
}
void check(int status) { assert(status == 0); }
struct Adapter {
    const full_tensile::Host& host;
    std::vector<float>& device;
    int mode, calls = 0;
    int launchKernels(const std::vector<int>&) {
        ++calls;
        // Warmup succeeds before the faulty final sample. The expected values
        // are a fixture for device transport, not a replacement Host oracle.
        if(calls == 1 || mode == 0)
            std::copy(host.expected.begin(), host.expected.end(), device.begin());
        else if(mode == 2)
            std::copy(host.expected.begin(), host.expected.end()-1, device.begin());
        else if(mode == 3) {
            std::copy(host.expected.begin(), host.expected.end(), device.begin());
            device.front() += 1.f;
        }
        return 0;
    }
};
void run(int mode) {
    full_tensile::Host host(15, 17, 7, 1, 1, 1, false);
    std::vector<float> device(host.expected.size());
    struct { void* data; } dd{device.data()};
    const size_t bytes = device.size()*sizeof(float);
    Adapter adapter{host, device, mode};
    const std::vector<int> kernels{1};
    const int warmups = 1, samples = mode == 0 ? 2 : 1;
    bool rejected = false;
    try {
        std::vector<float> output(host.c.size());
"""
        + callbacks
        + r"""
        assert(timings.size() == size_t(samples));
    } catch(const std::runtime_error& error) {
        assert(std::string(error.what()).find("full output reference mismatch") != std::string::npos);
        rejected = true;
    }
    assert(adapter.calls == warmups + samples);
    assert(rejected == (mode != 0));
}
int main() {
    run(0); // unmodified callback path: warmup and both samples succeed
    run(1); // final no-op must not reuse the previous successful result
    run(2); // final partial write must not reuse the last previous element
    run(3); // finite wrong output must reach Host::validate, not just a NaN gate
}
"""
    )
    binary = tmp_path / "native_measurement"
    subprocess.run(
        ["c++", "-std=c++17", "-I", str(ROOT), str(source), "-o", str(binary)],
        check=True,
    )
    subprocess.run([str(binary)], check=True, capture_output=True, text=True)


def test_native_host_only_build(tmp_path):
    source = os.environ.get("FULL_TENSILE_TEST_SOURCE")
    sdk = os.environ.get("FULL_TENSILE_TEST_SDK")
    if not source or not sdk:
        pytest.skip("set FULL_TENSILE_TEST_SOURCE/SDK for offline native compilation")
    assert (
        ROOT / "CMakeLists.txt"
    ).is_file(), "native full Tensile adapter build is missing"
    # SDK HIP CMake invokes amdgpu-arch unless these are explicit BEFORE discovery.
    cmake = (ROOT / "CMakeLists.txt").read_text()
    assert 'set(GPU_TARGETS "gfx1100;gfx1201")' in cmake
    assert cmake.index("set(GPU_TARGETS") < cmake.index("find_package(hip")
    assert 'set(GPU_BUILD_TARGETS "gfx1100;gfx1201")' in cmake
    env = dict(os.environ, ROCM_PATH=sdk, HIP_PATH=sdk)
    env["LD_LIBRARY_PATH"] = (
        sdk + "/lib:" + sdk + "/lib/llvm/lib:" + env.get("LD_LIBRARY_PATH", "")
    )
    build = tmp_path / "build"
    subprocess.run(
        [
            "cmake",
            "-S",
            str(ROOT),
            "-B",
            str(build),
            "-DCMAKE_BUILD_TYPE=Release",
            "-DTENSILE_SOURCE=" + source,
            "-DCMAKE_PREFIX_PATH=" + sdk,
            "-DCMAKE_CXX_COMPILER=" + sdk + "/bin/amdclang++",
        ],
        env=env,
        check=True,
    )
    subprocess.run(
        ["cmake", "--build", str(build), "--parallel", "4"], env=env, check=True
    )
    assert (build / "full_tensile_runner").is_file()
    # Deliberately do NOT execute a HIP-linked binary or enumerate devices.


def test_fixed_fp32_selection():
    assert (ROOT / "prepare.py").is_file(), "full Tensile preparation is missing"
    prep = module("prepare")
    assert prep.REVISION == "1c63e26254a357007ce2d963266085a30b39515b"
    assert set(prep.CASES) == {"valu", "tensor", "splitk", "pointer"}
    expected = {
        "valu": {
            "variant": "valu",
            "dtype": "fp32",
            "m": 3072,
            "n": 2048,
            "k": 1024,
            "beta": 0,
        },
        "tensor": {
            "variant": "tensor",
            "dtype": "fp32",
            "i": 2048,
            "j": 2048,
            "k": 16,
            "l": 64,
            "beta": 1,
        },
        "splitk": {
            "variant": "splitk",
            "dtype": "fp32",
            "m": 3072,
            "n": 2048,
            "k": 1536,
            "gsu": 3,
            "beta": 1,
        },
        "pointer": {
            "variant": "pointer",
            "dtype": "fp32",
            "m": 1024,
            "n": 1024,
            "k": 1024,
            "batch": 8,
            "beta": 1,
        },
    }
    for variant, params in expected.items():
        assert prep.CASES[variant] == params
        assert prep.validate_parameters(params, "gfx1100") == variant
        assert prep.validate_parameters(params, "gfx1201") == variant
        for invalid in [
            dict(params, dtype="fp16"),
            dict(params, k=1),
            dict(params, extra=1),
        ]:
            with pytest.raises(ValueError):
                prep.validate_parameters(invalid, "gfx1100")
        with pytest.raises(ValueError):
            prep.validate_parameters(params, "gfx950")
