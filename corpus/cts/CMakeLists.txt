cmake_minimum_required(VERSION 3.28)

project(fpsan_tests LANGUAGES CXX)

if(NOT CMAKE_HIP_ARCHITECTURES)
    message(FATAL_ERROR
        "FPSan HIP tests require -DCMAKE_HIP_ARCHITECTURES=<gfx target>")
endif()

# HIP toolchain detection for corpus tests:
#   1. Respect an explicit -DROCM_PATH or inherited $ROCM_PATH.
#   2. Otherwise ask the ROCm Python SDK (`rocm-sdk path --root`), which is how
#      TheRock/venv-based ROCm artifacts are exposed in this corpus workflow.
#   3. Require the discovered root to contain hip-config.cmake before enabling HIP.
set(ROCM_PATH "" CACHE PATH "ROCm SDK root")
if(NOT ROCM_PATH AND DEFINED ENV{ROCM_PATH})
    set(ROCM_PATH "$ENV{ROCM_PATH}" CACHE PATH "ROCm SDK root" FORCE)
endif()
if(NOT ROCM_PATH)
    find_program(FPSAN_TESTS_ROCM_SDK_EXECUTABLE rocm-sdk)
    if(FPSAN_TESTS_ROCM_SDK_EXECUTABLE)
        execute_process(
            COMMAND "${FPSAN_TESTS_ROCM_SDK_EXECUTABLE}" path --root
            RESULT_VARIABLE fpsan_tests_rocm_sdk_result
            OUTPUT_VARIABLE fpsan_tests_rocm_sdk_root
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_QUIET
        )
        if(fpsan_tests_rocm_sdk_result EQUAL 0 AND fpsan_tests_rocm_sdk_root)
            set(ROCM_PATH "${fpsan_tests_rocm_sdk_root}" CACHE PATH "ROCm SDK root" FORCE)
        endif()
    endif()
endif()
if(NOT ROCM_PATH OR NOT EXISTS "${ROCM_PATH}/lib/cmake/hip/hip-config.cmake")
    message(FATAL_ERROR
        "FPSan HIP tests require ROCM_PATH to point at a ROCm SDK root containing "
        "lib/cmake/hip/hip-config.cmake")
endif()

set(ENV{ROCM_PATH} "${ROCM_PATH}")
set(ENV{HIP_PATH} "${ROCM_PATH}")
set(CMAKE_HIP_COMPILER_ROCM_ROOT "${ROCM_PATH}" CACHE PATH
    "ROCm root for the HIP compiler" FORCE)
list(APPEND CMAKE_PREFIX_PATH
    "${ROCM_PATH}"
    "${ROCM_PATH}/lib/cmake"
    "${ROCM_PATH}/lib64/cmake"
)
list(APPEND CMAKE_BUILD_RPATH
    "${ROCM_PATH}/lib"
    "${ROCM_PATH}/lib64"
)
if(NOT CMAKE_HIP_COMPILER)
    find_program(FPSAN_TESTS_HIP_COMPILER
        NAMES amdclang++
        PATHS
            "${ROCM_PATH}/lib/llvm/bin"
            "${ROCM_PATH}/bin"
            "${ROCM_PATH}/llvm/bin"
        NO_DEFAULT_PATH
    )
    if(FPSAN_TESTS_HIP_COMPILER)
        set(CMAKE_HIP_COMPILER "${FPSAN_TESTS_HIP_COMPILER}" CACHE FILEPATH
            "HIP compiler" FORCE)
    endif()
endif()

enable_language(HIP)
find_package(hip REQUIRED CONFIG)

include(cmake/FpsanTests.cmake)

enable_testing()
add_subdirectory(test_cases)
