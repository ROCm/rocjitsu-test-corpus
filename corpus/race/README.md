# Race-Detection Corpus

Small HIP kernels for scoring race and data-hazard detectors, with their device
assembly pinned per gfx target. Mutants are derived from the pinned assembly,
so the assembly, not the HIP source, is what the corpus is built on.

## Using the listings

A pinned listing is device code only. To run a case, build an executable in
these steps:

1. **Host object.** Compile the host half of the HIP source,
   `hipcc -c --cuda-host-only`. It holds the host code and the kernel launch,
   and refers to its device code through a `__hip_fatbin_<hash>` symbol.
2. **Device code object.** With the SDK recorded in the target's
   `recipe.toml`, build a loadable code object from the pinned listing, or a
   mutant of it:
   - assemble it for the target:
     `clang -target amdgcn-amd-amdhsa -mcpu=<target> -c <kernel>.s`;
   - link the result with the SDK's `ld.lld -shared`.

   Assembly alone gives a relocatable object (`ET_REL`), which the HIP runtime
   cannot load; the device link gives the shared object (`ET_DYN`) it loads.
   The clang driver does both steps when given no `-c`.
3. **Bundle and embed.** Bundle the code object with `clang-offload-bundler`
   under the bundle ID `hipv4-amdgcn-amd-amdhsa--<target>`, and embed the
   bundle in an object under the host object's fatbin symbol. The bundle ID is
   the offload target, not the listing's `.amdgcn_target` string.
4. **Link** the host object and the embedded bundle into the executable.

Do not compile the HIP source the usual way: that regenerates the device code
with whatever toolchain is installed and bypasses the pinned listing, mutants
included. The listing's `__hip_cuid_<hash>` symbol is normalized to a
placeholder and is not used to find the device code, so a pinned listing links
against a freshly compiled host object.

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

`[corpus]` holds `schema` and `targets`. `targets` lists the gfx targets the
corpus is built for. Both scripts read it, so adding a target is a deliberate
edit here.

The manifest is strict. A table or key other than `[corpus]`, its two keys,
and `[[case]]` is rejected, as is a manifest with no `[[case]]` tables. A
misspelled `[[case]]` table is therefore an error, not an empty corpus, which
regeneration would otherwise publish by deleting every listing.

Each `[[case]]` names one independently buildable kernel:

| Field | Meaning |
|---|---|
| `id` | Stable selector for the case. |
| `kernel` | Basename under `kernels/`, without `.hip`. |
| `targets` | The corpus targets the kernel builds for. Empty or absent means every corpus target. |
| `headers` | Optional. Headers outside ROCm's defaults that the kernel includes, such as `rocwmma/rocwmma.hpp`. |

## Why the assembly is pinned

