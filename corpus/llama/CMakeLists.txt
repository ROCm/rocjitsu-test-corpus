cmake_minimum_required(VERSION 3.28)

project(rocjitsu_llama_corpus LANGUAGES C CXX)

if(NOT CMAKE_HIP_ARCHITECTURES)
    message(FATAL_ERROR
        "The llama corpus requires -DCMAKE_HIP_ARCHITECTURES=<gfx target>")
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
    find_program(LLAMA_CORPUS_ROCM_SDK_EXECUTABLE rocm-sdk)
    if(LLAMA_CORPUS_ROCM_SDK_EXECUTABLE)
        execute_process(
            COMMAND "${LLAMA_CORPUS_ROCM_SDK_EXECUTABLE}" path --root
            RESULT_VARIABLE llama_corpus_rocm_sdk_result
            OUTPUT_VARIABLE llama_corpus_rocm_sdk_root
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_QUIET
        )
        if(llama_corpus_rocm_sdk_result EQUAL 0 AND llama_corpus_rocm_sdk_root)
            set(ROCM_PATH "${llama_corpus_rocm_sdk_root}" CACHE PATH
                "ROCm SDK root" FORCE)
        endif()
    endif()
endif()
if(NOT ROCM_PATH OR NOT EXISTS "${ROCM_PATH}/lib/cmake/hip/hip-config.cmake")
    message(FATAL_ERROR
        "The llama corpus requires ROCM_PATH to point at a ROCm SDK root "
        "containing lib/cmake/hip/hip-config.cmake")
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
    find_program(LLAMA_CORPUS_HIP_COMPILER
        NAMES amdclang++ clang++
        PATHS
            "${ROCM_PATH}/lib/llvm/bin"
            "${ROCM_PATH}/bin"
            "${ROCM_PATH}/llvm/bin"
        NO_DEFAULT_PATH
    )
    if(LLAMA_CORPUS_HIP_COMPILER)
        set(CMAKE_HIP_COMPILER "${LLAMA_CORPUS_HIP_COMPILER}" CACHE FILEPATH
            "HIP compiler" FORCE)
    endif()
endif()

set(LLAMA_CORPUS_SOURCE_DIR
    "${CMAKE_CURRENT_LIST_DIR}/third_party/llama.cpp"
    CACHE PATH "llama.cpp source root")
if(NOT EXISTS "${LLAMA_CORPUS_SOURCE_DIR}/tests/test-backend-ops.cpp")
    message(FATAL_ERROR
        "Expected llama.cpp test-backend-ops sources at "
        "${LLAMA_CORPUS_SOURCE_DIR}")
endif()

# GGML reads the GPU target from GPU_TARGETS and only enables the HIP backend
# when GGML_HIP is set before the subdirectory is added.
set(GGML_HIP ON CACHE BOOL "Build the GGML HIP backend" FORCE)
set(GPU_TARGETS "${CMAKE_HIP_ARCHITECTURES}" CACHE STRING
    "GGML HIP offload targets" FORCE)

add_subdirectory("${LLAMA_CORPUS_SOURCE_DIR}/ggml" ggml)

add_executable(test-backend-ops
    "${LLAMA_CORPUS_SOURCE_DIR}/tests/test-backend-ops.cpp")
target_compile_features(test-backend-ops PRIVATE cxx_std_17)
# Keep each backend-op process single-threaded; pytest-xdist provides
# test-level concurrency.
target_compile_definitions(test-backend-ops PRIVATE N_THREADS=1)
target_link_libraries(test-backend-ops PRIVATE ggml)
