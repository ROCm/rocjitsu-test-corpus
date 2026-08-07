#!/usr/bin/env python3
"""Render a GitHub-postable Markdown report from the llama triage groups."""

from __future__ import annotations

import json
import re
import shlex
from dataclasses import dataclass
from pathlib import Path

ROCM_SYSTEMS_REPO = "https://github.com/ROCm/rocm-systems"
ROCM_SYSTEMS_COMMIT = "63a89f8f5cf0f25b98a76057bc00e4a98f88425d"
CORPUS_REPO = "https://github.com/ROCm/rocjitsu-test-corpus"
CORPUS_COMMIT = "a6640a2139bf8e39e27125ad7e14c0b04746dedf"
MEMORY_FIX_PULL = f"{ROCM_SYSTEMS_REPO}/pull/9003"
ROCJITSU_PREFIX = "emulation/rocjitsu"

TARGETS = ("gfx942", "gfx950", "gfx1100", "gfx1201")
TARGET_CONFIGS = {
    "gfx942": "gfx942_cdna3.json",
    "gfx950": "gfx950_cdna4.json",
    "gfx1100": "gfx1100_w7900.json",
    "gfx1201": "gfx1201_r9700.json",
}
TARGET_DEVICES = {
    "gfx942": "AMD Instinct MI300A (CDNA3)",
    "gfx950": "AMD Radeon Graphics (CDNA4)",
    "gfx1100": "AMD Radeon Pro W7900 (RDNA3)",
    "gfx1201": "AMD Radeon AI PRO R9700 (RDNA4)",
}
CASE_COUNT_PER_TARGET = 535
INLINE_CASE_LIMIT = 6

ERROR_PATTERN = re.compile(r"\[[A-Z0-9_]+\] ERR = [0-9.]+ > [0-9.]+")
WARNING_PATTERN = re.compile(r"\[rj [a-z]+\] .*")
UBIQUITOUS_WARNING = "DRM ioctl rejected"


@dataclass(frozen=True)
class Group:
    """Reviewer-facing metadata for one refined failure group."""

    key: str
    title: str
    kind: str
    confidence: str
    root_cause: str
    evidence: tuple[str, ...]
    representative: tuple[str, str]


def source_link(path: str, anchor: str = "") -> str:
    blob = f"{ROCM_SYSTEMS_REPO}/blob/{ROCM_SYSTEMS_COMMIT}"
    return f"{blob}/{ROCJITSU_PREFIX}/{path}{anchor}"


GPU_MEMORY_LINK = source_link(
    "lib/rocjitsu/src/rocjitsu/vm/amdgpu/gpu_memory.h", "#L484-L511"
)
HWREG_RDNA4_LINK = source_link(
    "lib/rocjitsu/src/rocjitsu/vm/amdgpu/hwreg.cpp", "#L259-L282"
)
HWREG_GFX1250_LINK = source_link(
    "lib/rocjitsu/src/rocjitsu/vm/amdgpu/hwreg.cpp", "#L284-L312"
)

CDNA_SYMMETRY = (
    "gfx942 and gfx950 fail on exactly the same case strings, so the defect "
    "is in a shared CDNA path rather than in one target's model."
)
UNBACKED_ADDRESS = (
    "The simulator computes an operand address that no VMID page-table entry "
    "backs, then dereferences the GPU virtual address as a host pointer and "
    "takes SIGSEGV. The fallback explains how the process dies; it does not "
    "identify which earlier address computation produced the bad address."
)

