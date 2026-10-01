# Runtime torture tests

Standalone direct-KFD tests for MEC/MES/CP on gfx1201 and gfx1250. Each scenario has its own
source in its architecture directory and builds a standalone executable. Test headers describe
purpose, checks, parameters, defaults, limits and public inspiration. No ROCr,
rocddi, HIP, OpenCL runtime or candidate test library is linked.

Build on the GPU test machine with a C++17 compiler, Linux KFD UAPI headers,
CMake, Python 3 and pthreads. `AMDGPU_LLVM_BIN` selects an installed clang/ld.lld
supporting the selected architecture; kernels compile without device libraries. From the
repository root:

```sh
cmake -S corpus/runtime-torture -B build/runtime-torture -G Ninja \
  -DCMAKE_BUILD_TYPE=Release -DTORTURE_ARCHS=gfx1201 \
  -DAMDGPU_LLVM_BIN=/path/to/amdgpu/llvm/bin
cmake --build build/runtime-torture -j 8
ctest --test-dir build/runtime-torture -R gfx1201 -L smoke --output-on-failure
build/runtime-torture/pm4_timeline_fuzz_gfx1201 --queues 16 --iterations 4096 --seed 123
build/runtime-torture/queue_flood_gfx1201 --mode pm4 --queues 16
build/runtime-torture/queue_flood_gfx1201 --mode aql --queues 4
```

Use `-DTORTURE_ARCHS=gfx1250` for gfx1250, or quote
`'-DTORTURE_ARCHS=gfx1201;gfx1250'` to build both. gfx1201 is the default.
Each architecture directory owns its test list, kernels, queue setup and PM4,
SDMA and AQL programming. `common/` contains only CLI/check helpers and the ELF
embedding script. Scenarios keep matching names where their intent matches;
packet programming stays independent.
Shared scenarios accept `--mode pm4|aql` (default `pm4`). Tests whose intent
is specific to a packet protocol have `pm4_`, `aql_`, or `sdma_` prefixes.
Each file keeps its purpose, mode-specific defaults, checks and public references
in its header. The build output directory remains flat.

CTest runs the binaries directly; this suite is independent of the repository's
pytest runner. Both modes of each of the 19 shared scenarios are registered explicitly: the
gfx1201 build has 66 smoke invocations, including protocol-specific tests.
gfx1250 has the same scenarios plus metadata-ring reuse and native 64-bit SDMA
signal tests, for 68 invocations. Its standard AQL dispatches and barriers use
256-byte metadata companions by default and require KFD 1.19 or newer.
The metadata-reuse case compares plain AQL with metadata AQL. The vendor AQL
indirect-buffer case uses a plain queue: the public metadata layouts cover
standard dispatch and barrier packets.
Omitting `AMDGPU_LLVM_BIN` builds only the protocol-specific tests without
shaders; shared two-mode binaries require the compiler even for PM4 runs.
Keep `queue_flood` beside `multiprocess`, which execs it in the selected mode.
The live-wave pause binary is built separately from the smoke registrations.

Access to `/dev/kfd` and the target DRM render node is required. Current native
setup assumes Linux x86-64, 4 KiB pages and wave32; gfx1201 expects one XCC,
while gfx1250 allocates context-save storage per XCC. The gfx1201 fast suite
is validated on native hardware (66/66 smoke invocations). gfx1250 builds with
the ROCm wheel compiler and passes all 68 smoke invocations on native hardware
(KFD 1.23, firmware 2380). This includes metadata-ring reuse, imported DMA-BUF
signals, per-XCC CU masks, scratch-backing switches and PM4/SDMA interactions.
gfx1250 dependency waits use the public KFD ACE-offload encoding; release barriers
write back GL2 before signaling another engine. These results qualify the tested
defaults on that configuration, not every parameter combination or firmware version.
Exit 0 means PASS, 77 means target absent, 124 means
watchdog timeout; other nonzero exits are failures. A skip is not GPU validation.

`-DTORTURE_INVESTIGATION_TESTS=ON` registers cases labeled `INVESTIGATE`
(also `investigation` for existing commands). The binaries build regardless of
this option when the shader compiler is available. These are ordinary tests:
failures and watchdog timeouts remain failures, not expected passes or skips.
With registration enabled, use `-L smoke` for fast CI; unfiltered CTest also runs
the investigations. Run hang reproducers individually on a recoverable machine.

gfx1250 preserves two variants of passing smoke scenarios:

- `pm4_dependency_chain_no_offload_gfx1250 --queues 8 --iterations 4` clears only
  the dependency waits' ACE-offload optimization bit. This stalled on round 2
  with fw 2380 and left subsequent queue progress/recovery failing.
- `aql_metadata_nonexec_kernargs_gfx1250 --iterations 1` uses non-executable
  kernarg backing. Plain-AQL preload previously faulted on another gfx1250
  machine; this variant has not been rerun on the current machine.

Both retain the smoke scenario's checks. Their validity/root causes remain
INVESTIGATE; the passing alternatives do not resolve the observed failures.

Live-wave pause and eight-queue AQL oversubscription remain unresolved on gfx1201 and
are outside fast CI. The eight-queue AQL case passes on gfx1250. gfx1250 live-wave
pause returned UPDATE_QUEUE EACCES with a privileged instruction-fetch fault at
the kernel's reserved trap-code address, followed by failed MES/GPU recovery.
Its trap/preemption setup remains unqualified; this is not yet a confirmed
firmware bug. Details and reproducer parameters are in the source headers.
Live-wave pause can require a host reboot after failure. Tests do not
reset devices or change firmware, and never retry a failure into a pass.
