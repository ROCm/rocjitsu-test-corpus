#!/usr/bin/env python3
"""Summarize llama pytest failures from soft and hard ROCjitsu runs."""

from __future__ import annotations

import hashlib
import json
import re
from collections import Counter
from pathlib import Path


FAILURE_PATTERN = re.compile(
    r"^FAILED .*\[(llama\.(gfx[0-9a-z]+)\.backend_ops\."
    r"([A-Z0-9_]+)\.([0-9a-f]{12}))\].*? - (.*)$"
)
OUTCOME_PATTERN = re.compile(r"reported '([^']+)'")
TARGETS = ("gfx942", "gfx950", "gfx1100", "gfx1201")
WAVE_SCHED_MODE_DIGESTS = {
    "462ccb738b08",
    "720ff672c8f0",
    "7bcc11c86355",
    "bc1240d0e862",
    "d5d0d2415b9b",
}


def load_cases(inventory_path: Path) -> dict[str, str]:
    payload = json.loads(inventory_path.read_text(encoding="utf-8"))
    return {
        hashlib.sha256(case.encode("utf-8")).hexdigest()[:12]: case
        for case in payload["cases"]
    }


def classify(detail: str) -> str:
    if "Timeout" in detail:
        return "timeout"
    match = OUTCOME_PATTERN.search(detail)
    if match:
        return match.group(1)
    return "other"


def parse_log(log_path: Path, cases: dict[str, str]) -> list[dict[str, str]]:
    failures = {}
    for line in log_path.read_text(errors="replace").splitlines():
        match = FAILURE_PATTERN.match(line)
        if not match:
            continue
        case_id, target, operator, digest, detail = match.groups()
        failures[case_id] = {
            "id": case_id,
            "target": target,
            "operator": operator,
            "digest": digest,
            "case": cases[digest],
            "outcome": classify(detail),
        }
    return sorted(failures.values(), key=lambda failure: failure["id"])


def summarize_phase(
    result_root: Path, phase: str, cases: dict[str, str]
) -> dict[str, dict]:
    result = {}
    for target in TARGETS:
        log_path = result_root / phase / f"{target}.log"
        failures = parse_log(log_path, cases)
        result[target] = {
            "failure_count": len(failures),
            "counts": dict(
                sorted(Counter(item["outcome"] for item in failures).items())
            ),
            "failures": failures,
        }
    return result


def refined_group(failure: dict[str, str]) -> str:
    target = failure["target"]
    operator = failure["operator"]
    case = failure["case"]

    if failure["outcome"] == "timeout":
        if operator == "RMS_NORM_MUL_ROPE":
            return "timeout.contention-candidate"
        return f"timeout.throughput.{operator}"

    if target == "gfx1100" and operator == "FLASH_ATTN_EXT":
        if "hsk=72," in case:
            return "gfx1100.flash-attn.generic-tile-d72"
        return "gfx1100.flash-attn.optimized-mma-wmma"

    if target == "gfx1201":
        if operator in {"GATED_DELTA_NET", "TOPK_MOE", "RMS_NORM_MUL_ROPE"}:
            return "gfx1201.packed-workitem-y-surface"
        if operator == "RMS_NORM_BACK":
            return "gfx1201.rms-reduction"
        if failure["digest"] in WAVE_SCHED_MODE_DIGESTS:
            return "gfx1201.wave-sched-mode-gap"
        if failure["outcome"] == "segfault":
            return f"gfx1201.matrix-crash-surface.{operator}"

    if target in {"gfx942", "gfx950"}:
        if target == "gfx942" and "nvfp4" in case:
            return "gfx942.nvfp4-route"
        operator_groups = {
            "MUL_MAT": "cdna.mmf-f32",
            "ROPE": "cdna.rope-propagation",
            "ROPE_SET_ROWS": "cdna.rope-propagation",
            "SSM_SCAN": "cdna.ssm-scan",
            "XIELU": "cdna.xielu",
            "SOLVE_TRI": "cdna.rocblas-surface",
            "OUT_PROD": "cdna.rocblas-surface",
        }
        if operator in operator_groups:
            return operator_groups[operator]

    return f"unmerged.{target}.{operator}"


def main() -> None:
    result_root = Path(__file__).resolve().parent
    worktree = result_root.parent
    inventory_path = (
        worktree / "corpus/llama/selected_llama_backend_ops_tests.json"
    )
    cases = load_cases(inventory_path)
    phases = {
        phase: summarize_phase(result_root, phase, cases)
        for phase in ("soft", "hard", "fixed", "scalar")
        if (result_root / phase).exists()
    }

    if "soft" in phases and "hard" in phases:
        for target in TARGETS:
            soft = {
                item["id"]: item for item in phases["soft"][target]["failures"]
            }
            hard = {
                item["id"]: item for item in phases["hard"][target]["failures"]
            }
            phases["soft"][target]["recovered_on_hard_rerun"] = sorted(
                set(soft) - set(hard)
            )
            phases["soft"][target]["persistent_on_hard_rerun"] = sorted(
                set(soft) & set(hard)
            )

    if "hard" in phases and "fixed" in phases:
        for target in TARGETS:
            hard = {
                item["id"]: item for item in phases["hard"][target]["failures"]
            }
            fixed = {
                item["id"]: item for item in phases["fixed"][target]["failures"]
            }
            phases["hard"][target]["resolved_by_memory_fix"] = sorted(
                set(hard) - set(fixed)
            )
            phases["hard"][target]["persistent_with_memory_fix"] = sorted(
                set(hard) & set(fixed)
            )
            phases["fixed"][target]["new_against_hard_rerun"] = sorted(
                set(fixed) - set(hard)
            )

    if "hard" in phases and "scalar" in phases:
        for target in TARGETS:
            hard = {
                item["id"]: item
                for item in phases["hard"][target]["failures"]
                if item["outcome"] == "test-failure"
            }
            scalar = {
                item["id"]: item
                for item in phases["scalar"][target]["failures"]
            }
            phases["hard"][target]["resolved_by_scalar_executor"] = sorted(
                set(hard) - set(scalar)
            )
            phases["hard"][target]["persistent_with_scalar_executor"] = sorted(
                set(hard) & set(scalar)
            )

    if "hard" in phases:
        config_directory = result_root / "test-failure-configs"
        config_directory.mkdir(exist_ok=True)
        for target in TARGETS:
            selectors = [
                item["id"]
                for item in phases["hard"][target]["failures"]
                if item["outcome"] == "test-failure"
            ]
            (config_directory / f"{target}.json").write_text(
                json.dumps({"llama": selectors}, indent=2) + "\n",
                encoding="utf-8",
            )

        groups = {}
        segfault_mechanism = []
        for target in TARGETS:
            for failure in phases["hard"][target]["failures"]:
                group_name = refined_group(failure)
                groups.setdefault(group_name, []).append(failure)
                if failure["outcome"] == "segfault":
                    segfault_mechanism.append(failure)
        group_path = result_root / "root-cause-groups.json"
        group_path.write_text(
            json.dumps(
                {
                    "groups": dict(sorted(groups.items())),
                    "cross_cutting_mechanisms": {
                        "host-sigsegv-after-unresolved-gpu-address": (
                            segfault_mechanism
                        )
                    },
                },
                indent=2,
            )
            + "\n",
            encoding="utf-8",
        )

    output_path = result_root / "summary.json"
    output_path.write_text(
        json.dumps(phases, indent=2) + "\n",
        encoding="utf-8",
    )
    print(output_path)


if __name__ == "__main__":
    main()
