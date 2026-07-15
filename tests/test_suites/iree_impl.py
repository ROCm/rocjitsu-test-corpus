"""Legacy IREE corpus implementation retained behind the suite adapter.

This file contains the low-level IREE compile/run/output validation logic and
target-config parsing that existed before the unified `test_corpus.py` flow.
"""

import hashlib
import json
import os
import shlex
import shutil
import subprocess
from pathlib import Path

from support.prepare_inputs import (
    load_json,
    load_suite_target_configs,
    resolve_repo_path as _resolve_repo_path,
)


REPO_ROOT = Path(__file__).resolve().parents[2]
CORPUS_ROOT = REPO_ROOT / "corpus" / "iree"
DEFAULT_CONFIGS = tuple(sorted((CORPUS_ROOT / "configs").glob("*.json")))

_COMPILE_CACHE = {}


class CorpusError(Exception):
    pass


class ToolError(CorpusError):
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


class ValidationError(CorpusError):
    pass


def _np():
    import numpy as np

    return np


def split_config_files(value):
    if not value:
        return []
    if isinstance(value, (list, tuple)):
        return [Path(v) for v in value if v]

    # Match the upstream torch_ops convention while accepting os.pathsep too.
    pieces = []
    for chunk in str(value).split(";"):
        pieces.extend(part for part in chunk.split(os.pathsep) if part)
    return [Path(piece) for piece in pieces]


def default_config_files():
    return split_config_files(os.getenv("IREE_TEST_CONFIG_FILES")) or list(DEFAULT_CONFIGS)


def load_target_configs(config_files):
    return load_suite_target_configs(
        config_files,
        repo_root=REPO_ROOT,
        required_fields=("iree_compile_flags", "iree_run_module_flags"),
        allowed_fields={
            "$schema",
            "iree_compile_flags",
            "iree_run_module_flags",
            "expected_compile_failures",
            "expected_run_failures",
        },
    )


def resolve_repo_path(path):
    return _resolve_repo_path(REPO_ROOT, path)


def is_case_json(path):
    path = Path(path)
    if path.suffix != ".json":
        return False
    try:
        relative = path.resolve().relative_to(CORPUS_ROOT)
    except ValueError:
        return False
    if not relative.parts:
        return False
    return relative.parts[0] not in {"configs", "schemas"}


def discover_case_files():
    return sorted(path for path in CORPUS_ROOT.rglob("*.json") if is_case_json(path))


def load_case(case_path):
    case_path = Path(case_path)
    case = load_json(case_path)
    for field in ("name", "kind", "sources", "function"):
        if field not in case:
            raise ValueError(f"{case_path} is missing required field '{field}'")
    if case["kind"] != "run_module":
        raise ValueError(f"{case_path} has unsupported kind '{case['kind']}'")
    if not case["sources"]:
        raise ValueError(f"{case_path} must list at least one source")
    vmfb_names = case.get("vmfb_names") or [
        Path(source).with_suffix(".vmfb").name for source in case["sources"]
    ]
    if len(vmfb_names) != len(case["sources"]):
        raise ValueError(f"{case_path} must have one vmfb_name per source")
    case["vmfb_names"] = vmfb_names
    return case


def case_id(case_path, target_config):
    case = load_case(case_path)
    relative = Path(case_path).resolve().relative_to(CORPUS_ROOT).with_suffix("")
    return f"{target_config['config_name']}::{relative.as_posix()}::{case['name']}"


def build_case(case_path, target_config, artifact_directory):
    case_path = Path(case_path).resolve()
    case_dir = case_path.parent
    case = load_case(case_path)
    artifact_root = resolve_repo_path(artifact_directory)
    run_dir = _run_dir(artifact_root, target_config, case_path, case)
    run_dir.mkdir(parents=True, exist_ok=True)

    modules = [
        compile_source(
            source=case_dir / source,
            vmfb_name=vmfb_name,
            case=case,
            target_config=target_config,
            artifact_root=artifact_root,
        )
        for source, vmfb_name in zip(case["sources"], case["vmfb_names"])
    ]
    return {
        "modules": tuple(modules),
        "run_dir": run_dir,
    }


