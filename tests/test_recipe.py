# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
import dataclasses
import os
import subprocess
import sys
import tomllib
from pathlib import Path

import pytest

from support.race_corpus import CORPUS_DIR, SCRIPTS_DIR, import_module

recipe = import_module("recipe")

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


def test_recipe_is_a_frozen_dataclass() -> None:
    # Represented like the inventory's records: immutable fields, and no tuple
    # behaviour such as indexing or unpacking to depend on.
    assert dataclasses.is_dataclass(recipe.Recipe)
    assert recipe.Recipe.__dataclass_params__.frozen
    assert not issubclass(recipe.Recipe, tuple)
    with pytest.raises(dataclasses.FrozenInstanceError):
        GOOD.compiler = "clang++"


def test_committed_recipes_load() -> None:
    for target in ("gfx950", "gfx1250"):
        assert recipe.load(CORPUS_DIR / "asm" / target / recipe.FILE_NAME) is not None


def test_invalid_toml_keeps_the_parse_error(tmp_path: Path) -> None:
    # As for the inventory: the parser's error is the cause, and its
    # diagnostic is in the problem.
    path = tmp_path / recipe.FILE_NAME
    path.write_text("compiler = \n")
    with pytest.raises(recipe.RecipeError) as error:
        recipe.load(path)
    assert isinstance(error.value.__cause__, tomllib.TOMLDecodeError)
    assert "line 1" in error.value.problems[0]


# --- Strings are written as TOML strings ------------------------------------------
#
# Every string is written as a TOML basic string, in UTF-8: characters outside the
# Basic Multilingual Plane as themselves, not as the surrogate-pair escapes JSON
# uses, which TOML rejects, and the characters TOML requires escaped, escaped.

AWKWARD = 'U+20BB7 \U00020bb7, "quotes", back\\slash, tab\t, newline\n, \x01 and \x7f'


def test_awkward_strings_round_trip(tmp_path: Path) -> None:
    awkward = dataclasses.replace(
        GOOD, compiler_version=AWKWARD, flags=("-O3", f"-I/abs/{AWKWARD}")
    )
    path = tmp_path / recipe.FILE_NAME
    path.write_text(recipe.dumps(awkward), encoding="utf-8")
    assert recipe.load(path) == awkward


def test_character_outside_the_bmp_is_written_as_itself() -> None:
    text = recipe.dumps(dataclasses.replace(GOOD, flags=("-I/abs/\U00020bb7",)))
    assert "\U00020bb7" in text
    assert "\\ud842" not in text


def test_string_that_is_not_unicode_cannot_be_written() -> None:
    # A path the filesystem did not decode as UTF-8 holds a lone surrogate, which
    # no UTF-8 file can hold.
    with pytest.raises(ValueError, match="not valid Unicode"):
        recipe.dumps(dataclasses.replace(GOOD, flags=("-I/abs/\udcff",)))


def test_recipe_is_read_as_utf8_whatever_the_locale(tmp_path: Path) -> None:
    # A fresh interpreter in the C locale, whose default text encoding is ASCII,
    # still reads the recipe as UTF-8, as TOML requires.
    awkward = dataclasses.replace(GOOD, flags=("-I/abs/\U00020bb7",))
    path = tmp_path / recipe.FILE_NAME
    path.write_bytes(recipe.dumps(awkward).encode("utf-8"))
    program = (
        f"import sys; sys.path.insert(0, {str(SCRIPTS_DIR)!r}); import recipe; "
        f"from pathlib import Path; print(ascii(recipe.load(Path({str(path)!r})).flags))"
    )
    environment = {**os.environ, "LC_ALL": "C", "LANG": "C", "PYTHONUTF8": "0"}
    output = subprocess.check_output(
        [sys.executable, "-c", program], env=environment, text=True
    )
    assert output.strip() == ascii(awkward.flags)
