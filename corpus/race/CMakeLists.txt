cmake_minimum_required(VERSION 3.28)

project(rocjitsu_race_tests LANGUAGES CXX)

if(NOT CMAKE_HIP_ARCHITECTURES)
    message(FATAL_ERROR
        "RocJITsu race tests require -DCMAKE_HIP_ARCHITECTURES=<gfx target>")
endif()

set(ROCM_PATH "" CACHE PATH "ROCm SDK root")
if(NOT ROCM_PATH AND DEFINED ENV{ROCM_PATH})
    set(ROCM_PATH "$ENV{ROCM_PATH}" CACHE PATH "ROCm SDK root" FORCE)
endif()
if(NOT ROCM_PATH)
    find_program(RACE_ROCM_SDK_EXECUTABLE rocm-sdk)
    if(RACE_ROCM_SDK_EXECUTABLE)
        execute_process(
            COMMAND "${RACE_ROCM_SDK_EXECUTABLE}" path --root
            RESULT_VARIABLE race_rocm_sdk_result
            OUTPUT_VARIABLE race_rocm_sdk_root
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_QUIET
        )
        if(race_rocm_sdk_result EQUAL 0 AND race_rocm_sdk_root)
            set(ROCM_PATH "${race_rocm_sdk_root}" CACHE PATH "ROCm SDK root" FORCE)
        endif()
    endif()
endif()
if(NOT ROCM_PATH OR NOT EXISTS "${ROCM_PATH}/lib/cmake/hip/hip-config.cmake")
    message(FATAL_ERROR
        "RocJITsu race tests require ROCM_PATH to point at a ROCm SDK root "
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
    find_program(RACE_HIP_COMPILER
        NAMES amdclang++
        PATHS
            "${ROCM_PATH}/lib/llvm/bin"
            "${ROCM_PATH}/bin"
            "${ROCM_PATH}/llvm/bin"
        NO_DEFAULT_PATH
    )
    if(RACE_HIP_COMPILER)
        set(CMAKE_HIP_COMPILER "${RACE_HIP_COMPILER}" CACHE FILEPATH
            "HIP compiler" FORCE)
    endif()
endif()

enable_language(HIP)
find_package(hip REQUIRED CONFIG)

find_package(GTest QUIET)
if(NOT TARGET GTest::gtest)
    include(FetchContent)
    set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG v1.15.2
        GIT_SHALLOW TRUE
    )
    FetchContent_MakeAvailable(googletest)
endif()

function(add_rocjitsu_race_test target_name source)
    add_executable(${target_name} "${source}")
    set_source_files_properties("${source}" PROPERTIES LANGUAGE HIP)
    target_compile_features(${target_name} PRIVATE cxx_std_20)
    set_target_properties(${target_name} PROPERTIES
        HIP_STANDARD 20
        HIP_STANDARD_REQUIRED ON
        HIP_EXTENSIONS ON
    )
    # Preserve the code-generation mode used by the original in-tree tests.
    # Several cases intentionally depend on exact wait-counter instruction
    # sequences and are not valid coverage when compiled at -O0.
    target_compile_options(${target_name} PRIVATE -O2)
    target_include_directories(${target_name} PRIVATE "${CMAKE_CURRENT_LIST_DIR}")
    target_link_libraries(${target_name} PRIVATE GTest::gtest hip::device)
endfunction()

list(LENGTH CMAKE_HIP_ARCHITECTURES race_arch_count)
if(NOT race_arch_count EQUAL 1)
    message(FATAL_ERROR "RocJITsu race tests require exactly one HIP architecture")
endif()

if(CMAKE_HIP_ARCHITECTURES STREQUAL "gfx950")
    add_rocjitsu_race_test(
        hip_race_tests_gfx950
        "${CMAKE_CURRENT_LIST_DIR}/hip_race_gfx950_test.hip"
    )
elseif(CMAKE_HIP_ARCHITECTURES STREQUAL "gfx1151")
    add_rocjitsu_race_test(
        hip_race_tests_gfx1151
        "${CMAKE_CURRENT_LIST_DIR}/hip_race_gfx1151_test.hip"
    )
else()
    message(FATAL_ERROR
        "RocJITsu race tests support gfx950 and gfx1151, got "
        "'${CMAKE_HIP_ARCHITECTURES}'")
endif()
