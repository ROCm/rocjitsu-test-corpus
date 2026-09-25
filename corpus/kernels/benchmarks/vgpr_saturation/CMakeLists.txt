# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

if(NOT CMAKE_HIP_ARCHITECTURES STREQUAL "gfx942")
    message(
        FATAL_ERROR
        "The VGPR saturation resource profile is qualified only for gfx942"
    )
endif()

find_package(hip REQUIRED CONFIG)
find_package(Python3 COMPONENTS Interpreter REQUIRED)

set(vgpr_saturation_source "${CMAKE_CURRENT_SOURCE_DIR}/vgpr_saturation.hip")
set(vgpr_saturation_counts
    "${CMAKE_CURRENT_SOURCE_DIR}/vgpr_saturation_counts.def"
)
set(vgpr_saturation_verifier "${CMAKE_CURRENT_SOURCE_DIR}/verify_resources.py")
set(vgpr_saturation_resource_stamp
    "${CMAKE_CURRENT_BINARY_DIR}/vgpr_saturation_resources.stamp"
)

add_executable(rocjitsu_vgpr_saturation "${vgpr_saturation_source}")
set_source_files_properties("${vgpr_saturation_source}" PROPERTIES LANGUAGE HIP)
target_compile_features(rocjitsu_vgpr_saturation PRIVATE cxx_std_20)
set_target_properties(
    rocjitsu_vgpr_saturation
    PROPERTIES
        CXX_STANDARD 20
        CXX_STANDARD_REQUIRED ON
        CXX_EXTENSIONS OFF
        HIP_STANDARD 20
        HIP_STANDARD_REQUIRED ON
        HIP_EXTENSIONS OFF
)
target_compile_options(
    rocjitsu_vgpr_saturation
    PRIVATE $<$<COMPILE_LANGUAGE:HIP>:-O3;-Wall;-Wextra;-Werror>
)
target_link_libraries(rocjitsu_vgpr_saturation PRIVATE hip::device)

add_custom_command(
    OUTPUT "${vgpr_saturation_resource_stamp}"
    COMMAND
        "${Python3_EXECUTABLE}" "${vgpr_saturation_verifier}" --compiler
        "${CMAKE_HIP_COMPILER}" --rocm-path "${ROCM_PATH}" --arch
        "${CMAKE_HIP_ARCHITECTURES}"
    COMMAND "${CMAKE_COMMAND}" -E touch "${vgpr_saturation_resource_stamp}"
    DEPENDS
        "${vgpr_saturation_source}"
        "${vgpr_saturation_counts}"
        "${vgpr_saturation_verifier}"
    COMMENT "Verifying rocjitsu VGPR saturation benchmark resources"
    VERBATIM
)

add_custom_target(
    rocjitsu_vgpr_saturation_resources
    DEPENDS "${vgpr_saturation_resource_stamp}"
)
add_custom_target(
    rocjitsu_vgpr_saturation_check
    DEPENDS rocjitsu_vgpr_saturation rocjitsu_vgpr_saturation_resources
)
