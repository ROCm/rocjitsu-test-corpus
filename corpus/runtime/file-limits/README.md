# HIP file-size limits

This simulator integration matrix covers 18 local/daemon combinations of early,
late, inherited and post-fork file-size limits. It checks allocation, copies,
dispatch, daemon fixed mappings, and preservation of application limits and
SIGXFSZ behavior. Inherited cases verify both limits on entry, before changing
any state; late cases also check limits and SIGXFSZ across HIP initialization.

Local cases create, export, import and map VMM allocations through both handles.
Cases that can dispatch check data written through either alias from the other.
Daemon cases assert the known `hipMemCreate` rejection because daemon dma-buf
export is unsupported; they do not cover VMM mappings or export/import.
Early zero-limit and fork soft-zero cases omit copies and kernel dispatch,
including VMM data checks: COMGR's first-use compilation writes temporary files
that remain subject to application limits. Those cases still check allocation
and mapping; late zero-limit cases exercise copies and dispatch after warmup.

The supported runner in the companion rocm-systems checkout builds the clients
and runs the matrix with the same setup as CI:

```sh
ROCM_PATH=/path/to/rocm-sdk \
ROCJITSU_BUILD_DIR=/path/to/rocm-systems/emulation/rocjitsu/build \
ROCJITSU_CORPUS_DIR=/path/to/rocjitsu-test-corpus \
  bash /path/to/rocm-systems/emulation/rocjitsu/tests/corpus/run-file-limit-tests.sh
```

Build rocjitsu first and install `tini` on `PATH`: the runner uses `tini -s` to
reap detached memory keepers, including in containers. It selects gfx950 and the
matching small simulator config. For sanitized runs, build rocjitsu with Clang
and `RJ_SANITIZER_RUNTIME=AUTO` or `SHARED`; the runner uses that same compiler
for the HIP client. It must support gfx950 HIP with the selected ROCm SDK.
Additional runner arguments are passed to CTest, for example `-R local.inherited`.

For a manual unsanitized build from the corpus root:

```sh
cmake -S corpus/runtime/file-limits -B build/file-limits -G Ninja \
  -DROCM_PATH=/path/to/rocm-sdk -DCMAKE_HIP_ARCHITECTURES=gfx950 \
  -DROCJITSU=/path/to/rocjitsu/build/tools/rocjitsu/rocjitsu \
  -DROCJITSU_CONFIG=/path/to/rocjitsu/tests/race-detector/race_test_config.json
cmake --build build/file-limits -j 4
tini -s -- ctest --test-dir build/file-limits --output-on-failure -j 4
```

Set exactly one `CMAKE_HIP_ARCHITECTURES` target matching `ROCJITSU_CONFIG`.
The inherited soft-limit cases require an unlimited parent hard file-size limit.
CTest passes mode, phase, limit kind and (for inherited cases) expected soft/hard
limits as program arguments. Missing, unknown or incompatible arguments fail
instead of selecting a default scenario.

Use separate build directories with `-DFILE_LIMIT_SANITIZER=address,undefined`
or `-DFILE_LIMIT_SANITIZER=thread` and the matching sanitized rocjitsu. For manual
sanitized builds, also set `CMAKE_HIP_COMPILER` to rocjitsu's cached C++ compiler
and `CMAKE_BUILD_RPATH` to the SDK's `lib` directory. Instrumentation applies to
host code. The matrix retains the existing ROCr leak/race accommodations from
the source tests. The TSan fork cases start with `TMPDIR=/dev/null` so an external
symbolizer inheriting LD_PRELOAD and FSIZE=0 can initialize without its optional
temporary-file optimization.

GoogleTest can be supplied offline through
`-DFETCHCONTENT_SOURCE_DIR_GOOGLETEST=/path/to/googletest`. Otherwise CMake
uses an installed GoogleTest or fetches the pinned release.
