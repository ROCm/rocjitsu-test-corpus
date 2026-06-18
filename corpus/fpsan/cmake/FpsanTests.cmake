set(FPSAN_TESTS_THIRD_PARTY_DIR
    "${CMAKE_CURRENT_LIST_DIR}/../third_party"
    CACHE PATH "FPSan tests third-party source directory")

set(FPSAN_TESTS_INCLUDE_DIR
    "${FPSAN_TESTS_THIRD_PARTY_DIR}/hip-fpsan/include"
    CACHE PATH "Vendored hip-fpsan include directory")

set(FPSAN_TESTS_SUPPORT_INCLUDE_DIR
    "${CMAKE_CURRENT_LIST_DIR}/../support"
    CACHE PATH "FPSan test support include directory")

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

macro(fpsan_enable_hip_tests)
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
endmacro()

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
