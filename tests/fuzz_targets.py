import json
import os
import shlex
import shutil
import subprocess
import struct
import time
from dataclasses import dataclass
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
FUZZ_TARGETS_ROOT = REPO_ROOT / "corpus" / "fuzz-targets"
DEFAULT_CONFIG = FUZZ_TARGETS_ROOT / "configs" / "cdna3.json"
SUPPORTED_PROJECTS = {"hip-matmul", "hip-stream-k", "hipkittens", "llama.cpp"}
SUPPORTED_ARCHITECTURE_FAMILIES = {"cdna3", "cdna4", "rdna4"}
SUPPORTED_CASE_KINDS = {"cmake_executable"}
SUPPORTED_VALIDATION_KINDS = {"exit_code"}
SUPPORTED_INPUT_FORMATS = {"raw"}
SUPPORTED_INPUT_DTYPES = {"f32", "f16"}
SUPPORTED_INPUT_GENERATORS = {"repeat_affine", "identity_diagonal", "affine_indices"}
ROCFUZZ_ENABLE_CACHE_VARIABLES = (
    "ROCFUZZ_ENABLE_ALL",
    "ROCFUZZ_ENABLE_HIP_STREAMK",
    "ROCFUZZ_ENABLE_LLAMA_HIP",
    "ROCFUZZ_ENABLE_HIP_MATMUL",
    "ROCFUZZ_ENABLE_HIPKITTENS",
)


class FuzzTargetError(Exception):
    pass


class ToolError(FuzzTargetError):
    def __init__(self, *, message, command, cwd, returncode, stdout, stderr, log_path):
        self.command = command
        self.cwd = cwd
        self.returncode = returncode
        self.stdout = stdout
        self.stderr = stderr
        self.log_path = log_path
        super().__init__(
            "\n".join(
                [
                    message,
                    "Command:",
                    "  " + " ".join(command),
                    f"CWD: {cwd}",
                    f"Return code: {returncode}",
                    f"Log: {log_path}",
                    "stdout:",
                    stdout or "<empty>",
                    "stderr:",
                    stderr or "<empty>",
                ]
            )
        )


@dataclass(frozen=True)
class FuzzCase:
    path: Path
    case: dict
    input_set_path: Path | None = None
    input_set: dict | None = None


@dataclass(frozen=True)
class BuildResult:
    build_dir: Path
    executable_path: Path


def split_config_files(value):
    if not value:
        return []
    if isinstance(value, (list, tuple)):
        return [Path(v) for v in value if v]

    pieces = []
    for chunk in str(value).split(";"):
        pieces.extend(part for part in chunk.split(os.pathsep) if part)
    return [Path(piece) for piece in pieces]


def default_config_files():
    return split_config_files(os.getenv("ROCFUZZ_TEST_CONFIG_FILES")) or [DEFAULT_CONFIG]


def resolve_repo_path(path):
    path = Path(path)
    if path.is_absolute():
        return path
    return REPO_ROOT / path


def load_json(path):
    path = Path(path)
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def load_target_configs(config_files):
    configs = []
    for config_file in config_files:
        path = resolve_repo_path(config_file)
        config = load_json(path)
        require_fields(path, config, ("config_name", "architecture_family", "hip_architectures"))
        reject_unknown_fields(
            path,
            config,
            {
                "config_name",
                "architecture_family",
                "hip_architectures",
                "cmake",
                "run_environment",
                "skip_compile_tests",
                "skip_run_tests",
                "expected_compile_failures",
                "expected_run_failures",
            },
        )
        if config["architecture_family"] not in SUPPORTED_ARCHITECTURE_FAMILIES:
            raise ValueError(
                f"{path} has unsupported architecture_family "
                f"'{config['architecture_family']}'"
            )
        if not config["hip_architectures"]:
            raise ValueError(f"{path} must list at least one HIP architecture")
        config["_path"] = str(path)
        configs.append(config)
    return configs


