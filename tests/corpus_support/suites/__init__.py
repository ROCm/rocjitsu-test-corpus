from __future__ import annotations

from . import cts, iree, kernels

SUITE_MODULES = {
    "iree": iree,
    "kernels": kernels,
    "cts": cts,
}

DEFAULT_SUITES = ("iree", "kernels", "cts")