GROUPS = (
    Group(
        key="gfx1201.matrix-crash-surface.MUL_MAT",
        title="gfx1201 `MUL_MAT` faults on an unbacked GPU address",
        kind="defect",
        confidence=(
            "Confirmed ROCjitsu crash; initiating address defect not "
            "localized"
        ),
        root_cause=(
            UNBACKED_ADDRESS
            + " The 44 cases span f16, bf16, f32, and quantized `type_a` "
            "values with no shared shape, which points at an address or "
            "descriptor computation ahead of the matmul kernel rather than "
            "at one kernel variant. The crash is deterministic under normal "
            "address-space randomization, but the representative case did "
            "pass once in a GDB session with randomization disabled, so the "
            "faulting address is sensitive to host memory layout."
        ),
        evidence=(
            f"Fault path: [`gpu_memory.h` VMID walk and passthrough "
            f"fallback]({GPU_MEMORY_LINK}).",
            "`debug/gfx1201-mul-mat-gdb-aslr.log` faults in "
            "`GpuMemory::read_mapped()`; the source address is absent from "
            "`/proc/<pid>/maps` while the destination is writable.",
            "`debug/gfx1201-mul-mat-repeat-status.tsv`: 20 consecutive "
            "command-line runs all exited 139 (SIGSEGV).",
            f"Not fixed by [rocm-systems#9003]({MEMORY_FIX_PULL}); all 44 "
            "cases still fault with that branch built.",
        ),
        representative=("gfx1201", "67a24d655c21"),
    ),
    Group(
        key="gfx1100.flash-attn.optimized-mma-wmma",
        title=(
            "gfx1100 `FLASH_ATTN_EXT` optimized WMMA path is wrong and can "
            "fault"
        ),
        kind="defect",
        confidence=(
            "Likely one ROCjitsu bug family; high confidence in the "
            "grouping, medium in the mechanism"
        ),
        root_cause=(
            "All 29 cases use head sizes of 64, 80, or 128, which llama.cpp "
            "maps to its optimized MMA/WMMA flash-attention kernels on "
            "RDNA3 rather than to the generic tile kernel that the D=72 "
            "group below uses. Eleven return "
            "reproducible numerical error and 18 escalate to SIGSEGV as "
            "mask, sink, and permute parameters change. A single incorrect "
            "index or accumulator computation in ROCjitsu's WMMA emulation "
            "explains that gradient better than 29 independent defects."
        ),
        evidence=(
            "`debug/gfx1100-flash-attn-gdb-aslr.log` faults in the same "
            f"[`GpuMemory::read_mapped()` path]({GPU_MEMORY_LINK}) as the "
            "gfx1201 matmul crashes.",
            "`RJ_FORCE_SCALAR=1` reproduces the numerical failures "
            "unchanged, so the SIMD executor fast path is not the cause.",
            "No `FLASH_ATTN_EXT` case fails on gfx942, gfx950, or gfx1201.",
        ),
        representative=("gfx1100", "74edc47aa39a"),
    ),
    Group(
        key="gfx1201.packed-workitem-y-surface",
        title="gfx1201 kernels indexed on `threadIdx.y` return sentinels",
        kind="defect",
        confidence="Likely bug family; mechanism is a hypothesis",
        root_cause=(
            "24 gfx1201 cases across `GATED_DELTA_NET`, `TOPK_MOE`, and "
            "fused `RMS_NORM_MUL_ROPE` fail while the same operators pass "
            "on gfx942, gfx950, and gfx1100. The failing kernels all index "
            "on `threadIdx.y`, and the reported errors are exact sentinels "
            "such as `[VIEW] ERR = 1.000000000` plus downstream corruption, "
            "which is what an incorrect packed work-item Y decode in the "
            "RDNA4 wave prologue would produce. Not source-localized."
        ),
        evidence=(
            "Target-exclusive: no other supported target fails these "
            "operators.",
            "`RJ_FORCE_SCALAR=1` reproduces all 24 failures unchanged.",
            "Artifacts under "
            "`hard/gfx1201/artifacts/llama/gfx1201/cases/`.",
        ),
        representative=("gfx1201", "6ec8af8002fa"),
    ),
    Group(
        key="gfx942.nvfp4-route",
        title="gfx942 NVFP4 matmul route returns uncorrelated results",
        kind="defect",
        confidence="Likely ROCjitsu defect; high",
        root_cause=(
            "All 14 cases are `MUL_MAT`, `MUL_MAT_ID`, or "
            "`MUL_MAT_VEC_FUSION` with `type_a=nvfp4` on gfx942, and they "
            "report `ERR` at or near 1.0, meaning the output is "
            "uncorrelated with the reference rather than slightly off. The "
            "identical cases pass on gfx950, gfx1100, and gfx1201, so the "
            "NVFP4 dequantization or scale handling on the CDNA3 route is "
            "wrong rather than accumulated rounding error."
        ),
        evidence=(
            "`MUL_MAT.9e9ba8458bfc` reports `ERR = 0.999999932` on gfx942 "
            "and passes on gfx950, gfx1100, and gfx1201.",
            "`RJ_FORCE_SCALAR=1` reproduces all 14 failures unchanged.",
        ),
        representative=("gfx942", "9e9ba8458bfc"),
    ),
    Group(
        key="gfx1201.matrix-crash-surface.MUL_MAT_ID",
        title="gfx1201 `MUL_MAT_ID` faults on an unbacked GPU address",
        kind="defect",
        confidence=(
            "Confirmed ROCjitsu crash; kept separate from `MUL_MAT` because "
            "the expert-indexed route differs"
        ),
        root_cause=(
            UNBACKED_ADDRESS
            + " These seven cases reach the fallback through the "
            "expert-indexed matmul route, which reads an extra index tensor "
            "before the operand addresses are formed."
        ),
        evidence=(
            f"Shared fault path with the `MUL_MAT` group: "
            f"[`gpu_memory.h`]({GPU_MEMORY_LINK}).",
            f"Not fixed by [rocm-systems#9003]({MEMORY_FIX_PULL}).",
        ),
        representative=("gfx1201", "297df3b5f822"),
    ),
    Group(
        key="cdna.mmf-f32",
        title="CDNA small f32 `MUL_MAT` returns wrong values",
        kind="defect",
        confidence="Likely ROCjitsu defect; medium-high",
        root_cause=(
            "Three `type_a=f32,type_b=f32` cases with `m=16` and `k=4` fail "
            "identically on gfx942 and gfx950 with errors far above "
            "tolerance. All three use a non-trivial `per=` permutation or "
            "broadcast `nr=`, so ROCjitsu's small-tile f32 matmul appears to "
            "mishandle permuted or broadcast source strides. " + CDNA_SYMMETRY
        ),
        evidence=(
            "`MUL_MAT.5a436936375c` reports `ERR = 1.644854360` against a "
            "0.0005 tolerance on both CDNA targets.",
            "`RJ_FORCE_SCALAR=1` reproduces all six failures unchanged.",
        ),
        representative=("gfx942", "5a436936375c"),
    ),
    Group(
        key="cdna.rocblas-surface",
        title="CDNA `OUT_PROD` and `SOLVE_TRI` return wrong values",
        kind="defect",
        confidence="Likely one ROCjitsu defect; medium",
        root_cause=(
            "One `OUT_PROD` and two `SOLVE_TRI` f32 cases fail identically "
            "on gfx942 and gfx950. Both operators dispatch through the "
            "library-backed BLAS surface rather than a hand-written ggml "
            "kernel, so a shared defect in that dispatch or in the kernels "
            "the library selects is the most economical explanation. The "
            "shared-surface attribution is a hypothesis; the numerical "
            "failures are reproducible facts. All three case strings also "
            "fail on gfx1201, where they crash instead, so this is not a "
            "CDNA-only defect: the same operand shapes break on three of "
            "the four targets with two different symptoms."
        ),
        evidence=(
            "Both operators pass on gfx1100.",
            "The same three case strings take SIGSEGV on gfx1201; see the "
            "`OUT_PROD` and `SOLVE_TRI` crash sections.",
            "`RJ_FORCE_SCALAR=1` reproduces all six failures unchanged.",
        ),
        representative=("gfx942", "7eb05239af23"),
    ),
    Group(
        key="cdna.rope-propagation",
        title="CDNA `ROPE` and `ROPE_SET_ROWS` return wrong values",
        kind="defect",
        confidence="Likely one ROCjitsu defect; medium",
        root_cause=(
            "One `ROPE` case with `mode=40` and two `ROPE_SET_ROWS` cases "
            "with `mode=8` and `mode=24` fail identically on gfx942 and "
            "gfx950. All three use non-default rotary modes, so the shared "
            "suspect is ROPE mode-flag handling and its propagation into the "
            "fused set-rows variant. " + CDNA_SYMMETRY
        ),
        evidence=(
            "Default-mode ROPE cases in the same inventory pass on both "
            "CDNA targets.",
            "`RJ_FORCE_SCALAR=1` reproduces all six failures unchanged.",
        ),
        representative=("gfx942", "637c25a9ca18"),
    ),
    Group(
        key="cdna.ssm-scan",
        title="CDNA `SSM_SCAN` returns wrong values",
        kind="defect",
        confidence="Likely one ROCjitsu defect; medium",
        root_cause=(
            "Three `SSM_SCAN` f32 cases fail identically on gfx942 and "
            "gfx950 while other `SSM_SCAN` shapes pass. The failing shapes "
            "differ in `d_state`, `head_dim`, and `n_group`, so the suspect "
            "is the state-tiling or cross-lane reduction the scan kernel "
            "uses for those shapes. " + CDNA_SYMMETRY
        ),
        evidence=(
            "Other `SSM_SCAN` shapes in the same inventory pass on both "
            "CDNA targets.",
            "`RJ_FORCE_SCALAR=1` reproduces all six failures unchanged.",
        ),
        representative=("gfx942", "83b46ddc1f72"),
    ),
    Group(
        key="gfx1100.flash-attn.generic-tile-d72",
        title="gfx1100 `FLASH_ATTN_EXT` D=72 generic tile path",
        kind="defect",
        confidence=(
            "Likely a ROCjitsu defect distinct from the WMMA group; medium"
        ),
        root_cause=(
            "Five cases with `hsk=hsv=72` fail on gfx1100: two return "
            "numerical error and three take SIGSEGV. Head size 72 is not a "
            "WMMA tile multiple, so these run the generic flash-attention "
            "tile kernel rather than the optimized kernel of the group "
            "above, which is why they are tracked separately. Five other "
            "`hsk=72` cases pass and differ only in `nr23`, `kv`, or "
            "`max_bias`, so the defect needs a particular combination of "
            "head size and tiling rather than head size alone."
        ),
        evidence=(
            f"The three crashes reach the same "
            f"[`GpuMemory::read_mapped()` fallback]({GPU_MEMORY_LINK}).",
            "Five of the ten `hsk=72` cases in the inventory fail, all with "
            "`nr23=[4,1]`, `kv=512`, and `max_bias=0`.",
            "No `FLASH_ATTN_EXT` case fails on gfx942, gfx950, or gfx1201.",
        ),
        representative=("gfx1100", "27a842fb2b89"),
    ),
    Group(
        key="gfx1201.wave-sched-mode-gap",
        title="RDNA4 HWREG ID 26 (`WAVE_SCHED_MODE`) is not modeled",
        kind="defect",
        confidence=(
            "Confirmed ISA modeling gap; causal link to these five crashes "
            "unproven"
        ),
        root_cause=(
            "ROCjitsu's RDNA4 hardware-register table has no entry for ID "
            "26, so `s_setreg_imm32_b32` against it is dropped with a "
            "warning, while the gfx1250 table models the same ID as "
            "`WAVE_SCHED_MODE`. These five `MUL_MAT` cases are the only "
            "corpus cases that emit the warning, and all five then take "
            "SIGSEGV. The missing table entry is a confirmed gap; that it "
            "causes these crashes is not established."
        ),
        evidence=(
            f"[RDNA4 table without ID 26]({HWREG_RDNA4_LINK}) versus "
            f"[gfx1250 table with `WAVE_SCHED_MODE`]({HWREG_GFX1250_LINK}).",
            "Case artifacts log `[rj warn] s_setreg_imm32_b32: unsupported "
            "hwreg=unknown id=26`; no other corpus case does.",
        ),
        representative=("gfx1201", "7bcc11c86355"),
    ),
    Group(
        key="cdna.xielu",
        title="CDNA `XIELU` returns wrong values",
        kind="defect",
        confidence="Likely ROCjitsu defect; medium-high",
        root_cause=(
            "Both f16 and f32 `XIELU` cases fail identically on gfx942 and "
            "gfx950 with error several orders above tolerance. XIELU is "
            "dominated by exponential and comparison-select math, so a "
            "transcendental or select-path defect on CDNA is the leading "
            "suspect. " + CDNA_SYMMETRY
        ),
        evidence=(
            "`XIELU.925694f8c916` reports `ERR = 8.626576297` against a "
            "1e-7 tolerance.",
            "`RJ_FORCE_SCALAR=1` reproduces all four failures unchanged, so "
            "the SIMD transcendental fast path is not the cause.",
            "Additional traces: `debug/gfx950-xielu-amd-log.log`, "
            "`debug/gfx950-xielu-clocked.log`.",
        ),
        representative=("gfx950", "925694f8c916"),
    ),
    Group(
        key="gfx1201.matrix-crash-surface.OUT_PROD",
        title="gfx1201 `OUT_PROD` faults on an unbacked GPU address",
        kind="defect",
        confidence="Confirmed ROCjitsu crash; separate operator route",
        root_cause=(
            UNBACKED_ADDRESS
            + " One of the two cases, `nr=[1,2]`, returns wrong values "
            "instead of crashing on gfx942 and gfx950, so the same operand "
            "shape is mishandled on three targets with two symptoms."
        ),
        evidence=(
            f"Shared fault path: [`gpu_memory.h`]({GPU_MEMORY_LINK}).",
            "`OUT_PROD(...,nr=[1,2],...)` appears in the CDNA BLAS-surface "
            "group above as a wrong-result failure.",
            f"Not fixed by [rocm-systems#9003]({MEMORY_FIX_PULL}).",
        ),
        representative=("gfx1201", "f35a3e5a1843"),
    ),
    Group(
        key="gfx1201.matrix-crash-surface.SOLVE_TRI",
        title="gfx1201 `SOLVE_TRI` faults on an unbacked GPU address",
        kind="defect",
        confidence="Confirmed ROCjitsu crash; separate operator route",
        root_cause=(
            UNBACKED_ADDRESS
            + " Both case strings return wrong values instead of crashing "
            "on gfx942 and gfx950, so the same operand shapes are "
            "mishandled on three targets with two symptoms."
        ),
        evidence=(
            f"Shared fault path: [`gpu_memory.h`]({GPU_MEMORY_LINK}).",
            "Both case strings appear in the CDNA BLAS-surface group above "
            "as wrong-result failures.",
            f"Not fixed by [rocm-systems#9003]({MEMORY_FIX_PULL}).",
        ),
        representative=("gfx1201", "4b2665c93c4f"),
    ),
    Group(
        key="gfx1201.rms-reduction",
        title="gfx1201 `RMS_NORM_BACK` fails at every tested shape",
        kind="defect",
        confidence="Reproducible gfx1201-only defect; root cause not localized",
        root_cause=(
            "Both `RMS_NORM_BACK` cases in the inventory fail on gfx1201 "
            "and both pass on the other three targets. The 64-wide shape "
            "returns wrong values and the 1025-wide shape crashes, so row "
            "width changes the symptom but not the presence of the defect. "
            "The corpus offers no narrower shape to bisect against, so the "
            "failing computation is not localized."
        ),
        evidence=(
            "Both of the inventory's two `RMS_NORM_BACK` cases fail on "
            "gfx1201 and pass on gfx942, gfx950, and gfx1100.",
        ),
        representative=("gfx1201", "b0eca1729a88"),
    ),
    Group(
        key="unmerged.gfx942.OPT_STEP_ADAMW",
        title="gfx942 `OPT_STEP_ADAMW` returns wrong values",
        kind="defect",
        confidence="Reproducible failure; root cause not investigated",
        root_cause=(
            "One f32 `OPT_STEP_ADAMW` case fails. The identical case fails "
            "on gfx950, so this and the gfx950 entry are very likely the "
            "same CDNA defect, but they are reported separately because no "
            "shared code path has been confirmed."
        ),
        evidence=("The same case string fails on gfx950 and passes on RDNA.",),
        representative=("gfx942", "53563ed7ba67"),
    ),
    Group(
        key="unmerged.gfx950.OPT_STEP_ADAMW",
        title="gfx950 `OPT_STEP_ADAMW` returns wrong values",
        kind="defect",
        confidence="Reproducible failure; root cause not investigated",
        root_cause=(
            "Counterpart of the gfx942 `OPT_STEP_ADAMW` failure with an "
            "identical case string."
        ),
        evidence=("The same case string fails on gfx942 and passes on RDNA.",),
        representative=("gfx950", "53563ed7ba67"),
    ),
    Group(
        key="unmerged.gfx942.UPSCALE",
        title="gfx942 bicubic `UPSCALE` with `align_corners` is wrong",
        kind="defect",
        confidence="Reproducible failure; root cause not investigated",
        root_cause=(
            "One `mode=bicubic|align_corners` case that downscales to "
            "`ne_tgt=[1,1,3,2]` fails. The identical case fails on gfx950, "
            "so the bicubic coefficient or clamp handling for degenerate "
            "target extents is the suspect."
        ),
        evidence=("The same case string fails on gfx950 and passes on RDNA.",),
        representative=("gfx942", "f4497e2354a8"),
    ),
    Group(
        key="unmerged.gfx950.UPSCALE",
        title="gfx950 bicubic `UPSCALE` with `align_corners` is wrong",
        kind="defect",
        confidence="Reproducible failure; root cause not investigated",
        root_cause=(
            "Counterpart of the gfx942 `UPSCALE` failure with an identical "
            "case string."
        ),
        evidence=("The same case string fails on gfx942 and passes on RDNA.",),
        representative=("gfx950", "f4497e2354a8"),
    ),
    Group(
        key="timeout.throughput.MUL_MAT_ID_FUSION",
        title="`MUL_MAT_ID_FUSION` exceeds the 60 s per-case budget",
        kind="timeout",
        confidence="Simulator throughput limit; not a correctness defect",
        root_cause=(
            "Six fused expert-matmul cases on gfx1100 and gfx1201 do not "
            "finish within 60 seconds. The kernels have finite trip counts "
            "and the simulator stays on CPU throughout, so this is "
            "simulation cost rather than deadlock."
        ),
        evidence=(
            "A 20-second sample of the comparable `LIGHTNING_INDEXER` "
            "timeout consumed 39.90 user seconds at 200% CPU "
            "(`debug/gfx1201-lightning-20s-time.log`), which is active "
            "execution, not a blocked wait.",
        ),
        representative=("gfx1100", "f6f7601c1c97"),
    ),
    Group(
        key="timeout.throughput.LIGHTNING_INDEXER",
        title="`LIGHTNING_INDEXER` exceeds the 60 s per-case budget",
        kind="timeout",
        confidence="Simulator throughput limit; not a correctness defect",
        root_cause=(
            "The same `LIGHTNING_INDEXER` case times out on all four "
            "targets, which is the signature of a uniformly expensive "
            "kernel rather than a target-specific defect."
        ),
        evidence=(
            "`debug/gfx1201-lightning-20s-time.log`: 39.90 user seconds and "
            "200% CPU over a 20-second wall-clock window.",
        ),
        representative=("gfx942", "28d7def07117"),
    ),
    Group(
        key="timeout.throughput.MUL_MAT",
        title="Deep-batch `MUL_MAT` exceeds the 60 s per-case budget on CDNA",
        kind="timeout",
        confidence="Simulator throughput limit; not a correctness defect",
        root_cause=(
            "One `MUL_MAT` case with `bs=[1536,1]`, that is 1536 batched "
            "16x8x256 products, times out on gfx942 and gfx950 while "
            "shallower batches of the same operator complete."
        ),
        evidence=(
            "The same case string times out on both CDNA targets.",
            "On gfx1201 the same case string crashes instead, in the HWREG "
            "ID 26 group above.",
        ),
        representative=("gfx950", "462ccb738b08"),
    ),
    Group(
        key="timeout.throughput.MUL_MAT_ID",
        title="`MUL_MAT_ID` exceeds the 60 s per-case budget on gfx1100",
        kind="timeout",
        confidence="Simulator throughput limit; not a correctness defect",
        root_cause=(
            "Two expert-indexed matmul cases with `m=k=2880` exceed the "
            "budget on gfx1100 only and complete on the other three "
            "targets. No mechanism was investigated beyond confirming that "
            "the cost is CPU-bound simulation."
        ),
        evidence=("Both cases complete on gfx942, gfx950, and gfx1201.",),
        representative=("gfx1100", "4c6f0c369254"),
    ),
    Group(
        key="timeout.contention-candidate",
        title="gfx1201 `RMS_NORM_MUL_ROPE` timed out only under load",
        kind="timeout",
        confidence="Not a timeout defect; scheduling artifact",
        root_cause=(
            "This case returns an ordinary numerical failure in the "
            "30-second run and in the rocm-systems#9003 comparison run, and "
            "timed out only in the eight-worker 60-second run scheduled "
            "alongside three long fusion simulations. Treat it as host CPU "
            "contention. When it fails numerically it looks like the "
            "gfx1201 work-item Y group; it appears here rather than there "
            "because the outcome in the run this report covers was a "
            "timeout."
        ),
        evidence=(
            "Outcome differs by run phase: `test-failure` in the soft and "
            "fixed phases, `timeout` in the hard phase.",
        ),
        representative=("gfx1201", "92e31eecab55"),
    ),
)


