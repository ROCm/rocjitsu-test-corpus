cmake_minimum_required(VERSION 3.28)

project(rocfuzz_llama_pr13155_variant LANGUAGES C CXX)

set(ROCFUZZ_PR13155_GGML_ROOT "" CACHE PATH "Exact GGML overlay source tree")
set(ROCFUZZ_PR13155_RUNNER_SOURCE "" CACHE FILEPATH "PR #13155 runner source")
set(ROCFUZZ_THEROCK_ROCM_PATH "" CACHE PATH "ROCm dist tree")
set(ROCFUZZ_PR13155_AMDGCN_WAVEFRONT_SIZE "32" CACHE STRING
    "Compatibility definition for older GGML HIP sources that expect __AMDGCN_WAVEFRONT_SIZE")

if(NOT ROCFUZZ_PR13155_GGML_ROOT)
    message(FATAL_ERROR "ROCFUZZ_PR13155_GGML_ROOT is required")
endif()
if(NOT ROCFUZZ_PR13155_RUNNER_SOURCE)
    message(FATAL_ERROR "ROCFUZZ_PR13155_RUNNER_SOURCE is required")
endif()

if(ROCFUZZ_THEROCK_ROCM_PATH)
    list(APPEND CMAKE_PREFIX_PATH "${ROCFUZZ_THEROCK_ROCM_PATH}")
    list(APPEND CMAKE_PREFIX_PATH "${ROCFUZZ_THEROCK_ROCM_PATH}/lib/cmake")
    list(APPEND CMAKE_PREFIX_PATH "${ROCFUZZ_THEROCK_ROCM_PATH}/lib64/cmake")
endif()

set(GGML_HIP ON CACHE BOOL "ggml: use HIP" FORCE)
set(GGML_CUDA OFF CACHE BOOL "ggml: use CUDA" FORCE)
set(GGML_CUDA_FA OFF CACHE BOOL "ggml: compile ggml FlashAttention CUDA kernels" FORCE)
set(GGML_HIP_MMQ_MFMA OFF CACHE BOOL "ggml: enable MFMA MMA for CDNA in MMQ" FORCE)
set(GGML_HIP_RCCL OFF CACHE BOOL "ggml: use ROCm Collective Comm. Library" FORCE)

add_subdirectory("${ROCFUZZ_PR13155_GGML_ROOT}" "${CMAKE_BINARY_DIR}/ggml")

if(TARGET ggml-hip)
    target_compile_definitions(ggml-hip PRIVATE
        __AMDGCN_WAVEFRONT_SIZE=${ROCFUZZ_PR13155_AMDGCN_WAVEFRONT_SIZE}
    )
endif()

add_executable(rocfuzz_llama_pr13155_runner
    "${ROCFUZZ_PR13155_RUNNER_SOURCE}"
)
target_compile_features(rocfuzz_llama_pr13155_runner PRIVATE cxx_std_17)
target_include_directories(rocfuzz_llama_pr13155_runner PRIVATE
    "${ROCFUZZ_PR13155_GGML_ROOT}/include"
)
if(TARGET ggml::ggml)
    set(rocfuzz_pr13155_ggml_target ggml::ggml)
else()
    set(rocfuzz_pr13155_ggml_target ggml)
endif()
target_link_libraries(rocfuzz_llama_pr13155_runner PRIVATE
    ${rocfuzz_pr13155_ggml_target}
)
