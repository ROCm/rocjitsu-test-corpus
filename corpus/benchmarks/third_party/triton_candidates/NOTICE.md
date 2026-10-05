# Triton tutorial kernels

Source: https://github.com/triton-lang/triton/tree/ced7e4b42f992f0b125208767cafc371d079ffd9/python/tutorials

`persistent.py` contains `_compute_pid` and `matmul_kernel_persistent` from
`09-persistent-matmul.py`. `grouped.py` contains `grouped_matmul_kernel` from
`08-grouped-gemm.py`. Function signatures and bodies are unchanged. Autotuning
and launch-metadata decorators are removed, and the benchmark adapter supplies
fixed launch parameters. Tutorial drivers and other kernels are omitted.
Copyright (c) 2023–2025 NVIDIA Corporation & Affiliates. MIT license; see LICENSE.