def run_case(
    case_path,
    target_config,
    artifact_directory,
    *,
    compile_only=False,
    run_wrapper=None,
    modules=None,
):
    case_path = Path(case_path).resolve()
    case_dir = case_path.parent
    case = load_case(case_path)
    if modules is None:
        modules = build_case(case_path, target_config, artifact_directory)["modules"]

    artifact_root = resolve_repo_path(artifact_directory)
    run_dir = _run_dir(artifact_root, target_config, case_path, case)
    run_dir.mkdir(parents=True, exist_ok=True)

    if compile_only or case.get("compile_only", False):
        return

    inputs = materialize_inputs(case, case_dir, run_dir)
    outputs = [run_dir / output for output in case.get("outputs", [])]
    for output in outputs:
        output.parent.mkdir(parents=True, exist_ok=True)

    iree_run_module_command = (
        ["iree-run-module"]
        + target_config.get("iree_run_module_flags", [])
        + case.get("run_flags", [])
        + [f"--module={module}" for module in modules]
        + [f"--function={case['function']}"]
        + [f"--input=@{path}" for path in inputs]
        + [f"--output=@{path}" for path in outputs]
    )
    command = run_module_wrapper(run_wrapper) + iree_run_module_command
    _run_command(command, cwd=case_dir, log_path=run_dir / "run.log", phase="run")
    validate_outputs(case, case_dir, inputs, outputs)


def run_module_wrapper(run_wrapper):
    if run_wrapper is None:
        return []
    wrapper = run_wrapper
    if isinstance(wrapper, str):
        return shlex.split(wrapper)
    return list(wrapper)


def compile_source(*, source, vmfb_name, case, target_config, artifact_root):
    source = Path(source).resolve()
    if not source.exists():
        raise FileNotFoundError(source)
    artifact_root = Path(artifact_root).resolve()

    compile_flags = (
        list(target_config.get("iree_compile_flags", [])) + list(case.get("compile_flags", []))
    )
    cache_key = (
        str(artifact_root),
        target_config["config_name"],
        str(source),
        Path(vmfb_name).name,
        tuple(compile_flags),
    )
    cached = _COMPILE_CACHE.get(cache_key)
    if cached and cached.exists():
        return cached

    output = _compiled_module_path(
        artifact_root=artifact_root,
        target_config=target_config,
        source=source,
        flags=compile_flags,
        vmfb_name=vmfb_name,
    )
    output.parent.mkdir(parents=True, exist_ok=True)

    if not output.exists() or output.stat().st_mtime < source.stat().st_mtime:
        command = ["iree-compile", str(source)] + compile_flags + ["-o", str(output)]
        _run_command(
            command,
            cwd=source.parent,
            log_path=output.with_suffix(output.suffix + ".compile.log"),
            phase="compile",
        )

    _COMPILE_CACHE[cache_key] = output
    return output


def materialize_inputs(case, case_dir, run_dir):
    np = _np()
    np.random.seed(case.get("seed", 0))
    inputs = []
    for index, input_spec in enumerate(case.get("inputs", [])):
        if "Formula" in input_spec:
            tensor = tensor_from_formula(input_spec["Formula"])
            path = run_dir / f"input_{index}.npy"
            np.save(path, tensor)
        elif "File" in input_spec:
            file_spec = input_spec["File"]
            source = (case_dir / file_spec["path"]).resolve()
            if not source.exists():
                raise FileNotFoundError(source)
            path = run_dir / source.name
            if source != path:
                shutil.copyfile(source, path)
        else:
            raise ValidationError(f"Unsupported input spec: {input_spec}")
        inputs.append(path)
    return inputs


def tensor_from_formula(formula):
    np = _np()
    dtype = numpy_dtype(formula["dtype"])
    shape = tuple(formula.get("shape", []))
    coeff = formula.get("coeff", 1)
    offset = formula.get("offset", 0)
    return (coeff * np.random.rand(*shape) + offset).astype(dtype)


def numpy_dtype(dtype):
    np = _np()
    if dtype == "bfloat16":
        raise ValidationError("Formula dtype 'bfloat16' is not supported by numpy")
    return np.dtype(dtype)


def validate_outputs(case, case_dir, inputs, outputs):
    np = _np()
    expected_specs = case.get("expected_output", [])
    checks = case.get("checks", [])
    if not expected_specs and not checks:
        return
    if len(expected_specs) != len(outputs):
        raise ValidationError(
            f"{case['name']} has {len(expected_specs)} expected outputs for "
            f"{len(outputs)} observed outputs"
        )

    observed = [np.load(path) for path in outputs]
    expected = [
        expected_output(spec, case_dir=case_dir, inputs=inputs)
        for spec in expected_specs
    ]
    if not checks:
        checks = [{"kind": "allclose", "output": index} for index in range(len(outputs))]

    for check in checks:
        output_index = check["output"]
        if output_index >= len(observed):
            raise ValidationError(f"Check references missing output {output_index}")
        assert_check(case, check, observed[output_index], expected[output_index])


