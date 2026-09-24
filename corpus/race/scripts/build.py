# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""
Taking committed assembly, and a mutant of it, down to an executable.

Following the ROCm assembly_to_executable flow, because a mutant only exists as
edited *assembly* -- there is no source to recompile::

    asm/<target>/<kernel>.s   (COMMITTED)
                  |
      [mutate: edit the assembly]
                  |
           clang -target amdgcn
                  |
     clang-offload-bundler -> .hipfb
                  |
        llvm-mc (.incbin embed)
                  |
    HIP source -- hipcc -c --cuda-host-only --> host .o ---- hipcc link
                                                   |              |
                                                   +--------------+--> exe

The device assembly is not compiled here. It is frozen in the repository and
regenerated only by ``regenerate_asm.py``, so a toolchain bump cannot silently
change how many mutation sites a kernel has.

hipcc is still needed for the host half, and that object cannot be committed
alongside the assembly: its fatbin symbol is a per-kernel hash
(``__hip_fatbin_<hash>``, read back with llvm-nm at embed time) and it is an
x86-64 object tied to the HIP runtime ABI it links against. Embedding under the
wrong symbol links cleanly but leaves the device code unreachable, so the kernel
silently does nothing.

The host object depends only on the kernel, so it is cached per kernel and
shared by all of that kernel's mutants; everything else is per mutant.
"""

from __future__ import annotations

import os
import re
import shutil
import subprocess
from dataclasses import dataclass
from pathlib import Path


class BuildError(RuntimeError):
    """A build step failed. Carries the failing tool's diagnostics."""


# --- Toolchain discovery -----------------------------------------------------


def rocm_path() -> Path:
    if (explicit := os.environ.get("ROCM_PATH") is not None):
        return Path(explicit)
    if shutil.which("rocm-sdk"):
        proc = subprocess.run(
            ["rocm-sdk", "path", "--root"], capture_output=True, text=True, check=False
        )
        if proc.returncode == 0 and proc.stdout.strip():
            return Path(proc.stdout.strip())
    if Path("/opt/rocm").is_dir():
        return Path("/opt/rocm")
    raise BuildError("set ROCM_PATH, or make rocm-sdk available on PATH")


@dataclass(frozen=True)
class Toolchain:
    root: Path
    hipcc: Path
    clang: Path
    bundler: Path
    llvm_mc: Path
    llvm_nm: Path

    @property
    def include(self) -> Path:
        return self.root / "include"


def resolve_toolchain() -> Toolchain:
    root = rocm_path()
    llvm_bin = root / "llvm" / "bin"

    def find(name: str, *candidates: Path) -> Path:
        for candidate in candidates:
            if candidate.is_file():
                return candidate
        found = shutil.which(name)
        if found:
            return Path(found)
        raise BuildError(f"{name} not found under {root}; set ROCM_PATH")

    return Toolchain(
        root=root,
        hipcc=find("hipcc", root / "bin" / "hipcc"),
        clang=find("clang", llvm_bin / "clang", root / "bin" / "clang"),
        bundler=find("clang-offload-bundler", llvm_bin / "clang-offload-bundler"),
        llvm_mc=find("llvm-mc", llvm_bin / "llvm-mc"),
        llvm_nm=find("llvm-nm", llvm_bin / "llvm-nm"),
    )


def _run(argv: list[str], step: str) -> subprocess.CompletedProcess:
    proc = subprocess.run(argv, capture_output=True, text=True, errors="replace", check=False)
    if proc.returncode != 0:
        raise BuildError(f"{step} failed:\n  {' '.join(argv)}\n{proc.stderr.strip()}")
    return proc


# --- Per-kernel steps, cached and shared across a kernel's mutants -----------


def compile_host_object(
    kernel: Path,
    out: Path,
    *,
    tools: Toolchain | None = None,
) -> Path:
    """``hipcc -c --cuda-host-only`` -- the host half, independent of mutation."""
    tools = tools or resolve_toolchain()
    out.parent.mkdir(parents=True, exist_ok=True)
    argv = [
        str(tools.hipcc),
        f"--rocm-path={tools.root}",
        "-c",
        "--cuda-host-only",
        str(kernel),
        "-o",
        str(out),
    ]
    if tools.include.is_dir():
        argv += ["-I", str(tools.include)]
    _run(argv, f"host object for {kernel.name}")
    return out


# --- Per-mutant steps --------------------------------------------------------


def assemble_device_object(asm: Path, target: str, out: Path, *, tools: Toolchain) -> Path:
    """Assemble the (possibly mutated) device assembly into a code object."""
    out.parent.mkdir(parents=True, exist_ok=True)
    _run(
        [
            str(tools.clang),
            "-target",
            "amdgcn-amd-amdhsa",
            f"-mcpu={target}",
            str(asm),
            "-o",
            str(out),
        ],
        f"assembling {asm.name}",
    )
    return out


