# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
import json
import sys
import typing
from pathlib import Path

import pytest

from support.race_corpus import load_script

build = load_script("build")

# Stand-ins for clang, llvm-nm and hipcc. clang writes an empty code object to
# its -o path. llvm-nm prints FAKE_NM_OUTPUT and exits with FAKE_NM_EXIT. hipcc
# appends its arguments to <script>.argv, then behaves as FAKE_LINK says:
#   ok           link succeeds
#   reject-flag  reject --no-offload-new-driver as clang does, else succeed
#   link-error   fail with a linker error, whatever the flags
#   reject-then-link-error
#                reject the flag, and fail with a linker error without it
FAKE_CLANG = """
import sys
import typing
from pathlib import Path
Path(sys.argv[sys.argv.index("-o") + 1]).write_bytes(b"")
"""
FAKE_NM = """
import os, sys
status = int(os.environ.get("FAKE_NM_EXIT", "0"))
sys.stdout.write(os.environ.get("FAKE_NM_OUTPUT", ""))
if status:
    sys.stderr.write("llvm-nm: error: bad object\\n")
sys.exit(status)
"""
FAKE_HIPCC = """
import json, os, sys
from pathlib import Path
args = sys.argv[1:]
script = Path(__file__)
with script.with_name(script.name + ".argv").open("a") as log:
    log.write(json.dumps(args) + "\\n")
behaviour = os.environ["FAKE_LINK"]
flagged = "--no-offload-new-driver" in args
if behaviour in ("reject-flag", "reject-then-link-error") and flagged:
    sys.stderr.write("clang: error: unknown argument: '--no-offload-new-driver'\\n")
    sys.exit(1)
if behaviour in ("link-error", "reject-then-link-error"):
    sys.stderr.write("ld.lld: error: undefined symbol: hipLaunchKernel\\n")
    sys.exit(1)
"""


def write_tool(path: Path, body: str) -> Path:
    """An executable Python script at *path* that runs *body*."""
    path.write_text(f"#!{sys.executable}\n{body}")
    path.chmod(0o755)
    return path


@pytest.fixture
def tools(tmp_path: Path) -> build.Toolchain:
    """A toolchain whose clang, llvm-nm and hipcc are the fakes above."""
    unused = tmp_path / "unused"
    return build.Toolchain(
        root=tmp_path,
        hipcc=write_tool(tmp_path / "hipcc", FAKE_HIPCC),
        clang=write_tool(tmp_path / "clang", FAKE_CLANG),
        bundler=unused,
        llvm_mc=unused,
        llvm_nm=write_tool(tmp_path / "llvm-nm", FAKE_NM),
    )


def link_invocations(tools: build.Toolchain) -> list[list[str]]:
    """The arguments of each hipcc run, in order."""
    log = tools.hipcc.with_name(tools.hipcc.name + ".argv")
    return [json.loads(line) for line in log.read_text().splitlines()]


def link(tools: build.Toolchain, tmp_path: Path) -> Path:
    return build.link_executable(
        tmp_path / "host.o", tmp_path / "fatbin.o", tmp_path / "exe", tools=tools
    )


# --- The fatbin symbol is read from the host object, never assumed ---------------


def test_fatbin_symbol_is_read_from_the_host_object(
    tools: build.Toolchain, monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setenv(
        "FAKE_NM_OUTPUT",
        "                 U __hip_fatbin_wrapper\n"
        "0000000000000000 D __hip_fatbin_1f2e3d\n",
    )
    assert (
        build.fatbin_symbol(tmp_path / "host.o", tools=tools) == "__hip_fatbin_1f2e3d"
    )


def test_no_fatbin_symbol_is_a_build_error(
    tools: build.Toolchain, monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    # Embedding under a guessed name would link but leave the kernel unreachable.
    monkeypatch.setenv("FAKE_NM_OUTPUT", "")
    with pytest.raises(build.BuildError, match="host.o has no __hip_fatbin symbol"):
        build.fatbin_symbol(tmp_path / "host.o", tools=tools)


def test_only_the_wrapper_symbol_is_a_build_error(
    tools: build.Toolchain, monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setenv("FAKE_NM_OUTPUT", "                 U __hip_fatbin_wrapper\n")
    with pytest.raises(build.BuildError, match="has no __hip_fatbin symbol"):
        build.fatbin_symbol(tmp_path / "host.o", tools=tools)


def test_failed_symbol_inspection_is_a_build_error(
    tools: build.Toolchain, monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setenv("FAKE_NM_EXIT", "1")
    with pytest.raises(
        build.BuildError,
        match=r"(?s)reading symbols of host.o failed:.*llvm-nm: error: bad object",
    ):
        build.fatbin_symbol(tmp_path / "host.o", tools=tools)


# --- The link is retried only for a hipcc that rejects the driver flag -----------


def test_link_uses_the_old_driver_flag(
    tools: build.Toolchain, monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setenv("FAKE_LINK", "ok")
    assert link(tools, tmp_path) == tmp_path / "exe"
    (argv,) = link_invocations(tools)
    assert argv[0] == "--no-offload-new-driver"


def test_link_is_retried_without_a_rejected_flag(
    tools: build.Toolchain, monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setenv("FAKE_LINK", "reject-flag")
    assert link(tools, tmp_path) == tmp_path / "exe"
    first, retry = link_invocations(tools)
    assert "--no-offload-new-driver" in first
    assert "--no-offload-new-driver" not in retry
    assert retry == [arg for arg in first if arg != "--no-offload-new-driver"]


def test_unrelated_link_error_is_not_retried(
    tools: build.Toolchain, monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    # The first diagnostic is reported, not replaced by another driver's.
    monkeypatch.setenv("FAKE_LINK", "link-error")
    with pytest.raises(
        build.BuildError,
        match=r"(?s)linking exe failed:\nld\.lld: error: undefined symbol",
    ):
        link(tools, tmp_path)
    assert len(link_invocations(tools)) == 1


def test_failed_retry_reports_its_own_error(
    tools: build.Toolchain, monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setenv("FAKE_LINK", "reject-then-link-error")
    with pytest.raises(
        build.BuildError,
        match=r"(?s)retried without --no-offload-new-driver, which hipcc rejected:"
        r"\nld\.lld: error: undefined symbol",
    ):
        link(tools, tmp_path)
    assert len(link_invocations(tools)) == 2


# --- The SDK is the one ROCM_PATH names ------------------------------------------


def test_rocm_path_is_taken_from_the_environment(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setenv("ROCM_PATH", str(tmp_path / "rocm"))
    assert build.rocm_path() == tmp_path / "rocm"


# --- A build that stops at the code object has no executable ---------------------


def test_executable_is_optional_in_the_record() -> None:
    # Callers see from the annotation that an executable may be absent.
    assert typing.get_type_hints(build.BuiltMutant)["executable"] == Path | None


def test_unlinked_build_stops_at_the_code_object(
    tools: build.Toolchain, tmp_path: Path
) -> None:
    built = build.build_from_asm(
        tmp_path / "kernel.s",
        tmp_path / "host.o",
        "gfx950",
        tmp_path / "work",
        tools=tools,
        link=False,
    )
    assert built.executable is None
    assert built.code_object == tmp_path / "work" / "kernel_dev.o"
    assert built.code_object.is_file()
    # Nothing past the code object ran: no link was attempted.
    assert not tools.hipcc.with_name(tools.hipcc.name + ".argv").exists()
