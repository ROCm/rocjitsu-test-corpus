# Contributing to rocjitsu-test-corpus

We are enthusiastic about contributions to our code and documentation. Please
feel free to file issues where documentation or functionality is lacking or,
even better, volunteer to contribute to help close these gaps!

______________________________________________________________________

> **Security vulnerabilities** — do not open a public GitHub Issue. See [SECURITY.md](SECURITY.md) for the private reporting process.

______________________________________________________________________

## Developer policies

These policies apply to all forms of activity and engagement in this project.

> [!IMPORTANT]
> AMD employees must also follow the ROCm open source software
> contributing policies at http://u.amd.com/rocm-oss-policies.

### Governance

This project is covered by the
[ROCm Project Governance](https://github.com/ROCm/ROCm/blob/develop/GOVERNANCE.md),
which also defines the code of conduct.

### Licensing

Code contributions to this project are covered under the terms of the
[LICENSE](LICENSE) file.

### Communication channels

Issue tracking, project planning, and code contributions are managed in GitHub.
We use an open-source toolchain so that workflows can be easily replicated in any fork.

______________________________________________________________________

## Development workflows

### Issue tracking

Before filing a new issue, search through
[existing issues](https://github.com/ROCm/rocjitsu-test-corpus/issues) to avoid duplicates.

General guidelines:

- If your issue is already listed, upvote it and add a comment with reproduction details.
- When in doubt, file a new issue — we'll mark duplicates accordingly.
- Provide as much information as possible: command output, GPU model, ROCm version, and
  OS version. This significantly reduces triage time.
- Check your issue regularly — we may ask follow-up questions.

### Code style

Follow the [ROCm/TheRock style guides](https://github.com/ROCm/TheRock/tree/main/docs/development/style_guides):

- [Bash style guide](https://github.com/ROCm/TheRock/blob/main/docs/development/style_guides/bash_style_guide.md)
- [CMake style guide](https://github.com/ROCm/TheRock/blob/main/docs/development/style_guides/cmake_style_guide.md)
- [GitHub Actions style guide](https://github.com/ROCm/TheRock/blob/main/docs/development/style_guides/github_actions_style_guide.md)
- [Python style guide](https://github.com/ROCm/TheRock/blob/main/docs/development/style_guides/python_style_guide.md)

### New feature or test development

Discussion about new features and test areas is welcome via:

- Filing a [GitHub issue](https://github.com/ROCm/rocjitsu-test-corpus/issues)
- Reaching out [on Discord](https://discord.com/invite/amd-dev)

### Pull Requests

All contributions should be submitted through a Pull Request (PR).

Before submitting a PR:

- Ensure the change addresses an existing issue or documented requirement.
- Run all applicable tests and validate the results.
- Update documentation as needed.
- Ensure all required GitHub Actions checks pass.
- Resolve review feedback before requesting approval.

PRs require:

- Approval from the appropriate CODEOWNERS.
- Successful completion of required status checks.
- Compliance with repository security and quality requirements.

### Branching

- Do not commit directly to protected branches.
- Create a feature branch for all changes.
- Keep changes focused and atomic.
- Rebase or update branches regularly to minimize merge conflicts.

### Commit Messages

- Use clear and descriptive commit messages.

### Testing

Contributors are expected to:

- Execute relevant unit and integration tests.
- Verify that existing functionality is not impacted.
- Include test coverage for new functionality when applicable.
- Document any known limitations or test exclusions.

#### Helper-header isolation

First-party source files and headers should directly include the headers that
declare the names they use, rather than relying on transitive includes.

`scripts/check_helper_headers.py` compiles each first-party `.h` and `.hpp`
under `corpus/cts`, `corpus/runtime-cts`, `corpus/race`, and `corpus/semantics`
as the only include in a translation unit. It checks host C++17 runtime CTS
headers with the gfx1250 platform definitions, HIP GNU C++17 CTS headers,
HIP GNU C++20 race headers, and HIP C++20 semantics headers. It also checks
the host-used CTS helpers `fpsan_generic.hpp`, `fpsan_semantics.hpp`,
`parity_ops.hpp`, `test_random.hpp`, and `test_utils.hpp` in plain C++17
and race's `race_log_expectation.hpp` in plain C++20, without HIP's
implicit runtime includes. Each suite uses its own include roots:
CTS support and vendored hip-fpsan, race's owning directory, or semantics'
include directory. HIP headers use their
target family (`gfx942`, `gfx950`, `gfx1151`, `gfx1201`, or `gfx1250`). Generic
HIP headers use gfx950; the RDNA4 wave64 helper adds `-mwavefrontsize64`.
Additional wave64 configurations check `wmma_gfx11_parts.hpp` on gfx1151 and
`wmma_gfx12_parts.hpp`, `matrix_test_parts.hpp`, and `wave_test_harness.hpp`
on gfx1201, using the owning targets' wave64 definitions and
`-mwavefrontsize64`.
These are compile checks and do not require a GPU. They check self-containment;
they cannot detect direct dependencies supplied by another included header.

Provide a ROCm SDK supporting the selected HIP targets. Headers that include
GoogleTest, directly or through local helpers, also need its include directory.
For a GoogleTest source checkout, use its `googletest/include` directory. The
runtime CTS payload helper also needs the generated `payload_kernel.inc` from
a gfx1250 runtime CTS build:

```bash
cmake -S corpus/runtime-cts -B "$BUILD_DIR/runtime" -G Ninja \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DAMDGPU_LLVM_BIN="$ROCM_PATH/lib/llvm/bin" \
  -DCTS_ARCHS=gfx1250 -DCTS_SUITES=pm4
cmake --build "$BUILD_DIR/runtime" --parallel 4 --target kernel_payload_gfx1250
python3 scripts/check_helper_headers.py \
  --rocm-path "$ROCM_PATH" \
  --gtest-include "$GTEST_INCLUDE" \
  --runtime-kernel-dir "$BUILD_DIR/runtime/kernels/gfx1250"
```

Use `--header` to check one header, or repeat it for several. Only the selected
headers' dependencies and compilers are required; unused input paths are ignored.
For example, the semantics helper needs neither GoogleTest nor a runtime payload:

```bash
python3 scripts/check_helper_headers.py \
  --rocm-path "$ROCM_PATH" \
  --header corpus/semantics/gfx1250/include/test_support.hpp
```

Runtime CTS headers need only the host compiler, plus `--runtime-kernel-dir`
when they include the payload helper. `--host-cxx` and `--hip-cxx` select
explicit compilers. If the SDK needs additional HIP headers, pass each directory
with `--hip-include`; these become `-idirafter` paths. The script reports every
failure with its command and diagnostics and exits unsuccessfully if any check
fails. It creates no source-tree build files.

### Documentation

Changes that impact functionality, configuration, APIs, or user workflows should include corresponding documentation updates.

### Security Requirements

Contributors must not:

- Commit secrets, tokens, passwords, or credentials.
- Introduce vulnerable dependencies without justification.
- Bypass security controls or required security reviews.

All contributions may be subject to automated security scanning.
