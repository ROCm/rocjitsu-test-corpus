import os
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


def pytest_sessionstart(session):
    session.config.iree_target_configs = load_target_configs(
        session.config.getoption("config_files")
    )


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
