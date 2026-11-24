#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""Run one system workload with a fresh output directory and the selected rocjitsu build."""

import argparse
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "case", choices=("Network", "EmulatedPod", "GuestPeer", "GuestPod")
    )
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument("--rocjitsu", type=Path, required=True)
    parser.add_argument("--rank", type=Path, required=True)
    parser.add_argument("--guest-inputs", type=Path)
    args = parser.parse_args()
    source = args.source.resolve(strict=True)
    scripts = source / "scripts"
    config = source / "configs"
    log_root = os.environ.get("ROCJITSU_CTS_LOG_DIR")
    if log_root:
        Path(log_root).mkdir(parents=True, exist_ok=True)
    output = Path(tempfile.mkdtemp(prefix=f"{args.case}-", dir=log_root)) / "run"
    print(f"Workload logs: {output}", flush=True)
    common = ["--rocjitsu", args.rocjitsu.resolve(strict=True), "--output", output]
    if args.case == "Network":
        command = [
            scripts / "run-rccl-scaleout.py",
            "--config",
            config / "gfx1250_mi455x_kmd_2node_net.json",
            "--rank-binary",
            args.rank,
            "--node",
            "node0",
            "--node",
            "node1",
            "--gtest-filter",
            "RcclTest.*",
            "--seed",
            "79",
        ]
    else:
        common += ["--config", config / "gfx1250_mi455x_kmd_4node_2gpu_if.json"]
        if args.case == "EmulatedPod":
            # The pod checks HIP IPC peer channels. RCCL also supports VMM handles on gfx1250.
            os.environ["NCCL_CUMEM_ENABLE"] = "0"
            command = [scripts / "run-rccl-pod-emulated.py", "--rank-binary", args.rank]
        else:
            if not args.guest_inputs:
                parser.error(
                    "select the guest artifact manifest with ROCJITSU_CTS_GUEST_INPUTS"
                )
            manifest = args.guest_inputs.resolve(strict=True)
            inputs = json.loads(manifest.read_text())

            def artifact(name):
                return (manifest.parent / inputs[name]).resolve(strict=True)

            common += ["--qemu", artifact("qemu"), "--kernel", artifact("kernel")]
            if args.case == "GuestPeer":
                command = [
                    scripts / "run-vfio-guest.py",
                    "--node",
                    "node0",
                    "--initramfs",
                    artifact("peer_initramfs"),
                    "--socket",
                    output / "gpu0.sock",
                    "--socket",
                    output / "gpu1.sock",
                    "--accel",
                    "tcg",
                    "--smp",
                    "2",
                    "--memory",
                    "12G",
                    "--p2v-switch-topology",
                    "--p2v-atomic-root",
                    "--fabric-effect-trace",
                    "--append",
                    "console=ttyS0 rdinit=/init panic=-1 amdgpu.discovery=2 amdgpu.emu_mode=1 "
                    "amdgpu.fw_load_type=0 amdgpu.vm_update_mode=3 amdgpu.gpu_recovery=0 "
                    "amdgpu.vramlimit=1024 amdgpu.ip_block_mask=0x3f",
                    "--expect-log",
                    "guest: owner-peer-refetch PASS",
                    "--expect-log",
                    "fresh=0x2468ace0 expected_old=0x13579bdf expected_new=0x2468ace0 result=PASS",
                    "--reject-log",
                    "guest: owner-peer-refetch FAIL",
                    "--reject-log",
                    "Kernel panic",
                ]
            else:
                provenance = [
                    key for key in ("driver_source", "driver_package") if key in inputs
                ]
                if len(provenance) != 1:
                    parser.error(
                        "supply one guest driver source archive or driver package"
                    )
                driver_input = provenance[0]
                command = [
                    scripts / "run-rccl-pod-vfio.py",
                    "--initramfs",
                    artifact("pod_initramfs"),
                    "--driver-module",
                    artifact("driver_module"),
                    "--" + driver_input.replace("_", "-"),
                    artifact(driver_input),
                    "--rank-binary",
                    args.rank,
                ]
    subprocess.run([sys.executable, *command, *common], cwd=source, check=True)
    if args.case == "GuestPeer":
        log = (output / "server.log").read_text()
        if not re.search(
            r"committed fabric effect request=\d+ 1251 -> 1250: "
            r"op=write, backing_id=[1-9]\d*, offset=\d+, bytes=4\b",
            log,
        ):
            raise RuntimeError(f"Missing four-byte peer write in {output}/server.log")
        if not re.search(r"fabric effect trace captured=[1-9]\d*, dropped=0\b", log):
            raise RuntimeError(f"Incomplete fabric trace in {output}/server.log")
    return 0


if __name__ == "__main__":
    sys.exit(main())
