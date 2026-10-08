# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
import dataclasses
import tomllib
from pathlib import Path

import pytest

from support.race_corpus import CORPUS_DIR, corpus_table, import_module, load_script

inventory = import_module("inventory")


def write_manifest(
    path: Path, body: str, targets: tuple[str, ...] = ("gfx950", "gfx1250")
) -> Path:
    path.write_text(corpus_table(list(targets)) + body, encoding="utf-8")
    return path


PORTABLE = '[[case]]\nid = "portable"\nkernel = "portable"\ntargets = []\n'
ONLY = '[[case]]\nid = "only"\nkernel = "only"\ntargets = ["gfx1250"]\nheaders = ["x/y.hpp"]\n'


# --- Reading a valid inventory -------------------------------------------------


def test_load_gives_named_case_records(tmp_path: Path) -> None:
    loaded = inventory.load(write_manifest(tmp_path / "cases.toml", PORTABLE + ONLY))
    assert loaded.targets == ("gfx950", "gfx1250")
    portable, only = loaded.cases
    assert portable == inventory.Case(
        id="portable", kernel="portable", targets=(), headers=()
    )
    assert only.targets == ("gfx1250",) and only.headers == ("x/y.hpp",)


@pytest.mark.parametrize(
    "record",
    [inventory.Case, inventory.Inventory, inventory.MutationRules, inventory.Exemption],
)
def test_records_are_frozen_dataclasses(record: type) -> None:
    # Every inventory record is represented the same way: immutable fields,
    # and no tuple behaviour such as indexing or unpacking to depend on.
    assert dataclasses.is_dataclass(record)
    assert record.__dataclass_params__.frozen
    assert not issubclass(record, tuple)


def test_case_fields_are_the_fields_of_case_and_its_rules() -> None:
    # A field added to Case or MutationRules is accepted in cases.toml without
    # a second list to update, as recipe.FIELDS is derived from Recipe. Case's
    # rules field holds the mutation fields, and is not itself a manifest field.
    case_fields = {field.name for field in dataclasses.fields(inventory.Case)}
    rule_fields = {field.name for field in dataclasses.fields(inventory.MutationRules)}
    assert inventory.CASE_FIELDS == (case_fields - {"rules"}) | rule_fields
    assert inventory.CASE_FIELDS == {
        "id",
        "kernel",
        "targets",
        "headers",
        "mutate",
        "hazard",
        "description",
        "resource",
        "waits",
        "exempt",
    }


MUTATING = (
    '[[case]]\nid = "m"\nkernel = "m"\ntargets = ["gfx1250"]\n'
    'mutate = ["wait", "memory"]\nhazard = "RAW"\ndescription = "LDS RAW"\n'
    'resource = "lds"\nwaits = { gfx1250 = ["dscnt", "kmcnt"] }\n'
    '[[case.exempt]]\nkind = "wait"\nordinal = 3\nsite = "s_wait_kmcnt"\n'
    'reason = "already satisfied"\n'
    '[[case.exempt]]\nkind = "wait"\nordinal = 0\nsite = "s_wait_dscnt"\n'
    'reason = "own slot"\ntarget = "gfx1250"\n'
)


def test_mutation_rules_are_read_into_a_record(tmp_path: Path) -> None:
    (case,) = inventory.load(write_manifest(tmp_path / "cases.toml", MUTATING)).cases
    assert case.rules == inventory.MutationRules(
        mutate=("wait", "memory"),
        hazard="RAW",
        description="LDS RAW",
        resource="lds",
        waits={"gfx1250": ("dscnt", "kmcnt")},
        exempt=(
            inventory.Exemption(
                kind="wait", ordinal=3, site="s_wait_kmcnt", reason="already satisfied"
            ),
            inventory.Exemption(
                kind="wait",
                ordinal=0,
                site="s_wait_dscnt",
                reason="own slot",
                target="gfx1250",
            ),
        ),
    )
    assert case.rules.declared()


