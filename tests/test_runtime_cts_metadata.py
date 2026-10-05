"""Metadata CLI and exec propagation checks, without a GPU."""
from pathlib import Path
import shutil
import subprocess

import pytest

ROOT = Path(__file__).resolve().parents[1] / "corpus/runtime-cts"


@pytest.fixture(scope="module", params=[("aql", 120500), ("pm4", 120500), ("aql", 120001)])
def metadata_programs(tmp_path_factory, request):
    compiler = shutil.which("c++")
    if compiler is None:
        pytest.skip("C++ compiler required for CLI checks")
    suite, version = request.param
    target = "gfx1250" if version == 120500 else "gfx1201"
    directory = tmp_path_factory.mktemp(f"metadata-{suite}-{target}")
    worker = directory / "worker.cc"
    worker.write_text('''#include <cstdio>
#include "support/kfd.h"
#include "support/process_group.h"
int main(int argc, char** argv) {
  cts::Start(argc, argv, "worker", true);
  cts::WorkerPhase('R');
  cts::WorkerPhase('D');
  std::printf("worker_metadata=%d\\n", cts::kGfx125 && cts::AqlMetadataEnabled());
}
''')
    parent = directory / "multiprocess"
    for source, binary in [(ROOT / suite / "multiprocess.cc", parent),
                           (worker, directory / f"{suite}_queue_flood_{target}")]:
        subprocess.run([
            compiler, "-std=c++17", "-pthread", f"-DCTS_GFX_VERSION={version}",
            f'-DCTS_TARGET_NAME="{target}"', "-I", str(ROOT), "-I", str(ROOT / "common"),
            str(source), str(ROOT / "common/test.cc"), "-o", str(binary),
        ], check=True, capture_output=True, text=True)
    return parent, version, suite


@pytest.mark.parametrize("mode", [None, "on", "off", "invalid", "missing"])
def test_metadata_cli_and_worker_propagation(metadata_programs, mode):
    parent, version, suite = metadata_programs
    args = [str(parent), "--queues", "1", "--iterations", "1"]
    if suite == "pm4":
        args += ["--mode", "pm4"]
    if mode is not None:
        args.append("--aql-metadata")
        if mode != "missing":
            args.append(mode)
    result = subprocess.run(args, capture_output=True, text=True, timeout=10)
    if mode == "missing":
        assert result.returncode == 1
        assert "usage:" in result.stderr
    elif mode is not None and version != 120500:
        assert result.returncode == 1
        assert "only supported on gfx12.5" in result.stderr
    elif mode == "invalid":
        assert result.returncode == 1
        assert "expects off or on" in result.stderr
    else:
        assert result.returncode == 0, result.stdout + result.stderr
        enabled = version == 120500 and mode == "on"
        assert f"worker_metadata={int(enabled)}" in result.stdout
        assert "PASS multiprocess" in result.stdout
