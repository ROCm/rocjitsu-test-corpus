import json
import sys
from pathlib import Path

TESTS_DIR = Path(__file__).resolve().parent / "tests"
if str(TESTS_DIR) not in sys.path:
    sys.path.insert(0, str(TESTS_DIR))


_TIMEOUT_FAILURE_MARKERS = (
    "Failed: Timeout",
    "pytest-timeout",
    "timed out",
)


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
        "--run-tests-config",
        action="store",
        default=None,
        help=(
            "JSON file containing suite-specific test selectors to include, "
            "keyed by suite name."
        ),
    )
    parser.addoption(
        "--timeout-failures-config",
        action="store",
        default=None,
        help=(
            "Write a JSON file containing suite-specific selectors for tests "
            "that failed because pytest-timeout fired."
        ),
    )
    parser.addoption(
        "--non-timeout-failures-config",
        action="store",
        default=None,
        help=(
            "Write a JSON file containing suite-specific selectors for tests "
            "that failed for reasons other than pytest-timeout."
        ),
    )


def pytest_configure(config):
    timeout_failures_config = config.getoption("timeout_failures_config")
    non_timeout_failures_config = config.getoption("non_timeout_failures_config")
    if timeout_failures_config is None and non_timeout_failures_config is None:
        return
    config.pluginmanager.register(
        _FailureRecorder(
            _optional_path(timeout_failures_config),
            _optional_path(non_timeout_failures_config),
        ),
        "corpus-timeout-failure-recorder",
    )


def pytest_report_header(config):
    target = getattr(config, "_corpus_target", None)
    count = getattr(config, "_corpus_case_count", None)
    if target is None or count is None:
        return None
    return f"rocjitsu corpus target={target} selected_cases={count}"


class _FailureRecorder:
    def __init__(
        self,
        timeout_output_path: Path | None,
        non_timeout_output_path: Path | None,
    ):
        self._timeout_output_path = timeout_output_path
        self._non_timeout_output_path = non_timeout_output_path
        self._timeout_selectors: dict[str, list[str]] = {}
        self._non_timeout_selectors: dict[str, list[str]] = {}
        self._cases_by_nodeid = {}
        self._seen_nodeids = set()

    def pytest_collection_modifyitems(self, session, config, items):
        for item in items:
            callspec = getattr(item, "callspec", None)
            if callspec is None:
                continue
            corpus_case = callspec.params.get("corpus_case")
            if corpus_case is not None:
                self._cases_by_nodeid[item.nodeid] = corpus_case

    def pytest_sessionstart(self, session):
        _write_selector_config(self._timeout_output_path, {})
        _write_selector_config(self._non_timeout_output_path, {})

    def pytest_runtest_logreport(self, report):
        if not report.failed:
            return
        corpus_case = self._cases_by_nodeid.get(report.nodeid)
        if corpus_case is None:
            return
        if report.nodeid in self._seen_nodeids:
            return
        self._seen_nodeids.add(report.nodeid)
        if _is_timeout_failure(report):
            _append_selector(self._timeout_selectors, corpus_case)
        else:
            _append_selector(self._non_timeout_selectors, corpus_case)

    def pytest_sessionfinish(self, session, exitstatus):
        _write_selector_config(self._timeout_output_path, self._timeout_selectors)
        _write_selector_config(
            self._non_timeout_output_path,
            self._non_timeout_selectors,
        )


def _is_timeout_failure(report) -> bool:
    longrepr = getattr(report, "longreprtext", "")
    return any(marker in longrepr for marker in _TIMEOUT_FAILURE_MARKERS)


def _optional_path(path: str | None) -> Path | None:
    if path is None:
        return None
    return Path(path)


def _append_selector(selectors_by_suite: dict[str, list[str]], corpus_case) -> None:
    selectors_by_suite.setdefault(corpus_case.suite, []).append(corpus_case.id)


def _write_selector_config(path: Path | None, selectors_by_suite) -> None:
    if path is None:
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        suite: selectors
        for suite, selectors in selectors_by_suite.items()
        if selectors
    }
    path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
