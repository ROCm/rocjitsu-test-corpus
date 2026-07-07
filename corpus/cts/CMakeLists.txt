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

enable_testing()

set(FPSAN_TESTS_THIRD_PARTY_DIR "${CMAKE_CURRENT_LIST_DIR}/third_party")

set(FPSAN_TESTS_INCLUDE_DIR "${FPSAN_TESTS_THIRD_PARTY_DIR}/hip-fpsan/include")

set(FPSAN_TESTS_SUPPORT_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/support")

if(NOT EXISTS "${FPSAN_TESTS_INCLUDE_DIR}/fpsan/fpsan.hpp")
    message(FATAL_ERROR
        "Expected vendored hip-fpsan headers at ${FPSAN_TESTS_INCLUDE_DIR}")
endif()

set(FPSAN_TESTS_HAS_GFX1250 OFF)
set(FPSAN_TESTS_HAS_CDNA4 OFF)
set(FPSAN_TESTS_HAS_CDNA3 OFF)
set(FPSAN_TESTS_HAS_RDNA4 OFF)
set(FPSAN_TESTS_HAS_RDNA3 OFF)
set(FPSAN_TESTS_HAS_GFX12 OFF)

foreach(hip_arch IN LISTS CMAKE_HIP_ARCHITECTURES)
    if(hip_arch MATCHES "^gfx125")
        set(FPSAN_TESTS_HAS_GFX1250 ON)
    endif()
    if(hip_arch MATCHES "^gfx11")
        set(FPSAN_TESTS_HAS_RDNA3 ON)
    endif()
    if(hip_arch MATCHES "^gfx12")
        set(FPSAN_TESTS_HAS_GFX12 ON)
    endif()
    if(hip_arch STREQUAL "gfx950")
        set(FPSAN_TESTS_HAS_CDNA4 ON)
    endif()
    if(hip_arch MATCHES "^gfx94[0-2]$")
        set(FPSAN_TESTS_HAS_CDNA3 ON)
    endif()
    if(hip_arch MATCHES "^gfx120")
        set(FPSAN_TESTS_HAS_RDNA4 ON)
    endif()
endforeach()

function(fpsan_add_cxx_test target_name source)
    add_executable(${target_name} "${source}")
    target_compile_features(${target_name} PRIVATE cxx_std_17)
    target_include_directories(${target_name} PRIVATE
        "${FPSAN_TESTS_INCLUDE_DIR}"
        "${FPSAN_TESTS_SUPPORT_INCLUDE_DIR}"
    )
    add_test(NAME ${target_name} COMMAND ${target_name})
endfunction()

function(fpsan_add_compile_fail_test target_name source)
    add_executable(${target_name} EXCLUDE_FROM_ALL "${source}")
    target_compile_features(${target_name} PRIVATE cxx_std_17)
    target_include_directories(${target_name} PRIVATE
        "${FPSAN_TESTS_INCLUDE_DIR}"
        "${FPSAN_TESTS_SUPPORT_INCLUDE_DIR}"
    )
    set_target_properties(${target_name} PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD TRUE)
    add_test(NAME ${target_name}
        COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_BINARY_DIR}" --target ${target_name})
    set_tests_properties(${target_name} PROPERTIES WILL_FAIL TRUE)
endfunction()

function(fpsan_add_hip_test target_name source)
    add_executable(${target_name} "${source}")
    set_source_files_properties("${source}" PROPERTIES LANGUAGE HIP)
    target_compile_features(${target_name} PRIVATE cxx_std_17)
    set_target_properties(${target_name} PROPERTIES
        HIP_STANDARD 17
        HIP_STANDARD_REQUIRED ON
        HIP_EXTENSIONS ON
    )
    target_include_directories(${target_name} PRIVATE
        "${FPSAN_TESTS_INCLUDE_DIR}"
        "${FPSAN_TESTS_SUPPORT_INCLUDE_DIR}"
    )
    target_link_libraries(${target_name} PRIVATE hip::device)
    add_test(NAME ${target_name} COMMAND ${target_name})
endfunction()

function(fpsan_add_hip_codegen_test target_name source)
    add_library(${target_name} OBJECT EXCLUDE_FROM_ALL "${source}")
    set_source_files_properties("${source}" PROPERTIES LANGUAGE HIP)
    target_compile_features(${target_name} PRIVATE cxx_std_17)
    set_target_properties(${target_name} PROPERTIES
        HIP_STANDARD 17
        HIP_STANDARD_REQUIRED ON
        HIP_EXTENSIONS ON
        EXCLUDE_FROM_DEFAULT_BUILD TRUE
    )
    target_include_directories(${target_name} PRIVATE
        "${FPSAN_TESTS_INCLUDE_DIR}"
        "${FPSAN_TESTS_SUPPORT_INCLUDE_DIR}"
    )
    target_link_libraries(${target_name} PRIVATE hip::device)
    add_test(NAME ${target_name}
        COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_BINARY_DIR}" --target ${target_name})
endfunction()

function(fpsan_enable_wave64 target_name)
    target_compile_definitions(${target_name} PRIVATE FPSAN_TEST_FORCE_WAVE_SIZE=64)
    target_compile_options(${target_name} PRIVATE
        $<$<COMPILE_LANGUAGE:HIP>:-mwavefrontsize64>)
endfunction()

set(FPSAN_TEST_CASES_DIR "${CMAKE_CURRENT_LIST_DIR}/test_cases")

# Compile-fail tests.
fpsan_add_compile_fail_test(fpsan_neg_cross_mode
    "${FPSAN_TEST_CASES_DIR}/compile_fail/neg_cross_mode.cpp")
fpsan_add_compile_fail_test(fpsan_neg_explicit_ctor
    "${FPSAN_TEST_CASES_DIR}/compile_fail/neg_explicit_ctor.cpp")
fpsan_add_compile_fail_test(fpsan_neg_explicit_mixed_pod
    "${FPSAN_TEST_CASES_DIR}/compile_fail/neg_explicit_mixed_pod.cpp")
fpsan_add_compile_fail_test(fpsan_neg_non_float_type
    "${FPSAN_TEST_CASES_DIR}/compile_fail/neg_non_float_type.cpp")

# Tests shared across supported GPU families.
fpsan_add_cxx_test(fpsan_build_canary
    "${FPSAN_TEST_CASES_DIR}/general/build_canary.cpp")
fpsan_add_cxx_test(fpsan_cast_test
    "${FPSAN_TEST_CASES_DIR}/general/cast_test.cpp")
fpsan_add_cxx_test(fpsan_core_test
    "${FPSAN_TEST_CASES_DIR}/general/core_test.cpp")
fpsan_add_cxx_test(fpsan_drop_in_test
    "${FPSAN_TEST_CASES_DIR}/general/drop_in_test.cpp")
fpsan_add_cxx_test(fpsan_fp8_test
    "${FPSAN_TEST_CASES_DIR}/general/fp8_test.cpp")
fpsan_add_cxx_test(fpsan_math_test
    "${FPSAN_TEST_CASES_DIR}/general/math_test.cpp")
fpsan_add_cxx_test(fpsan_parity_test
    "${FPSAN_TEST_CASES_DIR}/general/parity_test.cpp")
fpsan_add_cxx_test(fpsan_algebraic_proto_test
    "${FPSAN_TEST_CASES_DIR}/general/algebraic_proto_test.cpp")
fpsan_add_hip_test(fpsan_algebraic_value_test
    "${FPSAN_TEST_CASES_DIR}/general/algebraic_value_test.cpp")
fpsan_add_hip_test(fpsan_vector_test
    "${FPSAN_TEST_CASES_DIR}/general/vector_test.cpp")
fpsan_add_hip_test(fpsan_extern_tagged_test
    "${FPSAN_TEST_CASES_DIR}/general/extern_tagged_test.cpp")
fpsan_add_hip_test(fpsan_subbyte_widen_test
    "${FPSAN_TEST_CASES_DIR}/general/subbyte_widen_test.cpp")
fpsan_add_hip_test(fpsan_atomic_test
    "${FPSAN_TEST_CASES_DIR}/general/atomic_test.cpp")
fpsan_add_hip_test(fpsan_classify_test
    "${FPSAN_TEST_CASES_DIR}/general/classify_test.cpp")
fpsan_add_hip_test(fpsan_hip_device_test
    "${FPSAN_TEST_CASES_DIR}/general/hip_device_test.cpp")

if(FPSAN_TESTS_HAS_RDNA3 OR FPSAN_TESTS_HAS_GFX12 OR FPSAN_TESTS_HAS_CDNA3)
    fpsan_add_hip_test(fpsan_cvt_test
        "${FPSAN_TEST_CASES_DIR}/general/cvt_test.cpp")
endif()
if(FPSAN_TESTS_HAS_GFX12 OR FPSAN_TESTS_HAS_CDNA3)
    fpsan_add_hip_test(fpsan_cvt_fp8_test
        "${FPSAN_TEST_CASES_DIR}/general/cvt_fp8_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_fp8_pk_test
        "${FPSAN_TEST_CASES_DIR}/general/cvt_fp8_pk_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_fp8_pack_test
        "${FPSAN_TEST_CASES_DIR}/general/cvt_fp8_pack_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_fp8_sr_test
        "${FPSAN_TEST_CASES_DIR}/general/cvt_fp8_sr_test.cpp")
endif()
if(FPSAN_TESTS_HAS_RDNA3 OR FPSAN_TESTS_HAS_GFX12)
    fpsan_add_hip_test(fpsan_xlane_test
        "${FPSAN_TEST_CASES_DIR}/general/xlane_test.cpp")
endif()
if(FPSAN_TESTS_HAS_GFX12)
    fpsan_add_hip_test(fpsan_global_load_tr_test
        "${FPSAN_TEST_CASES_DIR}/general/global_load_tr_test.cpp")
endif()
if(FPSAN_TESTS_HAS_RDNA3 OR FPSAN_TESTS_HAS_GFX12 OR
    FPSAN_TESTS_HAS_CDNA3 OR FPSAN_TESTS_HAS_CDNA4)
    fpsan_add_hip_test(fpsan_wave_test
        "${FPSAN_TEST_CASES_DIR}/general/wave_test.cpp")
    fpsan_add_hip_test(fpsan_amdgcn_ldexp_test
        "${FPSAN_TEST_CASES_DIR}/general/amdgcn_ldexp_test.cpp")
    fpsan_add_hip_test(fpsan_amdgcn_math_test
        "${FPSAN_TEST_CASES_DIR}/general/amdgcn_math_test.cpp")
    if(FPSAN_TESTS_HAS_RDNA3 OR FPSAN_TESTS_HAS_RDNA4 OR FPSAN_TESTS_HAS_CDNA3)
        target_compile_definitions(fpsan_amdgcn_math_test
            PRIVATE FPSAN_TEST_ENABLE_FDOT2=1)
    endif()
    if(FPSAN_TESTS_HAS_RDNA3 OR FPSAN_TESTS_HAS_RDNA4)
        target_compile_definitions(fpsan_amdgcn_math_test
            PRIVATE FPSAN_TEST_ENABLE_FDOT2_EXTENDED=1)
    endif()
    if(FPSAN_TESTS_HAS_RDNA4)
        target_compile_definitions(fpsan_amdgcn_math_test
            PRIVATE FPSAN_TEST_ENABLE_GFX12_DOT_MATH=1)
    endif()
    fpsan_add_hip_test(fpsan_amdgcn_math_extra_test
        "${FPSAN_TEST_CASES_DIR}/general/amdgcn_math_extra_test.cpp")
    if(FPSAN_TESTS_HAS_RDNA3 OR FPSAN_TESTS_HAS_RDNA4 OR FPSAN_TESTS_HAS_CDNA3)
        fpsan_add_hip_test(fpsan_amdgcn_math_fdot2_test
            "${FPSAN_TEST_CASES_DIR}/general/amdgcn_math_fdot2_test.cpp")
        target_compile_definitions(fpsan_amdgcn_math_fdot2_test
            PRIVATE FPSAN_TEST_ENABLE_FDOT2=1)
        if(FPSAN_TESTS_HAS_RDNA3 OR FPSAN_TESTS_HAS_RDNA4)
            target_compile_definitions(fpsan_amdgcn_math_fdot2_test
                PRIVATE FPSAN_TEST_ENABLE_FDOT2_EXTENDED=1)
        endif()
    endif()
    if(FPSAN_TESTS_HAS_RDNA4)
        fpsan_add_hip_test(fpsan_amdgcn_math_dot4_test
            "${FPSAN_TEST_CASES_DIR}/general/amdgcn_math_dot4_test.cpp")
        target_compile_definitions(fpsan_amdgcn_math_dot4_test
            PRIVATE FPSAN_TEST_ENABLE_GFX12_DOT_MATH=1)
    endif()
endif()

if(FPSAN_TESTS_HAS_RDNA3)
    fpsan_add_hip_test(fpsan_wmma_gfx11_test
        "${FPSAN_TEST_CASES_DIR}/rdna3/wmma_gfx11_test.cpp")
    fpsan_add_hip_test(fpsan_wmma_gfx11_acc16_test
        "${FPSAN_TEST_CASES_DIR}/rdna3/wmma_gfx11_acc16_test.cpp")
    fpsan_add_hip_test(fpsan_wmma_gfx11_tied_test
        "${FPSAN_TEST_CASES_DIR}/rdna3/wmma_gfx11_tied_test.cpp")
    fpsan_add_hip_test(fpsan_wmma_gfx11_tied_bf16_test
        "${FPSAN_TEST_CASES_DIR}/rdna3/wmma_gfx11_tied_bf16_test.cpp")

    fpsan_add_hip_test(fpsan_wmma_gfx11_w64_test
        "${FPSAN_TEST_CASES_DIR}/rdna3/wmma_gfx11_test.cpp")
    target_compile_definitions(fpsan_wmma_gfx11_w64_test
        PRIVATE FPSAN_TEST_GFX11_WAVE64=1)
    fpsan_enable_wave64(fpsan_wmma_gfx11_w64_test)

    fpsan_add_hip_test(fpsan_wmma_gfx11_acc16_w64_test
        "${FPSAN_TEST_CASES_DIR}/rdna3/wmma_gfx11_acc16_test.cpp")
    target_compile_definitions(fpsan_wmma_gfx11_acc16_w64_test
        PRIVATE FPSAN_TEST_GFX11_WAVE64=1)
    fpsan_enable_wave64(fpsan_wmma_gfx11_acc16_w64_test)

    fpsan_add_hip_test(fpsan_wmma_gfx11_tied_w64_test
        "${FPSAN_TEST_CASES_DIR}/rdna3/wmma_gfx11_tied_test.cpp")
    target_compile_definitions(fpsan_wmma_gfx11_tied_w64_test
        PRIVATE FPSAN_TEST_GFX11_WAVE64=1)
    fpsan_enable_wave64(fpsan_wmma_gfx11_tied_w64_test)

    fpsan_add_hip_test(fpsan_wmma_gfx11_tied_bf16_w64_test
        "${FPSAN_TEST_CASES_DIR}/rdna3/wmma_gfx11_tied_bf16_test.cpp")
    target_compile_definitions(fpsan_wmma_gfx11_tied_bf16_w64_test
        PRIVATE FPSAN_TEST_GFX11_WAVE64=1)
    fpsan_enable_wave64(fpsan_wmma_gfx11_tied_bf16_w64_test)

    fpsan_add_hip_test(fpsan_xlane_w64_test
        "${FPSAN_TEST_CASES_DIR}/general/xlane_test.cpp")
    fpsan_enable_wave64(fpsan_xlane_w64_test)

    fpsan_add_hip_test(fpsan_classify_w64_test
        "${FPSAN_TEST_CASES_DIR}/general/classify_test.cpp")
    fpsan_enable_wave64(fpsan_classify_w64_test)

    fpsan_add_hip_test(fpsan_wave_gfx11_w64_test
        "${FPSAN_TEST_CASES_DIR}/general/wave_test.cpp")
    target_compile_definitions(fpsan_wave_gfx11_w64_test
        PRIVATE
            FPSAN_TEST_ENABLE_WAVE_F64=1
            FPSAN_TEST_SKIP_FLOAT_WAVE_REDUCE=1)
    fpsan_enable_wave64(fpsan_wave_gfx11_w64_test)
endif()

if(FPSAN_TESTS_HAS_GFX1250)
    fpsan_add_hip_test(fpsan_amdgcn_bf16_trans_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/amdgcn_bf16_trans_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_f16_fp8_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/cvt_f16_fp8_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_scalef32_pk_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/cvt_scalef32_pk_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_scale_unpack_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/cvt_scale_unpack_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_fp8_e5m3_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/cvt_fp8_e5m3_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_sr_pack_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/cvt_sr_pack_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_sr_pk_f16_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/cvt_sr_pk_f16_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_load_tr16_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/load_tr16_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_wmma_16x16x4_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/wmma_16x16x4_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_wmma_16x16x32_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/wmma_16x16x32_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_wmma_16x16x64_fp8_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/wmma_16x16x64_fp8_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_wmma_16x16x128_fp8_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/wmma_16x16x128_fp8_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_wmma_16x16x128_f8f6f4_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/wmma_16x16x128_f8f6f4_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_wmma_32x16x128_f4_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/wmma_32x16x128_f4_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_wmma_scale_f8f6f4_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/wmma_scale_f8f6f4_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_swmmac_16x16x128_fp8_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/swmmac_16x16x128_fp8_gfx1250_test.cpp")
    fpsan_add_hip_test(fpsan_swmmac_16x16x64_16_gfx1250_test
        "${FPSAN_TEST_CASES_DIR}/gfx1250/swmmac_16x16x64_16_gfx1250_test.cpp")
endif()

if(FPSAN_TESTS_HAS_CDNA4)
    fpsan_add_hip_test(fpsan_mfma_gfx950_test
        "${FPSAN_TEST_CASES_DIR}/cdna4/mfma_gfx950_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_gfx950_scaled_test
        "${FPSAN_TEST_CASES_DIR}/cdna4/mfma_gfx950_scaled_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_gfx950_smfmac_test
        "${FPSAN_TEST_CASES_DIR}/cdna4/mfma_gfx950_smfmac_test.cpp")
    fpsan_add_hip_test(fpsan_ds_read_tr_test
        "${FPSAN_TEST_CASES_DIR}/cdna4/ds_read_tr_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_gfx950_test
        "${FPSAN_TEST_CASES_DIR}/cdna4/cvt_gfx950_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_scalef32_mx_gfx950_test
        "${FPSAN_TEST_CASES_DIR}/cdna4/cvt_scalef32_mx_gfx950_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_scalef32_fp4_gfx950_test
        "${FPSAN_TEST_CASES_DIR}/cdna4/cvt_scalef32_fp4_gfx950_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_scalef32_fp6_gfx950_test
        "${FPSAN_TEST_CASES_DIR}/cdna4/cvt_scalef32_fp6_gfx950_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_scalef32_fp8vec_gfx950_test
        "${FPSAN_TEST_CASES_DIR}/cdna4/cvt_scalef32_fp8vec_gfx950_test.cpp")
    fpsan_add_hip_test(fpsan_cvt_scalef32_sr_gfx950_test
        "${FPSAN_TEST_CASES_DIR}/cdna4/cvt_scalef32_sr_gfx950_test.cpp")

    fpsan_add_hip_test(fpsan_xlane_gfx950_test
        "${FPSAN_TEST_CASES_DIR}/general/xlane_test.cpp")
    target_compile_definitions(fpsan_xlane_gfx950_test
        PRIVATE FPSAN_TEST_FORCE_WAVE_SIZE=64)
endif()

if(FPSAN_TESTS_HAS_CDNA3)
    fpsan_add_hip_test(fpsan_mfma_cdna3_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_f16_16x16x4_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_f16_16x16x4_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_f16_wide_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_f16_wide_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_f16_32x32x4_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_f16_32x32x4_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_f16_4x4x4_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_f16_4x4x4_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_bf16_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_bf16_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_bf16_16x16x4_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_bf16_16x16x4_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_bf16_wide_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_bf16_wide_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_bf16_32x32x4_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_bf16_32x32x4_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_bf16_4x4x4_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_bf16_4x4x4_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_fp8_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_fp8_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_fp8_16x16x32_bf8_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_fp8_16x16x32_bf8_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_fp8_32x32x16_fp8_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_fp8_32x32x16_fp8_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_fp8_32x32x16_bf8_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_fp8_32x32x16_bf8_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_xf32_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_xf32_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_f32_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_f32_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_f32_32x32_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_f32_32x32_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_f32_4x4_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_f32_4x4_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_f64_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_f64_test.cpp")
    fpsan_add_hip_test(fpsan_mfma_cdna3_f64_4x4_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/mfma_cdna3_f64_4x4_test.cpp")
    fpsan_add_hip_test(fpsan_smfmac_cdna3_test
        "${FPSAN_TEST_CASES_DIR}/cdna3/smfmac_cdna3_test.cpp")
endif()

if(FPSAN_TESTS_HAS_RDNA4)
    fpsan_add_hip_test(fpsan_global_load_tr_gfx12_w64_test
        "${FPSAN_TEST_CASES_DIR}/general/global_load_tr_test.cpp")
    target_compile_definitions(fpsan_global_load_tr_gfx12_w64_test
        PRIVATE
            FPSAN_TEST_GLOBAL_LOAD_TR_W64=1
            FPSAN_TEST_FORCE_WAVE_SIZE=64)
    fpsan_enable_wave64(fpsan_global_load_tr_gfx12_w64_test)

    fpsan_add_hip_test(fpsan_wmma_gfx12_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/wmma_gfx12_test.cpp")
    fpsan_add_hip_test(fpsan_wmma_gfx12_acc16_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/wmma_gfx12_acc16_test.cpp")
    fpsan_add_hip_test(fpsan_wmma_gfx12_fp8_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/wmma_gfx12_fp8_test.cpp")
    fpsan_add_hip_test(fpsan_wmma_gfx12_fp8_bf8_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/wmma_gfx12_fp8_bf8_test.cpp")
    fpsan_add_hip_test(fpsan_wmma_gfx12_fp8_mixed_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/wmma_gfx12_fp8_mixed_test.cpp")

    fpsan_add_hip_test(fpsan_wmma_gfx12_w64_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/wmma_gfx12_test.cpp")
    target_compile_definitions(fpsan_wmma_gfx12_w64_test
        PRIVATE
            FPSAN_TEST_GFX12_WAVE64=1
            FPSAN_TEST_FORCE_WAVE_SIZE=64)
    fpsan_enable_wave64(fpsan_wmma_gfx12_w64_test)

    fpsan_add_hip_test(fpsan_wmma_gfx12_acc16_w64_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/wmma_gfx12_acc16_test.cpp")
    target_compile_definitions(fpsan_wmma_gfx12_acc16_w64_test
        PRIVATE
            FPSAN_TEST_GFX12_WAVE64=1
            FPSAN_TEST_FORCE_WAVE_SIZE=64)
    fpsan_enable_wave64(fpsan_wmma_gfx12_acc16_w64_test)

    fpsan_add_hip_test(fpsan_wmma_gfx12_w64_fp8_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/wmma_gfx12_fp8_test.cpp")
    target_compile_definitions(fpsan_wmma_gfx12_w64_fp8_test
        PRIVATE
            FPSAN_TEST_GFX12_WAVE64=1
            FPSAN_TEST_FORCE_WAVE_SIZE=64)
    fpsan_enable_wave64(fpsan_wmma_gfx12_w64_fp8_test)

    fpsan_add_hip_test(fpsan_wmma_gfx12_w64_fp8_bf8_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/wmma_gfx12_fp8_bf8_test.cpp")
    target_compile_definitions(fpsan_wmma_gfx12_w64_fp8_bf8_test
        PRIVATE
            FPSAN_TEST_GFX12_WAVE64=1
            FPSAN_TEST_FORCE_WAVE_SIZE=64)
    fpsan_enable_wave64(fpsan_wmma_gfx12_w64_fp8_bf8_test)

    fpsan_add_hip_test(fpsan_wmma_gfx12_w64_fp8_mixed_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/wmma_gfx12_fp8_mixed_test.cpp")
    target_compile_definitions(fpsan_wmma_gfx12_w64_fp8_mixed_test
        PRIVATE
            FPSAN_TEST_GFX12_WAVE64=1
            FPSAN_TEST_FORCE_WAVE_SIZE=64)
    fpsan_enable_wave64(fpsan_wmma_gfx12_w64_fp8_mixed_test)

    fpsan_add_hip_test(fpsan_swmmac_gfx12_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/swmmac_gfx12_test.cpp")
    fpsan_add_hip_test(fpsan_swmmac_gfx12_h_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/swmmac_gfx12_h_test.cpp")
    fpsan_add_hip_test(fpsan_swmmac_gfx12_h_bf16_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/swmmac_gfx12_h_bf16_test.cpp")
    fpsan_add_hip_test(fpsan_swmmac_gfx12_h_f16out_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/swmmac_gfx12_h_f16out_test.cpp")
    fpsan_add_hip_test(fpsan_swmmac_gfx12_fp8_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/swmmac_gfx12_fp8_test.cpp")
    fpsan_add_hip_test(fpsan_swmmac_gfx12_fp8_mixed_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/swmmac_gfx12_fp8_mixed_test.cpp")

    fpsan_add_hip_test(fpsan_swmmac_gfx12_w64_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/swmmac_gfx12_w64_test.cpp")
    target_compile_definitions(fpsan_swmmac_gfx12_w64_test
        PRIVATE FPSAN_TEST_FORCE_WAVE_SIZE=64)
    fpsan_enable_wave64(fpsan_swmmac_gfx12_w64_test)

    fpsan_add_hip_test(fpsan_swmmac_gfx12_w64_16_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/swmmac_gfx12_w64_16_test.cpp")
    fpsan_enable_wave64(fpsan_swmmac_gfx12_w64_16_test)

    fpsan_add_hip_test(fpsan_swmmac_gfx12_w64_fp8_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/swmmac_gfx12_w64_fp8_test.cpp")
    fpsan_enable_wave64(fpsan_swmmac_gfx12_w64_fp8_test)

    fpsan_add_hip_test(fpsan_swmmac_gfx12_w64_fp8_bf8_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/swmmac_gfx12_w64_fp8_bf8_test.cpp")
    fpsan_enable_wave64(fpsan_swmmac_gfx12_w64_fp8_bf8_test)

    fpsan_add_hip_test(fpsan_swmmac_gfx12_w64_fp8_mixed_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/swmmac_gfx12_w64_fp8_mixed_test.cpp")
    fpsan_enable_wave64(fpsan_swmmac_gfx12_w64_fp8_mixed_test)

    fpsan_add_hip_test(fpsan_swmmac_gfx12_w64_fp8_bf8bf8_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/swmmac_gfx12_w64_fp8_bf8bf8_test.cpp")
    fpsan_enable_wave64(fpsan_swmmac_gfx12_w64_fp8_bf8bf8_test)

    fpsan_add_hip_test(fpsan_xlane_gfx12_w64_test
        "${FPSAN_TEST_CASES_DIR}/general/xlane_test.cpp")
    target_compile_definitions(fpsan_xlane_gfx12_w64_test
        PRIVATE FPSAN_TEST_FORCE_WAVE_SIZE=64)
    fpsan_enable_wave64(fpsan_xlane_gfx12_w64_test)

    fpsan_add_hip_test(fpsan_classify_gfx12_w64_test
        "${FPSAN_TEST_CASES_DIR}/general/classify_test.cpp")
    target_compile_definitions(fpsan_classify_gfx12_w64_test
        PRIVATE FPSAN_TEST_FORCE_WAVE_SIZE=64)
    fpsan_enable_wave64(fpsan_classify_gfx12_w64_test)

    fpsan_add_hip_test(fpsan_wave_gfx12_w64_test
        "${FPSAN_TEST_CASES_DIR}/general/wave_test.cpp")
    target_compile_definitions(fpsan_wave_gfx12_w64_test
        PRIVATE
            FPSAN_TEST_ENABLE_WAVE_F64=1
            FPSAN_TEST_FORCE_WAVE_SIZE=64
            FPSAN_TEST_SKIP_FLOAT_WAVE_REDUCE=1)
    fpsan_enable_wave64(fpsan_wave_gfx12_w64_test)

    fpsan_add_hip_codegen_test(fpsan_algebraic_device_test
        "${FPSAN_TEST_CASES_DIR}/rdna4/algebraic_device_test.cpp")
endif()