def discover_cases():
    cases = []
    for case_path in sorted((FUZZ_TARGETS_ROOT / "cases").glob("*/*/case.json")):
        case = load_case(case_path)
        input_set_paths = sorted((case_path.parent / "input_sets").glob("*.json"))
        if input_set_paths:
            for input_set_path in input_set_paths:
                cases.append(
                    FuzzCase(
                        path=case_path,
                        case=case,
                        input_set_path=input_set_path,
                        input_set=load_input_set(input_set_path),
                    )
                )
        else:
            cases.append(FuzzCase(path=case_path, case=case))
    return cases


def load_case(case_path):
    case_path = Path(case_path)
    case = load_json(case_path)
    require_fields(
        case_path,
        case,
        (
            "name",
            "project",
            "runner",
            "kind",
            "architectures",
            "build",
            "run",
            "validation",
        ),
    )
    reject_unknown_fields(
        case_path,
        case,
        {
            "name",
            "project",
            "runner",
            "kind",
            "architectures",
            "build",
            "run",
            "validation",
            "inputs",
            "tags",
        },
    )
    if case["project"] not in SUPPORTED_PROJECTS:
        raise ValueError(f"{case_path} has unsupported project '{case['project']}'")
    if case["kind"] not in SUPPORTED_CASE_KINDS:
        raise ValueError(f"{case_path} has unsupported kind '{case['kind']}'")
    if not case["architectures"]:
        raise ValueError(f"{case_path} must list at least one architecture")
    for architecture in case["architectures"]:
        if architecture not in SUPPORTED_ARCHITECTURE_FAMILIES:
            raise ValueError(f"{case_path} has unsupported architecture '{architecture}'")

    require_fields(case_path, case["build"], ("system", "target"))
    reject_unknown_fields(case_path, case["build"], {"system", "target"})
    if case["build"]["system"] != "cmake":
        raise ValueError(f"{case_path} has unsupported build system '{case['build']['system']}'")

    require_fields(case_path, case["run"], ("args", "gpu_timeout_seconds", "cpu_timeout_seconds"))
    reject_unknown_fields(
        case_path,
        case["run"],
        {"executable", "args", "env", "gpu_timeout_seconds", "cpu_timeout_seconds"},
    )
    _validate_run(case_path, case["run"])

    require_fields(case_path, case["validation"], ("kind", "pass_exit_code"))
    reject_unknown_fields(case_path, case["validation"], {"kind", "pass_exit_code", "abs_tolerance"})
    if case["validation"]["kind"] not in SUPPORTED_VALIDATION_KINDS:
        raise ValueError(
            f"{case_path} has unsupported validation kind "
            f"'{case['validation']['kind']}'"
        )

    if "inputs" in case:
        _validate_inputs(case_path, case["inputs"])
    return case


def load_input_set(input_set_path):
    input_set_path = Path(input_set_path)
    input_set = load_json(input_set_path)
    require_fields(input_set_path, input_set, ("name",))
    reject_unknown_fields(
        input_set_path,
        input_set,
        {"name", "description", "inputs", "run", "validation", "tags"},
    )
    if not isinstance(input_set["name"], str) or not input_set["name"]:
        raise ValueError(f"{input_set_path} field 'name' must be a non-empty string")
    if "inputs" in input_set:
        _validate_inputs(input_set_path, input_set["inputs"])
    if "run" in input_set:
        reject_unknown_fields(
            input_set_path,
            input_set["run"],
            {"executable", "args", "env", "gpu_timeout_seconds", "cpu_timeout_seconds"},
        )
        _validate_run(input_set_path, input_set["run"], require_timeout=False)
    if "validation" in input_set:
        reject_unknown_fields(input_set_path, input_set["validation"], {"kind", "pass_exit_code", "abs_tolerance"})
        if "kind" in input_set["validation"] and input_set["validation"]["kind"] not in SUPPORTED_VALIDATION_KINDS:
            raise ValueError(
                f"{input_set_path} has unsupported validation kind "
                f"'{input_set['validation']['kind']}'"
            )
    return input_set


def require_fields(path, data, fields):
    for field in fields:
        if field not in data:
            raise ValueError(f"{path} is missing required field '{field}'")


