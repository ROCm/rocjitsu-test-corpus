# Runtime CTS

Two standalone direct-KFD suites, selected with `--suite aql` or `--suite pm4`:

- `aql/`: GPU-agnostic scenario sources and one shared manifest. Tests submit
  only AQL and/or SDMA. Kernels are compiled for the selected target; KFD queue
  setup and SDMA encoding live in `common/support/`. AQL builds reject PM4
  queue creation. The scenarios have prior native verification on **gfx1201**
  and **gfx1250**; this is a verification record, not a universal packet ABI.
- `pm4/`: shared scenarios and one capability-gated manifest. These tests may
  combine PM4, AQL and SDMA. `pm4/support/` holds only differing packet fields:
  `gfx9/` (GCN/CDNA), `gfx11/` (gfx11 and gfx12.0), and `gfx125/` (gfx12.5).
  AQL vendor-PM4 indirect buffers, PM4-produced AQL packets, and tests using
  PM4 control queues belong here even when their names start with `aql` or `sdma`.

Test headers explain motivation, options, checks and public references.
No ROCr, rocddi, HIP or candidate runtime library is linked. The current
support groups cover gfx9 through gfx950, gfx11, gfx1200/gfx1201 and gfx1250.
Adding a target that uses an existing layout does not require another directory
or copy of the scenarios. Add a support group only when packets actually differ.
See [the reference audit](pm4/REFERENCES.md) for the boundaries and evidence. These tests are not
single GPU-independent executables: compiled kernels and low-level support
remain target-specific.

## Build and run

Requires Linux x86-64, 4 KiB pages, C++17, Linux KFD headers, Python 3.11+,
pytest, filelock, and an AMDGPU clang/ld.lld supporting the target. Build and run
on the test machine, with access to `/dev/kfd` and its DRM render node:

```sh
cmake -S corpus/runtime-cts -B build/runtime-cts -G Ninja \
  -DCMAKE_BUILD_TYPE=Release -DCTS_ARCHS=gfx1250 \
  -DAMDGPU_LLVM_BIN=/path/to/amdgpu/llvm/bin
cmake --build build/runtime-cts -j 8
python -m pytest tests/test_corpus.py --suite aql --target gfx1250 \
  --binary-dir build/runtime-cts -v -ra
```

For example, use `'-DCTS_ARCHS=gfx942;gfx1100;gfx1201;gfx1250'` to build
CDNA, RDNA3 and both existing gfx12 targets together. `-DCTS_SUITES=aql` builds just AQL/SDMA; `pm4` builds just the PM4
suite. Both suites are built by default. Use `--suite pm4` to run PM4, or
`--suite aql,pm4` to run both in sequence. CMake only builds; pytest runs binaries sequentially and stops on an
unexpected failure. Run this suite separately, without parallel pytest workers.
Logs and JSON outcomes go under `.pytest-artifacts/<suite>/<target>/`.
Existing `--case`, `--exclude-case`, `--artifact-directory`, `--run-wrapper`
and `--junitxml` options work. Binaries can also be run directly.

## Manifests

`aql/cases.toml` defines shared AQL/SDMA invocations. Its binary names use
`{target}`, substituted from `--target`. `pm4/cases.toml` uses the same model
for PM4 invocations, including mixed AQL/PM4/SDMA tests.
`--cases-config /path/to/custom.toml` replaces the list; custom files can select
a subset. Binary names resolve against `--binary-dir`. Multiple entries can
use the same binary with different arguments:

```toml
[defaults]
timeout_seconds = 60

[[case]]
id = "queue-flood-pm4"
binary = "pm4_queue_flood_gfx1250"
args = ["--mode", "pm4", "--queues", "16", "--iterations", "64"]

[[case]]
id = "chain-no-offload"
binary = "pm4_dependency_chain_no_offload_gfx1250"
args = ["--queues", "8", "--iterations", "4"]
status = "SKIP"
reason = "Investigate: stalls on round 2 with fw 2380; GPU recovery failed."
```

