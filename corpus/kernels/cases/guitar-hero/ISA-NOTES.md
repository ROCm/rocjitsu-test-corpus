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
