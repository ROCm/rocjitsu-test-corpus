# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
import sys
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = REPO_ROOT / "corpus" / "race" / "scripts"
sys.path.insert(0, str(SCRIPTS))

import recipe  # noqa: E402

GOOD = recipe.Recipe(
    compiler="hipcc",
    compiler_version="AMD clang version 23.0.0git",
    rocm_version="10.1.0",
    flags=("-O3", "-x", "hip"),
)
GOOD_TEXT = recipe.dumps(GOOD)

# Each malformed recipe, and the problem load() reports for it. The two scripts'
# tests run the same cases through their own entry points.
BAD_RECIPES = {
    "malformed TOML": ("compiler = \n", "not valid TOML"),
    "missing field": (GOOD_TEXT.replace('rocm_version = "10.1.0"\n', ""), "rocm_version is missing"),
    "empty field": (
        GOOD_TEXT.replace('compiler = "hipcc"', 'compiler = ""'),
        "compiler must be a non-empty string",
    ),
    "flags not a list": (
        GOOD_TEXT.replace('flags = ["-O3", "-x", "hip"]', 'flags = "-O3"'),
        "flags must be a list of strings",
    ),
    "unknown field": (GOOD_TEXT + 'sdk = "x"\n', "unknown field 'sdk'"),
}


def test_dumps_and_load_round_trip(tmp_path):
    path = tmp_path / recipe.FILE_NAME
    path.write_text(GOOD_TEXT)
    assert recipe.load(path) == GOOD


def test_absent_recipe_loads_as_none(tmp_path):
    assert recipe.load(tmp_path / recipe.FILE_NAME) is None


@pytest.mark.parametrize("text, problem", BAD_RECIPES.values(), ids=BAD_RECIPES.keys())
def test_invalid_recipe_is_rejected(tmp_path, text, problem):
    path = tmp_path / recipe.FILE_NAME
    path.write_text(text)
    with pytest.raises(recipe.RecipeError) as error:
        recipe.load(path)
    assert any(problem in reported for reported in error.value.problems)


def test_every_problem_is_reported_at_once(tmp_path):
    path = tmp_path / recipe.FILE_NAME
    path.write_text('compiler = ""\nflags = "-O3"\n')
    with pytest.raises(recipe.RecipeError) as error:
        recipe.load(path)
    assert len(error.value.problems) == 4  # empty compiler, two missing, bad flags


def test_toolchain_fields_are_every_field_but_the_flags():
    assert recipe.TOOLCHAIN_FIELDS == ("compiler", "compiler_version", "rocm_version")
    assert set(recipe.Recipe._fields) == {*recipe.TOOLCHAIN_FIELDS, "flags"}


def test_committed_recipes_load():
    for target in ("gfx950", "gfx1250"):
        assert recipe.load(SCRIPTS.parent / "asm" / target / recipe.FILE_NAME) is not None