def expected_output(spec, *, case_dir, inputs):
    np = _np()
    if spec["kind"] == "file":
        return np.load(case_dir / spec["path"])
    if spec["kind"] == "formula":
        op = spec["op"]
        tensors = [np.load(inputs[index]) for index in spec["inputs"]]
        if op == "matmul":
            if len(tensors) != 2:
                raise ValidationError("matmul expected_output requires two inputs")
            return np.matmul(tensors[0], tensors[1])
        raise ValidationError(f"Unsupported expected_output op '{op}'")
    raise ValidationError(f"Unsupported expected_output kind '{spec['kind']}'")


def assert_check(case, check, observed, expected):
    np = _np()
    rtol = check.get("rtol", case.get("rtol", 1e-5))
    atol = check.get("atol", case.get("atol", 1e-8))
    kind = check["kind"]
    if kind == "allclose":
        if not np.allclose(observed, expected, rtol=rtol, atol=atol):
            raise ValidationError(_failure_message("allclose", observed, expected, rtol, atol))
        return
    if kind == "sparse_allclose":
        for raw_index in check["indices"]:
            index = tuple(raw_index)
            if not np.allclose(observed[index], expected[index], rtol=rtol, atol=atol):
                raise ValidationError(
                    _failure_message(f"sparse_allclose at {index}", observed[index], expected[index], rtol, atol)
                )
        return
    if kind == "corner_allclose":
        slices = corner_slices(observed.shape, check["corner"], check["shape"])
        if not np.allclose(observed[slices], expected[slices], rtol=rtol, atol=atol):
            raise ValidationError(
                _failure_message(f"corner_allclose {check['corner']}", observed[slices], expected[slices], rtol, atol)
            )
        return
    raise ValidationError(f"Unsupported check kind '{kind}'")


def corner_slices(output_shape, corner, shape):
    if len(shape) > len(output_shape):
        raise ValidationError(
            f"Corner rank {len(shape)} is greater than output rank {len(output_shape)}"
        )
    slices = []
    for axis, size in enumerate(shape):
        dim = output_shape[axis]
        if size > dim:
            raise ValidationError(f"Corner size {size} exceeds dimension {dim}")
        if corner in {"top_left", "top_right"} or axis < len(shape) - 1:
            start = 0
        else:
            start = dim - size
        if corner in {"top_right", "bottom_right"} and axis == len(shape) - 1:
            start = dim - size
        slices.append(slice(start, start + size))
    return tuple(slices)


def _failure_message(kind, observed, expected, rtol, atol):
    return (
        f"{kind} failed with rtol={rtol}, atol={atol}\n"
        f"observed={observed}\n"
        f"expected={expected}"
    )


def _compiled_module_path(*, artifact_root, target_config, source, flags, vmfb_name):
    relative_source = source.relative_to(CORPUS_ROOT)
    digest = hashlib.sha256(
        json.dumps(
            {
                "source": relative_source.as_posix(),
                "config": target_config["config_name"],
                "flags": flags,
            },
            sort_keys=True,
        ).encode("utf-8")
    ).hexdigest()[:16]
    return (
        Path(artifact_root)
        / target_config["config_name"]
        / "compile-cache"
        / relative_source.parent
        / digest
        / Path(vmfb_name).name
    )


def _run_dir(artifact_root, target_config, case_path, case):
    relative_case = case_path.resolve().relative_to(CORPUS_ROOT).with_suffix("")
    return Path(artifact_root) / target_config["config_name"] / "runs" / relative_case / case["name"]


def _run_command(command, *, cwd, log_path, phase):
    tool = shutil.which(command[0])
    if tool is None:
        raise ToolError(
            message=f"Could not find required tool '{command[0]}' in PATH",
            command=command,
            cwd=cwd,
            returncode=127,
            stdout="",
            stderr="",
            log_path=log_path,
        )
    command = [tool] + command[1:]
    process = subprocess.run(
        command,
        cwd=str(cwd),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        check=False,
    )
    log_path.parent.mkdir(parents=True, exist_ok=True)
    log_path.write_text(
        "\n".join(
            [
                "$ " + " ".join(command),
                f"cwd: {cwd}",
                f"returncode: {process.returncode}",
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
            message=f"IREE {phase} failed",
            command=command,
            cwd=cwd,
            returncode=process.returncode,
            stdout=process.stdout,
            stderr=process.stderr,
            log_path=log_path,
        )
