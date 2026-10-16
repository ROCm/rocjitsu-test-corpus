# hip-fpsan

Vendored from:

- Repository: https://github.com/ROCm/hip-fpsan.git
- Commit: 59a6dec60030cee91328f01919b977ebaa42e11f
- License: MIT, see `LICENSE.md`

Only the header-only `include/fpsan` library is vendored here for FPSan tests.

The corpus adds direct standard-library includes for the declarations used by
these sources and headers, including platform-specific code. These local
include edits leave the extracted implementations unchanged.
