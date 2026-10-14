# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Multi-target/policy producer contract regression tests."""

import io
import json
import subprocess
from collections.abc import Sequence
from dataclasses import replace
from pathlib import Path
from types import SimpleNamespace
from typing import Any
from unittest import mock

import pytest
from support.benchmark_runner import _run, _successful_process

from benchmarks import runner


@pytest.mark.parametrize("missing", ["targets", "thread_policies"])
def test_case_constructor_requires_support_declarations(missing: str) -> None:
    arguments: dict[str, Any] = {
        "id": "copy.small",
        "workload": "copy",
        "suite": "Custom",
        "name": "Small copy",
        "operation": "Copy",
        "params": {},
        "targets": ("gfx950",),
        "thread_policies": ("default", "single"),
    }
    del arguments[missing]
    with pytest.raises(TypeError, match=missing):
        runner.Case(**arguments)


def test_cell_constructor_requires_explicit_policy() -> None:
    case = runner.load_manifest().cases[0]
    with pytest.raises(TypeError, match="thread_policy"):
        runner.Cell(case, case.targets[0])


@pytest.mark.parametrize("policies", [("default",), ("single",), ("default", "single")])
def test_case_constructor_preserves_explicit_support(
    policies: tuple[str, ...],
) -> None:
    options = {"thread_policies": policies}
    case = runner.Case(
        id="copy.small",
        workload="copy",
        suite="Custom",
        name="Small copy",
        operation="Copy",
        params={},
        targets=("gfx950",),
        **options,
    )
    expected = policies
    assert case.thread_policies == expected
    suite = runner.Suite("custom", case.targets, (case,), 0, 1, 60)
    matrix = runner.select_matrix(suite)
    assert tuple(cell.thread_policy for cell in matrix) == expected
    assert all(cell.definition is case and cell.target == "gfx950" for cell in matrix)


@pytest.mark.parametrize(
    "manifest,warmups,samples",
    [("performance-v1", 0, 1), ("smoke", 1, 3), ("plugin-overhead", 3, 21)],
)
def test_manifest_sampling_recipes(manifest: str, warmups: int, samples: int) -> None:
    suite = runner.load_manifest(runner.BENCHMARK_ROOT / "suites" / f"{manifest}.toml")
    assert (suite.warmups, suite.samples) == (warmups, samples)


@pytest.mark.parametrize(
    "warmups,samples", [(None, None), (0, None), (None, 5), (2, 5)]
)
def test_direct_sampling_precedence_reaches_output_commands_and_progress(
    runner_context: SimpleNamespace,
    warmups: int | None,
    samples: int | None,
) -> None:
    ctx = runner_context
    ctx.suite = replace(ctx.suite, warmups=1, samples=3)
    expected = (1 if warmups is None else warmups, 3 if samples is None else samples)
    observed = []

    def execute(argv: Sequence[str], **kwargs: Any) -> subprocess.CompletedProcess[str]:
        observed.append(
            (
                int(argv[argv.index("--warmups") + 1]),
                int(argv[argv.index("--samples") + 1]),
            )
        )
        return _successful_process(ctx, argv, **kwargs)

    progress = io.StringIO()
    output, raw = _run(
        ctx,
        runner.select_matrix(ctx.suite)[:1],
        "sampling",
        process=execute,
        warmups=warmups,
        samples=samples,
        progress=progress,
    )
    summary = raw["execution_summary"]
    assert (summary["warmups"], summary["samples"]) == expected
    assert observed == [expected]
    assert f"warmups={expected[0]} samples={expected[1]}" in progress.getvalue()
    assert len(raw["benchmark_results"][0]["timing_results_s"]) == expected[1]
    assert raw["benchmark_results"][0]["status"] == "completed"
    assert json.loads((output / "run.json").read_text())["execution_summary"] == summary


