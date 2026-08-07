#!/usr/bin/env python3
"""Generate plugin-enabled copies of the four shipped ROCjitsu configs.

Usage: ./make_trace_configs.py <rocjitsu-source-dir>
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

TARGET_CONFIGS = {
    "gfx942": "gfx942_cdna3.json",
    "gfx950": "gfx950_cdna4.json",
    "gfx1100": "gfx1100_w7900.json",
    "gfx1201": "gfx1201_r9700.json",
}


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit(__doc__)
    configs = Path(sys.argv[1]) / "configs"
    out = Path(__file__).resolve().parent / "trace-configs"
    out.mkdir(exist_ok=True)

    for target, name in TARGET_CONFIGS.items():
        base = json.loads((configs / name).read_text(encoding="utf-8"))

        (out / f"{target}.json").write_text(
            json.dumps(base, indent=2) + "\n", encoding="utf-8"
        )

        plugins = dict(base)
        plugins["plugins"] = {"logging": {}, "race": {}}
        plugins["sinks"] = {
            "types": ["file"],
            "dir": str(out.parent / "trace-out" / target),
        }
        (out / f"{target}-plugins.json").write_text(
            json.dumps(plugins, indent=2) + "\n", encoding="utf-8"
        )
        print(f"{target}: {name}")

    print(out)


if __name__ == "__main__":
    main()