def reject_unknown_fields(path, data, allowed_fields):
    unknown = sorted(set(data) - allowed_fields)
    if unknown:
        raise ValueError(f"{path} has unsupported fields: {', '.join(unknown)}")


def _validate_run(path, run, *, require_timeout=True):
    if "args" not in run:
        raise ValueError(f"{path} run is missing required field 'args'")
    if require_timeout:
        for timeout_field in ("gpu_timeout_seconds", "cpu_timeout_seconds"):
            if timeout_field not in run:
                raise ValueError(f"{path} run is missing required field '{timeout_field}'")
    if not isinstance(run["args"], list):
        raise ValueError(f"{path} run field 'args' must be a list")
    for index, arg in enumerate(run["args"]):
        if isinstance(arg, bool) or not isinstance(arg, (str, int, float)):
            raise ValueError(
                f"{path} run args[{index}] must be a string or numeric value"
            )
    for timeout_field in ("gpu_timeout_seconds", "cpu_timeout_seconds"):
        if timeout_field in run and (
            isinstance(run[timeout_field], bool)
            or not isinstance(run[timeout_field], (int, float))
            or run[timeout_field] <= 0
        ):
            raise ValueError(f"{path} run field '{timeout_field}' must be a positive number")


def case_id(fuzz_case, target_config):
    case = fuzz_case.case
    test_id = f"{target_config['config_name']}::{case['project']}/{case['name']}"
    if fuzz_case.input_set is not None:
        test_id += f"::{fuzz_case.input_set['name']}"
    return test_id


def supports_target_config(fuzz_case, target_config):
    return target_config["architecture_family"] in fuzz_case.case["architectures"]


def run_case(fuzz_case, target_config, artifact_directory, *, build_only=False, run_wrapper=None):
    case = effective_case(fuzz_case)
    artifact_root = resolve_repo_path(artifact_directory)
    run_dir = _run_dir(artifact_root, target_config, fuzz_case)
    run_dir.mkdir(parents=True, exist_ok=True)

    build_result = build_runner(case, target_config, artifact_root, run_dir)
    if build_only:
        return
    materialized_inputs = materialize_inputs(case, run_dir)
    run_executable(
        case,
        target_config,
        build_result.build_dir,
        build_result.executable_path,
        run_dir,
        materialized_inputs,
        run_wrapper=run_wrapper,
    )


def build_runner(case, target_config, artifact_root, log_dir):
    artifact_root = Path(artifact_root)
    build_dir = _build_dir(artifact_root, target_config)
    log_dir = Path(log_dir)
    build_dir.mkdir(parents=True, exist_ok=True)
    log_dir.mkdir(parents=True, exist_ok=True)

    configure_cmake(target_config, build_dir, log_dir)
    build_target(case, target_config, build_dir, log_dir)
    return BuildResult(
        build_dir=build_dir,
        executable_path=resolve_executable_path(case, build_dir),
    )


def configure_cmake(target_config, build_dir, log_dir):
    cache_variables = _cmake_cache_variables(target_config)
    cache_variables["CMAKE_HIP_ARCHITECTURES"] = ";".join(target_config["hip_architectures"])
    command = ["cmake", "-S", str(FUZZ_TARGETS_ROOT), "-B", str(build_dir)]
    if "generator" in target_config.get("cmake", {}):
        command.extend(["-G", target_config["cmake"]["generator"]])
    elif shutil.which("ninja"):
        command.extend(["-G", "Ninja"])
    for key, value in sorted(cache_variables.items()):
        command.append(f"-D{key}={value}")
    _run_command(
        command,
        cwd=FUZZ_TARGETS_ROOT,
        log_path=Path(log_dir) / "configure.log",
        phase="configure",
        env=command_environment(target_config),
    )


def build_target(case, target_config, build_dir, log_dir):
    command = [
        "cmake",
        "--build",
        str(build_dir),
        "--target",
        case["build"]["target"],
        "--parallel",
    ]
    _run_command(
        command,
        cwd=FUZZ_TARGETS_ROOT,
        log_path=Path(log_dir) / "build.log",
        phase="build",
        env=command_environment(target_config),
    )


