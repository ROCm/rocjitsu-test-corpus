#!/usr/bin/env python3
"""Embed a linked, relocation-free AMDGPU ELF image using only Python stdlib.

Usage: embed_kernel.py INPUT_CODE_OBJECT OUTPUT_INCLUDE [--allow-scratch]
The input must contain cts_work.kd, use no scratch unless explicitly allowed,
and need at most 64 KiB
static LDS. Emit the load image, descriptor offset and segment sizes for our
native AQL dispatch tests. Parameters are build-time paths, not runtime options.
ELF/kernel descriptor reference: https://llvm.org/docs/AMDGPUUsage.html
"""
import pathlib
import struct
import sys

if len(sys.argv) not in (3, 4) or (len(sys.argv) == 4 and sys.argv[3] != "--allow-scratch"):
    raise SystemExit("usage: embed_kernel.py INPUT OUTPUT [--allow-scratch]")
source, output = map(pathlib.Path, sys.argv[1:3])
allow_scratch = len(sys.argv) == 4
data = source.read_bytes()
if data[:6] != b"\x7fELF\x02\x01" or struct.unpack_from("<H", data, 18)[0] != 224:
    raise SystemExit("expected little-endian ELF64 AMDGPU")
phoff, shoff = struct.unpack_from("<QQ", data, 32)
phsize, phnum, shsize, shnum = struct.unpack_from("<HHHH", data, 54)
if phsize != 56 or shsize != 64:
    raise SystemExit("unexpected ELF table layout")
segments = [struct.unpack_from("<IIQQQQQQ", data, phoff + i * phsize) for i in range(phnum)]
loads = [p for p in segments if p[0] == 1]
if not loads or min(p[3] for p in loads) != 0:
    raise SystemExit("expected zero-based load image")
extent = max(p[3] + p[6] for p in loads)
if extent > 1024 * 1024:
    raise SystemExit("unexpectedly large kernel")
image = bytearray(extent)
for _, _, offset, address, _, filesz, memsz, _ in loads:
    if offset + filesz > len(data) or filesz > memsz:
        raise SystemExit("invalid load segment")
    image[address:address + filesz] = data[offset:offset + filesz]
sections = [struct.unpack_from("<IIQQQQIIQQ", data, shoff + i * shsize) for i in range(shnum)]
descriptor = None
for section in sections:
    if section[1] in (4, 9) and section[5]:
        raise SystemExit("kernel has unresolved relocations")
    if section[1] != 2:
        continue
    strings = sections[section[6]]
    names = data[strings[4]:strings[4] + strings[5]]
    if section[9] != 24:
        raise SystemExit("invalid symbol table")
    for offset in range(section[4], section[4] + section[5], 24):
        name, _, _, _, value, size = struct.unpack_from("<IBBHQQ", data, offset)
        if names[name:].split(b"\0", 1)[0] == b"cts_work.kd":
            if size != 64:
                raise SystemExit("unexpected kernel descriptor size")
            descriptor = value
if descriptor is None or descriptor + 64 > len(image):
    raise SystemExit("missing kernel descriptor")
group, private, kernarg = struct.unpack_from("<III", image, descriptor)
if (private and not allow_scratch) or private > 65536 or group > 65536 or kernarg < 24:
    raise SystemExit("kernel needs scratch, exceeds 64 KiB LDS, or has wrong kernargs")
lines = ["// Generated from our linked kernel; do not edit.",
         f"constexpr unsigned kDescriptorOffset = {descriptor};",
         f"constexpr unsigned kKernargBytes = {kernarg};",
         f"constexpr unsigned kGroupBytes = {group};",
         f"constexpr unsigned kPrivateBytes = {private};",
         "constexpr unsigned char kKernelImage[] = {"]
lines += ["  " + ",".join(f"0x{x:02x}" for x in image[i:i + 16]) + "," for i in range(0, len(image), 16)]
output.write_text("\n".join(lines + ["};", ""]))