def test_case_without_mutation_fields_has_no_rules(tmp_path: Path) -> None:
    (case,) = inventory.load(write_manifest(tmp_path / "cases.toml", PORTABLE)).cases
    assert case.rules == inventory.MutationRules()
    assert not case.rules.declared()
    # An empty waits table is still a declared rule: the case names no target.
    assert inventory.MutationRules(waits={}).declared()


def test_case_fields_cannot_be_reassigned() -> None:
    case = inventory.Case(id="a", kernel="a", targets=(), headers=())
    with pytest.raises(dataclasses.FrozenInstanceError):
        case.kernel = "b"


def test_absent_targets_means_every_corpus_target(tmp_path: Path) -> None:
    loaded = inventory.load(
        write_manifest(tmp_path / "cases.toml", '[[case]]\nid = "a"\nkernel = "a"\n')
    )
    (case,) = loaded.cases
    assert case.targets == ()
    assert loaded.targets_of(case) == ("gfx950", "gfx1250")


def test_targets_of_and_outputs_apply_one_rule(tmp_path: Path) -> None:
    loaded = inventory.load(write_manifest(tmp_path / "cases.toml", PORTABLE + ONLY))
    portable, only = loaded.cases
    assert loaded.targets_of(portable) == ("gfx950", "gfx1250")
    assert loaded.targets_of(only) == ("gfx1250",)
    assert loaded.outputs() == {
        ("gfx950", "portable.s"),
        ("gfx1250", "portable.s"),
        ("gfx1250", "only.s"),
    }
    assert loaded.outputs(["gfx950"]) == {("gfx950", "portable.s")}


def test_committed_inventory_loads() -> None:
    loaded = inventory.load(CORPUS_DIR / "cases.toml")
    assert loaded.targets == ("gfx950", "gfx1250")
    assert len(loaded.cases) == 21


# --- Validation ----------------------------------------------------------------