Most wait instructions are placed by the compiler; some kernels insert them
explicitly as inline assembly, which the listings mark between `;;#ASMSTART` and
`;;#ASMEND`. Mutants are derived from the waits: `s_waitcnt` on gfx950,
including combined counters such as `vmcnt(0) lgkmcnt(0)`, and the per-counter
`s_wait_*` instructions on gfx1250, including XCNT waits (`s_wait_xcnt`) and
combined forms such as `s_wait_loadcnt_dscnt`. Mutants also come from marked
loads: in `global_byte_eviction`, a byte load that the mutation harness rewrites
as a store is followed in both listings by a `; probe` marker block, which
contains no instruction. Which waits and loads become mutants is the mutant
generator's decision. Compiling at test time would let a toolchain update
silently change the mutants. Pinning the assembly keeps the set of injected
defects fixed, and makes moving it onto newer codegen a reviewable commit.

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
| `flags` | The explicit flags: `-O3 -x hip`, then `--cxxflags` as the compiler receives them. A supported relative path, such as `-Iinclude` or `-include include/options.h`, is made absolute against the directory the script runs from, so running from another directory, where it selects a different file, changes the recipe. See Extra flags for which relative paths are supported. |

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
  `--cxxflags='-I"/path/to/my headers"'`. The compiler runs in a scratch
  directory, so relative paths are supported only for these options, taken from
  the directory you run the script in:
  - `-I`, `-iquote` and `-isystem`, which are made absolute;
  - `-include`, which must name a file in that directory, such as
    `-include include/options.h`. The compiler's own header search could
    otherwise select a different file.

  Other path-taking options the script recognizes, such as `-idirafter`,
  `--include-directory`, `-include-pch` and `-imacros`, need absolute paths. A
  relative path for any of them is rejected (exit 2). An option's `=` spelling,
  such as `-resource-dir=/path`, and a value clang reads as relative to the
  sysroot, such as `-I=/usr/include`, are kept as written. So is an argument
  forwarded with `-Xclang`, `-Xpreprocessor`, `-Xarch_host` or `-Xarch_device`.
  A forwarded argument is checked like a top-level one, under the rules below,
  and a path forwarded that way must be absolute.

  Path options are recognized only by their complete names. An argument that
  only starts like one, such as `-iframeworkwithsysroot` or
  `--include-directory-after=`, is rejected rather than read as a path, and so
  is any other forwarding option, such as `-Xassembler`, `-Wp,` or `-mllvm`.

  Every other argument must be an option that cannot carry a path, and passes
  through unchanged: `-D` and `-U` macros, `-O` levels, `-W` warnings, `-std=`,
  `-save-temps`, and these `-f` and `-m` switches, which compile to the same
  listing on every regeneration:

  - `-ffast-math`, `-finline`, `-funroll-loops`, `-fstrict-aliasing`,
    `-fgpu-approx-transcendentals`, `-fgpu-flush-denormals-to-zero` and
    `-fhip-fp32-correctly-rounded-divide-sqrt`, and the `-fno-` form of each;
  - `-fno-gpu-rdc`;
  - `-mcumode`, `-mwavefrontsize64`, and the `-mno-` form of each.

  Other `-f` and `-m` switches are rejected (exit 2), because some embed
  per-invocation data that an immediate `--check` would report as drift:
  `-frecord-command-line` and `-fsave-optimization-record` embed the compile's
  temporary directory, and `-fprofile-generate`, `-fcoverage-mapping` and
  `-fgpu-rdc` change encoded metadata. Anything else is rejected too, including
  aliases of path options such as `--include=`, response files (`@file`), whose
  arguments the script cannot see, and input files. So is `-g`: debug info
  embeds each compile's temporary directory, so the listing would differ on
  every regeneration.
- **Whole targets.** Every case is compiled into a temporary directory first.
  A target is published only when all of its cases compiled: its new listings,
  exactly the ones its cases produce, and its `recipe.toml` are staged in a
  hidden directory beside it, which then replaces it. A listing of a removed
  case, or of a target a case no longer builds for, is not carried over; a
  target no case builds for any more is published with only its recipe. A
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
- **Environment.** The compiler comes from the selected SDK, and gets the
  recorded flags. Variables that would change the compile without being
  recorded are removed from its environment, with a note:
  - `HIPCC_COMPILE_FLAGS_APPEND`, `HIPCC_LINK_FLAGS_APPEND` and
    `CCC_OVERRIDE_OPTIONS`, which add to the compiler's command line;
  - `CPATH`, `CPLUS_INCLUDE_PATH` and `C_INCLUDE_PATH`, which add header
    directories;
  - hipcc's other `HIP_*` variables, such as `HIP_PATH`, and `DEVICE_LIB_PATH`,
    which point it at another SDK's parts.

  `ROCM_PATH` is set to the selected SDK. Pass extra flags and include
  directories with `--cxxflags`, which `recipe.toml` records.

  The recipe does not capture the whole host. The compiler's own header search
  still includes host directories, such as the host C++ standard library,
  `/usr/local/include` and `/usr/include`, which are not recorded. Regenerate
  on a host whose system headers match, or treat a difference as possible
  drift.

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
- the manifest uses only known tables, keys and fields, has at least one case,
  and its ids and kernels are unique;
- every target in a case's `targets` is a corpus target;
- every case has its `kernels/<kernel>.hip` and, for each target it builds for,
  its `asm/<target>/<kernel>.s`;
- every `kernels/*.hip` belongs to a case;
- every committed `.s` file belongs to a case that builds for that target, and a
  target directory holds nothing but those listings and its `recipe.toml`, since
  regeneration would remove anything else;
- every committed `.s` file declares `.amdgcn_target` for the target its
  directory names;
- every target directory has its `recipe.toml`, with all of its fields. Commit
  it with the `.s` files the same regeneration wrote.

This is the check suited to CI. `tests/test_check_cases.py` runs it against the
committed corpus under pytest. It exits 0 when `cases.toml` agrees with
`kernels/` and `asm/`, and 1 on any problem, including an invalid `cases.toml`.

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
