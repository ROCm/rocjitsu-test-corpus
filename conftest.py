import os
import sys
from pathlib import Path

import pytest

TESTS_DIR = Path(__file__).resolve().parent / "tests"
if str(TESTS_DIR) not in sys.path:
    sys.path.insert(0, str(TESTS_DIR))

from support.prepare_inputs import parse_csv_values  # noqa: E402


def pytest_addoption(parser):
    from test_suites import dbt

    parser.addoption(
        "--target",
        action="store",
        default=None,
        help=(
            "Concrete gfx target to run (for example gfx1201, gfx1250, gfx942). "
            "Defaults to gfx1201."
        ),
    )
    parser.addoption(
        "--suite",
        action="append",
        default=[],
        help=(
            "Suite selector (iree, kernels, cts, dbt, semantics, llama). "
            "Repeat or pass "
            "comma-separated values."
        ),
    )
    parser.addoption(
        "--exclude-suite",
        action="append",
        default=[],
        help="Exclude suite selector.",
    )
    parser.addoption(
        "--backend",
        action="append",
        default=[],
        help="Kernel backend selector (for example hipkittens).",
    )
    parser.addoption(
        "--exclude-backend",
        action="append",
        default=[],
        help="Exclude kernel backend selector.",
    )
    parser.addoption(
        "--case",
        action="append",
        default=[],
        help="Include case selector (case id or case selector name).",
    )
    parser.addoption(
        "--exclude-case",
        action="append",
        default=[],
        help="Exclude case selector (case id or case selector name).",
    )
    parser.addoption(
        "--skip-tests-config",
        action="store",
        default=None,
        help=(
            "JSON file containing suite-specific test selectors to skip, keyed "
            "by suite name."
        ),
    )
    parser.addoption(
        "--artifact-directory",
        action="store",
        default=".pytest-artifacts",
        help="Directory for build artifacts, logs, and generated outputs.",
    )
    parser.addoption(
        "--skip-all-runs",
        action="store_true",
        default=False,
        help="Build/compile only and skip runtime execution where supported.",
    )
    parser.addoption(
        "--run-wrapper",
        action="store",
        default=None,
        help=(
            "Shell-style command prefix for suite runtime commands, for example "
            "'rocjitsu --config /path/to/config.json --'."
        ),
    )
    parser.addoption(
        "--comparison-run-wrapper",
        action="store",
        default=None,
        help=(
            "Second shell-style command prefix for exact semantic-result "
            "comparison against --run-wrapper."
        ),
    )
    parser.addoption(
        "--comparison-required-stderr",
        action="append",
        default=[],
        help=(
            "Text that must occur in each comparison run's stderr. Repeat for "
            "multiple required fragments."
        ),
    )
    parser.addoption(
        "--run-tests-config",
        action="store",
        default=None,
        help=(
            "JSON file containing suite-specific test selectors to include, "
            "keyed by suite name."
        ),
    )
    dbt.add_pytest_options(parser)


# Pytest hook: called during configuration before collection starts.
def pytest_configure(config):
    _validate_comparison_options(config)
    _configure_xdist_loadgroup(config)


def pytest_report_header(config):
    target = getattr(config, "_corpus_target", None)
    count = getattr(config, "_corpus_case_count", None)
    if target is None or count is None:
        return None
    return f"rocjitsu corpus target={target} selected_cases={count}"


def pytest_xdist_make_scheduler(config, log):
    if _requested_numprocesses(config) <= 1:
        return None
    from xdist.scheduler.loadgroup import LoadGroupScheduling

    return LoadGroupScheduling(config, log)


def _configure_xdist_loadgroup(config) -> None:
    if _requested_numprocesses(config) <= 1:
        return
    if hasattr(config.option, "loadgroup"):
        config.option.loadgroup = True
    if not hasattr(config.option, "dist"):
        return
    if getattr(config.option, "dist", None) in (None, "", "no", "load"):
        config.option.dist = "loadgroup"


def _validate_comparison_options(config) -> None:
    comparison_wrapper = config.getoption("comparison_run_wrapper")
    required_stderr = config.getoption("comparison_required_stderr")

    if comparison_wrapper is not None and not comparison_wrapper.strip():
        raise pytest.UsageError("--comparison-run-wrapper must not be empty")
    if any(not fragment for fragment in required_stderr):
        raise pytest.UsageError("--comparison-required-stderr must not be empty")
    if required_stderr and comparison_wrapper is None:
        raise pytest.UsageError(
            "--comparison-required-stderr requires --comparison-run-wrapper"
        )
    if comparison_wrapper is None:
        return

    selected_suites = parse_csv_values(config.getoption("suite"))
    if selected_suites != ("semantics",):
        raise pytest.UsageError(
            "--comparison-run-wrapper requires selecting only --suite semantics"
        )


def _requested_numprocesses(config) -> int:
    worker_count = os.getenv("PYTEST_XDIST_WORKER_COUNT")
    if worker_count:
        try:
            return max(1, int(worker_count))
        except ValueError:
            pass
    numprocesses = getattr(config.option, "numprocesses", None)
    if numprocesses in (None, 0, "0"):
        return 1
    if isinstance(numprocesses, int):
        return max(1, numprocesses)
    text = str(numprocesses).strip().lower()
    if text in {"", "no"}:
        return 1
    if text in {"auto", "logical"}:
        return max(1, os.cpu_count() or 1)
    try:
        return max(1, int(text))
    except ValueError:
        return 1
