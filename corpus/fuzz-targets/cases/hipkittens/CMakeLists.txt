set(HIPKITTENS_ROOT "${PROJECT_SOURCE_DIR}/third_party/hipkittens")

if(NOT EXISTS "${HIPKITTENS_ROOT}/include/kittens.cuh")
    message(FATAL_ERROR
        "ROCFUZZ_ENABLE_HIPKITTENS=ON requires extracted HipKittens sources at "
        "${HIPKITTENS_ROOT}")
endif()

find_package(hip REQUIRED CONFIG)

set(hipkittens_gemm_targets)

set(hipkittens_supports_cdna3 OFF)
set(hipkittens_supports_cdna4 OFF)
foreach(hip_arch IN LISTS CMAKE_HIP_ARCHITECTURES)
    if(hip_arch STREQUAL "gfx942")
        set(hipkittens_supports_cdna3 ON)
    endif()
    if(hip_arch STREQUAL "gfx950")
        set(hipkittens_supports_cdna4 ON)
    endif()
endforeach()

if(hipkittens_supports_cdna3 OR hipkittens_supports_cdna4)
    find_package(OpenMP REQUIRED)

    if(hipkittens_supports_cdna4)
        set(hipkittens_cdna_definition KITTENS_CDNA4)
    else()
        set(hipkittens_cdna_definition KITTENS_CDNA3)
    endif()

    function(apply_case_compile_definitions target_name case_name)
        set(case_json_path "${CMAKE_CURRENT_SOURCE_DIR}/${case_name}/case.json")
        if(NOT EXISTS "${case_json_path}")
            return()
        endif()

        file(READ "${case_json_path}" case_json)
        string(JSON define_count ERROR_VARIABLE define_count_error LENGTH "${case_json}" build defines)
        if(define_count_error OR define_count EQUAL 0)
            return()
        endif()

        math(EXPR last_define_index "${define_count} - 1")
        set(case_compile_definitions)
        foreach(define_index RANGE 0 ${last_define_index})
            string(JSON define_name MEMBER "${case_json}" build defines ${define_index})
            string(JSON define_value GET "${case_json}" build defines "${define_name}")
            list(APPEND case_compile_definitions "${define_name}=${define_value}")
        endforeach()
        target_compile_definitions(${target_name} PRIVATE ${case_compile_definitions})
    endfunction()

    function(add_hipkittens_gemm_runner target_name case_name include_dir run_comment)
        set(runner_source "${CMAKE_CURRENT_SOURCE_DIR}/${case_name}/runner.hip")
        add_executable(${target_name}
            "${runner_source}"
        )
        set_source_files_properties("${runner_source}" PROPERTIES LANGUAGE HIP)
        target_compile_features(${target_name} PRIVATE cxx_std_20)
        set_target_properties(${target_name} PROPERTIES
            CXX_STANDARD 20
            CXX_STANDARD_REQUIRED ON
            CXX_EXTENSIONS OFF
            HIP_STANDARD 20
            HIP_STANDARD_REQUIRED ON
            HIP_EXTENSIONS OFF
        )
        target_compile_definitions(${target_name} PRIVATE
            ${hipkittens_cdna_definition}
        )
        apply_case_compile_definitions(${target_name} ${case_name})
        target_compile_options(${target_name} PRIVATE
            $<$<COMPILE_LANGUAGE:HIP>:-fopenmp>
            $<$<COMPILE_LANGUAGE:HIP>:-Wall>
            $<$<COMPILE_LANGUAGE:HIP>:-Wextra>
            $<$<COMPILE_LANGUAGE:HIP>:-O3>
            $<$<COMPILE_LANGUAGE:HIP>:-Rpass-analysis=kernel-resource-usage>
        )
        target_link_options(${target_name} PRIVATE
            -fopenmp
            -Wl,--allow-multiple-definition
        )
        target_include_directories(${target_name} PRIVATE
            "${include_dir}"
            "${ROCM_PATH}/include"
            "${ROCM_PATH}/include/hip"
        )
        target_link_libraries(${target_name} PRIVATE
            hip::device
            OpenMP::OpenMP_CXX
        )

        add_custom_target(run_${target_name}
            COMMAND ${target_name}
            DEPENDS ${target_name}
            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
            COMMENT "${run_comment}"
            VERBATIM
        )
        list(APPEND hipkittens_gemm_targets ${target_name})
        set(hipkittens_gemm_targets "${hipkittens_gemm_targets}" PARENT_SCOPE)
    endfunction()

    if(hipkittens_supports_cdna4)
        add_hipkittens_gemm_runner(
            hipkittens_gemm_mxfp8_4wave
            gemm_mxfp8_4wave
            "${HIPKITTENS_ROOT}/include"
            "Run HipKittens MXFP8 4-wave GEMM runner"
        )
        add_hipkittens_gemm_runner(
            hipkittens_gemm_fp8fp32_4wave
            gemm_fp8fp32_4wave
            "${HIPKITTENS_ROOT}/include"
            "Run HipKittens FP8/FP32 4-wave GEMM runner"
        )
        add_hipkittens_gemm_runner(
            hipkittens_gemm_bf16fp32_16x32
            gemm_bf16fp32_16x32
            "${HIPKITTENS_ROOT}/include"
            "Run HipKittens BF16/FP32 16x32 GEMM runner"
        )
    else()
        message(STATUS "Skipping HipKittens main-branch MXFP8/FP8/BF16 GEMM runners: vendored main-branch sources target CDNA4/gfx950")
    endif()

    if(hipkittens_supports_cdna3)
        add_hipkittens_gemm_runner(
            hipkittens_gemm_bf16fp32_cdna3_64x16
            gemm_bf16fp32_cdna3_64x16
            "${HIPKITTENS_ROOT}/cdna3/include"
            "Run HipKittens CDNA3 BF16/FP32 64x16 GEMM runner"
        )
    endif()
else()
    message(STATUS "Skipping HipKittens GEMM runners: enabled runners require CDNA3/gfx942 or CDNA4/gfx950")
endif()

add_custom_target(hipkittens_gemm_runners ALL
    DEPENDS ${hipkittens_gemm_targets}
    COMMENT "Build HipKittens GEMM runners"
)
