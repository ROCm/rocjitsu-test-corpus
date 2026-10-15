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
| `rocm_version` | The SDK's `.info/version`, or `unknown`. |
| `flags` | The explicit flags: `-O3 -x hip`, then `--cxxflags` as given. |

The recipe covers the whole target directory. A case that a run skipped or
failed to compile keeps its earlier `.s`, which may have been built with an
earlier recipe.

## Regenerating the assembly

Regenerating is a manual step that needs a ROCm toolchain. Run it from the
repository root:

```bash
python corpus/race/scripts/regenerate_asm.py                    # every corpus target
python corpus/race/scripts/regenerate_asm.py --target gfx950    # one target
```

- **Toolchain.** The compiler comes from `ROCM_PATH`, else `rocm-sdk path
  --root`, else `/opt/rocm`. Within that SDK, `bin/hipcc` is used, falling back
  to `llvm/bin/clang++`, then to `hipcc` on `PATH`.
- **Extra flags.** `--cxxflags` passes extra compiler flags, split like shell
  words, so a path with spaces can be quoted:
  `--cxxflags='-I"/path/to/my headers"'`.
- **Optional headers.** A case that declares `headers` is skipped, and its
  committed assembly is left as it is, when a header is not found. The search
  covers ROCm's include directory, `-I`/`-isystem`/`-iquote` from
  `--cxxflags`, and the absolute entries of `CPATH` and `CPLUS_INCLUDE_PATH`.
- **Failures.** A kernel that fails to compile keeps its committed assembly, and
  the compiler's diagnostic is printed.
- **Environment.** `HIPCC_COMPILE_FLAGS_APPEND`, `HIPCC_LINK_FLAGS_APPEND` and
  `CCC_OVERRIDE_OPTIONS` add to the compiler's command line from the
  environment, so they would change the assembly without being recorded. They
  are removed from the compile's environment, with a note. Pass extra flags with
  `--cxxflags` instead.

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
or whether the compiler or SDK changed (`toolchain changed`). That tells a
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
| 2 | A kernel failed to compile. |
| 3 | Incomplete: a case was skipped, or nothing was selected to compare. |

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
  directory names.

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
