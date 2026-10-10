# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Multi-target/policy producer contract regression tests."""
import json
import subprocess
from dataclasses import replace
from pathlib import Path
from unittest import mock

import pytest

from benchmarks import runner
from test_benchmark_runner import runner_context, _successful_process, _run


def test_consolidated_matrix_and_defaults():
    suite = runner.load_manifest()
    matrix = runner.select_matrix(suite, thread_policies=('default', 'single'))
    assert suite.name == 'performance-v1'
    assert len(suite.cases) == 20
    assert len(matrix) == 38
    assert sum(c.thread_policy == 'default' for c in matrix) == 28
    assert sum(c.thread_policy == 'single' for c in matrix) == 10
    assert len({(c.case, c.target, c.thread_policy) for c in matrix}) == 38
    groups = list(dict.fromkeys((c.target, c.thread_policy) for c in matrix))
    assert groups == [('gfx950', 'default'), ('gfx950', 'single'),
                      ('gfx1250', 'default'), ('gfx1250', 'single')]
    args = runner.build_parser().parse_args([])
    assert (args.warmups, args.samples, args.thread_policy) == (0, 1, 'default')


def test_combine_manifests(tmp_path):
    first = runner.load_manifest(runner.BENCHMARK_ROOT / 'suites/smoke.toml')
    other = replace(first, name='other', cases=(replace(first.cases[0], id='other.copy', targets=('gfx942',)),))
    suite = runner.combine_suites((first, other))
    assert suite.targets == ('gfx950', 'gfx942')
    assert len(runner.select_matrix(suite)) == 2
    with pytest.raises(runner.RunnerError, match='duplicate'):
        runner.combine_suites((first, first))
    with pytest.raises(runner.RunnerError, match='timeout'):
        runner.combine_suites((first, replace(other, timeout_seconds=61)))
    with pytest.raises(runner.RunnerError, match='no supported'):
        runner.select_matrix(first, thread_policies=('single',))
    with pytest.raises(runner.RunnerError, match='thread_policy'):
        runner.select_matrix(first, thread_policies=('bogus',))


@pytest.mark.parametrize('flag', ['--cpu-thread-budget 2', '--cpu-thread-budget=2'])
def test_wrapper_budget_conflict(flag):
    with pytest.raises(runner.RunnerError, match='budget'):
        runner.parse_run_wrapper(f'rocjitsu {flag} --config {{config}} --')


def test_grouped_run_contract_and_native_budgets(runner_context):
    ctx = runner_context
    ctx.suite = replace(ctx.suite, cases=tuple(replace(c, targets=ctx.suite.targets,
                        thread_policies=('default', 'single')) for c in ctx.suite.cases))
    matrix = runner.select_matrix(ctx.suite, thread_policies=('default', 'single'))
    commands = []
    def execute(argv, **kwargs):
        commands.append(tuple(argv))
        budget = argv[argv.index('--cpu-thread-budget') + 1]
        config = Path(argv[argv.index('--config') + 1])
        assert json.loads(config.read_text()) == {'exec_mode': 'functional', 'num_threads': 8, 'max_ticks': 0}
        assert budget == ('1' if config.parent.name == 'single' or config.parents[2].name == 'single' else '0')
        if '--thread-budget-table' in argv:
            return subprocess.CompletedProcess(argv, 0, 'Configured | 1 | 1 | 0 | 1\n', '')
        case = argv[argv.index('--case') + 1]
        if case == ctx.suite.cases[1].id:
            return subprocess.CompletedProcess(argv, 7, '', 'mock failure')
        if case == ctx.suite.cases[2].id:
            raise subprocess.TimeoutExpired(argv, 300, output='partial')
        return _successful_process(ctx, argv, **kwargs)
    output = ctx.root / 'multi'
    with mock.patch.object(runner, '_run_command', side_effect=execute):
        raw = runner.run_suite(ctx.suite, matrix, build_dir=ctx.build,
            rocjitsu_source_dir=ctx.source, output=output, run_wrapper=ctx.wrapper,
            target_configs=ctx.configs, samples=3)
    assert len([c for c in commands if '--thread-budget-table' in c]) == 4
    rows = raw['benchmark_results']
    assert len(rows) == 12
    assert [r['status'] for r in rows] == ['completed', 'failed', 'timeout'] * 4
    assert len(list(output.rglob('run.json'))) == 1
    assert 'threading_mode' not in raw['execution_summary']
    assert 'target_config_sha256' not in raw['provenance']['rocjitsu']
    for cell, row in zip(matrix, rows, strict=True):
        assert row['operation'] == cell.definition.operation
        assert row['thread_policy'] == cell.thread_policy
        group = output / cell.target / cell.thread_policy
        assert (group / 'allocation.json').is_file()
        assert (group / 'cases' / cell.case / 'config.json').is_file()
        assert (group / 'cases' / cell.case / 'stderr.txt').is_file()
    assert rows[0]['timing_results_s'] == [1e-9, 2e-9, 3e-9]


