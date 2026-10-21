# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""
How a target's pinned assembly was regenerated: ``asm/<target>/recipe.toml``.

``regenerate_asm.py`` writes it and compares it in ``--check``, and
``check_cases.py`` requires it. Both read it through :func:`load`, so they agree
on its fields and on what makes it valid. A change to the recipe is a change
here, not in each script.
"""

import dataclasses
import json
import tomllib
from pathlib import Path

FILE_NAME = "recipe.toml"

# A toolchain field whose value could not be found, such as the build of an SDK
# that was not installed as a Python distribution.
UNKNOWN = "unknown"


class RecipeError(ValueError):
    """The recipe is invalid. ``problems`` lists every problem found."""

    def __init__(self, problems: list[str]) -> None:
        super().__init__("\n".join(problems))
        self.problems = problems


@dataclasses.dataclass(frozen=True)
class Recipe:
    """
    How a target's assembly was regenerated.

    ``.ident`` in each ``.s`` names the compiler, but not the SDK or the flags,
    so the same ``.ident`` can come with different code. ``--check`` compares
    the recipe it would write with the committed one, and reports a changed
    recipe apart from a toolchain update.

    Attributes:
        compiler: The compiler's file name: ``hipcc``, or ``clang++`` when the
            SDK's clang is used directly.
        compiler_version: The ``clang version`` line of ``--version``.
        rocm_release: The SDK's release, from its ``.info/version``, such as
            ``10.1.0``, or ``unknown``.
        rocm_build: The SDK's build, such as ``10.1.0a20260822``, from the
            Python distributions that installed it, or ``unknown`` when it was
            not installed that way. Two builds can share a release and a clang
            revision, so only the build tells them apart.
        flags: The explicit flags: the baseline recipe, then ``--cxxflags`` as
            the compiler receives them, with relative paths made absolute, so
            the recipe changes when a flag selects a different file. The flags
            every compile gets, such as the target and the SDK's include
            directory, are implied.
    """

    compiler: str
    compiler_version: str
    rocm_release: str
    rocm_build: str
    flags: tuple[str, ...]


# Every field of a recipe, in the order recipe.toml lists them.
FIELDS = tuple(field.name for field in dataclasses.fields(Recipe))

# The fields that identify the toolchain, as opposed to the flags the person
# regenerating chose. Each is a non-empty string.
TOOLCHAIN_FIELDS = tuple(field for field in FIELDS if field != "flags")


def dumps(recipe: Recipe) -> str:
    """*recipe* as the text of a recipe.toml."""
    lines = [
        "# How the .s files beside this one were regenerated. Written by",
        "# regenerate_asm.py and compared by regenerate_asm.py --check.",
        *(
            f"{field} = {json.dumps(getattr(recipe, field))}"
            for field in TOOLCHAIN_FIELDS
        ),
        f"flags = {json.dumps(list(recipe.flags))}",
    ]
    return "\n".join(lines) + "\n"


def load(path: Path) -> Recipe | None:
    """
    The recipe at *path*, or None if there is none.

    Raises RecipeError naming every problem, not just the first.
    """
    if not path.is_file():
        return None
    try:
        fields = tomllib.loads(path.read_text())
    except tomllib.TOMLDecodeError as error:
        raise RecipeError([f"not valid TOML ({error})"]) from None

    problems = [f"unknown field {name!r}" for name in sorted(set(fields) - set(FIELDS))]
    for name in TOOLCHAIN_FIELDS:
        if name not in fields:
            problems.append(f"{name} is missing")
        elif not isinstance(fields[name], str) or not fields[name]:
            problems.append(f"{name} must be a non-empty string")
    flags = fields.get("flags")
    if flags is None:
        problems.append("flags is missing")
    elif not isinstance(flags, list) or not all(
        isinstance(flag, str) for flag in flags
    ):
        problems.append("flags must be a list of strings")
    if problems:
        raise RecipeError(problems)
    return Recipe(
        **{name: fields[name] for name in TOOLCHAIN_FIELDS}, flags=tuple(flags)
    )
