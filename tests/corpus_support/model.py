"""Core datamodels used by corpus discovery, selection, and execution.

These dataclasses define the normalized contract between:
- target capability loading (`TargetSpec`),
- suite discovery output (`CorpusCase`),
- CLI/profile selection filters (`SelectionOptions`), and
- runtime/build orchestration (`RunContext`, `BuildResult`).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Mapping


@dataclass(frozen=True)
class TargetSpec:
    target: str
    architecture_family: str
    hip_architectures: tuple[str, ...]
    supported_suites: tuple[str, ...] = ()
    suite_defaults: Mapping[str, Any] = field(default_factory=dict)


@dataclass(frozen=True)
class CorpusCase:
    id: str
    suite: str
    target: str
    collection: str | None
    backend: str | None
    path: Path
    tags: tuple[str, ...]
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
    include_tags: tuple[str, ...] = ()
    exclude_tags: tuple[str, ...] = ()


@dataclass(frozen=True)
class RunContext:
    repo_root: Path
    artifact_directory: Path
    skip_all_runs: bool


@dataclass(frozen=True)
class BuildResult:
    cache_key: str
    build_dir: Path | None
    executable_path: Path | None
    metadata: Mapping[str, Any] = field(default_factory=dict)