@pytest.mark.parametrize("manifest", ["performance-v1", "smoke", "plugin-overhead"])
@pytest.mark.parametrize(
    "flags",
    [[], ["--warmups", "0"], ["--samples", "5"], ["--warmups", "2", "--samples", "5"]],
)
def test_cli_sampling_precedence(
    runner_context: SimpleNamespace,
    manifest: str,
    flags: list[str],
    capsys: pytest.CaptureFixture[str],
) -> None:
    ctx = runner_context
    path = runner.BENCHMARK_ROOT / "suites" / f"{manifest}.toml"
    ctx.suite = runner.load_manifest(path)
    expected_warmups = (
        int(flags[flags.index("--warmups") + 1])
        if "--warmups" in flags
        else ctx.suite.warmups
    )
    expected_samples = (
        int(flags[flags.index("--samples") + 1])
        if "--samples" in flags
        else ctx.suite.samples
    )
    output = ctx.root / "cli-sampling"
    observed = []

    def execute(argv: Sequence[str], **kwargs: Any) -> subprocess.CompletedProcess[str]:
        observed.append(
            (
                int(argv[argv.index("--warmups") + 1]),
                int(argv[argv.index("--samples") + 1]),
            )
        )
        return _successful_process(ctx, argv, **kwargs)

    args = [
        "--manifest",
        str(path),
        "--case",
        ctx.suite.cases[0].id,
        "--target",
        ctx.suite.cases[0].targets[0],
        "--thread-policy",
        "default",
        "--build-dir",
        str(ctx.build),
        "--rocjitsu-source-dir",
        str(ctx.source),
        "--output",
        str(output),
        "--run-wrapper",
        ctx.wrapper,
        *flags,
    ]
    for target, config in ctx.configs.items():
        args.extend(["--target-config", f"{target}={config}"])
    with mock.patch.object(
        runner,
        "_native_target_metadata",
        side_effect=lambda config, *_: runner.TargetMetadata(config),
    ), mock.patch.object(runner, "_run_command", side_effect=execute):
        assert runner.main(args) == 0
    raw = json.loads((output / "run.json").read_text())
    summary = raw["execution_summary"]
    assert (summary["warmups"], summary["samples"]) == (
        expected_warmups,
        expected_samples,
    )
    assert observed == [(expected_warmups, expected_samples)]
    assert len(raw["benchmark_results"][0]["timing_results_s"]) == expected_samples
    assert (
        f"warmups={expected_warmups} samples={expected_samples}"
        in capsys.readouterr().out
    )


@pytest.mark.parametrize("field", ["warmups", "samples"])
def test_manifest_requires_sampling_fields(tmp_path: Path, field: str) -> None:
    text = (runner.BENCHMARK_ROOT / "suites/smoke.toml").read_text()
    path = tmp_path / "missing.toml"
    path.write_text(
        "\n".join(
            line for line in text.splitlines() if not line.startswith(f"{field} =")
        )
    )
    with pytest.raises(runner.RunnerError, match=f"missing=.*{field}"):
        runner.load_manifest(path)


@pytest.mark.parametrize(
    "field,value",
    [
        ("warmups", "-1"),
        ("warmups", "true"),
        ("warmups", "1.5"),
        ("warmups", '"1"'),
        ("warmups", "[]"),
        ("samples", "0"),
        ("samples", "-1"),
        ("samples", "2"),
        ("samples", "true"),
        ("samples", "1.5"),
        ("samples", '"3"'),
        ("samples", "[]"),
    ],
)
def test_invalid_manifest_sampling_rejected_despite_cli_override(
    tmp_path: Path,
    field: str,
    value: str,
    capsys: pytest.CaptureFixture[str],
) -> None:
    text = (runner.BENCHMARK_ROOT / "suites/smoke.toml").read_text()
    original = "warmups = 1" if field == "warmups" else "samples = 3"
    path = tmp_path / "invalid.toml"
    path.write_text(text.replace(original, f"{field} = {value}"))
    with pytest.raises(runner.RunnerError, match=field):
        runner.load_manifest(path)
    with mock.patch.object(runner, "run_suite") as execute:
        assert (
            runner.main(
                ["--manifest", str(path), "--list", "--warmups", "0", "--samples", "1"]
            )
            == 2
        )
        execute.assert_not_called()
    assert field in capsys.readouterr().err


