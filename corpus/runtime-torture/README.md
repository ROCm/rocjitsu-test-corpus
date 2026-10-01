# Runtime torture tests

Standalone direct-KFD MEC/MES/CP stress tests for gfx1201 and gfx1250. Each
architecture owns its scenarios, kernels and packet encoders. Test headers
explain motivation, options, checks and public references. No ROCr, rocddi,
HIP or candidate runtime library is linked.

## Build and run

Requires Linux x86-64, 4 KiB pages, C++17, Linux KFD headers, Python 3.11+,
pytest, filelock, and an AMDGPU clang/ld.lld supporting the target. Build and run
on the test machine, with access to `/dev/kfd` and its DRM render node:

```sh
cmake -S corpus/runtime-torture -B build/runtime-torture -G Ninja \
  -DCMAKE_BUILD_TYPE=Release -DTORTURE_ARCHS=gfx1250 \
  -DAMDGPU_LLVM_BIN=/path/to/amdgpu/llvm/bin
cmake --build build/runtime-torture -j 8
python -m pytest tests/test_corpus.py --suite runtime-torture --target gfx1250 \
  --binary-dir build/runtime-torture -v -ra
```

Use `gfx1201` for that target, or `'-DTORTURE_ARCHS=gfx1201;gfx1250'` to build
both. CMake only builds; pytest runs binaries sequentially and stops on an
unexpected failure. Run this suite separately, without parallel pytest workers.
Logs and JSON outcomes go under `.pytest-artifacts/runtime-torture/`.
Existing `--case`, `--exclude-case`, `--artifact-directory`, `--run-wrapper`
and `--junitxml` options work. Binaries can also be run directly.

## Manifests

`gfx1201/cases.toml` and `gfx1250/cases.toml` define the default invocations.
`--cases-config /path/to/custom.toml` replaces the list; custom files can select
a subset. Binary names resolve against `--binary-dir`. Multiple entries can
use the same binary with different arguments:

```toml
[defaults]
timeout_seconds = 60

[[case]]
id = "queue-flood-pm4"
binary = "queue_flood_gfx1250"
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
  generated `runtime-torture-<arch>-targets.txt` beside the built binaries.

`AMDGPU_LLVM_BIN` is mandatory. Configuration checks the host KFD headers and
compiles, links and embeds a kernel for every selected architecture before the
build starts. There is no partial, shader-free build. Exit 77 is a target-unavailable
skip, not validation success. No retries or GPU resets are performed; a hung
kernel task can require host recovery. To run a skipped reproducer, use a
custom entry without SKIP and read its source header first.

Validated defaults: gfx1201 **66 passed / 2 skipped**; gfx1250 **68 passed /
4 skipped** (KFD 1.23, firmware 2380). gfx1250 standard AQL uses metadata
companions; its indirect-buffer AQL case uses a plain queue.
