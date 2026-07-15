"""Core datamodels used by corpus discovery, selection, and execution."""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Mapping


@dataclass(frozen=True)
class TargetSpec:
    target: str

    @property
    def hip_architectures(self) -> tuple[str, ...]:
        return (self.target,)


@dataclass(frozen=True)
class CorpusCase:
    id: str
    suite: str
    target: str
    collection: str | None
    backend: str | None
    path: Path
    build: Mapping[str, Any]
    run: Mapping[str, Any]
    metadata: Mapping[str, Any] = field(default_factory=dict)
    selector_names: tuple[str, ...] = ()
    expected_compile_failure: bool = False
    expected_run_failure: bool = False


@dataclass(frozen=True)
class SelectionOptions:
    include_suites: tuple[str, ...] = ()
    exclude_suites: tuple[str, ...] = ()
    include_backends: tuple[str, ...] = ()
    exclude_backends: tuple[str, ...] = ()
    include_cases: tuple[str, ...] = ()
    exclude_cases: tuple[str, ...] = ()


@dataclass(frozen=True)
class RunContext:
    repo_root: Path
    artifact_directory: Path
    skip_all_runs: bool
    run_wrapper: str | None = None


@dataclass
class BuildState:
    """Mutable build coordination state owned by a single BuildManager session."""

    configured_build_dirs: frozenset[Path] = frozenset()


@dataclass(frozen=True)
class BuildResult:
    build_dir: Path | None
    executable_path: Path | None
    metadata: Mapping[str, Any] = field(default_factory=dict)
