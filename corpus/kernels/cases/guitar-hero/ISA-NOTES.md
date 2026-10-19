# Target-specific ISA notes

See the shared [README](README.md) for the harness, checkpoint diagnostics and
timing limits. These notes describe differences between variants; the assembly
defines the exact inputs. No saved expected outputs are included.

## RDNA4

Both gfx1201 variants share one assembly source and code object, with separate
entry points and runner configurations. The build assembles each entry in
its strict wave mode because the SDK's mixed-wave parser rejects some sparse
WMMA selectors. Both include all eleven dense and eleven sparse gfx1201 WMMA
mnemonics, plus FP8/BF8 conversions and dot products, scalar floating-point ALU,
pseudo-scalar operations and selected formatted buffers. Stochastic conversions
use explicit deterministic random-bit inputs. Each lane has 64 bytes of scratch.

Wave64 uses 64-bit EXEC and condition/carry masks, recording each half without
clobbering VCC. Its probes cover cross-half permutations, lane 63 and a full-wave
reduction. LDS exchange occurs between halves of one wave rather than between
the wave32 entry's two waves. WMMA uses wave64 operand shapes. Wave32-only VOPD
sections become sequential VALU checkpoints named `serial_valu` and
`serial_valu_complete`; both entries keep the same checkpoint positions.

Development-time manual captures on R9700 covered 1, 7 and 256 groups, including
256 groups over 20 launches. Independent arithmetic and true16 DPP8 checks were
manual qualification, not committed automated tests. Checkpoints 639–640
exercise packed-dot DPP permutations. The shipped smoke has no hardware oracle.

## RDNA2

The gfx1030 variant is an independent wave32 source port of the gfx1100 case,
audited against the RDNA2 manual and instruction inventory and assembled with
`-mcpu=gfx1030 -mno-wavefrontsize64`. It keeps the gfx10 ABI: s0:s1 holds the
kernarg pointer and the workgroup ID from s2 is preserved in s48. Each 64-item
group contains two waves and owns 4 KiB of LDS/workspace. The 40-byte kernarg,
64-byte private segment per lane, rolling hashes, bounded EXEC regions, dumps
and checkpoint stopping are unchanged.

RDNA3-only WMMA, VOPD, BF16-dot and global-addtid sections are removed. The port
retains F16 and integer packed dots, DPP8/DPP16, DS addtid, scalar/vector ALU,
memory, atomics and divergent control flow. The RDNA3 `v_dot2acc_f32_f16`
probes use the gfx10 `v_dot2c_f32_f16` spelling; LDS floating compare/store uses
`ds_cmpst_*`, and floating flat/buffer compare-and-swap uses
`*_atomic_fcmpswap`. Compare and replacement operands follow the gfx10 layouts.

Store completion uses `s_waitcnt_vscnt`; VMEM, LDS and scalar observations use
the applicable VM/LGKM waits. The split VM, LGKM, EXP and dependency waits and
`buffer_gl0_inv`, `buffer_gl1_inv` and `s_gl1_inv` cache operations are retained
and followed by a checked load.

The final inventory has 489 checkpoints. Qualification covers successful
gfx1030 assembly, code-object/runner build and host structural checks; no
gfx1030 runtime capture or expected-output oracle is committed. Wave64 is
supported by the architecture but remains deferred and unqualified.

## RDNA3

The gfx1100 wave32 port was exercised on W7900 during development. Its audit
compared RDNA3/RDNA4 manuals, inventories and LLVM assembler tests in both directions, then assembled
candidates with the same SDK. Operand/cache-modifier rejection was distinguished
from an unavailable mnemonic. This is a maintained source port, not translation.

| RDNA3 forms absent from gfx1201 | Treatment |
| --- | --- |
| `S_CMPK_{EQ,LG,GT,GE,LT,LE}_{I32,U32}` | All twelve immediate comparisons; SCC is checkpointed. |
| `V_DOT2ACC_F32_F16` | Compact plain, DPP16 and DPP8 forms. |
| `V_FMAC_DX9_ZERO_F32` | Compact and extended standalone forms. |
| Typed `V_CMPX_F` / `V_CMPX_T` | Applicable widths and encodings; EXEC observed after reconvergence. |
| `DS_CMPSTORE_F32/F64` | Returning forms, partial EXEC and lane-owned targets. |
| `FLAT_ATOMIC_CMPSWAP_F32`, `BUFFER_ATOMIC_CMPSWAP_F32` | Returning/nonreturning forms and checked memory. |
| `DS_WRAP_RTN_B32` | Per-lane LDS operation, without GDS. |
| `S_BARRIER`, older wait counters | Separate load/LDS/scalar and store waits. |
| `BUFFER_GL0_INV`, `BUFFER_GL1_INV`, `S_GL1_INV` | Cache operations followed by checked reads. |

The port removes unsupported FP8/BF8 operations, sparse WMMA, extra RDNA4 matrix
shapes, scalar floating-point ALU, pseudo-scalar VALU and other rejected forms.
It retains six dense WMMA families, using the larger RDNA3 register groups and
repeated matrix data across each 16-lane half. Packed results use eight VGPRs per
wave32 lane with explicit low/high-half selection, unlike RDNA4's layout.

The kernarg pointer uses s0:s1 and the workgroup ID is saved from s2; gfx1201
instead uses ttmp9. IEEE and DX10 clamping are explicit. MODE sections restore
entry policies. Scalar local calls checkpoint results rather than code addresses.
Each lane has 64 bytes of scratch. Manual hardware captures covered 1, 7 and
256 groups; those captures are not part of the shipped smoke.