BAD_MANIFESTS = {
    "misspelled field": (
        '[[case]]\nid = "a"\nkernel = "a"\nheader = ["x.hpp"]\n',
        "cases.toml [a]: unknown field 'header'",
    ),
    "old requires field": (
        '[[case]]\nid = "a"\nkernel = "a"\nrequires = ["gfx950"]\n',
        "cases.toml [a]: 'requires' is now 'targets'",
    ),
    "target outside the corpus": (
        '[[case]]\nid = "a"\nkernel = "a"\ntargets = ["gfx1201"]\n',
        "cases.toml [a]: lists target gfx1201, which is not in [corpus] targets",
    ),
    "duplicate id": (
        '[[case]]\nid = "a"\nkernel = "a"\n[[case]]\nid = "a"\nkernel = "b"\n',
        "cases.toml [a]: duplicate id",
    ),
    "duplicate kernel": (
        '[[case]]\nid = "a"\nkernel = "k"\n[[case]]\nid = "b"\nkernel = "k"\n',
        "cases.toml [b]: kernel k is already used by another case",
    ),
    "missing kernel": (
        '[[case]]\nid = "a"\n',
        "cases.toml [a]: kernel must be a non-empty string",
    ),
    "headers not a list": (
        '[[case]]\nid = "a"\nkernel = "a"\nheaders = "x.hpp"\n',
        "cases.toml [a]: headers must be a list of strings",
    ),
    # An id or kernel that is not a string cannot be checked for duplicates,
    # and must be reported rather than crash that check.
    "id is a list": (
        '[[case]]\nid = []\nkernel = "a"\n',
        "cases.toml [[]]: id must be a non-empty string",
    ),
    "id is a table": (
        '[[case]]\nid = {}\nkernel = "a"\n',
        "cases.toml [{}]: id must be a non-empty string",
    ),
    "kernel is a list": (
        '[[case]]\nid = "a"\nkernel = []\n',
        "cases.toml [a]: kernel must be a non-empty string",
    ),
    "kernel is a table": (
        '[[case]]\nid = "a"\nkernel = {}\n',
        "cases.toml [a]: kernel must be a non-empty string",
    ),
    # The manifest around the cases is as strict as the cases: a misspelled
    # table would otherwise leave no cases, and regeneration would publish
    # every target empty.
    "misspelled case table": (
        '[[cases]]\nid = "a"\nkernel = "a"\n',
        "cases.toml: unknown top-level key 'cases'",
    ),
    "unknown corpus key": (
        'name = "race"\n[[case]]\nid = "a"\nkernel = "a"\n',
        "cases.toml: unknown [corpus] key 'name'",
    ),
    "no cases": ("", "cases.toml: no [[case]] tables"),
    # Mutation rules are checked for type here; whether they agree with the
    # assembly is check_cases.py's job.
    "unknown mutation kind": (
        '[[case]]\nid = "a"\nkernel = "a"\nmutate = ["weight"]\n',
        "cases.toml [a]: mutate lists 'weight'; known kinds are memory, wait",
    ),
    "mutate not a list": (
        '[[case]]\nid = "a"\nkernel = "a"\nmutate = "wait"\n',
        "cases.toml [a]: mutate must be a list of strings",
    ),
    "hazard not a string": (
        '[[case]]\nid = "a"\nkernel = "a"\nhazard = 1\n',
        "cases.toml [a]: hazard must be a non-empty string",
    ),
    "waits not a table": (
        '[[case]]\nid = "a"\nkernel = "a"\nwaits = ["vmcnt"]\n',
        "cases.toml [a]: waits must be a table keyed by target",
    ),
    "waits entry not a list": (
        '[[case]]\nid = "a"\nkernel = "a"\nwaits = { gfx950 = "vmcnt" }\n',
        "cases.toml [a]: waits.gfx950 must be a list of strings",
    ),
    "exempt not a list of tables": (
        '[[case]]\nid = "a"\nkernel = "a"\nexempt = "wait"\n',
        "cases.toml [a]: exempt must be a list of [[case.exempt]] tables",
    ),
    "exempt missing its site": (
        '[[case]]\nid = "a"\nkernel = "a"\n'
        '[[case.exempt]]\nkind = "wait"\nordinal = 0\nreason = "r"\n',
        "cases.toml [a]: exempt site must be a non-empty string",
    ),
    "exempt negative ordinal": (
        '[[case]]\nid = "a"\nkernel = "a"\n'
        '[[case.exempt]]\nkind = "wait"\nordinal = -1\nsite = "s"\nreason = "r"\n',
        "cases.toml [a]: exempt ordinal must be a non-negative integer",
    ),
    "exempt boolean ordinal": (
        '[[case]]\nid = "a"\nkernel = "a"\n'
        '[[case.exempt]]\nkind = "wait"\nordinal = true\nsite = "s"\nreason = "r"\n',
        "cases.toml [a]: exempt ordinal must be a non-negative integer",
    ),
    "exempt unknown key": (
        '[[case]]\nid = "a"\nkernel = "a"\n'
        '[[case.exempt]]\nkind = "wait"\nordinal = 0\nsite = "s"\nreason = "r"\n'
        'note = "x"\n',
        "cases.toml [a]: unknown [[case.exempt]] key 'note'",
    ),
}


@pytest.mark.parametrize(
    "body, problem", BAD_MANIFESTS.values(), ids=BAD_MANIFESTS.keys()
)
def test_invalid_manifest_is_rejected(tmp_path: Path, body: str, problem: str) -> None:
    with pytest.raises(inventory.InventoryError) as error:
        inventory.load(write_manifest(tmp_path / "cases.toml", body))
    assert problem in error.value.problems


