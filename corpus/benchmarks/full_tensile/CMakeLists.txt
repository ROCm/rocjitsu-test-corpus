# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
cmake_minimum_required(VERSION 3.25)
project(full_tensile_benchmark LANGUAGES CXX)
find_package(Python3 COMPONENTS Interpreter REQUIRED)
execute_process(COMMAND "${Python3_EXECUTABLE}" -c
  "import sys; sys.path.insert(0, sys.argv[1]); from prepare import verify_source; verify_source(sys.argv[2])"
  "${CMAKE_CURRENT_SOURCE_DIR}" "${TENSILE_SOURCE}" COMMAND_ERROR_IS_FATAL ANY)
# Suppress HIP CMake's implicit amdgpu-arch invocation even for host-only code.
set(GPU_TARGETS "gfx1100;gfx1201")
set(GPU_BUILD_TARGETS "gfx1100;gfx1201")
find_package(hip REQUIRED CONFIG)
# Build only the upstream host runtime. No upstream client, SMI, tuning driver,
# device compiler discovery, or GPU kernels are needed in this executable.
set(TENSILE_USE_HIP ON)
set(TENSILE_USE_MSGPACK ON)
set(TENSILE_USE_LLVM OFF)
set(TENSILE_STATIC_ONLY ON)
add_subdirectory("${TENSILE_SOURCE}/shared/tensile/Tensile/Source/lib" tensile-host EXCLUDE_FROM_ALL)
target_compile_options(TensileHost PUBLIC "SHELL:-x hip" --offload-host-only)
add_executable(full_tensile_runner runner.cpp)
target_compile_features(full_tensile_runner PRIVATE cxx_std_17)
target_link_libraries(full_tensile_runner PRIVATE TensileHost hip::host)