@pytest.mark.parametrize(
    "field,value",
    [
        ("warmups", -1),
        ("warmups", True),
        ("warmups", 1.5),
        ("warmups", "1"),
        ("samples", 0),
        ("samples", -1),
        ("samples", 2),
        ("samples", True),
        ("samples", 1.5),
        ("samples", "3"),
    ],
)
@pytest.mark.parametrize("source", ["recipe", "override"])
def test_direct_sampling_validation_precedes_launch(
    runner_context: SimpleNamespace,
    field: str,
    value: Any,
    source: str,
) -> None:
    ctx = runner_context
    if source == "recipe":
        ctx.suite = replace(ctx.suite, **{field: value})
        overrides: dict[str, Any] = {"warmups": 0, "samples": 1}
    else:
        overrides = {field: value}
    with mock.patch.object(runner, "validate_build") as validate, mock.patch.object(
        runner, "_run_command"
    ) as execute:
        with pytest.raises(runner.RunnerError, match=field):
            runner.run_suite(
                ctx.suite,
                runner.select_matrix(ctx.suite)[:1],
                build_dir=ctx.build,
                rocjitsu_source_dir=ctx.source,
                output=ctx.root / "invalid-recipe",
                run_wrapper=ctx.wrapper,
                target_configs=ctx.configs,
                **overrides,
            )
        validate.assert_not_called()
        execute.assert_not_called()
    assert not (ctx.root / "invalid-recipe").exists()


@pytest.mark.parametrize(
    "value", [None, "default", "single", "default,single", "single,default"]
)
def test_cli_policy_comma_list_preserves_supported_order(
    value: str | None,
    capsys: pytest.CaptureFixture[str],
) -> None:
    args = ["--list", "--target", "gfx950", "--target", "gfx1250"]
    policies = ("default", "single") if value is None else tuple(value.split(","))
    if value is not None:
        args.extend(["--thread-policy", value])
    expected = runner.select_matrix(runner.load_manifest(), thread_policies=policies)
    assert runner.main(args) == 0
    listed = [tuple(line.split("\t")) for line in capsys.readouterr().out.splitlines()]
    assert listed == [(cell.case, cell.target, cell.thread_policy) for cell in expected]


@pytest.mark.parametrize(
    "values", [("default", "single"), ("single", "default"), ("default", "default")]
)
def test_cli_repeated_policy_keeps_last_value(
    values: tuple[str, str],
    capsys: pytest.CaptureFixture[str],
) -> None:
    assert (
        runner.build_parser()
        .parse_args(["--thread-policy", values[0], "--thread-policy", values[1]])
        .thread_policy
        == values[1]
    )
    expected = runner.select_matrix(
        runner.load_manifest(), thread_policies=(values[1],)
    )
    assert (
        runner.main(
            ["--list", "--thread-policy", values[0], "--thread-policy", values[1]]
        )
        == 0
    )
    listed = [tuple(line.split("\t")) for line in capsys.readouterr().out.splitlines()]
    assert listed == [(cell.case, cell.target, cell.thread_policy) for cell in expected]


@pytest.mark.parametrize(
    "value",
    [
        "",
        ",",
        "default,",
        ",single",
        "default,,single",
        "unknown",
        "default,unknown",
        "default,default",
        "single,single",
        "single, default",
    ],
)
@pytest.mark.parametrize("listing", [False, True])
def test_invalid_policy_list_rejected_before_loading(
    value: str,
    listing: bool,
    capsys: pytest.CaptureFixture[str],
) -> None:
    args = ["--thread-policy", value, *(["--list"] if listing else [])]
    with mock.patch.object(runner, "load_manifest") as load, mock.patch.object(
        runner, "run_suite"
    ) as execute:
        with pytest.raises(SystemExit) as error:
            runner.main(args)
        assert error.value.code == 2
        load.assert_not_called()
        execute.assert_not_called()
    assert "--thread-policy" in capsys.readouterr().err


