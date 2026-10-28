# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""
Shared setup for the race corpus tests: the scripts under corpus/race/scripts,
loaded as their own command lines see them, and a scratch cases.toml's
``[corpus]`` table.

The scripts import their sibling modules (inventory, recipe) by name, as they do
when run from scripts/, so that directory is put on sys.path once, here. The
sibling modules are imported once and shared, so every test and script sees the
same Recipe and InventoryError classes. Only the two command-line scripts are
loaded afresh, by load_script, so a test can patch one copy without another.
"""

import importlib
import importlib.util
import json
import sys
from pathlib import Path
from types import ModuleType

CORPUS_DIR = Path(__file__).resolve().parents[2] / "corpus" / "race"
SCRIPTS_DIR = CORPUS_DIR / "scripts"

if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))


def import_module(name: str) -> ModuleType:
    """The shared copy of the sibling module scripts/<name>.py, such as inventory."""
    return importlib.import_module(name)


def load_script(name: str) -> ModuleType:
    """
    A fresh copy of the command-line script scripts/<name>.py, registered in
    sys.modules as *name*, as when it runs from scripts/.
    """
    spec = importlib.util.spec_from_file_location(name, SCRIPTS_DIR / f"{name}.py")
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {SCRIPTS_DIR / f'{name}.py'}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def corpus_table(targets: list[str] | None, schema: int | None = None) -> str:
    """
    The ``[corpus]`` table of a scratch cases.toml, listing *targets*, or with
    no targets at all when *targets* is None. Its schema is *schema*, or the
    current one, inventory.SCHEMA, when *schema* is None.
    """
    if schema is None:
        schema = import_module("inventory").SCHEMA
    table = f"[corpus]\nschema = {schema}\n"
    if targets is not None:
        table += f"targets = {json.dumps(targets)}\n"
    return table + "\n"
