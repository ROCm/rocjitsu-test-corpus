"""Prepare one fixed solution per pinned TensileLite candidate (no timed runs)."""
import hashlib
from pathlib import Path
import subprocess

REVISION = "dd77374194a3ea1a7258cd54f87af6747b6362a5"
CANDIDATES = {
    "bf16_streamk": ("gfx950", "sk_bgemm_pap.yaml", 0, (4096, 4096, 4096)),
    "bf16_subtile": ("gfx1250", "subtile_bf16_gfx1250_bench.yaml", 0, (4096, 4096, 4096)),
    "mxfp8_subtile": ("gfx950", "subtile_mxfp8.yaml", 4, (4096, 4096, 4096)),
    "mxfp4_streamk": ("gfx1250", "sk_mxf4gemm_tdm_pap.yaml", 0, (4096, 4096, 4096)),
}


def configuration(variant, shape=None):
    import yaml

    target, filename, group_index, defaults = CANDIDATES[variant]
    path = Path(__file__).parent / "upstream" / filename
    original = path.read_bytes()
    config = yaml.safe_load(original)
    problem, group = config["BenchmarkProblems"][group_index][:2]
    # Fix the first explicitly listed value of each tuning dimension. The MXFP8
    # group is the upstream MT256x256 Stream-K correctness-regression group.
    for name in ("BenchmarkCommonParameters", "ForkParameters"):
        for entry in group.get(name) or []:
            for key, values in entry.items():
                entry[key] = values[:1]
    m, n, k = shape or defaults
    if any(type(v) is not int or v <= 0 for v in (m, n, k)):
        raise ValueError("dimensions must be positive integers")
    final = [{"ProblemSizes": [{"Exact": [m, n, 1, k]}]}]
    final.extend(item for item in group["BenchmarkFinalParameters"] if "ProblemSizes" not in item)
    group["BenchmarkFinalParameters"] = final
    globals_ = config["GlobalParameters"]
    globals_.update(Architecture=target, LibraryFormat="yaml", NumWarmups=1,
                    NumBenchmarks=1, EnqueuesPerSync=1, SyncsPerBenchmark=1,
                    KernelTime=False, CpuThreads=4, NumElementsToValidate=-1)
    config["BenchmarkProblems"] = [[problem, group]]
    return config, {"source_revision": REVISION, "upstream_file": filename,
                    "upstream_sha256": hashlib.sha256(original).hexdigest(),
                    "variant": variant, "target": target, "shape": [m, n, k],
                    "selection": "first explicit value per fork in selected upstream group",
                    "upstream_problem_group": group_index}


def verify_source(source_root):
    """Require the clean, pinned Git checkout used by generation and native builds."""
    source_root = Path(source_root).resolve()

    def git(*args):
        try:
            return subprocess.run(
                ['git', '-C', str(source_root), *args], check=True,
                capture_output=True, text=True,
            ).stdout.strip()
        except subprocess.CalledProcessError as error:
            raise ValueError('Tensile source must be a Git checkout; archives are unsupported') from error

    if Path(git('rev-parse', '--show-toplevel')).resolve() != source_root:
        raise ValueError('Tensile source must be the rocm-libraries checkout root')
    if git('rev-parse', 'HEAD') != REVISION:
        raise ValueError(f'Tensile source must be at pinned revision {REVISION}')
    if git('status', '--porcelain', '--untracked-files=all', '--ignore-submodules=none'):
        raise ValueError('Tensile source must be clean (including untracked files)')
