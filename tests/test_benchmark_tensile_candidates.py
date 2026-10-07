# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
import importlib.util
from pathlib import Path
import unittest
from unittest import mock
import hashlib
import json
import os
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location('tensile_prepare', ROOT / 'corpus/benchmarks/tensile_candidates/prepare.py')
prepare = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(prepare)
with mock.patch.dict(sys.modules, {'prepare': prepare}):
    SPEC = importlib.util.spec_from_file_location('tensile_generate', ROOT / 'corpus/benchmarks/tensile_candidates/generate.py')
    generate = importlib.util.module_from_spec(SPEC)
    SPEC.loader.exec_module(generate)


class TensileCandidates(unittest.TestCase):
    def test_candidate_configs_are_single_solution_and_shape(self):
        for variant, (target, _, _, shape) in prepare.CANDIDATES.items():
            with self.subTest(variant=variant):
                config, provenance = prepare.configuration(variant)
                self.assertEqual(provenance['target'], target)
                self.assertEqual(len(config['BenchmarkProblems']), 1)
                problem, group = config['BenchmarkProblems'][0]
                self.assertEqual(len(config['BenchmarkProblems'][0]), 2)
                self.assertEqual(group['BenchmarkFinalParameters'][0],
                                 {'ProblemSizes': [{'Exact': [shape[0], shape[1], 1, shape[2]]}]})
                for params in group['ForkParameters']:
                    for values in params.values():
                        self.assertEqual(len(values), 1)
                self.assertEqual(config['GlobalParameters']['EnqueuesPerSync'], 1)
                self.assertEqual(config['GlobalParameters']['NumElementsToValidate'], -1)

    def test_shape_override_replaces_all_upstream_shapes(self):
        config, provenance = prepare.configuration('bf16_subtile', (256, 512, 1024))
        self.assertEqual(provenance['shape'], [256, 512, 1024])
        self.assertEqual(config['BenchmarkProblems'][0][1]['BenchmarkFinalParameters'],
                         [{'ProblemSizes': [{'Exact': [256, 512, 1, 1024]}]}])

    def test_invalid_shape_rejected(self):
        with self.assertRaises(ValueError):
            prepare.configuration('bf16_streamk', (0, 1, 1))


