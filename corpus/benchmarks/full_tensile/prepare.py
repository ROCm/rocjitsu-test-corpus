# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
"""Offline preparation for fixed full Tensile FP32 RDNA solutions (not TensileLite)."""

import hashlib
import json
from pathlib import Path
import subprocess

REVISION = "1c63e26254a357007ce2d963266085a30b39515b"
CASES = {
    "valu": dict(variant="valu", dtype="fp32", m=3072, n=2048, k=1024, beta=0),
    "tensor": dict(variant="tensor", dtype="fp32", i=2048, j=2048, k=16, l=64, beta=1),
    "splitk": dict(
        variant="splitk", dtype="fp32", m=3072, n=2048, k=1536, gsu=3, beta=1
    ),
    "pointer": dict(
        variant="pointer", dtype="fp32", m=1024, n=1024, k=1024, batch=8, beta=1
    ),
}
TARGETS = {"gfx1100": (11, 0, 0), "gfx1201": (12, 0, 1)}


def validate_parameters(params, target):
    if not isinstance(params, dict) or target not in TARGETS:
        raise ValueError("unsupported full Tensile target/parameters")
    variant = params.get("variant")
    if variant not in CASES or params != CASES[variant]:
        raise ValueError("only the four qualified fixed FP32 selections are supported")
    if any(
        type(v) is not int for k, v in params.items() if k not in ("variant", "dtype")
    ):
        raise ValueError("dimensions and scalar parameters must be integers")
    return variant


UPSTREAM = {
    "valu": "Tensile/Tests/extended/nonbatched/sgemm_asm_nn.yaml",
    "splitk": "Tensile/Tests/extended/nonbatched/sgemm_asm_nn.yaml",
    "tensor": "Tensile/Tests/extended/classic/test_tensor_contraction.yaml",
    "pointer": "Tensile/Tests/pre_checkin/sgemm_general_batch_asm_nn.yaml",
}
VENDOR = Path(__file__).resolve().parent / "upstream"


def verify_source(source_root):
    """Require a clean exact-pin monorepo and unchanged vendored seed bytes."""
    source_root = Path(source_root).resolve()
    source = source_root / "shared/tensile"
    if not (source / "Tensile/Source/lib/CMakeLists.txt").is_file():
        raise ValueError("source-root must contain full shared/tensile")

    def git(*args):
        return subprocess.check_output(
            ["git", "-C", str(source_root), *args], text=True
        ).strip()

    if git("rev-parse", "HEAD") != REVISION or git(
        "status", "--porcelain", "--", "shared/tensile"
    ):
        raise ValueError(
            "full Tensile source must be clean at the exact pinned revision"
        )
    for rel in set(UPSTREAM.values()):
        if (source / rel).read_bytes() != (VENDOR / Path(rel).name).read_bytes():
            raise ValueError("vendored source configuration mismatch")
    return source


def selection(variant, target):
    import yaml

    params = CASES[variant]
    validate_parameters(params, target)
    upstream = Path(UPSTREAM[variant]).name
    index = 1 if variant == "tensor" else 0
    vendor = yaml.safe_load((VENDOR / upstream).read_bytes())
    problem, group = vendor["BenchmarkProblems"][index][:2]
    selected = {}
    for section in ("BenchmarkCommonParameters", "ForkParameters"):
        for entry in group.get(section) or []:
            for key, choices in entry.items():
                selected[key] = choices[0]
    selected.update(
        ThreadTile=[4, 8],
        WorkGroup=[8, 8, 1],
        DepthU=8,
        VectorWidth=1,
        WavefrontSize=64,
        MatrixInstruction=[],
        GlobalSplitU=1,
    )
    if variant == "tensor":
        selected.update(ThreadTile=[4, 4], KernelLanguage="Assembly")
        sizes = [params[k] for k in ("i", "j", "k", "l")]
    elif variant == "pointer":
        sizes = [params[k] for k in ("m", "n", "batch", "k")]
    else:
        sizes = [params[k] for k in ("m", "n", "k")]
    if variant == "splitk":
        selected.update(GlobalSplitU=3, GlobalSplitUAlgorithm="SingleBuffer")
    selected.update(ProblemType=problem, ISA=TARGETS[target])
    return selected, sizes, upstream


def validate_artifacts(root, params, target):
    validate_parameters(params, target)
    root = Path(root).resolve()
    meta = json.loads((root / "artifacts.json").read_text())
    if (
        meta.get("source_revision") != REVISION
        or meta.get("target") != target
        or meta.get("parameters") != params
    ):
        raise ValueError("full Tensile artifact provenance mismatch")
    files = meta.get("files", {})
    actual = {p.name for p in root.iterdir() if p.suffix in (".co", ".hsaco")}
    actual |= {"TensileLibrary.dat", "selection.yaml"}
    if (
        not actual.intersection({p for p in actual if p.endswith((".co", ".hsaco"))})
        or set(files) != actual
    ):
        raise ValueError("full Tensile artifact inventory mismatch")
    for name, digest in files.items():
        path = root / name
        if (
            Path(name).name != name
            or path.is_symlink()
            or not path.resolve().is_relative_to(root)
        ):
            raise ValueError("artifact path escapes cell")
        if hashlib.sha256(path.read_bytes()).hexdigest() != digest:
            raise ValueError("full Tensile artifact hash mismatch: " + name)
    return meta


