"""Exercise worker rendezvous, retained lifetimes and bounded cleanup without a GPU."""

import os
from pathlib import Path
import shutil
import subprocess
import sys

import pytest

ROOT = Path(__file__).resolve().parents[1] / "corpus/runtime-cts"


@pytest.fixture(scope="module")
def supervisor(tmp_path_factory):
    compiler = shutil.which("c++")
    if compiler is None:
        pytest.skip("C++ compiler required")
    directory = tmp_path_factory.mktemp("process-group")
    parent = directory / "multiprocess"
    subprocess.run([
        compiler, "-std=c++17", "-pthread", "-DCTS_GFX_VERSION=120001",
        '-DCTS_TARGET_NAME="gfx1201"', "-I", str(ROOT), "-I", str(ROOT / "common"),
        str(ROOT / "aql/multiprocess.cc"), str(ROOT / "common/test.cc"),
        "-o", str(parent),
    ], check=True, capture_output=True, text=True)
    worker = directory / "aql_queue_flood_gfx1201"
    worker.write_text(f"#!{sys.executable}\n" + r'''
import os
from pathlib import Path
import socket
import time

directory = Path(os.environ["WORKER_TEST_DIRECTORY"])
scenario = os.environ["WORKER_TEST_SCENARIO"]
try:
    fd = os.open(directory / "first", os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
    os.close(fd)
    index = 0
except FileExistsError:
    index = 1
log = os.open(directory / "events", os.O_WRONLY | os.O_CREAT | os.O_APPEND, 0o600)
def event(phase):
    os.write(log, f"{index} {os.getpid()} {phase}\n".encode())
event("CREATED")
channel = socket.socket(fileno=int(os.environ["CTS_WORKER_CHANNEL"]))
if scenario == "skip" or (scenario == "mixed-skip" and index == 1):
    raise SystemExit(77)
if scenario == "fail-ready" and index == 1:
    raise SystemExit(23)
if scenario == "timeout-ready" and index == 1:
    time.sleep(30)
if index == 1:
    time.sleep(0.1)
event("READY")
channel.sendall(b"R")
assert channel.recv(1) == b"R"
event("STARTED")
if scenario == "fail-done" and index == 1:
    raise SystemExit(24)
if scenario == "timeout-done" and index == 1:
    time.sleep(30)
if index == 1:
    time.sleep(0.1)
event("DONE")
channel.sendall(b"D")
assert channel.recv(1) == b"D"
event("RELEASED")
if scenario == "timeout-exit" and index == 1:
    time.sleep(30)
if scenario == "late-skip" and index == 1:
    raise SystemExit(77)
''')
    worker.chmod(0o755)
    return parent


@pytest.mark.parametrize("scenario,code", [
    ("normal", 0), ("skip", 77), ("mixed-skip", 1), ("late-skip", 1),
    ("fail-ready", 1), ("fail-done", 1), ("timeout-ready", 1),
    ("timeout-done", 1), ("timeout-exit", 1),
])
def test_rendezvous_and_cleanup(supervisor, tmp_path, scenario, code):
    result = subprocess.run([
        str(supervisor), "--queues", "2", "--iterations", "1", "--timeout", "1",
    ], env={**os.environ, "WORKER_TEST_DIRECTORY": str(tmp_path),
            "WORKER_TEST_SCENARIO": scenario}, capture_output=True, text=True, timeout=6)
    assert result.returncode == code, result.stdout + result.stderr
    events = [line.split() for line in (tmp_path / "events").read_text().splitlines()]
    pids = {int(row[1]) for row in events}
    assert len(pids) == 2
    # A terminated but unreaped zombie still has a proc entry.
    assert all(not Path(f"/proc/{pid}").exists() for pid in pids)
    if scenario == "normal":
        phases = [row[2] for row in events]
        assert max(i for i, phase in enumerate(phases) if phase == "READY") < phases.index("STARTED")
        assert max(i for i, phase in enumerate(phases) if phase == "DONE") < phases.index("RELEASED")
        assert phases.count("RELEASED") == 2
    elif code == 1:
        assert "multiprocess worker or rendezvous failed" in result.stderr
