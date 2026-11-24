#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Assemble two bootable initramfs images from the CI guest base and selected ROCm build."""

import argparse
import json
import mmap
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

from firmware_fixtures import generate


def copy_dependencies(binary, root, libraries, sdk):
    # Retain ELF SONAMEs while relocating the SDK (wheel and /opt layouts differ).
    listing = subprocess.check_output(["ldd", binary], text=True)
    for row in listing.splitlines():
        if "=> not found" in row:
            raise ValueError(f"{binary}: {row.strip()}")
        mapped = re.match(r"\s*(\S+) => (/.*?) \(0x", row)
        loader = re.match(r"\s*(/\S+) \(0x", row)
        if mapped:
            name, path = mapped.groups()
            source = Path(path).resolve(strict=True)
            # The candidate rank may have a RUNPATH to the host SDK.
            if name.partition(".so")[0] in (
                "libamdhip64",
                "libhsa-runtime64",
                "librccl",
            ):
                if not source.samefile(sdk / "lib" / name):
                    raise ValueError(f"{name} resolved outside the guest SDK: {source}")
            if name in libraries:
                if libraries[name] != source:
                    raise ValueError(
                        f"Conflicting libraries for {name}: {libraries[name]}, {source}"
                    )
                continue
            libraries[name] = source
            destination = root / "opt/rocm/lib" / name
        elif loader:
            source = Path(loader[1])
            destination = root / source.relative_to("/")
        else:
            continue
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)


def stage_rccl_code(root, sdk, libraries):
    rccl = next(
        path for name, path in libraries.items() if name.startswith("librccl.so")
    )
    with rccl.open("rb") as stream, mmap.mmap(
        stream.fileno(), 0, access=mmap.ACCESS_READ
    ) as data:
        if data.find(b"rccl_lib_@GFXARCH@.kpack") < 0:
            return  # The RCCL library carries its own device code.
    for directory in (
        sdk / ".kpack",
        sdk / "lib/.kpack",
        rccl.parent / ".kpack",
        rccl.parent.parent / ".kpack",
    ):
        archive = directory / "rccl_lib_gfx1250.kpack"
        if archive.is_file():
            destination = root / "opt/rocm/.kpack"
            destination.mkdir(parents=True)
            shutil.copy2(archive, destination)
            return
    raise FileNotFoundError(f"Install the gfx1250 device package for {rccl}")


def build(args):
    base, sdk, sim = (
        p.resolve(strict=True) for p in (args.base, args.rocm, args.build)
    )
    assets = Path(__file__).resolve().parent
    out = args.output.resolve()
    if out.exists():
        raise FileExistsError(f"Select a new image directory: {out}")
    out.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        ["sha256sum", "--check", "--quiet", "SHA256SUMS"], cwd=base, check=True
    )
    with tempfile.TemporaryDirectory(dir=out.parent, prefix="initramfs-") as tmp:
        work = Path(tmp)
        root = work / "root"
        images = work / "images"
        images.mkdir()
        for name in ("bin", "dev", "proc", "sys", "tmp", "etc", "opt/rocjitsu/bin"):
            (root / name).mkdir(parents=True, exist_ok=True)
        busybox = Path(shutil.which("busybox") or "/usr/bin/busybox")
        if "INTERP" in subprocess.check_output(["readelf", "-lW", busybox], text=True):
            raise ValueError("Install busybox-static for the guest initramfs")
        shutil.copy2(busybox, root / "bin/busybox")
        (root / "etc/hosts").write_text("127.0.0.1 localhost\n")
        shutil.copytree(base / "modules", root / "modules")
        firmware = root / "lib/firmware/amdgpu"
        generate(firmware)
        subprocess.run(
            [
                sim / "tools/rj-ip-discovery/rj-ip-discovery",
                "gfx1250",
                firmware / "ip_discovery.bin",
            ],
            check=True,
        )
        ids = Path("/usr/share/libdrm/amdgpu.ids")
        if ids.is_file():
            (root / "usr/share/libdrm").mkdir(parents=True)
            shutil.copy2(ids, root / "usr/share/libdrm")
        probe = work / "hip_owner_peer_refetch"
        subprocess.run(
            [
                sdk / "lib/llvm/bin/amdclang++",
                "-x",
                "hip",
                f"--rocm-path={sdk}",
                "--offload-arch=gfx1250",
                "-O2",
                assets / "hip_owner_peer_refetch.cpp",
                "-o",
                probe,
            ],
            check=True,
        )
        rank = sim / "tests/hip_rccl_gfx1250_test"
        libraries = {}
        inputs = {
            key: os.path.relpath(base / path, out)
            for key, path in (
                ("qemu", "qemu/bin/qemu-system-x86_64"),
                ("kernel", "vmlinuz"),
                ("driver_module", "modules/amdgpu.ko"),
                ("driver_source", "amdgpu-source.tar.gz"),
            )
        }
        for case, binary, init in (
            ("peer", probe, "hip_owner_peer_refetch_init"),
            ("pod", rank, "rccl_pod_init"),
        ):
            copy_dependencies(binary, root, libraries, sdk)
            if case == "pod":
                stage_rccl_code(root, sdk, libraries)
            executable = root / "opt/rocjitsu/bin" / binary.name
            shutil.copy2(binary, executable)
            shutil.copy2(assets / init, root / "init")
            archive = images / f"{case}.cpio.gz"
            with archive.open("wb") as output:
                subprocess.run(
                    [
                        "bash",
                        "-o",
                        "pipefail",
                        "-c",
                        "find . -print0 | cpio --null --quiet -o -H newc --owner=0:0 | pigz -1",
                    ],
                    cwd=root,
                    stdout=output,
                    check=True,
                )
            inputs[case + "_initramfs"] = archive.name
            executable.unlink()
        (images / "inputs.json").write_text(json.dumps(inputs, indent=2) + "\n")
        images.rename(out)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("base", "rocm", "build", "output"):
        parser.add_argument("--" + name, type=Path, required=True)
    build(parser.parse_args())
