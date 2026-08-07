#!/usr/bin/env python3
"""Emit the RDNA3 scalar-register causality probe as a unified diff.

The diff is built in memory from the pristine blobs in git rather than by
editing the worktree, because the worktree holds another experiment's
uncommitted changes.

Usage: ./make_rdna3_sgpr_patch.py
"""

from __future__ import annotations

import difflib
import subprocess
from pathlib import Path

WORKTREE = Path.home() / "rocjitsu_dev/wt/rocm-systems/llama-root-cause-trace"
BASELINE = "63a89f8f5cf0f25b98a76057bc00e4a98f88425d"

OPERAND = (
    "emulation/rocjitsu/lib/rocjitsu/src/rocjitsu/isa/arch/amdgpu/rdna3/"
    "operand.cpp"
)
CONFIG = "emulation/rocjitsu/configs/gfx1100_w7900.json"

# On GFX10 and later, encodings 102 and 103 are ordinary s102/s103, so
# each branch below is deleted and the following "ev <= 105" case reads
# and writes the register as it already does for 0-101.
EDITS = {
    OPERAND: [
        (
            """  if (ev == 102)
    return static_cast<uint32_t>(wf.scratch_base());
  if (ev == 103)
    return static_cast<uint32_t>(wf.scratch_base() >> 32);
  if (ev <= 105)
    return amdgpu::RegisterAccess(wf).read_sgpr""",
            """  if (ev <= 105)
    return amdgpu::RegisterAccess(wf).read_sgpr""",
        ),
        (
            """  if (ev == 102)
    return wf.scratch_base();
  if (ev <= 105) {""",
            """  if (ev <= 105) {""",
        ),
        (
            """  if (ev == 102) {
    uint64_t sb = wf.scratch_base();
    wf.set_scratch_base((sb & 0xFFFFFFFF00000000ULL) | val);
    return;
  }
  if (ev == 103) {
    uint64_t sb = wf.scratch_base();
    wf.set_scratch_base((sb & 0x00000000FFFFFFFFULL) | (static_cast<uint64_t>(val) << 32));
    return;
  }
  if (ev <= 105) {""",
            """  if (ev <= 105) {""",
        ),
        (
            """  if (ev == 102) {
    wf.set_scratch_base(val);
    return;
  }
  if (ev <= 105) {""",
            """  if (ev <= 105) {""",
        ),
    ],
    CONFIG: [
        (
            '{ "key": "sgprs_per_wf", "value": "104" }',
            '{ "key": "sgprs_per_wf", "value": "106" }',
        ),
    ],
}


def blob(path: str) -> str:
    return subprocess.run(
        ["git", "show", f"{BASELINE}:{path}"],
        cwd=WORKTREE,
        check=True,
        capture_output=True,
        text=True,
    ).stdout


def main() -> None:
    chunks: list[str] = []
    for path, edits in EDITS.items():
        before = blob(path)
        after = before
        for old, new in edits:
            if after.count(old) != 1:
                raise SystemExit(
                    f"{path}: expected exactly one match for:\n{old}"
                )
            after = after.replace(old, new)
        chunks.extend(
            difflib.unified_diff(
                before.splitlines(keepends=True),
                after.splitlines(keepends=True),
                fromfile=f"a/{path}",
                tofile=f"b/{path}",
                n=3,
            )
        )

    out = Path(__file__).resolve().parent / "probes/rdna3-scalar-registers.patch"
    out.write_text("".join(chunks), encoding="utf-8")
    print(out)


if __name__ == "__main__":
    main()
