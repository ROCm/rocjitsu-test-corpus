"""CPU checks of public MEC/SDMA layouts; no GPU or ROCm compiler required.

Golden dwords check generation-specific fields and retain the verified gfx12 streams.
"""
from pathlib import Path
import shutil
import subprocess

import pytest

ROOT = Path(__file__).resolve().parents[1] / "corpus/runtime-cts"


@pytest.mark.parametrize("version, profile", [
    (90000, "gfx9"), (90402, "gfx9"), (110000, "gfx11"),
    (120001, "gfx11"), (120500, "gfx125"),
])
def test_pm4_and_sdma_packet_layouts(tmp_path, version, profile):
    compiler = shutil.which("c++")
    if compiler is None:
        pytest.skip("C++ compiler required for packet encoding checks")
    source = tmp_path / "packets.cc"
    source.write_text(r'''
#include <cstdio>
#include "pm4.h"
#include "support/sdma.h"
using namespace cts;
void Print(const std::vector<uint32_t>& words) {
  for (auto word : words) std::printf("%08x ", word);
  std::puts("");
}
int main() {
  constexpr uint64_t address = 0x1234567890ull;
  Pm4 barrier, release, write, wait, wait64, dma, atomic, cas32, cas64;
  barrier.Barrier(); Print(barrier.words);
  release.Release64(address, 0xfedcba9876543210ull); Print(release.words);
  write.Write(address, 42); Print(write.words);
  wait.Wait(address, 42); Print(wait.words);
  wait64.Wait64(address, 0x123456789ull); Print(wait64.words);
  dma.DmaCopy(address, address + 128, 65); Print(dma.words);
  atomic.Add(address, 0x123456789ull, true); Print(atomic.words);
  Sdma sdma(kGfxVersion);
  sdma.Acquire(); Print(sdma.words); sdma.words.clear();
  sdma.Copy(address, address + 128, 65); Print(sdma.words); sdma.words.clear();
  sdma.Wait(address, 42); Print(sdma.words); sdma.words.clear();
  sdma.Finish(address, 42); Print(sdma.words);
  cas32.Atomic(8, address, 0xabcdef01, false, 0x76543210); Print(cas32.words);
  cas64.Atomic(8, address, 0xabcdef0198765432ull, true, 0xfedcba9876543210ull);
  Print(cas64.words);
}
''')
    binary = tmp_path / "packets"
    subprocess.run([
        compiler, "-std=c++17", "-pthread", f"-DCTS_GFX_VERSION={version}",
        "-I", str(ROOT), "-I", str(ROOT / "common"), "-I", str(ROOT / "pm4"),
        "-I", str(ROOT / "pm4/support" / profile), str(source),
        str(ROOT / "common/test.cc"), "-o", str(binary),
    ], check=True, capture_output=True, text=True)
    lines = subprocess.check_output([str(binary)], text=True).splitlines()
    packets = [[int(word, 16) for word in line.split()] for line in lines]
    acquire = {
        "gfx9": [0xc0055800, 0x28c40000, 0xffffffff, 0xffffff, 0, 0, 10],
        "gfx11": [0xc0065800, 0, 0xffffffff, 0xff, 0, 0, 10, 0xc3b3],
        "gfx125": [0xc0065800, 0, 0xffffffff, 0, 0, 0, 4, 0xc191],
    }[profile]
    release = {"gfx9": 0x28514, "gfx11": 0x70c514, "gfx125": 0x1601514}[profile]
    scoped = profile == "gfx125"
    assert packets[0] == [0xc0004600, 0x407, *acquire]
    assert packets[1] == [0xc0064902, release, 0x43000000, 0x34567890, 0x12,
                          0x76543210, 0xfedcba98, 0]
    assert packets[2] == [0xc0033700, 0x103200 if scoped else 0x100200, 0x34567890, 0x12, 42]
    assert packets[3] == [0xc0053c00, 0x13, 0x34567890, 0x12, 42, 0xffffffff,
                          0x80000004 if scoped else 4]
    assert packets[4] == [0xc0079300, 0x15, 0x34567890, 0x12, 0x23456789, 1,
                          0xffffffff, 0xffffffff, 4]
    assert packets[5] == [0xc0055000, 0x80000000, 0x34567890, 0x12, 0x34567910, 0x12, 65]
    assert packets[6] == [0xc0071e00, 0x2f, 0x34567890, 0x12, 0x23456789, 1, 0, 0, 0]
    sdma_acquire = [] if profile == "gfx9" else (
        [0x111, 0, 0, 0x4010, 0, 0] if scoped else [0x111, 0, 0xc3c00000, 0, 0])
    sdma_release = [] if profile == "gfx9" else (
        [0x111, 0, 0, 0x8010, 0, 0] if scoped else [0x111, 0, 0x80400000, 0, 0])
    fence = {90000: 5, 90402: 5, 110000: 0x30005, 120001: 0x130005, 120500: 0x3130005}[version]
    assert packets[7] == sdma_acquire
    assert packets[8] == [1, 64, 0xc0c0000 if scoped else 0, 0x34567890, 0x12, 0x34567910, 0x12]
    assert packets[9] == [0xb0000008, 0x34567890, 0x12, 42, 0xffffffff,
                          0x3fff0004 if scoped else 0x0fff0004]
    finish = [*sdma_release, fence, 0x34567890, 0x12, 42]
    assert packets[10] == finish + [0] * (32 - len(finish))

    assert packets[11] == [0xc0071e00, 8, 0x34567890, 0x12, 0xabcdef01, 0,
                           0x76543210, 0, 0]
    assert packets[12] == [0xc0071e00, 0x28, 0x34567890, 0x12, 0x98765432, 0xabcdef01,
                           0x76543210, 0xfedcba98, 0]
