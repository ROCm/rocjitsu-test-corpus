from __future__ import annotations

import hashlib
import json
from pathlib import Path

from .model import BuildResult, CorpusCase, RunContext


class BuildManager:
    def __init__(self, context: RunContext):
        self._context = context
        self._cache: dict[str, BuildResult] = {}

    def ensure_built(self, case: CorpusCase, suite_module) -> BuildResult:
        cache_key = self._cache_key(case)
        cached = self._cache.get(cache_key)
        if cached is not None:
            return cached

        suite_result = suite_module.build(case, self._context)
        if suite_result is None:
            suite_result = BuildResult(
                cache_key=cache_key,
                build_dir=None,
                executable_path=None,
                metadata={},
            )
        elif suite_result.cache_key != cache_key:
            suite_result = BuildResult(
                cache_key=cache_key,
                build_dir=suite_result.build_dir,
                executable_path=suite_result.executable_path,
                metadata=suite_result.metadata,
            )
        self._cache[cache_key] = suite_result
        return suite_result

    @staticmethod
    def _cache_key(case: CorpusCase) -> str:
        payload = {
            "suite": case.suite,
            "target": case.target,
            "backend": case.backend,
            "collection": case.collection,
            "build": case.build,
            "path": str(case.path),
        }
        encoded = json.dumps(payload, sort_keys=True).encode("utf-8")
        digest = hashlib.sha256(encoded).hexdigest()[:16]
        return f"{case.suite}:{case.target}:{digest}"


def resolve_artifact_directory(repo_root: Path, artifact_directory: str) -> Path:
    path = Path(artifact_directory)
    if not path.is_absolute():
        path = repo_root / path
    path = path.resolve()
    if not path.is_relative_to(repo_root):
        raise ValueError("--artifact-directory must resolve under the repo root")
    return path
