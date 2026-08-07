from __future__ import annotations

import importlib.util
import lzma
import struct
import sys
from pathlib import Path

import msgpack
import pytest

REPO_ROOT = Path(__file__).resolve().parents[1]
GFX1201_MACH = 0x4E


def load_script(name: str):
    path = REPO_ROOT / "scripts" / f"{name}.py"
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None
    assert spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


extractor = load_script("extract_gfx1250_hsacos")


def make_amdgpu_elf(
    *,
    elf_type: int = 3,
    machine: int = 224,
    flags: int = 0,
) -> bytes:
    data = bytearray(64)
    data[:6] = b"\x7fELF\x02\x01"
    struct.pack_into("<H", data, 16, elf_type)
    struct.pack_into("<H", data, 18, machine)
    struct.pack_into("<I", data, 48, flags)
    struct.pack_into("<H", data, 52, 64)
    return bytes(data)


def make_elf_with_named_section(name: bytes, content: bytes) -> bytes:
    section_offset = 64
    section_count = 3
    section_table_size = section_count * 64
    names = b"\0.shstrtab\0" + name + b"\0"
    names_offset = section_offset + section_table_size
    content_offset = names_offset + len(names)
    data = bytearray(content_offset + len(content))
    data[:6] = b"\x7fELF\x02\x01"
    struct.pack_into("<Q", data, 40, section_offset)
    struct.pack_into("<HHH", data, 58, 64, section_count, 1)
    struct.pack_into(
        "<IIQQQQIIQQ",
        data,
        section_offset + 64,
        1,
        3,
        0,
        0,
        names_offset,
        len(names),
        0,
        0,
        1,
        0,
    )
    struct.pack_into(
        "<IIQQQQIIQQ",
        data,
        section_offset + 128,
        len(b"\0.shstrtab\0"),
        1,
        0,
        0,
        content_offset,
        len(content),
        0,
        0,
        1,
        0,
    )
    data[names_offset : names_offset + len(names)] = names
    data[content_offset:] = content
    return bytes(data)


def make_amdgpu_elf_with_metadata_target(
    target: str,
    *,
    flags: int = 0,
    suffix: bytes = b"",
) -> bytes:
    return make_amdgpu_elf_with_metadata_targets(
        (target,),
        flags=flags,
        suffix=suffix,
    )


def make_amdgpu_elf_with_metadata_targets(
    targets: tuple[str, ...],
    *,
    flags: int = 0,
    suffix: bytes = b"",
) -> bytes:
    owner = b"AMDGPU\0"
    notes = []
    for target in targets:
        description = msgpack.packb(
            {
                "amdhsa.kernels": [],
                "amdhsa.target": f"amdgcn-amd-amdhsa--{target}",
                "amdhsa.version": [1, 2],
            },
            use_bin_type=True,
        )
        notes.append(
            struct.pack("<III", len(owner), len(description), 32)
            + owner
            + bytes((-len(owner)) % 4)
            + description
            + bytes((-len(description)) % 4)
        )
    note = b"".join(notes)
    program_offset = 64
    note_offset = program_offset + 56
    data = bytearray(note_offset + len(note))
    data[:6] = b"\x7fELF\x02\x01"
    struct.pack_into("<HHI", data, 16, 3, 224, 1)
    struct.pack_into("<I", data, 48, flags)
    struct.pack_into("<Q", data, 32, program_offset)
    struct.pack_into("<HHH", data, 52, 64, 56, 1)
    struct.pack_into(
        "<IIQQQQQQ",
        data,
        program_offset,
        4,
        4,
        note_offset,
        0,
        0,
        len(note),
        len(note),
        4,
    )
    data[note_offset:] = note
    return bytes(data) + suffix


