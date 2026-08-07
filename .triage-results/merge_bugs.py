#!/usr/bin/env python3
"""Collapse target-keyed symptom groups into cross-architecture bugs.

Usage: ./merge_bugs.py
"""

from __future__ import annotations

import json
from pathlib import Path

# The six flash-attention cases that still fail once the RDNA3 scalar
# register fix is applied, so they belong to a separate defect.
FLASH_ATTN_SOFTCAP = [
    f"llama.gfx1100.backend_ops.FLASH_ATTN_EXT.{digest}"
    for digest in (
        "09f30cac3778",
        "5e2b94d34560",
        "a12f4ee82c79",
        "a845b89cd4f0",
        "c94907bea454",
        "e024795e26c2",
    )
]

# Each bug owns the tests of the listed groups, minus any "excludes", plus
# any "owns_ids" named individually. Ownership is exclusive so that owned
# counts sum to the persistent failure total. "lists" names an additional
# non-owning set: a mechanism-level bug enumerates every test that reaches
# its faulting site, including tests owned by other bugs.
BUGS = [
    {
        "id": "rdna4-buffer-oob",
        "name": (
            "RDNA4 buffer address calculation omits the out-of-bounds "
            "check, so out-of-range lanes reach wild addresses"
        ),
        "scope": "RDNA4 model",
        "kind": "initiating",
        "confidence": "confirmed by experiment",
        "owns": [
            "gfx1201.matrix-crash-surface.MUL_MAT",
            "gfx1201.matrix-crash-surface.MUL_MAT_ID",
            "gfx1201.matrix-crash-surface.OUT_PROD",
            "gfx1201.matrix-crash-surface.SOLVE_TRI",
            "gfx1201.wave-sched-mode-gap",
        ],
        "merge_evidence": (
            "Restoring the bounds check that every other architecture "
            "already implements turns all 60 of these from failures into "
            "passes. That merges five symptom groups into one defect and "
            "retires the separate WAVE_SCHED_MODE hypothesis."
        ),
    },
    {
        "id": "cdna-smem-sgpr-offset",
        "name": (
            "The gfx9 SMEM SGPR-offset form drops the offset, so every "
            "pointer-array batched rocBLAS call reads batch 0"
        ),
        "scope": "CDNA-wide",
        "kind": "initiating",
        "confidence": "confirmed by experiment",
        "owns": ["cdna.mmf-f32", "cdna.rocblas-surface"],
        "merge_evidence": (
            "The f32 MUL_MAT cases and the OUT_PROD and SOLVE_TRI cases "
            "were separate groups. Both dispatch through Tensile's "
            "pointer-array batched kernels, and adding the missing "
            "address form turns all 12 into passes, so they are one "
            "defect. These case strings also fail on gfx1201, which had "
            "looked like the strongest architecture-independent lead in "
            "the corpus; that is refuted, because the RDNA4 buffer bounds "
            "probe fixes the gfx1201 cases and leaves these untouched."
        ),
    },
    {
        "id": "rdna3-scalar-registers",
        "name": (
            "RDNA3 models scalar encodings 102 and 103 as FLAT_SCRATCH "
            "instead of ordinary SGPRs"
        ),
        "scope": "RDNA3 model",
        "kind": "initiating",
        "confidence": "confirmed by experiment",
        "owns": [
            "gfx1100.flash-attn.optimized-mma-wmma",
            "gfx1100.flash-attn.generic-tile-d72",
        ],
        "excludes": FLASH_ATTN_SOFTCAP,
        "merge_evidence": (
            "The previous split into an optimized MMA/WMMA subgroup and a "
            "generic D=72 tile subgroup is refuted: hsk values 64, 72, 80 "
            "and 128 are all fixed by the same change, and it repairs both "
            "the crashing and the wrong-result cases."
        ),
    },
    {
        "id": "flash-attn-softcap",
        "name": "gfx1100 flash attention with logit_softcap and a large grid",
        "scope": "single GFX model",
        "kind": "initiating",
        "owns_ids": FLASH_ATTN_SOFTCAP,
    },
    {
        "id": "rdna4-smem-subdword",
        "name": (
            "RDNA4 truncates scalar memory addresses to a dword boundary, "
            "breaking the sub-dword scalar loads that GFX12 added"
        ),
        "scope": "RDNA4 model",
        "kind": "initiating",
        "confidence": "confirmed by experiment",
        "owns": ["gfx1201.packed-workitem-y-surface"],
        "merge_evidence": (
            "Removing the dword mask turns all 24 of these from failures "
            "into passes and retires the packed work-item Y hypothesis "
            "these tests were originally grouped under."
        ),
    },
    {
        "id": "nvfp4-gfx942",
        "name": "gfx942 NVFP4 quantized route produces wrong results",
        "scope": "single GFX model",
        "kind": "initiating",
        "owns": ["gfx942.nvfp4-route"],
    },
    {
        "id": "cdna-pk-f32-scalar-src",
        "name": (
            "Packed FP32 VOP3P instructions read only the low dword of an "
            "SGPR-pair source"
        ),
        "scope": "shared code, observed on CDNA",
        "kind": "initiating",
        "confidence": "confirmed by experiment",
        "owns": [
            "cdna.rope-propagation",
            "cdna.ssm-scan",
            "cdna.xielu",
            "unmerged.gfx942.OPT_STEP_ADAMW",
            "unmerged.gfx950.OPT_STEP_ADAMW",
            "unmerged.gfx942.UPSCALE",
            "unmerged.gfx950.UPSCALE",
        ],
        "merge_evidence": (
            "Six operator families collapse into one defect. ROPE, "
            "ROPE_SET_ROWS, SSM_SCAN and XIELU were filed as four "
            "candidate defects and are one. OPT_STEP_ADAMW and UPSCALE "
            "were four target-keyed entries held separately and are the "
            "same defect again. Only MUL_MAT resisted the merge and "
            "belongs to the SMEM offset defect instead."
        ),
    },
    {
        "id": "rms-reduction-gfx1201",
        "name": "gfx1201 RMS_NORM_BACK multi-wave reduction",
        "scope": "single GFX model",
        "kind": "initiating",
        "owns": ["gfx1201.rms-reduction"],
    },
    {
        "id": "simulator-throughput",
        "name": "Simulator throughput limit on long fusion and indexer kernels",
        "scope": "all targets",
        "kind": "cost",
        "owns": [
            "timeout.throughput.LIGHTNING_INDEXER",
            "timeout.throughput.MUL_MAT",
            "timeout.throughput.MUL_MAT_ID",
            "timeout.throughput.MUL_MAT_ID_FUSION",
            "timeout.contention-candidate",
        ],
        "merge_evidence": (
            "LIGHTNING_INDEXER times out on all four targets and "
            "MUL_MAT_ID_FUSION on both RDNA targets, which is consistent "
            "with simulation cost rather than a target defect. Not a "
            "correctness defect."
        ),
    },
]


