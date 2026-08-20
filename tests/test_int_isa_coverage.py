from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import stat

import pytest

SCRIPT = (
    Path(__file__).resolve().parents[1]
    / "corpus"
    / "cts"
    / "scripts"
    / "check_int_isa_coverage.py"
)
SPEC = importlib.util.spec_from_file_location("check_int_isa_coverage", SCRIPT)
assert SPEC is not None and SPEC.loader is not None
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)

NAME = "int_isa_gfx1250_case_test"


def _inputs(tmp_path: Path):
    source_root = tmp_path / "sources"
    source_root.mkdir()
    (source_root / "case.cpp").write_text("// source\n", encoding="utf-8")
    coverage = {
        "schema_version": 2,
        "target": "gfx1250",
        "tests": [
            {
                "name": NAME,
                "source": "case.cpp",
                "expected_opcodes": ["v_gap_op_e32"],
            }
        ],
    }
    inventory = {
        "collection": "int_isa",
        "cases": [
            {"name": NAME, "supported_targets": ["gfx1250"]},
            {
                "name": MODULE.COVERAGE_TEST_NAME,
                "supported_targets": ["gfx1250"],
            },
        ],
    }
    disassembly = {NAME: "\tv_gap_op_e32 v0, v1\n"}
    return coverage, inventory, disassembly, source_root


def _validate(tmp_path: Path, mutate=None):
    inputs = list(_inputs(tmp_path))
    if mutate is not None:
        mutate(*inputs)
    return MODULE.validate_documents(*inputs)


def test_validate_accepts_complete_linked_coverage(tmp_path: Path):
    assert _validate(tmp_path) == []


def test_validate_normalizes_encoding_suffixes(tmp_path: Path):
    def mutate(coverage, inventory, disassembly, source_root):
        disassembly[NAME] = "\tv_gap_op_e64 v0, v1\n"

    assert _validate(tmp_path, mutate) == []


def test_validate_recognizes_global_memory_opcodes(tmp_path: Path):
    def mutate(coverage, inventory, disassembly, source_root):
        coverage["tests"][0]["expected_opcodes"] = ["global_load_tr8_b64"]
        disassembly[NAME] = "\tglobal_load_tr8_b64 v[0:1], v[2:3], off\n"

    assert _validate(tmp_path, mutate) == []


@pytest.mark.parametrize("opcode", ["v_cmp_lt_i32", "v_cmp_gt_i32"])
def test_validate_accepts_opcode_alternatives(tmp_path: Path, opcode: str):
    def mutate(coverage, inventory, disassembly, source_root):
        coverage["tests"][0]["expected_opcodes"] = []
        coverage["tests"][0]["expected_opcode_alternatives"] = [
            ["v_cmp_lt_i32", "v_cmp_gt_i32"]
        ]
        disassembly[NAME] = f"\t{opcode} v0, v1\n"

    assert _validate(tmp_path, mutate) == []


def test_validate_rejects_missing_opcode_alternatives(tmp_path: Path):
    def mutate(coverage, inventory, disassembly, source_root):
        coverage["tests"][0]["expected_opcodes"] = []
        coverage["tests"][0]["expected_opcode_alternatives"] = [
            ["v_cmp_lt_i32", "v_cmp_gt_i32"]
        ]
        disassembly[NAME] = "\tv_cmp_eq_i32 v0, v1\n"

    errors = _validate(tmp_path, mutate)
    assert any("missing opcode alternatives" in error for error in errors), errors


@pytest.mark.parametrize(
    ("mutate", "message"),
    [
        (
            lambda coverage, *_: coverage.update(schema_version=1),
            "coverage schema_version must be 2",
        ),
        (
            lambda coverage, *_: coverage.update(target="gfx1201"),
            "coverage target must be gfx1250",
        ),
        (
            lambda coverage, *_: coverage["tests"].append(dict(coverage["tests"][0])),
            "duplicate coverage test names",
        ),
        (
            lambda coverage, *_: coverage["tests"][0].update(source="missing.cpp"),
            "source does not exist",
        ),
        (
            lambda coverage, *_: coverage["tests"][0].update(expected_opcodes=[None]),
            "expected_opcodes must be a string list",
        ),
        (
            lambda coverage, *_: coverage["tests"][0].update(
                expected_opcode_alternatives=[["v_gap_op"], []]
            ),
            "expected_opcode_alternatives must be a list",
        ),
        (
            lambda coverage, *_: coverage["tests"][0].update(
                expected_opcodes=[], semantic_only=False
            ),
            "requires expected_opcodes, expected_opcode_alternatives, or semantic_only",
        ),
        (
            lambda coverage, *_: coverage["tests"][0].update(
                expected_opcodes=[], semantic_only=True
            ),
            "semantic_only entries require a non-empty reason",
        ),
        (
            lambda coverage, inventory, disassembly, *_: disassembly.clear(),
            "coverage entries missing linked images",
        ),
        (
            lambda coverage, inventory, disassembly, *_: disassembly.update(
                extra="v_gap_op v0, v1"
            ),
            "linked images missing coverage entries",
        ),
        (
            lambda coverage, inventory, disassembly, *_: disassembly.update(
                {NAME: "v_other_op v0, v1"}
            ),
            "linked image is missing opcodes: v_gap_op",
        ),
        (
            lambda coverage, inventory, *_: inventory["cases"].append(
                {
                    "name": "int_isa_gfx1250_missing_test",
                    "supported_targets": ["gfx1250"],
                }
            ),
            "gfx1250 integer cases missing coverage entries",
        ),
        (
            lambda coverage, inventory, *_: inventory["cases"][0].update(
                supported_targets=None
            ),
            "supported_targets must be a non-empty string list",
        ),
        (
            lambda coverage, inventory, *_: inventory["cases"].pop(),
            "case inventory must contain exactly one gfx1250 entry (found 0)",
        ),
        (
            lambda coverage, inventory, *_: inventory["cases"].append(
                dict(inventory["cases"][-1])
            ),
            "case inventory must contain exactly one gfx1250 entry (found 2)",
        ),
    ],
)
def test_validate_rejects_invalid_documents(tmp_path: Path, mutate, message: str):
    errors = _validate(tmp_path, mutate)
    assert any(message in error for error in errors), errors


