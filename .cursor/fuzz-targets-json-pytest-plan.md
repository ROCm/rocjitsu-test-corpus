# Fuzz Targets JSON Pytest Harness Plan

## Goal

Design a testing framework for `corpus/fuzz-targets` that follows the useful
parts of the IREE corpus structure:

```text
metadata describes what to test
target configs describe where to run it
pytest discovers cases and orchestrates build/run/validation
CMake remains the source of truth for build mechanics
```

The framework should not make pytest the only way to build or run fuzz targets.
Manual CMake workflows must continue to work.

## Planned Layout

```text
corpus/fuzz-targets/
  configs/
    cdna3.json
    rdna4.json
  cases/
    <project>/
      <case>/
        case.json
        runner.cpp|runner.hip
        input_sets/*.json
        overrides/<relative/source/path>
        cmake/*.cmake
  third_party/
    <project>/

tests/
  fuzz_targets.py
  test_fuzz_targets.py
```

## Ownership

JSON describes intent. Python executes test policy. CMake owns the build graph.
HIP/ROCm compilers build the actual GPU code.

```text
case.json / input-set json / target config
  = declare what should be built and run

pytest harness
  = discover cases and input sets, pick configs, call CMake, run executables,
    validate results, collect logs and artifacts

CMake
  = define source files, include paths, libraries, source overlays, executable
    targets, and run targets

HIP/ROCm compiler
  = compile runner and kernel code into executable/code objects
```

The pytest harness should trigger builds through CMake, not manually compile
kernels with raw `hipcc` commands.

## Manual CMake Path

The JSON/pytest layer must not replace direct CMake usage. A developer should
still be able to configure, build, and run a target manually:

```sh
cmake --preset local-hip
cmake --build --preset local-hip --target <target-name>
./build/local-hip/path/to/runner --validate
```

The pytest path should automate the same build/run behavior:

```text
pytest -> CMake configure/build -> built runner -> validation/reporting
```

## Planned JSON Responsibilities

`corpus/fuzz-targets/cases/<project>/<case>/case.json`

Stable test-case metadata. Planned contents:

- `name`: stable case identifier used in pytest IDs and artifact paths.
- `project`: owning upstream or corpus project, such as `llama.cpp`.
- `runner`: case-local runner source, such as `runner.cpp` or `runner.hip`.
- `kind`: build/run kind, initially likely `cmake_executable`.
- `build`: CMake build metadata, including target name.
- `run`: executable path or CMake-provided run target, arguments, environment,
  and timeout.
- `validation`: expected exit code, output checks, numeric tolerance, or
  case-specific validation mode.
- `architectures`: supported architecture families or concrete GPU targets.
- `inputs`: input definitions for simple cases, or omit when using
  `input_sets/*.json`.
- `tags`: optional labels for filtering.

Example shape:

```json
{
  "name": "llama_noncont_batched_matmul",
  "project": "llama.cpp",
  "runner": "runner.cpp",
  "kind": "cmake_executable",
  "architectures": ["cdna3", "rdna4"],
  "build": {
    "system": "cmake",
    "target": "llama_cpp_noncont_batched_matmul"
  },
  "run": {
    "args": ["--validate"],
    "timeout_seconds": 60
  },
  "validation": {
    "kind": "exit_code",
    "pass_exit_code": 0
  },
  "tags": ["llama", "matmul", "regression"]
}
```

`corpus/fuzz-targets/cases/<project>/<case>/input_sets/<name>.json`

Optional input-set metadata for cases that should run the same executable with
multiple input definitions. Planned contents:

- `name`: stable input-set identifier used in pytest IDs and artifact paths.
- `description`: human-readable purpose.
- `inputs`: concrete input definitions materialized by pytest.
- `run`: optional run metadata override, such as layout selector arguments.
- `validation`: optional validation override, such as expected exit code.
- `tags`: optional labels for filtering.

`corpus/fuzz-targets/configs/cdna3.json`

Target configuration for CDNA3-class runs. Planned contents:

- config name, such as `cdna3`.
- architecture family and concrete default architectures, such as `gfx942`.
- ROCm/TheRock environment expectations.
- CMake preset or cache variables.
- enabled corpus backends.
- optional run wrapper.
- target-specific skips.
- target-specific expected failures.

`corpus/fuzz-targets/configs/rdna4.json`

Target configuration for RDNA4-class runs. Same shape as `cdna3.json`, but with
RDNA4 architecture defaults and any RDNA4-specific backend enables, skips, or
expected failures.

## Planned Pytest Flow

```text
case.json + optional input-set json + target config
        |
        v
pytest discovers case/input-set/target combinations
        |
        v
pytest asks CMake to configure/build the selected target
        |
        v
CMake builds the runner and linked kernel/source code
        |
        v
pytest runs the resulting executable with declared arguments
        |
        v
pytest validates exit code, expected pass/fail behavior, output text, numeric
checks, and case-specific output files
```

The harness should create stable pytest IDs, write per-case configure/build/run
logs, keep artifacts under a target-specific output directory, and centralize
skip/xfail decisions so target-specific behavior does not get scattered through
case metadata.

## Schema Decision

No JSON schema is required for the first version. The Python loader should be
strict and explicit while the format settles:

- fail on missing required fields.
- reject unsupported `kind` and validation modes.
- reject unknown architecture families when target configs do not support them.
- produce actionable error messages that point at the bad JSON file.

Schemas can be added later if the format stabilizes and many people start
adding cases.
