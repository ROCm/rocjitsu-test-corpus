# Race-Detection Corpus

Small HIP kernels for scoring race and data-hazard detectors, with their device
assembly pinned per gfx target. Mutants are derived from the pinned assembly,
so the assembly, not the HIP source, is what the corpus is built on.

## Layout

```text
corpus/race/
  cases.toml              Kernel inventory and the corpus target set.
  kernels/<kernel>.hip    HIP source for each case.
  asm/<target>/<kernel>.s Pinned device assembly, one file per case and target.
  asm/<target>/recipe.toml How that target's assembly was regenerated.
  scripts/
    regenerate_asm.py     Regenerates asm/ from kernels/, or checks it for drift.
    check_cases.py        Checks cases.toml against kernels/ and asm/ (no compiler).
    inventory.py          Reads and validates cases.toml for both scripts.
    recipe.py             Reads, validates and writes recipe.toml for both scripts.
```

## `cases.toml`

`[corpus] targets` lists the gfx targets the corpus is built for. Both scripts
read it, so adding a target is a deliberate edit here.

Each `[[case]]` names one independently buildable kernel:

| Field | Meaning |
|---|---|
| `id` | Stable selector for the case. |
| `kernel` | Basename under `kernels/`, without `.hip`. |
| `targets` | The corpus targets the kernel builds for. Empty or absent means every corpus target. |
| `headers` | Optional. Headers outside ROCm's defaults that the kernel includes, such as `rocwmma/rocwmma.hpp`. |

## Why the assembly is pinned

The compiler decides how many `s_wait_*` instructions a kernel contains, and
mutants are derived from them. Compiling at test time would let a toolchain
update silently change the mutants. Pinning the assembly keeps the set of
injected defects fixed, and makes moving it onto newer codegen a reviewable
commit.

Pinning fixes the listing's text, not which assembler can read it. A listing
carries the SDK's assembler directives as well as its instructions, and a newer
assembler can reject one. For example, the gfx1250 listings set
`.amdhsa_wavefront_size32 1`, which the recorded SDK accepts and a newer
upstream LLVM rejects as unsupported on gfx1250. **Assemble the listings, and
the mutants derived from them, with the SDK recorded in the target's
`recipe.toml`** (below). Moving to another assembler is the same step as moving
to newer codegen: regenerate with its SDK, and commit the listings and recipe
together.

Each `.s` file keeps its `.ident` line, which names the compiler that produced
it. hipcc's per-invocation `__hip_cuid_<hash>` symbol is replaced with a fixed
placeholder, so regenerating with the same toolchain reproduces the committed
files exactly.

`.ident` names clang, but not the SDK or the flags, and different flags can
produce different code under the same `.ident`. So regenerating also writes
`asm/<target>/recipe.toml`, which records:

| Field | Meaning |
|---|---|
| `compiler` | `hipcc`, or `clang++` when the SDK's clang is used directly. |
| `compiler_version` | The `clang version` line of the compiler's `--version`. |
| `rocm_release` | The SDK's release, from its `.info/version`, such as `10.1.0`, or `unknown`. |
| `rocm_build` | The SDK's build, such as `10.1.0a20260822`: the version of the Python distributions that installed it, read from the selected installation. `unknown` for an SDK not installed that way, such as `/opt/rocm`. Two builds can share a release and a clang revision, so only the build tells them apart. |
| `flags` | The explicit flags: `-O3 -x hip`, then `--cxxflags` as the compiler receives them. A relative path, such as `-include options.h` or `-Iinclude`, is made absolute against the directory the script runs from, so running from another directory, where it selects a different file, changes the recipe. |

The recipe describes every listing in its target directory, and only those: a
target directory holds its listings and `recipe.toml`, nothing else. `--check`
compares builds only when both recipes know them, and otherwise says they cannot
be compared, rather than reporting a toolchain change.

## Regenerating the assembly

Regenerating is a manual step that needs a ROCm toolchain. Run it from the
repository root:

```bash
python corpus/race/scripts/regenerate_asm.py                    # every corpus target
python corpus/race/scripts/regenerate_asm.py --target gfx950    # one target
```

- **Toolchain.** The compiler comes from `ROCM_PATH`, else `rocm-sdk path
  --root`, else `/opt/rocm`. Within that SDK, `bin/hipcc` is used, falling back
  to `llvm/bin/clang++`. A compiler elsewhere, such as a `hipcc` on `PATH`, is
  never used: the recipe records the compiler's `--version`, so it must be the
  selected SDK's compiler that builds the listings. An SDK with neither is
  rejected (exit 4).
- **Extra flags.** `--cxxflags` passes extra compiler flags, split like shell
  words, so a path with spaces can be quoted:
  `--cxxflags='-I"/path/to/my headers"'`.
