# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
import dataclasses
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
    rocm_release="10.1.0",
    rocm_build="10.1.0a20260822",
    flags=("-O3", "-x", "hip"),
)
GOOD_TEXT = recipe.dumps(GOOD)


def without_field(field: str) -> str:
    """GOOD_TEXT with *field*'s line removed."""
    return "".join(
        line
        for line in GOOD_TEXT.splitlines(keepends=True)
        if not line.startswith(f"{field} = ")
    )


# Each malformed recipe, and the problem load() reports for it, built from GOOD
# so that a schema change updates every fixture here. The two scripts' tests run
# the same cases through their own entry points.
BAD_RECIPES = {
    "malformed TOML": ("compiler = \n", "not valid TOML"),
    "missing field": (without_field("rocm_build"), "rocm_build is missing"),
    "empty field": (
        recipe.dumps(dataclasses.replace(GOOD, compiler="")),
        "compiler must be a non-empty string",
    ),
    "flags not a list": (
        without_field("flags") + 'flags = "-O3"\n',
        "flags must be a list of strings",
    ),
    "unknown field": (GOOD_TEXT + 'sdk = "x"\n', "unknown field 'sdk'"),
}


def test_dumps_and_load_round_trip(tmp_path: Path) -> None:
    path = tmp_path / recipe.FILE_NAME
    path.write_text(GOOD_TEXT)
    assert recipe.load(path) == GOOD


def test_unknown_build_round_trips(tmp_path: Path) -> None:
    # An SDK whose build cannot be found is recorded as such, not as its release.
    release_only = dataclasses.replace(GOOD, rocm_build=recipe.UNKNOWN)
    path = tmp_path / recipe.FILE_NAME
    path.write_text(recipe.dumps(release_only))
    assert recipe.load(path) == release_only


def test_absent_recipe_loads_as_none(tmp_path: Path) -> None:
    assert recipe.load(tmp_path / recipe.FILE_NAME) is None


@pytest.mark.parametrize("text, problem", BAD_RECIPES.values(), ids=BAD_RECIPES.keys())
def test_invalid_recipe_is_rejected(tmp_path: Path, text: str, problem: str) -> None:
    path = tmp_path / recipe.FILE_NAME
    path.write_text(text)
    with pytest.raises(recipe.RecipeError) as error:
        recipe.load(path)
    assert any(problem in reported for reported in error.value.problems)


def test_every_problem_is_reported_at_once(tmp_path: Path) -> None:
    path = tmp_path / recipe.FILE_NAME
    path.write_text('compiler = ""\nflags = "-O3"\n')
    with pytest.raises(recipe.RecipeError) as error:
        recipe.load(path)
    # An empty compiler, three missing toolchain fields, and bad flags.
    assert len(error.value.problems) == 5


def test_toolchain_fields_are_every_field_but_the_flags() -> None:
    assert recipe.TOOLCHAIN_FIELDS == (
        "compiler",
        "compiler_version",
        "rocm_release",
        "rocm_build",
    )
    assert recipe.FIELDS == (*recipe.TOOLCHAIN_FIELDS, "flags")


def test_recipe_is_a_frozen_dataclass():
    # Represented like the inventory's records: immutable fields, and no tuple
    # behaviour such as indexing or unpacking to depend on.
    assert dataclasses.is_dataclass(recipe.Recipe)
    assert recipe.Recipe.__dataclass_params__.frozen
    assert not issubclass(recipe.Recipe, tuple)
    with pytest.raises(dataclasses.FrozenInstanceError):
        GOOD.compiler = "clang++"


def test_committed_recipes_load():
    for target in ("gfx950", "gfx1250"):
        assert (
            recipe.load(SCRIPTS.parent / "asm" / target / recipe.FILE_NAME) is not None
        )