def load_payload(result_root: Path) -> dict:
    path = result_root / "root-cause-groups.json"
    return json.loads(path.read_text(encoding="utf-8"))


def artifact_log(result_root: Path, case: dict) -> Path:
    target = case["target"]
    return (
        result_root
        / "hard"
        / target
        / "artifacts"
        / "llama"
        / target
        / "cases"
        / f"{case['operator']}.{case['digest']}.log"
    )


def observed_lines(result_root: Path, case: dict) -> list[str]:
    """Extract harness and simulator diagnostics for one case."""
    path = artifact_log(result_root, case)
    if not path.is_file():
        return []
    text = path.read_text(encoding="utf-8", errors="replace")
    observed = list(dict.fromkeys(ERROR_PATTERN.findall(text)))
    for warning in dict.fromkeys(WARNING_PATTERN.findall(text)):
        if UBIQUITOUS_WARNING not in warning:
            observed.append(warning.strip())
    return observed


def reproducer(case: dict) -> str:
    config = TARGET_CONFIGS[case["target"]]
    return "\n".join(
        [
            f'"$ROCJITSU" --config "$ROCJITSU_CONFIGS/{config}" -- \\',
            '  "$CORPUS/corpus/llama/build/test-backend-ops" test \\',
            f"  -o {shlex.quote(case['case'])} \\",
            "  -b ROCm0 -j 1 --output csv",
        ]
    )


