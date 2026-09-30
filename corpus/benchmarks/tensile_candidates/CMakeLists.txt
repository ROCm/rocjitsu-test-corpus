# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
cmake_minimum_required(VERSION 3.25)
project(tensile_candidate LANGUAGES CXX)
if(NOT IS_DIRECTORY "${TENSILE_SOURCE}/projects/hipblaslt/tensilelite")
  message(FATAL_ERROR "TENSILE_SOURCE must contain pinned rocm-libraries dd773741 source")
endif()
find_package(Python 3.10 COMPONENTS Interpreter Development.Module REQUIRED)
execute_process(
  COMMAND "${Python_EXECUTABLE}" -c
    "import sys; sys.path.insert(0, sys.argv[1]); from prepare import verify_source; verify_source(sys.argv[2])"
    "${CMAKE_CURRENT_SOURCE_DIR}" "${TENSILE_SOURCE}"
  COMMAND_ERROR_IS_FATAL ANY
)
set(GPU_TARGETS "gfx950;gfx1250")
find_package(hip REQUIRED CONFIG)
find_package(ROCmCMakeBuildTools REQUIRED CONFIG)
include(ROCMSetupVersion)
find_package(LLVM REQUIRED CONFIG PATHS "${ROCM_PATH}/lib/llvm/lib/cmake/llvm" NO_DEFAULT_PATH)
set(ORIGAMI_ENABLE_INSTALL OFF)
set(ORIGAMI_ENABLE_PYTHON OFF)
set(ORIGAMI_BUILD_TESTING OFF)
set(BUILD_TESTING OFF)
add_subdirectory("${TENSILE_SOURCE}/shared/origami" origami EXCLUDE_FROM_ALL)
set(TENSILELITE_ENABLE_HOST ON)
set(TENSILELITE_ENABLE_AUTOBUILD OFF)
set(TENSILELITE_ENABLE_CLIENT OFF)
set(TENSILELITE_BUILD_TESTING OFF)
set(HIPBLASLT_ENABLE_YAML ON)
set(HIPBLASLT_ENABLE_MXDATAGENERATOR ON)
set(HIPBLASLT_BUNDLE_PYTHON_DEPS OFF)
add_subdirectory("${TENSILE_SOURCE}/projects/hipblaslt/tensilelite" tensilelite EXCLUDE_FROM_ALL)
target_compile_options(tensilelite-host PUBLIC "SHELL:-x hip" --offload-host-only)
add_executable(tensile_candidate runner.cpp)
target_compile_features(tensile_candidate PRIVATE cxx_std_17)
target_include_directories(tensile_candidate PRIVATE ${LLVM_INCLUDE_DIRS})
target_link_libraries(tensile_candidate PRIVATE roc::tensilelite-host hip::host LLVMObjectYAML)