def make_clang_offload_bundle(entries: list[tuple[str, bytes]]) -> bytes:
    encoded = [(target.encode(), payload) for target, payload in entries]
    header_size = (
        len(extractor.CLANG_OFFLOAD_BUNDLE_MAGIC)
        + 8
        + sum(24 + len(target) for target, _payload in encoded)
    )
    payload_offset = header_size
    header = bytearray(extractor.CLANG_OFFLOAD_BUNDLE_MAGIC)
    header += struct.pack("<Q", len(encoded))
    payloads = bytearray()
    for target, payload in encoded:
        header += struct.pack("<QQQ", payload_offset, len(payload), len(target))
        header += target
        payloads += payload
        payload_offset += len(payload)
    return bytes(header + payloads)


def test_loadable_amdgpu_elf_validation():
    valid = make_amdgpu_elf()
    assert extractor.is_loadable_amdgpu_elf(valid)
    assert not extractor.is_loadable_amdgpu_elf(make_amdgpu_elf(elf_type=1))
    assert not extractor.is_loadable_amdgpu_elf(make_amdgpu_elf(machine=62))


@pytest.mark.parametrize(
    ("ccob_containers", "materialize_ccob", "failures", "expected"),
    (
        (0, False, [], ("not-present", True)),
        (1, False, [], ("skipped", False)),
        (1, True, [], ("materialized", True)),
        (1, True, [{"category": "ccob"}], ("failed", False)),
        (1, True, [{"category": "hip-bundle"}], ("materialized", False)),
    ),
    ids=(
        "no-ccob",
        "offline-skip",
        "materialized",
        "ccob-failure",
        "other-extraction-failure",
    ),
)
def test_extraction_completion_contract(
    ccob_containers,
    materialize_ccob,
    failures,
    expected,
):
    assert (
        extractor.extraction_completion(
            ccob_containers=ccob_containers,
            materialize_ccob=materialize_ccob,
            failures=failures,
        )
        == expected
    )


def test_embedded_elf_size_finds_minimal_image():
    image = make_amdgpu_elf()
    container = b"prefix" + image + b"suffix"
    assert extractor.embedded_elf_size(container, len(b"prefix")) == len(image)


def test_target_matching_uses_architecture_boundaries():
    assert extractor.path_mentions_target(Path("lib/gfx1250/kernel.hsaco"), "gfx1250")
    assert not extractor.path_mentions_target(
        Path("lib/gfx12501/kernel.hsaco"), "gfx1250"
    )
    assert extractor.bundle_target_matches(
        "hipv4-amdgcn-amd-amdhsa--gfx1250", "gfx1250"
    )
    assert extractor.bundle_target_matches(
        "hipv4-amdgcn-amd-amdhsa--gfx1250:xnack-", "gfx1250"
    )
    assert not extractor.bundle_target_matches(
        "hipv4-amdgcn-amd-amdhsa--gfx1201", "gfx1250"
    )
    assert extractor.amdhsa_targets(
        make_amdgpu_elf_with_metadata_target("gfx1250")
    ) == {"gfx1250"}
    assert "gfx1250" not in extractor.amdhsa_targets(
        make_amdgpu_elf_with_metadata_target("gfx12501")
    )


@pytest.mark.parametrize(
    ("image", "expected"),
    (
        (
            make_amdgpu_elf_with_metadata_target("gfx1250", flags=0x549),
            "amdhsa-target+elf-flags",
        ),
        (
            make_amdgpu_elf_with_metadata_target("gfx1250"),
            "amdhsa-target",
        ),
        (make_amdgpu_elf(flags=0x549), "elf-flags"),
        (make_amdgpu_elf(), None),
    ),
    ids=("metadata-and-flags", "metadata", "flags", "no-elf-evidence"),
)
def test_elf_target_evidence_accepts_unambiguous_inputs(image, expected):
    assert extractor.AMDGPU_MACH_BY_TARGET["gfx1250"] == 0x49
    assert extractor.elf_target_evidence(image, "gfx1250") == expected


