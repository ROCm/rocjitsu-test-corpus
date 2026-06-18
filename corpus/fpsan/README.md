# FPSan Tests

This directory contains deterministic HIP tests for the vendored `hip-fpsan`
header-only library.

## Layout

```text
third_party/
  hip-fpsan/        Vendored upstream headers and license/provenance.

tests/
  general/          Architecture-independent FPSan API and payload tests.
  gfx1250/          gfx1250-only AMDGPU intrinsic wrapper tests.
  cdna4/            CDNA4/gfx950-specific AMDGPU intrinsic wrapper tests.
  cdna3/            CDNA3/gfx94x-specific AMDGPU intrinsic wrapper tests.
  rdna3/            RDNA3/gfx11-specific AMDGPU intrinsic wrapper tests.
  rdna4/            RDNA4/gfx120x-specific AMDGPU intrinsic wrapper tests.

configs/            Test target configs and selected test lists.
support/            Shared test support headers.
cmake/              Shared CMake helpers for tests.
```

The upstream GoogleTest suites are not vendored directly. Individual upstream
tests should be adapted into standalone tests that return `0` on pass and a
nonzero status on failure.
