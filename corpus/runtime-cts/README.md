# Runtime CTS

## Build and run

Requires Linux x86-64, 4 KiB pages, C++17, Linux KFD headers, Python 3.11+,
pytest, filelock, and AMDGPU clang/ld.lld supporting the selected targets.
Run from the repository root, with access to `/dev/kfd` and its DRM render node:

```sh
cmake -S corpus/runtime-cts -B build/runtime-cts -G Ninja \
  -DCMAKE_BUILD_TYPE=Release -DCTS_ARCHS=gfx1250 \
  -DAMDGPU_LLVM_BIN=/path/to/amdgpu/llvm/bin
cmake --build build/runtime-cts -j 8
python -m pytest tests/test_corpus.py --suite aql,pm4 --target gfx1250 \
  --binary-dir build/runtime-cts -v -ra
```

Use `'-DCTS_ARCHS=gfx942;gfx1100;gfx1201;gfx1250'` to build multiple targets.
Both suites build by default. `-DCTS_SUITES=aql` selects AQL/SDMA tests;
`-DCTS_SUITES=pm4` selects tests that may combine PM4, AQL and SDMA.
Use `--suite aql` or `--suite pm4` to run one suite. Run sequentially, without
parallel pytest workers. Unexpected failures stop the run.

Binaries can also run directly; their source headers document parameters and
checks. Keep the generated `<suite>-<target>-targets.txt` and
`runtime-<target>-features.txt` inventories beside the binaries for pytest.
Logs and JSON results go under `.pytest-artifacts/<suite>/<target>/`.

## Manifests

Each suite uses `cases.toml`, unless `cases_<target>.toml` exists for the selected
`--target`. Both suites provide `cases_gfx1250.toml`, with explicit
`--aql-metadata off` and `--aql-metadata on` cases for AQL scenarios. Metadata
defaults to off. Either explicit value is rejected on targets other than
gfx1250. SDMA-only and PM4-only scenarios run once; the metadata comparison
test always tests both queue types, and vendor PM4-IB packets use a plain queue.

`--cases-config /path/to/custom.toml` replaces the selected manifest and may
contain a subset. Binary names resolve against `--binary-dir`; `{target}` is
replaced with the selected target. Multiple entries can use the same binary:

```toml
[defaults]
timeout_seconds = 60

[[case]]
id = "queue-flood-plain"
binary = "aql_queue_flood_{target}"
args = ["--queues", "4", "--iterations", "32"]

[[case]]
id = "queue-flood-metadata"
binary = "aql_queue_flood_{target}"
args = ["--queues", "4", "--iterations", "32", "--aql-metadata", "on"]
requires = ["aql_metadata"]
```

- IDs must be unique. Arguments are strings, passed without shell expansion.
- `requires` lists capabilities from the build's feature inventory. Missing
  capabilities cause a SKIP. Existing reproducer skips remain in both modes.
- Omit `status` to run normally. `status = "SKIP"` requires a `reason` and never
  executes the case. `status = "XFAIL"` requires a `reason`, `expected_exit_code`
  and `expected_output` substring matching the subprocess output. Unexpected
  passes fail; timeouts cannot be xfailed.
- Cases may override `timeout_seconds`. The binary's `--timeout` watchdog
  defaults to 45 seconds; the runner timeout defaults to 60 seconds.
- Every built executable must appear in the selected default manifest, even
  if skipped. Coverage and executable checks also apply with custom manifests.
- `--case`, `--exclude-case`, `--artifact-directory`, `--run-wrapper` and
  `--junitxml` are supported by the pytest runner.
