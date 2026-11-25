# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

# Included from the rocjitsu tests build so the wire client exercises the
# selected host implementation and matching generated configuration schema.
add_executable(vfio_system_cts vfio/vfio_device_host_test.cpp vfio/vfio_user_client.cpp)
rj_configure_target(vfio_system_cts TEST)
target_include_directories(vfio_system_cts PRIVATE "${CMAKE_SOURCE_DIR}/tests")
target_link_libraries(
    vfio_system_cts
    PRIVATE ${RJ_OBJECT_LIBS} rocjitsu_kmd rocjitsu_vmm_vfu libvfio-user::libvfio-user
            util flatbuffers Threads::Threads GTest::gtest_main
)
target_link_options(vfio_system_cts PRIVATE "LINKER:--wrap=vfu_run_ctx")
rj_add_test_path(vfio_system_cts RJ_VFU_TEST_CONFIG_PATH "${CMAKE_SOURCE_DIR}/configs/gfx1250_mi455x.json")
add_test(NAME SystemCTS.VfioTransport COMMAND vfio_system_cts)
set_tests_properties(SystemCTS.VfioTransport PROPERTIES LABELS "system-cts;vfio" TIMEOUT 180)

foreach(check IN ITEMS run_vfio_guest run_rccl_scaleout run_rccl_pod_emulated_node)
    add_test(
        NAME SystemCTS.Launcher.${check}
        COMMAND "${CMAKE_COMMAND}" -E env "ROCJITSU_SOURCE_DIR=${CMAKE_SOURCE_DIR}"
                "${Python3_EXECUTABLE}" -B "${CMAKE_CURRENT_SOURCE_DIR}/launchers/check_${check}.py"
    )
    set_tests_properties(SystemCTS.Launcher.${check} PROPERTIES LABELS "system-cts;launcher" TIMEOUT 180)
endforeach()
add_test(
    NAME SystemCTS.VfioSocketAliases
    COMMAND "${Python3_EXECUTABLE}" -B "${CMAKE_CURRENT_SOURCE_DIR}/launchers/check_vfio_cli.py"
            $<TARGET_FILE:rocjitsu_bin> "${CMAKE_SOURCE_DIR}/tests/fixtures/fabric_node_projection.json"
)
set_tests_properties(SystemCTS.VfioSocketAliases PROPERTIES LABELS "system-cts;vfio" TIMEOUT 15)
