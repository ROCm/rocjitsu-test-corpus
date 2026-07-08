# CTS Tests

This directory contains deterministic HIP CTS cases used by the rocJITsu test
corpus. FPSan-derived cases remain in the `fpsan` collection; standalone integer
ISA semantic cases live in separate collections such as `int_isa`.

## Layout

```text
third_party/
  hip-fpsan/        Vendored upstream headers and license/provenance.

test_cases/
  *_test_cases.json Test inventories, one collection per file.
  general/fpsan/    Architecture-independent FPSan API and payload tests.
  gfx1250/fpsan/    gfx1250-only FPSan AMDGPU intrinsic wrapper tests.
  cdna4/fpsan/      CDNA4/gfx950-specific FPSan intrinsic wrapper tests.
  cdna3/fpsan/      CDNA3/gfx94x-specific FPSan intrinsic wrapper tests.
  rdna3/fpsan/      RDNA3/gfx11-specific FPSan intrinsic wrapper tests.
  rdna4/fpsan/      RDNA4/gfx120x-specific FPSan intrinsic wrapper tests.
  rdna4/int_isa/    RDNA4/gfx1201 standalone integer ISA semantic tests.

configs/            Test target configs and selected test lists.
support/            Shared test support headers.
CMakeLists.txt      Shared configure/build definitions for CTest targets.
```

The upstream GoogleTest suites are not vendored directly. FPSan-derived tests
should stay under `fpsan/` directories so standalone CTS additions remain easy
to distinguish. Individual upstream tests should be adapted into standalone
CTest targets that return `0` on pass and a nonzero status on failure.