- **Whole targets.** Every case is compiled into a temporary directory first.
  A target is published only when all of its cases compiled: its new listings,
  exactly the ones its cases produce, and its `recipe.toml` are staged in a
  hidden directory beside it, which then replaces it. A listing of a removed
  case, or of a target a case no longer builds for, is not carried over. A
  target with a failed or skipped case, or whose staging fails, for example on
  a full disk, keeps all of its committed files. Other, complete targets are
  still published.
- **Interrupted runs.** The swap is two renames. A run killed between them
  leaves a hidden `.<target>.staging-*` or `.<target>.retired-*` directory
  under `asm/`, which the inventory check rejects as not a corpus target.
  Restore the target from git and regenerate it.
- **Optional headers.** A case that declares `headers` is skipped when a header
  is not found, and so its target is not updated (exit 3). The search covers
  ROCm's include directory and `-I`/`-isystem`/`-iquote` from `--cxxflags`.
- **Failures.** A kernel that fails to compile leaves its target as it was, and
  the compiler's diagnostic is printed (exit 2).
- **Environment.** Only the selected SDK and the recorded flags reach the
  compiler. Variables that would change the compile without being recorded are
  removed from its environment, with a note:
  - `HIPCC_COMPILE_FLAGS_APPEND`, `HIPCC_LINK_FLAGS_APPEND` and
    `CCC_OVERRIDE_OPTIONS`, which add to the compiler's command line;
  - `CPATH`, `CPLUS_INCLUDE_PATH` and `C_INCLUDE_PATH`, which add header
    directories;
  - hipcc's other `HIP_*` variables, such as `HIP_PATH`, and `DEVICE_LIB_PATH`,
    which point it at another SDK's parts.

  `ROCM_PATH` is set to the selected SDK. Pass extra flags and include
  directories with `--cxxflags`, which `recipe.toml` records.

Review the diff before committing. Where waits or loads moved, the mutants of
those kernels change with them. Then run the inventory check below.

## Checking for drift

```bash
python corpus/race/scripts/regenerate_asm.py --check
```

`--check` regenerates into a temporary directory, compares the result with the
committed assembly as text, and removes the directory. It also compares the
recipe it would write with each target's committed `recipe.toml`, and says
whether the recipe is unchanged, whether the flags changed (`recipe changed`),
or whether the compiler or SDK changed (`toolchain changed`). A committed recipe
that is invalid is reported as one that cannot be compared. That tells a
changed recipe apart from a toolchain update. The recipe comparison is
informational: the exit code depends only on the assembly. It is a manual tool, not
a CI gate: it compiles with whatever toolchain is installed, so its result
changes when the toolchain does.

- A file that differs only in its `.ident` line came from another compiler that
  emitted the same text. It is reported, but is not drift.
- Any other difference, in an instruction, a directive or metadata, is drift.
  So is an expected file that is missing, and a committed file that no selected
  case builds.

| Exit code | Meaning |
|---:|---|
| 0 | The committed assembly matches this toolchain. |
| 1 | Drift. |
| 2 | A kernel failed to compile, or an argument is invalid. |
| 3 | Incomplete: a case was skipped, or nothing was selected to compare. |
| 4 | The inventory or the toolchain cannot be used, so nothing was compiled. |

A regeneration without `--check` uses the same codes: 0 when every target was
published, 2 when a case failed to compile, 3 when a skipped case kept a target
from being published, and 4 as above.

A case skipped for a missing optional header makes the check incomplete. With
`--allow-skipped`, the check passes on the cases it could compare, and still
names each case it did not.

## Checking the inventory

```bash
python corpus/race/scripts/check_cases.py
```

`check_cases.py` needs no compiler. It checks that:

- `[corpus] targets` is set, and `asm/` has a directory for each target and for
  nothing else;
- cases use only known fields, with unique ids and kernels;
- every target in a case's `targets` is a corpus target;
- every case has its `kernels/<kernel>.hip` and, for each target it builds for,
  its `asm/<target>/<kernel>.s`;
- every committed `.s` file belongs to a case that builds for that target;
- every committed `.s` file declares `.amdgcn_target` for the target its
  directory names;
- every target directory has its `recipe.toml`, with all of its fields. Commit
  it with the `.s` files the same regeneration wrote.

This is the check suited to CI. `tests/test_check_cases.py` runs it against the
committed corpus under pytest.

It is an inventory check only. It does not check that the assembly is up to date
with its source: a kernel whose signature or body changed without regenerating
its `.s` still passes. Only the manual `regenerate_asm.py --check` compiles the
kernels and compares the result, so run it after changing a kernel.

## Adding a kernel or a target

- **A kernel:** add `kernels/<kernel>.hip` and a `[[case]]` entry, regenerate,
  and run `check_cases.py`.
- **A target:** add it to `[corpus] targets`, regenerate with
  `--target <target>`, and run `check_cases.py`. Until `asm/<target>/` exists
  and is complete, the inventory check fails.