def generate(source_root, sdk_root, output, variant, target):
    """Generate/assemble one fixed library, never invoke the upstream client."""
    import os
    import shutil
    import sys
    import yaml

    source = verify_source(source_root)
    sdk = Path(sdk_root).resolve()
    selected, sizes, upstream = selection(variant, target)
    out = Path(output).resolve() / target / variant
    out.mkdir(parents=True, exist_ok=False)
    work = out / "build"
    work.mkdir()
    # The pin's assembler probes can create a.out. Always use an owned cwd.
    original = Path.cwd()
    os.chdir(work)
    try:
        sys.path.insert(0, str(source))
        from Tensile import Common
        from Tensile.SolutionStructs import Solution, ProblemSizes
        from Tensile.BenchmarkProblems import writeBenchmarkFiles
        import Tensile

        if not Path(Tensile.__file__).resolve().is_relative_to(source):
            raise ValueError("wrong full Tensile Python import")
        os.environ["HCC_AMDGPU_TARGET"] = target
        config = dict(
            CurrentISA=TARGETS[target],
            SupportedISA=[TARGETS[target]],
            ROCmAgentEnumeratorPath=False,
            CxxCompiler=str(sdk / "bin/amdclang++"),
            CCompiler=str(sdk / "bin/amdclang"),
            Assembler=str(sdk / "lib/llvm/bin/clang++"),
            OffloadBundler=str(sdk / "lib/llvm/bin/clang-offload-bundler"),
            Architecture=target,
            CodeObjectVersion="V5",
            WorkingPath=str(work),
            CpuThreads=1,
            LibraryFormat="msgpack",
            MergeFiles=False,
            KeepBuildTmp=True,
            IgnoreAsmCapCache=True,
            PrintLevel=1,
            PrintSolutionRejectionReason=True,
            HardwareMonitor=False,
            PinClocks=False,
            SleepPercent=0,
            KernelTime=False,
            NumWarmups=0,
            NumBenchmarks=1,
            EnqueuesPerSync=1,
            SyncsPerBenchmark=1,
            NumElementsToValidate=-1,
            DataInitTypeAB=3,
            DataInitTypeC=3,
            DataInitTypeAlpha=1,
            DataInitTypeBeta=CASES[variant]["beta"],
            BoundsCheck=0,
            ExitOnFails=2,
            PristineOnGPU=False,
        )
        Common.globalParameters.update(config)
        Common.assignGlobalParameters(config, warnOnMissingIsa=False)
        solution = Solution(selected)
        if not solution["Valid"]:
            raise ValueError("fixed full Tensile solution rejected; no search fallback")
        (out / "selection.yaml").write_text(
            yaml.safe_dump(
                dict(selected_solution=selected, sizes=sizes, global_parameters=config),
                sort_keys=False,
            )
        )
        writeBenchmarkFiles(
            str(work),
            [solution],
            ProblemSizes(solution["ProblemType"], [{"Exact": sizes}]),
            "fixed",
            [],
        )
        library = work / "library"
        generated = [
            library / "TensileLibrary.dat",
            *library.glob("*.co"),
            *library.glob("*.hsaco"),
        ]
        for path in generated:
            shutil.copyfile(path, out / path.name)
        files = {
            p.name: hashlib.sha256(p.read_bytes()).hexdigest()
            for p in out.iterdir()
            if p.is_file()
        }
        meta = dict(
            source_revision=REVISION,
            target=target,
            parameters=CASES[variant],
            files=files,
            upstream_file=UPSTREAM[variant],
            upstream_sha256=hashlib.sha256(
                (VENDOR / upstream).read_bytes()
            ).hexdigest(),
            generator_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            generator_cpu_threads=1,
            code_object_version="V5",
        )
        (out / "artifacts.json").write_text(json.dumps(meta, indent=2) + "\n")
        validate_artifacts(out, CASES[variant], target)
        print("PREPARED", out)
    finally:
        os.chdir(original)
    return out


def main():
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--source-root", type=Path, required=True, help="pinned rocm-libraries monorepo"
    )
    parser.add_argument("--sdk-root", type=Path, required=True)
    parser.add_argument(
        "--output",
        type=Path,
        required=True,
        help="fresh cells under output/target/variant",
    )
    parser.add_argument("--target", choices=TARGETS, required=True)
    parser.add_argument("--variant", choices=CASES, required=True)
    args = parser.parse_args()
    generate(args.source_root, args.sdk_root, args.output, args.variant, args.target)


if __name__ == "__main__":
    main()