def case_table(cases: list[dict]) -> list[str]:
    """Render the case table, dropping outcome when the group is uniform."""
    if len({case["outcome"] for case in cases}) == 1:
        return [
            "| Test ID | Case |",
            "| --- | --- |",
            *(f"| `{case['id']}` | `{case['case']}` |" for case in cases),
        ]
    return [
        "| Test ID | Outcome | Case |",
        "| --- | --- | --- |",
        *(
            f"| `{case['id']}` | {case['outcome']} | `{case['case']}` |"
            for case in cases
        ),
    ]


def affected_block(cases: list[dict]) -> list[str]:
    table = case_table(cases)
    if len(cases) <= INLINE_CASE_LIMIT:
        return table
    return [
        "<details>",
        f"<summary>{len(cases)} affected tests</summary>",
        "",
        *table,
        "",
        "</details>",
    ]


def outcome_summary(cases: list[dict]) -> str:
    counts: dict[str, int] = {}
    for case in cases:
        counts[case["outcome"]] = counts.get(case["outcome"], 0) + 1
    return ", ".join(
        f"{count} {outcome}" for outcome, count in sorted(counts.items())
    )


def representative_case(group: Group, cases: list[dict]) -> dict:
    target, digest = group.representative
    for case in cases:
        if case["target"] == target and case["digest"] == digest:
            return case
    raise SystemExit(
        f"group {group.key} representative {target}/{digest} is not a member"
    )


