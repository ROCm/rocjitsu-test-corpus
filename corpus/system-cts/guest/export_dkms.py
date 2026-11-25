#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

"""Export the tagged AMDGPU DKMS sources and save the matching Git archive."""

import argparse
from pathlib import Path
import shutil
import subprocess
import tempfile


def export(repo, revision, destination, archive):
    commit = subprocess.check_output(
        [
            "git",
            "-C",
            repo,
            "rev-parse",
            "--verify",
            "--end-of-options",
            revision + "^{commit}",
        ],
        text=True,
    ).strip()
    manifest = subprocess.check_output(
        ["git", "-C", repo, "show", commit + ":drivers/gpu/drm/amd/dkms/sources"],
        text=True,
    )
    entries = [
        line.split()
        for line in manifest.splitlines()
        if line.strip() and not line.lstrip().startswith("#")
    ]
    for src, dst in entries:
        if any(
            Path(name).is_absolute() or ".." in Path(name).parts for name in (src, dst)
        ):
            raise ValueError(f"Non-relative AMDGPU manifest entry: {src} {dst}")
    if destination.exists() or archive.exists():
        raise FileExistsError("Select new source and archive paths")
    destination.parent.mkdir(parents=True, exist_ok=True)
    archive.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(dir=destination.parent, prefix="dkms-") as tmp:
        staging = Path(tmp) / "tree"
        output = Path(tmp) / "export"
        staging.mkdir()
        output.mkdir()
        with tempfile.TemporaryDirectory(
            dir=archive.parent, prefix="archive-"
        ) as archive_tmp:
            packed = Path(archive_tmp) / "source.tar.gz"
            subprocess.run(
                [
                    "git",
                    "-C",
                    repo,
                    "archive",
                    "--format=tar.gz",
                    f"--output={packed}",
                    commit,
                    "--",
                    *[src for src, _ in entries],
                ],
                check=True,
            )
            subprocess.run(["tar", "-xf", packed, "-C", staging], check=True)
            for src, dst in entries:
                source = staging / src
                target = output / dst
                if dst == "." or dst.endswith("/"):
                    target /= source.name
                target.parent.mkdir(parents=True, exist_ok=True)
                if source.is_dir():
                    shutil.copytree(source, target, dirs_exist_ok=True, symlinks=True)
                else:
                    shutil.copy2(source, target, follow_symlinks=False)
            (output / "Makefile").symlink_to("amd/dkms/Makefile")
            (output / "dkms.conf").symlink_to("amd/dkms/dkms.conf")
            packed.rename(archive)
            output.rename(destination)
    print(f"Exported {commit} to {destination} and {archive}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("repo", type=Path)
    parser.add_argument("revision")
    parser.add_argument("destination", type=Path)
    parser.add_argument("--archive", required=True, type=Path)
    args = parser.parse_args()
    export(
        args.repo.resolve(strict=True),
        args.revision,
        args.destination.resolve(),
        args.archive.resolve(),
    )