def test_empty_and_duplicate_matrix_rejected(runner_context):
    ctx = runner_context
    cell = runner.select_matrix(ctx.suite)[0]
    for matrix in ((), (cell, cell)):
        with pytest.raises(runner.RunnerError, match='empty|duplicate'):
            runner.run_suite(ctx.suite, matrix, build_dir=ctx.build,
                rocjitsu_source_dir=ctx.source, output=ctx.root / 'invalid',
                run_wrapper=ctx.wrapper, target_configs=ctx.configs)
    assert not (ctx.root / 'invalid').exists()


def test_repeatable_manifest_cli(tmp_path, capsys):
    smoke = runner.BENCHMARK_ROOT / 'suites/smoke.toml'
    other = tmp_path / 'other.toml'
    other.write_text(smoke.read_text().replace('triton.rmsnorm_bf16', 'custom.rmsnorm')
                     .replace('gfx950', 'gfx942').replace('name = "smoke"', 'name = "other"'))
    assert runner.main(['--manifest', str(smoke), '--manifest', str(other), '--list']) == 0
    assert capsys.readouterr().out == (
        'triton.rmsnorm_bf16\tgfx950\tdefault\ncustom.rmsnorm\tgfx942\tdefault\n')
    assert runner.main(['--manifest', str(smoke), '--manifest', str(smoke), '--list']) == 2
    assert 'duplicate' in capsys.readouterr().err
    other.write_text(other.read_text().replace('timeout_seconds = 60', 'timeout_seconds = 61'))
    assert runner.main(['--manifest', str(smoke), '--manifest', str(other), '--list']) == 2
    assert 'timeout' in capsys.readouterr().err


@pytest.mark.parametrize('args', [
    ['--thread-policy', 'single,default'], ['--thread-policy', 'unknown'],
    ['--unknown'],
])
def test_cli_rejects_invalid_flags(args):
    with pytest.raises(SystemExit) as error:
        runner.main([*args, '--list'])
    assert error.value.code == 2


@pytest.mark.parametrize('args', [['--warmups', '-1'], ['--samples', '0'], ['--samples', '2']])
def test_cli_rejects_invalid_measurement_even_when_listing(args, capsys):
    assert runner.main([*args, '--list']) == 2
    assert 'error:' in capsys.readouterr().err


def test_interruption_retains_all_group_identities(runner_context):
    ctx = runner_context
    matrix = runner.select_matrix(ctx.suite, thread_policies=('default', 'single'))
    calls = 0
    def execute(argv, **kwargs):
        nonlocal calls
        calls += 1
        if calls == 4:
            raise runner._CommandInterrupted('SIGTERM', 'partial', 'interrupted')
        return _successful_process(ctx, argv, **kwargs)
    with pytest.raises(KeyboardInterrupt):
        _run(ctx, matrix, 'group-interrupt', process=execute, samples=3)
    output = ctx.root / 'group-interrupt'
    raw = json.loads((output / 'run.json').read_text())
    assert raw['execution_summary']['finished_at'] is not None
    assert [r['status'] for r in raw['benchmark_results']] == ['completed'] * 3 + ['failed'] * 9
    for cell, row in zip(matrix, raw['benchmark_results'], strict=True):
        assert (row['id'], row['target'], row['thread_policy']) == (cell.case, cell.target, cell.thread_policy)
        assert row['operation'] == cell.definition.operation
    assert (output / 'gfx950/single/cases' / matrix[3].case / 'stdout.txt').read_text() == 'partial'
    assert not (output / 'gfx1250/default/cases').exists()


def test_composite_operation_is_metadata_on_failure(runner_context):
    ctx = runner_context
    case = replace(ctx.suite.cases[0], operation='GEMM + activation + reduction')
    ctx.suite = replace(ctx.suite, cases=(case,))
    _, raw = _run(ctx, runner.select_matrix(ctx.suite), 'composite',
                 process=lambda argv, **kw: subprocess.CompletedProcess(argv, 1, '', 'failure'))
    assert all(r['id'] == case.id and r['operation'] == case.operation for r in raw['benchmark_results'])


@pytest.mark.parametrize('value', ['NaN', 'Infinity', '1e999'])
def test_nonfinite_config_rejected_before_output(runner_context, value):
    ctx = runner_context
    ctx.configs['gfx950'].write_text('{"exec_mode":"functional", "extra":' + value + '}')
    with pytest.raises(runner.RunnerError, match='finite'):
        _run(ctx, runner.select_matrix(ctx.suite, targets=['gfx950']), 'nonfinite-config')
    assert not (ctx.root / 'nonfinite-config').exists()