@pytest.mark.parametrize("targets", [(), ("gfx950", "gfx950"), ("",)])
def test_invalid_corpus_targets_are_rejected(
    tmp_path: Path, targets: tuple[str, ...]
) -> None:
    with pytest.raises(inventory.InventoryError, match=r"\[corpus\] targets"):
        inventory.load(
            write_manifest(tmp_path / "cases.toml", PORTABLE, targets=targets)
        )


def test_every_problem_is_reported_at_once(tmp_path: Path) -> None:
    body = (
        '[[case]]\nid = "a"\nkernel = "a"\nheader = []\n'
        '[[case]]\nid = "b"\nkernel = "b"\ntargets = ["gfx1201"]\n'
    )
    with pytest.raises(inventory.InventoryError) as error:
        inventory.load(write_manifest(tmp_path / "cases.toml", body))
    assert len(error.value.problems) == 2


def test_unsupported_schema_is_rejected(tmp_path: Path) -> None:
    path = tmp_path / "cases.toml"
    path.write_text(
        corpus_table(["gfx950"], schema=inventory.SCHEMA + 1), encoding="utf-8"
    )
    with pytest.raises(inventory.InventoryError, match="unsupported corpus schema"):
        inventory.load(path)


# --- Manifests that cannot be read as an inventory ----------------------------
#
# A file that is not valid UTF-8 or not valid TOML, or whose [corpus] or cases
# are not tables, is reported as an InventoryError like any other invalid
# manifest, not raised as whatever exception reading it happened to hit. The
# decoder's or parser's error is kept as the cause. Each file is given as its
# bytes, so that one that is not valid UTF-8 can be among them.

CORPUS = corpus_table(["gfx950"])

MALFORMED_FILES = {
    "unterminated table header": (
        # The header's closing bracket removed.
        corpus_table(["gfx950"]).replace("[corpus]", "[corpus", 1).encode(),
        "cases.toml: not valid TOML",
    ),
    "not valid UTF-8": (
        CORPUS.encode() + b"# \xff\n",
        "cases.toml: not valid UTF-8",
    ),
    "corpus not a table": (b"corpus = 1\n", "cases.toml: [corpus] must be a table"),
    "case not a list": (
        ("case = 1\n" + CORPUS).encode(),
        "cases.toml: case must be a list of [[case]] tables",
    ),
    "case entry not a table": (
        ('case = ["x"]\n' + CORPUS).encode(),
        "cases.toml: case must be a list of [[case]] tables",
    ),
}


@pytest.mark.parametrize(
    "data, problem", MALFORMED_FILES.values(), ids=MALFORMED_FILES.keys()
)
def test_malformed_file_is_an_inventory_error(
    tmp_path: Path, data: bytes, problem: str
) -> None:
    path = tmp_path / "cases.toml"
    path.write_bytes(data)
    with pytest.raises(inventory.InventoryError) as error:
        inventory.load(path)
    assert any(problem in reported for reported in error.value.problems)


def test_invalid_toml_keeps_the_parse_error(tmp_path: Path) -> None:
    path = tmp_path / "cases.toml"
    path.write_text("[corpus\n", encoding="utf-8")
    with pytest.raises(inventory.InventoryError) as error:
        inventory.load(path)
    assert isinstance(error.value.__cause__, tomllib.TOMLDecodeError)
    # The parser's own diagnostic, with its line and column, is in the message.
    assert "line 1" in error.value.problems[0]


def test_invalid_utf8_keeps_the_decode_error(tmp_path: Path) -> None:
    path = tmp_path / "cases.toml"
    path.write_bytes(CORPUS.encode() + b"# \xff\n")
    with pytest.raises(inventory.InventoryError) as error:
        inventory.load(path)
    assert isinstance(error.value.__cause__, UnicodeDecodeError)
    # The decoder's own diagnostic, with the byte's position, is in the message.
    assert "0xff in position" in error.value.problems[0]


def test_unreadable_file_is_an_inventory_error(tmp_path: Path) -> None:
    path = tmp_path / "cases.toml"
    with pytest.raises(inventory.InventoryError, match="cannot be read") as error:
        inventory.load(path)
    assert isinstance(error.value.__cause__, OSError)


