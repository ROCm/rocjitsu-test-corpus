# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Install the guest's module closure in dependency order. Prefer the DKMS build."""

import argparse
from pathlib import Path
import shutil
import subprocess


def stage(kernel_root, release, dkms, destination):
    modules = {p.stem.replace("-", "_"): p for p in dkms.rglob("*.ko")}
    if "amdgpu" not in modules:
        raise ValueError(f"No compiled AMDGPU module in {dkms}")
    destination.mkdir(parents=True)
    visited = set()
    order = []

    def install(name):
        name = name.replace("-", "_")
        if name in visited:
            return
        visited.add(name)
        module = modules.get(name)
        if module is None:
            filename = subprocess.check_output(
                ["modinfo", "-b", kernel_root, "-k", release, "-n", name], text=True
            ).strip()
            if filename == "(builtin)":
                return
            module = Path(filename)
        dependencies = subprocess.check_output(
            ["modinfo", "-F", "depends", module], text=True
        ).strip()
        for dep in filter(None, dependencies.split(",")):
            install(dep)
        target = destination / module.name.removesuffix(".zst")
        if module.suffix == ".zst":
            with target.open("wb") as out:
                subprocess.run(["zstd", "-dc", module], stdout=out, check=True)
        else:
            shutil.copyfile(module, target)
        if name in modules:
            subprocess.run(["strip", "--strip-debug", target], check=True)
        order.append(target.name)

    for required in ("virtio_pci", "virtio_net", "amdgpu"):
        install(required)
    (destination / "load-order").write_text("\n".join(order) + "\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("kernel_root", type=Path)
    parser.add_argument("release")
    parser.add_argument("dkms", type=Path)
    parser.add_argument("destination", type=Path)
    args = parser.parse_args()
    stage(args.kernel_root, args.release, args.dkms, args.destination)
