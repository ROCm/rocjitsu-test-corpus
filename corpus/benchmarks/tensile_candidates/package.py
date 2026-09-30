"""Package a generated one-solution library with content hashes for workload.py."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil

import yaml


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--generated', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    libraries = list(args.generated.rglob('TensileLibrary.yaml'))
    if len(libraries) != 1:
        raise ValueError(f'expected one generated library, found {len(libraries)}')
    library = libraries[0]
    parsed = yaml.safe_load(library.read_text())
    if len(parsed.get("solutions", [])) != 1:
        raise ValueError("generated library must contain exactly one fixed solution")
    objects = sorted(library.parent.glob('*.co')) + sorted(library.parent.glob('*.hsaco'))
    if not objects:
        raise ValueError('generated library has no code objects')
    metadata = json.loads((args.output / 'source.json').read_text())
    metadata['files'] = {}
    for source in [library, *objects]:
        dest = args.output / source.name
        shutil.copy2(source, dest)
        metadata['files'][source.name] = hashlib.sha256(dest.read_bytes()).hexdigest()
    (args.output / 'artifacts.json').write_text(json.dumps(metadata, indent=2) + '\n')


if __name__ == '__main__':
    main()