@pytest.mark.parametrize("value", ["default,single", "single,default"])
def test_policy_list_cli_run_retains_canonical_order(
    runner_context: SimpleNamespace,
    value: str,
) -> None:
    ctx = runner_context
    ctx.suite = replace(ctx.suite, warmups=1, samples=3)
    output = ctx.root / "policy-cli"
    budgets = []

    def execute(argv: Sequence[str], **kwargs: Any) -> subprocess.CompletedProcess[str]:
        budgets.append(argv[argv.index("--cpu-thread-budget") + 1])
        assert argv[argv.index("--warmups") + 1] == "1"
        assert argv[argv.index("--samples") + 1] == "3"
        return _successful_process(ctx, argv, **kwargs)

    args = [
        "--thread-policy",
        value,
        "--case",
        ctx.suite.cases[0].id,
        "--target",
        "gfx950",
        "--build-dir",
        str(ctx.build),
        "--rocjitsu-source-dir",
        str(ctx.source),
        "--output",
        str(output),
        "--run-wrapper",
        ctx.wrapper,
        "--target-config",
        f"gfx950={ctx.configs['gfx950']}",
    ]
    with mock.patch.object(
        runner, "load_manifest", return_value=ctx.suite
    ), mock.patch.object(
        runner,
        "_native_target_metadata",
        side_effect=lambda config, *_: runner.TargetMetadata(config),
    ), mock.patch.object(
        runner, "_run_command", side_effect=execute
    ):
        assert runner.main(args) == 0
    raw = json.loads((output / "run.json").read_text())
    assert budgets == ["0", "1"]
    assert [row["thread_policy"] for row in raw["benchmark_results"]] == [
        "default",
        "single",
    ]
    assert all(row["status"] == "completed" for row in raw["benchmark_results"])
    assert (
        raw["execution_summary"]["warmups"],
        raw["execution_summary"]["samples"],
    ) == (1, 3)


def test_consolidated_matrix_and_defaults() -> None:
    suite = runner.load_manifest()
    matrix = runner.select_matrix(suite, thread_policies=("default", "single"))
    assert suite.name == "performance-v1"
    assert len(suite.cases) == 20
    assert len(matrix) == 38
    assert sum(c.thread_policy == "default" for c in matrix) == 28
    assert sum(c.thread_policy == "single" for c in matrix) == 10
    assert len({(c.case, c.target, c.thread_policy) for c in matrix}) == 38
    groups = list(dict.fromkeys((c.target, c.thread_policy) for c in matrix))
    assert groups == [
        ("gfx950", "default"),
        ("gfx950", "single"),
        ("gfx1250", "default"),
        ("gfx1250", "single"),
    ]
    args = runner.build_parser().parse_args([])
    assert (args.warmups, args.samples, args.thread_policy) == (
        None,
        None,
        "default,single",
    )


@pytest.mark.parametrize(
    "policies",
    [None, ("default",), ("single",), ("default", "single"), ("single", "default")],
)
@pytest.mark.parametrize("filtered", [False, True])
def test_cli_and_direct_selection_intersect_manifest_support(
    policies: tuple[str, ...] | None, filtered: bool, capsys: pytest.CaptureFixture[str]
) -> None:
    suite = runner.load_manifest()
    targets = ("gfx950",) if filtered else ()
    cases = (
        ("gpt_oss.causal_seq2560", "gpt_oss.window_batch4_seq3072") if filtered else ()
    )
    expected = {
        (case.id, target, policy)
        for case in suite.cases
        for target in case.targets
        for policy in case.thread_policies
        if (not targets or target in targets)
        and (not cases or case.id in cases)
        and (policies is None or policy in policies)
    }
    selection = {} if policies is None else {"thread_policies": policies}
    matrix = runner.select_matrix(suite, targets=targets, cases=cases, **selection)
    assert {(cell.case, cell.target, cell.thread_policy) for cell in matrix} == expected
    args = ["--list"]
    for target in targets:
        args.extend(["--target", target])
    for case in cases:
        args.extend(["--case", case])
    if policies is not None:
        args.extend(["--thread-policy", ",".join(policies)])
    assert runner.main(args) == 0
    listed = [tuple(line.split("\t")) for line in capsys.readouterr().out.splitlines()]
    assert listed == [(cell.case, cell.target, cell.thread_policy) for cell in matrix]