def resolve_executable_path(case, build_dir):
    executable = case["run"].get("executable")
    if executable is None:
        return Path(build_dir) / case["build"]["target"]
    return Path(build_dir) / executable


def effective_case(fuzz_case):
    case = dict(fuzz_case.case)
    if fuzz_case.input_set is None:
        return case

    input_set = fuzz_case.input_set
    if "inputs" in input_set:
        case["inputs"] = input_set["inputs"]
    if "run" in input_set:
        case["run"] = {**case["run"], **input_set["run"]}
    if "validation" in input_set:
        case["validation"] = {**case["validation"], **input_set["validation"]}
    return case


def run_executable(
    case,
    target_config,
    build_dir,
    executable_path,
    run_dir,
    materialized_inputs,
    *,
    run_wrapper=None,
):
    if case["project"] == "llama.cpp":
        run_llama_output_comparison(
            case,
            target_config,
            build_dir,
            executable_path,
            run_dir,
            materialized_inputs,
            run_wrapper=run_wrapper,
        )
        return

    command = run_wrapper_command(run_wrapper, target_config) + [str(executable_path)]
    for input_name, input_path in materialized_inputs:
        command.extend(["--input", f"{input_name}={input_path}"])
    command.extend(_command_args(case["run"].get("args", [])))
    expected_exit_code = int(case["validation"]["pass_exit_code"])
    result = _run_command(
        command,
        cwd=build_dir,
        log_path=run_dir / "run.log",
        phase="run",
        env=command_environment(target_config, case["run"].get("env", {})),
        timeout=case["run"]["gpu_timeout_seconds"],
        expected_returncode=expected_exit_code,
    )
    _write_timing_record(
        run_dir / "timings.json",
        "gpu",
        result,
        timeout_seconds=case["run"]["gpu_timeout_seconds"],
    )


def run_llama_output_comparison(
    case,
    target_config,
    build_dir,
    executable_path,
    run_dir,
    materialized_inputs,
    *,
    run_wrapper=None,
):
    gpu_output_path = run_dir / "gpu_output.f32.raw"
    reference_output_path = run_dir / "reference_output.f32.raw"
    run_args = _command_args(case["run"].get("args", []))
    base_args = _without_validate_args(run_args)
    env = command_environment(target_config, case["run"].get("env", {}))

    gpu_command = run_wrapper_command(run_wrapper, target_config) + _runner_command(
        executable_path,
        materialized_inputs,
        base_args,
        gpu_output_path,
    )
    gpu_result = _run_command(
        gpu_command,
        cwd=build_dir,
        log_path=run_dir / "run.log",
        phase="run",
        env=env,
        timeout=case["run"]["gpu_timeout_seconds"],
        expected_returncode=0,
    )
    _write_timing_record(
        run_dir / "timings.json",
        "gpu",
        gpu_result,
        output_path=gpu_output_path,
        timeout_seconds=case["run"]["gpu_timeout_seconds"],
    )

    reference_command = _runner_command(
        executable_path,
        materialized_inputs,
        [*base_args, "--validate"],
        reference_output_path,
    )
    reference_result = _run_command(
        reference_command,
        cwd=build_dir,
        log_path=run_dir / "validate.log",
        phase="validate",
        env=env,
        timeout=case["run"]["cpu_timeout_seconds"],
        expected_returncode=int(case["validation"]["pass_exit_code"]),
    )
    _write_timing_record(
        run_dir / "timings.json",
        "cpu",
        reference_result,
        output_path=reference_output_path,
        timeout_seconds=case["run"]["cpu_timeout_seconds"],
    )

    if int(case["validation"]["pass_exit_code"]) == 0:
        compare_f32_outputs(
            gpu_output_path,
            reference_output_path,
            abs_tolerance=float(case["validation"].get("abs_tolerance", 0.0)),
        )


def _runner_command(executable_path, materialized_inputs, args, output_path):
    command = [str(executable_path)]
    for input_name, input_path in materialized_inputs:
        command.extend(["--input", f"{input_name}={input_path}"])
    command.extend(_command_args(args))
    command.extend(["--output", str(output_path)])
    return command


