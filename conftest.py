import sys
from pathlib import Path

TESTS_DIR = Path(__file__).resolve().parent / "tests"
if str(TESTS_DIR) not in sys.path:
    sys.path.insert(0, str(TESTS_DIR))

def pytest_addoption(parser):
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
        help="Suite selector (iree, kernels, cts). Repeat or pass comma-separated values.",
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


def pytest_report_header(config):
    target = getattr(config, "_corpus_target", None)
    count = getattr(config, "_corpus_case_count", None)
    if target is None or count is None:
        return None
    return f"rocjitsu corpus target={target} selected_cases={count}"