def render_group(
    result_root: Path, index: int, group: Group, cases: list[dict]
) -> list[str]:
    targets = ", ".join(sorted({case["target"] for case in cases}))
    representative = representative_case(group, cases)
    observed = observed_lines(result_root, representative)

    noun = "test" if len(cases) == 1 else "tests"
    lines = [
        f"### {index}. {group.title}",
        "",
        f"`{group.key}` — {len(cases)} {noun} on {targets} "
        f"({outcome_summary(cases)})",
        "",
        "**Affected tests**",
        "",
        *affected_block(cases),
        "",
        "**Likely root cause**",
        "",
        group.root_cause,
        "",
        f"*Confidence: {group.confidence}.*",
        "",
        "**Evidence**",
        "",
    ]
    lines.extend(f"- {item}" for item in group.evidence)
    if observed:
        lines.extend(
            ["", f"Observed for `{representative['id']}`:", "", "```"]
        )
        lines.extend(observed)
        lines.append("```")
    lines.extend(
        [
            "",
            "**Reproducer**",
            "",
            "```bash",
            reproducer(representative),
            "```",
            "",
        ]
    )
    return lines


def render_header(payload: dict) -> list[str]:
    groups = payload["groups"]
    total = sum(len(cases) for cases in groups.values())
    segfaults = len(
        payload["cross_cutting_mechanisms"][
            "host-sigsegv-after-unresolved-gpu-address"
        ]
    )
    per_target: dict[str, list[dict]] = {target: [] for target in TARGETS}
    for cases in groups.values():
        for case in cases:
            per_target[case["target"]].append(case)

    lines = [
        "# ROCjitsu llama backend-ops triage: "
        f"{total} persistent failures on four targets",
        "",
        "Every llama `test-backend-ops` case in the corpus inventory was run "
        "under ROCjitsu on each supported target, once with a 30-second "
        "per-case timeout and then again on every failure with a 60-second "
        "timeout. Only failures that survived both runs are reported here. "
        "Each section below lists the affected tests first, then the likely "
        "ROCjitsu root cause with an explicit confidence level, the "
        "supporting evidence, and one command that reproduces the group's "
        "representative case.",
        "",
        "## Environment",
        "",
        "| Item | Value |",
        "| --- | --- |",
        f"| ROCjitsu / rocm-systems | [`{ROCM_SYSTEMS_COMMIT[:12]}`]"
        f"({ROCM_SYSTEMS_REPO}/commit/{ROCM_SYSTEMS_COMMIT}) |",
        f"| Corpus | [`{CORPUS_COMMIT[:12]}`]"
        f"({CORPUS_REPO}/commit/{CORPUS_COMMIT}) |",
        f"| Inventory | [`selected_llama_backend_ops_tests.json`]"
        f"({CORPUS_REPO}/blob/{CORPUS_COMMIT}/corpus/llama/"
        "selected_llama_backend_ops_tests.json) |",
        "| Suite | `llama` only |",
        f"| Cases per target | {CASE_COUNT_PER_TARGET} |",
        "| Execution | functional mode, eight pytest-xdist workers |",
        "",
        "`gfx1250` is excluded because the llama inventory does not list it "
        "as a supported target.",
        "",
        "## Results",
        "",
        "| Target | Simulated device | Config | Passed | "
        "Persistent failures | SIGSEGV | Wrong result | Timeout |",
        "| --- | --- | --- | --- | --- | --- | --- | --- |",
    ]
    for target in TARGETS:
        cases = per_target[target]
        counts: dict[str, int] = {}
        for case in cases:
            counts[case["outcome"]] = counts.get(case["outcome"], 0) + 1
        lines.append(
            f"| `{target}` | {TARGET_DEVICES[target]} | "
            f"`{TARGET_CONFIGS[target]}` | "
            f"{CASE_COUNT_PER_TARGET - len(cases)} | {len(cases)} | "
            f"{counts.get('segfault', 0)} | "
            f"{counts.get('test-failure', 0)} | "
            f"{counts.get('timeout', 0)} |"
        )

    totals: dict[str, int] = {}
    for cases in per_target.values():
        for case in cases:
            totals[case["outcome"]] = totals.get(case["outcome"], 0) + 1
    lines.extend(
        [
            f"| **Total** | | | "
            f"{CASE_COUNT_PER_TARGET * len(TARGETS) - total} | {total} | "
            f"{totals.get('segfault', 0)} | "
            f"{totals.get('test-failure', 0)} | "
            f"{totals.get('timeout', 0)} |",
            "",
            f"All {segfaults} SIGSEGV cases share one crash mechanism, "
            "described in its own section below. The passed column includes "
            "12 cases that failed only against the 30-second timeout and "
            "passed on the 60-second rerun.",
            "",
            "## Running the reproducers",
            "",
            "Every reproducer in this report uses these three variables:",
            "",
            "```bash",
            "export ROCJITSU=<rocm-systems build>/tools/rocjitsu/rocjitsu",
            f"export ROCJITSU_CONFIGS=<rocm-systems>/{ROCJITSU_PREFIX}/"
            "configs",
            "export CORPUS=<rocjitsu-test-corpus checkout>",
            "```",
            "",
            "`$CORPUS/corpus/llama/build/test-backend-ops` is produced by "
            "`corpus/llama/build_llama_tests.sh`. The `ERR` values quoted "
            "below come from the recorded run; the harness generates random "
            "inputs, so a rerun reproduces the same pass or fail verdict "
            "with a slightly different magnitude. To rerun a whole target "
            "through the pytest harness instead, from `$CORPUS`:",
            "",
            "```bash",
            '"$ROCJITSU" --config "$ROCJITSU_CONFIGS/gfx1201_r9700.json" -- \\',
            "  python -m pytest tests/test_corpus.py --target gfx1201 \\",
            "  --suite llama --timeout 60 -n 8 -o timeout_func_only=true",
            "```",
            "",
        ]
    )
    return lines


