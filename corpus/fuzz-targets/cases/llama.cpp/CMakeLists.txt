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

set(llama_pr13155_targets)
set(llama_pr13155_case_dir "${CMAKE_CURRENT_SOURCE_DIR}/pr13155_noncont_batched_matmul")

function(add_llama_pr13155_run_target run_target dep_target runner expect_validate_pass)
    if(expect_validate_pass)
        set(expect_label "expected pass")
        set(expect_pass ON)
    else()
        set(expect_label "expected fail")
        set(expect_pass OFF)
    endif()

    add_custom_target(${run_target}
        COMMAND
            ${CMAKE_COMMAND}
            -DROCFUZZ_RUNNER=${runner}
            -DROCFUZZ_EXPECT_PASS=${expect_pass}
            -DROCFUZZ_LD_LIBRARY_PATH=${ROCFUZZ_THEROCK_ROCM_PATH}/lib:${ROCFUZZ_THEROCK_ROCM_PATH}/lib64:$ENV{LD_LIBRARY_PATH}
            -P "${llama_pr13155_case_dir}/cmake/RunExpected.cmake"
        DEPENDS ${dep_target}
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
        COMMENT "Run llama.cpp PR #13155 validation; ${expect_label}"
        VERBATIM
    )
endfunction()

add_executable(llama_cpp_pr13155_noncont_batched_matmul_fix
    "${llama_pr13155_case_dir}/runner.cpp"
)
target_compile_features(llama_cpp_pr13155_noncont_batched_matmul_fix PRIVATE cxx_std_17)
target_include_directories(llama_cpp_pr13155_noncont_batched_matmul_fix PRIVATE
    "${LLAMA_GGML_ROOT}/include"
)
target_link_libraries(llama_cpp_pr13155_noncont_batched_matmul_fix PRIVATE
    ggml::ggml
)
add_llama_pr13155_run_target(
    run_llama_cpp_pr13155_noncont_batched_matmul_fix
    llama_cpp_pr13155_noncont_batched_matmul_fix
    $<TARGET_FILE:llama_cpp_pr13155_noncont_batched_matmul_fix>
    ON
)
list(APPEND llama_pr13155_targets llama_cpp_pr13155_noncont_batched_matmul_fix)

set(llama_pr13155_bug_target llama_cpp_pr13155_noncont_batched_matmul_bug)
set(llama_pr13155_bug_overlay_root "${CMAKE_BINARY_DIR}/generated/llama_pr13155/pr13155_bug_from_vendored/ggml")
set(llama_pr13155_bug_overlay_stamp "${llama_pr13155_bug_overlay_root}/.rocfuzz-overlay-stamp")
set(llama_pr13155_bug_build_dir "${CMAKE_BINARY_DIR}/cases/llama.cpp/${llama_pr13155_bug_target}-build")
set(llama_pr13155_bug_exe "${llama_pr13155_bug_build_dir}/rocfuzz_llama_pr13155_runner")
set(llama_pr13155_bug_patch "${llama_pr13155_case_dir}/variants/pr13155_bug/patches/reintroduce_pr13155_bug.patch")

add_custom_command(
    OUTPUT "${llama_pr13155_bug_overlay_stamp}"
    COMMAND
        ${CMAKE_COMMAND}
        -DROCFUZZ_VENDOR_ROOT=${LLAMA_GGML_ROOT}
        -DROCFUZZ_OUTPUT_ROOT=${llama_pr13155_bug_overlay_root}
        -DROCFUZZ_STAMP_FILE=${llama_pr13155_bug_overlay_stamp}
        -DROCFUZZ_COPY_FILES=src/ggml-cuda/ggml-cuda.cu
        -DROCFUZZ_PATCH_FILE=${llama_pr13155_bug_patch}
        -P "${llama_pr13155_case_dir}/cmake/CreateVendoredPatchOverlay.cmake"
    DEPENDS
        "${llama_pr13155_case_dir}/cmake/CreateVendoredPatchOverlay.cmake"
        "${llama_pr13155_bug_patch}"
    COMMENT "Materialize PR #13155 bug GGML overlay from vendored GGML plus patched affected file"
    VERBATIM
)

add_custom_target(${llama_pr13155_bug_target}_overlay
    DEPENDS "${llama_pr13155_bug_overlay_stamp}"
)

set(configure_env)
if(ROCFUZZ_THEROCK_ROCM_PATH)
    list(APPEND configure_env "ROCM_PATH=${ROCFUZZ_THEROCK_ROCM_PATH}")
endif()

set(configure_args
    -S "${llama_pr13155_case_dir}/cmake"
    -B "${llama_pr13155_bug_build_dir}"
    -G "${CMAKE_GENERATOR}"
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_HIP_ARCHITECTURES=${CMAKE_HIP_ARCHITECTURES}
    -DROCFUZZ_PR13155_GGML_ROOT=${llama_pr13155_bug_overlay_root}
    -DROCFUZZ_PR13155_RUNNER_SOURCE=${llama_pr13155_case_dir}/runner.cpp
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

add_custom_target(${llama_pr13155_bug_target}
    COMMAND ${CMAKE_COMMAND} -E env ${configure_env} ${CMAKE_COMMAND} ${configure_args}
    COMMAND ${CMAKE_COMMAND} --build "${llama_pr13155_bug_build_dir}" --target rocfuzz_llama_pr13155_runner
    DEPENDS ${llama_pr13155_bug_target}_overlay
    COMMENT "Build llama.cpp PR #13155 bug backend from vendored GGML plus patched affected file"
    VERBATIM
)

add_llama_pr13155_run_target(
    run_${llama_pr13155_bug_target}
    ${llama_pr13155_bug_target}
    "${llama_pr13155_bug_exe}"
    OFF
)

add_custom_target(run_llama_pr13155_noncont_batched_matmul
    DEPENDS
        run_llama_cpp_pr13155_noncont_batched_matmul_fix
        run_${llama_pr13155_bug_target}
    COMMENT "Run llama.cpp PR #13155 fixed and bug backend validations"
)
list(APPEND llama_pr13155_targets ${llama_pr13155_bug_target})

add_custom_target(llama_cpp_kernels ALL
    DEPENDS llama_cpp_mul_mat_vec_q llama_cpp_rms_norm ${llama_pr13155_targets}
    COMMENT "Build runnable llama.cpp high-level GGML HIP/CUDA harnesses"
)
