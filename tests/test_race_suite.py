from __future__ import annotations

import json
import re
from pathlib import Path

import pytest

from support.prepare_inputs import make_target_spec
from test_suites import race


def test_manifest_preserves_every_moved_gtest() -> None:
    configs = race.load_target_configs(race.default_config_files())
    expected_counts = {"gfx950": 45, "gfx1151": 8}

    for target, expected_count in expected_counts.items():
        cases = race.discover(make_target_spec(target), configs)
        assert len(cases) == expected_count
        assert {case.metadata["test_filter"] for case in cases} == _source_gtests(target)
        assert all(
            f"RaceTest.{target}_{case.metadata['name']}" in case.selector_names
            for case in cases
        )


def test_materialize_config_adds_required_race_plugin(tmp_path: Path) -> None:
    base = tmp_path / "base.json"
    output = tmp_path / "case" / "config.json"
    sink = tmp_path / "case" / "plugins"
    output.parent.mkdir()
    sink.mkdir()
    base.write_text('{"max_ticks": 123, "vm": {}}\n', encoding="utf-8")

    race._materialize_config(base, output, sink)

    value = json.loads(output.read_text(encoding="utf-8"))
    assert value["max_ticks"] == 123
    assert value["require_all_plugins"] is True
    assert value["plugins"] == {"race": {}}
    assert value["sinks"] == {"types": ["file"], "dir": str(sink)}


def test_materialize_config_rejects_preconfigured_plugins(tmp_path: Path) -> None:
    base = tmp_path / "base.json"
    output = tmp_path / "config.json"
    sink = tmp_path / "plugins"
    base.write_text('{"plugins": {"logging": {}}}\n', encoding="utf-8")

    with pytest.raises(RuntimeError, match="must not enable plugins or sinks"):
        race._materialize_config(base, output, sink)


def test_run_wrapper_substitutes_private_config(tmp_path: Path) -> None:
    config = tmp_path / "config.json"
    assert race._run_wrapper_command(
        "rocjitsu --config {config} --", config
    ) == ["rocjitsu", "--config", str(config), "--"]


@pytest.mark.parametrize(
    "wrapper",
    ["rocjitsu --config fixed.json --", "rocjitsu {config} {config} --"],
)
def test_run_wrapper_requires_one_config_token(wrapper: str, tmp_path: Path) -> None:
    with pytest.raises(RuntimeError, match="exactly one"):
        race._run_wrapper_command(wrapper, tmp_path / "config.json")


def _source_gtests(target: str) -> set[str]:
    layout = race.TARGET_LAYOUT[target]
    source = race.RACE_SOURCE_DIR / f"hip_race_{target}_test.hip"
    pattern = re.compile(r"^TEST_F\(([^,]+),\s*([^)]+)\)", re.MULTILINE)
    return {
        f"{fixture.strip()}.{name.strip()}"
        for fixture, name in pattern.findall(source.read_text(encoding="utf-8"))
        if fixture.strip() == layout["fixture"]
    }
