# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""
Assembly mutation engine for the race corpus.

Two mutation kinds turn a correct kernel into one with a known injected defect:

``wait``
    Replace one ``s_wait_*`` with ``s_nop``. Whatever that wait was ordering is
    now unguarded, so a detector should report a hazard at that point.

``memory``
    Rewrite one sub-dword load as a store to the same address. A byte *read*
    turned into a byte *write* is the single edit that makes an otherwise
    race-free all-reads kernel racy, since the new writer must race the byte's
    foreign readers.

A mutation is identified by its **ordinal** -- its index into the sites this
module finds, in the order it finds them -- rather than by a line number. Both
would address the committed assembly under ``asm/`` equally well, since that is
frozen. The ordinal is kept because it degrades more gracefully when the
assembly is regenerated: an edit that shifts code around without changing the
number of waits leaves every recipe still pointing at the same instruction.

A site is pinned by its **signature**: the instruction without its comment,
whitespace collapsed, such as ``s_waitcnt lgkmcnt(0)``. Exemptions and tag
overrides in ``cases.toml`` name the signature they were checked against, and
``pin_mismatch`` is the one check both ``check_cases.py`` and ``generate.py``
apply to them, so an ordinal that moves onto a different instruction -- even
one with the same mnemonic -- is caught.

This module is deliberately free of any simulator, detector, or ROCm dependency:
it reads text and writes text. The interface a detector implements is in
``detector_protocol.py``.
"""

import re
from dataclasses import dataclass
from pathlib import Path

MUTATION_KIND_WAIT = "wait"
MUTATION_KIND_MEMORY = "memory"
VALID_MUTATION_KINDS = frozenset({MUTATION_KIND_WAIT, MUTATION_KIND_MEMORY})

# s_wait_xcnt is excluded as a scope choice, not because removing it is
# harmless. XCNT tracks memory instructions whose address translation may still
# be replayed (XNACK replay), and a replayed instruction needs its address and
# descriptor source registers again. A wait on XCNT therefore guards a
# source-register hazard: LLVM's SIInsertWaitcnts places one before a register
# definition that would overwrite such a source. In asm/gfx1250/add_buffer.s,
# s_wait_xcnt 0x1 precedes the s_or_b64 that overwrites s[0:1], part of the
# buffer descriptor an earlier buffer_load_b32 may still need on replay.
# Removing the wait matters only when a translation is actually replayed, and
# on targets without shader XNACK replay the instruction is a NOP. The detectors
# this corpus scores check data-completion hazards, so these waits are not
# mutation sites. Pass an empty set to include them.
DEFAULT_EXCLUDED_WAITS = frozenset({"s_wait_xcnt"})

_WAIT_RE = re.compile(r"(s_wait\w+)\s+(\S.*)")

# Counter fields named inside a gfx9-era combined s_waitcnt operand.
_LEGACY_FIELD_RE = re.compile(r"\b(vmcnt|lgkmcnt|expcnt|vscnt)\((\d+)\)")


def signature(line: str) -> str:
    """*line*'s instruction without its comment, whitespace collapsed."""
    return " ".join(line.split(";", 1)[0].split())


def wait_limits(instruction: str) -> dict[str, int]:
    """
    Each counter the wait *instruction* waits on, and the count it waits for.

    gfx9 names its counters in the operand of a combined ``s_waitcnt``
    (``vmcnt(0) lgkmcnt(1)``); gfx10+ names one in the mnemonic
    (``s_wait_loadcnt 0x0``) or two (``s_wait_loadcnt_dscnt 0x0``), which share
    the one count. Counters are spelled as the target spells them.
    """
    text = signature(instruction)
    mnemonic, _, operand = text.partition(" ")
    if mnemonic == "s_waitcnt":
        return {name: int(count) for name, count in _LEGACY_FIELD_RE.findall(operand)}
    suffix = mnemonic.removeprefix("s_waitcnt_").removeprefix("s_wait_")
    counters = [part for part in suffix.split("_") if part.endswith("cnt")]
    count = operand.split(",")[-1].strip()
    return {counter: int(count, 0) for counter in counters}


@dataclass(frozen=True)
class WaitSite:
    """One ``s_wait_*`` instruction that the ``wait`` mutation can remove."""

    ordinal: int  # index into the file's wait list, the stable identifier
    line_number: int  # 0-based, derived per-compilation
    mnemonic: str  # e.g. "s_wait_loadcnt"
    operand: str  # e.g. "0x0" or "vmcnt(0) lgkmcnt(0)", without its comment
    full_line: str  # original line text, without trailing newline

    @property
    def signature(self) -> str:
        """The instruction, as an exemption or tag override pins it."""
        return signature(self.full_line)

    @property
    def counters(self) -> frozenset[str]:
        """The counters this wait drains; a wait naming two drains both."""
        return frozenset(wait_limits(self.full_line))


