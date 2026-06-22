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
