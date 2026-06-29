cmake_minimum_required(VERSION 3.28)

project(rocfuzz_llama_noncont_batched_matmul_hazard_variant LANGUAGES C CXX)

set(ROCFUZZ_NONCONT_GGML_ROOT "" CACHE PATH "Exact GGML overlay source tree")
set(ROCFUZZ_NONCONT_RUNNER_SOURCE "" CACHE FILEPATH "PR #13155 runner source")
set(ROCM_PATH "" CACHE PATH "ROCm SDK root")
set(ROCFUZZ_NONCONT_AMDGCN_WAVEFRONT_SIZE "32" CACHE STRING
    "Compatibility definition for older GGML HIP sources that expect __AMDGCN_WAVEFRONT_SIZE")

if(NOT ROCFUZZ_NONCONT_GGML_ROOT)
    message(FATAL_ERROR "ROCFUZZ_NONCONT_GGML_ROOT is required")
endif()
if(NOT ROCFUZZ_NONCONT_RUNNER_SOURCE)
    message(FATAL_ERROR "ROCFUZZ_NONCONT_RUNNER_SOURCE is required")
endif()

if(ROCM_PATH)
    list(APPEND CMAKE_PREFIX_PATH "${ROCM_PATH}")
    list(APPEND CMAKE_PREFIX_PATH "${ROCM_PATH}/lib/cmake")
    list(APPEND CMAKE_PREFIX_PATH "${ROCM_PATH}/lib64/cmake")
endif()

set(GGML_HIP ON CACHE BOOL "ggml: use HIP" FORCE)
set(GGML_CUDA OFF CACHE BOOL "ggml: use CUDA" FORCE)
set(GGML_CUDA_FA OFF CACHE BOOL "ggml: compile ggml FlashAttention CUDA kernels" FORCE)
set(GGML_HIP_MMQ_MFMA OFF CACHE BOOL "ggml: enable MFMA MMA for CDNA in MMQ" FORCE)
set(GGML_HIP_RCCL OFF CACHE BOOL "ggml: use ROCm Collective Comm. Library" FORCE)

add_subdirectory("${ROCFUZZ_NONCONT_GGML_ROOT}" "${CMAKE_BINARY_DIR}/ggml")

if(TARGET ggml-hip)
    target_compile_definitions(ggml-hip PRIVATE
        __AMDGCN_WAVEFRONT_SIZE=${ROCFUZZ_NONCONT_AMDGCN_WAVEFRONT_SIZE}
    )
endif()

add_executable(rocfuzz_llama_noncont_batched_matmul_hazard_runner
    "${ROCFUZZ_NONCONT_RUNNER_SOURCE}"
)
target_compile_features(rocfuzz_llama_noncont_batched_matmul_hazard_runner PRIVATE cxx_std_17)
target_include_directories(rocfuzz_llama_noncont_batched_matmul_hazard_runner PRIVATE
    "${ROCFUZZ_NONCONT_GGML_ROOT}/include"
)
if(TARGET ggml::ggml)
    set(rocfuzz_noncont_ggml_target ggml::ggml)
else()
    set(rocfuzz_noncont_ggml_target ggml)
endif()
target_link_libraries(rocfuzz_llama_noncont_batched_matmul_hazard_runner PRIVATE
    ${rocfuzz_noncont_ggml_target}
)
