# HIP file-size limits

This simulator integration matrix covers all 18 local/daemon combinations of
early, late, inherited and post-fork file-size limits. It checks allocation,
copies, dispatch, VMM export/import, daemon fixed mappings, and unchanged
application limits and SIGXFSZ behavior. Early zero-limit cases omit COMGR
compilation, whose temporary files remain subject to application limits.

Build from the corpus root with a ROCm SDK and a matching rocjitsu checkout:

```sh
cmake -S corpus/runtime/file-limits -B build/file-limits -G Ninja \
  -DROCM_PATH=/path/to/rocm-sdk -DCMAKE_HIP_ARCHITECTURES=gfx950 \
  -DROCJITSU=/path/to/rocjitsu/build/tools/rocjitsu/rocjitsu \
  -DROCJITSU_CONFIG=/path/to/rocjitsu/tests/race-detector/race_test_config.json
cmake --build build/file-limits -j 4
ctest --test-dir build/file-limits --output-on-failure -j 4
```

Use separate build directories with `-DFILE_LIMIT_SANITIZER=address,undefined`
or `-DFILE_LIMIT_SANITIZER=thread` and the matching sanitized rocjitsu.
Instrumentation applies to host code. The matrix retains the existing ROCr
leak/race accommodations from the source tests. The TSan fork cases start with
`TMPDIR=/dev/null` so an external symbolizer inheriting LD_PRELOAD and FSIZE=0
can initialize without its optional temporary-file optimization.

GoogleTest can be supplied offline through
`-DFETCHCONTENT_SOURCE_DIR_GOOGLETEST=/path/to/googletest`. Otherwise CMake
uses an installed GoogleTest or fetches the pinned release.
