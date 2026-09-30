# Runtime torture tests

Standalone direct-KFD tests for MEC/MES/CP on gfx1201 and gfx1250. Each scenario
builds one executable per architecture. Test headers describe purpose, checks,
parameters, defaults, limits and public inspiration. No ROCr, rocddi, HIP,
OpenCL runtime or candidate test library is linked.

Build on the GPU test machine with a C++17 compiler, Linux KFD UAPI headers,
CMake, Python 3 and pthreads. `AMDGPU_LLVM_BIN` selects an installed clang/ld.lld
supporting both targets; kernels compile without device libraries. From the
repository root:

```sh
cmake -S corpus/runtime-torture -B build/runtime-torture -G Ninja \
  -DCMAKE_BUILD_TYPE=Release -DAMDGPU_LLVM_BIN=/path/to/amdgpu/llvm/bin
cmake --build build/runtime-torture -j 8
ctest --test-dir build/runtime-torture -R gfx1201 -L smoke --output-on-failure
build/runtime-torture/timeline_fuzz_gfx1201 --queues 16 --iterations 4096 --seed 123
```

CTest runs the binaries directly; this suite is independent of the repository's
pytest runner. Omitting `AMDGPU_LLVM_BIN` omits shader tests. With it, there are
27 fast scenarios and one separately built live-wave pause investigation binary
per architecture. Keep `queue_flood` beside `multiprocess`, which execs it.

Access to `/dev/kfd` and the target DRM render node is required. Current native
setup assumes Linux x86-64, 4 KiB pages, one XCC and wave32. The gfx1201 fast suite
has been hardware-tested; gfx1250 is compiled but awaits hardware validation.
Use `-R gfx1250` there. Exit 0 means PASS, 77 means target absent, 124 means
watchdog timeout; other nonzero exits are failures. A skip is not GPU validation.

`-DTORTURE_INVESTIGATION_TESTS=ON` registers live-wave pause and eight-queue AQL
oversubscription cases under `-L investigation`. These remain unresolved and
are outside fast CI; details and reproducer parameters are in their source
headers. Live-wave pause can exercise driver recovery on failure. Tests do not
reset devices or change firmware, and never retry a failure into a pass.
