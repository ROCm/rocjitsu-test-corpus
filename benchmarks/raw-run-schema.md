# Raw benchmark run schema

The benchmark runner writes `run.json` in its output directory. The format below
shows each field and its expected value. Angle-bracketed strings describe types
or allowed values; they are placeholders, not literal output. Numbers are JSON
numbers, not strings.

```json
{
  "schema_version": 1,
  "publication": {
    "id": null,
    "source": {
      "branch": null,
      "message": null,
      "base": null,
      "pull_request": null
    },
    "trigger": null,
    "machine_label": null,
    "workflow_commit_sha": null,
    "tensile_commit_sha": null
  },
  "execution_summary": {
    "warmups": "<nonnegative integer>",
    "samples": "<positive odd integer>",
    "timeout_seconds": "<positive number>",
    "benchmark_suite": "<manifest name>",
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
      "operation": "<human-readable overall computation, including composites>",
      "thread_policy": "<default|single>",
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
      "rocm_sdk_version": "<version string|null>"
    },
    "corpus": {
      "corpus_commit_sha": "<SHA|null>",
      "corpus_commit_timestamp": "<timestamp|null>"
    },
    "auxiliary": {
      "<package name>": "<version string|null>",
      "python": "<Python runtime version>"
    }
  }
}
```

`provenance.rocjitsu.rocm_sdk_version` records the `rocm-sdk-devel` package
version in the Python environment running `benchmarks.runner`, which also
supplies the interpreter used to launch workloads. SDK discovery and version
recording happen in the runner process; this field doesn't describe rocjitsu's
build toolchain.

## Reading the results

- **One schema version covers the whole document.** Corpus owns `schema_version`,
  currently `1`, including the publication metadata and raw results.
- **The workflow owns publication metadata.** Corpus leaves every
  `publication.source` field null, along with the other publication fields,
  including `workflow_commit_sha` and `tensile_commit_sha`. The workflow fills
  them later without changing raw provenance. When known,
  `source.base` is `{"branch": "develop", "commit": "<base SHA>"}` and
  `source.pull_request` is `{"number": 42}` with an optional `url` string.
  Unavailable values remain null, including runs with no base or PR.
- **One result per case, target and policy.** The same corpus-owned `id` occurs
  unchanged across targets/policies; use `(id, target, thread_policy)` as identity.
  `operation` and `thread_policy` are present even on failed/timeout results.
  `operation` is metadata, not identity. `problem` preserves the manifest's
  parameter names and values, including `dtype`.
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
  `{"python": "3.12.0", "torch": "2.10.0"}`. Target config hashes are not emitted;
  the actual config snapshots and native allocation reports are retained.

Timestamps are UTC ISO 8601 strings. All numbers must be finite. The only
thread policies are `default` (automatic native budget, not guaranteed MT) and
`single` (one total CPU worker). No file-level threading mode is emitted.

## Related files

One consolidated `run.json` contains all selected target/policy groups.
Each group retains `<target>/<thread-policy>/{config.json,policy.txt,stderr.txt,allocation.json}`.
Per-case files live under `<target>/<thread-policy>/cases/<case-id>/`: `workload.json`,
`stdout.txt`, `stderr.txt`, `config.json`, and any plugin reports. A workload
that fails early may not produce `workload.json`. That file retains the child's
**nanosecond** timings and derived launch metadata; its schema is separate from
`run.json`.

See [Results and plugins](README.md#results-and-plugins) for artifact details.