@pytest.mark.parametrize(
    "image",
    (
        make_amdgpu_elf_with_metadata_targets(("gfx1250", "gfx1201")),
        make_amdgpu_elf_with_metadata_target("gfx1250", flags=GFX1201_MACH),
        make_amdgpu_elf(flags=GFX1201_MACH),
    ),
    ids=("multiple-target-notes", "metadata-flags-conflict", "wrong-flags"),
)
def test_elf_target_evidence_rejects_conflicts(image):
    with pytest.raises(ValueError):
        extractor.elf_target_evidence(image, "gfx1250")


def test_loose_object_path_does_not_override_target_note(tmp_path):
    environment = tmp_path / "environment"
    path = environment / "gfx1250" / "kernel.hsaco"
    path.parent.mkdir(parents=True)
    path.write_bytes(
        make_amdgpu_elf_with_metadata_target(
            "gfx1201",
            suffix=b"diagnostic: amdgcn-amd-amdhsa--gfx1250",
        )
    )
    corpus = extractor.Corpus(tmp_path / "corpus", "gfx1250")

    assert extractor.extract_loose([path], corpus, environment, "gfx1250") == 0
    assert corpus.records == []


def test_loose_object_path_does_not_override_elf_machine(tmp_path):
    environment = tmp_path / "environment"
    path = environment / "gfx1250" / "kernel.hsaco"
    path.parent.mkdir(parents=True)
    path.write_bytes(make_amdgpu_elf(flags=GFX1201_MACH))
    corpus = extractor.Corpus(tmp_path / "corpus", "gfx1250")

    assert extractor.extract_loose([path], corpus, environment, "gfx1250") == 0
    assert corpus.records == []


def test_loose_object_uses_target_path_as_last_resort(tmp_path):
    environment = tmp_path / "environment"
    path = environment / "gfx1250" / "kernel.hsaco"
    path.parent.mkdir(parents=True)
    path.write_bytes(make_amdgpu_elf())
    corpus = extractor.Corpus(tmp_path / "corpus", "gfx1250")

    assert extractor.extract_loose([path], corpus, environment, "gfx1250") == 1
    assert corpus.records[0]["target_evidence"] == "path"


def test_loose_object_uses_matching_elf_machine(tmp_path):
    environment = tmp_path / "environment"
    path = environment / "kernel.hsaco"
    path.parent.mkdir(parents=True)
    path.write_bytes(
        make_amdgpu_elf(flags=0x549)
    )
    corpus = extractor.Corpus(tmp_path / "corpus", "gfx1250")

    assert extractor.extract_loose([path], corpus, environment, "gfx1250") == 1
    assert corpus.records[0]["target_evidence"] == "elf-flags"


def test_loose_object_rejects_conflicting_target_metadata(tmp_path):
    environment = tmp_path / "environment"
    path = environment / "gfx1250" / "kernel.hsaco"
    path.parent.mkdir(parents=True)
    path.write_bytes(
        make_amdgpu_elf_with_metadata_target(
            "gfx1250",
            flags=GFX1201_MACH,
        )
    )
    corpus = extractor.Corpus(tmp_path / "corpus", "gfx1250")

    assert extractor.extract_loose([path], corpus, environment, "gfx1250") == 0
    assert corpus.records == []


def test_loose_object_rejects_multiple_target_notes(tmp_path):
    environment = tmp_path / "environment"
    path = environment / "gfx1250" / "kernel.hsaco"
    path.parent.mkdir(parents=True)
    path.write_bytes(
        make_amdgpu_elf_with_metadata_targets(
            ("gfx1250", "gfx1201"),
            flags=extractor.AMDGPU_MACH_BY_TARGET["gfx1250"],
        )
    )
    corpus = extractor.Corpus(tmp_path / "corpus", "gfx1250")

    assert extractor.extract_loose([path], corpus, environment, "gfx1250") == 0
    assert corpus.records == []