# --- Both entry points read the same inventory ---------------------------------


def report_from_both_scripts(
    path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
) -> tuple[str, str]:
    """
    Run both scripts' main() against the manifest at *path*, asserting each
    fails the way it documents for an invalid inventory: the checker exits 1,
    and regeneration exits SETUP_FAILED before compiling anything. Returns what
    each printed to stderr.

    Both scripts see a corpus in *path*'s directory, never the committed one,
    and regeneration cannot reach a compiler: a manifest that wrongly loads
    fails the test instead of publishing anything.
    """
    check_cases = load_script("check_cases")
    regenerate_asm = load_script("regenerate_asm")
    for script in (check_cases, regenerate_asm):
        monkeypatch.setattr(script, "CORPUS_ROOT", path.parent)
        monkeypatch.setattr(script, "CASES_PATH", path)
        monkeypatch.setattr(script, "KERNELS_DIR", path.parent / "kernels")
        monkeypatch.setattr(script, "ASM_DIR", path.parent / "asm")

    def no_toolchain() -> None:
        raise AssertionError("an invalid inventory must stop before the toolchain")

    monkeypatch.setattr(regenerate_asm, "select_toolchain", no_toolchain)
    assert check_cases.main([]) == check_cases.ExitCode.PROBLEMS_FOUND
    checker = capsys.readouterr().err
    assert regenerate_asm.main([]) == regenerate_asm.ExitCode.SETUP_FAILED
    return checker, capsys.readouterr().err


@pytest.mark.parametrize(
    "body, problem", BAD_MANIFESTS.values(), ids=BAD_MANIFESTS.keys()
)
def test_both_scripts_report_the_same_problem(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
    body: str,
    problem: str,
) -> None:
    path = write_manifest(tmp_path / "cases.toml", body)
    checker, regeneration = report_from_both_scripts(path, monkeypatch, capsys)
    assert problem in checker and problem in regeneration


@pytest.mark.parametrize(
    "data, problem", MALFORMED_FILES.values(), ids=MALFORMED_FILES.keys()
)
def test_both_scripts_report_a_malformed_file(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
    data: bytes,
    problem: str,
) -> None:
    path = tmp_path / "cases.toml"
    path.write_bytes(data)
    checker, regeneration = report_from_both_scripts(path, monkeypatch, capsys)
    assert problem in checker and problem in regeneration


def test_both_scripts_report_an_unreadable_file(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
) -> None:
    checker, regeneration = report_from_both_scripts(
        tmp_path / "cases.toml", monkeypatch, capsys
    )
    assert "cannot be read" in checker and "cannot be read" in regeneration


# --- Scratch manifests follow the current schema --------------------------------


def test_scratch_manifests_use_the_current_schema(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    # The helper writes inventory.SCHEMA rather than its own copy of it, so a
    # schema change updates every scratch manifest with it.
    monkeypatch.setattr(inventory, "SCHEMA", inventory.SCHEMA + 1)
    path = write_manifest(tmp_path / "cases.toml", PORTABLE)
    assert f"schema = {inventory.SCHEMA}" in path.read_text(encoding="utf-8")
    assert inventory.load(path).cases[0].id == "portable"


# --- One corpus layout ------------------------------------------------------------

CORPUS_PATHS = ("CORPUS_ROOT", "CASES_PATH", "KERNELS_DIR", "ASM_DIR")


@pytest.mark.parametrize("script", ["check_cases", "regenerate_asm"])
def test_scripts_use_the_inventory_layout(script: str) -> None:
    # The corpus paths are defined once, in inventory, and each script refers
    # to them by name so that tests can point a run at a scratch corpus.
    module = load_script(script)
    for name in CORPUS_PATHS:
        assert getattr(module, name) == getattr(inventory, name)
    assert inventory.CORPUS_ROOT == CORPUS_DIR
