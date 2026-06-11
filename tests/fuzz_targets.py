import json
import os
import shlex
import shutil
import subprocess
import struct
from dataclasses import dataclass
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
FUZZ_TARGETS_ROOT = REPO_ROOT / "corpus" / "fuzz-targets"
DEFAULT_CONFIG = FUZZ_TARGETS_ROOT / "configs" / "cdna3.json"
SUPPORTED_PROJECTS = {"hip-matmul", "llama.cpp"}
SUPPORTED_ARCHITECTURE_FAMILIES = {"cdna3", "rdna4"}
SUPPORTED_CASE_KINDS = {"cmake_executable"}
SUPPORTED_VALIDATION_KINDS = {"exit_code"}
SUPPORTED_VARIANT_ROLES = {"upstream", "bug", "fix"}
SUPPORTED_VARIANT_EXPECTATIONS = {"pass", "fail"}
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
    variant_path: Path
    case: dict
    variant: dict


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
        variants_root = case_path.parent / "variants"
        variant_paths = sorted(variants_root.glob("*/variant.json"))
        if not variant_paths:
            raise ValueError(f"{case_path} has no variant.json files under {variants_root}")
        for variant_path in variant_paths:
            cases.append(
                FuzzCase(
                    path=case_path,
                    variant_path=variant_path,
                    case=case,
                    variant=load_variant(variant_path),
                )
            )
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
            "default_variant",
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
            "default_variant",
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

    require_fields(case_path, case["run"], ("args", "timeout_seconds"))
    reject_unknown_fields(case_path, case["run"], {"executable", "args", "env", "timeout_seconds"})

    require_fields(case_path, case["validation"], ("kind", "pass_exit_code"))
    reject_unknown_fields(case_path, case["validation"], {"kind", "pass_exit_code"})
    if case["validation"]["kind"] not in SUPPORTED_VALIDATION_KINDS:
        raise ValueError(
            f"{case_path} has unsupported validation kind "
            f"'{case['validation']['kind']}'"
        )

    if case["project"] == "llama.cpp" and "inputs" not in case:
        raise ValueError(f"{case_path} is missing required field 'inputs' for llama.cpp")
    if "inputs" in case:
        _validate_inputs(case_path, case["inputs"])
    return case


def load_variant(variant_path):
    variant_path = Path(variant_path)
    variant = load_json(variant_path)
    require_fields(
        variant_path,
        variant,
        ("name", "description", "role", "source_overlay", "patches", "expect"),
    )
    reject_unknown_fields(
        variant_path,
        variant,
        {
            "name",
            "description",
            "role",
            "source_overlay",
            "patches",
            "expect",
            "build",
            "run",
            "upstream_commit",
            "trigger",
        },
    )
    if variant["role"] not in SUPPORTED_VARIANT_ROLES:
        raise ValueError(f"{variant_path} has unsupported role '{variant['role']}'")
    if variant["expect"] not in SUPPORTED_VARIANT_EXPECTATIONS:
        raise ValueError(f"{variant_path} has unsupported expect '{variant['expect']}'")
    if "build" in variant:
        require_fields(variant_path, variant["build"], ("target",))
        reject_unknown_fields(variant_path, variant["build"], {"target"})
    if "run" in variant:
        reject_unknown_fields(variant_path, variant["run"], {"executable", "args", "env", "timeout_seconds"})
    return variant


def require_fields(path, data, fields):
    for field in fields:
        if field not in data:
            raise ValueError(f"{path} is missing required field '{field}'")


def reject_unknown_fields(path, data, allowed_fields):
    unknown = sorted(set(data) - allowed_fields)
    if unknown:
        raise ValueError(f"{path} has unsupported fields: {', '.join(unknown)}")


def case_id(fuzz_case, target_config):
    case = fuzz_case.case
    return f"{target_config['config_name']}::{case['project']}/{case['name']}::{fuzz_case.variant['name']}"


def supports_target_config(fuzz_case, target_config):
    return target_config["architecture_family"] in fuzz_case.case["architectures"]


def run_case(fuzz_case, target_config, artifact_directory, *, build_only=False):
    case = effective_case(fuzz_case)
    artifact_root = resolve_repo_path(artifact_directory)
    build_dir = _build_dir(artifact_root, target_config)
    run_dir = _run_dir(artifact_root, target_config, fuzz_case)
    build_dir.mkdir(parents=True, exist_ok=True)
    run_dir.mkdir(parents=True, exist_ok=True)

    configure_cmake(target_config, build_dir, run_dir)
    build_target(case, target_config, build_dir, run_dir)
    if build_only:
        return
    materialized_inputs = materialize_inputs(case, run_dir)
    run_executable(case, target_config, build_dir, run_dir, materialized_inputs)


def effective_case(fuzz_case):
    case = dict(fuzz_case.case)
    variant = fuzz_case.variant
    if "build" in variant:
        case["build"] = {**case["build"], **variant["build"]}
    if "run" in variant:
        case["run"] = {**case["run"], **variant["run"]}
    return case


def configure_cmake(target_config, build_dir, run_dir):
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
        log_path=run_dir / "configure.log",
        phase="configure",
        env=_command_environment(target_config),
    )


def build_target(case, target_config, build_dir, run_dir):
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
        log_path=run_dir / "build.log",
        phase="build",
        env=_command_environment(target_config),
    )


def run_executable(case, target_config, build_dir, run_dir, materialized_inputs):
    executable = case["run"].get("executable")
    if executable is None:
        executable_path = build_dir / case["build"]["target"]
    else:
        executable_path = build_dir / executable
    command = [str(executable_path)]
    for input_name, input_path in materialized_inputs:
        command.extend(["--input", f"{input_name}={input_path}"])
    command.extend(list(case["run"].get("args", [])))
    expected_exit_code = int(case["validation"]["pass_exit_code"])
    _run_command(
        command,
        cwd=build_dir,
        log_path=run_dir / "run.log",
        phase="run",
        env=_command_environment(target_config, case["run"].get("env", {})),
        timeout=case["run"]["timeout_seconds"],
        expected_returncode=expected_exit_code,
    )


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


def _command_environment(target_config, extra_environment=None):
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
    return (
        Path(artifact_root)
        / "fuzz_targets"
        / target_config["config_name"]
        / "runs"
        / relative_case
        / fuzz_case.variant["name"]
    )


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
    try:
        process = subprocess.run(
            command,
            cwd=str(cwd),
            env=env,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=False,
            timeout=timeout,
        )
        returncode = process.returncode
        stdout = process.stdout
        stderr = process.stderr
    except subprocess.TimeoutExpired as exc:
        returncode = 124
        stdout = exc.stdout or ""
        stderr = exc.stderr or ""

    log_path.parent.mkdir(parents=True, exist_ok=True)
    log_path.write_text(
        "\n".join(
            [
                "$ " + " ".join(shlex.quote(part) for part in command),
                f"cwd: {cwd}",
                f"returncode: {returncode}",
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