def test_bundle_dump_failure_is_recorded(tmp_path, monkeypatch):
    environment = tmp_path / "environment"
    path = environment / "library.so"
    path.parent.mkdir(parents=True)
    path.write_bytes(b"host ELF with .hip_fatbin marker")
    corpus = extractor.Corpus(tmp_path / "corpus", "gfx1250")

    monkeypatch.setattr(extractor, "has_elf_section", lambda *_args: True)

    def fail_dump(*_args, **_kwargs):
        return extractor.subprocess.CompletedProcess(
            _args[0],
            1,
            stderr="section dump failed",
        )

    monkeypatch.setattr(extractor.subprocess, "run", fail_dump)
    count, failures = extractor.extract_bundles(
        [path],
        corpus,
        environment,
        "gfx1250",
        Path("llvm-objcopy"),
        Path("clang-offload-bundler"),
    )

    assert count == 0
    assert failures == [
        {
            "category": "hip-bundle",
            "operation": "dump-section",
            "path": "library.so",
            "returncode": 1,
            "stderr": "section dump failed",
        }
    ]


def test_bundle_extraction_preserves_repeated_target_entries(tmp_path, monkeypatch):
    environment = tmp_path / "environment"
    path = environment / "library.so"
    path.parent.mkdir(parents=True)
    path.write_bytes(b"host ELF")
    corpus = extractor.Corpus(tmp_path / "corpus", "gfx1250")
    target = "hipv4-amdgcn-amd-amdhsa--gfx1250"
    fatbin = make_clang_offload_bundle(
        [(target, make_amdgpu_elf() + b"a")]
    ) + make_clang_offload_bundle([(target, make_amdgpu_elf() + b"b")])

    monkeypatch.setattr(extractor, "has_elf_section", lambda *_args: True)

    def dump_section(command, **_kwargs):
        output = Path(command[2].split("=", 1)[1])
        output.write_bytes(fatbin)
        return extractor.subprocess.CompletedProcess(command, 0, stderr="")

    monkeypatch.setattr(extractor.subprocess, "run", dump_section)
    count, failures = extractor.extract_bundles(
        [path],
        corpus,
        environment,
        "gfx1250",
        Path("llvm-objcopy"),
        Path("clang-offload-bundler"),
    )

    assert count == 2
    assert failures == []
    assert len(corpus.unique) == 2
    assert [record["bundle_index"] for record in corpus.records] == [0, 1]


def test_bundle_prefilter_rejects_plain_string_match(tmp_path):
    path = tmp_path / "library.so"
    path.write_bytes(make_amdgpu_elf() + b".hip_fatbin")

    assert not extractor.has_elf_section(path, b".hip_fatbin")


def test_bundle_prefilter_requires_nonempty_section(tmp_path):
    path = tmp_path / "library.so"
    path.write_bytes(make_elf_with_named_section(b".hip_fatbin", b""))
    assert not extractor.has_elf_section(path, b".hip_fatbin")

    path.write_bytes(make_elf_with_named_section(b".hip_fatbin", b"bundle"))
    assert extractor.has_elf_section(path, b".hip_fatbin")


def test_parse_aks2_yields_directory_metadata_and_image():
    image = make_amdgpu_elf() + b"amdgcn-amd-amdhsa--gfx1250"
    name = b"kernel.hsaco\0"
    directory = (
        extractor.AKS2_METADATA.pack(
            512,
            256,
            0,
            len(image),
            len(name),
        )
        + name
    )
    content = directory + image
    blob = extractor.AKS2_HEADER.pack(
        b"AKS2",
        len(content),
        1,
        len(directory),
    ) + lzma.compress(content)

    assert list(extractor.parse_aks2(blob)) == [("kernel.hsaco", 512, 256, image)]


