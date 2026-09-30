import importlib.util
from pathlib import Path
import unittest
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
                           solution_index=0, input_pattern='separable_periodic_bf16',
                           timings_ns=[123])
        self.output = self.root / 'output.json'

    def run_workload(self):
        script = '#!' + sys.executable + '\nimport pathlib, sys\npathlib.Path(sys.argv[-1]).write_text(' + repr(json.dumps(self.result)) + ')\n'
        self.runner.write_text(script)
        self.runner.chmod(0o755)
        env = dict(os.environ, TENSILE_CANDIDATE_ARTIFACTS=str(self.root),
                   TENSILE_CANDIDATE_RUNNER=str(self.runner))
        command = [sys.executable, str(ROOT / 'corpus/benchmarks/tensile_candidates/workload.py'),
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
        self.assertEqual(payload['parameters']['initialization_launches'], 1)

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


if __name__ == '__main__':
    unittest.main()