def test_single_manifest_rejects_unsupported_policies() -> None:
    suite = runner.load_manifest(runner.BENCHMARK_ROOT / "suites/smoke.toml")
    with pytest.raises(runner.RunnerError, match="no supported"):
        runner.select_matrix(suite, thread_policies=("single",))
    with pytest.raises(runner.RunnerError, match="thread_policy"):
        runner.select_matrix(suite, thread_policies=("bogus",))


@pytest.mark.parametrize("flag", ["--cpu-thread-budget 2", "--cpu-thread-budget=2"])
def test_wrapper_budget_conflict(flag: str) -> None:
    with pytest.raises(runner.RunnerError, match="budget"):
        runner.parse_run_wrapper(f"rocjitsu {flag} --config {{config}} --")


def test_grouped_run_contract_and_native_budgets(
    runner_context: SimpleNamespace,
) -> None:
    ctx = runner_context
    ctx.suite = replace(
        ctx.suite,
        cases=tuple(
            replace(c, targets=ctx.suite.targets, thread_policies=("default", "single"))
            for c in ctx.suite.cases
        ),
    )
    matrix = runner.select_matrix(ctx.suite, thread_policies=("default", "single"))
    commands = []

    def execute(argv: Sequence[str], **kwargs: Any) -> subprocess.CompletedProcess[str]:
        commands.append(tuple(argv))
        budget = argv[argv.index("--cpu-thread-budget") + 1]
        config = Path(argv[argv.index("--config") + 1])
        assert json.loads(config.read_text()) == {
            "exec_mode": "functional",
            "max_ticks": 0,
        }
        assert budget == (
            "1"
            if config.parent.name == "single" or config.parents[2].name == "single"
            else "0"
        )
        if "--thread-budget-table" in argv:
            return subprocess.CompletedProcess(
                argv, 0, "Configured | 1 | 1 | 0 | 1\n", ""
            )
        case = argv[argv.index("--case") + 1]
        if case == ctx.suite.cases[1].id:
            return subprocess.CompletedProcess(argv, 7, "", "mock failure")
        if case == ctx.suite.cases[2].id:
            raise subprocess.TimeoutExpired(argv, 300, output="partial")
        return _successful_process(ctx, argv, **kwargs)

    output = ctx.root / "multi"
    with mock.patch.object(runner, "_run_command", side_effect=execute):
        raw = runner.run_suite(
            ctx.suite,
            matrix,
            build_dir=ctx.build,
            rocjitsu_source_dir=ctx.source,
            output=output,
            run_wrapper=ctx.wrapper,
            target_configs=ctx.configs,
            samples=3,
        )
    assert len([c for c in commands if "--thread-budget-table" in c]) == 4
    rows = raw["benchmark_results"]
    assert len(rows) == 12
    assert [r["status"] for r in rows] == ["completed", "failed", "timeout"] * 4
    assert len(list(output.rglob("run.json"))) == 1
    assert "threading_mode" not in raw["execution_summary"]
    assert "target_config_sha256" not in raw["provenance"]["rocjitsu"]
    for cell, row in zip(matrix, rows, strict=True):
        assert row["operation"] == cell.definition.operation
        assert row["thread_policy"] == cell.thread_policy
        group = output / cell.target / cell.thread_policy
        assert (group / "allocation.json").is_file()
        assert (group / "cases" / cell.case / "config.json").is_file()
        assert (group / "cases" / cell.case / "stderr.txt").is_file()
    assert rows[0]["timing_results_s"] == [1e-9, 2e-9, 3e-9]


def test_empty_and_duplicate_matrix_rejected(runner_context: SimpleNamespace) -> None:
    ctx = runner_context
    cell = runner.select_matrix(ctx.suite)[0]
    for matrix in ((), (cell, cell)):
        with pytest.raises(runner.RunnerError, match="empty|duplicate"):
            runner.run_suite(
                ctx.suite,
                matrix,
                build_dir=ctx.build,
                rocjitsu_source_dir=ctx.source,
                output=ctx.root / "invalid",
                run_wrapper=ctx.wrapper,
                target_configs=ctx.configs,
            )
    assert not (ctx.root / "invalid").exists()


