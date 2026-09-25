#!/usr/bin/env bash
# Build unmodified pinned headless Vulkan CTS. No GPU/ROCm SDK needed.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_root="${1:-${repo_root}/.build/vulkan-cts}"
mkdir -p "${build_root}"
build_root="$(cd "${build_root}" && pwd)"
source_dir="${build_root}/src"
revision="$(cat "${repo_root}/corpus/vulkan/revision.txt")"

if [[ ! -d "${source_dir}" ]]; then
  git init "${source_dir}"
  git -C "${source_dir}" remote add origin https://github.com/KhronosGroup/VK-GL-CTS.git
  git -C "${source_dir}" fetch --depth 1 origin "${revision}"
  git -C "${source_dir}" checkout --detach FETCH_HEAD
fi
if [[ "$(git -C "${source_dir}" rev-parse HEAD)" != "${revision}" ]]; then
  echo "Expected CTS checkout at ${revision}: ${source_dir}" >&2
  echo "Use a new build directory for a different revision." >&2
  exit 1
fi
if ! git -C "${source_dir}" diff --quiet HEAD; then
  echo "Expected an unmodified CTS checkout: ${source_dir}" >&2
  echo "Use a new build directory or restore the checkout's tracked changes." >&2
  exit 1
fi

# Keep upstream's dependency revisions and checksums. Validation layers are
# optional in the upstream fetcher and are unnecessary for this selection.
if [[ ! -f "${build_root}/sources-ready" ]]; then
  python3 "${source_dir}/external/fetch_sources.py" --protocol https
  touch "${build_root}/sources-ready"
fi
cmake -S "${source_dir}" -B "${build_root}/build" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release -DDEQP_TARGET=vulkan_headless \
  -DDEQP_DISABLE_VK_VIDEO_TESTS=ON
cmake --build "${build_root}/build" --target deqp-vk
echo "VULKAN_CTS_BINARY=${build_root}/build/external/vulkancts/modules/vulkan/deqp-vk"
