cmake_minimum_required(VERSION 3.22)
project(gfx1250_semantic_corpus LANGUAGES CXX)

include(CTest)
find_package(Python3 3.11 REQUIRED COMPONENTS Interpreter)

set(SEMANTIC_GPU_TARGET "gfx1250" CACHE STRING
    "GPU target used to compile the semantic fixtures")
set(HIPCC "hipcc" CACHE FILEPATH "Path to the HIP compiler driver")

set(SEMANTIC_TESTS
    barrier_signal_isfirst_test
    cluster_load_test
    ds_2addr_test
    ds_addtid_test
    ds_storexchg_2addr_test
    fp8_e5m3_pack_test
    fp8_e5m3_unpack_test
    integer_wmma_hazard_test
    s_clause_test
    tensor_load_to_lds_test
    wmma_scale_regular_test
    wmma_scale_m32_fp4_differential_test
    wmma_scale16_m16_test
    wmma_scale16_m32_test
    wmma_scale16_m32_fp4_differential_test
    wmma_split_f16_test
    wmma_split_f32_test
    wmma_split_fp4_test)

set(SEMANTIC_BINARIES)
set(SEMANTIC_ASSEMBLY)
foreach(test_name IN LISTS SEMANTIC_TESTS)
  set(source "${CMAKE_CURRENT_SOURCE_DIR}/test_cases/${test_name}.hip")
  set(binary "${CMAKE_CURRENT_BINARY_DIR}/bin/${test_name}")
  set(assembly "${CMAKE_CURRENT_BINARY_DIR}/assembly/${test_name}.s")

  add_custom_command(
    OUTPUT "${binary}"
    COMMAND "${CMAKE_COMMAND}" -E make_directory
            "${CMAKE_CURRENT_BINARY_DIR}/bin"
    COMMAND "${HIPCC}" -std=c++20 -O2
            --offload-arch=${SEMANTIC_GPU_TARGET}
            "-I${CMAKE_CURRENT_SOURCE_DIR}/include"
            "${source}" -o "${binary}"
    DEPENDS
            "${source}"
            "${CMAKE_CURRENT_SOURCE_DIR}/include/test_support.hpp"
            "${CMAKE_CURRENT_SOURCE_DIR}/include/wmma_m32_fp4_differential.hpp"
    VERBATIM)
  add_custom_target("${test_name}" DEPENDS "${binary}")
  list(APPEND SEMANTIC_BINARIES "${binary}")

  add_custom_command(
    OUTPUT "${assembly}"
    COMMAND "${CMAKE_COMMAND}" -E make_directory
            "${CMAKE_CURRENT_BINARY_DIR}/assembly"
    COMMAND "${HIPCC}" -std=c++20 -O2
            --offload-arch=${SEMANTIC_GPU_TARGET}
            --cuda-device-only -S
            "-I${CMAKE_CURRENT_SOURCE_DIR}/include"
            "${source}" -o "${assembly}"
    DEPENDS
            "${source}"
            "${CMAKE_CURRENT_SOURCE_DIR}/include/test_support.hpp"
            "${CMAKE_CURRENT_SOURCE_DIR}/include/wmma_m32_fp4_differential.hpp"
    VERBATIM)
  list(APPEND SEMANTIC_ASSEMBLY "${assembly}")

  add_custom_target(
    "check-semantic-${test_name}"
    COMMAND
      "${Python3_EXECUTABLE}"
      "${CMAKE_CURRENT_SOURCE_DIR}/scripts/check_source_coverage.py"
      --manifest "${CMAKE_CURRENT_SOURCE_DIR}/cases.toml"
      --assembly-dir "${CMAKE_CURRENT_BINARY_DIR}/assembly"
      --test "${test_name}"
    DEPENDS "${binary}" "${assembly}"
    VERBATIM)
endforeach()

add_custom_target(semantic-binaries ALL DEPENDS ${SEMANTIC_BINARIES})
add_custom_target(semantic-assembly ALL DEPENDS ${SEMANTIC_ASSEMBLY})
add_custom_target(
  check-source-coverage
  COMMAND
    "${Python3_EXECUTABLE}"
    "${CMAKE_CURRENT_SOURCE_DIR}/scripts/check_source_coverage.py"
    --manifest "${CMAKE_CURRENT_SOURCE_DIR}/cases.toml"
    --assembly-dir "${CMAKE_CURRENT_BINARY_DIR}/assembly"
  DEPENDS semantic-assembly
  VERBATIM)
add_custom_target(check-gfx1250-semantics
                  DEPENDS semantic-binaries check-source-coverage)

if(BUILD_TESTING)
  add_test(
    NAME semantics.source-coverage
    COMMAND
      "${Python3_EXECUTABLE}"
      "${CMAKE_CURRENT_SOURCE_DIR}/scripts/check_source_coverage.py"
      --manifest "${CMAKE_CURRENT_SOURCE_DIR}/cases.toml"
      --assembly-dir "${CMAKE_CURRENT_BINARY_DIR}/assembly")
  set_tests_properties(semantics.source-coverage PROPERTIES
                       LABELS "compile;isa;semantics")
endif()