@pytest.mark.parametrize("second_manifest", ["smoke.toml", "plugin-overhead.toml"])
def test_cli_rejects_repeated_manifest_before_loading(
    second_manifest: str, capsys: pytest.CaptureFixture[str]
) -> None:
    smoke = runner.BENCHMARK_ROOT / "suites" / "smoke.toml"
    other = runner.BENCHMARK_ROOT / "suites" / second_manifest
    with mock.patch.object(
        runner, "load_manifest", wraps=runner.load_manifest
    ) as load, mock.patch.object(runner, "run_suite") as run:
        with pytest.raises(SystemExit) as error:
            runner.main(["--manifest", str(smoke), "--manifest", str(other), "--list"])
        assert error.value.code == 2
        load.assert_not_called()
        run.assert_not_called()
    assert "--manifest may only be supplied once" in capsys.readouterr().err


@pytest.mark.parametrize(
    "args",
    [
        ["--thread-policy", "single,default,single"],
        ["--thread-policy", "unknown"],
        ["--unknown"],
    ],
)
def test_cli_rejects_invalid_flags(args: list[str]) -> None:
    with pytest.raises(SystemExit) as error:
        runner.main([*args, "--list"])
    assert error.value.code == 2


@pytest.mark.parametrize(
    "args", [["--warmups", "-1"], ["--samples", "0"], ["--samples", "2"]]
)
def test_cli_rejects_invalid_measurement_even_when_listing(
    args: list[str], capsys: pytest.CaptureFixture[str]
) -> None:
    assert runner.main([*args, "--list"]) == 2
    assert "error:" in capsys.readouterr().err


def test_interruption_retains_all_group_identities(
    runner_context: SimpleNamespace,
) -> None:
    ctx = runner_context
    matrix = runner.select_matrix(ctx.suite, thread_policies=("default", "single"))
    calls = 0

    def execute(argv: Sequence[str], **kwargs: Any) -> subprocess.CompletedProcess[str]:
        nonlocal calls
        calls += 1
        if calls == 4:
            raise runner._CommandInterrupted("SIGTERM", "partial", "interrupted")
        return _successful_process(ctx, argv, **kwargs)

    with pytest.raises(KeyboardInterrupt):
        _run(ctx, matrix, "group-interrupt", process=execute, samples=3)
    output = ctx.root / "group-interrupt"
    raw = json.loads((output / "run.json").read_text())
    assert raw["execution_summary"]["finished_at"] is not None
    assert [r["status"] for r in raw["benchmark_results"]] == ["completed"] * 3 + [
        "failed"
    ] * 9
    for cell, row in zip(matrix, raw["benchmark_results"], strict=True):
        assert (row["id"], row["target"], row["thread_policy"]) == (
            cell.case,
            cell.target,
            cell.thread_policy,
        )
        assert row["operation"] == cell.definition.operation
    assert (
        output / "gfx950/single/cases" / matrix[3].case / "stdout.txt"
    ).read_text() == "partial"
    assert not (output / "gfx1250/default/cases").exists()


def test_composite_operation_is_metadata_on_failure(
    runner_context: SimpleNamespace,
) -> None:
    ctx = runner_context
    case = replace(ctx.suite.cases[0], operation="GEMM + activation + reduction")
    ctx.suite = replace(ctx.suite, cases=(case,))
    _, raw = _run(
        ctx,
        runner.select_matrix(ctx.suite),
        "composite",
        process=lambda argv, **kw: subprocess.CompletedProcess(argv, 1, "", "failure"),
    )
    assert all(
        r["id"] == case.id and r["operation"] == case.operation
        for r in raw["benchmark_results"]
    )


@pytest.mark.parametrize("value", ["NaN", "Infinity", "1e999"])
def test_nonfinite_config_rejected_before_output(
    runner_context: SimpleNamespace, value: str
) -> None:
    ctx = runner_context
    ctx.configs["gfx950"].write_text(
        '{"exec_mode":"functional", "extra":' + value + "}"
    )
    with pytest.raises(runner.RunnerError, match="finite"):
        _run(
            ctx, runner.select_matrix(ctx.suite, targets=["gfx950"]), "nonfinite-config"
        )
    assert not (ctx.root / "nonfinite-config").exists()