@dataclass(frozen=True)
class MemorySite:
    """One sub-dword load that the ``memory`` mutation can rewrite as a store."""

    ordinal: int  # index into the file's sub-dword load list
    line_number: int  # 0-based, derived per-compilation
    load_mnemonic: str  # e.g. "flat_load_ubyte"
    store_mnemonic: str  # e.g. "flat_store_byte"
    full_line: str  # original line text, without trailing newline
    rewritten_line: str  # the store that replaces it, without indent or newline

    @property
    def signature(self) -> str:
        """The load, as an exemption or tag override pins it."""
        return signature(self.full_line)


# Sub-dword (byte / short) load mnemonics mapped to the store that writes the
# same operand width. Full-dword loads are deliberately absent: they cannot
# expose a sub-dword eviction gap. Legacy and _bN spellings both appear because
# the compiler emits either depending on the pointer type, and the store
# spelling is matched to the load's family (flat vs global) and era. d16
# half-register loads are omitted, since their store side writes only part of
# the data register and needs different operands.
SUBDWORD_LOAD_TO_STORE = {
    # byte, legacy spelling
    "flat_load_ubyte": "flat_store_byte",
    "flat_load_sbyte": "flat_store_byte",
    "global_load_ubyte": "global_store_byte",
    "global_load_sbyte": "global_store_byte",
    # byte, bN spelling
    "flat_load_u8": "flat_store_b8",
    "flat_load_i8": "flat_store_b8",
    "global_load_u8": "global_store_b8",
    "global_load_i8": "global_store_b8",
    # short, legacy spelling
    "flat_load_ushort": "flat_store_short",
    "flat_load_sshort": "flat_store_short",
    "global_load_ushort": "global_store_short",
    "global_load_sshort": "global_store_short",
    # short, bN spelling
    "flat_load_u16": "flat_store_b16",
    "flat_load_i16": "flat_store_b16",
    "global_load_u16": "global_store_b16",
    "global_load_i16": "global_store_b16",
}

_SUBDWORD_LOAD_RE = re.compile(
    r"^\s*(" + "|".join(re.escape(m) for m in SUBDWORD_LOAD_TO_STORE) + r")\b\s+(.*)$"
)


def _is_code(stripped: str) -> bool:
    """False for comments and assembler directives, which are never mutated."""
    return not (stripped.startswith(";") or stripped.startswith("."))


def find_wait_sites(
    asm_path: Path,
    excluded_waits: frozenset[str] | None = None,
) -> list[WaitSite]:
    """Every ``s_wait_*`` in *asm_path*, in emission order, ordinals assigned."""
    exclude = DEFAULT_EXCLUDED_WAITS if excluded_waits is None else excluded_waits
    sites: list[WaitSite] = []
    for idx, line in enumerate(asm_path.read_text().splitlines()):
        stripped = line.strip()
        if not _is_code(stripped):
            continue
        match = _WAIT_RE.match(stripped)
        if not match or match.group(1) in exclude:
            continue
        sites.append(
            WaitSite(
                ordinal=len(sites),
                line_number=idx,
                mnemonic=match.group(1),
                operand=signature(match.group(2)),
                full_line=line.rstrip(),
            )
        )
    return sites


def _rewrite_load_to_store(store_mnemonic: str, operands: str) -> str:
    """
    Rewrite a sub-dword load's operands for its store counterpart.

    A load reads into its first operand from the address in the following
    operand(s); the store writes the same register to the same address, so the
    first two operands swap and everything after (a scalar base, ``offset:``,
    cache flags) is preserved verbatim::

        flat_load_ubyte   v0, v[0:1] offset:1 sc0 sc1
            -> flat_store_byte  v[0:1], v0 offset:1 sc0 sc1
        global_load_ubyte v0, v2, s[0:1] offset:1
            -> global_store_byte v2, v0, s[0:1] offset:1

    The load's destination register is reused as the store's data source; its
    contents do not matter, since what is being exercised is only that the byte
    was written.
    """
    parts = [p.strip() for p in operands.split(",")]
    # Trailing modifiers (offset:, sc0, nt, ...) hang off the last operand with
    # no comma, so split them away from that register token.
    last_tokens = parts[-1].split()
    regs = parts[:-1] + [last_tokens[0]]
    modifiers = " ".join(last_tokens[1:])

    vdst, vaddr, *rest = regs
    new_operands = ", ".join([vaddr, vdst, *rest])
    if modifiers:
        new_operands += " " + modifiers
    return f"{store_mnemonic} {new_operands}"