def run_wrapper_command(run_wrapper, target_config):
    if run_wrapper is None:
        wrapper = target_config.get("run_wrapper", [])
    else:
        wrapper = run_wrapper
    if isinstance(wrapper, str):
        return shlex.split(wrapper)
    return list(wrapper)


def _command_args(args):
    return [str(arg) for arg in args]


def _without_validate_args(args):
    filtered = []
    for arg in args:
        if arg in {"--validate", "--validate=true"} or arg.startswith("--validate="):
            continue
        filtered.append(arg)
    return filtered


def compare_f32_outputs(gpu_output_path, reference_output_path, *, abs_tolerance):
    gpu_data = Path(gpu_output_path).read_bytes()
    reference_data = Path(reference_output_path).read_bytes()
    if len(gpu_data) != len(reference_data):
        raise FuzzTargetError(
            f"output size mismatch: gpu={gpu_output_path} has {len(gpu_data)} bytes, "
            f"reference={reference_output_path} has {len(reference_data)} bytes"
        )
    if len(gpu_data) % 4 != 0:
        raise FuzzTargetError(f"output is not f32-sized: {gpu_output_path}")

    count = len(gpu_data) // 4
    if count == 0:
        raise FuzzTargetError(f"output is empty: {gpu_output_path}")
    gpu_values = struct.unpack(f"<{count}f", gpu_data)
    reference_values = struct.unpack(f"<{count}f", reference_data)
    max_abs_diff = 0.0
    max_abs_diff_index = 0
    for index, (gpu_value, reference_value) in enumerate(zip(gpu_values, reference_values)):
        abs_diff = abs(gpu_value - reference_value)
        if abs_diff > max_abs_diff:
            max_abs_diff = abs_diff
            max_abs_diff_index = index
    if max_abs_diff > abs_tolerance:
        raise FuzzTargetError(
            f"output mismatch: max_abs_diff={max_abs_diff} at index {max_abs_diff_index}, "
            f"tolerance={abs_tolerance}, gpu={gpu_values[max_abs_diff_index]}, "
            f"reference={reference_values[max_abs_diff_index]}"
        )


def _write_timing_record(
    timings_path,
    key,
    result,
    *,
    output_path=None,
    timeout_seconds=None,
):
    timings_path = Path(timings_path)
    if timings_path.exists():
        timings = load_json(timings_path)
    else:
        timings = {}
    record = {
        "phase": result["phase"],
        "elapsed_seconds": result["elapsed_seconds"],
        "timeout_seconds": timeout_seconds,
        "returncode": result["returncode"],
        "log_path": str(result["log_path"]),
    }
    if output_path is not None:
        record["output_path"] = str(output_path)
    timings[key] = record
    timings_path.write_text(json.dumps(timings, indent=2) + "\n", encoding="utf-8")


def _cmake_cache_variables(target_config):
    cache_variables = dict(target_config.get("cmake", {}).get("cache_variables", {}))
    for key in ROCFUZZ_ENABLE_CACHE_VARIABLES:
        cache_variables[key] = "ON" if str(cache_variables.get(key, "")).upper() == "ON" else "OFF"
    return cache_variables


def _validate_inputs(case_path, inputs):
    if not isinstance(inputs, list) or not inputs:
        raise ValueError(f"{case_path} field 'inputs' must be a non-empty list")
    seen_names = set()
    for index, input_spec in enumerate(inputs):
        entry_path = f"{case_path} inputs[{index}]"
        if not isinstance(input_spec, dict):
            raise ValueError(f"{entry_path} must be an object")
        require_fields(entry_path, input_spec, ("name", "format", "dtype", "shape", "generator"))
        reject_unknown_fields(entry_path, input_spec, {"name", "format", "dtype", "shape", "generator"})
        name = input_spec["name"]
        if not isinstance(name, str) or not name:
            raise ValueError(f"{entry_path} field 'name' must be a non-empty string")
        if name in seen_names:
            raise ValueError(f"{entry_path} duplicates input name '{name}'")
        seen_names.add(name)
        if input_spec["format"] not in SUPPORTED_INPUT_FORMATS:
            raise ValueError(f"{entry_path} has unsupported format '{input_spec['format']}'")
        if input_spec["dtype"] not in SUPPORTED_INPUT_DTYPES:
            raise ValueError(f"{entry_path} has unsupported dtype '{input_spec['dtype']}'")
        shape = input_spec["shape"]
        if not isinstance(shape, list) or not shape:
            raise ValueError(f"{entry_path} field 'shape' must be a non-empty list")
        for axis, dim in enumerate(shape):
            if not isinstance(dim, int) or dim <= 0:
                raise ValueError(f"{entry_path} shape[{axis}] must be a positive integer")
        _validate_generator(entry_path, input_spec["generator"], shape)


