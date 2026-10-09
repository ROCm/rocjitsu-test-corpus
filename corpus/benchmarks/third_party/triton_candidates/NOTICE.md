# Triton tutorial kernels

Source: https://github.com/triton-lang/triton/tree/ced7e4b42f992f0b125208767cafc371d079ffd9/python/tutorials

`persistent.py` contains `_compute_pid` and `matmul_kernel_persistent` from
`09-persistent-matmul.py`. `grouped.py` contains `grouped_matmul_kernel` from
`08-grouped-gemm.py`. Function signatures and bodies are unchanged. Autotuning
and launch-metadata decorators are removed, and the benchmark adapter supplies
fixed launch parameters. Tutorial drivers and other kernels are omitted.
Copyright (c) 2023–2025 NVIDIA Corporation & Affiliates. MIT license; see LICENSE.

`softmax.py` contains `softmax_kernel` from `02-fused-softmax.py` (upstream
Git blob `dd06410f921a45594bcba5c95804261c01d1b31e`). `layernorm.py` contains
`_layer_norm_fwd_fused` from `05-layer-norm.py` (upstream Git blob
`de8afeb2ccddd41d4e17a5b19b7765e4161a30aa`). Their JIT decorators, function
signatures, and bodies are unchanged. Tutorial drivers, occupancy selection,
and backward kernels are omitted; the adapter supplies fixed launch settings.
