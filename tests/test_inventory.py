# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
import importlib.util
import sys
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = REPO_ROOT / "corpus" / "race" / "scripts"
sys.path.insert(0, str(SCRIPTS))

import inventory  # noqa: E402


def load_script(name: str):
    spec = importlib.util.spec_from_file_location(name, SCRIPTS / f"{name}.py")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def write_manifest(path: Path, body: str, targets: str = '["gfx950", "gfx1250"]') -> Path:
    path.write_text(f'[corpus]\nschema = 1\nname = "race"\ntargets = {targets}\n\n{body}')
    return path


PORTABLE = '[[case]]\nid = "portable"\nkernel = "portable"\ntargets = []\n'
ONLY = '[[case]]\nid = "only"\nkernel = "only"\ntargets = ["gfx1250"]\nheaders = ["x/y.hpp"]\n'


# --- Reading a valid inventory -------------------------------------------------


def test_load_gives_named_case_records(tmp_path):
    loaded = inventory.load(write_manifest(tmp_path / "cases.toml", PORTABLE + ONLY))
    assert loaded.targets == ("gfx950", "gfx1250")
    portable, only = loaded.cases
    assert portable == inventory.Case(id="portable", kernel="portable", targets=(), headers=())
    assert only.targets == ("gfx1250",) and only.headers == ("x/y.hpp",)


def test_absent_targets_means_every_corpus_target(tmp_path):
    loaded = inventory.load(
        write_manifest(tmp_path / "cases.toml", '[[case]]\nid = "a"\nkernel = "a"\n')
    )
    (case,) = loaded.cases
    assert case.targets == ()
    assert loaded.targets_of(case) == ("gfx950", "gfx1250")


def test_targets_of_and_outputs_apply_one_rule(tmp_path):
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


def test_committed_inventory_loads():
    loaded = inventory.load(REPO_ROOT / "corpus" / "race" / "cases.toml")
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
}


@pytest.mark.parametrize("body, problem", BAD_MANIFESTS.values(), ids=BAD_MANIFESTS.keys())
def test_invalid_manifest_is_rejected(tmp_path, body, problem):
    with pytest.raises(inventory.InventoryError) as error:
        inventory.load(write_manifest(tmp_path / "cases.toml", body))
    assert problem in error.value.problems


@pytest.mark.parametrize("targets", ["[]", '["gfx950", "gfx950"]', '[""]'])
def test_invalid_corpus_targets_are_rejected(tmp_path, targets):
    with pytest.raises(inventory.InventoryError, match=r"\[corpus\] targets"):
        inventory.load(write_manifest(tmp_path / "cases.toml", PORTABLE, targets=targets))


def test_every_problem_is_reported_at_once(tmp_path):
    body = (
        '[[case]]\nid = "a"\nkernel = "a"\nheader = []\n'
        '[[case]]\nid = "b"\nkernel = "b"\ntargets = ["gfx1201"]\n'
    )
    with pytest.raises(inventory.InventoryError) as error:
        inventory.load(write_manifest(tmp_path / "cases.toml", body))
    assert len(error.value.problems) == 2


def test_unsupported_schema_is_rejected(tmp_path):
    path = tmp_path / "cases.toml"
    path.write_text('[corpus]\nschema = 2\ntargets = ["gfx950"]\n')
    with pytest.raises(inventory.InventoryError, match="unsupported corpus schema"):
        inventory.load(path)


# --- Both entry points read the same inventory ---------------------------------


@pytest.mark.parametrize("body, problem", BAD_MANIFESTS.values(), ids=BAD_MANIFESTS.keys())
def test_both_scripts_report_the_same_problem(tmp_path, monkeypatch, capsys, body, problem):
    path = write_manifest(tmp_path / "cases.toml", body)
    check_cases = load_script("check_cases")
    regenerate_asm = load_script("regenerate_asm")
    monkeypatch.setattr(check_cases, "CASES_PATH", path)
    monkeypatch.setattr(regenerate_asm, "CASES_PATH", path)

    assert check_cases.main([]) == 1
    assert problem in capsys.readouterr().err
    with pytest.raises(SystemExit) as exit_info:
        regenerate_asm.load_inventory()
    assert problem in str(exit_info.value.code)