def _validate_generator(entry_path, generator, shape):
    if not isinstance(generator, dict):
        raise ValueError(f"{entry_path} field 'generator' must be an object")
    require_fields(entry_path, generator, ("kind",))
    kind = generator["kind"]
    if kind not in SUPPORTED_INPUT_GENERATORS:
        raise ValueError(f"{entry_path} has unsupported generator kind '{kind}'")

    if kind == "repeat_affine":
        require_fields(entry_path, generator, ("kind", "period", "scale", "offset"))
        reject_unknown_fields(entry_path, generator, {"kind", "period", "scale", "offset"})
        if not isinstance(generator["period"], int) or generator["period"] <= 0:
            raise ValueError(f"{entry_path} repeat_affine period must be a positive integer")
        _require_numeric(entry_path, "repeat_affine scale", generator["scale"])
        _require_numeric(entry_path, "repeat_affine offset", generator["offset"])
        return

    if kind == "identity_diagonal":
        require_fields(entry_path, generator, ("kind", "diagonal_value", "other_value"))
        reject_unknown_fields(entry_path, generator, {"kind", "diagonal_value", "other_value"})
        if len(shape) != 2:
            raise ValueError(f"{entry_path} identity_diagonal requires a rank-2 shape")
        _require_numeric(entry_path, "identity_diagonal diagonal_value", generator["diagonal_value"])
        _require_numeric(entry_path, "identity_diagonal other_value", generator["other_value"])
        return

    require_fields(entry_path, generator, ("kind", "coefficients", "bias"))
    reject_unknown_fields(entry_path, generator, {"kind", "coefficients", "bias"})
    coefficients = generator["coefficients"]
    if not isinstance(coefficients, list) or len(coefficients) != len(shape):
        raise ValueError(
            f"{entry_path} affine_indices coefficients must be a list with one entry per shape axis"
        )
    for coeff in coefficients:
        _require_numeric(entry_path, "affine_indices coefficient", coeff)
    _require_numeric(entry_path, "affine_indices bias", generator["bias"])


def _require_numeric(entry_path, field_name, value):
    if not isinstance(value, (int, float)):
        raise ValueError(f"{entry_path} field '{field_name}' must be numeric")


def materialize_inputs(case, run_dir):
    inputs = case.get("inputs", [])
    if not inputs:
        return []
    inputs_dir = run_dir / "inputs"
    inputs_dir.mkdir(parents=True, exist_ok=True)
    materialized = []
    for input_spec in inputs:
        input_name = input_spec["name"]
        dtype = input_spec["dtype"]
        output_path = inputs_dir / f"{input_name}.{dtype}.raw"
        raw_data = _materialize_input_bytes(input_spec)
        output_path.write_bytes(raw_data)
        materialized.append((input_name, output_path))
    return materialized


def _materialize_input_bytes(input_spec):
    shape = input_spec["shape"]
    generator = input_spec["generator"]
    values = (_generate_value(generator, _unflatten_index(flat_index, shape), flat_index) for flat_index in range(_num_elements(shape)))
    if input_spec["dtype"] == "f32":
        return b"".join(struct.pack("<f", float(value)) for value in values)
    return b"".join(struct.pack("<e", float(value)) for value in values)