class TensileSourceVerification(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.source = self.root / 'source'
        self.source.mkdir()
        self.git('init', '-q')
        self.git('config', 'user.name', 'Benchmark Test')
        self.git('config', 'user.email', 'benchmark@example.invalid')
        self.tracked = self.source / 'generator.py'
        self.tracked.write_text('original')
        self.git('add', 'generator.py')
        self.git('-c', 'commit.gpgsign=false', 'commit', '--signoff', '-qm', 'Fixture')
        self.revision = self.git('rev-parse', 'HEAD')

    def git(self, *args):
        return subprocess.run(['git', '-C', str(self.source), *args], check=True,
                              capture_output=True, text=True).stdout.strip()

    def test_clean_pinned_checkout_accepted(self):
        with mock.patch.object(prepare, 'REVISION', self.revision):
            prepare.verify_source(self.source)

    def test_invalid_source_rejected_before_generation(self):
        archive = self.root / 'archive'
        archive.mkdir()
        cases = [
            ('wrong revision', self.source, '0' * 40, 'pinned revision'),
            ('archive', archive, self.revision, 'Git checkout'),
            ('dirty', self.source, self.revision, 'must be clean'),
            ('untracked', self.source, self.revision, 'must be clean'),
        ]
        for name, source, revision, message in cases:
            with self.subTest(name=name):
                self.tracked.write_text('changed' if name == 'dirty' else 'original')
                if name == 'untracked':
                    (self.source / 'extra.py').write_text('untracked')
                output = self.root / 'output'
                argv = ['generate.py', '--source-root', str(source), '--output', str(output)]
                with mock.patch.object(prepare, 'REVISION', revision), mock.patch.object(
                        sys, 'argv', argv), mock.patch.object(generate, 'configuration') as configuration:
                    with self.assertRaisesRegex(ValueError, message):
                        generate.main()
                    configuration.assert_not_called()
                self.assertFalse(output.exists())


class TensilePackaging(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)

    def test_package_preserves_provenance_and_records_artifacts(self):
        generated = self.root / 'generated'
        generated.mkdir()
        files = {'TensileLibrary.yaml': b'solutions: [{}]\n', 'kernel.co': b'code object'}
        for name, contents in files.items():
            (generated / name).write_bytes(contents)
        _, provenance = prepare.configuration('bf16_streamk')
        original = json.loads(json.dumps(provenance))
        generate.package(generated, self.root, provenance)
        expected = dict(original, files={name: hashlib.sha256(contents).hexdigest()
                                        for name, contents in files.items()})
        self.assertEqual(json.loads((self.root / 'artifacts.json').read_text()), expected)
        self.assertEqual(provenance, original)
        for name, contents in files.items():
            self.assertEqual((self.root / name).read_bytes(), contents)

    def test_failed_generation_retains_configuration_and_provenance(self):
        source = self.root / 'source'
        generator = source / 'projects/hipblaslt/tensilelite/Tensile'
        inputs = generator / 'Tests/common'
        inputs.mkdir(parents=True)
        (generator / 'Tensile.py').touch()
        variant = 'bf16_streamk'
        filename = prepare.CANDIDATES[variant][1]
        original = ROOT / 'corpus/benchmarks/tensile_candidates/upstream' / filename
        (inputs / filename).write_bytes(original.read_bytes())
        output = self.root / 'output'
        argv = ['generate.py', '--source-root', str(source), '--output', str(output),
                '--variant', variant]
        with mock.patch.object(sys, 'argv', argv), mock.patch.object(generate, 'verify_source'), \
                mock.patch.object(generate.subprocess, 'run',
                                  side_effect=subprocess.CalledProcessError(1, 'generator')):
            with self.assertRaises(subprocess.CalledProcessError):
                generate.main()
        destination = output / variant
        _, expected = prepare.configuration(variant)
        expected['config_sha256'] = hashlib.sha256((destination / 'candidate.yaml').read_bytes()).hexdigest()
        self.assertEqual(json.loads((destination / 'source.json').read_text()), expected)
        self.assertTrue((destination / 'generation-command.json').is_file())
        self.assertTrue((destination / 'generate.log').is_file())
        self.assertFalse((destination / 'artifacts.json').exists())


class TensileWorkloadContract(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.artifacts = self.root / 'bf16_streamk'
        self.artifacts.mkdir()
        (self.artifacts / 'TensileLibrary.yaml').write_text('fixture')
        self.metadata = dict(source_revision=prepare.REVISION, target='gfx950',
                             variant='bf16_streamk', shape=[256, 256, 256],
                             upstream_file='sk_bgemm_pap.yaml', upstream_sha256='sourcehash',
                             config_sha256='confighash',
                             files={'TensileLibrary.yaml': hashlib.sha256(b'fixture').hexdigest()})
        (self.artifacts / 'artifacts.json').write_text(json.dumps(self.metadata))
        self.runner = self.root / 'native-fixture'
        self.result = dict(invocations=1, correctness='passed', kernel_name='fixed_kernel',
                           solution_index=0, input_pattern='separable_positive_k_bf16_v1',
                           timings_ns=[123])
        self.output = self.root / 'output.json'

    def run_workload(self):
        script = '#!' + sys.executable + '\nimport pathlib, sys\npathlib.Path(sys.argv[-1]).write_text(' + repr(json.dumps(self.result)) + ')\n'
        self.runner.write_text(script)
        self.runner.chmod(0o755)
        env = dict(os.environ, TENSILE_CANDIDATE_ARTIFACTS=str(self.root),
                   TENSILE_CANDIDATE_RUNNER=str(self.runner))
        command = [sys.executable, '-S', str(ROOT / 'corpus/benchmarks/tensile_candidates/workload.py'),
                   '--workload', 'tensile_candidate', '--case', 'fixture', '--target', 'gfx950',
                   '--params', json.dumps(dict(variant='bf16_streamk', dtype='bf16', m=256, n=256, k=256)),
                   '--warmups', '1', '--samples', '1', '--output', str(self.output)]
        return subprocess.run(command, env=env, capture_output=True, text=True)

    def test_success_preserves_solution_provenance(self):
        result = self.run_workload()
        self.assertEqual(result.returncode, 0, result.stderr)
        payload = json.loads(self.output.read_text())
        self.assertEqual(payload['provider'], 'tensile')
        self.assertEqual(payload['timings_ns'], [123])
        self.assertEqual(payload['parameters']['kernel_name'], 'fixed_kernel')
        self.assertEqual(payload['parameters']['artifact_sha256'], self.metadata['files'])

    def test_multi_launch_result_rejected(self):
        self.result['invocations'] = 2
        result = self.run_workload()
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.output.exists())

    def test_tampered_artifact_rejected(self):
        (self.artifacts / 'TensileLibrary.yaml').write_text('changed')
        result = self.run_workload()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('artifact hash mismatch', result.stderr)

    def test_unrecorded_code_object_rejected(self):
        (self.artifacts / 'extra.co').write_text('unrecorded')
        result = self.run_workload()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('artifact inventory mismatch', result.stderr)


class TensileNativeHostReference(unittest.TestCase):
    def test_real_host_reference_executable(self):
        executable = os.environ.get('TENSILE_CANDIDATE_HOST_TESTS')
        if not executable:
            self.skipTest('Set TENSILE_CANDIDATE_HOST_TESTS to the built native host-test executable')
        result = subprocess.run([executable], capture_output=True, text=True, timeout=120)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn('Tensile host reference tests passed', result.stdout)


if __name__ == '__main__':
    unittest.main()