def render_mechanism(payload: dict) -> list[str]:
    cases = payload["cross_cutting_mechanisms"][
        "host-sigsegv-after-unresolved-gpu-address"
    ]
    by_target: dict[str, int] = {}
    for case in cases:
        by_target[case["target"]] = by_target.get(case["target"], 0) + 1
    spread = ", ".join(
        f"{target}: {count}" for target, count in sorted(by_target.items())
    )
    return [
        "## Cross-cutting crash mechanism: host SIGSEGV after an unresolved "
        "GPU address",
        "",
        f"{len(cases)} of the failures above die the same way ({spread}). "
        "This section describes the shared mechanism; the initiating defects "
        "stay in their own sections because they differ per group.",
        "",
        "When a VMID page-table walk misses and passthrough is enabled, "
        "ROCjitsu casts the unresolved GPU virtual address to a host pointer "
        f"and hands it to `memcpy()` inside `GpuMemory::read_mapped()` "
        f"([source]({GPU_MEMORY_LINK})). In both GDB reproductions the "
        "faulting source address was absent from `/proc/<pid>/maps` while "
        "the destination was writable, confirming the read side is the bad "
        "pointer.",
        "",
        "*Confidence: confirmed crash mechanism; not the initiating cause of "
        "any group.*",
        "",
        "Two facts bound the scope:",
        "",
        f"- The pending local-memory work in [rocm-systems#9003]"
        f"({MEMORY_FIX_PULL}) adds a backing resolver but still falls "
        "through to the same raw pointer when no backing range matches. "
        f"Rebuilding on that branch left all {len(cases)} crashes and every "
        "other persistent failure unchanged.",
        "- The fallback only converts an already-wrong address into a host "
        "fault. Fixing it would turn these crashes into diagnosable errors, "
        "but the address computations that produce unbacked addresses would "
        "still be wrong.",
        "",
        "Supporting logs: `debug/gfx1100-flash-attn-gdb-aslr.log`, "
        "`debug/gfx1201-mul-mat-gdb-aslr.log`, "
        "`debug/gfx1201-mul-mat-fixed-gdb-aslr.log`, "
        "`debug/gfx1201-mul-mat-fixed-mappings.log`.",
        "",
    ]