def _generate_value(generator, indices, flat_index):
    kind = generator["kind"]
    if kind == "repeat_affine":
        period_index = flat_index % generator["period"]
        return float(generator["scale"]) * float(period_index + generator["offset"])
    if kind == "identity_diagonal":
        return float(generator["diagonal_value"]) if indices[0] == indices[1] else float(generator["other_value"])
    value = float(generator["bias"])
    for coeff, index in zip(generator["coefficients"], indices):
        value += float(coeff) * float(index)
    return value


def _unflatten_index(flat_index, shape):
    indices = []
    remaining = flat_index
    for dim in shape:
        indices.append(remaining % dim)
        remaining //= dim
    return indices


def _num_elements(shape):
    total = 1
    for dim in shape:
        total *= dim
    return total


def command_environment(target_config, extra_environment=None):
    env = os.environ.copy()
    env.update({str(k): str(v) for k, v in target_config.get("run_environment", {}).items()})
    if extra_environment:
        env.update({str(k): str(v) for k, v in extra_environment.items()})

    rocm_path = env.get("ROCFUZZ_THEROCK_ROCM_PATH") or env.get("ROCM_PATH")
    if rocm_path:
        library_paths = [str(Path(rocm_path) / "lib"), str(Path(rocm_path) / "lib64")]
        existing = env.get("LD_LIBRARY_PATH")
        if existing:
            library_paths.append(existing)
        env["LD_LIBRARY_PATH"] = os.pathsep.join(library_paths)
    return env


def _build_dir(artifact_root, target_config):
    return Path(artifact_root) / "fuzz_targets" / target_config["config_name"] / "build"


def _run_dir(artifact_root, target_config, fuzz_case):
    relative_case = fuzz_case.path.resolve().relative_to(FUZZ_TARGETS_ROOT).parent
    run_dir = (
        Path(artifact_root)
        / "fuzz_targets"
        / target_config["config_name"]
        / "runs"
        / relative_case
    )
    if fuzz_case.input_set is not None:
        run_dir = run_dir / fuzz_case.input_set["name"]
    return run_dir


def _run_command(
    command,
    *,
    cwd,
    log_path,
    phase,
    env,
    timeout=None,
    expected_returncode=0,
):
    command = _resolve_command(command)
    started_at = time.perf_counter()
    try:
        process = subprocess.run(
            command,
            cwd=str(cwd),
            env=env,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            errors="replace",
            check=False,
            timeout=timeout,
        )
        returncode = process.returncode
        stdout = process.stdout
        stderr = process.stderr
    except subprocess.TimeoutExpired as exc:
        returncode = 124
        stdout = _to_text(exc.stdout)
        stderr = _to_text(exc.stderr)
    elapsed_seconds = time.perf_counter() - started_at

    log_path.parent.mkdir(parents=True, exist_ok=True)
    log_path.write_text(
        "\n".join(
            [
                "$ " + " ".join(shlex.quote(part) for part in command),
                f"cwd: {cwd}",
                f"returncode: {returncode}",
                f"elapsed_seconds: {elapsed_seconds:.6f}",
                "",
                "stdout:",
                stdout,
                "",
                "stderr:",
                stderr,
            ]
        ),
        encoding="utf-8",
    )
    if returncode != expected_returncode:
        raise ToolError(
            message=f"fuzz-target {phase} failed",
            command=command,
            cwd=cwd,
            returncode=returncode,
            stdout=stdout,
            stderr=stderr,
            log_path=log_path,
        )
    return {
        "phase": phase,
        "command": command,
        "cwd": cwd,
        "returncode": returncode,
        "elapsed_seconds": elapsed_seconds,
        "log_path": log_path,
    }


def _to_text(value):
    if value is None:
        return ""
    if isinstance(value, bytes):
        return value.decode("utf-8", errors="replace")
    return str(value)


def _resolve_command(command):
    first = command[0]
    if os.sep in first:
        if not Path(first).exists():
            raise FileNotFoundError(first)
        return command
    tool = shutil.which(first)
    if tool is None:
        raise ToolError(
            message=f"Could not find required tool '{first}' in PATH",
            command=command,
            cwd=Path.cwd(),
            returncode=127,
            stdout="",
            stderr="",
            log_path="<not written>",
        )
    return [tool] + command[1:]