def find_memory_sites(asm_path: Path) -> list[MemorySite]:
    """Every sub-dword load in *asm_path* that can be flipped to a store."""
    sites: list[MemorySite] = []
    for idx, line in enumerate(asm_path.read_text().splitlines()):
        stripped = line.strip()
        if not _is_code(stripped):
            continue
        match = _SUBDWORD_LOAD_RE.match(stripped)
        if not match:
            continue
        load_mnemonic = match.group(1)
        store_mnemonic = SUBDWORD_LOAD_TO_STORE[load_mnemonic]
        sites.append(
            MemorySite(
                ordinal=len(sites),
                line_number=idx,
                load_mnemonic=load_mnemonic,
                store_mnemonic=store_mnemonic,
                full_line=line.rstrip(),
                rewritten_line=_rewrite_load_to_store(store_mnemonic, match.group(2)),
            )
        )
    return sites


def find_sites(
    asm_path: Path,
    kind: str,
    excluded_waits: frozenset[str] | None = None,
) -> list[WaitSite] | list[MemorySite]:
    """Sites of the given mutation *kind*, dispatching to the right finder."""
    if kind == MUTATION_KIND_WAIT:
        return find_wait_sites(asm_path, excluded_waits)
    if kind == MUTATION_KIND_MEMORY:
        return find_memory_sites(asm_path)
    raise ValueError(
        f"unknown mutation kind {kind!r}; known: {', '.join(sorted(VALID_MUTATION_KINDS))}"
    )


class StaleOrdinalError(LookupError):
    """
    A recipe names a site that the committed assembly does not contain.

    The recipes in ``mutants.toml`` are generated from the committed assembly,
    so an ordinal out of range means the two disagree: the assembly was
    regenerated, or the manifest edited, without the other. That is a corpus
    defect, and a caller fails on it rather than skipping the mutant.
    """


def _site_at(
    sites: list[WaitSite] | list[MemorySite], ordinal: int, kind: str, asm_path: Path
) -> WaitSite | MemorySite:
    if ordinal < len(sites):
        return sites[ordinal]
    raise StaleOrdinalError(
        f"{asm_path.name}: {kind} ordinal {ordinal} is out of range; the assembly "
        f"has {len(sites)} {kind} site(s), so it and mutants.toml disagree. "
        f"Regenerate the manifest with python corpus/race/scripts/generate.py."
    )


def pin_mismatch(
    sites: list[WaitSite] | list[MemorySite], ordinal: int, pinned: str, listing: str
) -> str | None:
    """
    Why the site *ordinal* of *sites*, from *listing*, is not the instruction
    *pinned*, a signature; or None if it is.
    """
    if ordinal >= len(sites):
        return (
            f"ordinal {ordinal} is out of range; {listing} has {len(sites)} such sites"
        )
    site = sites[ordinal]
    if site.signature != pinned:
        return (
            f"ordinal {ordinal} is {site.signature!r} at {listing}:"
            f"{site.line_number + 1}, not {pinned!r}"
        )
    return None


def apply_wait_mutation(asm_path: Path, ordinal: int, output: Path) -> WaitSite:
    """
    Write *output*: a copy of *asm_path* with wait *ordinal* replaced by s_nop.

    The removed instruction is preserved as a trailing comment so the mutant
    stays readable, and so a detector's report can be related to what was taken
    away.
    """
    sites = find_wait_sites(asm_path)
    site = _site_at(sites, ordinal, MUTATION_KIND_WAIT, asm_path)

    lines = asm_path.read_text().splitlines(keepends=True)
    original = lines[site.line_number].rstrip()
    lines[site.line_number] = f"\ts_nop 0  ; MUTANT: removed {original.strip()}\n"
    output.write_text("".join(lines))
    return site


def apply_memory_mutation(asm_path: Path, ordinal: int, output: Path) -> MemorySite:
    """
    Write *output*: a copy of *asm_path* with sub-dword load *ordinal* rewritten
    as the store to the same address.
    """
    sites = find_memory_sites(asm_path)
    site = _site_at(sites, ordinal, MUTATION_KIND_MEMORY, asm_path)

    lines = asm_path.read_text().splitlines(keepends=True)
    original = lines[site.line_number]
    indent = original[: len(original) - len(original.lstrip())]
    lines[site.line_number] = (
        f"{indent}{site.rewritten_line}  ; MUTANT: load->store {site.full_line.strip()}\n"
    )
    output.write_text("".join(lines))
    return site


def apply_mutation(
    asm_path: Path,
    kind: str,
    ordinal: int,
    output: Path,
) -> WaitSite | MemorySite:
    """Apply one mutation of *kind* at *ordinal*, writing to *output*."""
    if kind == MUTATION_KIND_WAIT:
        return apply_wait_mutation(asm_path, ordinal, output)
    if kind == MUTATION_KIND_MEMORY:
        return apply_memory_mutation(asm_path, ordinal, output)
    raise ValueError(
        f"unknown mutation kind {kind!r}; known: {', '.join(sorted(VALID_MUTATION_KINDS))}"
    )
