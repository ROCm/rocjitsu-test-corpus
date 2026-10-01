# Runtime torture tests

Standalone direct-KFD tests for MEC/MES/CP on gfx1201. Each scenario has its own
source in `gfx1201/` and builds a standalone executable. Test headers describe
purpose, checks, parameters, defaults, limits and public inspiration. No ROCr,
rocddi, HIP, OpenCL runtime or candidate test library is linked.

Build on the GPU test machine with a C++17 compiler, Linux KFD UAPI headers,
CMake, Python 3 and pthreads. `AMDGPU_LLVM_BIN` selects an installed clang/ld.lld
supporting gfx1201; kernels compile without device libraries. From the
repository root:

```sh
cmake -S corpus/runtime-torture -B build/runtime-torture -G Ninja \
  -DCMAKE_BUILD_TYPE=Release -DAMDGPU_LLVM_BIN=/path/to/amdgpu/llvm/bin
cmake --build build/runtime-torture -j 8
ctest --test-dir build/runtime-torture -R gfx1201 -L smoke --output-on-failure
build/runtime-torture/pm4_timeline_fuzz_gfx1201 --queues 16 --iterations 4096 --seed 123
build/runtime-torture/queue_flood_gfx1201 --mode pm4 --queues 16
build/runtime-torture/queue_flood_gfx1201 --mode aql --queues 4
```

`gfx1201/` owns its test list, kernels, queue setup and PM4, SDMA and AQL
programming. `common/` contains only CLI/check helpers and the ELF embedding
script. Future architectures should own independent implementations; sharing
scenario names or coverage is optional. gfx1250 tests are not included yet.
Shared scenarios accept `--mode pm4|aql` (default `pm4`). Tests whose intent
is specific to a packet protocol have `pm4_`, `aql_`, or `sdma_` prefixes.
Each file keeps its purpose, mode-specific defaults, checks and public references
in its header. The build output directory remains flat.

CTest runs the binaries directly; this suite is independent of the repository's
pytest runner. Both modes of each of the 19 shared scenarios are registered explicitly: the
full build has 66 smoke invocations, including protocol-specific tests.
Omitting `AMDGPU_LLVM_BIN` builds only the protocol-specific tests without
shaders; shared two-mode binaries require the compiler even for PM4 runs.
Keep `queue_flood` beside `multiprocess`, which execs it in the selected mode.
The live-wave pause binary is built separately from the smoke registrations.

Access to `/dev/kfd` and the target DRM render node is required. Current native
setup assumes Linux x86-64, 4 KiB pages, one XCC and wave32. The gfx1201 fast suite
is validated on native hardware; new modes must pass independently. Exit 0 means PASS, 77 means target absent, 124 means
watchdog timeout; other nonzero exits are failures. A skip is not GPU validation.

`-DTORTURE_INVESTIGATION_TESTS=ON` registers live-wave pause and eight-queue AQL
oversubscription cases under `-L investigation`. These remain unresolved and
are outside fast CI; details and reproducer parameters are in their source
headers. Live-wave pause can exercise driver recovery on failure. Tests do not
reset devices or change firmware, and never retry a failure into a pass.