def render_excluded() -> list[str]:
    return [
        "## Hypotheses ruled out",
        "",
        f"- **The pending local-memory fix.** [rocm-systems#9003]"
        f"({MEMORY_FIX_PULL}) resolves none of the persistent failures.",
        "- **The SIMD executor fast paths.** Rerunning every wrong-result "
        "case with `RJ_FORCE_SCALAR=1` reproduced all of them unchanged, so "
        "the scalar and vector paths share the defects.",
        "- **Flaky infrastructure.** Twelve cases that failed with a "
        "30-second timeout passed at 60 seconds and are excluded from this "
        "report; everything reported here failed in both runs.",
        "",
    ]


def validate(payload: dict) -> None:
    groups = payload["groups"]
    metadata_keys = [group.key for group in GROUPS]
    if len(metadata_keys) != len(set(metadata_keys)):
        raise SystemExit("duplicate group metadata keys")
    missing = sorted(set(groups) - set(metadata_keys))
    if missing:
        raise SystemExit(f"missing group metadata: {', '.join(missing)}")
    unknown = sorted(set(metadata_keys) - set(groups))
    if unknown:
        raise SystemExit(f"metadata for unknown groups: {', '.join(unknown)}")

    seen: dict[str, str] = {}
    for key, cases in groups.items():
        for case in cases:
            if case["id"] in seen:
                raise SystemExit(
                    f"case {case['id']} appears in {seen[case['id']]} and "
                    f"{key}"
                )
            seen[case["id"]] = key

    mechanism = payload["cross_cutting_mechanisms"][
        "host-sigsegv-after-unresolved-gpu-address"
    ]
    mechanism_ids = {case["id"] for case in mechanism}
    segfault_ids = {
        case["id"]
        for cases in groups.values()
        for case in cases
        if case["outcome"] == "segfault"
    }
    if mechanism_ids != segfault_ids:
        raise SystemExit(
            "cross-cutting mechanism does not cover exactly the segfaults"
        )

    for group in GROUPS:
        if not (group.confidence and group.root_cause and group.evidence):
            raise SystemExit(f"group {group.key} is missing metadata")
        representative_case(group, groups[group.key])

    for kind in ("defect", "timeout"):
        sizes = [
            len(groups[group.key]) for group in GROUPS if group.kind == kind
        ]
        if sizes != sorted(sizes, reverse=True):
            raise SystemExit(f"{kind} groups are not ordered by size")