- IDs must be unique. Arguments are strings, passed without shell expansion.
- Omit status to run normally. `SKIP` requires a reason and never executes.
- `XFAIL` requires a reason, `expected_exit_code` and an `expected_output`
  substring. Only matching failures are expected; unexpected passes fail.
  Timeouts cannot be xfailed. Use SKIP for unresolved hang reproducers.
- Each case may override `timeout_seconds`. The outer timeout kills the process
  group, with up to five seconds for reaping. Binary watchdogs (`--timeout`,
  default 45 seconds) and internal progress deadlines still apply.
- Every CMake executable must appear in the default manifest, even if skipped.
  Collection validates coverage before selection, including with custom files.
  Unknown selected binaries, missing build executables (including helpers), and
  unavailable run wrappers are rejected before execution. Keep CMake's
  generated `<suite>-<arch>-targets.txt` and `runtime-<arch>-features.txt`
  beside the built binaries.

## Feature gates

Both manifests declare `requires` capabilities. `cmake/Platforms.cmake` selects
capabilities and a PM4 packet support group, and records the features beside
the binaries. Pytest reports unsupported cases as SKIP without requiring a
binary for that feature. CMake gates feature-specific executables too. Custom
manifests still undergo inventory and feature checks.

| Capability | Implemented support |
| --- | --- |
| `pm4` | Basic MEC writes, copies, atomics, waits, IBs, DMA and cache barriers; all three groups |
| `pm4_wait64` | Native masked WAIT_REG_MEM64; all three groups |
| `pm4_release_mem` | Ordered 64-bit release writes and interrupt events; all three groups |
| `aql_pm4_ib` | ROCr's vendor AQL-to-PM4 IB packet; all three groups |
| `pm4_wait_offload` | gfx12.5 dependency-wait policy and its disabled-offload reproducer |
| `aql_metadata` | gfx1250 metadata companions; requires KFD 1.19+ |
| `sdma_signal64` | gfx1250 native 64-bit SDMA polls/fences |
| `wave32_scratch`, `wgp_placement` | Existing gfx12-specific scratch and placement helpers |

These are capabilities of the implemented test support, not claims that other
GPUs lack scratch, placement or similar hardware features. Base AQL dispatch,
barriers and SDMA copies use shared support; gfx9 kernels use wave64 and gfx11/12
kernels use wave32. Queue context sizes use KFD sysfs when available, with
ROCr's topology-based calculation as the fallback. The
[reference audit](pm4/REFERENCES.md) links each capability to public code.

Feature availability is separate from known-problem SKIPs. In particular,
queue oversubscription, live-wave pause, and existing fault/hang reproducers
retain their default skips. PM4 support is not inferred from AQL/SDMA support.

`AMDGPU_LLVM_BIN` is mandatory. Configuration checks the host KFD headers and
compiles, links and embeds a kernel for every selected architecture before the
build starts. There is no partial, shader-free build. Exit 77 is a target-unavailable
skip, not validation success. No retries or GPU resets are performed; a hung
kernel task can require host recovery. To run a skipped reproducer, use a
custom entry without SKIP and read its source header first.

Validation of the common support:

- Built both suites for gfx900, gfx90a, gfx942, gfx950, gfx1100, gfx1150,
  gfx1201 and gfx1250. CPU packet-layout and runner tests: **47 passed**.
- Native gfx1201 (KFD 1.17, firmware 3060): **66 passed / 6 skipped** across
  both default manifests. Four unavailable features and two existing
  reproducers account for the skips.
- gfx9/gfx11 have build and packet-layout validation, with native GPU validation
  pending. No gfx9/gfx11 hardware was available for this change.
- Before this refactor, native gfx1250 defaults had **68 passed / 4 skipped**
  (KFD 1.23, firmware 2380). The refactored gfx1250 build passes; a new native
  run is pending. AQL scenarios have prior verification on gfx1201 and gfx1250.

gfx1250 standard AQL uses metadata companions; its vendor-PM4 indirect-buffer
AQL case uses a plain queue. Verification records are separate from support
selection and known-problem skips.
