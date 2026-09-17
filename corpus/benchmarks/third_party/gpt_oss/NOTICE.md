# GPT-OSS attention extracted source

- Upstream repository: https://github.com/openai/gpt-oss
- Extracted revision: `7b583341fe16729127f6d5b94a7b09ccae97e1a1`
- Original path: `gpt_oss/triton/attention.py`
- License: Apache License 2.0; see `LICENSE`.

`attention.py` retains the upstream `_attn_fwd` kernel and `attention_ref`
CPU reference unchanged. Unused wrappers and tests were omitted. The benchmark
adapter and fixed launch settings live separately in `../../triton/workloads.py`.
