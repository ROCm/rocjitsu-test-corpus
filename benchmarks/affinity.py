#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""Select eight physical cores sharing one L3 cache for benchmarks."""

import os
from pathlib import Path


def cpu_list(value):
    cpus = set()
    for part in value.strip().split(","):
        bounds = part.split("-")
        if len(bounds) == 1:
            cpus.add(int(part))
        elif len(bounds) == 2 and int(bounds[0]) <= int(bounds[1]):
            cpus.update(range(int(bounds[0]), int(bounds[1]) + 1))
        else:
            raise ValueError(f"Invalid CPU list: {value!r}")
    if not cpus or min(cpus) < 0:
        raise ValueError(f"Invalid CPU list: {value!r}")
    return sorted(cpus)


def read_topology(allowed, sysfs=Path("/sys/devices/system/cpu")):
    """Read allowed CPUs, retaining full sibling/cache masks for reservation."""
    records = []
    for cpu in sorted(allowed):
        root = sysfs / f"cpu{cpu}"
        topology = root / "topology"
        package = int((topology / "physical_package_id").read_text())
        core = int((topology / "core_id").read_text())
        siblings = cpu_list((topology / "thread_siblings_list").read_text())
        groups = set()
        for cache in sorted((root / "cache").glob("index*")):
            if int((cache / "level").read_text()) == 3 and (
                cache / "type"
            ).read_text().strip() in ("Unified", "Data"):
                groups.add(tuple(cpu_list((cache / "shared_cpu_list").read_text())))
        if len(groups) != 1 or cpu not in next(iter(groups), ()):
            raise ValueError(f"CPU {cpu}: expected one shared L3 cache mask")
        if package < 0 or core < 0 or cpu not in siblings:
            raise ValueError(f"CPU {cpu}: invalid physical core topology")
        governor_path = root / "cpufreq/scaling_governor"
        try:
            governor = governor_path.read_text().strip()
        except OSError:
            governor = "unknown"
        records.append(
            {
                "cpu": cpu,
                "physical_package_id": package,
                "core_id": core,
                "smt_siblings": siblings,
                "l3_cpus": list(next(iter(groups))),
                "governor": governor,
            }
        )
    return records


def select_cpus(records):
    groups = {}
    for record in records:
        groups.setdefault(tuple(record["l3_cpus"]), []).append(record)
    for group in sorted(groups):
        cores = {}
        for record in sorted(groups[group], key=lambda item: item["cpu"]):
            key = (record["physical_package_id"], record["core_id"])
            cores.setdefault(key, record["cpu"])
        if len(cores) >= 8:
            return sorted(cores.values())[:8]
    raise ValueError(
        "Need eight allowed physical cores sharing one L3 cache; no suitable group found"
    )


def discover(
    allowed=None,
    sysfs=Path("/sys/devices/system/cpu"),
    cpuinfo=Path("/proc/cpuinfo"),
):
    allowed = sorted(os.sched_getaffinity(0) if allowed is None else allowed)
    records = read_topology(allowed, sysfs)
    selected = select_cpus(records)
    try:
        models = sorted(
            {
                line.split(":", 1)[1].strip()
                for line in cpuinfo.read_text().splitlines()
                if line.startswith("model name") and ":" in line
            }
        )
    except OSError:
        models = []
    return {
        "cpu_models": models or ["unknown"],
        "allowed_cpus": allowed,
        "selected_cpus": selected,
        "cpu_topology": records,
    }
