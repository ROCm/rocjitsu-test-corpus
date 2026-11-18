#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Verify shipped Gluon extraction locally; optionally recheck exact upstream.

--upstream downloads only the pinned tutorial and LICENSE into memory, never
executes either, and compares exact function source segments/decorators.
--output saves a preparation receipt outside this source directory.
"""

import argparse
import ast
import hashlib
import json
from pathlib import Path
import urllib.request

HERE = Path(__file__).resolve().parent
PIN = "675c59878aa2280b31f722aaf42b825fcee21de8"


def digest(data):
    return hashlib.sha256(data).hexdigest()


def verify_local():
    metadata = json.loads((HERE / "provenance.json").read_text())
    if metadata["source_pin"] != PIN:
        raise ValueError("unexpected Gluon source pin")
    for name, key in [("kernels.py", "kernels_sha256"), ("LICENSE", "license_sha256")]:
        if digest((HERE / name).read_bytes()) != metadata[key]:
            raise ValueError("Gluon source/license hash mismatch: " + name)
    return metadata


def functions(data, names):
    text = data.decode()
    return {
        node.name: (
            ast.get_source_segment(text, node),
            [ast.dump(d) for d in node.decorator_list],
        )
        for node in ast.parse(text).body
        if isinstance(node, ast.FunctionDef) and node.name in names
    }


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--upstream", action="store_true")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args(argv)
    metadata = verify_local()
    if args.upstream:
        base = "https://raw.githubusercontent.com/triton-lang/triton/" + PIN + "/"
        upstream = urllib.request.urlopen(
            base + metadata["upstream_path"], timeout=30
        ).read()
        license_data = urllib.request.urlopen(base + "LICENSE", timeout=30).read()
        if (
            digest(upstream) != metadata["upstream_sha256"]
            or digest(license_data) != metadata["license_sha256"]
        ):
            raise ValueError("pinned upstream source/license hash mismatch")
        if functions(upstream, metadata["functions"]) != functions(
            (HERE / "kernels.py").read_bytes(), metadata["functions"]
        ):
            raise ValueError("extracted functions differ from pinned upstream")
    receipt = dict(metadata, upstream_verified=args.upstream)
    text = json.dumps(receipt, indent=2) + "\n"
    if args.output:
        path = args.output.resolve()
        if path == HERE or HERE in path.parents:
            parser.error("receipt must remain outside source directories")
        path.parent.mkdir(parents=True, exist_ok=True)
        with path.open("x") as output:
            output.write(text)
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
