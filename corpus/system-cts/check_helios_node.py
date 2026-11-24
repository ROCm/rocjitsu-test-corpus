# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Check the runtime-visible MI455X pair for one Helios-like logical node."""

import ctypes
import os
from pathlib import Path
import sys


def check(node):
    expected = (1250 + 2 * node, 1251 + 2 * node)
    topology = Path("/sys/class/kfd/kfd/topology/nodes")
    fd = os.open("/dev/kfd", os.O_RDWR)
    try:
        devices = []
        for directory in topology.iterdir():
            gpu = int((directory / "gpu_id").read_text())
            if gpu == 0:
                continue
            properties = dict(
                line.split()
                for line in (directory / "properties").read_text().splitlines()
            )
            devices.append(
                (
                    gpu,
                    (directory / "name").read_text().strip(),
                    int(properties["gfx_target_version"]),
                    int(properties["device_id"]),
                    int(properties["unique_id"]),
                )
            )
        wanted = [(gpu, "AMD Instinct MI455X", 120500, 0x75C1, gpu) for gpu in expected]
        if sorted(devices) != wanted:
            raise RuntimeError(f"node{node}: expected {wanted}, discovered {devices}")
        count = ctypes.c_int()
        status = ctypes.CDLL("libamdhip64.so").hipGetDeviceCount(ctypes.byref(count))
        if status or count.value != 2:
            raise RuntimeError(
                f"node{node}: hipGetDeviceCount returned {status}, count {count.value}"
            )
        print(f"node{node}: two HIP devices, MI455X GPU IDs {expected}")
    finally:
        os.close(fd)


if __name__ == "__main__":
    check(int(sys.argv[1]))
