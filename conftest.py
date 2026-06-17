import os
import shutil
import sys
from pathlib import Path

import pytest

TESTS_DIR = Path(__file__).resolve().parent / "tests"
if str(TESTS_DIR) not in sys.path:
    sys.path.insert(0, str(TESTS_DIR))

from iree_corpus import (  # noqa: E402
    CorpusError,
    default_config_files,
    is_case_json,
    load_case,
    load_target_configs,
    run_case,
)
from fuzz_targets import (  # noqa: E402
    DEFAULT_CASE_TIMEOUT_SECONDS,
    default_config_files as default_fuzz_target_config_files,
    load_target_configs as load_fuzz_target_configs,
)

collect_ignore = ["tests/test_iree_corpus.py"]

def pytest_addoption(parser):
    parser.addoption(
        "--config-files",
        action="store",
        nargs="*",
        default=default_config_files(),
        help="Target config JSON files used to compile and run IREE corpus cases.",
    )
    parser.addoption(
        "--artifact-directory",
        action="store",
        default=".pytest-artifacts",
        help="Directory for compiled VMFBs, materialized inputs, outputs, and logs.",
    )
    parser.addoption(
        "--ignore-xfails",
        action="store_true",
        default=False,
        help="Run expected-failure cases as normal tests.",
    )
    parser.addoption(
        "--skip-all-runs",
        action="store_true",
        default=False,
        help="Compile cases but skip every iree-run-module invocation.",
    )
    parser.addoption(
        "--run-wrapper",
        action="store",
        default=os.getenv("IREE_RUN_MODULE_WRAPPER"),
        help=(
            "Command prefix used to run iree-run-module, for example "
            "'rocjitsu --config configs/amdgpu_gfx1250.json --'. "
            "Can also be set with IREE_RUN_MODULE_WRAPPER."
        ),
    )
    parser.addoption(
        "--fuzz-target-config-files",
        action="store",
        nargs="*",
        default=default_fuzz_target_config_files(),
        help="Target config JSON files used to build and run kernel cases.",
    )
    parser.addoption(
        "--case-timeout",
        action="store",
        type=positive_seconds,
        default=DEFAULT_CASE_TIMEOUT_SECONDS,
        help=(
            "Timeout in seconds for each case phase; run and validation each get "
            "this limit separately. Defaults to 15 seconds."
        ),
    )


def positive_seconds(value):
    timeout = float(value)
    if timeout <= 0:
        raise ValueError("--case-timeout must be a positive number")
    return timeout


def pytest_sessionstart(session):
    session.config.iree_target_configs = load_target_configs(
        session.config.getoption("config_files")
    )
    session.config.fuzz_target_configs = load_fuzz_target_configs(
        session.config.getoption("fuzz_target_config_files")
    )
    repo_root = Path(__file__).resolve().parent
    artifact_root = Path(session.config.getoption("artifact_directory"))
    if not artifact_root.is_absolute():
        artifact_root = repo_root / artifact_root
    artifact_root = artifact_root.resolve()
    if not artifact_root.is_relative_to(repo_root):
        raise pytest.UsageError("--artifact-directory must resolve under the repo root")
    for target_config in session.config.fuzz_target_configs:
        artifact_dir = artifact_root / "fuzz_targets" / target_config["config_name"]
        if artifact_dir.exists():
            shutil.rmtree(artifact_dir)


def pytest_collect_file(parent, file_path):
    if is_case_json(file_path):
        return IreeCorpusJsonFile.from_parent(parent, path=file_path)
    return None


class IreeCorpusJsonFile(pytest.File):
    def collect(self):
        case = load_case(self.path)
        for target_config in self.config.iree_target_configs:
            if case["name"] in target_config.get("skip_compile_tests", []):
                continue
            yield IreeCorpusJsonItem.from_parent(
                self,
                name=f"{target_config['config_name']}::{case['name']}",
                case_path=self.path,
                target_config=target_config,
            )


class IreeCorpusJsonItem(pytest.Item):
    def __init__(self, *, case_path, target_config, **kwargs):
        super().__init__(**kwargs)
        self.case_path = case_path
        self.target_config = target_config
        self.case = load_case(case_path)
        if not self.config.getoption("ignore_xfails"):
            if self.case["name"] in target_config.get("expected_compile_failures", []):
                self.add_marker(
                    pytest.mark.xfail(
                        raises=CorpusError,
                        strict=True,
                        reason="Expected compilation to fail for this target config.",
                    )
                )
            if self.case["name"] in target_config.get("expected_run_failures", []):
                self.add_marker(
                    pytest.mark.xfail(
                        raises=CorpusError,
                        strict=True,
                        reason="Expected execution to fail for this target config.",
                    )
                )

    def runtest(self):
        compile_only = self.config.getoption("skip_all_runs") or (
            self.case["name"] in self.target_config.get("skip_run_tests", [])
        )
        run_case(
            self.case_path,
            self.target_config,
            self.config.getoption("artifact_directory"),
            compile_only=compile_only,
            run_wrapper=self.config.getoption("run_wrapper"),
        )

    def repr_failure(self, excinfo):
        if isinstance(excinfo.value, CorpusError):
            return str(excinfo.value)
        return super().repr_failure(excinfo)

    def reportinfo(self):
        return self.path, 0, f"IREE corpus case: {self.case['name']}"
