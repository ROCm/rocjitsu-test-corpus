"""Shared result-record and report handling for the semantic corpus."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import re
from typing import Any

try:
    import tomllib
except ModuleNotFoundError:
    import tomli as tomllib


RESULT_PREFIX = "CORPUS_RESULT "
REPORT_SCHEMA = 1
FNV1A64_OFFSET_BASIS = 14695981039346656037
FNV1A64_PRIME = 1099511628211


class ResultError(RuntimeError):
    """A semantic result or report violated the corpus contract."""


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def fnv1a64(data: bytes) -> str:
    digest = FNV1A64_OFFSET_BASIS
    for byte in data:
        digest ^= byte
        digest = (digest * FNV1A64_PRIME) & ((1 << 64) - 1)
    return f"{digest:016x}"


def load_manifest(path: Path) -> dict[str, Any]:
    try:
        with path.open("rb") as stream:
            manifest = tomllib.load(stream)
    except (OSError, tomllib.TOMLDecodeError) as error:
        raise ResultError(f"cannot read manifest {path}: {error}") from error
    corpus = manifest.get("corpus")
    if not isinstance(corpus, dict) or corpus.get("schema") != 1:
        raise ResultError(f"{path}: unsupported corpus schema")
    if not isinstance(corpus.get("target"), str):
        raise ResultError(f"{path}: corpus target is missing")
    return manifest


def expected_records(manifest: dict[str, Any]) -> dict[str, set[tuple[str, int]]]:
    results = manifest.get("results")
    if not isinstance(results, dict):
        raise ResultError("manifest contains no result contracts")
    expected: dict[str, set[tuple[str, int]]] = {}
    for test, contract in results.items():
        records = contract.get("records") if isinstance(contract, dict) else None
        if not isinstance(records, list):
            raise ResultError(f"manifest result contract for {test} is invalid")
        expected[test] = {
            (record["case"], variant)
            for record in records
            for variant in range(record["variants"])
        }
    return expected


def case_tests(manifest: dict[str, Any]) -> dict[str, str]:
    mapping: dict[str, str] = {}
    for case in manifest.get("case", []):
        case_id = case.get("id") if isinstance(case, dict) else None
        test = case.get("test") if isinstance(case, dict) else None
        if not isinstance(case_id, str) or not isinstance(test, str):
            raise ResultError("manifest contains an invalid semantic case")
        mapping[case_id] = test
    return mapping


def select_tests(
    manifest: dict[str, Any],
    selectors: list[str] | tuple[str, ...],
) -> list[str]:
    contracts = expected_records(manifest)
    if not selectors:
        return sorted(contracts)
    cases = case_tests(manifest)
    selected: set[str] = set()
    unknown = []
    for selector in selectors:
        if selector in contracts:
            selected.add(selector)
        elif selector in cases:
            selected.add(cases[selector])
        else:
            unknown.append(selector)
    if unknown:
        raise ResultError(f"unknown case or test selector(s): {', '.join(unknown)}")
    return sorted(selected)


def parse_records(
    *,
    label: str,
    stdout: str,
    test: str,
    expected_keys: set[tuple[str, int]],
) -> list[dict[str, Any]]:
    records = []
    for line in stdout.splitlines():
        if not line.startswith(RESULT_PREFIX):
            continue
        try:
            records.append(json.loads(line.removeprefix(RESULT_PREFIX)))
        except json.JSONDecodeError as error:
            raise ResultError(
                f"{label} emitted invalid result JSON: {error}"
            ) from error
    if not records:
        raise ResultError(f"{label} emitted no {RESULT_PREFIX.strip()} records")

    expected_test = f"{test}.hip"
    indices = []
    keys = set()
    for record in records:
        key = validate_record(record, label=label, expected_test=expected_test)
        if key in keys:
            raise ResultError(f"{label} emitted duplicate result key {key!r}")
        keys.add(key)
        indices.append(record["index"])
    if indices != list(range(len(records))):
        raise ResultError(f"{label} emitted an out-of-order result index sequence")
    if keys != expected_keys:
        missing = sorted(expected_keys - keys)
        extra = sorted(keys - expected_keys)
        raise ResultError(
            f"{label} result identity mismatch: missing={missing!r}, extra={extra!r}"
        )
    return records


def compare_records(
    *,
    test: str,
    reference_records: list[dict[str, Any]],
    candidate_records: list[dict[str, Any]],
) -> None:
    if reference_records == candidate_records:
        return
    mismatch_index = next(
        (
            index
            for index, rows in enumerate(
                zip(reference_records, candidate_records, strict=False)
            )
            if rows[0] != rows[1]
        ),
        min(len(reference_records), len(candidate_records)),
    )
    reference_record = (
        reference_records[mismatch_index]
        if mismatch_index < len(reference_records)
        else "<missing>"
    )
    candidate_record = (
        candidate_records[mismatch_index]
        if mismatch_index < len(candidate_records)
        else "<missing>"
    )
    raise ResultError(
        "\n".join(
            [
                f"{test}: semantic result mismatch at record {mismatch_index}",
                "reference: " + json.dumps(reference_record, sort_keys=True),
                "candidate: " + json.dumps(candidate_record, sort_keys=True),
            ]
        )
    )


def validate_record(
    record: Any,
    *,
    label: str,
    expected_test: str,
) -> tuple[str, int]:
    required_fields = {
        "test",
        "case",
        "variant",
        "index",
        "count",
        "element_bytes",
        "comparison",
        "fnv1a64",
        "data_hex",
    }
    if not isinstance(record, dict):
        raise ResultError(f"{label} emitted a non-object result")
    missing = required_fields - set(record)
    if missing:
        raise ResultError(
            f"{label} result is missing fields: {', '.join(sorted(missing))}"
        )
    if record["test"] != expected_test:
        raise ResultError(
            f"{label} reported test={record['test']!r}, " f"expected {expected_test!r}"
        )
    if not isinstance(record["case"], str) or not record["case"]:
        raise ResultError(f"{label} emitted an invalid result case")
    if (
        not isinstance(record["variant"], int)
        or isinstance(record["variant"], bool)
        or record["variant"] < 0
    ):
        raise ResultError(f"{label} emitted an invalid result variant")
    if not isinstance(record["index"], int) or isinstance(record["index"], bool):
        raise ResultError(f"{label} emitted a non-integer result index")
    if (
        not isinstance(record["count"], int)
        or isinstance(record["count"], bool)
        or record["count"] < 0
    ):
        raise ResultError(f"{label} emitted an invalid result count")
    if (
        not isinstance(record["element_bytes"], int)
        or isinstance(record["element_bytes"], bool)
        or record["element_bytes"] < 1
    ):
        raise ResultError(f"{label} emitted an invalid element size")
    if record["comparison"] not in {"exact", "near"}:
        raise ResultError(f"{label} emitted an invalid comparison mode")
    if re.fullmatch(r"[0-9a-f]{16}", str(record["fnv1a64"])) is None:
        raise ResultError(f"{label} emitted an invalid result digest")
    expected_hex_bytes = record["count"] * record["element_bytes"] * 2
    if (
        not isinstance(record["data_hex"], str)
        or len(record["data_hex"]) != expected_hex_bytes
        or re.fullmatch(r"[0-9a-f]*", record["data_hex"]) is None
    ):
        raise ResultError(f"{label} emitted invalid typed result bytes")
    if fnv1a64(bytes.fromhex(record["data_hex"])) != record["fnv1a64"]:
        raise ResultError(f"{label} emitted inconsistent typed result bytes")
    return record["case"], record["variant"]


def load_report(path: Path) -> dict[str, Any]:
    try:
        report = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as error:
        raise ResultError(f"cannot read run report {path}: {error}") from error
    if not isinstance(report, dict) or report.get("schema") != REPORT_SCHEMA:
        raise ResultError(f"{path}: unsupported run-report schema")
    corpus = report.get("corpus")
    if (
        not isinstance(corpus, dict)
        or not isinstance(corpus.get("target"), str)
        or not corpus["target"]
        or re.fullmatch(r"[0-9a-f]{64}", str(corpus.get("manifest_sha256"))) is None
    ):
        raise ResultError(f"{path}: run report contains invalid corpus identity")
    if not isinstance(report.get("label"), str):
        raise ResultError(f"{path}: run report contains an invalid label")
    if not isinstance(report.get("metadata"), dict):
        raise ResultError(f"{path}: run report contains invalid metadata")
    tests = report.get("tests")
    if not isinstance(tests, list) or not tests:
        raise ResultError(f"{path}: run report contains no tests")
    test_names = set()
    for row in tests:
        if not isinstance(row, dict):
            raise ResultError(f"{path}: run report contains an invalid test")
        test = row.get("test")
        if not isinstance(test, str) or not test or test in test_names:
            raise ResultError(f"{path}: run report contains invalid test identity")
        test_names.add(test)
        artifact = row.get("artifact")
        if (
            not isinstance(artifact, dict)
            or not isinstance(artifact.get("bytes"), int)
            or isinstance(artifact["bytes"], bool)
            or artifact["bytes"] < 0
            or re.fullmatch(r"[0-9a-f]{64}", str(artifact.get("sha256"))) is None
        ):
            raise ResultError(f"{path}: {test} contains invalid artifact identity")
        records = row.get("records")
        if not isinstance(records, list) or not records:
            raise ResultError(f"{path}: {test} contains no result records")
        indices = []
        keys = set()
        for record in records:
            key = validate_record(
                record,
                label=f"{path}: {test}",
                expected_test=f"{test}.hip",
            )
            if key in keys:
                raise ResultError(f"{path}: {test} contains duplicate result key")
            keys.add(key)
            indices.append(record["index"])
        if indices != list(range(len(records))):
            raise ResultError(f"{path}: {test} contains out-of-order result indices")
    return report
