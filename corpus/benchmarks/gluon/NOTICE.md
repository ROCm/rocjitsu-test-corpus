# Source notice

`kernels.py` extracts these functions unchanged, including comments and
signatures, from Triton commit `675c59878aa2280b31f722aaf42b825fcee21de8`,
`python/tutorials/gluon/02-layouts.py`:

- `memcpy_1d_kernel`
- `get_mask_and_offsets`
- `memcpy_2d_inout_kernel`

Permanent upstream source:
https://github.com/triton-lang/triton/blob/675c59878aa2280b31f722aaf42b825fcee21de8/python/tutorials/gluon/02-layouts.py

Only the required imports and the three decorated functions were extracted;
tutorial examples, benchmark loops, plots and GPU assertions are not included.
No function body or decorator was changed. `prepare.py --upstream` checks exact
function source segments and decorators against the pinned file and verifies
full-file SHA-256 provenance. `provenance.json` owns those hashes.

The accompanying `LICENSE` is copied verbatim from that commit's root LICENSE:
Copyright 2018–2020 Philippe Tillet; Copyright 2020–2022 OpenAI, MIT terms.
First-party workload/preparation code is separate from the extraction and bears
its own MIT SPDX notice. This extraction pin does not silently change the
corpus's pre-existing Triton sources or installed compiler package pin.
