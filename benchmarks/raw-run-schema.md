# Raw benchmark run schema

The benchmark runner writes `run.json` in its output directory. The format below
shows each field and its expected value. Angle-bracketed strings describe types
or allowed values; they are placeholders, not literal output. Numbers are JSON
numbers, not strings.

```json
{
  "execution_summary": {
    "warmups": "<nonnegative integer>",
    "samples": "<positive odd integer>",
    "timeout_seconds": "<positive number>",
    "benchmark_suite": "<suite name from the manifest>",
    "threading_mode": "<default|single>",
    "plugin_profile": "<none|logging|race|throughput>",
    "timestamp": "<run start timestamp>",
    "finished_at": "<run finish timestamp|null while running>",
    "wall_time_s": "<nonnegative number>"
  },
  "benchmark_results": [
    {
      "id": "<case ID from the manifest>",
      "name": "<human-readable case name>",
      "target": "<target architecture, such as gfx950>",
      "suite": "<workload family, such as Triton>",
      "operation": "<operation from the manifest, such as GEMM>",
      "workload": "<adapter identifier from the manifest, such as triton_persistent>",
      "problem": {
        "<parameter name>": "<JSON value from the manifest>"
      },
      "status": "<completed|failed|timeout>",
      "exit_code": "<integer|null>",
      "error": "<failure description|null>",
      "timing_results_s": [
        "<positive number; empty array if no accepted timings>"
      ]
    }
  ],
  "provenance": {
    "machine": {
      "hostname": "<string>",
      "platform": "<string>",
      "kernel": "<string>",
      "cpu": "<string>"
    },
    "rocjitsu": {
      "rocjitsu_commit_sha": "<SHA|null>",
      "rocjitsu_commit_timestamp": "<timestamp|null>",
      "rocjitsu_dirty": "<boolean|null if unknown>",
      "target_config_sha256": {
        "<target architecture>": "<SHA-256 of the target configuration before adding plugins and sinks>"
      },
      "rocm_sdk_version": "<version string|null>"
    },
    "corpus": {
      "corpus_commit_sha": "<SHA|null>",
      "corpus_commit_timestamp": "<timestamp|null>",
      "corpus_dirty": "<boolean|null if unknown>"
    },
    "auxiliary": {
      "<package name>": "<version string|null>",
      "python": "<Python runtime version>"
    }
  }
}
```

## Reading the results

- **One result per case and target.** The same `id` can occur on both targets;
  use `(target, id)` to identify a result. `problem` preserves the manifest's
  parameter names and values, including `dtype`. `operation` and `workload`
  identify the operation and adapter for every result, including early failures.
- **Timings are in seconds.** `timing_results_s` contains accepted samples in
  execution order, excluding warmups. For example, `[0.012]` means one 12 ms
  sample. `wall_time_s` is elapsed time for the whole run, including setup and
  validation, rather than the sum of sample timings.
- **A finish time means the run has ended.** While `finished_at` is null, results
  are a checkpoint. Cases that have not run yet appear as `failed`, with an
  explanatory `error` and no timings. Once finished, the run succeeds only if
  every result is `completed`. Interruptions retain completed results and mark
  unfinished cases as failed.
- **Provenance identifies the host and software.** Unknown revisions and
  versions are null. `auxiliary` is a flat version map, such as
  `{"python": "3.12.0", "torch": "2.10.0"}`. Target configuration hashes include
  the selected thread policy but exclude plugins and report sinks.
  `execution_summary.plugin_profile` identifies the selected instrumentation.
  `rocjitsu_dirty` and `corpus_dirty` are true when Git reports tracked changes
  or untracked files, false for a clean checkout, and null if Git status is
  unavailable. A recorded revision alone does not imply a clean checkout.
  `provenance.rocjitsu.rocm_sdk_version` records the `rocm-sdk-devel` package
  version in the workload's Python environment, not the SDK used to compile
  rocjitsu.

Timestamps are UTC ISO 8601 strings. All numbers must be finite. The only
threading modes are `default` (native worker allocation) and `single` (one total
CPU worker); numeric-thread manifests cannot produce new runs.

## Related files

Per-case files live under `cases/<case-id>/<target>/`: `workload.json`,
`stdout.txt`, `stderr.txt`, `config.json`, and any plugin reports. A workload
that fails early may not produce `workload.json`. That file retains the child's
**nanosecond** timings and derived launch metadata; its schema is separate from
`run.json`.

See [Results and plugins](README.md#results-and-plugins) for artifact details.