def test_validate_accepts_semantic_only_entry(tmp_path: Path):
    def mutate(coverage, inventory, disassembly, source_root):
        coverage["tests"][0] = {
            "name": NAME,
            "source": "case.cpp",
            "semantic_only": True,
            "reason": "compiler lowers this operation through equivalent predicates",
        }
        coverage["tests"].append(
            {
                "name": "int_isa_gfx1250_other_test",
                "source": "other.cpp",
                "expected_opcodes": ["v_other_test"],
            }
        )
        inventory["cases"].append(
            {
                "name": "int_isa_gfx1250_other_test",
                "supported_targets": ["gfx1250"],
            }
        )
        (source_root / "other.cpp").write_text("// source\n", encoding="utf-8")
        disassembly["int_isa_gfx1250_other_test"] = "\tv_other_test v0, v1"

    assert _validate(tmp_path, mutate) == []


def test_validate_ignores_opcode_tokens_outside_instruction_mnemonics(tmp_path: Path):
    def mutate(coverage, inventory, disassembly, source_root):
        disassembly[NAME] = (
            "0000000000000000 <v_gap_op>:\n" "\tv_other_op v0, v1 // v_gap_op_e64\n"
        )

    errors = _validate(tmp_path, mutate)
    assert any("linked image is missing opcodes: v_gap_op" in error for error in errors)


@pytest.mark.parametrize(
    ("values", "message"),
    [
        (["missing-separator"], "invalid --image mapping"),
        (["case=/tmp/one", "case=/tmp/two"], "duplicate --image mapping"),
    ],
)
def test_parse_images_rejects_bad_mappings(values, message: str):
    _, errors = MODULE._parse_images(values)
    assert any(message in error for error in errors)


def test_load_json_reports_malformed_input(tmp_path: Path):
    path = tmp_path / "bad.json"
    path.write_text("{", encoding="utf-8")
    document, errors = MODULE._load_json(path)
    assert document is None
    assert errors and "cannot read" in errors[0]


def _fake_objdump(tmp_path: Path, extracted_names: list[str]) -> Path:
    path = tmp_path / "llvm-objdump"
    quoted_names = repr(extracted_names)
    path.write_text(
        "#!/usr/bin/env python3\n"
        "from pathlib import Path\n"
        "import sys\n"
        f"names = {quoted_names}\n"
        "if sys.argv[1] == '--offloading':\n"
        "    source = Path(sys.argv[2])\n"
        "    for name in names:\n"
        "        (source.parent / f'{source.name}.{name}').write_bytes(b'image')\n"
        "elif sys.argv[1] == '--disassemble':\n"
        "    print('\\tv_gap_op_e32 v0, v1')\n"
        "else:\n"
        "    raise SystemExit(2)\n",
        encoding="utf-8",
    )
    path.chmod(path.stat().st_mode | stat.S_IXUSR)
    return path


def test_disassemble_image_extracts_exact_target(tmp_path: Path):
    executable = tmp_path / "case"
    executable.write_bytes(b"host executable")
    objdump = _fake_objdump(tmp_path, ["0.hipv4-amdgcn-amd-amdhsa--gfx1250"])
    assert "v_gap_op_e32" in MODULE._disassemble_image(executable, objdump, "gfx1250")


@pytest.mark.parametrize(
    "names",
    [
        [],
        ["0.hipv4-amdgcn-amd-amdhsa--gfx1201"],
        ["0.hipv4-amdgcn-amd-amdhsa--gfx12500"],
        [
            "0.hipv4-amdgcn-amd-amdhsa--gfx1250",
            "1.hipv4-amdgcn-amd-amdhsa--gfx1250",
        ],
    ],
)
def test_disassemble_image_requires_one_exact_target(tmp_path: Path, names):
    executable = tmp_path / "case"
    executable.write_bytes(b"host executable")
    objdump = _fake_objdump(tmp_path, names)
    with pytest.raises(RuntimeError, match="expected one gfx1250 image"):
        MODULE._disassemble_image(executable, objdump, "gfx1250")