def test_raw_embedded_conflict_records_failure_and_keeps_following_object(tmp_path):
    conflicting = make_amdgpu_elf_with_metadata_targets(("gfx1250", "gfx1201"))
    clean = make_amdgpu_elf_with_metadata_target("gfx1250") + b"tail"
    environment = tmp_path / "environment"
    host = environment / "lib" / "libfoo.so"
    host.parent.mkdir(parents=True)
    host.write_bytes(b"HOSTELF" + conflicting + b"pad" + clean)
    corpus = extractor.Corpus(tmp_path / "corpus", "gfx1250")

    count, failures = extractor.extract_raw_embedded(
        [host], corpus, environment, "gfx1250"
    )

    assert count == 1
    assert [record["category"] for record in corpus.records] == ["raw-embedded"]
    assert failures[0]["category"] == "raw-embedded"
    assert failures[0]["path"] == "lib/libfoo.so"
    assert "expected only gfx1250" in failures[0]["error"]


def test_corpus_deduplicates_bytes_but_preserves_provenance(tmp_path):
    corpus = extractor.Corpus(tmp_path / "corpus", "gfx1250")
    image = make_amdgpu_elf()

    first = corpus.add(image, "loose", {"path": "first.hsaco"})
    second = corpus.add(image, "kpack", {"archive": "kernels.kpack"})
    summary = corpus.finish({})

    assert first == second
    assert len(list(corpus.objects.glob("*.hsaco"))) == 1
    assert summary["source_records"] == 2
    assert summary["unique_code_objects"] == 1
    assert summary["category_unique_code_objects"] == {
        "kpack": 1,
        "loose": 1,
    }


def test_additional_roots_are_resolved_in_caller_order(tmp_path):
    first = tmp_path / "first"
    second = tmp_path / "second"
    first.mkdir()
    second.mkdir()

    assert extractor.resolve_additional_roots([second, first]) == [
        second.resolve(),
        first.resolve(),
    ]


def test_additional_roots_reject_missing_and_repeated_paths(tmp_path):
    root = tmp_path / "root"
    root.mkdir()

    with pytest.raises(RuntimeError, match="not a directory"):
        extractor.resolve_additional_roots([tmp_path / "missing"])
    with pytest.raises(RuntimeError, match="repeated"):
        extractor.resolve_additional_roots([root, root])


def test_inventory_deduplicates_hardlinks_across_roots(tmp_path):
    first = tmp_path / "first"
    second = tmp_path / "second"
    first.mkdir()
    second.mkdir()
    image = make_amdgpu_elf_with_metadata_target("gfx1250")
    source = first / "kernel.hsaco"
    source.write_bytes(image)
    (second / "kernel.hsaco").hardlink_to(source)

    inventory = extractor.inventory_files([first, second])

    assert inventory.files == [source]
    assert inventory.loose_amdgpu == [source]


def test_corpus_manifests_are_deterministic_across_insertion_order(tmp_path):
    image_a = make_amdgpu_elf() + b"a"
    image_b = make_amdgpu_elf() + b"b"
    records = [
        (image_a, "loose", {"path": "z/kernel.hsaco"}),
        (image_b, "kpack", {"archive": "a/kernels.kpack", "member": "b"}),
        (image_a, "kpack", {"archive": "a/kernels.kpack", "member": "a"}),
    ]

    outputs = []
    for name, insertion_order in (
        ("forward", records),
        ("reverse", list(reversed(records))),
    ):
        corpus = extractor.Corpus(tmp_path / name, "gfx1250")
        for image, category, source in insertion_order:
            corpus.add(image, category, source)
        corpus.finish({"target": "gfx1250"})
        outputs.append(corpus.destination)

    forward, reverse = outputs
    for relative in (
        Path("summary.json"),
        Path("manifests/NON_CCOB_SHA256SUMS"),
        Path("manifests/provenance.jsonl"),
        Path("manifests/SHA256SUMS"),
    ):
        assert (forward / relative).read_bytes() == (reverse / relative).read_bytes()
    assert sorted(path.name for path in (forward / "objects").iterdir()) == sorted(
        path.name for path in (reverse / "objects").iterdir()
    )
