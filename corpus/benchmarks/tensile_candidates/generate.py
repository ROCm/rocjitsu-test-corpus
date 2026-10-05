"""Build and package pinned candidate code objects without running benchmarks."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import shutil
import sys

from prepare import CANDIDATES, REVISION, configuration, verify_source
import yaml


def package(generated, output, provenance):
    libraries = list(generated.rglob('TensileLibrary.yaml'))
    if len(libraries) != 1:
        raise ValueError(f'expected one generated library, found {len(libraries)}')
    library = libraries[0]
    parsed = yaml.safe_load(library.read_text())
    if len(parsed.get("solutions", [])) != 1:
        raise ValueError("generated library must contain exactly one fixed solution")
    objects = sorted(library.parent.glob('*.co')) + sorted(library.parent.glob('*.hsaco'))
    if not objects:
        raise ValueError('generated library has no code objects')
    metadata = dict(provenance)
    metadata['files'] = {}
    for source in [library, *objects]:
        dest = output / source.name
        shutil.copy2(source, dest)
        metadata['files'][source.name] = hashlib.sha256(dest.read_bytes()).hexdigest()
    (output / 'artifacts.json').write_text(json.dumps(metadata, indent=2) + '\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-root', type=Path, required=True,
                        help='clean ROCm/rocm-libraries Git checkout at the pinned revision')
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--variant', choices=CANDIDATES, action='append')
    parser.add_argument('--shape', type=int, nargs=3,
                        help='override M N K; requires exactly one --variant')
    args = parser.parse_args()
    variants = args.variant or list(CANDIDATES)
    if args.shape and len(variants) != 1:
        parser.error('--shape requires exactly one --variant')
    verify_source(args.source_root)
    source = args.source_root.resolve() / 'projects/hipblaslt/tensilelite'
    if not (source / 'Tensile/Tensile.py').is_file():
        parser.error('source-root has no TensileLite generator')
    env = dict(os.environ)
    for variable in ('LD_PRELOAD', 'RJ_CONFIG', 'HSA_MODEL_LIB', 'HSA_MODEL_TOPOLOGY', 'HSA_OVERRIDE_GFX_VERSION'):
        env.pop(variable, None)
    env['PYTHONPATH'] = str(source) + os.pathsep + env.get('PYTHONPATH', '')
    env.setdefault('TENSILE_HELPER_CACHE_DIR', str(Path.home() / '.cache/tensile-helper'))
    for variant in variants:
        output = (args.output / variant).resolve()
        output.mkdir(parents=True, exist_ok=True)
        config, provenance = configuration(variant, args.shape)
        # Check the source configuration is the exact vendored input at this pin.
        filename = provenance['upstream_file']
        matches = list((source / 'Tensile/Tests/common').rglob(filename))
        if len(matches) != 1 or hashlib.sha256(matches[0].read_bytes()).hexdigest() != provenance['upstream_sha256']:
            raise ValueError(f'{variant}: source configuration differs from {REVISION}')
        text = yaml.safe_dump(config, sort_keys=False)
        (output / 'candidate.yaml').write_text(text)
        provenance['config_sha256'] = hashlib.sha256(text.encode()).hexdigest()
        (output / 'source.json').write_text(json.dumps(provenance, indent=2)+'\n')
        command = [sys.executable, '-c', 'import sys; from Tensile.Tensile import Tensile; Tensile(sys.argv[1:])',
                   str(output/'candidate.yaml'), str(output/'generated'), '--build-only',
                   '--gpu-targets', provenance['target'], '--cpu-only']
        (output/'generation-command.json').write_text(json.dumps(command, indent=2)+'\n')
        with (output/'generate.log').open('w') as log:
            subprocess.run(command, env=env, stdout=log, stderr=subprocess.STDOUT, check=True)
        package(output / 'generated', output, provenance)


if __name__ == '__main__':
    main()