Scalar carries, min/max, conditional subtraction and width spellings include
aliases or renames; VOPD min/max use gfx1100 spellings. GDS/GWS, ordered counts,
GS/debug operations, older prefetch-distance control and pixel termination remain
excluded. SDK-rejected forms, including extended READFIRSTLANE, are omitted.
RDNA4 wave64 coverage does not establish RDNA3 wave64 coverage.

## CDNA4

The gfx950 variant is wave64 only. It uses the gfx9 entry ABI, preserving the
workgroup ID from s2 in s68. The descriptor allocates 128 VGPRs, 48 AGPRs at
offset 128 and 80 SGPRs; s72:s79 hold hashed-loop state. Checkpoints consume
v16:v31 and v60:v61 hold rolling hashes. IEEE and DX10 clamping are explicit.
No private scratch is allocated.

MFMA replaces WMMA, covering VGPR/AGPR sources, dense and sparse floating forms,
scaled FP8/FP6/FP4 and accumulator transfers. Large fragments get a second
checkpoint. Lane, packed-element, index-set and scale-byte variation make controls
observable. Matrix operations use full EXEC. Software waits cover scalar masks,
DPP dependencies, division flags, transcendental forwarding, MODE, M0 and matrix
inputs, following the ISA tables and LLVM gfx950 hazard recognizer.

Memory uses gfx950 format/cache encodings; returning vector atomics use `sc0`.
LDS compare-and-store operand order differs from global/flat/buffer compare/swap.
Transpose probes use full EXEC, lane-varying data, permuted addresses and offsets
0/16, with distinct chunks at 0/16/32/48. B64 addresses satisfy eight-byte
alignment. B96 uses a conservative 16-byte layout without claiming its unresolved
numeric hardware alignment rule.

**No CDNA4 hardware was available.** Development-time simulator comparisons
found normal/forced-scalar agreement through checkpoint 1196 and a BF16 overflow
disagreement at checkpoint 1197. Ordinary BF16 products use finite inputs.
Sixteen disputed sparse-index cases occupy 1181–1196 so they do not contaminate
preceding checkpoints. Four also depend on resolving inconsistent index-set
widths in the manual. These observations are diagnostic; the shipped smoke
contains no expected values and does not validate architectural index selection.

Deliberate omissions retain their place in the complete coverage denominator:
the qualification simulator reports unimplemented handlers for all 52 scalar
atomic forms, seven `global_load_lds_*` forms and these sparse integer operations:

- `v_smfmac_i32_16x16x128_i8`
- `v_smfmac_i32_32x32x64_i8`
- `v_smfmac_i32_16x16x64_i8`
- `v_smfmac_i32_32x32x32_i8`

Additional boundary probes cover pre-boundary ROW_BCAST15/31 lanes with both
BOUND_CTRL values and source aliases. Raw buffer probes use an INVALID data
format with valid backing storage, observing a suppressed load, store and
returning atomic before rereading through a bound descriptor.

Physical timing and target-specific floating-point behavior remain unqualified.

## CDNA5

The gfx1250 variant is wave32 only, with two waves per 64-work-item group and
64 bytes of private scratch per lane. Use ordinary non-cluster dispatch, as the
HIP harness does: ttmp9 carries a cluster ID under cluster dispatch. Buffer
descriptors use CDNA5 byte-count packing and linear addressing.

The matrix sweep covers native dense/sparse WMMA and all 25 FP8/BF8/FP6/BF6/FP4
format pairs, varied A/B/C and ordered sparse indices, plus scale16/scale32 with
distinct per-byte/lane scales and scalar/vector/inline sources. Scalar scale
pairs use A=2 and B=4 so bypassing both changes the result. True16 DPP8 probes use
initialized v8/v9 high halves and observe preserved destination halves.

A BF16-output WMMA checkpoint uses zero products and positive/negative F32
midpoints, including even/odd retained mantissas and values on either side. It
observes nearest-even narrowing under the default round mode, separately from
multiplication; fixed rounding independently of MODE is not checked.

Scheduling is explicit: native entry issues an unclaused VMEM prefetch and sets
REPLAY_MODE; TRANS and V_PERM_PK16 have V_NOP successors, and V_PERM_PK16 sites
run under full EXEC; all 124 matrix sites
have eight VALU slots before dependent access. End padding uses S_CODE_END.
Vector-store/scalar-load observations use SE scope, completion waits and cache
invalidation. These ISA/LLVM-based guards are structurally checked, without
claiming complete physical pipeline qualification.

**No CDNA5 hardware was available.** Development-time normal/scalar simulator
captures agreed for all checkpoints and seeds. Selected CPU models and mutation
checks were manual qualification, not committed automated tests. There are no
saved expected values; simulator-mode agreement is not independent ISA proof.

Nonzero `index_key` cases are assembler/decoder probes: the public field table
reserves those bits, and the qualified simulator hardcodes key zero. Meaningful
sparse selection checks vary ordered index pairs instead. Nine key-zero sparse
8-bit cases disagree with the public A/B/index routing model; the simulator cites
different hardware-reference routing. This disagreement remains a diagnostic
limitation. Inline-zero scale probes are also provisional: the ISA's unit E8
scale interpretation is not independently qualified by these outputs.
Independent scale checks use vector and scalar sources.

Floating packed-dot and formatted-buffer forms removed from gfx1250 are omitted.
LLVM rejects dual floating-dot instructions despite SDK assembler acceptance.
Two assembler-supported `v_cvt_pk_f16_f32` DPP forms remain excluded because the
qualification decoder rejects them; the ordinary form is included.

Tensor DMA, asynchronous copies to LDS, transpose-memory loads (`global_load_tr*`
and `ds_load_tr*`), and cluster dispatch are outside this kernel's coverage.

MODE-write timing is not qualified on physical CDNA5 hardware; the field writes
in these sweeps do not add the two preceding VALU no-ops used by LLVM's whole
MODE-register hazard handling.