def render(result_root: Path, payload: dict) -> str:
    groups = payload["groups"]
    defects = [group for group in GROUPS if group.kind == "defect"]
    timeouts = [group for group in GROUPS if group.kind == "timeout"]

    lines = render_header(payload)
    lines.extend(
        [
            f"## Candidate bugs ({len(defects)})",
            "",
            "Ordered by number of affected tests.",
            "",
        ]
    )
    for index, group in enumerate(defects, start=1):
        lines.extend(
            render_group(result_root, index, group, groups[group.key])
        )

    lines.extend(render_mechanism(payload))

    timeout_total = sum(len(groups[group.key]) for group in timeouts)
    lines.extend(
        [
            f"## Not correctness defects: {timeout_total} timeouts",
            "",
            "These cases exhausted the 60-second per-case budget. For the "
            "14 throughput cases the kernels have finite trip counts and "
            "the simulator burns CPU throughout, so they are simulation "
            "cost rather than deadlock; the last entry is a scheduling "
            "artifact rather than a slow case. They are listed for "
            "completeness and for anyone tuning corpus timeouts.",
            "",
        ]
    )
    for index, group in enumerate(timeouts, start=1):
        lines.extend(
            render_group(result_root, index, group, groups[group.key])
        )

    lines.extend(render_excluded())
    return "\n".join(lines).rstrip("\n") + "\n"


def main() -> None:
    result_root = Path(__file__).resolve().parent
    payload = load_payload(result_root)
    validate(payload)
    output_path = result_root / "github-report.md"
    output_path.write_text(render(result_root, payload), encoding="utf-8")
    print(output_path)


if __name__ == "__main__":
    main()