@pytest.mark.parametrize(
    "manifest_name,timeout",
    [
        ("performance-v1", 1200),
        ("plugin-overhead", 300),
        ("smoke", 60),
    ],
)
def test_single_manifest_timeout_forwarding_and_metadata(
    runner_context: SimpleNamespace, manifest_name: str, timeout: int
) -> None:
    ctx = runner_context
    manifest = runner.BENCHMARK_ROOT / "suites" / f"{manifest_name}.toml"
    ctx.suite = runner.load_manifest(manifest)
    matrix = runner.select_matrix(ctx.suite)[:1]
    forwarded = []

    def execute(argv: Sequence[str], **kwargs: Any) -> subprocess.CompletedProcess[str]:
        forwarded.append(kwargs["timeout"])
        return _successful_process(ctx, argv, **kwargs)

    output, raw = _run(ctx, matrix, "scalar-timeout", process=execute)
    assert forwarded == [timeout]
    assert raw["execution_summary"]["timeout_seconds"] == timeout
    assert raw["execution_summary"]["benchmark_suite"] == manifest_name
    assert json.loads((output / "run.json").read_text()) == raw


@pytest.mark.parametrize(
    "manifest_name", [None, "performance-v1", "plugin-overhead", "smoke"]
)
def test_cli_default_and_explicit_single_manifest(
    manifest_name: str | None, capsys: pytest.CaptureFixture[str]
) -> None:
    manifest = (
        runner.DEFAULT_MANIFEST
        if manifest_name is None
        else (runner.BENCHMARK_ROOT / "suites" / f"{manifest_name}.toml")
    )
    args = (
        ["--list"] if manifest_name is None else ["--manifest", str(manifest), "--list"]
    )
    assert runner.main(args) == 0
    assert capsys.readouterr().out == "".join(
        f"{cell.case}\t{cell.target}\t{cell.thread_policy}\n"
        for cell in runner.select_matrix(runner.load_manifest(manifest))
    )


@pytest.mark.parametrize("field", ["id", "workload", "suite", "name", "operation"])
@pytest.mark.parametrize("value", [42, True, [], {}, "", "   "])
def test_manifest_string_fields_reject_wrong_types_and_blanks(
    field: str, value: Any
) -> None:
    import tomllib

    manifest = runner.BENCHMARK_ROOT / "suites" / "smoke.toml"
    parsed = tomllib.loads(manifest.read_text())
    parsed["cases"][0][field] = value
    with mock.patch.object(runner.tomllib, "loads", return_value=parsed), pytest.raises(
        runner.RunnerError, match=f"case {field} must be a non-empty string"
    ):
        runner.load_manifest(manifest)


@pytest.mark.parametrize(
    "field,value",
    [
        ("params", []),
        ("params", {"dtype": 1}),
        ("targets", "gfx950"),
        ("targets", []),
        ("targets", [True]),
        ("thread_policies", "default"),
        ("thread_policies", []),
        ("thread_policies", ["unknown"]),
    ],
)
def test_manifest_nonstring_fields_remain_validated(field: str, value: Any) -> None:
    import tomllib

    manifest = runner.BENCHMARK_ROOT / "suites" / "smoke.toml"
    parsed = tomllib.loads(manifest.read_text())
    parsed["cases"][0][field] = value
    with mock.patch.object(runner.tomllib, "loads", return_value=parsed), pytest.raises(
        runner.RunnerError
    ):
        runner.load_manifest(manifest)


@pytest.mark.parametrize("change", ["missing", "unknown"])
def test_manifest_case_field_set_remains_exact(change: str) -> None:
    import tomllib

    manifest = runner.BENCHMARK_ROOT / "suites" / "smoke.toml"
    parsed = tomllib.loads(manifest.read_text())
    if change == "missing":
        del parsed["cases"][0]["operation"]
    else:
        parsed["cases"][0]["extra"] = 1
    with mock.patch.object(runner.tomllib, "loads", return_value=parsed), pytest.raises(
        runner.RunnerError, match="each case must contain"
    ):
        runner.load_manifest(manifest)