def load_probe(root: Path) -> dict[str, str]:
    path = root / "debug2/probe-rdna4-oob.json"
    if not path.exists():
        return {}
    payload = json.loads(path.read_text(encoding="utf-8"))
    return {r["id"]: r["outcome"] for r in payload["results"]}


def build(source: dict, probe: dict[str, str]) -> dict:
    groups = source["groups"]
    segfaults = source["cross_cutting_mechanisms"][
        "host-sigsegv-after-unresolved-gpu-address"
    ]

    by_id = {c["id"]: c for v in groups.values() for c in v}

    owner: dict[str, str] = {}
    bugs = []
    for spec in BUGS:
        excludes = set(spec.get("excludes", ()))
        selected = [
            case
            for group_name in spec.get("owns", ())
            for case in groups[group_name]
            if case["id"] not in excludes
        ]
        for test_id in spec.get("owns_ids", ()):
            if test_id not in by_id:
                raise SystemExit(f"{spec['id']} names unknown test {test_id}")
            selected.append(by_id[test_id])

        owned = []
        for case in selected:
            if case["id"] in owner:
                raise SystemExit(
                    f"{case['id']} owned by {owner[case['id']]} "
                    f"and {spec['id']}"
                )
            owner[case["id"]] = spec["id"]
            owned.append(case)

        bug = {
            "id": spec["id"],
            "name": spec["name"],
            "scope": spec["scope"],
            "kind": spec["kind"],
            "confidence": spec.get("confidence", "candidate"),
            "targets": sorted({c["target"] for c in owned}),
            "operators": sorted({c["operator"] for c in owned}),
            "owned_count": len(owned),
            "merged_from": spec.get("merged_from", spec.get("owns", [])),
            "owned": sorted(owned, key=lambda c: c["id"]),
        }
        if probe:
            outcomes: dict[str, int] = {}
            for case in owned:
                result = probe.get(case["id"])
                if result:
                    outcomes[result] = outcomes.get(result, 0) + 1
            bug["rdna4_oob_probe"] = dict(sorted(outcomes.items()))
        if spec.get("merge_evidence"):
            bug["merge_evidence"] = spec["merge_evidence"]
        if spec.get("lists") == "all-segfaults":
            bug["listed_count"] = len(segfaults)
            bug["listed_targets"] = sorted({c["target"] for c in segfaults})
            bug["listed"] = sorted(
                (c["id"] for c in segfaults),
            )
        bugs.append(bug)

    total_cases = sum(len(v) for v in groups.values())
    if len(owner) != total_cases:
        missing = sorted(
            c["id"] for v in groups.values() for c in v if c["id"] not in owner
        )
        raise SystemExit(f"unowned tests: {missing}")

    return {
        "attribution_rule": (
            "Each test is owned by exactly one initiating bug. A "
            "mechanism-level bug additionally lists every test that "
            "reaches its faulting site without owning them, so owned "
            "counts sum to the persistent failure total."
        ),
        "persistent_failures": total_cases,
        "owned_total": sum(b["owned_count"] for b in bugs),
        "source_group_count": len(groups),
        "bug_count": len(bugs),
        "bugs": bugs,
    }


def main() -> None:
    root = Path(__file__).resolve().parent
    source = json.loads(
        (root / "root-cause-groups.json").read_text(encoding="utf-8")
    )
    merged = build(source, load_probe(root))

    out = root / "merged-bugs.json"
    out.write_text(json.dumps(merged, indent=2) + "\n", encoding="utf-8")

    print(
        f"{merged['source_group_count']} groups -> "
        f"{merged['bug_count']} bugs, "
        f"{merged['owned_total']}/{merged['persistent_failures']} owned"
    )
    for bug in merged["bugs"]:
        listed = bug.get("listed_count")
        suffix = f" (lists {listed})" if listed else ""
        print(
            f"  {bug['owned_count']:3d}{suffix:12s} {bug['id']:24s} "
            f"{bug['scope']:26s} {','.join(bug['targets'])}"
        )
    print(out)


if __name__ == "__main__":
    main()