def create_offload_bundle(device_obj: Path, target: str, out: Path, *, tools: Toolchain) -> Path:
    targets = f"host-x86_64-unknown-linux-gnu,hipv4-amdgcn-amd-amdhsa--{target}"
    _run(
        [
            str(tools.bundler),
            "-type=o",
            "-bundle-align=4096",
            f"-targets={targets}",
            "-input=/dev/null",
            f"-input={device_obj}",
            f"-output={out}",
        ],
        f"bundling {device_obj.name}",
    )
    return out


def fatbin_symbol(host_obj: Path, *, tools: Toolchain) -> str:
    """
    The ``__hip_fatbin*`` symbol this host object expects.

    Not always plain ``__hip_fatbin``: the runtime may suffix it, and embedding
    under the wrong name links cleanly but leaves the device code unreachable,
    so the kernel silently does nothing.
    """
    proc = subprocess.run(
        [str(tools.llvm_nm), str(host_obj)], capture_output=True, text=True, check=False
    )
    if proc.returncode != 0:
        proc = subprocess.run(["nm", str(host_obj)], capture_output=True, text=True, check=False)
    for line in proc.stdout.splitlines():
        match = re.search(r"\b(__hip_fatbin\w*)\b", line)
        if match and "wrapper" not in match.group(1):
            return match.group(1)
    return "__hip_fatbin"


def embed_fatbin(bundle: Path, symbol: str, workdir: Path, out: Path, *, tools: Toolchain) -> Path:
    """Wrap the bundle in a host object via ``.incbin`` under *symbol*."""
    mcin = workdir / "hip_obj_gen.mcin"
    mcin.write_text(
        f"    .type {symbol},@object\n"
        '    .section .hip_fatbin,"a",@progbits\n'
        f"    .globl {symbol}\n"
        "    .p2align 12\n"
        f"{symbol}:\n"
        f'    .incbin "{bundle}"\n'
    )
    _run(
        [
            str(tools.llvm_mc),
            "-triple",
            "x86_64-unknown-linux-gnu",
            "-o",
            str(out),
            str(mcin),
            "--filetype=obj",
        ],
        f"embedding {bundle.name}",
    )
    return out


def link_executable(host_obj: Path, fatbin_obj: Path, out: Path, *, tools: Toolchain) -> Path:
    """
    Link host and fatbin objects.

    ``--no-offload-new-driver`` keeps hipcc from re-processing the device code
    that was just hand-assembled, which would discard the mutation. Older hipcc
    does not accept the flag, hence the fallback.
    """
    common = [
        "-o",
        str(out),
        str(host_obj),
        str(fatbin_obj),
        f"--rocm-path={tools.root}",
        f"-L{tools.root}/lib",
        f"-Wl,-rpath,{tools.root}/lib",
    ]
    proc = subprocess.run(
        [str(tools.hipcc), "--no-offload-new-driver", *common],
        capture_output=True,
        text=True,
        errors="replace",
        check=False,
    )
    if proc.returncode != 0:
        proc = subprocess.run(
            [str(tools.hipcc), *common],
            capture_output=True,
            text=True,
            errors="replace",
            check=False,
        )
    if proc.returncode != 0:
        raise BuildError(f"linking {out.name} failed:\n{proc.stderr.strip()}")
    return out


@dataclass(frozen=True)
class BuiltMutant:
    asm: Path
    code_object: Path
    executable: Path


def build_from_asm(
    asm: Path,
    host_obj: Path,
    target: str,
    workdir: Path,
    *,
    tools: Toolchain | None = None,
    link: bool = True,
) -> BuiltMutant:
    """
    Take edited assembly through to an executable.

    With ``link=False`` it stops after the code object, which is all a static
    detector needs -- that is what lets the suite run one under
    ``--skip-all-runs`` with no linking at all.
    """
    tools = tools or resolve_toolchain()
    workdir.mkdir(parents=True, exist_ok=True)
    stem = asm.stem

    device_obj = assemble_device_object(asm, target, workdir / f"{stem}_dev.o", tools=tools)
    if not link:
        return BuiltMutant(asm=asm, code_object=device_obj, executable=None)  # type: ignore[arg-type]

    bundle = create_offload_bundle(device_obj, target, workdir / f"{stem}.hipfb", tools=tools)
    symbol = fatbin_symbol(host_obj, tools=tools)
    fatbin_obj = embed_fatbin(
        bundle, symbol, workdir, workdir / f"{stem}_fatbin.o", tools=tools
    )
    executable = link_executable(host_obj, fatbin_obj, workdir / stem, tools=tools)
    return BuiltMutant(asm=asm, code_object=device_obj, executable=executable)
