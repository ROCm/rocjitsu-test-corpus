# Copyright Advanced Micro Devices, Inc., or its affiliates.
# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.25)
project(tensilelite_validation_client LANGUAGES CXX)

include(GenerateExportHeader)

set(ROCM_PATH "" CACHE PATH "ROCm SDK root")
set(ROCISA_INCLUDE_ROOT "" CACHE PATH "Directory containing rocisa/include")

if(NOT ROCM_PATH)
    message(FATAL_ERROR "ROCM_PATH is required")
endif()
if(NOT EXISTS "${ROCISA_INCLUDE_ROOT}/rocisa/include/enum.hpp")
    message(FATAL_ERROR "ROCISA_INCLUDE_ROOT must contain rocisa/include/enum.hpp")
endif()

find_package(hip REQUIRED CONFIG)
find_package(amd_smi REQUIRED CONFIG)
find_package(LLVM REQUIRED CONFIG)
find_package(OpenMP REQUIRED)
find_package(ZLIB REQUIRED)

set(HIPBLASLT_ENABLE_YAML ON)
set(HIPBLASLT_ENABLE_HOST OFF)
set(HIPBLASLT_ENABLE_ASAN OFF)
set(HIPBLASLT_ENABLE_MXDATAGENERATOR ON)
set(TENSILELITE_ENABLE_COVERAGE OFF)
set(TENSILELITE_CLIENT_ENABLE_ROCPROFSDK OFF)

add_library(origami STATIC
    third_party/origami/src/origami/attention.cpp
    third_party/origami/src/origami/gemm.cpp
    third_party/origami/src/origami/hardware.cpp
    third_party/origami/src/origami/heuristics.cpp
    third_party/origami/src/origami/logger.cpp
    third_party/origami/src/origami/origami.cpp
    third_party/origami/src/origami/streamk.cpp
    third_party/origami/src/origami/types.cpp
    third_party/origami/src/simulator/tensilelite/formocast.cpp
    third_party/origami/src/simulator/tensilelite/formocast_simulator.cpp
)
add_library(roc::origami ALIAS origami)
set_target_properties(origami PROPERTIES
    POSITION_INDEPENDENT_CODE ON
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)
generate_export_header(origami
    BASE_NAME ORIGAMI
    EXPORT_MACRO_NAME ORIGAMI_EXPORT
    EXPORT_FILE_NAME "${CMAKE_CURRENT_BINARY_DIR}/include/origami/origami_export.h"
    STATIC_DEFINE ORIGAMI_STATIC
)
target_compile_definitions(origami PUBLIC ORIGAMI_STATIC)
target_include_directories(origami PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/third_party/origami/include"
    "${CMAKE_CURRENT_BINARY_DIR}/include"
)
target_link_libraries(origami PRIVATE hip::host)

add_library(mxDataGenerator INTERFACE)
add_library(roc::mxDataGenerator ALIAS mxDataGenerator)
target_include_directories(mxDataGenerator INTERFACE
    "${CMAKE_CURRENT_SOURCE_DIR}/third_party/mxdatagenerator/include"
)
target_link_libraries(mxDataGenerator INTERFACE OpenMP::OpenMP_CXX)

add_library(hipblaslt-headers INTERFACE)
add_library(hipblaslt::headers ALIAS hipblaslt-headers)
target_include_directories(hipblaslt-headers INTERFACE "${ROCM_PATH}/include")
target_link_libraries(hipblaslt-headers INTERFACE hip::host)

add_library(hipblaslt-mxdatagen STATIC third_party/mxdatagen/src/mxDataGen.cpp)
add_library(hipblaslt::mxdatagen ALIAS hipblaslt-mxdatagen)
set_target_properties(hipblaslt-mxdatagen PROPERTIES
    POSITION_INDEPENDENT_CODE ON
    CXX_STANDARD 20
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)
target_include_directories(hipblaslt-mxdatagen PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/third_party/mxdatagen/include"
)
target_compile_definitions(hipblaslt-mxdatagen PUBLIC HIPBLASLT_ENABLE_MXDATAGENERATOR=1)
target_link_libraries(hipblaslt-mxdatagen
    PUBLIC
        hipblaslt::headers
        roc::mxDataGenerator
    PRIVATE
        hip::device
)

add_library(rocisa-cpp INTERFACE)
add_library(rocisa::rocisa-cpp ALIAS rocisa-cpp)
target_include_directories(rocisa-cpp INTERFACE "${ROCISA_INCLUDE_ROOT}")

add_library(tensilelite-host STATIC)
add_library(roc::tensilelite-host ALIAS tensilelite-host)
set_target_properties(tensilelite-host PROPERTIES
    POSITION_INDEPENDENT_CODE ON
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)

generate_export_header(tensilelite-host
    BASE_NAME TENSILELITEHOST
    EXPORT_MACRO_NAME TENSILELITEHOST_EXPORT
    EXPORT_FILE_NAME "${CMAKE_CURRENT_BINARY_DIR}/include/tensilelitehost/export.h"
)

target_compile_definitions(tensilelite-host PUBLIC
    __HIP_HCC_COMPAT_MODE__=1
    TENSILE_YAML
)
target_include_directories(tensilelite-host
    PUBLIC
        "${CMAKE_CURRENT_SOURCE_DIR}/include"
        "${CMAKE_CURRENT_BINARY_DIR}/include"
        "${ROCISA_INCLUDE_ROOT}"
    PRIVATE
        ${LLVM_INCLUDE_DIRS}
)
target_link_libraries(tensilelite-host
    PUBLIC
        hip::host
        roc::origami
        rocisa::rocisa-cpp
    PRIVATE
        hip::device
        LLVMObjectYAML
        ZLIB::ZLIB
)

list(APPEND CMAKE_BUILD_RPATH
    "${ROCM_PATH}/lib"
    "${ROCM_PATH}/lib/llvm/lib"
)

add_subdirectory(src)
add_subdirectory(include)
add_subdirectory(client)
