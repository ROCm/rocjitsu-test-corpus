# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""
What removing a wait exposes, read from the committed assembly.

A wait retires memory operations that are still in flight. Removing it leaves
those operations unguarded until a later wait retires them, and the first
instruction in that window that depends on one of them is the hazard the
mutation injects. Its scoring tag follows from that dependency:

* an instruction that reads a register an exposed load still writes is a RAW
  on that register (``sgpr``, ``vgpr`` or ``agpr``); one that writes it first
  is a WAW;
* a DS access after an exposed tensor or asynchronous transfer into LDS is a
  RAW (a read) or WAW (a write) on ``lds``, and a DS write after an exposed
  transfer out of LDS is a WAR on ``lds``. Those transfers are not ordered with
  the wave's DS operations, while its DS operations complete in order, so one
  DS access never depends on an earlier one of the same wave;
* an LDS access still in flight at a workgroup barrier can race another
  wave's access after it: a ``LocalMemoryRace`` on ``lds``.

RAW, WAR and WAW name dependencies inside one wave, and ``LocalMemoryRace`` a
dependency between waves, which only a barrier creates here. A global memory
access in flight at a barrier would race between waves of one workgroup, which
the corpus vocabulary has no kind for, so it is rejected rather than tagged.

The analysis follows the listing in order, without following branches, and
treats every access to a memory space as possibly the same address. A site it
attributes wrongly is pinned with a ``[[case.tag]]`` override in
``cases.toml``, and one that exposes nothing is exempted.
"""

import re
from dataclasses import dataclass

import mutate

# The instruction at which a wave's earlier accesses must be complete for other
# waves to see them: s_barrier on gfx9, and s_barrier_signal on gfx12, whose
# s_barrier_wait only waits for the other waves.
_BARRIERS = ("s_barrier_signal", "s_barrier")
_BARRIER_WAIT = "s_barrier_wait"

# Instructions with no register destination: every register they name is read.
_NO_DESTINATION = (
    "s_cmp",
    "s_bitcmp",
    "s_cbranch",
    "s_branch",
    "s_nop",
    "s_endpgm",
    "s_barrier",
    "s_wait",
    "s_sleep",
    "s_setprio",
    "s_sendmsg",
    "s_delay_alu",
    "s_clause",
    "tensor_",
    "global_load_async",
    "global_store_async",
)

_DS_READS = ("ds_load", "ds_read", "ds_bpermute", "ds_permute", "ds_swizzle")
_DS_WRITES = ("ds_store", "ds_write")

# Transfers between LDS and global memory outside the DS queue: the prefix, the
# counter that tracks it, and whether it reads or writes LDS.
_ASYNC_LDS = (
    ("tensor_load_to_lds", "tensorcnt", False, True),
    ("tensor_store_from_lds", "tensorcnt", True, False),
    ("global_load_async_to_lds", "asynccnt", False, True),
    ("global_store_async_from_lds", "asynccnt", True, False),
)

# Vector memory instructions and the memory space they access. A flat address
# may be LDS too, which is why flat operations also count on the DS counter.
_VECTOR_MEMORY = (
    ("global_", "global"),
    ("buffer_", "global"),
    ("scratch_", "scratch"),
    ("flat_", "global"),
)

_REGISTER_RE = re.compile(r"^([sva])(?:(\d+)|\[(\d+):(\d+)\])$")
# How an atomic asks for the old value: gfx12's th:TH_ATOMIC_RETURN, gfx9's
# glc, and gfx940+'s sc0.
_ATOMIC_RETURN_RE = re.compile(r"TH_ATOMIC_RETURN|\bglc\b|\bsc0\b")


class AttributionError(ValueError):
    """A wait whose exposed operations the corpus has no tag for."""


@dataclass(frozen=True)
class Register:
    """A register range, such as ``v[2:3]``: its class and inclusive bounds."""

    kind: str  # "s", "v" or "a"
    low: int
    high: int

    def overlaps(self, other: "Register") -> bool:
        return (
            self.kind == other.kind
            and self.low <= other.high
            and other.low <= self.high
        )

    @property
    def resource(self) -> str:
        """The corpus resource this register is."""
        return {"s": "sgpr", "v": "vgpr", "a": "agpr"}[self.kind]


@dataclass(frozen=True)
class Instruction:
    """
    One instruction of a listing.

    Attributes:
        line: Its 0-based line in the listing.
        mnemonic: The first mnemonic on the line.
        text: Its signature; see mutate.signature.
        reads: The registers it reads.
        writes: The registers it writes.
    """

    line: int
    mnemonic: str
    text: str
    reads: tuple[Register, ...]
    writes: tuple[Register, ...]


@dataclass(frozen=True)
class MemoryOperation:
    """
    An instruction that is in flight until a wait retires it.

    Attributes:
        instruction: The instruction.
        counters: The wait counters it increments.
        space: The memory space it accesses: "lds", "global" or "scratch".
        writes_memory: Whether it writes that memory.
        async_lds: Whether it moves data to or from LDS outside the DS queue.
    """

    instruction: Instruction
    counters: frozenset[str]
    space: str
    writes_memory: bool
    async_lds: bool = False


@dataclass(frozen=True)
class Tag:
    """
    The scoring tag a mutation exposes.

    Attributes:
        resource: Where the hazard lands; see detector_protocol.RESOURCES.
        hazard: The hazard kind; see detector_protocol.HAZARD_KINDS.
        witness: The first instruction that depends on what the wait retired.
    """

    resource: str
    hazard: str
    witness: Instruction


def parse_register(token: str) -> Register | None:
    """The register *token* names, or None for a constant or special register."""
    match = _REGISTER_RE.match(token)
    if not match:
        return None
    if match.group(2) is not None:
        number = int(match.group(2))
        return Register(kind=match.group(1), low=number, high=number)
    return Register(
        kind=match.group(1), low=int(match.group(3)), high=int(match.group(4))
    )


def parse_instruction(line: int, raw: str) -> Instruction | None:
    """The instruction on *raw*, or None for a blank, comment, label or directive."""
    text = mutate.signature(raw)
    if not text or text.startswith(".") or text.endswith(":"):
        return None
    reads: list[Register] = []
    writes: list[Register] = []
    # A VOPD pair, "v_dual_x ... :: v_dual_y ...", issues two instructions.
    for half in text.split("::"):
        mnemonic, _, rest = half.strip().partition(" ")
        operands = [token.split()[0] for token in rest.split(",") if token.strip()]
        registers = [parse_register(token) for token in operands]
        written = _destination_count(mnemonic, operands, half)
        writes += [reg for reg in registers[:written] if reg is not None]
        reads += [reg for reg in registers[written:] if reg is not None]
    return Instruction(
        line=line,
        mnemonic=text.partition(" ")[0],
        text=text,
        reads=tuple(reads),
        writes=tuple(writes),
    )


def _destination_count(mnemonic: str, operands: list[str], text: str) -> int:
    """How many leading operands of the instruction *text* it writes."""
    if mnemonic.startswith(_NO_DESTINATION) or "_store" in mnemonic:
        return 0
    if mnemonic.startswith(_DS_WRITES):
        return 0
    if mnemonic.startswith("ds_") and not mnemonic.startswith(_DS_READS):
        return 1 if "_rtn" in mnemonic else 0
    if "_atomic_" in mnemonic:
        return 1 if _ATOMIC_RETURN_RE.search(text) else 0
    if mnemonic.startswith("v_cmpx"):
        # Writes EXEC; on gfx9 its e64 form also names an SGPR destination.
        first = parse_register(operands[0]) if operands else None
        return 1 if first is not None and first.kind == "s" else 0
    # A carry-out, or the second half of a 64-bit multiply-add, is a second
    # destination named second.
    if "_co_" in mnemonic or mnemonic.startswith(
        ("v_mad_u64", "v_mad_i64", "v_div_scale")
    ):
        return 2
    return 1


def memory_operation(instruction: Instruction, gfx9: bool) -> MemoryOperation | None:
    """*instruction* as an operation a wait retires, or None if it is not one."""
    name = instruction.mnemonic
    if name.startswith(("s_load", "s_buffer_load")):
        counter = "lgkmcnt" if gfx9 else "kmcnt"
        return MemoryOperation(instruction, frozenset({counter}), "global", False)
    if name.startswith("ds_"):
        counter = "lgkmcnt" if gfx9 else "dscnt"
        writes = not name.startswith(_DS_READS)
        return MemoryOperation(instruction, frozenset({counter}), "lds", writes)
    for prefix, counter, _, writes in _ASYNC_LDS:
        if name.startswith(prefix):
            return MemoryOperation(
                instruction, frozenset({counter}), "lds", writes, async_lds=True
            )
    for prefix, space in _VECTOR_MEMORY:
        if name.startswith(prefix):
            return _vector_operation(instruction, space, gfx9)
    return None


def _vector_operation(
    instruction: Instruction, space: str, gfx9: bool
) -> MemoryOperation:
    """A vector memory instruction: a load if it returns data, else a store."""
    returns_data = bool(instruction.writes)
    if gfx9:
        counters = {"vmcnt"}
    else:
        counters = {"loadcnt" if returns_data else "storecnt"}
    if instruction.mnemonic.startswith("flat_"):
        counters.add("lgkmcnt" if gfx9 else "dscnt")
    writes = "_store" in instruction.mnemonic or "_atomic_" in instruction.mnemonic
    return MemoryOperation(instruction, frozenset(counters), space, writes)


def _is_barrier(instruction: Instruction) -> bool:
    """Whether *instruction* is where this wave reaches a workgroup barrier."""
    return (
        instruction.mnemonic.startswith(_BARRIERS)
        and instruction.mnemonic != _BARRIER_WAIT
    )


def _is_wait(instruction: Instruction) -> bool:
    return (
        instruction.mnemonic.startswith("s_wait")
        and instruction.mnemonic != _BARRIER_WAIT
    )


def _retired(
    outstanding: list[MemoryOperation], limits: dict[str, int]
) -> list[MemoryOperation]:
    """
    The operations in *outstanding* that a wait with *limits* retires: for each
    counter, all but the *count* most recent operations it tracks.
    """
    retired: list[MemoryOperation] = []
    for counter, count in limits.items():
        counted = [op for op in outstanding if counter in op.counters]
        retired += counted[: max(0, len(counted) - count)]
    return [op for op in outstanding if op in retired]


def _step(
    instruction: Instruction, outstanding: list[MemoryOperation], gfx9: bool
) -> None:
    """Advance *outstanding* past *instruction*: retire or issue operations."""
    if _is_wait(instruction):
        for operation in _retired(outstanding, mutate.wait_limits(instruction.text)):
            outstanding.remove(operation)
    elif (operation := memory_operation(instruction, gfx9)) is not None:
        outstanding.append(operation)


def expose(lines: list[str], wait_line: int, target: str) -> Tag | None:
    """
    The tag of the hazard that removing the wait on 0-based *wait_line* of
    *lines*, a listing for *target*, exposes. None if the wait retires nothing,
    or nothing depends on what it retires before a later wait does.

    Raises AttributionError for a dependency the corpus has no tag for.
    """
    gfx9 = target.startswith("gfx9")
    instructions = [
        instruction
        for number, raw in enumerate(lines)
        if (instruction := parse_instruction(number, raw)) is not None
    ]
    outstanding: list[MemoryOperation] = []
    for instruction in instructions:
        if instruction.line >= wait_line:
            break
        _step(instruction, outstanding, gfx9)
    wait = next(i for i in instructions if i.line == wait_line)
    exposed = _retired(outstanding, mutate.wait_limits(wait.text))
    after = [i for i in instructions if i.line > wait_line]
    return _first_dependency(after, exposed, outstanding, gfx9)


def _first_dependency(
    after: list[Instruction],
    exposed: list[MemoryOperation],
    outstanding: list[MemoryOperation],
    gfx9: bool,
) -> Tag | None:
    """The first hazard an instruction of *after* has on an *exposed* operation."""
    for instruction in after:
        if not exposed or instruction.mnemonic == "s_endpgm":
            return None
        if (tag := _dependency(instruction, exposed)) is not None:
            return tag
        if _is_wait(instruction):
            retired = _retired(outstanding, mutate.wait_limits(instruction.text))
            exposed = [op for op in exposed if op not in retired]
        _step(instruction, outstanding, gfx9)
    return None


def _dependency(instruction: Instruction, exposed: list[MemoryOperation]) -> Tag | None:
    """The hazard *instruction* has on an exposed operation, if any."""
    destinations = [dest for op in exposed for dest in op.instruction.writes]
    for register in instruction.reads:
        if any(register.overlaps(dest) for dest in destinations):
            return Tag(resource=register.resource, hazard="RAW", witness=instruction)
    for register in instruction.writes:
        if any(register.overlaps(dest) for dest in destinations):
            return Tag(resource=register.resource, hazard="WAW", witness=instruction)
    if _is_barrier(instruction):
        return _barrier_dependency(instruction, exposed)
    if instruction.mnemonic.startswith("ds_"):
        return _async_lds_dependency(instruction, exposed)
    return None


def _barrier_dependency(
    barrier: Instruction, exposed: list[MemoryOperation]
) -> Tag | None:
    """The race between waves an operation still in flight at *barrier* opens."""
    if any(op.space == "lds" for op in exposed):
        return Tag(resource="lds", hazard="LocalMemoryRace", witness=barrier)
    if any(op.space == "global" and op.writes_memory for op in exposed):
        raise AttributionError(
            f"a global memory access is still in flight at {barrier.text!r}, which "
            f"races between waves of a workgroup; the corpus has no hazard kind for "
            f"that, so pin the site's tag with [[case.tag]]"
        )
    return None


def _async_lds_dependency(
    access: Instruction, exposed: list[MemoryOperation]
) -> Tag | None:
    """The hazard the DS *access* has on an exposed transfer to or from LDS."""
    reads = not access.mnemonic.startswith(_DS_WRITES)
    for operation in exposed:
        if not operation.async_lds:
            continue
        if operation.writes_memory:
            return Tag(resource="lds", hazard="RAW" if reads else "WAW", witness=access)
        if not reads:
            return Tag(resource="lds", hazard="WAR", witness=access)
    return None
