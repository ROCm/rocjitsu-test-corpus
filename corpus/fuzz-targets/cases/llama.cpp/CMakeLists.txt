set(LLAMA_CPP_ROOT "${PROJECT_SOURCE_DIR}/third_party/llama.cpp")
set(LLAMA_GGML_ROOT "${LLAMA_CPP_ROOT}/ggml")

set(GGML_HIP ON CACHE BOOL "ggml: use HIP" FORCE)
set(GGML_CUDA OFF CACHE BOOL "ggml: use CUDA" FORCE)
set(GGML_CUDA_FA OFF CACHE BOOL "ggml: compile ggml FlashAttention CUDA kernels" FORCE)
set(GGML_HIP_MMQ_MFMA OFF CACHE BOOL "ggml: enable MFMA MMA for CDNA in MMQ" FORCE)
set(GGML_HIP_RCCL OFF CACHE BOOL "ggml: use ROCm Collective Comm. Library" FORCE)
add_subdirectory("${LLAMA_GGML_ROOT}" "${CMAKE_BINARY_DIR}/third_party/llama.cpp/ggml")

function(add_llama_cpp_runner target_name case_name run_target_name run_comment)
    add_executable(${target_name}
        "${CMAKE_CURRENT_SOURCE_DIR}/${case_name}/runner.cpp"
    )
    target_compile_features(${target_name} PRIVATE cxx_std_17)
    target_link_libraries(${target_name} PRIVATE
        ggml::ggml
    )

    add_custom_target(${run_target_name}
        COMMAND ${target_name}
        DEPENDS ${target_name}
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
        COMMENT "${run_comment}"
        VERBATIM
    )
endfunction()

add_llama_cpp_runner(
    llama_cpp_mul_mat_vec_q
    mul_mat_vec_q
    run_llama_mul_mat_vec_q
    "Run llama.cpp high-level GGML quantized matvec harness"
)
add_llama_cpp_runner(
    llama_cpp_rms_norm
    rms_norm
    run_llama_rms_norm
    "Run llama.cpp high-level GGML RMS norm harness"
)

set(llama_noncont_targets)
set(llama_noncont_case_dir "${CMAKE_CURRENT_SOURCE_DIR}/noncont_batched_matmul")
set(llama_noncont_hazard_case_dir "${CMAKE_CURRENT_SOURCE_DIR}/noncont_batched_matmul_hazard")

add_executable(llama_cpp_noncont_batched_matmul
    "${llama_noncont_case_dir}/runner.cpp"
)
target_compile_features(llama_cpp_noncont_batched_matmul PRIVATE cxx_std_17)
target_include_directories(llama_cpp_noncont_batched_matmul PRIVATE
    "${LLAMA_GGML_ROOT}/include"
)
target_link_libraries(llama_cpp_noncont_batched_matmul PRIVATE
    ggml::ggml
)
list(APPEND llama_noncont_targets llama_cpp_noncont_batched_matmul)

set(llama_noncont_hazard_target llama_cpp_noncont_batched_matmul_hazard)
set(llama_noncont_hazard_overlay_root "${CMAKE_BINARY_DIR}/generated/llama_noncont_batched_matmul/hazard_from_vendored/ggml")
set(llama_noncont_hazard_overlay_stamp "${llama_noncont_hazard_overlay_root}/.rocfuzz-overlay-stamp")
set(llama_noncont_hazard_build_dir "${CMAKE_BINARY_DIR}/cases/llama.cpp/${llama_noncont_hazard_target}-build")
set(llama_noncont_hazard_override_root "${llama_noncont_hazard_case_dir}/overrides")

add_custom_command(
    OUTPUT "${llama_noncont_hazard_overlay_stamp}"
    COMMAND
        ${CMAKE_COMMAND}
        -DROCFUZZ_VENDOR_ROOT=${LLAMA_GGML_ROOT}
        -DROCFUZZ_OUTPUT_ROOT=${llama_noncont_hazard_overlay_root}
        -DROCFUZZ_STAMP_FILE=${llama_noncont_hazard_overlay_stamp}
        -DROCFUZZ_OVERRIDE_ROOT=${llama_noncont_hazard_override_root}
        -P "${llama_noncont_hazard_case_dir}/cmake/CreateVendoredOverrideOverlay.cmake"
    DEPENDS
        "${llama_noncont_hazard_case_dir}/cmake/CreateVendoredOverrideOverlay.cmake"
        "${llama_noncont_hazard_override_root}/src/ggml-cuda/ggml-cuda.cu"
    COMMENT "Materialize non-contiguous batched matmul hazard GGML overlay from vendored GGML plus override files"
    VERBATIM
)

add_custom_target(${llama_noncont_hazard_target}_overlay
    DEPENDS "${llama_noncont_hazard_overlay_stamp}"
)

set(configure_env)
if(ROCFUZZ_THEROCK_ROCM_PATH)
    list(APPEND configure_env "ROCM_PATH=${ROCFUZZ_THEROCK_ROCM_PATH}")
endif()

set(configure_args
    -S "${llama_noncont_hazard_case_dir}/cmake"
    -B "${llama_noncont_hazard_build_dir}"
    -G "${CMAKE_GENERATOR}"
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_HIP_ARCHITECTURES=${CMAKE_HIP_ARCHITECTURES}
    -DROCFUZZ_NONCONT_GGML_ROOT=${llama_noncont_hazard_overlay_root}
    -DROCFUZZ_NONCONT_RUNNER_SOURCE=${llama_noncont_hazard_case_dir}/runner.cpp
    -DROCFUZZ_THEROCK_ROCM_PATH=${ROCFUZZ_THEROCK_ROCM_PATH}
)
if(CMAKE_MAKE_PROGRAM)
    list(APPEND configure_args -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM})
endif()
if(CMAKE_C_COMPILER)
    list(APPEND configure_args -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER})
endif()
if(CMAKE_CXX_COMPILER)
    list(APPEND configure_args -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER})
endif()
if(CMAKE_HIP_COMPILER)
    list(APPEND configure_args -DCMAKE_HIP_COMPILER=${CMAKE_HIP_COMPILER})
endif()

add_custom_target(${llama_noncont_hazard_target}
    COMMAND ${CMAKE_COMMAND} -E env ${configure_env} ${CMAKE_COMMAND} ${configure_args}
    COMMAND ${CMAKE_COMMAND} --build "${llama_noncont_hazard_build_dir}" --target rocfuzz_llama_noncont_batched_matmul_hazard_runner
    DEPENDS ${llama_noncont_hazard_target}_overlay
    COMMENT "Build llama.cpp non-contiguous batched matmul hazard backend from vendored GGML plus override files"
    VERBATIM
)
list(APPEND llama_noncont_targets ${llama_noncont_hazard_target})

add_custom_target(llama_cpp_kernels ALL
    DEPENDS llama_cpp_mul_mat_vec_q llama_cpp_rms_norm ${llama_noncont_targets}
    COMMENT "Build runnable llama.cpp high-level GGML HIP/CUDA harnesses"
)
