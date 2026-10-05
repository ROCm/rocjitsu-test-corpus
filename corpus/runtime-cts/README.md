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

## Runtime stress test acceptance

Tests in `corpus/runtime-cts` exercise compute runtime mechanisms: GPU queues,
command processing, firmware, memory management, synchronization and process
lifetime. Keep each test focused on one mechanism. Graphics workloads are out
of scope.

- State the failure mechanism and the observed milestones that establish the
  intended state. Many queue objects do not by themselves prove oversubscription;
  a large allocation does not prove eviction; pausing an idle queue does not
  prove live-wave save/restore.
- Check data that depends on the operation under test. A dependency test must
  consume the producer's payload. A completion flag alone cannot establish that
  a wait or memory handoff worked. Check guards and exact execution counts where
  lost, duplicated or out-of-range work could otherwise pass.
- For a blocked-state test, establish a reached or full-capacity milestone
  before checking that later work has not completed. Verify independent progress,
  then release the operation and check its positive result. A sleep alone does
  not establish the state.
- Distinguish packet consumption, shader completion and safe resource retirement.
  Keep buffers, signals, arguments and command storage alive until every user
  retires. Validate dependency acyclicity including each queue's FIFO ordering.
- Use a few deliberate boundaries rather than a Cartesian product of parameters.
  Preserve deterministic seeds and immutable generations needed to reproduce
  failures. Do not require a performance threshold or scheduling order that the
  API does not guarantee.
- Bound waits and process lifetimes. Timeouts fail; unsupported capabilities skip
  before triggering the scenario. Report the target, feature mode, seed, iteration,
  queue/process, expected and observed values, and last reached milestone where
  relevant. Multiprocess tests must propagate failures and reap their children.
- Validate new stress scenarios on a supported native target before enabling
  them in normal manifests. Record which architectures and capabilities were
  exercised, which were only built, and any limitations. During
  development, demonstrate that an isolated mutation such as an omitted dependency,
  stale generation or suppressed execution makes the result check fail. Keep such
  mutations out of production binaries and manifest options.
- Update the source header with the purpose, parameters, checks, support limits
  and primary references. Explain which pattern is adapted and validate the
  actual API contract; an upstream test using a different API is not a packet
  specification. Keep build inventories and manifests consistent.
