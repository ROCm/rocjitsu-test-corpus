import json
import os
import shlex
import shutil
import subprocess
import time
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
CTS_ROOT = REPO_ROOT / "corpus" / "cts"
DEFAULT_CONFIG = CTS_ROOT / "configs" / "gfx1250.json"

_CONFIGURED_BUILDS = set()


class FpsanError(Exception):
    pass


class ToolError(FpsanError):
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
                    "  " + " ".join(shlex.quote(part) for part in command),
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
    return split_config_files(os.getenv("FPSAN_TEST_CONFIG_FILES")) or [DEFAULT_CONFIG]


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
        require_fields(path, config, ("config_name", "hip_architectures", "tests"))
        reject_unknown_fields(
            path,
            config,
            {
                "config_name",
                "hip_architectures",
                "tests",
                "cmake",
                "run_environment",
                "skip_tests",
                "expected_failures",
                "expected_compile_failures",
                "expected_run_failures",
            },
        )
        if not isinstance(config["config_name"], str) or not config["config_name"]:
            raise ValueError(f"{path} has invalid config_name")
        if not isinstance(config["hip_architectures"], list) or not config["hip_architectures"]:
            raise ValueError(f"{path} field 'hip_architectures' must be a non-empty list")
        if not isinstance(config["tests"], list) or not config["tests"]:
            raise ValueError(f"{path} field 'tests' must be a non-empty list")
        for field in (
            "hip_architectures",
            "tests",
            "skip_tests",
            "expected_failures",
            "expected_compile_failures",
            "expected_run_failures",
        ):
            _validate_string_list(path, config, field)
        _validate_cmake_config(path, config.get("cmake", {}))
        config["_path"] = str(path)
        configs.append(config)
    return configs


def require_fields(path, data, fields):
    for field in fields:
        if field not in data:
            raise ValueError(f"{path} is missing required field '{field}'")


def reject_unknown_fields(path, data, allowed_fields):
    unknown = sorted(set(data) - allowed_fields)
    if unknown:
        raise ValueError(f"{path} has unsupported fields: {', '.join(unknown)}")


def _validate_string_list(path, config, field):
    values = config.get(field, [])
    if not isinstance(values, list):
        raise ValueError(f"{path} field '{field}' must be a list")
    for index, value in enumerate(values):
        if not isinstance(value, str) or not value:
            raise ValueError(f"{path} field '{field}' item {index} must be a non-empty string")


def _validate_cmake_config(path, cmake):
    if not isinstance(cmake, dict):
        raise ValueError(f"{path} field 'cmake' must be an object")
    reject_unknown_fields(f"{path} cmake", cmake, {"generator", "cache_variables"})
    cache_variables = cmake.get("cache_variables", {})
    if not isinstance(cache_variables, dict):
        raise ValueError(f"{path} cmake.cache_variables must be an object")
    for name, value in cache_variables.items():
        if isinstance(value, bool) or not isinstance(value, (str, int, float)):
            raise ValueError(
                f"{path} cmake cache variable '{name}' must be a string or numeric value"
            )


def case_id(test_name, target_config):
    return f"{target_config['config_name']}::{test_name}"


def run_case(test_name, target_config, artifact_directory, *, build_only=False):
    artifact_root = resolve_repo_path(artifact_directory)
    build_dir = _build_dir(artifact_root, target_config)
    run_dir = _run_dir(artifact_root, target_config, test_name)
    run_dir.mkdir(parents=True, exist_ok=True)

    configure_cts(target_config, build_dir, run_dir)
    if build_only:
        return
    if not _is_compile_fail_test(test_name):
        build_target(test_name, target_config, build_dir, run_dir)
    run_ctest(test_name, target_config, build_dir, run_dir)


def configure_cts(target_config, build_dir, log_dir):
    cache_key = (str(build_dir), target_config["config_name"])
    if cache_key in _CONFIGURED_BUILDS:
        return

    build_dir.mkdir(parents=True, exist_ok=True)
    command = ["cmake", "-S", str(CTS_ROOT), "-B", str(build_dir)]
    if "generator" in target_config.get("cmake", {}):
        command.extend(["-G", target_config["cmake"]["generator"]])
    elif shutil.which("ninja"):
        command.extend(["-G", "Ninja"])
    command.append(f"-DCMAKE_HIP_ARCHITECTURES={';'.join(target_config['hip_architectures'])}")
    for key, value in sorted(_cmake_cache_variables(target_config).items()):
        command.append(f"-D{key}={value}")
    _run_command(
        command,
        cwd=CTS_ROOT,
        log_path=Path(log_dir) / "configure.log",
        phase="configure",
        env=command_environment(target_config),
    )
    _CONFIGURED_BUILDS.add(cache_key)


def build_target(test_name, target_config, build_dir, log_dir):
    command = ["cmake", "--build", str(build_dir), "--target", test_name, "--parallel"]
    _run_command(
        command,
        cwd=CTS_ROOT,
        log_path=Path(log_dir) / "build.log",
        phase="build",
        env=command_environment(target_config),
    )


def run_ctest(test_name, target_config, build_dir, log_dir):
    command = [
        "ctest",
        "--test-dir",
        str(build_dir),
        "-R",
        f"^{test_name}$",
        "--output-on-failure",
    ]
    _run_command(
        command,
        cwd=CTS_ROOT,
        log_path=Path(log_dir) / "ctest.log",
        phase="ctest",
        env=command_environment(target_config),
    )


def command_environment(target_config):
    env = os.environ.copy()
    env.update({str(k): str(v) for k, v in target_config.get("run_environment", {}).items()})
    rocm_path = env.get("ROCM_PATH")
    if rocm_path:
        library_paths = [str(Path(rocm_path) / "lib"), str(Path(rocm_path) / "lib64")]
        existing = env.get("LD_LIBRARY_PATH")
        if existing:
            library_paths.append(existing)
        env["LD_LIBRARY_PATH"] = os.pathsep.join(library_paths)
    return env


def _cmake_cache_variables(target_config):
    return dict(target_config.get("cmake", {}).get("cache_variables", {}))


def _is_compile_fail_test(test_name):
    return test_name.startswith("fpsan_neg_")


def _build_dir(artifact_root, target_config):
    return Path(artifact_root) / "cts" / target_config["config_name"] / "build"


def _run_dir(artifact_root, target_config, test_name):
    return Path(artifact_root) / "cts" / target_config["config_name"] / "runs" / test_name


def _run_command(command, *, cwd, log_path, phase, env):
    command = _resolve_command(command)
    started_at = time.perf_counter()
    process = subprocess.run(
        command,
        cwd=str(cwd),
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        errors="replace",
        check=False,
    )
    elapsed_seconds = time.perf_counter() - started_at
    log_path = Path(log_path)
    log_path.parent.mkdir(parents=True, exist_ok=True)
    log_path.write_text(
        "\n".join(
            [
                "$ " + " ".join(shlex.quote(part) for part in command),
                f"cwd: {cwd}",
                f"returncode: {process.returncode}",
                f"elapsed_seconds: {elapsed_seconds:.6f}",
                "",
                "stdout:",
                process.stdout,
                "",
                "stderr:",
                process.stderr,
            ]
        ),
        encoding="utf-8",
    )
    if process.returncode != 0:
        raise ToolError(
            message=f"FPSAN CTS {phase} failed",
            command=command,
            cwd=cwd,
            returncode=process.returncode,
            stdout=process.stdout,
            stderr=process.stderr,
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
