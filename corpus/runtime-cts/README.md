# Runtime CTS

These tests stress the GPU and may crash the GPU or leave the host requiring a
reboot. Run them on a remote machine that you can reboot, with recovery access
that remains available if the host stops responding (for example, BMC access).

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

Use `'-DCTS_ARCHS=gfx942;gfx950;gfx1100;gfx1201;gfx1250'` to build multiple targets.
Both suites build by default. `-DCTS_SUITES=aql` selects AQL/SDMA tests;
`-DCTS_SUITES=pm4` selects tests that may combine PM4, AQL and SDMA.
Use `--suite aql` or `--suite pm4` to run one suite. Run sequentially, without
parallel pytest workers. Unexpected failures stop the run.

Binaries can also run directly; their source headers document parameters and
checks. Keep the generated `<suite>-<target>-targets.txt` and
`runtime-<target>-features.txt` inventories beside the binaries for pytest.
Logs and JSON results go under `.pytest-artifacts/<suite>/<target>/`.

For native validation on NUMA hosts, follow the public
[ROCm system setup guidance](https://rocm.docs.amd.com/en/docs-7.2.0/how-to/rocm-for-ai/system-setup/prerequisite-system-validation.html#disable-numa-auto-balancing)
and disable automatic NUMA balancing for the run. Save the original value of
`/proc/sys/kernel/numa_balancing`, use `sudo sysctl -w kernel.numa_balancing=0`,
and restore the saved value afterward. The USERPTR tests exercise registration,
copying and unregistration; concurrent page migration is outside their scope.

## Manifests

Each suite has an explicit `cases_<target>.toml` for gfx942, gfx950, gfx1100,
gfx1201 and gfx1250. There is no default manifest or fallback for unverified
targets. Each manifest includes only executables built for its target; unsupported
packet/shader profiles are omitted instead of copied as investigation skips.
Both suites provide `cases_gfx1250.toml`, with explicit
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
args = ["--iterations", "9"]

[[case]]
id = "queue-flood-metadata"
binary = "aql_queue_flood_{target}"
args = ["--iterations", "9", "--aql-metadata", "on"]
requires = ["aql_metadata"]
```

- IDs must be unique. Arguments are strings, passed without shell expansion.
- Case-specific validation notes, failure details and workarounds belong in
  comments beside the case. Keep `reason` concise for the test runner's skip report.
- `requires` lists capabilities from the build's feature inventory. Missing
  capabilities cause a SKIP. Existing reproducer skips remain in both modes.
- Omit `status` to run normally. `status = "SKIP"` requires a `reason` and never
  executes the case. `status = "XFAIL"` requires a `reason`, `expected_exit_code`
  and `expected_output` substring matching the subprocess output. Unexpected
  passes fail; timeouts cannot be xfailed.
- `slow = true` marks cases measured above two seconds on native hardware
  or above 60 seconds under RocJITsu for that target. Simulator classifications
  record the observed runtime beside the case. They are skipped
  by default; `--run-slow` includes them and `--run-slow -m slow` selects only
  them. This does not override feature requirements or explicit `SKIP` status.
- Cases may override `timeout_seconds`. The binary's `--timeout` watchdog
  defaults to 45 seconds; the runner timeout defaults to 60 seconds.
- Every built executable must appear in the selected default manifest, even
  if skipped. Coverage and executable checks also apply with custom manifests.
- `--case`, `--exclude-case`, `--artifact-directory`, `--run-wrapper` and
  `--junitxml` are supported by the pytest runner.

The gfx1100 manifests use the gfx1101 case selection for simulator runs with
the existing gfx1100 config. Native measurements below remain gfx1101 results.

## Validated architectures

The AQL and PM4 suites have been validated on native gfx942, gfx950, gfx1101,
gfx1201 and gfx1250 using TheRock `10.2.0a20261005`. Validation qualifications,
required environment workarounds and investigation details are documented beside
the relevant cases in each target's TOML manifest. Explicit `SKIP` reasons remain
the authority for cases that are not yet qualified.
